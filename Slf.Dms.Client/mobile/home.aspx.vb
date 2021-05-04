Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers


Partial Class mobile_home
    Inherits System.Web.UI.Page

    Dim UserID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Page.IsPostBack Then
            hWelcome.InnerHtml = "Welcome, " & UserHelper.GetName(UserID)
        End If
    End Sub

    Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLogout.Click
        FormsAuthentication.SignOut()
        Response.Redirect("login.aspx?action=logout")
    End Sub

    Public Function GetPendingClientsCount() As String
        Dim companyid As Integer = -1
        Return ClientHelper2.GetPendingLeadsCount(companyid, UserID)
    End Function

End Class
