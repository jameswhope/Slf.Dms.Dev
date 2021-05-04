Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class SqlHelper

    Public Enum ConnectionString
        IDENTIFYLEDB
        IDENTIFYLEWHSE
    End Enum

    Public Shared Sub ExecuteNonQuery(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.StoredProcedure, Optional ByVal params() As SqlParameter = Nothing, Optional ByVal connStr As ConnectionString = ConnectionString.IDENTIFYLEDB)
        Dim cmd As New SqlCommand()

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.ConnectionStrings([Enum].GetName(GetType(ConnectionString), connStr)).ConnectionString)
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

    Public Shared Function GetDataTable(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.Text, Optional ByVal params() As SqlParameter = Nothing, Optional ByVal connStr As ConnectionString = ConnectionString.IDENTIFYLEDB) As DataTable
        Dim cmd As New SqlCommand()
        Dim dtTemp As New Data.DataTable

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            cmd.CommandTimeout = 180 '3min
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.ConnectionStrings([Enum].GetName(GetType(ConnectionString), connStr)).ConnectionString)
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

    Public Shared Function GetDataSet(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.StoredProcedure, Optional ByVal params() As SqlParameter = Nothing, Optional ByVal connStr As ConnectionString = ConnectionString.IDENTIFYLEDB) As DataSet
        Dim cmd As New SqlCommand()
        Dim dsTemp As New DataSet

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            cmd.CommandTimeout = 180 '3min
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.ConnectionStrings([Enum].GetName(GetType(ConnectionString), connStr)).ConnectionString)
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

    Public Shared Function ExecuteScalar(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.StoredProcedure, Optional ByVal params() As SqlParameter = Nothing, Optional ByVal connStr As ConnectionString = ConnectionString.IDENTIFYLEDB) As Object
        Dim cmd As New SqlCommand()
        Dim obj As Object

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.ConnectionStrings([Enum].GetName(GetType(ConnectionString), connStr)).ConnectionString)
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
