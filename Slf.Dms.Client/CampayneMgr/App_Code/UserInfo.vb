Imports Microsoft.VisualBasic
Imports ININ.IceLib.Connection
Imports ININ.IceLib.Interactions

Public Class UserInfo

    Private _UserID As Integer
    Private _Username As String
    Private _Password As String
    Private _CICServer As String

    Public Property UserID() As Integer
        Get
            Return _UserID
        End Get
        Set(ByVal value As Integer)
            _UserID = value
        End Set
    End Property

    Public Property Username() As String
        Get
            Return _Username
        End Get
        Set(ByVal value As String)
            _Username = value
        End Set
    End Property

    Public Property Password() As String
        Get
            Return _Password
        End Get
        Set(ByVal value As String)
            _Password = value
        End Set
    End Property

    Public Property CICServer() As String
        Get
            Return _CICServer
        End Get
        Set(ByVal value As String)
            _CICServer = value
        End Set
    End Property

    Public Sub New(ByVal p_UserID As Integer, ByVal p_Username As String, ByVal p_Password As String, ByVal p_CICServer As String)
        _UserID = p_UserID
        _Username = p_Username
        _Password = p_Password
        _CICServer = p_CICServer
    End Sub

    Public Function CanConnectionOccur() As Boolean
        Return (_Username.Length > 0 AndAlso _Password.Length > 0 AndAlso _CICServer.Length > 0)
    End Function

End Class
