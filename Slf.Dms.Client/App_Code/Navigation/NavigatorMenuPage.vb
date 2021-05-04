Option Explicit On

Imports System.Collections.Generic

Public Class NavigatorMenuPage

#Region "Variables"

    Private _url As String
    Private _title As String
    Private _date As String

#End Region

#Region "Properties"

    ReadOnly Property Url() As String
        Get
            Return _url
        End Get
    End Property
    ReadOnly Property Title() As String
        Get
            Return _title
        End Get
    End Property
    ReadOnly Property [Date]() As DateTime
        Get
            Return _date
        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal Url As String, ByVal Title As String, ByVal [Date] As DateTime)

        _url = Url
        _title = Title
        _date = [Date]

    End Sub

#End Region

End Class
