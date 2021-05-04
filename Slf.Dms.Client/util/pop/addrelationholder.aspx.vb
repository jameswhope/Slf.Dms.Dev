Option Explicit On

Partial Class util_pop_addrelationholder
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ifrmBody.Attributes("src") = "addrelation.aspx" & Request.Url.Query

    End Sub
End Class