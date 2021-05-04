Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Public Class Persons

#Region "Fields"

    Dim _Prefix As String
    Dim _FirstName As String
    Dim _LastName As String

    Dim _SocialSecurityNumber As String
    Dim _DOB As String

    Dim _Street1 As String
    Dim _Street2 As String
    Dim _City As String
    Dim _StateName As String
    Dim _StateAbbreviation As String
    Dim _ZipCode As String

    Dim _Email As String
    Dim _HomePhone As String
    Dim _CellPhone As String
    Dim _BusinessPhone As String
    Dim _FaxPhone As String

#End Region 'Fields

#Region "Properties"

    Public Property Prefix() As String
        Get
            Return _Prefix
        End Get
        Set(ByVal value As String)
            _Prefix = value
        End Set
    End Property

    Public Property FirstName() As String
        Get
            Return _FirstName
        End Get
        Set(ByVal value As String)
            _FirstName = value
        End Set
    End Property

    Public Property LastName() As String
        Get
            Return _LastName
        End Get
        Set(ByVal value As String)
            _LastName = value
        End Set
    End Property

    Public Property SocialSecurityNumber() As String
        Get
            Return _SocialSecurityNumber
        End Get
        Set(ByVal value As String)
            _SocialSecurityNumber = value
        End Set
    End Property

    Public Property Street1() As String
        Get
            Return _Street1
        End Get
        Set(ByVal value As String)
            _Street1 = value
        End Set
    End Property

    Public Property Street2() As String
        Get
            Return _Street2
        End Get
        Set(ByVal value As String)
            _Street2 = value
        End Set
    End Property

    Public Property City() As String
        Get
            Return _City
        End Get
        Set(ByVal value As String)
            _City = value
        End Set
    End Property

    Public Property StateName() As String
        Get
            Return _StateName
        End Get
        Set(ByVal value As String)
            _StateName = value
        End Set
    End Property

    Public Property StateAbbreviation() As String
        Get
            Return _StateAbbreviation
        End Get
        Set(ByVal value As String)
            _StateAbbreviation = value
        End Set
    End Property

    Public Property ZipCode() As String
        Get
            Return _ZipCode
        End Get
        Set(ByVal value As String)
            _ZipCode = value
        End Set
    End Property

    Public Property Email() As String
        Get
            Return _Email
        End Get
        Set(ByVal value As String)
            _Email = value
        End Set
    End Property

    Public Property HomePhone() As String
        Get
            Return _HomePhone
        End Get
        Set(ByVal value As String)
            _HomePhone = value
        End Set
    End Property

    Public Property CellPhone() As String
        Get
            Return _CellPhone
        End Get
        Set(ByVal value As String)
            _CellPhone = value
        End Set
    End Property

    Public Property BusinessPhone() As String
        Get
            Return _BusinessPhone
        End Get
        Set(ByVal value As String)
            _BusinessPhone = value
        End Set
    End Property

    Public Property FaxPhone() As String
        Get
            Return _FaxPhone
        End Get
        Set(ByVal value As String)
            _FaxPhone = value
        End Set
    End Property

#End Region 'Properties

#Region "Constructors"

    Public Sub New()

    End Sub

#End Region 'Constructors

#Region "Methods"

    Public Sub GetPersonalData(IdentificationNumber As Integer)
        Dim params As New List(Of SqlParameter)
        Dim dt As DataTable

        params.Add(New SqlParameter("leadapplicantid", IdentificationNumber))
        dt = SqlHelper.GetDataTable("stp_GetPersonsData", CommandType.StoredProcedure, params.ToArray)

        For Each dr As DataRow In dt.Rows
            _Prefix = dr("Prefix").ToString
            _FirstName = dr("FirstName").ToString
            _LastName = dr("LastName").ToString
            _SocialSecurityNumber = dr("ssn").ToString
            _Street1 = dr("Address1").ToString
            _City = dr("City").ToString
            _StateName = dr("StateName").ToString
            _StateAbbreviation = dr("StateAbbreviation").ToString
            _ZipCode = dr("ZipCode").ToString
            _HomePhone = dr("HomePhone").ToString
            _CellPhone = dr("CellPhone").ToString
            _BusinessPhone = dr("BusinessPhone").ToString
            _FaxPhone = dr("FaxNumber").ToString
            _Email = dr("Email").ToString
            _DOB = dr("DOB").ToString

        Next

    End Sub

#End Region 'Methods


End Class
