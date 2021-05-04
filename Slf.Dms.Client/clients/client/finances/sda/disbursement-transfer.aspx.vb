Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataHelpers
Imports Drg.Util.DataAccess

Partial Class Clients_client_finances_sda_disbursement_transfer
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If IsNumeric(Request.QueryString("id")) AndAlso IsNumeric(Request.QueryString("rid")) Then
                LoadTransfer()
            Else
                btnSubmit.Enabled = False
            End If
        End If
    End Sub

    Private Sub LoadTransfer()
        Dim cmdText As New Text.StringBuilder
        Dim tblTransfer As DataTable
        Dim tblBankAccounts As DataTable
        Dim params(0) As SqlParameter
        Dim row As DataRow

        lnkClient.InnerText = Drg.Util.DataHelpers.ClientHelper.GetDefaultPersonName(CInt(Request.QueryString("id")))
        lnkClient.HRef = "~/clients/client/?id=" & Request.QueryString("id")

        With cmdText
            .Append("select n.name, r.checknumber, r.registerid, n.amount, '('+e.type+')'+' '+e.name [type], c.accountnumber, c.companyid ")
            .Append("from tblnacharegister2 n ")
            .Append("join tblregister r on r.registerid = n.registerid ")
            .Append("join tblclient c on c.clientid = r.clientid ")
            .Append("join tblentrytype e on e.entrytypeid = r.entrytypeid ")
            .Append("where n.registerid = " & Request.QueryString("rid") & " and n.trustid = 23 and n.state = 1 and n.status = 0 and n.flow = 'debit'")
        End With

        tblTransfer = SqlHelper.GetDataTable(cmdText.ToString)

        If tblTransfer.Rows.Count = 1 Then
            lblFrom.Text = tblTransfer.Rows(0)("name")
            lblAmount.Text = FormatCurrency(tblTransfer.Rows(0)("amount"), 2)
            lblTransactionID.Text = tblTransfer.Rows(0)("registerid")
            lblTransactionType.Text = tblTransfer.Rows(0)("type")
            lblCheckNumber.Text = tblTransfer.Rows(0)("checknumber")
            hdnAccountNumber.Value = tblTransfer.Rows(0)("accountnumber")
            hdnCompanyID.Value = tblTransfer.Rows(0)("companyid")
            params(0) = New SqlParameter("ClientID", Request.QueryString("id"))
            tblBankAccounts = SqlHelper.GetDataTable("stp_ClientBankAccounts", Data.CommandType.StoredProcedure, params)
            row = tblBankAccounts.NewRow
            row(0) = "Other"
            tblBankAccounts.Rows.Add(row)
            ddlTo.DataSource = tblBankAccounts
            ddlTo.DataTextField = "bankaccount"
            ddlTo.DataBind()
            If tblBankAccounts.Rows.Count = 1 Then
                trRouting.Visible = True
                trAccount.Visible = True
                trType.Visible = True
            End If
        Else
            btnSubmit.Enabled = False
        End If
    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        If ddlTo.SelectedItem.Text = "Other" Then
            If txtRouting.Text.Trim.Length = 9 AndAlso txtAccount.Text.Trim.Length > 5 Then
                Dim objStore As New WCFClient.Store
                Dim bankName As String
                If objStore.RoutingIsValid(txtRouting.Text, bankName) Then
                    CreateTransfer(bankName, txtRouting.Text, txtAccount.Text, ddlType.SelectedItem.Text)
                Else
                    lblErrMsg.Text = "The Routing Number you entered does not validate against the Federal ACH Directory."
                End If
            Else
                lblErrMsg.Text = "A valid Routing and Account number is required."
            End If
        Else
            Dim bank() As String = Split(ddlTo.SelectedItem.Text, "::")
            CreateTransfer(bank(0), bank(1), bank(2), bank(3))
        End If
    End Sub

    Private Sub CreateTransfer(ByVal bankName As String, ByVal routing As String, ByVal account As String, ByVal type As String)
        Dim UserID As Integer = DataHelper.Nz_int(Page.User.Identity.Name)
        Dim ClientID As Integer = CInt(Request.QueryString("id"))
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Name", lnkClient.InnerText)
        DatabaseHelper.AddParameter(cmd, "RoutingNumber", routing)
        DatabaseHelper.AddParameter(cmd, "AccountNumber", account)
        DatabaseHelper.AddParameter(cmd, "Type", type)
        DatabaseHelper.AddParameter(cmd, "Amount", lblAmount.Text.Replace("$", "").Replace(",", ""))
        DatabaseHelper.AddParameter(cmd, "IsPersonal", 1)
        DatabaseHelper.AddParameter(cmd, "CompanyID", hdnCompanyID.Value)
        DatabaseHelper.AddParameter(cmd, "ShadowStoreId", hdnAccountNumber.Value)
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        DatabaseHelper.AddParameter(cmd, "RegisterID", Request.QueryString("rid"))
        DatabaseHelper.AddParameter(cmd, "Flow", "debit")
        DatabaseHelper.AddParameter(cmd, "TrustId", 23)
        DatabaseHelper.BuildInsertCommandText(cmd, "tblNachaRegister2")

        cmd.Connection.Open()
        cmd.ExecuteNonQuery()
        DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        Drg.Util.DataHelpers.NoteHelper.InsertNote("Ad-hoc ACH transfer created from " & lblFrom.Text & " to " & bankName & " ***" & Right(account, 4) & " for " & lblAmount.Text & " " & lblTransactionType.Text & ", Transaction ID " & lblTransactionID.Text, UserID, ClientID)
        Response.Redirect("~/clients/client/?id=" & ClientID)
    End Sub

    Protected Sub ddlTo_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTo.SelectedIndexChanged
        If ddlTo.SelectedItem.Text = "Other" Then
            trRouting.Visible = True
            trAccount.Visible = True
            trType.Visible = True
        Else
            trRouting.Visible = False
            trAccount.Visible = False
            trType.Visible = False
        End If
    End Sub
End Class
