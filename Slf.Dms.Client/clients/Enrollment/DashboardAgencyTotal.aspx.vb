Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports System.Collections.Generic

Partial Class Clients_Enrollment_DashboardAgencyTotal
    Inherits System.Web.UI.Page

    Private _userid As Integer
    Private _agencyid As Integer
    Private _commrecid As Integer

    Private _FromDate As DateTime
    Private _ToDate As DateTime

    Private _allAgencies As String
    Private _allCompanies As String
    Private _AllReps As String

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Request.QueryString("mobile") = "1" Then
            hdnNotab.Value = "1"
        End If

        _userid = DataHelper.Nz_int(Page.User.Identity.Name)
        _agencyId = DataHelper.FieldLookup("tbluser", "agencyid", String.Format("userid={0}", DataHelper.Nz_int(Page.User.Identity.Name)))

        _ToDate = Now
        _FromDate = DateAdd(DateInterval.Year, -1, _ToDate)

        If Not IsPostBack Then
            SetProducts()
            SetCompanies()
            SetReps()
            LoadGrid()
        End If

    End Sub

    Private Sub SetProducts()

        ddlProduct.Items.Clear()
        ddlProduct.Items.Add(New System.Web.UI.WebControls.ListItem("All Sources", -1))
        ddlProduct.SelectedIndex = 0

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("fromDate", _FromDate))
        params.Add(New SqlParameter("toDate", _ToDate))

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

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("fromDate", _FromDate))
        params.Add(New SqlParameter("toDate", _ToDate))

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

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("fromDate", _FromDate))
        params.Add(New SqlParameter("toDate", _ToDate))

        Dim dt As DataTable
        dt = SqlHelper.GetDataTable("stp_enrollment_getRepsTakingLeads", CommandType.StoredProcedure, params.ToArray)

        For Each rw As DataRow In dt.Rows
            _allReps += rw("userid").ToString + ","
            ddlRep.Items.Add(New System.Web.UI.WebControls.ListItem(rw("fullname"), rw("userid")))
        Next
        _allReps.Remove(_allReps.Length - 1)
        hdnReps.Value = _allReps
    End Sub

    Public Sub LoadGrid()

        Dim dateFrom As DateTime
        Dim dateTo As DateTime
        Dim dsOutput As DataSet
        Dim products As String
        Dim companies As String
        Dim reps As String
        Dim params(5) As SqlParameter

        If ddlProduct.SelectedValue = -1 Then
            products = hdnProducts.Value
        Else
            products = ddlProduct.SelectedValue
        End If

        If ddlCompany.SelectedValue = -1 Then
            companies = hdnCompanies.Value
        Else
            companies = ddlCompany.SelectedValue
        End If

        If ddlRep.SelectedValue = -1 Then
            reps = hdnReps.Value
        Else
            reps = ddlRep.SelectedValue
        End If

        For i As Integer = 0 To 11
            dateFrom = CDate(Month(DateAdd(DateInterval.Month, -1 * i, Today)) & "/1/" & Year(DateAdd(DateInterval.Month, -1 * i, Today)))
            dateTo = DateAdd(DateInterval.Month, 1, dateFrom)
            params(0) = New SqlParameter("fromDate", dateFrom)
            params(1) = New SqlParameter("toDate", dateTo)
            params(2) = New SqlParameter("description", String.Format("{0:MMMM yyyy}", dateFrom))
            params(3) = New SqlParameter("productid", products)
            params(4) = New SqlParameter("repid", reps)
            params(5) = New SqlParameter("companyid", companies)
            If i = 0 Then
                dsOutput = SqlHelper.GetDataSet("stp_enrollment_getLeadDepositReportCommission", , params)
            Else
                dsOutput.Merge(SqlHelper.GetDataSet("stp_enrollment_getLeadDepositReportCommission", , params))
            End If
        Next

        BuildGrid(dsOutput)

    End Sub

    Private Sub BuildGrid(ByVal dsOutput As DataSet)

        dsOutput.Relations.Add("DateDescription", dsOutput.Tables(0).Columns("description"), dsOutput.Tables(1).Columns("description"))

        'Dim parentCol(1) As DataColumn
        'Dim childCol(1) As DataColumn

        'parentCol(0) = dsOutput.Tables(1).Columns("description")
        'parentCol(1) = dsOutput.Tables(1).Columns("product")

        'childCol(0) = dsOutput.Tables(2).Columns("description")
        'childCol(1) = dsOutput.Tables(2).Columns("product")

        'dsOutput.Relations.Add("DescriptionRep", parentCol, childCol)

        'Create PlaceHolder
        Dim sb As New StringBuilder
        Dim rowid As Integer = 0
        For Each dr As DataRow In dsOutput.Tables(0).Rows
            rowid += 1
            RenderChildRows(sb, dr, "row" & rowid, "", 0)
        Next
        ltrTree.Text = "<table id=""tbtree"" class=""rawtb""><thead><tr><th>Date/Lead Name</th><th>Leads</th><th>Lead Name</th><th>Created</th><th>Approved</th><th>Product</th>"
        ltrTree.Text += "<th style=""background-color:#CCFFCC""># of Debts</th><th style=""background-color:#CCFFCC"">Total Debt</th><th style=""background-color:#CCFFCC"">Fee Pct</th><th style=""background-color:#CCFFCC"">Total Fees</th><th style=""background-color:#CCFFCC"">Fees / Debt</th><th style=""background-color:#CCFFCC"">Initial Date</th><th style=""background-color:#CCFFCC"">Initial Amount</th><th style=""background-color:#CCFFCC"">Monthly Day</th><th style=""background-color:#CCFFCC"">Monthly Amount</th>"
        ltrTree.Text += "<th style=""background-color:#CC6666"">Deposit Method</th><th style=""background-color:#CC6666"" colspan=""2"">Cleared</th><th style=""background-color:#CC6666"" colspan=""2"">Bounced</th>"
        ltrTree.Text += "<th style=""background-color:#8F5B4F"">SalesPerson</th><th style=""background-color:#8F5B4F"">Status</th><th style=""background-color:#8F5B4F"">Law Firm</th></tr></thead>" & sb.ToString & "</table>"
    End Sub

    Private Sub RenderChildRows(ByRef sb As StringBuilder, ByVal dr As DataRow, ByVal rowid As String, ByVal parentrowid As String, ByVal level As Integer)
        Dim sbcells As New StringBuilder
        For Each col As DataColumn In dr.Table.Columns
            If dr.Table.Columns.IndexOf(col) >= level Then
                sbcells.AppendFormat("<td>{0}</td>", GetCellValue(dr, col, level))
            End If
        Next
        'Write Row
        sb.AppendFormat("<tr data-tt-id=""{0}"" {1} class=""level{3}"">{2}</tr>", rowid, IIf(level > 0, String.Format("data-tt-parent-id=""{0}""", parentrowid), ""), sbcells, level)
        'Write Children 
        If level <= dr.Table.DataSet.Relations.Count - 1 Then
            Dim id As Integer = 0
            For Each drchild As DataRow In dr.GetChildRows(dr.Table.DataSet.Relations(level).RelationName)
                id += 1
                RenderChildRows(sb, drchild, rowid & "_" & id, rowid, level + 1)
            Next
        End If
    End Sub

    Private Function GetCellValue(ByVal dr As DataRow, ByVal col As DataColumn, ByVal level As Integer) As String
        Dim emptyreptext As String = "[Not Assigned]"
        Dim cellvalue As String = IIf(dr(col) Is DBNull.Value, "", dr(col).ToString)
        Dim colname As String = col.ColumnName

        If cellvalue.Contains(".00%") Then
            cellvalue = cellvalue.Replace(".00%", "%")
        End If

        If cellvalue.Contains("%") Or colname = "Total Leads" Then
            Dim statusgroup As String = ""

            If colname <> "Total Leads" Then
                statusgroup = colname
            End If

        ElseIf cellvalue.Trim.Length = 0 AndAlso colname.ToLower.Trim = "rep" Then
            cellvalue = emptyreptext
        End If

        Return cellvalue
    End Function

    Protected Sub btnFilter_Click(sender As Object, e As EventArgs) Handles btnFilter.Click
        LoadGrid()
    End Sub
End Class
