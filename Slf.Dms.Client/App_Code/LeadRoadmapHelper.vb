Imports Microsoft.VisualBasic
Imports System.Data
Imports Drg.Util.DataAccess
Imports System.Data.SqlClient

Public Class LeadRoadmapHelper
	Public Shared Function GetRoadmapID(ByVal LeadApplicantID As Integer) As String
		Dim roadmapID As Integer

		Dim ssql As String = "SELECT TOP (1) RoadmapID, LeadApplicantID FROM tblLeadStatusRoadMap AS rm "
		ssql += String.Format("WHERE (LeadApplicantID = {0}) ORDER BY LastModified DESC", LeadApplicantID)

		Using cmd As New SqlCommand(ssql, ConnectionFactory.Create())
			Using cmd.Connection
				cmd.Connection.Open()
				roadmapID = cmd.ExecuteScalar()
			End Using
		End Using

		Return roadmapID
    End Function

	Public Shared Sub InsertRoadmap(ByVal LeadApplicantID As Integer, ByVal LeadStatusID As Integer, ByVal ParentRoadmapID As Integer, ByVal Reason As String, ByVal UserID As Integer)

		Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

		DatabaseHelper.AddParameter(cmd, "LeadApplicantID", LeadApplicantID)
		DatabaseHelper.AddParameter(cmd, "LeadStatusID", LeadStatusID)

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

        DatabaseHelper.BuildInsertCommandText(cmd, "tblLeadStatusRoadmap", "RoadmapID", SqlDbType.Int)

		Try
			cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        InsertLeadRoadmap(LeadApplicantID, LeadStatusID, ParentRoadmapID, Reason, UserID)

    End Sub

    Public Shared Sub InsertLeadRoadmap(ByVal LeadApplicantID As Integer, ByVal LeadStatusID As Integer, ByVal ParentRoadmapID As Integer, ByVal Reason As String, ByVal UserID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "LeadApplicantID", LeadApplicantID)
        DatabaseHelper.AddParameter(cmd, "LeadStatusID", LeadStatusID)

        If Not Reason Is Nothing AndAlso Reason.Length > 255 Then
            Reason = Reason.Substring(0, 255)
        End If

        DatabaseHelper.AddParameter(cmd, "Reason", DataHelper.Zn(Reason))

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))

        If ParentRoadmapID > 0 Then
            DatabaseHelper.AddParameter(cmd, "ParentLeadRoadmapID", DataHelper.Nz_int(ParentRoadmapID))
        End If

        DatabaseHelper.BuildInsertCommandText(cmd, "tblLeadRoadmap", "LeadRoadmapID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

End Class
