Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data
Imports System.Collections.Generic

Public Class PropertyHelper

    Public Shared Function Value(ByVal Name As String) As String
        Return DataHelper.FieldLookup("tblProperty", "Value", "[Name] = '" & Name & "'")
    End Function
    Public Shared Function Value(ByVal PropertyID As Integer) As String
        Return DataHelper.FieldLookup("tblProperty", "Value", "[PropertyID] = " & PropertyID)
    End Function
    Public Shared Sub Update(ByVal Name As String, ByVal Value As String, ByVal UserID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Value", Value)

        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblProperty", "Name = '" & Name & "'")

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
End Class