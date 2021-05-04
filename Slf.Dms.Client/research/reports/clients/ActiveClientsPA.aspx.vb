Imports System.Linq
Imports System.Data
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.Web.UI.WebControls
Imports System.Xml
Imports System.Xml.Linq

Partial Class research_reports_clients_ActiveClientsPA
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery, _
                                                GlobalFiles.JQuery.UI, _
                                                "~/jquery/json2.js", _
                                                "~/jquery/jquery.multiselect.min.js", _
                                                "~/jquery/plugins/table2CSV.js", _
                                                "~/jquery/jquery.modaldialog.js" _
                                                })

        If Not Me.IsPostBack Then
            LoadCompanys()
            LoadAgencies()
            Me.hdnFirstLoad.Value = "1"
        Else
            Me.hdnFirstLoad.Value = "0"
        End If
    End Sub

    Private Sub LoadCompanys()
        Dim co As New Drg.Util.DataHelpers.CompanyHelper
        Me.ddlCompany.DataSource = co.CompanyList()
        Me.ddlCompany.DataValueField = "companyid"
        Me.ddlCompany.DataTextField = "shortconame"
        Me.ddlCompany.DataBind()
    End Sub

    Private Sub LoadAgencies()
        Dim ag As New Drg.Util.DataHelpers.AgencyHelper
        Dim dt As DataTable = ag.GetAgencies
        Dim qry = From dr As DataRow In dt.Rows Order By dr("code") Ascending Select New With {.agencyId = dr("agencyid"), .code = IIf(dr("code").ToString.Trim.ToLower = "stonewall", "TKM", dr("code").ToString)}
        Me.ddlAgency.DataSource = qry.ToList
        Me.ddlAgency.DataValueField = "agencyid"
        Me.ddlAgency.DataTextField = "code"
        Me.ddlAgency.DataBind()
    End Sub

    Private Function GetReportData(ByVal CompanyIds As String, ByVal AgencyIds As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("companyids", SqlDbType.VarChar)
        param.Value = CompanyIds
        params.Add(param)

        Dim selectedagencies As String() = (From item As ListItem In ddlAgency.Items Where item.Selected Select item.Value).ToArray
        param = New SqlParameter("agencyids", SqlDbType.VarChar)
        param.Value = AgencyIds
        params.Add(param)

        Return SqlHelper.GetDataTable("stp_GetActiveSettlements_Report", CommandType.StoredProcedure, params.ToArray)
    End Function

    Private Sub BindGrid(ByVal SortField As String, ByVal SortDirection As SortDirection)
        Dim dt As DataTable = GetReportData(ViewState("companies").ToString, ViewState("agencies").ToString)
        Dim dv As New DataView(dt)
        ViewState("sortfield") = SortField
        ViewState("sortdirection") = CInt(SortDirection)
        dv.Sort = String.Format("{0} {1}", SortField, IIf(SortDirection = SortDirection.Ascending, "ASC", "DESC"))
        Me.grdReport.DataSource = dv
        Me.grdReport.DataBind()
        If dv.Count > 0 Then SetColumnSortIcon(SortField, SortDirection)
    End Sub

    Private Sub SetColumnSortIcon(ByVal SortField As String, ByVal SortDirection As SortDirection)
        For Each col As DataControlField In grdReport.Columns
            If col.SortExpression.Trim.ToLower = SortField.ToLower Then
                grdReport.HeaderRow.Cells(grdReport.Columns.IndexOf(col)).CssClass = IIf(SortDirection = WebControls.SortDirection.Ascending, "sorted sortedAsc", "sorted sortedDesc")
            Else
                grdReport.HeaderRow.Cells(grdReport.Columns.IndexOf(col)).CssClass = ""
            End If
        Next
    End Sub

    Protected Sub lnkView_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkView.Click
        Try
            Dim companies As String = String.Join(",", (From item As ListItem In ddlCompany.Items Where item.Selected Select item.Value).ToArray)
            If companies.Trim.Length = 0 Then Throw New Exception("Please select a law firm.")
            Dim agencies As String = String.Join(",", (From item As ListItem In ddlAgency.Items Where item.Selected Select item.Value).ToArray)
            If agencies.Trim.Length = 0 Then Throw New Exception("Please select an agency")
            ViewState("companies") = companies
            ViewState("agencies") = agencies
            grdReport.PageIndex = 0
            BindGrid("LawFirm", SortDirection.Ascending)
        Catch ex As Exception
            ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "reporterror", String.Format("AlertModal({{message: '{0}', title: 'Error', type: 'error' ,width: 300, height: 30}});", ex.Message.Replace("'", "")), True)
        End Try
    End Sub

    Protected Sub grdReport_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles grdReport.PageIndexChanging
        grdReport.PageIndex = e.NewPageIndex
        BindGrid(ViewState("sortfield").ToString, CInt(ViewState("sortdirection").ToString))
    End Sub

    Protected Sub grdReport_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles grdReport.Sorting
        Dim sortDirection As SortDirection = e.SortDirection
        If Not ViewState("sortfield") Is Nothing Then
            If Not ViewState("sortdirection") Is Nothing AndAlso ViewState("sortfield").ToString.Trim.ToLower = e.SortExpression.Trim.ToLower Then
                sortDirection = IIf(CInt(ViewState("sortdirection").ToString) = sortDirection.Ascending, sortDirection.Descending, sortDirection.Ascending)
            End If
        End If
        BindGrid(e.SortExpression, sortDirection)
    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        If ViewState("companies") Is Nothing OrElse ViewState("agencies") Is Nothing Then Exit Sub
        Dim dt As DataTable = GetReportData(ViewState("companies").ToString, ViewState("agencies").ToString)
        Dim dv As New DataView(dt)
        dv.Sort = String.Format("{0} {1}", ViewState("sortfield"), IIf(CInt(ViewState("sortdirection")) = SortDirection.Ascending, "ASC", "DESC"))
        Dim xdoc As XDocument = New XDocument( _
                  New XElement("table", _
                      New XElement("thead", _
                          New XElement("tr", _
                              New XElement("th", "Law Firm"), _
                              New XElement("th", "Block"), _
                              New XElement("th", "File #"), _
                              New XElement("th", "Cred. Account #"), _
                              New XElement("th", "Last Pmt."), _
                              New XElement("th", "Last Pmt. Amount"), _
                              New XElement("th", "Monthly Deposit"), _
                              New XElement("th", "Maint. Fee"))), _
                      New XElement("tbody", _
                          From r As DataRowView In dv _
                          Select New XElement("tr", _
                                  New XElement("td", r("LawFirm").ToString()), _
                                  New XElement("td", r("Block").ToString()), _
                                  New XElement("td", r("Client").ToString()), _
                                  New XElement("td", String.Format("""{0}""", r("AccountNumber").ToString())), _
                                  New XElement("td", String.Format("{0:yyyy/MM/dd}", r("LastPaymentDate"))), _
                                  New XElement("td", String.Format("{0:c}", r("LastPmtAmount"))), _
                                  New XElement("td", String.Format("{0:c}", r("DepositAmount"))), _
                                  New XElement("td", String.Format("{0:c}", r("MonthlyFee")))))))


        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.ContentType = "application/ms-excel"
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=ActiveClients.xls")
        HttpContext.Current.Response.Write(xdoc.ToString())
        HttpContext.Current.Response.End()
    End Sub
End Class
