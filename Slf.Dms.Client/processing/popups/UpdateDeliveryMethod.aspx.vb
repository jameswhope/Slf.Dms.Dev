Imports System
Imports System.IO
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Linq

Partial Class processing_popups_UpdateDeliveryMethod
    Inherits System.Web.UI.Page
#Region "Declaration"
    Public SettlementID As Integer = 0
    Public MatterId As Integer = 0
    Public UserID As Integer = 0
    Public DeliveryMethod As String
    Public payTo As String
    Public PaymentId As Integer = 0
    Private Information As SettlementMatterHelper.SettlementInformation

#End Region

#Region "Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Not Request.QueryString("mid") Is Nothing Then
            MatterId = Integer.Parse(Request.QueryString("mid"))
        End If

        If Not Request.QueryString("payTo") Is Nothing Then
            payTo = Request.QueryString("payTo")
        End If

        If Not Request.QueryString("delMethod") Is Nothing Then
            DeliveryMethod = Request.QueryString("delMethod")
        End If

        If Not Request.QueryString("pmtid") Is Nothing Then
            PaymentId = Request.QueryString("pmtid")
        End If

        If Not IsPostBack Then
            LoadInformation(payTo, DeliveryMethod)
        End If
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        SettlementID = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & MatterId))
        Information = SettlementMatterHelper.GetSettlementInformation(SettlementID)
        Dim NewMatterSubStatus As Integer
        Dim NewMatterStatusCode As Integer
        Dim ContactNumber As String = Nothing
        Dim DelAmount As Double
        Dim delFeeDesc As String = "Settlement Delivery Fee - "
        delFeeDesc += SettlementMatterHelper.GetSettRegisterEntryDesc(Information.AccountID)
        Dim Address As String = Nothing
        Dim Attention As String = Nothing
        Dim city As String = Nothing
        Dim Zip As String = Nothing
        Dim State As String = Nothing
        Dim Email As String = Nothing
        Dim ContactName As String = Nothing
        Dim PayableTo As String
        Dim checkNumber As Integer = 0

        If radMethod1.Checked Or radMethod2.Checked Then
            If Information.MatterSubStatusId = 67 Then
                NewMatterSubStatus = 67
                NewMatterStatusCode = 38
            ElseIf hdnDelMethod.Value = "P" Then
                NewMatterSubStatus = 66
                NewMatterStatusCode = 39
            ElseIf hdnDelMethod.Value = "C" Then
                NewMatterSubStatus = 63
                NewMatterStatusCode = 35
            Else
                NewMatterSubStatus = 68
                NewMatterStatusCode = 40
            End If

            If Information.MatterSubStatusId <> 67 And hdnDelMethod.Value <> "C" Then
                If Not DataHelper.FieldLookup("tblAccount_PaymentProcessing", "CheckNumber", "PaymentProcessingId = " & PaymentId) <> "" Then
                    checkNumber = SettlementMatterHelper.GetCheckNumber(Information.ClientID)

                    If checkNumber <> 0 Then
                        'Update tblAccount_PaymentProcessing with CheckNumber
                        Using cmd As New SqlCommand("Update tblAccount_PaymentProcessing Set CheckNumber = " & checkNumber & " where PaymentProcessingId = " & PaymentId, ConnectionFactory.Create())
                            Using cmd.Connection
                                cmd.Connection.Open()

                                cmd.ExecuteNonQuery()
                            End Using
                        End Using
                    End If
                End If
            End If

            If hdnDelMethod.Value = "P" Then
                ContactNumber = txtContactNumber.Text
                If Not String.IsNullOrEmpty(txtExt.Text) Then
                    ContactNumber = ContactNumber & " x" & txtExt.Text
                End If

                DelAmount = CDbl(txtPhoneFee.Text)
            ElseIf hdnDelMethod.Value = "C" Then
                ContactNumber = Nothing
                DelAmount = 15
            ElseIf hdnDelMethod.Value = "E" Then
                ContactNumber = Nothing
                DelAmount = CDbl(txtEmailDelivery.Text)
            End If

            Attention = IIf(hdnDelMethod.Value = "C", txtAttention.Text, Nothing)
            Address = IIf(hdnDelMethod.Value = "C", txtAddress.Text, Nothing)
            city = IIf(hdnDelMethod.Value = "C", txtCity.Text, Nothing)
            State = IIf(hdnDelMethod.Value = "C", ddlState.SelectedItem.Value, Nothing)
            Zip = IIf(hdnDelMethod.Value = "C", txtZip.Text, Nothing)
            Email = IIf(hdnDelMethod.Value = "E", txtEmail.Text, Nothing)
            ContactName = IIf(hdnDelMethod.Value = "P", txtContactName.Text, Nothing)
            PayableTo = hdnPay.Value

            SettlementMatterHelper.AddFeeAdjustmentsToSettlement(SettlementID, 6, delFeeDesc, Math.Abs(DelAmount) * -1, UserID, True, -1, False, Nothing)
            SettlementMatterHelper.AddFeeAdjustmentsToSettlement(SettlementID, 28, delFeeDesc, Math.Abs(Information.DeliveryAmount) * -1, UserID, True, -1, True, UserID)
        Else
            hdnDelMethod.Value = DeliveryMethod
            DelAmount = Information.DeliveryAmount
            NewMatterSubStatus = Information.MatterSubStatusId
            NewMatterStatusCode = Information.MatterStatusCodeId
            PayableTo = hdnPay.Value

            If Information.DeliveryMethod.Equals("chk") Then
                Attention = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "AttentionTo", "SettlementId = " & SettlementID)
                Address = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "Address", "SettlementId = " & SettlementID)
                city = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "City", "SettlementId = " & SettlementID)
                State = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "State", "SettlementId = " & SettlementID)
                Zip = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "Zip", "SettlementId = " & SettlementID)
            ElseIf Information.DeliveryMethod.Equals("chkbyemail") Then
                Email = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "EmailAddress", "SettlementId = " & SettlementID)
            Else
                ContactName = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "ContactName", "SettlementId = " & SettlementID)
                ContactNumber = DataHelper.FieldLookup("tblSettlements_DeliveryAddresses", "ContactNumber", "SettlementId = " & SettlementID)
            End If
        End If


        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_ChangeSettlementDeliveryMethod"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "PaymentProcessingId", PaymentId)
                DatabaseHelper.AddParameter(cmd, "SettlementId", SettlementID)
                DatabaseHelper.AddParameter(cmd, "DeliveryMethod", hdnDelMethod.Value)
                DatabaseHelper.AddParameter(cmd, "DeliveryAmount", DelAmount)
                DatabaseHelper.AddParameter(cmd, "AttentionTo", Attention)
                DatabaseHelper.AddParameter(cmd, "Address", Address)
                DatabaseHelper.AddParameter(cmd, "City", city)
                DatabaseHelper.AddParameter(cmd, "State", State)
                DatabaseHelper.AddParameter(cmd, "Zip", Zip)
                DatabaseHelper.AddParameter(cmd, "EmailAddress", Email)
                DatabaseHelper.AddParameter(cmd, "ContactNumber", ContactNumber)
                DatabaseHelper.AddParameter(cmd, "ContactName", ContactName)
                DatabaseHelper.AddParameter(cmd, "PayableTo", PayableTo)
                DatabaseHelper.AddParameter(cmd, "MatterStatusCodeId", NewMatterStatusCode)
                DatabaseHelper.AddParameter(cmd, "MatterSubStatusId", NewMatterSubStatus)
                DatabaseHelper.AddParameter(cmd, "MatterStatusId", 3)
                DatabaseHelper.AddParameter(cmd, "Note", Nothing)
                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                cmd.ExecuteNonQuery()
            End Using
        End Using

        If Information.DeliveryAmount <> DelAmount Then
            Dim ds As DataTable = SqlHelper.GetDataTable("Select SettlementId, DeliveryAmount, AdjustedSettlementFee FROM tblSettlements where MatterId = " & MatterId)
            SettlementMatterHelper.UpdateSettlementCalculations(CInt(ds.Rows(0)("SettlementId")), UserID, hdnDelMethod.Value, CDbl(ds.Rows(0)("DeliveryAmount")), CDbl(ds.Rows(0)("AdjustedSettlementFee")))
        End If

        If NewMatterStatusCode = 40 Then
            SettlementMatterHelper.PayByEMail(PaymentId, MatterId, UserID)
        End If

        ClientScript.RegisterClientScriptBlock(GetType(Page), "ProcessConfirmation", "<script> window.onload = function() { CloseConfirmationWindow(); } </script>")
    End Sub
