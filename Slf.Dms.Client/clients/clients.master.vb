
Partial Class clients_clients
    Inherits PermissionMasterPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(cphMenu, c, "Clients")
        AddControl(cphBody, c, "Clients")
    End Sub
End Class

