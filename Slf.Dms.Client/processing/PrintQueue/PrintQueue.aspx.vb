Imports Drg.Util.DataAccess

Partial Class processing_PrintQueue_PrintQueue
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        PrintQueueControl1.CurrentUserID = DataHelper.Nz_int(Page.User.Identity.Name)
    End Sub
End Class
