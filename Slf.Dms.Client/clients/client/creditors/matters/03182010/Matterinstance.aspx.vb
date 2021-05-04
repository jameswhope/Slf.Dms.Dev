Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports SharedFunctions

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.IO

Partial Class clients_client_creditors_matters_MatterInstance

    Inherits PermissionPage

#Region "Variables"
    Public tabIndex As Int16 = 0
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Public QueryString As String

    Private UserID As Integer
    Private UserTypeID As Integer
    Public UserGroupID As Integer

    Private SortField As String
    Private SortOrder As String
    Private Headers As Dictionary(Of String, HtmlTableCell)
    Private HeadersTasks As Dictionary(Of String, HtmlTableCell)
    Private HeadersPhones As Dictionary(Of String, HtmlTableCell)
    Private HeadersNotes As Dictionary(Of String, HtmlTableCell)
    Private HeadersEmails As Dictionary(Of String, HtmlTableCell)
    Private HeadersOverview As Dictionary(Of String, HtmlTableCell)

    Public AccountId As Integer
    Public MatterId As Integer
    Public MatterTypeId As Integer
    Public MatterGroupId As Integer
    Public AttorneyId As Integer
    Public CreditorInstanceId As Integer
    Public UserGroupName As String
    'Added to check user is a manager
    Public UserIsManager As Boolean
    Public UserCanEdit As Boolean = True

    Private conv_stateid As Integer
    Private relations As New List(Of SharedFunctions.DocRelation)
    Protected ReadOnly Property Identity() As String
        Get
            Return Me.Page.GetType.Name & "_" & Me.ID
        End Get
    End Property


    Protected Property Setting(ByVal s As String) As Object
        Get
            Return Session(Identity & "_" & s)
        End Get
        Set(ByVal value As Object)
            Session(Identity & "_" & s) = value
        End Set
    End Property
    Protected ReadOnly Property Setting(ByVal s As String, ByVal d As Object) As Object
        Get
            Dim o As Object = Setting(s)
            If o Is Nothing Then
                Return d
            Else
                Return o
            End If
        End Get
    End Property
    Public ReadOnly Property DataClientID() As Integer
        Get
            Return Master.DataClientID
        End Get
    End Property

    Private Function GetFullyQualifiedNameForNotes(ByVal s As String) As String
        Select Case s
            Case "Th2"
                Return "[By]"
            Case "Th3"
                Return "ut.name"
            Case "Th4"
                Return "n.created"
        End Select
        Return "n.created"
    End Function

    Private Function GetFullyQualifiedNameForTasks(ByVal s As String) As String
        Select Case s
            Case "Th5"
                Return "TaskType"
            Case "Th6"
                Return "T.Description"
            Case "Th7"
                Return "CreatedBy"
            Case "Th8"
                Return "AssignedTo"
            Case "Th9"
                Return "CreatedDate"
            Case "Th10"
                Return "DueDate"
            Case "Th11"
                Return "T.Resolved"
        End Select
        Return "CreatedBy"
    End Function

    Private Function GetFullyQualifiedNameForOverview(ByVal s As String) As String
        Select Case s
            Case "tdCreatedDate"
                Return "date"
            Case "tdCreatedBy"
                Return "[by]"
            Case "tdMessage"
                Return "message"
            Case "tdCreatedBy"
                Return "CreatedBy"
        End Select
        Return "date"
    End Function

