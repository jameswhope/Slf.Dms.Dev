Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data

Public Class PhoneCallHelper

    Public Shared Sub RelatePhoneCall(ByVal PhoneCallID As Integer, ByVal RelationTypeID As Integer, ByVal RelationID As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "PhoneCallID", PhoneCallID)
        DatabaseHelper.AddParameter(cmd, "RelationTypeID", RelationTypeID)
        DatabaseHelper.AddParameter(cmd, "RelationId", RelationID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblPhoneCallRelation")

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub
    Public Shared Function UpdatePhoneCall(ByVal phoneCallId As Integer, ByVal UserID As Integer, ByVal InternalUserID As String, ByVal PersonID As Integer, ByVal Direction As Integer, ByVal PhoneNumber As String, ByVal Body As String, ByVal Subject As String, ByVal StartTime As DateTime, ByVal EndTime As DateTime) As Integer
        'If DataHelper.FieldCount("tblPhoneCall", "PhoneCallID", "Body = '" + Body.Substring(0, Integer.Parse(IIf(Body.Length > 1000, 1000, Body.Length))).Replace("'", "''") + "' and PersonID = " + PersonID.ToString() + " and Direction = " + Direction.ToString() + " and PhoneNumber = '" + PhoneNumber + "' and Subject = '" + Subject.Replace("'", "''") + "'") > 0 Then
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "Body", Body)
                DatabaseHelper.AddParameter(cmd, "PersonID", PersonID)
                DatabaseHelper.AddParameter(cmd, "Direction", Direction)
                DatabaseHelper.AddParameter(cmd, "PhoneNumber", PhoneNumber)
                DatabaseHelper.AddParameter(cmd, "Subject", Subject)
                DatabaseHelper.AddParameter(cmd, "StartTime", StartTime)
                DatabaseHelper.AddParameter(cmd, "EndTime", EndTime)
                DatabaseHelper.AddParameter(cmd, "UserID", InternalUserID)

                DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

                DatabaseHelper.BuildUpdateCommandText(cmd, "tblPhoneCall", "PhoneCallID = " & phoneCallId)

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        'End If

        Return phoneCallId
    End Function


    Public Shared Function InsertPhoneCall(ByVal ClientID As Integer, ByVal UserID As Integer, ByVal InternalUserID As String, _
        ByVal PersonID As Integer, ByVal Direction As Integer, ByVal PhoneNumber As String, _
        ByVal Body As String, ByVal Subject As String, ByVal StartTime As DateTime, _
        ByVal EndTime As DateTime) As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        If Body.Length > 1000 Then
            DatabaseHelper.AddParameter(cmd, "Body", Body.Substring(0, 5000))
        Else
            DatabaseHelper.AddParameter(cmd, "Body", Body)
        End If

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "PersonID", PersonID)
        DatabaseHelper.AddParameter(cmd, "Direction", Direction)
        DatabaseHelper.AddParameter(cmd, "PhoneNumber", PhoneNumber)
        DatabaseHelper.AddParameter(cmd, "Subject", Subject)
        DatabaseHelper.AddParameter(cmd, "StartTime", StartTime)
        DatabaseHelper.AddParameter(cmd, "EndTime", EndTime)
        DatabaseHelper.AddParameter(cmd, "UserID", InternalUserID)

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        DatabaseHelper.BuildInsertCommandText(cmd, "tblPhoneCall", "PhoneCallID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Return DataHelper.Nz_int(cmd.Parameters("@PhoneCallID").Value)

    End Function
    Public Shared Sub Delete(ByVal PhoneCallID As Integer())
        For i As Integer = 0 To PhoneCallID.Length - 1
            Delete(PhoneCallID(i), True)
        Next i
    End Sub
    Public Shared Sub Delete(ByVal PhoneCallID As Integer)
        Delete(PhoneCallID, True)
    End Sub
    Public Shared Sub Delete(ByVal PhoneCallID As Integer, ByVal RemoveDependencies As Boolean)

        'first remove the phone call itself
        DataHelper.Delete("tblPhoneCall", "PhoneCallID = " & PhoneCallID)

        If RemoveDependencies Then
            DataHelper.Delete("tblphonecallrelation", "PhoneCallID=" & PhoneCallID)
        End If

    End Sub

    Public Shared Function TruncateMessage(ByVal value As String) As String
        Return TruncateMessage(value, 150)
    End Function
    Public Shared Function TruncateMessage(ByVal value As String, ByVal length As Integer) As String
        If value.Length <= length Then
            Return value
        Else
            Return value.Substring(0, length) + "..."
        End If
    End Function

    Public Shared Function RegisterInboundCall(ByVal clientId As Integer, ByVal userId As Integer, ByVal callId As Long) As Long
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "ClientID", clientId)
        DatabaseHelper.AddParameter(cmd, "UserID", userId)
        DatabaseHelper.AddParameter(cmd, "CallID", callId, SqlDbType.BigInt)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblInboundCall", "InboundCall", SqlDbType.BigInt)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Function

End Class