Imports Microsoft.VisualBasic
Imports System.Runtime.Serialization.Json.DataContractJsonSerializer
Imports System.Data.SqlClient

Public Class VicidialClientManualDialRequest
    Public phone As String
    Public clientid As String
End Class

Public Class VicidialClientManualDialResponse
    Public clientid As String
    Public phone As String
    Public sourceid As String
    Public callerid As String
End Class


Public Class VicidialclientmanualdialAction
    Inherits VicidialAction

    Public Overrides Function Execute(ByVal json As String) As String
        Dim req As VicidialClientManualDialRequest = CType(readJson(json, GetType(VicidialClientManualDialRequest)), VicidialClientManualDialRequest)
        Dim resp As New VicidialClientManualDialResponse With {.clientId = req.clientid, .sourceid = VicidialGlobals.ViciClientSource}
        'VicidialHelper.CancelPendingLeadCalls(0, req.clientid, VicidialGlobals.ViciClientSource)
        resp.phone = SmartDebtorHelper.CleanPhoneNumber(req.phone)
        resp.callerid = ""
        Return writeJson(resp)
    End Function
End Class

