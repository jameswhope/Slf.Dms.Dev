Imports System
Imports System.Data
Imports System.Text
Imports System.Collections.Generic

Imports Drg.Util.DataAccess

Public Class FeeManager

    Public Shared Sub ExecuteAllDays()
        Dim lastCollectionDateObj As Object

        Using cn As IDbConnection = ConnectionFactory.Create()
            Using cmd As IDbCommand = cn.CreateCommand()
                cmd.CommandText = "SELECT MAX(Date) FROM tblFeeCollectionLog"

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

                Dim description As String = "Monthly fee for " & [date].ToString("MMMM yyyy")

                sb.Append("SELECT ClientId, MonthlyFee FROM tblClient WHERE NOT MonthlyFee IS NULL AND MONTH(Created) < MONTH('")
                sb.Append([date].ToString("yyyy-MM-dd"))
                sb.Append("') AND (MonthlyFeeDay=")
                sb.Append([date].Day)

                If IsLastDayOfMonth([date]) Then
                    sb.Append(" OR MonthlyFeeDay=-1)")
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
                                    insertCmd.CommandText = "INSERT INTO tblRegister (ClientId, Amount, EntryTypeId, Description) VALUES (@clientId, @amount, 1, '" & description & "')"

                                    Dim clientIdParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertCmd, "clientId", DbType.Int32)
                                    Dim amountParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertCmd, "amount", DbType.Currency)

                                    insertCmd.Transaction = trans

                                    Do While rd.Read()
                                        Dim clientId As Integer = rd.GetInt32(0)
                                        Dim monthlyFee As Decimal = rd.GetDecimal(1)

                                        clientIdParm.Value = clientId
                                        amountParm.Value = -monthlyFee

                                        insertCmd.ExecuteNonQuery()
                                    Loop
                                End Using

                                ' Insert a log entry for this day
                                Using insertCmd As IDbCommand = insertCn.CreateCommand()
                                    insertCmd.CommandText = "INSERT INTO tblFeeCollectionLog (Date) VALUES ('" & [date].ToString("yyyy-MM-dd") & "')"

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
End Class