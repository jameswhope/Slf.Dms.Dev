Option Explicit On

Imports Drg.Util.Helpers

Imports System.Web.HttpContext

Public Class NoteSearch

#Region "Variables"

    Private _noteid As Integer
    Private _clientId As Integer
    Private _value As String

    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String

    Private _approot As String

#End Region

#Region "Properties"

    ReadOnly Property NoteID() As Integer
        Get
            Return _noteid
        End Get
    End Property
    ReadOnly Property ClientID() As Integer
        Get
            Return _clientId
        End Get
    End Property
    ReadOnly Property Value() As String
        Get
            Return _value
        End Get
    End Property
    ReadOnly Property Created() As DateTime
        Get
            Return _created
        End Get
    End Property
    ReadOnly Property CreatedBy() As Integer
        Get
            Return _createdby
        End Get
    End Property
    ReadOnly Property CreatedByName() As String
        Get
            Return _createdbyname
        End Get
    End Property
    ReadOnly Property LastModified() As DateTime
        Get
            Return _lastmodified
        End Get
    End Property
    ReadOnly Property LastModifiedBy() As Integer
        Get
            Return _lastmodifiedby
        End Get
    End Property
    ReadOnly Property LastModifiedByName() As String
        Get
            Return _lastmodifiedbyname
        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal NoteID As Integer, ByVal Value As String, ByVal Created As DateTime, _
        ByVal CreatedBy As Integer, ByVal CreatedByName As String, ByVal LastModified As DateTime, _
        ByVal LastModifiedBy As Integer, ByVal LastModifiedByName As String, ByVal AppRoot As String, ByVal clientId As Integer)

        _clientId = clientId
        _noteid = NoteID
        _value = Value

        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName

        _approot = AppRoot
    End Sub

#End Region

End Class