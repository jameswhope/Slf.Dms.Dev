Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.Data.SqlClient

Namespace App_Code

    Public Class HoldbackHelper

        Public Shared Function GetDailyAgencyPayouts(ByVal today As DateTime) As DataTable
            Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
            Dim dtPayouts1 As DataTable

            Try
                Dim strSQL As String = "stp_GetDailyAgencyPayouts"
                Dim param As New SqlParameter
                Using cn As New SqlConnection(connectionString)
                    cn.Open()
                    Using cmd As New SqlCommand(strSQL, cn)
                        cmd.CommandType = CommandType.StoredProcedure
                        'Add the parameter 
                        cmd.Parameters.Add("@sDate", SqlDbType.DateTime)
                        cmd.Parameters("@sDate").Value = Format(Now, "MM/dd/yyyy")
                        dtPayouts1 = New DataTable
                        Using rdr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                            dtPayouts1.Load(rdr)
                            Return dtPayouts1
                        End Using
                    End Using
                End Using

            Catch ex As Exception
                Alert.Show("Error reading daily returns data 1. " & ex.Message)
            End Try
            dtPayouts1 = Nothing
            Return dtPayouts1
        End Function

        Public Shared Function GetDailyAttorneyPayouts(ByVal today As DateTime) As DataTable
            Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
            Dim dtPayouts2 As DataTable

            Try
                Dim strSQL As String = "stp_GetDailyAttorneyPayouts"
                Dim param As New SqlParameter
                Using cn As New SqlConnection(connectionString)
                    cn.Open()
                    Using cmd As New SqlCommand(strSQL, cn)
                        cmd.CommandType = CommandType.StoredProcedure
                        'Add the parameter 
                        cmd.Parameters.Add("@sDate", SqlDbType.DateTime)
                        cmd.Parameters("@sDate").Value = Format(Now, "MM/dd/yyyy")
                        dtPayouts2 = New DataTable
                        Using rdr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                            dtPayouts2.Load(rdr)
                            Return dtPayouts2
                        End Using
                    End Using
                End Using

            Catch ex As Exception
                Alert.Show("Error reading daily returns data 2. " & ex.Message)
            End Try
            dtPayouts2 = Nothing
            Return dtPayouts2
        End Function

        Public Shared Function GetDailyNegativeBal() As DataTable
            Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
            Dim dtPayouts2 As DataTable

            Try
                Dim strSQL As String = "stp_GetDailyNegativeBal"
                Using cn As New SqlConnection(connectionString)
                    cn.Open()
                    Using cmd As New SqlCommand(strSQL, cn)
                        cmd.CommandType = CommandType.StoredProcedure
                        dtPayouts2 = New DataTable
                        Using rdr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                            dtPayouts2.Load(rdr)
                            Return dtPayouts2
                        End Using
                    End Using
                End Using

            Catch ex As Exception
                Alert.Show("Error reading daily AR Balances. " & ex.Message)
            End Try
            dtPayouts2 = Nothing
            Return dtPayouts2
        End Function

        Public Shared Function GetOAHold() As DataTable
            Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
            Dim dtOA As DataTable

            Try
                Dim strSQL As String = "stp_GetAttorney_OA_TransactionsIn"
                Dim param As New SqlParameter
                Using cn As New SqlConnection(connectionString)
                    cn.Open()
                    Using cmd As New SqlCommand(strSQL, cn)
                        cmd.CommandType = CommandType.StoredProcedure
                        'Add the parameter 
                        cmd.Parameters.Add("@sDate", SqlDbType.DateTime)
                        If connectionString.ToUpper.Contains("SQL2") Then
                            cmd.Parameters("@sDate").Value = Format(DateAdd(DateInterval.Day, -1, Now), "MM/dd/yyyy")
                        Else
                            cmd.Parameters("@sDate").Value = Format(Now, "MM/dd/yyyy")
                        End If
                        dtOA = New DataTable
                        Using rdr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                            dtOA.Load(rdr)
                            Return dtOA
                        End Using
                    End Using
                End Using

            Catch ex As Exception
                Alert.Show("Error reading daily Operating account data. " & ex.Message)
            End Try
            dtOA = Nothing
            Return dtOA
        End Function

        Private Shared Function IncludeARNegBalances(ByVal dt1 As DataTable, ByVal dt2 As DataTable) As DataTable
            Dim dRow1 As DataRow()
            Dim dRow2 As DataRow
            Try
                For Each dRow2 In dt2.Rows
                    If Not dRow2.IsNull("Balance") Then
                        dRow1 = dt1.Select("Accountnumber = '" & dRow2.Item(3) & "'")
                        If dRow1.Length > 0 Then
                            dRow1(0).Item("ARBalance") = dRow2.Item(2)
                        End If
                    End If
                Next
            Catch ex As Exception
                Alert.Show("Error posting agency's daily negative AR balances. " & ex.Message)
            End Try
            Return dt1
        End Function

        Public Shared Function ProcessPayeeTransactions(ByVal Pct As Double, ByVal AccountNumber As String) As DataTable
            Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
            Dim dt As DataTable
            Dim strSQL As String = ""
            Dim param As SqlParameter

            'Get individual payouts by agency
            Try
                strSQL = "stp_GetIndividualAgencyPayouts"
                param = New SqlParameter
                Using cn As New SqlConnection(connectionString)
                    cn.Open()
                    Using cmd As New SqlCommand(strSQL, cn)
                        cmd.CommandType = CommandType.StoredProcedure

                        'Add the parameters
                        cmd.Parameters.Add("@sDate", SqlDbType.DateTime)
                        cmd.Parameters("@sDate").Value = Format(DateAdd(DateInterval.Day, -1, Now), "MM/dd/yyyy")
                        cmd.Parameters.Add("@pct", SqlDbType.Real)
                        cmd.Parameters("@pct").Value = Pct
                        cmd.Parameters.Add("@AccountNumber", SqlDbType.VarChar)
                        cmd.Parameters("@AccountNumber").Value = AccountNumber
                        dt = New DataTable
                        Using rdr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                            dt.Load(rdr)
                            Return dt
                        End Using
                    End Using
                End Using
                param = Nothing

                dt = Nothing
                Return dt

            Catch ex As Exception
                Alert.Show("Error reading daily all of the Agency payouts. " & ex.Message)
            End Try
            dt = Nothing
            Return dt
        End Function

        Public Shared Function ProcessOATransactions(ByVal Pct As Double, ByVal AccountNumber As String) As DataTable
            Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
            Dim dt As DataTable
            Dim strSQL As String = ""
            Dim param As SqlParameter

            'Get individual payouts by attorney into OA
            Try
                strSQL = "stp_GetIndividualAttorneyPayouts"
                param = New SqlParameter
                Using cn As New SqlConnection(connectionString)
                    cn.Open()
                    Using cmd As New SqlCommand(strSQL, cn)
                        cmd.CommandType = CommandType.StoredProcedure

                        'Add the parameters
                        cmd.Parameters.Add("@sDate", SqlDbType.DateTime)
                        If cn.ConnectionString.ToUpper.Contains("SQL2") Then
                            cmd.Parameters("@sDate").Value = Format(DateAdd(DateInterval.Day, -1, Now), "MM/dd/yyyy")
                        Else
                            cmd.Parameters("@sDate").Value = Format(Now, "MM/dd/yyyy")
                        End If
                        cmd.Parameters.Add("@pct", SqlDbType.Real)
                        cmd.Parameters("@pct").Value = Pct
                        cmd.Parameters.Add("@AccountNumber", SqlDbType.VarChar)
                        cmd.Parameters("@AccountNumber").Value = AccountNumber
                        dt = New DataTable
                        Using rdr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                            dt.Load(rdr)
                            Return dt
                        End Using
                    End Using
                End Using
                param = Nothing

                dt = Nothing
                Return dt

            Catch ex As Exception
                Alert.Show("Error reading daily the Attorney OA payouts. " & ex.Message)
            End Try
            dt = Nothing
            Return dt
        End Function

        Public Shared Function InsertWithholding(ByVal dt As DataTable, ByVal AccountNumber As String, ByVal UserID As Integer, ByVal CompanyToID As Integer, ByVal Type As Integer) As Boolean
            Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
            Dim dRow As DataRow = Nothing
            Dim strSQL As String = ""
            Dim param As SqlParameter = Nothing

            If Type = 1 Then
                Try
                    For Each dRow In dt.Rows
                        'For Each topRow In dt.Rows
                        param = New SqlParameter
                        Using cn As New SqlConnection(connectionString)
                            cn.Open()
                            strSQL = "stp_InsertDailyAgencyWithholding"
                            Using cmd As New SqlCommand(strSQL, cn)
                                cmd.CommandType = CommandType.StoredProcedure
                                'Add the parameters
                                cmd.Parameters.Add("@NR", SqlDbType.Int)
                                cmd.Parameters("@NR").Value = CInt(Val(dRow("NachaRegister").ToString))
                                cmd.Parameters.Add("@NachaRegisterID", SqlDbType.Int)
                                cmd.Parameters("@NachaRegisterID").Value = CInt(Val(dRow("NachaRegisterID")))
                                cmd.Parameters.Add("@CompanyID", SqlDbType.Int)
                                cmd.Parameters("@CompanyID").Value = CompanyToID
                                cmd.Parameters.Add("@AmountWithHeld", SqlDbType.Real)
                                cmd.Parameters("@AmountWithHeld").Value = Val(dRow("WithHold"))
                                cmd.Parameters.Add("@Balance", SqlDbType.Real)
                                cmd.Parameters("@Balance").Value = Val(dRow("Balance"))
                                cmd.Parameters.Add("@WithheldBy", SqlDbType.Int)
                                cmd.Parameters("@WithheldBy").Value = UserID
                                cmd.Parameters.Add("@WithheldFrom", SqlDbType.NVarChar)
                                cmd.Parameters("@WithheldFrom").Value = dRow("Name").ToString
                                'Insert the transaction and update the old transaction with the data
                                cmd.ExecuteNonQuery()
                                cmd.Parameters.Clear()
                            End Using
                        End Using
                    Next
                    Return True
                Catch ex As Exception
                    Return False
                End Try
            ElseIf Type = 2 Then
                Try
                    For Each dRow In dt.Rows
                        'For Each topRow In dt.Rows
                        param = New SqlParameter
                        Using cn As New SqlConnection(connectionString)
                            cn.Open()
                            strSQL = "stp_InsertDailyGCAWithholding"
                            Using cmd As New SqlCommand(strSQL, cn)
                                cmd.CommandType = CommandType.StoredProcedure
                                'Add the parameters
                                cmd.Parameters.Add("@NR", SqlDbType.Int)
                                cmd.Parameters("@NR").Value = CInt(Val(dRow("NachaRegister").ToString))
                                cmd.Parameters.Add("@NachaRegisterID", SqlDbType.Int)
                                cmd.Parameters("@NachaRegisterID").Value = CInt(Val(dRow("NachaRegisterID")))
                                cmd.Parameters.Add("@CompanyID", SqlDbType.Int)
                                cmd.Parameters("@CompanyID").Value = CompanyToID
                                cmd.Parameters.Add("@AmountWithHeld", SqlDbType.Real)
                                cmd.Parameters("@AmountWithHeld").Value = Val(dRow("WithHold"))
                                cmd.Parameters.Add("@Balance", SqlDbType.Real)
                                cmd.Parameters("@Balance").Value = Val(dRow("Balance"))
                                cmd.Parameters.Add("@WithheldBy", SqlDbType.Int)
                                cmd.Parameters("@WithheldBy").Value = UserID
                                cmd.Parameters.Add("@WithheldFrom", SqlDbType.NVarChar)
                                cmd.Parameters("@WithheldFrom").Value = dRow("Name").ToString
                                cmd.Parameters.Add("@WithholdFromOA", SqlDbType.Int)
                                cmd.Parameters("@WithholdFromOA").Value = 1
                                'Insert the transaction and update the old transaction with the data
                                cmd.ExecuteNonQuery()
                                cmd.Parameters.Clear()
                            End Using
                        End Using
                    Next
                    Return True
                Catch ex As Exception
                    Return False
                End Try
            End If
            Return False
        End Function

        Public Shared Function GetAttyAcctRouting(ByVal CompanyID As Integer) As String
            Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
            Dim strSQL As String = "SELECT RoutingNumber + '|' + AccountNumber FROM tblCompany WHERE CompanyID = " & CompanyID
            Using cn As New SqlConnection(connectionString)
                cn.Open()
                Using cmd As New SqlCommand(strSQL, cn)
                    cmd.CommandType = CommandType.Text
                    Return cmd.ExecuteScalar
                End Using
            End Using
        End Function

        Public Shared Function GetAttyCompanyNo(ByVal Attorney As String) As Integer
            Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
            Dim strSQL As String = "SELECT CompanyID FROM tblCompany WHERE [Name] LIKE '%" & Attorney & "%'"
            Using cn As New SqlConnection(connectionString)
                cn.Open()
                Using cmd As New SqlCommand(strSQL, cn)
                    cmd.CommandType = CommandType.Text
                    Return cmd.ExecuteScalar
                End Using
            End Using
        End Function

        Public Shared Function GetOAAttyCompanyNo(ByVal Attorney As String) As Integer
            Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
            Dim strSQL As String = "SELECT CompanyID FROM tblCommRec WHERE [Display] LIKE '%" & Attorney & "%'"
            Using cn As New SqlConnection(connectionString)
                cn.Open()
                Using cmd As New SqlCommand(strSQL, cn)
                    cmd.CommandType = CommandType.Text
                    Return cmd.ExecuteScalar
                End Using
            End Using
        End Function

        Public Shared Function GetLexxiomDetail() As DataTable
            Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
            Dim dtLexxiom As DataTable

            Try
                Dim strSQL As String = "stp_LexxiomCommRpt"
                Dim param As New SqlParameter
                Using cn As New SqlConnection(connectionString)
                    cn.Open()
                    Using cmd As New SqlCommand(strSQL, cn)
                        cmd.CommandType = CommandType.StoredProcedure
                        'Add the parameter 
                        cmd.Parameters.Add("@StartDate", SqlDbType.DateTime)
                        cmd.Parameters("@StartDate").Value = Format(Now.AddDays(-1), "MM/dd/yyyy")
                        dtLexxiom = New DataTable
                        Using rdr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                            dtLexxiom.Load(rdr)
                            Return dtLexxiom
                        End Using
                    End Using
                End Using

            Catch ex As Exception
                Alert.Show("Error reading daily returns Lexxiom detail data 2. " & ex.Message)
            End Try
            dtLexxiom = Nothing
            Return dtLexxiom
        End Function

        Public Shared Function LoadCommRec() As DataTable
            Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
            Dim dtLexxiom As DataTable

            Try
                Dim strSQL As String = "SELECT DISTINCT Display, AccountNumber FROM tblCommRec WHERE isTrust = 0 AND Display NOT LIKE '%Trust%' AND Display NOT LIKE '%General Clearing%' AND AccountNumber IS NOT NULL ORDER BY Display, AccountNumber"
                Dim param As New SqlParameter
                Using cn As New SqlConnection(connectionString)
                    cn.Open()
                    Using cmd As New SqlCommand(strSQL, cn)
                        cmd.CommandType = CommandType.Text
                        dtLexxiom = New DataTable
                        Using rdr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                            dtLexxiom.Load(rdr)
                            Return dtLexxiom
                        End Using
                    End Using
                End Using

            Catch ex As Exception
                Alert.Show("Error reading commission receipients. " & ex.Message)
            End Try
            dtLexxiom = Nothing
            Return dtLexxiom
        End Function

        Public Shared Function LoadRptData(ByVal sDate As String, ByVal eDate As String, ByVal ReportNumber As String) As DataTable
            Dim connectionString As String = ConfigurationManager.AppSettings("connectionstring").ToString
            Dim dtLexxiom As DataTable

            Try
                Dim strSQL As String = GetRptSQL(sDate, eDate, ReportNumber)
                If strSQL <> "" Then
                    Using cn As New SqlConnection(connectionString)
                        cn.Open()
                        Using cmd As New SqlCommand(strSQL, cn)
                            cmd.CommandType = CommandType.Text
                            dtLexxiom = New DataTable
                            Using rdr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
                                dtLexxiom.Load(rdr)
                                Return dtLexxiom
                            End Using
                        End Using
                    End Using
                End If

            Catch ex As Exception
                Alert.Show("Error reading report data. " & ex.Message)
            End Try
            dtLexxiom = Nothing
            Return dtLexxiom
        End Function

        Private Shared Function GetRptSQL(ByVal sDate As Date, ByVal eDate As Date, ByVal ReportNumber As String) As String
            Dim strSQL As String = ""

            If ReportNumber = "1" Then
                strSQL = "SELECT "
                strSQL += "NachaRegisterID, DateWithheld, [Name], OriginalAmount, AmountWithheld, "
                strSQL += "OriginalAmount - AmountWithheld [Amount], "
                strSQL += "RoutingNumber, AccountNumber, WithHeldBy, WithheldFrom, "
                strSQL += "OriginalNachaRegisterID "
                strSQL += "FROM (SELECT  nr.NachaRegisterId, nr.DateWithheld, nr.Name, nr.OriginalAmount, nr.AmountWithheld, nr.Amount, nr.RoutingNumber, nr.accountnumber, "
                strSQL += "u.FirstName + ' ' + u.lastname[WithheldBy], nr.WithheldFrom, nr.OriginalNachaRegisterID "
                strSQL += "FROM tblNachaRegister nr JOIN tblUser u ON u.UserID = nr.WithheldBy "
                strSQL += "WHERE nr.PayoutWithheld = 1 "
                strSQL += "AND nr.DateWithheld BETWEEN '" & sDate & "' AND '" & eDate & "' "
                strSQL += "AND AmountWithheld > 0 "
                strSQL += "AND nr.Name LIKE '%Clearing%' "
                strSQL += "AND nr.KeepInGCA IS NULL "

                'If AccountNumber <> "0" And AccountNumber <> "-1" Then
                '    strSQL += "AND nr.AccountNumber = '" & AccountNumber & "' "
                'End If
                strSQL += "UNION ALL "

                strSQL += "SELECT nr.NachaRegisterId, nr.DateWithheld, nr.Name, nr.OriginalAmount, nr.AmountWithheld, "
                strSQL += "OriginalAmount - AmountWithheld [Amount],  "
                strSQL += "nr.RoutingNumber, nr.accountnumber, "
                strSQL += "u.FirstName + ' ' + u.lastname[WithheldBy], nr.WithheldFrom, nr.OriginalNachaRegisterID "
                strSQL += "FROM tblNachaRegister2 nr JOIN tblUser u ON u.UserID = nr.WithheldBy "
                strSQL += "WHERE nr.PayoutWithheld = 1 "
                strSQL += "AND nr.DateWithheld BETWEEN  '" & sDate & "' AND '" & eDate & "' "
                strSQL += "AND nr.AmountWithheld > 0 "
                strSQL += "AND nr.Name LIKE '%Clearing%' "
                strSQL += "AND nr.KeepInGCA IS NULL "

                'If AccountNumber <> "0" And AccountNumber <> "-1" Then
                '    strSQL += "AND nr.AccountNumber = '" & AccountNumber & "') w ORDER BY   Name, DateWithheld"
                'Else
                strSQL += ") w ORDER BY Name, DateWithheld"
                'End If
                Return strSQL
            ElseIf ReportNumber = 2 Then
                strSQL = "SELECT "
                strSQL += "NachaRegisterID, DateWithheld, [Name], OriginalAmount, AmountWithheld, "
                strSQL += "OriginalAmount - AmountWithheld [Amount], "
                strSQL += "RoutingNumber, AccountNumber, WithHeldBy, WithheldFrom, "
                strSQL += "OriginalNachaRegisterID "
                strSQL += "FROM (SELECT  nr.NachaRegisterId, nr.DateWithheld, nr.Name, nr.OriginalAmount, nr.AmountWithheld, nr.Amount, nr.RoutingNumber, nr.accountnumber, "
                strSQL += "u.FirstName + ' ' + u.lastname[WithheldBy], nr.WithheldFrom, nr.OriginalNachaRegisterID "
                strSQL += "FROM tblNachaRegister nr JOIN tblUser u ON u.UserID = nr.WithheldBy "
                strSQL += "WHERE nr.PayoutWithheld = 1 "
                strSQL += "AND nr.DateWithheld BETWEEN '" & sDate & "' AND '" & eDate & "' "
                strSQL += "AND AmountWithheld > 0 "
                strSQL += "AND nr.Name LIKE '%Clearing%' "
                strSQL += "AND nr.KeepInGCA = 1 "

                'If AccountNumber <> "0" And AccountNumber <> "-1" Then
                '    strSQL += "AND nr.AccountNumber = '" & AccountNumber & "' "
                'End If
                strSQL += "UNION ALL "

                strSQL += "SELECT nr.NachaRegisterId, nr.DateWithheld, nr.Name, nr.OriginalAmount, nr.AmountWithheld, "
                strSQL += "OriginalAmount - AmountWithheld [Amount],  "
                strSQL += "nr.RoutingNumber, nr.accountnumber, "
                strSQL += "u.FirstName + ' ' + u.lastname[WithheldBy], nr.WithheldFrom, nr.OriginalNachaRegisterID "
                strSQL += "FROM tblNachaRegister2 nr JOIN tblUser u ON u.UserID = nr.WithheldBy "
                strSQL += "WHERE nr.PayoutWithheld = 1 "
                strSQL += "AND nr.DateWithheld BETWEEN  '" & sDate & "' AND '" & eDate & "' "
                strSQL += "AND nr.AmountWithheld > 0 "
                strSQL += "AND nr.Name LIKE '%Clearing%' "
                strSQL += "AND nr.KeepInGCA = 1 "

                'If AccountNumber <> "0" And AccountNumber <> "-1" Then
                '    strSQL += "AND nr.AccountNumber = '" & AccountNumber & "') w ORDER BY   Name, DateWithheld"
                'Else
                strSQL += ") w ORDER BY Name, DateWithheld"
                'End If
                Return strSQL
            End If
            Return strSQL
        End Function

    End Class
End Namespace