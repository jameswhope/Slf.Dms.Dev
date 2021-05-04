Imports System
Imports System.Data
Imports Drg.Util.DataAccess
Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.Security.Cryptography
Imports System.Security.Cryptography.X509Certificates

Public Class LeadHelper

#Region "Structure OldAssignments"

   Public Structure OldAssignments

      Public LeadApplicantID As Integer
      Public TableName As String
      Public FieldName As String
      Public OldValue As String
      Public NewValue As String

   End Structure

#End Region

   Public Overloads Shared Function getReportDataSet(ByVal strSQL As String, ByVal TableName As String) As Data.DataSet

      ' Returns a data set from a datatable and names it
      Dim dsTemp As Data.DataSet

      Try
         Using cnSQL As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
            Dim adapter As New SqlDataAdapter()
            adapter.SelectCommand = New SqlCommand(strSQL, cnSQL)
            adapter.SelectCommand.CommandTimeout = 180
            dsTemp = New Data.DataSet
            adapter.Fill(dsTemp)
            dsTemp.Tables(0).TableName = TableName
         End Using
         Return dsTemp
      Catch ex As SqlException
         Alert.Show("This report has generated errors. Error: " & ex.Message)
         Return Nothing
      End Try

   End Function

   Public Shared Function GetLeadSQL() As String

      ' Get the stored proc as the assignment call
      Dim strSQL As String = "exec stp_GetAssignLeads"
      Return strSQL

   End Function

   Public Shared Function GetReps1SQL() As String

      ' Get the Law Firm Rep names call
      Dim strSQL As String = ""

      strSQL += "DECLARE @Reps TABLE "
      strSQL += "(UserID int, "
      strSQL += "Rep nvarchar(200)) "
      strSQL += "INSERT INTO @Reps "
      strSQL += "SELECT 0, 'Please Select....' "
      strSQL += "INSERT INTO @Reps "
      strSQL += "SELECT 1, 'Return to Leadpool' "
      strSQL += "INSERT INTO @Reps "
      strSQL += "SELECT "
      strSQL += "UserID, "
      strSQL += "FirstName + ' ' + LastName [Rep]"
      strSQL += "FROM tblUser "
      strSQL += "WHERE "
        strSQL += "locked = 0 and temporary = 0 "
        strSQL += "ORDER BY FirstName, LastName "
      strSQL += "SELECT * FROM @Reps"

      Return strSQL

   End Function

   Public Shared Function GetReps2SQL() As String

      ' Get the Law Firm Rep names call
      Dim strSQL As String = ""

      strSQL += "DECLARE @Reps TABLE "
      strSQL += "(UserID int, "
      strSQL += "Rep nvarchar(200)) "
      strSQL += "INSERT INTO @Reps "
      strSQL += "SELECT 0, '-- All --' "
      strSQL += "INSERT INTO @Reps "
      strSQL += "SELECT 1, '**Unassigned**' "
      strSQL += "INSERT INTO @Reps "
      strSQL += "SELECT "
      strSQL += "UserID, "
      strSQL += "FirstName + ' ' + LastName [Rep] "
      strSQL += "FROM tblUser "
      strSQL += "WHERE "
        strSQL += "locked = 0 and temporary = 0 "
        strSQL += "ORDER BY FirstName, LastName "
      strSQL += "SELECT * FROM @Reps"

      Return strSQL

   End Function

   Public Shared Function GetApplicantSQL() As String

      ' Get the Law Firm Rep names call
      Dim strSQL As String = ""

      strSQL += "DECLARE @Applicant TABLE "
      strSQL += "(LeadApplicantID int, "
      strSQL += "Applicant nvarchar(200)) "
      strSQL += "INSERT INTO @Applicant "
      strSQL += "SELECT 0, '-- All --' "
      strSQL += "INSERT INTO @Applicant "
      strSQL += "SELECT "
      strSQL += "LeadApplicantID, "
      strSQL += "CASE WHEN LEN(FirstName) = 0 THEN '?, ' + LastName WHEN LEN(LastName) = 0 THEN FirstName + ', ?' ELSE FirstName + ' ' + LastName END  [Applicant] "
      strSQL += "FROM tblLeadApplicant "
      strSQL += "WHERE LEN(FirstName) > 0 "
      strSQL += "OR LEN(LastName) > 0 "
      strSQL += "ORDER BY LastName "
      strSQL += "SELECT * FROM @Applicant"

      Return strSQL

   End Function

   Public Shared Function GetStatusSQL() As String

      ' Get the Law Firm Rep names call
      Dim strSQL As String = ""

      strSQL += "DECLARE @Status TABLE "
      strSQL += "(StatusID int, "
      strSQL += "Description nvarchar(200)) "
      strSQL += "INSERT INTO @Status "
      strSQL += "SELECT 0, '-- All --' "
      strSQL += "INSERT INTO @Status "
      strSQL += "SELECT "
      strSQL += "StatusID, "
      strSQL += "Description "
      strSQL += "FROM tblLeadStatus "
      strSQL += "ORDER BY Description "
      strSQL += "SELECT * FROM @Status"

      Return strSQL

   End Function

   Public Shared Function GetAgingSQL() As String
      ' Get the aging periods call
      Dim strSQL As String = ""

      strSQL += "DECLARE @Aging TABLE "
      strSQL += "(AgingID int, "
      strSQL += "Aging nvarchar(50)) "
      strSQL += "INSERT INTO @Aging "
      strSQL += "SELECT 0, '-- All --' "
      strSQL += "INSERT INTO @Aging "
      strSQL += "SELECT "
      strSQL += "LeadAgingID AS 'AgingID', "
      strSQL += "LeadAge AS 'Aging' "
      strSQL += "FROM tblLeadAging "
      strSQL += "ORDER BY LeadAgingID "
      strSQL += "SELECT * FROM @Aging"

      Return strSQL
   End Function

   Public Shared Function GetAgingUpdate() As String
      Dim strSQL As String = ""

      strSQL += "SELECT "
      strSQL += "LeadAge AS 'Aging Days' "
      strSQL += "FROM tblLeadAging "
      strSQL += "ORDER BY LeadAgingID "

      Return strSQL
   End Function

   Public Shared Function AddAging(ByVal Row As Infragistics.WebUI.UltraWebGrid.UltraGridRow, ByVal UserID As Integer) As Boolean

      If Row IsNot Nothing Then
         If Row.Cells(1).Value.ToString <> "" Then
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand
               Using cmd.Connection
                  cmd.Connection.Open()
                  cmd.Parameters.Clear()
                  DatabaseHelper.AddParameter(cmd, "LeadAge", Row.Cells(1).Value)
                  DatabaseHelper.AddParameter(cmd, "Created", Now)
                  DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                  DatabaseHelper.AddParameter(cmd, "Modified", Now)
                  DatabaseHelper.AddParameter(cmd, "ModifiedBy", UserID)
                  DatabaseHelper.BuildInsertCommandText(cmd, "tblLeadAging")
                  cmd.ExecuteNonQuery()
               End Using
            End Using
         End If
      End If

   End Function

   Public Shared Function UpdateAging(ByVal Row As Infragistics.WebUI.UltraWebGrid.UltraGridRow, ByVal UserID As Integer) As Boolean

      If Row IsNot Nothing Then
         If Row.Cells(1).Value.ToString <> "" Then
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand
               Using cmd.Connection
                  cmd.Connection.Open()
                  cmd.CommandType = CommandType.Text
                  cmd.CommandText = "UPDATE tblLeadAging SET LeadAge = '" & Row.Cells(1).Value.ToString & "', "
                  cmd.CommandText += "Modified = '" & Now & "', "
                  cmd.CommandText += "ModifiedBy = " & UserID & " "
                  cmd.CommandText += "WHERE LeadAgingID = " & Row.Cells(0).Value
                  cmd.ExecuteNonQuery()
               End Using
            End Using
         End If
      End If

   End Function

   Public Shared Function DeleteAging(ByVal Row As Infragistics.WebUI.UltraWebGrid.UltraGridRow, ByVal UserID As Integer) As Boolean

      If Row IsNot Nothing Then
         If Row.Cells(0).Value.ToString <> "" Then
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand
               Using cmd.Connection
                  cmd.Connection.Open()
                  cmd.CommandType = CommandType.Text
                  cmd.CommandText = "DELETE FROM tblLeadAging WHERE LeadAge = " & Row.Cells(1).Value
                  cmd.ExecuteNonQuery()
               End Using
            End Using
         End If
      End If

   End Function

   Public Shared Function GetStateSQL() As String

      ' Get the Law Firm Rep names call
      Dim strSQL As String = ""

      strSQL += "DECLARE @State TABLE "
      strSQL += "(StateID int, "
      strSQL += "Abbreviation nvarchar(15)) "
      strSQL += "INSERT INTO @State "
      strSQL += "SELECT 0, '-- All --' "
      strSQL += "INSERT INTO @State "
      strSQL += "SELECT "
      strSQL += "StateID, "
      strSQL += "Abbreviation "
      strSQL += "FROM tblState "
      strSQL += "ORDER BY Abbreviation "
      strSQL += "SELECT * FROM @State"

      Return strSQL

   End Function

   Public Shared Function BuildReportSQL(ByVal ApplicantID As Integer, ByVal StateID As Integer, ByVal StatusID As Integer, ByVal RepID As Integer, ByVal Aging As String, ByVal Flags As Boolean) As String

      Dim WhereClause As String = ""
      Dim Space As Char = " "c
      Dim Hyphen As Char = "-"c
      Dim Delimiters() As Char = {Space, Hyphen}
      'Dim AgingArray As String()
      Dim StartDate As String = ""
      Dim EndDate As String = ""
      Dim strSQL As String = ""

      If Flags = True Then
         If ApplicantID > 0 Then
            If Len(WhereClause) = 0 Then
               WhereClause += "AND la.LeadApplicantID = " & ApplicantID
            Else
               WhereClause += " AND la.LeadApplicantID = " & ApplicantID
            End If
         End If

         If StateID > 0 Then
            If Len(WhereClause) = 0 Then
               WhereClause += "AND la.StateID = " & StateID
            Else
               WhereClause += " AND la.StateID = " & StateID
            End If
         End If

         If StatusID > 0 Then
            If Len(WhereClause) = 0 Then
               WhereClause += "AND la.StatusID = " & StatusID
            Else
               WhereClause += " AND la.StatusID = " & StatusID
            End If
         End If

         'This is the rep stuff
         If RepID > 0 Then
            If Len(WhereClause) = 0 Then
               WhereClause += "AND la.RepID "
            Else
               WhereClause += " AND la.RepID "
            End If
            If RepID = 1 Then
               WhereClause += "< 1"
            Else
               WhereClause += "= " & RepID
            End If
         End If

         'Manipulate the Aging string it must always have a string value
         If Aging = "-- All --" Then 'This is the only thing this can be for all
            If Len(WhereClause) = 0 Then
               WhereClause += "AND la.Created > '01/01/1900'"
            Else
               WhereClause += " AND la.Created > '01/01/1900'"
            End If
         Else 'Break apart the string into usable parts and get the days always has a value
            If Len(WhereClause) = 0 Then 'Start the where clause with a between statement
               WhereClause += "AND la.Created >= '" & Format(DateAdd(DateInterval.Day, -CDbl(Val(Aging)), Now), "MM/dd/yyyy") & "'"
            Else
               WhereClause += " AND la.Created >= '" & Format(DateAdd(DateInterval.Day, -CDbl(Val(Aging)), Now), "MM/dd/yyyy") & "'"
            End If
         End If

         ''Now process the rest of the statement
         'Dim cnt As Integer = 0
         'AgingArray = Aging.Split(Delimiters)
         'Dim subString As String
         'For Each subString In AgingArray
         '   Select Case subString
         '      Case "Over"
         '         EndDate = "'01/01/2050'"
         '      Case Else 'Number of days from today
         '         If StartDate = "" Then
         '            StartDate = "'" & Format(DateAdd(DateInterval.Day, CDbl(Val(subString)), Now), "MM/dd/yyyy") & "'"
         '         End If
         '         If EndDate = "" Then
         '            'EndDate = "'" & Format(Now, "MM/dd/yyyy") & "'"
         '            EndDate = "'" & Format(DateAdd(DateInterval.Day, +1, Now), "MM/dd/yyyy") & "'"
         '         End If
         '         WhereClause += StartDate & " AND " & EndDate
         '   End Select
         'Next subString
      End If

      ' Get the Law Firm Rep names call

        strSQL += "SELECT distinct la.LeadApplicantID, "
        strSQL += "u.LastName, "
        strSQL += "0 [Selected], "
        strSQL += "la.FullName [Applicant], "
        strSQL += "s.Abbreviation [State], "
        strSQL += "la.HomePhone [Home], "
        strSQL += "la.BusinessPhone [Business], "
        strSQL += "CASE WHEN lrm.reason IS NULL THEN ls.description ELSE ls.Description + '/' + lrm.Reason END [Status], "
        strSQL += "DATEDIFF(day, cast(la.lastmodified AS varchar(30)), cast(GETDATE() AS nvarchar(30))) [TIS], "
        strSQL += "u.FirstName + ' ' + u.LastName [Rep], "
        strSQL += "DATEDIFF(day, cast(la.Created AS varchar(30)), cast(GETDATE() AS varchar(30))) [Aging] "
        strSQL += "FROM tblLeadApplicant AS la "
        strSQL += "LEFT JOIN tblLeadStatus AS ls ON ls.StatusID = la.StatusID "
        strSQL += "LEFT JOIN tblLeadRoadmap lrm ON lrm.LeadRoadmapID = (SELECT TOP 1 LeadRoadMapID FROM tblLeadRoadMap WHERE tblLeadRoadMap.LeadApplicantID = la.leadapplicantid ORDER BY lastmodified) "
        strSQL += "LEFT JOIN tblState AS s ON s.StateID = la.StateID "
        strSQL += "LEFT JOIN tblUser AS u ON u.UserID = la.RepID "
        strSQL += "WHERE 1=1 " & WhereClause

        Return strSQL

    End Function

   Public Shared Function ReAssignLeads(ByVal NewAssignments() As Integer, ByVal UserID As Integer, ByVal RepID As Integer) As Boolean

      ' Update the leads to the newy assigned Law Firm Rep.
      Dim i As Integer

      Dim cmd As New Data.SqlClient.SqlCommand()

      For i = 0 To NewAssignments.Length - 1
         cmd.CommandType = Data.CommandType.Text
         If RepID = 1 Then
                     cmd.CommandText = "UPDATE tblLeadApplicant SET RepID = NULL, LastModified = '" & Format(Now, "MM/dd/yyyy") & "', LastModifiedByID = " & UserID & ", LeadAssignedToDate = '" & Format(Now, "MM/dd/yyyy") & "' WHERE LeadApplicantID = " & NewAssignments(i)
         Else
         cmd.CommandText = "UPDATE tblLeadApplicant SET RepID = " & RepID & ", LastModified = '" & Format(Now, "MM/dd/yyyy") & "', LastModifiedByID = " & UserID & ", LeadAssignedToDate = '" & Format(Now, "MM/dd/yyyy") & "' WHERE LeadApplicantID = " & NewAssignments(i)
         End If

         cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
         cmd.Connection.Open()
         cmd.ExecuteNonQuery()
         cmd.CommandText = ""
         cmd.Connection.Close()
      Next
      cmd = Nothing

   End Function

   Public Shared Function LogAssignments(ByVal OldAssignments() As OldAssignments, ByVal UserId As Integer, ByVal RepID As Integer) As Boolean
      Dim i As Integer
      Dim strSQL As string

      Try
         Using cnSQL As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
            cnSQL.Open()
            For i = 0 To OldAssignments.Length - 1
                    strSQL = ("INSERT INTO tblLeadAudit (" _
                          & "LeadApplicantID, " _
                          & "UserID, " _
                          & "ModificationDate, " _
                          & "LeadTable, " _
                          & "ModificationType, " _
                          & "LeadField, " _
                          & "PreviousValue, " _
                          & "NewValue) " _
                          & "VALUES (" _
                          & OldAssignments(i).LeadApplicantID & ", " _
                          & UserId & ", " _
                          & "'" & Now & "', " _
                          & "'tblLeadApplicant', " _
                          & "'Assign new Rep', " _
                          & "'RepID', " _
                          & "'" & OldAssignments(i).OldValue.ToString() & "', " _
                          & "'" & OldAssignments(i).NewValue.ToString()) & "')"
               Using cmd As New SqlCommand(strSQL, cnSQL)
                  cmd.ExecuteNonQuery()
               End Using
            Next i
            End Using
      Catch ex As SqlException
         Alert.Show("Unable to write to the Assignments Log. Error: " & ex.Message)
      End Try

   End Function

   Public Shared Function GetRepIDFromAppID(ByVal LeadAppID As Integer) As Integer
        Dim strSQL As String
        Dim dr As SqlDataReader

      Try
         Using cnSQL As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
            cnSQL.Open()
            strSQL = "SELECT RepID from tblLeadApplicant where LeadApplicantID = " & LeadAppID
            Using cmd As New SqlCommand(strSQL, cnSQL)
                    dr = cmd.ExecuteReader
                    If dr.HasRows Then
                        Do While dr.Read
                            If Not dr.Item(0) Is DBNull.Value Then
                                Return dr.Item(0)
                            Else
                                Return 1
                            End If
                        Loop
                    End If
                End Using
         End Using
      Catch ex As SqlException
         Alert.Show("Unable to get Law Firm Rep ID. Error: " & ex.Message)
         Return Nothing
      End Try

    End Function

    Public Shared Function GetLeadDeposits(ByVal LeadId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@LeadApplicantId", SqlDbType.Int)
        param.Value = LeadId
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_GetLeadDeposits", CommandType.StoredProcedure, params.ToArray)
    End Function

    'stp_enrollment_InsertDepositDay

    Public Shared Function InsertLeadDeposit(ByVal LeadId As Integer, ByVal DepositDay As Integer, ByVal DepositAmount As Decimal, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@LeadApplicantId", SqlDbType.Int)
        param.Value = LeadId
        params.Add(param)

        param = New SqlParameter("@DepositDay", SqlDbType.Int)
        param.Value = DepositDay
        params.Add(param)

        param = New SqlParameter("@DepositAmount", SqlDbType.Money)
        param.Value = DepositAmount
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Return SqlHelper.ExecuteScalar("stp_enrollment_InsertDepositDay", CommandType.StoredProcedure, params.ToArray)
    End Function

    'stp_enrollment_DeleteDepositDay
    Public Shared Sub DeleteLeadDeposit(ByVal LeadDepositId As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@LeadDepositId", SqlDbType.Int)
        param.Value = LeadDepositId
        params.Add(param)
        SqlHelper.ExecuteNonQuery("stp_enrollment_DeleteDepositDay", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Sub UpdateLeadDeposit(ByVal LeadDepositId As Integer, ByVal DepositDay As Nullable(Of Integer), ByVal DepositAmount As Nullable(Of Decimal), ByVal UserId As Integer)
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@LeadDepositId", SqlDbType.Int)
        param.Value = LeadDepositId
        params.Add(param)

        If DepositDay.HasValue Then
            param = New SqlParameter("@DepositDay", SqlDbType.Int)
            param.Value = DepositDay.Value
            params.Add(param)
        End If

        If DepositAmount.HasValue Then
            param = New SqlParameter("@DepositAmount", SqlDbType.Money)
            param.Value = DepositAmount.Value
            params.Add(param)
        End If

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_enrollment_UpdateDepositDay", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Sub SendVerificationEmail(ByVal LeadApplicantID As Integer, ByVal TemplatePath As String, ByVal LeadName As String, ByVal Email As String, ByVal CompanyID As Integer, ByVal Company As String, ByVal SentBy As Integer)
        Dim cmdText As String = String.Format("select co.website from tblleadapplicant la join tblCompany co on co.companyid = la.companyid where leadapplicantid = {0}", LeadApplicantID)
        Dim sr As IO.StreamReader
        Dim template As String
        Dim tempPwd As String = GenerateEasyPassword()
        Dim subject As String
        Dim clientPortalUrl As String
        Dim from As String
        Dim webSite As String
        Dim emailID As Integer

        sr = IO.File.OpenText(TemplatePath)
        template = sr.ReadToEnd
        sr.Close()
        sr.Dispose()

        webSite = CStr(SqlHelper.ExecuteScalar(cmdText, CommandType.Text))
        clientPortalUrl = String.Format("http://{0}/lexxcms/portals/login.aspx", webSite)

        template = template.Replace("{{clientname}}", LeadName)
        template = template.Replace("{{company}}", Company)
        template = template.Replace("{{url}}", clientPortalUrl)
        template = template.Replace("{{username}}", Email)
        template = template.Replace("{{password}}", tempPwd)

        subject = String.Format("Verification Request From {0} (File #{1})", Company, LeadApplicantID)
        from = String.Format("{0} <noreply@{1}>", Company, webSite.Replace("www.", ""))

        AddLexxCMSUser(Email, tempPwd, CompanyID, LeadApplicantID)

        emailID = InsertLeadEmail(LeadApplicantID, Email, "Verification", subject, template, SentBy)
        template &= String.Format("<img src='http://www.lexpros.com/images/{0}.aspx'/>", emailID) 'add read receipt

        EmailHelper.SendMessage(from, Email, subject, template)
    End Sub

    Public Shared Function InsertLeadEmail(ByVal LeadApplicantID As Integer, ByVal Email As String, ByVal Type As String, ByVal Subject As String, ByVal Body As String, ByVal SentBy As Integer) As Integer
        Dim cmdText As String = String.Format("insert tblleademails (leadapplicantid,email,type,subject,body,sentby) values ({0},'{1}','{2}','{3}','{4}',{5}); select scope_identity();", LeadApplicantID, Email, Type, Subject, Body.Replace("'", "''"), SentBy)
        Return CInt(SqlHelper.ExecuteScalar(cmdText, CommandType.Text))
    End Function

    Private Shared Function GenerateStrongPassword(ByVal PasswordLength As Integer) As String
        Dim PWD_ALLOWED_CHARS As String = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ0123456789"
        Dim encoder As New System.Text.ASCIIEncoding
        Dim abytAllowedChars() As Byte = encoder.GetBytes(PWD_ALLOWED_CHARS)

        ' Use the RNGCryptoServiceProvider to get a
        ' crytographically strong set of random bytes.
        Dim abytRand(PasswordLength) As Byte
        Dim rng As RNGCryptoServiceProvider = New RNGCryptoServiceProvider
        rng.GetBytes(abytRand)

        ' Calculate the number of allowed characters.
        Dim intChars As Integer = abytAllowedChars.Length

        ' Build password.
        Dim abytOutput(PasswordLength) As Byte
        For intLoop As Integer = 0 To PasswordLength - 1
            abytOutput(intLoop) = abytAllowedChars(abytRand(intLoop) Mod intChars)
        Next
        Return encoder.GetString(abytOutput, 0, abytOutput.Length - 1)
    End Function

    Private Shared Function GenerateEasyPassword() As String
        Return CStr(SqlHelper.ExecuteScalar("select top 1 word from tblwords order by newid()", CommandType.Text))
    End Function

    Private Shared Sub AddLexxCMSUser(ByVal Username As String, ByVal Password As String, ByVal CompanyID As Integer, ByVal LeadApplicantID As Integer, Optional ByVal bLocked As Boolean = False, Optional ByVal bTempPwd As Boolean = True)
        Dim CMSConnStr As String = ConfigurationManager.ConnectionStrings("CMSConnStr").ConnectionString
        Dim sqlCMSInsert As New StringBuilder
        sqlCMSInsert.AppendFormat("delete from tblUsers where leadapplicantid = {0}; ", LeadApplicantID)
        sqlCMSInsert.Append("INSERT INTO [tblUsers] ([Username],[UserTypeID],[UserPassword],[CompanyID],[Created],[LastModified],[LastLogin],[NumLogins],[ClientID],[LeadApplicantID],[Locked],[Temporary]) ")
        sqlCMSInsert.AppendFormat("VALUES('{0}',3,'{1}',{2},getdate(),getdate(),null,0,null,{3},{4},{5});", Username, Password, CompanyID, LeadApplicantID, IIf(bLocked, 1, 0), IIf(bTempPwd, 1, 0))
        SharedFunctions.AsyncDB.executeScalar(sqlCMSInsert.ToString, CMSConnStr)
    End Sub

    Public Shared Function VerificationComplete(ByVal LeadApplicantID As Integer) As Boolean
        Dim index As Integer = CInt(SqlHelper.ExecuteScalar("select isnull(max(stepindex),0) from tblleadverificationsheet where leadapplicantid = " & LeadApplicantID, CommandType.Text))
        Return (index = 3)
    End Function

End Class
