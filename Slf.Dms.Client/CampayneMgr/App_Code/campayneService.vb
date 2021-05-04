Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://CampayneMgr.com/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class campayneService
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function HelloWorld() As String
        Return "Hello World"
    End Function

    <WebMethod()> _
    Public Sub SendEmailMessage(ByVal from As String, ByVal [to] As String, ByVal subject As String, ByVal body As String, smtpServerAddress As String, smtpUser As String, smtpPassword As String)
        LeadHelper.LogError("SendMessage", from, subject)

        Dim email As New Net.Mail.SmtpClient(smtpServerAddress)

        Dim message As New Net.Mail.MailMessage()
        message.From = New Net.Mail.MailAddress(from)
        message.To.Add([to])
        message.Subject = subject
        message.Body = body
        message.IsBodyHtml = True

        Try
            'make sure we have someone to send it to if all emails were invalid
            If message.To.Count > 0 Then
                'Dim nc As New Net.NetworkCredential(smtpUser, smtpPassword)
                'email.UseDefaultCredentials = False
                'email.Credentials = nc
                email.DeliveryMethod = Net.Mail.SmtpDeliveryMethod.Network
                'email.EnableSsl = True
                'Net.ServicePointManager.SecurityProtocol = Net.SecurityProtocolType.Tls 
                email.ServicePoint.MaxIdleTime = 1
                email.Send(message)
            End If
        Catch ex As Exception
            LeadHelper.LogError("SendMessage", ex.Message, ex.StackTrace)
            Throw
        End Try
    End Sub

End Class