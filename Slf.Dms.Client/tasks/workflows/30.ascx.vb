﻿Option Explicit On

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

Partial Class tasks_workflows_30
    Inherits System.Web.UI.UserControl

#Region "Variables"
   
    Public tabIndex As Int16 = 0
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Public QueryString As String

    Private UserID As Integer
    Private UserTypeID As Integer

    Private SortField As String
    Private SortOrder As String
    Private Headers As Dictionary(Of String, HtmlTableCell)
    Private HeadersTasks As Dictionary(Of String, HtmlTableCell)
    Private HeadersPhones As Dictionary(Of String, HtmlTableCell)
    Private HeadersNotes As Dictionary(Of String, HtmlTableCell)
    Private HeadersEmails As Dictionary(Of String, HtmlTableCell)

    Public AccountId As Integer
    Public MatterId As Integer
    Public TaskTypeId As Integer
    Public MatterTypeId As Integer
    Public CreditorInstanceId As Integer
    Private conv_stateid As Integer
    Private relations As New List(Of SharedFunctions.DocRelation)

    Private strMatterDesc As String = String.Empty
    Private strDate As String = String.Empty
    Private strCreatedBy As String = String.Empty

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
            Return ClientID ' Master.DataClientID
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
    Private Function GetFullyQualifiedNameForEmails(ByVal s As String) As String
        Select Case s
            Case "tdEmailDate"
                Return "[Emaildate]"
            Case "tdSentBy"
                Return "tblcreatedby.firstname"
            Case "tdEMailSubject"
                Return "t.[MailSubject]"
        End Select
        Return "n.created"
    End Function

    Private Function GetFullyQualifiedNameForTasks(ByVal s As String) As String
        Select Case s
            Case "Th5"
                Return "TaskType"
            Case "Th6"
                Return "Description" '"T.Description"
            Case "Th7"
                Return "CreatedBy"
            Case "Th8"
                Return "AssignedTo"
            Case "Th9"
                Return "CreatedDate"
            Case "Th10"
                Return "DueDate"
            Case "Th11"
                Return "Resolved" '"T.Resolved"
        End Select
        Return "CreatedBy"
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
        'Dim Duration As String
        Dim Value As String
        Dim Color As String
        Dim TextColor As String
        Dim BodyColor As String
        Dim TaskResolutionId As Integer


        'ReadOnly Property Status() As String
        '    Get

        '        If ResolvedDate.HasValue Then
        '            Return "RESOLVED"
        '        Else

        '            If DueDate < Now Then
        '                Return "PAST DUE"
        '            Else
        '                Return "OPEN"
        '            End If

        '        End If

        '    End Get
        'End Property
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
                'sb.Append("<img style=""position:relative;top:4"" src=""" & ResolveUrl(r.IconURL) & """ border=""0""/>&nbsp;<b>" + r.RelationTypeName + "</b>&nbsp;<a class=""lnk"" href=""" + r.NavigateURL + """>" + r.EntityName + "</a>")
                sb.Append("<img style=""position:relative;top:4"" src=""" & ResolveUrl(r.IconURL) & """ border=""0""/>&nbsp;<b>" + r.RelationTypeName + "</b>&nbsp; " + r.EntityName + " ")

            Else
                sb.Append(r.EntityName)
            End If
        Next
        Return sb.ToString
    End Function
    
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

    Private Sub LoadTabStrips()

        tsMatterView.TabPages.Clear()
        If hdnTasksCount.Value <> "" And hdnTasksCount.Value <> "0" Then
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Parent&nbsp;Tasks&nbsp;&nbsp;<font color='blue'>(" & hdnTasksCount.Value.ToString() & ")</font>", dvPanel0.ClientID))
        Else
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Parent&nbsp;Tasks", dvPanel0.ClientID))
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
        qs = LoadQueryString()
        UserTypeID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID))

        If Not qs Is Nothing Then
            Dim iTaskId As Int32 = DataHelper.Nz_int(qs("id"), 0)
            Dim rd As IDataReader = Nothing
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            ' UserTypeId=7 is Litigation
            'cmd.CommandText = "select mt.matterid, m.clientid, a.accountid, t.tasktypeid, m.creditorinstanceid, m.MatterTypeId from tbltask t , tblmattertask mt, tblmatter m," & _
            '                  " tblaccount a, tblCreditorInstance c " & _
            '                  " where t.taskid = @TaskId And t.taskid = mt.taskid And mt.matterid = m.matterid " & _
            '                  " and m.clientid=a.clientid and m.CreditorInstanceId=c.CreditorInstanceID" & _
            '                  " and a.accountid=c.accountid"
            cmd.CommandText = "select mt.matterid, m.clientid, a.accountid, t.tasktypeid, m.creditorinstanceid, m.MatterTypeId from tbltask t ," & _
                                "  tblmattertask mt, tblmatter m left outer join " & _
                                " tblCreditorInstance c on m.CreditorInstanceId=c.CreditorInstanceID " & _
                                " left outer join  tblaccount a on c.accountid=c.accountid and m.clientid=a.clientid  " & _
                               " where t.taskid = @TaskId And t.taskid = mt.taskid And mt.matterid = m.matterid "
            DatabaseHelper.AddParameter(cmd, "TaskId", iTaskId)
            Try
                cmd.Connection.Open()
                rd = cmd.ExecuteReader()

                While rd.Read()
                    MatterId = DatabaseHelper.Peel_int(rd, "matterid")
                    AccountId = DatabaseHelper.Peel_int(rd, "accountid")
                    ClientID = DatabaseHelper.Peel_int(rd, "clientid")
                    TaskTypeId = DatabaseHelper.Peel_int(rd, "TaskTypeId")
                    MatterTypeId = DatabaseHelper.Peel_int(rd, "MatterTypeId")
                    CreditorInstanceId = DatabaseHelper.Peel_int(rd, "CreditorInstanceId")
                End While
                If MatterId > 0 Then
                    Dim MatterGroupId As Integer = Integer.Parse(DataHelper.FieldLookup("tblMattertype", "MatterGroupID", "MatterTypeId=" & MatterTypeId))
                    If MatterGroupId = 1 Then
                        dvActions.Style.Add("display", "")
                    End If
                End If
            Finally
                DatabaseHelper.EnsureReaderClosed(rd)
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try


            'ClientID = DataHelper.Nz_int(qs("id"), 0)
            'AccountId = DataHelper.Nz_int(qs("aid"), 0)
            'MatterId = DataHelper.Nz_int(qs("mid"), 0)

            If Not IsPostBack Then
                hdnTempAccountID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()
                hdnTempMatterID.Value = MatterId

                ''LoadPrimaryPerson()
                ' LoadMatterDetail()
                Dim strInstructions As String = DataHelper.Nz_string(DataHelper.FieldLookup("tblTaskType", _
                   "TaskInstruction", "TaskTypeID = " & TaskTypeId))

                lblInstruction.Text = strInstructions.Replace(vbCrLf, "<br>")

                LoadMatterPropagations()
                ResetPropagationsCounter()

                '' Turned off now as this should be documents for matters'
                LoadDocuments()

                LoadTasks()
                LoadNotes()
                LoadPhoneCalls()
                LoadAllEmails()

       
                LoadTabStrips()
            End If
        End If

    End Sub

  
    Protected Sub LoadTasks()
        SortField = Setting("SortField", "Th7")
        SortOrder = Setting("SortOrder", "DESC")

        Dim iTaskId As Int32 = DataHelper.Nz_int(qs("id"), 0)
        Dim Tasks As New List(Of GridTask)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTaskRoadMap")
            Using cmd.Connection

                'DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                DatabaseHelper.AddParameter(cmd, "TaskId", iTaskId)
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


    Private Sub LoadAllEmails()

        SortField = Setting("SortFieldEmails", "tdEmailDate")
        SortOrder = Setting("SortOrderEmails", "DESC")

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetMatterEMails")

        DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
        DatabaseHelper.AddParameter(cmd, "OrderBy", GetFullyQualifiedNameForEmails(SortField) + " " + SortOrder)

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
                        Dim DueHr As Integer
                        Dim DueMin As Integer

                        DueHr = dtDueDate.Hour()
                        DueMin = dtDueDate.Minute()
                        If txtPropagations.Value.Length > 0 Then
                            'ddlLocalCounsel.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "LocalCounsel"), DatabaseHelper.Peel_int(rd, "AttorneyId")))
                            txtPropagations.Value += "|" + Convert.ToString(DatabaseHelper.Peel_int(rd, "AssignedTo")) + "," + "0" + "," + Convert.ToString(FormatDateTime(dtDueDate, DateFormat.ShortDate)) + "," + "0" + "," + Convert.ToString(DatabaseHelper.Peel_int(rd, "TaskTypeID")) + "," + DatabaseHelper.Peel_string(rd, "Description") + "," + Convert.ToString(DatabaseHelper.Peel_int(rd, "TaskID")) + "," + Convert.ToString(DueHr) + "," + Convert.ToString(DueMin) + "," + "0"
                        Else
                            txtPropagations.Value = Convert.ToString(DatabaseHelper.Peel_int(rd, "AssignedTo")) + "," + "0" + "," + Convert.ToString(FormatDateTime(dtDueDate, DateFormat.ShortDate)) + "," + "0" + "," + Convert.ToString(DatabaseHelper.Peel_int(rd, "TaskTypeID")) + "," + DatabaseHelper.Peel_string(rd, "Description") + "," + Convert.ToString(DatabaseHelper.Peel_int(rd, "TaskID")) + "," + Convert.ToString(DueHr) + "," + Convert.ToString(DueMin) + "," + "0"
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

    'Private Sub LoadMatterDetail()
    '    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
    '        Using cmd.Connection

    '            cmd.CommandText = "stp_GetMatterInstance"
    '            cmd.CommandType = CommandType.StoredProcedure
    '            DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
    '            DatabaseHelper.AddParameter(cmd, "AccountId", AccountId)
    '            cmd.Connection.Open()
    '            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
    '                While rd.Read()

    '                    txtMatterDate.Text = rd("MatterDate")
    '                    txtMatterNumber.Value = rd("MatterNumber")
    '                    txtMatterMemo2.Text = rd("Note")
    '                    txtMatterStatusCode.Text = rd("MatterStatusCode")
    '                    txtLocalCounsel.Text = rd("LocalCounsel")
    '                    txtAccountNumber.Value = rd("AccountNumber")

    '                End While
    '            End Using
    '        End Using
    '    End Using
    'End Sub

    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function

    Private Sub Close()
        'Response.Redirect("~/clients/client/creditors/accounts/?id=" & ClientID)
        Response.Redirect("~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & AccountId & "&a=m")
    End Sub

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        'SharedFunctions.DocumentAttachment.DeleteAllForItem(hdnTempAccountID.Value, "account", UserID)
        SharedFunctions.DocumentAttachment.DeleteAllForItem(hdnTempAccountID.Value, "matter", UserID)
        Close()
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim strNotes As String() = {}
        Dim strPropagations As String() = {}
        Dim iTaskId As Int32 = DataHelper.Nz_int(qs("id"), 0)
        TaskHelper.Resolve(iTaskId, txtResolved.Value, hdnTaskResolutionID.Value, UserID, strNotes, strPropagations)
        Close()
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

        '        Dim cmdStr As String = "SELECT dr.DocTypeID, dr.subfolder, dr.DocRelationID, dt.DisplayName, isnull(ds.ReceivedDate, '01/01/1900') as ReceivedDate, " + _
        '"isnull(ds.Created, '01/01/1900') as Created, isnull(u.FirstName + ' ' + u.LastName + '</br>' + ug.Name, '') as CreatedBy FROM tblDocRelation as dr with(nolock) inner join tblDocumentType as dt  with(nolock) " + _
        '"on dt.TypeID = dr.DocTypeID left join tblDocScan as ds  with(nolock) on ds.DocID = dr.DocID left join tblUser as u  with(nolock) on u.UserID = ds.CreatedBy inner join tblusergroup as ug  with(nolock) on ug.usergroupid = u.usergroupid " + _
        '"WHERE dr.RelationID = " + relationID.ToString() + " and dr.RelationType = '" + relationType + "' and (DeletedFlag = 0 or DeletedBy = -1) " + _
        '"ORDER BY ds.Created desc"

        Dim cmdStr As String = " SELECT dr.DocTypeID, dr.subfolder, dr.DocRelationID,dt.DisplayName, isnull(dr.RelatedDate, '01/01/1900') as ReceivedDate," + _
            "isnull(dr.RelatedDate, '01/01/1900') as Created, isnull(u.FirstName + ' ' + u.LastName + '</br>' + ug.Name, '') as CreatedBy " + _
            "FROM tblDocRelation as dr with(nolock) inner join tblDocumentType as dt with(nolock) on dt.TypeID = dr.DocTypeID " + _
            "left join tblUser as u  with(nolock) on u.UserID = dr.RelatedBy " + _
            "inner join tblusergroup as ug  with(nolock) on ug.usergroupid = u.usergroupid " + _
            "WHERE dr.RelationID = " + relationID.ToString() + " and dr.RelationType = '" + relationType + "' and (DeletedFlag = 0 or DeletedBy = -1) " + _
            "ORDER BY dr.RelatedDate desc"


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
            doc.DocumentPath = LocalHelper.GetVirtualDocFullPath(tempName)
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
        Using cmd As New SqlCommand("SELECT ClientID, DocTypeID, DocID, DateString, isnull(SubFolder, '') as SubFolder FROM tblDocRelation with (nolock) WHERE DocRelationID = " + docRelID.ToString(), ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
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

        Using cmd As New SqlCommand("SELECT AccountNumber, StorageServer, StorageRoot FROM tblClient with(nolock) WHERE ClientID = " + clientID.ToString(), ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999")) '
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        acctNo = reader("AccountNumber").ToString()
                        server = reader("StorageServer").ToString()
                        storage = reader("StorageRoot").ToString()
                    End If
                End Using
                cmd.CommandText = "SELECT DocFolder FROM tblDocumentType with(nolock) WHERE TypeID = '" + docTypeID + "'"
                folder = cmd.ExecuteScalar().ToString()
            End Using
        End Using

        If docTypeID = "M030" Then
            'Return "\\" + server + "\" + storage + "\" + acctNo + "\" + folder + "\" & subFolder
            Return subFolder
        Else
            Return "\\" + server + "\" + storage + "\" + acctNo + "\" + folder + "\" + IIf(subFolder.Length > 1, subFolder, "") + acctNo + "_" + docTypeID + "_" + docID + "_" + dateStr + ".pdf"
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
        tabIndex = 0
        LoadTabStrips()
        tsMatterView.TabPages(tabIndex).Selected = True
        LoadTasks()
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
            SortOrder = "ASC"
        End If
        SortField = txtSortFieldNotes.Value

        Setting("SortFieldNotes") = SortField
        Setting("SortOrderNotes") = SortOrder
        tabIndex = 1
        LoadTabStrips()
        tsMatterView.TabPages(tabIndex).Selected = True
        LoadNotes()

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
            SortOrder = "ASC"
        End If
        SortField = txtSortFieldPhones.Value

        Setting("SortFieldPhones") = SortField
        Setting("SortOrderPhones") = SortOrder
        tabIndex = 2
        LoadTabStrips()
        tsMatterView.TabPages(tabIndex).Selected = True
        LoadPhoneCalls()
    End Sub

    Protected Sub lnkResortEmails_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResortEmails.Click
        If txtSortFieldEmails.Value = Setting("SortFieldEmails") Then
            'toggle sort order
            If Setting("SortOrderEmails") = "ASC" Then 'SortFieldEmails
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
        tabIndex = 3
        LoadTabStrips()
        tsMatterView.TabPages(tabIndex).Selected = True
        LoadAllEmails()
    End Sub
End Class
