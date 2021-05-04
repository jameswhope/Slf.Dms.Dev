
Partial Class util_pop_negotiationfieldholder
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ifrmBody.Attributes("src") = "negotiationfield.aspx" & Request.Url.Query
    End Sub
End Class