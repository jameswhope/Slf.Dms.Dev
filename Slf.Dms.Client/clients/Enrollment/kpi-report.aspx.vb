Imports System.Data
Imports System.Data.SqlClient

Partial Class mobile_financial_kpi_report
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadGrid()
            'LoadPersistency()
        End If
    End Sub

    'Private Sub LoadPersistency()
    '    Dim ds As DataSet
    '    Dim dv As DataView

    '    ds = SqlHelper.GetDataSet("stp_KPIPersistency")
    '    ds.Relations.Add("Relation1", ds.Tables(0).Columns("mthyr"), ds.Tables(1).Columns("mthyr"))

    '    dv = ds.Tables(0).DefaultView

    '    Accordion1.DataSource = dv
    '    Accordion1.DataBind()
    '    Accordion1.SelectedIndex = -1
    'End Sub

    Private Sub LoadGrid()
        Dim ds As DataSet
        Dim dv As DataView

        ds = SqlHelper.GetDataSet("stp_KPIReport")
        ds.Relations.Add("Relation1", ds.Tables(0).Columns("StartEnd"), ds.Tables(1).Columns("StartEnd"))
        ds.Relations.Add("Relation2", ds.Tables(0).Columns("StartEnd"), ds.Tables(2).Columns("StartEnd")) '30-60-90
        ds.Relations.Add("Relation3", ds.Tables(1).Columns("ConnectDate"), ds.Tables(3).Columns("ConnectDate")) '30-60-90 by day

        dv = ds.Tables(0).DefaultView

        Accordion1.DataSource = dv
        Accordion1.DataBind()
        Accordion1.SelectedIndex = -1

        lblLastMod.Text = "Last Updated: " & CStr(SqlHelper.ExecuteScalar("select top 1 lastrefresh from tblKPI order by lastrefresh desc", CommandType.Text))
    End Sub
End Class
