Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports Slf.Dms.Records
Imports Drg.Util.DataHelpers

Imports System.Text
Imports System.Data
Imports System.Collections.Generic

Partial Class tasks_task_resolve
    Inherits System.Web.UI.Page

    Private Enum TaskType As Integer
        ResolveDataEntry = 12
        ResolveVerification = 13
    End Enum

#Region "Variables"

    Public TaskID As Integer
    Private qs As QueryStringCollection
    Private baseTable As String = "tblTask"

    Private UserID As Integer

#End Region

#Region "Properties"

    Property SaveForLater() As Boolean
        Get
            Return tdMenuSaveForLater.Visible
        End Get
        Set(ByVal value As Boolean)

            tdMenuSaveForLater.Visible = value
            tdMenuSaveForLaterSep.Visible = value
        End Set
    End Property
    ReadOnly Property MasterNavigator() As Navigator
        Get
            Return CType(Page.Master, Site).Navigator
        End Get
    End Property
    ReadOnly Property Control_tdTaskInfo() As HtmlTableCell
        Get
            Return tdTaskInfo
        End Get
    End Property
    ReadOnly Property Control_imgTaskInfoOpen() As HtmlImage
        Get
            Return imgTaskInfoOpen
        End Get
    End Property
    ReadOnly Property Control_imgTaskInfoClose() As HtmlImage
        Get
            Return imgTaskInfoClose
        End Get
    End Property
    ReadOnly Property Control_tdError() As HtmlTableCell
        Get
            Return tdError
        End Get
    End Property
    ReadOnly Property Control_dvError() As HtmlGenericControl
        Get
            Return dvError
        End Get
    End Property
    ReadOnly Property Control_txtResolved() As AssistedSolutions.WebControls.InputMask
        Get
            Return txtResolved
        End Get
    End Property
    ReadOnly Property Control_cboTaskResolutionID() As WebControls.DropDownList
        Get
            Return cboTaskResolutionID
        End Get
    End Property
    ReadOnly Property Control_txtNotes() As WebControls.HiddenField
        Get
            Return txtNotes
        End Get
    End Property
    ReadOnly Property Control_txtPropagations() As WebControls.HiddenField
        Get
            Return txtPropagations
        End Get
    End Property

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()


        If Not qs Is Nothing Then

            TaskID = DataHelper.Nz_int(qs("id"), 0)

            If TaskID = 0 Then
                Response.Redirect("~/tasks") 'head back to calendar
            Else

                If Not IsPostBack Then

                    LoadClients()
                    LoadTaskResolutions()
                    LoadTaskTypes(cboTaskType, 0)
                    LoadRecord()

                    txtResolved.Text = Now.ToString("MM/dd/yyyy hh:mm tt")

                    LoadVisitLogs()

                End If

                LoadWorkflow()

                ResetNotesCounter()
                ResetPropagationsCounter()

            End If

        End If

    End Sub
    Private Sub LoadVisitLogs()

        Dim Display As String = TaskHelper.GetShortDescription(TaskID, 20)

        If Not Display Is Nothing AndAlso Display.Length > 0 Then

            'redo user visit log
            UserHelper.StoreVisit(UserID, "Task", TaskID, Display)

        End If

    End Sub
    Private Sub LoadRecord()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTaskForTask")

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim Created As DateTime = DatabaseHelper.Peel_date(rd, "Created")
                Dim Due As DateTime = DatabaseHelper.Peel_date(rd, "Due")
                Dim Resolved As Nullable(Of DateTime) = DatabaseHelper.Peel_ndate(rd, "Resolved")
                Dim intTaskResolutionId As Integer = DatabaseHelper.Peel_int(rd, "TaskResolutionId")

                lblCreated.Text = Created.ToString("MMM dd, yy hh:mm tt")
                lblDue.Text = Due.ToString("MMM dd, yy hh:mm tt")

                If Resolved.HasValue Then 'resolved
                    If intTaskResolutionId = 1 Then
                        lblResolvedDate.Text = Resolved.Value.ToString("MMM dd, yy hh:mm tt")

                        Dim NumDaysSinceCreated As Integer = Resolved.Value.Subtract(Created).Days

                        If NumDaysSinceCreated = 0 Then

                            'lblAging.Text = "Resolved same day"
                            lblStatusCurrent.Text = "<font style=""color:rgb(0,129,0);"">RESOLVED</font>&nbsp;<font style=""color:#a1a1a1;"">(on time)</font>"

                        Else

                            If Resolved.Value.Date = Due.Date Then 'resolved on due day

                                'lblAging.Text = "Resolved in " & GetCase(NumDaysSinceCreated, "day") _
                                '    & ", on the day it was due"
                                lblStatusCurrent.Text = "<font style=""color:rgb(0,129,0);"">RESOLVED</font>&nbsp;<font style=""color:#a1a1a1;"">(on time)</font>"

                            Else

                                If Resolved.Value < Due Then 'resolved before due

                                    Dim NumDaysBeforeDue As Integer = Due.Subtract(Resolved.Value).Days

                                    'lblAging.Text = "Resolved in " & GetCase(NumDaysSinceCreated, "day") _
                                    '    & " , " & GetCase(NumDaysBeforeDue, "day") & " before it was due"
                                    lblStatusCurrent.Text = "<font style=""color:rgb(0,129,0);"">RESOLVED</font>&nbsp;<font style=""color:#a1a1a1;"">(on time)</font>"

                                Else 'resolved after due

                                    Dim NumDaysAfterDue As Integer = Resolved.Value.Subtract(Due).Days

                                    'lblAging.Text = "Resolved in " & GetCase(NumDaysSinceCreated, "day") _
                                    '    & ", " & GetCase(NumDaysAfterDue, "day") & " after it was due"
                                    lblStatusCurrent.Text = "<font style=""color:rgb(0,129,0);"">RESOLVED</font>&nbsp;<font style=""color:#a1a1a1;"">(" & GetCase(NumDaysAfterDue, "day") & " late)</font>"

                                End If

                            End If

                        End If

                        ListHelper.SetSelected(cboTaskResolutionID, DatabaseHelper.Peel_int(rd, "TaskResolutionID"))

                        lblTaskResolutionName.Text = cboTaskResolutionID.SelectedItem.Text

                        pnlMenuDefault.Visible = False
                        pnlMenuResolved.Visible = True

                        trResolved.Visible = True
                        trResolution.Visible = True
                        trResolutionBody.Visible = False
                        trResolutionHeader.Visible = False

                        lblResolvedDate.Visible = True
                        cboTaskResolutionID.Visible = False
                        lblTaskResolutionName.Visible = True

                        'load notes and propagations
                        LoadNotes()
                        LoadPropagations()

                        chkResolved.Checked = True

                    Else 'If intTaskResolutionId = 5 Then

                        pnlMenuDefault.Visible = True
                        pnlMenuResolved.Visible = False

                        trResolved.Visible = False
                        trResolution.Visible = False
                        trResolutionBody.Visible = True
                        trResolutionHeader.Visible = True

                        lblResolvedDate.Visible = False
                        cboTaskResolutionID.Visible = True
                        lblTaskResolutionName.Visible = False

                        'load preliminary propagations
                        LoadPropagationsPrelim()


                        'lblStatusCurrent.Text = "<font style=""color:rgb(0,0,255);"">IN PROGRESS</font>&nbsp;<font style=""color:#a1a1a1;"">(on time)</font>"

                        Dim NumDaysSinceCreated As Integer = Now.Subtract(Created).Days

                        If Due < Now Then 'unresolved, past due

                            If Now.Date = Due.Date Then 'unresolved, due today

                                'lblAging.Text = "Unresolved, due today"
                                lblStatusCurrent.Text = "<font style=""color:rgb(0,0,255);"">IN PROGRESS</font>&nbsp;<font style=""color:#a1a1a1;"">(due today)</font>"

                            Else

                                If Now.Subtract(New TimeSpan(1, 0, 0, 0)).Date = Due.Date Then 'resolved, due yesterday

                                    'lblAging.Text = "Unresolved, due yesterday"
                                    lblStatusCurrent.Text = "<font style=""color:rgb(0,0,255);"">IN PROGRESS</font>&nbsp;<font style=""color:#a1a1a1;"">(due yesterday)</font>"

                                Else

                                    Dim NumDaysSinceDue As Integer = Now.Subtract(Due).Days

                                    'lblAging.Text = "Unresolved for " & GetCase(NumDaysSinceCreated, "day") _
                                    '        & ", " & GetCase(NumDaysSinceDue, "day") & " since it was due"
                                    lblStatusCurrent.Text = "<font style=""color:rgb(0,0,255);"">IN PROGRESS</font>&nbsp;<font style=""color:#a1a1a1;"">(" & GetCase(NumDaysSinceDue, "day") & ")</font>"

                                End If

                            End If

                        End If

                    End If

                Else 'unresolved

                    pnlMenuDefault.Visible = True
                    pnlMenuResolved.Visible = False

                    trResolved.Visible = False
                    trResolution.Visible = False
                    trResolutionBody.Visible = True
                    trResolutionHeader.Visible = True

                    lblResolvedDate.Visible = False
                    cboTaskResolutionID.Visible = True
                    lblTaskResolutionName.Visible = False

                    'load preliminary propagations
                    LoadPropagationsPrelim()

                    Dim NumDaysSinceCreated As Integer = Now.Subtract(Created).Days

                    If Due < Now Then 'unresolved, past due

                        If Now.Date = Due.Date Then 'unresolved, due today

                            'lblAging.Text = "Unresolved, due today"
                            lblStatusCurrent.Text = "<font style=""color:red;"">PAST DUE</font>&nbsp;<font style=""color:#a1a1a1;"">(due today)</font>"

                        Else

                            If Now.Subtract(New TimeSpan(1, 0, 0, 0)).Date = Due.Date Then 'resolved, due yesterday

                                'lblAging.Text = "Unresolved, due yesterday"
                                lblStatusCurrent.Text = "<font style=""color:red;"">PAST DUE</font>&nbsp;<font style=""color:#a1a1a1;"">(due yesterday)</font>"

                            Else

                                Dim NumDaysSinceDue As Integer = Now.Subtract(Due).Days

                                'lblAging.Text = "Unresolved for " & GetCase(NumDaysSinceCreated, "day") _
                                '        & ", " & GetCase(NumDaysSinceDue, "day") & " since it was due"
                                lblStatusCurrent.Text = "<font style=""color:red;"">PAST DUE</font>&nbsp;<font style=""color:#a1a1a1;"">(" & GetCase(NumDaysSinceDue, "day") & ")</font>"

                            End If

                        End If

                    Else 'unresolved, not due

                        lblStatusCurrent.Text = "<font style=""color:rgb(0,0,159);"">OPEN</font>"

                        If Now.Date = Due.Date Then 'unresolved, due today

                            'lblAging.Text = "Unresolved, due today"

                        Else

                            Dim NumDaysBeforeDue As Integer = Due.Subtract(Now).Days

                            'lblAging.Text = "Unresolved for " & GetCase(NumDaysSinceCreated, "day") _
                            '    & ", " & GetCase(NumDaysBeforeDue, "day") & " before it is due"

                        End If

                    End If

                End If

                lblType.Text = DatabaseHelper.Peel_string(rd, "TaskTypeName")
                lblDescription.Text = DatabaseHelper.Peel_string(rd, "Description").Replace(vbCrLf, "<br>")


                If lblType.Text.Length = 0 Then
                    lblType.Text = "Resolution Workflow"
                End If

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub ResetNotesCounter()

        Dim Count As Integer = 0

        If txtNotes.Value.Length > 0 Then

            Count = Regex.Split(txtNotes.Value, "\|--\$--\|").Length

            lblNotes.Text = " (" & Count & ")"

        Else
            lblNotes.Text = String.Empty
        End If

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
    Private Sub LoadPropagationsPrelim()

        'get associated client
        Dim ClientIDs As Integer() = TaskHelper.GetClients(TaskID)
        Dim ClientID As Integer
        If ClientIDs.Length > 0 Then
            ClientID = TaskHelper.GetClients(TaskID)(0)

            Dim TaskTypeID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblTask", "TaskTypeID", "TaskID = " & TaskID))

            Select Case TaskTypeID
                Case TaskType.ResolveDataEntry
                    Response.Redirect("../../clients/client/dataentry.aspx?id=" & ClientID)
                Case TaskType.ResolveVerification
                    Response.Redirect("../../clients/client/underwriting.aspx?id=" & ClientID)
            End Select

            Dim rd As IDataReader = Nothing
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblTaskPropagation WHERE Type = 'Task' AND TaskTypeID = @TaskTypeID ORDER BY [Order]"

            DatabaseHelper.AddParameter(cmd, "TaskTypeID", TaskTypeID)

            Try

                cmd.Connection.Open()
                rd = cmd.ExecuteReader()

                Dim Propagations As New StringBuilder()

                While rd.Read()

                    Dim TaskPropagationID As Integer = DatabaseHelper.Peel_int(rd, "TaskPropagationID")
                    Dim Type As String = DatabaseHelper.Peel_string(rd, "Type")
                    Dim TypeID As Integer = DatabaseHelper.Peel_int(rd, "TypeID")
                    Dim Due As Double = DatabaseHelper.Peel_double(rd, "Due").ToString("###0.0000")
                    Dim AssignedToResolver As Boolean = DatabaseHelper.Peel_bool(rd, "AssignedToResolver")
                    Dim Description As String = ""

                    'check task propagation exception table for an override due date
                    Dim OverrideDueDate As Nullable(Of DateTime) = DataHelper.Nz_ndate(DataHelper.FieldLookup( _
                        "tblTaskPropagationException", "DueDate", "TaskPropagationID = " & TaskPropagationID _
                        & " AND ClientID = " & ClientID))

                    If Propagations.Length > 0 Then
                        Propagations.Append("|")
                    End If

                    If OverrideDueDate.HasValue Then

                        Due = OverrideDueDate.Value.Subtract(Now).TotalDays.ToString("###0.0000")

                        Propagations.Append(IIf(AssignedToResolver, 1, 0) & ",0," _
                            & OverrideDueDate.Value.ToString("MM/dd/yyyy hh:mm tt") _
                            & "," & Due & "," & TypeID & "," & Description)

                    Else

                        Propagations.Append(IIf(AssignedToResolver, 1, 0) & ",1,," & Due & "," & TypeID _
                            & "," & Description)

                    End If

                End While

                txtPropagations.Value = Propagations.ToString()

            Finally
                DatabaseHelper.EnsureReaderClosed(rd)
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try
        End If
    End Sub
    Private Sub LoadPropagations()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblTaskPropagationSaved WHERE TaskID = @TaskID"

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            Dim Propagations As New StringBuilder()

            While rd.Read()

                Dim AssignedTo As Integer = DatabaseHelper.Peel_int(rd, "AssignedTo")
                Dim DueType As Integer = DatabaseHelper.Peel_int(rd, "DueType")
                Dim Due As Double = DatabaseHelper.Peel_double(rd, "Due")
                Dim [Date] As Nullable(Of DateTime) = DatabaseHelper.Peel_ndate(rd, "Date")
                Dim TaskTypeID As Integer = DatabaseHelper.Peel_int(rd, "TaskTypeID")
                Dim Description As String = DatabaseHelper.Peel_string(rd, "Description")

                If Propagations.Length > 0 Then
                    Propagations.Append("|")
                End If

                Dim DateString As String = String.Empty

                If [Date].HasValue Then
                    DateString = [Date].Value.ToString("MM/dd/yyyy")
                End If

                Propagations.Append(AssignedTo & "," & DueType & "," & DateString & "," & Due & "," _
                    & TaskTypeID & "," & Description)

            End While

            txtPropagations.Value = Propagations.ToString()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadNotes()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNotesForTask")

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            Dim Notes As New StringBuilder()

            While rd.Read()

                If Notes.Length > 0 Then
                    Notes.Append("|--$--|")
                End If

                Notes.Append(DatabaseHelper.Peel_string(rd, "Value"))

            End While

            txtNotes.Value = Notes.ToString()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadWorkflow()

        Dim MatterTypeCount As Integer = 0
        Dim TaskTypeID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblTask", _
            "TaskTypeID", "TaskID = " & TaskID))
        Dim VirtualPath As String = "~/tasks/workflows/" & TaskTypeID & ".ascx"
        '03.10.2010 
        Dim MatterId As String

        MatterId = DataHelper.Nz_int(DataHelper.FieldLookup("tblMatterTask", _
            "MatterId", "TaskID =" & TaskID))


        If IO.File.Exists(Server.MapPath(VirtualPath)) Then 'workflow exists

            phWorkflow.Controls.Add(LoadControl(VirtualPath))

            phWorkflow.Visible = True
            pnlNoWorkflow.Visible = False
            If TaskTypeID = 30 Then
                'spnMatterNotes.Visible = True
                'spnPhoneCalls.Visible = True
                'spnMatterRoadMap.Visible = True
                '03.10.2010  MatterInstance is visible if the task is associated to a Matter
                If MatterId > 0 Then
                    spnMatterInstance.Visible = True
                    spnMatterNotes.Visible = True
                    spnPhoneCalls.Visible = True
                    spnMatterRoadMap.Visible = True
                End If

            End If

        Else 'no such workflow

            Dim rd As IDataReader = Nothing
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT count(*) FROM tblMatterTypeTaskXRef WHERE TaskTypeID = @TaskTypeID"

            DatabaseHelper.AddParameter(cmd, "TaskTypeID", TaskTypeID)

            Try

                cmd.Connection.Open()
                MatterTypeCount = Convert.ToInt32(cmd.ExecuteScalar())

            Finally
                DatabaseHelper.EnsureReaderClosed(rd)
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try

            If MatterTypeCount > 0 Or TaskTypeID = 0 Then
                'phWorkflow.Controls.Add(LoadControl("~/tasks/workflows/generic.ascx"))
                phWorkflow.Controls.Add(LoadControl("~/tasks/workflows/30.ascx"))
                phWorkflow.Visible = True
                pnlNoWorkflow.Visible = False
                'spnMatterNotes.Visible = True
                'spnPhoneCalls.Visible = True
                'spnMatterRoadMap.Visible = True
                '03.10.2010 
                If MatterId > 0 Then
                    spnMatterInstance.Visible = True
                    spnMatterNotes.Visible = True
                    spnPhoneCalls.Visible = True
                    '03.11.2010
                    spnMatterRoadMap.Visible = True
                End If

            Else
                phWorkflow.Visible = False
                pnlNoWorkflow.Visible = True

                'put a Record_Save() function on the page
                Dim SaveFunction As New StringBuilder()

                SaveFunction.Append("<script type=""text/javascript"">function Record_Save(){" _
                    & ClientScript.GetPostBackEventReference(lnkSave, Nothing) & ";}</script>")

                ClientScript.RegisterClientScriptBlock(GetType(String), "Record_Save()", SaveFunction.ToString())
            End If
            End If

    End Sub
    Private Sub LoadTaskResolutions()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblTaskResolution"

        cboTaskResolutionID.Items.Clear()

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboTaskResolutionID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "TaskResolutionID")))
            End While
            cboTaskResolutionID.SelectedIndex = cboTaskResolutionID.Items.IndexOf(cboTaskResolutionID.Items.FindByText("In Progress"))
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadTaskTypes(ByRef cboTaskType As DropDownList, ByVal SelectedTaskTypeID As Integer)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblTaskType"

        cboTaskType.Items.Clear()

        cboTaskType.Items.Add(New ListItem(" -- Ad Hoc -- ", 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboTaskType.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "TaskTypeID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        ListHelper.SetSelected(cboTaskType, SelectedTaskTypeID)

    End Sub
    Private Sub LoadClients()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetClientsForTask")

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            rpClients.DataSource = rd
            rpClients.DataBind()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        trClients.Visible = rpClients.Items.Count > 0
        trClientsList.Visible = rpClients.Items.Count > 0

    End Sub
    Private Function GetCase(ByVal Number As Integer, ByVal SValue As String) As String
        Return GetCase(Number, SValue, SValue & "s")
    End Function
    Private Function GetCase(ByVal Number As Integer, ByVal SValue As String, ByVal PValue As String) As String

        If Number > 1 Then
            Return Number & " " & PValue
        Else
            Return Number & " " & SValue
        End If

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
    Private Sub Close()
        Response.Redirect("~/clients/client/applicants/?id=" & ClientID)
    End Sub
    Protected Sub rpClients_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpClients.ItemDataBound

        Dim lnkClientID As HtmlAnchor = CType(e.Item.FindControl("lnkClientID"), HtmlAnchor)

        lnkClientID.HRef = "~/clients/client/?id=" & e.Item.DataItem("ClientID")

    End Sub
    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click

        TaskHelper.ClearResolve(TaskID, UserID)

        ReturnToReferrer()

    End Sub

    Public Sub ReturnToReferrer()

        Dim Navigator As Navigator = CType(Page.Master, Site).Navigator

        Dim i As Integer = Navigator.Pages.Count - 1

        While i >= 0 AndAlso Not Navigator.Pages(i).Url.IndexOf("resolve.aspx") = -1 'not found

            'decrement i
            i -= 1

        End While

        If i >= 0 Then
            Response.Redirect(Navigator.Pages(i).Url)
        Else
            Response.Redirect("~/tasks")
        End If

    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        'resolve task, notes and propagations
        'TaskHelper.Resolve(TaskID, txtResolved.Text, cboTaskResolutionID.SelectedValue, UserID, _
        '    Regex.Split(txtNotes.Value, "\|--\$--\|"), txtPropagations.Value.Split("|"))

        TaskHelper.Resolve(TaskID, txtResolved.Text, cboTaskResolutionID.SelectedValue, UserID, _
        Regex.Split("", "\|--\$--\|"), txtPropagations.Value.Split("|"))

        ReturnToReferrer()

    End Sub

End Class