Imports Microsoft.VisualBasic
Imports System.Runtime.Serialization.Json.DataContractJsonSerializer
Imports System.Configuration
Imports System.IO

Public Class FPBXVerificationRecordingRequest
    Public [type] As String
    Public personid As String
    Public persontype As String
    Public callId As String
    Public referenceid As String
    Public filename As String
End Class

Public Class FPBXVerificationRecordingResponse
    Public filename As String
End Class

Public Class FPBXverificationrecordingAction
    Inherits FPBXAction

    Private Function AttachDocument(ByVal req As FPBXVerificationRecordingRequest, ByVal recordingpath As String, ByVal userid As Integer) As String
        Dim doc As String = String.Empty
        Select Case req.persontype.ToLower
            Case "client"
                Dim DocTypeId As String = "9072"
                doc = FreePBXHelper.AttachRecordedDocument(req.personid, userid, Path.Combine(recordingpath, req.filename.Trim), DocTypeId, "ClientDocs", ".wav")
            Case "lead applicant"
                Dim leaddocspath As String = ConfigurationManager.AppSettings("leadDocumentsDir").ToString '.Replace("\", "\\")
                leaddocspath = Path.Combine(leaddocspath, "audio")
                Dim leadverificationfile As String = Path.Combine(leaddocspath, req.filename.Trim)
                File.Move(Path.Combine(recordingpath, req.filename.Trim), leadverificationfile)
                SmartDebtorHelper.SaveLeadDocument(req.personid, Path.GetFileNameWithoutExtension(req.filename.Trim), userid, SmartDebtorHelper.DocType.VerificationRecorded)
                doc = leadverificationfile
        End Select
        Return doc
    End Function

    Public Overrides Function Execute(ByVal json As String) As String
        Dim newfilename As String = ""
        Dim req As FPBXVerificationRecordingRequest = CType(readJson(json, GetType(FPBXVerificationRecordingRequest)), FPBXVerificationRecordingRequest)
        Dim resp As New FPBXVerificationRecordingResponse
        Dim recordingpath As String = ConfigurationManager.AppSettings("verificationrecordings")
        Dim ehostdomain As String = System.Configuration.ConfigurationManager.AppSettings("externalhostdomain").ToString
        If HttpContext.Current.Request.ServerVariables("SERVER_NAME").ToString.Contains(ehostdomain) Then
            recordingpath = ConfigurationManager.AppSettings("verificationrecordingsEM").ToString
        End If
        Dim userid As Integer = HttpContext.Current.User.Identity.Name
        If CInt(req.personid) > 0 And CInt(req.referenceid > 0) Then
            If recordingpath.Trim.Length > 0 AndAlso req.filename.Trim.Length > 0 Then
                'Attach the document
                newfilename = AttachDocument(req, recordingpath, userid)
                'Update CallVerification
                If newfilename.Trim.Length > 0 Then
                    CallVerificationHelper.UpdateVerificationCall(req.referenceid, Now, True, req.callId, newfilename, "", "", "")
                End If
            End If
        End If
        resp.filename = newfilename
        Return writeJson(resp)
    End Function

End Class

