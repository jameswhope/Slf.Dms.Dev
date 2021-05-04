Imports System.Data
Imports System.Data.SqlClient
Public Class AsyncDB
#Region "Async DB Calls"
    Public Shared Function executeScalar(ByVal sqlText As String, ByVal sqlConnectionString As String) As String
        Dim cmd As SqlCommand = Nothing
        Try

            cmd = New SqlCommand(sqlText, New SqlConnection(sqlConnectionString))
            cmd.Connection.Open()
            Return cmd.ExecuteScalar
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Connection.Close()
            cmd.Dispose()
        End Try
    End Function
    Public Shared Function executeReaderAsync(ByVal sqlText As String, ByVal sqlConnectionString As String) As SqlDataReader
        Try

            'If Not sqlConnectionString.Contains("Asynchronous Processing=true") Or Not sqlConnectionString.Contains("Async=true") Then
            '    sqlConnectionString += ";Asynchronous Processing=true"
            '    sqlConnectionString = sqlConnectionString.Replace(";;", ";")
            'End If

            Dim cmd As New SqlCommand(sqlText, New SqlConnection(sqlConnectionString))
            cmd.Connection.Open()
            'Dim result As IAsyncResult = cmd.BeginExecuteReader(CommandBehavior.CloseConnection)
            'Dim rdr As SqlDataReader = cmd.EndExecuteReader(result)

            Return cmd.ExecuteReader

        Catch ex As Exception
            Throw ex
        End Try
    End Function
    Public Shared Function executeDataTableAsync(ByVal sqlText As String, ByVal sqlConnectionString As String) As DataTable
        Dim dtTemp As New DataTable
        Try
            'If Not sqlConnectionString.Contains("Asynchronous Processing=true") Or Not sqlConnectionString.Contains("Async=true") Then
            '    sqlConnectionString += ";Asynchronous Processing=true"
            '    sqlConnectionString = sqlConnectionString.Replace(";;", ";")
            'End If


            Dim cmd As New SqlCommand(sqlText, New SqlConnection(sqlConnectionString))
            If cmd.Connection.State = ConnectionState.Closed Then cmd.Connection.Open()
            'Dim result As IAsyncResult = cmd.BeginExecuteReader(CommandBehavior.CloseConnection)
            'Using rdr As SqlDataReader = cmd.EndExecuteReader(result)
            '    dtTemp.Load(rdr)
            'End Using

            Using rdr As SqlDataReader = cmd.ExecuteReader
                dtTemp.Load(rdr)
            End Using

            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            dtTemp.Dispose()
        End Try

    End Function
    Public Shared Function executeDataTableAsync(ByVal sqlCommand As SqlCommand) As DataTable
        Dim dtTemp As New DataTable
        Try
            'If Not sqlCommand.Connection.ConnectionString.Contains("Asynchronous Processing=true") Or Not sqlCommand.Connection.ConnectionString.Contains("Async=true") Then
            '    sqlCommand.Connection.ConnectionString += ";Asynchronous Processing=true"
            '    sqlCommand.Connection.ConnectionString = sqlCommand.Connection.ConnectionString.Replace(";;", ";")
            'End If

            If sqlCommand.Connection.State = ConnectionState.Closed Then sqlCommand.Connection.Open()
            'Dim result As IAsyncResult = sqlCommand.BeginExecuteReader(CommandBehavior.CloseConnection)
            'Using rdr As SqlDataReader = sqlCommand.EndExecuteReader(result)
            '    dtTemp.Load(rdr)
            'End Using
            Using rdr As SqlDataReader = sqlCommand.ExecuteReader
                dtTemp.Load(rdr)
            End Using

            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            dtTemp.Dispose()
        End Try

    End Function

#End Region
End Class
