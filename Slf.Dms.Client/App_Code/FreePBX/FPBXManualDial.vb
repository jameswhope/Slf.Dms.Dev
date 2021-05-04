Imports Microsoft.VisualBasic
Imports System.Runtime.Serialization.Json.DataContractJsonSerializer
Imports System.Data.SqlClient

Public Class FPBXManualDialRequest
    Public phone As String
    Public reasonid As String
End Class

Public Class FPBXManualDialResponse
    Public callid As String
    Public phone As String
End Class

Public Class FPBXmanualdialAction
    Inherits FPBXAction

    Public Overrides Function Execute(ByVal json As String) As String
        Dim req As FPBXManualDialRequest = CType(readJson(json, GetType(FPBXManualDialRequest)), FPBXManualDialRequest)
        Dim resp As New FPBXManualDialResponse
        Dim phone As String = SmartDebtorHelper.CleanPhoneNumber(req.phone)
        Dim userid As Integer = HttpContext.Current.User.Identity.Name
        Dim callerid As String = FreePBXHelper.GetDefaultCallerId(0, userid)
        resp.phone = phone
        resp.callid = FreePBXHelper.InsertCall(phone, False, userid, callerid, "", Nothing, req.reasonid)
        Return writeJson(resp)
    End Function

End Class

