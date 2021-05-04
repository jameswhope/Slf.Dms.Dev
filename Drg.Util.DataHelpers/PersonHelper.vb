Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Public Class PersonHelper

    Public Shared Sub DeletePhones(ByVal PersonID As Integer, ByVal Criteria As String)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_DeletePhonesForPerson")

            DatabaseHelper.AddParameter(cmd, "PersonID", PersonID)

            If Not Criteria Is Nothing AndAlso Criteria.Length > 0 Then
                DatabaseHelper.AddParameter(cmd, "Criteria", Criteria)
            End If

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

    End Sub
    Public Shared Sub Delete(ByVal PersonID As Integer, ByVal UserID As Integer)

        '(1) delete all phone links (tblPersonPhone)
        Dim PersonPhones As List(Of PersonPhone) = GetPersonPhones(PersonID)

        For Each PersonPhone As PersonPhone In PersonPhones
            PersonPhoneHelper.Delete(PersonPhone.PersonPhoneID)
        Next

        '(2) delete the record
        DataHelper.AuditedDelete("tblPerson", PersonID, UserID)

    End Sub
    Public Shared Sub Delete(ByVal Criteria As String, ByVal UserID As Integer)

        Dim PersonIDs() As Integer = DataHelper.FieldLookupIDs("tblPerson", _
            "PersonID", Criteria)

        Delete(PersonIDs, UserID)

    End Sub
    Public Shared Sub Delete(ByVal PersonIDs() As Integer, ByVal UserID As Integer)

        'loop through and delete each one
        For Each PersonID As Integer In PersonIDs
            Delete(PersonID, UserID)
        Next

    End Sub
    Public Shared Sub SetGender(ByVal PersonID As Integer)

        Dim FirstName As String = DataHelper.FieldLookup("tblPerson", "FirstName", "PersonID = " & PersonID)

        Dim Gender As String = NameHelper.GetGender(FirstName)

        'only write in gender if no gender exists
        If Gender.Length > 0 Then
            DataHelper.FieldUpdate("tblPerson", "Gender", Gender.Substring(0, 1).ToUpper(), "PersonID = " & PersonID & " AND (Gender IS NULL OR LEN(Gender) = 0)")
        End If

    End Sub
    Public Shared Sub SetAsPrimary(ByVal PersonID As Integer, ByVal ClientID As Integer, ByVal UserID As Integer)

        'get current primary person
        Dim CurrentPrimaryPersonID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "PrimaryPersonID", "ClientID = " & ClientID))

        'set current primary relationship to "Other"
        UpdateField(CurrentPrimaryPersonID, "Relationship", "Other", UserID)

        'set current primary's canauthorize to "false"
        UpdateField(CurrentPrimaryPersonID, "CanAuthorize", False, UserID)

        'set this persons relationship to "Prime"
        UpdateField(PersonID, "Relationship", "Prime", UserID)

        'set this person's canauthorize to "true"
        UpdateField(PersonID, "CanAuthorize", True, UserID)

        'set this person as primary on client
        ClientHelper.UpdateField(ClientID, "PrimaryPersonID", PersonID, UserID)

    End Sub
    Public Shared Function GetName(ByVal PersonID As Integer) As String
        Return GetName(PersonID, False)
    End Function
    Public Shared Function GetName(ByVal PersonID As Integer, ByVal Formal As Boolean) As String

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT FirstName, LastName, SSN, EmailAddress FROM tblPerson WHERE PersonID = @PersonID"

        DatabaseHelper.AddParameter(cmd, "PersonID", PersonID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim FirstName As String = DatabaseHelper.Peel_string(rd, "FirstName")
                Dim LastName As String = DatabaseHelper.Peel_string(rd, "LastName")
                Dim SSN As String = DatabaseHelper.Peel_string(rd, "SSN")
                Dim EmailAddress As String = DatabaseHelper.Peel_string(rd, "EmailAddress")

                Return GetName(FirstName, LastName, SSN, EmailAddress, Formal)

            End If

        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
        Return ""
    End Function
    Public Shared Function GetName(ByVal FirstName As String, ByVal LastName As String, ByVal SSN As String, _
        ByVal EmailAddress As String) As String

        Return GetName(FirstName, LastName, SSN, EmailAddress, False)

    End Function
    Public Shared Function GetName(ByVal FirstName As String, ByVal LastName As String, ByVal SSN As String, _
        ByVal EmailAddress As String, ByVal Formal As Boolean) As String

        If LastName.Length > 0 Then

            If FirstName.Length > 0 Then

                If Formal Then
                    Return LastName & ", " & FirstName
                Else
                    Return FirstName & " " & LastName
                End If

            Else
                Return LastName
            End If

        Else

            If FirstName.Length > 0 Then
                Return FirstName
            Else

                If SSN.Length > 0 Then
                    Return StringHelper.PlaceInMask(SSN, "___-__-____", "_", StringHelper.Filter.NumericOnly, False)
                Else

                    If EmailAddress.Length > 0 Then
                        Return EmailAddress
                    End If

                End If

            End If

        End If
        Return ""
    End Function
    Public Shared Function GetAddress(ByVal PersonID As Integer)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPerson WHERE PersonID = @PersonID"

        DatabaseHelper.AddParameter(cmd, "PersonID", PersonID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim StateID As Integer = DatabaseHelper.Peel_int(rd, "StateID")
                Dim State As String = DataHelper.FieldLookup("tblState", "Name", "StateID = " & StateID)

                Return PersonHelper.GetAddress(DatabaseHelper.Peel_string(rd, "Street"), _
                    DatabaseHelper.Peel_string(rd, "Street2"), _
                    DatabaseHelper.Peel_string(rd, "City"), State, _
                    DatabaseHelper.Peel_string(rd, "ZipCode"))

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
        Return ""
    End Function
    Public Shared Function GetAddress(ByVal Street1 As String, ByVal Street2 As String, ByVal City As String, _
        ByVal State As String, ByVal ZipCode As String) As String

        GetAddress = String.Empty

        If Street1.Length > 0 Then
            GetAddress += Street1
        End If

        If Street2.Length > 0 Then
            If GetAddress.Length > 0 Then
                GetAddress += vbCrLf & Street2
            Else
                GetAddress += Street2
            End If
        End If

        If City.Length > 0 Then
            If GetAddress.Length > 0 Then
                GetAddress += vbCrLf & City
            Else
                GetAddress += City
            End If
        End If

        If State.Length > 0 Then
            If City.Length > 0 Then
                GetAddress += ", " & State
            Else
                If GetAddress.Length > 0 Then
                    GetAddress += vbCrLf & State
                Else
                    GetAddress += State
                End If
            End If
        End If

        If ZipCode.Length > 0 Then
            If State.Length > 0 Then
                GetAddress += " " & ZipCode
            ElseIf City.Length > 0 Then
                GetAddress += ", " & ZipCode
            Else
                If GetAddress.Length > 0 Then
                    GetAddress += vbCrLf & ZipCode
                Else
                    GetAddress += ZipCode
                End If
            End If
        End If

    End Function
    Public Shared Function InsertPerson(ByVal ClientID As Integer, ByVal FirstName As String, _
        ByVal LastName As String, ByVal Gender As String, _
        ByVal LanguageID As Integer, ByVal EmailAddress As String, ByVal Street As String, _
        ByVal Street2 As String, ByVal City As String, ByVal StateID As Integer, ByVal ZipCode As String, _
        ByVal Relationship As String, ByVal CanAuthorize As Boolean, ByVal UserID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "FirstName", FirstName)
        DatabaseHelper.AddParameter(cmd, "LastName", LastName)

        If Not Gender Is Nothing AndAlso Gender.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "Gender", Gender.Substring(0, 1).ToUpper)
        Else
            DatabaseHelper.AddParameter(cmd, "Gender", DBNull.Value)
        End If

        DatabaseHelper.AddParameter(cmd, "LanguageID", LanguageID)
        DatabaseHelper.AddParameter(cmd, "EmailAddress", DataHelper.Zn(EmailAddress))
        DatabaseHelper.AddParameter(cmd, "Street", Street)
        DatabaseHelper.AddParameter(cmd, "Street2", DataHelper.Zn(Street2))
        DatabaseHelper.AddParameter(cmd, "City", City)
        DatabaseHelper.AddParameter(cmd, "StateID", StateID)
        DatabaseHelper.AddParameter(cmd, "ZipCode", ZipCode)
        DatabaseHelper.AddParameter(cmd, "Relationship", Relationship)
        DatabaseHelper.AddParameter(cmd, "CanAuthorize", CanAuthorize)

        'try-retrieve the web service info
        If ZipCode.Trim.Length >= 5 Then

            Dim WebInfo As AddressHelper.AddressInfo = AddressHelper.GetInfoForZip(ZipCode.Trim.Substring(0, 5))

            If Not WebInfo Is Nothing AndAlso WebInfo.ZipCode.Length > 0 Then

                DatabaseHelper.AddParameter(cmd, "WebCity", WebInfo.City)
                DatabaseHelper.AddParameter(cmd, "WebStateID", WebInfo.StateID)
                DatabaseHelper.AddParameter(cmd, "WebZipCode", WebInfo.ZipCode)
                DatabaseHelper.AddParameter(cmd, "WebAreaCode", WebInfo.AreaCode)
                DatabaseHelper.AddParameter(cmd, "WebTimeZoneID", WebInfo.TimeZoneID)

            End If

        End If

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        DatabaseHelper.BuildInsertCommandText(cmd, "tblPerson", "PersonID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@PersonID").Value)

    End Function
    Public Shared Function InsertPersonPhone(ByVal PersonID As Integer, ByVal PhoneID As Integer, _
        ByVal UserID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "PersonID", PersonID)
        DatabaseHelper.AddParameter(cmd, "PhoneID", PhoneID)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        DatabaseHelper.BuildInsertCommandText(cmd, "tblPersonPhone", "PersonPhoneID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@PersonPhoneID").Value)

    End Function
    Public Shared Sub UpdateField(ByVal PersonID As Integer, ByVal Field As String, ByVal Value As Object, _
        ByVal UserID As Integer)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, Field, Value)

            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

            DatabaseHelper.BuildUpdateCommandText(cmd, "tblPerson", "PersonID = " & PersonID)

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

    End Sub
    Public Shared Function GetPhones(ByVal PersonID As Integer) As List(Of Phone)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPhonesForPerson")

        DatabaseHelper.AddParameter(cmd, "PersonID", PersonID)

        Dim Phones As New List(Of Phone)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Phones.Add(New Phone(DatabaseHelper.Peel_int(rd, "PhoneID"), _
                    DatabaseHelper.Peel_int(rd, "PhoneTypeID"), _
                    DatabaseHelper.Peel_string(rd, "PhoneTypeName"), _
                    DatabaseHelper.Peel_string(rd, "AreaCode"), _
                    DatabaseHelper.Peel_string(rd, "Number"), _
                    DatabaseHelper.Peel_string(rd, "Extension"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return Phones

    End Function
    Public Shared Function GetPersonPhones(ByVal PersonID As Integer) As List(Of PersonPhone)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPersonPhonesForPerson")

        DatabaseHelper.AddParameter(cmd, "PersonID", PersonID)

        Dim PersonPhones As New List(Of PersonPhone)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                PersonPhones.Add(New PersonPhone(DatabaseHelper.Peel_int(rd, "PersonPhoneID"), _
                    DatabaseHelper.Peel_int(rd, "PersonID"), _
                    DatabaseHelper.Peel_int(rd, "PhoneID"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return PersonPhones

    End Function
End Class