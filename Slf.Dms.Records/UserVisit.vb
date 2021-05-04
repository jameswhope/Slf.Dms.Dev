Option Explicit On

Public Class UserVisit

#Region "Variables"

    Private _uservisitid As Integer
    Private _userid As Integer
    Private _type As String
    Private _typeid As Integer
    Private _display As String
    Private _visit As DateTime

#End Region

#Region "Properties"

    ReadOnly Property UserVisitID() As Integer
        Get
            Return _uservisitid
        End Get
    End Property
    ReadOnly Property UserID() As Integer
        Get
            Return _userid
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
    ReadOnly Property Display() As String
        Get
            Return _display
        End Get
    End Property
    ReadOnly Property Visit() As DateTime
        Get
            Return _visit
        End Get
    End Property
    ReadOnly Property Icon() As String
        Get

            Select Case Type.ToLower
                Case "task"
                    Return "12x12_calendar.png"
                Case "client"
                    Return "12x12_person.png"
                Case Else
                    Return ""
            End Select

        End Get
    End Property
    ReadOnly Property IconLarge() As String
        Get

            Select Case Type.ToLower
                Case "task"
                    Return "16x16_calendar.png"
                Case "client"
                    Return "16x16_person.png"
                Case Else
                    Return ""
            End Select

        End Get
    End Property
    ReadOnly Property Link() As String
        Get

            Select Case Type.ToLower
                Case "task"
                    Return "tasks/task/resolve.aspx?id=" & TypeID
                Case "client"
                    Return "clients/client/?id=" & TypeID
                Case Else
                    Return ""
            End Select

        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal UserVisitID As Integer, ByVal UserID As Integer, ByVal Type As String, _
        ByVal TypeID As Integer, ByVal Display As String, ByVal Visit As DateTime)

        _uservisitid = UserVisitID
        _userid = UserID
        _type = Type
        _typeid = TypeID
        _display = Display
        _visit = Visit

    End Sub

#End Region

End Class