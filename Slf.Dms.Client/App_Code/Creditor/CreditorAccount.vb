Imports Microsoft.VisualBasic

Public Class CreditorAccount

#Region "Fields"
    Protected _MemberCode As String
    Protected _CreditorName As String
    Protected _AccountType As String
    Protected _AccountNumber As String
    Protected _AccountDesignator As String
    Protected _DateOpened As String
    Protected _DateVerified As String
    Protected _TradeVerificationIndicator As String
    Protected _DateClosed As String
    Protected _DateClosedIndicator As String
    Protected _DatePaidOut As String
    Protected _DateOfLastActivity As String
    Protected _CurrentMannerOfPayment As String
    Protected _Currency As String
    Protected _TradeBalance As String
    Protected _TradeHighCredit As String
    Protected _TradeCreditLimit As String
    Protected _TermsDuration As String
    Protected _TermsFrequency As String
    Protected _AmountOfPayment As String
    Protected _Collateral As String
    Protected _LoanType As String
    Protected _RemarksCode As String
    Protected _TradeAmountPastDue As String
    Protected _NumberOfPaymentsPastDue As String
    Protected _MaxDelinquencyAmount As String
    Protected _MaxDelinquencyDate As String
    Protected _MaxDelinquencyMOP As String
    Protected _PaymentPatternStartDate As String
    Protected _PaymentPattern As String
    Protected _NumberMonthsReviewed As String
    Protected _Times30DaysLate As String
    Protected _Times60DaysLate As String
    Protected _Times90DaysLate As String
    Protected _HistoricalCountersVerificationIndicator As String
    Protected _collection_agency_name As String
    Protected _CurrentBalance As String
    Protected _OriginalBalance As String


#End Region 'Fields

