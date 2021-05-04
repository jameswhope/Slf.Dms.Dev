Imports System.Data
Imports System.Data.SqlClient

Partial Class mobile_financial_kpi_report
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadGrid()
            If Request.QueryString("rev") = "1" Then
                hTitle.InnerHtml = "Rev-Share KPI"
            End If
        End If
    End Sub

    Private Sub LoadGrid()
        Dim ds As DataSet
        Dim dv As DataView
        Dim parent(1) As DataColumn
        Dim child(1) As DataColumn

        ds = SqlHelper.GetDataSet("exec stp_KPIReport " & Request.QueryString("rev"), CommandType.Text)
        ds.Relations.Add("Relation1", ds.Tables(0).Columns("StartEnd"), ds.Tables(1).Columns("StartEnd"))

        parent(0) = ds.Tables(1).Columns("StartEnd")
        parent(1) = ds.Tables(1).Columns("ConnectDate")
        child(0) = ds.Tables(2).Columns("StartEnd")
        child(1) = ds.Tables(2).Columns("ServiceFee")
        ds.Relations.Add("Relation3", parent, child)

        'ds = SqlHelper.GetDataSet("stp_KPIReport")
        'ds.Relations.Add("Relation1", ds.Tables(0).Columns("StartEnd"), ds.Tables(1).Columns("StartEnd"))
        'ds.Relations.Add("Relation2", ds.Tables(0).Columns("StartEnd"), ds.Tables(2).Columns("StartEnd")) '30-60-90
        'ds.Relations.Add("Relation3", ds.Tables(1).Columns("ConnectDate"), ds.Tables(3).Columns("ConnectDate")) '30-60-90 by day

        dv = ds.Tables(0).DefaultView

        Accordion1.DataSource = dv
        Accordion1.DataBind()
        Accordion1.SelectedIndex = -1

        lblLastMod.Text = "Last Updated: " & CStr(SqlHelper.ExecuteScalar("select top 1 lastrefresh from tblKPI order by lastrefresh desc", CommandType.Text))
    End Sub

    Protected Sub accByDay_ItemDataBound(ByVal sender As Object, ByVal e As AjaxControlToolkit.AccordionItemEventArgs)
        If e.ItemType = AccordionItemType.Header Then
            Dim hdn As HiddenField = TryCast(e.AccordionItem.FindControl("hdnConnectDate"), HiddenField)
            If Not IsNumeric(hdn.Value) Then
                Dim img As HtmlImage = TryCast(e.AccordionItem.FindControl("imgPlus"), HtmlImage)
                img.Visible = False
            End If
        End If
    End Sub
End Class
