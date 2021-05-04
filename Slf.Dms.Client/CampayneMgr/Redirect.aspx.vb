
Partial Class Redirect
    Inherits System.Web.UI.Page

    Protected Sub Redirect_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Dim u As UserHelper.UserObj = UserHelper.GetUserObject(Page.User.Identity.Name)
        UserHelper.RedirectUser(u.UserTypeId, u.UserId)
    End Sub
End Class
