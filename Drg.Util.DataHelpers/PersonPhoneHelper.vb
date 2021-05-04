Imports Drg.Util.DataAccess

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Public Class PersonPhoneHelper

    Public Shared Sub Delete(ByVal PersonPhoneID As Integer)

        'delete the record
        DataHelper.Delete("tblPersonPhone", "PersonPhoneID = " & PersonPhoneID)

    End Sub
    Public Shared Sub Delete(ByVal Criteria As String)

        Dim PersonPhoneIDs() As Integer = DataHelper.FieldLookupIDs("tblPersonPhone", _
            "PersonPhoneID", Criteria)

        Delete(PersonPhoneIDs)

    End Sub
    Public Shared Sub Delete(ByVal PersonPhoneIDs() As Integer)

        'loop through and delete each one
        For Each PersonPhoneID As Integer In PersonPhoneIDs
            Delete(PersonPhoneID)
        Next

    End Sub
    Public Shared Function Insert(ByVal PersonID As Integer, ByVal PhoneID As Integer, ByVal UserID As Integer)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "PersonID", PersonID)
            DatabaseHelper.AddParameter(cmd, "PhoneID", PhoneID)

            DatabaseHelper.AddParameter(cmd, "Created", Now)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

            DatabaseHelper.BuildInsertCommandText(cmd, "tblPersonPhone", "PersonPhoneID", SqlDbType.Int)

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

                Return DataHelper.Nz_int(cmd.Parameters("@PersonPhoneID").Value)

            End Using
        End Using

    End Function
    Public Shared Sub Update(ByVal PersonID As Integer, ByVal Type As String, ByVal Value As String, _
        ByVal UserID As Integer)

        Dim PhoneTypeID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPhoneType", _
            "PhoneTypeID", "Name = '" & Type & "'"))

        If Value.Length > 0 Then

            If PhoneTypeID = 0 Then
                PhoneTypeID = 32 'other
            End If

            Dim AreaCode As String = Value.Substring(0, 3)
            Dim Number As String = Value.Substring(3)

            'search for any instance of this phone record
            Dim PhoneID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPhone", "PhoneID", _
                "PhoneTypeID = " & PhoneTypeID & " AND AreaCode = '" & AreaCode & "' AND Number = '" _
                & Number & "'"))

            If Not PhoneID = 0 Then

                'search for any instance of a link between this existing phone record and this person
                Dim PersonPhoneID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPersonPhone", _
                    "PersonPhoneID", "PhoneID = " & PhoneID & " AND PersonID = " & PersonID))

                If PersonPhoneID = 0 Then 'phone exists, not for this person

                    'link existing phone record to this person
                    PersonPhoneHelper.Insert(PersonID, PhoneID, UserID)

                End If

            Else 'phone does NOT exist

                'delete any existing phone record for this person with the same phonetypeid
                PersonHelper.DeletePhones(PersonID, "PhoneTypeID = " & PhoneTypeID)

                'create new phone record
                PhoneID = PhoneHelper.InsertPhone(PhoneTypeID, AreaCode, Number, String.Empty, UserID)

                'link it to this person
                PersonPhoneHelper.Insert(PersonID, PhoneID, UserID)

            End If

        Else

            'delete the existing phone record for this person of this phonetype
            PersonHelper.DeletePhones(PersonID, "PhoneTypeID = " & PhoneTypeID)

        End If

    End Sub
End Class