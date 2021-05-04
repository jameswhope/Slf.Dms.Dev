Option Explicit On

Imports Drg.Util.DataAccess

Imports Slf.Dms.Records

Imports System.Data

Public Class CreditorHelper

    Public Shared Function Find(ByVal Name As String, ByVal CreateIfNotFound As Boolean, ByVal UserID As Integer) As Integer
        Return Find(Name, Nothing, Nothing, Nothing, 0, Nothing, CreateIfNotFound, UserID)
    End Function
    Public Shared Function Find(ByVal Name As String, ByVal Street As String, ByVal Street2 As String, _
        ByVal City As String, ByVal StateID As Integer, ByVal ZipCode As String, _
        ByVal CreateIfNotFound As Boolean, ByVal UserID As Integer)

        'build criteria
        Dim Criteria As String = String.Empty

        If Not Name Is Nothing AndAlso Name.Length > 0 Then
            If Criteria.Length > 0 Then
                Criteria += " AND tblCreditor.Name = '" & Name.Replace("'", "''") & "'"
            Else
                Criteria = "tblCreditor.Name = '" & Name.Replace("'", "''") & "'"
            End If
        End If

        If Not Street Is Nothing AndAlso Street.Length > 0 Then
            If Criteria.Length > 0 Then
                Criteria += " AND tblCreditor.Street = '" & Street.Replace("'", "''") & "'"
            Else
                Criteria = "tblCreditor.Street = '" & Street.Replace("'", "''") & "'"
            End If
        End If

        If Not Street2 Is Nothing AndAlso Street2.Length > 0 Then
            If Criteria.Length > 0 Then
                Criteria += " AND tblCreditor.Street2 = '" & Street2.Replace("'", "''") & "'"
            Else
                Criteria = "tblCreditor.Street2 = '" & Street2.Replace("'", "''") & "'"
            End If
        End If

        If Not City Is Nothing AndAlso City.Length > 0 Then
            If Criteria.Length > 0 Then
                Criteria += " AND tblCreditor.City = '" & City.Replace("'", "''") & "'"
            Else
                Criteria = "tblCreditor.City = '" & City.Replace("'", "''") & "'"
            End If
        End If

        If StateID > 0 Then
            If Criteria.Length > 0 Then
                Criteria += " AND tblCreditor.StateID = " & StateID
            Else
                Criteria = "tblCreditor.StateID = " & StateID
            End If
        End If

        If Not ZipCode Is Nothing AndAlso ZipCode.Length > 0 Then
            If Criteria.Length > 0 Then
                Criteria += " AND tblCreditor.ZipCode = '" & ZipCode.Replace("'", "''") & "'"
            Else
                Criteria = "tblCreditor.ZipCode = '" & ZipCode.Replace("'", "''") & "'"
            End If
        End If

        Dim CreditorID As Integer = DataHelper.Nz_int(DataHelper.FieldTop1("tblCreditor", _
            "CreditorID", Criteria, "[Name]"))

        If CreditorID = 0 Then 'not found

            If CreateIfNotFound Then
                CreditorID = InsertCreditor(Name, Street, Street2, City, StateID, ZipCode, UserID, -1)
            End If

        End If

        Return CreditorID

    End Function
    Public Shared Sub DeletePhones(ByVal CreditorID As Integer, ByVal Criteria As String)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_DeletePhonesForCreditor")

            DatabaseHelper.AddParameter(cmd, "CreditorID", CreditorID)

            If Not Criteria Is Nothing AndAlso Criteria.Length > 0 Then
                DatabaseHelper.AddParameter(cmd, "Criteria", Criteria)
            End If

            Using cmd.Connection

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

    End Sub
    Public Shared Function GetPhones(ByVal CreditorID As Integer) As List(Of Phone)

        Dim Phones As New List(Of Phone)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPhonesForCreditor")

            DatabaseHelper.AddParameter(cmd, "CreditorID", CreditorID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

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

                End Using
            End Using
        End Using

        Return Phones

    End Function
    Public Shared Function InsertCreditorPhone(ByVal CreditorID As Integer, ByVal PhoneID As Integer, _
        ByVal UserID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "CreditorID", CreditorID)
        DatabaseHelper.AddParameter(cmd, "PhoneID", PhoneID)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblCreditorPhone", "CreditorPhoneID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@CreditorPhoneID").Value)

    End Function
    Public Shared Function InsertCreditor(ByVal Name As String, ByVal Street As String, _
        ByVal Street2 As String, ByVal City As String, ByVal StateID As Integer, _
        ByVal ZipCode As String, ByVal UserID As Integer, ByVal CreditorGroupID As Integer) As Integer

        Dim intCreditorID As Integer

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_InsertCreditor")
            DatabaseHelper.AddParameter(cmd, "CreditorGroupID", CreditorGroupID)
            DatabaseHelper.AddParameter(cmd, "Name", Name.Trim.Replace("&nbsp;", ""))
            DatabaseHelper.AddParameter(cmd, "Street", Street.Trim.Replace("&nbsp;", ""))
            DatabaseHelper.AddParameter(cmd, "Street2", Street2.Trim.Replace("&nbsp;", ""))
            DatabaseHelper.AddParameter(cmd, "City", City.Trim.Replace("&nbsp;", ""))
            DatabaseHelper.AddParameter(cmd, "StateID", DataHelper.Zn(StateID))
            DatabaseHelper.AddParameter(cmd, "ZipCode", ZipCode.Trim.Replace("&nbsp;", ""))
            DatabaseHelper.AddParameter(cmd, "UserID", UserID)

            Using cmd.Connection
                cmd.Connection.Open()
                intCreditorID = CInt(cmd.ExecuteScalar)
            End Using
        End Using

        Return intCreditorID
    End Function
End Class