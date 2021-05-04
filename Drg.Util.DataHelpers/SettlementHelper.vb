Imports Drg.Util.DataAccess

Imports System.Data.SqlClient

Public Class SettlementHelper

#Region "Enumerations"
    Public Enum SettlementAcceptanceStatus
        Accepted
        Rejected
    End Enum
#End Region

#Region "Structures"
    Public Structure SettlementRoadmap
        Public RoadmapID As Integer
        Public SettlementStatusID As Integer
        Public Reason As String
        Public StatusName As String

        Public Sub New(ByVal _RoadmapID As Integer, ByVal _SettlementStatusID As Integer, ByVal _Reason As String, ByVal _StatusName As String)
            Me.RoadmapID = _RoadmapID
            Me.SettlementStatusID = _SettlementStatusID
            Me.Reason = _Reason
            Me.StatusName = _StatusName
        End Sub
    End Structure

    Public Structure SettlementInformation
        Public SettlementID As Integer
        Public AccountID As Integer
        Public ClientID As Integer
        Public RegisterBalance As Double
        Public FrozenAmount As Double
        Public CreditorAccountBalance As Double
        Public SettlementPercent As Single
        Public SettlementAmount As Double
        Public SettlementAmountAvailable As Double
        Public SettlementAmountSent As Double
        Public SettlementAmountOwed As Double
        Public SettlementDueDate As DateTime
        Public SettlementSavings As Double
        Public SettlementFee As Double
        Public SettlementFeeCredit As Double
        Public OvernightDeliveryFee As Double
        Public SettlementCost As Double
        Public SettlementFeeAmountAvailable As Double
        Public SettlementFeeAmountBeingPaid As Double
        Public SettlementFeeAmountOwed As Double
        Public SettlementNotes As String
        Public AcceptanceStatus As SettlementAcceptanceStatus
        Public RegisterHoldID As Integer
        Public OfferDirection As String
        Public SettlementSessionGUID As String
        Public CurrentSettlementStatusID As Integer
        Public Roadmap As Dictionary(Of Integer, SettlementRoadmap)

        Public Sub New(ByVal _SettlementID As Integer, ByVal _AccountID As Integer, ByVal _ClientID As Integer, ByVal _RegisterBalance As Double, _
            ByVal _FrozenAmount As Double, ByVal _CreditorAccountBalance As Double, ByVal _SettlementPercent As Single, _
            ByVal _SettlementAmount As Double, ByVal _SettlementAmountAvailable As Double, ByVal _SettlementAmountSent As Double, _
            ByVal _SettlementAmountOwed As Double, ByVal _SettlementDueDate As DateTime, ByVal _SettlementSavings As Double, _
            ByVal _SettlementFee As Double, ByVal _OvernightDeliveryFee As Double, ByVal _SettlementCost As Double, _
            ByVal _SettlementFeeAmountAvailable As Double, ByVal _SettlementFeeAmountBeingPaid As Double, ByVal _SettlementFeeAmountOwed As Double, _
            ByVal _SettlementNotes As String, ByVal _AcceptanceStatus As SettlementAcceptanceStatus, ByVal _RegisterHoldID As Integer, _
            ByVal _OfferDirection As String, ByVal _SettlementSessionGUID As String, ByVal _CurrentSettlementStatusID As Integer)

            Me.SettlementID = _SettlementID
            Me.AccountID = _AccountID
            Me.ClientID = _ClientID
            Me.RegisterBalance = _RegisterBalance
            Me.FrozenAmount = _FrozenAmount
            Me.CreditorAccountBalance = _CreditorAccountBalance
            Me.SettlementPercent = _SettlementPercent
            Me.SettlementAmount = _SettlementAmount
            Me.SettlementAmountAvailable = _SettlementAmountAvailable
            Me.SettlementAmountSent = _SettlementAmountSent
            Me.SettlementAmountOwed = _SettlementAmountOwed
            Me.SettlementDueDate = _SettlementDueDate
            Me.SettlementSavings = _SettlementSavings
            Me.SettlementFee = _SettlementFee
            Me.OvernightDeliveryFee = _OvernightDeliveryFee
            Me.SettlementCost = _SettlementCost
            Me.SettlementFeeAmountAvailable = _SettlementFeeAmountAvailable
            Me.SettlementFeeAmountBeingPaid = _SettlementFeeAmountBeingPaid
            Me.SettlementFeeAmountOwed = _SettlementFeeAmountOwed
            Me.SettlementNotes = _SettlementNotes
            Me.AcceptanceStatus = _AcceptanceStatus
            Me.RegisterHoldID = _RegisterHoldID
            Me.OfferDirection = _OfferDirection
            Me.SettlementSessionGUID = _SettlementSessionGUID
            Me.CurrentSettlementStatusID = _CurrentSettlementStatusID
            Me.Roadmap = New Dictionary(Of Integer, SettlementRoadmap)()
        End Sub

        Public Sub New(ByVal _AccountID As Integer, ByVal _ClientID As Integer, ByVal _RegisterBalance As Double, _
            ByVal _FrozenAmount As Double, ByVal _CreditorAccountBalance As Double, ByVal _SettlementPercent As Single, _
            ByVal _SettlementAmount As Double, ByVal _SettlementDueDate As String, ByVal _SettlementFee As Double, ByVal _OvernightDeliveryFee As Double, ByVal _SettlementCost As Double, _
            ByVal _SettlementFeeAmountAvailable As Double, ByVal _SettlementFeeAmountBeingPaid As Double, ByVal _SettlementFeeAmountOwed As Double, _
            ByVal _AcceptanceStatus As SettlementAcceptanceStatus, _
            ByVal _OfferDirection As String, ByVal _SettlementSessionGUID As String, ByVal _CurrentSettlementStatusID As Integer, Optional ByVal _SettlementFeeCredit As Double = 0)

            Dim AmtAvail As Double = 0
            Dim AmtSent As Double = 0
            Dim AmtOwed As Double = 0
            If _RegisterBalance - _SettlementAmount > 0 Then
                AmtAvail = _SettlementAmount
                AmtSent = _SettlementAmount
                AmtOwed = 0
            Else
                AmtAvail = _RegisterBalance
                AmtSent = _RegisterBalance
                AmtOwed = _RegisterBalance - _SettlementAmount
            End If

            Me.AccountID = _AccountID
            Me.ClientID = _ClientID
            Me.RegisterBalance = _RegisterBalance
            Me.FrozenAmount = _FrozenAmount
            Me.CreditorAccountBalance = _CreditorAccountBalance
            Me.SettlementPercent = _SettlementPercent
            Me.SettlementAmount = _SettlementAmount
            Me.SettlementAmountAvailable = AmtAvail
            Me.SettlementAmountSent = AmtSent
            Me.SettlementAmountOwed = AmtOwed
            If IsDate(_SettlementDueDate) Then
                Me.SettlementDueDate = _SettlementDueDate
            Else
                Me.SettlementDueDate = CDate("1/1/1990")
            End If

            Me.SettlementSavings = _CreditorAccountBalance - _SettlementAmount
            Me.SettlementFee = _SettlementFee
            Me.OvernightDeliveryFee = _OvernightDeliveryFee
            Me.SettlementCost = _SettlementCost
            Me.SettlementFeeAmountAvailable = _SettlementFeeAmountAvailable
            Me.SettlementFeeAmountBeingPaid = _SettlementFeeAmountBeingPaid
            Me.SettlementFeeAmountOwed = _SettlementFeeAmountOwed
            Me.AcceptanceStatus = _AcceptanceStatus
            Me.OfferDirection = _OfferDirection
            Me.SettlementSessionGUID = _SettlementSessionGUID
            Me.CurrentSettlementStatusID = _CurrentSettlementStatusID
            Me.Roadmap = New Dictionary(Of Integer, SettlementRoadmap)()
            Me.SettlementFeeCredit = _SettlementFeeCredit
        End Sub
    End Structure

    Public Structure ClientVerification
        Public ApprovalType As String
        Public Note As String

        Public Sub New(ByVal _ApprovalType As String, ByVal _Note As String)
            Me.ApprovalType = _ApprovalType
            Me.Note = _Note
        End Sub
    End Structure
