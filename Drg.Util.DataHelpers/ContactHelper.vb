Option Explicit On

Imports Drg.Util.DataAccess
Imports System.Data
Imports System.Data.SqlClient

Public Class ContactHelper
    Public Shared Function InsertContact(ByVal CreditorAcctID As Integer, ByVal FirstName As String, _
                                        ByVal LastName As String, ByVal EmailAddress As String, _
                                        ByVal UserID As Integer, Optional ByVal SessionGUID As String = "") As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()


        DatabaseHelper.AddParameter(cmd, "CreditorID", CreditorAcctID)

        DatabaseHelper.AddParameter(cmd, "FirstName", FirstName)
        DatabaseHelper.AddParameter(cmd, "LastName", LastName)
        DatabaseHelper.AddParameter(cmd, "EmailAddress", EmailAddress)
        DatabaseHelper.AddParameter(cmd, "NegotiationSessionGUID", SessionGUID)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        DatabaseHelper.BuildInsertCommandText(cmd, "tblContact", "ContactID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@ContactID").Value)

    End Function
    Public Shared Function RelatePhoneToContact(ByVal ContactID As Integer, ByVal PhoneID As Integer, ByVal UserID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "ContactID", ContactID)
        DatabaseHelper.AddParameter(cmd, "PhoneID", PhoneID)


        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        DatabaseHelper.BuildInsertCommandText(cmd, "tblContactPhone", "ContactPhoneID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@ContactPhoneID").Value)

    End Function
    Public Shared Function GetContactInfo(ByVal CreditorAccountID As String) As DataTable
        Try
            Dim sqlSelect As String = "SELECT TOP (2) c.FirstName, c.LastName, c.EmailAddress, p.PhoneTypeID, p.AreaCode, p.Number, p.Extension "
            sqlSelect += "FROM tblContactPhone AS cp INNER JOIN tblPhone as p ON cp.PhoneID = p.PhoneID RIGHT OUTER JOIN tblContact AS c ON cp.ContactID = c.ContactID "
            sqlSelect += "WHERE (c.CreditorID =  [@CreditorID]) "
            sqlSelect += "ORDER BY c.LastModified DESC "
            sqlSelect = sqlSelect.Replace("[@CreditorID]", CreditorAccountID)
            Using saTemp = New SqlClient.SqlDataAdapter(sqlSelect, System.Configuration.ConfigurationManager.AppSettings("connectionstring"))
                Dim dtContact As New DataTable
                saTemp.fill(dtContact)
                Return dtContact
            End Using
        Catch ex As Exception
            Return Nothing
        End Try
    End Function
End Class
 