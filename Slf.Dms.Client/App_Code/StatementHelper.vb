Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Text
Imports Drg.Util.DataAccess
Imports System.Data.OleDb
Imports System.Security.Principal

Public Class StatementHelper

#Region "Declare"

    Public Declare Auto Function LogonUser Lib "advapi32.dll" (ByVal lpszUsername As String, ByVal lpszDomain As String, ByVal lpszPassword As String, ByVal dwLogonType As Integer, ByVal dwLogonProvider As Integer, ByRef phToken As IntPtr) As Integer
    Public Declare Auto Function DuplicateToken Lib "advapi32.dll" (ByVal ExistingTokenHandle As IntPtr, ByVal ImpersonationLevel As Integer, ByRef DuplicateTokenHandle As IntPtr) As Integer

#End Region

#Region "Variables"

    Private LOGON32_LOGON_INTERACTIVE As Integer = 2
    Private LOGON32_PROVIDER_DEFAULT As Integer = 0
    Private moImpersonationContext As WindowsImpersonationContext
    Private ds As DataSet

#End Region

#Region "Constants"

    Private Const OLE_CONN_STRING As String = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};" & "Extended Properties='text;HDR=No;FMT=Delimited(|)';"

#End Region

    'Public access point
    Public Function GetTheStatementData(ByVal ClientID As Integer, ByVal Month As String, ByVal SYear As String, Optional ByVal HasData As Boolean = True, Optional ByVal period As String = "Jan16_Jan31_2014") As Data.DataSet
        Dim BasePath As String
        Dim dsStatement As New DataSet
        Dim AttorneyID As Integer
        Dim nMonth As Int32
        Dim SRunDay As Integer
        Dim CAccountNumber As String = ""
        Dim iEOM As DateTime
        Dim EOM As String = ""
        'Dim Period As String
        Dim psMonth As String = Month

        'Get the Client Account Number and necessary stuff
        Try
            AttorneyID = GetAAttorneyID(ClientID)
            nMonth = GetMonthNumber(Month)
            CAccountNumber = CStr(GetAccountNumber(ClientID))
            SRunDay = GetStatementPeriod(CAccountNumber)
            'Get the end of the month day for this month
            iEOM = GetLastDayOfMonth(nMonth, CInt(SYear))
            EOM = Format(iEOM, "dd")
            Period = nMonth.ToString & "/" & SRunDay & "/" & SYear
        Catch ex As Exception
            Alert.Show("Error getting statement period data. " & ex.Message)
        End Try

        'Format the Statement month we are looking for
        Dim SMonthName As String
        If Val(Month) = 0 Then
            SMonthName = Mid(Month, 1, 3)
        Else
            SMonthName = MonthName(Val(Month), True)
        End If

        'Create the statement folder name for the period
        Dim SFolderName As String = "Client_Stmts_" & SMonthName
        If SRunDay >= 16 Then
            SFolderName += "16_" & SMonthName & EOM
        Else
            SFolderName += "1_" & SMonthName & "15"
        End If

        BasePath = ConfigurationManager.AppSettings("StatementPath").ToString()
        Dim BasePath2 = BasePath

        If SYear = Format(Now, "yyyy") Then
            BasePath += SFolderName & "\"
        Else 'It's for a prior period and not this year
            BasePath += "Statement Archives\" & SYear & "\" & SFolderName & "\"
        End If

        'New process using the table data to fill the dataset
        dsStatement = GetDataFromTables(SFolderName.Substring(13) & "_" & SYear, nMonth, SYear, CAccountNumber)

        'Use impersonation to get to statement storage location
        'ImpersonateUser("MorningProcesses", "DMSI", "h0m3run!")

        Try
            'Open and read the text files format string as follows "DMS_StatusRpt_" + "Personal" 
            'or + "Creditors" or + "Trans" or + "_Full month name" +".txt"
            'Dim FileName As String
            'FileName = GetBaseFileName() & "Personal_" & MonthName(nMonth, False) & ".txt"
            'dsStatement.Tables.Add(GetDataTables(BasePath & FileName, CAccountNumber, "Personal"))
            'FileName = GetBaseFileName() & "Creditors_" & MonthName(nMonth, False) & ".txt"
            'dsStatement.Tables.Add(GetDataTables(BasePath & FileName, CAccountNumber, "Creditors"))
            'FileName = GetBaseFileName() & "Trans_" & MonthName(nMonth, False) & ".txt"
            'dsStatement.Tables.Add(GetDataTables(BasePath & FileName, CAccountNumber, "Transactions"))

            'Load the 3 tables with the data for printing
            If dsStatement.Tables(0).Rows.Count = 0 Then
                Return dsStatement
                'Else
                'PopulateTables(dsStatement, ClientID)
            End If

        Catch sx As SqlException
            Alert.Show("SQL Exception from GetTheStatementData. Unable to extract/insert the data into the tables. " & sx.Message & " " & BasePath)
        Catch ex As Exception
            Alert.Show("General Exception from GetTheStatementData. Unable to extract/insert the data into the tables. " & ex.Message & " " & BasePath)
        Finally
            'UndoImpersonation()
        End Try

        Return dsStatement

    End Function

    Public Function GetHeaderData() As DataSet
        Dim dsPersonel As New DataSet
        Dim daPersonel As SqlDataAdapter

        Using cn As New SqlConnection(GetRptConnectionString)
            daPersonel = New SqlDataAdapter("SELECT * FROM tblSingleStatementPersonal", cn)
            daPersonel.Fill(dsPersonel, "Personal")
            cn.Close()
        End Using

        Return dsPersonel
    End Function

    Public Function GetRptConnectionString() As String
        Return ConfigurationManager.AppSettings("connectionstring").ToString()
    End Function

