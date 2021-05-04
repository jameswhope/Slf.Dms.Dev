Public Enum Genders
    u = 0
    m = 1
    f = 2
End Enum

Public Enum Languages
    english = 1
    spanish = 2
End Enum

Public Enum PersonalRelationType
    unknown = 0
    self = 1
    spouse = 2
    father = 3
    mother = 4
    brother = 5
    sister = 6
    son = 7
    daughter = 8
    coworker = 9
    [friend] = 10
    other = 99
End Enum

Public Class PersonInfo
    Private _id As Integer = 0
    Private _clientid As Integer = 0
    Private _firstName As String = String.Empty
    Private _middleName As String = String.Empty
    Private _lastName As String = String.Empty
    Private _ssn As String = String.Empty
    Private _address As AddressInfo
    Private _phones As New List(Of PhoneInfo)
    Private _gender As Genders = Genders.u
    Private _dob As Date
    Private _language As Languages = Languages.english
    Private _email As String = String.Empty
    Private _canAuthorize As Boolean = False
    Private _isThirdParty As Boolean = False
    Private _relationship As PersonalRelationType = PersonalRelationType.unknown

    Public Property ID() As Integer
        Get
            Return _id
        End Get
        Set(ByVal value As Integer)
            _id = value
        End Set
    End Property

    Public Property FirstName() As String
        Get
            Return _firstName
        End Get
        Set(ByVal value As String)
            _firstName = value
        End Set
    End Property

    Public Property MiddleName() As String
        Get
            Return _middleName
        End Get
        Set(ByVal value As String)
            _middleName = value
        End Set
    End Property

    Public Property LastName() As String
        Get
            Return _lastName
        End Get
        Set(ByVal value As String)
            _lastName = value
        End Set
    End Property

    Public ReadOnly Property FirstAndMidName() As String
        Get
            Return String.Format("{0} {1}", _firstName, _middleName).Trim
        End Get
    End Property

    Public ReadOnly Property FullName() As String
        Get
            Return String.Format("{0} {1} {2}", _firstName, _middleName, _lastName).Trim
        End Get
    End Property

    Public Property SSN() As String
        Get
            Return _ssn
        End Get
        Set(ByVal value As String)
            _ssn = value.Trim.Replace("-", "").Replace(" ", "")
            'If _ssn.Length > 0 AndAlso Not Int64.TryParse(_ssn, Nothing) Then Throw New Exception("SSN is invalid")
            If _ssn.Length = 0 Then Throw New Exception("SSN is required")
        End Set
    End Property

    Public Property Address() As AddressInfo
        Get
            Return _address
        End Get
        Set(ByVal value As AddressInfo)
            _address = value
        End Set
    End Property

    Public Property Phones() As List(Of PhoneInfo)
        Get
            Return _phones
        End Get
        Set(ByVal value As List(Of PhoneInfo))
            _phones = value
        End Set
    End Property

    Public Function GetGenderName(ByVal PersonGender As Genders) As String
        Select Case PersonGender
            Case Genders.f
                Return "Female"
            Case Genders.m
                Return "Male"
            Case Else
                Return "Unknown"
        End Select
    End Function


    Public Property Gender() As Genders
        Get
            Return _gender
        End Get
        Set(ByVal value As Genders)
            _gender = value
        End Set
    End Property

    Public Property DateOfBirth() As Date
        Get
            Return _dob
        End Get
        Set(ByVal value As Date)
            _dob = value
        End Set
    End Property

    Public Property Language() As Languages
        Get
            Return _language
        End Get
        Set(ByVal value As Languages)
            If System.Array.IndexOf([Enum].GetValues(GetType(Languages)), value) = -1 Then
                Throw New Exception("Invalid Language")
            End If
            _language = value
        End Set
    End Property

    Public Property Email() As String
        Get
            Return _email
        End Get
        Set(ByVal value As String)
            _email = value
        End Set
    End Property

    Public Property CanAuthorize() As Boolean
        Get
            Return _canAuthorize
        End Get
        Set(ByVal value As Boolean)
            _canAuthorize = value
        End Set
    End Property

    Public Property IsThirdParty() As Boolean
        Get
            Return _isThirdParty
        End Get
        Set(ByVal value As Boolean)
            _isThirdParty = value
        End Set
    End Property

    Public Property RelationshipWithPrincipalApplicant() As PersonalRelationType
        Get
            Return _relationship
        End Get
        Set(ByVal value As PersonalRelationType)
            _relationship = value
        End Set
    End Property

    Public Shared Function GetRelationshipName(ByVal PersonRelationship As PersonalRelationType) As String
        Select Case PersonRelationship
            Case PersonalRelationType.other
                Return "other"
            Case PersonalRelationType.self
                Return "prime"
            Case PersonalRelationType.spouse
                Return "spouse"
            Case PersonalRelationType.father
                Return "father"
            Case PersonalRelationType.mother
                Return "mother"
            Case PersonalRelationType.sister
                Return "sister"
            Case PersonalRelationType.brother
                Return "brother"
            Case PersonalRelationType.son
                Return "son"
            Case PersonalRelationType.daughter
                Return "daughter"
            Case PersonalRelationType.coworker
                Return "coworker"
            Case PersonalRelationType.friend
                Return "friend"
            Case Else
                Return "unknown"
        End Select
    End Function

    Public Property ClientId() As Integer
        Get
            Return _clientid
        End Get
        Set(ByVal value As Integer)
            _clientid = value
        End Set
    End Property

End Class
