Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class CancellationRptHelper

   Public Overloads Shared Function getReportDataSet(ByVal strSQL As String, ByVal TableName As String) As Data.DataSet
      Dim dsTemp As Data.DataSet

      Try
         Using cnSQL As New SqlConnection("server=Lexsrvsqlprod1\lexsrvsqlprod;uid=dms_sql2;pwd=j@ckp0t!;database=dms;connect timeout=60;max pool size = 150")
            Dim adapter As New SqlDataAdapter()
            adapter.SelectCommand = New SqlCommand(strSQL, cnSQL)
            adapter.SelectCommand.CommandTimeout = 180
            dsTemp = New Data.DataSet
            adapter.Fill(dsTemp)
            dsTemp.Tables(0).TableName = TableName
         End Using
         Return dsTemp
      Catch ex As SqlException
         Alert.Show("This report has timmed out. Please wait a few minutes and run the report again.")
         Return Nothing
      End Try

   End Function

   Public Shared Function CreateCancelledTSQL(ByVal StartDate As String, ByVal EndDate As String) As String
		Dim strSQL As String = ""

		strSQL = "DECLARE @Clients table ("
		strSQL += " ClientID Int)"

		strSQL += " INSERT INTO @Clients"
		strSQL += " Select distinct(c.clientid)"
		strSQL += " FROM tblClient c"
		strSQL += " INNER JOIN tblroadmap rm ON rm.clientid = c.clientid AND rm.clientstatusid = 17"
		strSQL += " WHERE rm.created BETWEEN '" & StartDate & "' AND '" & EndDate & "'"

		strSQL += " SELECT convert(nvarchar(10), rm.created, 101) [Date Cancelled],"
		strSQL += " c.AccountNumber [Account Number],"
		strSQL += " p.FirstName + ' ' + p.LastName [Client Name],"
		strSQL += " a.[Name] [Agent.Name],"
		strSQL += " co.ShortCoName [Attorney],"
		strSQL += " (select pt.name + ': (' + convert(varchar,isnull(areacode,'')) + ')' +  convert(varchar, case when not number is null then right(number,3) + '-' + left(number,4) else '' end ) + case when extension is null then '' else 'Ext: ' +convert(varchar,extension) end + ','"
		strSQL += " from tblPersonPhone pp inner join tblphone p on pp.phoneid = p.phoneid inner join tblPhoneType pt on pt.phonetypeid = p.phonetypeid"
		strSQL += " where pp.personid = c.primarypersonid FOR XML PATH('') )[ContactInfo]"
		strSQL += " FROM tblclient c"
		strSQL += " INNER JOIN tblroadmap rm ON rm.clientid = c.clientid AND rm.clientstatusid = 17"
		strSQL += " INNER JOIN tblcompany co ON co.companyid = c.companyid"
		strSQL += " INNER JOIN tblperson p ON p.clientid = c.clientid AND p.relationship = 'Prime'"
		strSQL += " INNER JOIN tblAgency a ON a.AgencyID = c.AgencyID"
		strSQL += " WHERE c.currentclientstatusid = 17"
        strSQL += " AND c.clientid IN (SELECT clientid FROM @Clients)"
        strSQL += " AND rm.created BETWEEN '" & StartDate & "' AND '" & EndDate & "'"
		strSQL += " ORDER BY convert(nvarchar(10), rm.created, 101), co.shortconame"

		Return strSQL
   End Function

   Public Shared Function SmartDebtorCancellations(ByVal StartDate As String, ByVal EndDate As String) As String
		Dim strSQL As String

		strSQL = "DECLARE @Clients table ("
		strSQL += " ClientID Int,"
		strSQL += " Created nvarchar(10)) "

		strSQL += " INSERT INTO @Clients"
		strSQL += " Select distinct(c.clientid), convert(nvarchar(10), rm.created, 101)"
		strSQL += " FROM tblClient c"
		strSQL += " INNER JOIN tblroadmap rm ON rm.clientid = c.clientid AND rm.clientstatusid = 17"
		strSQL += " WHERE rm.created BETWEEN '" & StartDate & "' AND '" & EndDate & "'"
		strSQL += " AND c.AgencyID = 856"

		strSQL += " SELECT"
		strSQL += " (SELECT TOP 1 Created FROM @Clients WHERE ClientID = c.ClientID) [Date Cancelled],"
		strSQL += " c.AccountNumber [Account Number],"
		strSQL += " p.FirstName + ' ' + p.LastName [Client Name],"
		strSQL += " u2.firstname + ' ' + u2.lastname [Agent Name],"
		strSQL += " u1.FirstName + ' ' + u1.LastName [Law Firm Rep.],"
		strSQL += " CASE WHEN (SELECT TOP 1 Amount FROM tblRegister WHERE ClientID = c.ClientID AND EntryTypeID = 3 AND Bounce IS NULL"
		strSQL += " AND InitialDraftYN = 1 ORDER BY TransactionDate) IS NOT NULL THEN 'YES' ELSE 'NO' END [Initial Deposit Completed],"
		strSQL += " ls.source [Lead Source],"
		strSQL += " co.ShortCoName [Attorney],"
		strSQL += " (select pt.name + ': (' + convert(varchar,isnull(areacode,'')) + ')' +  convert(varchar, case when not number is null then right(number,3) + '-' + left(number,4) else '' end ) + case when extension is null then '' else 'Ext: ' +convert(varchar,extension) end + ','"
		strSQL += " from tblPersonPhone pp inner join tblphone p on pp.phoneid = p.phoneid inner join tblPhoneType pt on pt.phonetypeid = p.phonetypeid"
		strSQL += " where pp.personid = c.primarypersonid FOR XML PATH('') )[ContactInfo]"
		strSQL += " FROM tblclient c"
		strSQL += " INNER JOIN tblroadmap rm ON rm.clientid = c.clientid AND rm.clientstatusid = 17"
		strSQL += " INNER JOIN tblcompany co ON co.companyid = c.companyid"
		strSQL += " INNER JOIN tblperson p ON p.clientid = c.clientid AND p.relationship = 'Prime'"
		strSQL += " INNER JOIN tblAgency ag ON ag.AgencyID = c.AgencyID"
        strSQL += " LEFT JOIN tblImportedClient ic ON ic.importid = c.ServiceImportID"
		strSQL += " INNER JOIN tblLeadApplicant la ON la.LeadApplicantID = ic.ExternalClientId"
		strSQL += " INNER JOIN tblUser u1 ON u1.UserID = la.RepID"
		strSQL += " INNER JOIN tblUser u2 ON u2.UserID = la.CreatedByID"
        strSQL += " LEFT JOIN tblLeadSource ls on ls.LeadSourceID = la.LeadSourceID"
        strSQL += " WHERE c.ClientID IN (SELECT ClientID FROM @Clients)"

		Return strSQL

    End Function

    Public Shared Function RollingCancellations24(ByVal AgencyID As Integer, Optional ByVal MonthCreated As Integer = 12, Optional ByVal YearCreated As Integer = 2009, Optional ByVal RepID As Integer = 0, Optional ByVal SourceID As Integer = 0, Optional ByVal MarketID As Integer = 0) As String
        'Returns SQL statement
        Dim strSQL As String = ""

        If AgencyID = 0 Then
            AgencyID = 856
        End If

        strSQL += "DECLARE @sSQL VARCHAR(max) "
        strSQL += "DECLARE @pstart DATETIME "
        strSQL += "DECLARE @pend DATETIME "
        strSQL += "DECLARE @AgencyID INT "

        strSQL += "SET @AgencyID = " & AgencyID

        strSQL += " SELECT "
        strSQL += "a.ImportAbbr "
        strSQL += ",CONVERT(VARCHAR,c.accountnumber) [Acct#] "
        strSQL += ",CONVERT(VARCHAR,c.created,110) [Created] "
        strSQL += ",s.name [Status] "
        strSQL += ",Retention = isnull(datediff(day,c.created,(select top(1) rm.created from tblroadmap rm where clientstatusid in (17) and rm.clientid = c.clientid order by roadmapid desc)),'') "
        strSQL += "INTO #cr "
        strSQL += "FROM tblclient c "
        strSQL += "INNER JOIN tblClientStatus s ON c.currentclientstatusid = s.clientstatusid "
        strSQL += "INNER JOIN tblagency a ON c.agencyid = a.agencyid "
        strSQL += "INNER JOIN tblimportedclient ic ON ic.importid = c.serviceimportid "
        strSQL += "INNER JOIN tblleadapplicant la ON la.leadapplicantid = ic.externalclientid "
        strSQL += "LEFT JOIN tblUser u ON u.userID = la.repid "
        strSQL += "LEFT JOIN tblLeadSource ls ON ls.leadsourceid = la.leadsourceid "
        strSQL += "LEFT JOIN tblLeadMarket lm ON lm.leadmarketid = ls.leadmarketid "
        strSQL += "WHERE c.created >= DATEADD(yy,-2,GETDATE()) "
        strSQL += "AND c.accountnumber IS NOT NULL "
        strSQL += "AND a.agencyid = @AgencyID "
        If RepID > 0 Then
            strSQL += "AND la.repid = '" & CStr(RepID) & "' "
        End If
        If SourceID > 0 Then
            strSQL += "AND ls.leadsourceid = '" & CStr(SourceID) & "' "
        End If
        If MarketID > 0 Then
            strSQL += "AND lm.leadmarketid = '" & CStr(MarketID) & "' "
        End If
        strSQL += "ORDER BY c.created "

        strSQL += "DECLARE @Months INT "
        strSQL += "DECLARE @LastNumber INT "
        strSQL += "DECLARE @TotalClients INT "

        strSQL += "SELECT @TotalClients = COUNT(*) FROM #cr "

        strSQL += "SET @Months = 1 "
        strSQL += "SET @LastNumber = 0 "

        strSQL += "SET @sSQL = 'SELECT ''Cancelled''[Status],[TotalClients] = ' + CAST(@totalclients AS VARCHAR) + CHAR(13) "
        strSQL += "WHILE @Months <= 12 "
        strSQL += "BEGIN "
        strSQL += "SET @sSQL = @sSQL + ',[Month ' + CAST(@Months AS VARCHAR) + ']' "
        strSQL += "SET @sSQL = @sSQL + ' = (SELECT COUNT(*) FROM #cr WHERE retention > ' + CAST(@LastNumber AS VARCHAR) "
        strSQL += "SET @sSQL = @sSQL + ' AND retention <=' + CAST(@months*30 AS VARCHAR) + ')' + CHAR(13) "
        strSQL += "SET @LastNumber = @months*30 "
        strSQL += "SET @Months = @Months + 1 "
        strSQL += "END "

        strSQL += "SET @sSQL = @sSQL + ' UNION ALL '	+ CHAR(13) "

        strSQL += "SET @Months = 1 "
        strSQL += "SET @sSQL = @sSQL +'SELECT ''Remaining''[Status]' "
        strSQL += "SET @sSQL = @sSQL + ', ' + CAST(@totalclients AS VARCHAR)+ ' [TotalClients]' "
        strSQL += "SET @LastNumber = 0 "

        strSQL += "WHILE @Months <= 12 "
        strSQL += "BEGIN "
        strSQL += "DECLARE @remaining INT "

        strSQL += "SELECT @remaining  = @totalclients -(SELECT COUNT(*) FROM #cr WHERE retention > @LastNumber  AND retention <=@months*30 ) "

        strSQL += "SET @sSQL = @sSQL + ', ' + CAST(@remaining AS VARCHAR) +' [Month ' + CAST(@Months AS VARCHAR) + ']' + CHAR(13) "

        strSQL += "SET @totalclients = @remaining "
        strSQL += "SET @LastNumber = @months*30 "
        strSQL += "SET @months = @Months + 1 "
        strSQL += "END "

        strSQL += "EXEC(@sSQL) "

        strSQL += "DROP TABLE #cr "

        Return strSQL
    End Function

    Public Shared Function RollingCancellationsByCreated(ByVal AgencyID As Integer, Optional ByVal MonthCreated As Integer = 12, Optional ByVal YearCreated As Integer = 2009, Optional ByVal RepID As Integer = 0, Optional ByVal SourceID As Integer = 0, Optional ByVal MarketID As Integer = 0) As String
        'Returns SQL statement
        Dim strSQL As String = ""

        If AgencyID = 0 Then
            AgencyID = 856
        End If

        strSQL += "DECLARE @sSQL VARCHAR(max) "
        strSQL += "DECLARE @pstart DATETIME "
        strSQL += "DECLARE @pend DATETIME "
        strSQL += "DECLARE @YearCreated INT "
        strSQL += "DECLARE @MonthCreated INT "
        strSQL += "DECLARE @AgencyID INT "

        strSQL += "SET @YearCreated = " & YearCreated
        strSQL += " SET @MonthCreated = " & MonthCreated
        strSQL += " SET @AgencyID = " & AgencyID

        strSQL += " SELECT @pstart = CAST(CAST(@YearCreated AS VARCHAR) + '-' + CAST(@MonthCreated AS VARCHAR) + '-01' AS DATETIME)"
        strSQL += " SELECT @pend = CAST(CAST(@YearCreated AS VARCHAR) + '-' + CAST(@MonthCreated AS VARCHAR) + '-' + CAST(day(DATEADD(d,-1,DATEADD(m,1,@pstart))) AS VARCHAR) AS DATETIME)"

        strSQL += " SELECT "
        strSQL += "a.ImportAbbr "
        strSQL += ",CONVERT(VARCHAR,c.accountnumber) [Acct#] "
        strSQL += ",CONVERT(VARCHAR,c.created,110) [Created] "
        strSQL += ",s.name [Status] "
        strSQL += ",Retention = isnull(datediff(day,c.created,(select top(1) rm.created from tblroadmap rm where clientstatusid in (17) and rm.clientid = c.clientid order by roadmapid desc)),'') "
        strSQL += "INTO #cr "
        strSQL += "FROM tblclient c "
        strSQL += "INNER JOIN tblClientStatus s ON c.currentclientstatusid = s.clientstatusid "
        strSQL += "INNER JOIN tblagency a ON c.agencyid = a.agencyid "
        strSQL += "INNER JOIN tblimportedclient ic ON ic.importid = c.serviceimportid "
        strSQL += "INNER JOIN tblleadapplicant la ON la.leadapplicantid = ic.externalclientid "
        strSQL += "LEFT JOIN tblUser u ON u.userID = la.repid "
        strSQL += "LEFT JOIN tblLeadSource ls ON ls.leadsourceid = la.leadsourceid "
        strSQL += "LEFT JOIN tblLeadMarket lm ON lm.leadmarketid = ls.leadmarketid "
        strSQL += "WHERE c.created >= @pstart "
        strSQL += "AND c.created < @pend "
        strSQL += "AND c.accountnumber IS NOT NULL "
        strSQL += "AND a.agencyid = @AgencyID "
        If RepID > 0 Then
            strSQL += "AND la.repid = '" & CStr(RepID) & "' "
        End If
        If SourceID > 0 Then
            strSQL += "AND ls.leadsourceid = '" & CStr(SourceID) & "' "
        End If
        If MarketID > 0 Then
            strSQL += "AND lm.leadmarketid = '" & CStr(MarketID) & "' "
        End If
        strSQL += "ORDER BY c.created "

        strSQL += "DECLARE @Months INT "
        strSQL += "DECLARE @LastNumber INT "
        strSQL += "DECLARE @TotalClients INT "

        strSQL += "SELECT @TotalClients = COUNT(*) FROM #cr "

        strSQL += "SET @Months = 1 "
        strSQL += "SET @LastNumber = 0 "

        strSQL += "SET @sSQL = 'SELECT ''Cancelled''[Status],[TotalClients] = ' + CAST(@totalclients AS VARCHAR) + CHAR(13) "
        strSQL += "WHILE @Months <= DATEDIFF(m,@pstart,GETDATE()) "
        strSQL += "BEGIN "
        strSQL += "SET @sSQL = @sSQL + ',[Month ' + CAST(@Months AS VARCHAR) + ']' "
        strSQL += "SET @sSQL = @sSQL + ' = (SELECT COUNT(*) FROM #cr WHERE retention > ' + CAST(@LastNumber AS VARCHAR) "
        strSQL += "SET @sSQL = @sSQL + ' AND retention <=' + CAST(@months*30 AS VARCHAR) + ')' + CHAR(13) "
        strSQL += "SET @LastNumber = @months*30 "
        strSQL += "SET @Months = @Months + 1 "
        strSQL += "END "

        strSQL += "SET @sSQL = @sSQL + ' UNION ALL '	+ CHAR(13) "

        strSQL += "SET @Months = 1 "
        strSQL += "SET @sSQL = @sSQL +'SELECT ''Remaining''[Status]' "
        strSQL += "SET @sSQL = @sSQL + ', ' + CAST(@totalclients AS VARCHAR)+ ' [TotalClients]' "
        strSQL += "SET @LastNumber = 0 "

        strSQL += "WHILE @Months <= DATEDIFF(m,@pstart,GETDATE()) "
        strSQL += "BEGIN "
        strSQL += "DECLARE @remaining INT "

        strSQL += "SELECT @remaining  = @totalclients -(SELECT COUNT(*) FROM #cr WHERE retention > @LastNumber  AND retention <=@months*30 ) "

        strSQL += "SET @sSQL = @sSQL + ', ' + CAST(@remaining AS VARCHAR) +' [Month ' + CAST(@Months AS VARCHAR) + ']' + CHAR(13) "

        strSQL += "SET @totalclients = @remaining "
        strSQL += "SET @LastNumber = @months*30 "
        strSQL += "SET @months = @Months + 1 "
        strSQL += "END "

        strSQL += "EXEC(@sSQL) "

        strSQL += "DROP TABLE #cr "


        Return strSQL
    End Function

    Public Shared Function ClientMinMaxCreated(ByVal AgencyID As Integer, Optional ByVal MonthCreated As Integer = 12, Optional ByVal YearCreated As Integer = 2009, Optional ByVal RepID As Integer = 0, Optional ByVal SourceID As Integer = 0, Optional ByVal MarketID As Integer = 0) As String
        Dim strSQL As String = ""

        strSQL += "select min(year(c.created)) [min], max(year(c.created)) [max] "
        strSQL += "from tblclient c "
        strSQL += "INNER JOIN tblimportedclient ic ON ic.importid = c.serviceimportid "
        strSQL += "INNER JOIN tblleadapplicant la ON la.leadapplicantid = ic.externalclientid "
        strSQL += "LEFT JOIN tblUser u ON u.userID = la.repid "
        strSQL += " LEFT JOIN tblLeadSource ls ON ls.leadsourceid = la.leadsourceid "
        strSQL += "LEFT JOIN tblLeadMarket lm ON lm.leadmarketid = ls.leadmarketid "
        strSQL += "WHERE c.agencyid = " & AgencyID
        If RepID > 0 Then
            strSQL += " AND la.repid = '" & CStr(RepID) & "'"
        End If
        If SourceID > 0 Then
            strSQL += " AND ls.leadsourceid = '" & CStr(SourceID) & "'"
        End If
        If MarketID > 0 Then
            strSQL += " AND lm.leadmarketid = '" & CStr(MarketID) & "'"
        End If
        Return strSQL
    End Function

End Class
