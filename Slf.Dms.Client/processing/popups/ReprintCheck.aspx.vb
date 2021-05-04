Imports System
Imports System.IO
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Partial Class processing_popups_ReprintCheck
    Inherits System.Web.UI.Page
#Region "Declaration"
    Public SettlementID As Integer = 0
    Public MatterId As Integer = 0
    Public UserID As Integer = 0
    Private Information As SettlementMatterHelper.SettlementInformation
#End Region

#Region "Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        ddlPrinters.Items.Clear()
        ddlPrinters.Items.Add(New ListItem("--Select--", ""))
        ddlPrinters.Items.Add(New ListItem("Mail Room", "\\DMF-APP-0001\dmf-prn-0001"))
        ddlPrinters.Items.Add(New ListItem("Data Entry", "\\DMF-APP-0001\dmf-prn-0002"))
    End Sub

    Private Sub ConfirmCheck(ByVal CheckNumber As Integer)
        Dim MatterType As Integer
        Dim strMatter As String
        Dim paymentid As String

        paymentid = DataHelper.FieldLookup("tblAccount_PaymentProcessing", "PaymentProcessingId", "CheckNumber = " & CheckNumber)
        strMatter = DataHelper.FieldLookup("tblAccount_PaymentProcessing", "MatterId", "PaymentProcessingId = " & paymentid)

        If String.IsNullOrEmpty(strMatter) Then
            dvError.Style.Item("display") = ""
            tdError.InnerText = "This is not a valid check Number. Please enter a valid check number and try again!"
        Else
            MatterId = CInt(strMatter)
            hdnMatter.Value = MatterId
            MatterType = CInt(DataHelper.FieldLookup("tblMatter", "MatterTypeId", "MatterId = " & MatterId))

            If MatterType = 3 Then
                SettlementID = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & MatterId))

                If SettlementID <> 0 Then
                    txtVerifyCheck.Text = txtCheckNumber.Text
                    Using connection As IDbConnection = ConnectionFactory.Create()
                        connection.Open()

                        Using cmd As IDbCommand = connection.CreateCommand()
                            cmd.CommandText = "stp_CheckReport_SettlementCheck"
                            cmd.CommandType = CommandType.StoredProcedure
                            DatabaseHelper.AddParameter(cmd, "PaymentID", paymentid)
                            Using reader As IDataReader = cmd.ExecuteReader()
                                While reader.Read()
                                    txtFirmName.Text = DatabaseHelper.Peel_string(reader, "CompanyAddress1")
                                    txtClientName.Text = DatabaseHelper.Peel_string(reader, "ClientName")
                                    txtCreditorName.Text = DatabaseHelper.Peel_string(reader, "CurrentCreditorName")
                                    txtNewPayTo.Text = txtCreditorName.Text
                                    txtCreditorAcct.Text = DatabaseHelper.Peel_string(reader, "CurrentCreditorAcctNo")
                                    txtAmount.Text = FormatCurrency(DatabaseHelper.Peel_double(reader, "CheckAmount"), 2)
                                    If Not String.IsNullOrEmpty(DatabaseHelper.Peel_string(reader, "ReferenceNumber")) Then
                                        txtCreditorAcct.Text &= "/" & DatabaseHelper.Peel_string(reader, "ReferenceNumber") & "(Ref#)"
                                    End If
                                End While
                                lnkEditPayTo.Style("display") = "block"
                            End Using
                        End Using
                    End Using
                End If
            End If
        End If
    End Sub
    Protected Sub lnkConfirm_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkConfirm.Click
        Dim CheckNumber As Integer = CInt(txtCheckNumber.Text)
        ConfirmCheck(CheckNumber)
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim filePath = SettlementMatterHelper.GetCheckPathForPrinting(hdnMatter.Value)
        SettlementID = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & hdnMatter.Value))
        Dim Success As Boolean
        Dim networkPrinter As String = hdnPrinter.Value
        Dim Note As String

        If String.IsNullOrEmpty(filePath) Or Not File.Exists(filePath) Then
            Dim MatterStatus = CInt(DataHelper.FieldLookup("tblMatter", "MatterStatusCodeId", "MatterId = " & hdnMatter.Value))
            Dim _ClientId = CInt(DataHelper.FieldLookup("tblMatter", "ClientId", "MatterId = " & hdnMatter.Value))
            Dim _AccountId = CInt(DataHelper.FieldLookup("tblSettlements", "CreditorAccountID", "MatterId = " & hdnMatter.Value))

            If MatterStatus = 37 Or MatterStatus = 36 Then
                Dim paymentid As String
                paymentid = DataHelper.FieldLookup("tblAccount_PaymentProcessing", "PaymentProcessingId", "CheckNumber = " & txtCheckNumber.Text)
                filePath = SettlementMatterHelper.GenerateSettlementCheck(paymentid, SettlementID, _ClientId, txtCheckNumber.Text, CDbl(txtAmount.Text), _AccountId, UserID, 0, "D9011", "Reprint Check")
                Dim SubFolder As String = SettlementMatterHelper.GetSubFolder(_AccountId)

                Dim folderPaths() As String = filePath.Split("\")
                Dim DocId As String = SettlementMatterHelper.GetDocIdFromPath(folderPaths(folderPaths.Length - 1))
                SharedFunctions.DocumentAttachment.CreateScan(folderPaths(folderPaths.Length - 1), UserID, DateTime.Now)

                SharedFunctions.DocumentAttachment.AttachDocument("client", _ClientId, "D9011", DocId, String.Format("{0:yyMMdd}", DateTime.Now), _ClientId, UserID, SubFolder)
                SharedFunctions.DocumentAttachment.AttachDocument("account", _AccountId, "D9011", DocId, String.Format("{0:yyMMdd}", DateTime.Now), _ClientId, UserID, SubFolder)
                SharedFunctions.DocumentAttachment.AttachDocument("matter", MatterId, "D9011", DocId, String.Format("{0:yyMMdd}", DateTime.Now), _ClientId, UserID, SubFolder)

            End If
        End If

        If Not String.IsNullOrEmpty(filePath) AndAlso File.Exists(filePath) Then
            Note = UserHelper.GetName(UserID) & " re-printed the check with Check # " & txtCheckNumber.Text & " on the " & networkPrinter & " printer "
            Success = RawPrinterHelper.SendFileToPrinter(networkPrinter, filePath)

            If Not Success Then
                dvError.Style.Item("display") = ""
                tdError.InnerText = "Error Occurred while searching for file! Contact System Admin!!"
            Else
                SettlementMatterHelper.AddSettlementNote(SettlementID, Note, UserID)

                ClientScript.RegisterClientScriptBlock(GetType(Page), "ProcessConfirmation", "<script> window.onload = function() { CloseConfirmationWindow(); } </script>")
            End If
        Else
            dvError.Style.Item("display") = ""
            tdError.InnerText = "Error Occurred while searching for file! Contact System Admin!!"
        End If
    End Sub
#End Region

    
    
    Protected Sub lnkUpdatePayTo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUpdatePayTo.Click
        If txtCheckNumber.Text <> "" Then
            Dim CheckNumber As Integer = CInt(txtCheckNumber.Text)
            'update tblsettlements_deliveryaddresses
            Dim settid As String = SqlHelper.ExecuteScalar(String.Format("select s.settlementid from tblAccount_PaymentProcessing ap with(nolock) inner join tblsettlements s with(nolock) on ap.matterid = s.matterid where ap.checknumber = {0}", CheckNumber), CommandType.Text)
            Dim newPayTo As String = txtNewPayTo.Text
            If newPayTo.Length > 0 Then
                Dim sqlUpdate As String = String.Format("update tblsettlements_deliveryaddresses set payableto='{0}',lastmodified=getdate(), lastmodifiedby={1} where settlementid = {2}", newPayTo, UserID, settid)
                SqlHelper.ExecuteNonQuery(sqlUpdate, CommandType.Text)
                ConfirmCheck(CheckNumber)
            End If

        End If
    End Sub
End Class
