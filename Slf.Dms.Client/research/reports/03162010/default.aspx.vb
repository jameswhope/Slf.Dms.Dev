Imports Drg.Util.DataAccess

Partial Class research_reports_default
    Inherits System.Web.UI.Page

    Private UserId As Integer
    Private UserTypeId As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Redirect("~/research/reports/clients/")
    End Sub
End Class