#Region "Get basic data"

    Private Function GetStatementPeriod(ByVal AccountNumber As Integer) As Integer
        Dim StatementRunDay As Integer

        Dim FeeDay As Integer = DataHelper.Nz_string(DataHelper.FieldLookup("tblClient", _
                        "DepositDay", "AccountNumber = " + AccountNumber.ToString()))

        If FeeDay <= 15 Then
            StatementRunDay = 16
        Else
            StatementRunDay = 1
        End If

        Return StatementRunDay

    End Function

    Public Function GetClientCurrentStatus(ByVal ClientID As Integer) As Integer
        Return DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "CurrentClientStatusID", "ClientID = " & ClientID))
    End Function

    Public Function GetAccountNumber(ByVal ClientID As Integer) As Integer
        Return DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + ClientID.ToString()))
    End Function

    Public Function GetAAttorneyID(ByVal ClientID As Integer) As Integer
        Return DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "CompanyID", "ClientID = " + ClientID.ToString()))
    End Function

    Public Function GetMonthNumber(ByVal Month As String) As Integer
        Dim i As Integer

        For i = 1 To 12
            If Month.Length > 3 Then
                If Format(DateSerial(1, i, 1), "MMMM") = Month Then
                    Return i
                End If
            Else
                If Format(DateSerial(1, i, 1), "MMM") = Month Then
                    Return i
                End If
            End If
        Next
        Return 0
    End Function

    Public Function GetLastDayOfMonth(ByVal iMonth As Int32, ByVal iYear As Int32) As DateTime

        'set return value to the last day of the month for any date passed in to the method create a datetime variable set to the passed in date
        Dim dtTo As New DateTime(iYear, iMonth, 1)

        'overshoot the date by a month
        dtTo = dtTo.AddMonths(1)

        'remove all of the days in the next month to get bumped down to the last day of the previous(month)
        dtTo = dtTo.AddDays(-(dtTo.Day))

        'return the last day of the month
        Return dtTo

    End Function

    Public Function GetBaseFileName() As String
        Return "DMS_StatusRpt_"
    End Function

    Public Function GetTheDepositData(ByVal AccountNumber As Integer) As SqlDataReader
        Dim dr As SqlDataReader
        Dim cn As New SqlConnection(GetRptConnectionString)
        cn.Open()
        Dim cmd As SqlCommand
        Dim strSQL As String = "SELECT dd.DepositDay, dd.DepositAmount FROM tblClientDepositDay dd " _
        & "JOIN tblClient c ON c.ClientID = dd.ClientID " _
        & "WHERE c.AccountNumber = " & AccountNumber & " ORDER By dd.DepositDay"
        cmd = New SqlCommand(strSQL, cn)
        dr = cmd.ExecuteReader
        Return dr
    End Function

    Private Function GetMonthName(ByVal nMonth As Int16) As String
        If nMonth = 13 Then nMonth = 1
        Dim sDate As New DateTime(1, nMonth, 1)
        Return sDate.ToString("MMM")
    End Function

#End Region