#End Region

#Region "Utilities"
    Private Sub LoadInformation(ByVal _PayTo As String, ByVal _DelMethod As String)
        If _DelMethod.Equals("C") Then
            radMethod1.Text = "Check By Phone"
            radMethod2.Text = "Check By Email"
        ElseIf _DelMethod.Equals("P") Then
            radMethod1.Text = "Check"
            radMethod2.Text = "Check By Email"
        Else
            radMethod1.Text = "Check By Phone"
            radMethod2.Text = "Check"
        End If

        txtPayable.Text = _PayTo

        ddlState.Items.Clear()
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync("select name, abbreviation from tblstate with(nolock) order by name", ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each state As DataRow In dt.Rows
                Try
                    ddlState.Items.Add(New ListItem(state("name").ToString, state("abbreviation").ToString))
                Catch ex As Exception
                    Continue For
                End Try
            Next
        End Using

        radMethod1.Attributes.Add("onClick", "javascript:ChangeStatus('" & radMethod1.Text & "')")
        radMethod2.Attributes.Add("onClick", "javascript:ChangeStatus('" & radMethod2.Text & "')")

        txtPhoneFee.Attributes("onkeypress") = "javascript:onlyDigits();"
        txtEmailDelivery.Attributes("onkeypress") = "javascript:onlyDigits();"
        txtZip.Attributes("onkeypress") = "javascript:onlyDigits();"
        txtExt.Attributes("onkeypress") = "javascript:onlyDigits();"
        txtContactNumber.Attributes("onkeypress") = "javascript:onlyDigits();"
    End Sub
#End Region

#Region "Async Methods"
    <Services.WebMethod()> _
   Public Shared Function RetrieveCreditorAddress(ByVal matterid As Integer) As Object
        Try
            Dim SettlementID As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & matterid))
            Dim dt As DataTable = SettlementMatterHelper.GetCreditorAddress(SettlementID)
            Dim qry = From row As DataRow In dt.AsEnumerable() _
                      Select New With {.name = row("name").ToString, _
                             .street = row("Street").ToString, _
                             .city = row("City").ToString, _
                             .state = row("Abbreviation"), _
                             .zipcode = row("ZipCode").ToString}

            Return New With {.status = "OK", .data = qry.First()}
        Catch ex As Exception
            Return New With {.status = "ERROR", .error = ex.Message}
        End Try
    End Function
#End Region

End Class
