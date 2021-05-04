﻿Imports System.Net.Mail
Imports System.Configuration

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports SharedFunctions
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic
Imports System.IO

Partial Class Clients_client_communication_email
    Inherits System.Web.UI.Page

#Region "Variables"
    Private Action As String
    Private qs As QueryStringCollection
    Private strToMailID As String
    Public MatterID As Integer
    Public AccountID As Integer
    Private AccountNumber As String
    Private CreditorAccountNumber As String
    Private UserID As Integer
    Private UserGroupID As Integer
    Public Shadows ClientID As Integer
    Private EmailLogID As Integer = 0
    Public CreditorInstanceId As Integer = 0
    Public AttorneyId As Integer = 0
    Private AttorneyName As String
    Private DocumentRoot As String
    Private IntakeEmail As String = String.Empty
    Private UserName As String
    Private UserGroupName As String
    Private NoteID As Integer
    Private blnSuperUser As Boolean = False
    Private CompanyId As Integer
    Private ClientLastName As String
    Private FirmName As String
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserName = UserHelper.GetName(UserID)
        UserGroupID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupId", "UserId=" & UserID))
        UserGroupName = DataHelper.FieldLookup("tblUserGroup", "Name", "UserGroupId=" & UserGroupID)
        qs = LoadQueryString()
        If Not qs Is Nothing Then
            ClientID = DataHelper.Nz_int(qs("id"), 0)
            AccountID = DataHelper.Nz_int(qs("aid"), 0)
            Action = DataHelper.Nz_string(qs("a"))
            IntakeEmail = DataHelper.Nz_string(qs("s"))
            MatterID = DataHelper.Nz_int(qs("mid"), 0)
            CreditorInstanceId = DataHelper.Nz_int(qs("ciid"), 0)
            EmailLogID = DataHelper.Nz_int(qs("eid"), 0)
            CompanyId = DataHelper.FieldLookup("tblClient", "CompanyID", "ClientID = " + ClientID.ToString())
            FirmName = DataHelper.FieldLookup("tblCompany", "ShortCOName", "CompanyID = " + CompanyId.ToString())
            If FirmName.Length > 0 Then
                FirmName = FirmName.Substring(0, 1).ToUpper() + FirmName.ToLower().Substring(1)
            End If
            If EmailLogID = 0 Then
                AccountNumber = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + ClientID.ToString())
            End If
        End If
        FetchCreditorAccountNumber()

        FetchAttorneyEMailID()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        cmd.CommandText = "select LastName  from tblPerson P Left Outer Join tblClient C on P.PersonId=C.PrimaryPersonID where C.Clientid=@Clientid"
        DatabaseHelper.AddParameter(cmd, "Clientid", ClientID)
        cmd.Connection.Open()
        rd = cmd.ExecuteReader()

        While rd.Read()
            ClientLastName = DatabaseHelper.Peel_string(rd, "LastName")
        End While
        DatabaseHelper.EnsureReaderClosed(rd)

        If Not IsPostBack Then
            '03.18.2010
            txtAttachments.Value = ""
            CheckIfSuperUser()
            txtFromID.Text = DataHelper.FieldLookup("tblUser", "emailaddress", "UserId=" & UserID)
            PopulateMatterEmailSubjects()

            If EmailLogID > 0 Then
                FetchEMailDetails()
            End If

            If IntakeEmail = "i" Then
                FetchIntakeEmailDetails()
                txtAttachmentstext.Value = "Client Intake Document;"
                Dim iLastDocInsertedId As Int64 = 0

                Try
                    cmd.CommandText = "select top 1 *  from tbldocrelation where clientid=@clientid and relatedby=@relatedby order by docrelationid desc"
                    cmd.Parameters.Clear()
                    DatabaseHelper.AddParameter(cmd, "clientid", ClientID)
                    DatabaseHelper.AddParameter(cmd, "relatedby", UserID)
                    'cmd.Connection.Open()
                    rd = cmd.ExecuteReader()
                    Dim subfolder As String = String.Empty
                    Dim docid As String = String.Empty
                    Dim doctypeid As String = String.Empty
                    Dim DateString As String = String.Empty
                    While rd.Read()
                        subfolder = DatabaseHelper.Peel_string(rd, "subfolder")
                        docid = DatabaseHelper.Peel_string(rd, "docid")
                        doctypeid = DatabaseHelper.Peel_string(rd, "doctypeid")
                        DateString = DatabaseHelper.Peel_string(rd, "datestring")
                    End While
                    Dim MatterNumber As String = DataHelper.FieldLookup("tblmatter", "MatterNumber", "matterid = " + MatterID.ToString())

                    txtAttachments.Value = subfolder.Replace("\", "") & "//" & MatterNumber.Substring(0, MatterNumber.IndexOf("-")) & "_M005_" & docid & "_" & DateString & ".pdf"

                Catch
                Finally
                    DatabaseHelper.EnsureReaderClosed(rd)
                    DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
                End Try

            End If
        End If
        HandleAction()

    End Sub

    Private Sub FetchCreditorAccountNumber()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "select RIGHT(ci.AccountNumber,4) as CreditorAccountNumber  from tblcreditorinstance ci where ci.CreditorInstanceId=@CreditorInstanceId"
        DatabaseHelper.AddParameter(cmd, "CreditorInstanceId", CreditorInstanceId)
        cmd.Connection.Open()
        rd = cmd.ExecuteReader()

        While rd.Read()
            CreditorAccountNumber = DatabaseHelper.Peel_string(rd, "CreditorAccountNumber")
        End While
    End Sub

    Private Sub CheckIfSuperUser()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Try
            cmd.CommandText = "select UserID, SuperUser, Username, FirstName, LastName, ug.[Name] as GroupName From tblUser u join tblUserGroup ug on ug.UserGroupId = u.userGroupId Where SuperUser=1 and UserID=@UserID"
            DatabaseHelper.AddParameter(cmd, "UserID", UserID)
            cmd.Connection.Open()
            rd = cmd.ExecuteReader()
            While rd.Read()
                blnSuperUser = True
            End While

            If blnSuperUser = False Then
                txtMailContent.ReadOnly = True
                txtMailContent.Toolbar.Style.Add("display", "none")
            End If
        Catch
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Private Sub FetchEMailDetails()
        Dim strMailMessage As String
        Dim strMailFooter As String
        Dim strSubject As String
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        Try
            cmd.CommandText = "SELECT EMailLogID, FromMailID, ToMailID, CCMailID, BCCMailID, MailSubject, MailMessage, MailFooter FROM tblEmailRelayLog where EMailLogID=@EMailLogID"
            DatabaseHelper.AddParameter(cmd, "EMailLogID", EmailLogID)
            txtMailContent.Text = ""
            txtMailFooter.Text = ""
            Try
                cmd.Connection.Open()
                rd = cmd.ExecuteReader()
                While rd.Read()
                    strMailMessage = DatabaseHelper.Peel_string(rd, "MailMessage")
                    strMailFooter = DatabaseHelper.Peel_string(rd, "MailFooter")
                    strSubject = DatabaseHelper.Peel_string(rd, "MailSubject")
                    txtFromID.Text = DatabaseHelper.Peel_string(rd, "FromMailID")
                    txtToID.Text = DatabaseHelper.Peel_string(rd, "ToMailID")
                    txtCCID.Text = DatabaseHelper.Peel_string(rd, "CCMailID")
                    txtBCCID.Text = DatabaseHelper.Peel_string(rd, "BCCMailID")
                    txtSubject.Text = strSubject.Replace("{ClientLastName}", ClientLastName).Replace("{AccountNumber.Creditor}", AccountNumber + " - " + CreditorAccountNumber).Replace("{FirmName}", FirmName).Replace("{AccountNumber}", AccountNumber)
                    txtMailContent.Text = Replace(Replace(Replace(Replace(strMailMessage, strMailFooter, ""), "{UserFullName}", UserName), "{AttorneyName}", AttorneyName), "{UserGroupName}", UserGroupName)
                    txtMailFooter.Text = strMailFooter
                End While
            Finally

            End Try
        Catch ex As Exception
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub
    Private Sub FetchSettlementCheckDetails()
        Throw New Exception("This feature needs to be updated to Payment Arrangements")
        Dim lblBankDispaly As String
        Dim lblBankStreet As String
        Dim lblBankAddress As String
        Dim lblBankAccount As String
        Dim lblRouting As String
        Dim lblAccountName As String
        Dim lblAccountAddress As String
        Dim lblAccountStreet As String
        Dim lblClient As String
        Dim lblCreditor As String
        Dim lblCreditorAccount As String
        Dim lblAmount As Double
        Dim CheckNumber As Integer
        Dim lblCoApp As String
        Dim Companyid As Integer
        Dim SettlementId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & MatterID))
        CheckNumber = CInt(DataHelper.FieldLookup("tblAccount_PaymentProcessing", "CheckNumber", "MatterId = " & MatterID))
        Dim EmailAddress As String = DataHelper.FieldLookup("tblSettlements_DeliveryADdresses", "EmailAddress", "SettlementId = " & SettlementId)
        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()

            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_CheckReport_SettlementCheck"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "SettlementId", SettlementId)
                Using reader As IDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        lblBankDispaly = DatabaseHelper.Peel_string(reader, "BankDisplayName")
                        lblBankStreet = DatabaseHelper.Peel_string(reader, "Street")
                        lblBankAddress = DatabaseHelper.Peel_string(reader, "City") & ", " & DatabaseHelper.Peel_string(reader, "State") & " " & DatabaseHelper.Peel_string(reader, "Zip")
                        lblBankAccount = DatabaseHelper.Peel_string(reader, "AccountNumber")
                        lblRouting = DatabaseHelper.Peel_string(reader, "RoutingNumber")
                        lblAccountName = DatabaseHelper.Peel_string(reader, "CompanyAddress1")
                        lblAccountAddress = DatabaseHelper.Peel_string(reader, "CompanyCity") & ", " & DatabaseHelper.Peel_string(reader, "CompanyState") & " " & DatabaseHelper.Peel_string(reader, "companyZip")
                        lblAccountStreet = DatabaseHelper.Peel_string(reader, "CompanyAddress2")
                        lblClient = DatabaseHelper.Peel_string(reader, "ClientName")
                        lblCreditor = DatabaseHelper.Peel_string(reader, "CurrentCreditorName")
                        lblCoApp = DatabaseHelper.Peel_string(reader, "CoApplicantName")
                        lblAmount = FormatCurrency(DatabaseHelper.Peel_double(reader, "CheckAmount"), 2)
                        If Not String.IsNullOrEmpty(DatabaseHelper.Peel_string(reader, "ReferenceNumber")) Then
                            lblCreditorAccount = DatabaseHelper.Peel_string(reader, "CurrentCreditorAcctNo") & "\" & DatabaseHelper.Peel_string(reader, "ReferenceNumber")
                        Else
                            lblCreditorAccount = DatabaseHelper.Peel_string(reader, "CurrentCreditorAcctNo")
                        End If
                        Companyid = DatabaseHelper.Peel_int(reader, "companyid")
                    End While
                End Using
            End Using
        End Using

        txtSubject.Text = txtSubject.Text.Replace("{CheckNumber}", CheckNumber.ToString())
        txtFromID.Text = SettlementMatterHelper.GetPaymentEmailSender(Companyid)
        txtToID.Text = EmailAddress
        txtMailContent.Text = txtMailContent.Text.Replace("{FirmName}", lblAccountName).Replace("{FirmStreet}", lblAccountStreet).Replace("{FirmAddress}", lblAccountAddress).Replace("{BankDisplay}", lblBankDispaly).Replace("{BankStreet}", lblBankStreet).Replace("{BankAddress}", lblBankAddress).Replace("{Routing}", lblRouting).Replace("{AccountNumber}", lblBankAccount).Replace("{CoAppName}", lblCoApp).Replace("{ClientName}", lblClient).Replace("{CreditorName}", lblCreditor).Replace("{CreditorAccount}", lblCreditorAccount).Replace("{CheckNumber}", CheckNumber.ToString()).Replace("{Amount}", lblAmount.ToString())
    End Sub

    Private Sub FetchIntakeEmailDetails()
        Dim strMailMessage As String
        Dim strMailFooter As String
        Dim strSubject As String
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        Try
            cmd.CommandText = "select EmailConfigID, MailFrom, MailCC, MailBCC, MailSubject, MailPurpose, MailContent, MailFooter from tblEmailConfiguration where EmailConfigID=5"
            DatabaseHelper.AddParameter(cmd, "EMailLogID", EmailLogID)
            txtMailContent.Text = ""
            txtMailFooter.Text = ""
            txtSubject.Text = ""
            Try
                cmd.Connection.Open()
                rd = cmd.ExecuteReader()
                While rd.Read()
                    strMailMessage = DatabaseHelper.Peel_string(rd, "MailContent")
                    strMailFooter = DatabaseHelper.Peel_string(rd, "MailFooter")
                    strSubject = DatabaseHelper.Peel_string(rd, "MailSubject")
                    txtCCID.Text = DatabaseHelper.Peel_string(rd, "MailCC")
                    txtBCCID.Text = DatabaseHelper.Peel_string(rd, "MailBCC")
                    ddlSubject.SelectedItem.Text = DatabaseHelper.Peel_string(rd, "MailPurpose")
                    txtSubject.Text = strSubject.Replace("{ClientLastName}", ClientLastName).Replace("{AccountNumber.Creditor}", AccountNumber + " - " + CreditorAccountNumber).Replace("{FirmName}", FirmName).Replace("{AccountNumber}", AccountNumber)
                    txtMailContent.Text = strMailMessage.Replace(strMailFooter, "").Replace("{UserFullName}", UserName).Replace("{AttorneyName}", AttorneyName).Replace("{UserGroupName}", UserGroupName)
                    txtMailFooter.Text = strMailFooter
                End While
            Finally

            End Try
        Catch ex As Exception
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""clients_client_applicants_applicant_default""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If
        Return qsv.QueryString
    End Function

    Private Sub PopulateMatterEmailSubjects()
        ddlSubject.Items.Clear()
        ddlSubject.Items.Add(New ListItem("Select Template", 0))
        Dim StrMatterStatus = DataHelper.FieldLookup("tblMatter", "MatterStatusCodeId", "MatterId=" & MatterID)
        Dim MatterStatusCode As Integer = 0
        Dim strCommand As String
        If Not String.IsNullOrEmpty(StrMatterStatus) Then
            MatterStatusCode = CInt(StrMatterStatus)
        End If

        If MatterStatusCode = 40 Or MatterStatusCode = 37 Or MatterStatusCode = 57 Then
            strCommand = "SELECT MailPurpose, EmailConfigID FROM tblEmailConfiguration Where MType='M' and LawfirmId=@LawfirmId Or lawFirmId = 0 Order by MailPurpose"
        Else
            strCommand = "SELECT MailPurpose, EmailConfigID FROM tblEmailConfiguration Where MType='M' and LawfirmId=@LawfirmId Order by MailPurpose"
        End If

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = strCommand
                DatabaseHelper.AddParameter(cmd, "LawfirmId", CompanyId)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        ddlSubject.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "MailPurpose"), DatabaseHelper.Peel_int(rd, "EmailConfigID")))
                    End While

                End Using
            End Using
        End Using
    End Sub

    Private Sub HandleAction()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")

        If MatterID > 0 Then
            lblSendMail.Text = "&nbsp;>&nbsp;Send email to Attorney"
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""SendMail();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_email.png") & """ align=""absmiddle""/>Send Email</a>")
            lnkCommunications.InnerText = "Matter Instance"
            lnkCommunications.HRef = "~/clients/client/creditors/matters/matterinstance.aspx?id=" & ClientID & "&aid=" & AccountID & "&mid=" & MatterID & "&ciid=" & CreditorInstanceId
        Else
            lblSendMail.Text = "Send email "
        End If
        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID

    End Sub

    Private Sub FetchAttorneyEMailID()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        Try
            cmd.CommandText = "select ta.emailaddress, ta.firstname+' '+ta.lastname attorneyname from tblmatter tm, tblAttorney ta where tm.attorneyid=ta.attorneyid and tm.matterid=@matterid"
            DatabaseHelper.AddParameter(cmd, "matterid", MatterID)

            Try
                cmd.Connection.Open()
                rd = cmd.ExecuteReader()
                While rd.Read()
                    strToMailID = DatabaseHelper.Peel_string(rd, "emailaddress")
                    If Not Page.IsPostBack Then
                        txtToID.Text = strToMailID
                    End If
                    AttorneyName = DatabaseHelper.Peel_string(rd, "attorneyname")
                End While
            Finally

            End Try
        Catch ex As Exception
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        If IntakeEmail = "i" Then
            SaveAutoNote(False)
        End If
        Close()
    End Sub

    Private Sub Close()
        If Action = "am" And MatterID > 0 Then
            Response.Redirect("~/clients/client/creditors/matters/matterinstance.aspx?id=" & ClientID & "&aid=" & AccountID & "&mid=" & MatterID & "&ciid=" & CreditorInstanceId, False)
        Else
            Response.Redirect("~/clients/client/communication/emails.aspx?id=" & ClientID, False)
        End If
    End Sub

    Protected Sub ddlSubject_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlSubject.SelectedIndexChanged
        FetchEmailTemplateDetails()
    End Sub

    Private Sub FetchEmailTemplateDetails()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Dim strMailMessage As String
        Dim strMailFooter As String
        Dim strSubject As String
        Try
            cmd.CommandText = "select EmailConfigID, MailFrom, MailCC, MailBCC, MailSubject, MailPurpose, MailContent, MailFooter from tblEmailConfiguration where EmailConfigID=@EmailConfigID"
            DatabaseHelper.AddParameter(cmd, "EmailConfigID", ddlSubject.SelectedValue)
            txtMailContent.Text = ""
            txtMailFooter.Text = ""
            txtSubject.Text = ""
            Try
                cmd.Connection.Open()
                rd = cmd.ExecuteReader()
                While rd.Read()
                    strMailMessage = DatabaseHelper.Peel_string(rd, "MailContent")
                    strMailFooter = DatabaseHelper.Peel_string(rd, "MailFooter")
                    strSubject = DatabaseHelper.Peel_string(rd, "MailSubject")
                    txtCCID.Text = DatabaseHelper.Peel_string(rd, "MailCC")
                    txtBCCID.Text = DatabaseHelper.Peel_string(rd, "MailBCC")
                    txtSubject.Text = strSubject.Replace("{ClientLastName}", ClientLastName).Replace("{AccountNumber.Creditor}", AccountNumber + " - " + CreditorAccountNumber).Replace("{FirmName}", FirmName).Replace("{AccountNumber}", AccountNumber)
                    txtMailContent.Text = strMailMessage.Replace(strMailFooter, "").Replace("{UserFullName}", UserName).Replace("{AttorneyName}", AttorneyName).Replace("{UserGroupName}", UserGroupName)
                    txtMailFooter.Text = strMailFooter
                End While
            Finally

            End Try
        Catch ex As Exception
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Dim StrMatterStatus = DataHelper.FieldLookup("tblMatter", "MatterStatusCodeId", "MatterId=" & MatterID)
        Dim MatterStatusCode As Integer = 0
        If Not String.IsNullOrEmpty(StrMatterStatus) Then
            MatterStatusCode = CInt(StrMatterStatus)
        End If

        If MatterStatusCode = 40 Or MatterStatusCode = 37 Or MatterStatusCode = 57 Then
            Me.FetchSettlementCheckDetails()
        End If
    End Sub

    Protected Sub lnkSendMail_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSendMail.Click
        Try
            'If ConfigurationManager.AppSettings("FolderPath").ToString() <> "local" Then
            '    '***** Production/QA path *****
            '    DocumentRoot = "\\" + DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " + ClientID.ToString()) + "\" + _
            '       DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " + ClientID.ToString()) + "\" + AccountNumber
            'End If

            '03.02.2010
            
            DocumentRoot = "\\" + DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " + ClientID.ToString()) + "\" + _
                            DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " + ClientID.ToString()) + "\" + AccountNumber
           
            Dim strSubject As String = String.Empty
            strSubject = txtSubject.Text

            Dim objMM As New MailMessage()
            objMM.From = New MailAddress(txtFromID.Text)
            'If strToMailID <> "" Then objMM.To.Add(New MailAddress(strToMailID))



            'If ConfigurationManager.AppSettings("FolderPath").ToString() = "local" Then
            '    '*** Dev/QA (Send back to user) ****
            '    '***QA send back to the email of the user who logged in
            '    If txtToID.Text <> "" Then objMM.To.Add(New MailAddress(txtFromID.Text))
            'Else
            '    '*** Production ***
            '    If txtToID.Text <> "" Then objMM.To.Add(New MailAddress(txtToID.Text))
            'End If

            '03.02.2010  for testing always send back to the user
            If txtToID.Text <> "" Then
                objMM.To.Add(New MailAddress(txtToID.Text))
            Else
                objMM.To.Add(New MailAddress(txtFromID.Text))
                'objMM.To.Add(New MailAddress(txtToID.Text))
            End If



            Dim strCCMailIDs As String()
            strCCMailIDs = txtCCID.Text.Replace(",", ";").Split(";")
            For Each strCC In strCCMailIDs
                If strCC.Trim <> "" Then
                    objMM.CC.Add(New MailAddress(strCC.Trim))
                End If
            Next
            'If txtCCID.Text <> "" Then objMM.CC.Add(New MailAddress(txtCCID.Text))

            Dim strBCCMailIDs As String()
            strBCCMailIDs = txtBCCID.Text.Replace(",", ";").Split(";")
            For Each strBCC In strBCCMailIDs
                If strBCC.Trim <> "" Then
                    objMM.Bcc.Add(New MailAddress(strBCC.Trim))
                End If
            Next
            'If txtBCCID.Text <> "" Then objMM.Bcc.Add(New MailAddress(txtBCCID.Text))

            'attachments
            If txtAttachments.Value <> "" Then
                Dim strAttachments As String()
                'strAttachments = txtAttachments.Value.Split(";")
                strAttachments = (txtAttachments.Value.Replace("//", "\").Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries))
                For Each strAttachment In strAttachments
                    If strAttachment <> "" Then
                        Dim strFolderName() As String
                        strFolderName = strAttachment.Split("_")  'txtAttachments.Value.Split("_")
                        If strFolderName(0) <> "" Then
                            'If ConfigurationManager.AppSettings("FolderPath").ToString() = "local" Then
                            '    'local box
                            '    objMM.Attachments.Add(New Attachment(Server.MapPath("~/ClientStorage/" & AccountNumber & "/CreditorDocs/" & strAttachment)))
                            'Else
                            '    '**QA/ production
                            '    objMM.Attachments.Add(New Attachment(DocumentRoot & "/CreditorDocs/" & strAttachment))
                            'End If
                            Dim origAttachPath As String = strAttachment
                            Try
                                If strAttachment.StartsWith("\\") Then
                                    strAttachment = strAttachment.Replace("\\", "\")
                                    strAttachment = strAttachment.Replace("\'", "'")
                                    objMM.Attachments.Add(New Attachment(strAttachment))
                                Else
                                    objMM.Attachments.Add(New Attachment(DocumentRoot & "/CreditorDocs/" & strAttachment))
                                End If
                            Catch ex As Exception
                                Try
                                    objMM.Attachments.Add(New Attachment(origAttachPath))
                                Catch noStripex As Exception
                                    Throw noStripex
                                End Try
                            End Try
                        End If
                    End If
                Next
            End If

            'If ConfigurationManager.AppSettings("FolderPath").ToString() = "local" Then
            '    '***QA  - add DMS QA in the subject
            '    objMM.Subject = "<<<DMS-QA>>>" + "-" + strSubject
            'Else
            'Production
            objMM.Subject = strSubject
            'End If

            objMM.IsBodyHtml = True
            'objMM.Body = txtMailContent.Text& "<BR/><BR/><BR/>" & txtMailFooter.Text
            objMM.Body = txtMailContent.Text & "<BR/><BR/><BR/><table width='100%'><tr><td>___________________________________________________________________________</td></tr><tr><td>" & txtMailFooter.Text & "</td></tr></table>"

            Dim client As New SmtpClient(ConfigurationManager.AppSettings("EmailSMTP").ToString())
            client.Timeout = ConfigurationManager.AppSettings("EmailTimeOut").ToString()
            'Sending Email 
            client.Send(objMM)

            'Note: 1.26.2010 Please add error checking if the sending email fail (use userfriendly.aspx or userfriendlytimeout.aspx)

            ''Save a copy to the email log table
            EmailLogID = SaveEmailtoLog(objMM.Body, objMM.Subject)
            SaveEmailRelayRelation()
            If IntakeEmail = "i" Then
                SaveAutoNote(True)
            End If

            'Hotfix 10/5/10 (jh) - Process the settlement
            If ddlSubject.SelectedItem.Value = "49" Then 'Email To Process Settlement Checks
                ProcessCheckByEmail()
            End If

            'lblMsg.Text = "Email sent successfully"
            Close()
        Catch ex As Exception
            dvError.Style("display") = "block"
            tdError.InnerHtml = ex.Message
            'Response.Redirect("~/userfriendly.aspx")
        End Try
    End Sub

    Private Sub ProcessCheckByEmail()
        Throw New Exception("This feature needs to be updated to Payment Arrangements")
        Dim PaymentId As Integer

        Dim MatterStatusCodeId As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblMatter", "MatterStatusCodeId", "MatterId = " & MatterID))

        If MatterStatusCodeId = 40 Then 'Pending Email Processing
            Dim SettlementId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & MatterID))
            Dim CheckNumber As Integer = CInt(DataHelper.FieldLookup("tblAccount_PaymentProcessing", "CheckNumber", "MatterId = " & MatterID))
            Dim params As New List(Of SqlParameter)
            Dim tblSettlement As DataTable

            params.Add(New SqlParameter("SettlementId", SettlementId))
            tblSettlement = SqlHelper.GetDataTable("stp_CheckReport_SettlementCheck", CommandType.StoredProcedure, params.ToArray)

            SettlementMatterHelper.ResolveEmailProcessing(PaymentId, SettlementId, ClientID, AccountID, UserID, MatterID, Val(tblSettlement.Rows(0)("CheckAmount")), CheckNumber)

            Dim note As String = "Check by Email sent to " & tblSettlement.Rows(0)("CurrentCreditorName") & " #" & Right(CStr(tblSettlement.Rows(0)("CurrentCreditorAcctNo")), 4) & " for " & FormatCurrency(Val(tblSettlement.Rows(0)("CheckAmount")), 2)
            SettlementMatterHelper.AddSettlementNote(SettlementId, note, UserID)
        End If
    End Sub

    Private Sub SaveAutoNote(ByVal blnSent As Boolean)

        If blnSent = True Then
            NoteID = NoteHelper.InsertNote("Email of Client intake sent to local counsel", UserID, ClientID)
        Else
            NoteID = NoteHelper.InsertNote("Sending email with client intake form has been cancelled", UserID, ClientID)
        End If

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "NoteID", NoteID)
        DatabaseHelper.AddParameter(cmd, "RelationTypeID", 19)
        DatabaseHelper.AddParameter(cmd, "RelationID", MatterID)
        DatabaseHelper.BuildInsertCommandText(cmd, "tblNoteRelation", "NoteRelationId", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Using cmdUpdate As New SqlCommand("UPDATE tblNote SET UserGroupID = " + UserGroupID.ToString() + " WHERE NoteID = " + NoteID.ToString(), ConnectionFactory.Create())
            Using cmdUpdate.Connection
                cmdUpdate.Connection.Open()

                cmdUpdate.ExecuteNonQuery()
            End Using
        End Using

    End Sub

    Private Sub SaveEmailRelayRelation()
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "EMailLogID", EmailLogID)
        DatabaseHelper.AddParameter(cmd, "RelationTypeID", 19)
        DatabaseHelper.AddParameter(cmd, "RelationID", MatterID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblEmailRelayRelation", "EmailRelayRelationID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

    Private Function SaveEmailtoLog(ByVal strBody As String, ByVal strSubject As String) As Integer
        Dim NewId As Integer

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.Connection.Open()
                cmd.CommandText = "stp_InsertEmailRelayLog"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "FromMailID", txtFromID.Text)
                DatabaseHelper.AddParameter(cmd, "ToMailID", txtToID.Text)
                DatabaseHelper.AddParameter(cmd, "CCMailID", txtCCID.Text)
                DatabaseHelper.AddParameter(cmd, "BCCMailID", txtBCCID.Text)
                DatabaseHelper.AddParameter(cmd, "MailSubject", strSubject)
                DatabaseHelper.AddParameter(cmd, "MailMessage", strBody)
                DatabaseHelper.AddParameter(cmd, "Attachment", txtAttachments.Value)
                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                DatabaseHelper.AddParameter(cmd, "MailFooter", txtMailFooter.Text)
                DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
                DatabaseHelper.AddParameter(cmd, "UserGroupID", UserGroupID)
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()

                        NewId = rd("NewId")

                    End While
                End Using
            End Using
        End Using
        Return NewId
    End Function

End Class