#Region "Get tables for processing"

    Private Function GetDataTables(ByVal nPath As String, ByVal AccountNumber As Integer, ByVal Type As String) As DataTable

        Dim sr As StreamReader = New StreamReader(nPath)
        Dim line As String
        Dim aRow As DataRow
        Dim tbl As New DataTable
        Dim i As Integer = 0

        Select Case Type
            Case "Personal"
                tbl = CreateBasePersonalTable()
            Case "Creditors"
                tbl = CreateBaseCreditorTable()
            Case "Transactions"
                tbl = CreateBaseTransactionTable()
            Case Else

        End Select

        Try
            Do
                line = sr.ReadLine()
                If line Is Nothing Then
                    Exit Do
                End If

                Dim sAry As String() = Split(line, "|,|")
                sAry(0) = Mid(sAry(0), 2)
                If sAry(0) = CStr(AccountNumber) Then
                    Select Case Type
                        Case "Personal"
                            If sAry.Length > 19 Then
                                sAry(26) = Left(sAry(26), Len(sAry(26)) - 1)
                            Else
                                sAry(18) = Left(sAry(18), Len(sAry(18)) - 1)
                            End If
                        Case "Creditors"
                            sAry(4) = Left(sAry(4), Len(sAry(4)) - 1)
                        Case "Transactions"
                            sAry(5) = Left(sAry(5), Len(sAry(5)) - 1)
                        Case Else

                    End Select

                    aRow = tbl.NewRow
                    For i = 0 To sAry.Length - 1
                        aRow(i) = sAry(i)
                    Next i
                    tbl.Rows.Add(aRow)
                    If Type = "Personal" Then
                        Exit Do
                    End If
                End If
            Loop

            sr.Close()
            Return tbl
        Catch ex As SqlException
            Alert.Show("The statement data fetch has generated an error. " & ex.Message)
            Return Nothing
        End Try
    End Function

    Private Function GetAttorneyTable(ByVal AttorneyID As Integer) As DataTable
        Dim dsTemp As New Data.DataSet
        Dim strSQL As String = "SELECT c.Name, a.Address1, a.Address2, a.City, a.STATE, a.Zipcode " _
       & "FROM tblCompany c " _
       & "JOIN tblCompanyAddresses a ON a.companyid = c.companyid " _
       & "WHERE a.addresstypeid = 2 " _
       & "AND c.CompanyID = " & AttorneyID

        Try
            Using cnSQL As New SqlConnection(GetRptConnectionString)
                Dim adapter As New SqlDataAdapter()
                adapter.SelectCommand = New SqlCommand(strSQL, cnSQL)
                adapter.SelectCommand.CommandTimeout = 180
                dsTemp = New Data.DataSet
                adapter.Fill(dsTemp)
                dsTemp.Tables(0).TableName = "Attorney"
            End Using
            Return dsTemp.Tables(0)
        Catch ex As SqlException
            Alert.Show("There has been an error retrieving the Attorney information.")
            Return Nothing
        End Try

    End Function

#End Region

