Option Explicit On

Imports Slf.Dms.Records

Imports Drg.Util.DataAccess

Imports System.Data

Public Class CheckToPrintHelper

    Public Shared Sub Delete(ByVal CheckToPrintID As Integer)

        '(1) remove checktoprint record
        DataHelper.Delete("tblCheckToPrint", "CheckToPrintID = " & CheckToPrintID)

    End Sub
    Public Shared Sub DeleteForClient(ByVal ClientID As Integer)

        Dim CheckToPrintIDs() As Integer = DataHelper.FieldLookupIDs("tblCheckToPrint", _
            "CheckToPrintID", "ClientID = " & ClientID)

        Delete(CheckToPrintIDs)

    End Sub
    Public Shared Sub Delete(ByVal CheckToPrintIDs() As Integer)

        For Each CheckToPrintID As Integer In CheckToPrintIDs
            Delete(CheckToPrintID)
        Next

    End Sub
    Public Shared Function InsertCheckToPrint(ByVal ClientID As Integer, ByVal FirstName As String, _
        ByVal LastName As String, ByVal SpouseFirstName As String, ByVal SpouseLastName As String, _
        ByVal Street As String, ByVal Street2 As String, ByVal City As String, ByVal StateAbbreviation As String, _
        ByVal StateName As String, ByVal ZipCode As String, ByVal AccountNumber As String, _
        ByVal BankName As String, ByVal BankCity As String, ByVal BankStateAbbreviation As String, _
        ByVal BankStateName As String, ByVal BankZipCode As String, ByVal BankRoutingNumber As String, _
        ByVal BankAccountNumber As String, ByVal Amount As Double, ByVal CheckNumber As String, _
        ByVal CheckDate As DateTime, ByVal Fraction As String, ByVal UserID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "FirstName", FirstName)
        DatabaseHelper.AddParameter(cmd, "LastName", LastName)
        DatabaseHelper.AddParameter(cmd, "SpouseFirstName", SpouseFirstName)
        DatabaseHelper.AddParameter(cmd, "SpouseLastName", SpouseLastName)
        DatabaseHelper.AddParameter(cmd, "Street", Street)
        DatabaseHelper.AddParameter(cmd, "Street2", Street2)
        DatabaseHelper.AddParameter(cmd, "City", City)
        DatabaseHelper.AddParameter(cmd, "StateAbbreviation", StateAbbreviation)
        DatabaseHelper.AddParameter(cmd, "StateName", StateName)
        DatabaseHelper.AddParameter(cmd, "ZipCode", ZipCode)
        DatabaseHelper.AddParameter(cmd, "AccountNumber", AccountNumber)
        DatabaseHelper.AddParameter(cmd, "BankName", BankName)
        DatabaseHelper.AddParameter(cmd, "BankCity", BankCity)
        DatabaseHelper.AddParameter(cmd, "BankStateAbbreviation", BankStateAbbreviation)
        DatabaseHelper.AddParameter(cmd, "BankStateName", BankStateName)
        DatabaseHelper.AddParameter(cmd, "BankZipCode", BankZipCode)
        DatabaseHelper.AddParameter(cmd, "BankRoutingNumber", BankRoutingNumber)
        DatabaseHelper.AddParameter(cmd, "BankAccountNumber", BankAccountNumber)
        DatabaseHelper.AddParameter(cmd, "Amount", Amount)
        DatabaseHelper.AddParameter(cmd, "CheckNumber", CheckNumber)
        DatabaseHelper.AddParameter(cmd, "CheckDate", CheckDate)
        DatabaseHelper.AddParameter(cmd, "Fraction", Fraction)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblCheckToPrint", "CheckToPrintID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@CheckToPrintID").Value)

    End Function
End Class