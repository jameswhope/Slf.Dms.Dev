Imports System.Collections
Imports System.Collections.Specialized

Public Class QueryStringCollection
    Inherits NameObjectCollectionBase

    Public Sub New(ByVal c As NameValueCollection)
        Dim k As String

        For Each k In c.Keys
            Add(k, c(k))
        Next k
    End Sub

    Public Sub New(ByVal c As QueryStringCollection)
        Dim k As String

        For Each k In c.Keys
            Add(k, c(k))
        Next k
    End Sub

    Default Public Property Item(ByVal name As String) As String
        Get
            Item = CType(BaseGet(name), String)
        End Get

        Set(ByVal Value As String)
            BaseSet(name, Value)
        End Set
    End Property

    Public Sub Add(ByVal name As String, ByVal value As String)
        BaseAdd(name, value)
    End Sub

    Public Sub Remove(ByVal name As String)
        BaseRemove(name)
    End Sub
End Class
