Public Class Results

#Region "Fields"
    Dim _MonthlyDeposit As String

    Dim _TotalDebt As String
    Dim _PercentageOfSettlement As String
    Dim _SettlementAmount As String

    Dim _SettlementFeePercentage As String
    Dim _SettleFeeAmount As String

    Dim _InititalFeeAmount As String

    Dim _MonthlyRecurringFee As String
    Dim _TotalMonthlyFee As String

    Dim _TotalAmountFees As String
    Dim _PercentFeesToCost As String

    Dim _Months As String
    Dim _Years As String

#End Region 'Fields

#Region "Properties"

    Public Property MonthlyDeposit() As String
        Get
            Return _MonthlyDeposit
        End Get
        Set(value As String)
            _MonthlyDeposit = value
        End Set
    End Property

    Public Property TotalDebt() As String
        Get
            Return _TotalDebt
        End Get
        Set(value As String)
            _TotalDebt = value
        End Set
    End Property

    Public Property PercentageOfSettlement() As String
        Get
            Return _PercentageOfSettlement
        End Get
        Set(value As String)
            _PercentageOfSettlement = value
        End Set
    End Property

    Public Property SettlementAmount() As String
        Get
            Return _SettlementAmount
        End Get
        Set(value As String)
            _SettlementAmount = value
        End Set
    End Property

    Public Property SettlementFeePercentage() As String
        Get
            Return _SettlementFeePercentage
        End Get
        Set(value As String)
            _SettlementFeePercentage = value
        End Set
    End Property

    Public Property SettleFeeAmount() As String
        Get
            Return _SettleFeeAmount
        End Get
        Set(value As String)
            _SettleFeeAmount = value
        End Set
    End Property

    Public Property InititalFeeAmount() As String
        Get
            Return _InititalFeeAmount
        End Get
        Set(value As String)
            _InititalFeeAmount = value
        End Set
    End Property

    Public Property MonthlyRecurringFee() As String
        Get
            Return _MonthlyRecurringFee
        End Get
        Set(value As String)
            _MonthlyRecurringFee = value
        End Set
    End Property

    Public Property TotalMonthlyFee() As String
        Get
            Return _TotalMonthlyFee
        End Get
        Set(value As String)
            _TotalMonthlyFee = value
        End Set
    End Property

    Public Property TotalAmountFees() As String
        Get
            Return _TotalAmountFees
        End Get
        Set(value As String)
            _TotalAmountFees = value
        End Set
    End Property

    Public Property PercentFeesToCost() As String
        Get
            Return _PercentFeesToCost
        End Get
        Set(value As String)
            _PercentFeesToCost = value
        End Set
    End Property

    Public Property Months() As String
        Get
            Return _Months
        End Get
        Set(value As String)
            _Months = value
        End Set
    End Property

    Public Property Years() As String
        Get
            Return _Years
        End Get
        Set(value As String)
            _Years = value
        End Set
    End Property



#End Region 'Properties

#Region "Constructors"

    Public Sub New()

    End Sub

#End Region 'Constructors

#Region "Methods"

    'None

#End Region

End Class
