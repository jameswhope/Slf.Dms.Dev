Imports Drg.Util.DataHelpers
Imports Drg.Util.DataAccess
Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Public Class ClientHelper2

    Public Shared Sub GetBalances(ByVal ClientID As Integer, ByRef SDABalance As Double, ByRef BankReserve As Double, ByRef AvailSDA As Double, ByRef PFOBalance As Double, ByRef FundsOnHold As Double)
        Dim tbl As DataTable
        Dim row As DataRow

        tbl = SqlHelper.GetDataTable("select pfobalance, sdabalance, isnull(bankreserve,0) [bankreserve], dbo.udf_FundsOnHold(clientid,-1) [fundsonhold], isnull(availablesda,0) - dbo.udf_FundsOnHold(clientid,-1) [availablesda] from tblclient where clientid = " & ClientID)

        If tbl.Rows.Count = 1 Then
            row = tbl.Rows(0)
            PFOBalance = CDbl(row("pfobalance"))
            SDABalance = CDbl(row("sdabalance"))
            BankReserve = CDbl(row("bankreserve"))
            FundsOnHold = CDbl(row("fundsonhold"))
            AvailSDA = CDbl(row("availablesda"))
        End If
    End Sub

    Public Shared Function ExpectedDeposits(ByVal ClientId As Integer, ByVal EndDate As String) As DataSet
        Dim params(1) As SqlParameter
        Dim ds As New DataSet

        params(0) = New SqlParameter("ClientId", ClientId)
        params(1) = New SqlParameter("EndDate", EndDate)
        ds = SqlHelper.GetDataSet("stp_ExpectedDeposits", , params)

        Return ds
    End Function

    Public Shared Function GetPendingLeadsCount(ByVal companyid As Integer, ByVal userid As Integer) As String
        Dim params As New List(Of SqlParameter)
        If companyid > 0 Then
            params.Add(New SqlParameter("@companyid", companyid))
        End If
        params.Add(New SqlParameter("@userid", userid))
        Try
            'Return String.Format("({0})", SqlHelper.ExecuteScalar("stp_PendingLeadsReportCount", Data.CommandType.StoredProcedure, params.ToArray).ToString)
            Return String.Format("({0})", SqlHelper.ExecuteScalar("stp_PendingClientsReportCount", Data.CommandType.StoredProcedure, params.ToArray).ToString)
        Catch ex As Exception
            Return "()"
        End Try
    End Function
End Class
