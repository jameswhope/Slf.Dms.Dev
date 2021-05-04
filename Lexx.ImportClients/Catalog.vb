Public Class SetupDefault
    Private _ReturnedCheckFee As Decimal = 25D
    Private _OvernightFee As Decimal = 15D
    Private _AdditionalAccountFee As Decimal = 35D
    Private _MonthlyFeeDay As Integer = 1
    Private _InitialClientStatusId As Integer = 2
    Private _SetupFeePercentage As Decimal = 10
    Private _SettlementFeePercentage As Decimal = 33

    Public Sub New()
        Dim dh As New DataHelper
        Dim dt As DataTable = dh.GetDefaultFees
        If dt.Rows.Count > 0 Then
            _ReturnedCheckFee = CDec(dt.Rows(0)("ReturnedCheckFee"))
            _AdditionalAccountFee = CDec(dt.Rows(0)("AdditionalAccountFee"))
            _OvernightFee = CDec(dt.Rows(0)("OvernightFee"))
            _MonthlyFeeDay = CDec(dt.Rows(0)("MonthlyFeeDay"))
            _SetupFeePercentage = CDec(dt.Rows(0)("RetainerPercentage"))
            _SettlementFeePercentage = CDec(dt.Rows(0)("SettlementPercentage"))
        End If
    End Sub

    Public ReadOnly Property ReturnedCheckFee() As Decimal
        Get
            Return _ReturnedCheckFee
        End Get
    End Property

    Public ReadOnly Property AdditionalAccountFee() As Decimal
        Get
            Return _AdditionalAccountFee
        End Get
    End Property

    Public ReadOnly Property OvernightFee() As Decimal
        Get
            Return _OvernightFee
        End Get
    End Property

    Public ReadOnly Property MonthlyFeeDay() As Integer
        Get
            Return _MonthlyFeeDay
        End Get
    End Property

    Public ReadOnly Property SetupFeePercentage()
        Get
            Return _SetupFeePercentage
        End Get
    End Property

    Public Property SettlementFeePercentage() As Decimal
        Get
            Return _SettlementFeePercentage
        End Get
        Set(ByVal value As Decimal)
            _SettlementFeePercentage = value
        End Set
    End Property

    Public ReadOnly Property InitialClientStatusId()
        Get
            Return _InitialClientStatusId
        End Get
    End Property

End Class

Public Class CatalogInfo
    Private _agencylist As New AgencyList
    Private _lawfirmlist As New LawFirmList
    Private _stateslist As New UsStateList
    Private _trustList As New TrustList
    Private _default As New SetupDefault

    Public ReadOnly Property Agencies() As AgencyList
        Get
            Return _agencylist
        End Get
    End Property

    Public ReadOnly Property Lawfirms() As LawFirmList
        Get
            Return _lawfirmlist
        End Get
    End Property

    Public ReadOnly Property States() As UsStateList
        Get
            Return _stateslist
        End Get
    End Property

    Public ReadOnly Property Trusts() As TrustList
        Get
            Return _trustList
        End Get
    End Property

    Public ReadOnly Property DefaultValues() As SetupDefault
        Get
            Return _default
        End Get
    End Property
End Class
