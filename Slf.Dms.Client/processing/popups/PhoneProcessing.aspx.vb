Imports System
Imports System.IO
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Collections.Generic
Imports System.Data
Imports System.Xml.Linq
Imports System.Web.Script.Services
Imports System.Web.Services
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers

Partial Class processing_popups_PhoneProcessing
    Inherits System.Web.UI.Page
#Region "Declaration"
    Public SettlementID As Integer = 0
    Public UserID As Integer = 0
    Public CheckNumber As Integer = 0
    Public PaymentId As Integer = 0
    Public Information As SettlementMatterHelper.SettlementInformation
#End Region

#Region "Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Not Request.QueryString("sid") Is Nothing Then
            SettlementID = Integer.Parse(Request.QueryString("sid"))
        End If

        If Not Request.QueryString("chk") Is Nothing Then
            CheckNumber = Integer.Parse(Request.QueryString("chk"))
        End If

        If Not Request.QueryString("pmtid") Is Nothing Then
            PaymentId = Integer.Parse(Request.QueryString("pmtid"))
        Else
            Throw New Exception("A payment id has not been passed!")
        End If

        If SettlementID <> 0 And CheckNumber <> 0 And PaymentId <> 0 Then
            Me.LoadInformation(SettlementID, CheckNumber, PaymentId)
        End If

    End Sub
#End Region

