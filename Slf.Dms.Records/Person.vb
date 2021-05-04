Option Explicit On

Imports Drg.Util.Helpers

Public Class Person

#Region "Variables"

    Private _personid As Integer
    Private _clientid As Integer
    Private _ssn As String
    Private _firstname As String
    Private _lastname As String
    Private _gender As String
    Private _dateofbirth As Nullable(Of DateTime)
    Private _languageid As Integer
    Private _languagename As String
    Private _emailaddress As String
    Private _street As String
    Private _street2 As String
    Private _city As String
    Private _stateid As Integer
    Private _statename As String
    Private _stateabbreviation As String
    Private _zipcode As String
    Private _relationship As String
    Private _canauthorize As Boolean
    Private _thirdparty As Boolean
    Private _isdeceased As Boolean
    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String

#End Region

#Region "Properties"

    ReadOnly Property IsDeceased() As Boolean
        Get
            Return _isdeceased
        End Get
       
    End Property
    ReadOnly Property PersonID() As Integer
        Get
            Return _personid
        End Get
    End Property
    ReadOnly Property ClientID() As Integer
        Get
            Return _clientid
        End Get
    End Property
    ReadOnly Property SSN() As String
        Get
            Return _ssn
        End Get
    End Property
    ReadOnly Property SSNFormatted() As String
        Get
            Return StringHelper.PlaceInMask(_ssn, "___-__-____", "_", StringHelper.Filter.NumericOnly, False)
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
    ReadOnly Property Name() As String
        Get
            Return _firstname & " " & _lastname
        End Get
    End Property
    ReadOnly Property Gender() As String
        Get
            Return _gender
        End Get
    End Property
    ReadOnly Property Age() As Integer
        Get

            If _dateofbirth.HasValue Then

                ' get the difference in years
                Age = Now.Year - _dateofbirth.Value.Year

                ' subtract another year if we're before the birth day in the current year
                If Now.Month < _dateofbirth.Value.Month Or (Now.Month = _dateofbirth.Value.Month And Now.Day < _dateofbirth.Value.Day) Then
                    Age -= 1
                End If

            Else
                Return 0
            End If

        End Get
    End Property
    ReadOnly Property DateOfBirth() As Nullable(Of DateTime)
        Get
            Return _dateofbirth
        End Get
    End Property
    ReadOnly Property DateOfBirthFormatted() As String
        Get

            If _dateofbirth.HasValue Then
                Return _dateofbirth.Value.ToString("MM/dd/yyyy")
            Else
                Return String.Empty
            End If

        End Get
    End Property
    ReadOnly Property AgeAndDateOfBirth() As String
        Get

            If _dateofbirth.HasValue Then
                Return "(" & Age & ") " & _dateofbirth.Value.ToString("MMM d, yyyy")
            Else
                Return "&nbsp;"
            End If

        End Get
    End Property
    ReadOnly Property LanguageID() As Integer
        Get
            Return _languageid
        End Get
    End Property
    ReadOnly Property LanguageName() As String
        Get
            Return _languagename
        End Get
    End Property
    ReadOnly Property EmailAddress() As String
        Get
            Return _emailaddress
        End Get
    End Property
    ReadOnly Property Address() As String
        Get

            Address = String.Empty

            If Street.Length > 0 Then
                Address += Street
            End If

            If Street2.Length > 0 Then
                If Address.Length > 0 Then
                    Address += vbCrLf & Street2
                Else
                    Address += Street2
                End If
            End If

            If City.Length > 0 Then
                If Address.Length > 0 Then
                    Address += vbCrLf & City
                Else
                    Address += City
                End If
            End If

            If StateAbbreviation.Length > 0 Then
                If City.Length > 0 Then
                    Address += ", " & StateAbbreviation
                Else
                    If Address.Length > 0 Then
                        Address += vbCrLf & StateAbbreviation
                    Else
                        Address += StateAbbreviation
                    End If
                End If
            End If

            If ZipCode.Length > 0 Then
                If StateAbbreviation.Length > 0 Then
                    Address += " " & ZipCode
                ElseIf City.Length > 0 Then
                    Address += ", " & ZipCode
                Else
                    If Address.Length > 0 Then
                        Address += vbCrLf & ZipCode
                    Else
                        Address += ZipCode
                    End If
                End If
            End If

        End Get
    End Property
    ReadOnly Property Street() As String
        Get
            Return _street
        End Get
    End Property
    ReadOnly Property Street2() As String
        Get
            Return _street2
        End Get
    End Property
    ReadOnly Property City() As String
        Get
            Return _city
        End Get
    End Property
    ReadOnly Property StateID() As Integer
        Get
            Return _stateid
        End Get
    End Property
    ReadOnly Property StateName() As String
        Get
            Return _statename
        End Get
    End Property
    ReadOnly Property StateAbbreviation() As String
        Get
            Return _stateabbreviation
        End Get
    End Property
    ReadOnly Property ZipCode() As String
        Get
            Return _zipcode
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
    ReadOnly Property Relationship() As String
        Get
            Return _relationship
        End Get
    End Property
    ReadOnly Property CanAuthorize() As Boolean
        Get
            Return _canauthorize
        End Get
    End Property
    ReadOnly Property ThirdParty() As Boolean
        Get
            Return _thirdparty
        End Get
    End Property
    ReadOnly Property IconLock() As String
        Get

            If _canauthorize Then
                Return "16x16_lock.png"
            Else
                Return "16x16_empty.png"
            End If

        End Get
    End Property
    ReadOnly Property IconThirdParty() As String
        Get

            If _thirdparty Then
                Return "16x16_check.png"
            Else
                Return "16x16_empty.png"
            End If

        End Get
    End Property
    ReadOnly Property IconCheck() As String
        Get

            If _canauthorize Then
                Return "16x16_check.png"
            Else
                Return "16x16_empty.png"
            End If

        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal PersonID As Integer, ByVal ClientID As Integer, ByVal SSN As String, _
        ByVal FirstName As String, ByVal LastName As String, ByVal Gender As String, _
        ByVal DateOfBirth As Nullable(Of DateTime), ByVal LanguageID As Integer, ByVal LanguageName As String, _
        ByVal EmailAddress As String, ByVal Street As String, ByVal Street2 As String, ByVal City As String, _
        ByVal StateID As Integer, ByVal StateName As String, ByVal StateAbbreviation As String, _
        ByVal ZipCode As String, ByVal Relationship As String, ByVal CanAuthorize As Boolean, _
        ByVal ThirdParty As Boolean, ByVal Created As DateTime, ByVal CreatedBy As Integer, _
        ByVal CreatedByName As String, ByVal LastModified As DateTime, ByVal LastModifiedBy As Integer, _
        ByVal LastModifiedByName As String)

        _personid = PersonID
        _clientid = ClientID
        _ssn = SSN
        _firstname = FirstName
        _lastname = LastName
        _gender = Gender
        _dateofbirth = DateOfBirth
        _languageid = LanguageID
        _languagename = LanguageName
        _emailaddress = EmailAddress
        _street = Street
        _street2 = Street2
        _city = City
        _stateid = StateID
        _statename = StateName
        _stateabbreviation = StateAbbreviation
        _zipcode = ZipCode
        _relationship = Relationship
        _canauthorize = CanAuthorize
        _thirdparty = ThirdParty

        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName

    End Sub
    Public Sub New(ByVal PersonID As Integer, ByVal ClientID As Integer, ByVal SSN As String, _
        ByVal FirstName As String, ByVal LastName As String, ByVal Gender As String, _
        ByVal DateOfBirth As Nullable(Of DateTime), ByVal LanguageID As Integer, ByVal LanguageName As String, _
        ByVal EmailAddress As String, ByVal Street As String, ByVal Street2 As String, ByVal City As String, _
        ByVal StateID As Integer, ByVal StateName As String, ByVal StateAbbreviation As String, _
        ByVal ZipCode As String, ByVal Relationship As String, ByVal CanAuthorize As Boolean, _
        ByVal ThirdParty As Boolean, ByVal Created As DateTime, ByVal CreatedBy As Integer, _
        ByVal CreatedByName As String, ByVal LastModified As DateTime, ByVal LastModifiedBy As Integer, _
        ByVal LastModifiedByName As String, ByVal bIsDeceased As Boolean)

        _personid = PersonID
        _clientid = ClientID
        _ssn = SSN
        _firstname = FirstName
        _lastname = LastName
        _gender = Gender
        _dateofbirth = DateOfBirth
        _languageid = LanguageID
        _languagename = LanguageName
        _emailaddress = EmailAddress
        _street = Street
        _street2 = Street2
        _city = City
        _stateid = StateID
        _statename = StateName
        _stateabbreviation = StateAbbreviation
        _zipcode = ZipCode
        _relationship = Relationship
        _canauthorize = CanAuthorize
        _thirdparty = ThirdParty
        _isdeceased = bIsDeceased
        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName

    End Sub
#End Region

End Class