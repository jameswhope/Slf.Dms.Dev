Imports Microsoft.VisualBasic
Imports System.Data

Public Class VicidialConnectLeadCallRequest
    Public vicileadid As String
    Public leadid As String
    Public sourceid As String
End Class

Public Class VicidialConnectLeadCallResponse
    Public leadid As String
    Public sourceid As String
End Class

Public Class VicidialconnectleadcallAction
    Inherits VicidialAction

    Public Overrides Function Execute(ByVal json As String) As String
        Dim req As VicidialConnectLeadCallRequest = CType(readJson(json, GetType(VicidialConnectLeadCallRequest)), VicidialConnectLeadCallRequest)
        Dim resp As New VicidialConnectLeadCallResponse
        'Update Call Reference
        Dim UserId As Integer = HttpContext.Current.User.Identity.Name
        VicidialHelper.ConnectCallWithLead(req.vicileadid, req.leadid, req.sourceid)
        resp.leadid = req.leadid
        resp.sourceid = req.sourceid
        Return writeJson(resp)
    End Function

End Class


