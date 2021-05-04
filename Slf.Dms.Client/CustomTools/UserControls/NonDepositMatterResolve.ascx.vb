Imports Drg.Util.DataAccess
Imports System.Data

Partial Class CustomTools_UserControls_NonDepositMatterResolve
    Inherits System.Web.UI.UserControl

    Private _UserId As Integer
    Public Event OptionChanged(ByVal OptionId As Integer)
 
    Protected Sub rdCan_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdCan.CheckedChanged
        ShowResolve(2)
    End Sub

    Protected Sub rdCannot_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdCannot.CheckedChanged
        ShowResolve(1)
    End Sub

    Protected Sub rdPostpone_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdPostpone.CheckedChanged
        ShowResolve(3)
    End Sub

    Protected Sub rdCancelRequest_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdCancelRequest.CheckedChanged
        ShowResolve(4)
    End Sub

    Protected Sub rdError_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rdError.CheckedChanged
        ShowResolve(5)
    End Sub

    Protected Sub ddlDepositMethod_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlDepositMethod.SelectedIndexChanged
        ShowBanking()
    End Sub

    Private Sub ShowResolve(ByVal ResolveType As Integer)
        Select Case ResolveType
            Case 1, 4, 5
                Me.tbPostponeDialer.Visible = False
                Me.tbWillMakeDeposit.Visible = False
                RaiseEvent OptionChanged(1)
            Case 2
                Me.tbPostponeDialer.Visible = False
                Me.tbWillMakeDeposit.Visible = True
                ShowBanking()
            Case 3
                Me.tbPostponeDialer.Visible = True
                Me.tbWillMakeDeposit.Visible = False
                RaiseEvent OptionChanged(ResolveType)
        End Select

    End Sub

    Private Sub ShowBanking()
        tbBanking.Visible = (ddlDepositMethod.SelectedItem.Text <> "Check")
        If ddlDepositMethod.SelectedItem.Text <> "Check" Then
            RaiseEvent OptionChanged(4)
        Else
            RaiseEvent OptionChanged(2)
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _UserId = DataHelper.Nz_int(Page.User.Identity.Name)

        Me.txtBankRoutingNumber.Attributes.Add("onkeydown", "return digitOnly(this, event);")
        Me.txtBankAccountNumber.Attributes.Add("onkeydown", "return digitOnly(this, event);")
        Me.lnkSave.Attributes.Add("onmouseover", "this.style.backgroundColor='#cccccc'; this.style.border='1px outset #c0c0c0';")
        Me.lnkSave.Attributes.Add("onmouseout", "this.style.backgroundColor=''; this.style.border='';")
        Me.lnkCancel.Attributes.Add("onmouseover", "this.style.backgroundColor='#cccccc'; this.style.border='1px outset #c0c0c0';")
        Me.lnkCancel.Attributes.Add("onmouseout", "this.style.backgroundColor=''; this.style.border='';")

        Me.dvError.Visible = False

        If Not Me.IsPostBack Then
            Me.trCloseError.Visible = PermissionHelperLite.HasPermission(_UserId, "Non Deposit-Close created in error")
            hdnMatterId.Value = GetMatterId()
            hdnClientId.Value = NonDepositHelper.GetClientId(hdnMatterId.Value)
            Me.txtDepositAmount.Text = NonDepositHelper.GetExpectedAmount(hdnMatterId.Value)
            Me.rdCannot.Checked = True

            LoadMulti()
            ShowResolve(1)
        End If


    End Sub

    Private Function GetMatterId() As Integer
        Try
            Return Me.Request.QueryString("mid")
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        ResolveMatter(False)
    End Sub

    Private Sub ResolveMatter(ByVal SkipWarning As Boolean)
        Try
            hdnNonDepositId.Value = NonDepositHelper.GetNonDepositId(hdnMatterId.Value)
            Dim note As String = ParseNote()
            If rdCannot.Checked Then
                'Close Matter
                'Note: Client is unable to make deposit this time.
                note = "Client is unable make deposit this time. " & note
                NonDepositHelper.RemoveCurrentReplacement(hdnNonDepositId.Value, _UserId)
                NonDepositHelper.CloseMatter(hdnMatterId.Value, "ND_UN", "Client Unable Deposit", note, _UserId)
            ElseIf rdCancelRequest.Checked Then
                'Close Matter
                note = "Client requests to Cancel. " & note
                'Get All Open Non Deposits Matters for this client and resolve them.
                Dim dt As DataTable = NonDepositHelper.GetOpenNonDepositsByClientId(hdnClientId.Value)
                For Each dr As DataRow In dt.Rows
                    NonDepositHelper.RemoveCurrentReplacement(dr("nondepositid"), _UserId)
                    NonDepositHelper.CloseMatter(dr("matterid"), "ND_CQ", "Cancellation Requested", String.Format("Matter# {0}: {1}", dr("matterid"), note), _UserId)
                Next
                'Add logic here to handle cancellation request
                'SendCancellationRequest()
            ElseIf rdError.Checked Then
                'Close Matter
                note = "Non deposit created in error. " & note
                NonDepositHelper.CloseMatter(hdnMatterId.Value, "ND_ER", "Closed for Error", note, _UserId)
                NonDepositHelper.DeleteMatter(hdnMatterId.Value, _UserId)
            ElseIf rdCan.Checked Then
                'Note: Client promises to make up deposit.
                If IsValidDepositDate() AndAlso IsValidDepositAmount() Then
                    If Me.ddlDepositMethod.SelectedValue.Trim.ToLower = "check" Then
                        'create replacement deposit
                        NonDepositHelper.InsertNonDepositReplacement(hdnNonDepositId.Value, CDate(txtDepositDate.Text), txtDepositAmount.Text, Nothing, _UserId)
                        'set matter substatus to Wait for replacement
                        NonDepositHelper.UpdateMatterStatus(hdnMatterId.Value, "ND_RD", "Pending Client Deposit", note, _UserId)
                    Else
                        If IsValidBankingInformation() Then
                            'Create Adhoc ACH
                            InsertAdHocReplacement(SkipWarning)
                            'set matter substatus to Wait for replacement
                            NonDepositHelper.UpdateMatterStatus(hdnMatterId.Value, "ND_RD", "Pending Client Deposit", note, _UserId)
                        End If
                    End If
                End If
            Else
                'Postpone
                'Note: Client will need time to make a decision. Reschedule dialer calls.
                Dim d As DateTime
                If IsValidPostponeDateTime(d) Then
                    'Reschedule Dialer for Matter
                    DialerHelper.UpdateMatterDialerResumeTime(hdnMatterId.Value, d, txtNote.Text.Trim, _UserId, hdnClientId.Value)
                End If
            End If
            'Close Window Successfully
            ScriptManager.RegisterStartupScript(Me, GetType(Page), "closeResolve", "CloseNonDepResolve(1);", True)
        Catch ex As Exception
            'Show Error. Leave window open
            'ScriptManager.RegisterClientScriptBlock(Me, GetType(CustomTools_UserControls_NonDepositMatterResolve), "errnondepomatter", String.Format("alert('{0}');", ex.Message.Replace("'", "")), True)
            Me.lblError.Text = ex.Message
            Me.dvError.Visible = True
        End Try
    End Sub

    Private Sub InsertAdHocReplacement(ByVal SkipWarning As Boolean)
        Dim adhocachid As Integer = 0
        'Get non deposit id
        hdnNonDepositId.Value = NonDepositHelper.GetNonDepositId(hdnMatterId.Value)
        'verify non deposit id
        If hdnNonDepositId.Value.Trim.Length = 0 Then Throw New Exception("Could not get a non deposit id")
        'Verify additionals that are near the date
        If Not SkipWarning AndAlso MultiDepositHelper.GetOtherAdhocsInRange(hdnClientId.Value, -1, CDate(txtDepositDate.Text), 3) Then
            Throw New Exception(String.Format("WARNING: This client has other additionals set up near {0}. <br/>Click <a href='#' onclick='SaveNoWarning();'>here</a> if you want to create this additional anyway.", txtDepositDate.Text))
        End If
        'create additional ach
        adhocachid = InsertAdhocAch()
        'verify additional ach id
        If adhocachid = 0 Then Throw New Exception("Could not get a valid additional ach id")
        'create replacement
        Try
            NonDepositHelper.InsertNonDepositReplacement(hdnNonDepositId.Value, CDate(txtDepositDate.Text), txtDepositAmount.Text, adhocachid, _UserId)
        Catch ex As Exception
            If adhocachid > 0 Then
                'rollback adhoc
                NonDepositHelper.DeletePlannedAdHocACH(adhocachid)
            End If
            Throw
        End Try
    End Sub

    Private Function IsValidDepositDate() As Boolean
        'Deposit has to be 2 business days from today
        If txtDepositDate.Text.Length = 0 Then
            Throw New Exception("Enter the Deposit Date.")
        End If

        'is valid date
        Dim d As DateTime
        If Not DateTime.TryParse(txtDepositDate.Text, d) Then
            Throw New Exception("The Deposit Date you entered is not a valid date.")
        End If

        'is not on weekend
        If d.DayOfWeek = DayOfWeek.Saturday Or d.DayOfWeek = DayOfWeek.Sunday Then
            Throw New Exception("The Deposit Date you entered is on a weekend.")
        End If

        'is not on bank holiday
        Dim HolidayName As String = DataHelper.Nz_string(DataHelper.FieldLookup("tblBankHoliday", "Name", DataHelper.StripTime("Date") & "='" & d.ToString("MM/dd/yyyy") & "'"))
        If Not String.IsNullOrEmpty(HolidayName) Then
            Throw New Exception("The Deposit Date you entered is on a bank holiday (" & HolidayName & ").")
        End If

        'is two days from now
        If LocalHelper.AddBusinessDays(d, -2) < Date.Today Then
            Throw New Exception("The Deposit Date you entered is not a minimum of two business days from now.")
        End If

        Return True
    End Function

    Private Function IsValidDepositAmount() As Boolean
        'Has to be greater than zero
        If Val(Me.txtDepositAmount.Text) <= 0 Then
            Throw New Exception("The Deposit Amount must be greater than zero.")
        End If
        Return True
    End Function

    Private Function IsValidPostponeDateTime(ByRef dialerdate As DateTime) As Boolean
        'Date has to be at least 5 minutes from now
        If txtDialerAfter.Text.Trim.Length = 0 OrElse Not IsDate(txtDialerAfter.Text.Trim) Then Throw New Exception("Invalid Date")
        If txtDialerTimeAfter.Text.Trim.Length = 0 Then Throw New Exception("Invalid Time")
        Dim d As DateTime = Me.txtDialerAfter.Text & " " & Me.txtDialerTimeAfter.Text
        If Now.AddMinutes(5) > d Then Throw New Exception("The date and time to recontact the client for this issue must be at least 5 minutes from now.")
        dialerdate = d
        Return True
    End Function

    Private Function IsValidBankingInformation() As Boolean
        Dim RoutingNumber As String = ""

        'Routing Number has to be 9 digits
        If txtBankRoutingNumber.Text.Length < 9 Then
            Throw New Exception("The Routing Number must be 9 digits.")
        End If

        'Account Number Cannot be empty
        If txtBankAccountNumber.Text.Length = 0 Then
            Throw New Exception("Enter the Account Number.")
        End If

        'Accout Type Cannot be Empty
        If cboBankType.SelectedItem.Text.Trim.Length = 0 Then
            Throw New Exception("Select Bank Account Type.")
        End If

        'Routing Number has to be valid, ck both the Federal DB and our DB for the routing number
        Dim objClient As New WCFClient.Store
        If Not objClient.RoutingIsValid(txtBankRoutingNumber.Text, lblBankName.Text) Then
            RoutingNumber = Drg.Util.DataAccess.DataHelper.FieldLookup("tblRoutingNumber", "RoutingNumber", "RoutingNumber = '" & Trim(txtBankRoutingNumber.Text) & "'")
            If RoutingNumber = "" Then
                Throw New Exception("The Bank Routing Number you entered does not validate against the Federal ACH Directory.")
            End If
        End If

        Return True
    End Function

    Private Function ParseNote() As String
        Return txtNote.Text.Trim.Replace("'", "''")
    End Function

    Private Function InsertAdhocAch() As Integer
        Dim AdHocAchID As Integer = 0
        Dim bMulti As Boolean = MultiDepositHelper.IsMultiDepositClient(hdnClientId.Value)

        If Val(txtDepositAmount.Text.ToString) > 0 Then

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection

                    DatabaseHelper.AddParameter(cmd, "BankName", DataHelper.Zn(lblBankName.Text))
                    DatabaseHelper.AddParameter(cmd, "BankRoutingNumber", txtBankRoutingNumber.Text)
                    DatabaseHelper.AddParameter(cmd, "BankAccountNumber", txtBankAccountNumber.Text)
                    DatabaseHelper.AddParameter(cmd, "DepositAmount", DataHelper.Nz_double(txtDepositAmount.Text))
                    DatabaseHelper.AddParameter(cmd, "DepositDate", DateTime.Parse(txtDepositDate.Text))
                    DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                    DatabaseHelper.AddParameter(cmd, "LastModifiedBy", _UserId)
                    Dim bankID As Integer = 0
                    If bMulti Then
                        Select Case ddlBankName.SelectedItem.Value
                            Case "add"
                                bankID = MultiDepositHelper.InsertClientBank(hdnClientId.Value, txtBankRoutingNumber.Text, txtBankAccountNumber.Text, cboBankType.SelectedItem.Value, _UserId)
                            Case "select"
                                bankID = 0
                            Case Else
                                bankID = ddlBankName.SelectedItem.Value
                        End Select
                    End If
                    If Not bankID = 0 Then DatabaseHelper.AddParameter(cmd, "BankAccountId", bankID)

                    If cboBankType.SelectedValue = "0" Then
                        DatabaseHelper.AddParameter(cmd, "BankType", DBNull.Value, DbType.String)
                    Else
                        DatabaseHelper.AddParameter(cmd, "BankType", cboBankType.SelectedValue, DbType.String)
                    End If

                    DatabaseHelper.AddParameter(cmd, "ClientID", hdnClientId.Value)
                    DatabaseHelper.AddParameter(cmd, "Created", Now)
                    DatabaseHelper.AddParameter(cmd, "CreatedBy", _UserId)
                    DatabaseHelper.BuildInsertCommandText(cmd, "tblAdHocACH", "AdHocACHId", SqlDbType.Int)

                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()

                End Using

                AdHocAchID = DataHelper.Nz_int(cmd.Parameters("@AdHocACHId").Value)

            End Using
        End If

        Return AdHocAchID
    End Function

    Private Sub LoadMulti()
        Dim bMulti As Boolean = MultiDepositHelper.IsMultiDepositClient(hdnClientId.Value)

        Me.trSelectBank.Visible = bMulti
        If bMulti Then

            Me.trSelectBank.Visible = True
            ddlBankName.DataTextField = "BankName"
            ddlBankName.DataValueField = "BankAccountID"

            'Get disable account if current
            Dim banks As DataTable = MultiDepositHelper.getMultiDepositClientBanks(hdnClientId.Value)
            Dim criteria As String = "Disabled is null"
            Dim dvbanks As New DataView(banks)
            dvbanks.RowFilter = criteria
            ddlBankName.DataSource = dvbanks
            ddlBankName.DataBind()

            Dim addItm As New ListItem("(Add Bank)", "add")
            ddlBankName.Items.Add(addItm)

            ddlBankName.SelectedIndex = 0
            SelectBank(bMulti)
        End If
    End Sub

    Private Sub SelectBank(ByVal bMulti As Boolean)
        trAccountDisabled.Style("Display") = "None"
        Select Case ddlBankName.SelectedItem.Value
            Case "add"
                lblBankName.Text = ""
                txtBankAccountNumber.Text = String.Empty
                txtBankRoutingNumber.Text = String.Empty

                If bMulti Then
                    cboBankType.SelectedIndex = 1
                Else
                    cboBankType.SelectedIndex = 0
                End If

                lblBankName.Enabled = True
                txtBankRoutingNumber.Enabled = True
                txtBankAccountNumber.Enabled = True
                cboBankType.Enabled = True

            Case "select"
                txtBankAccountNumber.Text = ""
                txtBankRoutingNumber.Text = ""
                cboBankType.SelectedIndex = -1
                lblBankName.Text = ""

                lblBankName.Enabled = False
                txtBankAccountNumber.Enabled = False
                txtBankRoutingNumber.Enabled = False
                cboBankType.Enabled = False
            Case Else
                Dim sqlBank As String = String.Format("Select * from tblClientBankAccount where BankAccountID = {0}", ddlBankName.SelectedItem.Value)
                Dim dtBank As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlBank, ConfigurationManager.AppSettings("connectionstring").ToString)
                For Each bank As DataRow In dtBank.Rows
                    lblBankName.Text = ddlBankName.SelectedItem.Text
                    txtBankAccountNumber.Text = bank("AccountNumber")
                    txtBankRoutingNumber.Text = bank("RoutingNumber")
                    If Not bank("BankType") Is DBNull.Value Then
                        ListHelper.SetSelected(cboBankType, bank("BankType"))
                    Else
                        cboBankType.SelectedIndex = -1
                    End If

                    lblBankName.Enabled = False
                    txtBankRoutingNumber.Enabled = False
                    txtBankAccountNumber.Enabled = False
                    cboBankType.Enabled = False
                    Exit For
                Next
        End Select
    End Sub

    Protected Sub ddlBankName_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBankName.SelectedIndexChanged
        Dim bMulti As Boolean = MultiDepositHelper.IsMultiDepositClient(hdnClientId.Value)
        SelectBank(bMulti)
    End Sub

    Protected Sub btn24_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btn24.Click
        Me.txtDialerAfter.Text = Format(Now.AddDays(1), "MM/dd/yyyy")
        Me.txtDialerTimeAfter.Text = Format(Now.AddDays(1), "hh:mm tt")
    End Sub

    Protected Sub lnkSaveNoWarning_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveNoWarning.Click
        ResolveMatter(True)
    End Sub

    Private Sub SendCancellationRequest()
        Dim toAddress As String = ConfigurationManager.AppSettings("RequestCancelEmail")
        If Not toAddress Is Nothing AndAlso toAddress.Trim.Length > 0 Then
            Dim dt As DataTable = NonDepositHelper.GetClientData(hdnMatterId.Value)
            If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
                Dim body As New StringBuilder
                body.AppendFormat("Client with account number {0} has requested to cancel representation while resolving non-deposit matter #{1}.", dt.Rows(0)("accountnumber"), hdnMatterId.Value)
                If txtNote.Text.Trim.Length > 0 Then
                    body.AppendFormat("<br /><br />Note: {0}", txtNote.Text.Trim)
                End If
                Dim username As String = Drg.Util.DataHelpers.UserHelper.GetName(_UserId, True)
                body.AppendFormat("<br /><br />Generated by {0} on {1} at {2}.", username, Now.ToShortDateString, Now.ToShortTimeString)
                EmailHelper.SendMessage("nondeposit@lexxiom.com", toAddress, "Client Cancellation Request: " & dt.Rows(0)("accountnumber"), body.ToString)
            End If
        End If
    End Sub

    
End Class
