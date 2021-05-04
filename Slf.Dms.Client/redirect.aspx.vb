Imports Drg.Util.DataAccess

Partial Class redirect
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim UserGroupId As Integer = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupId", "UserId = " & DataHelper.Nz_int(Page.User.Identity.Name)))
        Dim MainPage As String = DataHelper.FieldLookup("tblUserGroup", "MainPage", "UserGroupID = " & UserGroupId)

        If MainPage <> "" Then
            Response.Redirect(MainPage, False)
        Else
            Response.Redirect("default.aspx", False)
        End If
    End Sub
End Class
