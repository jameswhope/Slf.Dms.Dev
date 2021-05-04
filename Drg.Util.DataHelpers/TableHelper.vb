Option Explicit On

Imports drg.Util.DataAccess

Imports System.Data

Public Class TableHelper

    Public Shared Function Exists(ByVal Name As String)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.Tables WHERE Table_Name = @TableName"

        DatabaseHelper.AddParameter(cmd, "TableName", Name)

        Using cmd
            Using cmd.Connection

                cmd.Connection.Open()

                Return DataHelper.Nz_int(cmd.ExecuteScalar()) > 0

            End Using
        End Using

    End Function
    Public Shared Function GetSchemaTable(ByVal Name As String) As DataTable

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT TOP 1 * FROM " & Name

        Using cmd
            Using cmd.Connection

                cmd.Connection.Open()
                rd = cmd.ExecuteReader(CommandBehavior.SchemaOnly)

                Return rd.GetSchemaTable()

            End Using
        End Using

    End Function
End Class