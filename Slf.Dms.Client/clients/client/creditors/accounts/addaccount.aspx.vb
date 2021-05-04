Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports SharedFunctions

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_accounts_addaccount
    Inherits PermissionPage

#Region "Variables"

    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection

    Public UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        txtSetupFeePercentage.Disabled = True

        qs = LoadQueryString()

        If Not qs Is Nothing Then
            ClientID = DataHelper.Nz_int(qs("id"), 0)

            SetRollups()

            If Not IsPostBack Then
                hdnTempAccountID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()

                LoadDocuments()
                SetAttributes()
                txtSetupFeePercentage.Value = GetSetupFeePercentage() * 100

                If IsNumeric(Request.QueryString("clid")) Then
                    LoadCreditLiability()
                End If
            End If
        End If

    End Sub
    Private Sub LoadCreditLiability()
        Dim tbl As DataTable = SqlHelper.GetDataTable("exec stp_CreditLiability " & Request.QueryString("clid"))
        Dim row As DataRow

        If tbl.Rows.Count = 1 Then
            row = tbl.Rows(0)

            hdnCreditor.Value = String.Format("{0}|{1}|{2}|{3}|{4}|{5}|{6}|{7}", row("creditorid"), row("currentcreditor"), row("street"), row("street2"), row("city"), row("stateid"), row("zipcode"), row("creditorgroupid"))
            btnCreditor.Attributes("creditor") = row("currentcreditor")
            btnCreditor.Attributes("street") = row("street")
            btnCreditor.Attributes("street2") = row("street2")
            btnCreditor.Attributes("city") = row("city")
            btnCreditor.Attributes("stateid") = row("stateid")
            btnCreditor.Attributes("zipcode") = row("zipcode")

            If Len(CStr(row("originalcreditor"))) > 0 Then
                hdnForCreditor.Value = String.Format("-9|{0}||||0||-9", row("originalcreditor"))
                btnForCreditor.Attributes("creditor") = row("originalcreditor")
            End If

            txtAccountNumber.Value = row("accountnumber")
            txtOriginalAmount.Value = Format(CDbl(row("originalamount")), "#.00")
            txtCurrentAmount.Value = Format(CDbl(row("currentamount")), "#.00")
        End If
    End Sub
    Private Sub SetAttributes()
        txtOriginalAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"
        txtCurrentAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"
        txtSetupFeePercentage.Attributes("onkeypress") = "AllowOnlyNumbers();"
    End Sub
    Private Function GetSetupFeePercentage() As Single
        'Dim str As String = DataHelper.FieldLookup("tblClient", "SetupFeePercentage", "ClientId=" & ClientID)
        'If String.IsNullOrEmpty(str) Then
        'str = PropertyHelper.Value("EnrollmentRetainerPercentage")

        'End If
        'Return Single.Parse(str)

        If Single.TryParse(DataHelper.FieldLookup("tblClient", "InitialAgencyPercent", "ClientId = " & ClientID), Nothing) Then
            Return 0.1
        Else
         Return CDbl(Val(DataHelper.FieldLookup("tblClient", "SetupFeePercentage", "ClientId=" & ClientID)))
        End If
    End Function
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        'add applicant tasks
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SaveConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save new account</a>")

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkAccounts.HRef = "~/clients/client/creditors/accounts/?id=" & ClientID

        btnCreditor.Attributes("onclick") = "FindCreditor(this);"
        btnForCreditor.Attributes("onclick") = "FindCreditor(this);"


        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:OpenScanning();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_remove.png") & """ align=""absmiddle""/>Scan Document</a>")
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
    Private Sub Close()
        Response.Redirect("~/clients/client/creditors/accounts/?id=" & ClientID)
    End Sub
    Private Function CreateAccount() As Integer

        Dim AccountID As Integer = 0

        Dim CurrentAmount As Single = Single.Parse(txtCurrentAmount.Value)
        Dim SetupFeePercentage As Single = (Single.Parse(txtSetupFeePercentage.Value) / 100)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                Dim AccountStatusID As Integer

                'set the status as "Insufficient Funds" from the beginning, if found
                AccountStatusID = StringHelper.ParseInt(DataHelper.FieldLookup("tblAccountStatus", "AccountStatusID", "Code = 'IF' AND Description = 'Insufficient Funds'"))

                If Not AccountStatusID = 0 Then
                    DatabaseHelper.AddParameter(cmd, "AccountStatusID", AccountStatusID)
                End If

                DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
                DatabaseHelper.AddParameter(cmd, "OriginalAmount", Single.Parse(txtOriginalAmount.Value))
                DatabaseHelper.AddParameter(cmd, "CurrentAmount", CurrentAmount)
                DatabaseHelper.AddParameter(cmd, "SetupFeePercentage", DataHelper.FieldLookup("tblClient", "SetupFeePercentage", "ClientID = " + ClientID.ToString()))
                DatabaseHelper.AddParameter(cmd, "OriginalDueDate", DateTime.Parse(txtOriginalDueDate.Text))
                DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)
                DatabaseHelper.AddParameter(cmd, "Created", Now)
                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

                DatabaseHelper.BuildInsertCommandText(cmd, "tblAccount", "AccountID", SqlDbType.Int)

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

                AccountID = DataHelper.Nz_int(cmd.Parameters("@AccountID").Value)

            End Using
        End Using

        Return AccountID

    End Function
    Private Function Save() As Integer

        Dim AccountID = CreateAccount()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                DatabaseHelper.AddParameter(cmd, "Acquired", DateTime.Parse(txtAcquired.Text))
                DatabaseHelper.AddParameter(cmd, "AccountNumber", txtAccountNumber.Value)
                DatabaseHelper.AddParameter(cmd, "ReferenceNumber", DataHelper.Zn(txtReferenceNumber.Value))
                DatabaseHelper.AddParameter(cmd, "OriginalAmount", Single.Parse(txtOriginalAmount.Value.Replace("$", "")))
                DatabaseHelper.AddParameter(cmd, "Amount", Single.Parse(txtCurrentAmount.Value.Replace("$", "")))

                Dim CreditorParts As String() = hdnCreditor.Value.Split("|")
                Dim CreditorID As Integer = CInt(CreditorParts(0))
                Dim CreditorGroupID As Integer = CInt(CreditorParts(7))

                If CreditorID = -1 Then
                    If CreditorGroupID = -1 Then
                        CreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(CreditorParts(1), UserID)
                    End If
                    CreditorID = CreditorHelper.InsertCreditor(CreditorParts(1), CreditorParts(2), CreditorParts(3), CreditorParts(4), Integer.Parse(CreditorParts(5)), CreditorParts(6), UserID, CreditorGroupID)
                End If

                DatabaseHelper.AddParameter(cmd, "CreditorID", CreditorID)

                If hdnForCreditor.Value.Length > 0 Then
                    Dim ForCreditorParts As String() = hdnForCreditor.Value.Split("|")
                    Dim ForCreditorID As Integer = CInt(ForCreditorParts(0))
                    Dim ForCreditorGroupID As Integer = CInt(ForCreditorParts(7))

                    If ForCreditorID = -1 Then
                        If ForCreditorGroupID = -1 Then
                            ForCreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(ForCreditorParts(1), UserID)
                        End If
                        ForCreditorID = CreditorHelper.InsertCreditor(ForCreditorParts(1), ForCreditorParts(2), ForCreditorParts(3), ForCreditorParts(4), Integer.Parse(ForCreditorParts(5)), ForCreditorParts(6), UserID, ForCreditorGroupID)
                    End If

                    DatabaseHelper.AddParameter(cmd, "ForCreditorID", ForCreditorID)
                End If

                DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

                DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)
                DatabaseHelper.AddParameter(cmd, "Created", Now)
                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

                DatabaseHelper.BuildInsertCommandText(cmd, "tblCreditorInstance", "CreditorInstanceID", SqlDbType.Int)

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

            End Using

        End Using

        'update residue
        AccountHelper.SetWarehouseValues(AccountID)

        Dim SetupFeePercentage As Single = (Single.Parse(txtSetupFeePercentage.Value))

        'collect new or adjust existing fee
        AccountHelper.AdjustRetainerFee(AccountID, ClientID, UserID, False, SetupFeePercentage, 0)
        ClientHelper.CleanupRegister(ClientID)

        'if suppose to, lock verification
        If chkIsVerified.Checked Then

            Dim CurrentAmount As Single = Single.Parse(txtCurrentAmount.Value)

            Dim MinimumAdditionalAccountFee As Double = Math.Abs(StringHelper.ParseDouble(DataHelper.FieldLookup("tblClient", _
                "AdditionalAccountFee", "ClientID = " & ClientID)))

            SetupFeePercentage = SetupFeePercentage / 100

            Dim FeeAmount As Double = Math.Abs((CurrentAmount * SetupFeePercentage))

            If MinimumAdditionalAccountFee > FeeAmount Then
                FeeAmount = MinimumAdditionalAccountFee
            End If

            AccountHelper.LockVerification(AccountID, CurrentAmount, 0.0, DateTime.Now, UserID, _
                CurrentAmount, FeeAmount)

        End If

        If Not hdnTempAccountID.Value = 0 Then
            SharedFunctions.DocumentAttachment.SolidifyTempRelation(hdnTempAccountID.Value, "account", ClientID, AccountID)
        End If

        'If this was a non-represented account, mark it as imported
        If IsNumeric(Request.QueryString("clid")) Then
            SqlHelper.ExecuteNonQuery(String.Format("update tblCreditLiability set DateImported = getdate(), ImportedBy = {0} where CreditLiabilityID = {1}", UserID, Request.QueryString("clid")), CommandType.Text)
        End If

        Return AccountID

    End Function
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        SharedFunctions.DocumentAttachment.DeleteAllForItem(hdnTempAccountID.Value, "account", UserID)

        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Response.Redirect("~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & Save())
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub

    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        SharedFunctions.DocumentAttachment.DeleteAttachment(hdnCurrentDoc.Value, UserID)
        LoadDocuments()
    End Sub

    Private Sub LoadDocuments()
        rpDocuments.DataSource = documentHelper.GetDocumentsForRelation(Integer.Parse(hdnTempAccountID.Value), "account") 'SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(Integer.Parse(hdnTempAccountID.Value), "account")

        rpDocuments.DataBind()

        If rpDocuments.DataSource.Count > 0 Then
            hypDeleteDoc.Disabled = False
        Else
            hypDeleteDoc.Disabled = True
        End If
    End Sub

    Protected Sub lnkShowDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowDocs.Click
        LoadDocuments()
    End Sub
End Class