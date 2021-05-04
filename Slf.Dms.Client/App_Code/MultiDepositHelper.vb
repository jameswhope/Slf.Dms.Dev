Imports Microsoft.VisualBasic
Imports System.Data

Public Class MultiDepositHelper
    Public Shared Function getMultiDepositRuleOverlaps(ByVal newRuleStartDate As DateTime, ByVal newRuleEndDate As DateTime, ByVal clientDepositID As Integer, ByVal RuleAchId As Integer) As Data.DataTable

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("stp_getMultiDepositRuleOverlaps '{0}','{1}',{2}, {3}", newRuleStartDate, newRuleEndDate, clientDepositID, RuleAchId)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function

    'stp_NonDeposit_GetMultiDepositCheckRuleOverlaps
    Public Shared Function getMultiDepositCheckRuleOverlaps(ByVal newRuleStartDate As DateTime, ByVal newRuleEndDate As DateTime, ByVal clientDepositID As Integer, ByVal RuleCheckId As Integer) As Data.DataTable

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("stp_NonDeposit_GetMultiDepositCheckRuleOverlaps '{0}','{1}',{2}, {3}", newRuleStartDate, newRuleEndDate, clientDepositID, RuleCheckId)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function


    Public Overloads Shared Function getMultiDepositClientBanks(ByVal clientID As Integer) As Data.DataTable

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("stp_getMultiDepositClientBanks {0}", clientID)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function

    Public Overloads Shared Function getMultiDepositClientBanks(ByVal clientID As Integer, ByVal BankRoutingNumber As String, ByVal BankAccountNumber As String) As Data.DataTable

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("stp_getMultiDepositClientBanks {0}, '{1}', '{2}'", clientID, BankRoutingNumber, BankAccountNumber)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function

    Public Shared Function getMultiDepositRuleByRuleID(ByVal ruleID As Integer) As Data.DataRow

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("stp_getMultiDepositRulesByRuleID {0}", ruleID)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            If dtTemp.Rows.Count > 0 Then
                Return dtTemp.Rows(0)
            Else
                Return Nothing
            End If

        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try
    End Function

    'stp_NonDeposit_GetMultiDepositRulesByCheckRuleID
    Public Shared Function getMultiDepositRuleByCheckRuleID(ByVal CheckRuleID As Integer) As Data.DataRow

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("stp_NonDeposit_GetMultiDepositRulesByCheckRuleID {0}", CheckRuleID)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            If dtTemp.Rows.Count > 0 Then
                Return dtTemp.Rows(0)
            Else
                Return Nothing
            End If

        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try
    End Function

    Public Shared Function getMultiDepositRulesByClientID(ByVal clientID As Integer, ByVal bOnlyCurrent As String) As Data.DataTable

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("stp_getMultiDepositRules {0},'{1}'", clientID, bOnlyCurrent.Replace("'", "''"))
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function

    Public Shared Function getMultiDepositCheckRulesByClientID(ByVal clientID As Integer, ByVal bOnlyCurrent As String) As Data.DataTable

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("stp_NonDeposit_getMultiDepositCheckRules {0},'{1}'", clientID, bOnlyCurrent.Replace("'", "''"))
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function

    Public Shared Function getMultiDepositsForClient(ByVal clientID As Integer) As Data.DataTable
        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("Select d.* from tblClientDepositDay d Where d.Clientid = {0} and DeletedDate is null order by d.depositday asc", clientID)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function

    Public Shared Function getAllMultiDepositsForClient(ByVal clientID As Integer) As Data.DataTable
        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("Select d.* from tblClientDepositDay d Where d.Clientid = {0}", clientID)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function


    Public Shared Function IsMultiDepositClient(ByVal clientID As Integer) As Boolean
        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = "Select MultiDeposit from tblClient where clientid = @clientid"
            cmd.Parameters.Add(New Data.SqlClient.SqlParameter("ClientId", clientID))
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Return cmd.ExecuteScalar
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try
    End Function
    Public Shared Function InsertClientBank(ByVal clientID As Integer, ByVal bankRoutingNumber As String, ByVal bankAccountNumber As String, ByVal bankType As String, ByVal createdBy As Integer) As Integer

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try

         Dim dt As DataTable = MultiDepositHelper.getMultiDepositClientBanks(clientID, bankRoutingNumber, bankAccountNumber)
            If dt.Rows.Count = 0 Then
                cmd.CommandType = Data.CommandType.StoredProcedure
                cmd.CommandText = "stp_InsertClientBankAccount"
                cmd.Parameters.Add(New Data.SqlClient.SqlParameter("ClientId", clientID))
                cmd.Parameters.Add(New Data.SqlClient.SqlParameter("Routing", bankRoutingNumber))
                cmd.Parameters.Add(New Data.SqlClient.SqlParameter("Account", bankAccountNumber))
                cmd.Parameters.Add(New Data.SqlClient.SqlParameter("BankType", bankType))
                cmd.Parameters.Add(New Data.SqlClient.SqlParameter("UserID", createdBy))
                cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
                cmd.Connection.Open()
                'Return cmd.ExecuteNonQuery()
                Return cmd.ExecuteScalar
            Else
                Return dt.Rows(0).Item("BankAccountID").ToString
            End If

        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function
   Public Shared Function InsertClientDepositDay(ByVal clientID As Integer, ByVal Frequency As String, ByVal DepositDay As Integer, ByVal Amount As Double, ByVal Occurrence As Integer, ByVal DepositMethod As String, ByVal BankAccountID As Integer, ByVal UserID As Integer) As Integer

      Dim cmd As New Data.SqlClient.SqlCommand()
      Try
            cmd.CommandType = Data.CommandType.StoredProcedure
            cmd.CommandText = "stp_InsertClientDepositDay"
            cmd.Parameters.Add(New Data.SqlClient.SqlParameter("ClientId", clientID))
            cmd.Parameters.Add(New Data.SqlClient.SqlParameter("Frequency", Frequency))
            cmd.Parameters.Add(New Data.SqlClient.SqlParameter("DepositDay", DepositDay))
            cmd.Parameters.Add(New Data.SqlClient.SqlParameter("Amount", Amount))
            If Occurrence > 0 Then cmd.Parameters.Add(New Data.SqlClient.SqlParameter("Occurrence", Occurrence))
            cmd.Parameters.Add(New Data.SqlClient.SqlParameter("DepositMethod", DepositMethod))
            If BankAccountID > 0 Then cmd.Parameters.Add(New Data.SqlClient.SqlParameter("BankAccountId", BankAccountID))
            cmd.Parameters.Add(New Data.SqlClient.SqlParameter("UserId", UserID))
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            'Return cmd.ExecuteNonQuery()
            Return cmd.ExecuteScalar

        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

   End Function
   Public Shared Function InsertMultiDepositRule(ByVal clientDepositID As Integer, ByVal StartDate As DateTime, ByVal EndDate As DateTime, _
                                                 ByVal DepositDay As Integer, ByVal DepositAmount As Double, _
                                                 ByVal bankAccountID As String, ByVal CreatedBy As Integer, ByVal LastModifiedBy As Integer, Optional ByVal OldRuleID As Integer = 0, Optional ByVal Locked As Boolean = False) As Integer

      Dim cmd As New Data.SqlClient.SqlCommand()
      Try
         cmd.CommandType = Data.CommandType.StoredProcedure
         cmd.CommandText = "stp_InsertMultiDepositRule"
         cmd.Parameters.Add(New Data.SqlClient.SqlParameter("StartDate", StartDate))
         cmd.Parameters.Add(New Data.SqlClient.SqlParameter("EndDate", EndDate))
         cmd.Parameters.Add(New Data.SqlClient.SqlParameter("DepositDay", DepositDay))
         cmd.Parameters.Add(New Data.SqlClient.SqlParameter("DepositAmount", DepositAmount))
         cmd.Parameters.Add(New Data.SqlClient.SqlParameter("bankAccountID", bankAccountID))
         cmd.Parameters.Add(New Data.SqlClient.SqlParameter("CreatedBy", CreatedBy))
         cmd.Parameters.Add(New Data.SqlClient.SqlParameter("LastModifiedBy", LastModifiedBy))
         cmd.Parameters.Add(New Data.SqlClient.SqlParameter("ClientDepositId", clientDepositID))
         If OldRuleID > 0 Then
            cmd.Parameters.Add(New Data.SqlClient.SqlParameter("OldRuleID", OldRuleID))
            cmd.Parameters.Add(New Data.SqlClient.SqlParameter("Locked", Locked))
         End If

         cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
         cmd.Connection.Open()
         Return cmd.ExecuteNonQuery()

      Catch ex As Exception
         Throw ex
      Finally
         cmd.Dispose()
         cmd = Nothing
      End Try

    End Function

    Public Shared Function GetDepositsForRule(ByVal RuleAchId As Integer) As Data.DataTable

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("stp_getRuledDeposits {0}", RuleAchId)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function

    Public Shared Function GetMultiDepositsForRule(ByVal RuleAchId As Integer) As Data.DataTable

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("stp_getRuledMultiDeposits {0}", RuleAchId)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function


    Public Shared Function GetScheduledDepositsPosted(ByVal ClientId As Integer, ByVal newRuleStartDate As String, ByVal newRuleEndDate As String) As Data.DataTable

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("stp_getScheduledDepositsPosted '{0}','{1}',{2}", newRuleStartDate, newRuleEndDate, ClientId)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function

    Public Shared Function GetOtherAdhocsInRange(ByVal ClientId As Integer, ByVal AdHocAchId As Integer, ByVal DepositDate As DateTime, ByVal DaysRange As Integer) As Integer
        Dim sqlStr As New StringBuilder()
        sqlStr.Append("Select count(adhocachid) from tbladhocach where registerid is null ")
        sqlStr.AppendFormat("and depositdate between dateadd(d,-{0}, '{1}') and dateadd(d,{0}, '{1}')", DaysRange, DepositDate.ToShortDateString)
        sqlStr.AppendFormat("and clientid = {0} and adhocachid <> {1}", ClientId, AdHocAchId)
        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = sqlStr.ToString
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Return CInt(cmd.ExecuteScalar)
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try
        Return 0
    End Function

