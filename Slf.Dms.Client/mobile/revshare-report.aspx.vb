Imports System.Data

Partial Class mobile_revshare_report
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadRevShare()
        End If
    End Sub

    Private Sub LoadRevShare()
        Dim ds As DataSet
        Dim dv As DataView
        Dim parent(1) As DataColumn
        Dim child(1) As DataColumn

        ds = SqlHelper.GetDataSet("stp_RevShareReport")
        ds.Relations.Add("Relation1", ds.Tables(0).Columns("monthyr"), ds.Tables(1).Columns("monthyr"))

        parent(0) = ds.Tables(1).Columns("monthyr")
        parent(1) = ds.Tables(1).Columns("servicefee")
        child(0) = ds.Tables(2).Columns("monthyr")
        child(1) = ds.Tables(2).Columns("servicefee")
        ds.Relations.Add("Relation2", parent, child)

        dv = ds.Tables(0).DefaultView

        Accordion1.DataSource = dv
        Accordion1.DataBind()
        Accordion1.SelectedIndex = -1

        lblLastMod.Text = CStr(SqlHelper.ExecuteScalar("select top 1 lastrefresh from tblrevsharereport order by lastrefresh desc", CommandType.Text))
    End Sub

End Class
