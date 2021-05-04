Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Public Class RegisterHelper

    Public Shared Function CanDelete(ByVal RegisterID As Integer) As Boolean

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT dbo.udf_CanDeleteRegister(@RegisterID)"

            DatabaseHelper.AddParameter(cmd, "RegisterID", RegisterID)

            Using cn As IDbConnection = cmd.Connection

                cn.Open()
                Return StringHelper.ParseBoolean(cmd.ExecuteScalar())

            End Using
        End Using

    End Function
    Public Shared Sub FixAdjustedFee(ByVal RegisterID As Integer, ByVal DoCleanUp As Nullable(Of Boolean),optional ByVal UserID As Integer = 28)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_DoRegisterFixAdjustedFee")

         DatabaseHelper.AddParameter(cmd, "RegisterID", RegisterID)
         DatabaseHelper.AddParameter(cmd, "UserID", UserID)

            If DoCleanUp.HasValue Then
                DatabaseHelper.AddParameter(cmd, "DoCleanUp", DoCleanUp.Value)
            End If

            Using cn As IDbConnection = cmd.Connection

                cn.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

    End Sub
    Public Shared Sub Remove(ByVal RegisterIDs() As Integer, ByVal UserID As Integer)
        Remove(RegisterIDs, UserID, Nothing)
    End Sub
    Public Shared Sub Remove(ByVal RegisterIDs() As Integer, ByVal UserID As Integer, ByVal DoCleanUp As Nullable(Of Boolean))

        If Not RegisterIDs Is Nothing Then

            'loop through and remove each one
            For Each RegisterID As Integer In RegisterIDs
                Remove(RegisterID, UserID, DoCleanUp)
            Next

        End If

    End Sub
    Public Shared Sub Remove(ByVal RegisterID As Integer, ByVal UserID As Integer)
        Remove(RegisterID, UserID, Nothing)
    End Sub
    Public Shared Sub Remove(ByVal RegisterID As Integer, ByVal UserID As Integer, ByVal DoCleanup As Nullable(Of Boolean))

        If CanDelete(RegisterID) Then
            Delete(RegisterID, DoCleanup)
        Else
            Void(RegisterID, UserID, DoCleanup)
        End If

    End Sub
    Public Shared Sub Delete(ByVal RegisterIDs() As Integer)
        Delete(RegisterIDs, Nothing)
    End Sub
    Public Shared Sub Delete(ByVal RegisterIDs() As Integer, ByVal DoCleanUp As Nullable(Of Boolean))

        If Not RegisterIDs Is Nothing Then

            'loop through and delete each one
            For Each RegisterID As Integer In RegisterIDs
                Delete(RegisterID, DoCleanUp)
            Next

        End If

    End Sub
    Public Shared Sub Delete(ByVal RegisterID As Integer)
        Delete(RegisterID, Nothing)
    End Sub
    Public Shared Sub Delete(ByVal RegisterID As Integer, ByVal DoCleanUp As Nullable(Of Boolean))

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_DeleteRegister")

            DatabaseHelper.AddParameter(cmd, "RegisterID", RegisterID)

            If DoCleanUp.HasValue Then
                DatabaseHelper.AddParameter(cmd, "DoCleanUp", DoCleanUp.Value)
            End If

            Using cn As IDbConnection = cmd.Connection

                cn.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

    End Sub
    Public Shared Sub Void(ByVal RegisterIDs() As Integer, ByVal UserID As Integer, ByVal DoCleanup As Nullable(Of Boolean), Optional ByVal Reason As String = "")
        Void(RegisterIDs, UserID, Nothing, DoCleanup, Reason)
    End Sub
    Public Shared Sub Void(ByVal RegisterIDs() As Integer, ByVal UserID As Integer, ByVal [When] As Nullable(Of DateTime), ByVal DoCleanup As Nullable(Of Boolean), Optional ByVal Reason As String = "")

        If Not RegisterIDs Is Nothing Then

            'loop through and void each one
            For Each RegisterID As Integer In RegisterIDs
                Void(RegisterID, UserID, [When], DoCleanup, Reason)
            Next

        End If

    End Sub
    Public Shared Sub Void(ByVal RegisterID As Integer, ByVal UserID As Integer, ByVal DoCleanup As Nullable(Of Boolean), Optional ByVal Reason As String = "")
        Void(RegisterID, UserID, Nothing, DoCleanup, Reason)
    End Sub
    Public Shared Sub Void(ByVal RegisterID As Integer, ByVal UserID As Integer, ByVal [When] As Nullable(Of DateTime), ByVal DoCleanup As Nullable(Of Boolean), Optional ByVal Reason As String = "")
        TakeAction("stp_DoRegisterVoid", RegisterID, UserID, [When], Nothing, DoCleanup)

        AuditVoid(RegisterID, Reason, UserID)
    End Sub
    Public Shared Sub AuditVoid(ByVal RegisterID As Integer, ByVal Reason As String, ByVal UserID As Integer)
        Dim clientID As Integer = DataHelper.FieldLookup("tblRegister", "ClientID", "RegisterID = " + RegisterID.ToString())
        Dim amount As Double = DataHelper.FieldLookup("tblRegister", "Amount", "RegisterID = " + RegisterID.ToString())

        AuditTransaction.AuditTransaction(clientID, RegisterID, "register", Reason, amount, UserID)
    End Sub
    Public Shared Sub Bounce(ByVal RegisterIDs() As Integer, ByVal UserID As Integer, ByVal CollectFee As Boolean, ByVal DoCleanup As Nullable(Of Boolean), ByVal Reason As Integer)
        Bounce(RegisterIDs, UserID, CollectFee, Nothing, DoCleanup, Reason)
    End Sub
    Public Shared Sub Bounce(ByVal RegisterIDs() As Integer, ByVal UserID As Integer, ByVal CollectFee As Boolean, ByVal [When] As Nullable(Of DateTime), ByVal DoCleanup As Nullable(Of Boolean), ByVal Reason As Integer)

        If Not RegisterIDs Is Nothing Then

            'loop through and bounce each one
            For Each RegisterID As Integer In RegisterIDs
                Bounce(RegisterID, UserID, CollectFee, [When], DoCleanup, Reason)
            Next

        End If

    End Sub
    Public Shared Sub Bounce(ByVal RegisterID As Integer, ByVal UserID As Integer, ByVal CollectFee As Boolean, ByVal DoCleanup As Nullable(Of Boolean), ByVal Reason As Integer)
        Bounce(RegisterID, UserID, CollectFee, Nothing, DoCleanup, reason)
    End Sub
    Public Shared Sub Bounce(ByVal RegisterID As Integer, ByVal UserID As Integer, ByVal CollectFee As Boolean, ByVal [When] As Nullable(Of DateTime), ByVal DoCleanup As Nullable(Of Boolean), ByVal Reason As Integer)
        TakeAction("stp_DoRegisterBounce", RegisterID, UserID, [When], CollectFee, DoCleanup, Reason)
    End Sub
    Public Shared Sub Clear(ByVal RegisterIDs() As Integer, ByVal UserID As Integer, ByVal DoCleanup As Nullable(Of Boolean))
        Clear(RegisterIDs, UserID, Nothing, DoCleanup)
    End Sub
    Public Shared Sub Clear(ByVal RegisterIDs() As Integer, ByVal UserID As Integer, ByVal [When] As Nullable(Of DateTime), ByVal DoCleanup As Nullable(Of Boolean))

        If Not RegisterIDs Is Nothing Then

            'loop through and clear each one
            For Each RegisterID As Integer In RegisterIDs
                Clear(RegisterID, UserID, [When], DoCleanup)
            Next

        End If

    End Sub
    Public Shared Sub Clear(ByVal RegisterID As Integer, ByVal UserID As Integer, ByVal DoCleanup As Nullable(Of Boolean))
        Clear(RegisterID, UserID, Nothing, DoCleanup)
    End Sub
    Public Shared Sub Clear(ByVal RegisterID As Integer, ByVal UserID As Integer, ByVal [When] As Nullable(Of DateTime), ByVal DoCleanup As Nullable(Of Boolean))
        TakeAction("stp_DoRegisterClear", RegisterID, UserID, [When], Nothing, DoCleanup)
    End Sub
    Public Shared Sub Hold(ByVal RegisterIDs() As Integer, ByVal UserID As Integer, ByVal DoCleanup As Nullable(Of Boolean))
        Hold(RegisterIDs, UserID, Nothing, DoCleanup)
    End Sub
    Public Shared Sub Hold(ByVal RegisterIDs() As Integer, ByVal UserID As Integer, ByVal Until As Nullable(Of DateTime), ByVal DoCleanup As Nullable(Of Boolean))

        If Not RegisterIDs Is Nothing Then

            'loop through and issue a hold against each one
            For Each RegisterID As Integer In RegisterIDs
                Hold(RegisterID, UserID, Until, DoCleanup)
            Next

        End If

    End Sub
    Public Shared Sub Hold(ByVal RegisterID As Integer, ByVal UserID As Integer, ByVal DoCleanup As Nullable(Of Boolean))
        Hold(RegisterID, UserID, Nothing, DoCleanup)
    End Sub
    Public Shared Sub Hold(ByVal RegisterID As Integer, ByVal UserID As Integer, ByVal Until As Nullable(Of DateTime), ByVal DoCleanup As Nullable(Of Boolean))
        TakeAction("stp_DoRegisterHold", RegisterID, UserID, Until, Nothing, DoCleanup)
    End Sub
    Public Shared Sub TakeAction(ByVal StoredProc As String, ByVal RegisterID As Integer, _
        ByVal UserID As Integer, ByVal WhenOrUntil As Nullable(Of DateTime), _
        ByVal CollectFee As Nullable(Of Boolean), ByVal DoCleanup As Nullable(Of Boolean), Optional ByVal Reason As Integer = 0)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand(StoredProc)

            DatabaseHelper.AddParameter(cmd, "RegisterID", RegisterID)
            DatabaseHelper.AddParameter(cmd, "By", UserID)

            cmd.CommandTimeout = 360
            If Reason > 0 Then
                DatabaseHelper.AddParameter(cmd, "BouncedReason", Reason)
            End If

            If WhenOrUntil.HasValue Then
                DatabaseHelper.AddParameter(cmd, "When", WhenOrUntil.Value)
            End If

            If CollectFee.HasValue Then
                DatabaseHelper.AddParameter(cmd, "CollectFee", CollectFee.Value)
            End If

            If DoCleanup.HasValue Then
                DatabaseHelper.AddParameter(cmd, "DoCleanup", DoCleanup.Value)
            End If

            Using cn As IDbConnection = cmd.Connection

                cn.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

    End Sub
    Public Shared Sub Rebalance(ByVal ClientID As Integer)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_DoRegisterRebalanceClient")

            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

            Using cn As IDbConnection = cmd.Connection

                cn.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

    End Sub
    Public Shared Function GetBalanceAsOf(ByVal ClientID As Integer, ByVal [When] As DateTime) As Double

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT TOP 1 Balance FROM tblRegister WHERE ClientID = @ClientID AND " _
            & "TransactionDate < @When ORDER BY TransactionDate DESC, RegisterID DESC"

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "When", [When])

        Try

            cmd.Connection.Open()
            Return DataHelper.Nz_double(cmd.ExecuteScalar())

        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Function
    Public Shared Function GetSDABalanceAsOf(ByVal ClientID As Integer, ByVal [When] As DateTime) As Double

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT TOP 1 SDABalance FROM tblRegister WHERE ClientID = @ClientID AND " _
            & "TransactionDate < @When ORDER BY TransactionDate DESC, RegisterID DESC"

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "When", [When])

        Try

            cmd.Connection.Open()
            Return DataHelper.Nz_double(cmd.ExecuteScalar())

        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Function
    Public Shared Function GetPFOBalanceAsOf(ByVal ClientID As Integer, ByVal [When] As DateTime) As Double

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT TOP 1 PFOBalance FROM tblRegister WHERE ClientID = @ClientID AND " _
            & "TransactionDate < @When ORDER BY TransactionDate DESC, RegisterID DESC"

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "When", [When])

        Try

            cmd.Connection.Open()
            Return DataHelper.Nz_double(cmd.ExecuteScalar())

        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Function
    Public Shared Function InsertDeposit(ByVal ClientID As Integer, ByVal TransactionDate As DateTime, ByVal CheckNumber As String, _
        ByVal Description As String, ByVal Amount As Double, ByVal EntryTypeID As Integer, ByVal Hold As Nullable(Of DateTime), _
        ByVal HoldBy As Nullable(Of Integer), ByVal CreatedBy As Integer) As Integer

        Dim RegisterID As Integer = Insert(Nothing, ClientID, Nothing, Nothing, TransactionDate, CheckNumber, Description, Nothing, Amount, 0, _
             EntryTypeID, False, Nothing, Nothing, Nothing, Nothing, Hold, HoldBy, Nothing, Nothing, Nothing, Nothing, _
             Nothing, Nothing, Nothing, Nothing, CreatedBy)

        ClientHelper.CleanupRegister(ClientID)

        Return RegisterID

    End Function
    Public Shared Function InsertFee(ByVal RegisterSetID As Nullable(Of Integer), ByVal ClientID As Integer, _
        ByVal AccountID As Nullable(Of Integer), ByVal TransactionDate As DateTime, ByVal Description As String, _
        ByVal Amount As Double, ByVal EntryTypeID As Integer, ByVal MediatorID As Nullable(Of Integer), _
        ByVal FeeMonth As Nullable(Of Integer), ByVal FeeYear As Nullable(Of Integer), _
        ByVal CreatedBy As Integer, ByVal DoCleanUp As Boolean) As Integer

        Dim RegisterID As Integer = Insert(RegisterSetID, ClientID, AccountID, Nothing, TransactionDate, String.Empty, Description, Nothing, Amount, 0, _
            EntryTypeID, False, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, MediatorID, _
            Nothing, Nothing, FeeMonth, FeeYear, CreatedBy)

        If DoCleanUp Then ClientHelper.CleanupRegister(ClientID)

        Return RegisterID

    End Function
    Public Shared Function InsertFeeAdjustment(ByVal ClientID As Integer, ByVal AdjustedRegisterID As Integer, _
        ByVal TransactionDate As DateTime, ByVal Description As String, ByVal Amount As Double, _
        ByVal EntryTypeID As Integer, ByVal CreatedBy As Integer, ByVal DoCleanUp As Boolean) As Integer

        If Not Amount = 0 Then

            Dim RegisterID As Integer = Insert(Nothing, ClientID, Nothing, AdjustedRegisterID, TransactionDate, String.Empty, Description, Nothing, Amount, _
                0, EntryTypeID, False, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, _
                Nothing, Nothing, Nothing, Nothing, CreatedBy)

            'the below procedure tweaks the parent fee amount, resets payments and does register cleanup
         FixAdjustedFee(RegisterID, DoCleanUp, CreatedBy)

            Return RegisterID

        End If

    End Function
    Public Shared Function InsertDebit(ByVal ClientID As Integer, ByVal AccountID As Nullable(Of Integer), _
        ByVal TransactionDate As DateTime, ByVal CheckNumber As String, ByVal Description As String, _
        ByVal Amount As Double, ByVal MediatorID As Nullable(Of Integer), ByVal EntryTypeID As Integer, _
        ByVal CreatedBy As Integer) As Integer

        Dim RegisterID As Integer = Insert(Nothing, ClientID, AccountID, Nothing, TransactionDate, _
            CheckNumber, Description, Nothing, Amount, 0, EntryTypeID, False, Nothing, Nothing, Nothing, _
            Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, MediatorID, Nothing, Nothing, Nothing, _
            Nothing, CreatedBy)

        ClientHelper.CleanupRegister(ClientID)

        Return RegisterID

    End Function
    Private Shared Function Insert(ByVal RegisterSetID As Nullable(Of Integer), ByVal ClientID As Integer, _
        ByVal AccountID As Nullable(Of Integer), ByVal AdjustedRegisterID As Nullable(Of Integer), _
        ByVal TransactionDate As DateTime, ByVal CheckNumber As String, ByVal Description As String, _
        ByVal OriginalAmount As Nullable(Of Double), ByVal Amount As Double, ByVal Balance As Double, _
        ByVal EntryTypeID As Integer, ByVal IsFullyPaid As Boolean, _
        ByVal Bounce As Nullable(Of DateTime), ByVal BounceBy As Nullable(Of Integer), _
        ByVal Void As Nullable(Of DateTime), ByVal VoidBy As Nullable(Of Integer), _
        ByVal Hold As Nullable(Of DateTime), ByVal HoldBy As Nullable(Of Integer), _
        ByVal Clear As Nullable(Of DateTime), ByVal ClearBy As Nullable(Of Integer), _
        ByVal ImportID As Nullable(Of Integer), ByVal MediatorID As Nullable(Of Integer), _
        ByVal ACHMonth As Nullable(Of Integer), ByVal ACHYear As Nullable(Of Integer), _
        ByVal FeeMonth As Nullable(Of Integer), ByVal FeeYear As Nullable(Of Integer), _
        ByVal CreatedBy As Nullable(Of Integer)) As Integer

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "RegisterSetID", RegisterSetID)
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)
        DatabaseHelper.AddParameter(cmd, "AdjustedRegisterID", AdjustedRegisterID)
        DatabaseHelper.AddParameter(cmd, "TransactionDate", TransactionDate)
        DatabaseHelper.AddParameter(cmd, "CheckNumber", DataHelper.Zn(CheckNumber))
        DatabaseHelper.AddParameter(cmd, "Description", DataHelper.Zn(Description))
        DatabaseHelper.AddParameter(cmd, "OriginalAmount", OriginalAmount, DbType.Double)
        DatabaseHelper.AddParameter(cmd, "Amount", Amount, DbType.Double)
        DatabaseHelper.AddParameter(cmd, "Balance", Balance, DbType.Double)
        DatabaseHelper.AddParameter(cmd, "EntryTypeId", EntryTypeID)
        DatabaseHelper.AddParameter(cmd, "IsFullyPaid", IsFullyPaid)
        DatabaseHelper.AddParameter(cmd, "Bounce", Bounce)
        DatabaseHelper.AddParameter(cmd, "BounceBy", BounceBy)
        DatabaseHelper.AddParameter(cmd, "Void", Void)
        DatabaseHelper.AddParameter(cmd, "VoidBy", VoidBy)
        DatabaseHelper.AddParameter(cmd, "Hold", Hold)
        DatabaseHelper.AddParameter(cmd, "HoldBy", HoldBy)
        DatabaseHelper.AddParameter(cmd, "Clear", Clear)
        DatabaseHelper.AddParameter(cmd, "ClearBy", ClearBy)
        DatabaseHelper.AddParameter(cmd, "ImportID", ImportID)
        DatabaseHelper.AddParameter(cmd, "MediatorID", MediatorID)
        DatabaseHelper.AddParameter(cmd, "ACHMonth", ACHMonth)
        DatabaseHelper.AddParameter(cmd, "ACHYear", ACHYear)
        DatabaseHelper.AddParameter(cmd, "FeeMonth", FeeMonth)
        DatabaseHelper.AddParameter(cmd, "FeeYear", FeeYear)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", CreatedBy)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblRegister", "RegisterID", SqlDbType.Int)

        Using cmd
            Using cn As IDbConnection = cmd.Connection

                cn.Open()
                cmd.ExecuteNonQuery()

            End Using
        End Using

        Return DataHelper.Nz_int(cmd.Parameters("@RegisterID").Value)

    End Function
End Class