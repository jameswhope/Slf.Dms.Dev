Imports Drg.Util.DataAccess

Partial Class research_queries_default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Redirect("~/research/queries/clients/")
    End Sub
End Class
