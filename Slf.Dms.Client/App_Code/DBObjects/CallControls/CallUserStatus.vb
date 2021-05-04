Imports Microsoft.VisualBasic

Public Class CallUserStatus
    Private _ID As String
    Private _Description As String

    Public Sub New(ByVal StatusId As String, ByVal StatusDescription As String)
        _ID = StatusId
        _Description = StatusDescription
    End Sub

    Public Property ID() As String
        Get
            Return _ID
        End Get
        Set(ByVal value As String)
            _ID = value
        End Set
    End Property

    Public Property Description() As String
        Get
            Return _Description
        End Get
        Set(ByVal value As String)
            _Description = value
        End Set
    End Property

End Class
