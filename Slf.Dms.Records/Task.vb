Option Explicit On

Public Class Task

#Region "Variables"

    Private _taskid As Integer
    Private _parenttaskid As Integer
    Private _clientid As Integer
    Private _clientname As String
    Private _tasktypeid As Integer
    Private _tasktypename As String
    Private _tasktypecategoryid As Integer
    Private _tasktypecategoryname As String
    Private _description As String
    Private _assignedto As Integer
    Private _assignedtoname As String
    Private _due As DateTime
    Private _resolved As Nullable(Of DateTime)
    Private _resolvedby As Integer
    Private _resolvedbyname As String
    Private _taskresolutionid As Integer
    Private _taskresolutionname As String

    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String

    Private _notes As Dictionary(Of Integer, Note)

#End Region

#Region "Properties"

    ReadOnly Property TaskID() As Integer
        Get
            Return _taskid
        End Get
    End Property
    ReadOnly Property ParentTaskID() As Integer
        Get
            Return _parenttaskid
        End Get
    End Property
    ReadOnly Property ClientID() As Integer
        Get
            Return _clientid
        End Get
    End Property
    ReadOnly Property Client() As String
        Get
            Return IIf(_clientname.Length > 0, _clientname, "<em>no client</em>")
        End Get
    End Property
    ReadOnly Property ClientName() As String
        Get
            Return _clientname
        End Get
    End Property
    ReadOnly Property TaskTypeID() As Integer
        Get
            Return _tasktypeid
        End Get
    End Property
    ReadOnly Property TaskTypeName() As String
        Get
            Return _tasktypename
        End Get
    End Property
    ReadOnly Property TaskTypeCategoryID() As Integer
        Get
            Return _tasktypecategoryid
        End Get
    End Property
    ReadOnly Property TaskTypeCategoryName() As String
        Get
            Return _tasktypecategoryname
        End Get
    End Property
    ReadOnly Property TypeOrDescription() As String
        Get

            If _tasktypename.Length > 0 Then
                Return _tasktypecategoryname & " >> " & _tasktypename
            Else

                If _description.Length > 65 Then
                    Return _description.Substring(0, 65) & "..."
                Else
                    Return _description
                End If
            End If

        End Get
    End Property
    ReadOnly Property Description() As String
        Get
            Return _description
        End Get
    End Property
    ReadOnly Property AssignedTo() As Integer
        Get
            Return _assignedto
        End Get
    End Property
    ReadOnly Property AssignedToName() As String
        Get
            Return _assignedtoname
        End Get
    End Property
    ReadOnly Property Due() As DateTime
        Get
            Return _due
        End Get
    End Property
    ReadOnly Property Status() As String
        Get

            If _resolved.HasValue Then
                Return "RESOLVED"
            Else

                If _due < Now Then
                    Return "PAST DUE"
                Else
                    Return "OPEN"
                End If

            End If

        End Get
    End Property
    ReadOnly Property StatusFormatted() As String
        Get

            Dim Value As String = Status

            Select Case Value.ToLower
                Case "resolved"
                    Return "<font style=""color:rgb(0,129,0);"">" & Value & "</font>"
                Case "past due"
                    Return "<font style=""color:red;"">" & Value & "</font>"
                Case "open"
                    Return "<font style=""color:rgb(0,0,159);"">" & Value & "</font>"
                Case Else
                    Return ""
            End Select

        End Get
    End Property
    ReadOnly Property Resolved() As Nullable(Of DateTime)
        Get
            Return _resolved
        End Get
    End Property
    ReadOnly Property ResolvedBy() As Integer
        Get
            Return _resolvedby
        End Get
    End Property
    ReadOnly Property ResolvedByName() As String
        Get
            Return _resolvedbyname
        End Get
    End Property
    ReadOnly Property TaskResolutionID() As Integer
        Get
            Return _taskresolutionid
        End Get
    End Property
    ReadOnly Property TaskResolutionName() As String
        Get
            Return _taskresolutionname
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
    ReadOnly Property Notes() As Dictionary(Of Integer, Note)
        Get

            If _notes Is Nothing Then
                _notes = New Dictionary(Of Integer, Note)
            End If

            Return _notes

        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal TaskID As Integer, ByVal ParentTaskID As Integer, ByVal ClientID As Integer, _
        ByVal ClientName As String, ByVal TaskTypeID As Integer, ByVal TaskTypeName As String, _
        ByVal TaskTypeCategoryID As Integer, ByVal TaskTypeCategoryName As String, _
        ByVal Description As String, ByVal AssignedTo As Integer, ByVal AssignedToName As String, _
        ByVal Due As DateTime, ByVal Resolved As Nullable(Of DateTime), ByVal ResolvedBy As Integer, _
        ByVal ResolvedByName As String, ByVal TaskResolutionID As Integer, ByVal TaskResolutionName As String, _
        ByVal Created As DateTime, ByVal CreatedBy As Integer, ByVal CreatedByName As String, _
        ByVal LastModified As DateTime, ByVal LastModifiedBy As Integer, ByVal LastModifiedByName As String)

        _taskid = TaskID
        _parenttaskid = ParentTaskID
        _clientid = ClientID
        _clientname = ClientName
        _tasktypeid = TaskTypeID
        _tasktypename = TaskTypeName
        _tasktypecategoryid = TaskTypeCategoryID
        _tasktypecategoryname = TaskTypeCategoryName
        _description = Description
        _assignedto = AssignedTo
        _assignedtoname = AssignedToName
        _due = Due
        _resolved = Resolved
        _resolvedby = ResolvedBy
        _resolvedbyname = ResolvedByName
        _taskresolutionid = TaskResolutionID
        _taskresolutionname = TaskResolutionName

        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName

    End Sub

#End Region

End Class