Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports SharedFunctions
Imports System.Data

Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic
Partial Class tasks_workflows_generic
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
                Return "createdbyname"
            Case "Th3"
                Return "value"
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
    Public Sub SetSortImageNotes()
        HeadersNotes(SortField).Controls.Add(GetSortImage(SortOrder))
    End Sub
    Private Function GetSortImage(ByVal SortOrder As String) As HtmlImage
        Dim img As HtmlImage = New HtmlImage()
        img.Src = ResolveUrl("~/images/sort-" & SortOrder & ".png")
        img.Align = "absmiddle"
        img.Border = 0
        img.Style("margin-left") = "5px"
        Return img
    End Function

    Private Sub LoadHeadersNotes()
        HeadersNotes = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(HeadersNotes, Th2)
        AddHeader(HeadersNotes, Th3)
        AddHeader(HeadersNotes, Th4)
    End Sub
   
    Private Sub AddHeader(ByVal c As System.Collections.Generic.Dictionary(Of String, HtmlTableCell), ByVal td As HtmlTableCell)
        c.Add(td.ID, td)
    End Sub

    Private Sub LoadTabStrips()

        tsMatterView.TabPages.Clear()

        If hdnNotesCount.Value <> "" And hdnNotesCount.Value <> "0" Then
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Task&nbsp;Notes&nbsp;&nbsp;<font color='blue'>(" & hdnNotesCount.Value.ToString() & ")</font>", dvPanel1.ClientID))
        Else
            tsMatterView.TabPages.Add(New Slf.Dms.Controls.TabPage("Task&nbsp;Notes", dvPanel1.ClientID))
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
            'UserTypeID = 7 Is Litigation
            'cmd.CommandText = "select mt.matterid, m.clientid, a.accountid, t.tasktypeid, m.creditorinstanceid, m.MatterTypeId from tbltask t , tblmattertask mt, tblmatter m," & _
            '                  " tblaccount a, tblCreditorInstance c " & _
            '                  " where t.taskid = @TaskId And t.taskid = mt.taskid And mt.matterid = m.matterid " & _
            '                  " and m.clientid=a.clientid and m.CreditorInstanceId=c.CreditorInstanceID" & _
            '                  " and a.accountid=c.accountid"
            cmd.CommandText = "select mt.matterid, m.clientid, t.tasktypeid, IsNull(m.creditorinstanceid,0) as creditorinstanceid, m.MatterTypeId,  " & _
                              " case when IsNull(m.creditorinstanceid,0)>0 Then   " & _
                              " (select accountid from tblcreditorinstance where creditorinstanceid=m.creditorinstanceid) Else 0 End as AccountId" & _
                              " from tbltask t inner join tblmattertask mt ON t.taskid = mt.taskid " & _
                              " inner JOIN tblmatter m ON mt.matterid = m.matterid " & _
                              " left outer join tblClient c ON m.clientid=c.clientid " & _
                              " where t.taskid = @TaskId "
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
            Finally
                DatabaseHelper.EnsureReaderClosed(rd)
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try

            Dim strInstructions As String = DataHelper.Nz_string(DataHelper.FieldLookup("tblTaskType", _
    "TaskInstruction", "TaskTypeID = " & TaskTypeId))

            lblInstruction.Text = strInstructions.Replace(vbCrLf, "<br>")

            If Not IsPostBack Then
                hdnTempAccountID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()
                hdnTempMatterID.Value = MatterId

                LoadTaskNotes()

            End If
        End If

    End Sub

    Private Sub LoadTaskNotes()

        SortField = Setting("SortFieldNotes", "Th2")
        SortOrder = Setting("SortOrderNotes", "DESC")

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNotesForTask")
            Using cmd.Connection
                Dim iTaskId As Int32 = DataHelper.Nz_int(qs("id"), 0)
                DatabaseHelper.AddParameter(cmd, "TaskID", iTaskID)

                cmd.Connection.Open()
                Dim sqlDa As New SqlDataAdapter(cmd)
                Dim ds As New DataSet
                sqlDa.Fill(ds)
                Dim iIndex As Int32 = 0
                Dim dv As DataView = ds.Tables(0).DefaultView
                dv.Sort = GetFullyQualifiedNameForNotes(SortField) & "  " & SortOrder

                For iIndex = 0 To dv.Count - 1
                    Dim n As New GridNote
                    n.NoteID = DataHelper.Nz_int(dv(iIndex)("NoteID"), 0)
                    n.Author = DataHelper.Nz_string(dv(iIndex)("createdbyname"))
                    n.UserType = ""
                    n.NoteDate = DataHelper.Nz_date(dv(iIndex)("Created"))
                    n.Value = DataHelper.Nz_string(dv(iIndex)("value"))
                    n.Color = ""
                    n.TextColor = ""
                    n.BodyColor = ""

                    'n.Relations = New List(Of NoteRelation)
                    Notes.Add(n.NoteID, n)
                Next iIndex
                'Using rd As IDataReader = cmd.ExecuteReader()
                '    While rd.Read
                '        Dim n As New GridNote
                '        n.NoteID = DatabaseHelper.Peel_int(rd, "NoteID")
                '        n.Author = DatabaseHelper.Peel_string(rd, "createdbyname")
                '        n.UserType = ""
                '        n.NoteDate = DatabaseHelper.Peel_date(rd, "Created")
                '        n.Value = DatabaseHelper.Peel_string(rd, "value")
                '        n.Color = ""
                '        n.TextColor = ""
                '        n.BodyColor = ""

                '        'n.Relations = New List(Of NoteRelation)
                '        Notes.Add(n.NoteID, n)
                '    End While
                '    'rd.NextResult()
                '    'While rd.Read
                '    '    Dim NoteID As String = DatabaseHelper.Peel_int(rd, "NoteID")
                '    '    Dim n As GridNote = Nothing
                '    '    If Notes.TryGetValue(NoteID, n) Then
                '    '        Dim r As New NoteRelation
                '    '        r.NoteID = NoteID
                '    '        r.EntityName = DatabaseHelper.Peel_string(rd, "relationname")
                '    '        r.RelationTypeName = DatabaseHelper.Peel_string(rd, "relationtypename")
                '    '        r.RelationID = DatabaseHelper.Peel_int(rd, "relationid")
                '    '        r.RelationTypeID = DatabaseHelper.Peel_int(rd, "relationtypeid")
                '    '        r.IconURL = DatabaseHelper.Peel_string(rd, "iconurl")
                '    '        r.NavigateURL = ResolveUrl(DatabaseHelper.Peel_string(rd, "navigateurl").Replace("$clientid$", DataClientID).Replace("$x$", r.RelationID))
                '    '        n.Relations.Add(r)
                '    '    End If
                '    'End While
                'End Using
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
        Response.Redirect("~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & AccountId & "&a=m")
    End Sub


    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim strNotes As String() = {}
        Dim strPropagations As String() = {}
        Dim iTaskId As Int32 = DataHelper.Nz_int(qs("id"), 0)
        TaskHelper.Resolve(iTaskId, txtResolved.Value, hdnTaskResolutionID.Value, UserID, strNotes, strPropagations)
        Close()
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
        LoadTaskNotes()
    End Sub

End Class
