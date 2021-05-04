
Partial Class research_queries_financial_default
    Inherits PermissionPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(tblBody, c, "Research-Metrics-Financial")
        AddControl(trComparison, c, "Research-Metrics-Financial-Commission Comparison")
    End Sub
End Class
