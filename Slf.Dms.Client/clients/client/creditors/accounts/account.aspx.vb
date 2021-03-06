Option Explicit On
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO

Imports CreditorHarassmentFormControl

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers

Imports LexxiomLetterTemplates

Imports Slf.Dms.Records

Partial Class clients_client_accounts_account
    Inherits EntityPage

    #Region "Fields"

    Public AccountID As Integer
    Public SetupFeePercentage As Double
    Public UserID As Integer
    Public bVerifiedAccount As Boolean = True 'False
    Public rptTemplates As LexxiomLetterTemplates.LetterTemplates

    Public Shadows ClientID As Integer

    Private Action As String
    Private Manager As Boolean = False
    Private qs As QueryStringCollection

    #End Region 'Fields

    #Region "Properties"

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

    #End Region 'Properties

    #Region "Methods"

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(dvTab3, c, "Home-Default Controls-Tasks") 'Matters tab uses same permissions as the Home page task tabs
    End Sub

    Public Function BuildAttachmentPath(ByVal docRelID As Integer) As String
        Dim docTypeID As String = String.Empty
        Dim docID As String = String.Empty
        Dim dateStr As String = String.Empty
        Dim clientID As Integer = 0
        Dim subFolder As String = String.Empty
        Using cmd As New SqlCommand("SELECT ClientID, DocTypeID, DocID, DateString, isnull(SubFolder, '') as SubFolder FROM tblDocRelation with(nolock) WHERE DocRelationID = " + docRelID.ToString(), ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        docTypeID = reader("DocTypeID").ToString()
                        docID = reader("DocID").ToString()
                        dateStr = reader("DateString").ToString()
                        clientID = Integer.Parse(reader("ClientID"))
                        subFolder = reader("SubFolder").ToString()
                    End If
                End Using
            End Using
        End Using

        Return BuildAttachmentPath(docTypeID, docID, dateStr, clientID, subFolder)
    End Function

    Public Function BuildAttachmentPath(ByVal docTypeID As String, ByVal docID As String, ByVal dateStr As String, ByVal clientID As Integer, Optional ByVal subFolder As String = "") As String
        Dim acctNo As String = String.Empty
        Dim server As String = String.Empty
        Dim storage As String = String.Empty
        Dim folder As String = String.Empty

        Using cmd As New SqlCommand("SELECT AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + clientID.ToString(), ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999")) '
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        acctNo = reader("AccountNumber").ToString()
                        server = reader("StorageServer").ToString()
                        storage = reader("StorageRoot").ToString()
                    End If
                End Using
                cmd.CommandText = "SELECT DocFolder FROM tblDocumentType WHERE TypeID = '" + docTypeID + "'"
                folder = cmd.ExecuteScalar().ToString()
            End Using
        End Using
        If docTypeID = "M030" Then
            'Return "\\" + server + "\" + storage + "\" + acctNo + "\LegacyDocs\" & subFolder
            Return subFolder
        Else
            Return "\\" + server + "\" + storage + "\" + acctNo + "\" + folder + "\" + IIf(subFolder.Length > 0, subFolder, "") + acctNo + "_" + docTypeID + "_" + docID + "_" + dateStr + ".pdf"
        End If
    End Function

    Public Function GetAttachmentsForRelation(ByVal ClientID As Integer, ByVal AccountID As Integer, ByVal relationType As String, Optional ByVal url As String = "") As List(Of AttachedDocument)
        Dim docs As New List(Of AttachedDocument)

        Dim final As New List(Of AttachedDocument)

        Dim cmdStr As String = String.Format("stp_Matters_GetAttachmentsForRelation {0},{1}", AccountID, ClientID)

        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))

            Using cmd.Connection

                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()

                    While reader.Read()

                        docs.Add(New AttachedDocument(reader("RelationID"), reader("DocRelationID"), "", reader("DisplayName"), "", False, "", Date.Parse(reader("ReceivedDate")).ToString("d"), Date.Parse(reader("Created")).ToString("g"), IIf(reader("CreatedBy") Is Nothing, "", reader("CreatedBy").ToString())))

                    End While

                End Using

            End Using

        End Using

        Dim tempName As String

        For Each doc As AttachedDocument In docs

            tempName = BuildAttachmentPath(doc.DocRelationID)
            'tempName = SharedFunctions.DocumentAttachment.BuildAttachmentPath(doc.DocRelationID)

            doc.DocumentPath = LocalHelper.GetVirtualDocFullPath(tempName)

            doc.DocumentName = Path.GetFileName(doc.DocumentPath)

            If File.Exists(tempName) Then

                doc.Existence = True

            End If

            If doc.Received = "1/1/1900" Then

                doc.Received = ""

            End If

            If doc.Created.Contains("1/1/1900") Then

                doc.Created = ""

            End If

            final.Add(doc)

        Next

        Return final
    End Function

    Public Function GetMatterImage(ByVal group As String) As String
        Select Case group
            Case "1"
                Return ResolveUrl("~/images/matter.jpg")
            Case "2"
                Return ResolveUrl("~/images/16x16_user.png")
        End Select
        Return String.Empty
    End Function

    Public Function Snippet(ByVal s As Object) As String
        If IsDBNull(s) OrElse s Is Nothing Then
            Return ""
        ElseIf CType(s, String).Length <= 4 Then
            Return CType(s, String)
        Else
            Return "***" & CType(s, String).Substring(CType(s, String).Length - 4)
        End If
    End Function

    Protected Sub Harassment1_ReloadDocuments1(ByVal sender As Object, ByVal e As CreditorHarassmentFormControl.harassDocumentEventArgs) Handles Harassment1.ReloadDocuments
        If e.ReloadDocuments = True Then
            Reload()
        End If
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

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        If dvTab3.Visible Then
            '*** Added Matter tab strip to display Matters ***'
            tsTabStrip.TabPages.Add(New Slf.Dms.Controls.TabPage("Matters", dvTab3.ClientID))
        End If

        If Action = "m" Then
            tsTabStrip.SelectedIndex = 3

            dvTab0.Style.Add("display", "none")
            dvTab3.Style.Add("display", "block")
            tr1.Style.Add("display", "block")
            tr2.Style.Add("display", "none")
            'tr3.Style.Add("display", "block")
        Else
            tr1.Style.Add("display", "block")
            tr2.Style.Add("display", "block")
            'tr3.Style.Add("display", "none")
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
                lblCurrentStatus.Text = "Unverified, " & AccountStatus & GetPAIfSettled(AccountID, AccountStatus)

                lblUnverifiedAmount.Text = DatabaseHelper.Peel_double(rd, "CurrentAmount").ToString("#,##0.00")
                lblUnverifiedRetainerFee.Text = Math.Abs(DataHelper.FieldSum("tblRegister", "Amount", "EntryTypeID IN (2, 42) AND AccountID = " & AccountID)).ToString("#,##0.00")

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

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
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

    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        SharedFunctions.DocumentAttachment.DeleteAttachment(hdnCurrentDoc.Value, UserID)
        LoadDocuments()
        Me.updDocs.Update()
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

    Protected Sub lnkShowDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowDocs.Click
        LoadDocuments()
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
                    ClientHelper.CleanupRegister(ClientID)
                End If
            End If

            Dim rtrFee As Double = (CDbl(Val(lblVerifiedRetainerFeePercentage2.Text)) * 0.01) * CDbl(lblCurrentAmount.Text)

            'lock verification
            AccountHelper.LockVerification(AccountID, PreviousAmount, PreviousFee, DateTime.Now, UserID, _
                StringHelper.ParseDouble(txtVerifiedAmount.Text), _
                rtrFee)
            'AccountHelper.GetSumRetainerOrAdditionalAccountFees(AccountID))

            Reload()
        End If
    End Sub

    Protected Sub rpMatterInstance_ItemDataBound(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If rpMatterInstance.Items.Count < 1 Then
            If e.Item.ItemType = ListItemType.Footer Then
                Dim lblFooter As Label = CType(e.Item.FindControl("lblEmptyData"), Label)
                lblFooter.Visible = True
            End If
        End If
    End Sub

    Private Sub Close()
        Response.Redirect("~/clients/client/creditors/accounts/?id=" & ClientID)
    End Sub

    Private Sub HandleAction()
        Dim CommonTasks As List(Of String) = Master.CommonTasks
        Dim Views As List(Of String) = Master.Views
        If Master.UserEdit Then
            Views.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/clients/client/creditors/matters/matterroadmap.aspx?id=" & ClientID & "&a=a&aid=" & AccountID & "") & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_flowchart.png") & """ align=""absmiddle""/>Show Matter roadmap</a>")
        End If

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
                    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""javascript:AttachDocument();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/12x13_arrow_up.png") & """ align=""absmiddle""/>Upload Document</a>")

                    LoadRecord()
                    LoadCreditorInstances()
                    'Added for loading Matter'
                    LoadMatters()
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

        If PermissionHelperLite.HasPermission(UserID, "Home-Default Controls-Tasks") Then
            '******* Added for Matter  **********'
            'CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddCall();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_phone2.png") & """ align=""absmiddle""/>Make Phone Call</a>")
            'CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddNote();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_note.png") & """ align=""absmiddle""/>Add a note</a>")
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_AddMatter();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/matter.jpg") & """ align=""absmiddle""/>Add a Matter</a>")
        End If
    End Sub

    Private Sub LoadCreditorInstances()
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_getCreditorInstancesForAccount")
            Using cmd.Connection
                cmd.Connection.Open()
                DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)
                Using rd As IDataReader = cmd.ExecuteReader()
                    rpCreditorInstances.DataSource = rd
                    rpCreditorInstances.DataBind()
                End Using
            End Using
        End Using

        'dsCredInstance.selectparameters("AccountID").defaultvalue = AccountID
        'dsCredInstance.databind()

    End Sub

    Private Sub LoadDocuments()
        rpDocuments.DataSource = documentHelper.GetDocumentsForRelation(AccountID, "account", Request.Url.AbsoluteUri)
        rpDocuments.DataBind()

        If rpDocuments.DataSource.Count > 0 Then
            hypDeleteDoc.Disabled = False
        Else
            hypDeleteDoc.Disabled = True
        End If

        Dim rdMatter As IDataReader = Nothing
        Dim cmdMatter As IDbCommand = ConnectionFactory.Create().CreateCommand
        Dim strHTML As String = String.Empty

        Dim MatterID As Integer
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand
        Try
            cmd.Connection.Open()
            'loading matters information
            cmdMatter.Connection.Open()
            cmdMatter.CommandText = "stp_GetMattersbyClientAccount"
            cmdMatter.CommandType = CommandType.StoredProcedure
            DatabaseHelper.AddParameter(cmdMatter, "ClientId", ClientID)
            DatabaseHelper.AddParameter(cmdMatter, "AccountId", AccountID)
            rdMatter = cmdMatter.ExecuteReader()

            While rdMatter.Read()
                MatterID = rdMatter("MatterID")

                rpMatterDocuments.DataSource = GetAttachmentsForRelation(ClientID, AccountID, "matter") '  SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(MatterID, "matter")
                rpMatterDocuments.DataBind()

                If rpMatterDocuments.DataSource.Count > 0 Then
                    lnkMatterDeleteDocuments.Disabled = False
                Else
                    lnkMatterDeleteDocuments.Disabled = True
                End If
            End While
            rdMatter.Close()

        Catch ex As Exception
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            DatabaseHelper.EnsureReaderClosed(rdMatter)
            DatabaseHelper.EnsureConnectionClosed(cmdMatter.Connection)
        End Try

    End Sub
    
    '***** Added to load Matters ******'
    Private Sub LoadMatters()
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetMattersbyClientAccount")
            Using cmd.Connection
                cmd.Connection.Open()
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                DatabaseHelper.AddParameter(cmd, "AccountId", AccountID)
                Using rd As IDataReader = cmd.ExecuteReader()
                    rpMatterInstance.DataSource = rd
                    rpMatterInstance.DataBind()
                End Using
            End Using
        End Using
    End Sub

    Private Function GetPAIfSettled(ByVal AccountId As Integer, ByVal Status As String) As String
        Dim sb As New StringBuilder
        Select Case Status.Trim.ToLower
            Case "settled account"
                Dim settid As Nullable(Of Integer) = Nothing
                If PaymentScheduleHelper.IsAccountSettledWithActivePA(AccountId, settid) Then
                    If settid.HasValue AndAlso settid.Value > 0 Then
                        sb.AppendFormat(", <a href=""javascript:void()"" onclick=""OpenPABox({0});return false;"">with Pending Payments</a>", settid)
                    End If
                End If
        End Select
        Return sb.ToString
    End Function

    Private Sub LoadRecord()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblAccount WHERE AccountID = @AccountId"

        DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                lblName.Text = CreditorGroupHelper.GetOrigCreditorName(AccountID)
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
                    lblCurrentStatus.Text = "Verified, " & AccountStatus & GetPAIfSettled(AccountID, AccountStatus)

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

                    lblCurrentStatus.Text = "Unverified, " & AccountStatus & GetPAIfSettled(AccountID, AccountStatus)

                    lblUnverifiedAmount.Text = DatabaseHelper.Peel_double(rd, "CurrentAmount").ToString("#,##0.00")
                    lblUnverifiedRetainerFee.Text = Math.Abs(DataHelper.FieldSum("tblRegister", "Amount", "EntryTypeID IN (2, 42) AND AccountID = " & AccountID)).ToString("#,##0.00")

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

    Private Sub Reload()
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub

    Private Sub RemoveAddAccountFees()
        Dim RegisterIDs() As Integer = DataHelper.FieldLookupIDs("tblRegister", "RegisterID", "EntryTypeID = 19 AND AccountID = " & AccountID)

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

    Private Sub RemoveSettlementFees()
        Dim RegisterIDs() As Integer = DataHelper.FieldLookupIDs("tblRegister", "RegisterID", "EntryTypeID = 4 AND AccountID = " & AccountID)

        RemoveRegisterIDs(RegisterIDs)
    End Sub

    #End Region 'Methods

    #Region "Nested Types"

    Public Structure AttachedDocument

        #Region "Fields"

        Public Created As String
        Public CreatedBy As String
        Public DocRelationID As Integer
        Public DocumentName As String
        Public DocumentPath As String
        Public DocumentType As String
        Public Existence As Boolean
        Public Origin As String
        Public Received As String
        Public RelationID As Integer

        #End Region 'Fields

        #Region "Constructors"

        Public Sub New(ByVal _RelationID As Integer, ByVal _DocRelationID As Integer, ByVal _DocumentName As String, ByVal _DocumentType As String, ByVal _DocumentPath As String, ByVal _Existence As Boolean, ByVal _Origin As String, ByVal _Received As String, ByVal _Created As String, ByVal _CreatedBy As String)
            Me.RelationID = _RelationID

            Me.DocRelationID = _DocRelationID

            Me.DocumentName = _DocumentName

            Me.DocumentType = _DocumentType

            Me.DocumentPath = _DocumentPath

            Me.Existence = _Existence

            Me.Origin = _Origin

            Me.Received = _Received

            Me.Created = _Created

            Me.CreatedBy = _CreatedBy
        End Sub

        #End Region 'Constructors

    End Structure

    #End Region 'Nested Types

    #Region "Other"

    'Protected Sub lnkDeleteMI_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteMI.Click
    '    'Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
    '    If txtSelectedIDs.Value.Length > 0 Then
    '        'get selected "," delimited ID's
    '        Dim arr() As String = txtSelectedIDs.Value.Split(",")
    '        'delete array of ID's
    '        For Each s As String In arr
    '            Using cmd As New SqlCommand("UPDATE tblMatter SET IsDeleted = 1 WHERE MatterID = " + Integer.Parse(s).ToString(), ConnectionFactory.Create())
    '                Using cmd.Connection
    '                    cmd.Connection.Open()
    '                    cmd.ExecuteNonQuery()
    '                End Using
    '            End Using
    '            'CreditorInstanceHelper.Delete(Integer.Parse(s))
    '        Next
    '    End If
    '    'reload same page
    '    Response.Redirect(Request.Url.AbsoluteUri)
    'End Sub

    #End Region 'Other
    Public Function AddDocIDToReportArguments() As String
        Return ReportsHelper.GetNewDocID
    End Function
    
End Class