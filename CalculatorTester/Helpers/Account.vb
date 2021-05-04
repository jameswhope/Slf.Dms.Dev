Public Class Account

#Region "Fields"

    Dim _AccountIdentifier As Integer               'Primary Key ID
    Dim _ApplicantId As Integer                        'Person ID Linked To The Account

    Dim _AccountNumber As String
    Dim _AccountBalance As Double
    Dim _MinimumPayment As Double
    Dim _InterestRate As Double
    Dim _AccountType As String
    Dim _AccountStatus As String
    Dim _LoanType As String

    Dim _LateThirtyDays As Boolean
    Dim _LateSixtyDays As Boolean
    Dim _LateNinetyDays As Boolean
    Dim _LateOneTwentyDays As Boolean

    'Create Class
    Dim _CreditorGroup As String
    Dim _CreditorId As Integer
    Dim _CreditorName As String

    Dim _Street1 As String
    Dim _Street2 As String
    Dim _City As String
    Dim _State As Integer
    Dim _ZipCode As Integer
    Dim _Phone As String
    Dim _Extension As String
    'End Class

#End Region 'Fields

#Region "Properties"

    Public Property AccountIdentifier() As Integer
        Get
            Return _AccountIdentifier
        End Get
        Set(ByVal value As Integer)
            _AccountIdentifier = value
        End Set
    End Property

    Public Property ApplicantId() As Integer
        Get
            Return _ApplicantId
        End Get
        Set(ByVal value As Integer)
            _ApplicantId = value
        End Set
    End Property

    Public Property AccountNumber() As String
        Get
            Return _AccountNumber
        End Get
        Set(ByVal value As String)
            _AccountNumber = value
        End Set
    End Property

    Public Property AccountBalance() As Double
        Get
            Return _AccountBalance
        End Get
        Set(ByVal value As Double)
            _AccountBalance = value
        End Set
    End Property

    Public Property MinimumPayment() As Double
        Get
            Return _MinimumPayment
        End Get
        Set(ByVal value As Double)
            _MinimumPayment = value
        End Set
    End Property

    Public Property InterestRate() As Double
        Get
            Return _InterestRate
        End Get
        Set(ByVal value As Double)
            _InterestRate = value
        End Set
    End Property

    Public Property AccountType() As String
        Get
            Return _AccountType
        End Get
        Set(ByVal value As String)
            _AccountType = value
        End Set
    End Property

    Public Property AccountStatus() As String
        Get
            Return _AccountStatus
        End Get
        Set(ByVal value As String)
            _AccountStatus = value
        End Set
    End Property

    Public Property LoanType() As String
        Get
            Return _LoanType
        End Get
        Set(ByVal value As String)
            _LoanType = value
        End Set
    End Property

    Public Property CreditorGroup() As String
        Get
            Return _CreditorGroup
        End Get
        Set(ByVal value As String)
            _CreditorGroup = value
        End Set
    End Property

    Public Property CreditorId() As Integer
        Get
            Return _CreditorId
        End Get
        Set(ByVal value As Integer)
            _CreditorId = value
        End Set
    End Property

    Public Property CreditorName() As String
        Get
            Return _CreditorName
        End Get
        Set(ByVal value As String)
            _CreditorName = value
        End Set
    End Property

    Public Property Street1() As String
        Get
            Return _Street1
        End Get
        Set(ByVal value As String)
            _Street1 = value
        End Set
    End Property

    Public Property Street2() As String
        Get
            Return _Street2
        End Get
        Set(ByVal value As String)
            _Street2 = value
        End Set
    End Property

    Public Property City() As String
        Get
            Return _City
        End Get
        Set(ByVal value As String)
            _City = value
        End Set
    End Property

    Public Property State() As Integer
        Get
            Return _State
        End Get
        Set(ByVal value As Integer)
            _State = value
        End Set
    End Property

    Public Property ZipCode() As Integer
        Get
            Return _ZipCode
        End Get
        Set(ByVal value As Integer)
            _ZipCode = value
        End Set
    End Property

    Public Property Phone() As String
        Get
            Return _Phone
        End Get
        Set(ByVal value As String)
            _Phone = value
        End Set
    End Property

    Public Property Extension() As String
        Get
            Return _Extension
        End Get
        Set(ByVal value As String)
            _Extension = value
        End Set
    End Property

    Public Property LateThirtyDays() As Boolean
        Get
            Return _LateThirtyDays
        End Get
        Set(ByVal value As Boolean)
            _LateThirtyDays = value
        End Set
    End Property

    Public Property LateSixtyDays() As Boolean
        Get
            Return _LateSixtyDays
        End Get
        Set(ByVal value As Boolean)
            _LateSixtyDays = value
        End Set
    End Property

    Public Property LateNinetyDays() As Boolean
        Get
            Return _LateNinetyDays
        End Get
        Set(ByVal value As Boolean)
            _LateNinetyDays = value
        End Set
    End Property

    Public Property LateOneTwentyDays() As Boolean
        Get
            Return _LateOneTwentyDays
        End Get
        Set(ByVal value As Boolean)
            _LateOneTwentyDays = value
        End Set
    End Property

#End Region 'Properties

#Region "Constructors"

    Public Sub New()

    End Sub

#End Region 'Constructors

#Region "Methods"


#End Region 'Methods





End Class
