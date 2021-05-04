Imports System
Imports System.Data
Imports Drg.Util.DataAccess
Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Collections.Generic

Public Class LeadProcessorHelper

#Region "Structure OldProcessorAssignments"

    Public Structure OldProcessorAssignments

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

    Public Shared Function GetProcessorSQL() As String

        Dim strSQL As String = "exec stp_GetAssignLeads"
        Return strSQL
    End Function

    Public Shared Function GetProcessor1SQL() As String

        ' Get the Law Firm Rep names call
        Dim strSQL As String = ""

        strSQL += "DECLARE @Processor TABLE "
        strSQL += "(UserID int, "
        strSQL += "Processor nvarchar(200)) "
        strSQL += "INSERT INTO @Processor "
        strSQL += "SELECT 0, 'Please Select....' "
        strSQL += "INSERT INTO @Processor "
        strSQL += "SELECT 1, 'Return to Leadpool' "
        strSQL += "INSERT INTO @Processor "
        strSQL += "SELECT "
        strSQL += "UserID, "
        strSQL += "FirstName + ' ' + LastName [Processor]"
        strSQL += "FROM tblUser "
        strSQL += "WHERE "
        strSQL += "UserGroupID = 28 "
        strSQL += "ORDER BY LastName "
        strSQL += "SELECT * FROM @Processor"

        Return strSQL

    End Function

    Public Shared Function GetProcessor2SQL() As String

        ' Get the Law Firm Rep names call
        Dim strSQL As String = ""

        strSQL += "DECLARE @Processor TABLE "
        strSQL += "(UserID int, "
        strSQL += "Processor nvarchar(200)) "
        strSQL += "INSERT INTO @Processor "
        strSQL += "SELECT 0, '-- All --' "
        strSQL += "INSERT INTO @Processor "
        strSQL += "SELECT 1, '**Unassigned**' "
        strSQL += "INSERT INTO @Processor "
        strSQL += "SELECT "
        strSQL += "UserID, "
        strSQL += "FirstName + ' ' + LastName [Processor] "
        strSQL += "FROM tblUser "
        strSQL += "WHERE "
        strSQL += "UserGroupID = 28 "
        strSQL += "ORDER BY LastName "
        strSQL += "SELECT * FROM @Processor"

        Return strSQL

    End Function

    Public Shared Function GetProcessors1SQL() As String

        ' Get the Law Firm Rep names call
        Dim strSQL As String = ""

        strSQL += "DECLARE @Processors TABLE "
        strSQL += "(UserID int, "
        strSQL += "Processor nvarchar(200)) "
        strSQL += "INSERT INTO @Processors "
        strSQL += "SELECT 0, 'Please Select....' "
        strSQL += "INSERT INTO @Processors "
        strSQL += "SELECT 1, 'Return to Leadpool' "
        strSQL += "INSERT INTO @Processors "
        strSQL += "SELECT "
        strSQL += "UserID, "
        strSQL += "FirstName + ' ' + LastName [Processor]"
        strSQL += "FROM tblUser "
        strSQL += "WHERE "
        strSQL += "UserGroupID = 28 "
        strSQL += "ORDER BY LastName "
        strSQL += "SELECT * FROM @Processors"

        Return strSQL

    End Function

    Public Shared Function GetProcessors2SQL() As String

        ' Get the Law Firm Rep names call
        Dim strSQL As String = ""

        strSQL += "DECLARE @Processors TABLE "
        strSQL += "(UserID int, "
        strSQL += "Processor nvarchar(200)) "
        strSQL += "INSERT INTO @Processors "
        strSQL += "SELECT 0, '-- All --' "
        strSQL += "INSERT INTO @Processors "
        strSQL += "SELECT 1, '**Unassigned**' "
        strSQL += "INSERT INTO @Processors "
        strSQL += "SELECT "
        strSQL += "UserID, "
        strSQL += "FirstName + ' ' + LastName [Processor] "
        strSQL += "FROM tblUser "
        strSQL += "WHERE "
        strSQL += "UserGroupID = 28 "
        strSQL += "ORDER BY LastName "
        strSQL += "SELECT * FROM @Processors"

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

    Public Shared Function BuildReportSQL(ByVal ApplicantID As Integer, ByVal StateID As Integer, ByVal StatusID As Integer, ByVal ProcessorID As Integer, ByVal Aging As String, ByVal Flags As Boolean) As String

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
            If ProcessorID > 0 Then
                If Len(WhereClause) = 0 Then
                    WhereClause += "AND la.Processor "
                Else
                    WhereClause += " AND la.Processor "
                End If
                If ProcessorID = 1 Then
                    WhereClause += "< 1"
                Else
                    WhereClause += "= " & ProcessorID
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
        strSQL += "LEFT JOIN tblUser AS u ON u.UserID = la.Processor "
        strSQL += "WHERE (len(la.firstname) > 0 or len(la.lastname) > 0) " & WhereClause

        Return strSQL

    End Function

    Public Shared Function ReAssignLeads(ByVal NewAssignments() As Integer, ByVal UserID As Integer, ByVal ProcessorID As Integer) As Boolean

        ' Update the leads to the newy assigned Law Firm Rep.
        Dim i As Integer

        Dim cmd As New Data.SqlClient.SqlCommand()

        For i = 0 To NewAssignments.Length - 1
            cmd.CommandType = Data.CommandType.Text
            If ProcessorID = 1 Then
                cmd.CommandText = "UPDATE tblLeadApplicant SET Processor = NULL, LastModified = '" & Format(Now, "MM/dd/yyyy") & "', LastModifiedByID = " & UserID & ", LeadAssignedToDate = '" & Format(Now, "MM/dd/yyyy") & "' WHERE LeadApplicantID = " & NewAssignments(i)
            Else
                cmd.CommandText = "UPDATE tblLeadApplicant SET Processor = " & ProcessorID & ", LastModified = '" & Format(Now, "MM/dd/yyyy") & "', LastModifiedByID = " & UserID & ", LeadAssignedToDate = '" & Format(Now, "MM/dd/yyyy") & "' WHERE LeadApplicantID = " & NewAssignments(i)
            End If

            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            cmd.CommandText = ""
            cmd.Connection.Close()
        Next
        cmd = Nothing

    End Function

    Public Shared Function LogProcessorAssignments(ByVal OldAssignments() As OldProcessorAssignments, ByVal UserId As Integer, ByVal RepID As Integer) As Boolean
        Dim i As Integer
        Dim strSQL As String

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
                          & "'Assign Processor', " _
                          & "'Processor', " _
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

        'Try
        '    Using cnSQL As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
        '        cnSQL.Open()
        '        For i = 0 To OldAssignments.Length - 1
        '            strSQL = "INSERT INTO tblLeadStatusRoadmap (" _
        '                  & "LeadApplicantID, " _
        '                  & "LeadStatusID, " _
        '                  & "Reason, " _
        '                  & "Created, " _
        '                  & "CreatedBy, " _
        '                  & "LastModified, " _
        '                  & "LastModifiedBy) " _
        '                  & "VALUES (" _
        '                  & OldAssignments(i).LeadApplicantID & ", " _
        '                  & "10 , " _
        '                  & "'In Process', " _
        '                  & "'" & Now & "', " _
        '                  & UserId & ", " _
        '                  & "'" & Now & "', " _
        '                  & UserId & ")"
        '            Using cmd As New SqlCommand(strSQL, cnSQL)
        '            cmd.ExecuteNonQuery()
        '            End Using
        '        Next i
        '    End Using
        'Catch ex As SqlException
        '    Alert.Show("Unable to write to the Assignments Log. Error: " & ex.Message)
        'End Try

    End Function

    Public Shared Function GetProcessorFromAppID(ByVal LeadAppID As Integer) As Integer
        Dim strSQL As String

        Try
            Using cnSQL As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
                cnSQL.Open()
                strSQL = "SELECT Processor from tblLeadApplicant where LeadApplicantID = " & LeadAppID
                Using cmd As New SqlCommand(strSQL, cnSQL)
                    Return cmd.ExecuteScalar
                End Using
            End Using
        Catch ex As SqlException
            Alert.Show("Unable to get Processor ID. Error: " & ex.Message)
            Return Nothing
        End Try

    End Function

End Class
