Imports System.Data.SqlClient

Public Class Person

#Region "Fields"

    Dim _FirstName As String
    Dim _LastName As String

    Dim _SocialSecurityNumber As String

    Dim _Street1 As String
    Dim _Street2 As String
    Dim _City As String
    Dim _StateID As Integer
    Dim _ZipCode As Integer

    Dim _HomePhone As String
    Dim _CellPhone As String
    Dim _BusinessPhone As String
    Dim _FaxPhone As String

    Dim Email As String

#End Region 'Fields

#Region "Properties"

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

    Public Property StateID() As Integer
        Get
            Return _StateID
        End Get
        Set(ByVal value As Integer)
            _StateID = value
        End Set
    End Property

    Public Property ZipCode() As Integer
        Get
            Return _ZipCode
        End Get
        Set(ByVal value As Integer)
            _ZipCode = value
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

        params.Add(New SqlParameter("IdentificationNumber", IdentificationNumber))
        dt = SqlHelper.GetDataTable("stp_GetPersonsData", CommandType.StoredProcedure, params.ToArray)

        For Each dr As DataRow In dt.Rows
            _FirstName = dr("FirstName").ToString
            _LastName = dr("LastName").ToString
            _SocialSecurityNumber = dr("SocialSecurityNumber").ToString
            _Street1 = dr("Street1").ToString
            _Street2 = dr("Street2").ToString
            _City = dr("City").ToString
            _StateID = CInt(dr("StateId").ToString)
            _ZipCode = CInt(dr("ZipCode").ToString)
            _HomePhone = dr("HomePhone").ToString
            _CellPhone = dr("CellPhone").ToString
            _BusinessPhone = dr("BusinessPhone").ToString
            _FaxPhone = dr("FaxPhone").ToString

        Next

    End Sub

#End Region 'Methods

    
End Class
