Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports AssistedSolutions.WebControls

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports System.Data
Imports System.Collections.Generic

Partial Class tasks_default
    Inherits PermissionPage

    Public Structure GridTask
        Dim TaskID As Integer
        Dim TaskType As String
        Dim ClientID As Integer
        Dim Client As String
        Dim TaskDescription As String
        Dim CreatedBy As String
        Dim AssignedTo As String
        Dim AssignedToGroupName As String
        Dim intAssignedToId As Integer
        Dim intAssignedToGroupId As Integer
        Dim StartDate As DateTime
        Dim DueDate As DateTime
        Dim ResolvedDate As Nullable(Of DateTime)
        Dim TaskResolutionId As Integer
        'Dim Duration As String
        Dim Value As String
        Dim Color As String
        Dim TextColor As String
        Dim BodyColor As String

        ReadOnly Property AssignedToId() As Integer
            Get
                Return intAssignedToId
            End Get
        End Property

        ReadOnly Property AssignedToGroupId() As Integer
            Get
                Return intAssignedToGroupId
            End Get
        End Property

        ReadOnly Property Status() As String
            Get

                If ResolvedDate.HasValue Then
                    If TaskResolutionId = 1 Then
                        'Return "RESOLVED"
                        Return "<font style=""color:rgb(0,129,0);"">RESOLVED</font>"
                    Else 'If TaskResolutionID = 5 Then
                        'Return "IN PROGRESS"
                        Return "<font style=""color:rgb(0,0,255);"">IN PROGRESS</font>"
                    End If
                Else
                    If DueDate < Now Then
                        'Return "PAST DUE"
                        Return "<font style=""color:red;"">PAST DUE</font>"
                    Else
                        'Return "OPEN"
                        Return "<font style=""color:rgb(0,0,159);"">OPEN</font>"
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

#Region "Variables"
    Private SortField As String
    Private SortOrder As String
    Private Headers As Dictionary(Of String, HtmlTableCell)

    Dim TaskList As Int16 = 0
    Private EndDate As String
    Private tsk As String = String.Empty
    Private type As String = String.Empty
    Private StartDate As String
    Private StartMonth As Integer
    Private StartYear As Integer
    Private Mode As TaskCalendar.DisplayMode

    Protected WithEvents tcMain As New TaskCalendar

    Private qs As QueryStringCollection

    Private UserID As Integer

    Public UserTypeId As Integer
    Public UserGroupId As Integer
    Public CommRecId As String
    'Added to check user is a manager
    Public UserIsManager As Boolean
