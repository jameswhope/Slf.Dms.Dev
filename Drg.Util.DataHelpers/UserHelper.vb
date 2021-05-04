Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Public Class UserHelper
    Inherits DataHelperBase

    Private Const Visit_MaxLen As Integer = 50
    Private Const Search_MaxLen As Integer = 255

    Public Shared Function HasPosition(ByVal UserID As Integer, ByVal PositionID As Integer) As Boolean

        Return (DataHelper.FieldCount("tblUserPosition", "UserPositionID", "UserID = " & UserID _
            & " AND PositionID = " & PositionID) > 0)

    End Function
    Public Shared Function Exists(ByVal UserID As Integer) As Boolean
        Return DataHelper.RecordExists("tblUser", "UserID = " & UserID)
    End Function
    Public Shared Function Exists(ByVal UserName As String) As Boolean
        Return DataHelper.RecordExists("tblUser", "UserName = '" & UserName & "'")
    End Function
    Public Shared Sub Delete(ByVal UserID As Integer)

        '(1) remove user visits
        UserVisitHelper.DeleteForUser(UserID)

        '(2) remove user searches
        UserSearchHelper.DeleteForUser(UserID)

        '(3) remove user info boxes
        UserInfoBoxHelper.DeleteForUser(UserID)

        '(4) remove user languages
        UserLanguageHelper.DeleteForUser(UserID)

        '(5) remove user positions
        UserPositionHelper.DeleteForUser(UserID)

        '(6) remove user record
        DataHelper.Delete("tblUser", "UserID = " & UserID)

    End Sub
    Public Shared Sub Delete(ByVal UserIDs() As Integer)

        For Each UserID As Integer In UserIDs
            Delete(UserID)
        Next

    End Sub

    Public Shared Function StoreVisit(ByVal UserID As Integer, ByVal Type As String, ByVal TypeID As Integer, _
        ByVal Disp As String) As Integer

        Dim Display As String = Disp
        If Display.Length > Visit_MaxLen Then
            Display = Display.Substring(0, Visit_MaxLen)
        End If

        Dim UserVisitID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblUserVisit", "UserVisitID", _
            "UserID = " & UserID & " AND Type = '" & Type & "' AND TypeID = " & TypeID))

        If UserVisitID = 0 Then 'user has not visited this

            'insert new visit
            UserVisitID = InsertUserVisit(UserID, Type, TypeID, Display)

        Else 'user made same visit already

            'take last visit and update it
            UpdateUserVisit(UserVisitID, UserID, Display)

        End If

        Return UserVisitID

    End Function
    Public Shared Function GetNextUser(ByVal LanguageID As Integer, ByVal PositionID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNextUserForClient")

        DatabaseHelper.AddParameter(cmd, "LanguageID", LanguageID)
        DatabaseHelper.AddParameter(cmd, "PositionID", PositionID)

        Try
            cmd.Connection.Open()
            Return DataHelper.Nz_int(cmd.ExecuteScalar())
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Function
    Public Shared Function StoreSearch(ByVal UserID As Integer, ByVal strTerms As String, _
        ByVal Results As Integer, ByVal ResultsClients As Integer, ByVal ResultsNotes As Integer, _
        ByVal ResultsCalls As Integer, ByVal ResultsTasks As Integer, ByVal ResultsEmail As Integer, _
        ByVal ResultsPersonnel As Integer) As Integer

        Dim Terms As String = strTerms
        If Terms.Length > Search_MaxLen Then
            Terms = Terms.Substring(0, Search_MaxLen)
        End If

        Dim UserSearchID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblUserSearch", "UserSearchID", _
            "UserID = " & UserID & " AND " & DataHelper.StripTime("Search") & " = '" _
            & Now.Date.ToString("MM/dd/yyyy") & "' AND Terms = '" & Terms.Replace("'", "''") & "'"))

        If UserSearchID = 0 Then 'user has not done this search today

            'insert new search
            UserSearchID = InsertUserSearch(UserID, Terms, Results, ResultsClients, ResultsNotes, _
                ResultsCalls, ResultsTasks, ResultsEmail, ResultsPersonnel)

        Else 'user made same search already today

            'take last search and update it
            UpdateUserSearch(UserSearchID, UserID, Terms, Results, ResultsClients, ResultsNotes, _
                ResultsCalls, ResultsTasks, ResultsEmail, ResultsPersonnel)

        End If

        Return UserSearchID

    End Function
    Public Shared Function InsertUserSearch(ByVal UserID As Integer, ByVal Terms As String, _
        ByVal Results As Integer, ByVal ResultsClients As Integer, ByVal ResultsNotes As Integer, _
        ByVal ResultsCalls As Integer, ByVal ResultsTasks As Integer, ByVal ResultsEmail As Integer, _
        ByVal ResultsPersonnel As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "UserID", UserID)
        DatabaseHelper.AddParameter(cmd, "Search", Now)
        DatabaseHelper.AddParameter(cmd, "Terms", Terms)
        DatabaseHelper.AddParameter(cmd, "Results", Results)
        DatabaseHelper.AddParameter(cmd, "ResultsClients", ResultsClients)
        DatabaseHelper.AddParameter(cmd, "ResultsNotes", ResultsNotes)
        DatabaseHelper.AddParameter(cmd, "ResultsCalls", ResultsCalls)
        DatabaseHelper.AddParameter(cmd, "ResultsTasks", ResultsTasks)
        DatabaseHelper.AddParameter(cmd, "ResultsEmail", ResultsEmail)
        DatabaseHelper.AddParameter(cmd, "ResultsPersonnel", ResultsPersonnel)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblUserSearch", "UserSearchID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@UserSearchID").Value)

    End Function
    Public Shared Sub UpdateUserSearch(ByVal UserSearchID As Integer, ByVal UserID As Integer, _
        ByVal Terms As String, ByVal Results As Integer, ByVal ResultsClients As Integer, _
        ByVal ResultsNotes As Integer, ByVal ResultsCalls As Integer, ByVal ResultsTasks As Integer, _
        ByVal ResultsEmail As Integer, ByVal ResultsPersonnel As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "UserID", UserID)
        DatabaseHelper.AddParameter(cmd, "Search", Now)
        DatabaseHelper.AddParameter(cmd, "Terms", Terms)
        DatabaseHelper.AddParameter(cmd, "Results", Results)
        DatabaseHelper.AddParameter(cmd, "ResultsClients", ResultsClients)
        DatabaseHelper.AddParameter(cmd, "ResultsNotes", ResultsNotes)
        DatabaseHelper.AddParameter(cmd, "ResultsCalls", ResultsCalls)
        DatabaseHelper.AddParameter(cmd, "ResultsTasks", ResultsTasks)
        DatabaseHelper.AddParameter(cmd, "ResultsEmail", ResultsEmail)
        DatabaseHelper.AddParameter(cmd, "ResultsPersonnel", ResultsPersonnel)

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblUserSearch", "UserSearchID = " & UserSearchID)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Public Shared Function InsertUserVisit(ByVal UserID As Integer, ByVal Type As String, _
        ByVal TypeID As Integer, ByVal Display As String) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "UserID", UserID)
        DatabaseHelper.AddParameter(cmd, "Type", Type)
        DatabaseHelper.AddParameter(cmd, "TypeID", TypeID)
        DatabaseHelper.AddParameter(cmd, "Display", Display)
        DatabaseHelper.AddParameter(cmd, "Visit", Now)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblUserVisit", "UserVisitID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@UserVisitID").Value)

    End Function
    Public Shared Sub UpdateUserVisit(ByVal UserVisitID As Integer, ByVal UserID As Integer, _
        ByVal Display As String)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Display", Display)
        DatabaseHelper.AddParameter(cmd, "Visit", Now)

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblUserVisit", "UserVisitID = " & UserVisitID)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Public Shared Function GetLastSearchTerms(ByVal UserID As Integer, ByRef UserSearchID As Integer) As String
        Return GetLastSearchTerms(UserID, Nothing, UserSearchID)
    End Function
    Public Shared Function GetLastSearchTerms(ByVal UserID As Integer, ByVal Day As Nullable(Of DateTime), ByRef UserSearchID As Integer) As String

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        If Day.HasValue Then

            cmd.CommandText = "SELECT TOP 1 UserSearchID, Terms FROM tblUserSearch WHERE " _
                & "UserID = @UserID AND " & DataHelper.StripTime("Search") & " = @Day ORDER BY Search DESC"

            DatabaseHelper.AddParameter(cmd, "Day", Day.Value.Date)

        Else

            cmd.CommandText = "SELECT TOP 1 UserSearchID, Terms FROM tblUserSearch WHERE " _
                & "UserID = @UserID ORDER BY Search DESC"

        End If

        DatabaseHelper.AddParameter(cmd, "UserID", UserID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                UserSearchID = DatabaseHelper.Peel_int(rd, "UserSearchID")

                Return DatabaseHelper.Peel_string(rd, "Terms")

            End If

        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
        Return ""
    End Function
    Public Shared Function GetName(ByVal UserID As Integer) As String
        Return GetName(UserID, False)
    End Function
    Public Shared Function GetName(ByVal UserID As Integer, ByVal Formal As Boolean) As String

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT FirstName, LastName FROM tblUser WHERE UserID = @UserID"

        DatabaseHelper.AddParameter(cmd, "UserID", UserID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim FirstName As String = DatabaseHelper.Peel_string(rd, "FirstName")
                Dim LastName As String = DatabaseHelper.Peel_string(rd, "LastName")

                Return GetName(FirstName, LastName, Formal)

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
        Return ""
    End Function
    Public Shared Function GetName(ByVal FirstName As String, ByVal LastName As String, ByVal Formal As Boolean) As String

        If Formal Then
            Return LastName & ", " & FirstName
        Else
            Return FirstName & " " & LastName
        End If

    End Function
    Public Shared Function GetLoginName(ByVal UserID As Integer) As String
        Return DataAccess.DataHelper.FieldLookup("tblUser", "UserName", "UserId = " & UserID)
    End Function
    Public Shared Function GetUserRole(ByVal UserID As Integer) As Integer
        Dim intUserRole As Integer

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandText = "SELECT UserID, UserGroupID, UserTypeID FROM tblUser where UserID = @UserID"

            DatabaseHelper.AddParameter(cmd, "UserID", UserID)

            cmd.Connection.Open()
            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)
                If rd.Read() Then
                    intUserRole = DatabaseHelper.Peel_int(rd, "UserGroupID")
                End If
            End Using
        End Using

        Return intUserRole
    End Function

    Public Shared Function InsertUser(ByVal FirstName As String, ByVal LastName As String, ByVal EmailAddress As String, ByVal SuperUser As Boolean, ByVal Locked As Boolean, ByVal Temporary As Boolean, ByVal UserName As String, ByVal Password As String, ByVal UserTypeId As Integer, ByVal UserGroupId As Integer, ByVal CommRecId As Integer, ByVal CreatedBy As Integer) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Dim recordUserId As Integer

        DatabaseHelper.AddParameter(cmd, "UserName", UserName)
        DatabaseHelper.AddParameter(cmd, "Password", DataHelper.GenerateSHAHash(Password))

        DatabaseHelper.AddParameter(cmd, "FirstName", FirstName)
        DatabaseHelper.AddParameter(cmd, "LastName", LastName)
        DatabaseHelper.AddParameter(cmd, "EmailAddress", EmailAddress)

        DatabaseHelper.AddParameter(cmd, "SuperUser", SuperUser)
        DatabaseHelper.AddParameter(cmd, "Locked", Locked)
        DatabaseHelper.AddParameter(cmd, "Temporary", Temporary)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", CreatedBy)

        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", CreatedBy)

        DatabaseHelper.AddParameter(cmd, "UserTypeId", UserTypeId)

        If Not UserGroupId = 0 Then
            DatabaseHelper.AddParameter(cmd, "UserGroupId", UserGroupId)
        Else
            DatabaseHelper.AddParameter(cmd, "UserGroupId", DBNull.Value, DbType.Int32)
        End If

        If Not CommRecId = 0 Then
            DatabaseHelper.AddParameter(cmd, "CommRecId", CommRecId)
        Else
            DatabaseHelper.AddParameter(cmd, "CommRecId", DBNull.Value, DbType.Int32)
        End If

        DatabaseHelper.BuildInsertCommandText(cmd, "tblUser", "UserID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        recordUserId = DataHelper.Nz_int(cmd.Parameters("@UserID").Value)

        Return recordUserId
    End Function

    Public Shared Function UpdateUser(ByVal UserId As Integer, ByVal FirstName As String, ByVal LastName As String, ByVal EmailAddress As String, ByVal SuperUser As Boolean, ByVal Locked As Boolean, ByVal Temporary As Boolean, ByVal UserName As String, ByVal Password As String, ByVal UserTypeId As Integer, ByVal UserGroupId As Integer, ByVal CommRecId As Integer, ByVal ModifiedBy As Integer) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "FirstName", FirstName)
        DatabaseHelper.AddParameter(cmd, "LastName", LastName)
        DatabaseHelper.AddParameter(cmd, "EmailAddress", EmailAddress)

        DatabaseHelper.AddParameter(cmd, "SuperUser", SuperUser)
        DatabaseHelper.AddParameter(cmd, "Locked", Locked)
        DatabaseHelper.AddParameter(cmd, "Temporary", Temporary)

        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", ModifiedBy)

        DatabaseHelper.AddParameter(cmd, "UserTypeId", UserTypeId)

        If Not UserName Is Nothing And UserName.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "Password", DataHelper.GenerateSHAHash(Password))
        End If

        If Not Password Is Nothing And Password.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "Password", DataHelper.GenerateSHAHash(Password))
        End If

        If Not UserGroupId = 0 Then
            DatabaseHelper.AddParameter(cmd, "UserGroupId", UserGroupId)
        Else
            DatabaseHelper.AddParameter(cmd, "UserGroupId", DBNull.Value, DbType.Int32)
        End If

        If Not CommRecId = 0 Then
            DatabaseHelper.AddParameter(cmd, "CommRecId", CommRecId)
        Else
            DatabaseHelper.AddParameter(cmd, "CommRecId", DBNull.Value, DbType.Int32)
        End If

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblUser", "UserID = " & UserId)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Function

    Public Shared Function UserCompanies(ByVal intUserID As Integer) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_UserCompanies")
        Dim objBase As New DataHelperBase
        Dim tbl As DataTable

        Try
            DatabaseHelper.AddParameter(cmd, "UserID", intUserID)
            tbl = objBase.ExecuteQuery(cmd)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            objBase = Nothing
        End Try

        Return tbl
    End Function

    Public Shared Function UserCommRecs(ByVal intUserID As Integer) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_UserCommRecs")
        Dim objBase As New DataHelperBase
        Dim tbl As DataTable

        Try
            DatabaseHelper.AddParameter(cmd, "UserID", intUserID)
            tbl = objBase.ExecuteQuery(cmd)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            objBase = Nothing
        End Try

        Return tbl
    End Function

    Public Function GetCommRecAccessUsers() As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCommRecAccessUsers")
        Return MyBase.ExecuteQuery(cmd)
    End Function

    Public Shared Function UserAgency(ByVal intUserID As Integer) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_UserAgency")
        Dim objBase As New DataHelperBase
        Dim tbl As DataTable

        Try
            DatabaseHelper.AddParameter(cmd, "UserID", intUserID)
            tbl = objBase.ExecuteQuery(cmd)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            objBase = Nothing
        End Try

        Return tbl
    End Function

    Public Shared Sub SaveUserCommRecAccess(ByVal intUserID As Integer, ByVal lstCommRecIDs As String)
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_SaveUserCommRecAccess")
        Dim objBase As New DataHelperBase

        Try
            DatabaseHelper.AddParameter(cmd, "UserID", intUserID)
            DatabaseHelper.AddParameter(cmd, "CommRecIDs", lstCommRecIDs)

            'save any new ids and remove any ids not in this list
            objBase.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            objBase = Nothing
        End Try
    End Sub

    Public Shared Sub SaveUserAgencyAccess(ByVal intUserID As Integer, ByVal lstAgencyIDs As String)
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_SaveUserAgencyAccess")
        Dim objBase As New DataHelperBase

        Try
            DatabaseHelper.AddParameter(cmd, "UserID", intUserID)
            DatabaseHelper.AddParameter(cmd, "AgencyIDs", lstAgencyIDs)

            'save any new ids and remove any ids not in this list
            objBase.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            objBase = Nothing
        End Try
    End Sub

    Public Shared Sub SaveUserCompanyAccess(ByVal intUserID As Integer, ByVal lstCompanyIDs As String)
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_SaveUserCompanyAccess")
        Dim objBase As New DataHelperBase

        Try
            DatabaseHelper.AddParameter(cmd, "UserID", intUserID)
            DatabaseHelper.AddParameter(cmd, "CompanyIDs", lstCompanyIDs)

            'save any new ids and remove any ids not in this list
            objBase.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            objBase = Nothing
        End Try
    End Sub

    Public Shared Sub SaveUserClientAccess(ByVal intUserID As Integer, ByVal strCreatedFrom As String, ByVal strCreatedTo As String)
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_SaveUserClientAccess")
        Dim objBase As New DataHelperBase

        Try
            If Not IsDate(strCreatedFrom) Then strCreatedFrom = "1/1/2000"
            If Not IsDate(strCreatedTo) Then strCreatedTo = "12/31/2050"

            DatabaseHelper.AddParameter(cmd, "UserID", intUserID)
            DatabaseHelper.AddParameter(cmd, "CreatedFrom", strCreatedFrom)
            DatabaseHelper.AddParameter(cmd, "CreatedTo", strCreatedTo)

            objBase.ExecuteNonQuery(cmd)
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            objBase = Nothing
        End Try
    End Sub

End Class