Option Explicit On

Imports Drg.Util.DataAccess

Public Class ImportLogHelper

    Public Shared Function Insert(ByVal ImportID As Integer, ByVal Log As String) As Integer

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "ImportID", ImportID)
            DatabaseHelper.AddParameter(cmd, "Value", Log)

            DatabaseHelper.BuildInsertCommandText(cmd, "tblImportLog", "ImportLogID", SqlDbType.Int)

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

                Return DataHelper.Nz_int(cmd.Parameters("@ImportLogID").Value)

            End Using
        End Using

    End Function
End Class