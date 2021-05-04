Imports System.Data.SqlClient

Imports Drg.Util.DataAccess

Public Class CacheHelper
    'Public Shared Function CacheView(ByVal view As String, ByVal uniqueID As String) As String
    '    Dim cachedView As String = "tblCache_" & view
    '    CacheView(view, cachedView, uniqueID)

    '    Return cachedView
    'End Function

    'Public Shared Sub CacheView(ByVal view As String, ByVal cachedView As String, ByVal uniqueID As String)
    '    Dim countView As Integer = 0
    '    Dim countTable As Integer = 0
    '    Dim lacking As Integer = 0

    '    Using cmd As New SqlCommand("SELECT count(*) FROM " & view, ConnectionFactory.Create())
    '        Using cmd.Connection
    '            cmd.Connection.Open()

    '            countView = Integer.Parse(cmd.ExecuteScalar())

    '            cmd.CommandText = "SELECT count(*) FROM " & cachedView

    '            'WaitForCache(cachedView)
    '            countTable = Integer.Parse(cmd.ExecuteScalar())

    '            If countTable = countView Then
    '                cmd.CommandText = "SELECT count(*) FROM " & cachedView & " WHERE " & uniqueID & " not in (SELECT " & uniqueID & " FROM " & view & ")"

    '                'WaitForCache(cachedView)
    '                lacking = Integer.Parse(cmd.ExecuteScalar())
    '            End If

    '            If Not countTable = countView Or lacking > 0 Then
    '                cmd.CommandType = Data.CommandType.StoredProcedure

    '                cmd.CommandText = "stp_CacheView"
    '                cmd.Parameters.AddWithValue("view", view)
    '                cmd.Parameters.AddWithValue("newTable", cachedView)

    '                'WaitForCache(cachedView)
    '                cmd.ExecuteNonQuery()

    '                'Code changed by Jim Hope 4/17/2008 to wait for the command to complete before trying to read the table.
    '                'Commented out by Jim on the same day since J. Hernandez thought it was not a good idea.
    '                'Dim count As Integer
    '                'Dim result As IAsyncResult = cmd.BeginExecuteNonQuery()
    '                'While Not result.IsCompleted
    '                '    Threading.Thread.Sleep(100)
    '                '    count += 1
    '                'End While
    '                'cmd.EndExecuteNonQuery(result)
    '            End If
    '        End Using
    '    End Using
    'End Sub

    'Public Shared Sub WaitForCache(ByVal name As String, Optional ByVal limit As Long = 60000)
    '    Dim startTime As DateTime = DateTime.Now

    '    Try
    '        Using cmd As New SqlCommand("SELECT count(*) FROM sysobjects WHERE type = 'U' AND name = '" & name & "'", ConnectionFactory.Create())
    '            Using cmd.Connection
    '                cmd.Connection.Open()

    '                cmd.CommandTimeout = limit + 10000

    '                While Integer.Parse(cmd.ExecuteScalar()) = 0 Or DateTime.Now.Subtract(startTime).TotalMilliseconds < limit
    '                End While
    '            End Using
    '        End Using
    '    Catch ex As SqlException
    '        WaitForCache(name, limit)
    '    End Try
    'End Sub
End Class