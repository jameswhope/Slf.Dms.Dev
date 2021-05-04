Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class SqlHelper

    Public Shared Sub ExecuteNonQuery(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.StoredProcedure, Optional ByVal params() As SqlParameter = Nothing)
        Dim cmd As New SqlCommand()
        Dim opened As Boolean

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            If cmd.Connection.State <> ConnectionState.Open Then
                cmd.Connection.Open()
                opened = True
            End If
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            If opened Then
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
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
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
    End Function

    Public Shared Function GetDataSet(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.StoredProcedure, Optional ByVal params() As SqlParameter = Nothing) As DataSet
        Dim cmd As New SqlCommand()

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            cmd.CommandTimeout = 360 '6min
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            Dim da As New SqlDataAdapter(cmd)
            Dim dsTemp As New DataSet
            da.Fill(dsTemp)
            If cmd.Connection.State <> ConnectionState.Closed Then
                cmd.Connection.Close()
            End If
            cmd.Dispose()
            cmd = Nothing
            Return dsTemp
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Shared Function GetDataReader(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.StoredProcedure, Optional ByVal params() As SqlParameter = Nothing) As SqlDataReader
        Dim drTemp As SqlDataReader
        Try
            Using cn As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
                cn.Open()
                Using cmd As New SqlCommand(cmdText, cn)
                    cmd.CommandType = cmdType
                    cmd.CommandText = cmdText
                    If Not IsNothing(params) Then
                        cmd.Parameters.AddRange(params)
                    End If
                    drTemp = cmd.ExecuteReader
                End Using
            End Using
            Return drTemp
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Shared Function ExecuteScalar(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.StoredProcedure, Optional ByVal params() As SqlParameter = Nothing) As Object
        Dim cmd As New SqlCommand()
        Dim obj As Object
        Dim opened As Boolean

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            If cmd.Connection.State <> ConnectionState.Open Then
                cmd.Connection.Open()
                opened = True
            End If
            obj = cmd.ExecuteScalar
        Catch ex As Exception
            Throw ex
        Finally
            If opened Then
                cmd.Connection.Close()
            End If
            cmd.Dispose()
            cmd = Nothing
        End Try

        Return obj
    End Function

    Public Shared Function ExecuteScalarCMS(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.StoredProcedure, Optional ByVal params() As SqlParameter = Nothing) As Object
        Dim cmd As New SqlCommand()
        Dim obj As Object
        Dim opened As Boolean

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection(ConfigurationManager.AppSettings("CMSConnStr").ToString)
            If cmd.Connection.State <> ConnectionState.Open Then
                cmd.Connection.Open()
                opened = True
            End If
            obj = cmd.ExecuteScalar
        Catch ex As Exception
            Throw ex
        Finally
            If opened Then
                cmd.Connection.Close()
            End If
            cmd.Dispose()
            cmd = Nothing
        End Try

        Return obj
    End Function

End Class
