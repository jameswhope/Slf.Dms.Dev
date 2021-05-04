Imports Microsoft.VisualBasic
Imports System.Runtime.Serialization.Json.DataContractJsonSerializer
Imports System.Configuration
Imports System.IO

Public Class FPBXSettlementRecordingRequest
    Public clientid As String
    Public matterid As String
    Public callId As String
    Public recordingid As String
    Public filename As String
End Class

Public Class FPBXSettlementRecordingResponse
    Public filename As String
End Class

Public Class FPBXsettlementrecordingAction
    Inherits FPBXAction

    Public Overrides Function Execute(ByVal json As String) As String
        Dim newfilename As String = ""
        Dim req As FPBXSettlementRecordingRequest = CType(readJson(json, GetType(FPBXSettlementRecordingRequest)), FPBXSettlementRecordingRequest)
        Dim resp As New FPBXSettlementRecordingResponse
        Dim recordingpath As String = ConfigurationManager.AppSettings("settlementrecordings")
        Dim userid As Integer = HttpContext.Current.User.Identity.Name
        If CInt(req.clientid) > 0 And CInt(req.recordingid > 0) And CInt(req.matterid > 0) Then
            If recordingpath.Trim.Length > 0 AndAlso req.filename.Trim.Length > 0 Then
                'Attach the document
                newfilename = FreePBXHelper.AttachRecordedDocument(req.clientid, userid, Path.Combine(recordingpath, req.filename.Trim), "9074", "ClientDocs", ".wav")
                'Update Settlement Recording
                If newfilename.Trim.Length > 0 Then
                    FreePBXHelper.AttachDocToReference("matter", req.matterid, userid, Path.GetFileName(newfilename), "ClientDocs")
                    CallControlsHelper.UpdateCallRecording(req.recordingid, "", newfilename, "", 0, "")
                End If
            End If
        End If
        resp.filename = newfilename
        Return writeJson(resp)
    End Function

End Class

