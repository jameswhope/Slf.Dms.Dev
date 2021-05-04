
Partial Class research_default
    Inherits PermissionPage



    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(aMetrics, c, "Research-Metrics")
        AddControl(aQueries, c, "Research-Queries")
        AddControl(aReports, c, "Research-Reports")
        AddControl(aNegotiationInterface, c, "Research-NegotiationInterface")
    End Sub

End Class
