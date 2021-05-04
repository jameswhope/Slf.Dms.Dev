Imports Microsoft.VisualBasic
Imports System.Runtime.Serialization.Json.DataContractJsonSerializer
Imports System.Configuration
Imports System.IO

Public Class VicidialStartManualRecordingRequest
    Public serverip As String
    Public filename As String
    Public channel As String
End Class

Public Class VicidialStartManualRecordingResponse
    Public filename As String
End Class

Public Class VicidialstartmanualrecordingAction
    Inherits VicidialAction

    Public Overrides Function Execute(ByVal json As String) As String
        Dim req As VicidialStartManualRecordingRequest = CType(readJson(json, GetType(VicidialStartManualRecordingRequest)), VicidialStartManualRecordingRequest)
        Dim resp As New VicidialStartManualRecordingResponse With {.filename = req.filename}
        VicidialHelper.StartManualRecording(req.serverip, req.filename, req.channel)
        Return writeJson(resp)
    End Function

End Class

