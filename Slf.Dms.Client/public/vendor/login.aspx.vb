Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient

Partial Class public_vendor_login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.Page.SetFocus(txtUsername)
    End Sub

    Protected Sub lnkLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLogin.Click
        Dim params As New List(Of SqlParameter)

        params.Add(New SqlParameter("username", txtUsername.Text))
        params.Add(New SqlParameter("password", txtPassword.Text))

        Dim vendorID As Integer = CInt(SqlHelper.ExecuteScalar("stp_VendorLogin", , params.ToArray))

        If vendorID > 0 Then
            Session.Add("vendor", txtUsername.Text.ToUpper)
            Session.Add("vendorID", vendorID)
            Response.Redirect("lead-analysis.aspx", False)
        Else
            lblError.Text = "Invalid username/password."
        End If
    End Sub
End Class
