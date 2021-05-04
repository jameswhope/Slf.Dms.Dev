Imports System.Collections.ObjectModel

Public Class LawFirmList
    Private _list As New List(Of LawFirmInfo)

    Public Sub New()
        GetLawFirms()
    End Sub

    Private Sub GetLawFirms()
        Dim dhelper As New DataHelper
        Dim dt As DataTable = dhelper.GetCompanies()
        If Not dt Is Nothing Then
            For Each dr As DataRow In dt.Rows
                _list.Add(New LawFirmInfo(dr("CompanyId"), dr("Name")))
            Next
        End If
    End Sub

    Public ReadOnly Property LawFirms() As ReadOnlyCollection(Of LawFirmInfo)
        Get
            Return New ReadOnlyCollection(Of LawFirmInfo)(_list)
        End Get
    End Property

    Public ReadOnly Property FindById(ByVal LawFirmId As Integer) As LawFirmInfo
        Get
            For Each itm In _list
                If itm.Id = LawFirmId Then
                    Return itm
                End If
            Next
            Return Nothing
        End Get
    End Property

    Public ReadOnly Property FindByName(ByVal LawFirmName As Integer) As LawFirmInfo
        Get
            For Each itm In _list
                If itm.Name = LawFirmName Then
                    Return itm
                End If
            Next
            Return Nothing
        End Get
    End Property
End Class


Public Class LawFirmInfo
    Private _id As Integer = 0
    Private _name As String = String.Empty

    Public Sub New(ByVal LawFirmId As Integer, ByVal LawFirmName As String)
        _id = LawFirmId
        _name = LawFirmName
    End Sub

    Public ReadOnly Property Id() As Integer
        Get
            Return _id
        End Get
    End Property

    Public ReadOnly Property Name() As String
        Get
            Return _name
        End Get
    End Property
End Class
