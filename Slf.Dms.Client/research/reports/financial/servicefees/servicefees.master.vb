
Partial Class research_reports_financial_servicefees_servicefees
    Inherits PermissionMasterPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(cphBody, c, "Research-Reports-Financial-Service Fees")
        AddControl(cphBodyagency, c, "Research-Reports-Financial-Service Fees-Agency")
    End Sub
End Class