#End Region

    Public Structure NoteRelation
        Dim NoteID As Integer
        Dim EntityName As String
        Dim RelationTypeID As Integer
        Dim RelationTypeName As String
        Dim RelationID As Integer
        Dim IconURL As String
        Dim NavigateURL As String
    End Structure

    Public Structure GridTask
        Dim TaskID As Integer
        Dim TaskType As String
        Dim TaskDescription As String
        Dim CreatedBy As String
        Dim AssignedTo As String
        Dim StartDate As DateTime
        Dim DueDate As DateTime
        Dim ResolvedDate As Nullable(Of DateTime)
        Dim TaskResolutionId As Integer
        'Dim Duration As String
        Dim Value As String
        Dim Color As String
        Dim TextColor As String
        Dim BodyColor As String


        ReadOnly Property Status() As String
            Get

                If ResolvedDate.HasValue Then
                    If TaskResolutionId = 1 Then
                        Return "RESOLVED"
                    Else 'If TaskResolutionID = 5 Then
                        Return "IN PROGRESS"
                    End If
                Else
                    If DueDate < Now Then
                        Return "PAST DUE"
                    Else
                        Return "OPEN"
                    End If

                End If

            End Get
        End Property

        ReadOnly Property Duration() As String
            Get

                If ResolvedDate.HasValue Then
                    Dim Dur As TimeSpan
                    Dur = ResolvedDate - StartDate

                    'Return Math.Round(Dur.TotalHours, 2).ToString()
                    Return Dur.Days & "d:" & Dur.Hours & "h:" & Dur.Minutes & "m:" & Dur.Seconds & "s"

                Else
                    Return " "

                End If

            End Get
        End Property


    End Structure

    Public Structure GridNote
        Dim NoteID As Integer
        Dim Author As String
        Dim UserType As String
        Dim NoteDate As DateTime
        Dim Relations As List(Of NoteRelation)
        Dim Value As String
        Dim Color As String
        Dim TextColor As String
        Dim BodyColor As String
    End Structure

    Public Structure GridPhoneCall
        Dim PhoneCallID As Integer
        Dim PersonName As String
        Dim UserType As String
        Dim UserName As String
        Dim CallDate As DateTime
        Dim CallDateEnd As DateTime
        Dim Duration As String
        Dim Subject As String
        Dim Body As String
        Dim strDirection As String
        Dim Direction As Boolean
        Dim Color As String
        Dim TextColor As String
        Dim BodyColor As String
    End Structure
    Private Notes As New Dictionary(Of Integer, GridNote)
    Public Function GetAttachmentText(ByVal id As Integer, ByVal type As String) As String
        For Each rel As SharedFunctions.DocRelation In relations
            If rel.RelationID = id And rel.RelationType = type Then
                Return "<img src=""" + ResolveUrl("~/images/11x16_paperclip.png") + """ border="""" alt="""" />"
            End If
        Next

        Return "&nbsp"
    End Function
    Public Function GetPage(ByVal type As String) As String
        Return type
    End Function

    Public Function GetQSID(ByVal type As String) As String
        Select Case type
            Case "note"
                Return "nid"
            Case "phonecall"
                Return "pcid"
            Case "email"
                Return "eid"
        End Select
        Return String.Empty
    End Function
    Public Function GetImage(ByVal type As String, ByVal direction As Object) As String
        Select Case type
            Case "note"
                Return ResolveUrl("~/images/16x16_note.png")
            Case "phonecall"
                Dim dir = CType(direction, Boolean)
                Return ResolveUrl("~/images/16x16_call" & IIf(dir, "out", "in") & ".png")
            Case "email"
                Return ResolveUrl("~/images/16x16_email_read.png")
            Case "task"
                Return ResolveUrl("~/images/16x16_taskpropagation.png")
        End Select
        Return String.Empty
    End Function

    Public Function GetPagePath(ByVal type As String, ByVal Field As String) As String
        Select Case type
            Case "note"
                Return ResolveUrl("~/clients/client/communication/note.aspx?id=") + DataClientID.ToString() + "&nid=" + Field + "&aid=" + AccountId.ToString() + "&mid=" + MatterId.ToString() + "&ciid=" + CreditorInstanceId.ToString() + "&t=m"
            Case "phonecall"
                Return ResolveUrl("~/clients/client/communication/phonecall.aspx?id=") + DataClientID.ToString() + "&pcid=" + Field + "&aid=" + AccountId.ToString() + "&mid=" + MatterId.ToString() + "&ciid=" + CreditorInstanceId.ToString() + "&t=m"
            Case "email"
                Return ResolveUrl("~/clients/client/communication/email.aspx") + "?id=" + DataClientID.ToString() + "&eid=" + Field
            Case "task"
                Return ResolveUrl("~/tasks/task/resolve.aspx?id=") + Field
        End Select
        Return String.Empty
    End Function

    Public Function MakeSnippet(ByVal s As String, ByVal length As Integer) As String
        Dim result As String = s
        If result.Length > length Then result = result.Substring(0, length - 3) + "..."
        Return result
    End Function
    Public Function GetRelations(ByVal Relations As List(Of NoteRelation)) As String
        Dim sb As New StringBuilder
        For Each r As NoteRelation In Relations
            If Not sb.Length = 0 Then
                sb.Append("<br>")
            End If
            If Not r.RelationTypeID = 1 Then
                sb.Append("<img style=""position:relative;top:4"" src=""" & ResolveUrl(r.IconURL) & """ border=""0""/>&nbsp;<b>" + r.RelationTypeName + "</b>&nbsp;<a class=""lnk"" href=""" + r.NavigateURL + """>" + r.EntityName + "</a>")
            Else
                sb.Append(r.EntityName)
            End If
        Next
        Return sb.ToString
    End Function

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        LoadOverview()
        LoadAllEmails()
        LoadPhoneCalls()
        LoadNotes()
        LoadTasks()
        LoadTabStrips()
        ddlMatterType.Enabled = False
    End Sub

    Public Sub SetSortImage()
        Headers(SortField).Controls.Add(GetSortImage(SortOrder))
    End Sub

    Public Sub SetSortImageTasks()
        HeadersTasks(SortField).Controls.Add(GetSortImage(SortOrder))
    End Sub

    Public Sub SetSortImageNotes()
        HeadersNotes(SortField).Controls.Add(GetSortImage(SortOrder))
    End Sub

    Public Sub SetSortImagePhones()
        HeadersPhones(SortField).Controls.Add(GetSortImage(SortOrder))
    End Sub

    Public Sub SetSortImageEmails()
        HeadersEmails(SortField).Controls.Add(GetSortImage(SortOrder))
    End Sub

    Public Sub SetSortImageOverview()
        HeadersOverview(SortField).Controls.Add(GetSortImage(SortOrder))
    End Sub

    Private Function GetSortImage(ByVal SortOrder As String) As HtmlImage
        Dim img As HtmlImage = New HtmlImage()
        img.Src = ResolveUrl("~/images/sort-" & SortOrder & ".png")
        img.Align = "absmiddle"
        img.Border = 0
        img.Style("margin-left") = "5px"
        Return img
    End Function

    Private Sub LoadHeaders()
        Headers = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(Headers, tdDate)
        AddHeader(Headers, tdDuration)
        AddHeader(Headers, tdPerson)
        AddHeader(Headers, tdUser)
        AddHeader(Headers, tdUserType)
    End Sub

    Private Sub LoadHeadersTasks()
        HeadersTasks = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(HeadersTasks, Th5)
        AddHeader(HeadersTasks, Th6)
        AddHeader(HeadersTasks, Th7)
        AddHeader(HeadersTasks, Th8)
        AddHeader(HeadersTasks, Th9)
        AddHeader(HeadersTasks, Th10)
        AddHeader(HeadersTasks, Th11)
    End Sub

    Private Sub LoadHeadersPhones()
        HeadersPhones = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(HeadersPhones, tdUser)
        AddHeader(HeadersPhones, tdUserType)
        AddHeader(HeadersPhones, tdPerson)
        AddHeader(HeadersPhones, tdDate)
        AddHeader(HeadersPhones, tdDuration)
    End Sub

    Private Sub LoadHeadersNotes()
        HeadersNotes = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(HeadersNotes, Th2)
        AddHeader(HeadersNotes, Th3)
        AddHeader(HeadersNotes, Th4)
    End Sub

    Private Sub LoadHeadersEmails()
        HeadersEmails = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(HeadersEmails, tdEmailDate)
        AddHeader(HeadersEmails, tdSentBy)
        AddHeader(HeadersEmails, tdEMailSubject)
    End Sub

    Private Sub LoadHeadersOverview()
        HeadersOverview = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(HeadersOverview, tdCreatedDate)
        AddHeader(HeadersOverview, tdCreatedBy)
        AddHeader(HeadersOverview, tdMessage)
    End Sub

    Private Sub AddHeader(ByVal c As System.Collections.Generic.Dictionary(Of String, HtmlTableCell), ByVal td As HtmlTableCell)
        c.Add(td.ID, td)
    End Sub

    Private Function GetFullyQualifiedNameForCalls(ByVal s As String) As String
        Select Case s
            Case "tdDate"
                Return "pc.starttime"
            Case "tdDuration"
                Return "datediff(ss,pc.starttime,pc.endtime)"
            Case "tdPerson"
                Return "p.lastname"
            Case "tdUser"
                Return "u.lastname"
            Case "tdUserType"
                Return "ut.name"
        End Select
        Return "pc.starttime"
    End Function

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        'tsMatterView.TabPages(0).Selected = True

    End Sub

    Private Sub LoadTabStrips()

        tsMatterView.TabPages.Clear()

        If hdnOverview.Value <> "" And hdnOverview.Value <> "0" Then
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Overview&nbsp;&nbsp;<font color='blue'>(" & hdnOverview.Value.ToString() & ")</font>", dvPanel4.ClientID))
        Else
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Overview", dvPanel4.ClientID))
        End If

        If hdnTasksCount.Value <> "" And hdnTasksCount.Value <> "0" Then
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Tasks&nbsp;&nbsp;<font color='blue'>(" & hdnTasksCount.Value.ToString() & ")</font>", dvPanel0.ClientID))
        Else
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Tasks", dvPanel0.ClientID))
        End If

        If hdnNotesCount.Value <> "" And hdnNotesCount.Value <> "0" Then
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Notes&nbsp;&nbsp;<font color='blue'>(" & hdnNotesCount.Value.ToString() & ")</font>", dvPanel1.ClientID))
        Else
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Notes", dvPanel1.ClientID))
        End If

        If hdnCallsCount.Value <> "" And hdnCallsCount.Value <> "0" Then
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Phones&nbsp;&nbsp;<font color='blue'>(" & hdnCallsCount.Value.ToString() & ")</font>", dvPanel2.ClientID))
        Else
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Phones", dvPanel2.ClientID))
        End If

        If hdnEmailCount.Value <> "" And hdnEmailCount.Value <> "0" Then
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Emails&nbsp;&nbsp;<font color='blue'>(" & hdnEmailCount.Value.ToString() & ")</font>", dvPanel3.ClientID))
        Else
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Emails", dvPanel3.ClientID))
        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        LoadTabStrips()

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserTypeID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID))
        UserGroupID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupID", "UserId=" & UserID))
        qs = LoadQueryString()

        'trCreditor.Visible = False
        'trLocalCounsel.Visible = False

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)
            AccountId = DataHelper.Nz_int(qs("aid"), 0)
            MatterId = DataHelper.Nz_int(qs("mid"), 0)
            CreditorInstanceId = DataHelper.Nz_int(qs("ciid"), 0)
            MatterTypeId = Integer.Parse(DataHelper.FieldLookup("tblMatter", "MatterTypeId", "MatterId=" & MatterId))
            MatterGroupId = Integer.Parse(DataHelper.FieldLookup("tblMattertype", "MatterGroupID", "MatterTypeId=" & MatterTypeId))
            If MatterGroupId = 1 Then
                dvActions.Style.Add("display", "")
            End If
            SetRollups()

            If Not IsPostBack Then

                ddlLocalCounsel.Attributes.Add("OnChange", "FillDetails();return false;")
                hdnTempAccountID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()
                hdnTempMatterID.Value = MatterId
                PopulateMatterTypes(MatterTypeId)
                PopulateMatterStatusCode()
                PopulateClassifications()

                PopulateMatterClassifications()

                'Added to check user is a manager - Manager field in tblUser
                UserIsManager = Boolean.Parse(DataHelper.FieldLookup("tblUser", "Manager", "UserId = " & UserID))

                'Fetch usergroup name
                UserGroupName = DataHelper.FieldLookup("tblUserGroup", "Name", "UserGroupID=" & UserGroupID)

                'If (UserGroupName.IndexOf("Litigation East") >= 0 Or UserGroupName.IndexOf("Litigation West") >= 0) Then
                'Litigation West/East supervisor only
                If UserIsManager = True Then
                    UserCanEdit = True
                Else
                    UserCanEdit = False
                End If
                'Else
                '    UserCanEdit = True
                'End If

                LoadMatterPropagations()
                ResetPropagationsCounter()

                If UserCanEdit = False Then
                    lnkAddTask.Visible = True
                    lnkEditTask.Visible = False
                Else
                    lnkAddTask.Visible = False
                    lnkEditTask.Visible = True
                End If

                '' Turned off now as this should be documents for matters'
                LoadDocuments()

                PopulateValidCreditors()
                LoadMatterDetail()
                PopulateValidLocalCounselforClient()

                If CreditorInstanceId > 0 And hdnLatestCreditorId.Value <> CreditorInstanceId Then
                    txtCreditor.Visible = True
                    ddlCreditors.Visible = False

                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                        Using cmd.Connection
                            cmd.CommandText = "select cc.name+'-'+RIGHT(ci.accountnumber,4) as CreditorName from tblcreditorinstance ci left outer join tblcreditor cc on ci.creditorid=cc.creditorid where ci.CreditorInstanceId=@CreditorInstanceId"
                            DatabaseHelper.AddParameter(cmd, "CreditorInstanceId", CreditorInstanceId)
                            cmd.Connection.Open()
                            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                                While rd.Read()
                                    txtCreditor.Text = DatabaseHelper.Peel_string(rd, "CreditorName")
                                End While
                            End Using
                        End Using
                    End Using

                End If




            End If
        End If

    End Sub

    Private Sub PopulateValidCreditors()

        '2.10.2010 added load valid creditors - force user to select creditors if litigation matter is selected
        ddlCreditors.Items.Clear()
        ddlCreditors.Items.Add(New ListItem("--NONE--", "-1"))
        ddlCreditors.Items.Add(New ListItem("--TBD --", "0"))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                'cmd.CommandText = "get_ClientAccountOverviewList"
                cmd.CommandText = "get_ValidCreditorsList"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()

                        'ddlCreditors.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "CreditorName"), DatabaseHelper.Peel_int(rd, "AccountId")))
                        ddlCreditors.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "CreditorName"), DatabaseHelper.Peel_int(rd, "AccountId")))

                        If AccountId = DatabaseHelper.Peel_int(rd, "AccountId") Or CreditorInstanceId = DatabaseHelper.Peel_int(rd, "CreditorInstanceId") Then
                            ddlCreditors.SelectedIndex = ddlCreditors.Items.IndexOf(ddlCreditors.Items.FindByValue(DatabaseHelper.Peel_int(rd, "AccountId")))
                            hdnLatestCreditorId.Value = DatabaseHelper.Peel_int(rd, "CreditorInstanceId")
                        End If

                    End While

                End Using
            End Using
        End Using

    End Sub

    Private Sub PopulateMatterTypes(ByVal MatterTypeId As Integer)

        ddlMatterType.Items.Clear()
        ddlMatterType.Items.Add(New ListItem("Select Matter Type", "0"))
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                'cmd.CommandText = "SELECT * FROM tblMatterType Where IsActive=1"
                cmd.CommandText = "stp_GetMatterTypes"
                cmd.CommandType = CommandType.StoredProcedure
                'DatabaseHelper.AddParameter(cmd, "UserGroupId", UserGroupID)
                DatabaseHelper.AddParameter(cmd, "UserGroupId", DBNull.Value)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)

                    While rd.Read()
                        ddlMatterType.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "MatterTypeCode"), DatabaseHelper.Peel_int(rd, "MatterTypeId")))
                    End While

                    ddlMatterType.SelectedIndex = ddlMatterType.Items.IndexOf(ddlMatterType.Items.FindByValue(MatterTypeId))

                End Using
            End Using
        End Using

    End Sub

    Protected Sub LoadTasks()
        SortField = Setting("SortField", "Th7")
        SortOrder = Setting("SortOrder", "DESC")

        Dim Tasks As New List(Of GridTask)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetMattertasks2")
            Using cmd.Connection

                DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                DatabaseHelper.AddParameter(cmd, "OrderBy", GetFullyQualifiedNameForTasks(SortField) + " " + SortOrder)

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read
                        Dim tsk As New GridTask

                        tsk.TaskID = DatabaseHelper.Peel_int(rd, "TaskID")
                        tsk.AssignedTo = Convert.ToString(DatabaseHelper.Peel_string(rd, "AssignedTo"))
                        tsk.TaskType = Convert.ToString(DatabaseHelper.Peel_string(rd, "TaskType"))
                        tsk.TaskDescription = DatabaseHelper.Peel_string(rd, "Description").Replace("-Not Available", "")
                        tsk.StartDate = DatabaseHelper.Peel_date(rd, "CreatedDate")
                        tsk.DueDate = DatabaseHelper.Peel_date(rd, "DueDate")
                        tsk.CreatedBy = Convert.ToString(DatabaseHelper.Peel_string(rd, "CreatedBy"))
                        tsk.ResolvedDate = DatabaseHelper.Peel_ndate(rd, "Resolved")
                        tsk.TaskResolutionId = DatabaseHelper.Peel_int(rd, "TaskResolutionID")
                        Tasks.Add(tsk)


                    End While
                End Using
            End Using
        End Using

        rpTasks.DataSource = Tasks
        rpTasks.DataBind()

        rpTasks.Visible = rpTasks.Items.Count > 0
        pnlNoTasks.Visible = rpTasks.Items.Count = 0
        hdnTasksCount.Value = rpTasks.Items.Count

        LoadHeadersTasks()
        SetSortImageTasks()
    End Sub

    Private Sub LoadNotes()

        SortField = Setting("SortFieldNotes", "Th4")
        SortOrder = Setting("SortOrderNotes", "DESC")



        'Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNotes2")
        '    Using cmd.Connection
        '        DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)
        '        DatabaseHelper.AddParameter(cmd, "OrderBy", GetFullyQualifiedNameForNotes(SortField) + " " + SortOrder)
        '        cmd.Connection.Open()
        '        Using rd As IDataReader = cmd.ExecuteReader()
        '            While rd.Read
        '                Dim n As New GridNote
        '                n.NoteID = DatabaseHelper.Peel_int(rd, "NoteID")
        '                n.Author = DatabaseHelper.Peel_string(rd, "By")
        '                n.UserType = DatabaseHelper.Peel_string(rd, "UserType")
        '                n.NoteDate = DatabaseHelper.Peel_date(rd, "Date")
        '                n.Value = DatabaseHelper.Peel_string(rd, "Value")
        '                n.Color = DatabaseHelper.Peel_string(rd, "Color")
        '                n.TextColor = DataHelper.Nz(DatabaseHelper.Peel_string(rd, "TextColor"), "black")
        '                n.BodyColor = LocalHelper.AdjustColor(DataHelper.Nz(DatabaseHelper.Peel_string(rd, "TextColor"), "black"), 1.5)

        '                n.Relations = New List(Of NoteRelation)
        '                Notes.Add(n.NoteID, n)
        '            End While
        '            rd.NextResult()
        '            While rd.Read
        '                Dim NoteID As String = DatabaseHelper.Peel_int(rd, "NoteID")
        '                Dim n As GridNote = Nothing
        '                If Notes.TryGetValue(NoteID, n) Then
        '                    Dim r As New NoteRelation
        '                    r.NoteID = NoteID
        '                    r.EntityName = DatabaseHelper.Peel_string(rd, "relationname")
        '                    r.RelationTypeName = DatabaseHelper.Peel_string(rd, "relationtypename")
        '                    r.RelationID = DatabaseHelper.Peel_int(rd, "relationid")
        '                    r.RelationTypeID = DatabaseHelper.Peel_int(rd, "relationtypeid")
        '                    r.IconURL = DatabaseHelper.Peel_string(rd, "iconurl")
        '                    r.NavigateURL = ResolveUrl(DatabaseHelper.Peel_string(rd, "navigateurl").Replace("$clientid$", DataClientID).Replace("$x$", r.RelationID))
        '                    n.Relations.Add(r)
        '                End If
        '            End While
        '        End Using
        '    End Using
        'End Using
        'rpNotes.DataSource = Notes.Values
        'rpNotes.DataBind()

        'rpNotes.Visible = rpNotes.Items.Count > 0
        'pnlNoNotes.Visible = rpNotes.Items.Count = 0



        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetMatterNotes")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                DatabaseHelper.AddParameter(cmd, "OrderBy", GetFullyQualifiedNameForNotes(SortField) + " " + SortOrder)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read
                        Dim n As New GridNote
                        n.NoteID = DatabaseHelper.Peel_int(rd, "NoteID")
                        n.Author = DatabaseHelper.Peel_string(rd, "By")
                        n.UserType = DatabaseHelper.Peel_string(rd, "UserType")
                        n.NoteDate = DatabaseHelper.Peel_date(rd, "Date")
                        n.Value = DatabaseHelper.Peel_string(rd, "Value")
                        n.Color = DatabaseHelper.Peel_string(rd, "Color")
                        n.TextColor = DataHelper.Nz(DatabaseHelper.Peel_string(rd, "TextColor"), "black")
                        n.BodyColor = LocalHelper.AdjustColor(DataHelper.Nz(DatabaseHelper.Peel_string(rd, "TextColor"), "black"), 1.5)

                        n.Relations = New List(Of NoteRelation)
                        Notes.Add(n.NoteID, n)
                    End While
                    rd.NextResult()
                    While rd.Read
                        Dim NoteID As String = DatabaseHelper.Peel_int(rd, "NoteID")
                        Dim n As GridNote = Nothing
                        If Notes.TryGetValue(NoteID, n) Then
                            Dim r As New NoteRelation
                            r.NoteID = NoteID
                            r.EntityName = DatabaseHelper.Peel_string(rd, "relationname")
                            r.RelationTypeName = DatabaseHelper.Peel_string(rd, "relationtypename")
                            r.RelationID = DatabaseHelper.Peel_int(rd, "relationid")
                            r.RelationTypeID = DatabaseHelper.Peel_int(rd, "relationtypeid")
                            r.IconURL = DatabaseHelper.Peel_string(rd, "iconurl")
                            r.NavigateURL = ResolveUrl(DatabaseHelper.Peel_string(rd, "navigateurl").Replace("$clientid$", DataClientID).Replace("$x$", r.RelationID))
                            n.Relations.Add(r)
                        End If
                    End While
                End Using
            End Using
        End Using
        rpNotes.DataSource = Notes.Values
        rpNotes.DataBind()

        rpNotes.Visible = rpNotes.Items.Count > 0
        pnlNoNotes.Visible = rpNotes.Items.Count = 0
        hdnNotesCount.Value = rpNotes.Items.Count

        LoadHeadersNotes()
        SetSortImageNotes()
    End Sub

    Private Sub LoadPhoneCalls()



        'Dim PhoneCalls As New List(Of GridPhoneCall)
        'Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPhoneCalls2")
        '    Using cmd.Connection

        '        DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)
        '        DatabaseHelper.AddParameter(cmd, "OrderBy", GetFullyQualifiedNameForCalls(SortField) + " " + SortOrder)

        '        cmd.Connection.Open()
        '        Using rd As IDataReader = cmd.ExecuteReader()
        '            While rd.Read
        '                Dim pc As New GridPhoneCall

        '                pc.PhoneCallID = DatabaseHelper.Peel_int(rd, "PhoneCallID")
        '                pc.PersonName = DatabaseHelper.Peel_string(rd, "person")
        '                pc.UserName = DatabaseHelper.Peel_string(rd, "by")
        '                pc.UserType = DatabaseHelper.Peel_string(rd, "UserType")
        '                pc.CallDate = DatabaseHelper.Peel_date(rd, "starttime")
        '                pc.Body = DatabaseHelper.Peel_string(rd, "body")
        '                pc.Subject = DatabaseHelper.Peel_string(rd, "subject")
        '                pc.CallDateEnd = DatabaseHelper.Peel_date(rd, "endtime")
        '                pc.Direction = DatabaseHelper.Peel_bool(rd, "direction")
        '                pc.Color = DatabaseHelper.Peel_string(rd, "color")
        '                pc.TextColor = DataHelper.Nz(DatabaseHelper.Peel_string(rd, "TextColor"), "black")
        '                pc.BodyColor = LocalHelper.AdjustColor(DataHelper.Nz(DatabaseHelper.Peel_string(rd, "TextColor"), "black"), 1.5)
        '                pc.strDirection = IIf(pc.Direction, "To", "From")
        '                pc.Duration = LocalHelper.FormatTimeSpan(pc.CallDateEnd.Subtract(pc.CallDate))

        '                PhoneCalls.Add(pc)
        '            End While
        '        End Using
        '    End Using
        'End Using

        'rpPhoneCalls.DataSource = PhoneCalls
        'rpPhoneCalls.DataBind()

        'rpPhoneCalls.Visible = rpPhoneCalls.Items.Count > 0
        'pnlNoNotes.Visible = rpPhoneCalls.Items.Count = 0

        SortField = Setting("SortFieldPhones", "tdDate")
        SortOrder = Setting("SortOrderPhones", "DESC")




        Dim PhoneCalls As New List(Of GridPhoneCall)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetMatterPhoneCalls")
            Using cmd.Connection

                DatabaseHelper.AddParameter(cmd, "MatterID", MatterId)
                DatabaseHelper.AddParameter(cmd, "OrderBy", GetFullyQualifiedNameForCalls(SortField) + " " + SortOrder)

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read
                        Dim pc As New GridPhoneCall

                        pc.PhoneCallID = DatabaseHelper.Peel_int(rd, "PhoneCallID")
                        pc.PersonName = DatabaseHelper.Peel_string(rd, "person")
                        pc.UserName = DatabaseHelper.Peel_string(rd, "by")
                        pc.UserType = DatabaseHelper.Peel_string(rd, "UserType")
                        pc.CallDate = DatabaseHelper.Peel_date(rd, "starttime")
                        pc.Body = DatabaseHelper.Peel_string(rd, "body")
                        pc.Subject = DatabaseHelper.Peel_string(rd, "subject")
                        pc.CallDateEnd = DatabaseHelper.Peel_date(rd, "endtime")
                        pc.Direction = DatabaseHelper.Peel_bool(rd, "direction")
                        pc.Color = DatabaseHelper.Peel_string(rd, "color")
                        pc.TextColor = DataHelper.Nz(DatabaseHelper.Peel_string(rd, "TextColor"), "black")
                        pc.BodyColor = LocalHelper.AdjustColor(DataHelper.Nz(DatabaseHelper.Peel_string(rd, "TextColor"), "black"), 1.5)
                        pc.strDirection = IIf(pc.Direction, "To", "From")
                        pc.Duration = LocalHelper.FormatTimeSpan(pc.CallDateEnd.Subtract(pc.CallDate))

                        PhoneCalls.Add(pc)
                    End While
                End Using
            End Using
        End Using

        rpPhoneCalls.DataSource = PhoneCalls
        rpPhoneCalls.DataBind()

        rpPhoneCalls.Visible = rpPhoneCalls.Items.Count > 0
        pnlNoCalls.Visible = rpPhoneCalls.Items.Count = 0
        hdnCallsCount.Value = rpPhoneCalls.Items.Count

        LoadHeadersPhones()
        SetSortImagePhones()
    End Sub
    Public Function PhoneCallDuration(ByRef startTime As Object, ByRef endTime As Object) As String
        If Not IsNothing(startTime) And Not IsNothing(endTime) Then
            If Not startTime Is System.DBNull.Value And Not endTime Is System.DBNull.Value Then
                Return LocalHelper.FormatTimeSpan(DataHelper.Nz_date(endTime).Subtract(DataHelper.Nz_date(startTime))) & "&nbsp;&nbsp;(" & DataHelper.Nz_date(startTime).ToString("hh:mm tt") & "<img style=""margin: 0 5 0 5"" border=""0"" align=""absmiddle""  src=""" & ResolveUrl("~/images/16x16_arrowright (thin gray).png") & """/>" & DataHelper.Nz_date(endTime).ToString("hh:mm tt") & ")"
            Else
                Return "&nbsp;"
            End If
        Else
            Return "&nbsp;"
        End If
    End Function
    Private Sub LoadOverview()
        'SortFieldOverview
        'SortOrderOverview

        SortField = Setting("SortFieldOverview", "tdCreatedDate")
        SortOrder = Setting("SortOrderOverview", "DESC")



        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetOverviewForMatter")

        DatabaseHelper.AddParameter(cmd, "ReturnTop", "10")
        DatabaseHelper.AddParameter(cmd, "MatterID", MatterId)
        DatabaseHelper.AddParameter(cmd, "OrderBy", GetFullyQualifiedNameForOverview(SortField) + " " + SortOrder)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            rptOverview.DataSource = rd
            rptOverview.DataBind()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        rptOverview.Visible = rptOverview.Items.Count > 0
        pnlNoOverview.Visible = rptOverview.Items.Count = 0

        LoadHeadersOverview()
        SetSortImageOverview()
    End Sub

    Private Sub LoadAllEmails()

        SortField = Setting("SortFieldEmails", "tdEmailDate")
        SortOrder = Setting("SortOrderEmails", "DESC")

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetMatterEMails")

        DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            rpCommunication.DataSource = rd
            rpCommunication.DataBind()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        rpCommunication.Visible = rpCommunication.Items.Count > 0
        pnlNoCommunication.Visible = rpCommunication.Items.Count = 0

        hdnEmailCount.Value = rpCommunication.Items.Count

        'LoadHeadersEmails()
        'SetSortImageEmails()

    End Sub

    Protected Sub LoadMatterPropagations()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "stp_GetMattertasks"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)

                    While rd.Read()
                        Dim dtDueDate As DateTime
                        Dim DueHr As Integer = 0
                        Dim DueMin As Integer = 0
                        Dim intDueZoneDisplay As Integer = 0
                        'Dim strTimeDiff As String = "-8.0"
                        'Dim intDBTimeDiff As Integer = -8
                        'Dim intUTCDiff As Integer = -8
                        Dim AssignedToGroupId As Integer = 0
                        Dim AssignedTo As Integer = 0
                        Dim strDisplayName As String = String.Empty
                        Dim strTimeBlock As String = String.Empty
                        Dim intRowNumber As Integer = 0
                        Dim strDescription As String = String.Empty
                        strDescription = DatabaseHelper.Peel_string(rd, "Description")

                        If strDescription.IndexOf("7-10 AM") > 0 Then
                            strTimeBlock = "7-10 AM"
                            strDescription = strDescription.Replace("-" + strTimeBlock, "")
                        ElseIf strDescription.IndexOf("11 AM-2 PM") > 0 Then
                            strTimeBlock = "11 AM-2 PM"
                            strDescription = strDescription.Replace("-" + strTimeBlock, "")
                        ElseIf strDescription.IndexOf("3-6 PM") > 0 Then
                            strTimeBlock = "3-6 PM"
                            strDescription = strDescription.Replace("-" + strTimeBlock, "")
                        ElseIf strDescription.IndexOf("Not Available") > 0 Then
                            strTimeBlock = "Not Available"
                            strDescription = strDescription.Replace("-" + strTimeBlock, "")
                        End If

                        'intDBTimeDiff = DatabaseHelper.Peel_int(rd, "DBTimeDiff")
                        'intUTCDiff = DatabaseHelper.Peel_int(rd, "FromUTC")
                        dtDueDate = DatabaseHelper.Peel_date(rd, "Due")
                        'intDueZoneDisplay = DatabaseHelper.Peel_int(rd, "DueDateZoneDisplay")
                        'dtDueDate = dtDueDate.AddHours(intDBTimeDiff - intUTCDiff)

                        AssignedToGroupId = DatabaseHelper.Peel_int(rd, "AssignedToGroupId")
                        AssignedTo = DatabaseHelper.Peel_int(rd, "AssignedTo")
                        ''strTimeBlock = DatabaseHelper.Peel_string(rd, "TimeBlock")

                        Using cmdAssigned As IDbCommand = ConnectionFactory.Create().CreateCommand()
                            Using cmdAssigned.Connection

                                cmdAssigned.CommandText = "stp_GetTaskAsignedToList"
                                cmdAssigned.CommandType = CommandType.StoredProcedure
                                DatabaseHelper.AddParameter(cmdAssigned, "UserId", AssignedTo)
                                DatabaseHelper.AddParameter(cmdAssigned, "UserGroupId", AssignedToGroupId)
                                '03.08.2010 added MatterTypeId
                                DatabaseHelper.AddParameter(cmdAssigned, "MatterTypeId", MatterTypeId)
                                cmdAssigned.Connection.Open()
                                Using rdAssigned As IDataReader = cmdAssigned.ExecuteReader(CommandBehavior.SingleResult)
                                    While rdAssigned.Read()
                                        strDisplayName = DatabaseHelper.Peel_string(rdAssigned, "DisplayName")
                                        intRowNumber = DatabaseHelper.Peel_int(rdAssigned, "ROWNumber")
                                    End While
                                End Using

                            End Using
                        End Using

                        'If strDueZoneDisplay = "US Central Time" Then
                        '    dtDueDate = dtDueDate.AddHours(-2)
                        '    strTimeDiff = "-6.0"
                        'ElseIf strDueZoneDisplay = "US Eastern Time" Then
                        '    dtDueDate = dtDueDate.AddHours(-3)
                        '    strTimeDiff = "-5.0"
                        'End If

                        'If Convert.ToString(DatabaseHelper.Peel_string(rd, "DueZone")) = "-6.0" Then
                        '    dtDueDate = dtDueDate.AddHours(-2)
                        'ElseIf Convert.ToString(DatabaseHelper.Peel_string(rd, "DueZone")) = "-5.0" Then
                        '    dtDueDate = dtDueDate.AddHours(-3)
                        'End If

                        'DueHr = dtDueDate.Hour()
                        'DueMin = dtDueDate.Minute()
                        If txtPropagations.Value.Length > 0 Then
                            'ddlLocalCounsel.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "LocalCounsel"), DatabaseHelper.Peel_int(rd, "AttorneyId")))
                            txtPropagations.Value += "|" + intRowNumber.ToString() + "," + "0" + "," + Convert.ToString(FormatDateTime(dtDueDate, DateFormat.ShortDate)) + "," + "0" + "," + Convert.ToString(DatabaseHelper.Peel_int(rd, "TaskTypeID")) + "," + strDescription + "," + Convert.ToString(DatabaseHelper.Peel_int(rd, "TaskID")) + "," + Convert.ToString(DueHr) + "," + Convert.ToString(DueMin) + "," + Convert.ToString(intDueZoneDisplay) + "," + strDisplayName + "," + "" + "," + strTimeBlock + "," + UserCanEdit.ToString()
                        Else
                            txtPropagations.Value = intRowNumber.ToString() + "," + "0" + "," + Convert.ToString(FormatDateTime(dtDueDate, DateFormat.ShortDate)) + "," + "0" + "," + Convert.ToString(DatabaseHelper.Peel_int(rd, "TaskTypeID")) + "," + strDescription + "," + Convert.ToString(DatabaseHelper.Peel_int(rd, "TaskID")) + "," + Convert.ToString(DueHr) + "," + Convert.ToString(DueMin) + "," + Convert.ToString(intDueZoneDisplay) + "," + strDisplayName + "," + "" + "," + strTimeBlock + "," + UserCanEdit.ToString()
                        End If

                    End While
                End Using
            End Using
        End Using

    End Sub

    Private Sub ResetPropagationsCounter()

        Dim Count As Integer = 0

        If txtPropagations.Value.Length > 0 Then

            Count = txtPropagations.Value.Split("|").Length

            lblPropagations.Text = " (" & Count & ")"

        Else
            lblPropagations.Text = String.Empty
        End If

    End Sub

    ''Added to populate MatterStatus Code
    Private Sub PopulateMatterStatusCode()

        ddlMatterStatusCode.Items.Clear()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                'cmd.CommandText = "SELECT * FROM tblMatterStatusCode"
                cmd.CommandText = "SELECT * FROM tblMatterStatus"
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)

                    While rd.Read()
                        'ddlMatterStatusCode.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "MatterStatusCode"), DatabaseHelper.Peel_int(rd, "MatterStatusCodeId")))
                        ddlMatterStatusCode.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "MatterStatus"), DatabaseHelper.Peel_int(rd, "MatterStatusId")))
                    End While

                End Using
            End Using
        End Using

    End Sub

    ''Added to populate MattersubStatus Code
    Private Sub PopulateMatterSubStatusCodes()

        ddlMatterSubStatusCode.Items.Clear()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblMatterSubStatus Where MatterStatusId=@MatterStatusId"
                DatabaseHelper.AddParameter(cmd, "MatterStatusId", ddlMatterStatusCode.SelectedValue)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)

                    While rd.Read()
                        ddlMatterSubStatusCode.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "MatterSubStatus"), DatabaseHelper.Peel_int(rd, "MatterSubStatusId")))
                    End While

                End Using
            End Using
        End Using

    End Sub

    Private Sub LoadMatterDetail()

        'Adding code to pass null into creditor number
        Dim InsertedValue As Integer = 0

        If ddlCreditors.SelectedValue >= 0 Then
            InsertedValue = ddlCreditors.SelectedValue
        End If

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "stp_GetMatterInstance"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                DatabaseHelper.AddParameter(cmd, "AccountId", InsertedValue)
                DatabaseHelper.AddParameter(cmd, "MatterTypeId", MatterTypeId)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()

                        txtMatterDate.Text = rd("MatterDate")
                        txtMatterNumber.Text = rd("MatterNumber")
                        txtMatterMemo2.Text = rd("Note")
                        'ddlMatterStatusCode.SelectedItem.Text = rd("MatterStatusCode")
                        'ddlMatterStatusCode.SelectedItem.Value = rd("MatterStatusCodeId")
                        'If rd("LocalCounsel") = "0" Then
                        '    ddlLocalCounsel.SelectedItem.Text = ""
                        'Else
                        '    ddlLocalCounsel.SelectedValue = rd("LocalCounsel")
                        'End If
                        '2.17.2010
                        ' get alternative such as compare the data with the selected. 

                        'If MatterTypeId = 1 And AccountId > 0 Then
                        'ddlLocalCounsel.Items.FindByValue(rd("AttorneyId")).Selected = True
                        'ddlCreditors.Enabled = False
                        'End If

                        If AccountId > 0 Then
                            ddlCreditors.SelectedIndex = ddlCreditors.Items.IndexOf(ddlCreditors.Items.FindByValue(AccountId))
                        Else
                            If DataHelper.Nz_int(rd("CreditorInstanceId")) = 0 Then
                                ddlCreditors.SelectedValue = DataHelper.Nz_int(rd("CreditorInstanceId"))
                            End If
                        End If

                        AttorneyId = DataHelper.Nz_int(rd("AttorneyId"))

                        txtAccountNumber.Text = rd("AccountNumber")

                        ddlMatterStatusCode.SelectedIndex = ddlMatterStatusCode.Items.IndexOf(ddlMatterStatusCode.Items.FindByValue(DataHelper.Nz_int(rd("MatterStatusId"))))

                        PopulateMatterSubStatusCodes()

                        ddlMatterSubStatusCode.SelectedIndex = ddlMatterSubStatusCode.Items.IndexOf(ddlMatterSubStatusCode.Items.FindByValue(DataHelper.Nz_int(rd("MatterSubStatusId"))))

                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadMatterNumber()

        'Adding code to pass null into creditor number
        Dim InsertedValue As Integer = 0

        If ddlCreditors.SelectedValue >= 0 Then
            InsertedValue = ddlCreditors.SelectedValue
        End If

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "stp_GenerateMatterNumber"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                DatabaseHelper.AddParameter(cmd, "AccountId", InsertedValue)
                DatabaseHelper.AddParameter(cmd, "MatterTypeId", ddlMatterType.SelectedValue)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()

                        txtAccountNumber.Text = rd("AccountNumber")

                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub PopulateValidLocalCounselforClient()
        ddlLocalCounsel.Items.Clear()
        ddlLocalCounsel.Items.Add(New ListItem("--NONE--", "-1"))
        ddlLocalCounsel.Items.Add(New ListItem("--TBD--", "0"))

        Dim strLocalCounselName As String = String.Empty
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "stp_GetLocalCounselListbyClient"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()

                        ddlLocalCounsel.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "LocalCounsel"), DatabaseHelper.Peel_int(rd, "AttorneyId").ToString() + "#" + DatabaseHelper.Peel_string(rd, "Details")))
                        'ddlLocalCounsel.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "LocalCounsel"), DatabaseHelper.Peel_int(rd, "AttorneyId")))
                        If AttorneyId = DatabaseHelper.Peel_int(rd, "AttorneyId") Then
                            strLocalCounselName = DatabaseHelper.Peel_string(rd, "LocalCounsel")
                        End If

                    End While

                    If AttorneyId > 0 Then
                        If strLocalCounselName <> "" Then
                            ddlLocalCounsel.SelectedIndex = ddlLocalCounsel.Items.IndexOf(ddlLocalCounsel.Items.FindByText(strLocalCounselName))
                        End If
                    Else
                        ddlLocalCounsel.SelectedIndex = ddlLocalCounsel.Items.IndexOf(ddlLocalCounsel.Items.FindByValue(AttorneyId))
                    End If

                End Using
            End Using
        End Using
    End Sub

    Private Sub PopulateClassifications()
        ddlClassification.Items.Clear()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblClassifications"

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        ddlClassification.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Classification"), DatabaseHelper.Peel_int(rd, "ClassificationID")))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub PopulateMatterClassifications()

        Dim ClassificationID As Int32 = 0
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT ClassificationID FROM tblMatterClassification Where MatterID=@MatterID"
                DatabaseHelper.AddParameter(cmd, "MatterID", MatterId)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        ClassificationID = DatabaseHelper.Peel_int(rd, "ClassificationID")
                        ddlClassification.Items.FindByValue(ClassificationID).Selected = True
                    End While
                End Using
            End Using
        End Using

    End Sub

    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        'add applicant tasks
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SaveConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Matter</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SaveAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save and close</a>")

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkAccounts.HRef = "~/clients/client/creditors/accounts/?id=" & ClientID

        lnkPerson.InnerText = AccountHelper.GetCreditorName(AccountId)
        lnkPerson.HRef = "~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & AccountId & "&a=m"

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:OpenScanning();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_remove.png") & """ align=""absmiddle""/>Scan Document</a>")

        If Master.UserEdit Or UserTypeID = 5 Then 'Attorneys always can add notes
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddMatterNote();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_note.png") & """ align=""absmiddle""/>Add a note</a>")
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddMatterPhoneCall();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_phone2.png") & """ align=""absmiddle""/>Add a Phone Call</a>")
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SendEmail();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_email.png") & """ align=""absmiddle""/>Send an Email</a>")
            If UserGroupID = 20 Or UserGroupID = 34 Or UserGroupID = 35 Or UserGroupID = 38 Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddExpenses();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_report.png") & """ align=""absmiddle""/>Time & Expense entry</a>")
            End If

        End If

    End Sub

    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function

    Private Sub InsertOrUpdate()

        Dim AttorneyID As Integer = 0

        If ddlLocalCounsel.SelectedValue <> "0" And ddlLocalCounsel.SelectedValue <> "-1" Then
            AttorneyID = ddlLocalCounsel.SelectedValue.Split("#")(0)
        Else
            AttorneyID = ddlLocalCounsel.SelectedValue
        End If

        If ddlCreditors.SelectedValue > 0 Then
            If CreditorInstanceId = 0 Or CreditorInstanceId = hdnLatestCreditorId.Value Then

                CreditorInstanceId = hdnLatestCreditorId.Value

            ElseIf CreditorInstanceId <> hdnLatestCreditorId.Value Then

                CreditorInstanceId = hdnLatestCreditorId.Value

            End If
        Else
            CreditorInstanceId = ddlCreditors.SelectedValue
        End If


        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "stp_InsertMatter"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                DatabaseHelper.AddParameter(cmd, "AccountId", ddlCreditors.SelectedValue)
                DatabaseHelper.AddParameter(cmd, "MatterStatusCodeId", ddlMatterStatusCode.SelectedValue)
                DatabaseHelper.AddParameter(cmd, "MatterNumber", txtMatterNumber.Text)
                DatabaseHelper.AddParameter(cmd, "MatterDate", txtMatterDate.Text)
                DatabaseHelper.AddParameter(cmd, "MatterMemo", txtMatterMemo2.Text)
                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                DatabaseHelper.AddParameter(cmd, "AttorneyId", AttorneyID)
                DatabaseHelper.AddParameter(cmd, "CreditorInstanceId", CreditorInstanceId)
                DatabaseHelper.AddParameter(cmd, "MatterTypeId", ddlMatterType.SelectedValue)
                DatabaseHelper.AddParameter(cmd, "MatterStatusId", ddlMatterStatusCode.SelectedValue)
                DatabaseHelper.AddParameter(cmd, "MatterSubStatusId", ddlMatterSubStatusCode.SelectedValue)

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)

                End Using
            End Using
        End Using


        Dim strClassification As String = String.Empty
        Dim iListIndex As Int32 = 0
        For iListIndex = 0 To ddlClassification.Items.Count - 1
            If ddlClassification.Items(iListIndex).Selected Then
                strClassification = strClassification & ddlClassification.Items(iListIndex).Value & ","
            End If
        Next iListIndex
        If strClassification <> String.Empty Then
            strClassification = strClassification & "0"
        End If


        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.Connection.Open()

                If strClassification.Trim().Length > 0 Then
                    cmd.CommandText = "INSERT INTO tblMatterClassification SELECT  " & MatterId & ",srt.ClassificationID," & UserID & ",getdate()  FROM tblClassifications as srt left join (SELECT ClassificationID, MatterID, count(*) as Num FROM tblMatterClassification GROUP BY MatterID, ClassificationID) as rel on rel.ClassificationID = srt.ClassificationID and rel.MatterID = " & MatterId & " WHERE rel.Num is null and srt.ClassificationID in (" & strClassification & ")"

                    cmd.ExecuteNonQuery()

                    cmd.CommandText = "DELETE tblMatterClassification WHERE ClassificationID in (SELECT rel.ClassificationID FROM tblClassifications as rel inner join tblMatterClassification as srt on srt.ClassificationID = rel.ClassificationID WHERE srt.ClassificationID not in (" & strClassification & ") and srt.MatterID = " & MatterId & ")"

                    cmd.ExecuteNonQuery()
                Else
                    cmd.CommandText = "DELETE tblMatterClassification WHERE MatterID = " & MatterId

                    cmd.ExecuteNonQuery()
                End If
            End Using
        End Using

    End Sub

    Private Sub UpdateMatterTask()

        Dim Propagations() As String

        Propagations = txtPropagations.Value.Split("|")

        For Each Propagation As String In Propagations

            If Propagation.Length > 0 Then

                Dim Parts() As String = Propagation.Split(",")
                Dim AssignedToGroupId As Integer
                Dim AssignedTo As Integer
                Dim AssignedToResolver As Integer = DataHelper.Nz_int(Parts(0))
                Dim DueTypeID As Integer = DataHelper.Nz_int(Parts(1))
                Dim DueDate As String = Parts(2)
                Dim Due As String = Parts(3)
                Dim TaskTypeID As Integer = DataHelper.Nz_int(Parts(4))
                Dim Description As String = Parts(5)
                Dim TaskId As Integer = Parts(6)
                'Dim DueHr As Integer = Parts(7)
                'Dim DueMin As Integer = Parts(8)
                'Dim DueZone As Integer = Parts(9)
                Dim strTimeBlock As String = Parts(12).ToString()
                Dim strReason As String = Parts(14).ToString()


                'build Due date with time
                Dim dtDueDate As DateTime
                dtDueDate = Convert.ToDateTime(DueDate + " 0:0")
                'dtDueDate = Convert.ToDateTime(DueDate + " " + Convert.ToString(DueHr) + ":" + Convert.ToString(DueMin))

                'build description
                If Not TaskTypeID = 0 Then 'not ad hoc, predefined by tasktype
                    Description = DataHelper.FieldLookup("tblTaskType", "DefaultDescription", "TaskTypeID = " & TaskTypeID)
                End If

                Description = Description + " " + "-" + strTimeBlock

                Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                    Using cmd.Connection
                        cmd.Connection.Open()
                        cmd.CommandText = "stp_GetTaskAsignedToList"
                        cmd.CommandType = CommandType.StoredProcedure
                        DatabaseHelper.AddParameter(cmd, "RowNumber", AssignedToResolver)
                        DatabaseHelper.AddParameter(cmd, "UserGroupId", UserGroupID)
                        DatabaseHelper.AddParameter(cmd, "UserId", DBNull.Value)
                        DatabaseHelper.AddParameter(cmd, "MatterTypeId", MatterTypeId)
                        Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                            While rd.Read()
                                AssignedTo = rd("UserId")
                                AssignedToGroupId = rd("UserGroupId")
                            End While
                        End Using
                    End Using
                End Using

                If TaskId > 0 Then
                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                        Using cmd.Connection

                            cmd.CommandText = "stp_UpdateMatterTask"
                            cmd.CommandType = CommandType.StoredProcedure
                            DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                            DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                            DatabaseHelper.AddParameter(cmd, "Description", Description)
                            DatabaseHelper.AddParameter(cmd, "AssignedTo", AssignedTo)
                            DatabaseHelper.AddParameter(cmd, "DueDate", dtDueDate)
                            DatabaseHelper.AddParameter(cmd, "TaskTypeId", TaskTypeID)
                            DatabaseHelper.AddParameter(cmd, "UserId", UserID)
                            DatabaseHelper.AddParameter(cmd, "TaskId", TaskId)
                            DatabaseHelper.AddParameter(cmd, "DueZoneDisplay", 0)
                            DatabaseHelper.AddParameter(cmd, "AssignedToGroupId", AssignedToGroupId)

                            cmd.Connection.Open()
                            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                            End Using
                        End Using
                    End Using

                    If strReason.Trim().Length > 0 Then
                        'Save the reason to tblTaskNotes table 

                        Dim NoteID As Integer = NoteHelper.InsertNote(strReason, UserID, ClientID)

                        'link this note to current task
                        TaskHelper.InsertTaskNote(TaskId, NoteID, UserID)

                    End If

                Else
                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                        Using cmd.Connection

                            cmd.CommandText = "stp_InsertMatterTask"
                            cmd.CommandType = CommandType.StoredProcedure
                            DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                            DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                            DatabaseHelper.AddParameter(cmd, "Description", Description)
                            DatabaseHelper.AddParameter(cmd, "AssignedTo", AssignedTo)
                            DatabaseHelper.AddParameter(cmd, "DueDate", dtDueDate)
                            DatabaseHelper.AddParameter(cmd, "TaskTypeId", TaskTypeID)
                            DatabaseHelper.AddParameter(cmd, "UserId", UserID)
                            DatabaseHelper.AddParameter(cmd, "DueZoneDisplay", 0)
                            DatabaseHelper.AddParameter(cmd, "AssignedToGroupId", AssignedToGroupId)

                            cmd.Connection.Open()
                            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                            End Using
                        End Using
                    End Using
                End If

            End If
        Next

    End Sub

    Private Sub Close()
        If Not IsNothing(Request.QueryString("t")) Then
            Response.Redirect("~/clients/client/?id=" & ClientID)
        Else
            Response.Redirect("~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & AccountId & "&a=m")
        End If
        'If MatterTypeId = 1 Then
        '    If AccountId > 0 Then
        '        Response.Redirect("~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & AccountId & "&a=m")
        '    Else
        '        Response.Redirect("~/clients/client/?id=" & ClientID)
        '    End If
        '    'Response.Redirect("~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & AccountId & "&a=m")
        'Else
        '    Response.Redirect("~/clients/client/?id=" & ClientID)
        'End If
    End Sub

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        'SharedFunctions.DocumentAttachment.DeleteAllForItem(hdnTempAccountID.Value, "account", UserID)
        SharedFunctions.DocumentAttachment.DeleteAllForItem(hdnTempAccountID.Value, "matter", UserID)
        Close()
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        InsertOrUpdate()
        'UpdateMatterTask()
        'Close()
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub

    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        SharedFunctions.DocumentAttachment.DeleteAttachment(hdnCurrentDoc.Value, UserID)
        LoadDocuments()
    End Sub

    Private Sub LoadDocuments()
        'rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(Integer.Parse(hdnTempAccountID.Value), "account")
        'rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(Integer.Parse(hdnTempMatterID.Value), "matter")
        'rpDocuments.DataBind()
        rpDocuments.DataSource = GetAttachmentsForRelation(Integer.Parse(hdnTempMatterID.Value), "matter")
        rpDocuments.DataBind()
        'If rpDocuments.DataSource.Count > 0 Then
        '    hypDeleteDoc.Disabled = False
        'Else
        '    hypDeleteDoc.Disabled = True
        'End If
    End Sub

    Public Function GetAttachmentsForRelation(ByVal relationID As Integer, ByVal relationType As String, Optional ByVal url As String = "") As List(Of AttachedDocument)

        Dim docs As New List(Of AttachedDocument)

        Dim final As New List(Of AttachedDocument)

        Dim cmdStr As String = "SELECT dr.DocTypeID, dr.subfolder, dr.DocRelationID, dt.DisplayName, isnull(ds.ReceivedDate, '01/01/1900') as ReceivedDate, " + _
"isnull(ds.Created, '01/01/1900') as Created, isnull(u.FirstName + ' ' + u.LastName + '</br>' + ug.Name, '') as CreatedBy FROM tblDocRelation as dr inner join tblDocumentType as dt " + _
"on dt.TypeID = dr.DocTypeID left join tblDocScan as ds on ds.DocID = dr.DocID left join tblUser as u on u.UserID = ds.CreatedBy inner join tblusergroup as ug on ug.usergroupid = u.usergroupid " + _
"WHERE dr.RelationID = " + relationID.ToString() + " and dr.RelationType = '" + relationType + "' and (DeletedFlag = 0 or DeletedBy = -1) " + _
"ORDER BY ds.Created desc"


        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        'docs.Add(New AttachedDocument(reader("DocRelationID"), "", reader("DisplayName"), "", False, "", Date.Parse(reader("ReceivedDate")).ToString("d"), Date.Parse(reader("Created")).ToString("g"), IIf(reader("CreatedBy") Is Nothing, "", reader("CreatedBy").ToString())))
                        If DataHelper.Nz_string(reader("DocTypeID")) = "M030" Then
                            docs.Add(New AttachedDocument(reader("DocRelationID"), "", DataHelper.Nz_string(reader("subfolder")), "", False, "", Date.Parse(reader("ReceivedDate")).ToString("d"), Date.Parse(reader("Created")).ToString("g"), IIf(reader("CreatedBy") Is Nothing, "", reader("CreatedBy").ToString())))
                        Else
                            docs.Add(New AttachedDocument(reader("DocRelationID"), "", reader("DisplayName"), "", False, "", Date.Parse(reader("ReceivedDate")).ToString("d"), Date.Parse(reader("Created")).ToString("g"), IIf(reader("CreatedBy") Is Nothing, "", reader("CreatedBy").ToString())))

                        End If
                    End While
                End Using
            End Using
        End Using

        Dim tempName As String

        For Each doc As AttachedDocument In docs
            tempName = BuildAttachmentPath(doc.DocRelationID)
            If url.ToLower().Contains(".com") Then
                doc.DocumentPath = "http://service.dmsisupport.com" & tempName.Substring(tempName.IndexOf("\", 2))
            Else
                doc.DocumentPath = "file:///" & tempName
            End If
            doc.DocumentName = Path.GetFileName(doc.DocumentPath)
            If File.Exists(tempName) Then
                doc.Existence = True
            End If
            If doc.Received = "1/1/1900" Then
                doc.Received = ""
            End If
            If doc.Created.Contains("1/1/1900") Then
                doc.Created = ""
            End If
            final.Add(doc)
        Next
        Return final
    End Function

    Public Function BuildAttachmentPath(ByVal docRelID As Integer) As String
        Dim docTypeID As String = String.Empty
        Dim docID As String = String.Empty
        Dim dateStr As String = String.Empty
        Dim clientID As Integer = 0
        Dim subFolder As String = String.Empty
        Using cmd As New SqlCommand("SELECT ClientID, DocTypeID, DocID, DateString, isnull(SubFolder, '') as SubFolder FROM tblDocRelation WHERE DocRelationID = " + docRelID.ToString(), ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        docTypeID = reader("DocTypeID").ToString()
                        docID = reader("DocID").ToString()
                        dateStr = reader("DateString").ToString()
                        clientID = Integer.Parse(reader("ClientID"))
                        subFolder = reader("SubFolder").ToString()
                    End If
                End Using
            End Using
        End Using

        Return BuildAttachmentPath(docTypeID, docID, dateStr, clientID, subFolder)

    End Function

    Public Function BuildAttachmentPath(ByVal docTypeID As String, ByVal docID As String, ByVal dateStr As String, ByVal clientID As Integer, Optional ByVal subFolder As String = "") As String
        Dim acctNo As String = String.Empty
        Dim server As String = String.Empty
        Dim storage As String = String.Empty
        Dim folder As String = String.Empty

        Using cmd As New SqlCommand("SELECT AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + clientID.ToString(), ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999")) '
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        acctNo = reader("AccountNumber").ToString()
                        server = reader("StorageServer").ToString()
                        storage = reader("StorageRoot").ToString()
                    End If
                End Using
                cmd.CommandText = "SELECT DocFolder FROM tblDocumentType WHERE TypeID = '" + docTypeID + "'"
                folder = cmd.ExecuteScalar().ToString()
            End Using
        End Using
        If subfolder = "\" Then
            subfolder = ""
        End If
        If docTypeID = "M030" Then
            'Return "\\" + server + "\" + storage + "\" + acctNo + "\" + folder + "\" & subFolder
            Return subFolder
        Else
            Return "\\" + server + "\" + storage + "\" + acctNo + "\" + folder + "\" + IIf(subFolder.Length > 0, subFolder, "") + acctNo + "_" + docTypeID + "_" + docID + "_" + dateStr + ".pdf"
            'Return "\\" + server + "\" + storage + "\" + acctNo + "\" + folder + IIf(subFolder.Length > 0, +subFolder, "") + acctNo + "_" + docTypeID + "_" + docID + "_" + dateStr + ".pdf"
        End If
    End Function

    Protected Sub lnkShowDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowDocs.Click
        LoadDocuments()
    End Sub

    Protected Sub lnkResort_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResort.Click
        If txtSortField.Value = Setting("SortField") Then
            'toggle sort order
            If Setting("SortOrder") = "ASC" Then
                SortOrder = "DESC"
            Else
                SortOrder = "ASC"
            End If
        Else
            SortField = txtSortField.Value
            SortOrder = "ASC"
        End If
        SortField = txtSortField.Value

        Setting("SortField") = SortField
        Setting("SortOrder") = SortOrder
        tabIndex = 1
        tsMatterView.TabPages(tabIndex).Selected = True
    End Sub

    Protected Sub lnkResortNotes_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResortNotes.Click
        If txtSortFieldNotes.Value = Setting("SortFieldNotes") Then
            'toggle sort order
            If Setting("SortOrderNotes") = "ASC" Then
                SortOrder = "DESC"
            Else
                SortOrder = "ASC"
            End If
        Else
            SortField = txtSortFieldNotes.Value
            SortOrder = "DESC"
        End If
        SortField = txtSortFieldNotes.Value

        Setting("SortFieldNotes") = SortField
        Setting("SortOrderNotes") = SortOrder
        tabIndex = 2
        tsMatterView.TabPages(tabIndex).Selected = True
    End Sub

    Protected Sub lnkResortPhones_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResortPhones.Click
        If txtSortFieldPhones.Value = Setting("SortFieldPhones") Then
            'toggle sort order
            If Setting("SortOrderPhones") = "ASC" Then
                SortOrder = "DESC"
            Else
                SortOrder = "ASC"
            End If
        Else
            SortField = txtSortFieldPhones.Value
            SortOrder = "DESC"
        End If
        SortField = txtSortFieldPhones.Value

        Setting("SortFieldPhones") = SortField
        Setting("SortOrderPhones") = SortOrder
        tabIndex = 3
        tsMatterView.TabPages(tabIndex).Selected = True
    End Sub

    Protected Sub lnkResortEmails_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResortEmails.Click
        If txtSortFieldEmails.Value = Setting("SortFieldEmails") Then
            'toggle sort order
            If Setting("SortOrderEmails") = "ASC" Then
                SortOrder = "DESC"
            Else
                SortOrder = "ASC"
            End If
        Else
            SortField = txtSortFieldEmails.Value
            SortOrder = "ASC"
        End If
        SortField = txtSortFieldEmails.Value

        Setting("SortFieldEmails") = SortField
        Setting("SortOrderEmails") = SortOrder
        tabIndex = 4
        tsMatterView.TabPages(tabIndex).Selected = True
    End Sub

    Protected Sub ddlCreditors_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCreditors.SelectedIndexChanged
        LoadMatterNumber()

        If ddlCreditors.SelectedValue > 0 Then
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandText = "get_ValidCreditorsList"
                    cmd.CommandType = CommandType.StoredProcedure
                    DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                    DatabaseHelper.AddParameter(cmd, "AccountId", ddlCreditors.SelectedValue)
                    cmd.Connection.Open()
                    Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                        While rd.Read()
                            hdnLatestCreditorId.Value = DatabaseHelper.Peel_int(rd, "CreditorInstanceId")
                        End While
                    End Using
                End Using
            End Using
        End If

    End Sub

    Protected Sub ddlMatterStatusCode_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlMatterStatusCode.SelectedIndexChanged
        PopulateMatterSubStatusCodes()
    End Sub

    Protected Sub lnkResortOverview_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResortOverview.Click
        If txtSortFieldOverview.Value = Setting("SortFieldOverview") Then
            'toggle sort order
            If Setting("SortOrderOverview") = "ASC" Then
                SortOrder = "DESC"
            Else
                SortOrder = "ASC"
            End If
        Else
            SortField = txtSortFieldOverview.Value
            SortOrder = "DESC"
        End If
        SortField = txtSortFieldOverview.Value

        Setting("SortFieldOverview") = SortField
        Setting("SortOrderOverview") = SortOrder
        tabIndex = 0
        tsMatterView.TabPages(tabIndex).Selected = True
    End Sub

    Protected Sub lnkSaveClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveClose.Click
        InsertOrUpdate()
        'UpdateMatterTask()
        Close()
    End Sub
End Class
