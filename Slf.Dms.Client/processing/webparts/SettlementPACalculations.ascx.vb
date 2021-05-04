Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess

Partial Class processing_webparts_SettlementPACalculations
    Inherits System.Web.UI.UserControl

    Private PmtScheduleId As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    End Sub

    Public Sub LoadSettlementInfo(ByVal _pmtScheduleId As Integer)
        Dim dtsettinfo As DataTable = PaymentScheduleHelper.GetSettlementInfoPA(_pmtScheduleId)

        If dtsettinfo.Rows.Count = 0 Then Throw New Exception("Settlement information could not be found")

        Dim settinfo As DataRow = dtsettinfo.Rows(0)
        Me.lblCurrentSDA.Text = FormatCurrency(settinfo("SDABalance"), 2)
        Me.lblAvailSDABal.Text = FormatCurrency(settinfo("RegisterBalance"), 2)
        Me.lblPFOBalance.Text = FormatCurrency(settinfo("PFOBalance"), 2)
        Me.lblDueDate.Text = CDate(settinfo("PaymentDueDate")).ToString("MM/dd/yyyy")
        Me.lblAmtSent.Text = FormatCurrency(settinfo("SettlementAmtBeingSent"), 2)
        Me.lblAmtOwed.Text = FormatCurrency(settinfo("SettlementAmtStillOwed"), 2)
        Me.lblBankReserve.Text = FormatCurrency(settinfo("BankReserve"), 2)
        Me.lblFundsOnHold.Text = FormatCurrency(settinfo("FrozenAmount"), 2)
        If settinfo("SettlementAmtStillOwed") <> 0 Then
            lblAmtOwed.ForeColor = System.Drawing.Color.Red
        End If
        Me.lblSettlementFee.Text = FormatCurrency(settinfo("SettlementFee"), 2)
        Me.lblAdjustedFee.Text = FormatCurrency(settinfo("AdjustedSettlementFee"), 2)
        Me.lblOvernightDeliveryCost.Text = FormatCurrency(settinfo("OvernightDeliveryAmount"), 2)
        Me.lblSettlementCost.Text = FormatCurrency(settinfo("SettlementCost"), 2)
        Me.lblSettlementFee_AmtAvailable.Text = FormatCurrency(settinfo("SettlementFeeAmtAvailable"), 2)
        Me.lblSettlementFee_AmtBeingPaid.Text = FormatCurrency(settinfo("SettlementFeeAmtBeingPaid"), 2)
        Me.lblSettlementFee_AmtStillOwed.Text = FormatCurrency(settinfo("SettlementFeeAmtStillOwed"), 2)
        Me.lblPmtAmt.Text = FormatCurrency(settinfo("PaymentAmount"), 2)
        Me.lblTotalPaid.Text = FormatCurrency(settinfo("TotalPaidToCreditor"), 2)
        Me.lblBalanceOwed.Text = FormatCurrency(settinfo("TotalStillOwedToCreditor"), 2)
        Me.lblSettlementFeePaid.Text = FormatCurrency(settinfo("SettlementFeesPaid"), 2)
        Me.lblSettlementFeeOwed.Text = FormatCurrency(settinfo("SettlementFeesOwed"), 2)
        Me.lblSettlementAmt.Text = FormatCurrency(settinfo("SettlementAmount"), 2)
        Me.lblDeliveryMethod.Text = settinfo("DeliveryMethod")
        lblSpecialInstructions.Text = settinfo("SpecialInstructions")
        Dim tbl As DataTable = SqlHelper.GetDataTable("stp_GetSettlementCreditorInfo", CommandType.StoredProcedure, New SqlParameter() {New SqlParameter("@accountid", settinfo("AccountID"))})
        lblCurCreditor.Text = tbl.Rows(0)("creditorname").ToString
        lblOrigCreditor.Text = tbl.Rows(0)("forcreditorname").ToString
        lblAcctNo.Text = tbl.Rows(0)("accountnumber").ToString
        lblRefNo.Text = tbl.Rows(0)("referencenumber").ToString

        Dim dsExpected As New DataSet
        dsExpected = ClientHelper2.ExpectedDeposits(settinfo("ClientID"), settinfo("PaymentDueDate"))
        gvExpected.DataSource = dsExpected.Tables(1)
        gvExpected.DataBind()
    End Sub

End Class
