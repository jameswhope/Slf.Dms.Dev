Imports System.Data
Imports System.Data.SqlClient

Public Class ReportsHelper

    Public Shared Function RevTotals(ByVal fromDate As String, ByVal ToDate As String, ByVal _userId As Integer, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("fromDate", fromDate))
        params.Add(New SqlParameter("toDate", ToDate))
        params.Add(New SqlParameter("userid", _userId))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        Dim dateString As String() = fromDate.Split("/"c)
        Dim daysInMonth As Integer = DateTime.DaysInMonth(CInt(dateString(2)), CInt(dateString(0)))
        Dim startDate As String = dateString(0) + "/01/" + dateString(2)
        Dim endDate As String = dateString(0) + "/" + daysInMonth.ToString + "/" + dateString(2)
        If CDate(endDate) > Date.Today Then
            endDate = Date.Today.ToString
        End If

        params.Add(New SqlParameter("startDate", startDate))
        params.Add(New SqlParameter("endDate", endDate))

        If CDate(fromDate) < CDate(Today.AddDays(-2)) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_RevTotals", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function RevSnapshot(ByVal fromDate As String, ByVal ToDate As String, ByVal _userId As Integer, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("fromDate", fromDate))
        params.Add(New SqlParameter("toDate", ToDate))
        params.Add(New SqlParameter("userid", _userId))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If CDate(fromDate) < CDate(Today.AddDays(-2)) Then
            'If Not CDate(fromDate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_RevSnapshot", CommandType.StoredProcedure, params.ToArray, connStr)
        'Return SqlHelper.GetDataTable("_Contract_Test", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Sub SaveRevReport(_revReportID As Integer, _userId As Integer, _emailRev As String, _adsenseRev As String)
        Dim cmdText As String = String.Format("update tblrevreport set emailrev={1}, adsenserev={2}, lastmodified=getdate(), lastmodifiedby={3} where revreportid = {0}", _revReportID, Val(_emailRev.Replace(",", "")), Val(_adsenseRev.Replace(",", "")), _userId)
        SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
    End Sub

    'Public Shared Sub SaveRevTotals(_corpCost As String, Year As Integer, Month As Integer)
    '    'find days in month
    '    Dim daysInMonth As Integer = System.DateTime.DaysInMonth(Year, Month)
    '    'extract amount and divide by days in month
    '    Dim CorporateCostPerDay As Double = Math.Round(_corpCost / daysInMonth, 2)
    '    Dim startdate As String = String.Format("{0}/1/{1}", Month, Year)
    '    Dim enddate As String = String.Format("{0}/{1}/{2}", Month, daysInMonth, Year)
    '    If CDate(enddate) > Date.Today Then
    '        enddate = Date.Today.ToString
    '    End If
    '    'update available fields
    '    Dim cmdText As String = String.Format("update tblRevReport set CorporateCost = {0} where Category = 'RTO' and RevDate between '{1}' and '{2}'", CorporateCostPerDay, startdate, enddate)
    '    Try
    '        SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
    '    Catch ex As Exception
    '        LeadHelper.LogError("ReportsHelper.SaveRevTotals_UpdatingRevRecords", ex.Message, _corpCost, -1)
    '    End Try

    '    Dim cmdText2 As String = String.Format("update TblCategory set DailyCorporateCost = {0} where Category = 'RTO'", CorporateCostPerDay)
    '    Try
    '        SqlHelper.ExecuteNonQuery(cmdText2, CommandType.Text)
    '    Catch ex As Exception
    '        LeadHelper.LogError("ReportsHelper.SaveRevTotals_UpdatingDefaultValue", ex.Message, _corpCost, -1)
    '    End Try

    'End Sub

    Public Shared Function GetCostBreakdown(ByVal category As String, ByVal internal As Boolean, ByVal fromDate As String, ByVal ToDate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("fromDate", fromDate))
        params.Add(New SqlParameter("toDate", ToDate))
        params.Add(New SqlParameter("category", category))
        params.Add(New SqlParameter("internal", IIf(internal, 1, 0)))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(fromDate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_CostBreakdown", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function GetCostBreakdownBySubId(ByVal campaignid As Integer, ByVal fromDate As String, ByVal ToDate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("fromDate", fromDate))
        params.Add(New SqlParameter("toDate", ToDate))
        params.Add(New SqlParameter("campaignid", campaignid))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(fromDate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_CostBreakdownBySubId", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function GetOnlineBreakdown(ByVal category As String, ByVal fromDate As String, ByVal ToDate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("fromDate", fromDate))
        params.Add(New SqlParameter("toDate", ToDate))
        params.Add(New SqlParameter("category", category))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(fromDate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_OnlineBreakdown", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function GetOnlineBreakdownBySrcId(ByVal campaignid As Integer, ByVal fromDate As String, ByVal ToDate As String, ByVal category As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("fromDate", fromDate))
        params.Add(New SqlParameter("toDate", ToDate))
        params.Add(New SqlParameter("campaignid", campaignid))
        params.Add(New SqlParameter("category", category))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(fromDate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_OnlineBreakdownBySrc", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function UnsoldDataAnalysis(ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate & " 23:59:59"))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_Unsold_DataAnalysis", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function UnsoldDataSummary(ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_Unsold_DataSummary", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function DispositionReport(category As String, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("category", category))
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_DispositionReport", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function DispositionBySubId(CampaignID As Integer, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("campaignid", CampaignID))
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_DispositionBySubId", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function DispositionLeadsBySubId(CampaignID As Integer, SubId1 As String, IdentStatus As String, ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("campaignid", CampaignID))
        params.Add(New SqlParameter("subid1", SubId1))
        params.Add(New SqlParameter("identstatus", IdentStatus))
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_DispositionLeadsBySubId", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function ViciRecordings(ByVal startdate As String, ByVal enddate As String, ByVal fromhr As String, ByVal tohr As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        params.Add(New SqlParameter("from", startdate))
        params.Add(New SqlParameter("to", enddate))
        params.Add(New SqlParameter("fromhr", fromhr))
        params.Add(New SqlParameter("tohr", tohr))
        If Not CDate(startdate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If
        Return SqlHelper.GetDataTable("stp_ViciRecordings", CommandType.StoredProcedure, params.ToArray, connStr)
    End Function

    Public Shared Function CsvExport(tbl As DataTable) As String
        Dim csv As New StringBuilder

        For i As Integer = 0 To tbl.Columns.Count - 1
            csv.AppendFormat("{1}""{0}""", tbl.Columns(i).ColumnName, IIf(i.Equals(0), "", ","))
        Next
        csv.Append(vbCrLf)

        For Each row As DataRow In tbl.Rows
            For i As Integer = 0 To tbl.Columns.Count - 1
                csv.AppendFormat("{1}""{0}""", row(i), IIf(i.Equals(0), "", ","))
            Next
            csv.Append(vbCrLf)
        Next

        Return csv.ToString
    End Function

End Class
