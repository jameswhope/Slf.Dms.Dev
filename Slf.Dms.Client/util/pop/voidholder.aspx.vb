Option Explicit On

Partial Class util_pop_voidholder
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Title = "Void " & Request.QueryString("t")
        ifrmBody.Attributes("src") = "void.aspx" & Request.Url.Query

    End Sub
End Class