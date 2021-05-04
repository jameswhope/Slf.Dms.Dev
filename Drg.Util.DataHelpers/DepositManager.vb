Imports System
Imports System.Data
Imports System.Text
Imports System.Collections.Generic

Imports Drg.Util.DataAccess

Public Class DepositManager

    Public Shared Sub CollectAllDeposits()

    End Sub

    Public Shared Sub ExecuteAllDays()
        Dim lastCollectionDateObj As Object

        Using cn As IDbConnection = ConnectionFactory.Create()
            Using cmd As IDbCommand = cn.CreateCommand()
                cmd.CommandText = "SELECT MAX(Date) FROM tblDepositCollectionLog"

                cn.Open()

                lastCollectionDateObj = cmd.ExecuteScalar()

                ' If there have been no collections ever
                If lastCollectionDateObj Is DBNull.Value Then
                    ' Get the earliest client creation date
                    cmd.CommandText = "SELECT MIN(Created) FROM tblClient"

                    lastCollectionDateObj = cmd.ExecuteScalar()

                    If lastCollectionDateObj Is DBNull.Value Then
                        Return
                    End If

                    ' Subtract one day
                    lastCollectionDateObj = (CDate(lastCollectionDateObj)).AddDays(-1)
                End If
            End Using
        End Using

        Dim lastCollectionDate As DateTime = StripDate(CDate(lastCollectionDateObj))

        ' If there are collections to be made, make them
        If lastCollectionDate < StripDate(DateTime.Now) Then
            ExecuteAllDays(lastCollectionDate, DateTime.Now)
        End If
    End Sub

    Public Shared Sub ExecuteAllDays(ByVal startDate As DateTime, ByVal endDate As DateTime)
        Dim [date] As DateTime = StripDate(startDate)
        endDate = StripDate(endDate)

        Do While [date] < endDate
            ExecuteDay([date])

            [date] = [date].AddDays(1)
        Loop
    End Sub

    Public Shared Sub ExecuteDay(ByVal [date] As DateTime)
        Using cn As IDbConnection = ConnectionFactory.Create()
            Using cmd As IDbCommand = cn.CreateCommand()
                Dim sb As StringBuilder = New StringBuilder()

                sb.Append("SELECT tblClient.ClientId, DepositAmount, AccountNumber, BankName, BankRoutingNumber, BankAccountNumber, FirstName, LastName, Street FROM tblClient INNER JOIN tblPerson ON tblClient.PrimaryPersonId=tblPerson.PersonId WHERE NOT DepositAmount IS NULL AND DepositMethod='ACH' AND MONTH(tblClient.Created) < MONTH('")
                sb.Append([date].ToString("yyyy-MM-dd"))
                sb.Append("') AND (DepositDay=")
                sb.Append([date].Day)

                If IsLastDayOfMonth([date]) Then
                    sb.Append(" OR DepositDay=-1)")
                Else
                    sb.Append(")")
                End If

                cmd.CommandText = sb.ToString()

                cn.Open()

                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    Using insertCn As IDbConnection = ConnectionFactory.Create()
                        insertCn.Open()

                        Using trans As IDbTransaction = insertCn.BeginTransaction()
                            Try
                                Using insertCmd As IDbCommand = insertCn.CreateCommand()
                                    insertCmd.CommandText = "INSERT INTO tblCheckToPrint (ClientId, Name, Address, AccountNumber, BankName, BankAddress, BankRoutingNumber, BankAccountNumber, Amount, CheckNumber, Fraction, Created) VALUES " & "(@clientId, @name, @address, @accountNumber, @bankName, '', @bankRoutingNumber, @bankAccountNumber, @amount, '', @fraction, GETDATE())"

                                    Dim clientIdParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertCmd, "clientId", DbType.Int32)
                                    Dim amountParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertCmd, "amount", DbType.Currency)
                                    Dim accountNumberParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertCmd, "accountNumber", DbType.String)
                                    Dim bankNameParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertCmd, "bankName", DbType.String)
                                    Dim bankRoutingNumberParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertCmd, "bankRoutingNumber", DbType.String)
                                    Dim bankAccountNumberParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertCmd, "bankAccountNumber", DbType.String)
                                    Dim nameParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertCmd, "name", DbType.String)
                                    Dim addressParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertCmd, "address", DbType.String)
                                    Dim fractionParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertCmd, "fraction", DbType.String)
                                    fractionParm.Value = GetFraction()

                                    insertCmd.Transaction = trans

                                    Do While rd.Read()
                                        Dim clientId As Integer = rd.GetInt32(0)
                                        Dim monthlyDeposit As Decimal = rd.GetDecimal(1)
                                        Dim accountNumber As String = Nothing
                                        If (Not rd.IsDBNull(2)) Then
                                            accountNumber = rd.GetString(2)
                                        End If
                                        Dim bankName As String = rd.GetString(3)
                                        Dim bankRoutingNumber As String = rd.GetString(4)
                                        Dim bankAccountNumber As String = rd.GetString(5)
                                        Dim firstName As String = rd.GetString(6)
                                        Dim lastName As String = rd.GetString(7)
                                        Dim street As String = rd.GetString(8)

                                        clientIdParm.Value = clientId
                                        amountParm.Value = monthlyDeposit

                                        If Not accountNumber Is Nothing Then
                                            accountNumberParm.Value = accountNumber
                                        Else
                                            accountNumberParm.Value = String.Empty
                                        End If

                                        bankNameParm.Value = bankName
                                        bankRoutingNumberParm.Value = bankRoutingNumber
                                        bankAccountNumberParm.Value = bankAccountNumber
                                        nameParm.Value = firstName & " " & lastName
                                        addressParm.Value = street

                                        insertCmd.ExecuteNonQuery()

                                    Loop
                                End Using

                                ' Insert a log entry for this day
                                Using insertCmd As IDbCommand = insertCn.CreateCommand()
                                    insertCmd.CommandText = "INSERT INTO tblDepositCollectionLog (Date) VALUES ('" & [date].ToString("yyyy-MM-dd") & "')"

                                    insertCmd.Transaction = trans

                                    insertCmd.ExecuteNonQuery()
                                End Using

                                trans.Commit()
                            Catch
                                trans.Rollback()
                            End Try
                        End Using
                    End Using
                End Using
            End Using
        End Using
    End Sub

    Private Shared Function StripDate(ByVal [date] As DateTime) As DateTime
        Return New DateTime([date].Year, [date].Month, [date].Day)
    End Function

    Private Shared Function IsLastDayOfMonth(ByVal [date] As DateTime) As Boolean
        Return ([date].Month <> [date].AddDays(1).Month)
    End Function

    Private Shared _fraction As String

    Private Shared Function GetFraction() As String
        If _fraction Is Nothing Then
            Using cn As IDbConnection = ConnectionFactory.Create()
                Using cmd As IDbCommand = cn.CreateCommand()
                    cmd.CommandText = "SELECT Value FROM tblProperty WHERE Name='CheckPrintingFraction'"

                    cn.Open()

                    _fraction = CStr(cmd.ExecuteScalar())
                End Using
            End Using
        End If

        Return _fraction
    End Function
End Class