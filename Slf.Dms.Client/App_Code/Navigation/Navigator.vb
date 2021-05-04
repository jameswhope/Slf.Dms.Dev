Option Explicit On

Imports System.Collections.Generic

Public Class Navigator

#Region "Variables"

    Private _pages As List(Of NavigatorMenuPage)
    Private _menus As Dictionary(Of String, NavigatorMenu)

#End Region

#Region "Properties"

    ReadOnly Property Pages() As List(Of NavigatorMenuPage)
        Get

            If _pages Is Nothing Then
                _pages = New List(Of NavigatorMenuPage)
            End If

            Return _pages

        End Get
    End Property
    ReadOnly Property Menus() As Dictionary(Of String, NavigatorMenu)
        Get

            If _menus Is Nothing Then
                _menus = New Dictionary(Of String, NavigatorMenu)
            End If

            Return _menus

        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New()

    End Sub

#End Region

    Public Sub Store(ByVal Menu As String, ByVal Url As String, ByVal Title As String)
        Store(Menu, Url, Title, Now)
    End Sub
    Public Sub Store(ByVal Menu As String, ByVal Url As String, ByVal Title As String, ByVal [Date] As DateTime)

        Dim m As NavigatorMenu = Nothing

        If Not Menus.TryGetValue(Menu, m) Then

            m = New NavigatorMenu(Menu)

            Menus.Add(Menu, m)

        End If

        Pages.Add(New NavigatorMenuPage(Url, Title, [Date]))
        m.Pages.Add(New NavigatorMenuPage(Url, Title, [Date]))

    End Sub
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