Imports Drg.Util.DataAccess

Partial Class research_metrics_default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Redirect("~/research/metrics/financial/")
    End Sub
End Class
