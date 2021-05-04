Option Explicit On

Imports Drg.Util.Helpers

Partial Class clients_client_creditors_default
    Inherits System.Web.UI.Page

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

        Dim qs As String = New QueryStringBuilder(Request.Url.Query).QueryString

        If qs.Length > 0 Then
            qs = "?" & qs
        End If

        Response.Redirect("~/clients/client/creditors/accounts/" & qs)

    End Sub
End Class