#Region "Create Tables"

    Private Function CreateBaseTransactionTable() As DataTable
        Dim objDataTable As New DataTable

        With objDataTable.Columns
            .Add("AccountNumber", String.Empty.GetType())
            .Add("Date", String.Empty.GetType())
            .Add("Description", String.Empty.GetType())
            .Add("Amount", String.Empty.GetType())
            .Add("Account Balance", String.Empty.GetType())
            .Add("Balance Owed", String.Empty.GetType())
        End With

        objDataTable.TableName = "Trans"
        Return objDataTable
    End Function

    Private Function CreateBasePersonalTable() As DataTable
        Dim objDataTable As New DataTable

        With objDataTable.Columns
            .Add("AccountNumber", String.Empty.GetType())   'Account Number 0
            .Add("Company", String.Empty.GetType())            'Attorney number 1
            .Add("Name", String.Empty.GetType())                 'Client Name 2
            .Add("Street", String.Empty.GetType())                'Address 3 
            .Add("City", String.Empty.GetType())                   'City 4
            .Add("ST", String.Empty.GetType())                    'State 5
            .Add("Zip", String.Empty.GetType())                    'Zip 6
            .Add("Period", String.Empty.GetType())                'Transaction Period 7
            .Add("DepDate", String.Empty.GetType())             'Deposit Date 8
            .Add("DepAmount", String.Empty.GetType())         'Deposit Amount 9
            .Add("Unknown1", String.Empty.GetType())          'Unknown1 10
            .Add("ACH", String.Empty.GetType())                  'ACH 11
            .Add("NoChecks", String.Empty.GetType())           'No check flag 12
            .Add("Payee", String.Empty.GetType())                'Whomever check is made out to Client or Atty 13
            .Add("cslocation1", String.Empty.GetType())         'Mailing Address 14
            .Add("cslocation2", String.Empty.GetType())         'Mailing City, State, Zip 15
            .Add("desc1", String.Empty.GetType())                'Client Services Phone 16
            .Add("desc2", String.Empty.GetType())                'Office hours 17
            .Add("desc3", String.Empty.GetType())                'UnUsed 18
            .Add("DepDate1", String.Empty.GetType())           'for 1st deposit day 19
            .Add("DepAmt1", String.Empty.GetType())            '1st Deposit Amount 20
            .Add("DepDate2", String.Empty.GetType())           '2nd Deposit Day 21
            .Add("DepAmt2", String.Empty.GetType())            '2nd Deposit Amount 22
            .Add("DepDate3", String.Empty.GetType())           '3rd deposit day 23
            .Add("DepAmt3", String.Empty.GetType())            '3rd Deposit Amount 24
            .Add("DepDate4", String.Empty.GetType())           '4th Deposit Day 25
            .Add("DepAmt4", String.Empty.GetType())            '4th Deposit Amount 26
        End With

        objDataTable.TableName = "Personal"
        Return objDataTable
    End Function

    Private Function CreateBaseCreditorTable() As DataTable
        Dim objDataTable As New DataTable

        With objDataTable.Columns
            .Add("AccountNumber", String.Empty.GetType())
            .Add("Creditor", String.Empty.GetType())
            .Add("AcctNo", String.Empty.GetType())
            .Add("Status", String.Empty.GetType())
            .Add("Balance", String.Empty.GetType())
        End With

        objDataTable.TableName = "Creditor"
        Return objDataTable
    End Function

    Public Sub CreateTheDBTables(ByVal ClientID As Integer, ByVal Month As Integer, ByVal Year As String, Optional ByVal HasData As Boolean = True)

        Dim AccountNumber As Integer = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " & ClientID)
        Dim DepositDay As Integer = DataHelper.FieldLookup("tblClient", "DepositDay", "ClientID = " & ClientID)
        Dim StmtDate As Date = CStr(Val(Month)) & "/" & CStr(Val(DepositDay)) & "/" & Year

        Using cn As New SqlConnection(GetRptConnectionString)
            cn.Open()
            Using cmd As New SqlCommand("stp_SingleStatementBuilder", cn)
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.AddWithValue("@AccountNumber", AccountNumber)
                cmd.Parameters.AddWithValue("@date1", StmtDate)
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Function PopulateTables(ByVal dsStatement As DataSet, ByVal ClientID As Integer) As Boolean
        Dim strSQL As String = ""
        Dim row As DataRow

        Try
            Using cn As New SqlConnection(GetRptConnectionString)
                cn.Open()
                Dim cmd As New SqlCommand("", cn)
                cmd.CommandType = CommandType.Text

                'Truncate the tables
                cmd.CommandText = "Truncate table tblSingleStatementResults"
                cmd.ExecuteNonQuery()
                cmd.CommandText = "Truncate table tblSingleStatementPersonal"
                cmd.ExecuteNonQuery()
                cmd.CommandText = "Truncate table tblSingleStatementCreditor"
                cmd.ExecuteNonQuery()

                'Fill the tblPersonal with the data from the dataset Personal table
                strSQL += "INSERT INTO tblSingleStatementPersonal ("
                strSQL += "ClientID, "
                strSQL += "AccountNumber, "     'Account Number 0
                strSQL += "BaseCompany, "        'Attorney number 1
                strSQL += "Name, "                 'Client Name 2
                strSQL += "Street, "                'Address 3 
                strSQL += "City, "                   'City 4
                strSQL += "ST, "                    'State 5
                strSQL += "Zip, "                    'Zip 6
                strSQL += "Period, "                'Transaction Period 7
                strSQL += "DepDate, "             'Deposit Date 8
                strSQL += "DepAmt, "         'Deposit Amount 9
                strSQL += "PFOBalance, "        'Unknown1 10
                strSQL += "ACH, "                  'ACH 11
                strSQL += "NoChecks, "           'No check flag 12
                strSQL += "Payee, "                'Whomever check is made out to Client or Atty 13
                strSQL += "cslocation1, "         'Mailing Address 14
                strSQL += "cslocation2, "         'Mailing City, State, Zip 15
                strSQL += "desc1, "                'Client Services Phone 16
                strSQL += "desc2, "                'Office hours 17
                strSQL += "desc3) "                'UnUsed 18
                'strSQL += "DepDate1, "           'for 1st deposit day 19
                'strSQL += "DepAmt1, "            '1st Deposit Amount 20
                'strSQL += "DepDate2, "           '2nd Deposit Day 21
                'strSQL += "DepAmt2, "            '2nd Deposit Amount 22
                'strSQL += "DepDate3, "           '3rd deposit day 23
                'strSQL += "DepAmt3, "            '3rd Deposit Amount 24
                'strSQL += "DepDate4, "           '4th Deposit Day 25
                'strSQL += "DepAmt4) "            '4th Deposit Amount 26
                strSQL += "VALUES ("
                With dsStatement.Tables(0).Rows(0)
                    strSQL += ClientID & ", "
                    strSQL += .Item("AccountNumber") & ", "
                    strSQL += .Item("Company") & ", "
                    strSQL += "'" & .Item("Name") & "', "
                    strSQL += "'" & .Item("Street") & "', "
                    strSQL += "'" & .Item("City") & "', "
                    strSQL += "'" & .Item("ST") & "', "
                    strSQL += "'" & .Item("Zip") & "', "
                    strSQL += "'" & .Item("Period") & "', "
                    If .Item("DepDate").ToString().Contains("February 30") Then
                        If Date.IsLeapYear(Right(.Item("DepDate").ToString, 4)) Then
                            strSQL += "'February 29, " & Right(.Item("DepDate").ToString(), 4) & "', "
                            UpdatePTable(dsStatement, "'February 29, " & Right(.Item("DepDate").ToString(), 4))
                        Else
                            strSQL += "'February 28, " & Right(.Item("DepDate").ToString(), 4) & "', "
                            UpdatePTable(dsStatement, "'February 28, " & Right(.Item("DepDate").ToString(), 4))
                        End If
                    Else
                        strSQL += "'" & .Item("DepDate") & "', "
                    End If
                    strSQL += .Item("DepAmount") & ", "
                    strSQL += "'" & .Item("Unknown1") & "', "
                    strSQL += "'" & .Item("ACH") & "', "
                    strSQL += "'" & .Item("NoChecks") & "', "
                    strSQL += "'" & .Item("Payee") & "', "
                    strSQL += "'" & .Item("cslocation1") & "', "
                    strSQL += "'" & .Item("cslocation2") & "', "
                    strSQL += "'" & .Item("desc1") & "', "
                    strSQL += "'" & .Item("desc2") & "', "
                    strSQL += "'" & .Item("desc3") & "') "
                    'strSQL += .Item("DepDate1") & ", "
                    'strSQL += .Item("DepAmt1") & ", "
                    'strSQL += .Item("DepDate2") & ", "
                    'strSQL += .Item("DepAmt2") & ", "
                    'strSQL += .Item("DepDate3") & ", "
                    'strSQL += .Item("DepAmt3") & ", "
                    'strSQL += .Item("DepDate4") & ", "
                    'strSQL += .Item("DepAmt4") & ") "
                End With
                cmd.CommandText = strSQL
                strSQL = ""
                cmd.ExecuteNonQuery()

                'Fill the tblStatementResults with data from the dataset transactions table
                For Each row In dsStatement.Tables(2).Rows
                    strSQL += "INSERT INTO tblSingleStatementResults ("
                    strSQL += "AccountNumber, "
                    strSQL += "TransactionDate, "
                    strSQL += "EntryTypeName, "
                    strSQL += "Amount, "
                    strSQL += "SDABalance, "
                    strSQL += "PFOBalance) "
                    strSQL += "VALUES ("
                    strSQL += row.Item("AccountNumber") & ", "
                    strSQL += "'" & row.Item("Date") & "', "
                    strSQL += "'" & row.Item("Description") & "', "
                    strSQL += row.Item("Amount") & ", "
                    strSQL += row.Item("Account Balance") & ", "
                    strSQL += row.Item("Balance Owed") & ")"
                    cmd.CommandText = strSQL
                    strSQL = ""
                    cmd.ExecuteNonQuery()
                Next

                'Fill the tblStatementCreditors with data from the dataset Creditors table
                For Each row In dsStatement.Tables(1).Rows
                    strSQL += "INSERT INTO tblSingleStatementCreditor ("
                    strSQL += "Acct_No, "
                    strSQL += "Cred_Name, "
                    strSQL += "Orig_Acct_No, "
                    strSQL += "Status, "
                    strSQL += "Balance) "
                    strSQL += "VALUES ("
                    strSQL += row.Item("AccountNumber") & ", "
                    strSQL += "'" & row.Item("AcctNo") & "', "
                    strSQL += "'" & Replace(row.Item("Creditor"), "'", "''") & "', "
                    strSQL += "'" & row.Item("Status") & "', "
                    strSQL += row.Item("Balance") & ")"
                    cmd.CommandText = strSQL
                    strSQL = ""
                    cmd.ExecuteNonQuery()
                Next
            End Using
        Catch sx As SqlException
            Alert.Show("SQL Exception from PopulateTables. Error inserting data: " & sx.Message)
        Catch ex As Exception
            Alert.Show("General exception inserting data from PopulateTables: " & ex.Message)
        End Try

    End Function

