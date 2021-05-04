Imports Microsoft.VisualBasic
Imports System
Imports System.Collections.Generic
Imports System.Text
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Public Class SettlementFeeHelper

    Public EntryTypeID As Integer
    Public Account As Double

#Region "Settlement Fee adjustment calculation and posting"

    Public Shared Function AdjustSettlementFee(ByVal SettlementID As Integer, _
                              ByVal ClientID As Integer, ByVal UserID As Integer, ByVal AccountID As Integer) As Boolean

        Dim Adjustment As Double
        'Dim EntrytypeID As Integer
        Dim Avaliable As Double
        Dim CurrentFee As Double

        Try
            'Setup the basics
            'EntrytypeID = CInt(Val(DataHelper.FieldLookup("tblEntryType", "EntryTypeID", "[Name] = 'Fee Adjustment'")))

            'Has this fee already been assessed?
            If Not DataHelper.FieldLookup("tblSettlements", "SettlementID", "ClientID = " & ClientID & " AND SettlementID = " & SettlementID) Is DBNull.Value Then

                'Calculate the proper fees and Monthly deposit commitment each * 12 - Settlement fee returns a negative number
                Avaliable = AvailableForSettlementFee(ClientID)
                CurrentFee = CurrentSettlementFee(SettlementID)
                Adjustment = Avaliable - CurrentFee
                'Make a fee adjustment for this fee, if necessary
                If Adjustment < -1.0 Then
                    'Insert the total fee in tblregister if necessary ********************************************************V
                    'Dim RegisterID As Integer = InsertSettlementFeeInRegister(SettlementID, CurrentSettlementFee(SettlementID), ClientID, UserID)
                    'RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID, DateTime.Now, String.Empty, Math.Round(Adjustment * -1, 2), EntrytypeID, UserID, 1)

                    'Insert the adjusted fee in tblSettlements
                    InsertAdjustmentInSettlement(SettlementID, Adjustment)
                    Return True
                End If
            Else 'We have a non existent offer
                Return False
            End If

        Catch ex As Exception
            Return False
        End Try

    End Function

    Private Shared Function AvailableForSettlementFee(ByVal ClientID As Integer) As Double

        Dim AnnualMaintFee As Double = GetAnnualMaintFee(ClientID)
        Dim AnnualTotalDeposit As Double = GetAnnualDepositAmt(ClientID)

        'If the SDA is used in the calculation un-comment the two lines below ***********
        'Dim SDA As Double = DataHelper.FieldLookup("tblClient", "SDABalance", "ClientID = " & ClientID)
        'AnnualTotalDeposit = SDA  + AnnualTotalDeposit

        Return (AnnualTotalDeposit - AnnualMaintFee)

    End Function

    Public Shared Function CurrentSettlementFee(ByVal SettlementID As Integer) As Double

        Return CDbl(Val(DataHelper.FieldLookup("tblSettlements", "SettlementFee", "SettlementID = " & SettlementID)))

    End Function

    Public Shared Function GetAnnualMaintFee(ByVal ClientID As Integer) As Double

        'Setup the basics
        Dim AnnualFeeAmount As Double = 0
        Dim SubMaintFeeStart As Date
        Dim SubsequentFee As Double
        Dim MonthsAtCurrentFee As Integer = 12
        Dim MaintFeeCap As Double
        Dim ActiveAccounts As Integer

        Dim CurrentFee As Double = CDbl(Val(DataHelper.FieldLookup("tblClient", "MonthlyFee", "ClientID = " & ClientID)))

        'Do we have a subsequent maintenance fee?
        If DataHelper.FieldLookup("tblClient", "SubMaintFeeStart", "ClientID = " & ClientID).ToString <> "" Then
            SubMaintFeeStart = CDate("#" & DataHelper.FieldLookup("tblClient", "SubMaintFeeStart", "ClientID = " & ClientID) & "#")
            SubsequentFee = CDbl(Val(DataHelper.FieldLookup("tblClient", "SubsequentMaintFee", "ClientID = " & ClientID)))
            MonthsAtCurrentFee = DateDiff(DateInterval.Month, SubMaintFeeStart, Now)
        End If
        'Is this maintenance fee cap client
        If DataHelper.FieldLookup("tblClient", "MaintenanceFeeCap", "ClientID = " & ClientID).ToString <> "" Then
            MaintFeeCap = CDbl(Val(DataHelper.FieldLookup("tblClient", "MaintenanceFeeCap", "ClientID = " & ClientID).ToString))
            ActiveAccounts = GetActiveAccounts(ClientID)
            CurrentFee = CurrentFee * ActiveAccounts
            If CurrentFee > MaintFeeCap Then
                CurrentFee = MaintFeeCap
            End If
        End If

        'Do the calc and return the result
        If MonthsAtCurrentFee < 12 Then
            AnnualFeeAmount = (CurrentFee * MonthsAtCurrentFee) + (SubsequentFee * (12 - MonthsAtCurrentFee))
        Else
            AnnualFeeAmount = CurrentFee * MonthsAtCurrentFee
        End If

        Return AnnualFeeAmount

    End Function

    Public Shared Function GetAnnualDepositAmt(ByVal ClientID As Integer) As Double

        Dim AnnualDeposit As Double

        Dim MultiDeposit As Boolean = DataHelper.FieldLookup("tblClient", "MultiDeposit", "ClientID = " & ClientID)

        If Not MultiDeposit Then
            AnnualDeposit = DataHelper.FieldLookup("tblClient", "MonthlyFee", "ClientID = " & ClientID) * 12
        Else
            AnnualDeposit = GetMultiDepositTotal(ClientID) * 12
        End If

        Return AnnualDeposit

    End Function

    Public Shared Function GetMultiDepositTotal(ByVal ClientID As Integer) As Double

        Return CInt(SqlHelper.ExecuteScalar("select isnull(sum(depositamount),0) from tblclientdepositday where deleteddate is null and clientid = " & ClientID, CommandType.Text))

    End Function

    Public Shared Function GetActiveAccounts(ByVal ClientID As Integer) As Integer

        Dim ActiveAccounts As Integer = 0

        ActiveAccounts = SqlHelper.ExecuteScalar("SELECT count(ClientID) FROM tblAccount WHERE AccountStatusID NOT IN (171, 54, 55, 158, 170 ) AND ClientID = " & ClientID, CommandType.Text)

        Return ActiveAccounts

    End Function

    Public Shared Function InsertFullSettlementFeeInRegister(ByVal SettlementID As Integer, ByVal CurrentSettlementFee As Double, _
                                                  ByVal ClientID As Integer, ByVal UserID As Integer) As Integer
        Dim PFOBal As Double
        Dim SDABal As Double
        Dim Balance As Double
        Dim AccountID As Integer = CInt(Val(DataHelper.FieldLookup("tblSettlements", "CreditorAccountID", "SettlementID = " & SettlementID)))

        'Get the current PFO balance 
        If DataHelper.FieldTop1("tblRegister", "PFOBalance", "ClientID = " & ClientID, "TransactionDate DESC").ToString() <> "" Then
            PFOBal = DataHelper.FieldTop1("tblRegister", "PFOBalance", "ClientID = " & ClientID, "TransactionDate DESC")
        Else
            PFOBal = CurrentSettlementFee
        End If
        'Get the current SDA balance
        If DataHelper.FieldTop1("tblRegister", "SDABalance", "ClientID = " & ClientID, "TransactionDate DESC").ToString() <> "" Then
            SDABal = DataHelper.FieldTop1("tblRegister", "SDABalance", "ClientID = " & ClientID, "TransactionDate DESC")
        Else
            SDABal = 0.0
        End If
        If DataHelper.FieldTop1("tblRegister", "Balance", "ClientID = " & ClientID, "TransactionDate DESC").ToString() <> "" Then
            Balance = DataHelper.FieldTop1("tblRegister", "Balance", "ClientID = " & ClientID, "TransactionDate DESC")
        Else
            Balance = CurrentSettlementFee
        End If

        Dim strSQL As String = "INSERT INTO tblRegister (" _
                & "ClientID, " _
                & "AccountID, " _
                & "TransactionDate, " _
                & "Amount, " _
                & "Balance, " _
                & "EntryTypeID, " _
                & "IsFullyPaid, " _
                & "Created, " _
                & "CreatedBy, " _
                & "PFOBalance, " _
                & "SDABalance) " _
                & "VALUES (" _
                & ClientID & ", " _
                & AccountID & ", " _
                & "'" & Now & "', " _
                & CurrentSettlementFee & ", " _
                & Balance & ", " _
                & 4 & ", " _
                & 0 & ", " _
                & "'" & Now & "', " _
                & UserID & ", " _
                & PFOBal & ", " _
                & SDABal & ") " _
                & "SCOPE_IDENTITY()"
        Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                Return cmd.ExecuteScalar()
            End Using
        End Using
    End Function

    Public Shared Function InsertAdjustmentInSettlement(ByVal SettlementID As Integer, ByVal Adjustment As Double) As Boolean
        Dim strSQL As String = "UPDATE tblSettlements SET "
        strSQL += "AdjustedSettlementFee = " & Adjustment & " "
        strSQL += "WHERE SettlementID = " & SettlementID
        Try
            Using cmd As New SqlCommand(strSQL, ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()
                    Return True
                End Using
            End Using
        Catch ex As SqlException
            Return False
        End Try
    End Function

#End Region

End Class
