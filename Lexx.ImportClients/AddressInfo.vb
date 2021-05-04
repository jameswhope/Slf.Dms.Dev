Imports System.Collections.ObjectModel

Public Enum AddressType
    home = 0
    business = 1
    other = 99
End Enum

Public Class UsStateList
    Private _list As New List(Of USStateInfo)

    Public Sub New()
        GetStates()
    End Sub

    Private Sub GetStates()
        Dim dhelper As New DataHelper
        Dim dt As DataTable = dhelper.GetUsStates()
        If Not dt Is Nothing Then
            For Each dr As DataRow In dt.Rows
                _list.Add(New USStateInfo(dr("StateId"), dr("Name"), dr("Abbreviation")))
            Next
        End If
    End Sub

    Public ReadOnly Property UsStates() As ReadOnlyCollection(Of USStateInfo)
        Get
            Return New ReadOnlyCollection(Of USStateInfo)(_list)
        End Get
    End Property

    Public ReadOnly Property FindById(ByVal StateId As Integer) As USStateInfo
        Get
            For Each itm In _list
                If itm.Id = StateId Then
                    Return itm
                End If
            Next
            Return Nothing
        End Get
    End Property

    Public ReadOnly Property FindByName(ByVal StateName As Integer) As USStateInfo
        Get
            For Each itm In _list
                If itm.Name = StateName Then
                    Return itm
                End If
            Next
            Return Nothing
        End Get
    End Property

    Public ReadOnly Property FindByAbbreviation(ByVal StateAbbrev As Integer) As USStateInfo
        Get
            For Each itm In _list
                If itm.Abbreviation = StateAbbrev Then
                    Return itm
                End If
            Next
            Return Nothing
        End Get
    End Property

End Class

Public Class USStateInfo
    Private _Id As Integer = 0
    Private _Name As String = String.Empty
    Private _abbr As String = String.Empty


    Public Sub New(ByVal StateId As Integer, ByVal StateName As String, ByVal StateAbbrev As String)
        _Id = StateId
        _Name = StateName
        _abbr = StateAbbrev
    End Sub

    Public ReadOnly Property Id() As Integer
        Get
            Return _Id
        End Get
    End Property

    Public ReadOnly Property Name() As String
        Get
            Return _Name
        End Get
    End Property

    Public ReadOnly Property Abbreviation() As String
        Get
            Return _abbr
        End Get
    End Property
End Class

Public Class AddressInfo
    Private _type As AddressType = AddressType.home
    Private _street As String = String.Empty
    Private _street2 As String = String.Empty
    Private _city As String = String.Empty
    Private _state As USStateInfo
    Private _zipCode As String = String.Empty

    Public Property Type() As AddressType
        Get
            Return _type
        End Get
        Set(ByVal value As AddressType)
            _type = value
        End Set
    End Property

    Public Property Street() As String
        Get
            Return _street
        End Get
        Set(ByVal value As String)
            _street = value
        End Set
    End Property

    Public Property Street2() As String
        Get
            Return _street2
        End Get
        Set(ByVal value As String)
            _street2 = value
        End Set
    End Property

    Public ReadOnly Property FullStreet() As String
        Get
            Return String.Format("{0} {1}", _street, _street2).Trim
        End Get
    End Property

    Public Property City() As String
        Get
            Return _city
        End Get
        Set(ByVal value As String)
            _city = value
        End Set
    End Property

    Public Property USState() As USStateInfo
        Get
            Return _state
        End Get
        Set(ByVal value As USStateInfo)
            _state = value
        End Set
    End Property

    Public Property ZipCode() As String
        Get
            Return _zipCode
        End Get
        Set(ByVal value As String)
            _zipCode = value
        End Set
    End Property
End Class
