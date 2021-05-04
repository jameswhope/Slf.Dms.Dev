Imports Drg.Util.DataAccess
Partial Class research_negotiation_preview_Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.pvg1.UserID = DataHelper.Nz_int(Page.User.Identity.Name)
    End Sub
End Class
