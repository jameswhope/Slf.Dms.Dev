Imports Microsoft.VisualBasic

Public Class CallEventArgs
    Private _callidkey As String = String.Empty
    Private _remoteNumber As String = String.Empty
    Private _clientId As String = String.Empty
    Private _intercomParty As String = String.Empty
    Private _isDialerCall As Boolean = False
    Private _isCIDDialerCall As Boolean = False
    Private _isDialerINCall As Boolean = False
    Private _DialerCallMadeId As Integer
    Private _AppointmentId As Integer = 0
    Private _WorkGroupQueue As String = ""

    Public Sub New(ByVal CallId As String)
        _callidkey = CallId
    End Sub

    Public Property CallIdKey() As String
        Get
            Return _callidkey
        End Get
        Set(ByVal value As String)
            _callidkey = value
        End Set
    End Property

    Public Property RemoteNumber() As String
        Get
            Return _remoteNumber
        End Get
        Set(ByVal value As String)
            _remoteNumber = value
        End Set
    End Property

    Public Property ClientId() As String
        Get
            Return _clientId
        End Get
        Set(ByVal value As String)
            _clientId = value
        End Set
    End Property

    Public Property IntercomParty() As String
        Get
            Return _intercomParty
        End Get
        Set(ByVal value As String)
            _intercomParty = value
        End Set
    End Property

    Public Property IsDialerCall() As Boolean
        Get
            Return _isDialerCall
        End Get
        Set(ByVal value As Boolean)
            _isDialerCall = value
        End Set
    End Property

    Public Property IsCIDDialerCall() As Boolean
        Get
            Return _isCIDDialerCall
        End Get
        Set(ByVal value As Boolean)
            _isCIDDialerCall = value
        End Set
    End Property

    Public Property IsDialerINCall() As Boolean
        Get
            Return _isDialerINCall
        End Get
        Set(ByVal value As Boolean)
            _isDialerINCall = value
        End Set
    End Property

    Public Property DialerCallMadeId() As Integer
        Get
            Return _DialerCallMadeId
        End Get
        Set(ByVal value As Integer)
            _DialerCallMadeId = value
        End Set
    End Property

    Public Property AppointmentId() As Integer
        Get
            Return _AppointmentId
        End Get
        Set(ByVal value As Integer)
            _AppointmentId = value
        End Set
    End Property

    Public Property WorkgroupQueue() As String
        Get
            Return _WorkGroupQueue
        End Get
        Set(ByVal value As String)
            _WorkGroupQueue = value
        End Set
    End Property


End Class
