Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.IO
Imports Drg.Util.DataAccess

Public Class FilterSelection
    Private _Name As String
    Private _FromDate As String
    Private _ToDate As String

    Public Property FilterName() As String
        Get
            Return _Name
        End Get
        Set(ByVal value As String)
            _Name = value
        End Set
    End Property

    Public Property FromDate() As String
        Get
            Return _FromDate
        End Get
        Set(ByVal value As String)
            _FromDate = value
        End Set
    End Property

    Public Property ToDate() As String
        Get
            Return _ToDate
        End Get
        Set(ByVal value As String)
            _ToDate = value
        End Set
    End Property

End Class

Partial Class Clients_Enrollment_BoydMockup
    Inherits System.Web.UI.Page

    Private _agencyId As Integer
    Private _commrecid As Integer
    Private _allAgencies As String
    Private _allUsers As String

#Region "Page Event Handlers"

    Protected Sub btnExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        'Dim gvLeads As GridView
        ' Dim lblFilter As Label
        Dim filename As String = "IncomeFromAgencies.csv"

        Dim sw As StringWriter = New StringWriter

        sw.WriteLine("Report Date: {0:g}", Now)

        'If lvLeads.Items.Count = 1 Then
        '    sw.WriteLine("Date Range: {0:d}  -  {1:d}", txtDate1.Text, txtDate2.Text)
        'End If

        sw.WriteLine()

        'Dim rexp As New Regex("<br/>")

        'For Each l As ListViewDataItem In lvLeads.Items

        '    lblFilter = l.FindControl("lblFilter")
        '    sw.Write(rexp.Replace(lblFilter.Text, " "))

        '    sw.Write(Environment.NewLine)

        'gvLeads = l.FindControl("gvLeads")
        'For i As Integer = 0 To gvLeads.Columns.Count - 1
        '    sw.Write(rexp.Replace(gvLeads.Columns(i).HeaderText, " ") & ",")
        'Next
        'sw.Write(Environment.NewLine)

        For Each row As GridViewRow In gvLeads.Rows
            If row.RowType = DataControlRowType.DataRow Then
                For i As Integer = 0 To row.Cells.Count - 1
                    If row.Cells(i).Controls.Count = 0 Then
                        sw.Write(row.Cells(i).Text.Replace(",", String.Empty).Replace("&nbsp;", String.Empty) & ",")
                    Else
                        sw.Write(CType(row.Cells(i).Controls(0), DataBoundLiteralControl).Text.Trim.Replace(",", String.Empty).Replace("&nbsp;", String.Empty) & ",")
                    End If
                Next
                sw.Write(Environment.NewLine)
            End If
        Next

        'If Not gvLeads.FooterRow Is Nothing AndAlso gvLeads.FooterRow.Cells.Count > 0 Then
        '    For i As Integer = 0 To gvLeads.FooterRow.Cells.Count - 1
        '        sw.Write(gvLeads.FooterRow.Cells(i).Text.Replace(",", String.Empty).Replace("&nbsp;", String.Empty) & ",")
        '    Next
        'End If

        sw.Write(Environment.NewLine)

        'Next

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.AddHeader("content-disposition", String.Format("attachment; filename={0}", filename))
        HttpContext.Current.Response.ContentType = "text/csv"
        HttpContext.Current.Response.Write(sw.ToString)
        HttpContext.Current.Response.End()
    End Sub

    Public Sub btnFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilter.Click

        LoadLeads(gvLeads, txtDate1.Text, txtDate2.Text)

    End Sub

    'Protected Sub lvLeads_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ListViewItemEventArgs) Handles lvLeads.ItemDataBound
    '    Dim sel As FilterSelection = DirectCast(DirectCast(e.Item, ListViewDataItem).DataItem, FilterSelection)
    '    SortLeads(e.Item.FindControl("gvLeads"), hdnSortColumn.Value, hdnSortDirection.Value, sel.FromDate, sel.ToDate)
    'End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        _agencyId = DataHelper.FieldLookup("tbluser", "agencyid", String.Format("userid={0}", DataHelper.Nz_int(Page.User.Identity.Name)))
        _commrecid = DataHelper.FieldLookup("tbluser", "commrecid", String.Format("userid={0}", DataHelper.Nz_int(Page.User.Identity.Name)))

        If Not IsPostBack Then
            SetDates()
        End If

        SetAgencies()
        SetUsers()

        txtDate1.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        txtDate2.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        imgDate1.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        imgDate2.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        ddlMonthYear1.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower <> "by month", "none", "inline")
        ddlMonthYear2.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower <> "by month", "none", "inline")
    End Sub

#End Region

