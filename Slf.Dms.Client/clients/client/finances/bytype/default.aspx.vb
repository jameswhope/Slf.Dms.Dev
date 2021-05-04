Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Imports LocalHelper

Partial Class clients_client_finances_bytype_default
    Inherits System.Web.UI.Page

#Region "Variables"
    Public ReadOnly Property DataClientID() As Integer
        Get
            Return Master.DataClientID
        End Get
    End Property
    Public Shadows ReadOnly Property ClientID() As Integer
        Get
            Return DataClientID
        End Get
    End Property
    Private UserID As Integer
    Private qs As QueryStringCollection

#End Region

#Region "Structures"
    Public Structure PaymentsTransaction
        Public RegisterPaymentID As Integer
        Public PaymentDate As Date
        Public FeeRegisterID As Integer
        Public FeeRegisterEntryTypeID As Integer
        Public FeeRegisterEntryTypeName As String
        Public FeeRegisterTransactionDate As Date
        Public FeeRegisterCheckNumber As String
        Public FeeRegisterAmount As Double
        Public FeeRegisterIsFullyPaid As Boolean
        Public Amount As Double
        Public Voided As Boolean
        Public Bounced As Boolean
        Public RegisterPaymentDepositID As Integer
        Public DepositRegisterID As Integer
        Public DepositRegisterEntryTypeID As Integer
        Public DepositRegisterEntryTypeName As String
        Public DepositRegisterTransactionDate As Date
        Public DepositRegisterCheckNumber As String
        Public DepositRegisterAmount As Double
        Public DepositRegisterIsFullyPaid As Boolean
        Public RegisterPaymentDepositAmount As Double
        Public RegisterPaymentDepositVoided As Boolean
        Public RegisterPaymentDepositBounced As Boolean

        Public Sub New(ByVal _RegisterPaymentID As Integer, ByVal _PaymentDate As Date, ByVal _FeeRegisterID As Integer, _
        ByVal _FeeRegisterEntryTypeID As Integer, ByVal _FeeRegisterEntryTypeName As String, ByVal _FeeRegisterTransactionDate As Date, _
        ByVal _FeeRegisterCheckNumber As String, ByVal _FeeRegisterAmount As Double, ByVal _FeeRegisterIsFullyPaid As Boolean, ByVal _Amount As Double, _
        ByVal _Voided As Boolean, ByVal _Bounced As Boolean, ByVal _RegisterPaymentDepositID As Integer, ByVal _DepositRegisterID As Integer, _
        ByVal _DepositRegisterEntryTypeID As Integer, ByVal _DepositRegisterEntryTypeName As String, ByVal _DepositRegisterTransactionDate As Date, _
        ByVal _DepositRegisterCheckNumber As String, ByVal _DepositRegisterAmount As Double, ByVal _DepositRegisterIsFullyPaid As Boolean, _
        ByVal _RegisterPaymentDepositAmount As Double, ByVal _RegisterPaymentDepositVoided As Boolean, ByVal _RegisterPaymentDepositBounced As Boolean)
            Me.Amount = _Amount
            Me.Bounced = _Bounced
            Me.DepositRegisterAmount = _DepositRegisterAmount
            Me.DepositRegisterCheckNumber = _DepositRegisterCheckNumber
            Me.DepositRegisterEntryTypeID = _DepositRegisterEntryTypeID
            Me.DepositRegisterEntryTypeName = _DepositRegisterEntryTypeName
            Me.DepositRegisterID = _DepositRegisterID
            Me.DepositRegisterIsFullyPaid = _DepositRegisterIsFullyPaid
            Me.DepositRegisterTransactionDate = _DepositRegisterTransactionDate
            Me.FeeRegisterAmount = _FeeRegisterAmount
            Me.FeeRegisterCheckNumber = _FeeRegisterCheckNumber
            Me.FeeRegisterEntryTypeID = _FeeRegisterEntryTypeID
            Me.FeeRegisterEntryTypeName = _FeeRegisterEntryTypeName
            Me.FeeRegisterID = _FeeRegisterID
            Me.FeeRegisterIsFullyPaid = _FeeRegisterIsFullyPaid
            Me.FeeRegisterTransactionDate = _FeeRegisterTransactionDate
            Me.PaymentDate = _PaymentDate
            Me.RegisterPaymentDepositAmount = _RegisterPaymentDepositAmount
            Me.RegisterPaymentDepositBounced = _RegisterPaymentDepositBounced
            Me.RegisterPaymentDepositID = _RegisterPaymentDepositID
            Me.RegisterPaymentDepositVoided = _RegisterPaymentDepositVoided
            Me.RegisterPaymentID = _RegisterPaymentID
            Me.Voided = _Voided
        End Sub
    End Structure
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            LoadTabStrips()

            If Not IsPostBack Then

                Requery()

                lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
                lnkClient.HRef = "~/clients/client/?id=" & ClientID

            End If

            SetRollups()

        End If

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks
        If Master.UserEdit Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href="""" onclick=""Record_AddTransaction();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_transaction.png") & """ align=""absmiddle""/>Add transaction</a>")
        End If
    End Sub
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        tsMain.TabPages(0).Selected = True

    End Sub
    Private Sub LoadTabStrips()

        tsMain.TabPages.Clear()
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption0"">Payments</span>", dvPanel0.ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption1"">Deposits</span>", dvPanel0.ClientID, "deposits.aspx?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption2"">Credits</span>", dvPanel0.ClientID, "credits.aspx?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption3"">Fees&nbsp;Assessed</span>", dvPanel0.ClientID, "feesassessed.aspx?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption4"">Fee&nbsp;Adjustments</span>", dvPanel0.ClientID, "feeadjustments.aspx?id=" & ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("<span id=""tabCaption5"">Debits</span>", dvPanel0.ClientID, "debits.aspx?id=" & ClientID))

    End Sub
    Private Sub Requery()

        Dim Payments As New Dictionary(Of Integer, RegisterPayment)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTransactionByType_Payments")
            DatabaseHelper.AddParameter(cmd, "clientid", DataClientID)

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

        rpPayments.DataSource = Payments.Values
        rpPayments.DataBind()


        Dim totalAmount As Decimal
        Dim totalFee As Decimal
        Dim totalPortion As Decimal

        For Each d In Payments.Values
            totalAmount += d.Amount
            totalFee += d.FeeRegisterAmount
            totalPortion += d.Amount
        Next

        'dt.[Select]().Sum(Function(p) Convert.ToInt32(p("Marks")))
        TryCast(rpPayments.Controls(rpPayments.Controls.Count - 1).Controls(0).FindControl("lblPaidTotal"), Label).Text = Decimal.Round(totalAmount, 2).ToString("C")
        TryCast(rpPayments.Controls(rpPayments.Controls.Count - 1).Controls(0).FindControl("lblFeeTotal"), Label).Text = Decimal.Round(totalFee, 2).ToString("C")
        TryCast(rpPayments.Controls(rpPayments.Controls.Count - 1).Controls(0).FindControl("lblPortionTotal"), Label).Text = Decimal.Round(totalPortion, 2).ToString("C")

        rpPayments.Visible = Payments.Count > 0
        pnlNone.Visible = Not rpPayments.Visible

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
End Class