Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_finances_bytype_agencypayment
    Inherits PermissionPage

#Region "Variables"

    Private Action As String
    Private RegisterPaymentID As Integer
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

            If Not IsPostBack Then
                LoadRecord()
                LoadDeposits()
            End If

            SetupCommonTasks()

        End If

    End Sub

    Private Sub SetupCommonTasks()

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)

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

                    End While
                End Using
            End Using
        End Using

        rpDeposits.DataSource = Deposits
        rpDeposits.DataBind()

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
        AddControl(pnlBody, c, "Research-Reports-Financial-Service Fees-Agency")
        AddControl(pnlMenu, c, "Research-Reports-Financial-Service Fees-Agency")
    End Sub
End Class