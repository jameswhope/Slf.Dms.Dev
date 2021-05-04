Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_finances_bytype_agencyregister
    Inherits PermissionPage

#Region "Variables"

    Private Action As String
    Public RegisterID As Integer
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)
            RegisterID = DataHelper.Nz_int(qs("rid"), 0)

            If Not IsPostBack Then
                LoadRecord()
            End If

            lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)

        End If

    End Sub

    Private Sub LoadRecord()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblRegister WHERE RegisterID = @RegisterID"

        DatabaseHelper.AddParameter(cmd, "RegisterID", RegisterID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim EntryTypeID As Integer = DatabaseHelper.Peel_int(rd, "EntryTypeID")
                Dim Amount As Double = DatabaseHelper.Peel_double(rd, "Amount")

                Dim EntryTypeType As String = DataHelper.FieldLookup("tblEntryType", "Type", "EntryTypeID = " & EntryTypeID)
                Dim EntryTypeName As String = DataHelper.FieldLookup("tblEntryType", "Name", "EntryTypeID = " & EntryTypeID)
                Dim EntryTypeFee As Boolean = DataHelper.Nz_bool(DataHelper.FieldLookup("tblEntryType", "Fee", "EntryTypeID = " & EntryTypeID))

                lblRegisterID.Text = DatabaseHelper.Peel_int(rd, "RegisterID")

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

                lblDescription.Text = DatabaseHelper.Peel_string(rd, "Description")
                txtDescription.Text = DatabaseHelper.Peel_string(rd, "Description")

                If lblDescription.Text.Length = 0 Then
                    lblDescription.Text = "No description available"
                    lblDescription.Style("color") = "#a1a1a1"
                    lblDescription.Style("text-align") = "center"
                    lblDescription.Style("width") = "100%"
                    lblDescription.Style("padding") = "15 10 10 0"
                End If

                'return void, bounce, hold and clear info
                Dim Void As Nullable(Of DateTime) = DatabaseHelper.Peel_ndate(rd, "Void")
                Dim VoidBy As Nullable(Of Integer) = DatabaseHelper.Peel_nint(rd, "VoidBy")
                Dim Bounce As Nullable(Of DateTime) = DatabaseHelper.Peel_ndate(rd, "Bounce")
                Dim BounceBy As Nullable(Of Integer) = DatabaseHelper.Peel_nint(rd, "BounceBy")
                Dim Hold As Nullable(Of DateTime) = DatabaseHelper.Peel_ndate(rd, "Hold")
                Dim HoldBy As Nullable(Of Integer) = DatabaseHelper.Peel_nint(rd, "HoldBy")
                Dim Clear As Nullable(Of DateTime) = DatabaseHelper.Peel_ndate(rd, "Clear")
                Dim ClearBy As Nullable(Of Integer) = DatabaseHelper.Peel_nint(rd, "ClearBy")

                Dim VoidByName As String = String.Empty
                Dim BounceByName As String = String.Empty
                Dim HoldByName As String = String.Empty
                Dim ClearByName As String = String.Empty

                If VoidBy.HasValue Then
                    VoidByName = UserHelper.GetName(VoidBy.Value)
                End If

                If BounceBy.HasValue Then
                    BounceByName = UserHelper.GetName(BounceBy.Value)
                End If

                If HoldBy.HasValue Then
                    HoldByName = UserHelper.GetName(HoldBy.Value)
                End If

                If ClearBy.HasValue Then
                    ClearByName = UserHelper.GetName(ClearBy.Value)
                End If

                If Amount < 0 Then 'debit

                    lblPaymentsHeader.Text = "Payments Made On This Fee"

                    pnlPaymentsUsedFor.Visible = True
                    pnlPaymentsMadeWith.Visible = False

                    LoadPaymentsUsedFor()

                    If Void.HasValue Then

                        lblInfoBox.Text = "This transaction has the following flags:<div style=""padding:10 0 10 20;"">"

                        lblInfoBox.Text += "<li style=""padding-left:18;margin:1 0 1 1;list-style-position:" _
                            & "outside;list-style:none;background-repeat:no-repeat;background-image:url(" _
                            & ResolveUrl("~/images/12x12_flag_orange.png") & ");"">This transaction was " _
                            & "VOIDED on " & Void.Value.ToString("MMM d, yy") & " by " & VoidByName & "."

                        lblInfoBox.Text += "</li></div>"

                        trInfoBox.Visible = True

                    Else
                        trInfoBox.Visible = False
                    End If

                Else 'credit

                    lblPaymentsHeader.Text = "Payments Made With This Credit"

                    pnlPaymentsUsedFor.Visible = False
                    pnlPaymentsMadeWith.Visible = True

                    LoadPaymentsMadeWith()

                    'setup info material for the top
                    Dim Messages As New List(Of String)

                    If Void.HasValue Then

                        Messages.Add("This transaction was VOIDED on " & Void.Value.ToString("MMM d, yy") _
                            & " by " & VoidByName & ".")

                    End If

                    If Bounce.HasValue Then

                        Messages.Add("This transaction BOUNCED on " & Bounce.Value.ToString("MMM d, yy") _
                            & ", and was entered by " & BounceByName & ".")

                    End If

                    If Hold.HasValue Then
                        If Clear.HasValue Then 'held and cleared

                            Messages.Add("A HOLD was issued on this transaction for " _
                                & Hold.Value.ToString("MMM d, yy") & " by " & HoldByName & ", and a CLEAR " _
                                & "was issued for " & Clear.Value.ToString("MMM d, yy") & " by " & ClearByName & ".")

                        Else 'only held

                            If Hold.Value < DateTime.Now Then 'defacto clear

                                Messages.Add("A HOLD was issued on this transaction for " _
                                    & Hold.Value.ToString("MMM d, yy") & " by " & HoldByName & ", but that date " _
                                    & "has passed so this deposit is available.")

                            Else 'still on hold

                                Messages.Add("A HOLD was issued on this transaction for " _
                                    & Hold.Value.ToString("MMM d, yy") & " by " & HoldByName & ", and that date " _
                                    & "has not yet passed.  As such these funds are still on hold.&nbsp;&nbsp;" _
                                    & "<a class=""lnk"" href=""#"" onclick=""Record_ClearConfirm();return false;""" _
                                    & ">Click here</a>&nbsp;to issue a CLEAR.")

                            End If

                        End If
                    Else
                        If Clear.HasValue Then 'only cleared

                            Messages.Add("A CLEAR was issued on this transaction for " _
                                & Clear.Value.ToString("MMM d, yy") & " by " & ClearByName & ", but no original " _
                                & "HOLD was ever issued.")

                        Else 'never held or cleared

                        End If
                    End If

                    'determine if funds are available
                    Dim CreditRemaining As Double = Double.Parse(lblCreditRemaining.Text.Replace("$", "").Replace(",", ""))

                    If Bounce.HasValue Then
                        Messages.Add("These funds are not available.")
                    Else
                        If Void.HasValue Then
                            Messages.Add("These funds are not available.")
                        Else
                            If Hold.HasValue Then
                                If Hold.Value <= DateTime.Now Then 'held, but passed date
                                    If CreditRemaining > 0 Then
                                        Messages.Add("These funds are available and have not been completely used.")
                                    Else
                                        Messages.Add("These funds are available but have been completely used.")
                                    End If
                                Else
                                    If Clear.HasValue Then
                                        If Clear.Value <= DateTime.Now Then 'held, but cleared
                                            If CreditRemaining > 0 Then
                                                Messages.Add("These funds are available and have not been completely used.")
                                            Else
                                                Messages.Add("These funds are available but have been completely used.")
                                            End If
                                        Else 'held, with cleardate in future
                                            Messages.Add("These funds are not available.")
                                        End If
                                    Else 'held, not passed date and no clear
                                        Messages.Add("These funds are not available.")
                                    End If
                                End If
                            Else
                                If CreditRemaining > 0 Then
                                    Messages.Add("These funds are available and have not been completely used.")
                                Else
                                    Messages.Add("These funds are available but have been completely used.")
                                End If
                            End If
                        End If
                    End If

                    'print out info
                    If Messages.Count > 0 Then

                        lblInfoBox.Text = "This transaction has the following flags:<div style=""padding:10 0 10 20;"">"

                        For Each Message As String In Messages
                            lblInfoBox.Text += "<li style=""padding-left:18;margin:1 0 1 1;list-style-position:outside;list-style:none;background-repeat:no-repeat;background-image:url(" & ResolveUrl("~/images/12x12_flag_orange.png") & ");"">" & Message
                        Next

                        lblInfoBox.Text += "</li></div>"

                        trInfoBox.Visible = True

                    Else
                        trInfoBox.Visible = False
                    End If

                End If 'credit

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadPaymentsMadeWith()

        Dim Payments As New Dictionary(Of Integer, RegisterPayment)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPaymentsMadeWithRegister")

            DatabaseHelper.AddParameter(cmd, "RegisterID", RegisterID)

            Using cn As IDbConnection = cmd.Connection

                cn.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()

                        Dim Deposit As New RegisterPaymentDeposit( _
                            DatabaseHelper.Peel_int(rd, "RegisterPaymentDepositID"), _
                            DatabaseHelper.Peel_int(rd, "RegisterPaymentID"), _
                            DatabaseHelper.Peel_int(rd, "DepositRegisterID"), _
                            DatabaseHelper.Peel_int(rd, "DepositRegisterEntryTypeID"), _
                            DatabaseHelper.Peel_string(rd, "DepositRegisterEntryTypeName"), _
                            DatabaseHelper.Peel_date(rd, "DepositRegisterTransactionDate"), _
                            DatabaseHelper.Peel_string(rd, "DepositRegisterCheckNumber"), _
                            DatabaseHelper.Peel_double(rd, "DepositRegisterAmount"), _
                            DatabaseHelper.Peel_bool(rd, "DepositRegisterIsFullyPaid"), _
                            DatabaseHelper.Peel_double(rd, "RegisterPaymentDepositAmount"), _
                            DatabaseHelper.Peel_bool(rd, "RegisterPaymentDepositVoided"), _
                            DatabaseHelper.Peel_bool(rd, "RegisterPaymentDepositBounced"))

                        Dim Payment As RegisterPayment = Nothing

                        Dim RegisterPaymentID As String = DatabaseHelper.Peel_int(rd, "RegisterPaymentID")

                        If Not Payments.TryGetValue(RegisterPaymentID, Payment) Then

                            Payment = New RegisterPayment(DatabaseHelper.Peel_int(rd, "RegisterPaymentID"), _
                                DatabaseHelper.Peel_date(rd, "PaymentDate"), _
                                DatabaseHelper.Peel_int(rd, "FeeRegisterID"), _
                                DatabaseHelper.Peel_int(rd, "FeeRegisterEntryTypeID"), _
                                DatabaseHelper.Peel_string(rd, "FeeRegisterEntryTypeName"), _
                                DatabaseHelper.Peel_date(rd, "FeeRegisterTransactionDate"), _
                                DatabaseHelper.Peel_string(rd, "FeeRegisterCheckNumber"), _
                                DatabaseHelper.Peel_double(rd, "FeeRegisterAmount"), _
                                DatabaseHelper.Peel_bool(rd, "FeeRegisterIsFullyPaid"), _
                                DatabaseHelper.Peel_float(rd, "Amount"), _
                                DatabaseHelper.Peel_bool(rd, "Voided"), _
                                DatabaseHelper.Peel_bool(rd, "Bounced"))

                            Payments.Add(Payment.RegisterPaymentID, Payment)

                        End If

                        Payment.Deposits.Add(Deposit)

                    End While
                End Using
            End Using
        End Using

        rpPaymentsMadeWith.DataSource = Payments.Values
        rpPaymentsMadeWith.DataBind()

        LoadCreditRemaining()

    End Sub
    Private Sub LoadCreditRemaining()

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetRegisterAmountLeft")

        DatabaseHelper.AddParameter(cmd, "RegisterID", RegisterID)

        Using cmd
            Using cmd.Connection

                cmd.Connection.Open()

                lblCreditRemaining.Text = DataHelper.Nz_double(cmd.ExecuteScalar()).ToString("c")

            End Using
        End Using

    End Sub
    Private Sub LoadPaymentsUsedFor()

        Dim Payments As New Dictionary(Of Integer, RegisterPayment)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPaymentsUsedForRegister")

            DatabaseHelper.AddParameter(cmd, "RegisterID", RegisterID)

            Using cn As IDbConnection = cmd.Connection

                cn.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()

                        Dim Deposit As New RegisterPaymentDeposit( _
                            DatabaseHelper.Peel_int(rd, "RegisterPaymentDepositID"), _
                            DatabaseHelper.Peel_int(rd, "RegisterPaymentID"), _
                            DatabaseHelper.Peel_int(rd, "DepositRegisterID"), _
                            DatabaseHelper.Peel_int(rd, "DepositRegisterEntryTypeID"), _
                            DatabaseHelper.Peel_string(rd, "DepositRegisterEntryTypeName"), _
                            DatabaseHelper.Peel_date(rd, "DepositRegisterTransactionDate"), _
                            DatabaseHelper.Peel_string(rd, "DepositRegisterCheckNumber"), _
                            DatabaseHelper.Peel_double(rd, "DepositRegisterAmount"), _
                            DatabaseHelper.Peel_bool(rd, "DepositRegisterIsFullyPaid"), _
                            DatabaseHelper.Peel_double(rd, "RegisterPaymentDepositAmount"), _
                            DatabaseHelper.Peel_bool(rd, "RegisterPaymentDepositVoided"), _
                            DatabaseHelper.Peel_bool(rd, "RegisterPaymentDepositBounced"))

                        Dim Payment As RegisterPayment = Nothing

                        Dim RegisterPaymentID As String = DatabaseHelper.Peel_int(rd, "RegisterPaymentID")

                        If Not Payments.TryGetValue(RegisterPaymentID, Payment) Then

                            Payment = New RegisterPayment(DatabaseHelper.Peel_int(rd, "RegisterPaymentID"), _
                                DatabaseHelper.Peel_date(rd, "PaymentDate"), _
                                DatabaseHelper.Peel_int(rd, "FeeRegisterID"), _
                                DatabaseHelper.Peel_int(rd, "FeeRegisterEntryTypeID"), _
                                DatabaseHelper.Peel_string(rd, "FeeRegisterEntryTypeName"), _
                                DatabaseHelper.Peel_date(rd, "FeeRegisterTransactionDate"), _
                                DatabaseHelper.Peel_string(rd, "FeeRegisterCheckNumber"), _
                                DatabaseHelper.Peel_double(rd, "FeeRegisterAmount"), _
                                DatabaseHelper.Peel_bool(rd, "FeeRegisterIsFullyPaid"), _
                                DatabaseHelper.Peel_float(rd, "Amount"), _
                                DatabaseHelper.Peel_bool(rd, "Voided"), _
                                DatabaseHelper.Peel_bool(rd, "Bounced"))

                            Payments.Add(Payment.RegisterPaymentID, Payment)

                        End If

                        Payment.Deposits.Add(Deposit)

                    End While
                End Using
            End Using
        End Using

        rpPaymentsUsedFor.DataSource = Payments.Values
        rpPaymentsUsedFor.DataBind()

        LoadDebitRemaining()

    End Sub
    Private Sub LoadDebitRemaining()

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetRegisterAmountUsed")

        DatabaseHelper.AddParameter(cmd, "RegisterID", RegisterID)

        Using cmd
            Using cmd.Connection

                cmd.Connection.Open()

                lblDebitRemaining.Text = DataHelper.Nz_double(cmd.ExecuteScalar()).ToString("$#,##0.00")

            End Using
        End Using

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
    Protected Sub lnkBack_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkBack.ServerClick
        Response.Redirect(AgencyNavigator.Menus("Service Fees - Agency").LastUrlIn)
    End Sub
    ReadOnly Property AgencyNavigator() As Navigator
        Get

            If Session("AgencyNavigator") Is Nothing Then
                Session("AgencyNavigator") = New Navigator
            End If

            Return Session("AgencyNavigator")

        End Get
    End Property

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlMenu, c, "Research-Reports-Financial-Service Fees-Agency")
        AddControl(pnlBody, c, "Research-Reports-Financial-Service Fees-Agency")
    End Sub
End Class