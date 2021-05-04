Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data

Public Class TaskPropagationExceptionHelper

    Public Shared Function Insert(ByVal ClientID As Integer, ByVal TaskPropagationID As Integer, _
        ByVal DueDate As DateTime, ByVal UserID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "TaskPropagationID", TaskPropagationID)
        DatabaseHelper.AddParameter(cmd, "DueDate", DueDate)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblTaskPropagationException", _
            "TaskPropagationExceptionID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@TaskPropagationExceptionID").Value)

    End Function
End Class