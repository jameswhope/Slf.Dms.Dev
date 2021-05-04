
Partial Class research_queries_financial_accounting_accounting
    Inherits PermissionMasterPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(cphBody, c, "Research-Queries-Financial-Accounting")
    End Sub
End Class

