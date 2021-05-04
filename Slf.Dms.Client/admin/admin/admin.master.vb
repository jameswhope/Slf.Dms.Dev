Option Explicit On

Partial Class admin_admin
    Inherits PermissionMasterPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlMenu, c, "Admin")
        AddControl(pnlBody, c, "Admin")
        AddControl(tdSearch, c, "Client Search")
        AddControl(pnlUsers, c, "Admin-Users")
        AddControl(pnlSettings, c, "Admin-Settings")
        AddControl(pnlAttorneys, c, "Admin-Attorneys")
        'AddControl(pnlBankImport, c, "Admin-Bank Import")
        'AddControl(pnlDocument, c, "Admin-Documents")
    End Sub
End Class