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
            cmd.Connection = New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try
    End Sub

    Public Shared Function GetDataTable(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.Text, Optional ByVal params() As SqlParameter = Nothing) As DataTable
        Dim cmd As New SqlCommand()

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            cmd.Dispose()
            cmd = Nothing
            Return dtTemp
        Catch ex As Exception
            Throw ex
        End Try
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
            cmd.Connection = New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            obj = cmd.ExecuteScalar
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

        Return obj
    End Function

End Class
