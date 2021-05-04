Imports System
Imports System.Web

Partial Class _error
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Request.QueryString("err") Is Nothing Then
            lblError.Text = Request.QueryString("err").ToString()
        End If
    End Sub
End Class