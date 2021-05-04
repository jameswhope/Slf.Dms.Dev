Imports System.Data
Imports System.Data.SqlClient


Partial Class research_reports_financial_IOLTALedger
    Inherits System.Web.UI.Page

    Protected Sub btnRun_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRun.Click
        If Me.sDateTxt.Text = "" Then Me.sDateTxt.Text = Format(Now, "MM/dd/yyyy")
        If Me.eDateTxt.Text = "" Then Me.eDateTxt.Text = Format(Now, "MM/dd/yyyy")
        Dim strSQL As String = "stp_IOLTA_Ledger '" & Me.sDateTxt.Text.ToString & " 12:00 AM', '" & Me.eDateTxt.Text.ToString & " 11:59 PM', " & 4 & ", " & 26
        Dim strBeginBal As String = "stp_IOLTA_BeginBal '" & Me.sDateTxt.Text.ToString & " 12:00 AM', '" & Me.eDateTxt.Text.ToString & " 11:59 PM', " & 4 & ", " & 26
        Dim strEndBal As String = "stp_IOLTA_EndBal '" & Me.sDateTxt.Text.ToString & " 12:00 AM', '" & Me.eDateTxt.Text.ToString & " 11:59 PM', " & 4 & ", " & 26

        Me.lblBeginBal.Text = "Beginning Balance: " & SqlHelper.ExecuteScalar(strBeginBal, CommandType.Text).ToString
        Me.lblEndBal.Text = "Ending Balance: " & SqlHelper.ExecuteScalar(strEndBal, CommandType.Text).ToString

        Dim dt As DataTable
        dt = SqlHelper.GetDataTable(strSQL, CommandType.Text)
        Me.rptIOLTALedger.DataSource = dt
        Me.rptIOLTALedger.DataBind()
    End Sub

    Protected Function InsertNBSP(ByVal Field As String) As String
        If Field = "" Then
            Return "&nbsp;"
        Else
            Return Field
        End If
    End Function
End Class
