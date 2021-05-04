Imports System.Data
Imports System.Data.SqlClient

Public Class AffiliateHelper

    Public Shared Function CampaignSummary(ByVal FromDate As String, ByVal ToDate As String, ByVal UserID As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("from", FromDate))
        params.Add(New SqlParameter("to", ToDate))
        params.Add(New SqlParameter("userid", UserID))
        If Not CDate(fromDate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Try
            Return SqlHelper.GetDataTable("stp_affiliate_getTraffic", CommandType.StoredProcedure, params.ToArray, connStr)
        Catch ex As Exception
            LeadHelper.LogError("AffiliateHelper.CampaignSummary", ex.Message, ex.StackTrace)
            Return Nothing
        End Try
    End Function

End Class
