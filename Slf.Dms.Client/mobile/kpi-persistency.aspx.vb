Imports System.Data

Partial Class mobile_kpi_persistency
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadPersistency()
        End If
    End Sub

    Private Sub LoadPersistency()
        Dim ds As DataSet
        Dim dv As DataView

        ds = SqlHelper.GetDataSet("stp_KPIPersistency")
        ds.Relations.Add("Relation1", ds.Tables(0).Columns("mthyr"), ds.Tables(1).Columns("mthyr"))

        dv = ds.Tables(0).DefaultView

        Accordion1.DataSource = dv
        Accordion1.DataBind()
        Accordion1.SelectedIndex = -1

        rptFooter.DataSource = ds.Tables(2)
        rptFooter.DataBind()
    End Sub
End Class
