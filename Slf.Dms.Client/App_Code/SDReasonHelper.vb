Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess

Public Class SDReasonHelper

   Public Shared Function SaveReason(ByVal ApplicantID As Integer, ByVal StatusID As Integer, ByVal Reason As String, ByVal UserID As Integer) As Boolean
      Dim cmd As New Data.SqlClient.SqlCommand()
      Dim Exists As Integer

      cmd.CommandType = CommandType.Text
      cmd.CommandText = "SELECT top 1 LeadApplicantID FROM tblLeadRoadMap WHERE LeadApplicantID = " & ApplicantID & " AND LeadStatusID = " & StatusID
      cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
      cmd.Connection.Open()
      Exists = cmd.ExecuteScalar
        cmd.Connection.Close()

        If Exists <= 0 And StatusID > 0 Then 'Write to the roadmap and the LeadApplicant table
            Try
                cmd.CommandText = "INSERT INTO tblLeadRoadmap (LeadApplicantID, LeadStatusID, Reason, Created, CreatedBy, LastModified, LastModifiedBy) VALUES (" & ApplicantID & ", " & StatusID & ", '" & Reason & "', '" & Now & "', " & UserID & ", '" & Now & "', " & UserID & ")"
                cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
                cmd.Connection.Close()

                'Write to the LeadAppliant table
                cmd.CommandType = Data.CommandType.Text
                cmd.CommandText = "UPDATE tblLeadApplicant SET StatusID = " & StatusID & " WHERE LeadApplicantID = " & ApplicantID
                cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

                Return True
            Catch ex As Exception
                Throw ex
            Finally
                cmd.Dispose()
                cmd = Nothing
            End Try
        Else
            Alert.Show("This client has already had a " & DataHelper.FieldLookup("tblLeadRoadMap", "Reason", "LeadApplicantID = " & ApplicantID & " AND LeadStatusID = " & StatusID) & " reason on file.")
            Return False
        End If
        Return False

   End Function

    Public Shared Function LoadReasons(Optional ByVal ReasonType As String = "DNQ") As SqlDataReader
        Dim cmd As New Data.SqlClient.SqlCommand()
        Dim dr As SqlDataReader

        Try
            cmd.CommandType = Data.CommandType.Text
            cmd.CommandText = String.Format("SELECT Description FROM tblLeadReasons WHERE ReasonType = '" & ReasonType & "' ORDER BY DisplayOrder")
            cmd.Connection = New Data.SqlClient.SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
            cmd.Connection.Open()
            dr = cmd.ExecuteReader()
            Return dr
        Catch ex As Exception
            Throw ex
            Return Nothing
        Finally
            cmd.Dispose()
            cmd = Nothing
        End Try
    End Function
End Class
