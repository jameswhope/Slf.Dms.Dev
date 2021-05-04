
Partial Class research_queries_financial_default
    Inherits PermissionPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(tblBody, c, "Research-Queries-Financial")

        AddControl(tblAccounting, c, "Research-Queries-Financial-Accounting")
        AddControl(trGeneralClearingAccountTransfers, c, "Research-Queries-Financial-Accounting-General Clearing Account Transfer")
        AddControl(trChecksToPrint, c, "Research-Queries-Financial-Accounting-Checks To Print")

        AddControl(tblCommission, c, "Research-Queries-Financial-Commission")
        AddControl(trBatchPayments, c, "Research-Queries-Financial-Commission-Batch Payments")

        AddControl(tblServiceFees, c, "Research-Queries-Financial-Service Fees")
        AddControl(trMy, c, "Research-Queries-Financial-Service Fees-My Service Fees")
        AddControl(trAll, c, "Research-Queries-Financial-Service Fees-All Service Fees")
        AddControl(trByAgency, c, "Research-Queries-Financial-Service Fees-Service Fees By Agency")
        AddControl(trRemainingReceivables, c, "Research-Queries-Financial-Service Fees-Remaining Receivables")
    End Sub
End Class
