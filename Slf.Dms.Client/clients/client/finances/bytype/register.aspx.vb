Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports SharedFunctions

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_finances_bytype_register
    Inherits EntityPage

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

    Private Action As String
    Public RegisterID As Integer
    Private qs As QueryStringCollection
    Private TabStripPage As Integer
    Private NotAC21 As Boolean = False


    Private UserID As Integer

#End Region

#Region "Structures"
    Public Structure DepositEntry
        Public RegisterPaymentID As Integer
        Public PaymentDate As Date
        Public FeeRegisterID As Integer
        Public FeeRegisterEntryTypeID As Integer
        Public FeeRegisterEntryTypeName As Boolean
        Public FeeRegisterTransactionDate As Date
        Public FeeRegisterCheckNumber As Object
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
        Public DepositRegisterCheckNumber As Integer
        Public DepositRegisterAmount As Double
        Public DepositRegisterIsFullyPaid As Boolean
        Public RegisterPaymentDepositAmount As Double
        Public RegisterPaymentDepositVoided As Boolean
        Public RegisterPaymentDepositBounced As Boolean
        Public RegisterPaymentDepositAccountID As Object

        Public Sub New(ByVal _RegisterPaymentID As Integer, ByVal _PaymentDate As Date, ByVal _FeeRegisterID As Integer, _
            ByVal _FeeRegisterEntryTypeID As Integer, ByVal _FeeRegisterEntryTypeName As Boolean, ByVal _FeeRegisterTransactionDate As Date, _
            ByVal _FeeRegisterCheckNumber As Object, ByVal _FeeRegisterAmount As Double, ByVal _FeeRegisterIsFullyPaid As Boolean, _
            ByVal _Amount As Double, ByVal _Voided As Boolean, ByVal _Bounced As Boolean, ByVal _RegisterPaymentDepositID As Integer, _
            ByVal _DepositRegisterID As Integer, ByVal _DepositRegisterEntryTypeID As Integer, ByVal _DepositRegisterEntryTypeName As String, _
            ByVal _DepositRegisterTransactionDate As Date, ByVal _DepositRegisterCheckNumber As Integer, ByVal _DepositRegisterAmount As Double, _
            ByVal _DepositRegisterIsFullyPaid As Boolean, ByVal _RegisterPaymentDepositAmount As Double, ByVal _RegisterPaymentDepositVoided As Boolean, _
            ByVal _RegisterPaymentDepositBounced As Boolean, ByVal _RegisterPaymentDepositAccountID As Object)

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
            Me.RegisterPaymentDepositAccountID = _RegisterPaymentDepositAccountID
            Me.RegisterPaymentDepositAmount = _RegisterPaymentDepositAmount
            Me.RegisterPaymentDepositBounced = _RegisterPaymentDepositBounced
            Me.RegisterPaymentDepositID = _RegisterPaymentDepositID
            Me.RegisterPaymentDepositVoided = _RegisterPaymentDepositVoided
            Me.RegisterPaymentID = _RegisterPaymentID
            Me.Voided = _Voided
        End Sub
    End Structure
#End Region