#End Region

    Public Function GetRemitAddress(ByVal CompanyID As Integer, ByVal ACH As String) As String
        Dim Address As String

        If ACH = "N" Then
            Address = Trim(DataHelper.FieldLookup("tblCompany", "Name", "CompanyID = " & CompanyID)) & vbCrLf
            If CompanyID > 2 Then
                Address += "c/o Lexxiom Payment Systems Inc." & vbCrLf
            End If
            Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "Address1", "CompanyID = " & CompanyID & " AND AddressTypeID = 2")) & " " & vbCrLf

            If DataHelper.FieldLookup("tblCompanyAddresses", "Address2", "CompanyID = " & CompanyID & " AND AddressTypeID = 2") <> "" Then
                Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "Address2", "CompanyID = " & CompanyID & " AND AddressTypeID = 2")) & vbCrLf
            End If
            Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "City", "CompanyID = " & CompanyID & " AND AddressTypeID = 2")) & ", "
            Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "State", "CompanyID = " & CompanyID & " AND AddressTypeID = 2")) & " "
            Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "ZipCode", "CompanyID = " & CompanyID & " AND AddressTypeID = 2"))
        Else
            Address = Trim(DataHelper.FieldLookup("tblCompany", "Name", "CompanyID = " & CompanyID)) & vbCrLf
            Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "Address1", "CompanyID = " & CompanyID & " AND AddressTypeID = 2")) & " " & vbCrLf
            If DataHelper.FieldLookup("tblCompanyAddresses", "Address2", "CompanyID = " & CompanyID & " AND AddressTypeID = 2") <> "" Then
                Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "Address2", "CompanyID = " & CompanyID & " AND AddressTypeID = 2")) & " " & vbCrLf
            End If
            Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "City", "CompanyID = " & CompanyID & " AND AddressTypeID = 2")) & ", "
            Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "State", "CompanyID = " & CompanyID & " AND AddressTypeID = 2")) & " "
            Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "ZipCode", "CompanyID = " & CompanyID & " AND AddressTypeID = 2"))
        End If

        Return Address

    End Function

    Public Function GetClientSvcAddress(ByVal CompanyID As Integer, ByVal ACH As String) As String
        Dim Address As String

        Address = Trim(DataHelper.FieldLookup("tblCompanyAddresses", "Address1", "CompanyID = " & CompanyID & " AND AddressTypeID = 6")) & vbCrLf
        Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "Address2", "CompanyID = " & CompanyID & " AND AddressTypeID = 6")) '& vbCr
        Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "City", "CompanyID = " & CompanyID & " AND AddressTypeID = 6")) & ", "
        Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "State", "CompanyID = " & CompanyID & " AND AddressTypeID = 6")) & " "
        Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "ZipCode", "CompanyID = " & CompanyID & " AND AddressTypeID = 6"))

        Return Address

    End Function

    Public Function GetClientSvcLongAdd(ByVal companyid As Integer, ByVal ACH As String) As String
        Dim Address As String

        Address = Trim(DataHelper.FieldLookup("tblCompanyAddresses", "Address1", "CompanyID = " & companyid & " AND AddressTypeID = 6")) & ", "
        Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "Address2", "CompanyID = " & companyid & " AND AddressTypeID = 6")) & ", "
        Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "City", "CompanyID = " & companyid & " AND AddressTypeID = 6")) & ", "
        Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "State", "CompanyID = " & companyid & " AND AddressTypeID = 6")) & " "
        Address += Trim(DataHelper.FieldLookup("tblCompanyAddresses", "ZipCode", "CompanyID = " & companyid & " AND AddressTypeID = 6"))

        Return Address

    End Function

    Public Function GrabTheData() As DataSet
        Dim ds As DataSet
        Dim ds2 As New DataSet

        ds = CancellationRptHelper.getReportDataSet("Select * From tblSingleStatementPersonal", "Personal")
        ds2.Tables.Add(ds.Tables(0).Copy)
        ds = Nothing
        ds = CancellationRptHelper.getReportDataSet("Select * From tblSingleStatementCreditor", "Creditor")
        ds2.Tables.Add(ds.Tables(0).Copy)
        ds = Nothing
        ds = CancellationRptHelper.getReportDataSet("Select * From tblSingleStatementCreditor", "Results")
        ds2.Tables.Add(ds.Tables(0).Copy)
        ds = Nothing

        'If ds2.Tables.Count < 3 Then 'No statement was created so generate one

        'End If

        Return ds2

    End Function

    Public Function ConvertToDate(ByVal _date As String) As String
        Dim TrueDate As String
        Dim i As Integer = 0
        Dim d(3) As String
        Dim split As String() = _date.Split(New [Char]() {" "c, ","c})
        Dim s As String
        For Each s In split
            d(i) = s
            i += 1
        Next

        TrueDate += Mid(d(0), 1, 3) & ". "
        TrueDate += d(1) & ", "
        TrueDate += d(3)

        Return TrueDate
    End Function

    Private Function UpdatePTable(ByVal dsStatement As DataSet, ByVal DepositDate As String) As DataSet
        dsStatement.Tables(0).Rows(0).Item(8) = DepositDate
        dsStatement.AcceptChanges()
        Return ds
    End Function

    Private Function GenerateTransactionDates(ByVal Period As String) As String
        Dim sDate As String = ""
        Dim EOM As String
        Dim iEOM As DateTime
        Dim sYear1 As String

        Dim sYear As String = Right(Period, 4)
        Dim sMonth As String = Left(Period, 3)
        Dim nMonth As Int16 = GetMonthNumber(sMonth)
        sYear1 = sYear

        If nMonth = 1 Then
            sMonth = "Dec"
            sYear = CInt(sYear - 1)
            nMonth = 12
        Else
            If nMonth = 13 Then nMonth = 1
            sMonth = GetMonthName(nMonth - 1)
            nMonth -= 1
        End If

        If Period.Contains("15") Then
            'This is the 1st - EOM of last months transactions
            iEOM = GetLastDayOfMonth(nMonth, CInt(sYear))
            EOM = Format(iEOM, "dd")
            sDate = sMonth & ". 01, " & sYear & "|" & sMonth & ". " & EOM & ", " & sYear
        Else
            'This is the 16th of last month - the 15th of  this month
            sDate = sMonth & ". 16, " & sYear & "|" & GetMonthName(nMonth + 1) & ". 15, " & sYear1
        End If
        Return sDate
    End Function

