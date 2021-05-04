Option Explicit On

Public Class Reference

#Region "Variables"

    Private _referenceid As Integer
    Private _table As Integer
    Private _title As String
    Private _lastword As String

    Private _referencefields As List(Of ReferenceField)

#End Region

#Region "Properties"

    ReadOnly Property ReferenceID() As Integer
        Get
            Return _referenceid
        End Get
    End Property
    ReadOnly Property Table() As Integer
        Get
            Return _table
        End Get
    End Property
    ReadOnly Property Title() As String
        Get
            Return _title
        End Get
    End Property
    ReadOnly Property LastWord() As String
        Get
            Return _lastword
        End Get
    End Property
    ReadOnly Property ReferenceFields() As List(Of ReferenceField)
        Get

            If _referencefields Is Nothing Then
                _referencefields = New List(Of ReferenceField)
            End If

            Return _referencefields

        End Get
    End Property

#End Region

#Region "Constructor'"

    Public Sub New(ByVal ReferenceID As Integer, ByVal Table As Integer, ByVal Title As String, _
        ByVal LastWord As String)

        _referenceid = ReferenceID
        _table = Table
        _title = Title
        _lastword = LastWord

    End Sub

#End Region

End Class