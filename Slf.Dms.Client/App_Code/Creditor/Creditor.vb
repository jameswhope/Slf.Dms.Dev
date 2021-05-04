Imports Microsoft.VisualBasic
Imports col
Imports System.Collections.Generic

Public Class Creditor


#Region "Fields"
    'creditor account class being pulled into crdditor class
    Protected _CreditorAccount As New List(Of CreditorAccount)
    'creditor
    Protected _creditorName As String
    Protected _memberCode As String
    Protected _MethodOfContact As String
    Protected _Exists As String
    'address
    Protected _Address As String
    Protected _Address2 As String
    Protected _City As String
    Protected _State As String
    Protected _ZipCode As String
    'phone
    Protected _PhoneType As String
    Protected _AvailabilityCode As String
    Protected _AreaCode As String
    Protected _PhoneNumber As String
    Protected _ExtensionNumber As String
#End Region 'Fields

#Region "Properties"
    'CreditorAccount class
    Public Property CreditorAccount() As List(Of CreditorAccount)
        Get
            Return _CreditorAccount
        End Get
        Set(value As List(Of CreditorAccount))
            _CreditorAccount = value
        End Set
    End Property
    'creditor
    Public Property CreditorName() As String
        Get
            Return _creditorName
        End Get
        Set(value As String)
            _creditorName = value
        End Set
    End Property
    Public Property MemberCode() As String
        Get
            Return _memberCode
        End Get
        Set(value As String)
            _memberCode = value
        End Set
    End Property
    Public Property MethodOfContact() As String
        Get
            Return _MethodOfContact
        End Get
        Set(value As String)
            _MethodOfContact = value
        End Set
    End Property
    Public Property Exists() As String
        Get
            Return _Exists
        End Get
        Set(value As String)
            _Exists = value
        End Set
    End Property

    'address
    Public Property Address() As String
        Get
            Return _Address
        End Get
        Set(value As String)
            _Address = value
        End Set
    End Property
    Public Property Address2() As String
        Get
            Return _Address2
        End Get
        Set(value As String)
            _Address2 = value
        End Set
    End Property
    Public Property City() As String
        Get
            Return _City
        End Get
        Set(value As String)
            _City = value
        End Set
    End Property
    Public Property State() As String
        Get
            Return _State
        End Get
        Set(value As String)
            _State = value
        End Set
    End Property
    Public Property ZipCode() As String
        Get
            Return _ZipCode
        End Get
        Set(value As String)
            _ZipCode = value
        End Set
    End Property

    'phone
    Public Property PhoneType() As String
        Get
            Return _PhoneType
        End Get
        Set(value As String)
            _PhoneType = value
        End Set
    End Property
    Public Property AvailabilityCode() As String
        Get
            Return _AvailabilityCode
        End Get
        Set(value As String)
            _AvailabilityCode = value
        End Set
    End Property
    Public Property AreaCode() As String
        Get
            Return _AreaCode
        End Get
        Set(value As String)
            _AreaCode = value
        End Set
    End Property
    Public Property PhoneNumber() As String
        Get
            Return _PhoneNumber
        End Get
        Set(value As String)
            _PhoneNumber = value
        End Set
    End Property
    Public Property ExtensionNumber() As String
        Get
            Return _ExtensionNumber
        End Get
        Set(value As String)
            _ExtensionNumber = value
        End Set
    End Property

#End Region 'Properties

#Region "Constructors"

    Public Sub New()

    End Sub

#End Region 'Constructors
End Class
