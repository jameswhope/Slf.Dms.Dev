﻿Imports System.Data
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

Partial Class Clients_Enrollment_DepositAnalysisReport
    Inherits System.Web.UI.Page

    Private _agencyId As Integer
    Private _commrecid As Integer
    Private _allAgencies As String
    Private _allCompanies As String
    Private _allReps As String

#Region "Page Event Handlers"

    Protected Sub btnExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Dim gvLeads As GridView
        Dim lblFilter As Label
        Dim filename As String = "LeadDepositAnalysis.csv"

        Dim sw As StringWriter = New StringWriter

        sw.WriteLine("Report Date: {0:g}", Now)

        If lvLeads.Items.Count = 1 Then
            sw.WriteLine("Date Range: {0:d}  -  {1:d}", txtDate1.Text, txtDate2.Text)
        End If

        sw.WriteLine()

        Dim rexp As New Regex("<br/>")

        For Each l As ListViewDataItem In lvLeads.Items

            lblFilter = l.FindControl("lblFilter")
            sw.Write(rexp.Replace(lblFilter.Text, " "))

            sw.Write(Environment.NewLine)

            gvLeads = l.FindControl("gvLeads")
            For i As Integer = 0 To gvLeads.Columns.Count - 1
                sw.Write(rexp.Replace(gvLeads.Columns(i).HeaderText, " ") & ",")
            Next
            sw.Write(Environment.NewLine)

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

            If Not gvLeads.FooterRow Is Nothing AndAlso gvLeads.FooterRow.Cells.Count > 0 Then
                For i As Integer = 0 To gvLeads.FooterRow.Cells.Count - 1
                    sw.Write(gvLeads.FooterRow.Cells(i).Text.Replace(",", String.Empty).Replace("&nbsp;", String.Empty) & ",")
                Next
            End If

            sw.Write(Environment.NewLine)

        Next

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.AddHeader("content-disposition", String.Format("attachment; filename={0}", filename))
        HttpContext.Current.Response.ContentType = "text/csv"
        HttpContext.Current.Response.Write(sw.ToString)
        HttpContext.Current.Response.End()
    End Sub

    Protected Sub btnFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilter.Click
        hdnSortColumn.Value = "clientcreated"
        hdnSortDirection.Value = "desc"
        LoadReport()
    End Sub

    Protected Sub chkExcludeReferals_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkExcludeReferals.CheckedChanged
        LoadReport()
    End Sub

    Protected Sub gvLeads_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs)
        Dim sortDirection As String = "Asc"
        If hdnSortColumn.Value.ToLower = e.SortExpression.ToString.ToLower Then
            If hdnSortDirection.Value = "Asc" Then
                sortDirection = "Desc"
            End If
        End If
        hdnSortDirection.Value = sortDirection
        hdnSortColumn.Value = e.SortExpression

        LoadReport()
    End Sub

    Protected Sub lvLeads_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ListViewItemEventArgs) Handles lvLeads.ItemDataBound
        Dim sel As FilterSelection = DirectCast(DirectCast(e.Item, ListViewDataItem).DataItem, FilterSelection)
        SortLeads(e.Item.FindControl("gvLeads"), hdnSortColumn.Value, hdnSortDirection.Value, sel.FromDate, sel.ToDate)
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.QueryString("mobile") = "1" Then
            hdnNotab.Value = "1"
        End If

        _agencyId = DataHelper.FieldLookup("tbluser", "agencyid", String.Format("userid={0}", DataHelper.Nz_int(Page.User.Identity.Name)))
        _commrecid = DataHelper.FieldLookup("tbluser", "commrecid", String.Format("userid={0}", DataHelper.Nz_int(Page.User.Identity.Name)))

        If Not IsPostBack Then
            SetDates()
            SetProducts()
            SetCompanies()
            SetReps()
        End If

        chkExcludeReferals.Visible = False
        txtDate1.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        txtDate2.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        imgDate1.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        imgDate2.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        ddlMonthYear1.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower <> "by month", "none", "inline")
        ddlMonthYear2.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower <> "by month", "none", "inline")
    End Sub

#End Region