#Region "rpFeeAdjustments_Display"

    Public Function rpFeeAdjustments_Redirect(ByVal Row As RepeaterItem) As String

        Dim ID As Integer = StringHelper.ParseInt(Row.DataItem("RegisterID"))

        Return ResolveUrl("~/clients/client/finances/bytype/register.aspx?id=" & ClientID & "&rid=" & ID)

    End Function
    Public Function rpFeeAdjustments_ArrowDirection(ByVal Amount As Double)

        If Amount < 0 Then
            Return "<img src=""" & ResolveUrl("~/images/12x13_arrow_up.png") & """ align=""absmiddle"" title=""Up"" />"
        Else
            Return "<img src=""" & ResolveUrl("~/images/12x13_arrow_down.png") & """ align=""absmiddle"" title=""Down"" />"
        End If

    End Function
    Public Function rpFeeAdjustments_Amount(ByVal Amount As Double)

        If Amount > 0 Then
            Return "<font style=""color:red;"">" & (Amount * -1).ToString("$#,##0.00") & "</font>"
        Else
            Return (Amount * -1).ToString("$#,##0.00")
        End If

    End Function

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            RegisterID = DataHelper.Nz_int(qs("rid"), 0)
            'RegisterID = DataHelper.Nz_date(qs("rid"), 0)
            TabStripPage = DataHelper.Nz_int(qs("tsp"))

            If Not IsPostBack Then
                LoadTabStrips()
                LoadRecord()
                LoadDocuments()
            End If

            SetupCommonTasks()

        End If

    End Sub
    Private Sub LoadTabStrips()

        tsMain.TabPages.Clear()

        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("General&nbsp;Info", tr0.ClientID))
        tsMain.TabPages.Add(New Slf.Dms.Controls.TabPage("Description", tr1.ClientID))

        If TabStripPage > tsMain.TabPages.Count Then
            tsMain.TabPages(tsMain.TabPages.Count - 1).Selected = True
        Else
            tsMain.TabPages(TabStripPage).Selected = True
        End If

    End Sub
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        'set the proper pane on, others off
        Dim SearchPanes As New List(Of HtmlTableRow)

        SearchPanes.Add(tr0)
        SearchPanes.Add(tr1)

        For Each SearchPane As HtmlTableRow In SearchPanes

            If SearchPane.ID.Substring(SearchPane.ID.Length - 1, 1) = tsMain.SelectedIndex Then
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

    Private Sub LoadDocuments()
        'rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(RegisterID, "register", Request.Url.AbsoluteUri)
        rpDocuments.DataSource = documentHelper.GetDocumentsForRelation(RegisterID, "register", Request.Url.AbsoluteUri)
        rpDocuments.DataBind()

        If rpDocuments.DataSource.Count > 0 Then
            hypDeleteDoc.Disabled = False
        Else
            hypDeleteDoc.Disabled = True
        End If
    End Sub

    Private Sub SetupCommonTasks()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        'find and fill the flags for this register
        Dim Amount As Double
        Dim Void As Nullable(Of DateTime)
        Dim Bounce As Nullable(Of DateTime)
        Dim Hold As Nullable(Of DateTime)
        Dim Clear As Nullable(Of DateTime)
        Dim TrustID As Integer
        Dim CheckNo As String
        Dim ColonialDeposit As Boolean
        Dim EntryTypeID As Integer

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT top 1 r.*, c.TrustID, n.NachaRegisterID FROM tblRegister r JOIN tblClient c on c.ClientID = r.ClientID LEFT JOIN tblNachaCabinet n on lower(n.type) = 'registerid' and n.TypeID = r.RegisterID WHERE r.RegisterID = @RegisterID"

            DatabaseHelper.AddParameter(cmd, "RegisterID", RegisterID)

            Using cn As IDbConnection = cmd.Connection

                cn.Open()

                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)
                    If rd.Read() Then
                        Amount = DatabaseHelper.Peel_double(rd, "Amount")
                        TrustID = DatabaseHelper.Peel_int(rd, "TrustID")
                        Void = DatabaseHelper.Peel_ndate(rd, "Void")
                        Bounce = DatabaseHelper.Peel_ndate(rd, "Bounce")
                        Hold = DatabaseHelper.Peel_ndate(rd, "Hold")
                        Clear = DatabaseHelper.Peel_ndate(rd, "Clear")
                        CheckNo = DatabaseHelper.Peel_string(rd, "CheckNumber")
                        ColonialDeposit = (Not rd("NachaRegisterID") Is DBNull.Value)
                        NotAC21 = (Not rd("NotC21") Is DBNull.Value AndAlso rd("NotC21") <> 0)
                        EntryTypeID = DatabaseHelper.Peel_int(rd, "EntryTypeID")
                    End If
                End Using
            End Using
        End Using

        If Master.UserEdit Then
            'add regular register tasks
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")

            'add register tasks based on flags
            If Not Void.HasValue And Not Bounce.HasValue Then 'always list void if not voided already AND not bounced already
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_VoidConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_transaction_void2.png") & """ align=""absmiddle""/>Issue a void</a>")
            End If

            'only list bounce if not bounced already AND is credit AND not voided already AND is not a CheckSite client OR the deposit processed through Colonial
            If Not Bounce.HasValue And Amount > 0 And Not Void.HasValue And (TrustID <> 22 Or Drg.Util.DataHelpers.SettlementProcessingHelper.IsManager(UserID) Or ColonialDeposit) Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_BounceConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_transaction_void2.png") & """ align=""absmiddle""/>Issue a bounce</a>")
            End If

            If Not Hold.HasValue And Amount > 0 And Not Clear.HasValue And Not Bounce.HasValue And Not Void.HasValue Then 'only list hold if not held already AND is credit AND not cleared AND not bounced or voided
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_HoldConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_transaction_void2.png") & """ align=""absmiddle""/>Issue a hold</a>")
            End If

            If Not Clear.HasValue And Amount > 0 And Hold.HasValue AndAlso Hold.Value > DateTime.Now And Not Bounce.HasValue And Not Void.HasValue Then 'only list clear if not clear already AND is credit AND has existing hold AND existing hold has not passed
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_ClearConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_transaction_void2.png") & """ align=""absmiddle""/>Issue a clear</a>")
            End If

            If RegisterHelper.CanDelete(RegisterID) Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this transaction</a>")
            End If

            If TrustID = 22 Then
                If lblName.Text = "Deposit" And CheckNo.Trim.Length > 0 Then
                    Dim C21TransactionId As String = GetC21TransactionId()
                    Dim c21Task As String = String.Empty
                    Dim cmdText As String = "View C21 Image"
                    Dim cmdRef As String = String.Format("ViewC21('{0}')", RegisterID)
                    If Not NotAC21 Then
                        If C21TransactionId.Trim.Length = 0 Then
                            cmdText = "Assign C21 Image"
                            cmdRef = String.Format("AssignC21()", RegisterID)
                        End If
                        c21Task = "<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""" & cmdRef & ";return false;""><img id=""C21"" style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_transaction_void2.png") & """ align=""absmiddle""/>" & cmdText & "</a>"
                        CommonTasks.Add(c21Task)
                    End If
                    Dim bIsSysAdmin As Boolean = DataHelper.FieldLookup("tbluser", "usergroupid", "userid = " & UserID) = 11
                    If bIsSysAdmin Then
                        cmdRef = String.Format("MarkC21('{0}')", RegisterID)
                        c21Task = "<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""" & cmdRef & ";return false;""><img id=""C21"" style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_transaction_void2.png") & """ align=""absmiddle""/>" & IIf(NotAC21, "Mark as C21", "Mark as Not a C21") & "</a>"
                        CommonTasks.Add(c21Task)
                    End If
                End If

                Select Case EntryTypeID
                    Case 48, 28, 21 'Refund, Client withdrawal, Closing withdrawal
                        If Not Void.HasValue And Drg.Util.DataHelpers.SettlementProcessingHelper.IsManager(UserID) And DataHelper.RecordExists("tblNachaRegister2", String.Format("registerid={0} and trustid=23 and state=1 and status=0 and flow='debit'", Request.QueryString("rid"))) And Not DataHelper.RecordExists("tblNachaRegister2", String.Format("registerid={0} and trustid=23 and ispersonal=1 and flow='debit'", Request.QueryString("rid"))) Then
                            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href='../sda/disbursement-transfer.aspx?id=" & Request.QueryString("id") & "&rid=" & Request.QueryString("rid") & "'><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_results_last.png") & """ align=""absmiddle""/>Transfer Funds</a>")
                        End If
                End Select
            End If
        Else

            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
        End If

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:OpenScanning();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_remove.png") & """ align=""absmiddle""/>Scan Document</a>")

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(DataClientID)
        lnkClient.HRef = "~/clients/client/?id=" & DataClientID
        lnkFinanceRegister.HRef = "~/clients/client/finances/register/?id=" & DataClientID

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

                Dim AdjustedRegisterID As Integer = DatabaseHelper.Peel_int(rd, "AdjustedRegisterID")

                If Not AdjustedRegisterID = 0 Then
                    Response.Redirect("register.aspx?id=" & ClientID & "&rid=" & AdjustedRegisterID)
                Else

                    Dim EntryTypeID As Integer = DatabaseHelper.Peel_int(rd, "EntryTypeID")
                    Dim OriginalAmount As Double = DatabaseHelper.Peel_double(rd, "OriginalAmount")
                    Dim Amount As Double = DatabaseHelper.Peel_double(rd, "Amount")
                    Dim CheckNumber As String = DatabaseHelper.Peel_string(rd, "CheckNumber")
                    Dim AccountID As Integer = DatabaseHelper.Peel_int(rd, "AccountID")
                    Dim MediatorID As Integer = DatabaseHelper.Peel_int(rd, "MediatorID")
                    Dim ACHMonth As Integer = DatabaseHelper.Peel_int(rd, "ACHMonth")
                    Dim ACHYear As Integer = DatabaseHelper.Peel_int(rd, "ACHYear")
                    Dim FeeMonth As Integer = DatabaseHelper.Peel_int(rd, "FeeMonth")
                    Dim FeeYear As Integer = DatabaseHelper.Peel_int(rd, "FeeYear")

                    Dim EntryTypeType As String = DataHelper.FieldLookup("tblEntryType", "Type", "EntryTypeID = " & EntryTypeID)
                    Dim EntryTypeName As String = DataHelper.FieldLookup("tblEntryType", "Name", "EntryTypeID = " & EntryTypeID)
                    Dim EntryTypeFee As Boolean = DataHelper.Nz_bool(DataHelper.FieldLookup("tblEntryType", "Fee", "EntryTypeID = " & EntryTypeID))

                    lblName.Text = EntryTypeName
                    lblRegisterID.Text = DatabaseHelper.Peel_int(rd, "RegisterID")

                    If EntryTypeFee Then
                        lblEntryTypeName.Text = "(" & EntryTypeType & ") FEE - " & EntryTypeName
                    Else
                        lblEntryTypeName.Text = "(" & EntryTypeType & ") " & EntryTypeName
                        lblCheckNumber.Text = DatabaseHelper.Peel_string(rd, "CheckNumber")
                        If lblCheckNumber.Text.Length > 0 Then
                            trCheckNumber.Visible = True
                        End If
                    End If

                    lblAmount.Text = IIf(OriginalAmount <> 0, Math.Abs(OriginalAmount).ToString("c"), Math.Abs(Amount).ToString("c"))
                    lblAmount2.Text = Math.Abs(Amount).ToString("c")
                    lblTransactionDate.Text = DatabaseHelper.Peel_datestring(rd, "TransactionDate", "M/d/yyyy")
                    lblTransactionDate2.Text = DatabaseHelper.Peel_datestring(rd, "TransactionDate", "MM/dd/yyyy hh:mm:ss tt")
                    lblSDABalance.Text = DatabaseHelper.Peel_double(rd, "SDABalance").ToString("$#,##0.00")
                    lblPFOBalance.Text = DatabaseHelper.Peel_double(rd, "PFOBalance").ToString("$#,##0.00")

                    If Not AccountID = 0 Then
                        GetAccount(AccountID)
                        trAccount.Visible = True
                    End If

                    If Not MediatorID = 0 Then
                        lblMediator.Text = GetMediator(MediatorID)
                        trMediator.Visible = True
                    End If

                    If Not ACHMonth = 0 AndAlso Not ACHYear = 0 Then
                        lblACHMonthYear.Text = New DateTime(ACHYear, ACHMonth, 1).ToString("MMMM yyyy")
                        trACHMonthYear.Visible = True
                    End If

                    If Not FeeMonth = 0 AndAlso Not FeeYear = 0 Then
                        lblFeeMonthYear.Text = New DateTime(FeeYear, FeeMonth, 1).ToString("MMMM yyyy")
                        trFeeMonthYear.Visible = True
                    End If

                    lblDescription.Text = DatabaseHelper.Peel_string(rd, "Description")
                    txtDescription.Text = DatabaseHelper.Peel_string(rd, "Description")

                    If lblDescription.Text.Length = 0 Then
                        lblDescription.Text = "No description available"
                        lblDescription.Style("color") = "#a1a1a1"
                        lblDescription.Style("text-align") = "center"
                        lblDescription.Style("width") = "100%"
                        lblDescription.Style("padding") = "15 10 10 0"
                    End If

                    If EntryTypeFee Then 'fee

                        lblPostedWord.Text = "Assessed"

                        LoadFeeAdjustments(rpFeeAdjustments, RegisterID)

                        If rpFeeAdjustments.Items.Count > 0 Then
                            tdFeeAdjustments.Visible = True
                        End If

                    ElseIf EntryTypeID = 3 Then 'deposit
                        lblPostedWord.Text = "Deposited"
                    ElseIf EntryTypeType = "Debit" Then
                        lblPostedWord.Text = "Debited"
                    ElseIf EntryTypeType = "Credit" Then
                        lblPostedWord.Text = "Credited"
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
                End If 'adjustedregisterid
            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Function GetMediator(ByVal MediatorID As Integer) As String
        Return UserHelper.GetName(MediatorID)
    End Function
    Private Sub GetAccount(ByVal AccountID As Integer)

        aAccount.InnerHtml = AccountHelper.GetSummary(AccountID)

        aAccount.HRef = ResolveUrl("~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & AccountID)

    End Sub
    Private Sub LoadFeeAdjustments(ByVal rp As Repeater, ByVal RegisterID As Integer)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Dim cmdText As New StringBuilder
            cmdText.Append("SELECT r.*,tar.DisplayName[AdjustedReason] FROM tblRegister as r LEFT OUTER JOIN tblTranAdjustedReason AS tar ")
            cmdText.Append("ON r.AdjustedReasonID = tar.TranAdjustedReasonID ")
            cmdText.AppendFormat("WHERE r.AdjustedRegisterID = {0} ", RegisterID)

            cmdText.Append("ORDER BY TransactionDate, RegisterID")

            cmd.CommandText = cmdText.ToString

            Using cn As IDbConnection = cmd.Connection

                cn.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    rp.DataSource = rd
                    rp.DataBind()

                End Using
            End Using
        End Using

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

        Dim TotalAmount As Double = 0
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

                            TotalAmount += DatabaseHelper.Peel_float(rd, "Amount")

                        End If

                        Payment.Deposits.Add(Deposit)

                    End While
                End Using
            End Using
        End Using

        lblAmount.Text = TotalAmount.ToString("c")

        rpPaymentsUsedFor.DataSource = Payments.Values
        rpPaymentsUsedFor.DataBind()

        LoadDebitRemaining()

    End Sub

    Private Function GetC21TransactionId() As String
        Dim transactionId As String = String.Empty

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetCheck21TransactionByDepositId")
        DatabaseHelper.AddParameter(cmd, "DepositId", RegisterID)

        Using cmd
            Using cn As IDbConnection = cmd.Connection
                cn.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        transactionId = DatabaseHelper.Peel_string(rd, "Transaction Id")
                        Exit While
                    End While
                End Using
            End Using
        End Using

        Return transactionId
    End Function

    Private Sub LoadDebitRemaining()

        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetRegisterAmountUsed")

        DatabaseHelper.AddParameter(cmd, "RegisterID", RegisterID)

        Using cmd
            Using cmd.Connection

                cmd.Connection.Open()

                lblDebitRemaining.Text = DataHelper.Nz_double(cmd.ExecuteScalar()).ToString("c")

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

    Private Sub Close()
        Response.Redirect("~/clients/client/finances/register/?id=" & DataClientID)
    End Sub

    Private Sub Close_Old()

        'get last page referrer by cycling backwards
        Dim Navigator As Navigator = CType(Page.Master, clients_client).MasterNavigator

        Dim i As Integer = Navigator.Pages.Count - 1

        While i >= 0 AndAlso Not Navigator.Pages(i).Url.IndexOf("bytype/register.aspx") = -1 'not found

            'decrement i
            i -= 1

        End While

        If i >= 0 Then
            Response.Redirect(Navigator.Pages(i).Url)
        Else
            Response.Redirect("~/clients/client/finances/register/?id=" & DataClientID)
        End If

    End Sub

    Private Sub Reload()
        Response.Redirect("~/clients/client/finances/bytype/register.aspx?id=" & DataClientID & "&rid=" & RegisterID)
    End Sub
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Protected Sub lnkBounce_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkBounce.Click

        'bounce this register
        RegisterHelper.Bounce(RegisterID, UserID, chkBounceCollectFee.Checked, DateTime.Parse(txtBounce.Text), True, DataHelper.Nz_int(hdnBReason.Value, 0))

        'Send Bounced Letter
        NonDepositHelper.SendBouncedDepositLetter(RegisterID, UserID)

        'drop back to opener
        Close()

    End Sub
    Protected Sub lnkVoid_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkVoid.Click

        'void this register
        RegisterHelper.Void(RegisterID, UserID, DateTime.Parse(txtVoid.Text), True, DataHelper.Nz(hdnReason.Value, ""))

        'drop back to opener
        Close()

    End Sub
    Protected Sub lnkHold_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkHold.Click

        'hold this register
        RegisterHelper.Hold(RegisterID, UserID, DateTime.Parse(txtHold.Text), True)

        'drop back to opener
        Close()

    End Sub
    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click

        'clear this register
        RegisterHelper.Clear(RegisterID, UserID, DateTime.Parse(txtClear.Text), True)

        'drop back to opener
        Close()

    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        'save the new description
        DataHelper.FieldUpdate("tblRegister", "Description", DataHelper.Zn(txtDescription.Text), "RegisterID = " & RegisterID)

        'reload page
        Response.Redirect("~/clients/client/finances/bytype/register.aspx?id=" & DataClientID & "&rid=" & RegisterID & "&tsp=1")

    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        SharedFunctions.DocumentAttachment.DeleteAllForItem(RegisterID, "register", UserID)

        RegisterHelper.Delete(RegisterID, True)

        Response.Redirect("~/clients/client/finances/register/?id=" & DataClientID)

    End Sub
    Protected Sub lnkShowDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowDocs.Click
        LoadDocuments()
    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub

    Public Overrides ReadOnly Property BaseQueryString() As String
        Get
            Return "rid"
        End Get
    End Property

    Public Overrides ReadOnly Property BaseTable() As String
        Get
            Return "tblRegister"
        End Get
    End Property

    Protected Sub lnkUnassign_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUnassign.Click
        UnassignDeposit(RegisterID)
        'reload page
        Response.Redirect("~/clients/client/finances/bytype/register.aspx?id=" & DataClientID & "&rid=" & RegisterID)

    End Sub

    Protected Sub lnkAssignC21_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAssignC21.Click
        Dim transId As String = Me.C21TransactionPicker1.SelectedTransactionId
        If transId = "" Then
            ScriptManager.RegisterStartupScript(Me.Page, GetType(Page), "notransid", "alert('No transaction selected.');", True)
        Else
            AssingTransaction(transId, RegisterID)
            'reload page
            Response.Redirect("~/clients/client/finances/bytype/register.aspx?id=" & DataClientID & "&rid=" & RegisterID)
        End If
    End Sub

    Private Sub AssingTransaction(ByVal TransactionId As String, ByVal DepositId As Integer)
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandText = String.Format("Update tblC21BatchTransaction Set DepositId = {0}, LastMapped = GetDate(), LastMappedBy = {2} WHERE TransactionId = '{1}'", DepositId, TransactionId, UserID)
            Using cn As IDbConnection = cmd.Connection
                cn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Private Sub UnassignDeposit(ByVal DepositId As Integer)
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandText = String.Format("Update tblC21BatchTransaction Set DepositId = Null, LastMapped = GetDate(), LastMappedBy = {1} WHERE DepositId = {0}", DepositId, UserID)
            Using cn As IDbConnection = cmd.Connection
                cn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Protected Sub lnkMarkC21_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkMarkC21.Click
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandText = String.Format("Update tblRegister Set NotC21 = {1} WHERE RegisterId = {0}", RegisterID, IIf(NotAC21, "0", "1"))
            Using cn As IDbConnection = cmd.Connection
                cn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Response.Redirect("~/clients/client/finances/bytype/register.aspx?id=" & DataClientID & "&rid=" & RegisterID)
    End Sub
End Class