Imports System
Imports System.IO
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Partial Class processing_popups_ResendCheckByEmail
    Inherits System.Web.UI.Page

    Dim UserId As Integer
    Dim LogId As Integer

#Region "Events"
    ''' <summary>
    ''' Loads the content of the page
    ''' </summary>    
    ''' <remarks>sid is the settlementId</remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Request.QueryString("lid") Is Nothing AndAlso Not Request.QueryString("cn") Is Nothing AndAlso Not Request.QueryString("mid") Is Nothing Then
            LogId = Integer.Parse(Request.QueryString("lid"))
            Me.hdnCheckNumber.Value = Request.QueryString("cn").ToString.Trim
            Me.hdnSettlementId.Value = CInt(DataHelper.FieldLookup("tblSettlements", "SettlementId", "MatterId = " & Request.QueryString("mid")))
            If Not Me.IsPostBack Then
                chkOverride.Checked = True
                LoadEmailLog()
            End If
        End If

    End Sub

    Private Sub LoadEmailLog()
        Dim dt As DataTable = SettlementMatterHelper.GetChecksByEmailLog(LogId)
        If dt.Rows.Count > 0 Then
            Me.hdnFromAddress.Value = dt.Rows(0)("From")

            Me.hdnClientId.Value = dt.Rows(0)("ClientId")

            Me.txtRecipientEmail.Text = dt.Rows(0)("To")
            Me.lblDateSent.Text = String.Format("{0:g}", CDate(dt.Rows(0)("Sent")))
            Me.lblSentBy.Text = dt.Rows(0)("By")
            Me.lblSubject.Text = dt.Rows(0)("MailSubject")
            Me.ltrBody.Text = dt.Rows(0)("MailMessage")
        End If
    End Sub


    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Try
            Dim sendTo As String = txtRecipientEmail.Text.Trim
            sendTo = "opereira@lexxiom.com"
            Dim mailMsg As New System.Net.Mail.MailMessage(hdnFromAddress.Value.Trim, sendTo, lblSubject.Text & " - COPY", Me.ltrBody.Text)
            Dim mailSmtp As New System.Net.Mail.SmtpClient(ConfigurationManager.AppSettings("EmailSMTP"))
            mailMsg.IsBodyHtml = True
            mailSmtp.Send(mailMsg)
            Dim UserGroupId = CInt(DataHelper.FieldLookup("tblUser", "UserGroupId", "UserId=" & UserId))

            SettlementMatterHelper.SaveEmailtoLog(hdnFromAddress.Value.Trim, sendTo, Me.ltrBody.Text, Me.lblSubject.Text, UserId, "", hdnClientId.Value, UserGroupId)
            Dim username As String = DialerHelper.GetUserFullName(UserId)
            Dim note As String = String.Format("A copy of check #{0} was sent to {1} by {2}.", hdnCheckNumber.Value.Trim, sendTo, username)
            If chkOverride.Checked Then
                SettlementMatterHelper.ChangeDeliveryEmailAddress(hdnSettlementId.Value, sendTo)
                note = note & String.Format(" The delivery email address for other payments by email on this settlement has been updated to {0}.", sendTo)
            End If

            SettlementMatterHelper.AddSettlementNote(hdnSettlementId.Value, note, UserId)
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "closethiswindow", "CloseSend();", True)
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "reporterror", String.Format("ShowMessage('{0}');", ex.Message.Replace("'", "")), True)
        End Try
    End Sub

#End Region



End Class