#Region "Get the statement data from the tables"

    Public Function GetDataFromTables(ByVal Period As String, ByVal nMonth As Integer, ByVal sYear As String, ByVal AccountNumber As String) As DataSet
        Dim ds As New DataSet
        Dim TransactionDates As String
        Dim Params(1) As SqlClient.SqlParameter
        Dim EOM As String
        Dim iEOM As DateTime
        Dim x As Int16

        iEOM = GetLastDayOfMonth(nMonth, CInt(sYear))
        EOM = Format(iEOM, "dd")

        Period = "Jan16_Jan31_2014"

        Try
            'Get the Personal table for this client
            Params(0) = New SqlClient.SqlParameter("@AccountNumber", SqlDbType.Int)
            Params(0).Value = AccountNumber
            Params(1) = New SqlClient.SqlParameter("@StmtPeriod", SqlDbType.Text)
            Params(1).Value = Period
            ds.Tables.Add(SqlHelper.GetDataTable("stp_GetStmtPersonal_New", CommandType.StoredProcedure, Params))
            ds.Tables(0).TableName = "Personal"

            'Get the Creditor tables for this client
            ReDim Params(1)
            Params(0) = New SqlClient.SqlParameter("@AccountNumber", SqlDbType.Int)
            Params(0).Value = AccountNumber
            Params(1) = New SqlClient.SqlParameter("@StmtPeriod", SqlDbType.Text)
            Params(1).Value = Period
            ds.Tables.Add(SqlHelper.GetDataTable("stp_GetStmtCreditors_New", CommandType.StoredProcedure, Params))
            ds.Tables(1).TableName = "Creditor"
            'Setup the transaction period From and To
            TransactionDates = GenerateTransactionDates(Period)
            Dim dates As String() = TransactionDates.Split(New Char() {"|"c})
            Dim StartDate As DateTime = ConvertToDate(dates(0))
            Dim EndDate As DateTime = ConvertToDate(dates(1))
            'Get the Transactions for the period
            ReDim Params(3)
            Params(0) = New SqlClient.SqlParameter("@AccountNumber", SqlDbType.Int)
            Params(0).Value = AccountNumber
            Params(1) = New SqlClient.SqlParameter("@StmtPeriod", SqlDbType.Text)
            Params(1).Value = Period
            Params(2) = New SqlClient.SqlParameter("@StartDate", SqlDbType.DateTime)
            Params(2).Value = StartDate
            Params(3) = New SqlClient.SqlParameter("@EndDate", SqlDbType.DateTime)
            Params(3).Value = EndDate
            ds.Tables.Add(SqlHelper.GetDataTable("stp_GetStmtResults_New", CommandType.StoredProcedure, Params))
            ds.Tables(2).TableName = "Trans"
            For x = 0 To ds.Tables(2).Rows.Count - 1
                If Val(ds.Tables(2).Rows(x).Item("Amount")) < 1 Then
                    ds.Tables(2).Rows(x).Item("Amount") = ds.Tables(2).Rows(x).Item("Amount") * -1
                    ds.Tables(2).Rows(x).AcceptChanges()
                End If
            Next

            Return ds

        Catch ex As SqlException

        End Try

    End Function

