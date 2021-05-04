Option Explicit On
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers

Imports LexxiomLetterTemplates

Imports Slf.Dms.Records

Imports CreditorHarassmentFormControl

Partial Class clients_client_accounts_account
    Inherits EntityPage

#Region "Variables"

    Private Action As String
    Public AccountID As Integer
    Public Shadows ClientID As Integer
	Public bVerifiedAccount As Boolean = False
    Private qs As QueryStringCollection
    Public UserID As Integer
    Public SetupFeePercentage As Double
    Public rptTemplates As LexxiomLetterTemplates.LetterTemplates
    Private Manager As Boolean = False
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        rptTemplates = New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("ReportConnString"))
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)
            AccountID = DataHelper.Nz_int(qs("aid"), 0)
            Action = DataHelper.Nz_string(qs("a"))

            Manager = DataHelper.FieldLookup("tblUser", "Manager", "UserID = " & UserID)

            Me.Harassment1.DataClientID = ClientID
            Me.Harassment1.CreditorAccountID = AccountID
            Me.Harassment1.CreatedBy = UserID

            HandleAction()

            If Not IsPostBack Then
                LoadDocuments()

            End If

        End If

        tsTabStrip.TabPages.Clear()

        tsTabStrip.TabPages.Add(New Slf.Dms.Controls.TabPage("Creditor&nbsp;Instances", dvTab0.ClientID))
        tsTabStrip.TabPages.Add(New Slf.Dms.Controls.TabPage("Negotiations", dvTab1.ClientID))
        tsTabStrip.TabPages.Add(New Slf.Dms.Controls.TabPage("Status&nbsp;History", dvTab2.ClientID))

    End Sub
    Private Sub HandleAction()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        If Master.UserEdit Then

            'add applicant tasks
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Return to all accounts</a>")

            Select Case Action
                Case "a"    'add

                    'lblPerson.Text = "Add New Account"

                    tblVerification.Style("display") = "none"

                Case Else   'edit

                    If DataHelper.FieldLookup("tblAccount", "Removed", "AccountID = " & AccountID).Length = 0 _
                        AndAlso DataHelper.FieldLookup("tblAccount", "Settled", "AccountID = " & AccountID).Length = 0 Then
                        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_ChangeStatusConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_help.png") & """ align=""absmiddle""/>Change status</a>")
                        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_RemoveConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_remove.png") & """ align=""absmiddle""/>Remove this account</a>")
                        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SettleConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_change.png") & """ align=""absmiddle""/>Settle this account</a>")
                    ElseIf SettlementProcessingHelper.IsManager(UserID) Then
                        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_ChangeStatusConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_help.png") & """ align=""absmiddle""/>Change status</a>")
                    End If

                    'add delete task (only if client account has NOT finished verification)
                    If DataHelper.FieldLookup("tblClient", "VWUWResolved", "ClientID = " & ClientID).Length = 0 Then
                        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this account</a>")
                    End If

                    LoadRecord()
                    LoadCreditorInstances()

                    'lblPerson.Text = PersonHelper.GetName(PersonID)

            End Select

            'add normal tasks
        Else
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
        End If

        If Not AccountID = 0 Then
            Dim credName As String
            Dim cmdStr As String = "SELECT cr1.[Name] " _
                + "FROM  tblAccount a INNER JOIN " _
                + "tblCreditorInstance c1 on a.CurrentCreditorInstanceID = c1.CreditorInstanceID LEFT JOIN " _
                + "tblCreditorInstance c2 on a.CurrentCreditorInstanceID = c2.CreditorInstanceID INNER JOIN " _
                + "tblCreditor cr1 on c1.CreditorID = cr1.CreditorID INNER JOIN " _
                + "tblCreditor cr2 on c2.CreditorID = cr2.CreditorID " _
                + "WHERE a.AccountID = " + AccountID.ToString() + " ORDER BY cr1.[Name] ASC"

            Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()

                    credName = cmd.ExecuteScalar().ToString().Replace("*", "").Replace(".", "").Replace("""", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "")
                End Using
            End Using
        End If

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkPersons.HRef = "~/clients/client/creditors/?id=" & ClientID

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:OpenScanning();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_remove.png") & """ align=""absmiddle""/>Scan Document</a>")
    End Sub
    
    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        SharedFunctions.DocumentAttachment.DeleteAttachment(hdnCurrentDoc.Value, UserID)
        LoadDocuments()
        Me.updDocs.Update()
    End Sub

    Private Sub LoadDocuments()
        rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(AccountID, "account", Request.Url.AbsoluteUri)
        rpDocuments.DataBind()

        If rpDocuments.DataSource.Count > 0 Then
            hypDeleteDoc.Disabled = False
        Else
            hypDeleteDoc.Disabled = True
        End If
    End Sub

    Private Sub LoadRecord()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblAccount WHERE AccountID = @AccountId"

        DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                lblName.Text = AccountHelper.GetCreditorName(AccountID)
                lnkAccount.InnerHtml = lblName.Text

                lblOriginalDueDate.Text = DatabaseHelper.Peel_datestring(rd, "OriginalDueDate", "MMM d, yyyy")
                lblCurrentAmount.Text = DatabaseHelper.Peel_double(rd, "CurrentAmount").ToString("c")

                If Not DatabaseHelper.Peel_double(rd, "SettlementFeeCredit") = 0.0 Then
                    lblSettlementFeeCredit.Text = DatabaseHelper.Peel_double(rd, "SettlementFeeCredit").ToString("c")
                    trSettlementFeeCredit.Visible = True
                End If

                Dim AccountStatus As String = DataHelper.FieldLookup("tblAccountStatus", "Description", "AccountStatusID = " & DatabaseHelper.Peel_int(rd, "AccountStatusID"))

                lblAccountNumber.Text = DataHelper.FieldLookup("tblCreditorInstance", "AccountNumber", "CreditorInstanceID = " & DatabaseHelper.Peel_int(rd, "OriginalCreditorInstanceID"))

                lblOriginalRetainerFeePercentage.Text = DatabaseHelper.Peel_double(rd, "SetupFeePercentage").ToString("#,##0.##%")
                lblVerifiedRetainerFeePercentage2.Text = DatabaseHelper.Peel_double(rd, "SetupFeePercentage").ToString("#,##0.##%")

                If DatabaseHelper.Peel_ndate(rd, "Verified").HasValue Then 'is verified
                    bVerifiedAccount = True
                    lblCurrentStatus.Text = "Verified, " & AccountStatus

                    lblUnverifiedAmount.Text = DatabaseHelper.Peel_double(rd, "UnverifiedAmount").ToString("#,##0.00")
                    lblUnverifiedRetainerFee.Text = DatabaseHelper.Peel_double(rd, "UnverifiedRetainerFee").ToString("#,##0.00")
                    lblVerifiedAmount.Text = DatabaseHelper.Peel_double(rd, "VerifiedAmount").ToString("#,##0.00")
                    lblVerifiedRetainerFee.Text = DatabaseHelper.Peel_double(rd, "VerifiedRetainerFee").ToString("#,##0.00")
                    lblVerified.Text = DatabaseHelper.Peel_datestring(rd, "Verified", "MMM d, yyyy")
                    lblVerifiedBy.Text = UserHelper.GetName(DatabaseHelper.Peel_int(rd, "VerifiedBy"))

                    txtVerifiedAmount.Visible = False
                    lblVerifiedAmount.Visible = True

                    pnlVerificationAction.Visible = False
                    pnlVerificationDisplay.Visible = True

                    'If Manager Then
                    ckUnverify.Visible = True
                    lblSpacer.Visible = True
                    'Else
                    'ckUnverify.Visible = False
                    'lblSpacer.Visible = False
                    'End If

                Else

                    lblCurrentStatus.Text = "Unverified, " & AccountStatus

                    lblUnverifiedAmount.Text = DatabaseHelper.Peel_double(rd, "CurrentAmount").ToString("#,##0.00")
                    lblUnverifiedRetainerFee.Text = Math.Abs(DataHelper.FieldSum("tblRegister", "Amount", "EntryTypeID = 2 AND AccountID = " & AccountID)).ToString("#,##0.00")

                    txtVerifiedAmount.Visible = True
                    lblVerifiedAmount.Visible = False

                    pnlVerificationAction.Visible = True
                    pnlVerificationDisplay.Visible = False

                    SetupFeePercentage = DatabaseHelper.Peel_double(rd, "SetupFeePercentage")
                    txtVerifiedAmount.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
                    txtVerifiedAmount.Attributes("onkeyup") = "txtVerifiedAmount_OnKeyUp(this);"

                End If

                If Not lblCurrentStatus.Text.IndexOf("Account Removed") = -1 Then
                    lblCurrentStatus.Style("color") = "red"
                ElseIf Not lblCurrentStatus.Text.IndexOf("Settled Account") = -1 Then
                    lblCurrentStatus.Style("color") = "rgb(0,139,0)"
                End If

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try


    End Sub
    Private Sub LoadCreditorInstances()

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_getCreditorInstancesForAccount")
            Using cmd.Connection
                cmd.Connection.Open()
                DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)
                Using rd As IDataReader = cmd.ExecuteReader()
                    rpCreditorInstances.datasource = rd
                    rpCreditorInstances.databind()
                End Using
            End Using
        End Using
    End Sub
    Public Function Snippet(ByVal s As Object) As String
        If IsDBNull(s) OrElse s Is Nothing Then
            Return ""
        ElseIf CType(s, String).Length <= 4 Then
            Return CType(s, String)
        Else
            Return "***" & CType(s, String).Substring(CType(s, String).Length - 4)
        End If
    End Function
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
        Response.Redirect("~/clients/client/creditors/accounts/?id=" & ClientID)
    End Sub
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
   Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

      'commented out by Jim Hope on 04/10/2008 until we can set the permissions properly for this function
      ''delete account
      '  AccountHelper.Delete(AccountID)

      '  'do the fee modifications, if suppose to
      '  If chkRemoveModifyFees.Checked Then

      '      If chkRemoveAdditional.Checked Then
      '          RemoveAddAccountFees()
      '      End If

      '      If chkRemoveSettlement.Checked Then
      '          RemoveSettlementFees()
      '      End If

      '      If chkRemoveRetainer.Checked Then
      '          If chkRemoveRetainerAll.Checked Then
      '              RemoveAllRetainerFees()
      '          Else
      '              RemovePartialRetainerFees()
      '          End If
      '      End If

      '  End If

      'drop back to accounts
      Close()

   End Sub

    Public Overrides ReadOnly Property BaseQueryString() As String
        Get
            Return "aid"
        End Get
    End Property

    Public Overrides ReadOnly Property BaseTable() As String
        Get
            Return "tblAccount"
        End Get
    End Property

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub
    Protected Sub lnkVerify_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkVerify.Click

        Dim PreviousAmount As Double = AccountHelper.GetCurrentAmount(AccountID)
        Dim PreviousFee As Double = AccountHelper.GetSumRetainerFees(AccountID)
        Dim rtrHelper As New RtrFeeAdjustmentHelper

        'save verified amount
        DataHelper.FieldUpdate("tblCreditorInstance", "Amount", StringHelper.ParseDouble(txtVerifiedAmount.Text), _
            "CreditorInstanceID = " & AccountHelper.GetCurrentCreditorInstanceID(AccountID))

        Dim verified As String = DataHelper.FieldLookup("tblAccount", "Verified", "AccountID = " & AccountID).ToString
        If verified = "" Then
            'update original/current amounts on master account
            AccountHelper.SetWarehouseValues(AccountID)

            'adjust retainer fee if suppose to
            If chkVerifiedFee.Checked Then
                Dim ChangeIt As Boolean = rtrHelper.ShouldRtrFeeChange(ClientID, UserID)
                If ChangeIt Then
                    'AccountHelper.AdjustRetainerFee(AccountID, ClientID, UserID, False, SetupFeePercentage * 100, 0)
                    ClientHelper.CleanupRegister(ClientID)
                End If
            End If

            'lock verification
            AccountHelper.LockVerification(AccountID, PreviousAmount, PreviousFee, DateTime.Now, UserID, _
                StringHelper.ParseDouble(txtVerifiedAmount.Text), _
                AccountHelper.GetSumRetainerOrAdditionalAccountFees(AccountID))

            Reload()
        End If
    End Sub
    Private Sub Reload()
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub
    Protected Sub lnkRemove_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRemove.Click
        'set the status as "Account Removed" from the beginning, if found
        Dim AccountStatusID As Integer = StringHelper.ParseInt(DataHelper.FieldLookup("tblAccountStatus", "AccountStatusID", "Code = 'AR' AND Description = 'Account Removed'"))

        'set the current status to removed and set the removed fields
        Dim updates As New List(Of DataHelper.FieldValue)

        If Not AccountStatusID = 0 Then
            updates.Add(New DataHelper.FieldValue("AccountStatusID", AccountStatusID))
        End If

        updates.Add(New DataHelper.FieldValue("Removed", DateTime.Now))
        updates.Add(New DataHelper.FieldValue("RemovedBy", UserID))

        DataHelper.AuditedUpdate(updates, "tblAccount", AccountID, UserID)

        'do the fee modifications, if suppose to
        If chkRemoveModifyFees.Checked Then

            If chkRemoveAdditional.Checked Then
                RemoveAddAccountFees()
            End If

            If chkRemoveSettlement.Checked Then
                RemoveSettlementFees()
            End If

            If chkRemoveRetainer.Checked Then
                If chkRemoveRetainerAll.Checked Then
                    RemoveAllRetainerFees()
                Else
                    RemovePartialRetainerFees()
                End If
            End If

        End If

        Close()

    End Sub
    Private Sub RemoveAddAccountFees()

        Dim RegisterIDs() As Integer = DataHelper.FieldLookupIDs("tblRegister", "RegisterID", "EntryTypeID = 19 AND AccountID = " & AccountID)

        RemoveRegisterIDs(RegisterIDs)

    End Sub
    Private Sub RemoveSettlementFees()

        Dim RegisterIDs() As Integer = DataHelper.FieldLookupIDs("tblRegister", "RegisterID", "EntryTypeID = 4 AND AccountID = " & AccountID)

        RemoveRegisterIDs(RegisterIDs)

    End Sub
    Private Sub RemoveAllRetainerFees()

        Dim RegisterIDs() As Integer = DataHelper.FieldLookupIDs("tblRegister", "RegisterID", "EntryTypeID = 2 AND AccountID = " & AccountID)

        RemoveRegisterIDs(RegisterIDs)

    End Sub
    Private Sub RemovePartialRetainerFees()

        Dim CurrentFee As Double = AccountHelper.GetSumRetainerFees(AccountID)
        Dim AmountToDeduct As Double = StringHelper.ParseDouble(txtRemoveAmount.Value)

        If AmountToDeduct >= CurrentFee Then
            RemoveAllRetainerFees()
        Else 'is smaller then total, so do a fee adjustment down (which is done by entering a positive amount)

            Dim RegisterID As Integer = StringHelper.ParseInt(DataHelper.FieldLookup("tblRegister", "RegisterID", "EntryTypeID = 2 AND AccountID = " & AccountID))
            Dim EntryTypeID As Integer = StringHelper.ParseInt(DataHelper.FieldLookup("tblEntryType", "EntryTypeID", "[Name] = 'Fee Adjustment'"))

            RegisterHelper.InsertFeeAdjustment(ClientID, RegisterID, DateTime.Now, String.Empty, Math.Abs(AmountToDeduct), EntryTypeID, UserID, True)

        End If

    End Sub
    Private Sub RemoveRegisterIDs(ByVal RegisterIDs() As Integer)

        For Each RegisterID As Integer In RegisterIDs
            If RegisterHelper.CanDelete(RegisterID) Then
                RegisterHelper.Delete(RegisterID, False)
            Else
                RegisterHelper.Void(RegisterID, UserID, False)
            End If
        Next

        ClientHelper.CleanupRegister(ClientID)

    End Sub
    Protected Sub lnkDeleteCI_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteCI.Click

      'commented out by Jim Hope on 04/10/2008 until we can set the permissions properly for this function

      'If txtSelectedIDs.Value.Length > 0 Then

      '    'get selected "," delimited ID's
      '    Dim arr() As String = txtSelectedIDs.Value.Split(",")

      '    'delete array of ID's
      '    For Each s As String In arr
      '        CreditorInstanceHelper.Delete(Integer.Parse(s))
      '    Next

      'End If

      ''reset account warehouse values
      'AccountHelper.SetWarehouseValues(AccountID)

        'reload same page
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub
    Protected Sub lnkChangeStatus_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeStatus.Click
        Dim CurAccountStatusID As Integer = StringHelper.ParseInt(DataHelper.FieldLookup("tblAccount", "AccountStatusID", "AccountID = " & AccountID))
        Dim AccountStatusID As Integer = StringHelper.ParseInt(txtAccountStatusID.Value)

        'update the status field
        Dim updates As New List(Of DataHelper.FieldValue)

        updates.Add(New DataHelper.FieldValue("AccountStatusID", AccountStatusID))
        updates.Add(New DataHelper.FieldValue("LastModified", Now))
        updates.Add(New DataHelper.FieldValue("LastModifiedBy", UserID))

        Select Case CurAccountStatusID
            Case 54 'Settled Account
                updates.Add(New DataHelper.FieldValue("Settled", DBNull.Value))
                updates.Add(New DataHelper.FieldValue("SettledBy", DBNull.Value))
            Case 55 'Removed Account
                updates.Add(New DataHelper.FieldValue("Removed", DBNull.Value))
                updates.Add(New DataHelper.FieldValue("RemovedBy", DBNull.Value))
        End Select

        DataHelper.AuditedUpdate(updates, "tblAccount", AccountID, UserID)

        Close()

    End Sub
    Protected Sub lnkShowDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowDocs.Click
        LoadDocuments()
    End Sub
    Protected Sub lnkSettle_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSettle.Click

        'set the status as "Settled Account" from the beginning, if found
        Dim AccountStatusID As Integer = StringHelper.ParseInt(DataHelper.FieldLookup("tblAccountStatus", "AccountStatusID", "Code = 'SA' AND Description = 'Settled Account'"))

        'set the current status to removed and set the removed fields
        Dim updates As New List(Of DataHelper.FieldValue)

        If Not AccountStatusID = 0 Then
            updates.Add(New DataHelper.FieldValue("AccountStatusID", AccountStatusID))
        End If

        updates.Add(New DataHelper.FieldValue("Settled", DateTime.Now))
        updates.Add(New DataHelper.FieldValue("SettledBy", UserID))

        DataHelper.AuditedUpdate(updates, "tblAccount", AccountID, UserID)

        Close()

    End Sub

    Protected Sub Harassment1_ReloadDocuments1(ByVal sender As Object, ByVal e As CreditorHarassmentFormControl.harassDocumentEventArgs) Handles Harassment1.ReloadDocuments
        If e.ReloadDocuments = True Then
            Reload()
        End If
    End Sub

    Protected Sub UnVerify_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ckUnverify.Click

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        Try
            cmd.CommandText = "UPDATE tblAccount SET Verified = NULL, VerifiedBy = NULL, VerifiedAmount = NULL WHERE AccountID = @AccountId"
            DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            cmd.Connection.Close()
            cmd.CommandText = ""

            cmd.CommandText = "SELECT * FROM tblAccount WHERE AccountID = @AccountId"

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim AccountStatus As String = DataHelper.FieldLookup("tblAccountStatus", "Description", "AccountStatusID = " & DatabaseHelper.Peel_int(rd, "AccountStatusID"))
                lblCurrentStatus.Text = "Unverified, " & AccountStatus

                lblUnverifiedAmount.Text = DatabaseHelper.Peel_double(rd, "CurrentAmount").ToString("#,##0.00")
                lblUnverifiedRetainerFee.Text = Math.Abs(DataHelper.FieldSum("tblRegister", "Amount", "EntryTypeID = 2 AND AccountID = " & AccountID)).ToString("#,##0.00")

                txtVerifiedAmount.Visible = True
                lblVerifiedAmount.Visible = False

                pnlVerificationAction.Visible = True
                pnlVerificationDisplay.Visible = False

                SetupFeePercentage = DatabaseHelper.Peel_double(rd, "SetupFeePercentage")
                txtVerifiedAmount.Attributes("onkeypress") = "AllowOnlyNumbers(this);"
                txtVerifiedAmount.Attributes("onkeyup") = "txtVerifiedAmount_OnKeyUp(this);"
            End If

        Catch ex As Exception
            Alert.Show("There was an error Un-Verifying this creditor.")
            If cmd.Connection.State = ConnectionState.Open Then cmd.Connection.Close()
        End Try

    End Sub

End Class