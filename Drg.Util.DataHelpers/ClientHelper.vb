Option Explicit On

Imports Slf.Dms.Records

Imports Drg.Util.DataAccess
Imports Drg.Util.Helpers
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Collections.Generic

Public Class ClientHelper

    Public Shared Sub CleanupRegister(ByVal ClientID As Integer)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_DoRegisterCleanup")

            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

            Using cn As IDbConnection = cmd.Connection

                cn.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

    End Sub
    Public Shared Function GetNumAccountsOverThreshold(ByVal ClientID As Integer, _
        ByVal AvailableAmount As Double, ByVal MediationThreshold As Double) As Integer

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNumAccountOverThresholdForClient")

            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
            DatabaseHelper.AddParameter(cmd, "AvailableAmount", AvailableAmount)
            DatabaseHelper.AddParameter(cmd, "MediationThreshold", MediationThreshold)

            Using cn As IDbConnection = cmd.Connection

                cn.Open()
                Return DataHelper.Nz_int(cmd.ExecuteScalar())

            End Using
        End Using

    End Function
    Public Shared Function Exists(ByVal ClientID As Integer) As Boolean
        Return DataHelper.RecordExists("tblClient", "ClientID = " & ClientID)
    End Function
    Public Shared Function GetLanguage(ByVal ClientID As Integer)

        Return DataHelper.Nz(DataHelper.FieldLookup("tblPerson", "LanguageID", _
            "PersonID = " & GetDefaultPerson(ClientID)))

    End Function
   Public Shared Sub UpdateACHInfo(ByVal ClientID As Integer, ByVal DepositDay As Integer, _
       ByVal BankName As String, ByVal BankRoutingNumber As String, ByVal BankAccountNumber As String, _
       ByVal MonthlyFee As Double, ByVal UserID As Integer, Optional ByVal MultiDeposit As Boolean = False)

      Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

      DatabaseHelper.AddParameter(cmd, "DepositMethod", "ACH")
      DatabaseHelper.AddParameter(cmd, "DepositDay", DataHelper.Zn(DepositDay))
      DatabaseHelper.AddParameter(cmd, "BankName", DataHelper.Zn(BankName))
      DatabaseHelper.AddParameter(cmd, "BankRoutingNumber", DataHelper.Zn(BankRoutingNumber))
      DatabaseHelper.AddParameter(cmd, "BankAccountNumber", DataHelper.Zn(BankAccountNumber))
      DatabaseHelper.AddParameter(cmd, "MonthlyFee", DataHelper.Zn(MonthlyFee), DbType.Double)

      DatabaseHelper.AddParameter(cmd, "LastModified", Now)
      DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

      DatabaseHelper.BuildUpdateCommandText(cmd, "tblClient", "ClientID = " & ClientID)

      Try
         cmd.Connection.Open()
         cmd.ExecuteNonQuery()
      Finally
         DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
      End Try

   End Sub
    Public Shared Sub LoadSearch(ByVal ClientID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_LoadClientSearch")

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Public Shared Function GetDefaultPerson(ByVal ClientID As Integer) As Integer
        Return DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "PrimaryPersonID", "ClientID = " & ClientID))
    End Function
    Public Shared Function GetDefaultPersonName(ByVal ClientID As Integer) As String
        Return GetDefaultPersonName(ClientID, False)
    End Function
    Public Shared Function GetDefaultPersonName(ByVal ClientID As Integer, ByVal Formal As Boolean) As String
        Dim AccountNo As String = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " & ClientID)
        Dim Attorney As String = DataHelper.FieldLookup("tblCompany", "Name", "CompanyID = " & CInt(Val(DataHelper.FieldLookup("tblClient", "CompanyID", "ClientID = " & ClientID))))
        Dim PersonName As String = PersonHelper.GetName(GetDefaultPerson(ClientID), Formal)
        Return PersonName & " - " & Attorney & " - " & AccountNo

        'Return PersonHelper.GetName(GetDefaultPerson(ClientID), Formal)
    End Function
    Public Shared Function HasDefaultPerson(ByVal ClientID As Integer) As Boolean

        Dim PrimaryPersonID As Integer = GetDefaultPerson(ClientID)

        Return (DataHelper.FieldCount("tblPerson", "PersonID", "PersonID = " & PrimaryPersonID) > 0)

    End Function
    Public Shared Function SetNextDefaultPerson(ByVal ClientID As Integer, ByVal UserID As Integer) As Boolean

        'grab next person belonging to this client (written first to db)
        Dim NextHighestPersonID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPerson", "PersonID", "ClientID = " & ClientID))

        PersonHelper.SetAsPrimary(NextHighestPersonID, ClientID, UserID)

    End Function
    Public Shared Function GetStatus(ByVal ClientID As Integer) As String
        Dim result As String = ""
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.Connection.Open()
                cmd.CommandText = "SELECT tblClientStatus.Name FROM tblClient INNER JOIN tblClientStatus ON tblClient.CurrentClientStatusId=tblClientStatus.ClientStatusId WHERE tblClient.ClientId=@ClientId"
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                Using rd As IDataReader = cmd.ExecuteReader
                    If rd.Read Then
                        If Not rd.IsDBNull(0) Then
                            result = rd.GetString(0)
                        End If
                    End If
                End Using
            End Using
        End Using
        Return result
    End Function
    Public Shared Function GetStatus(ByVal ClientID As Integer, ByVal [When] As DateTime) As String

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetStatusForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "When", [When])

        Try

            cmd.Connection.Open()

            Return DataHelper.Nz_string(cmd.ExecuteScalar())

        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Function
    Public Shared Sub UpdateField(ByVal ClientID As Integer, ByVal Field As String, ByVal Value As Object, _
        ByVal UserID As Integer)

        Dim fields As New List(Of DataHelper.FieldValue)
        fields.Add(New DataHelper.FieldValue("LastModified", Now))
        fields.Add(New DataHelper.FieldValue("LastModifiedBy", DataHelper.Nz_int(UserID)))
        fields.Add(New DataHelper.FieldValue(Field, Value))

        DataHelper.AuditedUpdate(fields, "tblClient", ClientID, UserID)
    End Sub
    Public Shared Function GetRoadmap(ByVal ClientID As Integer, ByVal Field As String) As String
        Return GetRoadmap(ClientID, Now, Field)
    End Function
    Public Shared Function GetRoadmap(ByVal ClientID As Integer, ByVal [When] As DateTime, ByVal Field As String) As String
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetRoadmapForClient")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
                DatabaseHelper.AddParameter(cmd, "When", [When])

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)

                    If rd.Read() Then
                        Return rd.GetValue(rd.GetOrdinal(Field)).ToString
                    End If
                End Using
            End Using
        End Using
        Return ""
    End Function
    Public Shared Function GetTasksPastDue(ByVal ClientID As Integer, ByVal UserID As Integer) As List(Of Task)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTasksForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "Criteria", "tblTask.Resolved = NULL AND " _
            & DataHelper.StripTime("tblTask.Due") & " <= '" & Now.ToString("yyyy-MM-dd") _
            & "' AND tblTask.AssignedTo = " & UserID)

        GetTasksPastDue = New List(Of Task)

        Try
            cmd.Connection.Open()
            rd = cmd.ExecuteReader()
            While rd.Read()
                GetTasksPastDue.Add(New Task(DatabaseHelper.Peel_int(rd, "TaskID"), _
                    DatabaseHelper.Peel_int(rd, "ParentTaskID"), _
                    DatabaseHelper.Peel_int(rd, "ClientID"), _
                    DatabaseHelper.Peel_string(rd, "ClientName"), _
                    DatabaseHelper.Peel_int(rd, "TaskTypeID"), _
                    DatabaseHelper.Peel_string(rd, "TaskTypeName"), _
                    DatabaseHelper.Peel_int(rd, "TaskTypeCategoryID"), _
                    DatabaseHelper.Peel_string(rd, "TaskTypeCategoryName"), _
                    DatabaseHelper.Peel_string(rd, "Description"), _
                    DatabaseHelper.Peel_int(rd, "AssignedTo"), _
                    DatabaseHelper.Peel_string(rd, "AssignedToName"), _
                    DatabaseHelper.Peel_date(rd, "Due"), _
                    DatabaseHelper.Peel_ndate(rd, "Resolved"), _
                    DatabaseHelper.Peel_int(rd, "ResolvedBy"), _
                    DatabaseHelper.Peel_string(rd, "ResolvedByName"), _
                    DatabaseHelper.Peel_int(rd, "TaskResolutionID"), _
                    DatabaseHelper.Peel_string(rd, "TaskResolutionName"), _
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
    End Function
   Public Shared Function InsertClient(ByVal EnrollmentID As Integer, ByVal AgencyID As Integer, _
       ByVal CompanyID As Integer, ByVal UserID As Integer, Optional ByVal MultipleDeposit As Boolean = False) As Integer

      Dim SetupFee As Double
      Dim SetupFeePercentage As Double = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentRetainerPercentage"))
      Dim SettlementFeePercentage As Double = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentSettlementPercentage"))
      Dim MonthlyFee As Double = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentMonthlyFee"))
      Dim MonthlyFeeDay As Integer = DataHelper.Nz_int(PropertyHelper.Value("EnrollmentMonthlyFeeDay"))
      Dim AdditionalAccountFee As Double = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentAddAccountFee"))
      Dim ReturnedCheckFee As Double = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentReturnedCheckFee"))
      Dim OvernightDeliveryFee As Double = DataHelper.Nz_double(PropertyHelper.Value("EnrollmentOvernightFee"))
      Dim MultiDeposit As Boolean = DataHelper.Nz_bool(PropertyHelper.Value("MultiDeposit"))

      'lookup total debt as given at enrollment
      Dim TotalUnsecuredDebt As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblEnrollment", _
          "TotalUnsecuredDebt", "EnrollmentID = " & EnrollmentID))

      'calc the setup fee off the setupfeepercentage
      SetupFee = TotalUnsecuredDebt * SetupFeePercentage

      Dim TrustID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblTrust", "TrustID", _
          "[Default] = 1"))

      Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

      DatabaseHelper.AddParameter(cmd, "EnrollmentID", EnrollmentID)

      DatabaseHelper.AddParameter(cmd, "SetupFee", SetupFee)
      DatabaseHelper.AddParameter(cmd, "SetupFeePercentage", SetupFeePercentage)
      DatabaseHelper.AddParameter(cmd, "MonthlyFee", MonthlyFee)
      DatabaseHelper.AddParameter(cmd, "MonthlyFeeDay", MonthlyFeeDay)
      DatabaseHelper.AddParameter(cmd, "SettlementFeePercentage", SettlementFeePercentage)
      DatabaseHelper.AddParameter(cmd, "AdditionalAccountFee", AdditionalAccountFee)
      DatabaseHelper.AddParameter(cmd, "ReturnedCheckFee", ReturnedCheckFee)
      DatabaseHelper.AddParameter(cmd, "OvernightDeliveryFee", OvernightDeliveryFee)

      DatabaseHelper.AddParameter(cmd, "TrustID", DataHelper.Zn_double(TrustID))
      DatabaseHelper.AddParameter(cmd, "AgencyID", DataHelper.Zn_double(AgencyID))
      DatabaseHelper.AddParameter(cmd, "CompanyID", DataHelper.Zn_double(CompanyID))

      DatabaseHelper.AddParameter(cmd, "Created", Now)
      DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
      DatabaseHelper.AddParameter(cmd, "LastModified", Now)
      DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))
      DatabaseHelper.AddParameter(cmd, "MultiDeposit", DataHelper.Nz_bool(MultiDeposit))

      DatabaseHelper.BuildInsertCommandText(cmd, "tblClient", "ClientID", SqlDbType.Int)

      Try
         cmd.Connection.Open()
         cmd.ExecuteNonQuery()
      Finally
         DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
      End Try

      Return DataHelper.Nz_int(cmd.Parameters("@ClientID").Value)

   End Function
    Public Shared Sub UpdateClientPrimaryPersonID(ByVal ClientID As Integer, ByVal PersonID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "PrimaryPersonID", PersonID)

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblClient", "ClientID = " & ClientID)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Public Shared Function InsertClientTask(ByVal ClientID As Integer, ByVal TaskID As Integer, _
        ByVal UserID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        DatabaseHelper.BuildInsertCommandText(cmd, "tblClientTask", "ClientTaskID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@ClientTaskID").Value)

    End Function
    'Public Shared Function InsertClientNote(ByVal ClientID As Integer, ByVal NoteID As Integer, _
    '    ByVal UserID As Integer) As Integer

    '    Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

    '    DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
    '    DatabaseHelper.AddParameter(cmd, "NoteID", NoteID)

    '    DatabaseHelper.AddParameter(cmd, "Created", Now)
    '    DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
    '    DatabaseHelper.AddParameter(cmd, "LastModified", Now)
    '    DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

    '    DatabaseHelper.BuildInsertCommandText(cmd, "tblClientNote", "ClientNoteID", SqlDbType.Int)

    '    Try
    '        cmd.Connection.Open()
    '        cmd.ExecuteNonQuery()
    '    Finally
    '        DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
    '    End Try

    '    Return DataHelper.Nz_int(cmd.Parameters("@ClientNoteID").Value)
    'End Function
    Public Shared Sub ConvertToPlaza(ByVal DataClientID As Integer, ByVal NewCompanyId As Integer, ByVal ActionUserID As Integer)
        Dim fields As New List(Of DataHelper.FieldValue)
        Dim ClientAccountNumber As String = ""
        Dim ClientCompanyID As String = ""
        Dim dblCurrentSDA As Double = 0
        Dim strTrustName As String = ""
        Dim strTrustAcctNum As String = ""
        Dim strTrustRoutingNum As String = ""
        Dim strType As String = ""
        Dim ClientTrustID As Integer
        Const ChecksiteTrustID As Integer = 22

        'Note: RegisterHelper.Rebalance should have already been ran prior to calling ConvertToPlaza

        'get client info
        'LOGIC:  Get SDA Balance , include funds on hold that have not been processed, 
        'exclude all funds on hold that have been processed in the past 2 days by colonial or transactiondate is after processing date

        Dim sqlClient As String = "SELECT distinct c.TrustID, c.AccountNumber, c.CompanyID, c.SDABalance, case when nr.registerid is null then 'False' else 'True' end as [Processed], "
        sqlClient += "sum(case when isnull(r.hold,getdate()) > dateadd(d,1,getdate())or isnull(r.transactiondate,getdate()) > dateadd(d,1,getdate())  then r.amount else 0 end) as [OnHold] "
        sqlClient += "from tblClient as c left outer join (select r.hold, r.transactiondate, r.amount, r.clientid ,r.registerid,r.void,r.bounce,nr.registerid as [ProcessedRegisterID] "
        sqlClient += "from tblregister as r left outer join tblnacharegister as nr on r.registerid=nr.registerid "
        sqlClient += "where	(isnull(r.hold,getdate()) > dateadd(d,1,getdate())or isnull(r.transactiondate,getdate()) > dateadd(d,1,getdate())) "
        sqlClient += "and (r.void is null and r.bounce is null))as r on c.clientid =r.clientid  left outer join tblnacharegister as nr on r.registerid=nr.registerid "
        sqlClient += "where (c.clientid = " & DataClientID & ") "
        sqlClient += "group by c.TrustID, c.AccountNumber, c.CompanyID, c.SDABalance,nr.registerid"

        Dim dtClient As DataTable = GetDataTable(sqlClient)
        If dtClient.Rows.Count > 0 Then
            For Each dRow As DataRow In dtClient.Rows
                ClientAccountNumber = dRow("Accountnumber").ToString
                ClientCompanyID = dRow("CompanyID").ToString
                dblCurrentSDA = CDbl(dRow("SDABalance").ToString) - CDbl(dRow("OnHold").ToString)
                ClientTrustID = CInt(dRow("TrustID"))
                Exit For
            Next
        End If
        dtClient.Dispose()

        fields.Add(New DataHelper.FieldValue("TrustID", ChecksiteTrustID))
        fields.Add(New DataHelper.FieldValue("CompanyId", NewCompanyId))
        DataHelper.AuditedUpdate(fields, "tblClient", DataClientID, ActionUserID)

        Dim ClientCompanyName As String = DataAccess.DataHelper.FieldLookup("tblCompany", "Name", "CompanyId = " & ClientCompanyID)
        Dim NewCompanyName As String = DataAccess.DataHelper.FieldLookup("tblCompany", "Name", "CompanyId = " & NewCompanyId)
        Dim strTransMSG As String = String.Format("Settlement Attorney changed from {0} to {1}. ", ClientCompanyName, NewCompanyName)

        If dblCurrentSDA > 0 And (ClientTrustID <> ChecksiteTrustID) Then

            'get comm info
            Dim dtComm As DataTable = GetDataTable("SELECT display, routingnumber, accountnumber, commrecid, isnull(type,'C') [type] from tblcommrec where istrust = 1 and companyid =  " & ClientCompanyID)
            If dtComm.Rows.Count > 0 Then
                For Each dRow As DataRow In dtComm.Rows
                    strTrustName = dRow("display").ToString
                    strTrustAcctNum = dRow("accountnumber").ToString
                    strTrustRoutingNum = dRow("routingnumber").ToString
                    strType = dRow("type").ToString
                    Exit For
                Next
            End If
            dtComm.Dispose()

            'build status messages
            strTransMSG &= "Transfer " & FormatCurrency(dblCurrentSDA, 2) & " from " & strTrustName & " to Shadow Account " & ClientAccountNumber & "."

            'insert debit and deposit into tblregister - Close acct debit, open acct deposit
            Drg.Util.DataHelpers.RegisterHelper.InsertDebit(DataClientID, Nothing, Format(DateAdd(DateInterval.Day, 1, Now), "MM/dd/yyy") & " 12:01 AM", Nothing, strTransMSG, dblCurrentSDA * -1, ActionUserID, 44, ActionUserID)
            Dim regID As Integer = Drg.Util.DataHelpers.RegisterHelper.InsertDeposit(DataClientID, Format(DateAdd(DateInterval.Day, 1, Now), "MM/dd/yyy") & " 12:01 AM", "NULL", strTransMSG, dblCurrentSDA, 45, DateAdd(DateInterval.Day, 1, Now), ActionUserID, ActionUserID)

            'insert nacharegister2 to move funds from trust to client shadow store
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            DatabaseHelper.AddParameter(cmd, "Name", strTrustName)
            DatabaseHelper.AddParameter(cmd, "AccountNumber", strTrustAcctNum)
            DatabaseHelper.AddParameter(cmd, "RoutingNumber", strTrustRoutingNum)
            DatabaseHelper.AddParameter(cmd, "Type", strType)
            DatabaseHelper.AddParameter(cmd, "Amount", dblCurrentSDA)
            DatabaseHelper.AddParameter(cmd, "IsPersonal", 0)
            DatabaseHelper.AddParameter(cmd, "CompanyID", NewCompanyId)
            DatabaseHelper.AddParameter(cmd, "ShadowStoreId", ClientAccountNumber)
            DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)
            DatabaseHelper.AddParameter(cmd, "RegisterID", regID)
            DatabaseHelper.AddParameter(cmd, "Flow", "credit")
            DatabaseHelper.BuildInsertCommandText(cmd, "tblNachaRegister2")

            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try

        End If

        'insert note stating change
        Drg.Util.DataHelpers.NoteHelper.InsertNote("CheckSite conversion." & vbCrLf & strTransMSG, ActionUserID, DataClientID)

    End Sub
    Public Shared Sub ReverseConvertToPlaza(ByVal DataClientID As Integer, ByVal NewCompanyId As Integer, ByVal ActionUserID As Integer)

        'insert registry entries
        Dim ClientAccountNumber As String = ""
        Dim ClientCompanyID As String = ""
        Dim dblCurrentSDA As Double = 0
        Dim strTrustName As String = ""
        Dim strTrustAcctNum As String = ""
        Dim strTrustRoutingNum As String = ""
        Dim strType As String = ""

        'LOGIC:  Get SDA Balance , include funds on hold that have not been processed, 
        'exclude all funds on hold that have been processed in the past 2 days by colonial or transactiondate is after processing date

        'Edit 7/21/08 - jhernandez
        'Exclude on hold amounts if they have a clear date that has already passed.
        Dim sqlClient As String = "SELECT distinct c.AccountNumber, c.CompanyID, c.SDABalance, case when nr.registerid is null then 'False' else 'True' end as [Processed], "
        sqlClient += "isnull(sum(r.amount),0) [OnHold] "
        sqlClient += "from tblClient as c left outer join (select r.hold, r.transactiondate, r.amount, r.clientid ,r.registerid,r.void,r.bounce,nr.registerid as [ProcessedRegisterID] "
        sqlClient += "from tblregister as r left outer join tblnacharegister as nr on r.registerid=nr.registerid "
        sqlClient += "where	(isnull(r.hold,getdate()) > dateadd(d,1,getdate())or isnull(r.transactiondate,getdate()) > dateadd(d,1,getdate())) "
        sqlClient += "and (r.void is null and r.bounce is null) and isnull(r.Clear,'1/1/2050') > dateadd(d,1,getdate())) as r on c.clientid =r.clientid  left outer join tblnacharegister as nr on r.registerid=nr.registerid "
        sqlClient += "where (c.clientid = " & DataClientID & ") "
        sqlClient += "group by c.AccountNumber, c.CompanyID, c.SDABalance,nr.registerid"

        Dim dtClient As DataTable = GetDataTable(sqlClient)
        If dtClient.Rows.Count > 0 Then
            For Each dRow As DataRow In dtClient.Rows
                ClientAccountNumber = dRow("Accountnumber").ToString
                ClientCompanyID = dRow("CompanyID").ToString
                dblCurrentSDA = CDbl(dRow("SDABalance").ToString) - CDbl(dRow("OnHold").ToString)
                Exit For
            Next
        End If
        dtClient.Dispose()

        Dim fields As New List(Of DataHelper.FieldValue)
        fields.Add(New DataHelper.FieldValue("TrustID", 20))
        fields.Add(New DataHelper.FieldValue("CompanyId", NewCompanyId))
        DataHelper.AuditedUpdate(fields, "tblClient", DataClientID, ActionUserID)

        Dim ClientCompanyName As String = DataAccess.DataHelper.FieldLookup("tblCompany", "Name", "CompanyId = " & ClientCompanyID)
        Dim NewCompanyName As String = DataAccess.DataHelper.FieldLookup("tblCompany", "Name", "CompanyId = " & NewCompanyId)

        Dim strTransMSG As String = String.Format("Settlement Attorney changed from {0} to {1}. ", ClientCompanyName, NewCompanyName)

        If dblCurrentSDA > 0 Then
            'get comm info
            Dim dtComm As DataTable = GetDataTable("SELECT display, routingnumber, accountnumber, commrecid, isnull(type,'C') [type] from tblcommrec where istrust = 1 and companyid =  " & NewCompanyId)
            If dtComm.Rows.Count > 0 Then
                For Each dRow As DataRow In dtComm.Rows
                    strTrustName = dRow("display").ToString
                    strTrustAcctNum = dRow("accountnumber").ToString
                    strTrustRoutingNum = dRow("routingnumber").ToString
                    strType = dRow("type").ToString
                    Exit For
                Next
            End If
            dtComm.Dispose()

            'build status messages
            strTransMSG &= "Transfer " & FormatCurrency(dblCurrentSDA, 2) & " from Shadow Account " & ClientAccountNumber & " to " & strTrustName & "."

            'insert debit and deposit into tblregister - Close acct debit, open acct deposit
            Drg.Util.DataHelpers.RegisterHelper.InsertDebit(DataClientID, Nothing, Format(DateAdd(DateInterval.Day, 1, Now), "MM/dd/yyy") & " 12:01 AM", Nothing, strTransMSG, dblCurrentSDA * -1, ActionUserID, 46, ActionUserID)
            Dim regID As Integer = Drg.Util.DataHelpers.RegisterHelper.InsertDeposit(DataClientID, Format(DateAdd(DateInterval.Day, 1, Now), "MM/dd/yyy") & " 12:01 AM", "NULL", strTransMSG, dblCurrentSDA, 47, DateAdd(DateInterval.Day, 1, Now), ActionUserID, ActionUserID)

            'insert nacharegister2 to move funds from trust to client shadow store
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            DatabaseHelper.AddParameter(cmd, "Name", strTrustName)
            DatabaseHelper.AddParameter(cmd, "AccountNumber", strTrustAcctNum)
            DatabaseHelper.AddParameter(cmd, "RoutingNumber", strTrustRoutingNum)
            DatabaseHelper.AddParameter(cmd, "Type", strType)
            DatabaseHelper.AddParameter(cmd, "Amount", dblCurrentSDA)
            DatabaseHelper.AddParameter(cmd, "IsPersonal", 0)
            DatabaseHelper.AddParameter(cmd, "CompanyID", ClientCompanyID)
            DatabaseHelper.AddParameter(cmd, "ShadowStoreId", ClientAccountNumber)
            DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)
            DatabaseHelper.AddParameter(cmd, "RegisterID", regID)
            DatabaseHelper.AddParameter(cmd, "Flow", "debit")
            DatabaseHelper.BuildInsertCommandText(cmd, "tblNachaRegister2")

            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try

        End If

        'insert note stating change
        Drg.Util.DataHelpers.NoteHelper.InsertNote("CheckSite conversion reversed." & vbCrLf & strTransMSG, ActionUserID, DataClientID)

    End Sub
    Private Shared Function GetDataTable(ByVal sqlText As String) As DataTable
        Try
            Dim dtData As New DataTable
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Dim cnString As String = cmd.Connection.ConnectionString
            cmd.Dispose()
            cmd = Nothing
            Using saTemp = New SqlClient.SqlDataAdapter(sqlText, cnString)
                saTemp.fill(dtData)
            End Using
            Return dtData
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

End Class