#End Region

#Region "Impersonate User"

    Private Function ImpersonateUser(ByVal userName As String, ByVal domain As String, ByVal password As String) As Boolean
        '------------------------------------------------
        'PURPOSE: Impersonate a specific user
        'INPUTS: username(str), domain (str), pwd(str)
        'OUTPUTS: Boolean
        '------------------------------------------------
        Try
            Dim otempWindowsIdentity As WindowsIdentity
            Dim token As IntPtr
            Dim tokenDuplicate As IntPtr
            If LogonUser(userName, domain, password, LOGON32_LOGON_INTERACTIVE, _
            LOGON32_PROVIDER_DEFAULT, token) <> 0 Then
                If DuplicateToken(token, 2, tokenDuplicate) <> 0 Then
                    otempWindowsIdentity = New WindowsIdentity(tokenDuplicate)
                    moImpersonationContext = otempWindowsIdentity.Impersonate()
                    If moImpersonationContext Is Nothing Then
                        ImpersonateUser = False
                    Else
                        ImpersonateUser = True
                    End If
                Else
                    ImpersonateUser = False
                End If
            Else
                ImpersonateUser = False
            End If
        Catch ex As Exception
            Throw New System.Exception("Error Occurred in ImpersonateUser() : " & ex.ToString)
        End Try
    End Function

    Private Sub UndoImpersonation()
        '------------------------------------------------
        'PURPOSE: Undo the impersonation
        'INPUTS: None
        'OUTPUTS: None
        '------------------------------------------------

        Try
            moImpersonationContext.Undo()
        Catch ex As Exception
            Throw New System.Exception("Error Occurred in undoImpersonation() : " & ex.ToString)
        End Try

    End Sub

#End Region

#Region "Testing Area************"

    <STAThread()> _
Private Sub OleSample(ByVal nPath As String, ByVal nFileName As String)

        Try
            If Not File.Exists(nPath) Then
                Alert.Show("we have a file doesn't exist issue here.")
            End If
            Dim sDataSource As String = nPath
            Dim sConn As String = [String].Format(OLE_CONN_STRING, nPath)
            Using conn As New OleDbConnection(sConn)
                Dim cmdSelect As New OleDbCommand("SELECT * FROM " & nFileName, conn)
                conn.Open()
                Dim reader As OleDbDataReader = cmdSelect.ExecuteReader()
                While reader.Read()
                    Dim iFieldCount As Integer = reader.FieldCount
                    Dim sb As New StringBuilder()
                    For i As Integer = 0 To iFieldCount - 1
                        sb.Append(reader.GetValue(i).ToString())
                        sb.Append(vbTab)
                    Next
                    Alert.Show(sb.ToString())
                End While
                reader.Close()
            End Using
            Console.ReadLine()
        Catch ex As Exception
            Alert.Show(ex.Message)
        Finally

        End Try
    End Sub

#End Region

End Class