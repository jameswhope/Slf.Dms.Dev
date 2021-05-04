Imports System.Net.Mail
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

Partial Class admin_settings_references_AddEditGenEmai
    Inherits System.Web.UI.Page


#Region "Variables"
    Private Action As String
    Private qs As QueryStringCollection
    Private strToMailID As String
    Public MatterID As Integer
    Public EmailConfigID As Integer
    Public AccountID As Integer
    Public UserID As Integer
    Public Shadows ClientID As Integer
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        qs = LoadQueryString()
        If Not qs Is Nothing Then
            ClientID = DataHelper.Nz_int(qs("id"), 0)
            AccountID = DataHelper.Nz_int(qs("aid"), 0)
            EmailConfigID = DataHelper.Nz_int(qs("Eid"), 0)
            Action = DataHelper.Nz_string(qs("a"))
            'MatterID = DataHelper.Nz_int(qs("mid"), 0)
        End If
        If Not IsPostBack Then
            UserID = DataHelper.Nz_int(Page.User.Identity.Name)
            'txtFromID.Text = DataHelper.FieldLookup("tblUser", "emailaddress", "UserId=" & UserID)
            LoadLawFirms()
            If EmailConfigID > 0 Then
                FetchEmailTemplateDetails()
            End If
        End If
        HandleAction()
        'FetchAttorneyEMailID()
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

    Private Sub HandleAction()

        If Action = "a" Then
            lblTitle.Text = "Add General Email Template"
        ElseIf Action = "e" Then
            lblTitle.Text = "Edit General Email Template"
        End If

        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""SendMail();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_email.png") & """ align=""absmiddle""/>Save Email Template</a>")

    End Sub

    Private Sub LoadLawFirms()
        ddlLawFirm.Items.Clear()
        ddlLawFirm.Items.Add(New ListItem("Select Lawfirm", 0))
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT CompanyID, Name FROM tblCompany order by Name"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim EntryTypeID As Integer = DatabaseHelper.Peel_int(rd, "CompanyID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
                        ddlLawFirm.Items.Add(New ListItem(Name, EntryTypeID))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub FetchAttorneyEMailID()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        Try
            cmd.CommandText = " select ta.emailaddress from tblmatter tm, tblAttorney ta where tm.attorneyid=ta.attorneyid and tm.matterid=@matterid"
            DatabaseHelper.AddParameter(cmd, "matterid", MatterID)

            Try
                cmd.Connection.Open()
                rd = cmd.ExecuteReader()
                While rd.Read()
                    strToMailID = DatabaseHelper.Peel_string(rd, "emailaddress")
                    txtToID.Text = strToMailID
                End While
            Finally

            End Try
        Catch ex As Exception
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Private Sub FetchEmailTemplateDetails()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        Try
            cmd.CommandText = "select MailFrom, MailCC, MailBCC, MailSubject,MailPurpose, MailContent, MailFooter, MType, LawfirmId from tblEmailConfiguration where EmailConfigID=@EmailConfigID"
            DatabaseHelper.AddParameter(cmd, "EmailConfigID", EmailConfigID)

            Try
                cmd.Connection.Open()
                rd = cmd.ExecuteReader()
                While rd.Read()
                    txtFromID.Text = DatabaseHelper.Peel_string(rd, "MailFrom")
                    txtCCID.Text = DatabaseHelper.Peel_string(rd, "MailCC")
                    txtBCCID.Text = DatabaseHelper.Peel_string(rd, "MailBCC")
                    txtSubject.Text = DatabaseHelper.Peel_string(rd, "MailSubject")
                    txtPurpose.Text = DatabaseHelper.Peel_string(rd, "MailPurpose")
                    txtMailContent.Text = DatabaseHelper.Peel_string(rd, "MailContent")
                    txtMailFooter.Text = DatabaseHelper.Peel_string(rd, "MailFooter")
                    ddlMailType.SelectedIndex = ddlMailType.Items.IndexOf(ddlMailType.Items.FindByValue(DatabaseHelper.Peel_string(rd, "MType")))
                    ddlLawFirm.SelectedIndex = ddlLawFirm.Items.IndexOf(ddlLawFirm.Items.FindByValue(DatabaseHelper.Peel_int(rd, "LawfirmId")))
                End While
            Finally

            End Try
        Catch ex As Exception
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Protected Sub lnkSendMail_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSendMail.Click

        'SendMail()
        SaveMailTemplate()

        Close()

    End Sub

    Private Sub SaveMailTemplate()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.Connection.Open()
                cmd.CommandText = "stp_InsertMatterEmailTemplate"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "EmailConfigID", EmailConfigID)
                DatabaseHelper.AddParameter(cmd, "MailFrom", txtFromID.Text)
                DatabaseHelper.AddParameter(cmd, "MailCC", txtCCID.Text)
                DatabaseHelper.AddParameter(cmd, "MailBCC", txtBCCID.Text)
                DatabaseHelper.AddParameter(cmd, "MailSubject", txtSubject.Text)
                DatabaseHelper.AddParameter(cmd, "MailPurpose", txtPurpose.Text)
                DatabaseHelper.AddParameter(cmd, "MailContent", txtMailContent.Text)
                DatabaseHelper.AddParameter(cmd, "MailFooter", txtMailFooter.Text)
                DatabaseHelper.AddParameter(cmd, "MType", ddlMailType.SelectedValue)
                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                DatabaseHelper.AddParameter(cmd, "LawfirmId", ddlLawFirm.SelectedValue)
                cmd.ExecuteNonQuery()
            End Using
        End Using

    End Sub

    Private Sub SendMail()
        Dim objMM As New MailMessage()
        objMM.From = New MailAddress(txtFromID.Text)
        'If strToMailID <> "" Then objMM.To.Add(New MailAddress(strToMailID))
        If txtToID.Text <> "" Then objMM.To.Add(New MailAddress(txtToID.Text))
        If txtCCID.Text <> "" Then objMM.CC.Add(New MailAddress(txtCCID.Text))
        If txtBCCID.Text <> "" Then objMM.Bcc.Add(New MailAddress(txtBCCID.Text))

        'attachments
        If txtAttachments.Value <> "" Then
            Dim strAttachments As String()
            strAttachments = txtAttachments.Value.Split(";")
            For Each strAttachment In strAttachments
                If strAttachment <> "" Then
                    Dim strFolderName() As String
                    strFolderName = strAttachment.Split("_")  'txtAttachments.Value.Split("_")
                    If strFolderName(0) <> "" Then
                        'objMM.Attachments.Add(New Attachment(Server.MapPath("~/ClientStorage/" & strFolderName(0) & "/LegalDocs/" & txtAttachments.Value)))
                        objMM.Attachments.Add(New Attachment(Server.MapPath("~/ClientStorage/" & strFolderName(0) & "/LegalDocs/" & strAttachment)))

                    End If
                End If
            Next
        End If

        objMM.Subject = txtSubject.Text
        objMM.IsBodyHtml = True
        'objMM.Body = txtMailContent.Text& "<BR/><BR/><BR/>" & txtMailFooter.Text
        objMM.Body = txtMailContent.Text & "<BR/><BR/><BR/><table width='100%'><tr><td>" & txtMailFooter.Text & "</td></tr></table>"

        Dim client As New SmtpClient(ConfigurationManager.AppSettings("EmailSMTP").ToString())
        client.Timeout = ConfigurationManager.AppSettings("EmailTimeOut").ToString()
        client.Send(objMM)
        lblMsg.Text = "Email sent successfully"
    End Sub

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub

    Private Sub Close()
        Response.Redirect("~/admin/settings/generalemails.aspx")
    End Sub

End Class
