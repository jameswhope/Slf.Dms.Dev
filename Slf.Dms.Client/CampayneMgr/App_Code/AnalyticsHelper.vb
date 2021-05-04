Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Collections.Generic
Imports System.Data.SqlClient

Public Class AnalyticsHelper

    Public Enum DateUnit
        Day = 1
        Week = 2
        Month = 3
        Year = 4
    End Enum

    Public Shared Function InsertVisit(ByVal RemoteAddr As String, ByVal Referrer As String, ByVal Seed As String, ByVal AdGroup As String, ByVal UserAgent As String, ByVal ReturnVisit As Boolean, ByVal AdSource As String) As Integer
        Dim VisitID As Integer
        Dim cmdText As String

        Try
            Referrer = Referrer.Replace("'", "")
            Dim site As String = Referrer.Replace("http://", "").Replace("www.", "")
            If site.IndexOf("/") > 1 Then
                site = Mid(site, 1, site.IndexOf("/"))
            End If
            If Len(AdSource) > 0 Then
                AdSource = String.Format("'{0}'", AdSource)
            Else
                AdSource = "NULL"
            End If
            If Len(AdGroup) > 0 AndAlso Seed <> AdGroup Then
                AdGroup = String.Format("'{0}'", AdGroup)
            Else
                AdGroup = "NULL"
            End If
            cmdText = String.Format("insert tblVisits (RemoteAddr,Referrer,Seed,UserAgent,ReferringSite,ReturnVisit,AdSource,AdGroup) values ('{0}','{1}','{2}','{3}','{4}',{5},{6},{7}); select scope_identity();", RemoteAddr, Referrer, Seed, UserAgent, site, IIf(ReturnVisit, "1", "0"), AdSource, AdGroup)
            VisitID = CInt(SqlHelper.ExecuteScalar(cmdText, Data.CommandType.Text))
        Catch ex As Exception
            LeadHelper.LogError("InsertVisit", ex.Message, cmdtext) 'ex.StackTrace)
        End Try

        Return VisitID
    End Function

    Public Shared Function LeadsByPath(ByVal dateFrom As String, ByVal dateTo As String, ByVal website As String) As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("from", dateFrom))
        params.Add(New SqlParameter("to", dateTo & " 23:59:59"))
        params.Add(New SqlParameter("website", website))
        Return SqlHelper.GetDataTable("stp_LeadsByPath", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function OfferInquiries(ByVal dateFrom As String, ByVal dateTo As String, ByVal website As String) As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("from", dateFrom))
        params.Add(New SqlParameter("to", dateTo & " 23:59:59"))
        params.Add(New SqlParameter("website", website))
        Return SqlHelper.GetDataTable("stp_Inquiries", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function VisitsByDay(ByVal dateFrom As String, ByVal dateTo As String, ByVal website As String) As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("from", dateFrom))
        params.Add(New SqlParameter("to", dateTo & " 23:59:59"))
        params.Add(New SqlParameter("website", website))
        Return SqlHelper.GetDataTable("stp_VisitsByDay", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function LeadsByDay(ByVal dateFrom As String, ByVal dateTo As String, ByVal website As String) As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("from", dateFrom))
        params.Add(New SqlParameter("to", dateTo & " 23:59:59"))
        params.Add(New SqlParameter("website", website))
        Return SqlHelper.GetDataTable("stp_LeadsByDay", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function TopSeeds(ByVal dateFrom As String, ByVal dateTo As String, ByVal website As String) As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("from", dateFrom))
        params.Add(New SqlParameter("to", dateTo & " 23:59:59"))
        params.Add(New SqlParameter("website", website))
        Return SqlHelper.GetDataTable("stp_TopSeeds", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function TopReferring(ByVal dateFrom As String, ByVal dateTo As String, ByVal website As String) As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("from", dateFrom))
        params.Add(New SqlParameter("to", dateTo & " 23:59:59"))
        params.Add(New SqlParameter("website", website))
        Return SqlHelper.GetDataTable("stp_TopReferring", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function AvgOffersPer(ByVal dateFrom As String, ByVal dateTo As String, ByVal website As String) As Double
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("from", dateFrom))
        params.Add(New SqlParameter("to", dateTo & " 23:59:59"))
        params.Add(New SqlParameter("website", website))
        Return Val(SqlHelper.ExecuteScalar("stp_AvgOffersPer", , params.ToArray))
    End Function

    Public Shared Function RoundDate(ByVal d As DateTime, ByVal Direction As Integer, ByVal Unit As DateUnit) As DateTime
        Dim result As DateTime = d

        If Unit = DateUnit.Week Then
            If Direction = 1 Then
                While Not result.DayOfWeek = DayOfWeek.Saturday
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.DayOfWeek = DayOfWeek.Sunday
                    result = result.AddDays(-1)
                End While
            Else
                If result.DayOfWeek = DayOfWeek.Wednesday Or result.DayOfWeek = DayOfWeek.Thursday Or result.DayOfWeek = DayOfWeek.Friday Then
                    While Not result.DayOfWeek = DayOfWeek.Saturday
                        result = result.AddDays(1)
                    End While
                ElseIf result.DayOfWeek = DayOfWeek.Monday Or result.DayOfWeek = DayOfWeek.Tuesday Then
                    While Not result.DayOfWeek = DayOfWeek.Sunday
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        ElseIf Unit = DateUnit.Month Then
            If Direction = 1 Then
                While Not result.Day = Date.DaysInMonth(result.Year, result.Month)
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.Day = 1
                    result = result.AddDays(-1)
                End While
            Else
                Dim DaysInMonth As Integer = Date.DaysInMonth(result.Year, result.Month)
                Dim Midpoint As Integer = DaysInMonth / 2

                If result.Day >= Midpoint And result.Day < DaysInMonth Then
                    While Not result.Day = DaysInMonth
                        result = result.AddDays(1)
                    End While
                ElseIf result.Day < Midpoint And result.Day > 1 Then
                    While Not result.Day = 1
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        ElseIf Unit = DateUnit.Year Then
            Dim DaysInYear As Integer
            For i As Integer = 1 To 12
                DaysInYear += Date.DaysInMonth(result.Year, i)
            Next
            If Direction = 1 Then
                While Not result.DayOfYear = DaysInYear
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.DayOfYear = 1
                    result = result.AddDays(-1)
                End While
            Else
                Dim Midpoint As Integer = DaysInYear / 2

                If result.DayOfYear >= Midpoint And result.DayOfYear < DaysInYear Then
                    While Not result.DayOfYear = DaysInYear
                        result = result.AddDays(1)
                    End While
                ElseIf result.DayOfYear < Midpoint And result.DayOfYear > 1 Then
                    While Not result.DayOfYear = 1
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        End If

        Return result
    End Function

End Class
