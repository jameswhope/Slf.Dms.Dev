Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data
Imports System.Data.SqlClient

Public Class NoteHelper
    Public Shared Function AppendNote(ByVal noteId As Integer, ByVal value As String, ByVal userId As Integer)
        Dim strNote As String = DataHelper.FieldLookup("tblNote", "Value", "NoteID = " + noteId.ToString())

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "Value", value & Chr(13) & strNote.Replace("SessionStarted", ""))

                DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", userId)

                DatabaseHelper.BuildUpdateCommandText(cmd, "tblNote", "NoteID = " & noteId)

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        Return noteId
    End Function
    Public Shared Function UpdateNote(ByVal noteId As Integer, ByVal value As String, ByVal userId As Integer)
        If Not DataHelper.FieldLookup("tblNote", "Value", "NoteID = " + noteId.ToString()) = value Then
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    DatabaseHelper.AddParameter(cmd, "Value", value)

                    DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                    DatabaseHelper.AddParameter(cmd, "LastModifiedBy", userId)

                    DatabaseHelper.BuildUpdateCommandText(cmd, "tblNote", "NoteID = " & noteId)

                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        End If

        Return noteId
    End Function
    Public Shared Sub RelateNote(ByVal NoteID As Integer, ByVal RelationTypeID As Integer, ByVal RelationID As Integer)
        'check for existing relation, if exists do not relate again
        Dim strRelation As String = DataHelper.FieldLookup("tblNoteRelation", "noterelationid", "NoteID = " & NoteID.ToString() & " and relationtypeid=" & RelationTypeID.ToString() & " and relationid=" & RelationID.ToString())
        If strRelation.ToString = "" Then

            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "NoteID", NoteID)
            DatabaseHelper.AddParameter(cmd, "RelationTypeID", RelationTypeID)
            DatabaseHelper.AddParameter(cmd, "RelationId", RelationID)

            DatabaseHelper.BuildInsertCommandText(cmd, "tblNoteRelation")

            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try
        End If

    End Sub
    Public Shared Function InsertNote(ByVal Value As String, ByVal UserID As Integer, ByVal ClientID As Integer) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Value", Value)
        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblNote", "NoteID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@NoteID").Value)

    End Function

    Public Shared Sub Delete(ByVal NoteID As Integer())
        For i As Integer = 0 To NoteID.Length - 1
            Delete(NoteID(i), True)
        Next i
    End Sub
    Public Shared Sub Delete(ByVal NoteID As Integer)
        Delete(NoteID, True)
    End Sub
    Public Shared Sub Delete(ByVal NoteID As Integer, ByVal RemoveDependencies As Boolean)

        'first remove the note itself
        DataHelper.Delete("tblNote", "NoteID = " & NoteID)

        If RemoveDependencies Then

            'remove any relations
            DataHelper.Delete("tblnoterelation", "NoteID=" & NoteID)

            'remove note from tasks
            DataHelper.Delete("tblTaskNote", "NoteID = " & NoteID)

            'remove note from roadmaps
            DataHelper.Delete("tblRoadmapNote", "NoteID = " & NoteID)

        End If

    End Sub

    Public Shared Function TruncateMessage(ByVal value As String) As String
        Return TruncateMessage(value, 50)
    End Function
    Public Shared Function TruncateMessage(ByVal value As String, ByVal length As Integer) As String
        If value.Length <= length Then
            Return value
        Else
            Return value.Substring(0, length) + "..."
        End If
    End Function

    Public Shared Function GetNote(ByVal NoteID As String) As String
        Using cmd As New SqlCommand("SELECT [Value] FROM tblNote WHERE NoteID = " & NoteID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Return cmd.ExecuteScalar()
            End Using
        End Using
    End Function
End Class