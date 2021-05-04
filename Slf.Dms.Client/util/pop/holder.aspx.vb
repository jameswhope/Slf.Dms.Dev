Option Explicit On

Partial Class util_pop_holder
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Title = Request.QueryString("t")
        ifrmBody.Attributes("src") = Request.QueryString("p") & Request.Url.Query

    End Sub
End Class