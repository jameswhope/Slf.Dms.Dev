Imports System.Data
Imports System.Data.SqlClient

Public Class OfferHelper

    Public Shared Function GetOfferTagSummary(ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate & " 23:59:59"))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_OfferTagSummary", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function GetOfferSummary(ByVal tag As String, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("tag", tag))
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate & " 23:59:59"))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_OfferSummary", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function GetBuyerSummary(ByVal offerid As String, ByVal startdate As String, ByVal enddate As String, ByVal tag As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("offerid", offerid))
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate & " 23:59:59"))
        params.Add(New SqlParameter("tag", tag))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_BuyerSummary", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function GetCampaignSummary(ByVal offerid As Integer, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String, ByVal tag As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("offerid", offerid))
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate & " 23:59:59"))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        params.Add(New SqlParameter("tag", tag))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_CampaignSummary", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function GetSrcCampaignSummary(ByVal offerid As Integer, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("offerid", offerid))
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate & " 23:59:59"))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_SrcCampaignSummary", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function GetCampaignSubIDSummary(ByVal campaignid As Integer, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("campaignid", campaignid))
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate & " 23:59:59"))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_SubIdSummary", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    ' returns SubID1 summary
    Public Shared Function GetCampaignSubIDSummaryMTD(ByVal campaignid As Integer, ByVal mth As Integer, ByVal yr As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("campaignid", campaignid))
        params.Add(New SqlParameter("mth", mth))
        params.Add(New SqlParameter("yr", yr))
        Return SqlHelper.GetDataTable("stp_SubIdSummaryMTD", CommandType.StoredProcedure, params.ToArray, SqlHelper.ConnectionString.IDENTIFYLEWHSE)
    End Function

    ' returns all clicks and SubIDs
    Public Shared Function GetSubIDExportMTD(ByVal campaignid As Integer, ByVal mth As Integer, ByVal yr As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("campaignid", campaignid))
        params.Add(New SqlParameter("mth", mth))
        params.Add(New SqlParameter("yr", yr))
        Return SqlHelper.GetDataTable("stp_SubIdExportMTD", CommandType.StoredProcedure, params.ToArray, SqlHelper.ConnectionString.IDENTIFYLEWHSE)
    End Function

    ' returns all clicks and SubIDs
    Public Shared Function GetSubIDExport(ByVal campaignid As Integer, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("campaignid", campaignid))
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate & " 23:59:59"))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_SubIdExport", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function GetCampaignSubIDSummaryDetail(ByVal campaignid As Integer, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("campaignid", campaignid))
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate & " 23:59:59"))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_SubIdSummaryDetail", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function GetDataQueries(OfferID As Integer) As List(Of String())
        Dim tbl As DataTable = SqlHelper.GetDataTable(String.Format("select Name, StoredProc from tblDataQueries where OfferID = {0} order by Name", OfferID))
        Dim d As New List(Of String())

        d.Add(New String() {"None", ""})

        For Each row As DataRow In tbl.Rows
            d.Add(New String() {row("Name"), row("StoredProc")})
        Next

        Return d
    End Function

    Public Shared Function GetCampaignSubIDPickleDetail(campaignid As Integer) As DataTable

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("CampaignId", campaignid))
        Return SqlHelper.GetDataTable("stp_getSubIdPickleTable", CommandType.StoredProcedure, params.ToArray)

    End Function

End Class
