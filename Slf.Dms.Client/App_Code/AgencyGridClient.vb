Imports Microsoft.VisualBasic


Public Class AgencyGridClient
    Private _AccountNumber As String
    Private _LeadNumber As String
    Private _DateSent As DateTime
    Private _DateReceived As DateTime
    Private _FirstName As String
    Private _LastName As String
    Private _SSN As String
    Private _PaymentType As String
    Private _SeidemanPullDate As DateTime
    Private _PaymentAmount As Single
    Private _DebtTotal As Single
    Private _MissingInfo As String
    Private _Comments As String
    Private _ReceivedLSA As Boolean
    Private _ClientStatusName As String

    Public Sub New()

    End Sub

    Public Property ClientStatusName() As String
        Get
            Return _ClientStatusName
        End Get
        Set(ByVal value As String)
            _ClientStatusName = value
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
    Public Property LeadNumber() As String
        Get
            Return _LeadNumber
        End Get
        Set(ByVal value As String)
            _LeadNumber = value
        End Set
    End Property
    Public Property FirstName() As String
        Get
            Return _FirstName
        End Get
        Set(ByVal value As String)
            _FirstName = value
        End Set
    End Property
    Public Property LastName() As String
        Get
            Return _LastName
        End Get
        Set(ByVal value As String)
            _LastName = value
        End Set
    End Property
    Public Property SSN() As String
        Get
            Return _SSN
        End Get
        Set(ByVal value As String)
            _SSN = value
        End Set
    End Property
    Public Property DepositMethod() As String
        Get
            Return _PaymentType
        End Get
        Set(ByVal value As String)
            _PaymentType = value
        End Set
    End Property
    Public Property MissingInfo() As String
        Get
            Return _MissingInfo
        End Get
        Set(ByVal value As String)
            _MissingInfo = value
        End Set
    End Property
    Public Property Comments() As String
        Get
            Return _Comments
        End Get
        Set(ByVal value As String)
            _Comments = value
        End Set
    End Property
    Public Property DateSent() As DateTime
        Get
            Return _DateSent
        End Get
        Set(ByVal value As DateTime)
            _DateSent = value
        End Set
    End Property
    Public Property DateReceived() As DateTime
        Get
            Return _DateReceived
        End Get
        Set(ByVal value As DateTime)
            _DateReceived = value
        End Set
    End Property
    Public Property SeidemanPullDate() As DateTime
        Get
            Return _SeidemanPullDate
        End Get
        Set(ByVal value As DateTime)
            _SeidemanPullDate = value
        End Set
    End Property
    Public Property DebtTotal() As Single
        Get
            Return _DebtTotal
        End Get
        Set(ByVal value As Single)
            _DebtTotal = value
        End Set
    End Property
    Public Property DepositAmount() As Single
        Get
            Return _PaymentAmount
        End Get
        Set(ByVal value As Single)
            _PaymentAmount = value
        End Set
    End Property
    Public Property ReceivedLSA() As Boolean
        Get
            Return _ReceivedLSA
        End Get
        Set(ByVal value As Boolean)
            _ReceivedLSA = value
        End Set
    End Property
End Class