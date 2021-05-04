Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports SharedFunctions
Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_communication_default
    Inherits PermissionPage

#Region "Variables"
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
    Protected Sub RemoveSetting(ByVal s As String)
        Session.Remove(Identity & "_" & s)
    End Sub
    Public ReadOnly Property DataClientID() As Integer
        Get
            Return Master.DataClientID
        End Get
    End Property
    Public Shadows ReadOnly Property ClientID() As Integer
        Get
            Return DataClientID
        End Get
    End Property
    Public QueryString As String
    Private qs As QueryStringCollection
    Private baseTable As String = "tblClient"

    Private UserID As Integer
    Private UserTypeID As Integer

    Private SortField As String
    Private SortOrder As String
    Private Headers As Dictionary(Of String, HtmlTableCell)
    Private relations As New List(Of SharedFunctions.DocRelation)
#End Region

#Region "Sorting"
    Protected Sub lnkResort_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResort.Click
        LoadHeaders()

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

    End Sub
    Public Sub SetSortImage()
        Headers(SortField).Controls.Add(GetSortImage(SortOrder))
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
        AddHeader(Headers, tdUser)
        AddHeader(Headers, tdUserType)
    End Sub
    Private Sub AddHeader(ByVal c As System.Collections.Generic.Dictionary(Of String, HtmlTableCell), ByVal td As HtmlTableCell)
        c.Add(td.ID, td)
    End Sub
    Private Function GetFullyQualifiedName(ByVal s As String) As String
        Select Case s
            Case "tdDate"
                Return "n.created"
            Case "tdUser"
                Return "u.lastname"
            Case "tdUserType"
                Return "ut.name"
        End Select
        Return "Unknown"
    End Function
