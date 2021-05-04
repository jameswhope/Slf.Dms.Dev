Imports Drg.Util.DataAccess

Imports System.Data.SqlClient

Public Class AuditTransaction
    Public Shared Sub AuditTransaction(ByVal ClientID As Integer, ByVal ID As Integer, ByVal TranType As String, ByVal Reason As String, ByVal Amount As Double, ByVal UserID As Integer)
        Using cmd As New SqlCommand("SELECT count(*) FROM tblTransactionAudit WHERE [Value] = " + ID.ToString() + " and [Type] = '" + TranType + "'", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                If Integer.Parse(cmd.ExecuteScalar()) = 0 Then
                    cmd.CommandText = "INSERT INTO tblTransactionAudit (ClientID, [Value], [Type], Reason, Amount, Created, CreatedBy) VALUES (" + ClientID.ToString() + ", " + ID.ToString() + ", '" + TranType + "', '" + Reason + "', " + Math.Abs(Amount).ToString() + ", getdate(), " + UserID.ToString() + ")"
                    cmd.ExecuteNonQuery()
                End If
            End Using
        End Using
    End Sub
End Class