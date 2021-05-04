Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data

Public Class UserInfoBoxHelper

    Public Shared Sub Delete(ByVal UserInfoBoxID As Integer)

        '(1) remove user info box record
        DataHelper.Delete("tblUserInfoBox", "UserInfoBoxID = " & UserInfoBoxID)

    End Sub
    Public Shared Sub DeleteForUser(ByVal UserID As Integer)

        Dim UserInfoBoxIDs() As Integer = DataHelper.FieldLookupIDs("tblUserInfoBox", _
            "UserInfoBoxID", "UserID = " & UserID)

        Delete(UserInfoBoxIDs)

    End Sub
    Public Shared Sub Delete(ByVal UserInfoBoxIDs() As Integer)

        For Each UserInfoBoxID As Integer In UserInfoBoxIDs
            Delete(UserInfoBoxID)
        Next

    End Sub
    Public Shared Function Insert(ByVal InfoBoxID As Integer, ByVal UserID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "UserID", UserID)
        DatabaseHelper.AddParameter(cmd, "InfoBoxID", InfoBoxID)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblUserInfoBox", "UserInfoBoxID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@UserInfoBoxID").Value)

    End Function
End Class