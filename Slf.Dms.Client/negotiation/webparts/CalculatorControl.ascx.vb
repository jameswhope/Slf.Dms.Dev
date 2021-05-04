Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing.Imaging
Imports System.Drawing.Printing
Imports System.IO
Imports System.Linq

Imports GrapeCity.ActiveReports
Imports GrapeCity.ActiveReports.Export.Pdf

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports LexxiomLetterTemplates

Imports NegotiationCalcHelper

Imports ReportsHelper

Partial Class negotiation_webparts_CalculatorControl
    Inherits System.Web.UI.UserControl

    #Region "Events"

    Public Event InsertedOffer(ByVal SettlementID As String, ByVal settlementStatus As String, ByVal dataClientID As String, ByVal accountID As String)

    #End Region 'Events

    #Region "Properties"

    Public Property DataClientID() As String
        Get
            Return ViewState("_DataClientID")
        End Get
        Set(ByVal value As String)
            ViewState("_DataClientID") = value
        End Set
    End Property

    Public Property UserID() As String
        Get
            Return ViewState("_UserID")
        End Get
        Set(ByVal value As String)
            ViewState("_UserID") = value
        End Set
    End Property

    Public Property accountID() As String
        Get
            Return ViewState("_accountID")
        End Get
        Set(ByVal value As String)
            ViewState("_accountID") = value
        End Set
    End Property

    Public Property noteID() As String
        Get
            Return Me.hdnNoteID.Value
        End Get
        Set(ByVal value As String)
            Me.hdnNoteID.Value = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Public Shared Function CreateNewDocumentPathAndName(ByVal rootDir As String, ByVal ClientID As Integer, ByVal strDocTypeID As String, Optional ByVal subFolder As String = "ClientDocs\") As String
        Dim ssql As String = String.Format("SELECT AccountNumber FROM tblClient WHERE ClientID = {0}", ClientID.ToString)
        Dim acctNum As String = SqlHelper.ExecuteScalar(ssql, CommandType.Text)

        Dim ret As String
        ret = rootDir + subFolder + acctNum + "_" + strDocTypeID + "_" + ReportsHelper.GetNewDocID() + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        Return ret
    End Function

    ''' <summary>
    ''' adds business days to date
    ''' </summary>
    ''' <param name="startDate"></param>
    ''' <param name="numDays"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Function AddNBusinessDays(ByVal startDate As DateTime, ByVal numDays As Integer) As DateTime
        If numDays = 0 Then Return New DateTime(startDate.Ticks)

        If numDays < 0 Then Throw New ArgumentException()

        Dim i As Integer
        Dim totalDays As Integer
        Dim businessDays As Integer

        totalDays = 0
        businessDays = 0

        Dim currDate As DateTime
        While businessDays < numDays
            totalDays += 1

            currDate = startDate.AddDays(totalDays)

            If Not (currDate.DayOfWeek = DayOfWeek.Saturday Or currDate.DayOfWeek = DayOfWeek.Sunday) Then
                businessDays += 1
            End If

        End While

        Return currDate
    End Function

    Public Sub CheckStatus(ByVal ClientID As String, ByVal accountID As String)
        Dim strStatus As String = ClientHelper.GetStatus(ClientID)
        Dim strAcctStatus As String = SqlHelper.ExecuteScalar(String.Format("select accountstatusid from tblaccount where accountid = {0}", accountID), CommandType.Text)

        Select Case strStatus.ToLower
            Case "Inactive".ToLower, "Suspended".ToLower, "Cancelled".ToLower, "Completed".ToLower
                Me.ibtnAccept.Enabled = False
                Me.ibtnReject.Enabled = False
            Case Else
                Me.ibtnAccept.Enabled = True
                Me.ibtnReject.Enabled = True
                Select Case strAcctStatus
                    Case 54, 55
                        'only disable if not manager or IT
                        If IsManager(UserID) = False Then
                            Me.ibtnAccept.Enabled = False
                            Me.ibtnReject.Enabled = False
                        End If
                End Select
        End Select
    End Sub

    ''' <summary>
    ''' Insert an offer 
    ''' </summary>
    ''' <param name="OfferStatus"></param>
    ''' <returns>settlement id</returns>
    ''' <remarks>inserts offers accepted/rejected and returns the settlement id</remarks>
    Public Function InsertOffer(ByVal OfferStatus As String) As String
        'retrieve client and creditor id's
        Dim ids As String() = Me.hiddenIDs.Value.Split(":")
        Dim SettID As String = ""
        Dim RegisterBal As Double = System.Double.Parse(Me.lblAvailSDABal.Text, System.Globalization.NumberStyles.Currency) - System.Double.Parse(Me.lblPFOBal.Text, System.Globalization.NumberStyles.Currency)
        Dim settNew As New NegotiationCalcHelper.OfferInformation()
        Dim bPaymentArrangement As Boolean = IIf(hdnIsClientPaymentArrangement.Value = "1", True, False)

        With settNew
            .AccountID = ids(1)
            .ClientID = ids(0)
            .RegisterBalance = RegisterBal

            Dim createdDate As String = SqlHelper.ExecuteScalar(String.Format("select created from tblclient where clientid = {0}", ids(0)), CommandType.Text)

            .SDABalance = System.Double.Parse(lblSDABal.Text, System.Globalization.NumberStyles.Currency)
            .BankReserve = System.Double.Parse(lblReserve.Text, System.Globalization.NumberStyles.Currency)
            .FrozenAmount = System.Double.Parse(Me.lblFundsOnHold.Text, System.Globalization.NumberStyles.Currency)
            .AvailSDA = System.Double.Parse(lblAvailSDABal.Text, System.Globalization.NumberStyles.Currency)
            .PFOBalance = System.Double.Parse(lblPFOBal.Text, System.Globalization.NumberStyles.Currency)
            .CreditorAccountBalance = System.Double.Parse(lblCurrentBalance.Text, System.Globalization.NumberStyles.Currency)
            .SettlementPercent = Math.Round(CDbl(Me.txtSettlementPercent.Text), 2)
            .SettlementAmount = System.Double.Parse(Me.txtSettlementAmt.Text, System.Globalization.NumberStyles.Currency)

            'Check if a partial payment (Payment Arrangement Down Payment)
            Dim paymentamount As Double

            If bPaymentArrangement Then
                .DownPaymentAmount = System.Double.Parse(Me.lblPADownPayment.Text, System.Globalization.NumberStyles.Currency)
                paymentamount = .DownPaymentAmount
            Else
                .DownPaymentAmount = 0
                paymentamount = .SettlementAmount
            End If

            If .RegisterBalance - paymentamount > 0 Then
                .SettlementAmountAvailable = paymentamount
                .SettlementAmountSent = paymentamount
            Else
                .SettlementAmountAvailable = .RegisterBalance
                .SettlementAmountSent = .RegisterBalance
            End If

            .SettlementAmountOwed = .SettlementAmount - .SettlementAmountSent

            .SettlementSavings = System.Double.Parse(Me.lblSettlementSavings.Text, System.Globalization.NumberStyles.Currency)
            .SettlementFee = System.Double.Parse(Me.lblSettlementFee.Text, System.Globalization.NumberStyles.Currency)
            .SettlementFeeCredit = -1 * System.Double.Parse(Me.lblSettlementFeeCredit.Text, System.Globalization.NumberStyles.Currency)
            .OvernightDeliveryFee = System.Double.Parse(Me.lblOvernightDeliveryCost.Text, System.Globalization.NumberStyles.Currency)
            .SettlementCost = System.Double.Parse(Me.lblSettlementCost.Text, System.Globalization.NumberStyles.Currency)

            .SettlementFeeAmountAvailable = System.Double.Parse(Me.lblSettlementFee_AmtAvailable.Text, System.Globalization.NumberStyles.Currency)
            .SettlementFeeAmountBeingPaid = System.Double.Parse(lblSettlementFee_AmtBeingPaid.Text, System.Globalization.NumberStyles.Currency)
            .SettlementFeeAmountOwed = System.Double.Parse(lblSettlementFee_AmtStillOwed.Text, System.Globalization.NumberStyles.Currency)

            .AdjustedSettlementFee = 0
            .RegisterHoldID = 0
            .OfferDirection = Me.radDirection.SelectedValue
            .SettlementSessionGUID = ""
            .CurrentSettlementStatusID = IIf(OfferStatus = "A", 3, 2)
            .SettlementNotes = Me.hdnNoteID.Value
            .AcceptanceStatus = IIf(OfferStatus = "A", OfferAcceptanceStatus.Accepted, OfferAcceptanceStatus.Rejected)

            If OfferStatus = "A" Then
                If hdnDueDate.Value = "" Then
                    hdnDueDate.Value = String.Format("{0}", Now.ToShortDateString)
                End If
                .SettlementDueDate = hdnDueDate.Value
                .DeliveryMethod = IIf(hdnDeliveryMethod.Value.Trim = "", "chkbytel", hdnDeliveryMethod.Value)
                .DeliveryAmount = txtDeliveryAmount.Text
                .IsRestrictiveEndorsement = IIf(hdnRestrictiveEndorsement.Value.ToString.Trim = "1", True, False)
                .IsClientStipulation = IIf(hdnIsClientStipulation.Value.ToString.Trim = "1", True, False)
                .IsPaymentArrangement = bPaymentArrangement
            End If
        End With

        Dim nh As New NegotiationCalcHelper

        Select Case OfferStatus
            Case "A"
                Dim bNeedsApproval As Boolean = CheckForManagerApprovalNeeded(settNew.SettlementPercent, settNew.CreditorAccountBalance, settNew.ClientID, settNew.AccountID)

                'If CDbl(txtSettlementAmt.Text) > RegisterBal Then
                '    bOver = True
                'End If
                SettID = nh.AcceptOffer(settNew, Session("userid"), bNeedsApproval)
                If bPaymentArrangement Then
                    SettlementMatterHelper.UpdatePAByCLient(SettID, chkPAbyClient.Checked)
                End If

                'insert settlement if over avail sda
                If bNeedsApproval = True Then
                    Dim sqlInsert As String = "stp_settlements_insertOver"
                    Dim myParams As New List(Of SqlParameter)
                    myParams.Add(New SqlParameter("SettlementID", Double.Parse(SettID)))
                    myParams.Add(New SqlParameter("CreatedBy", UserID))
                    'Dim over As Double = 0
                    'over = Double.Parse(txtSettlementAmt.Text) - RegisterBal
                    myParams.Add(New SqlParameter("OverAmount", settNew.SettlementPercent))
                    SqlHelper.ExecuteNonQuery(sqlInsert, CommandType.StoredProcedure, myParams.ToArray)
                End If

            Case Else
                SettID = nh.RejectOffer(settNew, Session("userid"))
        End Select

        Return SettID
    End Function

    ''' <summary>
    ''' loads account info
    ''' </summary>
    ''' <param name="sClientID"></param>
    ''' <param name="sCreditorAccountID"></param>
    ''' <remarks></remarks>
    Public Sub LoadAccountInfo(ByVal sClientID As String, ByVal sCreditorAccountID As String)
        Me.hiddenIDs.Value = sClientID & ":" & sCreditorAccountID

        Dim SDABal As Double, AvailSDA As Double, PFOBal As Double, Reserve As Double, OnHold As Double
        Dim dtClient As DataTable = SqlHelper.GetDataTable(String.Format("select Created, CompanyId from tblclient where clientid = {0}", sClientID), CommandType.Text)
        Dim createddate As String = dtClient.Rows(0)("Created").ToString()
        Dim companyid As String = dtClient.Rows(0)("CompanyId").ToString()
        hdnCompanyId.Value = companyid
        'Dim createdDate As String = SqlHelper.ExecuteScalar(String.Format("select created from tblclient where clientid = {0}", sClientID), CommandType.Text)

        ClientHelper2.GetBalances(CInt(sClientID), SDABal, Reserve, AvailSDA, PFOBal, OnHold)

        lblAvailSDABal.Text = FormatCurrency(AvailSDA, 2)
        lblSDABal.Text = FormatCurrency(SDABal, 2)
        lblReserve.Text = FormatCurrency(Reserve, 2)
        lblPFOBal.Text = FormatCurrency(PFOBal, 2)
        lblFundsOnHold.Text = FormatCurrency(OnHold, 2)

        If AvailSDA < 0 Then
            lblAvailSDABal.ForeColor = System.Drawing.Color.Red
        End If

        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("get_ClientFeeInfo {0}", sClientID), CommandType.Text)
            For Each row As DataRow In dt.Rows
                Me.hdnDefaultOvernightAmount.Value = CDbl(row("OvernightDeliveryFee").ToString)
                Dim odFee As String = Me.hdnDefaultOvernightAmount.Value
                Me.lblSettlementFeePercentage.Text = CDbl(row("SettlementFeePercentage").ToString) * 100
                Me.lblOvernightDeliveryCost.Text = FormatCurrency(odFee, 2)
                Me.txtDeliveryAmount.Text = IIf(hdnDeliveryMethod.Value.Trim.ToLower = "chkbytel", "0.00", odFee)
                Exit For
            Next
        End Using

        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("stp_GetNextDeposit {0}", sClientID), CommandType.Text)
            For Each row As DataRow In dt.Rows
                lblNextDepDate.Text = Format(AddNBusinessDays(row("NextDepositDate").ToString, 5), "M/d/yyyy")
                lblNextDepAmt.Text = FormatCurrency(row("NextDepositAmount"), 2)
                Exit For
            Next
        End Using

        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("stp_GetCreditorInstancesForAccount {0}", sCreditorAccountID), CommandType.Text)
            For Each row As DataRow In dt.Rows
                If row("iscurrent") = True Then
                    Me.lblSettlementFeeCredit.Text = FormatCurrency(Double.Parse(row("settlementfeecredit").ToString, System.Globalization.NumberStyles.Currency) * -1)
                    Exit For
                End If
            Next
        End Using

        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("Select originalamount, currentamount, verifiedamount From tblAccount Where AccountId = {0} ", sCreditorAccountID), CommandType.Text)
            If dt.Rows.Count > 0 Then
                Me.lblCurrentBalance.Text = FormatCurrency(dt.Rows(0)("currentamount").ToString, 2)
                Me.hdnOriginalBalance.Value = dt.Rows(0)("originalamount").ToString
                Me.hdnVerifiedAmount.Value = ""
                If Not dt.Rows(0)("verifiedamount") Is DBNull.Value Then Me.hdnVerifiedAmount.Value = dt.Rows(0)("verifiedamount").ToString
            End If
        End Using

        Me.txtSettlementPercent.Text = "10"
        Me.txtSettlementAmt.Text = Math.Round(CDbl(Me.lblCurrentBalance.Text) * 0.1, 2).ToString("C2").Replace("$", "")
        Me.lblSettlementSavings.Text = FormatCurrency(CDbl(Me.lblCurrentBalance.Text) - CDbl(Me.txtSettlementAmt.Text), 2)

        'Fix Fee Calculation
        'Settlement Fee Calculation 
        If CDate(createddate) < CDate("9/24/2010") Then
            Me.lblSettlementFee.Text = FormatCurrency(CDbl(Me.lblSettlementFeePercentage.Text) / 100 * CDbl(Me.lblSettlementSavings.Text), 2)
            Me.lblUseOriginal.ToolTip = ""
            Me.lblUseOriginal.Text = ""
        Else
            'Use the verified original balance if any, otherwise the original not verified balance
            If hdnVerifiedAmount.Value.Trim.Length > 0 Then
                If CDbl(Me.hdnVerifiedAmount.Value) - CDbl(Me.txtSettlementAmt.Text) < 0.0 Then
                    Me.lblSettlementFee.Text = "0.00"
                ElseIf CInt(companyid) >= 10 Then
                    Me.lblSettlementFee.Text = FormatCurrency(CDbl(Me.lblSettlementFeePercentage.Text) / 100 * (CDbl(Me.hdnVerifiedAmount.Value)), 2)
                Else
                    Me.lblSettlementFee.Text = FormatCurrency(CDbl(Me.lblSettlementFeePercentage.Text) / 100 * (CDbl(Me.hdnVerifiedAmount.Value) - CDbl(Me.txtSettlementAmt.Text)), 2)
                End If
                Me.lblUseOriginal.ToolTip = String.Format("Calculated based on the Original Verified Debt Balance of {0:c}.", CDbl(Me.hdnVerifiedAmount.Value))
                Me.lblUseOriginal.Text = "<sup>(v)</sup>"
                'Use the original balance to find settlement fee (CAN NOT accept settlements, must verify account)
            Else
                'pnlWarning2.Style("display") = "block"
                'ibtnAccept.Style("display") = "none"
                'ibtnReject.Style("display") = "none"
                If CDbl(Me.hdnOriginalBalance.Value) - CDbl(Me.txtSettlementAmt.Text) < 0.0 Then
                    Me.lblSettlementFee.Text = "0.00"
                ElseIf CInt(companyid) >= 10 Then
                    Me.lblSettlementFee.Text = FormatCurrency(CDbl(Me.lblSettlementFeePercentage.Text) / 100 * (CDbl(Me.hdnOriginalBalance.Value)), 2)
                Else
                    Me.lblSettlementFee.Text = FormatCurrency(CDbl(Me.lblSettlementFeePercentage.Text) / 100 * (CDbl(Me.hdnOriginalBalance.Value) - CDbl(Me.txtSettlementAmt.Text)), 2)
                End If
                Me.lblUseOriginal.ToolTip = String.Format("Calculated based on the Original Debt Balance of {0:c}. (not verified)", CDbl(Me.hdnOriginalBalance.Value))
                Me.lblUseOriginal.Text = "<sup>(o)</sup>"
            End If
        End If

        Me.lblSettlementCost.Text = FormatCurrency(CDbl(Me.lblSettlementFee.Text) + CDbl(Me.lblOvernightDeliveryCost.Text) + CDbl(Me.lblSettlementFeeCredit.Text), 2)

        Dim RegisterBal As Double = AvailSDA - PFOBal
        Dim dBal As Double

        If RegisterBal < 0 Then
            dBal = -CDbl(Me.txtSettlementAmt.Text)
        Else
            dBal = RegisterBal - CDbl(Me.txtSettlementAmt.Text)
        End If

        If dBal > CDbl(Me.lblSettlementCost.Text) Then
            Me.lblSettlementFee_AmtAvailable.Text = FormatCurrency(Me.lblSettlementCost.Text, 2)
            Me.lblSettlementFee_AmtStillOwed.Text = FormatCurrency(0, 2)
        Else
            Me.lblSettlementFee_AmtAvailable.Text = FormatCurrency(dBal, 2)
            Dim owed As Double = CDbl(Me.lblSettlementCost.Text) - dBal
            Me.lblSettlementFee_AmtStillOwed.Text = FormatCurrency(owed, 2)
        End If

        Me.lblSettlementFee_AmtBeingPaid.Text = Me.lblSettlementFee_AmtAvailable.Text

        Me.ibtnAccept.Enabled = True
        Me.ibtnReject.Enabled = True
    End Sub

    ''' <summary>
    ''' load settlement info
    ''' </summary>
    ''' <param name="strSettlementID"></param>
    ''' <remarks></remarks>
    Public Sub LoadSettlementInfo(ByVal strSettlementID As String)
        Dim sqlText As String = String.Format("stp_GetSettlement {0}", strSettlementID)
        Using dt As DataTable = SqlHelper.GetDataTable(sqlText.ToString, CommandType.Text)
            For Each dRow As System.Data.DataRow In dt.Rows
                'Me.Settlement_ID = dRow("SettlementID").ToString

                Me.DataClientID = dRow("ClientID").ToString
                Me.accountID = dRow("CreditorAccountID").ToString

                If DataClientID IsNot Nothing And accountID IsNot Nothing Then
                    LoadAccountInfo(DataClientID, accountID)
                End If

                Me.txtSettlementPercent.Text = Math.Round(CDbl(dRow("SettlementPercent").ToString), 2)
                Me.txtSettlementAmt.Text = Math.Round(CDbl(dRow("SettlementAmount").ToString), 2)
                Me.lblSettlementSavings.Text = FormatCurrency(dRow("SettlementSavings").ToString, 2)
                Me.lblSettlementFee.Text = FormatCurrency(dRow("SettlementFee").ToString, 2)
                Me.lblSettlementCost.Text = FormatCurrency(dRow("SettlementCost").ToString, 2)
                Me.lblSettlementFee_AmtAvailable.Text = FormatCurrency(dRow("SettlementFeeAmtAvailable").ToString, 2)
                Me.lblSettlementFee_AmtStillOwed.Text = FormatCurrency(dRow("SettlementFeeAmtStillOwed").ToString, 2)
                Me.lblSettlementFee_AmtBeingPaid.Text = FormatCurrency(dRow("SettlementFeeAmtBeingPaid").ToString, 2)

                For Each i As ListItem In Me.radDirection.Items
                    If i.Value = dRow("OfferDirection").ToString Then
                        i.Selected = True
                    Else
                        i.Selected = False
                    End If
                Next
                Me.ibtnAccept.Enabled = False
                Me.ibtnReject.Enabled = False
                Exit For
            Next
        End Using
    End Sub

    Public Sub LoadStates()
        Using dt As DataTable = SqlHelper.GetDataTable("select name, abbreviation from tblstate with(nolock) order by name", CommandType.Text)
            For Each state As DataRow In dt.Rows
                Try
                    ddlRestrictive_State.Items.Add(New ListItem(state("name").ToString, state("abbreviation").ToString))
                    ddlDelivery_State.Items.Add(New ListItem(state("name").ToString, state("abbreviation").ToString))
                Catch ex As Exception
                    Continue For
                End Try
            Next
        End Using
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        If Not IsPostBack Then
            hdnDeliveryMethod.Value = "chkbytel"
            txtDeliveryAmount.Text = "0.00"
            Me.txtRestrictiveEndorsement.Text = String.Format("{0:d}", Now)
            'store the clientid in hidden field
            DataClientID = Request.QueryString("cid")
            accountID = Request.QueryString("crid")
            If accountID Is Nothing And DataClientID Is Nothing Then
                'disable button if no client/account id
                Me.ibtnAccept.Enabled = False
                Me.ibtnReject.Enabled = False
                Exit Sub
            End If
            If Request.QueryString("sid") IsNot Nothing Then
                Dim sqlSett As New StringBuilder
                sqlSett.AppendFormat("SELECT ClientID, CreditorAccountID FROM tblSettlements with(nolock) WHERE SettlementID = {0}", Request.QueryString("sid"))
                Using dt As DataTable = SqlHelper.GetDataTable(sqlSett.ToString, CommandType.Text)
                    For Each sett As DataRow In dt.Rows
                        ViewState("ClientDocuments_ClientID") = DataHelper.Nz_int(sett("ClientID"), -1)
                        ViewState("ClientDocuments_AccountID") = DataHelper.Nz_int(sett("CreditorAccountID"), -1)
                        DataClientID = ViewState("ClientDocuments_ClientID")
                        accountID = ViewState("ClientDocuments_AccountID")
                        Exit For
                    Next
                End Using

            End If

            Me.LoadAccountInfo(DataClientID, accountID)
            Me.hiddenIDs.Value = DataClientID & ":" & accountID
            'Me.rptFrame.Visible = False
            'Me.rptFrame.Attributes("src") = ""
            phDocuments.Controls.Clear()

            CheckStatus(DataClientID, accountID)
            ' Bug fix - 4/14/08 - jhernandez
            ' Client side changes to asp:TextBox controls get ignored in 2.0 when
            ' ReadOnly is set to True. Setting readonly in the Attributes
            ' collection gets around this issue.
            lblSettlementSavings.Attributes.Add("readonly", "readonly")
            lblSettlementFee.Attributes.Add("readonly", "readonly")
            lblOvernightDeliveryCost.Attributes.Add("readonly", "readonly")
            lblSettlementCost.Attributes.Add("readonly", "readonly")
            lblSettlementFee_AmtAvailable.Attributes.Add("readonly", "readonly")
            lblSettlementFee_AmtBeingPaid.Attributes.Add("readonly", "readonly")
            lblSettlementFee_AmtStillOwed.Attributes.Add("readonly", "readonly")

            LoadStates()

        End If

    End Sub

    Protected Sub ibtnAccept_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibtnAccept.Click
        'Use payment arrangement calculations is selected
        Me.dvPaymentArrangement.Visible = False
        Me.chkPaymentArrangement.Visible = False
        Me.chkPaymentArrangement.Enabled = False
        Me.chkRestrictiveEndorsement.Enabled = False
        Me.chkRestrictiveEndorsement.Checked = False
        Me.chkPAbyClient.Checked = False
        Me.hdnRestrictiveEndorsement.Value = 0
        If Val(Me.hdnPACalculatorId.Value) > 0 Then
            Me.lblPaymentArrangement.Text = "<b>THIS IS A PAYMENT ARRANGEMENT!!!</b>"
            Me.lblPaymentArrangement.ForeColor = System.Drawing.Color.DarkGreen
            Me.chkPaymentArrangement.Checked = True
            Me.dvPaymentArrangement.Visible = True
            Me.hdnIsClientPaymentArrangement.Value = "1"
            'First Payment date
            Me.txtDueDate.Text = PaymentScheduleHelper.ExtractFirstPADueDate(Me.hdnPACalculatorId.Value, Me.hdnPACalculatorJson.Value)
            Me.hdnDueDate.Value = Me.txtDueDate.Text
            Me.txtDueDate.Enabled = False
            Me.ImgCalendar.Enabled = False
        Else
            Me.lblPaymentArrangement.Text = "This is <span style=""font-weight:bold;color:red;background-color: yellow;"">NOT</span> a Payment Arrangement"
            Me.lblPaymentArrangement.ForeColor = System.Drawing.Color.Blue
            Me.chkPaymentArrangement.Checked = False
            Me.chkRestrictiveEndorsement.Enabled = True
            Me.txtDueDate.Enabled = True
            Me.ImgCalendar.Enabled = True
            Me.txtDueDate.Text = String.Format("{0}", Now.ToShortDateString)
            Me.hdnIsClientPaymentArrangement.Value = "0"
        End If
        dsDeliveryTypes.DataBind()
        rblDelivery.DataBind()
        rblDelivery.SelectedIndex = 2
        'show warning if accepted settlement exists already
        Dim sqlSelect As String = String.Format("SELECT [SettlementID] FROM [tblSettlements] with(nolock) WHERE CreditorAccountID = {0} and clientid = {1} and status ='a' and active = 1", accountID, DataClientID)
        Using dt As DataTable = SqlHelper.GetDataTable(sqlSelect, CommandType.Text)
            If dt.Rows.Count > 0 Then
                hdnOverwriteSettlementID.Value = dt.Rows(0).Item("settlementid").ToString
                'check current matter status
                ' only show warning if settlement is pass attach sif
                Dim matterStatus As Integer = GetSettlementMatterSubStatus(hdnOverwriteSettlementID.Value)
                Select Case matterStatus
                    Case 92, 71, 53, 0, 13
                        pnlWarning.Style("display") = "none"
                        pnlDueDate.Style("display") = "block"
                    Case Else
                        pnlWarning.Style("display") = "block"
                        pnlDueDate.Style("display") = "none"
                End Select
            Else
                'no settlement exists continue as normal
                pnlWarning.Style("display") = "none"
                pnlDueDate.Style("display") = "block"
            End If
        End Using

        'manager approval msg
        Dim bNeedsApproval As Boolean = CheckForManagerApprovalNeeded(txtSettlementPercent.Text, lblCurrentBalance.Text, DataClientID, accountID)
        If bNeedsApproval Then
            With divAcceptMsg
                .InnerHtml = "<b>Settlement needs Manager approval!</b>"
                .Attributes("style") = String.Format("border: 1px solid;margin: 10px 0px;padding:15px 10px 15px 50px;background-repeat: no-repeat;background-position: 10px center;color: #9F6000;background-color: #FEEFB3;background-image: url('{0}')", ResolveUrl("~/images/warning.png"))
                .Style("display") = "block"
            End With
        End If

        Me.mpeAccept.Show()
    End Sub

    Protected Sub ibtnReject_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        'insert the offer
        Dim settID As String = Me.InsertOffer("R")
        Dim ids As String() = Me.hiddenIDs.Value.Split(":") 'DataClientID & ":" & accountID

        'raise event
        RaiseEvent InsertedOffer(settID, "R", ids(0), ids(1))
    End Sub

    Protected Sub lnkContinue_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkContinue.Click
        Dim ids As String() = Me.hiddenIDs.Value.Split(":") 'DataClientID & ":" & accountID
        Dim SettID As String = Me.InsertOffer("A")

        If IsNothing(DataClientID) Or DataClientID = 0 Then
            DataClientID = ids(0)
        End If
        If IsNothing(accountID) Or accountID = 0 Then
            accountID = ids(1)
        End If

        'generate docs
        Dim bRestrictiveEndorsement As Boolean = IIf(hdnRestrictiveEndorsement.Value = "1", True, False)
        Dim bPaymentArrangement As Boolean = IIf(hdnIsClientPaymentArrangement.Value = "1", True, False)
        Dim bClientStipulation As Boolean = IIf(hdnIsClientStipulation.Value = "1", True, False)

        'generate payment schedule records
        If bPaymentArrangement Then
            PaymentScheduleHelper.CreatePaymentArrangements(SettID, Me.hdnPACalculatorId.Value, Me.hdnPACalculatorJson.Value)
        End If

        'create matter for everything except payment arrangement
        Dim bNeedsApproval As Boolean = CheckForManagerApprovalNeeded(txtSettlementPercent.Text, lblCurrentBalance.Text, DataClientID, accountID)
        If bNeedsApproval = False Then
            If bClientStipulation Then
                InsertMatterAndTask(DataClientID, SettID, accountID, 87, "Attach SIF/CS", UserID)
            ElseIf bRestrictiveEndorsement Then
                InsertMatterAndTask(DataClientID, SettID, accountID, 51, "Client Approval", UserID)
            Else
                InsertMatterAndTask(DataClientID, SettID, accountID, 92, "Attach SIF", UserID)
            End If
        End If

        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("select a.accountid from tblclient c INNER JOIN tblAccount a ON a.ClientID = c.ClientID inner join tblPerson p ON p.PersonID=c.PrimaryPersonID where a.ClientID = {0} and a.AccountStatusID = 157 and p.StateID = 5 ", DataClientID), CommandType.Text)
            If dt.Rows.Count > 0 Then
                Dim userName As String = UserHelper.GetName(UserID)
                Dim clientSix As String = SqlHelper.ExecuteScalar(String.Format("select accountnumber from tblclient where clientid = {0}", DataClientID), CommandType.Text)
                Dim creditorName As String = AccountHelper.GetCreditorName(accountID)
                Dim emailFrom As String = "noreply@lexxiom.com"
                Dim emailTo As String = ConfigurationManager.AppSettings("ILRSettlementNotify")
                emailTo = "opereira@lexxiom.com"
                Dim subj As String = "Settlement Requested for Account In Litigation (Represented) Status"
                Dim body As String = "A settlement offer has been accepted for an account that is in litigation.<br/><br/>"
                body += String.Format("Client : {0}<br/>", ClientHelper.GetDefaultPersonName(DataClientID))
                body += String.Format("Negotiator : {0}<br/>", userName)
                body += String.Format("Creditor : {0}<br/>", creditorName)
                body += String.Format("Settlement Amt$ : {0}<br/>", txtSettlementAmt.Text)

                For Each et As String In emailTo.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
                    EmailHelper.SendMessage(emailFrom, et, subj, body)
                Next
            End If
        End Using
        '*************************************************************
        Dim docs As Dictionary(Of String, String) = GenerateSettlementDocuments(SettID, ids(0), ids(1), bRestrictiveEndorsement)
        Dim bLoadDocs As Boolean = IPHelper.IsIntranetAddress(IPHelper.GetIP4Address())
        If bRestrictiveEndorsement Or bClientStipulation Or bPaymentArrangement Then
            pnlWarning.Style("display") = "none"

            If bLoadDocs Then LoadSettAcceptanceForm(docs)
            If bRestrictiveEndorsement Then
                bRestrictiveEndorsement = 1
            Else
                bRestrictiveEndorsement = 0
            End If
            If bPaymentArrangement Then
                bPaymentArrangement = 1
            Else
                bPaymentArrangement = 0
            End If
            Dim MatterId As String = DataHelper.FieldLookup("tblSettlements", "MatterId", "SettlementId = " & SettID)

            If Val(MatterId) <> 0 Then
                Dim tempName = AccountHelper.GetCreditorName(accountID)
                tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
                For Each keyValue In docs.Keys
                    SharedFunctions.DocumentAttachment.AttachDocument("matter", MatterId, Path.GetFileName(docs.Item(keyValue)), UserID, accountID + "_" + tempName & "\")
                Next
            End If
            If Not bLoadDocs Then mpeAccept.Hide()
        Else
            mpeAccept.Hide()
        End If

        'deliverymethod
        Dim DeliveryMethod As String = hdnDeliveryMethod.Value
        Select Case DeliveryMethod.ToLower
            Case "chk"
                Dim sqlInsert As String = "stp_settlements_insertDeliveryAddress"
                Dim myParams As New List(Of SqlParameter)
                myParams.Add(New SqlParameter("SettlementID", Double.Parse(SettID)))
                myParams.Add(New SqlParameter("AttentionTo", hdnDelivery_Attention.Value))
                myParams.Add(New SqlParameter("Address", hdnDelivery_Address.Value))
                myParams.Add(New SqlParameter("City", hdnDelivery_City.Value))
                myParams.Add(New SqlParameter("State", hdnDelivery_State.Value))
                myParams.Add(New SqlParameter("Zip", hdnDelivery_Zip.Value))
                myParams.Add(New SqlParameter("UserID", UserID))
                SqlHelper.ExecuteNonQuery(sqlInsert, CommandType.StoredProcedure, myParams.ToArray)
            Case "chkbyemail"
                Dim sqlInsert As String = "stp_settlements_insertDeliveryAddress"
                Dim myParams As New List(Of SqlParameter)
                myParams.Add(New SqlParameter("SettlementID", Double.Parse(SettID)))
                myParams.Add(New SqlParameter("AttentionTo", DBNull.Value))
                myParams.Add(New SqlParameter("Address", DBNull.Value))
                myParams.Add(New SqlParameter("City", DBNull.Value))
                myParams.Add(New SqlParameter("State", DBNull.Value))
                myParams.Add(New SqlParameter("Zip", DBNull.Value))
                myParams.Add(New SqlParameter("UserID", UserID))
                myParams.Add(New SqlParameter("Email", hdnDelivery_EmailAddress.Value))
                SqlHelper.ExecuteNonQuery(sqlInsert, CommandType.StoredProcedure, myParams.ToArray)
            Case "chkbytel"
                Dim sqlInsert As String = "stp_settlements_insertDeliveryAddress"
                Dim myParams As New List(Of SqlParameter)
                myParams.Add(New SqlParameter("SettlementID", Double.Parse(SettID)))
                myParams.Add(New SqlParameter("AttentionTo", DBNull.Value))
                myParams.Add(New SqlParameter("Address", DBNull.Value))
                myParams.Add(New SqlParameter("City", DBNull.Value))
                myParams.Add(New SqlParameter("State", DBNull.Value))
                myParams.Add(New SqlParameter("Zip", DBNull.Value))
                myParams.Add(New SqlParameter("UserID", UserID))
                myParams.Add(New SqlParameter("ContactName", hdnDelivery_ContactName.Value))
                myParams.Add(New SqlParameter("ContactNumber", String.Format("{0} {1}", hdnDelivery_ContactNumber.Value, IIf(hdnDelivery_ContactNumberExt.Value.ToString.Trim = "", "", "x " & hdnDelivery_ContactNumberExt.Value.ToString.Trim))))
                SqlHelper.ExecuteNonQuery(sqlInsert, CommandType.StoredProcedure, myParams.ToArray)
        End Select

        Me.ibtnAccept.Enabled = False

        RaiseEvent InsertedOffer(SettID, "A", ids(0), ids(1))
    End Sub

    Protected Sub mpeAccept_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles mpeAccept.Load
        ClearForm()
    End Sub

    Protected Sub rblDelivery_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles rblDelivery.DataBound
        For Each li As ListItem In rblDelivery.Items
            li.Attributes.Add("onclick", "return DeliveryMethodCheck(this);")
        Next
    End Sub

    Private Shared Function CheckForManagerApprovalNeeded(ByVal SettlementPercent As Double, ByVal CreditorAccountBalance As Double, _
        ByVal DataClientID As Integer, ByVal CreditorAccountID As Integer) As Boolean
        Dim bNeedsApproval As Boolean = False
        'implement manager approval rules
        '•	Accounts over a 55% settlement rate.
        If SettlementPercent > 55 Then
            bNeedsApproval = True
        End If

        '•	Any account with a current balance under $200 are to be excluded
        If CreditorAccountBalance < 200 Then
            bNeedsApproval = False
        End If

        '•	Clients’ last accounts are to be excluded
        Dim bLastAcct As Boolean = SqlHelper.ExecuteScalar(String.Format("stp_settlements_IsClientsLastAccount {0}", DataClientID), CommandType.Text)
        If bLastAcct Then
            bNeedsApproval = False
        End If

        '•	Accounts in litigation status to be excluded
        Dim acctStatusID As Integer = SqlHelper.ExecuteScalar(String.Format("select accountstatusid from tblaccount where accountid = {0}", CreditorAccountID), CommandType.Text)
        Select Case acctStatusID
            Case 157 To 161, 164 To 166, 169
                bNeedsApproval = False
        End Select
        Return bNeedsApproval
    End Function

    Private Shared Function CreateSAFFilePath(ByVal clientId As Integer, ByVal creditorAcctId As Integer) As String
        Dim filePath As String = ""
        Dim tempName As String
        Dim strDocTypeName As String = "SettlementAcceptanceForm"
        Dim strDocID As String = "D6004"
        Dim rootDir = SharedFunctions.DocumentAttachment.CreateDirForClient(clientId)
        Dim strCredName As String = AccountHelper.GetCreditorName(creditorAcctId)

        tempName = strCredName
        tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
        filePath = CreateNewDocumentPathAndName(rootDir, clientId, strDocID, String.Format("CreditorDocs\{0}_{1}\", creditorAcctId, tempName))

        If Directory.Exists(String.Format("{0}CreditorDocs\{1}_{2}\", rootDir, creditorAcctId, tempName)) = False Then
            Directory.CreateDirectory(String.Format("{0}CreditorDocs\{1}_{2}\", rootDir, creditorAcctId, tempName))
        End If
        Return filePath
    End Function

    Private Shared Function GetSettlementMatterSubStatus(ByVal settlementId As Integer) As Integer
        Dim matterStatus As Integer = 0
        Using cmd As New SqlCommand("Select m.MatterSubStatusId From tblMatter m " & _
                                    "inner join tblSettlements s On s.MatterId = m.MatterId and s.settlementId = " & settlementId, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        matterStatus = DatabaseHelper.Peel_int(reader, "MatterSubStatusId")
                    End If
                End Using
            End Using
        End Using
        Return matterStatus
    End Function

    Private Sub AttachDocumentToCreditor(ByVal DataClientID As String, ByVal accountID As String, ByVal filePath As String, ByVal tempName As String, ByVal strLogText As String)
        NoteHelper.AppendNote(noteID, strLogText, UserID)           'attach client copy of letter
        NoteHelper.RelateNote(noteID, 1, DataClientID)              'relate to client
        NoteHelper.RelateNote(noteID, 2, accountID)                 'relate to creditor
        'attach  document
        SharedFunctions.DocumentAttachment.AttachDocument("note", noteID, Path.GetFileName(filePath), UserID, accountID + "_" + tempName & "\")
        SharedFunctions.DocumentAttachment.AttachDocument("account", accountID, Path.GetFileName(filePath), UserID, accountID + "_" + tempName & "\")
        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(filePath), UserID, Now)
    End Sub

    ''' <summary>
    ''' clears all text on form
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub ClearForm()
        lblHdr.Text = "Accept Offer"
        Me.txtDueDate.Text = String.Format("{0:d}", Now)
        rblDelivery.SelectedIndex = 0
        chkClientStipulation.Checked = False
        chkRestrictiveEndorsement.Checked = False

        txtDelivery_Attention.Text = ""
        txtDelivery_Address.Text = ""
        txtDelivery_City.Text = ""
        ddlDelivery_State.SelectedIndex = 0
        txtDelivery_Zip.Text = ""

        txtRestrictive_Attention.Text = ""
        txtRestrictive_Address.Text = ""
        txtRestrictive_City.Text = ""
        ddlRestrictive_State.SelectedIndex = 0
        txtRestrictive_Zip.Text = ""

        Me.pnlDueDate.Style("Display") = "block"
        Me.pnlSettAcceptForm.Style("Display") = "none"
        'Me.rptFrame.Attributes("src") = ""
        phDocuments.Controls.Clear()
        Me.mpeAccept.Hide()
    End Sub

    Function EmailAddressCheck(ByVal emailAddress As String) As Boolean
        Dim pattern As String = "^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
        Dim emailAddressMatch As Match = Regex.Match(emailAddress, pattern)
        If emailAddressMatch.Success Then
            EmailAddressCheck = True
        Else
            EmailAddressCheck = False
        End If
    End Function

    ''' <summary>
    ''' Generates the Settlement Acceptance form pdf
    ''' </summary>
    ''' <param name="SettlementID"></param>
    ''' <param name="DataClientID"></param>
    ''' <param name="accountID"></param>
    ''' <returns>path to new pdf in clients folder</returns>
    ''' <remarks></remarks>
    Private Function GenerateSettlementDocuments(ByVal SettlementID As String, ByVal DataClientID As String, ByVal accountID As String, ByVal bNeedRestrictiveEndorsement As Boolean) As Dictionary(Of String, String)
        Dim formList As New Dictionary(Of String, String)
        Dim filePath As String = ""
        Dim tempName As String
        Dim strDocTypeName As String = "SettlementAcceptanceForm"
        Dim strDocID As String = ""
        Dim rootDir As String = ""
        Dim strCredName As String = ""
        Dim safFilePath As String = ""
        Try
            Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
                Dim currName As String = ""
                Dim origName As String = ""
                Dim acctLastFour As String = ""
                Dim numPagesInReport As Integer = 0
                Dim strLogText As New StringBuilder
                Dim sqlNote As String = "stp_NegotiationsSystemNoteInfo " & accountID
                Using dtNote As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlNote, ConfigurationManager.AppSettings("connectionstring").ToString)
                    For Each dRow As DataRow In dtNote.Rows
                        currName = dRow("CurrentCreditorName").ToString
                        origName = dRow("OriginalCreditorName").ToString
                        acctLastFour = dRow("CreditorAcctLast4").ToString
                        Exit For
                    Next
                End Using

                Using report As New GrapeCity.ActiveReports.SectionReport

                    Dim pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                    Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing

                    strDocID = rptTemplates.GetDocTypeID(strDocTypeName)
                    rootDir = SharedFunctions.DocumentAttachment.CreateDirForClient(DataClientID)
                    strCredName = AccountHelper.GetCreditorName(accountID)

                    tempName = strCredName
                    tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
                    filePath = CreateNewDocumentPathAndName(rootDir, DataClientID, strDocID, "CreditorDocs\" + accountID + "_" + tempName + "\")
                    If Directory.Exists(rootDir & "CreditorDocs\" + accountID + "_" + tempName + "\") = False Then
                        Directory.CreateDirectory(rootDir & "CreditorDocs\" + accountID + "_" + tempName + "\")
                    End If

                    Dim rArgs As String = "SettlementAcceptanceForm," & SettlementID
                    Dim IsPaymentArrangement As Boolean = CBool(DataHelper.FieldLookup("tblSettlements", "IsPaymentArrangement", "SettlementId = " & SettlementID))
                    Dim PAByClient As Boolean = SettlementMatterHelper.IsPAByClient(SettlementID)
                    Dim args As String() = rArgs.Split(",")
                    If Not IsPaymentArrangement Then
                        rptDoc = rptTemplates.ViewTemplate("SettlementAcceptanceForm", DataClientID, args, False, UserID, Path.GetFileNameWithoutExtension(filePath).Split("_")(2))
                    ElseIf PAByClient Then
                        rptDoc = rptTemplates.ViewTemplate("SettlementAcceptanceFormFinalPaymentArrangement", DataClientID, args, False, UserID, Path.GetFileNameWithoutExtension(filePath).Split("_")(2))
                    Else
                        rptDoc = rptTemplates.ViewTemplate("SettlementAcceptanceFormPaymentArrangement", DataClientID, args, False, UserID, Path.GetFileNameWithoutExtension(filePath).Split("_")(2))
                    End If
                    report.Document.Pages.AddRange(rptDoc.Pages)    'add pages to report
                    formList.Add("SettlementAcceptanceForm", filePath)
                    numPagesInReport = report.Document.Pages.Count
                    Using fStream As New System.IO.FileStream(filePath, FileMode.CreateNew)
                        pdf.Export(report.Document, fStream)
                    End Using

                    strLogText.AppendFormat("{0}/{1} #{2}.  ", origName, currName, acctLastFour)
                    strLogText.AppendFormat("Settlement Acceptance Form generated for {0}." & Chr(13), currName)
                    AttachDocumentToCreditor(DataClientID, accountID, filePath, tempName, strLogText.ToString)
                    ReportsHelper.InsertPrintInfo("D6004", DataClientID, filePath, UserID, numPagesInReport)

                    If bNeedRestrictiveEndorsement Then
                        strDocTypeName = "RestrictiveEndorsementLetter"

                        strDocID = rptTemplates.GetDocTypeID(strDocTypeName)
                        rootDir = SharedFunctions.DocumentAttachment.CreateDirForClient(DataClientID)
                        strCredName = AccountHelper.GetCreditorName(accountID)

                        tempName = strCredName
                        tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
                        filePath = CreateNewDocumentPathAndName(rootDir, DataClientID, strDocID, "CreditorDocs\" + accountID + "_" + tempName + "\")
                        If Directory.Exists(rootDir & "CreditorDocs\" + accountID + "_" + tempName + "\") = False Then
                            Directory.CreateDirectory(rootDir & "CreditorDocs\" + accountID + "_" + tempName + "\")
                        End If

                        rArgs = String.Format("RestrictiveEndorsementLetter,{0},{1},{2},{3},{4},{5},{6},{7}", SettlementID, FormatDateTime(txtRestrictiveEndorsement.Text, DateFormat.ShortDate), "", hdnDelivery_Attention.Value, hdnDelivery_Address.Value, hdnDelivery_City.Value, hdnDelivery_State.Value, hdnDelivery_Zip.Value)
                        args = rArgs.Split(",")
                        rptDoc = rptTemplates.ViewTemplate("RestrictiveEndorsementLetter", DataClientID, args, False, UserID, Path.GetFileNameWithoutExtension(filePath).Split("_")(2))
                        report.Document.Pages.AddRange(rptDoc.Pages)    'add pages to report
                        formList.Add("RestrictiveEndorsementLetter", filePath)
                        numPagesInReport = report.Document.Pages.Count
                        Using fStream As New System.IO.FileStream(filePath, FileMode.CreateNew)
                            pdf.Export(report.Document, fStream)
                        End Using

                        strLogText = New StringBuilder
                        strLogText.AppendFormat("{0}/{1} #{2}.  ", origName, currName, acctLastFour)
                        strLogText.AppendFormat("Restrictive Endorsement Letter generated for {0}." & Chr(13), strCredName)
                        AttachDocumentToCreditor(DataClientID, accountID, filePath, tempName, strLogText.ToString)
                        NegotiationRoadmapHelper.InsertRoadmap(SettlementID, 6, "Restrictive Endorsement Generated", UserID)
                        ReportsHelper.InsertPrintInfo("D3033", DataClientID, filePath, UserID, numPagesInReport)
                    End If
                End Using

            End Using
        Catch ex As Exception
            Throw ex
        End Try

        Return formList
    End Function

 

    Private Function IsManager(ByVal userID As Integer) As Boolean
        If DataHelper.FieldLookup("tblUser", "Manager", "UserID = " & userID) = True Then
            Return True
        Else
            Return CBool(DataHelper.FieldLookup("tblUser", "UserGroupID", "UserID = " & userID) = 11)
        End If
    End Function

    ''' <summary>
    ''' loads new settlement info for accepted offers
    ''' </summary>
    ''' <param name="SettlementID"></param>
    ''' <remarks></remarks>
    ''' 
    Private Sub LoadSettAcceptanceForm(ByVal pdfPaths As Dictionary(Of String, String))
        'pnlSettAcceptForm.Controls.Clear()
        Dim tabCont As New TabContainer
        tabCont.CssClass = "tabContainer"
        For Each pdfPath As KeyValuePair(Of String, String) In pdfPaths
            Dim tp As New TabPanel
            tp.HeaderText = pdfPath.Key
            tabCont.Tabs.Add(tp)

            Dim ifrm As New HtmlGenericControl("iframe style=""width: 100%; height: 300px"" ")
            ifrm.Visible = True
            ifrm.Attributes("src") = pdfPath.Value
            tabCont.Tabs(tabCont.Tabs.Count - 1).Controls.Add(ifrm)
        Next
        phDocuments.Controls.Add(tabCont)
        Me.pnlDueDate.Style("Display") = "none"
        Me.pnlSettAcceptForm.Style("Display") = "block"
        mpeAccept.Show()
    End Sub

   

    #End Region 'Methods

    #Region "Other"

    'Private UserID As String
    'Private _DataClientID As String
    'Private _accountID As String

    #End Region 'Other

End Class