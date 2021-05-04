Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data

Public Class EnrollmentHelper

    Public Shared Sub UpdateEnrollmentClientID(ByVal EnrollmentID As Integer, ByVal ClientID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblEnrollment", "EnrollmentID = " & EnrollmentID)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Public Shared Sub UpdateEnrollmentNotQualified(ByVal EnrollmentID As Integer, ByVal QualifiedReason As String)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Qualified", False)
        DatabaseHelper.AddParameter(cmd, "Committed", DBNull.Value)
        DatabaseHelper.AddParameter(cmd, "QualifiedReason", DataHelper.Zn(QualifiedReason))

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblEnrollment", "EnrollmentID = " & EnrollmentID)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Public Shared Sub UpdateEnrollmentNotCommitted(ByVal EnrollmentID As Integer, ByVal CommittedReason As String)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Qualified", DBNull.Value)
        DatabaseHelper.AddParameter(cmd, "Committed", False)
        DatabaseHelper.AddParameter(cmd, "CommittedReason", DataHelper.Zn(CommittedReason))

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblEnrollment", "EnrollmentID = " & EnrollmentID)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
End Class