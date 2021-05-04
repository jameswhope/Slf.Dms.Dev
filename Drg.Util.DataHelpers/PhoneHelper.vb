Option Explicit On

Imports Drg.Util.DataAccess
Imports System.Data
Imports System.Data.SqlClient

Public Class PhoneHelper

    Public Shared Function InsertPhone(ByVal PhoneTypeID As Integer, ByVal AreaCode As String, _
        ByVal Number As String, ByVal Extension As String, ByVal UserID As Integer) As Integer

		Dim phoneID As String = DataAccess.DataHelper.FieldLookup("tblPhone", "PhoneID", "PhoneTypeID = " & PhoneTypeID & " AND AreaCode = '" & AreaCode & "' AND Number = '" & Number & "' and Extension = '" & Extension & "'")

        If phoneID.ToString = "" Then

            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "PhoneTypeID", PhoneTypeID)
            DatabaseHelper.AddParameter(cmd, "AreaCode", AreaCode)
            DatabaseHelper.AddParameter(cmd, "Number", Number)
            DatabaseHelper.AddParameter(cmd, "Extension", DataHelper.Zn(Extension))

            DatabaseHelper.AddParameter(cmd, "Created", Now)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

            DatabaseHelper.BuildInsertCommandText(cmd, "tblPhone", "PhoneID", SqlDbType.Int)

            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try

            Return DataHelper.Nz_int(cmd.Parameters("@PhoneID").Value)
        Else
            Return phoneID
        End If
    End Function

    Public Shared Function GetPhoneTypes() As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet

        cmd.CommandText = "select PhoneTypeID, [Name] from tblPhoneType order by [Name]"

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

End Class