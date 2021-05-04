
Partial Class research_queries_financial_servicefees_servicefees
    Inherits PermissionMasterPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(cphBody, c, "Research-Queries-Financial-Service Fees")
        AddControl(cphBodyAgency, c, "Research-Queries-Financial-Service Fees-Agency")
    End Sub
End Class

