Public Class ExceptionInfo
    Private _code As Integer = 0
    Private _message As String = String.Empty

    Public Sub New()
    End Sub

    Public Sub New(ByVal code As Integer, ByVal Message As String)
        _code = code
        _message = Message
    End Sub

    Public Sub New(ByVal message As String)
        _message = message
    End Sub

    Public Property Code() As Integer
        Get
            Return _code
        End Get
        Set(ByVal value As Integer)
            _code = value
        End Set
    End Property

    Public Property Message() As String
        Get
            Return _message
        End Get
        Set(ByVal value As String)
            _message = value
        End Set
    End Property
End Class
