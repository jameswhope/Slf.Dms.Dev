Imports System.Data

Partial Class research_reports_clients_ClientsByStateDetail
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            aBack.HRef = String.Format("clientsbystate.aspx?companyid={0}&groupid={1}", Request.QueryString("companyid"), Request.QueryString("groupid"))
        End If
    End Sub

    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim dk As DataKey = GridView1.DataKeys(e.Row.RowIndex)
            e.Row.Style("cursor") = "hand"
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#ffffda';")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
            e.Row.Attributes.Add("onclick", String.Format("javascript:window.location.href='../../../clients/client/?id={0}';", dk(0)))
        End If
    End Sub
End Class