#Region "Conversion by Jim Hope 3/18/2009"
    Public Shared Function getClientDepositInformation(ByVal ClientID As Integer) As DataTable
        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("SELECT CurrentClientStatusID, DepositStartDate, DepositAmount, DepositDay, DepositMethod, BankRoutingNumber, BankAccountNumber, BankType, BankName FROM tblClient WHERE ClientID = {0}", ClientID)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try
    End Function
    Public Shared Function getAllACHsByClientID(ByVal clientID As Integer) As Data.DataTable

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("SELECT BankName, BankRoutingNumber, BankAccountNumber, BankType FROM tblAdHocACH WHERE ClientID = {0}", clientID)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function
    Public Shared Function getOldDepositRulesByClientID(ByVal clientID As Integer, Optional ByVal Current As Boolean = False) As Data.DataTable

        Dim cmd As New Data.SqlClient.SqlCommand()
        Dim dtTemp As New Data.DataTable
        cmd.CommandType = Data.CommandType.Text

        Try
            If Not Current Then 'All rules regardless if active or not
                cmd.CommandText = String.Format("SELECT * FROM tblRuleACH WHERE ClientId = " & clientID)
            Else 'Just active rules
                cmd.CommandText = String.Format("SELECT * FROM tblRuleACH WHERE ClientId = " & clientID & " AND isnull(EndDate, '2050-12-31') > GetDate()")
            End If
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function

    Public Shared Function getOldDepositRuleOverlaps(ByVal newRuleStartDate As DateTime, ByVal newRuleEndDate As DateTime, ByVal ClientID As Integer) As Data.DataTable

        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("stp_getOldDepositRuleOverlaps '{0}','{1}',{2}", newRuleStartDate, newRuleEndDate, ClientID)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            Return dtTemp
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try

    End Function
    Public Shared Function MakeMultiDepositClient(ByVal clientID As Integer, ByVal MakeMulti As Boolean, ByVal UserID As Integer) As Boolean
        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("UPDATE tblClient SET MultiDeposit = {0}, LastModifiedBy = {1}, LastModified = GetDate() WHERE clientid = {2}", IIf(MakeMulti, 1, 0), UserID, clientID)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Return cmd.ExecuteScalar
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try
    End Function
    Public Shared Function PhaseOutOldRule(ByVal EndDate As Date, ByVal ClientID As Integer, Optional ByVal StartDate As Date = #1/1/1900#) As Integer

        Dim strSQL As String = ""

        If StartDate > Now Then
            strSQL = "UPDATE tblRuleACH SET StartDate = '" & DateAdd(DateInterval.Day, -1, Now) & "', EndDate = '" & DateAdd(DateInterval.Day, -1, Now) & "' WHERE clientid = " & ClientID
        Else
            strSQL = "UPDATE tblRuleACH SET EndDate = '" & DateAdd(DateInterval.Day, -1, Now) & "' WHERE clientid = " & ClientID
        End If
        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = strSQL
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Return cmd.ExecuteNonQuery
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try
    End Function
    Public Shared Function getClientBanks(ByVal ClientID As Integer, Optional ByVal RoutingNumber As String = "", Optional ByVal AccountNumber As String = "") As DataTable

        Dim cmd As New Data.SqlClient.SqlCommand()

        If ClientID <> 0 Then 'just look for this clients accounts
            Try
                cmd.CommandType = Data.CommandType.Text
                cmd.CommandText = String.Format("SELECT BankAccountId, ClientID, RoutingNumber, AccountNumber, PrimaryAccount FROM tblClientBankAccount WHERE ClientID = {0}", ClientID)
                cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
                cmd.Connection.Open()
                Dim dtTemp As New Data.DataTable
                dtTemp.Load(cmd.ExecuteReader())
                Return dtTemp
            Catch ex As Exception
                Throw ex
            Finally
                cmd.Dispose()
                cmd = Nothing
            End Try
        Else 'check for duplicate matching accounts
            Try
                cmd.CommandType = Data.CommandType.Text
                cmd.CommandText = "SELECT BankAccountId, ClientID, RoutingNumber, AccountNumber, PrimaryAccount FROM tblClientBankAccount WHERE RoutingNumber = " & RoutingNumber & " AND AccountNumber = " & AccountNumber
                cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
                cmd.Connection.Open()
                Dim dtTemp As New Data.DataTable
                dtTemp.Load(cmd.ExecuteReader())
                Return dtTemp
            Catch ex As Exception
                Throw ex
            Finally
                cmd.Dispose()
                cmd = Nothing
            End Try
        End If
    End Function

    Public Shared Sub ClearMultiDeposit(ByVal ClientID As Integer)
        Dim strSQL As String
        'Clean up tblClient by setting the MultiDeposit flag to false
        Drg.Util.DataAccess.DataHelper.FieldUpdate("tblClient", "MultiDeposit", False, "ClientID = " & ClientID)
        'tblDepositRuleACH
        strSQL = String.Format("DELETE FROM tblDepositRuleACH WHERE ClientDepositId In (Select ClientDepositId From tblClientDepositDay Where ClientId = {0})", ClientID)
        deleteMulti(strSQL)
        'tblClientBankAccount
        strSQL = String.Format("DELETE FROM tblClientBankAccount WHERE ClientID = {0}", ClientID)
        deleteMulti(strSQL)
        'tblClientDepositDay
        strSQL = String.Format("DELETE FROM tblClientDepositDay WHERE ClientId = {0}", ClientID)
        deleteMulti(strSQL)
    End Sub

    Private Shared Function deleteMulti(ByVal strSQL As String) As Integer
        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = strSQL
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            Return cmd.ExecuteNonQuery
        Catch ex As Exception
            Throw ex
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try
    End Function

    Public Shared Sub AuditDeleteAdHocACH(ByVal AdHocAchId As Integer, ByVal UserId As Integer)
        Dim cmd As New Data.SqlClient.SqlCommand()
        Try
            cmd.CommandType = CommandType.Text
            cmd.CommandText = String.Format("Insert Into tblAudit(AuditColumnId, PK, Value, DC, UC, Deleted) Select (Select AuditColumnId From tblAuditColumn Where Name = 'AdHocAchId' and AuditTableId in (Select AuditTableId from tblAuditTable Where Name = 'tblAdHocAch')), '{0}',NULL, Getdate(),  {1}, 1", AdHocAchId, UserId)
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try
    End Sub

#End Region

End Class
