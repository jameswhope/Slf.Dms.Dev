Option Explicit On

Public Class PropertyCategory

#Region "Variables"

    Private _propertycategoryid As Integer
    Private _name As String

    Private _properties As Dictionary(Of String, [Property])

#End Region

#Region "Properties"

    ReadOnly Property PropertyCategoryID() As Integer
        Get
            Return _propertycategoryid
        End Get
    End Property
    ReadOnly Property Name() As String
        Get
            Return _name
        End Get
    End Property
    ReadOnly Property Properties() As Dictionary(Of String, [Property])
        Get

            If _properties Is Nothing Then
                _properties = New Dictionary(Of String, [Property])
            End If

            Return _properties

        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal PropertyCategoryID As Integer, ByVal Name As String)

        _propertycategoryid = PropertyCategoryID
        _name = Name

    End Sub

#End Region

End Class