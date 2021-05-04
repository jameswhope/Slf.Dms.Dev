Option Explicit On

Public Class User

#Region "Properties"

    Private _userid As Integer
    Private _username As String
    Private _password As String
    Private _firstname As String
    Private _lastname As String
    Private _emailaddress As String
    Private _superuser As Boolean
    Private _locked As Boolean
    Private _temporary As Boolean

    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String

    Private _approot As String

#End Region

#Region "Properties"

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
    ReadOnly Property Password() As String
        Get
            Return _password
        End Get
    End Property
    ReadOnly Property FirstName() As String
        Get
            Return _firstname
        End Get
    End Property
    ReadOnly Property LastName() As String
        Get
            Return _lastname
        End Get
    End Property
    ReadOnly Property EmailAddress() As String
        Get
            Return _emailaddress
        End Get
    End Property
    ReadOnly Property SuperUser() As Boolean
        Get
            Return _superuser
        End Get
    End Property
    ReadOnly Property SuperUserFormatted() As String
        Get
            Return GetIconSource(_superuser, "images/16x16_check.png")
        End Get
    End Property
    ReadOnly Property Locked() As Boolean
        Get
            Return _locked
        End Get
    End Property
    ReadOnly Property LockedFormatted() As String
        Get
            Return GetIconSource(_locked, "images/16x16_check.png")
        End Get
    End Property
    ReadOnly Property Temporary() As Boolean
        Get
            Return _temporary
        End Get
    End Property
    ReadOnly Property TemporaryFormatted() As String
        Get
            Return GetIconSource(_temporary, "images/16x16_check.png")
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
    ReadOnly Property LastModifedBy() As Integer
        Get
            Return _lastmodifiedby
        End Get
    End Property
    ReadOnly Property LastModifiedByName() As String
        Get
            Return _lastmodifiedbyname
        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal UserID As Integer, ByVal UserName As String, ByVal Password As String, _
        ByVal FirstName As String, ByVal LastName As String, ByVal EmailAddress As String, _
        ByVal SuperUser As Boolean, ByVal Locked As Boolean, ByVal Temporary As Boolean, _
        ByVal Created As DateTime, ByVal CreatedBy As Integer, ByVal CreatedByName As String, _
        ByVal LastModified As DateTime, ByVal LastModifiedBy As Integer, _
        ByVal LastModifiedByName As String, ByVal AppRoot As String)

        _userid = UserID
        _username = UserName
        _password = Password
        _firstname = FirstName
        _lastname = LastName
        _emailaddress = EmailAddress
        _superuser = SuperUser
        _locked = Locked
        _temporary = Temporary

        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName

        _approot = AppRoot

    End Sub

#End Region

    Private Function GetIconSource(ByVal Value As Boolean, ByVal TrueSrc As String) As String
        Return GetIconSource(Value, TrueSrc, Nothing)
    End Function
    Private Function GetIconSource(ByVal Value As Boolean, ByVal TrueSrc As String, ByVal FalseSrc As String) As String

        If Value Then
            Return "<img src=""" & _approot & TrueSrc & """ border=""0"" align=""absmiddle"" />"
        Else
            If Not FalseSrc Is Nothing AndAlso FalseSrc.Length > 0 Then
                Return "<img src=""" & _approot & FalseSrc & """ border=""0"" align=""absmiddle"" />"
            Else
                Return "&nbsp;"
            End If
        End If

    End Function

End Class