Option Explicit On

Partial Class deleteholder
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Title = "Delete " & Request.QueryString("t")
        ifrmBody.Attributes("src") = "delete.aspx" & Request.Url.Query

    End Sub
End Class