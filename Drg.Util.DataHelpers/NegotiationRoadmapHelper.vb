Imports Drg.Util.DataAccess

Imports System.Data
Imports System.Data.SqlClient

Public Class NegotiationRoadmapHelper
    Public Shared Sub InsertRoadmap(ByVal SettlementID As Integer, ByVal SettlementStatusID As Integer, ByVal ParentRoadmapID As Integer, ByVal Reason As String, ByVal UserID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "SettlementID", SettlementID)
        DatabaseHelper.AddParameter(cmd, "SettlementStatusID", SettlementStatusID)

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

        DatabaseHelper.BuildInsertCommandText(cmd, "tblNegotiationRoadmap", "RoadmapID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Public Shared Function InsertRoadmap(ByVal SettlementID As Integer, ByVal SettlementStatusID As Integer, ByVal Reason As String, ByVal UserID As Integer) As Integer

        'find if clientstatusid already exist (duplicate roadmaps cannot exist for a client)
        Dim RoadmapID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblNegotiationRoadmap", "RoadmapID", "SettlementID = " & SettlementID & " AND SettlementStatusID = " & SettlementStatusID))

        If RoadmapID = 0 Then 'doesn't exist

            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            'Get the parent RoadmapID
            cmd.CommandText = "SELECT TOP 1 RoadmapID FROM tblNegotiationRoadmap INNER JOIN tblNegotiationSettlementStatus ON " & _
                                "tblNegotiationRoadmap.SettlementStatusID=tblNegotiationSettlementStatus.SettlementStatusID where " & _
                                "tblNegotiationSettlementStatus.SettlementStatusId=(SELECT ParentSettlementStatusID from " & _
                                "tblNegotiationSettlementStatus WHERE SettlementStatusID=@SettlementStatusID) and SettlementID=@SettlementID " & _
                                "ORDER BY tblNegotiationRoadmap.Created DESC"

            DatabaseHelper.AddParameter(cmd, "SettlementID", SettlementID)
            DatabaseHelper.AddParameter(cmd, "SettlementStatusID", SettlementStatusID)

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

            If ParentRoadmapID <> 0 Then
                DatabaseHelper.AddParameter(cmd, "ParentRoadmapID", DataHelper.Nz_int(ParentRoadmapID))
            End If

            DatabaseHelper.BuildInsertCommandText(cmd, "tblNegotiationRoadmap", "RoadmapID", SqlDbType.Int)

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

        DatabaseHelper.BuildInsertCommandText(cmd, "tblNegotiationRoadmapTask", "RoadmapTaskID", SqlDbType.Int)

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

        DatabaseHelper.BuildInsertCommandText(cmd, "tblNegotiationRoadmapNote", "RoadmapNoteID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@RoadmapNoteID").Value)
    End Function

    Private Shared Function GetRoadmapNote(ByVal NoteID As Integer) As String
        Return NoteHelper.GetNote(NoteID)
    End Function

    Private Shared Function GetRoadmapNoteByID(ByVal RoadmapNoteID As Integer) As String
        Dim noteID As Integer

        Using cmd As New SqlCommand("SELECT NoteID FROM tblNegotiationRoadmapNote WHERE RoadmapNoteID = " & RoadmapNoteID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                noteID = cmd.ExecuteScalar()
            End Using
        End Using

        Return GetRoadmapNote(noteID)
    End Function
End Class