Imports Drg.Util.DataAccess
Imports System.IO
Imports System.Text
Imports System.Configuration

Public Class Payment
    Public Shared Function GetPaymentCommDiffs(ByVal StartDate As DateTime, ByVal EndDate As DateTime) As DataTable
        Dim dt As DataTable
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandText = "stp_GetPaymentCommissionDiff"
            DatabaseHelper.AddParameter(cmd, "StartDate", StartDate)
            DatabaseHelper.AddParameter(cmd, "EndDate", EndDate)
            Using cmd.Connection
                cmd.Connection.Open()
                Dim ds As DataSet = DatabaseHelper.ExecuteDataset(cmd)
                If Not ds Is Nothing AndAlso Not ds.Tables(0) Is Nothing Then
                    dt = ds.Tables(0)
                End If
            End Using
        End Using
        Return dt
    End Function

    Public Shared Function CreateFile(ByVal dt As DataTable) As String
        Dim sw As StreamWriter
        Dim fname As String
        Dim TmpPayCommDir As String = ConfigurationManager.AppSettings("tmpFolder").ToString

        Try
            If Not Directory.Exists(TmpPayCommDir) Then
                Directory.CreateDirectory(TmpPayCommDir)
            End If
            Dim sbh As New StringBuilder()
            fname = Path.Combine(TmpPayCommDir, String.Format("Discrepancies Report {0}.csv", Now.ToString("MM-dd-yyyy HH.mm.ss")))
            sw = New StreamWriter(fname)
            'Write Headers
            Dim separator As String = ""
            For Each col As DataColumn In dt.Columns
                sbh.AppendFormat("{0}{1}", separator, col.ColumnName)
                separator = ","
            Next
            sw.WriteLine(sbh.ToString)
            'Write Data
            For Each dr As DataRow In dt.Rows
                Dim sb As New StringBuilder
                separator = ""
                For Each col As DataColumn In dt.Columns
                    sb.AppendFormat("{0}{1}", separator, dr(col.ColumnName).ToString)
                    separator = ","
                Next
                sw.WriteLine(sb.ToString)
            Next
            sw.Flush()
        Finally
            If Not sw Is Nothing Then sw.Close()
        End Try
        Return fname
    End Function

    Public Shared Sub SaveHistory(ByVal FileName As String, ByVal dt As DataTable)
        For Each dr As DataRow In dt.Rows
            InsertHistoryItem(FileName, dr("Client Id"), dr("Payment Id"), dr("Payment Date"), dr("Fee Id"), dr("Fee Type"), dr("Amount Paid"), dr("Commission Paid"))
        Next
    End Sub

    Public Shared Sub InsertHistoryItem(ByVal FileName As String, ByVal ClientId As Integer, ByVal PaymentId As Integer, ByVal PaymentDate As DateTime, ByVal RegisterId As Integer, ByVal EntryTypeId As Integer, ByVal PaymentAmount As Decimal, ByVal CommissionPaid As Decimal)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

        DatabaseHelper.AddParameter(cmd, "FileName", FileName)
        DatabaseHelper.AddParameter(cmd, "ClientId", ClientId)
        DatabaseHelper.AddParameter(cmd, "PaymentId", PaymentId)
        DatabaseHelper.AddParameter(cmd, "PaymentDate", PaymentDate)
        DatabaseHelper.AddParameter(cmd, "RegisterId", RegisterId)
        DatabaseHelper.AddParameter(cmd, "EntryTypeId", EntryTypeId)
        DatabaseHelper.AddParameter(cmd, "PaymentAmount", PaymentAmount)
        DatabaseHelper.AddParameter(cmd, "CommissionPaid", CommissionPaid)
        DatabaseHelper.BuildInsertCommandText(cmd, "tblPaymentCommDiffHistory", "DiscrepancyId", SqlDbType.Int)
        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

End Class
