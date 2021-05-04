Partial Class Agency_reports_ReportDateRangeFilter
    Inherits System.Web.UI.UserControl
    Private connString As String = ConfigurationManager.AppSettings.Get("connectionstring").ToString

    Public Property [From]() As Date
        Get
            Return CDate(Me.wdBeginPeriod.Value)
        End Get
        Set(ByVal value As Date)
            Me.wdBeginPeriod.Value = value
        End Set
    End Property

    Public Property [To]() As Date
        Get
            Return CDate(Me.wdEndPeriod.Value)
        End Get
        Set(ByVal value As Date)
            Me.wdEndPeriod.Value = value
        End Set
    End Property

    Public Property Period() As String
        Get
            Return Me.ddlPeriod.SelectedValue
        End Get
        Set(ByVal value As String)
            Dim itm As ListItem = Me.ddlPeriod.Items.FindByValue(value)
            If Not itm Is Nothing Then
                Me.ddlPeriod.SelectedIndex = Me.ddlPeriod.Items.IndexOf(itm)
                ResetGroupBy()
            End If
        End Set
    End Property

    Public Property GroupBy() As String
        Get
            Return Me.ddlGroupBy.SelectedValue
        End Get
        Set(ByVal value As String)
            Dim itm As ListItem = Me.ddlGroupBy.Items.FindByValue(value)
            If Not itm Is Nothing Then Me.ddlGroupBy.SelectedIndex = Me.ddlGroupBy.Items.IndexOf(itm)
        End Set
    End Property

    Public Property LinkedRefreshControlID() As String
        Get
            Return Me.WebAsyncRefreshPanel1.LinkedRefreshControlID
        End Get
        Set(ByVal value As String)
            Me.WebAsyncRefreshPanel1.LinkedRefreshControlID = value
        End Set
    End Property

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        If Not Me.IsPostBack Then
            LoadPeriods()
            ResetGroupBy()
        End If
    End Sub


    Private Function CalculateEndDate(ByVal BeginDate As DateTime) As Date
        Dim endDate As Date = BeginDate
        Select Case Me.ddlGroupBy.SelectedValue
            Case "w"
                endDate = BeginDate.AddDays(6)
            Case "m"
                endDate = BeginDate.AddMonths(1).AddDays(-1)
            Case "q"
                endDate = BeginDate.AddMonths(3).AddDays(-1)
            Case "y"
                endDate = BeginDate.AddYears(1).AddDays(-1)
        End Select
        Return endDate
    End Function

    Private Sub LoadPeriods()
        Me.ddlPeriod.Items.Add(New ListItem("Today", "today"))
        Me.ddlPeriod.Items.Add(New ListItem("This week", "thisweek"))
        Me.ddlPeriod.Items.Add(New ListItem("This month", "thismonth"))
        Me.ddlPeriod.Items.Add(New ListItem("This quarter", "thisquarter"))
        Me.ddlPeriod.Items.Add(New ListItem("This year", "thisyear"))
        Me.ddlPeriod.Items.Add(New ListItem("Yesterday", "yesterday"))
        Me.ddlPeriod.Items.Add(New ListItem("Last week", "lastweek"))
        Me.ddlPeriod.Items.Add(New ListItem("Last month", "lastmonth"))
        Me.ddlPeriod.Items.Add(New ListItem("Last quarter", "lastquarter"))
        Me.ddlPeriod.Items.Add(New ListItem("Last year", "lastyear"))
        Me.ddlPeriod.Items.Add(New ListItem("Last 6 months", "lastsixmonths"))
        Me.ddlPeriod.Items.Add(New ListItem("Date range", "range"))
        If Me.ddlPeriod.SelectedIndex = -1 Then Me.ddlPeriod.SelectedIndex = ddlPeriod.Items.Count - 1
    End Sub

    Private Sub FillDateRange()
        Dim BeginPeriod As DateTime
        Dim EndPeriod As DateTime
        Dim date1 As Date = DateTime.Today
        Me.wdBeginPeriod.Enabled = False
        Me.wdEndPeriod.Enabled = False
        Select Case ddlPeriod.SelectedValue.ToLower
            Case "today"
                BeginPeriod = date1
                EndPeriod = date1
            Case "yesterday"
                BeginPeriod = date1.AddDays(-1)
                EndPeriod = BeginPeriod
            Case "thisweek"
                BeginPeriod = DateAdd(DateInterval.Day, 1 - DatePart(DateInterval.Weekday, date1, vbSunday), date1)
                EndPeriod = BeginPeriod.AddDays(6)
            Case "lastweek"
                BeginPeriod = DateAdd(DateInterval.Day, 1 - DatePart(DateInterval.Weekday, date1, vbSunday), date1).AddDays(-7)
                EndPeriod = BeginPeriod.AddDays(6)
            Case "thismonth"
                BeginPeriod = New DateTime(date1.Year, date1.Month, 1)
                EndPeriod = BeginPeriod.AddMonths(1).AddDays(-1)
            Case "lastmonth"
                BeginPeriod = New DateTime(date1.Year, date1.Month, 1).AddMonths(-1)
                EndPeriod = BeginPeriod.AddMonths(1).AddDays(-1)
            Case "lastsixmonths"
                BeginPeriod = New DateTime(date1.Year, date1.Month, 1).AddMonths(-6)
                EndPeriod = BeginPeriod.AddMonths(6).AddDays(-1)
            Case "thisquarter"
                BeginPeriod = New DateTime(date1.Year, ((date1.Month - 1) \ 3 + 1) * 3 - 2, 1)
                EndPeriod = BeginPeriod.AddMonths(3).AddDays(-1)
            Case "lastquarter"
                BeginPeriod = New DateTime(date1.Year, ((date1.Month - 1) \ 3 + 1) * 3 - 2, 1).AddMonths(-3)
                EndPeriod = BeginPeriod.AddMonths(3).AddDays(-1)
            Case "thisyear"
                BeginPeriod = New DateTime(date1.Year, 1, 1)
                EndPeriod = New DateTime(date1.Year, 12, 31)
            Case "lastyear"
                BeginPeriod = New DateTime(date1.Year, 1, 1).AddYears(-1)
                EndPeriod = New DateTime(date1.Year, 12, 31).AddYears(-1)
            Case "range"
                Me.wdBeginPeriod.Enabled = True
                Me.wdEndPeriod.Enabled = True
                BeginPeriod = CDate(wdBeginPeriod.Value)
                EndPeriod = CDate(wdEndPeriod.Value)
        End Select
        wdBeginPeriod.Value = BeginPeriod
        wdEndPeriod.Value = EndPeriod
    End Sub

    Private Function GetDayCount(ByVal Date1 As DateTime, ByVal Date2 As DateTime) As Integer
        Return Date2.Subtract(Date1).Days
    End Function

    Private Sub LoadGroupBy()
        Dim dayCount As Integer = GetDayCount(CDate(wdBeginPeriod.Value), CDate(wdEndPeriod.Value))
        Me.ddlGroupBy.Items.Clear()
        If dayCount < 32 Then Me.ddlGroupBy.Items.Add(New ListItem("Day", "d"))
        If dayCount \ 7 < 32 Then Me.ddlGroupBy.Items.Add(New ListItem("Week", "w"))
        If dayCount \ 28 < 32 Then Me.ddlGroupBy.Items.Add(New ListItem("Month", "m"))
        If dayCount \ 89 < 32 Then Me.ddlGroupBy.Items.Add(New ListItem("Quarter", "q"))
        If dayCount \ 365 < 32 Then Me.ddlGroupBy.Items.Add(New ListItem("Year", "y"))
    End Sub

    Private Sub ResetGroupBy()
        FillDateRange()
        LoadGroupBy()
    End Sub

    Protected Sub ddlPeriod_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPeriod.SelectedIndexChanged
        ResetGroupBy()
    End Sub

    Protected Sub wdBeginPeriod_ValueChanged(ByVal sender As Object, ByVal e As Infragistics.WebUI.WebSchedule.WebDateChooser.WebDateChooserEventArgs) Handles wdBeginPeriod.ValueChanged, wdEndPeriod.ValueChanged
        ResetGroupBy()
    End Sub

End Class
