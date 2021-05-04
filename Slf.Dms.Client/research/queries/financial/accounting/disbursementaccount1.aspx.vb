Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper

Imports System.Deployment
Imports System.Threading
Imports System.Windows.Forms
Imports System.IO
Imports System.Security.Cryptography
Imports System.Drawing

Partial Class research_queries_financial_accounting_disbursementaccount1
    Inherits PermissionPage

#Region "Variables"
    Private UserID As Integer

    Private Property Setting(ByVal s As String) As String
        Get
            Return Session(Me.UniqueID & "_" & s)
        End Get
        Set(ByVal value As String)
            Session(Me.UniqueID & "_" & s) = value
        End Set
    End Property

    Private Function GetSetting(ByVal s As String, ByVal d As String) As String
        Dim v As String = Setting(s)
        If String.IsNullOrEmpty(v) Then
            Return d
        Else
            Return v
        End If
    End Function
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Me.IsPostBack Then
            Initialize()
        End If

        Requery()
    End Sub

    Private Sub Initialize()
        Me.txtBeginDate.Text = DateTime.Today.ToShortDateString
        Me.txtEndDate.Text = DateTime.Today.ToShortDateString
        'SetAccountBalance()
    End Sub

    Public Sub Requery()
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetDisbursementTransactions")
        If Me.txtBeginDate.Text.Trim.Length > 0 Then DatabaseHelper.AddParameter(cmd, "StartDate", Me.txtBeginDate.Text)
        If Me.txtEndDate.Text.Trim.Length > 0 Then DatabaseHelper.AddParameter(cmd, "EndDate", CDate(Me.txtEndDate.Text).AddDays(1))
        grdResults.DataCommand = cmd
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        'AddControl(pnlBody, c, "Research-Queries-Finacial-Accounting-Disbursement Report")
    End Sub

    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
        grdResults.Reset(True)
        Requery()
    End Sub
  
    'Private Sub SetAccountBalance()
    '    Dim qry As WCFClient.QuerySvc

    '    Try
    '        qry = New WCFClient.QuerySvc
    '        Dim resp As WCFClient.CheckSite.Lexxiom.Entities.Ws.Queries.ControlledAccountBalanceResponse
    '        resp = qry.GetAccountBalance("Disbursement Account")
    '        If resp.Status <> WCFClient.CheckSite.Lexxiom.Entities.Ws.Queries.ControlledAccountBalanceResponse.StatusType.Succeeded Then Throw New Exception("Cannot get the balance information for this account.")
    '        lblBalance.Text = String.Format("Balance Date: {0:g}, Balance: <span style='color: {1}'>{2:c}</span>, Processed: <span style='color: {1}'>{2:c}</span>, Unprocessed: <span style='color: {3}'>{4:c}</span>, Net: <span style='color: {5}'>{6:c}</span>", resp.BalanceDate, IIf(resp.Balance > 0, "black", "red"), resp.Balance, IIf(resp.Processed > 0, "black", "red"), resp.Processed, IIf(resp.UnProcessed > 0, "black", "red"), resp.UnProcessed, IIf(resp.Balance + resp.Processed + resp.UnProcessed > 0, "black", "red"), resp.Balance + resp.Processed + resp.UnProcessed)
    '    Catch ex As Exception
    '        lblBalance.Text = "There was an error trying to get the account balance. Please, contact your system administrator."
    '    Finally
    '        If Not qry Is Nothing Then qry.Close()
    '    End Try
    'End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetDisbursementTransactions")
        Dim tblTransactions As New DataTable
        Dim sw As New StringWriter
        Dim htw As New HtmlTextWriter(sw)
        Dim table As New System.Web.UI.WebControls.Table
        Dim tr As New System.Web.UI.WebControls.TableRow
        Dim cell As TableCell

        DatabaseHelper.AddParameter(cmd, "StartDate", Me.txtBeginDate.Text)
        DatabaseHelper.AddParameter(cmd, "EndDate", CDate(Me.txtEndDate.Text).AddDays(1))

        cmd.Connection.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString
        Using saTemp = New SqlClient.SqlDataAdapter(cmd)
            saTemp.Fill(tblTransactions)
        End Using

        For i As Integer = 0 To tblTransactions.Columns.Count - 1
            cell = New TableCell
            cell.Text = tblTransactions.Columns(i).ColumnName
            tr.Cells.Add(cell)
        Next
        table.Rows.Add(tr)

        For Each row As DataRow In tblTransactions.Rows
            tr = New TableRow
            For i As Integer = 0 To tblTransactions.Columns.Count - 1
                cell = New TableCell
                cell.Attributes.Add("class", "text")
                cell.Text = row.Item(i).ToString
                tr.Cells.Add(cell)
            Next
            table.Rows.Add(tr)
        Next

        table.RenderControl(htw)

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.ContentType = "application/ms-excel"
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=disbursement_transfers.xls")
        'HttpContext.Current.Response.Write("<style>.text { mso-number-format:\@; } </style>")
        HttpContext.Current.Response.Write(sw.ToString)
        HttpContext.Current.Response.End()
    End Sub
End Class
