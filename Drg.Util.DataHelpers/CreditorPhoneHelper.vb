Option Explicit On

Imports Drg.Util.DataAccess

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Public Class CreditorPhoneHelper

    Public Shared Sub Delete(ByVal CreditorPhoneID As Integer)

        'delete the record
        DataHelper.Delete("tblCreditorPhone", "CreditorPhoneID = " & CreditorPhoneID)

    End Sub
    Public Shared Sub Delete(ByVal Criteria As String)

        Dim CreditorPhoneIDs() As Integer = DataHelper.FieldLookupIDs("tblCreditorPhone", _
            "CreditorPhoneID", Criteria)

        Delete(CreditorPhoneIDs)

    End Sub
    Public Shared Sub Delete(ByVal CreditorPhoneIDs() As Integer)

        'loop through and delete each one
        For Each CreditorPhoneID As Integer In CreditorPhoneIDs
            Delete(CreditorPhoneID)
        Next

    End Sub
    Public Shared Function Insert(ByVal CreditorID As Integer, ByVal PhoneID As Integer, ByVal UserID As Integer)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "CreditorID", CreditorID)
            DatabaseHelper.AddParameter(cmd, "PhoneID", PhoneID)

            DatabaseHelper.AddParameter(cmd, "Created", Now)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

            DatabaseHelper.BuildInsertCommandText(cmd, "tblCreditorPhone", "CreditorPhoneID", SqlDbType.Int)

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

                Return DataHelper.Nz_int(cmd.Parameters("@CreditorPhoneID").Value)

            End Using
        End Using

    End Function
End Class