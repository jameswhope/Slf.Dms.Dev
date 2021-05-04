Imports Microsoft.VisualBasic
Imports System.Data

Public Class ContactInfoHelper

    Public Enum ContactPhoneType As Integer
        Telephone = 56
        Fax = 57
    End Enum

    Public Shared Function GetContactInfo(ByVal CreditorAccountID As String, ByVal PhoneType As ContactPhoneType) As DataTable
        Try
            Dim sqlSelect As String = "SELECT TOP (1) c.FirstName, c.LastName, c.EmailAddress, p.PhoneTypeID, p.AreaCode, p.Number, p.Extension "
            sqlSelect += "FROM tblContactPhone AS cp INNER JOIN tblPhone as p ON cp.PhoneID = p.PhoneID RIGHT OUTER JOIN tblContact AS c ON cp.ContactID = c.ContactID "
            sqlSelect += "WHERE (c.CreditorID =  [@CreditorID]) "
            sqlSelect += "AND (PhoneTypeID = [@PhoneType]) "
            sqlSelect += "ORDER BY c.LastModified DESC "
            sqlSelect = sqlSelect.Replace("[@CreditorID]", CreditorAccountID)
            sqlSelect = sqlSelect.Replace("[@PhoneType]", PhoneType)
            Using saTemp = New SqlClient.SqlDataAdapter(sqlSelect, System.Configuration.ConfigurationManager.AppSettings("connectionstring"))
                Dim dtContact As New DataTable
                saTemp.Fill(dtContact)
                Return dtContact
            End Using
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

End Class
