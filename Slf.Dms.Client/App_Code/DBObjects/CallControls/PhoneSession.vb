Imports Microsoft.VisualBasic
Imports ININ.IceLib.Connection
Imports ININ.IceLib.Interactions
Imports System.Web.Caching

Public Class PhoneSession

    Private _SessionId As String
    Private _Session As ININ.IceLib.Connection.Session
    Private _Queue As InteractionQueue
    Private _User As UserInfo

    Public Sub Create(ByVal IceSessionId As String, ByVal IceUser As UserInfo, ByVal IceSession As ININ.IceLib.Connection.Session, ByVal IceQueue As InteractionQueue)
        _SessionId = IceSessionId
        _User = IceUser
        _Session = IceSession
        _Queue = IceQueue
    End Sub

    Public Property SessionId() As String
        Get
            Return _SessionId
        End Get
        Set(ByVal value As String)
            _SessionId = value
        End Set
    End Property

    Public Property Session() As ININ.IceLib.Connection.Session
        Get
            Return _Session
        End Get
        Set(ByVal value As ININ.IceLib.Connection.Session)
            _Session = value
        End Set
    End Property

    Public Property Queue() As InteractionQueue
        Get
            Return _Queue
        End Get
        Set(ByVal value As InteractionQueue)
            _Queue = value
        End Set
    End Property

    Public Property User() As UserInfo
        Get
            Return _User
        End Get
        Set(ByVal value As UserInfo)
            _User = value
        End Set
    End Property
    



End Class
