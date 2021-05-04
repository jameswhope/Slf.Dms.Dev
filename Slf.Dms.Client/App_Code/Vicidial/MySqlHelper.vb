Imports Microsoft.VisualBasic
Imports System.Data
Imports MySql.Data
Imports MySql.Data.MySqlClient
Imports System.Configuration

Public Class MySqlHelper

    Public Shared Function GetConnectionString() As String
        Return ConfigurationManager.ConnectionStrings("MySqlDB").ConnectionString
    End Function

    Public Shared Sub ExecuteNonQuery(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.Text, Optional ByVal params() As MySqlParameter = Nothing)
        Dim cmd As New MySqlCommand()

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New MySqlConnection(GetConnectionString())
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            If cmd.Connection.State <> ConnectionState.Closed Then
                cmd.Connection.Close()
            End If
            cmd.Dispose()
            cmd = Nothing
        End Try
    End Sub

    Public Shared Function GetDataTable(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.Text, Optional ByVal params() As MySqlParameter = Nothing) As DataTable
        Dim cmd As New MySqlCommand()
        Dim dtTemp As New Data.DataTable

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New MySqlConnection(GetConnectionString())
            cmd.Connection.Open()
            dtTemp.Load(cmd.ExecuteReader())
        Catch ex As Exception
            Throw ex
        Finally
            If cmd.Connection.State <> ConnectionState.Closed Then
                cmd.Connection.Close()
            End If
            cmd.Dispose()
            cmd = Nothing
        End Try

        Return dtTemp
    End Function

    Public Shared Function GetDataSet(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.Text, Optional ByVal params() As MySqlParameter = Nothing) As DataSet
        Dim cmd As New MySqlCommand()
        Dim dsTemp As New DataSet

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            cmd.CommandTimeout = 360 '6min
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New MySqlConnection(GetConnectionString())
            Dim da As New MySqlDataAdapter(cmd)
            da.Fill(dsTemp)
        Catch ex As Exception
            Throw ex
        Finally
            If cmd.Connection.State <> ConnectionState.Closed Then
                cmd.Connection.Close()
            End If
            cmd.Dispose()
            cmd = Nothing
        End Try

        Return dsTemp
    End Function

    Public Shared Function ExecuteScalar(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.Text, Optional ByVal params() As MySqlParameter = Nothing) As Object
        Dim cmd As New MySqlCommand()
        Dim obj As Object

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New MySqlConnection(GetConnectionString())
            cmd.Connection.Open()
            obj = cmd.ExecuteScalar
        Catch ex As Exception
            Throw ex
        Finally
            If cmd.Connection.State <> ConnectionState.Closed Then
                cmd.Connection.Close()
            End If
            cmd.Dispose()
            cmd = Nothing
        End Try

        Return obj
    End Function

End Class