#End Region

    Public Shared Function GetSettlementInformation(ByVal settlementID As Integer) As SettlementInformation
        Dim info As SettlementInformation = Nothing

        Using cmd As New SqlCommand("SELECT s.SettlementID, s.CreditorAccountID, s.ClientID, s.RegisterBalance, s.FrozenAmount, " & _
        "s.CreditorAccountBalance, s.SettlementPercent, isnull(spa.PendingAmount, s.SettlementAmount) as SettlementAmount, " & _
        "isnull(s.SettlementAmtAvailable,'0') as SettlementAmtAvailable, isnull(s.SettlementAmtBeingSent,'0') as SettlementAmtBeingSent, " & _
        "isnull(s.SettlementAmtStillOwed,'0') as SettlementAmtStillOwed, s.SettlementDueDate, s.SettlementSavings, " & _
        "s.SettlementFee, s.OvernightDeliveryAmount, s.SettlementCost, s.SettlementFeeAmtAvailable, s.SettlementFeeAmtBeingPaid, " & _
        "s.SettlementFeeAmtStillOwed, s.Status, isnull(s.SettlementRegisterHoldID,-1) as SettlementRegisterHoldID, s.OfferDirection, s.SettlementSessionGuid, s.SettlementNotes, " & _
        "nr.SettlementStatusID FROM tblSettlements as s inner join (SELECT max(RoadmapID) as RoadmapID, SettlementID FROM tblNegotiationRoadmap " & _
        "GROUP BY SettlementID) as drv on drv.SettlementID = s.SettlementID inner join tblNegotiationRoadmap as nr on nr.RoadmapID = drv.RoadmapID " & _
        "left join tblSettlementProcessingApproval as spa on spa.SettlementID = drv.SettlementID and spa.Approved = 1 " & _
        "WHERE s.Status = 'A' and s.SettlementID = " & settlementID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        info = New SettlementInformation(settlementID, DataHelper.Nz_int(reader("CreditorAccountID")), _
                        DataHelper.Nz_int(reader("ClientID")), DataHelper.Nz_double(reader("RegisterBalance")), DataHelper.Nz_double(reader("FrozenAmount")), _
                        DataHelper.Nz_double(reader("CreditorAccountBalance")), Single.Parse(reader("SettlementPercent")), _
                        DataHelper.Nz_double(reader("SettlementAmount")), DataHelper.Nz_double(reader("SettlementAmtAvailable")), _
                        DataHelper.Nz_double(reader("SettlementAmtBeingSent")), DataHelper.Nz_double(reader("SettlementAmtStillOwed")), _
                        DataHelper.Nz_date(reader("SettlementDueDate")), DataHelper.Nz_double(reader("SettlementSavings")), _
                        DataHelper.Nz_double(reader("SettlementFee")), DataHelper.Nz_double(reader("OvernightDeliveryAmount")), _
                        DataHelper.Nz_double(reader("SettlementCost")), DataHelper.Nz_double(reader("SettlementFeeAmtAvailable")), _
                        DataHelper.Nz_double(reader("SettlementFeeAmtBeingPaid")), DataHelper.Nz_double(reader("SettlementFeeAmtStillOwed")), _
                        DataHelper.Nz_string(reader("SettlementNotes")), IIf(reader("Status") = "A", SettlementAcceptanceStatus.Accepted, _
                        SettlementAcceptanceStatus.Accepted), DataHelper.Nz_int(reader("SettlementRegisterHoldID")), DataHelper.Nz_string(reader("OfferDirection")), _
                        reader("SettlementSessionGuid"), DataHelper.Nz_int(reader("SettlementStatusID")))
                    End If
                End Using

                cmd.CommandText = "SELECT nr.RoadmapID, nr.SettlementStatusID, nr.Reason, nss.[Name] FROM tblNegotiationRoadmap as nr " & _
                    "inner join tblNegotiationSettlementStatus as nss on nss.SettlementStatusID = nr.SettlementStatusID WHERE nr.SettlementID = " & _
                    settlementID

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        info.Roadmap.Add(Integer.Parse(reader("SettlementStatusID")), New SettlementRoadmap(Integer.Parse(reader("RoadmapID")), Integer.Parse(reader("SettlementStatusID")), reader("Reason"), reader("Name")))
                    End While
                End Using
            End Using
        End Using

        Return info
    End Function

    Public Shared Sub InsertVerification(ByVal info As SettlementInformation, ByVal intRoadmapID As Integer, ByVal strNotes As String, ByVal intUserID As Integer)
        Dim dr As SqlDataReader
        Dim intCreditorInstanceID As Integer

        Using cmd As New SqlCommand("SELECT * FROM tblSettlementVerification WHERE SettlementID = " & info.SettlementID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                dr = cmd.ExecuteReader

                '1. Save the settlement verification

                If dr.RecordsAffected > 0 Then
                    'Required manager approval
                    cmd.CommandText = "UPDATE tblSettlementVerification SET RoadmapID = " & intRoadmapID & " Note = '" & strNotes.Replace("'", "''") & "' where SettlementID = " & info.SettlementID
                Else
                    cmd.CommandText = "INSERT INTO tblSettlementVerification (SettlementID, RoadmapID, Note) VALUES (" & info.SettlementID & ", " & intRoadmapID & ", '" & strNotes.Replace("'", "''") & "')"
                End If
                If Not dr.IsClosed Then
                    dr.Close()
                End If

                cmd.ExecuteNonQuery()


                '2. Recalc and save all of the settlement amounts in case the processer altered the settlement amount or current balance using the current register balance.

                'Update hold amount **the balance is not the running register balance bu the creditor instance balance, ok?? This is what NegotiationHelper.HoldFunds is doing
                cmd.CommandText = "update tblRegister set Amount = " & info.SettlementAmount & ", Balance = " & info.CreditorAccountBalance & " where RegisterID = " & info.RegisterHoldID
                cmd.ExecuteNonQuery()

                'Update account current balance
                cmd.CommandText = "update tblAccount set CurrentAmount = " & info.CreditorAccountBalance & ", LastModifiedBy = " & intUserID & ", LastModified = getdate() where AccountID = " & info.AccountID
                cmd.ExecuteNonQuery()

                'Get creditor instance
                cmd.CommandText = "exec stp_GetCreditorInstancesForAccount " & info.AccountID
                dr = cmd.ExecuteReader
                While dr.Read
                    If dr("iscurrent") = True Then
                        intCreditorInstanceID = CInt(dr("CreditorInstanceID"))
                        Exit While
                    End If
                End While

                If Not dr.IsClosed Then
                    dr.Close()
                End If

                'Update creditor instance current balance
                cmd.CommandText = "update tblCreditorInstance set Amount = " & info.CreditorAccountBalance & ", LastModifiedBy = " & intUserID & ", LastModified = getdate() where CreditorInstanceID = " & intCreditorInstanceID
                cmd.ExecuteNonQuery()

                cmd.CommandText = "UPDATE tblSettlements SET" _
                    & "  CreditorAccountBalance = " & info.CreditorAccountBalance _
                    & ", RegisterBalance = " & info.RegisterBalance _
                    & ", SettlementPercent = " & info.SettlementPercent _
                    & ", SettlementAmount = " & info.SettlementAmount _
                    & ", SettlementSavings = " & info.SettlementSavings _
                    & ", SettlementFee = " & info.SettlementFee _
                    & ", SettlementFeeCredit = " & info.SettlementFeeCredit _
                    & ", SettlementFeeAmtAvailable = " & info.SettlementFeeAmountAvailable _
                    & ", SettlementFeeAmtBeingPaid = " & info.SettlementFeeAmountAvailable _
                    & ", SettlementFeeAmtStillOwed = " & info.SettlementFeeAmountOwed _
                    & ", SettlementCost = " & info.SettlementCost _
                    & ", SettlementAmtAvailable = " & info.SettlementAmountAvailable _
                    & ", SettlementAmtBeingSent = " & info.SettlementFeeAmountBeingPaid _
                    & ", SettlementAmtStillOwed = " & info.SettlementFeeAmountOwed _
                    & ", OvernightDeliveryAmount = " & info.OvernightDeliveryFee _
                    & ", SettlementDueDate = '" & info.SettlementDueDate & "'" _
                    & ", LastModified = getdate()" _
                    & ", LastModifiedBy = " & intUserID _
                    & " WHERE SettlementID = " & info.SettlementID
                cmd.ExecuteNonQuery()

            End Using 'Connection
        End Using 'Command

    End Sub

    Public Shared Function GetVerificationNote(ByVal SettlementID As Integer) As String
        Using cmd As New SqlCommand("SELECT Note FROM tblSettlementVerification WHERE SettlementID = " & SettlementID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()
                Dim note As String = CStr(cmd.ExecuteScalar())
                If note Is Nothing Then
                    note = ""
                End If
                Return note
            End Using
        End Using
    End Function

    Public Function GetRegisterHoldID(ByVal intSettlementID As Integer) As Integer
        Return DataHelper.FieldLookup("tblSettlements", "SettlementRegisterHoldID", "SettlementID = " & intSettlementID)
    End Function

    Public Function GetCreditorAccountID(ByVal intSettlementID As Integer) As Integer
        Return DataHelper.FieldLookup("tblSettlements", "CreditorAccountID", "SettlementID = " & intSettlementID)
    End Function

    Public Shared Sub ReleaseRegisterHold(ByVal intSettlementID As Integer)
        Dim registerID As Integer = DataHelper.FieldLookup("tblSettlements", "SettlementRegisterHoldID", "SettlementID = " & intSettlementID)

        If registerID > 0 Then
            RegisterHelper.Delete(registerID)
        End If
    End Sub

    Public Shared Sub InsertClientApproval(ByVal SettlementID As Integer, ByVal RoadmapID As Integer, ByVal ApprovalType As String, ByVal Note As String)
        Using cmd As New SqlCommand("INSERT INTO tblSettlementClientApproval (SettlementID, RoadmapID, ApprovalType, Note) VALUES (" & SettlementID & ", " & RoadmapID & ", '" & ApprovalType.Replace("'", "''") & "', '" & Note.Replace("'", "''") & "')", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Function GetClientApproval(ByVal SettlementID As Integer) As ClientVerification
        Dim ret As ClientVerification = Nothing

        Using cmd As New SqlCommand("SELECT ApprovalType, Note FROM tblSettlementClientApproval WHERE SettlementID = " & SettlementID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        ret.ApprovalType = reader("ApprovalType")
                        ret.Note = reader("Note")
                    End If
                End Using
            End Using
        End Using

        Return ret
    End Function

    Public Shared Sub DistributeSettlements()
        Dim entityIDs As New Dictionary(Of Integer, Double)()
        Dim settlements As New Dictionary(Of Integer, Double)()

        Using cmd As New SqlCommand("SELECT u.UserID, isnull(sp.SettlementAmount, 0) as SettlementAmount FROM tblUser as u left join " & _
        "(SELECT sum(isnull(s.SettlementAmount, 0)) as SettlementAmount, sp.UserID FROM tblSettlements as s inner join " & _
        "tblSettlementProcessing as sp on sp.SettlementID = s.SettlementID left join (SELECT max(RoadmapID) as RoadmapID, SettlementID " & _
        "FROM tblNegotiationRoadmap GROUP BY SettlementID) as nrt on nrt.SettlementID = s.SettlementID left join " & _
        "tblNegotiationRoadmap as nr on nr.RoadmapID = nrt.RoadmapID WHERE sp.UserID is not null and nr.SettlementStatusID in (6, 7, 8) " & _
        "GROUP BY sp.UserID) as sp on sp.UserID = u.UserID WHERE u.UserGroupID = 22 and u.Locked = 0 ORDER BY u.UserID", _
        ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        entityIDs.Add(CInt(reader("UserID")), CDbl(reader("SettlementAmount")))
                    End While
                End Using

                cmd.CommandText = "SELECT s.SettlementID, s.SettlementAmount FROM tblSettlementProcessing as sp inner join " & _
                    "tblSettlements as s on s.SettlementID = sp.SettlementID WHERE sp.UserID is null"

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        settlements.Add(CInt(reader("SettlementID")), CDbl(reader("SettlementAmount")))
                    End While
                End Using

                Dim list As Dictionary(Of Integer, List(Of Integer)) = DistributionHelper.DistributeEvenly(entityIDs, settlements)

                For Each userID As Integer In list.Keys
                    If list(userID).Count > 0 Then
                        cmd.CommandText = "UPDATE tblSettlementProcessing SET UserID = " & userID & " WHERE UserID is null and SettlementID in (" & String.Join(", ", ConvertArrayIntToString(list(userID).ToArray())) & ")"

                        cmd.ExecuteNonQuery()
                    End If
                Next
            End Using
        End Using
    End Sub

    Public Shared Sub UnassignSettlements(ByVal userID As Integer)
        Using cmd As New SqlCommand("UPDATE tblSettlementProcessing SET UserID = null WHERE UserID = " & userID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Shared Function ConvertArrayIntToString(ByVal array() As Integer) As String()
        Dim ret As New List(Of String)()

        For Each i As Integer In array
            ret.Add(i.ToString())
        Next

        Return ret.ToArray()
    End Function

#Region "Settlement Fee adjustment calculation and posting"

    Public Shared Function AdjustSettlementFee(ByVal SettlementID As Integer, _
                              ByVal ClientID As Integer, ByVal UserID As Integer, ByVal AccountID As Integer) As Boolean

        Dim Adjustment As Double
        Dim EntrytypeID As Integer
        Dim Avaliable As Double
        Dim CurrentFee As Double

        'Setup the basics
        EntrytypeID = CInt(Val(DataHelper.FieldLookup("tblEntryType", "EntryTypeID", _
                                       "[Name] = 'Fee Adjustment'")))
        'Has this fee already been assessed?
        If Not DataHelper.FieldLookup("tblSettlements", "SettlementID", "ClientID = " & ClientID & " AND SettlementID = " & SettlementID) Is DBNull.Value Then

            'Calculate the proper fees and Monthly deposit commitment each * 12 - Settlement fee returns a negative number
            Avaliable = AvailableForSettlementFee(ClientID)
            CurrentFee = CurrentSettlementFee(SettlementID)
            Adjustment = Avaliable - CurrentFee
            'Make a fee adjustment for this fee, if necessary
            If Adjustment < -1.0 Then
                'Insert the total fee in tblregister if necessary
                'Dim RegisterID As Integer = InsertSettlementFeeInRegister(SettlementID, CurrentSettlementFee(SettlementID), ClientID, UserID)
                'RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID, DateTime.Now, String.Empty, Math.Round(Adjustment * -1, 2), EntrytypeID, UserID, 1)

                'Insert the adjusted fee in tblSettlements
                InsertAdjustmentInSettlement(SettlementID, Adjustment)
            End If
        Else 'We have a non existent offer

        End If

    End Function

    Private Shared Function AvailableForSettlementFee(ByVal ClientID As Integer) As Double

        Dim AnnualMaintFee As Double = GetAnnualMaintFee(ClientID)
        Dim AnnualTotalDeposit As Double = GetAnnualDepositAmt(ClientID)

        'If the SDA is used
        Dim SDA As Double = DataHelper.FieldLookup("tblClient", "SDABalance", "ClientID = " & ClientID)
        'Return SDA + (AnnualTotalDeposit - AnnualMaintFee)

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

        Dim dt As DataTable
        Dim row As DataRow
        Dim TotalMoPmts As Double = 0.0

        dt = GetDataTable("SELECT DepositAmount FROM tblClient WHERE ClientID = " & ClientID, CommandType.Text)

        For Each row In dt.Rows
            TotalMoPmts += row("DepositAmount")
        Next

        Return TotalMoPmts
    End Function

    Public Shared Function GetActiveAccounts(ByVal ClientID As Integer) As Integer

        Dim ActiveAccounts As Integer = 0

        ActiveAccounts = ExecuteScalar("SELECT count(ClientID) FROM tblAccount WHERE AccountStatusID NOT IN (171, 54, 55, 158, 170 ) AND ClientID = " & ClientID, CommandType.Text)

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

#Region "Data calls"

    Public Shared Sub ExecuteNonQuery(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.StoredProcedure, _
                                      Optional ByVal params() As SqlParameter = Nothing)
        Dim cmd As New SqlCommand()
        Dim opened As Boolean

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection
            cmd.Connection = ConnectionFactory.Create
            If cmd.Connection.State <> ConnectionState.Open Then
                cmd.Connection.Open()
                opened = True
            End If
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            If opened Then
                cmd.Connection.Close()
            End If
            cmd.Dispose()
            cmd = Nothing
        End Try
    End Sub

    Public Shared Function GetDataTable(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.Text, _
                                        Optional ByVal params() As SqlParameter = Nothing) As DataTable
        Dim cmd As New SqlCommand()
        Dim opened As Boolean

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection
            cmd.Connection = ConnectionFactory.Create
            If cmd.Connection.State <> ConnectionState.Open Then
                cmd.Connection.Open()
                opened = True
            End If
            Dim dtTemp As New Data.DataTable
            dtTemp.Load(cmd.ExecuteReader())
            If opened Then
                cmd.Connection.Close()
            End If
            cmd.Dispose()
            cmd = Nothing
            Return dtTemp
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Shared Function ExecuteScalar(ByVal cmdText As String, Optional ByVal cmdType As CommandType = CommandType.StoredProcedure, _
                                         Optional ByVal params() As SqlParameter = Nothing) As Object
        Dim cmd As New SqlCommand()
        Dim obj As Object
        Dim opened As Boolean

        Try
            cmd.CommandType = cmdType
            cmd.CommandText = cmdText
            If Not IsNothing(params) Then
                cmd.Parameters.AddRange(params)
            End If
            cmd.Connection = New SqlConnection
            cmd.Connection = ConnectionFactory.Create
            If cmd.Connection.State <> ConnectionState.Open Then
                cmd.Connection.Open()
                opened = True
            End If
            obj = cmd.ExecuteScalar
        Catch ex As Exception
            Throw ex
        Finally
            If opened Then
                cmd.Connection.Close()
            End If
            cmd.Dispose()
            cmd = Nothing
        End Try

        Return obj
    End Function

#End Region

End Class
