Imports Microsoft.VisualBasic
Imports System.Data

Public Class FPBXLeadConnectCallRequest
    Public callid As String
    Public leadid As String
End Class

Public Class FPBXLeadConnectCallResponse
    Public callid As String
    Public leadid As String
    Public leadcallid As String
End Class

Public Class FPBXconnectleadcallAction
    Inherits FPBXAction

    Public Overrides Function Execute(ByVal json As String) As String
        Dim req As FPBXLeadConnectCallRequest = CType(readJson(json, GetType(FPBXLeadConnectCallRequest)), FPBXLeadConnectCallRequest)
        Dim resp As New FPBXLeadConnectCallResponse
        'ByVal CallId As Integer, ByVal LeadId As Integer, ByVal UserId As Integer
        'Update Call Reference
        Dim UserId As Integer = HttpContext.Current.User.Identity.Name
        FreePBXHelper.UpdateCallRef(req.callid, "LEAD", req.leadid, UserId)
        'Get Call data
        Dim dt As DataTable = FreePBXHelper.GetCallData(req.callid)
        Dim phone As String = dt.Rows(0)("phonenumber").ToString
        Dim calldirection As String = IIf(dt.Rows(0)("inbound"), "received from", "made to")
        Dim calldate As DateTime = dt.Rows(0)("created")
        'Insert Lead Call
        resp.callid = req.callid
        resp.leadcallid = FreePBXHelper.InsertLeadDialerCall(req.leadid, phone, UserId, req.callid)
        resp.leadid = req.leadid
        'Insert Call Note
        FreePBXHelper.InsertLeadNote(String.Format("Call {0} phone number {1} on {2} by {3}.", calldirection, phone, calldate, DialerHelper.GetUserFullName(UserId)), req.leadid, UserId)
        Return writeJson(resp)
    End Function

End Class


