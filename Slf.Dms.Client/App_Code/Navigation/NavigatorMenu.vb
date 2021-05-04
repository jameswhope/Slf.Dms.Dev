Option Explicit On

Imports System.Collections.Generic

Public Class NavigatorMenu

#Region "Variables"

    Private _name As String

    Private _pages As List(Of NavigatorMenuPage)

#End Region

#Region "Properties"

    ReadOnly Property Name() As String
        Get
            Return _name
        End Get
    End Property
    ReadOnly Property Pages() As List(Of NavigatorMenuPage)
        Get

            If _pages Is Nothing Then
                _pages = New List(Of NavigatorMenuPage)
            End If

            Return _pages

        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal Name As String)

        _name = Name

    End Sub

#End Region

    Public Function LastUrlIn() As String

        If Pages.Count > 0 Then
            Return Pages(Pages.Count - 1).Url
        Else
            Return Nothing
        End If

    End Function
    Public Function FirstUrlIn() As String

        If Pages.Count > 0 Then
            Return Pages(0).Url
        Else
            Return Nothing
        End If

    End Function
End Class