#Region "Private Routines"

    Private Sub LoadLeads(ByVal gvLeads As GridView, ByVal FromDate As String, ByVal ToDate As String)
        Try
            Dim params2 As New List(Of SqlParameter)
            Dim procname As String = "stp_GetIncomeFromAgencies"
            params2.Add(New SqlParameter("startdate", FromDate))
            params2.Add(New SqlParameter("enddate", ToDate & " 23:59"))
            params2.Add(New SqlParameter("commrecid", _commrecid))

            If ddlAgency.SelectedValue = -1 Then
                params2.Add(New SqlParameter("commrecids", _allAgencies))
            Else
                params2.Add(New SqlParameter("commrecids", ddlAgency.SelectedValue))
            End If

            If ddlUser.SelectedValue = -1 Then
                params2.Add(New SqlParameter("users", _allUsers))
            Else
                params2.Add(New SqlParameter("users", ddlUser.SelectedValue))
            End If

            Dim ds As DataSet
            ds = SqlHelper.GetDataSet(procname, CommandType.StoredProcedure, params2.ToArray)

            gvLeads.DataSource = ds.Tables(0)
            gvLeads.DataBind()

            gvTotals.DataSource = ds.Tables(1)
            gvTotals.DataBind()

        Catch ex As Exception
            'LeadHelper.LogError("Debt Analysis", ex.Message, ex.StackTrace)
        End Try
    End Sub

    'Private Sub LoadReport()
    '    Dim l As New List(Of FilterSelection)
    '    If ddlQuickPickDate.SelectedItem.Text.ToLower = "by month" Then
    '        Dim fromdate As DateTime = CDate(ddlMonthYear1.SelectedValue)
    '        Dim todate As DateTime = CDate(ddlMonthYear2.SelectedValue)
    '        Dim months As Integer = DateDiff(DateInterval.Month, fromdate, todate)
    '        fromdate = todate
    '        For i As Integer = 0 To months
    '            todate = fromdate.AddMonths(1).AddDays(-1)
    '            l.Add(New FilterSelection() With {.FilterName = String.Format("{0: MMMM yyyy}", CDate(fromdate)), .FromDate = fromdate, .ToDate = todate})
    '            fromdate = fromdate.AddMonths(-1)
    '        Next
    '    Else
    '        l.Add(New FilterSelection() With {.FilterName = BuildFilterName(), .FromDate = CDate(txtDate1.Text), .ToDate = txtDate2.Text})
    '    End If

    '    lvLeads.DataSource = l
    '    lvLeads.DataBind()
    'End Sub

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
        'ddlQuickPickDate.Items.Add(New ListItem("By Month", RoundDate(Now.AddMonths(-5), -1, DateUnit.Month).ToString("M/d/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("M/d/yyyy")))
        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = ddlQuickPickDate.Items.Count - 9

        'Dim d As Date
        'ddlMonthYear1.Items.Clear()
        'ddlMonthYear2.Items.Clear()
        'For i As Integer = 0 To 5
        '    d = RoundDate(Now.AddMonths(-i), -1, DateUnit.Month).ToString("M/d/yyyy")
        '    ddlMonthYear1.Items.Add(New ListItem(d.ToString("MMMM/yyyy"), d.ToString("M/d/yyyy")))
        '    ddlMonthYear2.Items.Add(New ListItem(d.ToString("MMMM/yyyy"), d.ToString("M/d/yyyy")))
        'Next
        'ddlMonthYear1.SelectedIndex = ddlMonthYear2.Items.Count - 1
        'ddlMonthYear2.SelectedIndex = 0

    End Sub

    Private Sub SetAgencies()

        ddlAgency.Items.Add(New System.Web.UI.WebControls.ListItem("All Agencies", -1))
        ddlAgency.SelectedIndex = 0

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("CommRecId", _commrecid))

        Dim dt As DataTable

        dt = SqlHelper.GetDataTable("stp_GetChildCommRecIds", CommandType.StoredProcedure, params.ToArray)

        _allAgencies += ""
        For Each rw As DataRow In dt.Rows
            _allAgencies += rw("CommRecid").ToString + ","
            ddlAgency.Items.Add(New System.Web.UI.WebControls.ListItem(rw("display"), rw("CommRecid")))
        Next
        _allAgencies.Remove(_allAgencies.Length - 1)
    End Sub

    Private Sub SetUsers()

        ddlUser.Items.Add(New System.Web.UI.WebControls.ListItem("All Users", -1))
        ddlUser.SelectedIndex = 0

        Dim selectedAgency As String = ""
        If ddlAgency.SelectedValue = -1 Then
            selectedAgency = _allAgencies
        Else
            selectedAgency = ddlAgency.SelectedValue
        End If

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("CommRecIds", selectedAgency))

        Dim dt As DataTable
        dt = SqlHelper.GetDataTable("stp_GetUsersFromCommRecIds", CommandType.StoredProcedure, params.ToArray)

        For Each rw As DataRow In dt.Rows
            _allUsers += rw("UserId").ToString + ","
            ddlUser.Items.Add(New System.Web.UI.WebControls.ListItem(rw("SalesName"), rw("UserId")))
        Next
        _allUsers.Remove(_allUsers.Length - 1)

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
