Option Explicit On

Public Class UserActivity

#Region "Property"

    Private _userid As Integer
    Private _username As String
    Private _type As String
    Private _typeid As Integer
    Private _activity As String
    Private _when As DateTime

    Private _approot As String

#End Region

#Region "Variables"

    ReadOnly Property UserID() As Integer
        Get
            Return _userid
        End Get
    End Property
    ReadOnly Property UserName() As String
        Get
            Return _username
        End Get
    End Property
    ReadOnly Property Type() As String
        Get
            Return _type
        End Get
    End Property
    ReadOnly Property TypeID() As Integer
        Get
            Return _typeid
        End Get
    End Property
    ReadOnly Property Activity() As String
        Get
            Return _activity
        End Get
    End Property
    ReadOnly Property [When]() As DateTime
        Get
            Return _when
        End Get
    End Property
    ReadOnly Property Icon()
        Get
            Select Case Type.ToLower()
                Case "visited client"
                    Return _approot & "images/16x16_person.png"
                Case "visited task"
                    Return _approot & "images/16x16_calendar.png"
                Case "searched for"
                    Return _approot & "images/16x16_search.png"
                Case Else
                    Return _approot & "images/16x16_empty.png"
            End Select
        End Get
    End Property
    ReadOnly Property Link()
        Get
            Select Case Type.ToLower()
                Case "visited client"
                    Return _approot & "clients/client/?id=" & _typeid
                Case "visited task"
                    Return _approot & "tasks/task/?id=" & _typeid
                Case "searched for"
                    Return _approot & "search.aspx?q=" & _activity
                Case Else
                    Return _approot & "#"
            End Select
        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal UserID As Integer, ByVal UserName As String, ByVal Type As String, _
        ByVal TypeID As Integer, ByVal Activity As String, ByVal [When] As DateTime, ByVal AppRoot As String)

        _userid = UserID
        _username = UserName
        _type = Type
        _typeid = TypeID
        _activity = Activity
        _when = [When]
        _approot = AppRoot

    End Sub

#End Region

End Class