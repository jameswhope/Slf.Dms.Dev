Imports System.Data
Imports Microsoft.VisualBasic
Imports System.Runtime.Serialization.Json.DataContractJsonSerializer
Imports System.Configuration
Imports System.IO

Public Class VicidialStopManualRecordingRequest
    Public [type] As String
    Public serverip As String
    Public filename As String
    Public referenceid As String
    Public callid As String
    Public completed As String
End Class

Public Class VicidialStopManualRecordingResponse
    Public filename As String
End Class

Public Class VicidialstopmanualrecordingAction
    Inherits VicidialAction

    Public Overrides Function Execute(ByVal json As String) As String
        Dim req As VicidialStopManualRecordingRequest = CType(readJson(json, GetType(VicidialStopManualRecordingRequest)), VicidialStopManualRecordingRequest)
        Dim resp As New VicidialStopManualRecordingResponse With {.filename = req.filename}
        Dim dt As DataTable = VicidialHelper.GetManualRecording(req.filename)
        If dt.Rows.Count > 0 Then
            VicidialHelper.StopManualRecording(req.serverip, dt.Rows(0)("channel"))
            VicidialHelper.CloseManualRecording(req.filename)
        End If
        If req.completed = "1" Then
            Select Case req.type.Trim.ToLower
                Case "settlement"
                    DialerHelper.UpdateSettlementRecordedCall(req.referenceid, Nothing, Nothing, Nothing, "", req.filename)
                Case "verification"
                    CallVerificationHelper.UpdateVerificationCall(req.referenceid, Nothing, Nothing, req.callid, "", "", "", req.filename)
            End Select
        End If
        resp.filename = req.filename
        Return writeJson(resp)
    End Function

End Class

