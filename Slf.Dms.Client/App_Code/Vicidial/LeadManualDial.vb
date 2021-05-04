Imports Microsoft.VisualBasic
Imports System.Runtime.Serialization.Json.DataContractJsonSerializer
Imports System.Data.SqlClient

Public Class VicidialLeadManualDialRequest
    Public leadid As String
    Public phone As String
    'Public UserId As Integer
End Class

Public Class VicidialLeadManualDialResponse
    Public leadid As String
    Public phone As String
    Public sourceid As String
    Public callerid As String
End Class

Public Class VicidialleadmanualdialAction
    Inherits VicidialAction

    Public Overrides Function Execute(ByVal json As String) As String
        Dim req As VicidialLeadManualDialRequest = CType(readJson(json, GetType(VicidialLeadManualDialRequest)), VicidialLeadManualDialRequest)
        Dim resp As New VicidialLeadManualDialResponse
        Dim phone As String = SmartDebtorHelper.CleanPhoneNumber(req.phone)
        resp.phone = phone
        Dim callerid As String = CallControlsHelper.GetLeadCustomAni(resp.phone)
        Dim UserId As Integer = HttpContext.Current.User.Identity.Name
        If callerid.Trim.Length = 0 Then callerid = FreePBXHelper.GetOutboundCallerIdByDepartment(1)
        resp.callerid = callerid
        resp.leadid = req.leadid
        resp.sourceid = VicidialGlobals.ViciLeadSource
        'If phone.Length > 0 Then
        'VicidialHelper.InsertLeadNote(String.Format("Call made to phone number {0} on {1} by {2}.", req.phone, Now.ToString, DialerHelper.GetUserFullName(UserId)), req.leadid, UserId)
        'End If
        Return writeJson(resp)
    End Function
End Class

