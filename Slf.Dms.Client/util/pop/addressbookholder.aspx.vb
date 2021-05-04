Option Explicit On

Partial Class util_pop_addressbookholder
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ifrmBody.Attributes("src") = "addressbook.aspx" & Request.Url.Query

    End Sub
End Class