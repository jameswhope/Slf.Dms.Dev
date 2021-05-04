Option Explicit On

Partial Class admin_default
    Inherits PermissionPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(aUsers, c, "Admin-Users")
        AddControl(aSettings, c, "Admin-Settings")
    End Sub
End Class