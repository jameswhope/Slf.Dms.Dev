Option Explicit On

Public Class TabPage

#Region "Variables"

    Friend _index As Integer
    Private _caption As String
    Private _selected As Boolean
    Private _pageclientid As String
    Private _redirect As String

    Private _container As TabStrip

#End Region

#Region "Properties"

    Property PageClientID() As String
        Get
            Return _pageclientid
        End Get
        Set(ByVal value As String)
            _pageclientid = value
        End Set
    End Property
    ReadOnly Property Index() As Integer
        Get
            Return _index
        End Get
    End Property
    Property Caption() As String
        Get
            Return _caption
        End Get
        Set(ByVal value As String)
            _caption = value
        End Set
    End Property
    Property Selected() As Boolean
        Get
            Return _selected
        End Get
        Set(ByVal value As Boolean)

            _selected = value

            If _selected AndAlso Not _container Is Nothing AndAlso TypeOf _container Is TabStrip Then
                _container.SelectedIndex = _index
            End If

        End Set
    End Property
    Friend Property Container() As TabStrip
        Get
            Return _container
        End Get
        Set(ByVal value As TabStrip)
            _container = value
        End Set
    End Property
    Property Redirect() As String
        Get
            Return _redirect
        End Get
        Set(ByVal value As String)
            _redirect = value
        End Set
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal Caption As String, ByVal PageClientID As String)

        _caption = Caption
        _pageclientid = PageClientID

    End Sub
    Public Sub New(ByVal Caption As String, ByVal PageClientID As String, ByVal Redirect As String)

        _caption = Caption
        _pageclientid = PageClientID

        If Not String.IsNullOrEmpty(Redirect) Then
            _redirect = Redirect
        End If

    End Sub

#End Region

End Class