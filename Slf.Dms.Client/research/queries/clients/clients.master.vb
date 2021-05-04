
Partial Class research_queries_clients_clients
    Inherits PermissionMasterPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(cphBody, c, "Research-Queries-Clients")
    End Sub
End Class

