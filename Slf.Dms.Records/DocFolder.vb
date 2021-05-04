Option Explicit On

Public Class DocFolder

#Region "Variables"

    Private _docfolderid As Integer
    Private _table As String
    Private _field As String
    Private _fieldid As Integer
    Private _parentdocfolderid As Nullable(Of Integer)
    Private _name As String

    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String

    Private _docs As List(Of Doc)
    Private _docfolders As List(Of DocFolder)

    Private _approot As String

#End Region

#Region "Properties"

    ReadOnly Property DocFolderID() As Integer
        Get
            Return _docfolderid
        End Get
    End Property
    ReadOnly Property Table() As String
        Get
            Return _table
        End Get
    End Property
    ReadOnly Property Field() As String
        Get
            Return _field
        End Get
    End Property
    ReadOnly Property FieldID() As Integer
        Get
            Return _fieldid
        End Get
    End Property
    ReadOnly Property ParentDocFolderID() As Nullable(Of Integer)
        Get
            Return _parentdocfolderid
        End Get
    End Property
    ReadOnly Property Name() As String
        Get
            Return _name
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
    ReadOnly Property LastModifed() As DateTime
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
    ReadOnly Property Docs() As List(Of Doc)
        Get

            If _docs Is Nothing Then
                _docs = New List(Of Doc)
            End If

            Return _docs

        End Get
    End Property
    ReadOnly Property DocFolders() As List(Of DocFolder)
        Get

            If _docfolders Is Nothing Then
                _docfolders = New List(Of DocFolder)
            End If

            Return _docfolders

        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal DocFolderID As Integer, ByVal Table As String, ByVal Field As String, _
        ByVal FieldID As Integer, ByVal ParentDocFolderID As Integer, ByVal Name As String, _
        ByVal Created As DateTime, ByVal CreatedBy As Integer, ByVal CreatedbyName As String, _
        ByVal LastModified As DateTime, ByVal LastModifiedBy As Integer, ByVal LastModifiedByName As String, _
        ByVal AppRoot As String)

        _docfolderid = DocFolderID
        _table = Table
        _field = Field
        _fieldid = FieldID
        _parentdocfolderid = ParentDocFolderID
        _name = Name

        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedbyName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName

        _approot = AppRoot

    End Sub

#End Region

End Class