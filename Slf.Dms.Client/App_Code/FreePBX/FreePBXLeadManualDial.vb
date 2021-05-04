Imports Microsoft.VisualBasic
Imports System.Runtime.Serialization.Json.DataContractJsonSerializer
Imports System.Data.SqlClient

Public Class FPBXLeadManualDialRequest
    Public leadid As String
    Public phone As String
End Class

Public Class FPBXLeadManualDialResponse
    Public callid As String
    Public leadcallid As String
    Public phone As String
End Class

Public Class FPBXleadmanualdialAction
    Inherits FPBXAction

    Public Overrides Function Execute(ByVal json As String) As String
        Dim req As FPBXLeadManualDialRequest = CType(readJson(json, GetType(FPBXLeadManualDialRequest)), FPBXLeadManualDialRequest)
        Dim resp As New FPBXLeadManualDialResponse()
        Dim phone As String = SmartDebtorHelper.CleanPhoneNumber(req.phone)
        resp.phone = phone
        Dim callerid As String = CallControlsHelper.GetLeadCustomAni(resp.phone)
        Dim UserId As Integer = HttpContext.Current.User.Identity.Name
        If callerid.Trim.Length = 0 Then callerid = FreePBXHelper.GetOutboundCallerIdByDepartment(1)
        resp.callid = FreePBXHelper.InsertCall(phone, False, UserId, callerid, "LEAD", req.leadid, 0)
        resp.leadcallid = FreePBXHelper.InsertLeadDialerCall(req.leadid, phone, UserId, resp.callid)
        If req.phone.Trim.Length > 0 Then
            FreePBXHelper.InsertLeadNote(String.Format("Call made to phone number {0} on {1} by {2}.", req.phone, Now.ToString, DialerHelper.GetUserFullName(UserId)), req.leadid, UserId)
        End If
        Return writeJson(resp)
    End Function
End Class

