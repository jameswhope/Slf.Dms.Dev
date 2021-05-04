Imports Microsoft.VisualBasic

Public Class ICLHelper
    Public Shared Function ReturnCheck(check21ID As String, reason As String, currentUserID As Integer) As String
        Dim result As String = String.Empty
        Try
            Dim sqlReg As String = String.Format("Select registerid from tbliclchecks where check21id = {0}", check21ID)
            Dim registerID As String = SqlHelper.ExecuteScalar(sqlReg, Data.CommandType.Text)

            result = String.Format("Register ID {0} has been returned for {1}", registerID, reason)

            'Drg.Util.DataHelpers.RegisterHelper.Void(registerID, currentUserID, True, reason)

        Catch ex As Exception
            Return ex.Message.ToString
        End Try
        Return result
    End Function
End Class
