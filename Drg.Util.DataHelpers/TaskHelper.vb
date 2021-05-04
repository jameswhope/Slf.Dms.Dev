Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data

Public Class TaskHelper

    Public Shared Function InsertTaskValue(ByVal TaskID As Integer, ByVal Name As String, _
        ByVal Value As String) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)
        DatabaseHelper.AddParameter(cmd, "Name", Name)
        DatabaseHelper.AddParameter(cmd, "Value", Value)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblTaskValue", "TaskValueID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@TaskValueID").Value)

    End Function
    Public Shared Function GetShortDescription(ByVal TaskID As Integer)
        Return GetShortDescription(TaskID, 30)
    End Function
    Public Shared Function GetShortDescription(ByVal TaskID As Integer, ByVal Length As Integer)

        Dim TaskTypeID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblTask", "TaskTypeID", _
            "TaskID = " & TaskID))

        If TaskTypeID = 0 Then 'does NOT have tasktype

            Dim Description As String = DataHelper.FieldLookup("tblTask", "Description", "TaskID = " & TaskID)

            If Description.Length > Length Then
                Return Description.Substring(0, Length) & "..."
            Else
                Return Description
            End If

        Else 'HAS task type

            Return DataHelper.FieldLookup("tblTaskType", "Name", "TaskTypeID = " & TaskTypeID)

        End If

    End Function
    Public Shared Sub Delete(ByVal TaskID As Integer, ByVal Recursive As Boolean)
        Delete(TaskID, Recursive, True)
    End Sub
    Public Shared Sub Delete(ByVal TaskID As Integer, ByVal Recursive As Boolean, ByVal RemoveDependencies As Boolean)

        If Recursive Then

            Dim ChildTaskIDs() As Integer = GetChildTasksIDs(TaskID)

            For Each ChildTaskID As Integer In ChildTaskIDs
                Delete(ChildTaskID, Recursive, RemoveDependencies)
            Next

        End If

        'remove the task itself
        DataHelper.Delete("tblTask", "TaskID = " & TaskID)

        If RemoveDependencies Then

            'remove task from clients
            DataHelper.Delete("tblClientTask", "TaskID = " & TaskID)

            'remove task from roadmap
            DataHelper.Delete("tblRoadmapTask", "TaskID = " & TaskID)

        End If

    End Sub
    Public Shared Function InsertTask(ByVal ClientID As Integer, ByVal RoadmapID As Integer, _
        ByVal TaskTypeID As Integer, ByVal Description As String, ByVal AssignedTo As Integer, _
        ByVal Due As DateTime, ByVal UserID As Integer) As Integer

        Dim TaskID As Integer = InsertTask(TaskTypeID, Description, AssignedTo, Due, UserID, 0)

        ClientHelper.InsertClientTask(ClientID, TaskID, UserID)
        RoadmapHelper.InsertRoadmapTask(RoadmapID, TaskID, UserID)

        Return TaskID

    End Function
    Public Shared Function InsertTask(ByVal ClientID As Integer, ByVal RoadmapID As Integer, _
        ByVal TaskTypeID As Integer, ByVal Description As String, ByVal AssignedTo As Integer, _
        ByVal Due As DateTime, ByVal UserID As Integer, ByVal ParentTaskID As Integer) As Integer

        Dim TaskID As Integer = InsertTask(TaskTypeID, Description, AssignedTo, Due, UserID, ParentTaskID)

        ClientHelper.InsertClientTask(ClientID, TaskID, UserID)
        RoadmapHelper.InsertRoadmapTask(RoadmapID, TaskID, UserID)

        Return TaskID

    End Function
    Public Shared Function InsertTask(ByVal TaskTypeID As Integer, ByVal Description As String, _
        ByVal AssignedTo As Integer, ByVal Due As DateTime, ByVal UserID As Integer, _
        ByVal ParentTaskID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "ParentTaskID", DataHelper.Zn(ParentTaskID))
        DatabaseHelper.AddParameter(cmd, "TaskTypeID", DataHelper.Zn(TaskTypeID))
        DatabaseHelper.AddParameter(cmd, "Description", Description)
        DatabaseHelper.AddParameter(cmd, "AssignedTo", AssignedTo)
        DatabaseHelper.AddParameter(cmd, "Due", Due)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        DatabaseHelper.BuildInsertCommandText(cmd, "tblTask", "TaskID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@TaskID").Value)

    End Function
    Public Shared Function InsertTaskNote(ByVal TaskID As Integer, ByVal NoteID As Integer, ByVal UserID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)
        DatabaseHelper.AddParameter(cmd, "NoteID", NoteID)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblTaskNote", "TaskNoteID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@TaskNoteID").Value)

    End Function
    Public Shared Function FindTaskIDs(ByVal Criteria As String) As Integer()

        Dim TaskIDs As New List(Of Integer)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTasks")

            If Not Criteria Is Nothing AndAlso Criteria.Length > 0 Then
                DatabaseHelper.AddParameter(cmd, "Where", "WHERE " & Criteria)
            End If

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()
                        TaskIDs.Add(DatabaseHelper.Peel_int(rd, "TaskID"))
                    End While
                End Using
            End Using
        End Using

        Return TaskIDs.ToArray()

    End Function
    Public Shared Sub Resolve(ByVal Criteria As String, ByVal TaskResolutionID As Integer, ByVal UserID As Integer)

        Dim TaskIDs() As Integer = FindTaskIDs(Criteria)

        If TaskIDs.Length > 0 Then

            'build the criteria to update
            Dim Where As String = String.Empty

            For Each TaskID As Integer In TaskIDs
                If Where.Length > 0 Then
                    Where += "," & TaskID
                Else
                    Where = TaskID
                End If
            Next

            'run the update against the whole list
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

                DatabaseHelper.AddParameter(cmd, "Resolved", Now)
                DatabaseHelper.AddParameter(cmd, "ResolvedBy", UserID)
                DatabaseHelper.AddParameter(cmd, "TaskResolutionID", TaskResolutionID)

                DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

                DatabaseHelper.BuildUpdateCommandText(cmd, "tblTask", "TaskID IN (" & Where & ")")

                Using cmd.Connection

                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()

                End Using
            End Using
        End If

    End Sub
    Public Shared Sub Resolve(ByVal TaskID As Integer, ByVal Resolved As DateTime, _
        ByVal TaskResolutionID As Integer, ByVal UserID As Integer, ByVal Notes() As String, _
        ByVal Propagations() As String)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Resolved", Resolved)
        DatabaseHelper.AddParameter(cmd, "ResolvedBy", UserID)
        DatabaseHelper.AddParameter(cmd, "TaskResolutionID", TaskResolutionID)

        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblTask", "TaskID = " & TaskID)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        'get associated clients
        Dim ClientIDs() As Integer = TaskHelper.GetClients(TaskID)

        For Each Note As String In Notes

            If Note.Length > 0 Then

                'Todo:  Fix ClientID logic.  Defaulting to 0 in order to build
                Dim NoteID As Integer = NoteHelper.InsertNote(Note, UserID, 0)

                'link this note to current task
                TaskHelper.InsertTaskNote(TaskID, NoteID, UserID)

                'link this note to all associated clients, NOT to roadmap
                For Each ClientID As Integer In ClientIDs
                    NoteHelper.RelateNote(NoteID, 1, ClientID)
                Next

            End If

        Next

        'set child roadmaps
        PropogateRoadmaps(TaskID, UserID)

        If Propagations.Length > 0 Then

            'link this note to all associated clients, NOT to roadmap
            For Each ClientID As Integer In ClientIDs

                'get current roadmap for client
                Dim CurrentRoadmapID As Integer = DataHelper.Nz_int(ClientHelper.GetRoadmap(ClientID, _
                    "RoadmapID"))

                For Each Propagation As String In Propagations

                    If Propagation.Length > 0 Then

                        Dim Parts() As String = Propagation.Split(",")

                        Dim AssignedToResolver As Integer = DataHelper.Nz_int(Parts(0))
                        Dim DueTypeID As Integer = DataHelper.Nz_int(Parts(1))
                        Dim DueDate As String = Parts(2)
                        Dim Due As String = Parts(3)
                        Dim TaskTypeID As Integer = DataHelper.Nz_int(Parts(4))
                        Dim Description As String = Parts(5)

                        'figure out who the next task is assigned to
                        Dim AssignedTo As Integer

                        If AssignedToResolver = 1 Then

                            AssignedTo = DataHelper.Nz_int(DataHelper.FieldLookup("tblTask", "ResolvedBy", _
                                "TaskID = " & TaskID))

                        Else

                            AssignedTo = DataHelper.Nz_int(DataHelper.FieldLookup("tblTask", "AssignedTo", _
                                "TaskID = " & TaskID))

                        End If

                        'build description
                        If Not TaskTypeID = 0 Then 'not ad hoc, predefined by tasktype

                            Description = DataHelper.FieldLookup("tblTaskType", "DefaultDescription", "TaskTypeID = " & TaskTypeID)

                        End If

                        'insert the new task against this client, with parent task, and against current roadmap
                        If DueTypeID = 0 Then '0 - specific date

                            TaskHelper.InsertTask(ClientID, CurrentRoadmapID, TaskTypeID, Description, AssignedTo, _
                                DateTime.Parse(DueDate), UserID, TaskID)

                        Else '1 - days from now

                            TaskHelper.InsertTask(ClientID, CurrentRoadmapID, TaskTypeID, Description, AssignedTo, _
                                Now.AddDays(Double.Parse(Due)), UserID, TaskID)

                        End If

                        Dim RealDueDate As Nullable(Of DateTime) = Nothing

                        If DueDate.Length > 0 Then
                            RealDueDate = DateTime.Parse(DueDate)
                        End If

                        'save propagation values against task for legacy purposes
                        InsertPropagationSaved(TaskID, AssignedToResolver, DueTypeID, _
                            DataHelper.Nz_double(Due), RealDueDate, TaskTypeID, Description)

                    End If

                Next

            Next

        End If

    End Sub
    Public Shared Function InsertPropagationSaved(ByVal TaskID As Integer, ByVal AssignedTo As Integer, _
        ByVal DueType As Integer, ByVal Due As Double, ByVal DueDate As Nullable(Of DateTime), _
        ByVal TaskTypeID As Integer, ByVal Description As String) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)
        DatabaseHelper.AddParameter(cmd, "AssignedTo", AssignedTo)
        DatabaseHelper.AddParameter(cmd, "DueType", DueType)
        DatabaseHelper.AddParameter(cmd, "Due", DataHelper.Zn(Due), DbType.Double)

        If DueDate.HasValue Then
            DatabaseHelper.AddParameter(cmd, "Date", DueDate.HasValue)
        End If

        DatabaseHelper.AddParameter(cmd, "TaskTypeID", DataHelper.Zn(TaskTypeID), DbType.Int32)
        DatabaseHelper.AddParameter(cmd, "Description", DataHelper.Zn(Description))

        DatabaseHelper.BuildInsertCommandText(cmd, "tblTaskPropagationSaved", "TaskPropagationSavedID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@TaskPropagationSavedID").Value)

    End Function
    Public Shared Sub ClearResolve(ByVal TaskID As Integer, ByVal UserID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Resolved", DBNull.Value)
        DatabaseHelper.AddParameter(cmd, "ResolvedBy", DBNull.Value)
        DatabaseHelper.AddParameter(cmd, "TaskResolutionID", DBNull.Value)

        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblTask", "TaskID = " & TaskID)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        'clear associated notes
        Dim NoteIDs() As Integer = GetNoteIDs(TaskID)

        For Each NoteID As Integer In NoteIDs
            NoteHelper.Delete(NoteID)
        Next

        'clear child tasks
        Dim TaskIDs() As Integer = GetChildTasksIDs(TaskID)

        For Each Task As Integer In TaskIDs
            Delete(Task, True)
        Next

        'clear values
        DataHelper.Delete("tblTaskValue", "TaskID = " & TaskID)

        'clear propagation values
        DataHelper.Delete("tblTaskPropagationSaved", "TaskID = " & TaskID)

    End Sub
    Public Shared Sub PropogateRoadmaps(ByVal TaskID As Integer, ByVal UserID As Integer)

        Dim TaskTypeID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblTask", "TaskTypeID", "TaskID = " & TaskID))

        Dim ClientIDs() As Integer = GetClients(TaskID)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblTaskPropagation WHERE Type = 'Roadmap' AND TaskTypeID = @TaskTypeID ORDER BY [Order]"

        DatabaseHelper.AddParameter(cmd, "TaskTypeID", TaskTypeID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Dim Type As String = DatabaseHelper.Peel_string(rd, "Type")
                Dim TypeID As Integer = DatabaseHelper.Peel_int(rd, "TypeID")
                Dim Due As Double = DatabaseHelper.Peel_double(rd, "Due")
                Dim AssignedToResolver As Boolean = DatabaseHelper.Peel_bool(rd, "AssignedToResolver")

                'for each associated client on this task
                For Each ClientID As Integer In ClientIDs

                    'simply insert a new roadmap against this client
                    RoadmapHelper.InsertRoadmap(ClientID, TypeID, Nothing, UserID)

                Next

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Public Shared Function GetClients(ByVal TaskID As Integer) As Integer()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetClientsForTask")

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)

        Dim Clients As New ArrayList

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                Clients.Add(DatabaseHelper.Peel_int(rd, "ClientID"))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return Clients.ToArray(GetType(Integer))

    End Function
    Public Shared Function GetNotes(ByVal TaskID As Integer) As String()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNotesForTask")

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)

        Dim Notes As New ArrayList

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                Notes.Add(DatabaseHelper.Peel_string(rd, "Value"))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return Notes.ToArray(GetType(String))

    End Function
    Public Shared Function GetNoteIDs(ByVal TaskID As Integer) As Integer()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNotesForTask")

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)

        Dim Notes As New ArrayList

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                Notes.Add(DatabaseHelper.Peel_int(rd, "NoteID"))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return Notes.ToArray(GetType(Integer))

    End Function
    Public Shared Function GetChildTasksIDs(ByVal TaskID As Integer) As Integer()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetChildTasksForTask")

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)

        Dim Tasks As New ArrayList

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                Tasks.Add(DatabaseHelper.Peel_int(rd, "TaskID"))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return Tasks.ToArray(GetType(Integer))

    End Function
End Class