#End Region

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlMenu, c, "Tasks")
        AddControl(pnlBody, c, "Tasks")
        AddControl(tdSearch, c, "Client Search")
        AddControl(pnlAddNewTask, c, "Tasks-Add New Task")
        AddControl(pnlTasksAnalysis, c, "Tasks-Analysis")
    End Sub

    Private Sub LoadHeaders()
        Headers = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(Headers, td1)
        AddHeader(Headers, td2)
        AddHeader(Headers, td3)
        AddHeader(Headers, td4)
        AddHeader(Headers, td5)
        AddHeader(Headers, td6)
    End Sub
    Private Sub AddHeader(ByVal c As System.Collections.Generic.Dictionary(Of String, HtmlTableCell), ByVal td As HtmlTableCell)
        c.Add(td.ID, td)
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
    Private Function GetFullyQualifiedName(ByVal s As String) As String
        Select Case s
            Case "td1"
                Return "Due"
            Case "td2"
                Return "ClientID"
            Case "td3"
                Return "ShortDescription"
            Case "td4"
                Return "StatusFormatted"
            Case "td5"
                Return "Created"
            Case "td6"
                Return "Resolved"
        End Select
        Return "Due"
    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        CommRecId = CStr(DataHelper.Nz_int(DataHelper.FieldLookup("tblUser", "CommRecId", "UserId = " & UserID), 0))
        UserTypeId = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId = " & UserID))
        UserGroupId = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupId", "UserId = " & UserID))
        'Added to check user is a manager - Manager field in tblUser
        UserIsManager = Boolean.Parse(DataHelper.FieldLookup("tblUser", "Manager", "UserId = " & UserID))

        qs = LoadQueryString()

        drMain.Visible = True

        StartDate = DataHelper.Nz_string(qs("sd"))
        EndDate = DataHelper.Nz_string(qs("ed"))
        StartMonth = DataHelper.Nz_int(qs("sm"), 0)
        StartYear = DataHelper.Nz_int(qs("sy"), 0)
        tsk = DataHelper.Nz_string(qs("tsk"))
        type = DataHelper.Nz_string(qs("type"))
        Try
            Mode = DataHelper.Nz_int(qs("mode"), 0)
        Catch ex As Exception
            Mode = 0
        End Try

        If StartDate.Length = 0 Or EndDate.Length = 0 Then 'nothing handed in

            If Not Session("TaskMode") Is Nothing Then 'old mode value saved up

                tcMain.StartDate = Session("Task" & Session("TaskMode").ToString() & "StartDate")
                tcMain.EndDate = Session("Task" & Session("TaskMode").ToString() & "EndDate")
                drMain.StartingMonth = Session("Task" & Session("TaskMode").ToString() & "StartingMonth")
                drMain.StartingYear = Session("Task" & Session("TaskMode").ToString() & "StartingYear")
                tcMain.Mode = Session("TaskMode")

            Else

                Dim LastMonday As DateTime = Now.Date

                While Not LastMonday.DayOfWeek = DayOfWeek.Monday
                    LastMonday = LastMonday.Subtract(New TimeSpan(1, 0, 0, 0))
                End While

                tcMain.ForceRange(LastMonday, LastMonday.AddDays(20), TaskCalendar.DisplayMode.Month)

            End If

            ResetPage()

        Else

            If Not IsPostBack Then
                'LoadTypes()
                'LoadStatuses()
                'LoadPrograms()
                'LoadPersonnel()
                'LoadFilter()

                If UserIsManager Then
                    pnlTeamTask.Visible = True
                Else
                    pnlTeamTask.Visible = False
                End If

                LoadCalendarAndDateRanger()
                SetDisplayMode(Mode)
                If tsk = "1" Then
                    pnlCalendar.Visible = False
                    TaskList = 1
                    LoadUpcomingTasks()
                Else
                    BindCalendar()
                End If
            Else
                LoadCalendarAndDateRanger()
                SetDisplayMode(Mode)
                BindCalendar()
            End If
        End If

    End Sub
    Private Sub SetDisplayMode(ByVal Mode As TaskCalendar.DisplayMode)
        If DataHelper.Nz_string(qs("tsk")) = "1" Then
            lnkModeDay.CssClass = "TCModeButton"
            lnkModeWeek.CssClass = "TCModeButton"
            lnkModeMonth.CssClass = "TCModeButton"
            lnkTaskList.CssClass = "TCModeButtonSel"

            tdModeDay.Attributes.Remove("class")
            tdModeWeek.Attributes.Remove("class")
            tdModeMonth.Attributes.Remove("class")
            tdTaskList.Attributes("class") = "TCModebuttonHolderSel"
        Else
            tcMain.Mode = Mode
            Select Case tcMain.Mode

                Case TaskCalendar.DisplayMode.Day

                    lnkModeDay.CssClass = "TCModeButtonSel"
                    lnkModeWeek.CssClass = "TCModeButton"
                    lnkModeMonth.CssClass = "TCModeButton"
                    lnkTaskList.CssClass = "TCModeButton"

                    tdModeDay.Attributes("class") = "TCModebuttonHolderSel"
                    tdModeWeek.Attributes.Remove("class")
                    tdModeMonth.Attributes.Remove("class")
                    tdTaskList.Attributes.Remove("class")

                Case TaskCalendar.DisplayMode.Week

                    lnkModeDay.CssClass = "TCModeButton"
                    lnkModeWeek.CssClass = "TCModeButtonSel"
                    lnkModeMonth.CssClass = "TCModeButton"
                    lnkTaskList.CssClass = "TCModeButton"

                    tdModeDay.Attributes.Remove("class")
                    tdModeWeek.Attributes("class") = "TCModebuttonHolderSel"
                    tdModeMonth.Attributes.Remove("class")
                    tdTaskList.Attributes.Remove("class")

                Case TaskCalendar.DisplayMode.Month

                    lnkModeDay.CssClass = "TCModeButton"
                    lnkModeWeek.CssClass = "TCModeButton"
                    lnkModeMonth.CssClass = "TCModeButtonSel"
                    lnkTaskList.CssClass = "TCModeButton"

                    tdModeDay.Attributes.Remove("class")
                    tdModeWeek.Attributes.Remove("class")
                    tdModeMonth.Attributes("class") = "TCModebuttonHolderSel"
                    tdTaskList.Attributes.Remove("class")

            End Select
        End If
    End Sub
    Private Sub BindCalendar()
        pnlCalendar.Controls.Add(tcMain)
    End Sub
    Private Sub LoadCalendarAndDateRanger()

        'setup start/end and today on date ranger
        Dim SD As New DateTime(StartDate.Substring(0, 4), StartDate.Substring(4, 2), StartDate.Substring(6, 2))
        Dim ED As New DateTime(EndDate.Substring(0, 4), EndDate.Substring(4, 2), EndDate.Substring(6, 2))

        If Not StartMonth = 0 Then
            drMain.StartingMonth = StartMonth
        End If

        If Not StartYear = 0 Then
            drMain.StartingYear = StartYear
        End If

        drMain.StartingMonth = Now.Month
        drMain.SetSelectedStartDate(SD.Day, SD.Month, SD.Year)
        drMain.SetSelectedEndDate(ED.Day, ED.Month, ED.Year)

        Dim TodayStyle As String = "border:solid 1px rgb(187,85,3);width:13px;padding:0 0 0 0;background-color:white;color:black"
        Dim TodayHoverStyle As String = "border:solid 1px rgb(187,85,3);width:13px;padding:0 0 0 0;background-color:rgb(252,238,182);color:#888888;"
        Dim TodaySelectedStyle As String = "border:solid 1px rgb(187,85,3);width:13px;padding:0 0 0 0;background-color:rgb(251,230,148);"

        Dim sods As New StandOutDateSet(TodayStyle, TodayHoverStyle, TodaySelectedStyle)

        sods.Dates.Add(New StandOutDate(Now.Year, Now.Month, Now.Day))

        drMain.StandOutDateSets.Clear()
        drMain.StandOutDateSets.Add(sods)

        'setup start/end on calendar
        tcMain.StartDate = New DateTime(StartDate.Substring(0, 4), StartDate.Substring(4, 2), StartDate.Substring(6, 2))
        tcMain.EndDate = New DateTime(EndDate.Substring(0, 4), EndDate.Substring(4, 2), EndDate.Substring(6, 2))

        'setup known dates on date ranger and calendar
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTasksb")
            Using cmd.Connection
                'DatabaseHelper.AddParameter(cmd, "CurrentPersonnelID", Integer.Parse(Page.User.Identity.Name))

                Dim Start As DateTime = New DateTime(StartDate.Substring(0, 4), StartDate.Substring(4, 2), StartDate.Substring(6, 2))
                Dim [End] As DateTime = New DateTime(EndDate.Substring(0, 4), EndDate.Substring(4, 2), EndDate.Substring(6, 2))

                If type = "" Then
                    DatabaseHelper.AddParameter(cmd, "Where", "WHERE (AssignedTo = " & UserID & "  OR IsNull(AssignedToGroupId,0) = " & UserGroupId & ") AND " _
                    & DataHelper.StripTime("Due") & " >= '" & Start.ToString("MM/dd/yyyy") & "' AND " _
                    & DataHelper.StripTime("Due") & " <= '" & [End].ToString("MM/dd/yyyy") & "'")
                ElseIf type = "T" Then
                    DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblassignedto.UserGroupId = " & UserGroupId & " AND " _
                    & DataHelper.StripTime("Due") & " >= '" & Start.ToString("MM/dd/yyyy") & "' AND " _
                    & DataHelper.StripTime("Due") & " <= '" & [End].ToString("MM/dd/yyyy") & "'")
                ElseIf type = "M" Then
                    DatabaseHelper.AddParameter(cmd, "Where", "WHERE tbltask.createdby = " & UserID & " AND " _
                    & DataHelper.StripTime("Due") & " >= '" & Start.ToString("MM/dd/yyyy") & "' AND " _
                    & DataHelper.StripTime("Due") & " <= '" & [End].ToString("MM/dd/yyyy") & "'")
                End If

                'DatabaseHelper.AddParameter(cmd, "Type", Byte.Parse(cboType.SelectedValue))
                'DatabaseHelper.AddParameter(cmd, "Status", Byte.Parse(cboStatus.SelectedValue))
                'DatabaseHelper.AddParameter(cmd, "PersonnelID", DataHelper.Nz_int(cboPersonnelID.SelectedValue, 0))
                'DatabaseHelper.AddParameter(cmd, "ProgramID", DataHelper.Nz_int(cboProgramID.SelectedValue, 0))

                'known dates on date ranger will be bold
                Dim Style As String = "font-weight:bold;width:15px;background-color:white;color:black;"
                Dim HoverStyle As String = "font-weight:bold;width:15px;background-color:rgb(252,238,182);color:#888888;"
                Dim SelectedStyle As String = "font-weight:bold;width:15px;background-color:rgb(251,230,148);color:black;"

                sods = New StandOutDateSet(Style, HoverStyle, SelectedStyle)



                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        Dim Due As DateTime = DatabaseHelper.Peel_date(rd, "Due")


                        Dim t As New Task(DatabaseHelper.Peel_int(rd, "TaskID"), _
                            DatabaseHelper.Peel_int(rd, "ParentTaskID"), _
                            DatabaseHelper.Peel_int(rd, "ClientID"), _
                            DatabaseHelper.Peel_string(rd, "ClientName"), _
                            DatabaseHelper.Peel_int(rd, "TaskTypeID"), _
                            DatabaseHelper.Peel_string(rd, "TaskTypeName"), _
                            DatabaseHelper.Peel_int(rd, "TaskTypeCategoryID"), _
                            DatabaseHelper.Peel_string(rd, "TaskTypeCategoryName"), _
                            DatabaseHelper.Peel_string(rd, "Description").Replace("-Not Available", ""), _
                            DatabaseHelper.Peel_int(rd, "AssignedTo"), _
                            DatabaseHelper.Peel_string(rd, "AssignedToName"), _
                            DatabaseHelper.Peel_date(rd, "Due"), _
                            DatabaseHelper.Peel_ndate(rd, "Resolved"), _
                            DatabaseHelper.Peel_int(rd, "ResolvedBy"), _
                            DatabaseHelper.Peel_string(rd, "ResolvedByName"), _
                            DatabaseHelper.Peel_int(rd, "TaskResolutionID"), _
                            DatabaseHelper.Peel_string(rd, "TaskResolutionName"), _
                            DatabaseHelper.Peel_date(rd, "Created"), _
                            DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                            DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                            DatabaseHelper.Peel_date(rd, "LastModified"), _
                            DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                            DatabaseHelper.Peel_string(rd, "LastModifiedByName"))

                        tcMain.Tasks.Add(t)

                        sods.Dates.Add(New StandOutDate(Due.Year, Due.Month, Due.Day))

                    End While
                End Using
            End Using
        End Using
        drMain.StandOutDateSets.Add(sods)

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
    Private Sub drMain_SelectedRangeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drMain.SelectedRangeChanged

        Dim StartDate As DateTime = DateTime.Parse(drMain.GetSelectedStartDate("MM/dd/yyyy"))
        Dim EndDate As DateTime = DateTime.Parse(drMain.GetSelectedEndDate("MM/dd/yyyy"))

        tcMain.ForceRange(StartDate, EndDate, Mode)

        ResetPage()

    End Sub
    Private Sub lnkModeDay_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lnkModeDay.Click
        CheckAndUse(TaskCalendar.DisplayMode.Day)
        pnlCalendar.Visible = True
        phTasks.Visible = False
        TaskList = 0
    End Sub
    Private Sub lnkModeMonth_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lnkModeMonth.Click
        CheckAndUse(TaskCalendar.DisplayMode.Month)
        pnlCalendar.Visible = True
        phTasks.Visible = False
        TaskList = 0
    End Sub
    Private Sub lnkModeWeek_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lnkModeWeek.Click
        CheckAndUse(TaskCalendar.DisplayMode.Week)
        pnlCalendar.Visible = True
        phTasks.Visible = False
        TaskList = 0
    End Sub
    Private Sub lnkTaskList_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkTaskList.Click
        'pnlCalendar.Visible = False
        TaskList = 1
        ResetPage()
        ' LoadUpcomingTasks()
    End Sub

    Private Sub LoadUpcomingTasks()
        Dim Tasks As New List(Of GridTask)
        SortField = Setting("SortField", "td1")
        SortOrder = Setting("SortOrder", "DESC")

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTasks")


        'DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblTask.AssignedTo = " & UserID & " AND Resolved IS NULL")
        '        DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblTask.AssignedTo = " & UserID & " ")
        DatabaseHelper.AddParameter(cmd, "Where", "WHERE (tblTask.AssignedTo = " & UserID & "  OR IsNull(tblTask.AssignedToGroupId,0) = " & UserGroupId & ") ")

        ' DatabaseHelper.AddParameter(cmd, "OrderBy", "ORDER BY Due")
        DatabaseHelper.AddParameter(cmd, "OrderBy", " ORDER BY " & GetFullyQualifiedName(SortField) + " " + SortOrder)


        'Dim Tasks As New List(Of Task)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                'Tasks.Add(New Task(DatabaseHelper.Peel_int(rd, "TaskID"), _
                '    DatabaseHelper.Peel_int(rd, "ParentTaskID"), _
                '    DatabaseHelper.Peel_int(rd, "ClientID"), _
                '    DatabaseHelper.Peel_string(rd, "ClientName"), _
                '    DatabaseHelper.Peel_int(rd, "TaskTypeID"), _
                '    DatabaseHelper.Peel_string(rd, "TaskTypeName"), _
                '    DatabaseHelper.Peel_int(rd, "TaskTypeCategoryID"), _
                '    DatabaseHelper.Peel_string(rd, "TaskTypeCategoryName"), _
                '    DatabaseHelper.Peel_string(rd, "Description"), _
                '    DatabaseHelper.Peel_int(rd, "AssignedTo"), _
                '    DatabaseHelper.Peel_string(rd, "AssignedToName"), _
                '    DatabaseHelper.Peel_date(rd, "Due"), _
                '    DatabaseHelper.Peel_ndate(rd, "Resolved"), _
                '    DatabaseHelper.Peel_int(rd, "ResolvedBy"), _
                '    DatabaseHelper.Peel_string(rd, "ResolvedByName"), _
                '    DatabaseHelper.Peel_int(rd, "TaskResolutionID"), _
                '    DatabaseHelper.Peel_string(rd, "TaskResolutionName"), _
                '    DatabaseHelper.Peel_date(rd, "Created"), _
                '    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                '    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                '    DatabaseHelper.Peel_date(rd, "LastModified"), _
                '    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                '    DatabaseHelper.Peel_string(rd, "LastModifiedByName")))

                Dim tsk As New GridTask

                tsk.TaskID = DatabaseHelper.Peel_int(rd, "TaskID")
                tsk.AssignedTo = DatabaseHelper.Peel_string(rd, "AssignedToName")
                tsk.TaskType = DatabaseHelper.Peel_string(rd, "TaskTypeName")
                tsk.TaskDescription = DatabaseHelper.Peel_string(rd, "Description").Replace("-Not Available", "")
                tsk.StartDate = DatabaseHelper.Peel_date(rd, "Created")
                tsk.DueDate = DatabaseHelper.Peel_date(rd, "Due")
                tsk.CreatedBy = DatabaseHelper.Peel_string(rd, "CreatedByName")
                tsk.ResolvedDate = DatabaseHelper.Peel_ndate(rd, "Resolved")
                tsk.TaskResolutionId = DatabaseHelper.Peel_int(rd, "TaskResolutionID")
                tsk.ClientID = DatabaseHelper.Peel_int(rd, "ClientID")
                tsk.Client = DatabaseHelper.Peel_string(rd, "ClientName")
                Tasks.Add(tsk)

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If Tasks.Count > 0 Then

            rpUpcomingTasks.DataSource = Tasks
            rpUpcomingTasks.DataBind()
            'If Tasks.Count > 5 Then
            '    dvUpcomingTasks.Style("overflow") = "auto"
            '    dvUpcomingTasks.Style("height") = "150"
            'End If

        End If

        rpUpcomingTasks.Visible = Tasks.Count > 0
        pnlNoUpcomingTasks.Visible = Tasks.Count = 0
      
    End Sub

    Private Sub CheckAndUse(ByVal Mode As TaskCalendar.DisplayMode)

        If Not Session("Task" & Mode.ToString() & "StartDate") Is Nothing Then

            tcMain.StartDate = Session("Task" & Mode.ToString() & "StartDate")
            tcMain.EndDate = Session("Task" & Mode.ToString() & "EndDate")
            drMain.StartingMonth = Session("Task" & Mode.ToString() & "StartingMonth")
            drMain.StartingYear = Session("Task" & Mode.ToString() & "StartingYear")
            tcMain.Mode = Mode

        Else
            tcMain.ForceToMode(Mode)
        End If

        ResetPage()

    End Sub
    Private Sub ResetPage()

        Dim qsb As New QueryStringBuilder(Request.Url.Query)

        qsb.Remove("b")
        qsb.Remove("id")

        qsb("sd") = tcMain.StartDate.ToString("yyyyMMdd")
        qsb("ed") = tcMain.EndDate.ToString("yyyyMMdd")
        qsb("sm") = Integer.Parse(drMain.StartingMonth)
        qsb("sy") = drMain.StartingYear
        qsb("mode") = tcMain.Mode
        qsb("type") = type
        If TaskList <> 0 Then
            qsb("tsk") = "1"
        Else
            qsb("tsk") = "0"
        End If

        'store values for round tripping
        Session("TaskMode") = tcMain.Mode
        Session("Task" & tcMain.Mode.ToString() & "StartDate") = tcMain.StartDate
        Session("Task" & tcMain.Mode.ToString() & "EndDate") = tcMain.EndDate
        Session("Task" & tcMain.Mode.ToString() & "StartingMonth") = drMain.StartingMonth
        Session("Task" & tcMain.Mode.ToString() & "StartingYear") = drMain.StartingYear

        'don't overwrite session filter values unless new value is selected
        'If cboType.Items.Count > 0 Then
        '    Session("TaskFilterType") = cboType.SelectedValue
        'End If

        'If cboStatus.Items.Count > 0 Then
        '    Session("TaskFilterStatus") = cboStatus.SelectedValue
        'End If

        'If cboPersonnelID.Items.Count > 0 Then
        '    Session("TaskFilterPersonnelID") = cboPersonnelID.SelectedValue
        'End If

        'If cboProgramID.Items.Count > 0 Then
        '    Session("TaskFilterProgramID") = cboProgramID.SelectedValue
        'End If

        If tcMain.Mode = TaskCalendar.DisplayMode.Day Then
            Response.Redirect("~/tasks/?" & qsb.QueryString & "#" & Now.Subtract(New TimeSpan(0, 4, 0, 0)).ToString("yyyy.MM.dd.HH"))
        Else
            Response.Redirect("~/tasks/?" & qsb.QueryString)
        End If

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
    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        If tsk = "1" Then
            pnlCalendar.Visible = False
            TaskList = 1
            LoadUpcomingTasks()
            LoadHeaders()
            SetSortImage()
            'Else
            '    BindCalendar()
        End If
    End Sub
End Class