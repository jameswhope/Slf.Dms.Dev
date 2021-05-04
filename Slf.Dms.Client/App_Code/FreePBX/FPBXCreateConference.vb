Imports Microsoft.VisualBasic
Imports System.Runtime.Serialization.Json.DataContractJsonSerializer
Imports System.Data.SqlClient

Public Class FPBXCreateConferenceRequest
    Public phone As String
    Public callid As String
    Public callerid As String
End Class

Public Class FPBXCreateConferenceResponse
    Public conferenceid As String
    Public phone As String
End Class

Public Class FPBXcreateconferenceAction
    Inherits FPBXAction

    Public Overrides Function Execute(ByVal json As String) As String
        Dim req As FPBXCreateConferenceRequest = CType(readJson(json, GetType(FPBXCreateConferenceRequest)), FPBXCreateConferenceRequest)
        Dim resp As New FPBXCreateConferenceResponse
        Dim phone As String = SmartDebtorHelper.CleanPhoneNumber(req.phone)
        Dim userid As Integer = HttpContext.Current.User.Identity.Name
        Dim callerid As String = req.callerid
        If callerid.Trim.Length = 0 Then callerid = FreePBXHelper.GetDefaultCallerId(0, userid)
        resp.phone = phone
        resp.conferenceid = FreePBXHelper.InsertConferenceCall(req.callid, phone, userid, callerid)
        Return writeJson(resp)
    End Function

End Class

