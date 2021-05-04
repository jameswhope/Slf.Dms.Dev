Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Collections.Generic

Public Class LeadReasonItem
    Public name As String
    Public value As String
End Class

Public Class LeadStatusReasonRequest
    Public statuscode As String
End Class

Public Class LeadStatusReasonResponse
    Public statusid As String = ""
    Public reasonid As String = ""
    Public reasons As LeadReasonItem() = New LeadReasonItem() {}
End Class

Public Class VicidialgetleadstatusreasonsAction
    Inherits VicidialAction

    Public Overrides Function Execute(ByVal json As String) As String
        Dim req As LeadStatusReasonRequest = CType(readJson(json, GetType(LeadStatusReasonRequest)), LeadStatusReasonRequest)
        Dim resp As New LeadStatusReasonResponse
        If req.statuscode.Trim.Length > 0 Then
            Dim dt As DataTable = VicidialHelper.GetLeadStatusByDisposition(req.statuscode)
            If dt.Rows.Count > 0 Then
                Dim dr As DataRow = dt.Rows(0)
                If Not dr("LeadStatusId") Is DBNull.Value Then resp.statusid = dr("LeadStatusId")
                If Not dr("LeadReasonId") Is DBNull.Value Then resp.reasonid = dr("LeadReasonId")

                If resp.statusid.Trim.Length > 0 AndAlso resp.reasonid.Length = 0 Then
                    'Get Reasons List if no reason is returned
                    dt = VicidialHelper.GetLeadReasonsByStatus(resp.statusid)
                    If dt.Rows.Count > 0 Then
                        resp.reasons = LoadReasons(dt).ToArray
                    End If
                End If
            End If
        End If
        Return writeJson(resp)
    End Function

    Private Function LoadReasons(ByVal dt As DataTable) As List(Of LeadReasonItem)
        Dim litems As New List(Of LeadReasonItem)
        For Each dr As DataRow In dt.Rows
            litems.Add(New LeadReasonItem() With {.Value = dr("LeadReasonsId"), .Name = dr("Description")})
        Next
        Return litems
    End Function

End Class
