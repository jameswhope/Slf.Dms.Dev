Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess

Partial Class processing_webparts_SettlementCalculations
    Inherits System.Web.UI.UserControl

    Private SettlementID As Integer
    Private Information As SettlementMatterHelper.SettlementInformation

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Not Request.QueryString("id") Is Nothing Then
                SettlementID = SettlementMatterHelper.GetSettlementFromTask(Integer.Parse(Request.QueryString("id")))
                Me.LoadSettlementInfo(SettlementID)
            End If
        End If
    End Sub

    Public Sub LoadSettlementInfo(ByVal _settlementId As Integer)
        SettlementID = _settlementId
        Information = SettlementMatterHelper.GetSettlementInformation(_settlementId)

        lblOriginalBalance.Text = FormatCurrency(Information.CreditorOriginalBalance, 2)
        Me.lblCurrentSDA.Text = FormatCurrency(Information.SDABalance, 2)
        Me.lblAvailSDABal.Text = FormatCurrency(Information.RegisterBalance, 2)
        Me.lblPFOBalance.Text = FormatCurrency(Information.PFOBalance, 2)
        Me.lblCurrentBalance.Text = FormatCurrency(Information.CreditorCurrentBalance, 2)
        Me.lblDueDate.Text = Information.SettlementDueDate.ToString("MM/dd/yyyy")
        Me.lblAmtSent.Text = FormatCurrency(Information.SettlementAmountSent, 2)
        Me.lblAmtOwed.Text = FormatCurrency(Information.SettlementAmountOwed, 2)
        Me.lblBankReserve.Text = FormatCurrency(Information.BankReserve, 2)
        Me.lblFundsOnHold.Text = FormatCurrency(Information.FrozenAmount, 2)
        If Information.SettlementAmountOwed <> 0 Then
            lblAmtOwed.ForeColor = System.Drawing.Color.Red
        End If
        Me.trDownPayment.Visible = Information.IsPaymentArrangement
        Me.trStillOwedToCreditor.Visible = Information.IsPaymentArrangement
        txtDownPaymentAmt.Text = FormatCurrency(Information.DownPayment, 2)
        txtStillOwedToCreditor.Text = FormatCurrency(Information.SettlementAmount - Information.DownPayment, 2)
        Me.lblSettlementSavings.Text = FormatCurrency(Information.SettlementSavings, 2)
        Me.lblSettlementFee.Text = FormatCurrency(Information.SettlementFee, 2)
        Me.lblAdjustedFee.Text = FormatCurrency(Information.AdjustedSettlementFee, 2)
        Me.lblSettlementFeeCredit.Text = FormatCurrency(Information.SettlementFeeCredit, 2)
        Me.lblOvernightDeliveryCost.Text = FormatCurrency(Information.DeliveryAmount, 2)
        Me.lblSettlementCost.Text = FormatCurrency(Information.SettlementCost, 2)
        Me.lblSettlementFee_AmtAvailable.Text = FormatCurrency(Information.SettlementFeeAmountAvailable, 2)
        Me.lblSettlementFee_AmtBeingPaid.Text = FormatCurrency(Information.SettlementFeeAmountBeingPaid, 2)
        Me.lblSettlementFee_AmtStillOwed.Text = FormatCurrency(Information.SettlementFeeAmountOwed, 2)

        Me.txtSettlementAmt.Text = FormatCurrency(Information.SettlementAmount, 2)
        'Me.txtSettlementPercent.Text = Information.SettlementPercent.ToString() & "%"
        Me.lblDeliveryMethod.Text = Information.DeliveryMethod
        lblSpecialInstructions.Text = Information.SpecialInstructions
        Dim IsPAByClient As Boolean = SettlementMatterHelper.IsPAByClient(_settlementId)
        Using si As AttachSifHelper._AttachSettlementInfo = AttachSifHelper.GetSettlementInfo(_settlementId)
            If si.IsClientStipulation Then
                lblSpecialInstructions.Text += IIf(lblSpecialInstructions.Text.Trim.Length > 0, "<br/>", "") & "This settlement requires a Client Stipulation!"
            End If
            If IsPAByClient Then
                lblSpecialInstructions.Text += IIf(lblSpecialInstructions.Text.Trim.Length > 0, "<br/>", "") & "Client is responsible to make the payments."
            End If
        End Using

        Dim tbl As DataTable = SqlHelper.GetDataTable("stp_GetSettlementCreditorInfo", CommandType.StoredProcedure, New SqlParameter() {New SqlParameter("accountid", Information.AccountID)})
        lblCurCreditor.Text = tbl.Rows(0)("creditorname").ToString
        lblOrigCreditor.Text = tbl.Rows(0)("forcreditorname").ToString
        lblAcctNo.Text = tbl.Rows(0)("accountnumber").ToString
        lblRefNo.Text = tbl.Rows(0)("referencenumber").ToString

        Dim dsExpected As New DataSet
        dsExpected = ClientHelper2.ExpectedDeposits(Information.ClientID, Information.SettlementDueDate)
        gvExpected.DataSource = dsExpected.Tables(1)
        gvExpected.DataBind()
    End Sub

End Class
