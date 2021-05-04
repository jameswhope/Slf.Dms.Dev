Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Net.Mail
Imports System.Configuration.ConfigurationManager

Public Class HydraHelper

    Public Enum EmailType
        Followup_1
        Followup_2
    End Enum

    Public Shared Function GetCompanyID(ByVal StateID As Integer) As Integer
        Dim companyID As Integer = CInt(SqlHelper.ExecuteScalar("select companyid from tblState where stateid = " & StateID, CommandType.Text))
        Return companyID
    End Function

    Public Shared Function GetRepID() As Integer
        Dim repID As Integer = CInt(SqlHelper.ExecuteScalar("select top 1 userid from tblleadhydra order by lastleadassignedto", CommandType.Text))
        Return repID
    End Function

    Public Shared Sub UpdateLeadLastAssignedTo(ByVal RepID As Integer)
        SqlHelper.ExecuteNonQuery("update tblleadhydra set lastleadassignedto=getdate() where userid=" & RepID, CommandType.Text)
    End Sub

    Public Shared Function InsertLeadEmail(ByVal LeadApplicantID As Integer, ByVal Email As String, ByVal Type As String, ByVal Subject As String, ByVal SentBy As Integer) As Integer
        Dim cmdText As String = String.Format("insert tblleademails (leadapplicantid,email,type,subject,sentby) values ({0},'{1}','{2}','{3}',{4}) select scope_identity()", LeadApplicantID, Email, Type, Subject, SentBy)
        Return CInt(SqlHelper.ExecuteScalar(cmdText, CommandType.Text))
    End Function

    Public Shared Sub SendThankYouEmail(ByVal SendTo As String, ByVal RepID As Integer, ByVal CompanyID As Integer, ByVal EmailID As Integer)
        Dim body As String
        Dim CompanyName As String = GetCompanyName(CompanyID)
        Dim LandingPage As String = GetLandingPage(CompanyID)
        Dim ImgSrc As String = String.Format("http://www.{0}/images/{1}.aspx", LandingPage, EmailID)
        Dim from As String

        If RepID > 0 Then
            Dim tblUser As DataTable
            Dim ext As String
            tblUser = GetUserInfo(RepID)
            ext = GetUserExt(RepID)
            from = CStr(tblUser.Rows(0)("emailaddress"))
            body = String.Format("<font style='font-family:arial; font-size:12px'>The recent internet inquiry you submitted has been received.<br><br>My name is {0}, and I am writing you on behalf of {1} Client Intake Department. I have been assigned to assist with your case and will be contacting you shortly to discuss your situation and your objectives. Should you need immediate assistance, you may reach me directly at {2} x{3} or email me at {4}. <br><br>Thank you.<br><br><br><br>{0}<br>Law Firm Representative<br>{2} x{3}</font><img src='{5}'>", tblUser.Rows(0)("name"), CompanyName, AppSettings("LawFirmRepPhone"), ext, tblUser.Rows(0)("emailaddress"), ImgSrc)
        Else
            Dim contact As String = GetContactName(CompanyID)
            from = "clientintake@lawfirmsd.com"
            body = String.Format("<font style='font-family:arial; font-size:12px'>The recent internet inquiry you submitted has been received.<br><br>My name is {0}, and I am writing you on behalf of my firm, {1}. I have assigned your case to our client intake department. Someone from my office will be contacting you shortly to discuss your situation and your objectives. Should you need immediate assistance, you may reach us directly at {2} or email us at clientintake@lawfirmsd.com. <br><br>Thank you.<br><br><br><br>{0}<br>{1}</font><img src='{3}'>", contact, CompanyName, AppSettings("LawFirmRepPhone"), ImgSrc)
        End If

        Dim mailMsg As New MailMessage(from, SendTo, "We received your request", body)
        Dim mailSmtp As New SmtpClient(AppSettings("EmailSMTP"))
        mailMsg.IsBodyHtml = True
        mailSmtp.Send(mailMsg)

        Try
            SqlHelper.ExecuteNonQuery(String.Format("update tblleademails set body = '{0}' where leademailid = {1}", body.Replace("'", "''"), EmailID), CommandType.Text)
        Catch ex As Exception
            'do nothing
        End Try
    End Sub

    Public Shared Sub SendFollowup(ByVal Type As EmailType, ByVal LeadApplicantID As Integer, ByVal SendTo As String, ByVal RepID As Integer, ByVal CompanyID As Integer)
        Dim tblLead As DataTable = GetLeadInfo(LeadApplicantID)
        Dim tblUser As DataTable = GetUserInfo(RepID)
        Dim CompanyName As String = GetCompanyName(CompanyID)
        Dim LandingPage As String = GetLandingPage(CompanyID)
        Dim Phone As String = ConfigurationManager.AppSettings("LawFirmRepPhone")
        Dim Ext As String = GetUserExt(RepID)
        Dim subject As String = ""
        Dim body As String = ""
        Dim EmailID As Integer
        Dim ImgSrc As String

        Select Case Type
            Case EmailType.Followup_1
                subject = String.Format("{0} - Follow Up", CompanyName)
            Case EmailType.Followup_2
                subject = String.Format("{0} - Final Attempt", CompanyName)
        End Select

        EmailID = CInt(SqlHelper.ExecuteScalar(String.Format("insert tblleademails (leadapplicantid,email,type,subject,sentby) values ({0},'{1}','{2}','{3}',{4}) select scope_identity()", LeadApplicantID, SendTo, [Enum].GetName(GetType(EmailType), Type).Replace("_", " #"), subject, RepID), CommandType.Text))
        ImgSrc = String.Format("http://www.{0}/images/{1}.aspx", LandingPage, EmailID)

        Select Case Type
            Case EmailType.Followup_1
                'body = String.Format("<font style='font-family:arial; font-size:12px'>Mr./Mrs. {0}, this is {1} with {2} Client Intake Department. On {3} you inquired online regarding your debt. My attempt to reach you was unsuccessful. Should you wish to contact me I can be reached at {4} x{5}. I am available from 8AM to 5PM to discuss your case. I look forward to speaking with you.<br><br><br><br>{1}<br>Law Firm Representative<br>{4} x{5}</font><br><a href='http://www.{6}/unsubscribe.aspx?email={7}&id={8}' style='font-family:arial; font-size: 11px; color: #999999; text-decoration:none'>unsubscribe</a><img src='{9}'>", tblLead.Rows(0)(0), tblUser.Rows(0)("name"), CompanyName, Format(CDate(tblLead.Rows(0)(1)), "M/d/yyyy"), Phone, Ext, LandingPage, System.Web.HttpUtility.UrlEncode(SendTo), EmailID, ImgSrc)
                body = String.Format("<font style='font-family:arial; font-size:12px'>Mr./ Mrs. {0}, this is {1} on behalf of {2} Client Intake Department. On {3} you inquired online regarding your debt. My attempt to reach you was unsuccessful. Should you wish to contact me I can be reached at {4} x{5}. I am available from 8AM PST to 5PM PST to discuss your inquiry. I look forward to speaking with you.<br><br><br><br>{1}<br>Law Firm Representative<br>{4} x{5}</font><br><a href='http://www.{6}/unsubscribe.aspx?email={7}&id={8}' style='font-family:arial; font-size: 11px; color: #999999; text-decoration:none'>unsubscribe</a><img src='{9}'>", tblLead.Rows(0)(0), tblUser.Rows(0)("name"), CompanyName, Format(CDate(tblLead.Rows(0)(1)), "M/d/yyyy"), Phone, Ext, LandingPage, System.Web.HttpUtility.UrlEncode(SendTo), EmailID, ImgSrc)
            Case EmailType.Followup_2
                'body = String.Format("<font style='font-family:arial; font-size:12px'>Mr./Mrs. {0}, this is {1} with {2} Client Intake Department. I have made several attempts to contact you via phone and email. It is my responsibility to ensure that every potential client is given an opportunity to discuss their case. It is important that I speak with you soon to discuss your case and resolve your inquiry request. Please contact me at {3} x{4} or email me at {5}. Thank you.<br><br><br><br>{1}<br>Law Firm Representative<br>{3} x{4}</font><br><a href='http://www.{6}/unsubscribe.aspx?email={7}&id={8}' style='font-family:arial; font-size: 11px; color: #999999; text-decoration:none'>unsubscribe</a><img src='{9}'>", tblLead.Rows(0)(0), tblUser.Rows(0)("name"), CompanyName, Phone, Ext, tblUser.Rows(0)("emailaddress"), LandingPage, System.Web.HttpUtility.UrlEncode(SendTo), EmailID, ImgSrc)
                body = String.Format("<font style='font-family:arial; font-size:12px'>Mr./ Mrs. {0}, this is {1} on behalf of {2} Client Intake Department. I have made several attempts to contact you via phone and email. It is my responsibility to ensure that every prospective client is given an opportunity to discuss their case. It is important that I speak with you soon to discuss your case and resolve your inquiry request. Please contact me at {3} x{4} or email me at {5}. This is our final attempt to contact you. Please understand that our efforts to contact you have not created an attorney-client relationship, and that we do not represent you at this time. We do hope to hear from you in response to this message.<br/><br/>Thank you.<br><br><br><br>{1}<br>Law Firm Representative<br>{3} x{4}</font><br><a href='http://www.{6}/unsubscribe.aspx?email={7}&id={8}' style='font-family:arial; font-size: 11px; color: #999999; text-decoration:none'>unsubscribe</a><img src='{9}'>", tblLead.Rows(0)(0), tblUser.Rows(0)("name"), CompanyName, Phone, Ext, tblUser.Rows(0)("emailaddress"), LandingPage, System.Web.HttpUtility.UrlEncode(SendTo), EmailID, ImgSrc)
        End Select

        Dim mailMsg As New MailMessage(tblUser.Rows(0)("emailaddress"), SendTo, subject, body)
        Dim mailSmtp As New SmtpClient(AppSettings("EmailSMTP"))
        mailMsg.IsBodyHtml = True
        mailSmtp.Send(mailMsg)
    End Sub

    Public Shared Sub SendRepNotification(ByVal RepID As Integer, ByVal LeadName As String)
        Dim tblUser As DataTable

        Try
            tblUser = GetUserInfo(RepID)
            Dim mailMsg As New MailMessage("donotreply@lawfirmsd.com", tblUser.Rows(0)("emailaddress"), "New Lead, " & LeadName, "You have a new lead in your pipeline, " & LeadName)
            Dim mailSmtp As New SmtpClient(AppSettings("EmailSMTP"))
            mailMsg.IsBodyHtml = True
            mailSmtp.Send(mailMsg)
        Catch ex As Exception
            'do nothing
        End Try
    End Sub

    Private Shared Function GetCompanyName(ByVal CompanyID As Integer) As String
        Dim name As String = CStr(SqlHelper.ExecuteScalar("select name from tblcompany where companyid = " & CompanyID, Data.CommandType.Text))
        Return name
    End Function

    Private Shared Function GetContactName(ByVal CompanyID As Integer) As String
        Dim name As String = CStr(SqlHelper.ExecuteScalar("select contact1 from tblcompany where companyid = " & CompanyID, Data.CommandType.Text))
        Return name
    End Function

    Private Shared Function GetLandingPage(ByVal CompanyID As Integer) As String
        Dim page As String = CStr(SqlHelper.ExecuteScalar("select landingpage from tblcompany where companyid = " & CompanyID, CommandType.Text))
        Return page
    End Function

    Private Shared Function GetLeadInfo(ByVal LeadApplicantID As Integer) As DataTable
        Dim tbl As DataTable = SqlHelper.GetDataTable("select firstname + ' ' + lastname, created from tblleadapplicant where leadapplicantid = " & LeadApplicantID)
        Return tbl
    End Function

    Private Shared Function GetUserInfo(ByVal UserID As Integer) As DataTable
        Dim tbl As DataTable = SqlHelper.GetDataTable("select firstname + ' ' + lastname[name], emailaddress, username from tbluser where userid = " & UserID)
        Return tbl
    End Function

    Private Shared Function GetUserExt(ByVal UserID As Integer) As String
        Dim ext As String = "000"
        Dim tbl As DataTable
        Dim params(0) As SqlParameter

        params(0) = New SqlParameter("userid", UserID)
        tbl = SqlHelper.GetDataTable("stp_SmartDebtor_GetAgentInfoFromUserID", CommandType.StoredProcedure, params)
        If tbl.Rows.Count = 1 Then
            ext = tbl.Rows(0)(0) 'ParaLegalExt
        End If

        Return ext
    End Function

End Class
