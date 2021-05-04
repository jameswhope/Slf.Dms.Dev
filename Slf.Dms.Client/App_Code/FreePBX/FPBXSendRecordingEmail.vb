Imports Microsoft.VisualBasic
Imports System.Runtime.Serialization.Json.DataContractJsonSerializer
Imports System.Configuration
Imports System.Collections.Generic
Imports System.IO

Public Class FPBXSendRecordingEmailRequest
    Public callId As String
    Public filename As String
End Class

Public Class FPBXSendRecordingEmailResponse
    Public status As String
End Class

Public Class FPBXsendrecordingemailAction
    Inherits FPBXAction

    Public Overrides Function Execute(ByVal json As String) As String

        Dim req As FPBXSendRecordingEmailRequest = CType(readJson(json, GetType(FPBXSendRecordingEmailRequest)), FPBXSendRecordingEmailRequest)
        Dim resp As New FPBXSendRecordingEmailResponse
        Dim recordingpath As String = ConfigurationManager.AppSettings("recordingspath")
        Dim userid As Integer = HttpContext.Current.User.Identity.Name

        Dim email As String = EmailHelper.GetUserEmailAddress(userid)
        resp.status = "Email not sent."
        If CInt(req.callId) > 0 AndAlso email.Trim.Length > 0 Then
            If recordingpath.Trim.Length > 0 AndAlso req.filename.Trim.Length > 0 Then
                Dim attachments As New List(Of String)
                Dim files As String() = Directory.GetFiles(recordingpath, req.filename & "*.*")
                If files.Length > 0 Then
                    attachments.Add(files(0))
                    Try
                        EmailHelper.SendMessage("noreply@lexxfreepbx.com", email, "Conversation Recorded File", String.Format("Email sent automatically by FreePBX server on {0:d}", Now), attachments)
                        resp.status = "Email sent."
                    Catch ex As Exception
                        'Ignore
                    End Try
                End If
            End If
        End If

        Return writeJson(resp)
    End Function

End Class