#Region "Private Routines"

    Private Function BuildFilterName() As String
        Dim name As String = String.Format("Date Range  From: {1} To: {2}", ddlQuickPickDate.SelectedItem.Text, txtDate1.Text, txtDate2.Text)
        Dim range As String() = ddlQuickPickDate.SelectedValue.Split(",")

        If range(0).Trim = txtDate1.Text.Trim AndAlso range(1).Trim = txtDate2.Text.Trim Then
            Select Case ddlQuickPickDate.SelectedItem.Text.Trim.ToLower
                Case "today", "yesterday"
                    name = String.Format("{0}: {1}", ddlQuickPickDate.SelectedItem.Text.Trim, txtDate1.Text.Trim)
                Case "this month", "last month"
                    name = String.Format("{0}: {1: MMMM yyyy}", ddlQuickPickDate.SelectedItem.Text.Trim, CDate(txtDate1.Text.Trim))
                Case Else
                    name = String.Format("{0}: {1} - {2}", ddlQuickPickDate.SelectedItem.Text, txtDate1.Text.Trim, txtDate2.Text.Trim)
            End Select
        Else
            name = String.Format("Date Range: {1} - {2}", ddlQuickPickDate.SelectedItem.Text, txtDate1.Text, txtDate2.Text)
        End If
        Return name
    End Function

    Private Sub BuildFooter(ByVal gvLeads As GridView, ByVal FromDate As String, ByVal ToDate As String)
        Dim dt As DataTable = GetSummary(FromDate, ToDate)
        If dt.Rows.Count > 0 Then
            gvLeads.FooterRow.Cells(GetGridColumnIndex(gvLeads, "debtcount")).Text = String.Format("{0:n0}", dt.Rows(0)("avgdebtcount"))
            gvLeads.FooterRow.Cells(GetGridColumnIndex(gvLeads, "debtamount")).Text = String.Format("{0:c}", dt.Rows(0)("avgdebtamount"))
            gvLeads.FooterRow.Cells(GetGridColumnIndex(gvLeads, "initialdraftamount")).Text = String.Format("{0:c}", dt.Rows(0)("avginitialamount"))
            gvLeads.FooterRow.Cells(GetGridColumnIndex(gvLeads, "depositamount")).Text = String.Format("{0:c}", dt.Rows(0)("avgdepositamount"))
            gvLeads.FooterRow.Cells(GetGridColumnIndex(gvLeads, "totalfixedfees")).Text = String.Format("{0:c}", dt.Rows(0)("avgfixedfeeamount"))
            If dt.Rows(0)("AvgFixedFeePct") Is DBNull.Value Then
                gvLeads.FooterRow.Cells(GetGridColumnIndex(gvLeads, "fixedfeepercentage")).Text = "0%"
            Else
                gvLeads.FooterRow.Cells(GetGridColumnIndex(gvLeads, "fixedfeepercentage")).Text = String.Format("{0:p1}", dt.Rows(0)("AvgFixedFeePct"))
            End If
            If dt.Rows(0)("PctActive") Is DBNull.Value Then
                gvLeads.FooterRow.Cells(GetGridColumnIndex(gvLeads, "status")).Text = "0%"
            Else
                gvLeads.FooterRow.Cells(GetGridColumnIndex(gvLeads, "status")).Text = String.Format("{0:p0}", dt.Rows(0)("PctActive"))
            End If
            If dt.Rows(0)("PctClearDeposits") Is DBNull.Value Then
                gvLeads.FooterRow.Cells(GetGridColumnIndex(gvLeads, "gooddepositscount")).Text = "0%"
            Else
                gvLeads.FooterRow.Cells(GetGridColumnIndex(gvLeads, "gooddepositscount")).Text = String.Format("{0:p0}", dt.Rows(0)("PctClearDeposits"))
            End If
        End If
    End Sub

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

    Private Function GetLeads(ByVal FromDate As DateTime, ByVal ToDate As DateTime) As DataTable
        Dim params As New List(Of SqlParameter)
        'Dim procname As String = "stp_enrollement_getLeadDepositReport"
        Dim procname As String = "stp_enrollment_getLeadDepositReport_Test"
        params.Add(New SqlParameter("FromDate", FromDate))
        params.Add(New SqlParameter("ToDate", ToDate & " 23:59"))

        'If _agencyId > 0 Then
        '    procname = "stp_enrollment_getLeadDepositReport_External"
        '    params.Add(New SqlParameter("agencyid", _agencyId))
        'Else
        params.Add(New SqlParameter("ExcludeReferals", IIf(chkExcludeReferals.Checked, 1, 0)))
        'End If

        If ddlCompany.SelectedValue = -1 Then
            params.Add(New SqlParameter("companyid", hdnCompanies.Value))
        Else
            params.Add(New SqlParameter("companyid", ddlCompany.SelectedValue))
        End If

        If ddlProduct.SelectedValue = -1 Then
            params.Add(New SqlParameter("productid", hdnProducts.Value))
        Else
            params.Add(New SqlParameter("productid", ddlProduct.SelectedValue))
        End If

        If ddlRep.SelectedValue = -1 Then
            params.Add(New SqlParameter("repid", hdnReps.Value))
        Else
            params.Add(New SqlParameter("repid", ddlRep.SelectedValue))
        End If

        Dim dts As New DataTable
        dts.Columns.Add("value", GetType(Int32))

        Dim dt As DataTable

        dt = SqlHelper.GetDataTable(procname, CommandType.StoredProcedure, params.ToArray)

        Return dt
    End Function

    Private Function GetSummary(ByVal FromDate As DateTime, ByVal ToDate As DateTime) As DataTable
        'Dim procname As String = "stp_enrollment_getLeadDepositReportSummary"
        Dim procname As String = "stp_enrollment_getLeadDepositReportSummary_Test"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("FromDate", FromDate))
        params.Add(New SqlParameter("ToDate", ToDate & " 23:59"))

        If _agencyId > 0 Then
            procname = "stp_enrollment_getLeadDepositReportSummary_External"
            params.Add(New SqlParameter("agencyid", _agencyId))
        Else
            params.Add(New SqlParameter("ExcludeReferals", IIf(chkExcludeReferals.Checked, 1, 0)))
        End If

        If ddlCompany.SelectedValue = -1 Then
            params.Add(New SqlParameter("companyid", hdnCompanies.Value))
        Else
            params.Add(New SqlParameter("companyid", ddlCompany.SelectedValue))
        End If

        If ddlProduct.SelectedValue = -1 Then
            params.Add(New SqlParameter("productid", hdnProducts.Value))
        Else
            params.Add(New SqlParameter("productid", ddlProduct.SelectedValue))
        End If

        If ddlRep.SelectedValue = -1 Then
            params.Add(New SqlParameter("repid", hdnReps.Value))
        Else
            params.Add(New SqlParameter("repid", ddlRep.SelectedValue))
        End If

        Dim dts As New DataTable
        dts.Columns.Add("value", GetType(Int32))

        Dim dt As DataTable

        dt = SqlHelper.GetDataTable(procname, CommandType.StoredProcedure, params.ToArray)

        Return dt
    End Function

    Private Sub LoadLeads(ByVal gvLeads As GridView, ByVal SortExpression As String, ByVal FromDate As String, ByVal ToDate As String)
        Try
            Dim dv As DataView = New DataView(GetLeads(FromDate, ToDate))

            If SortExpression.Trim.Length <> 0 Then
                dv.Sort = SortExpression
            End If

            gvLeads.DataSource = dv
            gvLeads.DataBind()

            BuildFooter(gvLeads, FromDate, ToDate)

        Catch ex As Exception
            'LeadHelper.LogError("Debt Analysis", ex.Message, ex.StackTrace)
        End Try
    End Sub

    Private Sub LoadReport()
        Dim l As New List(Of FilterSelection)
        If ddlQuickPickDate.SelectedItem.Text.ToLower = "by month" Then
            Dim fromdate As DateTime = CDate(ddlMonthYear1.SelectedValue)
            Dim todate As DateTime = CDate(ddlMonthYear2.SelectedValue)
            Dim months As Integer = DateDiff(DateInterval.Month, fromdate, todate)
            fromdate = todate
            For i As Integer = 0 To months
                todate = fromdate.AddMonths(1).AddDays(-1)
                l.Add(New FilterSelection() With {.FilterName = String.Format("{0: MMMM yyyy}", CDate(fromdate)), .FromDate = fromdate, .ToDate = todate})
                fromdate = fromdate.AddMonths(-1)
            Next
        Else
            l.Add(New FilterSelection() With {.FilterName = BuildFilterName(), .FromDate = CDate(txtDate1.Text), .ToDate = txtDate2.Text})
        End If

        lvLeads.DataSource = l
        lvLeads.DataBind()
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
        ddlQuickPickDate.Items.Add(New ListItem("By Month", RoundDate(Now.AddMonths(-11), -1, DateUnit.Month).ToString("M/d/yyyy") & "," & RoundDate(Now.AddMonths(1), 1, DateUnit.Month).ToString("M/d/yyyy")))
        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = ddlQuickPickDate.Items.Count - 1

        Dim d As Date
        ddlMonthYear1.Items.Clear()
        ddlMonthYear2.Items.Clear()
        For i As Integer = 0 To 13
            d = RoundDate(Now.AddMonths(-i), -1, DateUnit.Month).ToString("M/d/yyyy")
            ddlMonthYear1.Items.Add(New ListItem(d.ToString("MMMM/yyyy"), d.ToString("M/d/yyyy")))
            ddlMonthYear2.Items.Add(New ListItem(d.ToString("MMMM/yyyy"), d.ToString("M/d/yyyy")))
        Next
        ddlMonthYear1.SelectedIndex = ddlMonthYear2.Items.Count - 1
        ddlMonthYear2.SelectedIndex = 0
    End Sub

    Private Sub SetProducts()

        ddlProduct.Items.Clear()
        ddlProduct.Items.Add(New System.Web.UI.WebControls.ListItem("All Sources", -1))
        ddlProduct.SelectedIndex = 0

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("fromDate", CDate(ddlMonthYear1.SelectedValue)))
        If ddlMonthYear2.SelectedValue = "1/1/2017" Then
            params.Add(New SqlParameter("toDate", CDate(Now.ToString("d"))))
        Else
        params.Add(New SqlParameter("toDate", CDate(ddlMonthYear2.SelectedValue)))
        End If

        Dim dt As DataTable

        dt = SqlHelper.GetDataTable("stp_enrollment_getProductsOfClientsByDate", CommandType.StoredProcedure, params.ToArray)

        _allAgencies += ""
        For Each rw As DataRow In dt.Rows
            _allAgencies += rw("ProductId").ToString + ","
            ddlProduct.Items.Add(New System.Web.UI.WebControls.ListItem(rw("ProductDesc"), rw("ProductId")))
        Next
        _allAgencies.Remove(_allAgencies.Length - 1)
        hdnProducts.Value = _allAgencies
    End Sub

    Private Sub SetProductsTxtBoxes()

        ddlProduct.Items.Clear()
        ddlProduct.Items.Add(New System.Web.UI.WebControls.ListItem("All Products", -1))
        ddlProduct.SelectedIndex = 0

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("fromDate", CDate(txtDate1.Text)))
        params.Add(New SqlParameter("toDate", CDate(txtDate2.Text)))

        Dim dt As DataTable

        dt = SqlHelper.GetDataTable("stp_enrollment_getProductsOfClientsByDate", CommandType.StoredProcedure, params.ToArray)

        _allAgencies += ""
        For Each rw As DataRow In dt.Rows
            _allAgencies += rw("ProductId").ToString + ","
            ddlProduct.Items.Add(New System.Web.UI.WebControls.ListItem(rw("ProductDesc"), rw("ProductId")))
        Next
        _allAgencies.Remove(_allAgencies.Length - 1)
        hdnProducts.Value = _allAgencies
    End Sub

    Private Sub SetCompanies()

        ddlCompany.Items.Clear()
        ddlCompany.Items.Add(New System.Web.UI.WebControls.ListItem("All Law Firms", -1))
        ddlCompany.SelectedIndex = 0

        'Dim selectedCompany As String = ""
        'If ddlCompany.SelectedValue = -1 Then
        '    selectedCompany = hdnCompanies.Value
        'Else
        '    selectedCompany = ddlCompany.SelectedValue
        'End If

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("fromDate", CDate(ddlMonthYear1.SelectedValue)))
        params.Add(New SqlParameter("toDate", CDate(ddlMonthYear2.SelectedValue).AddMonths(1).AddSeconds(-1)))

        Dim dt As DataTable
        dt = SqlHelper.GetDataTable("stp_enrollment_getCompaniesThatAcceptedClients", CommandType.StoredProcedure, params.ToArray)

        For Each rw As DataRow In dt.Rows
            _allCompanies += rw("CompanyId").ToString + ","
            ddlCompany.Items.Add(New System.Web.UI.WebControls.ListItem(rw("ShortCoName"), rw("CompanyId")))
        Next
        _allCompanies.Remove(_allCompanies.Length - 1)
        hdnCompanies.Value = _allCompanies
    End Sub

    Private Sub SetCompaniesTxtBoxes()

        ddlCompany.Items.Clear()
        ddlCompany.Items.Add(New System.Web.UI.WebControls.ListItem("All Companies", -1))
        ddlCompany.SelectedIndex = 0

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("fromDate", CDate(txtDate1.Text)))
        params.Add(New SqlParameter("toDate", CDate(txtDate2.Text)))

        Dim dt As DataTable
        dt = SqlHelper.GetDataTable("stp_enrollment_getCompaniesThatAcceptedClients", CommandType.StoredProcedure, params.ToArray)

        For Each rw As DataRow In dt.Rows
            _allCompanies += rw("CompanyId").ToString + ","
            ddlCompany.Items.Add(New System.Web.UI.WebControls.ListItem(rw("ShortCoName"), rw("CompanyId")))
        Next
        _allCompanies.Remove(_allCompanies.Length - 1)
        hdnCompanies.Value = _allCompanies
    End Sub

    Private Sub SetReps()

        ddlRep.Items.Clear()
        ddlRep.Items.Add(New System.Web.UI.WebControls.ListItem("All Reps", -1))
        ddlRep.SelectedIndex = 0

        'Dim selectedCompany As String = ""
        'If ddlCompany.SelectedValue = -1 Then
        '    selectedCompany = hdnCompanies.Value
        'Else
        '    selectedCompany = ddlCompany.SelectedValue
        'End If

        Dim setdate As Date = CDate(ddlMonthYear2.SelectedValue)
        setdate = setdate.AddMonths(1).AddSeconds(-1.0)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("fromDate", CDate(ddlMonthYear1.SelectedValue)))
        params.Add(New SqlParameter("toDate", setdate))

        Dim dt As DataTable
        dt = SqlHelper.GetDataTable("stp_enrollment_getRepsTakingLeads", CommandType.StoredProcedure, params.ToArray)

        For Each rw As DataRow In dt.Rows
            _allReps += rw("userid").ToString + ","
            ddlRep.Items.Add(New System.Web.UI.WebControls.ListItem(rw("fullname"), rw("userid")))
        Next
        _allReps.Remove(_allReps.Length - 1)
        hdnReps.Value = _allReps
    End Sub

    'Private Sub SetRepsTxtBoxes()

    '    ddlRep.Items.Clear()
    '    ddlRep.Items.Add(New System.Web.UI.WebControls.ListItem("All Reps", -1))
    '    ddlRep.SelectedIndex = 0

    '    Dim params As New List(Of SqlParameter)
    '    params.Add(New SqlParameter("fromDate", CDate(txtDate1.Text)))
    '    params.Add(New SqlParameter("toDate", CDate(txtDate2.Text)))

    '    Dim dt As DataTable
    '    dt = SqlHelper.GetDataTable("stp_enrollment_getCompaniesThatAcceptedClients", CommandType.StoredProcedure, params.ToArray)

    '    For Each rw As DataRow In dt.Rows
    '        _allCompanies += rw("CompanyId").ToString + ","
    '        ddlCompany.Items.Add(New System.Web.UI.WebControls.ListItem(rw("ShortCoName"), rw("CompanyId")))
    '    Next
    '    _allCompanies.Remove(_allCompanies.Length - 1)
    '    hdnCompanies.Value = _allCompanies
    'End Sub

    Private Sub SortLeads(ByVal gvLeads As GridView, ByVal SortColumn As String, ByVal sortDirection As String, ByVal FromDate As String, ByVal ToDate As String)
        hdnSortColumn.Value = SortColumn
        hdnSortDirection.Value = sortDirection

        LoadLeads(gvLeads, String.Format("{0} {1}", SortColumn, sortDirection), FromDate, ToDate)

        'Set Sort Image
        Dim columnIndex As Integer = GetGridColumnIndex(gvLeads, SortColumn)

        If columnIndex <> -1 Then
            If Not gvLeads.HeaderRow Is Nothing Then
                gvLeads.HeaderRow.Cells(columnIndex).CssClass = "headitem5" & String.Format(" sort{0}", sortDirection.ToLower)
            End If
        End If
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

    Public Sub ddlMonthYear1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlMonthYear1.SelectedIndexChanged
        SetCompanies()
        SetProducts()
        SetReps()
    End Sub

    Public Sub txtDate1_TextChanged(sender As Object, e As EventArgs) Handles txtDate1.TextChanged
        SetCompaniesTxtBoxes()
        SetProductsTxtBoxes()
    End Sub
   
End Class
