Option Strict On

Imports Drg.Util.DataHelpers

Public Class Negotiation

    Private objDataHelper As Drg.Util.DataHelpers.NegotiationHelper

    Public Sub New()
        objDataHelper = New Drg.Util.DataHelpers.NegotiationHelper
    End Sub

    'Purpose: Updates an accounts creditor based on their current creditor information.
    'This method can be expanded to include other updateable fields such as Account Number
    'and Reference Number for use in CreditorInfoControl. *This method also adds client
    'notes.
    'Returns: New CreditorInstanceID
    Public Function UpdateCurrentCreditor(ByVal intAccountID As Integer, ByVal intCreditorID As Integer, ByVal intCreatedBy As Integer) As Integer
        Return objDataHelper.UpdateCurrentCreditor(intAccountID, intCreditorID, intCreatedBy)
    End Function

    Public Function InsertNewCreditor(ByVal CreditorName As String, ByVal Street1 As String, ByVal Street2 As String, ByVal City As String, ByVal StateID As Integer, ByVal ZipCode As String, ByVal intCreatedBy As Integer, Optional ByVal blnValidated As Boolean = False) As Integer
        Return objDataHelper.InsertNewCreditor(CreditorName.Trim, Street1.Trim, Street2.Trim, City.Trim, StateID, ZipCode.Trim, intCreatedBy, blnValidated)
    End Function

    Public Function CalcSettlementInfo(ByVal intCreditorAccountID As Integer, ByVal dblSettlementAmount As Double, ByVal dblCurrentBalance As Double, ByVal strOfferDirection As String, ByVal intAcceptanceStatus As SettlementHelper.SettlementAcceptanceStatus, Optional ByVal strDueDate As String = "", Optional ByVal intSettlementID As Integer = -1) As SettlementHelper.SettlementInformation
        Dim info As New SettlementHelper.SettlementInformation
        Dim tbl As DataTable
        Dim row As DataRow
        Dim dblSettlementFeePercentage As Double
        Dim dblAvailableSDA As Double

        info.SettlementAmount = dblSettlementAmount
        info.CreditorAccountBalance = dblCurrentBalance
        info.OfferDirection = strOfferDirection
        info.AcceptanceStatus = intAcceptanceStatus
        info.SettlementSessionGUID = "" 'don't append to any other notes
        info.ClientID = objDataHelper.GetClientIdbyAccount(intCreditorAccountID)

        If intAcceptanceStatus = SettlementHelper.SettlementAcceptanceStatus.Accepted Then
            info.SettlementDueDate = CDate(strDueDate)
        End If

        If intSettlementID > 0 Then
            Dim objSettlementHelper As New SettlementHelper
            info.SettlementID = intSettlementID
            'info.RegisterHoldID = objSettlementHelper.GetRegisterHoldID(intSettlementID)
        End If

        'Get client fee info
        tbl = objDataHelper.GetClientFeeInfo(info.ClientID)
        dblSettlementFeePercentage = Val(tbl.Rows(0)("SettlementFeePercentage"))
        info.OvernightDeliveryFee = Val(tbl.Rows(0)("OvernightDeliveryFee"))

        'Get creditor instance info
        tbl = objDataHelper.GetCreditorInstancesForAccount(intCreditorAccountID)
        For Each row In tbl.Rows
            If CBool(row("iscurrent")) Then
                info.AccountID = CInt(row("AccountID"))
                info.SettlementFeeCredit = Val(row("settlementfeecredit"))
                Exit For
            End If
        Next

        tbl = objDataHelper.GetStatsOverviewForClient(info.ClientID)
        info.RegisterBalance = Val(tbl.Rows(0)("registerbalance"))
        info.FrozenAmount = Val(tbl.Rows(0)("frozenbalance"))

        dblAvailableSDA = Math.Round(info.RegisterBalance - info.FrozenAmount, 2)
        info.SettlementPercent = CType(Math.Round((dblSettlementAmount / dblCurrentBalance) * 100, 2), Single)
        info.SettlementSavings = dblCurrentBalance - dblSettlementAmount
        'change ccastelo 2013_12_10
        'Changed from percent of savings to percent of verified cost for TKM.
        'If ClientHelper.LawFirm() = 12 Then
        'info.SettlementFee = Math.Round(dblSettlementFeePercentage * info.SettlementAmount, 2)
        'Else
        info.SettlementFee = Math.Round(dblSettlementFeePercentage * info.SettlementSavings, 2)
        'End If



        If info.SettlementFee > info.SettlementFeeCredit Then
            info.SettlementCost = (info.SettlementFee - info.SettlementFeeCredit) + info.OvernightDeliveryFee
        Else
            info.SettlementCost = info.OvernightDeliveryFee
        End If

        If info.RegisterBalance - dblSettlementAmount > 0 Then
            info.SettlementAmountAvailable = dblSettlementAmount
            info.SettlementAmountSent = dblSettlementAmount
            info.SettlementAmountOwed = 0
        Else
            info.SettlementAmountAvailable = info.RegisterBalance
            info.SettlementAmountSent = info.RegisterBalance
            info.SettlementAmountOwed = info.RegisterBalance - dblSettlementAmount
        End If

        If dblAvailableSDA > info.SettlementCost Then
            'There's money left after the settlement is paid to pay all of the fees
            info.SettlementFeeAmountAvailable = info.SettlementCost
            info.SettlementFeeAmountBeingPaid = info.SettlementCost
            info.SettlementFeeAmountOwed = 0
        Else
            info.SettlementFeeAmountAvailable = dblAvailableSDA
            info.SettlementFeeAmountBeingPaid = dblAvailableSDA
            info.SettlementFeeAmountOwed = info.SettlementCost - dblAvailableSDA
        End If

        Return info
    End Function

    Public Function RejectOffer(ByVal intCreditorAccountId As Integer, ByVal dblSettlementAmount As Double, ByVal dblCurrentBalance As Double, ByVal strOfferDirection As String, ByVal intUserId As Integer) As Integer
        Dim info As SettlementHelper.SettlementInformation = CalcSettlementInfo(intCreditorAccountId, dblSettlementAmount, dblCurrentBalance, strOfferDirection, SettlementHelper.SettlementAcceptanceStatus.Rejected)
        Return objDataHelper.RejectOffer(info, intUserId.ToString)
    End Function

    Public Function AcceptOffer(ByVal intCreditorAccountId As Integer, ByVal dblSettlementAmount As Double, ByVal dblCurrentBalance As Double, ByVal strOfferDirection As String, ByVal intUserId As Integer, ByVal strDueDate As String) As Integer
        Dim info As SettlementHelper.SettlementInformation = CalcSettlementInfo(intCreditorAccountId, dblSettlementAmount, dblCurrentBalance, strOfferDirection, SettlementHelper.SettlementAcceptanceStatus.Accepted, strDueDate)
        Return objDataHelper.AcceptOffer(info, intUserId.ToString)
    End Function

    Private Sub UpdateSettlement(ByVal RegisterId As Integer, ByVal SettlementId As String)
        objDataHelper.UpdateSettlement(RegisterId, SettlementId)
    End Sub

    Public Sub InsertVerification(ByVal intSettlementID As Integer, ByVal intRoadmapID As Integer, ByVal dblSettlementAmount As Double, ByVal dblCurrentBalance As Double, ByVal strDueDate As String, ByVal strNotes As String, ByVal intUserID As Integer)
        Dim objSettlementHelper As New SettlementHelper
        Dim intCreditorAccountID As Integer = objSettlementHelper.GetCreditorAccountID(intSettlementID)
        Dim info As SettlementHelper.SettlementInformation = CalcSettlementInfo(intCreditorAccountID, dblSettlementAmount, dblCurrentBalance, "", 0, strDueDate, intSettlementID)
        objSettlementHelper.InsertVerification(info, intRoadmapID, strNotes, intUserID)
    End Sub

End Class
