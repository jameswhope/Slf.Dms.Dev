Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class RefundHelper

   Public Shared Function getClientDeposits(ByVal AccountNumber As Integer) As Double

      Dim cnSQL As SqlConnection = New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
      Dim strSQL As String = ""
      Dim dr As SqlDataReader
      Dim Amount As Double

      If AccountNumber > 0 Then
         strSQL = "SELECT SUM(r.amount) FROM tblRegister r " _
         & "INNER JOIN tblClient c ON c.clientid = r.clientid " _
         & "WHERE r.entrytypeid = 3 " _
         & "AND r.bounce IS NULL " _
         & "AND c.AccountNumber = " & AccountNumber
         Using cmd As New SqlCommand(strSQL, cnSQL)
            cmd.Connection.Open()
            dr = cmd.ExecuteReader
            Do While dr.Read
               If Not dr.Item(0) Is DBNull.Value Then
                  Amount = dr.Item(0)
               End If
            Loop
            cmd.Connection.Close()
         End Using
      End If
      Return Amount
   End Function

   Public Shared Function getClientPayments(ByVal AccountNumber As Integer) As Double

      Dim cnSQL As SqlConnection = New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
      Dim strSQL As String = ""
      Dim dr As SqlDataReader
      Dim Amount As Double

      If AccountNumber > 0 Then
         strSQL = "SELECT SUM(rp.amount) FROM tblRegisterPayment rp " _
         & "INNER JOIN tblRegister r ON r.registerID = rp.FeeRegisterID " _
         & "INNER JOIN tblClient c ON c.clientid = r.clientid " _
         & "WHERE r.entrytypeid NOT IN (3, 21) " _
         & "AND rp.amount IS NOT NULL " _
         & "AND c.AccountNumber = " & AccountNumber
         Using cmd As New SqlCommand(strSQL, cnSQL)
            cmd.Connection.Open()
            dr = cmd.ExecuteReader
            Do While dr.Read
               If Not dr.Item(0) Is DBNull.Value Then
                  Amount = dr.Item(0)
               End If
            Loop
            cmd.Connection.Close()
         End Using
      End If
      Return Amount
   End Function

   Public Shared Function addFieldsToPrimary(ByVal ds As DataSet) As DataSet

      Dim dsTemp As DataSet = ds

      'Add the new Fields to the table in the primary dataset
      Dim dcRFP As DataColumn = New DataColumn("RetainerFeesPaid", System.Type.GetType("System.Double"))
      dsTemp.Tables("Demographics").Columns.Add(dcRFP)
      Dim dcMFP As DataColumn = New DataColumn("MaintenanceFeesPaid", System.Type.GetType("System.Double"))
      dsTemp.Tables("Demographics").Columns.Add(dcMFP)
      Dim dcSFP As DataColumn = New DataColumn("SettlementFeesPaid", System.Type.GetType("System.Double"))
      dsTemp.Tables("Demographics").Columns.Add(dcSFP)
      Dim dcTPR As DataColumn = New DataColumn("TotalPotentalRefund", System.Type.GetType("System.Double"))
      dsTemp.Tables("Demographics").Columns.Add(dcTPR)
      Dim dcRA As DataColumn = New DataColumn("RefundAmt", System.Type.GetType("System.Double"))
      dsTemp.Tables("Demographics").Columns.Add(dcRA)
      Dim dcPB As DataColumn = New DataColumn("PosBal", System.Type.GetType("System.Double"))
      dsTemp.Tables("Demographics").Columns.Add(dcPB)

      Return dsTemp

   End Function

   Public Overloads Shared Function getReportDataSet(ByVal strSQL As String, ByVal TableName As String) As Data.DataSet
      Dim dsTemp As Data.DataSet

      Try
         Using cnSQL As New SqlConnection("server=Lexsrvsqlprod1\lexsrvsqlprod;uid=dms_sql2;pwd=j@ckp0t!;database=dms;connect timeout=60;max pool size = 150")
            'Using cnSQL As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString())
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

   Public Overloads Shared Function UpdateToFinalDataSet(ByVal dsPrimary As DataSet, ByVal dsTrans As DataSet) As DataSet

      Dim AccountNumber As Integer
      Dim Deposits As Double 'Deposits
      Dim PaidOut As Double 'Payments
      Dim NewPosBalance As Double 'SDA Balance
      Dim OldPosBalance As Double 'What appears as current positive balance
      Dim RefundAmount As Double 'Refund amount
      Dim SettlementFeesPaid As Double 'Settlement Fees Paid
      Dim MaintenanceFeesPaid As Double 'Maintenance Fees Paid
      Dim RetainerFeesPaid As Double 'RetainerFeesPaid
      Dim TotalPotentalRefund As Double 'Potental refund amount
      Dim dr As DataRow
      Dim drTrans As DataRow

      For Each dr In dsPrimary.Tables("Demographics").Rows
         'First get an account number to work with
         AccountNumber = IIf(Not dr.Item("Account Number") Is DBNull.Value, dr.Item("Account Number"), 0)
         If AccountNumber > 0 Then
            Deposits = getClientDeposits(AccountNumber)
            PaidOut = getClientPayments(AccountNumber)
            NewPosBalance = Deposits - PaidOut
            'seed the variables from the transaction table
            For Each drTrans In dsTrans.Tables("Transactions").Rows
               If drTrans.Item("Account Number") = AccountNumber Then
                  RefundAmount = IIf(Not drTrans.Item("Refund Amount") Is DBNull.Value, drTrans.Item("Refund Amount"), 0)
                  SettlementFeesPaid = IIf(Not drTrans.Item("Settlement Fees Paid") Is DBNull.Value, drTrans.Item("Settlement Fees Paid"), 0)
                  MaintenanceFeesPaid = IIf(Not drTrans.Item("Maintenance Fees Paid") Is DBNull.Value, drTrans.Item("Maintenance Fees Paid"), 0)
                  RetainerFeesPaid = IIf(Not drTrans.Item("Retainer Fees Paid") Is DBNull.Value, drTrans.Item("Retainer Fees Paid"), 0)
                  TotalPotentalRefund = IIf(Not drTrans.Item("Total Potental Refund") Is DBNull.Value, drTrans.Item("Total Potental Refund"), 0)
                  OldPosBalance = IIf(Not drTrans.Item("Positive Balance") Is DBNull.Value, drTrans.Item("Positive Balance"), 0)
                  Exit For
               End If
            Next

            If NewPosBalance > 0 Then
               If RefundAmount <= NewPosBalance Then 'First the refund amount
                  RefundAmount = 0
               Else
                  RefundAmount = RefundAmount - NewPosBalance
               End If
               dr.Item("PosBal") = NewPosBalance
               dr.Item("RefundAmt") = RefundAmount
            End If
            If NewPosBalance <= 0 Then
               dr.Item("PosBal") = 0.0
            End If
            If SettlementFeesPaid <= 0 Then
               dr.Item("SettlementFeesPaid") = 0.0
            End If
            If MaintenanceFeesPaid <= 0 Then
               dr.Item("MaintenanceFeesPaid") = 0.0
            End If
            If RetainerFeesPaid <= 0 Then
               dr.Item("RetainerFeesPaid") = 0.0
            End If
            If TotalPotentalRefund <= 0 Then
               dr.Item("TotalPotentalRefund") = 0.0
            End If
            If RefundAmount <= NewPosBalance Then
               dr.Item("Refund") = "NO"
            Else
               dr.Item("Refund") = "YES"
            End If
         End If
         'Reset the variables
         AccountNumber = 0
         Deposits = 0.0 'Deposits
         PaidOut = 0.0 'Payments
         NewPosBalance = 0.0 'SDA Balance
         RefundAmount = 0.0 'Refund amount
         SettlementFeesPaid = 0.0 'Settlement Fees Paid
         MaintenanceFeesPaid = 0.0 'Maintenance Fees Paid
         RetainerFeesPaid = 0.0 'RetainerFeesPaid
         TotalPotentalRefund = 0.0 'Potental refund amount
      Next
      'Lock it down in memory before passing it back
      dsPrimary.AcceptChanges()
      Return dsPrimary
   End Function

   Public Shared Function CreatePrimaryTSQL(ByVal StartDate As String, ByVal EndDate As String) As String
      Dim strSQL As String = ""

      strSQL = ""
      'Write the first call - Basic demographics
      strSQL += "SELECT DATENAME(MONTH, rg.created) [Month], "
      strSQL += "rg.created [Date], "
      strSQL += "cl.AccountNumber [Account Number], "
      strSQL += "p.firstname + ' ' + p.lastname [Client Name], "
      strSQL += "co.ShortCoName [Law Firm], "
      strSQL += "ag.Name [Agent], "
      strSQL += "CASE WHEN us.username IS NOT NULL THEN (SELECT TOP 1 rde.Description FROM tblreasons res "
      strSQL += "JOIN tblreasonsdesc rde ON rde.ReasonsDescID = res.ReasonsDescID "
      strSQL += "WHERE res.value = cl.clientid) ELSE ' ' END [Reason], "
      strSQL += "et.DisplayName [Refund], "
      strSQL += "UPPER(LEFT(us.UserName, 2)) [CSR] "
      strSQL += "FROM tblRoadMap rm "
      strSQL += "JOIN tblClient cl ON cl.clientid = rm.clientid "
      strSQL += "JOIN tblperson p ON p.clientid = cl.clientid "
      strSQL += "AND p.Relationship = 'Prime' "
      strSQL += "JOIN tblclientstatus cs ON cs.ClientStatusID = rm.ClientStatusID "
      strSQL += "JOIN tblcompany co ON co.companyid = cl.CompanyID "
      strSQL += "JOIN tblagency ag ON ag.AgencyID = cl.agencyid "
      strSQL += "LEFT JOIN tblregister rg ON rg.ClientId = cl.ClientID "
      strSQL += "JOIN tblentrytype et ON et.EntryTypeId = rg.EntryTypeId "
      strSQL += "JOIN tblUser us ON us.userid = rg.Createdby "
      strSQL += "WHERE rm.clientstatusid IN (17) "
      strSQL += "AND rm.created BETWEEN '" & startDate & "' AND '" & endDate & "' "
      strSQL += "AND rg.entrytypeid IN (21, 50) "

      Return strSQL
   End Function

   Public Shared Function CreateTransactionTSQL(ByVal StartDate As String, ByVal EndDate As String) As String
      Dim strSQL As String

      strSQL = ""
      strSQL += "SELECT cl.accountnumber [Account Number], "
      strSQL += "CASE WHEN us.username IS NOT NULL THEN (SELECT CAST(SUM(rp.Amount) AS MONEY) FROM tblregister r "
      strSQL += "JOIN tblclient cl ON cl.clientid = r.clientid "
      strSQL += "JOIN tblregisterpayment rp on rp.feeregisterid = r.registerid "
      strSQL += "WHERE(rp.voided Is Not NULL) "
      strSQL += "AND r.clientid = rg.clientid "
      strSQL += "AND entrytypeid IN (2, 42)) ELSE 0 END [Retainer Fees Paid], "
      strSQL += "CASE WHEN us.username IS NOT NULL THEN (SELECT CAST(SUM(rp.Amount) AS  DECIMAL(18, 2)) FROM tblregister r "
      strSQL += "JOIN tblclient cl ON cl.clientid = r.clientid "
      strSQL += "JOIN tblregisterpayment rp on rp.feeregisterid = r.registerid "
      strSQL += "WHERE(rp.voided Is Not NULL) "
      strSQL += "AND r.clientid = rg.clientid "
      strSQL += "AND entrytypeid IN (1)) ELSE 0 END [Maintenance Fees Paid], "
      strSQL += "CASE WHEN us.username IS NOT NULL THEN (SELECT CAST(SUM(rp.Amount) AS  DECIMAL(18, 2)) FROM tblregister r "
      strSQL += "JOIN tblclient cl ON cl.clientid = r.clientid "
      strSQL += "JOIN tblregisterpayment rp on rp.feeregisterid = r.registerid "
      strSQL += "WHERE(rp.voided Is Not NULL) "
      strSQL += "AND r.clientid = rg.clientid "
      strSQL += "AND entrytypeid IN (4, 18)) ELSE 0 END [Settlement Fees Paid], "
      strSQL += "CASE WHEN us.username IS NOT NULL THEN (SELECT CAST(SUM(rp.Amount) AS  DECIMAL(18, 2)) FROM tblregister r "
      strSQL += "JOIN tblclient cl ON cl.clientid = r.clientid "
      strSQL += "JOIN tblregisterpayment rp on rp.feeregisterid = r.registerid "
      strSQL += "WHERE(rp.voided Is Not NULL) "
      strSQL += "AND r.clientid = rg.clientid "
      strSQL += "AND entrytypeid NOT IN (3)) ELSE 0 END [Total Potental Refund], "
      strSQL += "(rg.amount * -1)  [Refund Amount], "
      strSQL += "1.00 [Positive Balance] "
      strSQL += "FROM tblRoadMap rm "
      strSQL += "JOIN tblClient cl ON cl.clientid = rm.clientid "
      strSQL += "JOIN tblperson p ON p.clientid = cl.clientid "
      strSQL += "AND p.Relationship = 'Prime' "
      strSQL += "JOIN tblclientstatus cs ON cs.ClientStatusID = rm.ClientStatusID "
      strSQL += "JOIN tblcompany co ON co.companyid = cl.CompanyID "
      strSQL += "JOIN tblagency ag ON ag.AgencyID = cl.agencyid "
      strSQL += "LEFT JOIN tblregister rg ON rg.ClientId = cl.ClientID "
      strSQL += "JOIN tblentrytype et ON et.EntryTypeId = rg.EntryTypeId "
      strSQL += "JOIN tblUser us ON us.userid = rg.Createdby "
      strSQL += "WHERE rm.clientstatusid IN (17) "
      strSQL += "AND rm.created BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
      strSQL += "AND rg.entrytypeid IN (21, 50) "
      strSQL += "ORDER BY cl.AccountNumber "
      Return strSQL
   End Function

   Public Shared Function CreateBigTSQL(ByVal StartDate As String, ByVal EndDate As String) As String

      Dim strSQL As String

      strSQL = "SELECT DATENAME(MONTH, rg.created) [Month], "
      strSQL += "rg.created [Date], "
      strSQL += "cl.AccountNumber [Account Number], "
      strSQL += "p.firstname + ' ' + p.lastname [Client Name], "
      strSQL += "co.ShortCoName [Law Firm], "
      strSQL += "ag.Name [Agent], "
      strSQL += "CASE WHEN (SELECT TOP 1 rds.description "
      strSQL += "from tblreasonsdesc rds "
      strSQL += "JOIN tblreasons rs ON rs.reasonsdescid = rds.reasonsdescid "
      strSQL += "WHERE rs.value = cl.clientid) = '<other>' THEN (SELECT TOP 1 rs.other "
      strSQL += "FROM tblreasonsdesc rds "
      strSQL += "JOIN tblreasons rs ON rs.reasonsdescid = rds.reasonsdescid "
      strSQL += "WHERE rs.value = cl.clientid) WHEN (SELECT TOP 1 rds.description "
      strSQL += "FROM tblreasonsdesc rds "
      strSQL += "JOIN tblreasons rs ON rs.reasonsdescid = rds.reasonsdescid "
      strSQL += "WHERE rs.value = cl.clientid) IS NULL THEN 'Unknown Reason' "
      strSQL += "ELSE (SELECT TOP 1 rds.Description "
      strSQL += "FROM tblreasonsdesc rds "
      strSQL += "JOIN tblreasons rs on rs.reasonsdescid = rds.reasonsdescid "
      strSQL += "WHERE rs.value = cl.clientid) END [Reason], "
      strSQL += "CASE WHEN (rg.amount * -1) > CAST(((SELECT isnull(sum(r1.amount), 0) "
      strSQL += "FROM tblregister r1 "
      strSQL += "JOIN tblclient c1 ON c1.clientid = r1.clientid "
      strSQL += "WHERE r1.entrytypeid IN (3, 10) "
      strSQL += "AND c1.accountnumber = cl.accountnumber "
      strSQL += "AND r1.bounce is null) + (SELECT isnull(sum(r.amount), 0) FROM tblregister r "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (18, 28) "
      strSQL += "AND c.accountnumber = cl.accountnumber "
      strSQL += "AND r.void IS NULL)) - ((SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (2, 42) "
      strSQL += "AND c.accountnumber = cl.accountnumber) + (SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (1) "
      strSQL += "AND c.accountnumber = cl.accountnumber) + (SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (4) "
      strSQL += "AND c.accountnumber = cl.accountnumber) + (SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid NOT IN (1, 2, 3, 4, 10, 18, 21, 28, 42, 48) "
      strSQL += "AND c.accountnumber = cl.accountnumber)) AS DECIMAL(18, 2)) THEN 'YES' ELSE 'NO' END [Refund], "
      strSQL += "UPPER(LEFT(us.UserName, 2)) [CSR], "
      strSQL += "(SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (2, 42) "
      strSQL += "AND c.accountnumber = cl.accountnumber) [Retainer Fees Paid], "
      strSQL += "(SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (1) "
      strSQL += "AND c.accountnumber = cl.accountnumber) [Maintenance Fees Paid], "
      strSQL += "(SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (4) "
      strSQL += "AND c.accountnumber = cl.accountnumber) [Settlement Fees Paid], "
      strSQL += "(SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid NOT IN (1, 2, 3, 4, 18, 21, 28, 42) "
      strSQL += "AND c.accountnumber = cl.accountnumber) [Other Fees Paid], "
      strSQL += "((SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (2, 42) "
      strSQL += "AND c.accountnumber = cl.accountnumber) + (SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (1) "
      strSQL += "AND c.accountnumber = cl.accountnumber) + (SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (4) "
      strSQL += "AND c.accountnumber = cl.accountnumber) + (SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid NOT IN (1, 2, 3, 4, 18, 21, 28, 42) "
      strSQL += "AND c.accountnumber = cl.accountnumber)) [Total Potental Refund], "
      strSQL += "(SELECT isnull(sum(r3.amount), 0) "
      strSQL += "FROM tblRegister r3 "
      strSQL += "JOIN tblClient c3 ON c3.clientid = r3.clientid "
      strSQL += "WHERE r3.entrytypeid IN (48) "
      strSQL += "AND c3.accountnumber = cl.accountnumber) [Refund Amount], "
      strSQL += "CASE WHEN ((SELECT isnull(sum(r1.amount), 0) "
      strSQL += "FROM tblregister r1 "
      strSQL += "JOIN tblclient c1 ON c1.clientid = r1.clientid "
      strSQL += "WHERE r1.entrytypeid IN (3, 10) "
      strSQL += "AND c1.accountnumber = cl.accountnumber "
      strSQL += "AND r1.bounce is null) + (SELECT isnull(sum(r.amount), 0) FROM tblregister r "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (18, 28) "
      strSQL += "AND c.accountnumber = cl.accountnumber "
      strSQL += "AND r.void IS NULL)) - ((SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (2, 42) "
      strSQL += "AND c.accountnumber = cl.accountnumber) + (SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (1) "
      strSQL += "AND c.accountnumber = cl.accountnumber) + (SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (4) "
      strSQL += "AND c.accountnumber = cl.accountnumber) + (SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid NOT IN (1, 2, 3, 4, 10, 18, 21, 28, 42, 48) "
      strSQL += "AND c.accountnumber = cl.accountnumber)) > 0 THEN ((SELECT isnull(sum(r1.amount), 0) "
      strSQL += "FROM tblregister r1 "
      strSQL += "JOIN tblclient c1 ON c1.clientid = r1.clientid "
      strSQL += "WHERE r1.entrytypeid IN (3, 10) "
      strSQL += "AND c1.accountnumber = cl.accountnumber "
      strSQL += "AND r1.bounce is null) + (SELECT isnull(sum(r.amount), 0) FROM tblregister r "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (18, 28) "
      strSQL += "AND c.accountnumber = cl.accountnumber "
      strSQL += "AND r.void IS NULL)) - ((SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (2, 42) "
      strSQL += "AND c.accountnumber = cl.accountnumber) + (SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (1) "
      strSQL += "AND c.accountnumber = cl.accountnumber) + (SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid IN (4) "
      strSQL += "AND c.accountnumber = cl.accountnumber) + (SELECT isnull(sum(rp.amount), 0) FROM tblregisterPayment rp "
      strSQL += "LEFT JOIN tblregister r ON r.RegisterId = rp.feeregisterid "
      strSQL += "JOIN tblclient c ON c.ClientID = r.clientid "
      strSQL += "WHERE entrytypeid NOT IN (1, 2, 3, 4, 10, 18, 21, 28, 42, 48) "
      strSQL += "AND c.accountnumber = cl.accountnumber)) ELSE 0 END [Pos Bal] "
      strSQL += "FROM tblRoadMap rm "
      strSQL += "JOIN tblClient cl ON cl.clientid = rm.clientid "
      strSQL += "JOIN tblperson p ON p.clientid = cl.clientid "
      strSQL += "AND p.Relationship = 'Prime' "
      strSQL += "JOIN tblclientstatus cs ON cs.ClientStatusID = rm.ClientStatusID "
      strSQL += "JOIN tblcompany co ON co.companyid = cl.CompanyID "
      strSQL += "JOIN tblagency ag ON ag.AgencyID = cl.agencyid "
      strSQL += "LEFT JOIN tblregister rg ON rg.ClientId = cl.ClientID "
      strSQL += "JOIN tblentrytype et ON et.EntryTypeId = rg.EntryTypeId "
      strSQL += "JOIN tblUser us ON us.userid = rg.Createdby "
      strSQL += "WHERE rm.roadmapid IN (SELECT TOP 1 roadmapid FROM tblroadmap WHERE clientstatusid = 17 AND clientid = cl.ClientID ORDER BY Created) "
      strSQL += "AND rg.created BETWEEN '" & StartDate & "' AND '" & EndDate & "' "
      strSQL += "AND rg.entrytypeid IN (21) "
      strSQL += "ORDER BY cl.AccountNumber"

      Return strSQL

   End Function
End Class
