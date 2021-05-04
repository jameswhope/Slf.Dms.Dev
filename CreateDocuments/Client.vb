

Public Class Client

#Region "Fields"

    Dim _FullName As String
    Dim _DocumentDisplayName As String
    Dim _SettlementId As Integer
    Dim _TotalPages As Integer
    Dim _LastDateModififed As DateTime
    Dim _EmailAddress As String
    Dim _ClientId As Integer
    Dim _CreditorName As String
    Dim _SettlementAmount As Double
    Dim _SettlementDueDate As DateTime

#End Region 'Fields

#Region "Properties"

    Public Property FullName() As String
        Get
            Return _FullName
        End Get
        Set(ByVal value As String)
            _FullName = value
        End Set
    End Property
    Public Property DocumentName() As String
        Get
            Return _DocumentDisplayName
        End Get
        Set(ByVal value As String)
            _DocumentDisplayName = value
        End Set
    End Property
    Public Property SettlementId() As Integer
        Get
            Return _SettlementId
        End Get
        Set(ByVal value As Integer)
            _SettlementId = value
        End Set
    End Property
    Public Property TotalPages() As Integer
        Get
            Return _TotalPages
        End Get
        Set(ByVal value As Integer)
            _TotalPages = value
        End Set
    End Property
    Public Property LastDateModififed() As DateTime
        Get
            Return _LastDateModififed
        End Get
        Set(ByVal value As DateTime)
            _LastDateModififed = value
        End Set
    End Property
    Public Property EmailAddress() As String
        Get
            Return _EmailAddress
        End Get
        Set(ByVal value As String)
            _EmailAddress = value
        End Set
    End Property
    Public Property ClientId() As Integer
        Get
            Return _ClientId
        End Get
        Set(ByVal value As Integer)
            _ClientId = value
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
    Public Property SettlementAmount() As Double
        Get
            Return _SettlementAmount
        End Get
        Set(ByVal value As Double)
            _SettlementAmount = value
        End Set
    End Property
    Public Property SettlementDueDate() As DateTime
        Get
            Return _SettlementDueDate
        End Get
        Set(ByVal value As DateTime)
            _SettlementDueDate = value
        End Set
    End Property

#End Region 'Properties

#Region "Constructors"

    Public Sub New()

    End Sub

#End Region 'Constructors

#Region "Methods"

#End Region 'End Methods


End Class
