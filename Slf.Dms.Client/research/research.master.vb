
Partial Class research_research
    Inherits PermissionMasterPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(cphBody, c, "Research")
        AddControl(pnlMenu, c, "Research")
        AddControl(pnlMenuAgent, c, "Research-Agency Menu")
        AddControl(pnlMetrics, c, "Research-Metrics")
        AddControl(pnlQueries, c, "Research-Queries")
        AddControl(pnlReports, c, "Research-Reports")
        AddControl(pnlNegotiationInterface, c, "Research-NegotiationInterface")
        AddControl(tdSearch, c, "Client Search")

    End Sub
End Class

