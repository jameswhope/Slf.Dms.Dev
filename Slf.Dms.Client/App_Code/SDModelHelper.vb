Imports Microsoft.VisualBasic
Imports Drg.Util.DataAccess
Imports System.Data.SqlClient

Public Class SDModelHelper
    Public Shared Sub ConvertToModel(ByVal EnrollmentPage As String, ByVal LeadId As Integer, ByVal UserId As Integer)

        Dim notetext As String
        Select Case EnrollmentPage.Trim.ToLower
            Case "newenrollment.aspx"
                notetext = "Subsequent year service fee. (old calculator)"
            Case "newenrollment2.aspx"
                notetext = "Service fee per account with a maximum fee amount. (new calculator)"
            Case Else
                Return
        End Select

        Dim cmd As SqlCommand = Nothing
        Dim strSQL As String = String.Format("Update tblLeadApplicant Set EnrollmentPage = '{0}', LastModified = GetDate(), LastModifiedById = {1} Where LeadApplicantId = {2}", EnrollmentPage, UserId, LeadId)
        Try
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            If cmd.Connection.State <> Data.ConnectionState.Closed Then cmd.Connection.Close()
        End Try

        InsertNote(notetext, LeadId, UserId)

    End Sub

    Public Shared Sub InsertNote(ByVal noteText As String, ByVal LeadId As Integer, ByVal UserId As Integer)
        Dim cmd As SqlCommand = Nothing
        Dim strSQL As String = String.Format("INSERT INTO tblLeadNotes (LeadApplicantID, notetypeid, NoteType, Value, Created, CreatedByID, Modified, ModifiedBy) VALUES ({0}, 3 ,'OTHER', 'Lead switched to {1}', GetDate(), {2}, GetDate(), {2})", LeadId, noteText, UserId)
        Try
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            If cmd.Connection.State <> Data.ConnectionState.Closed Then cmd.Connection.Close()
        End Try
    End Sub

    Public Shared Sub ConvertToServiceFeeCapModel(ByVal ClientId As Integer, ByVal UserId As Integer)
        Dim cmd As SqlCommand = Nothing
        Dim strSQL As String = "stp_ConvertToMaintFeeCap"
        Try
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            cmd.CommandType = Data.CommandType.StoredProcedure

            Dim param As New SqlParameter("@ClientId", Data.SqlDbType.Int)
            param.Value = ClientId
            cmd.Parameters.Add(param)

            param = New SqlParameter("@UserId", Data.SqlDbType.Int)
            param.Value = UserId
            cmd.Parameters.Add(param)

            cmd.Connection.Open()
            cmd.ExecuteNonQuery()

        Catch ex As Exception
            Throw ex
        Finally
            If cmd.Connection.State <> Data.ConnectionState.Closed Then cmd.Connection.Close()
        End Try

    End Sub
End Class
