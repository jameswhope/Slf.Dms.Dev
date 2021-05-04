Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data

Public Class UserLanguageHelper

    Public Shared Sub Delete(ByVal UserLanguageID As Integer)

        '(1) remove user language record
        DataHelper.Delete("tblUserLanguage", "UserLanguageID = " & UserLanguageID)

    End Sub
    Public Shared Sub DeleteForUser(ByVal UserID As Integer)

        Dim UserLanguageIDs() As Integer = DataHelper.FieldLookupIDs("tblUserLanguage", _
            "UserLanguageID", "UserID = " & UserID)

        Delete(UserLanguageIDs)

    End Sub
    Public Shared Sub Delete(ByVal UserLanguageIDs() As Integer)

        For Each UserLanguageID As Integer In UserLanguageIDs
            Delete(UserLanguageID)
        Next

    End Sub
    Public Shared Function Insert(ByVal LanguageID As Integer, ByVal UserID As Integer) As Integer

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "LanguageID", LanguageID)
            DatabaseHelper.AddParameter(cmd, "UserID", UserID)

            DatabaseHelper.BuildInsertCommandText(cmd, "tblUserLanguage", "UserLanguageID", SqlDbType.Int)

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

                Return cmd.Parameters("@UserLanguageID").Value

            End Using
        End Using

    End Function
End Class