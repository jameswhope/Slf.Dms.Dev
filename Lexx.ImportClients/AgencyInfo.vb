Imports System.Collections.ObjectModel

Public Class AgencyList
    Private _list As New List(Of AgencyInfo)

    Public Sub New()
        GetAgencies()
    End Sub

    Private Sub GetAgencies()
        Dim dhelper As New DataHelper
        Dim dt As DataTable = dhelper.GetAgencies
        If Not dt Is Nothing Then
            For Each dr As DataRow In dt.Rows
                _list.Add(New AgencyInfo(dr("AgencyId"), dr("Name")))
            Next
        End If
    End Sub

    Public ReadOnly Property Agencies() As ReadOnlyCollection(Of AgencyInfo)
        Get
            Return New ReadOnlyCollection(Of AgencyInfo)(_list)
        End Get
    End Property

    Public ReadOnly Property FindById(ByVal AgencyId As Integer) As AgencyInfo
        Get
            For Each itm In _list
                If itm.Id = AgencyId Then
                    Return itm
                End If
            Next
            Return Nothing
        End Get
    End Property

    Public ReadOnly Property FindByName(ByVal AgencyName As Integer) As AgencyInfo
        Get
            For Each itm In _list
                If itm.Name = AgencyName Then
                    Return itm
                End If
            Next
            Return Nothing
        End Get
    End Property
End Class


Public Class AgencyInfo
    Private _Id As Integer = 0
    Private _name As String = String.Empty

    Public Sub New(ByVal AgencyId As Integer, ByVal AgencyName As String)
        _Id = AgencyId
        _name = AgencyName
    End Sub

    Public ReadOnly Property Id() As Integer
        Get
            Return _Id
        End Get
    End Property

    Public ReadOnly Property Name() As String
        Get
            Return _name
        End Get
    End Property
End Class
