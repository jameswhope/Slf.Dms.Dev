Imports Drg.Util.DataAccess
Imports System.Configuration

Public Class JobStep
    Private Shared Function GetLastRunCheck(ByVal StepName As String) As DateTime
        Dim dt As DateTime
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandText = "stp_GetJobStepLastRunTime"
            DatabaseHelper.AddParameter(cmd, "StepName", StepName)
            Using cmd.Connection
                cmd.Connection.Open()
                Dim objDate As Object = cmd.ExecuteScalar()
                If Not objDate Is Nothing Then
                    dt = DateTime.Parse(objDate)
                Else
                    dt = Now.AddDays(-1)
                End If
            End Using
        End Using
        Return dt
    End Function

    Private Shared Sub SendDifferencesEmail(ByVal filename As String, ByVal date1 As DateTime, ByVal date2 As DateTime)
        If filename.Length > 0 Then
            Dim em As New Email
            em.SmtpServer = ConfigurationManager.AppSettings("SmtpServer").ToString
            em.From = "checkdiffs@lexxiom.com"
            em.To = ConfigurationManager.AppSettings("EmailTo").ToString
            em.Subject = "Commission Differences"
            em.Body = String.Format("Payments vs. Commissions discrepancies have been found from {0} to {1}. Please, see the attachment.", date1.ToString, date2.ToString)
            em.Send(filename)
        End If
    End Sub

    Public Shared Sub Execute()
        Dim StepName As String = ConfigurationManager.AppSettings("jobstep").ToString
        Dim d1 As DateTime = CheckCommPaidLib.JobStep.GetLastRunCheck(StepName)
        Dim d2 As DateTime = Now()
        'd1 = DateTime.Parse("11/26/2007")
        'd2 = DateTime.Parse("11/27/2007")
        Dim dt As DataTable = CheckCommPaidLib.Payment.GetPaymentCommDiffs(d1, d2)
        If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
            'Create File
            Dim fname As String = CheckCommPaidLib.Payment.CreateFile(dt)
            'Keep History in DB
            CheckCommPaidLib.Payment.SaveHistory(System.IO.Path.GetFileName(fname), dt)
            'Send Email
            SendDifferencesEmail(fname, d1, d2)
        End If
    End Sub

End Class
