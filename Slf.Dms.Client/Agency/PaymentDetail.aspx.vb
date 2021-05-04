Imports Drg.Util.DataAccess

Partial Class Agency_PaymentDetail
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            lblInfo.Text = Request.QueryString("payment").Replace("other", "All Other Payments").Replace("first", "First Payments") & " > " & Request.QueryString("type") & " > " & Request.QueryString("datepartname")
            ugDetail.Columns(0).IsGroupByColumn = True 'Recipient
        End If
    End Sub
End Class