#Region "Utilities"
    Private Sub LoadInformation(ByVal _SettlementId As Integer, ByVal CheckNumber As Integer, _PaymentId as Integer)
        Dim _ClientId = CInt(DataHelper.FieldLookup("tblSettlements", "ClientId", "SettlementId=" & _SettlementId))
        Dim _Amount = CDbl(DataHelper.FieldLookup("tblSettlements", "SettlementAmount", "SettlementId=" & _SettlementId))
        Dim _IsPA = CBool(DataHelper.FieldLookup("tblSettlements", "IsPaymentArrangement", "SettlementId=" & _SettlementId))
        Dim _DelAmount = CDbl(DataHelper.FieldLookup("tblSettlements", "DeliveryAmount", "SettlementId=" & _SettlementId))
        If _IsPA Then
            _Amount = CDbl(DataHelper.FieldLookup("tblPaymentSchedule", "PmtAmount", "PaymentProcessingId=" & _PaymentId))
        End If
        Dim _specialInstr = DataHelper.FieldLookup("tblSettlements_SpecialInstructions", "SpecialInstructions", "SettlementId=" & _SettlementId)
        Dim _Phone = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "ContactNumber", "SettlementId=" & _SettlementId)
        Dim _ContactName = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "ContactName", "SettlementId=" & _SettlementId)
        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_CheckReport_SettlementCheck"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "PaymentId", _PaymentId)
                Using reader As IDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        lblBankDispaly.Text = DatabaseHelper.Peel_string(reader, "BankDisplayName")
                        lblBankStreet.Text = DatabaseHelper.Peel_string(reader, "Street")
                        lblBankAddress.Text = DatabaseHelper.Peel_string(reader, "City") & ", " & DatabaseHelper.Peel_string(reader, "State") & " " & DatabaseHelper.Peel_string(reader, "Zip")
                        lblBankAccount.Text = DatabaseHelper.Peel_string(reader, "AccountNumber")
                        lblRouting.Text = DatabaseHelper.Peel_string(reader, "RoutingNumber")
                        lblAccountName.Text = DatabaseHelper.Peel_string(reader, "CompanyAddress1")
                        lblAccountAddress.Text = DatabaseHelper.Peel_string(reader, "CompanyCity") & ", " & DatabaseHelper.Peel_string(reader, "CompanyState") & " " & DatabaseHelper.Peel_string(reader, "companyZip")
                        lblAccountStreet.Text = DatabaseHelper.Peel_string(reader, "CompanyAddress2")
                        lblClient.Text = DatabaseHelper.Peel_string(reader, "ClientName") & " (SSN#: " & StringHelper.PlaceInMask(DatabaseHelper.Peel_string(reader, "ClientSSN"), "___-__-____", "_", StringHelper.Filter.NumericOnly) & ")"
                        If Not String.IsNullOrEmpty(DatabaseHelper.Peel_string(reader, "ClientDOB").TrimEnd()) Then
                            lblClient.Text = lblClient.Text & " " & DatabaseHelper.Peel_string(reader, "ClientDOB")
                        End If
                        lblCreditor.Text = DatabaseHelper.Peel_string(reader, "CurrentCreditorName")
                        If String.IsNullOrEmpty(DatabaseHelper.Peel_string(reader, "CoAppSSN").TrimEnd()) Then
                            lblCoApp.Text = DatabaseHelper.Peel_string(reader, "CoApplicantName")
                        Else
                            lblCoApp.Text = DatabaseHelper.Peel_string(reader, "CoApplicantName") & " (SSN#: " & StringHelper.PlaceInMask(DatabaseHelper.Peel_string(reader, "CoAppSSN"), "___-__-____", "_", StringHelper.Filter.NumericOnly) & ")"
                        End If
                        If Not String.IsNullOrEmpty(DatabaseHelper.Peel_string(reader, "CoAppDOB").TrimEnd()) Then
                            lblCoApp.Text = lblCoApp.Text & " " & DatabaseHelper.Peel_string(reader, "CoAppDOB")
                        End If
                        lblCreditorAccount.Text = DatabaseHelper.Peel_string(reader, "CurrentCreditorAcctNo")
                        If Not String.IsNullOrEmpty(DatabaseHelper.Peel_string(reader, "ReferenceNumber")) Then
                            lblRefNo.Text = DatabaseHelper.Peel_string(reader, "ReferenceNumber")
                        End If
                    End While
                End Using
            End Using
        End Using

        lblCheck.Text = CheckNumber.ToString()
        lblAmount.Text = FormatCurrency(_Amount, 2)
        txtFees.Text = IIf(_DelAmount <> 15, FormatCurrency(_DelAmount, 2), FormatCurrency(0, 2))
        lblName.Text = _ContactName
        If Not _IsPA Then
            Me.lnkEditContactNumber.Style.Add("display", "none")
        End If
        Me.txtPhone.Text = ""
        Me.txtPhoneExt.Text = ""

        If Not String.IsNullOrEmpty(_Phone) Or _Phone.Length > 0 Then
            lblPhone.Text = String.Format("({0}){1}-{2}", IIf(_Phone.Length > 2, _Phone.Substring(0, 3), _Phone), IIf(_Phone.Length > 5, _Phone.Substring(3, 3), ""), IIf(_Phone.Length > 6, _Phone.Substring(6), ""))
            Dim phonepart As String() = _Phone.Split("x")
            Me.txtPhone.Text = phonepart(0).Trim
            If phonepart.Length > 1 Then Me.txtPhoneExt.Text = phonepart(1)
        End If
        txtFees.Attributes("onkeypress") = "javascript:onlyDigits();"
        txtZip.Attributes("onkeypress") = "javascript:onlyDigits();"

        ddlState.Items.Clear()
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync("select name, abbreviation from tblstate with(nolock) order by name", ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each state As DataRow In dt.Rows
                Try
                    ddlState.Items.Add(New ListItem(state("abbreviation").ToString, state("abbreviation").ToString))
                Catch ex As Exception
                    Continue For
                End Try
            Next
        End Using


        If Not String.IsNullOrEmpty(_specialInstr) And Not _specialInstr.Equals("None") And Not _specialInstr.Equals("null") Then
            lblInfoBox.Text = _specialInstr
            trInfoBox.Style.Add("display", "")
        Else
            lblInfoBox.Text = ""
            trInfoBox.Style.Add("display", "none")
        End If

    End Sub


#End Region

#Region "Other Events"
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Information = SettlementMatterHelper.GetSettlementInformation(SettlementID)
        Dim CheckNumber As Integer
        Dim delFeeDesc As String = "Settlement Delivery Fee - "
        Dim fee As Double = CDbl(hdnFee.Value)
        Dim delMethod As String = hdnDelMethod.Value.ToString()
        delFeeDesc += SettlementMatterHelper.GetSettRegisterEntryDesc(Information.AccountID)

        If delMethod.Equals("Check By Phone") Then
            If Information.MatterSubStatusId = 66 Then
                If fee <> 0 Then
                    SettlementMatterHelper.AddFeeAdjustmentsToSettlement(SettlementID, 28, delFeeDesc, Math.Abs(fee) * -1, UserID, True, -1, False, Nothing)
                    SettlementMatterHelper.AddFeeAdjustmentsToSettlement(SettlementID, 6, delFeeDesc, Math.Abs(15) * -1, UserID, True, -1, True, UserID)
                Else
                    SettlementMatterHelper.AddFeeAdjustmentsToSettlement(SettlementID, 6, delFeeDesc, Math.Abs(15) * -1, UserID, True, -1, False, Nothing)
                    SettlementMatterHelper.AddFeeAdjustmentsToSettlement(SettlementID, 28, delFeeDesc, Math.Abs(fee) * -1, UserID, True, -1, True, UserID)
                End If

                If fee <> Information.DeliveryAmount Then
                    SettlementMatterHelper.UpdateSettlementCalculations(SettlementID, UserID, Information.DeliveryMethod, fee, Information.AdjustedSettlementFee)
                End If

                CheckNumber = CInt(lblCheck.Text)
                Dim checkAmount As Double = CDbl(lblAmount.Text) + fee
                Dim filePath As String = SettlementMatterHelper.GenerateSettlementCheck(PaymentId, SettlementID, Information.ClientID, CheckNumber, checkAmount, Information.AccountID, UserID, False, "D9011")

                Dim SubFolder As String = SettlementMatterHelper.GetSubFolder(Information.AccountID)

                Dim folderPaths() As String = filePath.Split("\")
                Dim DocId As String = SettlementMatterHelper.GetDocIdFromPath(folderPaths(folderPaths.Length - 1))
                SharedFunctions.DocumentAttachment.CreateScan(folderPaths(folderPaths.Length - 1), UserID, DateTime.Now)

                SharedFunctions.DocumentAttachment.AttachDocument("client", Information.ClientID, "D9011", DocId, String.Format("{0:yyMMdd}", DateTime.Now), Information.ClientID, UserID, SubFolder)
                SharedFunctions.DocumentAttachment.AttachDocument("account", Information.AccountID, "D9011", DocId, String.Format("{0:yyMMdd}", DateTime.Now), Information.ClientID, UserID, SubFolder)
                SharedFunctions.DocumentAttachment.AttachDocument("matter", Information.MatterId, "D9011", DocId, String.Format("{0:yyMMdd}", DateTime.Now), Information.ClientID, UserID, SubFolder)

                Dim note = UserHelper.GetName(UserID) & " processed an amount of " & FormatCurrency(checkAmount, 2).ToString() & " by phone with a fee of " & FormatCurrency(fee, 2).ToString()

                SettlementMatterHelper.AddSettlementNote(SettlementID, note, UserID)

                Dim RegisterXml As XElement = SettlementMatterHelper.InsertSettlementPayments(Me.PaymentId, Information.ClientID, Information.AccountID, CheckNumber, UserID, SettlementID)

                Dim RegisterId = CInt(RegisterXml.Attribute("Id").Value)
                Dim FeeRegisterId = CInt(RegisterXml.Attribute("FeeId").Value)

                Using connection As IDbConnection = ConnectionFactory.Create()
                    connection.Open()

                    Using cmd As IDbCommand = connection.CreateCommand()
                        cmd.CommandText = "stp_ResolveSettlementProcessing"
                        cmd.CommandType = CommandType.StoredProcedure
                        DatabaseHelper.AddParameter(cmd, "PaymentId", PaymentId)
                        DatabaseHelper.AddParameter(cmd, "SettlementId", SettlementID)
                        DatabaseHelper.AddParameter(cmd, "Note", IIf(String.IsNullOrEmpty(txtNote.Text), Nothing, txtNote.Text))
                        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                        DatabaseHelper.AddParameter(cmd, "Reference", IIf(String.IsNullOrEmpty(txtConfirm.Text), Nothing, txtConfirm.Text))
                        DatabaseHelper.AddParameter(cmd, "CheckNumber", CheckNumber)
                        DatabaseHelper.AddParameter(cmd, "CheckAmount", checkAmount)
                        DatabaseHelper.AddParameter(cmd, "RegisterId", RegisterId)
                        DatabaseHelper.AddParameter(cmd, "FeeRegisterId", FeeRegisterId)
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
            End If
        Else
            SettlementMatterHelper.AddFeeAdjustmentsToSettlement(SettlementID, 6, delFeeDesc, Math.Abs(15) * -1, UserID, True, -1, False, Nothing)
            SettlementMatterHelper.AddFeeAdjustmentsToSettlement(SettlementID, 28, delFeeDesc, Math.Abs(fee) * -1, UserID, True, -1, True, UserID)
            Using connection As IDbConnection = ConnectionFactory.Create()
                connection.Open()

                Using cmd As IDbCommand = connection.CreateCommand()
                    cmd.CommandText = "stp_ChangeSettlementDeliveryMethod"
                    cmd.CommandType = CommandType.StoredProcedure
                    DatabaseHelper.AddParameter(cmd, "PaymentProcessingId", PaymentId)
                    DatabaseHelper.AddParameter(cmd, "SettlementId", SettlementID)
                    DatabaseHelper.AddParameter(cmd, "DeliveryMethod", "C")
                    DatabaseHelper.AddParameter(cmd, "DeliveryAmount", 15)
                    DatabaseHelper.AddParameter(cmd, "AttentionTo", txtAttention.Text)
                    DatabaseHelper.AddParameter(cmd, "Address", txtAddress.Text)
                    DatabaseHelper.AddParameter(cmd, "City", txtCity.Text)
                    DatabaseHelper.AddParameter(cmd, "State", hdnSelectedState.Value)
                    DatabaseHelper.AddParameter(cmd, "Zip", txtZip.Text)
                    DatabaseHelper.AddParameter(cmd, "EmailAddress", Nothing)
                    DatabaseHelper.AddParameter(cmd, "ContactNumber", Nothing)
                    DatabaseHelper.AddParameter(cmd, "ContactName", Nothing)
                    DatabaseHelper.AddParameter(cmd, "PayableTo", Nothing)
                    DatabaseHelper.AddParameter(cmd, "MatterStatusCodeId", 35)
                    DatabaseHelper.AddParameter(cmd, "MatterSubStatusId", 63)
                    DatabaseHelper.AddParameter(cmd, "MatterStatusId", 3)
                    DatabaseHelper.AddParameter(cmd, "Note", IIf(String.IsNullOrEmpty(txtNote.Text), Nothing, txtNote.Text))
                    DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        End If

        ScriptManager.RegisterStartupScript(UpdatePanel1, UpdatePanel1.GetType, "CloseWin", "ClosePhWindow();", True)
    End Sub
#End Region

#Region "Async Methods"
    <System.Web.Services.WebMethodAttribute()>
    Public Shared Function SavePhoneNumber(ByVal settlementid As Integer, ByVal phonenumber As String, ByVal userid As Integer) As String
        Try
            SettlementMatterHelper.ChangeDeliveryPhoneNumber(settlementid, phonenumber)
            Dim si As SettlementMatterHelper.SettlementInformation = SettlementMatterHelper.GetSettlementInformation(settlementid)
            Dim fphonenumber As String = LocalHelper.FormatPhone(phonenumber)
            NoteHelper.InsertNote(String.Format("Check by phone contact number for matter {0} has been changed to {1} by {2}.", si.MatterId, fphonenumber, DialerHelper.GetUserFullName(userid)), userid, si.ClientID)
            Return "OK"
        Catch ex As Exception
            Return ex.Message
        End Try
    End Function
#End Region
End Class
