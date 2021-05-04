Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports SharedFunctions

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_finances_bytype_payment
    Inherits EntityPage

#Region "Variables"

    Private Action As String
    Public RegisterPaymentID As Integer
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then
            ClientID = DataHelper.Nz_int(qs("id"), 0)
            RegisterPaymentID = DataHelper.Nz_int(qs("rpid"), 0)

            LoadTabStrips()

            If Not IsPostBack Then
                LoadDocuments()
                LoadRecord()
                LoadDeposits()
                LoadCommissions()
                LoadChargebacks()
            End If

            SetupCommonTasks()
        End If

    End Sub
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        tsCommission.TabPages(0).Selected = True

        'set the proper pane on, others off
        Dim SearchPanes As New List(Of HtmlGenericControl)

        SearchPanes.Add(dvCommissionPanel0)
        SearchPanes.Add(dvCommissionPanel1)

        For Each SearchPane As HtmlGenericControl In SearchPanes

            If SearchPane.ID.Substring(SearchPane.ID.Length - 1, 1) = tsCommission.SelectedIndex Then
                SearchPane.Style("display") = "inline"
            Else
                SearchPane.Style("display") = "none"
            End If

        Next

    End Sub

    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        SharedFunctions.DocumentAttachment.DeleteAttachment(hdnCurrentDoc.Value, UserID)
        LoadDocuments()
    End Sub

    Protected Sub lnkShowDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowDocs.Click
        LoadDocuments()
    End Sub

    Private Sub LoadDocuments()
        rpDocuments.DataSource = documentHelper.GetDocumentsForRelation(RegisterPaymentID, "registerpayment")
        rpDocuments.DataBind()

        If rpDocuments.DataSource.Count > 0 Then
            hypDeleteDoc.Disabled = False
        Else
            hypDeleteDoc.Disabled = True
        End If
    End Sub

    Private Sub LoadTabStrips()

        tsCommission.TabPages.Clear()
        tsCommission.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption0"">Commission</span>", dvCommissionPanel0.ClientID))
        tsCommission.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption1"">Chargebacks</span>", dvCommissionPanel1.ClientID))

    End Sub
    Private Sub SetupCommonTasks()
        Dim CommonTasks As List(Of String) = Master.CommonTasks

        If Master.UserEdit Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        Else
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
        End If

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkFinances.HRef = "~/clients/client/finances/register/?id=" & ClientID

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:OpenScanning();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_remove.png") & """ align=""absmiddle""/>Scan Document</a>")
    End Sub
    Private Sub LoadRecord()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblRegisterPayment WHERE RegisterPaymentID = @RegisterPaymentID"

            DatabaseHelper.AddParameter(cmd, "RegisterPaymentID", RegisterPaymentID)

            Using cn As IDbConnection = cmd.Connection

                cn.Open()

                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)

                    If rd.Read() Then

                        lblPaymentDate.Text = DatabaseHelper.Peel_date(rd, "PaymentDate").ToString("MMM d, yyyy hh:mm:ss tt")
                        lblPaymentAmount.Text = DatabaseHelper.Peel_double(rd, "Amount").ToString("c")

                        Dim FeeRegisterID As Integer = DatabaseHelper.Peel_int(rd, "FeeRegisterID")

                        LoadFee(FeeRegisterID)

                        'return voided or bounced bounce
                        Dim Voided As Boolean = DatabaseHelper.Peel_bool(rd, "Voided")
                        Dim Bounced As Boolean = DatabaseHelper.Peel_bool(rd, "Bounced")

                        'setup info material for the top
                        Dim Messages As New List(Of String)

                        If Voided Then

                            Messages.Add("This payment was VOIDED.  This most likely happened because an " _
                                & "associated fee or deposit was voided.")

                        End If

                        If Bounced Then

                            Messages.Add("This payment was BOUNCED.  This most likely happened because an " _
                                & "associated fee or deposit was bounced.")

                        End If

                        'print out info
                        If Messages.Count > 0 Then

                            lblInfoBox.Text = "This payment has the following flags:<div style=""padding:10 0 10 20;"">"

                            For Each Message As String In Messages
                                lblInfoBox.Text += "<li style=""padding-left:18;margin:1 0 1 1;list-style-position:outside;list-style:none;background-repeat:no-repeat;background-image:url(" & ResolveUrl("~/images/12x12_flag_orange.png") & ");"">" & Message
                            Next

                            lblInfoBox.Text += "</li></div>"

                            trInfoBox.Visible = True

                        Else
                            trInfoBox.Visible = False
                        End If

                    End If

                End Using
            End Using
        End Using

    End Sub
    Private Sub LoadFee(ByVal FeeRegisterID As Integer)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblRegister WHERE RegisterID = @RegisterID"

        DatabaseHelper.AddParameter(cmd, "RegisterID", FeeRegisterID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim EntryTypeID As Integer = DatabaseHelper.Peel_int(rd, "EntryTypeID")
                Dim Amount As Double = DatabaseHelper.Peel_double(rd, "Amount")

                Dim EntryTypeType As String = DataHelper.FieldLookup("tblEntryType", "Type", "EntryTypeID = " & EntryTypeID)
                Dim EntryTypeName As String = DataHelper.FieldLookup("tblEntryType", "Name", "EntryTypeID = " & EntryTypeID)
                Dim EntryTypeFee As Boolean = DataHelper.Nz_bool(DataHelper.FieldLookup("tblEntryType", "Fee", "EntryTypeID = " & EntryTypeID))

                lnkRegisterID.InnerHtml = DatabaseHelper.Peel_int(rd, "RegisterID")
                lnkRegisterID.HRef = ResolveUrl("register.aspx?id=" & ClientID & "&rid=" & DatabaseHelper.Peel_int(rd, "RegisterID"))

                If EntryTypeFee Then
                    lblEntryTypeName.Text = "(" & EntryTypeType & ") FEE - " & EntryTypeName
                Else
                    lblEntryTypeName.Text = "(" & EntryTypeType & ") " & EntryTypeName
                End If

                lblTransactionDate.Text = DatabaseHelper.Peel_datestring(rd, "TransactionDate", "MM/dd/yyyy hh:mm tt")
                lblAmount.Text = Math.Abs(Amount).ToString("$#,##0.00")

                If Amount < 0 Then
                    lblAmount.ForeColor = Color.Red
                Else
                    lblAmount.ForeColor = Color.FromArgb(0, 139, 0) 'green
                End If

                lblBalance.Text = DatabaseHelper.Peel_double(rd, "Balance").ToString("$#,##0.00")
                lblCheckNumber.Text = DatabaseHelper.Peel_string(rd, "CheckNumber")

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadDeposits()

        Dim Deposits As New List(Of RegisterPaymentDeposit)
        Dim TotalAmount As Double = 0

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPaymentDepositsForPayment")

            DatabaseHelper.AddParameter(cmd, "RegisterPaymentID", RegisterPaymentID)

            Using cn As IDbConnection = cmd.Connection

                cn.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        Deposits.Add(New RegisterPaymentDeposit( _
                            DatabaseHelper.Peel_int(rd, "RegisterPaymentDepositID"), _
                            DatabaseHelper.Peel_int(rd, "RegisterPaymentID"), _
                            DatabaseHelper.Peel_int(rd, "DepositRegisterID"), _
                            DatabaseHelper.Peel_int(rd, "DepositRegisterEntryTypeID"), _
                            DatabaseHelper.Peel_string(rd, "DepositRegisterEntryTypeName"), _
                            DatabaseHelper.Peel_date(rd, "DepositRegisterTransactionDate"), _
                            DatabaseHelper.Peel_string(rd, "DepositRegisterCheckNumber"), _
                            DatabaseHelper.Peel_double(rd, "DepositRegisterAmount"), _
                            DatabaseHelper.Peel_bool(rd, "DepositRegisterIsFullyPaid"), _
                            DatabaseHelper.Peel_double(rd, "Amount"), _
                            DatabaseHelper.Peel_bool(rd, "Voided"), _
                            DatabaseHelper.Peel_bool(rd, "Bounced")))

                        TotalAmount += DatabaseHelper.Peel_double(rd, "Amount")

                    End While
                End Using
            End Using
        End Using

        lblAmount.Text = TotalAmount.ToString("c")
        lblPaymentAmount.Text = TotalAmount.ToString("c")

        rpDeposits.DataSource = Deposits
        rpDeposits.DataBind()

    End Sub
    Private Sub LoadCommissions()

        Dim Commissions As New List(Of CommPay)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCommPaysForPayment")

            DatabaseHelper.AddParameter(cmd, "RegisterPaymentID", RegisterPaymentID)

            Using cn As IDbConnection = cmd.Connection

                cn.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        Commissions.Add(New CommPay( _
                            DatabaseHelper.Peel_int(rd, "CommPayID"), _
                            DatabaseHelper.Peel_int(rd, "RegisterPaymentID"), _
                            DatabaseHelper.Peel_int(rd, "CommStructID"), _
                            DatabaseHelper.Peel_double(rd, "Percent"), _
                            DatabaseHelper.Peel_double(rd, "Amount"), _
                            DatabaseHelper.Peel_nint(rd, "CommBatchID"), _
                            DatabaseHelper.Peel_int(rd, "CommScenID"), _
                            DatabaseHelper.Peel_int(rd, "CommRecID"), _
                            DatabaseHelper.Peel_int(rd, "ParentCommRecID"), _
                            DatabaseHelper.Peel_int(rd, "CommStructOrder"), _
                            DatabaseHelper.Peel_int(rd, "CommRecTypeID"), _
                            DatabaseHelper.Peel_string(rd, "Display"), _
                            DatabaseHelper.Peel_string(rd, "CommRecTypeName")))

                    End While
                End Using
            End Using
        End Using

        rpCommissions.DataSource = Commissions
        rpCommissions.DataBind()

        pnlCommissionsNone.Visible = Commissions.Count = 0

    End Sub
    Private Sub LoadChargebacks()

        Dim Chargebacks As New List(Of CommChargeback)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCommChargebacksForPayment")

            DatabaseHelper.AddParameter(cmd, "RegisterPaymentID", RegisterPaymentID)

            Using cn As IDbConnection = cmd.Connection

                cn.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        Chargebacks.Add(New CommChargeback( _
                            DatabaseHelper.Peel_int(rd, "CommChargebackID"), _
                            DatabaseHelper.Peel_nint(rd, "CommPayID"), _
                            DatabaseHelper.Peel_date(rd, "ChargebackDate"), _
                            DatabaseHelper.Peel_int(rd, "RegisterPaymentID"), _
                            DatabaseHelper.Peel_int(rd, "CommStructID"), _
                            DatabaseHelper.Peel_double(rd, "Percent"), _
                            DatabaseHelper.Peel_double(rd, "Amount"), _
                            DatabaseHelper.Peel_nint(rd, "CommBatchID"), _
                            DatabaseHelper.Peel_int(rd, "CommScenID"), _
                            DatabaseHelper.Peel_int(rd, "CommRecID"), _
                            DatabaseHelper.Peel_int(rd, "ParentCommRecID"), _
                            DatabaseHelper.Peel_int(rd, "CommStructOrder"), _
                            DatabaseHelper.Peel_int(rd, "CommRecTypeID"), _
                            DatabaseHelper.Peel_string(rd, "Display"), _
                            DatabaseHelper.Peel_string(rd, "CommRecTypeName")))

                    End While
                End Using
            End Using
        End Using

        rpChargebacks.DataSource = Chargebacks
        rpChargebacks.DataBind()

        pnlChargebacksNone.Visible = Chargebacks.Count = 0

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""clients_client_applicants_applicant_default""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Private Sub Close()
        Response.Redirect("~/clients/client/finances/register/?id=" & ClientID)
    End Sub
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub

    Public Overrides ReadOnly Property BaseQueryString() As String
        Get
            Return "rpid"
        End Get
    End Property

    Public Overrides ReadOnly Property BaseTable() As String
        Get
            Return "tblRegisterPayment"
        End Get
    End Property
End Class