Option Explicit On

Imports Drg.Util.Helpers

Public Class PhoneCall

#Region "Variables"

    Private _phonecallid As Integer
    Private _personid As Integer
    Private _personfirstname As String
    Private _personlastname As String
    Private _userid As Integer
    Private _userfirstname As String
    Private _userlastname As String
    Private _phonenumber As String
    Private _direction As Boolean
    Private _subject As String
    Private _body As String
    Private _starttime As DateTime
    Private _endtime As DateTime
    Private _clientid As Integer

    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String

    Private _approot As String

#End Region

#Region "Properties"

    ReadOnly Property PhoneCallID() As Integer
        Get
            Return _phonecallid
        End Get
    End Property
    ReadOnly Property PersonID() As Integer
        Get
            Return _personid
        End Get
    End Property
    ReadOnly Property PersonFirstName() As String
        Get
            Return _personfirstname
        End Get
    End Property
    ReadOnly Property PersonLastName() As String
        Get
            Return _personlastname
        End Get
    End Property
    ReadOnly Property UserID() As Integer
        Get
            Return _userid
        End Get
    End Property
    ReadOnly Property UserLastName() As String
        Get
            Return _userlastname
        End Get
    End Property
    ReadOnly Property UserFirstName() As String
        Get
            Return _userfirstname
        End Get
    End Property
    ReadOnly Property PhoneNumber() As String
        Get
            Return _phonenumber
        End Get
    End Property
    ReadOnly Property Direction() As Boolean
        Get
            Return _direction
        End Get
    End Property
    ReadOnly Property Subject() As String
        Get
            Return _subject
        End Get
    End Property
    ReadOnly Property Body() As String
        Get
            Return _body
        End Get
    End Property
    ReadOnly Property StartTime() As DateTime
        Get
            Return _starttime
        End Get
    End Property
    ReadOnly Property EndTime() As DateTime
        Get
            Return _endtime
        End Get
    End Property
    ReadOnly Property ClientID() As Integer
        Get
            Return _clientid
        End Get
    End Property
    ReadOnly Property Created() As DateTime
        Get
            Return _created
        End Get
    End Property
    ReadOnly Property CreatedBy() As Integer
        Get
            Return _createdby
        End Get
    End Property
    ReadOnly Property CreatedByName() As String
        Get
            Return _createdbyname
        End Get
    End Property
    ReadOnly Property LastModified() As DateTime
        Get
            Return _lastmodified
        End Get
    End Property
    ReadOnly Property LastModifiedBy() As Integer
        Get
            Return _lastmodifiedby
        End Get
    End Property
    ReadOnly Property LastModifiedByName() As String
        Get
            Return _lastmodifiedbyname
        End Get
    End Property
    ReadOnly Property PersonName() As String
        Get
            Return _personfirstname & " " & _personlastname
        End Get
    End Property
    ReadOnly Property DirectionFormatted() As String
        Get

            If _direction Then
                Return "TO"
            Else
                Return "FROM"
            End If

        End Get
    End Property
    ReadOnly Property Duration() As TimeSpan
        Get
            Return EndTime.Subtract(StartTime)
        End Get
    End Property
    ReadOnly Property DurationFormatted() As String
        Get

            Dim Length As String = String.Empty

            If Duration.TotalHours > 0 Then

                If Length.Length > 0 Then
                    Length += " "
                End If

                Length += Duration.TotalHours.ToString("0") & "H"

            End If

            If Duration.Minutes > 0 Then

                If Length.Length > 0 Then
                    Length += " "
                End If

                Length += Duration.Minutes & "M"

            End If

            If Duration.Seconds > 0 Then

                If Length.Length > 0 Then
                    Length += " "
                End If

                Length += Duration.Seconds & "S"

            End If

            Return StartTime.ToString("hh:mm tt") & " - " & EndTime.ToString("hh:mm tt") _
                & "<img style=""margin:0 5 0 5"" border=""0"" align=""absmiddle"" src=""" _
                & _approot & "images/16x16_arrowright (thin gray).png"" />" & Length

        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal PhoneCallID As Integer, ByVal PersonID As Integer, ByVal PersonFirstName As String, _
        ByVal PersonLastName As String, ByVal UserID As Integer, ByVal UserFirstName As String, _
        ByVal UserLastName As String, ByVal PhoneNumber As String, ByVal Direction As Boolean, _
        ByVal Subject As String, ByVal Body As String, ByVal StartTime As DateTime, ByVal EndTime As DateTime, _
        ByVal ClientID As Integer, ByVal Created As DateTime, ByVal CreatedBy As Integer, _
        ByVal CreatedByName As String, ByVal LastModified As DateTime, ByVal LastModifiedBy As Integer, _
        ByVal LastModifiedByName As String, ByVal AppRoot As String)

        _phonecallid = PhoneCallID
        _personid = PersonID
        _personfirstname = PersonFirstName
        _personlastname = PersonLastName
        _userid = UserID
        _userfirstname = UserFirstName
        _userlastname = UserLastName
        _phonenumber = PhoneNumber
        _direction = Direction
        _subject = Subject
        _body = Body
        _starttime = StartTime
        _endtime = EndTime
        _clientid = ClientID

        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName

        _approot = AppRoot

    End Sub

#End Region

End Class