#Region "Properties"
    Public Property MemberCode() As String
        Get
            Return _MemberCode
        End Get
        Set(value As String)
            _MemberCode = value
        End Set
    End Property
    Public Property CreditorName() As String
        Get
            Return _CreditorName
        End Get
        Set(value As String)
            _CreditorName = value
        End Set
    End Property
    Public Property AccountType() As String
        Get
            Return _AccountType
        End Get
        Set(value As String)
            _AccountType = value
        End Set
    End Property
    Public Property AccountNumber() As String
        Get
            Return _AccountNumber
        End Get
        Set(value As String)
            _AccountNumber = value
        End Set
    End Property
    Public Property AccountDesignator() As String
        Get
            Return _AccountDesignator
        End Get
        Set(value As String)
            _AccountDesignator = value
        End Set
    End Property
    Public Property DateOpened() As String
        Get
            Return _DateOpened
        End Get
        Set(value As String)
            _DateOpened = value
        End Set
    End Property
    Public Property DateVerified() As String
        Get
            Return _DateVerified
        End Get
        Set(value As String)
            _DateVerified = value
        End Set
    End Property
    Public Property TradeVerificationIndicator() As String
        Get
            Return _TradeVerificationIndicator
        End Get
        Set(value As String)
            _TradeVerificationIndicator = value
        End Set
    End Property
    Public Property DateClosed() As String
        Get
            Return _DateClosed
        End Get
        Set(value As String)
            _DateClosed = value
        End Set
    End Property
    Public Property DateClosedIndicator() As String
        Get
            Return _DateClosedIndicator
        End Get
        Set(value As String)
            _DateClosedIndicator = value
        End Set
    End Property
    Public Property DatePaidOut() As String
        Get
            Return _DatePaidOut
        End Get
        Set(value As String)
            _DatePaidOut = value
        End Set
    End Property
    Public Property DateOfLastActivity() As String
        Get
            Return _DateOfLastActivity
        End Get
        Set(value As String)
            _DateOfLastActivity = value
        End Set
    End Property
    Public Property CurrentMannerOfPayment() As String
        Get
            Return _CurrentMannerOfPayment
        End Get
        Set(value As String)
            _CurrentMannerOfPayment = value
        End Set
    End Property
    Public Property Currency() As String
        Get
            Return _Currency
        End Get
        Set(value As String)
            _Currency = value
        End Set
    End Property
    Public Property TradeBalance() As String
        Get
            Return _TradeBalance
        End Get
        Set(value As String)
            _TradeBalance = value
        End Set
    End Property
    Public Property TradeHighCredit() As String
        Get
            Return _TradeHighCredit
        End Get
        Set(value As String)
            _TradeHighCredit = value
        End Set
    End Property
    Public Property TradeCreditLimit() As String
        Get
            Return _TradeCreditLimit
        End Get
        Set(value As String)
            _TradeCreditLimit = value
        End Set
    End Property
    Public Property TermsDuration() As String
        Get
            Return _TermsDuration
        End Get
        Set(value As String)
            _TermsDuration = value
        End Set
    End Property
    Public Property TermsFrequency() As String
        Get
            Return _TermsFrequency
        End Get
        Set(value As String)
            _TermsFrequency = value
        End Set
    End Property
    Public Property AmountOfPayment() As String
        Get
            Return _AmountOfPayment
        End Get
        Set(value As String)
            _AmountOfPayment = value
        End Set
    End Property
    Public Property LoanType() As String
        Get
            Return _LoanType
        End Get
        Set(value As String)
            _LoanType = value
        End Set
    End Property
    Public Property RemarksCode() As String
        Get
            Return _RemarksCode
        End Get
        Set(value As String)
            _RemarksCode = value
        End Set
    End Property
    Public Property TradeAmountPastDue() As String
        Get
            Return _TradeAmountPastDue
        End Get
        Set(value As String)
            _TradeAmountPastDue = value
        End Set
    End Property
    Public Property NumberOfPaymentsPastDue() As String
        Get
            Return _NumberOfPaymentsPastDue
        End Get
        Set(value As String)
            _NumberOfPaymentsPastDue = value
        End Set
    End Property
    Public Property MaxDelinquencyAmount() As String
        Get
            Return _MaxDelinquencyAmount
        End Get
        Set(value As String)
            _MaxDelinquencyAmount = value
        End Set
    End Property
    Public Property MaxDelinquencyDate() As String
        Get
            Return _MaxDelinquencyDate
        End Get
        Set(value As String)
            _MaxDelinquencyDate = value
        End Set
    End Property
    Public Property MaxDelinquencyMOP() As String
        Get
            Return _MaxDelinquencyMOP
        End Get
        Set(value As String)
            _MaxDelinquencyMOP = value
        End Set
    End Property
    Public Property PaymentPatternStartDate() As String
        Get
            Return _PaymentPatternStartDate
        End Get
        Set(value As String)
            _PaymentPatternStartDate = value
        End Set
    End Property
    Public Property PaymentPattern() As String
        Get
            Return _PaymentPattern
        End Get
        Set(value As String)
            _PaymentPattern = value
        End Set
    End Property
    Public Property NumberMonthsReviewed() As String
        Get
            Return _NumberMonthsReviewed
        End Get
        Set(value As String)
            _NumberMonthsReviewed = value
        End Set
    End Property
    Public Property Times60DaysLate() As String
        Get
            Return _Times60DaysLate
        End Get
        Set(value As String)
            _Times60DaysLate = value
        End Set
    End Property
    Public Property Times30DaysLate() As String
        Get
            Return _Times30DaysLate
        End Get
        Set(value As String)
            _Times30DaysLate = value
        End Set
    End Property
    Public Property Times90DaysLate() As String
        Get
            Return _Times90DaysLate
        End Get
        Set(value As String)
            _Times90DaysLate = value
        End Set
    End Property
    Public Property HistoricalCountersVerificationIndicator() As String
        Get
            Return _HistoricalCountersVerificationIndicator
        End Get
        Set(value As String)
            _HistoricalCountersVerificationIndicator = value
        End Set
    End Property
    Public Property Collateral() As String
        Get
            Return _Collateral
        End Get
        Set(value As String)
            _Collateral = value
        End Set
    End Property
    Public Property CurrentBalance() As String
        Get
            Return _CurrentBalance
        End Get
        Set(value As String)
            _CurrentBalance = value
        End Set
    End Property
    Public Property OriginalBalance() As String
        Get
            Return _OriginalBalance
        End Get
        Set(value As String)
            _OriginalBalance = value
        End Set
    End Property
    Public Property CollectionAgencyName() As String
        Get
            Return _collection_agency_name
        End Get
        Set(value As String)
            _collection_agency_name = value
        End Set
    End Property
#End Region 'Properties

#Region "Constructors"

    Public Sub New()

    End Sub

#End Region 'Constructors

End Class
