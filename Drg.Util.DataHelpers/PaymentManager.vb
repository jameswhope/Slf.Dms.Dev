Imports System
Imports System.Data
Imports System.Text
Imports System.Collections.Generic

Imports Drg.Util.DataAccess

Public Class PaymentManager

    'Public Shared Sub ResetClient(ByVal clientId As Integer)

    '    ' (1) remove all IsFullyPaid bits from client's registers where not voided
    '    DataHelper.FieldUpdate("tblRegister", "IsFullyPaid", False, "ClientID = " & clientId & " AND Void = 0")

    '    ' (2) delete all payments for this client
    '    PaymentManager.ClearPaymentsForClient(clientId)

    '    ' (3) reset all register balances for this client, starting at the beginning
    '    RegisterManager.Rebalance(clientId)

    '    ' (4) re-execute the payment manager
    '    PaymentManager.ProcessClient(clientId)

    'End Sub
    'Public Shared Sub CheckThresholdForClient(ByVal clientId As Integer)

    '    Dim AssignedMediator As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "AssignedMediator", "ClientID = " & clientId))

    '    If AssignedMediator = 0 Then ' client has no assigned mediator

    '        Dim RegisterBalance As Double = RegisterHelper.GetBalanceAsOf(clientId, Now)

    '        If RegisterBalance > 0 Then ' client is in the black

    '            Dim MediationThreshold As Double = DataHelper.Nz_double(DataHelper.FieldLookup("tblProperty", "Value", "Name = 'MediationThreshold'"))
    '            Dim MinAccount As Double = DataHelper.Nz_double(DataHelper.FieldMin("tblAccount", "CurrentAmount", "ClientID = " & clientId))

    '            If (MinAccount * MediationThreshold) <= RegisterBalance Then ' client's money is above threshold
    '                ' assign an mediator

    '                ' get this client's preferred language
    '                Dim LanguageID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPerson", "LanguageID", "PersonID = " & ClientHelper.GetDefaultPerson(clientId)))

    '                ' get the next mediator who speaks this language
    '                Dim MediatorUserID As Integer = UserHelper.GetNextUser(LanguageID, 4)

    '                ' update the client - set the new mediator
    '                DataHelper.FieldUpdate("tblClient", "AssignedMediator", MediatorUserID, "ClientID = " & clientId)

    '                ' get current roadmap location
    '                Dim CurrentRoadmapID As Integer = DataHelper.Nz_int(ClientHelper.GetRoadmap(clientId, DateTime.Now, "RoadmapID"))

    '                ' insert task for "familiarize yourself with your new assignment" (tasktype 6) against this client/mediator
    '                Dim TaskTypeID As Integer = 6

    '                Dim Description As String = DataHelper.FieldLookup("tblTaskType", "DefaultDescription", "TaskTypeID = " & TaskTypeID)

    '                TaskHelper.InsertTask(clientId, CurrentRoadmapID, TaskTypeID, Description, _
    '                    MediatorUserID, DateTime.Now, -1)

    '            End If
    '        End If
    '    End If

    'End Sub

    'Public Shared Sub ClearPaymentsForClient(ByVal clientId As Integer)
    '    ' get all registerIds for this client
    '    Dim registerIds As String() = DataHelper.FieldLookupIDs_string("tblRegister", "RegisterId", "ClientId=" & clientId.ToString())

    '    If Not registerIds Is Nothing AndAlso registerIds.Length > 0 Then
    '        ' delete any fee or payment registerid in this group
    '        Using cn As IDbConnection = ConnectionFactory.Create()
    '            Using cmd As IDbCommand = cn.CreateCommand()
    '                cmd.CommandText = "DELETE FROM tblRegisterPayment WHERE FeeRegisterId IN (" & String.Join(",", registerIds) & ") OR PaymentRegisterID IN (" & String.Join(",", registerIds) & ")"

    '                cn.Open()

    '                cmd.ExecuteNonQuery()
    '            End Using
    '        End Using
    '    End If
    'End Sub

    ''Public Shared Sub ExecuteAll()
    '    Using cn As IDbConnection = ConnectionFactory.Create()
    '        Using cmd As IDbCommand = cn.CreateCommand()
    '            cmd.CommandText = "SELECT RegisterId FROM tblRegister WHERE IsFullyPaid=0 AND Amount < 0"

    '            cn.Open()

    '            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
    '                ExecuteReaderItems(rd)
    '            End Using
    '        End Using
    '    End Using
    'End Sub

    'Public Shared Sub ExecuteClient(ByVal clientId As Integer)
    '    Using cn As IDbConnection = ConnectionFactory.Create()
    '        Using cmd As IDbCommand = cn.CreateCommand()
    '            cmd.CommandText = "SELECT tblRegister.RegisterId FROM tblRegister INNER JOIN tblEntryType ON tblRegister.EntryTypeId = tblEntryType.EntryTypeId WHERE tblRegister.IsFullyPaid=0 AND tblRegister.Amount<0 AND ClientId=" & clientId.ToString() & " ORDER BY tblEntryType.[Order]"

    '            cn.Open()

    '            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
    '                ExecuteReaderItems(rd)
    '            End Using
    '        End Using
    '    End Using
    'End Sub

    'Private Shared Sub ExecuteReaderItems(ByVal rd As IDataReader)
    '    Do While rd.Read()
    '        Dim registerId As Integer = rd.GetInt32(0)

    '        ExecuteRegisterId(registerId)
    '    Loop
    'End Sub

    'Public Shared Sub ExecuteRegisterId(ByVal registerId As Integer)
    '    Dim clientId As Integer
    '    Dim amount As Decimal
    '    Dim amountPaid As Decimal = 0
    '    Dim amountRemaining As Decimal

    '    Using cn As IDbConnection = ConnectionFactory.Create()
    '        Using cmd As IDbCommand = cn.CreateCommand()
    '            cmd.CommandText = "SELECT tblRegister.ClientId, tblRegister.Amount, SUM(tblRegisterPayment.Amount) AS PaidAmount FROM tblRegister LEFT OUTER JOIN tblRegisterPayment ON tblRegister.RegisterId = tblRegisterPayment.FeeRegisterId WHERE RegisterId=" & registerId.ToString() & " GROUP BY tblRegister.ClientId, tblRegister.Amount"

    '            cn.Open()

    '            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)
    '                If rd.Read() Then
    '                    clientId = rd.GetInt32(0)
    '                    amount = -rd.GetDecimal(1)
    '                    If (Not rd.IsDBNull(2)) Then
    '                        amountPaid = rd.GetDecimal(2)
    '                    End If
    '                    amountRemaining = amount - amountPaid
    '                Else
    '                    Return
    '                End If
    '            End Using
    '        End Using
    '    End Using

    '    Dim deposits As List(Of RegisterEntry) = GetAvailableDeposits(clientId)

    '    Using cn As IDbConnection = ConnectionFactory.Create()
    '        Using insertPaymentCmd As IDbCommand = cn.CreateCommand()
    '            Using updateFullyPaidCmd As IDbCommand = cn.CreateCommand()
    '                insertPaymentCmd.CommandText = "INSERT INTO tblRegisterPayment (FeeRegisterId, PaymentRegisterId, Amount) VALUES (@feeRegisterId, @paymentRegisterId, @amount)"
    '                updateFullyPaidCmd.CommandText = "UPDATE tblRegister SET IsFullyPaid=1 WHERE RegisterId=@registerId"

    '                Dim feeRegisterIdParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertPaymentCmd, "feeRegisterId", DbType.Int32)
    '                Dim paymentRegisterIdParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertPaymentCmd, "paymentRegisterId", DbType.Int32)
    '                Dim amountParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(insertPaymentCmd, "amount", DbType.Decimal)

    '                feeRegisterIdParm.Value = registerId

    '                Dim registerIdParm As IDataParameter = DatabaseHelper.CreateAndAddParamater(updateFullyPaidCmd, "registerId", DbType.Int32)

    '                cn.Open()

    '                Using trans As IDbTransaction = cn.BeginTransaction()
    '                    Try
    '                        insertPaymentCmd.Transaction = trans
    '                        updateFullyPaidCmd.Transaction = trans

    '                        ' If there are available deposits, apply them until this fee has been satisfied, or there are none left
    '                        For Each deposit As RegisterEntry In deposits
    '                            Dim paymentAmount As Decimal = deposit.Amount

    '                            If amountRemaining < deposit.Amount Then
    '                                paymentAmount = amountRemaining
    '                            End If

    '                            paymentRegisterIdParm.Value = deposit.RegisterId
    '                            amountParm.Value = paymentAmount

    '                            insertPaymentCmd.ExecuteNonQuery()

    '                            If paymentAmount = deposit.Amount Then
    '                                registerIdParm.Value = deposit.RegisterId
    '                                updateFullyPaidCmd.ExecuteNonQuery()
    '                            End If

    '                            amountRemaining -= paymentAmount

    '                            If amountRemaining = 0 Then
    '                                registerIdParm.Value = registerId
    '                                updateFullyPaidCmd.ExecuteNonQuery()

    '                                Exit For
    '                            End If
    '                        Next deposit

    '                        trans.Commit()
    '                    Catch
    '                        trans.Rollback()
    '                    End Try
    '                End Using
    '            End Using
    '        End Using
    '    End Using

    'End Sub

    'Private Shared Function GetAvailableDeposits(ByVal clientId As Integer) As List(Of RegisterEntry)
    '    Dim deposits As List(Of RegisterEntry) = New List(Of RegisterEntry)()

    '    Using cn As IDbConnection = ConnectionFactory.Create()
    '        Using cmd As IDbCommand = cn.CreateCommand()
    '            cmd.CommandText = "SELECT tblRegister.RegisterId, tblRegister.Amount - COALESCE(SUM(tblRegisterPayment.Amount), 0) AS Amount FROM tblRegister LEFT OUTER JOIN tblRegisterPayment ON tblRegister.RegisterId = tblRegisterPayment.PaymentRegisterId WHERE tblRegister.Amount > 0 AND tblRegister.IsFullyPaid = 0 AND tblRegister.ClientID = " & clientId.ToString() & " GROUP BY tblRegister.RegisterId, tblRegister.Amount"

    '            cn.Open()

    '            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
    '                Do While rd.Read()
    '                    Dim deposit As RegisterEntry = New RegisterEntry(rd.GetInt32(0), rd.GetDecimal(1))

    '                    deposits.Add(deposit)
    '                Loop
    '            End Using
    '        End Using
    '    End Using

    '    Return deposits
    'End Function

    'Public Shared Sub ProcessClient(ByVal ClientID As Integer)

    '    Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_PayFeeForClient")

    '        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

    '        Using cn As IDbConnection = cmd.Connection

    '            cn.Open()
    '            cmd.ExecuteNonQuery()

    '        End Using
    '    End Using

    '    ' after taking fees, check threshold again
    '    CheckThresholdForClient(ClientID)

    'End Sub

End Class