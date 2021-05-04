Public Enum DepositMethodType
    unknown = 0
    ach = 1
    check = 2
End Enum

Public Enum DepositFrequencyType
    month = 0
    week = 1
End Enum

Public Class DepositDayInfo
    Private _id As Integer = 0
    Private _depositday As Integer = 1
    Private _frequency As DepositFrequencyType = DepositFrequencyType.month
    Private _amount As Decimal = 0
    Private _occurrence As Integer = 0
    Private _bankAccount As BankAccountInfo
    Private _depositMethod As DepositMethodType = DepositMethodType.unknown

    Public Property Id() As Integer
        Get
            Return _id
        End Get
        Set(ByVal value As Integer)
            _id = value
        End Set
    End Property

    Public Property DepositDay() As Integer
        Get
            Return _depositday
        End Get
        Set(ByVal value As Integer)
            _depositday = value
        End Set
    End Property

    Public Property Frequency() As DepositFrequencyType
        Get
            Return _frequency
        End Get
        Set(ByVal value As DepositFrequencyType)
            _frequency = value
        End Set
    End Property

    Public Property Amount() As Decimal
        Get
            Return _amount
        End Get
        Set(ByVal value As Decimal)
            _amount = value
        End Set
    End Property

    Public Property Occurrence() As Integer
        Get
            Return _occurrence
        End Get
        Set(ByVal value As Integer)
            _occurrence = value
        End Set
    End Property

    Public Property BankAccount() As BankAccountInfo
        Get
            Return _bankAccount
        End Get
        Set(ByVal value As BankAccountInfo)
            _bankAccount = value
        End Set
    End Property

    Public Property DepositMethod() As DepositMethodType
        Get
            Return _depositMethod
        End Get
        Set(ByVal value As DepositMethodType)
            _depositMethod = value
        End Set
    End Property

    Public Shared Function GetFrequencyName(ByVal DayFrequency As DepositFrequencyType) As String
        Select Case DayFrequency
            Case DepositFrequencyType.week
                Return "week"
            Case Else
                Return "month"
        End Select
    End Function
End Class

Public Class SetupInfo
    Private _settlementFeePercent As Decimal = 0
    Private _maintenanceFee As Decimal = 0
    Private _subseqMaintenanceFee As Nullable(Of Decimal)
    Private _setupPercentFee As Integer = 0
    Private _initialAgencyPercent As Decimal = 0
    Private _depositdays As List(Of DepositDayInfo)
    Private _depositstartdate As Date
    Private _firstdepositdate As Date
    Private _firsttdepositamount As Decimal = 0
    Private _depositmethod As DepositMethodType = DepositMethodType.unknown
    Private _subseqMaintenanceFeeStartDate As Date
    Private _maintenanceFeeCap As Nullable(Of Decimal)
    Private _additionalAccountFee As Decimal = 0

    Public Shared Function GetDepositMethodName(ByVal methodtype As DepositMethodType) As String
        Select Case methodtype
            Case DepositMethodType.ach
                Return "ACH"
            Case DepositMethodType.check
                Return "Check"
            Case Else
                Return "Unknown"
        End Select
    End Function

    Public Property SettlementFeePercent() As Decimal
        Get
            Return _settlementFeePercent
        End Get
        Set(ByVal value As Decimal)
            _settlementFeePercent = value
        End Set
    End Property

    Public Property MaintenanceFeeAmount() As Decimal
        Get
            Return _maintenanceFee
        End Get
        Set(ByVal value As Decimal)
            _maintenanceFee = value
        End Set
    End Property

    Public Property SubSeqMaintenanceFeeAmount() As Nullable(Of Decimal)
        Get
            Return _subseqMaintenanceFee
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            _subseqMaintenanceFee = value
        End Set
    End Property

    Public Property SubSeqMaintenanceFeeStartDate() As Date
        Get
            Return _subseqMaintenanceFeeStartDate
        End Get
        Set(ByVal value As Date)
            _subseqMaintenanceFeeStartDate = value
        End Set
    End Property

    Public Property MaintenanceFeeCap() As Nullable(Of Decimal)
        Get
            Return _maintenanceFeeCap
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            _maintenanceFeeCap = value
        End Set
    End Property

    Public Property SetupFeePercent() As Decimal
        Get
            Return _setupPercentFee
        End Get
        Set(ByVal value As Decimal)
            _setupPercentFee = value
        End Set
    End Property

    Public Property DepositDays() As List(Of DepositDayInfo)
        Get
            Return _depositdays
        End Get
        Set(ByVal value As List(Of DepositDayInfo))
            _depositdays = value
        End Set
    End Property

    Public Property DepositsStartDate() As Date
        Get
            Return _depositstartdate
        End Get
        Set(ByVal value As Date)
            _depositstartdate = value
        End Set
    End Property

    Public Property FirstDepositDate() As Date
        Get
            Return _firstdepositdate
        End Get
        Set(ByVal value As Date)
            _firstdepositdate = value
        End Set
    End Property

    Public Property FirstDepositAmount() As Decimal
        Get
            Return _firsttdepositamount
        End Get
        Set(ByVal value As Decimal)
            _firsttdepositamount = value
        End Set
    End Property

    Public Property DepositMethod() As DepositMethodType
        Get
            Return _depositmethod
        End Get
        Set(ByVal value As DepositMethodType)
            _depositmethod = value
        End Set
    End Property

    Public Property InitialAgencyPercent() As Decimal
        Get
            Return _initialAgencyPercent
        End Get
        Set(ByVal value As Decimal)
            _initialAgencyPercent = value
        End Set
    End Property

    Public Property AdditionalAccountFee() As Decimal
        Get
            Return _additionalAccountFee
        End Get
        Set(ByVal value As Decimal)
            _additionalAccountFee = value
        End Set
    End Property
End Class
