Imports System.Collections.ObjectModel

Public Class TrustList
    Private _list As New List(Of TrustInfo)

    Public Sub New()
        GetTrusts()
    End Sub

    Private Sub GetTrusts()
        Dim dhelper As New DataHelper
        Dim dt As DataTable = dhelper.GetTrusts()
        If Not dt Is Nothing Then
            For Each dr As DataRow In dt.Rows
                _list.Add(New TrustInfo(dr("TrustId"), dr("Name")))
            Next
        End If
    End Sub

    Public ReadOnly Property Trusts() As ReadOnlyCollection(Of TrustInfo)
        Get
            Return New ReadOnlyCollection(Of TrustInfo)(_list)
        End Get
    End Property

    Public ReadOnly Property FindById(ByVal TrustId As Integer) As TrustInfo
        Get
            For Each itm In _list
                If itm.ID = TrustId Then
                    Return itm
                End If
            Next
            Return Nothing
        End Get
    End Property

    Public ReadOnly Property FindByName(ByVal TrustName As Integer) As TrustInfo
        Get
            For Each itm In _list
                If itm.Name = TrustName Then
                    Return itm
                End If
            Next
            Return Nothing
        End Get
    End Property
End Class

Public Class TrustInfo
    Private _id As Integer = 0
    Private _name As String = String.Empty

    Friend Sub New(ByVal TrustId As Integer, ByVal TrustName As String)
        _id = TrustId
        _name = TrustName
    End Sub

    Public ReadOnly Property ID() As Integer
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
