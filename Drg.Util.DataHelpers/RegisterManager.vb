Imports System
Imports System.Data
Imports System.Collections.Generic

Imports Drg.Util.DataAccess

Public Class RegisterManager

    'Public Shared Sub Rebalance(ByVal clientId As Integer)
    '    ' get all register entries for this client in order
    '    Dim transactions As List(Of RegisterEntry) = GetOrderedTransactions(clientId)

    '    Dim runningBalance As Decimal = 0

    '    ' loop through and increment balance
    '    Using cn As IDbConnection = ConnectionFactory.Create()
    '        Using cmd As IDbCommand = cn.CreateCommand()
    '            cmd.CommandText = "UPDATE tblRegister SET Balance = @Balance WHERE RegisterID = @RegisterID"

    '            Dim paramBalance As IDataParameter = DatabaseHelper.CreateAndAddParamater(cmd, "Balance", DbType.Currency)
    '            Dim paramRegisterId As IDataParameter = DatabaseHelper.CreateAndAddParamater(cmd, "RegisterID", DbType.Int32)

    '            cn.Open()

    '            Using trans As IDbTransaction = cn.BeginTransaction()
    '                Try
    '                    cmd.Transaction = trans

    '                    For Each transaction As RegisterEntry In transactions
    '                        runningBalance += transaction.Amount

    '                        paramBalance.Value = runningBalance
    '                        paramRegisterId.Value = transaction.RegisterId

    '                        cmd.ExecuteNonQuery()
    '                    Next transaction

    '                    trans.Commit()
    '                Catch ex As Exception
    '                    trans.Rollback()
    '                End Try
    '            End Using
    '        End Using
    '    End Using
    'End Sub

    'Private Shared Function GetOrderedTransactions(ByVal clientId As Integer) As List(Of RegisterEntry)
    '    Dim transactions As List(Of RegisterEntry) = New List(Of RegisterEntry)()

    '    Using cn As IDbConnection = ConnectionFactory.Create()
    '        Using cmd As IDbCommand = cn.CreateCommand()
    '            cmd.CommandText = "SELECT RegisterID, Amount FROM tblRegister WHERE ClientID=" & clientId & " ORDER BY TransactionDate, RegisterID"

    '            cn.Open()

    '            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
    '                Do While rd.Read()
    '                    Dim transaction As RegisterEntry = New RegisterEntry(rd.GetInt32(0), rd.GetDecimal(1))

    '                    transactions.Add(transaction)
    '                Loop
    '            End Using
    '        End Using
    '    End Using

    '    Return transactions
    'End Function

End Class