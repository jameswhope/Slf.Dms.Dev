Imports Microsoft.VisualBasic
Imports System.Net.Mail

Public Class emailHelper
#Region "Methods"

    Public Shared Sub SendMessage(ByVal from As String, ByVal [to] As String, ByVal subject As String, ByVal body As String)
        Dim email As New SmtpClient(ConfigurationManager.AppSettings("emailSMTP").ToString)
        Dim message As New MailMessage()
        message.From = New MailAddress(from)
        For Each addr As String In [to].Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
            message.To.Add(addr)
        Next
        message.Subject = subject
        message.Body = body

        message.IsBodyHtml = True

        Try
            email.ServicePoint.MaxIdleTime = 1
            email.Send(message)
        Catch ex As Exception
            LeadHelper.LogError("SendMessage", ex.Message, String.Concat(from, "|", [to], "|", subject, "|", body))
        Finally
            message.Dispose()
            message = Nothing
        End Try
    End Sub

    Public Shared Sub SendMessage(ByVal from As String, ByVal [to] As String, ByVal subject As String, ByVal body As String, ByVal attachments As List(Of String))
        Dim email As New SmtpClient(ConfigurationManager.AppSettings("emailSMTP").ToString)
        Dim message As New MailMessage()
        message.From = New MailAddress(from)
        For Each addr As String In [to].Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
            message.To.Add(addr)
        Next
        message.Subject = subject
        message.Body = body

        message.IsBodyHtml = True

        'create the mail message
        Dim mail As New MailMessage()

        For Each att As String In attachments
            message.Attachments.Add(New Attachment(att))
        Next

        Try
            email.Send(message)
        Catch ex As Exception
            LeadHelper.LogError("SendMessage", ex.Message, String.Concat(from, "|", [to], "|", subject, "|", body, "|attachments"))
        End Try
    End Sub

#End Region 'Methods 
End Class
