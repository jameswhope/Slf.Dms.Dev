Public Class AccountInfo
    Private _creditor As CreditorInfo
    Private _accountnumber As String = String.Empty
    Private _balance As Decimal = 0
    Private _dueDate As Date
    Private _acquired As Date
    Private _id As Integer = 0

    Public Property Id() As Integer
        Get
            Return _id
        End Get
        Set(ByVal value As Integer)
            _id = value
        End Set
    End Property

    Public Property AccountNumber() As String
        Get
            Return _accountnumber
        End Get
        Set(ByVal value As String)
            _accountnumber = value
        End Set
    End Property

    Public Property Balance() As Decimal
        Get
            Return _balance
        End Get
        Set(ByVal value As Decimal)
            _balance = value
        End Set
    End Property

    Public Property Creditor() As CreditorInfo
        Get
            Return _creditor
        End Get
        Set(ByVal value As CreditorInfo)
            _creditor = value
        End Set
    End Property

    Public Property Acquired() As Date
        Get
            Return _Acquired
        End Get
        Set(ByVal value As Date)
            _Acquired = value
        End Set
    End Property

    Public Property DueDate() As Date
        Get
            Return _dueDate
        End Get
        Set(ByVal value As Date)
            _dueDate = value
        End Set
    End Property
End Class
