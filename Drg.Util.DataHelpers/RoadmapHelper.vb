Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data

Public Class RoadmapHelper
    Public Shared Sub InsertRoadmap(ByVal ClientID As Integer, ByVal ClientStatusID As Integer, ByVal ParentRoadmapID As Integer, _
           ByVal Reason As String, ByVal UserID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "ClientStatusID", ClientStatusID)

        If Not Reason Is Nothing AndAlso Reason.Length > 255 Then
            Reason = Reason.Substring(0, 255)
        End If

        DatabaseHelper.AddParameter(cmd, "Reason", DataHelper.Zn(Reason))

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        If ParentRoadmapID > 0 Then
            DatabaseHelper.AddParameter(cmd, "ParentRoadmapID", DataHelper.Nz_int(ParentRoadmapID))
        End If

        DatabaseHelper.BuildInsertCommandText(cmd, "tblRoadmap", "RoadmapID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Public Shared Function InsertRoadmap(ByVal ClientID As Integer, ByVal ClientStatusID As Integer, _
        ByVal Reason As String, ByVal UserID As Integer) As Integer

        'find if clientstatusid already exist (duplicate roadmaps cannot exist for a client)
        Dim RoadmapID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblRoadmap", "RoadmapID", "ClientID = " & ClientID & " AND ClientStatusID = " & ClientStatusID))

        If RoadmapID = 0 Then 'doesn't exist

            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            'Get the parent RoadmapID
            cmd.CommandText = "SELECT TOP 1 RoadmapID FROM tblRoadmap INNER JOIN tblClientStatus ON " & _
                                "tblRoadmap.ClientStatusID=tblClientStatus.ClientStatusID where " & _
                                "tblClientStatus.ClientStatusId=(SELECT ParentClientStatusID from " & _
                                "tblClientStatus WHERE ClientStatusID=@ClientStatusID) and ClientID=@ClientID " & _
                                "ORDER BY tblRoadmap.Created DESC"

            DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
            DatabaseHelper.AddParameter(cmd, "ClientStatusID", ClientStatusID)

            cmd.Connection.Open()

            Dim ParentRoadmapID As Integer = DataHelper.Nz_int(cmd.ExecuteScalar())

            If Not Reason Is Nothing AndAlso Reason.Length > 255 Then
                Reason = Reason.Substring(0, 255)
            End If

            DatabaseHelper.AddParameter(cmd, "Reason", DataHelper.Zn(Reason))

            DatabaseHelper.AddParameter(cmd, "Created", Now)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

            If ParentRoadmapId <> 0 Then
                DatabaseHelper.AddParameter(cmd, "ParentRoadmapID", DataHelper.Nz_int(ParentRoadmapID))
            End If

            DatabaseHelper.BuildInsertCommandText(cmd, "tblRoadmap", "RoadmapID", SqlDbType.Int)

            Try

                cmd.ExecuteNonQuery()
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try

            RoadmapID = DataHelper.Nz_int(cmd.Parameters("@RoadmapID").Value)

        End If

        Return RoadmapID

    End Function
    Public Shared Function InsertRoadmapTask(ByVal RoadmapID As Integer, ByVal TaskID As Integer, _
        ByVal UserID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "RoadmapID", RoadmapID)
        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        DatabaseHelper.BuildInsertCommandText(cmd, "tblRoadmapTask", "RoadmapTaskID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@RoadmapTaskID").Value)

    End Function
    Public Shared Function InsertRoadmapNote(ByVal RoadmapID As Integer, ByVal NoteID As Integer, _
        ByVal UserID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "RoadmapID", RoadmapID)
        DatabaseHelper.AddParameter(cmd, "NoteID", NoteID)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        DatabaseHelper.BuildInsertCommandText(cmd, "tblRoadmapNote", "RoadmapNoteID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@RoadmapNoteID").Value)

    End Function
End Class