Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data

Public Class TrustHelper

    Public Shared Function Insert(ByVal Name As String, ByVal City As String, _
        ByVal StateID As Integer, ByVal RoutingNumber As String, ByVal AccountNumber As String, _
        ByVal UserID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Name", Name)
        DatabaseHelper.AddParameter(cmd, "City", City)
        DatabaseHelper.AddParameter(cmd, "StateID", StateID)
        DatabaseHelper.AddParameter(cmd, "RoutingNumber", RoutingNumber)
        DatabaseHelper.AddParameter(cmd, "AccountNumber", AccountNumber)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblTrust", "TrustID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@TrustID").Value)

    End Function
End Class