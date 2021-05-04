Option Explicit On

Partial Class email_email
    Inherits PermissionMasterPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlMenu, c, "Email")
        AddControl(pnlBody, c, "Email")
        AddControl(tdSearch, c, "Send Email")
    End Sub
End Class