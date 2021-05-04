Option Explicit On

Imports Drg.Util.DataAccess
Imports System.Data.SqlClient

Public Class DataHelperBase

    Public Enum CmdType As Integer
        Insert = 1
        Update = 2
    End Enum

    Public Function GetStates() As DataTable
        Return ExecuteQuery("select StateID, Abbreviation, [Name] from tblState order by Abbreviation")
    End Function

    Public Function ExecuteDataSet(ByVal cmd As IDbCommand) As DataSet
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet

        Try
            da.Fill(ds)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            da.Dispose()
        End Try

        Return ds
    End Function

    Public Overloads Function ExecuteQuery(ByVal sqlText As String) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet

        cmd.CommandText = sqlText

        Try
            da.Fill(ds)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            da.Dispose()
        End Try

        Return ds.Tables(0)
    End Function

    Public Overloads Function ExecuteQuery(ByVal cmd As IDbCommand) As DataTable
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet

        Try
            da.Fill(ds)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            da.Dispose()
        End Try

        Return ds.Tables(0)
    End Function

    Public Overloads Sub ExecuteNonQuery(ByVal sqlText As String)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

        Try
            cmd.Connection.Open()
            cmd.CommandText = sqlText
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Public Overloads Sub ExecuteNonQuery(ByVal cmd As IDbCommand)
        Try
            DatabaseHelper.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Public Function ExecuteScalar(ByVal cmd As IDbCommand) As Object
        Dim obj As Object

        Try
            obj = DatabaseHelper.ExecuteScalar(cmd)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return obj
    End Function

End Class
