Public Enum BankAccountType
    unknown = 0
    checking = 1
    savings = 2
End Enum

Public Class BankAccountInfo
    Private _id As Integer = 0
    Private _routingNumber As String = String.Empty
    Private _accountNumber As String = String.Empty
    Private _accountType As BankAccountType = BankAccountType.unknown
    Private _bankName As String = String.Empty
    Private _address As AddressInfo
    Private _phone As PhoneInfo

    Public Property Id() As Integer
        Get
            Return _id
        End Get
        Set(ByVal value As Integer)
            _id = value
        End Set
    End Property

    Public Shared ReadOnly Property GetBankAccountTypeName(ByVal type As BankAccountType) As String
        Get
            Select Case type
                Case BankAccountType.checking
                    Return "Checking"
                Case BankAccountType.savings
                    Return "Savings"
                Case Else
                    Return "Unknown"
            End Select
        End Get
    End Property

    Public Property RoutingNumber() As String
        Get
            Return _routingNumber
        End Get
        Set(ByVal value As String)
            _routingNumber = value
        End Set
    End Property

    Public Property AccountNumber() As String
        Get
            Return _accountNumber
        End Get
        Set(ByVal value As String)
            _accountNumber = value
        End Set
    End Property

    Public Property Type() As BankAccountType
        Get
            Return _accountType
        End Get
        Set(ByVal value As BankAccountType)
            _accountType = value
        End Set
    End Property

    Public Property Name() As String
        Get
            Return _bankName
        End Get
        Set(ByVal value As String)
            _bankName = value
        End Set
    End Property

    Public Property Address() As AddressInfo
        Get
            Return _address
        End Get
        Set(ByVal value As AddressInfo)
            _address = value
        End Set
    End Property

    Public Property Phone() As PhoneInfo
        Get
            Return _phone
        End Get
        Set(ByVal value As PhoneInfo)
            _phone = value
        End Set
    End Property

    Public Shared Function IsValidRouting(ByRef Routing As String, ByRef BankName As String) As Boolean
        Dim store As New WCFClient.Store
        Return store.RoutingIsValid(Routing, BankName)
    End Function

End Class