#End Region

    Public Function MakeSnippet(ByVal s As String, ByVal length As Integer) As String
        Dim result As String = s
        If result.Length > length Then result = result.Substring(0, length - 3) + "..."
        Return result
    End Function
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        tsMain.TabPages(0).Selected = True

    End Sub
    Private Sub LoadTabStrips()

        tsMain.TabPages.Clear()
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Notes", dvPanel0.ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Phone&nbsp;Calls", dvPanel1.ClientID, "phonecalls.aspx?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Litigation", dvPanel2.ClientID, "litigation.aspx?id=" & ClientID))
        'tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Emails", dvPanel3.ClientID, "emails.aspx?id=" & ClientID))

    End Sub
    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        LoadHeaders()
        SortField = Setting("SortField", "tdDate")
        SortOrder = Setting("SortOrder", "DESC")

        LoadCommunication()

        SetSortImage()

    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        LoadTabStrips()

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserTypeID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID))

        qs = LoadQueryString()

        PrepQuerystring()

        If Not qs Is Nothing Then

            If Not IsPostBack Then

                lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
                lnkClient.HRef = "~/clients/client/" & QueryString

                SetRollups()

                relations = SharedFunctions.DocumentAttachment.GetRelationsForClient(ClientID)

            End If

        End If

    End Sub
    Private Sub PrepQuerystring()

        'prep querystring for pages that need those variables
        QueryString = New QueryStringBuilder(Request.Url.Query).QueryString

        If QueryString.Length > 0 Then
            QueryString = "?" & QueryString
        End If

    End Sub
    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = Master.CommonTasks
        If Master.UserEdit Then
            'CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddApplicant();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_person_add.png") & """ align=""absmiddle""/>Add new applicant</a>")
            'CommonTasks.Add("<hr size=""1""/>")
        End If
        If Master.UserEdit Or UserTypeID = 5 Then 'Attorneys always can add notes
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddNote();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_note.png") & """ align=""absmiddle""/>Add a note</a>")
        End If
    End Sub

    Public Structure NoteRelation
        Dim NoteID As Integer
        Dim EntityName As String
        Dim RelationTypeID As Integer
        Dim RelationTypeName As String
        Dim RelationID As Integer
        Dim IconURL As String
        Dim NavigateURL As String
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
    Private Notes As New Dictionary(Of Integer, GridNote)
    
    Private Sub LoadCommunication()
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNotes2")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)
                DatabaseHelper.AddParameter(cmd, "OrderBy", GetFullyQualifiedName(SortField) + " " + SortOrder)
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
                            If r.RelationTypeID = 19 Then
                                Dim CreditorInstanceId As Integer = 0
                                Dim AccountID As Integer = 0

                                Using cmdc As IDbCommand = ConnectionFactory.Create().CreateCommand()
                                    Using cmdc.Connection
                                        cmdc.CommandText = "select  m.MatterId, m.ClientId, ci.CreditorInstanceId, ci.AccountId,  m.MatterTypeId " & _
                                        " from dbo.tblMatter m left join dbo.tblCreditorInstance ci on m.CreditorInstanceId = ci.CreditorInstanceId  where m.matterid = @matterId "
                                        cmdc.Connection.Open()
                                        cmdc.Parameters.Clear()
                                        DatabaseHelper.AddParameter(cmdc, "matterid", r.RelationID)

                                        Using rdc As IDataReader = cmdc.ExecuteReader()
                                            While rdc.Read()
                                                CreditorInstanceId = DatabaseHelper.Peel_int(rdc, "CreditorInstanceId")
                                                AccountID = DatabaseHelper.Peel_int(rdc, "AccountId")
                                            End While
                                        End Using
                                    End Using
                                End Using


                                r.NavigateURL = ResolveUrl(DatabaseHelper.Peel_string(rd, "navigateurl").Replace("$clientid$", DataClientID).Replace("$aid$", AccountID).Replace("$ciid$", CreditorInstanceId).Replace("$x$", r.RelationID))
                            Else
                                r.NavigateURL = ResolveUrl(DatabaseHelper.Peel_string(rd, "navigateurl").Replace("$clientid$", DataClientID).Replace("$x$", r.RelationID))
                            End If
                            n.Relations.Add(r)
                        End If
                    End While
                End Using
            End Using
        End Using
        rpNotes.DataSource = Notes.values
        rpNotes.DataBind()

        rpNotes.Visible = rpNotes.Items.Count > 0
        pnlNoNotes.Visible = rpNotes.Items.Count = 0
    End Sub
    Public Function GetAttachmentText(ByVal id As Integer, ByVal type As String) As String
        For Each rel As SharedFunctions.DocRelation In relations
            If rel.RelationID = id And rel.RelationType = type Then
                Return "<img src=""" + ResolveUrl("~/images/11x16_paperclip.png") + """ border="""" alt="""" />"
            End If
        Next

        Return "&nbsp"
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

    Public Function GetPage(ByVal type As String) As String
        Return type
    End Function
    Public Function GetQSID(ByVal type As String) As String
        Select Case type
            Case "note"
                Return "nid"
            Case "phonecall"
                Return "pcid"
        End Select
        Return String.Empty
    End Function
    Public Function GetImage(ByVal type As String) As String
        Select Case type
            Case "note"
                Return ResolveUrl("~/images/16x16_note.png")
            Case "phonecall"
                Return ResolveUrl("~/images/16x16_phone2.png")
        End Select
        Return String.Empty
    End Function
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        If txtSelected.Value.Length > 0 Then

            'get selected "," delimited NoteId's
            Dim Communications() As String = txtSelected.Value.Split(",")

            Dim NoteIDs As New List(Of Integer)

            For Each com As String In Communications
                NoteIDs.Add(DataHelper.Nz_int(com))
            Next

            If NoteIDs.Count > 0 Then
                NoteHelper.Delete(NoteIDs.ToArray())
            End If

        End If

        'reload same page (of applicants)
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(phCommunication_default, c, "Clients-Client Single Record-Communication-Default")
        AddControl(trCommunication_agency, c, "Clients-Client Single Record-Communication-Agency")
        AddControl(trCommunication_my, c, "Clients-Client Single Record-Communication-My")
    End Sub

    Protected Sub grdCommunication_agency_OnFillTable(ByRef tbl As System.Data.DataTable) Handles grdCommunication_agency.OnFillTable
        Dim t As New DataTable
        t.Columns.Add("ClickableURL", GetType(String))
        t.Columns.Add("IconSrcURL", GetType(String))
        t.Columns.Add("Date", GetType(DateTime))
        t.Columns.Add("By", GetType(String))
        t.Columns.Add("Direction", GetType(String))
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCommunicationForClient")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read
                        Dim type As String = DatabaseHelper.Peel_string(rd, "type")
                        Dim commdate As DateTime = DatabaseHelper.Peel_date(rd, "date")
                        Dim by As String = DatabaseHelper.Peel_string(rd, "by")
                        Dim direction As Nullable(Of Boolean) = DatabaseHelper.Peel_nbool(rd, "direction")

                        Dim fieldid As String = DatabaseHelper.Peel_int(rd, "fieldid")

                        Dim r As DataRow = t.NewRow
                        r("ClickableURL") = ResolveUrl("~/clients/client/communication/" & GetPage(type) & ".aspx") & "?id=" & DataClientID.ToString & "&" & GetQSID(type) & "=" & fieldid
                        r("IconSrcURL") = GetImage(type)
                        r("Date") = commdate
                        r("By") = by
                        If direction.HasValue Then
                            r("Direction") = IIf(direction, "Outgoing", "Incoming")
                        End If
                        t.Rows.Add(r)
                    End While
                End Using
            End Using
        End Using
        tbl = t
    End Sub
    Protected Sub grdCommunication_my_OnFillTable(ByRef tbl As System.Data.DataTable) Handles grdCommunication_my.OnFillTable
        Dim t As New DataTable
        t.Columns.Add("ClickableURL", GetType(String))
        t.Columns.Add("IconSrcURL", GetType(String))
        t.Columns.Add("Date", GetType(DateTime))
        t.Columns.Add("By", GetType(String))
        t.Columns.Add("Message", GetType(String))
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCommunicationForClient")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "ReturnTop", "5")
                DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
                DatabaseHelper.AddParameter(cmd, "UserID", UserID)

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read
                        Dim type As String = DatabaseHelper.Peel_string(rd, "type")
                        Dim commdate As DateTime = DatabaseHelper.Peel_date(rd, "date")
                        Dim by As String = DatabaseHelper.Peel_string(rd, "by")
                        Dim message As String = DatabaseHelper.Peel_string(rd, "message")
                        Dim fieldid As String = DatabaseHelper.Peel_int(rd, "fieldid")

                        Dim r As DataRow = t.NewRow
                        r("ClickableURL") = ResolveUrl("~/clients/client/communication/" & GetPage(type) & ".aspx") & "?id=" & DataClientID.ToString & "&" & GetQSID(type) & "=" & fieldid
                        r("IconSrcURL") = GetImage(type)
                        r("Date") = commdate
                        r("By") = by
                        r("Message") = message
                        t.Rows.Add(r)
                    End While
                End Using
            End Using
        End Using
        tbl = t
    End Sub
End Class