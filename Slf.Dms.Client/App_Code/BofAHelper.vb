Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataHelpers
Imports Drg.Util.DataAccess

Public Class BofAHelper

    Public Function TransferAccount(ByVal ClientID As Integer) As Long
        Dim cn As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
        Try
            Dim TrustID = DataHelper.FieldLookup("tblTrust", "TrustID", "Name = 'Woolery'")
            Dim strSQL As String = "UPDATE tblClient SET TrustID = " & TrustID & " WHERE ClientID = " & ClientID
            'Flagged for change the nightly process will modify the conversion date for the account.
            cn.Open()
            'Modify the trust we are going to create the account in batch so don't do it now just mark the file for conversion
            Dim cmd As New SqlCommand(strSQL, cn)
            Return cmd.ExecuteNonQuery()
        Catch ex As Exception
            Alert.Show("An error was encounterd updating the banking information in the clients record. " & ex.Message)
        Finally
            cn.Close()
        End Try
    End Function

End Class
