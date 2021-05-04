Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Partial Class clients_client_creditors_accounts_action_verify
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Dim ClientID As Integer = StringHelper.ParseInt(Request.QueryString("id"))
        'Dim AccountID As Integer = StringHelper.ParseInt(Request.QueryString("aid"))
        'Dim VerifiedAmount As Double = StringHelper.ParseDouble(Request.QueryString("a"))

        'Dim SetupFeePercentage As Double = StringHelper.ParseDouble(DataHelper.FieldLookup("tblAccount", "SetupFeePercentage", "AccountID = " & AccountID))
        'Dim CurrentFee As Double = AccountHelper.GetSumRetainerFees(AccountID)
        'Dim AppropriateFee As Double = Math.Round(VerifiedAmount * SetupFeePercentage, 2)

        'lblAmount.Text = VerifiedAmount.ToString("#,##0.00")
        'lblAppropriateFee.Text = AppropriateFee.ToString("#,##0.00")
        'lblCurrentFee.Text = CurrentFee.ToString("#,##0.00")

        'If AppropriateFee = CurrentFee Then
        '    lblAction.Text = "No adjustments will be made."
        'Else

        '    Dim Direction As String
        '    Dim Difference As Double = Math.Abs(AppropriateFee - CurrentFee)

        '    If AppropriateFee > CurrentFee Then
        '        Direction = "increase"
        '    ElseIf AppropriateFee < CurrentFee Then
        '        Direction = "decrease"
        '    End If

        '    Dim NumRetainers As Integer = DataHelper.FieldCount("tblRegister", "RegisterID", "EntryTypeID = 2 AND AccountID = " & AccountID)

        '    If NumRetainers > 0 Then 'at least one already assessed
        '        lblAction.Text = "A fee adjustment for " & Difference.ToString("c") & " will be made to " & Direction & " the existing retainer fee."
        '    Else
        '        lblAction.Text = "A new retainer fee will be assessed for " & Difference.ToString("c") & "."
        '    End If

        'End If

    End Sub
End Class