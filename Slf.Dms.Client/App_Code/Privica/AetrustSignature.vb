Public Class AetrustSignature

    Private _signature As String
    Private _timestamp As Long

    Public Sub New(ByVal signature As String, ByVal timestamp As Long)
        _signature = signature
        _timestamp = timestamp
    End Sub

    Public Property Signature() As String
        Get
            Return _signature
        End Get
        Private Set(ByVal value As String)
            _signature = value
        End Set
    End Property

    Public Property Timestamp() As String
        Get
            Return _timestamp
        End Get
        Private Set(ByVal value As String)
            _timestamp = value
        End Set
    End Property

End Class