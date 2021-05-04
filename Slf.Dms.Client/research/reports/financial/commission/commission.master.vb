
Partial Class research_reports_financial_commission_commission
    Inherits PermissionMasterPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(cphBody, c, "Research-Reports-Financial-Commission")
    End Sub
End Class

