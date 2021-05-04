Imports Drg.Util.DataAccess
Imports System.Configuration

Public Class CICHelper
    Public Shared Function GetBusinessPhone(ByVal cicUserId As String) As String
        Dim PhoneNumber As String = String.Empty
        Using conn As IDbConnection = Drg.Util.DataAccess.ConnectionFactory.Create(ConfigurationManager.AppSettings("connectionstringcic").ToString)
            Using cmd As IDbCommand = conn.CreateCommand()
                cmd.CommandText = String.Format("Select BusinessPhone From IndivDetails Where ICUserId = '{0}'", cicUserId)
                conn.Open()
                PhoneNumber = cmd.ExecuteScalar().ToString
            End Using
        End Using
        Return PhoneNumber
    End Function
End Class
