Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data

Public Class UserPositionHelper

    Public Shared Sub Delete(ByVal UserPositionID As Integer)

        '(1) remove user position record
        DataHelper.Delete("tblUserPosition", "UserPositionID = " & UserPositionID)

    End Sub
    Public Shared Sub DeleteForUser(ByVal UserID As Integer)

        Dim UserPositionIDs() As Integer = DataHelper.FieldLookupIDs("tblUserPosition", _
            "UserPositionID", "UserID = " & UserID)

        Delete(UserPositionIDs)

    End Sub
    Public Shared Sub Delete(ByVal UserPositionIDs() As Integer)

        For Each UserPositionID As Integer In UserPositionIDs
            Delete(UserPositionID)
        Next

    End Sub
    Public Shared Function Insert(ByVal PositionID As Integer, ByVal UserID As Integer) As Integer

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "PositionID", PositionID)
            DatabaseHelper.AddParameter(cmd, "UserID", UserID)

            DatabaseHelper.BuildInsertCommandText(cmd, "tblUserPosition", "UserPositionID", SqlDbType.Int)

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

                Return cmd.Parameters("@UserPositionID").Value

            End Using
        End Using

    End Function
End Class