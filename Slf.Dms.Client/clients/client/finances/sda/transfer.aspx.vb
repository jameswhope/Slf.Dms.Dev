Imports Drg.Util.DataAccess
Imports Drg.Util.Helpers
Imports Drg.Util.DataHelpers
Imports System.Data

Partial Class Clients_client_finances_sda_transfer
    Inherits System.Web.UI.Page

    Private _ClientID As Integer = -1
    Private _UserID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        If IsNumeric(Request.QueryString("id")) Then
            _ClientID = CInt(Request.QueryString("id"))
        Else
            btnCreate.Enabled = False
        End If
        If Not Page.IsPostBack Then
            lnkClient.InnerText = ClientHelper.GetDefaultPersonName(_ClientID)
            lnkClient.HRef = "~/clients/client/?id=" & _ClientID
            lnkSDAStructure.HRef = "default.aspx?id=" & _ClientID
            LoadTrustInfo()
        End If
    End Sub

    Protected Sub btnCreate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCreate.Click
        If Val(txtAmount.Text) > 0 Then
            CreateTransfer()
        End If
    End Sub

    Private Sub LoadTrustInfo()
        Dim table As DataTable = GetDataTable("select accountnumber, sdabalance from tblclient where clientid = " & _ClientID)

        btnCreate.Enabled = False

        If table.Rows.Count = 1 Then
            lblAccountNumber.Text = table.Rows(0)("accountnumber")
            lblSDABalance.Text = FormatCurrency(table.Rows(0)("sdabalance"), 2)

            table = GetDataTable(String.Format("select value[companypid] from tblaudit where auditcolumnid = 27 and pk = {0} order by auditid", _ClientID))
            If table.Rows.Count = 2 Then
                hdnOrigCompanyID.Value = table.Rows(0)(0)
                hdnCurCompanyID.Value = table.Rows(1)(0)

                table = GetDataTable(String.Format("select t.displayname, a.dc from tblaudit a join tbltrust t on t.trustid = a.value where a.auditcolumnid = 4 and a.pk = {0} order by a.auditid", _ClientID))
                If table.Rows.Count = 2 Then
                    lblOrigTrust.Text = table.Rows(0)(0)
                    lblCurrTrust.Text = table.Rows(1)(0)
                    lblDateConverted.Text = table.Rows(1)(1)
                    btnCreate.Enabled = True
                End If
            End If
        End If
    End Sub

    Private Sub CreateTransfer()
        Dim strOrigTrustName As String
        Dim strOrigTrustAcctNum As String
        Dim strOrigTrustRoutingNum As String
        Dim strOrigTrustType As String
        Dim strTransMSG As String
        Dim table As DataTable = GetDataTable("SELECT display, routingnumber, accountnumber, commrecid, isnull(type,'C') [type] from tblcommrec where istrust = 1 and companyid =  " & hdnOrigCompanyID.Value)

        If table.Rows.Count = 1 Then
            strOrigTrustName = table.Rows(0)("display").ToString
            strOrigTrustAcctNum = table.Rows(0)("accountnumber").ToString
            strOrigTrustRoutingNum = table.Rows(0)("routingnumber").ToString
            strOrigTrustType = table.Rows(0)("type").ToString
        End If

        strTransMSG = "Transfering " & FormatCurrency(txtAmount.Text, 2) & " from " & strOrigTrustName & " to Shadow Account " & lblAccountNumber.Text & "."

        Drg.Util.DataHelpers.RegisterHelper.InsertDebit(_ClientID, Nothing, Format(DateAdd(DateInterval.Day, 1, Now), "MM/dd/yyy") & " 12:01 AM", Nothing, strTransMSG, Val(txtAmount.Text) * -1, _UserID, 44, _UserID)
        Dim registerID As Integer = Drg.Util.DataHelpers.RegisterHelper.InsertDeposit(_ClientID, Format(DateAdd(DateInterval.Day, 1, Now), "MM/dd/yyy") & " 12:01 AM", "NULL", strTransMSG, Val(txtAmount.Text), 45, DateAdd(DateInterval.Day, 1, Now), _UserID, _UserID)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        DatabaseHelper.AddParameter(cmd, "Name", strOrigTrustName)
        DatabaseHelper.AddParameter(cmd, "AccountNumber", strOrigTrustAcctNum)
        DatabaseHelper.AddParameter(cmd, "RoutingNumber", strOrigTrustRoutingNum)
        DatabaseHelper.AddParameter(cmd, "Type", strOrigTrustType)
        DatabaseHelper.AddParameter(cmd, "Amount", Val(txtAmount.Text))
        DatabaseHelper.AddParameter(cmd, "IsPersonal", 0)
        DatabaseHelper.AddParameter(cmd, "CompanyID", CInt(hdnCurCompanyID.Value))
        DatabaseHelper.AddParameter(cmd, "ShadowStoreId", lblAccountNumber.Text)
        DatabaseHelper.AddParameter(cmd, "ClientID", _ClientID)
        DatabaseHelper.AddParameter(cmd, "RegisterID", registerID)
        DatabaseHelper.AddParameter(cmd, "Flow", "credit")
        DatabaseHelper.BuildInsertCommandText(cmd, "tblNachaRegister2")

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            Drg.Util.DataHelpers.NoteHelper.InsertNote(strTransMSG, _UserID, _ClientID)
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Response.Redirect("~/clients/client/?id=" & _ClientID)
    End Sub

    Private Function GetDataTable(ByVal sqlText As String) As DataTable
        Try
            Dim dtData As New DataTable
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Dim cnString As String = cmd.Connection.ConnectionString
            cmd.Dispose()
            cmd = Nothing
            Using saTemp = New SqlClient.SqlDataAdapter(sqlText, cnString)
                saTemp.Fill(dtData)
            End Using
            Return dtData
        Catch ex As Exception
            Return Nothing
        End Try
    End Function
End Class
