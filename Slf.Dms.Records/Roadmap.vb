Option Explicit On

Public Class Roadmap

#Region "Variables"

    Private _roadmapid As Integer
    Private _parentroadmapid As Integer
    Private _clientid As Integer
    Private _clientstatusid As Integer
    Private _parentclientstatusid As Integer
    Private _clientstatusname As String
    Private _reason As String

    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String

    Private _notes As Dictionary(Of Integer, Note)
    Private _tasks As Dictionary(Of Integer, Task)
    Private _roadmaps As Dictionary(Of Integer, Roadmap)

#End Region

#Region "Properties"

    ReadOnly Property RoadmapID() As Integer
        Get
            Return _roadmapid
        End Get
    End Property
    ReadOnly Property ParentRoadmapID() As Integer
        Get
            Return _parentroadmapid
        End Get
    End Property
    ReadOnly Property ClientID() As Integer
        Get
            Return _clientid
        End Get
    End Property
    ReadOnly Property ClientStatusID() As Integer
        Get
            Return _clientstatusid
        End Get
    End Property
    ReadOnly Property ParentClientStatusID() As Integer
        Get
            Return _parentclientstatusid
        End Get
    End Property
    ReadOnly Property ClientStatusName() As String
        Get
            Return _clientstatusname
        End Get
    End Property
    ReadOnly Property Reason() As String
        Get
            Return _reason
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
    ReadOnly Property Notes() As Dictionary(Of Integer, Note)
        Get

            If _notes Is Nothing Then
                _notes = New Dictionary(Of Integer, Note)
            End If

            Return _notes

        End Get
    End Property
    ReadOnly Property Tasks() As Dictionary(Of Integer, Task)
        Get

            If _tasks Is Nothing Then
                _tasks = New Dictionary(Of Integer, Task)
            End If

            Return _tasks

        End Get
    End Property
    ReadOnly Property Roadmaps() As Dictionary(Of Integer, Roadmap)
        Get

            If _roadmaps Is Nothing Then
                _roadmaps = New Dictionary(Of Integer, Roadmap)
            End If

            Return _roadmaps

        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal RoadmapID As Integer, ByVal ParentRoadmapID As Integer, ByVal ClientID As Integer, ByVal ClientStatusID As Integer, _
        ByVal ParentClientStatusID As Integer, ByVal ClientStatusName As String, ByVal Reason As String, _
        ByVal Created As DateTime, ByVal CreatedBy As Integer, ByVal CreatedByName As String, _
        ByVal LastModified As DateTime, ByVal LastModifiedBy As Integer, ByVal LastModifiedByName As String)

        _roadmapid = RoadmapID
        _parentroadmapid = ParentRoadmapID
        _clientid = ClientID
        _clientstatusid = ClientStatusID
        _parentclientstatusid = ParentClientStatusID
        _clientstatusname = ClientStatusName
        _reason = Reason

        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName

    End Sub

#End Region

End Class