
Partial Class clients_default
    Inherits PermissionPage


    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlEnrollNewClient, c, "Clients-Client Enrollment")
        AddControl(tdSearch, c, "Client Search")
        AddControl(pnlImportClient, c, "Clients-Client Import")
        'AddControl(pnlClientsAnalysis, c, "Clients-Analysis")
        AddControl(pnlRedirectAgency, c, "Redirection-Agency")
        AddControl(pnlRedirectAttorney, c, "Redirection-Attorney")
    End Sub
End Class