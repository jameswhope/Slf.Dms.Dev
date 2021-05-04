Imports Microsoft.VisualBasic

Imports System.Collections.Generic
Namespace LexxiomWebPartsControls
    Public Structure AssignmentStruct
        Public ClientID As String
        Public CreditorAccountID As String
        Public NegotiationSessionGUID As String
    End Structure
    <Serializable()> _
    Public Structure SettlementOfferStruct
        Public Settlement_ID As Integer
        Public Settlement_AmountPercentage As Integer
        Public Settlement_Amount As Double
        Public Settlement_DueDate As String
        Public Settlement_Fee As Double
        Public Settlement_Savings As Double
        Public Settlement_Cost As Double
        Public Settlement_FeeAvailAmt As Double
        Public Settlement_FeePaidAmt As Double
        Public Settlement_FeeOwedAmt As Double
        Public Settlement_Notes As String
        Public Settlement_MediatorID As Integer
        Public Settlement_Direction As String
        Public Settlement_Status As String
        Public Settlement_SessionGUID As String

        Public Creditor_AccountNumber As String
        Public Creditor_AccountID As String
        Public Creditor_CurrentName As String
        Public Creditor_OriginalName As String
        Public Creditor_AccountBalance As Double
        Public Creditor_ReferenceNumber As String

        Public Client_ID As String
        Public Client_Name As String
        Public Client_SSN As String
        Public Client_CoAppName As String
        Public Client_CoAppSSN

        Public Client_RegisterBalance As Double
        Public Client_FrozenBalance As Double

        Public Client_SetupFee As Double
        Public Client_SettlementFeePercentage As Double
        Public Client_OvernightDeliveryFee As Double

    End Structure
    Public Structure SearchParameters
        Public Search As String
        Public Depth As String

        Public Sub New(ByVal _Search As String, ByVal _Depth As String)
            Me.Search = _Search
            Me.Depth = _Depth
        End Sub
    End Structure

    Public Structure NegotiationOptions
        Public radGroups As RadioButtonList
        Public chkFilters As CheckBoxList
        Public radGroupShow As RadioButtonList
        Public chkColumns As CheckBoxList
    End Structure

    Public Interface wAssignment
        ReadOnly Property SelectedAssignment() As AssignmentStruct
    End Interface

    Public Interface wSettlement
        ReadOnly Property Settlement() As SettlementOfferStruct
    End Interface

    Public Interface wSearch
        ReadOnly Property Searches() As SearchParameters
    End Interface

    Public Interface wRecentSearches
    End Interface

    Public Interface wRecentSearchesClick
        ReadOnly Property Searches() As SearchParameters
    End Interface

    Public Interface wEntityFilters
        ReadOnly Property EntityIDs() As List(Of String)
    End Interface

    Public Interface wNegotiationOptions
        ReadOnly Property Options() As NegotiationOptions
    End Interface

    Public Interface wNegotiationFilters
        ReadOnly Property chkFilters() As CheckBoxList
    End Interface

    Public Interface wSettlementVerification
    End Interface
End Namespace