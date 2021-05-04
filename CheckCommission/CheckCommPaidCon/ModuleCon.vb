Imports CheckCommPaidLib

Module ModuleCon

    Sub Main()
        Try
            JobStep.Execute()
            System.Environment.ExitCode = 0
        Catch ex As Exception
            System.Environment.ExitCode = 1
            My.Application.Log.WriteException(ex, TraceEventType.Error, String.Format("Date and Time: {0}.", Now.ToString()))
        End Try
    End Sub

End Module
