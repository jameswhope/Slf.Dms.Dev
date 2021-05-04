Imports System
Imports System.IO
Imports System.Text

Partial Class research_reports_dialer_default
    Inherits PermissionPage

    Public encUserID As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim encod As Encoding = Encoding.Default
        encUserID = Convert.ToBase64String(encod.GetBytes(Page.User.Identity.Name))
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(tblBody, c, "Research-Reports-Dialer")
    End Sub
End Class