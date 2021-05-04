Imports System
Imports System.IO
Imports System.Text

Partial Class research_reports_clients_default
    Inherits PermissionPage

    Public encUserID As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim encod As Encoding = Encoding.Default
        encUserID = Convert.ToBase64String(encod.GetBytes(Page.User.Identity.Name))
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(tblBody, c, "Research-Reports-Clients")
        AddControl(tblTransactions, c, "Research-Reports-Clients-Transactions")
        AddControl(trDepositDaysAgo, c, "Research-Reports-Clients-Transactions-Deposit Days Ago")
        AddControl(tblMediation, c, "Research-Reports-Clients-Mediation")
        AddControl(trAccountsOverPercentage, c, "Research-Reports-Clients-Mediation-Accounts Over Percentage")
        AddControl(trMediatorReassignment, c, "Research-Reports-Clients-Mediation-Mediator Reassignment")
        AddControl(trMyAssignments, c, "Research-Reports-Clients-Mediation-My Assignments")
        AddControl(trMyAssignments_ByCreditor, c, "Research-Reports-Clients-Mediation-My Assignments")
        AddControl(tblClientServices, c, "Research-Reports-Clients-ClientServices")
        AddControl(trNegotiationListUnsorted, c, "Research-Reports-Financial-NegotiationListUnsorted")
    End Sub
End Class