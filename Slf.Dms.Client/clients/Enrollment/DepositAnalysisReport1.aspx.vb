Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.IO
Imports Drg.Util.DataAccess


Partial Class Clients_Enrollment_DepositAnalysisReport1
    Inherits System.Web.UI.Page

    Private _agencyId As Integer

#Region "Page Event Handlers"

    Protected Sub btnFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilter.Click
        LoadReport()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery, _
                                                 GlobalFiles.JQuery.UI, _
                                                 ResolveUrl("~/jquery/plugins/table2CSV.js") _
                                                 })

        If Request.QueryString("mobile") = "1" Then
            hdnNotab.Value = "1"
        End If

        If Not IsPostBack Then
            SetDates()
        End If

        _agencyId = DataHelper.FieldLookup("tbluser", "agencyid", String.Format("userid={0}", DataHelper.Nz_int(Page.User.Identity.Name)))
        txtDate1.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        txtDate2.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        ddlMonthYear1.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower <> "by month", "none", "inline")
        ddlMonthYear2.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower <> "by month", "none", "inline")

        If Not IsPostBack Then
            LoadReport()
        End If

    End Sub

    Protected Sub BindSecondRpt(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim grd As GridView = CType(e.Item.FindControl("gvLeads"), GridView)
            Dim dt As DataTable = CType(e.Item.DataItem, DataRow).GetChildRows("daytoclient").CopyToDataTable()
            grd.DataSource = dt
            grd.DataBind()
        End If

    End Sub

#End Region

#Region "Private Routines"

    Private Function BuildFilterName() As String
        Dim name As String = String.Format("Date Range  From: {1} To: {2}", ddlQuickPickDate.SelectedItem.Text, txtDate1.Text, txtDate2.Text)
        Dim range As String() = ddlQuickPickDate.SelectedValue.Split(",")

        If ddlQuickPickDate.SelectedItem.Text.Trim.ToLower = "by month" Then
            name = String.Format("{0}:  {1} - {2}", ddlQuickPickDate.SelectedItem.Text, Me.ddlMonthYear1.SelectedItem.Text, Me.ddlMonthYear2.SelectedItem.Text)
        ElseIf range(0).Trim = txtDate1.Text.Trim AndAlso range(1).Trim = txtDate2.Text.Trim Then
            Select Case ddlQuickPickDate.SelectedItem.Text.Trim.ToLower
                Case "today", "yesterday"
                    name = String.Format("{0}:  {1}", ddlQuickPickDate.SelectedItem.Text.Trim, txtDate1.Text.Trim)
                Case "this month", "last month"
                    name = String.Format("{0}:  {1: MMMM yyyy}", ddlQuickPickDate.SelectedItem.Text.Trim, CDate(txtDate1.Text.Trim))
                Case Else
                    name = String.Format("{0}:  {1} - {2}", ddlQuickPickDate.SelectedItem.Text, txtDate1.Text.Trim, txtDate2.Text.Trim)
            End Select
        Else
            name = String.Format("Date Range:  {1} - {2}", ddlQuickPickDate.SelectedItem.Text, txtDate1.Text, txtDate2.Text)
        End If
        Return name
    End Function

    Private Function GetGridColumnIndex(ByVal gvLeads As GridView, ByVal SortColumn As String) As Integer
        Dim columnIndex As Integer = -1
        For Each col As DataControlField In gvLeads.Columns
            If col.SortExpression.ToLower = SortColumn.ToLower Then
                columnIndex = gvLeads.Columns.IndexOf(col)
                Exit For
            End If
        Next
        Return columnIndex
    End Function

    Private Function GetLeads(ByVal FromDate As DateTime, ByVal ToDate As DateTime) As DataSet
        Dim params As New List(Of SqlParameter)
        Dim procname As String = "stp_enrollment_getLeadDepositAnalysis"
        params.Add(New SqlParameter("FromDate", FromDate))
        params.Add(New SqlParameter("ToDate", ToDate & " 23:59"))

        If _agencyId > 0 Then
            params.Add(New SqlParameter("agencyid", _agencyId))
        End If

        Return SqlHelper.GetDataSet(procname, CommandType.StoredProcedure, params.ToArray)
    End Function

    Private Function GetData() As DataSet
        Dim fromdate As DateTime = CDate(txtDate1.Text)
        Dim toDate As DateTime = CDate(txtDate2.Text)
        If ddlQuickPickDate.SelectedItem.Text.ToLower = "by month" Then
            fromdate = CDate(ddlMonthYear1.SelectedValue)
            toDate = CDate(ddlMonthYear2.SelectedValue).AddMonths(1).AddDays(-1)
        End If
        Dim ds As DataSet = GetLeads(fromdate, toDate)
        ds.Relations.Add(New DataRelation("monthtoday", ds.Tables(0).Columns("YearMonth"), ds.Tables(1).Columns("YearMonth")))
        ds.Relations.Add(New DataRelation("daytoclient", ds.Tables(1).Columns("clientcreated"), ds.Tables(2).Columns("clientcreated")))
        Return ds
    End Function

    Private Sub LoadLeads(ByVal ds As DataSet)
        rptMain.DataSource = ds.Tables(0)
        rptMain.DataBind()
    End Sub

    Private Sub LoadReport()
        Dim ds As DataSet = GetData()
        LoadLeads(ds)
        lblFilter.Text = BuildFilterName()
    End Sub

    Private Sub SetDates()
        txtDate1.Text = Now.ToString("M/d/yyyy")
        txtDate2.Text = Now.ToString("M/d/yyyy")
        ddlQuickPickDate.Items.Clear()
        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("M/d/yyyy") & "," & Now.AddDays(-1).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("M/d/yyyy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("M/d/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("M/d/yyyy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("M/d/yyyy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last 30 days", RoundDate(Now.AddDays(-30), -1, DateUnit.Day).ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last 60 days", RoundDate(Now.AddDays(-60), -1, DateUnit.Day).ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last 90 days", RoundDate(Now.AddDays(-90), -1, DateUnit.Day).ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("By Month", RoundDate(Now.AddMonths(-17), -1, DateUnit.Month).ToString("M/d/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("M/d/yyyy")))
        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = ddlQuickPickDate.Items.Count - 1

        Dim d As Date
        ddlMonthYear1.Items.Clear()
        ddlMonthYear2.Items.Clear()
        For i As Integer = 0 To 17
            d = RoundDate(Now.AddMonths(-i), -1, DateUnit.Month).ToString("M/d/yyyy")
            ddlMonthYear1.Items.Add(New ListItem(d.ToString("MMMM/yyyy"), d.ToString("M/d/yyyy")))
            ddlMonthYear2.Items.Add(New ListItem(d.ToString("MMMM/yyyy"), d.ToString("M/d/yyyy")))
        Next
        ddlMonthYear1.SelectedIndex = 2
        ddlMonthYear2.SelectedIndex = 0
    End Sub

#End Region

#Region "Public Routines"

    Public Shared Function RoundDate(ByVal d As DateTime, ByVal Direction As Integer, ByVal Unit As DateUnit) As DateTime
        Dim result As DateTime = d

        If Unit = DateUnit.Week Then
            If Direction = 1 Then
                While Not result.DayOfWeek = DayOfWeek.Saturday
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.DayOfWeek = DayOfWeek.Sunday
                    result = result.AddDays(-1)
                End While
            Else
                If result.DayOfWeek = DayOfWeek.Wednesday Or result.DayOfWeek = DayOfWeek.Thursday Or result.DayOfWeek = DayOfWeek.Friday Then
                    While Not result.DayOfWeek = DayOfWeek.Saturday
                        result = result.AddDays(1)
                    End While
                ElseIf result.DayOfWeek = DayOfWeek.Monday Or result.DayOfWeek = DayOfWeek.Tuesday Then
                    While Not result.DayOfWeek = DayOfWeek.Sunday
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        ElseIf Unit = DateUnit.Month Then
            If Direction = 1 Then
                While Not result.Day = Date.DaysInMonth(result.Year, result.Month)
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.Day = 1
                    result = result.AddDays(-1)
                End While
            Else
                Dim DaysInMonth As Integer = Date.DaysInMonth(result.Year, result.Month)
                Dim Midpoint As Integer = DaysInMonth / 2

                If result.Day >= Midpoint And result.Day < DaysInMonth Then
                    While Not result.Day = DaysInMonth
                        result = result.AddDays(1)
                    End While
                ElseIf result.Day < Midpoint And result.Day > 1 Then
                    While Not result.Day = 1
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        ElseIf Unit = DateUnit.Year Then
            Dim DaysInYear As Integer
            For i As Integer = 1 To 12
                DaysInYear += Date.DaysInMonth(result.Year, i)
            Next
            If Direction = 1 Then
                While Not result.DayOfYear = DaysInYear
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.DayOfYear = 1
                    result = result.AddDays(-1)
                End While
            Else
                Dim Midpoint As Integer = DaysInYear / 2

                If result.DayOfYear >= Midpoint And result.DayOfYear < DaysInYear Then
                    While Not result.DayOfYear = DaysInYear
                        result = result.AddDays(1)
                    End While
                ElseIf result.DayOfYear < Midpoint And result.DayOfYear > 1 Then
                    While Not result.DayOfYear = 1
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        End If

        Return result
    End Function


#End Region

    
End Class
