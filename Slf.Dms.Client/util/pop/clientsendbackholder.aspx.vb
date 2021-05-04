Option Explicit On

Partial Class util_pop_clientsendbackholder
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Title = "Send Back to Agency"
        ifrmBody.Attributes("src") = "clientsendback.aspx" & Request.Url.Query

    End Sub
End Class