Imports Drg.Util.DataHelpers
Imports Drg.Util.DataAccess

Partial Class research_reports_financial_default
    Inherits PermissionPage

#Region "Variables"
    Private UserID As Integer
    Public AgencyID As Integer
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Integer.TryParse(DataHelper.FieldLookup("tblAgency", "AgencyID", "UserID = " + UserID.ToString()), AgencyID) Then
            AgencyID = 0
            trInitialAgency.Visible = False
        End If
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(trMy, c, "Research-Reports-Financial-Service Fees-My Service Fees")
        AddControl(trAll, c, "Research-Reports-Financial-Service Fees-All Service Fees")
        AddControl(trAgency, c, "Research-Reports-Financial-Service Fees-Agency")

        AddControl(trBatchPayments, c, "Research-Reports-Financial-Commission-Batch Payments")
        AddControl(trBatchPaymentsSummary, c, "Research-Reports-Financial-Commission-Batch Payments Summary")
        AddControl(trCIDCommissionPayments, c, "Research-Reports-Financial-Commission-Client Intake Payments")
        'AddControl(trPayRates, c, "Research-Reports-Financial-Commission-Pay Rates")
        'AddControl(trPayDirection, c, "Research-Reports-Financial-Commission-Pay Direction")

        AddControl(tblServiceFees, c, "Research-Reports-Financial-Service Fees")
        AddControl(tblCommission, c, "Research-Reports-Financial-Commission")
        AddControl(tblBody, c, "Research-Reports-Financial")
        AddControl(tblAccounting, c, "Research-Reports-Financial-Accounting")
        AddControl(trSettlementFeesPaid, c, "Research-Reports-Financial-Settlement Fees Paid")
        AddControl(trNonDepositReport, c, "Research-Reports-Financial-Non Deposit Report")
        AddControl(tblMarketing, c, "Research-Reports-Financial-Marketing")
        AddControl(tblMisc, c, "Research-Reports-Financial-Miscellaneous")
    End Sub
End Class
