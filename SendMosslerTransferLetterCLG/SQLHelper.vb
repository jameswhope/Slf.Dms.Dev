Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class SqlHelper

    Public Shared Sub ExecuteNonQuery(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.StoredProcedure, Optional ByVal params() As SqlParameter = Nothing)
        Dim cmd As New SqlCommand()

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.ConnectionStrings("LEXSPROD").ConnectionString)
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

    Public Shared Function GetDataTable(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.Text, Optional ByVal params() As SqlParameter = Nothing) As DataTable

        Dim cmd As New SqlCommand()
        Dim opened As Boolean

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            cmd.CommandTimeout = 240
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.ConnectionStrings("LEXSPROD").ConnectionString)
            If cmd.Connection.State <> ConnectionState.Open Then
                cmd.Connection.Open()
                opened = True
            End If
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            If opened Then
                cmd.Connection.Close()
            End If
            cmd.Dispose()
            cmd = Nothing
            Return dtTemp
        Catch ex As Exception
            Throw ex
        End Try
        'Dim cmd As New SqlCommand()
        'Dim dtTemp As New DataTable

        'Try
        '    cmd.CommandType = cmdType
        '    cmd.CommandText = cmdText
        '    cmd.CommandTimeout = 360 '6min
        '    If Not IsNothing(params) Then
        '        cmd.Parameters.AddRange(params)
        '    End If
        '    cmd.Connection = New SqlConnection(ConfigurationManager.ConnectionStrings("LEXSPROD").ConnectionString)
        '    cmd.Connection.Open()
        '    Dim reader As SqlClient.SqlDataReader
        '    reader = cmd.ExecuteReader()
        '    dtTemp.Load(reader)
        'Catch ex As Exception
        '    Throw ex
        'Finally
        '    If cmd.Connection.State <> ConnectionState.Closed Then
        '        cmd.Connection.Close()
        '    End If
        '    cmd.Dispose()
        '    cmd = Nothing
        'End Try

        'Return dtTemp
    End Function

    Public Shared Function GetDataSet(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.StoredProcedure, Optional ByVal params() As SqlParameter = Nothing) As DataSet
        Dim cmd As New SqlCommand()
        Dim dsTemp As New DataSet

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            cmd.CommandTimeout = 360 '6min
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.ConnectionStrings("LEXSPROD").ConnectionString)
            Dim da As New SqlDataAdapter(cmd)
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

    Public Shared Function ExecuteScalar(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.StoredProcedure, Optional ByVal params() As SqlParameter = Nothing) As Object
        Dim cmd As New SqlCommand()
        Dim obj As Object

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.ConnectionStrings("LEXSPROD").ConnectionString)
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
