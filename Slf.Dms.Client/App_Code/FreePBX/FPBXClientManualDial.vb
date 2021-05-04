Imports Microsoft.VisualBasic
Imports System.Runtime.Serialization.Json.DataContractJsonSerializer
Imports System.Data.SqlClient

Public Class FPBXClientManualDialRequest
    Public clientid As String
    Public phone As String
    Public reasonid As String
End Class

Public Class FPBXClientManualDialResponse
    Public callid As String
    Public phone As String
End Class

Public Class FPBXclientmanualdialAction
    Inherits FPBXAction

    Public Overrides Function Execute(ByVal json As String) As String
        Dim req As FPBXClientManualDialRequest = CType(readJson(json, GetType(FPBXClientManualDialRequest)), FPBXClientManualDialRequest)
        Dim resp As New FPBXClientManualDialResponse
        Dim phone As String = SmartDebtorHelper.CleanPhoneNumber(req.phone)
        resp.phone = phone
        Dim userid As Integer = HttpContext.Current.User.Identity.Name
        Dim companyid As Integer = FreePBXHelper.GetClientCompany(req.clientid)
        Dim callerid As String = FreePBXHelper.GetDefaultCallerId(companyid, userid)
        resp.callid = FreePBXHelper.InsertCall(phone, False, userid, callerid, "CLIENT", req.clientid, req.reasonid)
        Return writeJson(resp)
    End Function
End Class

