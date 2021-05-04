
Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_finances_ach_adhocach
    Inherits EntityPage

#Region "Variables"

    Private Action As String
    Public AdHocAchID As Integer
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Public NextDate As String
    Public UserID As Integer
    Private bUsed As Boolean = False
    Private bMulti As Boolean = False

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)
            AdHocAchID = DataHelper.Nz_int(qs("ahachid"), 0)
            Action = DataHelper.Nz_string(qs("a"))
            NextDate = LocalHelper.AddBusinessDays(Now, 2).ToString("MM/dd/yyyy")
            bMulti = MultiDepositHelper.IsMultiDepositClient(ClientID)

            If Not IsPostBack Then
                LoadMulti()
                SetDefaults()
                HandleAction()
                LoadNonDepositReplacement()
            End If

            SetRollups()
            SetAttributes()

        End If

    End Sub

    Private Sub LoadNonDepositReplacement()
        Dim matterid As Integer = NonDepositHelper.GetMatterIdByReplacementAdHoc(AdHocAchID)
        If matterid > 0 Then
            lblNondepositMatterId.Text = String.Format("<a href='{0}?id={1}&aid=0&mid={2}&ciid=0' >{2}</a>", ResolveUrl("~/clients/client/creditors/matters/nondepositmatterinstance.aspx"), ClientID, matterid)
            Me.trNonDeposit.Visible = True
            Me.hdnHasNonDeposit.Value = "1"
        Else
            Me.trNonDeposit.Visible = False
            lblNondepositMatterId.Text = ""
            Me.hdnHasNonDeposit.Value = "0"
        End If
    End Sub

    Private Sub LoadMulti()
        Me.trSelectBank.Visible = bMulti

        If bMulti Then

            Me.trSelectBank.Visible = True
            ddlBankName.DataTextField = "BankName"
            ddlBankName.DataValueField = "BankAccountID"

            'Get disable account if current
            Dim banks As DataTable = MultiDepositHelper.getMultiDepositClientBanks(ClientID)
            Dim criteria As String = "Disabled is null"
            Dim dvbanks As New DataView(banks)
            dvbanks.RowFilter = criteria
            ddlBankName.DataSource = dvbanks
            ddlBankName.DataBind()

            Dim addItm As New ListItem("(Add Bank)", "add")
            ddlBankName.Items.Add(addItm)

            If AdHocAchID > 0 Then
                addItm = New ListItem("Select one ", "select")
                addItm.Selected = True
                ddlBankName.Items.Add(addItm)
            Else
                ddlBankName.SelectedIndex = 0
                SelectBank()
            End If
        End If
    End Sub

    Private Sub SetAttributes()
        txtBankRoutingNumber.Attributes("onkeypress") = "AllowOnlyNumbersStrict();"
        txtBankAccountNumber.Attributes("onkeypress") = "AllowOnlyNumbersStrict();"
    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        If Master.UserEdit Then

            'add applicant tasks
            If Permission.UserEdit(Master.IsMy) Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#""" & IIf(bUsed, " disabled ", " onclick=""Record_Save();return false;"" ") & "><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this ACH</a>")
            Else
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
            End If

            If Not Action = "a" And Permission.UserDelete(Master.IsMy) Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#""" & IIf(bUsed, " disabled ", " onclick=""Record_DeleteConfirm();return false;"" ") & "><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this ACH</a>")
            End If

            'add normal tasks

        End If

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkFinances.HRef = "~/clients/client/finances/?id=" & ClientID
        lnkACH.HRef = "~/clients/client/finances/ach/?id=" & ClientID

    End Sub
    Private Sub SetDefaults()

        bdMain.Attributes("onload") = "SetFocus('" & txtDepositDate.ClientID & "');"

    End Sub
    Private Sub HandleAction()

        Select Case Action
            Case "a"    'add
                lblACHRule.Text = "Add Additional ACH"
            Case Else   'edit
                LoadRecord()
        End Select

    End Sub
    Private Sub LoadRecord()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT ah.*, " _
        & "left(u.firstname,1) + '. ' + u.lastname [uCreatedBy], " _
        & "ah.Created, " _
        & "ah.LastModified, " _
        & "left(u1.firstname,1) + '. ' + u1.lastname [uLastModifiedBy] " _
        & "FROM tblAdHocACH ah " _
        & "join tbluser u on u.userid = ah.createdby " _
        & "join tbluser u1 on u1.userid = ah.Lastmodifiedby " _
        & "WHERE AdHocAchId = @AdHocAchId"

        DatabaseHelper.AddParameter(cmd, "AdHocAchId", AdHocAchID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then
                lblACHRule.Text = "Ad&nbsp;Hoc ACH " & DatabaseHelper.Peel_int(rd, "AdHocAchId")
                txtBankAccountNumber.Text = DatabaseHelper.Peel_string(rd, "BankAccountNumber")
                txtBankAccountNumber.Attributes.Add("OrigAccNumber", txtBankAccountNumber.Text)
                lblBankName.Text = DatabaseHelper.Peel_string(rd, "BankName")
                lblBankName.Attributes.Add("OrigBankName", lblBankName.Text)
                txtBankRoutingNumber.Text = DatabaseHelper.Peel_string(rd, "BankRoutingNumber")
                txtBankRoutingNumber.Attributes.Add("OrigBankRouting", txtBankRoutingNumber.Text)
                cboBankType.SelectedValue = DatabaseHelper.Peel_string(rd, "BankType")
                cboBankType.Attributes.Add("OrigBankType", cboBankType.SelectedValue)
                txtDepositAmount.Text = DatabaseHelper.Peel_double(rd, "DepositAmount")
                txtDepositDate.Text = DatabaseHelper.Peel_datestring(rd, "DepositDate", "MM/dd/yyyy")
                lblCreated.Text = DatabaseHelper.Peel_datestring(rd, "Created")
                If rd.Item("uCreatedBy").ToString = "I. Engine" Then
                    lblCreatedBy.Text = "Import Engine"
                Else
                    lblCreatedBy.Text = DatabaseHelper.Peel_string(rd, "uCreatedBy")
                End If
                lblModified.Text = DatabaseHelper.Peel_datestring(rd, "LastModified")
                If rd.Item("uLastModifiedBy").ToString = "I. Engine" Then
                    lblModifiedBy.Text = "Import Engine"
                Else
                    lblModifiedBy.Text = DatabaseHelper.Peel_string(rd, "uLastModifiedBy")
                End If
                bUsed = (DatabaseHelper.Peel_int(rd, "RegisterId") > 0)
                If bUsed Then
                    DisableFromEdit()
                Else
                    If bMulti Then DisableBankInfo()
                End If
            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

    Private Sub DisableFromEdit()
        Me.trSelectBank.Visible = False
        DisableBankInfo()
        txtDepositAmount.Enabled = False
        txtDepositDate.Enabled = False
        lnkSetToNowStart.Attributes.Add("disabled", "true")
        lnkSetToNowStart.Attributes.Add("onclick", "return false;")
        lblUsed.Text = "DEPOSITED"
    End Sub

    Private Sub DisableBankInfo()
        lblBankName.Enabled = False
        txtBankAccountNumber.Enabled = False
        txtBankRoutingNumber.Enabled = False
        cboBankType.Enabled = False
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
        Response.Redirect("~/clients/client/finances/ach/?id=" & ClientID)
    End Sub
    Private Function InsertOrUpdate() As Integer

        If Val(txtDepositAmount.Text.ToString) > 0 Then

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection

                    DatabaseHelper.AddParameter(cmd, "BankName", DataHelper.Zn(lblBankName.Text))
                    DatabaseHelper.AddParameter(cmd, "BankRoutingNumber", txtBankRoutingNumber.Text)
                    DatabaseHelper.AddParameter(cmd, "BankAccountNumber", txtBankAccountNumber.Text)
                    DatabaseHelper.AddParameter(cmd, "DepositAmount", DataHelper.Nz_double(txtDepositAmount.Text))
                    DatabaseHelper.AddParameter(cmd, "DepositDate", DateTime.Parse(txtDepositDate.Text))
                    DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                    DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)
                    Dim bankID As Integer = 0
                    If bMulti Then
                        Select Case ddlBankName.SelectedItem.Value
                            Case "add"
                                bankID = MultiDepositHelper.InsertClientBank(ClientID, txtBankRoutingNumber.Text, txtBankAccountNumber.Text, cboBankType.SelectedItem.Value, UserID)
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

                    If Action = "a" Then 'add
                        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
                        DatabaseHelper.AddParameter(cmd, "Created", Now)
                        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                        DatabaseHelper.BuildInsertCommandText(cmd, "tblAdHocACH", "AdHocACHId", SqlDbType.Int)
                    Else 'edit
                        DatabaseHelper.BuildUpdateCommandText(cmd, "tblAdHocACH", "AdHocACHId = " & AdHocAchID)
                    End If

                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()

                End Using

                If Action = "a" Then 'add
                    AdHocAchID = DataHelper.Nz_int(cmd.Parameters("@AdHocACHId").Value)
                End If

            End Using
        Else
            Alert.Show("You can not create an AdHocACH for $0.")
            Return -1
        End If

        Return AdHocAchID
    End Function
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        If RequiredExist() Then

            InsertOrUpdate()
            Close()

        End If

    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        'delete check to print
        DataHelper.Delete("tblAdHocAch", "AdHocAchId = " & AdHocAchID)
        MultiDepositHelper.AuditDeleteAdHocACH(AdHocAchID, UserID)
        'drop back to ach
        Close()

    End Sub
    Private Sub DisplayError(ByVal Message As String, ByVal ToFocus As WebControl)

        dvError.Style("display") = "inline"
        tdError.InnerHtml = Message

        ToFocus.Style("border") = "solid 2px red"
        bdMain.Attributes("onload") = "SetFocus('" & ToFocus.ClientID & "');"

    End Sub
    Private Function RequiredExist() As Boolean

        Dim d As DateTime

        txtDepositDate.Style.Remove("border")
        txtBankRoutingNumber.Style.Remove("border")

        'is valid date
        If Not DateTime.TryParse(txtDepositDate.Text, d) Then
            DisplayError("The Deposit Date you entered is not a valid date.", txtDepositDate)
            Return False
        End If

        'is not on weekend
        If d.DayOfWeek = DayOfWeek.Saturday Or d.DayOfWeek = DayOfWeek.Sunday Then
            DisplayError("The Deposit Date you entered is on a weekend.", txtDepositDate)
            Return False
        End If

        'is not on bank holiday
        Dim HolidayName As String = DataHelper.Nz_string(DataHelper.FieldLookup("tblBankHoliday", "Name", DataHelper.StripTime("Date") & "='" & d.ToString("MM/dd/yyyy") & "'"))
        If Not String.IsNullOrEmpty(HolidayName) Then
            DisplayError("The Deposit Date you entered is on a bank holiday (" & HolidayName & ").", txtDepositDate)
            Return False
        End If

        'is two days from now
        If LocalHelper.AddBusinessDays(d, -2) < Date.Today Then
            DisplayError("The Deposit Date you entered is not a minimum of two business days from now.", txtDepositDate)
            Return False
        End If

        'routing number validation
        Dim objClient As New WCFClient.Store
        Dim BankName As String = ""
        If Not objClient.RoutingIsValid(txtBankRoutingNumber.Text, lblBankName.Text) Then
            If Not CheckOurTable(txtBankRoutingNumber.Text, lblBankName.Text) Then
                DisplayError("The Bank Routing Number you entered does not validate against the Federal ACH Directory.", txtBankRoutingNumber)
                Return False
            End If
        End If

        Return True
    End Function
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub
    Public Overrides ReadOnly Property BaseQueryString() As String
        Get
            Return "ahachid"
        End Get
    End Property
    Public Overrides ReadOnly Property BaseTable() As String
        Get
            Return "tblAdHocACH"
        End Get
    End Property

    Protected Sub ddlBankName_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBankName.SelectedIndexChanged
        SelectBank()
    End Sub

    Private Sub SelectBank()
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

    Private Function CheckOurTable(ByVal RoutingNumber As String, Optional ByRef BankName As String = "") As Boolean
        Dim IsGood As String = ""
        IsGood = DataHelper.FieldLookup("tblRoutingNumber", "RoutingNumber", "RoutingNumber = " & RoutingNumber)
        If IsGood <> "" Then
            BankName = DataHelper.FieldLookup("tblRoutingNumber", "CustomerName", "RoutingNumber = " & RoutingNumber)
            Return True
        Else
            Return False
        End If

    End Function

End Class