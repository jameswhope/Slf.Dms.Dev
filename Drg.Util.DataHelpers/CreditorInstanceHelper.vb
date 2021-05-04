Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Public Class CreditorInstanceHelper

    Public Shared Sub Delete(ByVal CreditorInstanceID As Integer)

        '(1) delete the record
        DataHelper.Delete("tblCreditorInstance", "CreditorInstanceID = " & CreditorInstanceID)

    End Sub
    Public Shared Sub Delete(ByVal CreditorInstanceIDs() As Integer)

        'loop through and delete each one
        For Each CreditorInstanceID As Integer In CreditorInstanceIDs
            Delete(CreditorInstanceID)
        Next

    End Sub
    Public Shared Function Insert(ByVal AccountID As Integer, ByVal CreditorID As Integer, _
        ByVal Acquired As DateTime, ByVal AccountNumber As String, ByVal UserID As Integer) As Integer

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)
        DatabaseHelper.AddParameter(cmd, "CreditorID", CreditorID)
        DatabaseHelper.AddParameter(cmd, "Acquired", Acquired)
        DatabaseHelper.AddParameter(cmd, "AccountNumber", AccountNumber)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblCreditorInstance", "CreditorInstanceID", SqlDbType.Int)

        Try

            cmd.Connection.Open()
            cmd.ExecuteNonQuery()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@CreditorInstanceID").Value)

    End Function
End Class