Option Explicit On

Partial Class util_pop_message
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Title = Request.QueryString("t")
        lblMessage.Text = Request.QueryString("m")

    End Sub
End Class