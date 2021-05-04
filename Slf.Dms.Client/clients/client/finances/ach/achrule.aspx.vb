Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Imports MultiDepositHelper

Partial Class clients_client_finances_ach_achrule
    Inherits EntityPage

    Private Enum RuleStatusType
        Expired = 0
        Current = 1
        Future = 2
    End Enum

#Region "Variables"

    Private Action As String
    Private RuleACHID As Integer
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Private LastUsed As Nullable(Of DateTime)
    Private ruleStatus As RuleStatusType = RuleStatusType.Current
    Private bMulti As Boolean = False

    Public UserID As Integer
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)
            RuleACHID = DataHelper.Nz_int(qs("ruleachid"), 0)
            Action = DataHelper.Nz_string(qs("a"))
            bMulti = MultiDepositHelper.IsMultiDepositClient(ClientID)
            LastUsed = GetLastDateUsed()

            If Not IsPostBack Then
                LoadMulti()
                SetDefaults()
                HandleAction()
            End If

            SetRollups()
            SetAttributes()


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
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#""" & IIf(ruleStatus = RuleStatusType.Expired, " disabled ", " onclick=""Record_Save();return false;"" ") & "><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this rule</a>")
            Else
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
            End If

            If Not Action = "a" And Permission.UserDelete(Master.IsMy) Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#""" & IIf(ruleStatus = RuleStatusType.Expired Or LastUsed.HasValue, " disabled ", " onclick=""Record_DeleteConfirm();return false;"" ") & "><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this rule</a>")
            End If

            'add normal tasks

        End If

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkFinances.HRef = "~/clients/client/finances/?id=" & ClientID
        lnkACH.HRef = "~/clients/client/finances/ach/?id=" & ClientID

    End Sub

    Private Sub HandleAction()

        Select Case Action
            Case "a"    'add
                lblACHRule.Text = "Add New Rule"
            Case Else   'edit
                LoadRecord()
        End Select

    End Sub
    Private Sub SetDefaults()

        bdMain.Attributes("onload") = "SetFocus('" & txtStartDate.ClientID & "');"

    End Sub
    Private Sub LoadDepositDays(ByVal SelectedDay As String)

        Dim iDay As Integer = Integer.Parse(SelectedDay.Replace("Day", ""))

        For i As Integer = 1 To 30
            Dim itm As New ListItem
            itm.Text = "Day " & i
            itm.Value = i
            If i = iDay Then
                itm.Selected = True
            End If
            ddlDepositDay.Items.Add(itm)
        Next
    End Sub
    Private Sub LoadMulti()
        '3.12.09.ug:sub for setting up multi  deposit clients
        If bMulti Then
            trMultiOverride.Style("display") = "block"
            ddlClientDepositID.DataTextField = "DepositDay"
            ddlClientDepositID.DataValueField = "ClientDepositID"
            ddlClientDepositID.DataTextFormatString = "Day {0}"
            ddlClientDepositID.DataSource = MultiDepositHelper.getMultiDepositsForClient(ClientID)
            ddlClientDepositID.DataBind()

            lblBankName.Visible = False

            ddlBankName.Style("display") = "block"
            ddlBankName.DataTextField = "BankName"
            ddlBankName.DataValueField = "BankAccountID"

            'Get disable account if current
            Dim banks As DataTable = MultiDepositHelper.getMultiDepositClientBanks(ClientID)
            Dim criteria As String = "Disabled is null"
            If RuleACHID > 0 Then
                Dim bankaccountid As String = DataHelper.FieldLookup("tblDepositRuleACH", "BankAccountId", "RuleAchId = " & RuleACHID)
                criteria = criteria & " Or BankAccountId = " & bankaccountid
            End If

            Dim dvbanks As New DataView(banks)
            dvbanks.RowFilter = criteria
            ddlBankName.DataSource = dvbanks
            ddlBankName.DataBind()

            Dim addItm As New ListItem("(Add Bank)", "add")
            ddlBankName.Items.Add(addItm)

            addItm = New ListItem("(Select Bank)", "select")
            addItm.Selected = True
            ddlBankName.Items.Add(addItm)

            LoadDepositDays(ddlClientDepositID.SelectedItem.Text)
        Else
            LoadDepositDays(1)
        End If
    End Sub
    Private Sub LoadRecord()
        Dim enableBank As Boolean = True
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        trAccountDisabled.Style("Display") = "None"
        If bMulti = False Then
            cmd.CommandText = "SELECT ra.*, left(u.firstname, 1) + '. ' + u.lastname [uCreatedBy], LEFT(u1.FirstName,1) + '. ' + u1.LastName [uLastModifiedBy], ra.Created, ra.LastModified FROM tblRuleACH ra join tbluser u on u.userid = ra.createdby join tbluser u1 on u1.userid = ra.lastmodifiedby WHERE RuleACHId = @RuleACHId"
            DatabaseHelper.AddParameter(cmd, "RuleACHId", RuleACHID)
            Try
                cmd.Connection.Open()
                rd = cmd.ExecuteReader(CommandBehavior.SingleRow)
                If rd.Read() Then
                    lblACHRule.Text = "Rule " & DatabaseHelper.Peel_int(rd, "RuleACHId")
                    lblBankName.Text = DatabaseHelper.Peel_string(rd, "BankName")
                    txtBankAccountNumber.Text = DatabaseHelper.Peel_string(rd, "BankAccountNumber")
                    txtBankRoutingNumber.Text = DatabaseHelper.Peel_string(rd, "BankRoutingNumber")
                    cboBankType.SelectedValue = DatabaseHelper.Peel_string(rd, "BankType")
                    txtDepositAmount.Text = DatabaseHelper.Peel_double(rd, "DepositAmount")
                    txtStartDate.Text = DatabaseHelper.Peel_datestring(rd, "StartDate", "MM/yyyy")
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
                    Dim EndDate As Nullable(Of DateTime) = DatabaseHelper.Peel_ndate(rd, "EndDate")
                    If EndDate.HasValue Then
                        txtEndDate.Text = EndDate.Value.ToString("MM/yyyy")
                    End If
                    ListHelper.SetSelected(ddlDepositDay, DatabaseHelper.Peel_int(rd, "DepositDay"))
                    ruleStatus = GetRuleStatus(rd("StartDate"), EndDate)
                End If
            Finally
                DatabaseHelper.EnsureReaderClosed(rd)
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try
        Else
            Dim rule As DataRow = MultiDepositHelper.getMultiDepositRuleByRuleID(RuleACHID)
            If rule IsNot Nothing Then
                lblACHRule.Text = "Rule " & rule("RuleACHId")
                lblBankName.Text = rule("BankName")
                txtBankAccountNumber.Text = rule("BankAccountNumber")
                txtBankRoutingNumber.Text = rule("BankRoutingNumber")
                txtDepositAmount.Text = rule("DepositAmount")
                txtStartDate.Text = Format(rule("StartDate"), "MM/yyyy")
                lblCreated.Text = Format(rule("Created"), "MM/dd/yyyy")
                lblCreatedBy.Text = rule("uCreatedBy")
                lblModified.Text = Format(rule("LastModified"), "MM/dd/yyyy")
                lblModifiedBy.Text = rule("uLastModifiedBy")
                Dim EndDate As Nullable(Of DateTime) = rule("EndDate")
                If EndDate.HasValue Then
                    txtEndDate.Text = EndDate.Value.ToString("MM/yyyy")
                End If
                ListHelper.SetSelected(ddlDepositDay, rule("DepositDay"))
                ListHelper.SetSelected(ddlClientDepositID, rule("ClientDepositID"))
                ListHelper.SetSelected(cboBankType, rule("BankType"))
                ListHelper.SetSelected(ddlBankName, rule("BankAccountID"))
                If Not rule("Disabled") Is DBNull.Value Then trAccountDisabled.Style("Display") = "block"
                enableBank = (rule("BankAccountID") Is DBNull.Value OrElse Not CInt(rule("BankAccountID")) > 0)
                txtBankAccountNumber.Enabled = enableBank
                txtBankRoutingNumber.Enabled = enableBank
                cboBankType.Enabled = enableBank
                ruleStatus = GetRuleStatus(rule("StartDate"), EndDate)
            End If
        End If


        DisableFromEdit(enableBank)


    End Sub

    Private Sub DisableFromEdit(ByVal enableBank As Boolean)
        Me.txtStartDate.Enabled = ruleStatus <> RuleStatusType.Expired And Not LastUsed.HasValue
        Me.txtEndDate.Enabled = ruleStatus <> RuleStatusType.Expired
        Me.ddlClientDepositID.Enabled = ruleStatus <> RuleStatusType.Expired And Not LastUsed.HasValue
        Me.ddlDepositDay.Enabled = ruleStatus <> RuleStatusType.Expired And Not LastUsed.HasValue
        Me.txtDepositAmount.Enabled = ruleStatus <> RuleStatusType.Expired And Not LastUsed.HasValue
        Me.lblBankName.Enabled = ruleStatus <> RuleStatusType.Expired And Not LastUsed.HasValue
        Me.ddlBankName.Enabled = ruleStatus <> RuleStatusType.Expired And Not LastUsed.HasValue
        Me.txtBankRoutingNumber.Enabled = ruleStatus <> RuleStatusType.Expired And Not LastUsed.HasValue And enableBank
        Me.txtBankAccountNumber.Enabled = ruleStatus <> RuleStatusType.Expired And Not LastUsed.HasValue And enableBank
        Me.cboBankType.Enabled = ruleStatus <> RuleStatusType.Expired And Not LastUsed.HasValue And enableBank
        If ruleStatus = RuleStatusType.Expired Or LastUsed.HasValue Then
            lnkSetToNowStart.Attributes.Add("disabled", "true")
            lnkSetToNowStart.Attributes.Add("onclick", "return false;")
        End If
        If ruleStatus = RuleStatusType.Expired Then
            lnkSetToNowEnd.Attributes.Add("disabled", "true")
            lnkSetToNowEnd.Attributes.Add("onclick", "return false;")
        End If
        Dim depAmt As Integer = 0
        Integer.TryParse(txtDepositAmount.Text, depAmt)
        If depAmt <> 0 And LastUsed.HasValue Then
            Me.lblLastUsed.Text = "Last time this rule or similar was used: " & LastUsed.Value.ToShortDateString
        End If
    End Sub


    Private Function GetRuleStatus(ByVal StartDate As DateTime, ByVal EndDate As Nullable(Of Date)) As RuleStatusType
        If StartDate < Now AndAlso (Not EndDate.HasValue OrElse EndDate.Value > Now) Then
            Return RuleStatusType.Current
        ElseIf StartDate > Now AndAlso (Not EndDate.HasValue OrElse EndDate.Value > Now) Then
            Return RuleStatusType.Future
        Else
            Return RuleStatusType.Expired
        End If
    End Function

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
        Dim ruleTable As String = ""
        Dim clientIDType As String = ""
        Dim clientIDTypeValue As String = ""

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                Select Case bMulti
                    Case False  'not a mutli client
                        DatabaseHelper.AddParameter(cmd, "BankName", DataHelper.Zn(lblBankName.Text))
                        DatabaseHelper.AddParameter(cmd, "BankRoutingNumber", txtBankRoutingNumber.Text)
                        DatabaseHelper.AddParameter(cmd, "BankAccountNumber", txtBankAccountNumber.Text)
                        If cboBankType.SelectedValue = "0" Then
                            DatabaseHelper.AddParameter(cmd, "BankType", DBNull.Value, DbType.String)
                        Else
                            DatabaseHelper.AddParameter(cmd, "BankType", cboBankType.SelectedValue, DbType.String)
                        End If
                        ruleTable = "tblRuleACH"
                        clientIDType = "ClientID"
                        clientIDTypeValue = ClientID

                    Case True
                        Dim bankID As Integer
                        Select Case ddlBankName.SelectedItem.Value
                            Case "add", "select"
                                bankID = MultiDepositHelper.InsertClientBank(ClientID, txtBankRoutingNumber.Text, txtBankAccountNumber.Text, cboBankType.SelectedItem.Value, UserID)
                            Case Else
                                bankID = ddlBankName.SelectedItem.Value
                        End Select

                        DatabaseHelper.AddParameter(cmd, "BankAccountID", bankID)
                        ruleTable = "tblDepositRuleAch"
                        clientIDType = "ClientDepositID"
                        clientIDTypeValue = ddlClientDepositID.SelectedItem.Value
                End Select

                DatabaseHelper.AddParameter(cmd, "DepositAmount", DataHelper.Nz_double(txtDepositAmount.Text))
              
                Dim startDate As Nullable(Of DateTime) = DataHelper.Nz_ndate(txtStartDate.Text)
                If startDate.HasValue Then
                    startDate = New DateTime(startDate.Value.Year, startDate.Value.Month, 1)
                End If
                Dim endDate As Nullable(Of DateTime) = DataHelper.Nz_ndate(txtEndDate.Text)
                If endDate.HasValue Then
                    endDate = New DateTime(endDate.Value.Year, endDate.Value.Month, DateTime.DaysInMonth(endDate.Value.Year, endDate.Value.Month))
                End If
                DatabaseHelper.AddParameter(cmd, "StartDate", startDate)
                DatabaseHelper.AddParameter(cmd, "EndDate", endDate)
                DatabaseHelper.AddParameter(cmd, "DepositDay", Integer.Parse(ddlDepositDay.SelectedValue.Replace("Day", "")))
                DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)
                If Action = "a" Then 'add
                    DatabaseHelper.AddParameter(cmd, "Created", Now)
                    DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                    DatabaseHelper.AddParameter(cmd, clientIDType, clientIDTypeValue)
                    DatabaseHelper.BuildInsertCommandText(cmd, ruleTable, "RuleACHId", SqlDbType.Int)
                Else 'edit
                    DatabaseHelper.BuildUpdateCommandText(cmd, ruleTable, "RuleACHId = " & RuleACHID)
                End If
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

            End Using

            If Action = "a" Then 'add
                RuleACHID = DataHelper.Nz_int(cmd.Parameters("@RuleACHId").Value)
            End If
        End Using

        Return RuleACHID

    End Function
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Private Sub DisplayError(ByVal Message As String, ByVal ToFocus As WebControl)

        dvError.Style("display") = "inline"
        tdError.InnerHtml = Message

        ToFocus.Style("border") = "solid 2px red"
        bdMain.Attributes("onload") = "SetFocus('" & ToFocus.ClientID & "');"

    End Sub
    Private Function RequiredExist() As Boolean

        txtBankRoutingNumber.Style.Remove("border")

        If LastUsed.HasValue Then
            'Do not allow to save the enddate a previous end date
            If txtEndDate.Text.Trim.Length > 0 Then
                Dim LastUsedDate As DateTime = New Date(Year(LastUsed.Value), Month(LastUsed.Value), 1)
                If CDate(txtEndDate.Text.Trim) < LastUsedDate Then
                    DisplayError("This rule has been used so the end date cannot be changed to before " & LastUsedDate.ToShortDateString, txtEndDate)
                    Return False
                End If
            End If
        End If

        'Check to see if first time rule is prior the next deposit business date
        If Action = "a" OrElse Not LastUsed.HasValue Then
            Try
                Dim NextBusDate As String = LocalHelper.AddBusinessDays(Now, 1).ToString("MM/dd/yyyy")
                Dim startDate As Nullable(Of DateTime) = DataHelper.Nz_ndate(txtStartDate.Text)
                Dim compStartDate As DateTime = GetFirstEffectiveDate()
                If compStartDate <= CDate(NextBusDate) Then Throw New Exception("The rule you are creating or changing must be any date after " & NextBusDate)
            Catch ex As Exception
                DisplayError(ex.Message, ddlDepositDay)
                Return False
            End Try
        End If

        'Check if there are rules used that match the new rule to add.
        If Action = "a" Then
            If SimilarRulesUsed() Then
                DisplayError("There is a deposit already posted that matches the rule you are creating. Try changing the date range", txtStartDate)
                Return False
            End If
        End If

        'routing number validation
        Dim objClient As New WCFClient.Store
        If Not objClient.RoutingIsValid(txtBankRoutingNumber.Text, lblBankName.Text) Then
            DisplayError("The Bank Routing Number you entered does not validate against the Federal ACH Directory.", txtBankRoutingNumber)
            Return False
        End If

        Return True
    End Function

    Private Function GetFirstEffectiveDate() As DateTime
        Dim startDate As Nullable(Of DateTime) = DataHelper.Nz_ndate(txtStartDate.Text)
        Dim day As Integer = ddlDepositDay.SelectedValue.Replace("Day", "")
        If day > DateTime.DaysInMonth(startDate.Value.Year, startDate.Value.Month) Then day = DateTime.DaysInMonth(startDate.Value.Year, startDate.Value.Month)
        Return New Date(startDate.Value.Year, startDate.Value.Month, day)
    End Function

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        If RequiredExist() Then
            If areThereOverLaps() = False Then ' Or Action <> "a"
                InsertOrUpdate()
                Close()
            End If

        End If
    End Sub
    Private Sub saveBank()
        Dim bankID As Integer = MultiDepositHelper.InsertClientBank(ClientID, txtBankRoutingNumber.Text, txtBankAccountNumber.Text, cboBankType.SelectedItem.Value, UserID)
     
    End Sub

    Private Function areThereOverLaps() As Boolean

        Select Case bMulti
            Case True
                Dim bAreThereOverLaps As Boolean = False
                Dim dv As New HtmlGenericControl("div class=""warning"" width=""60%"" ")

                Dim startDate As Nullable(Of DateTime) = DataHelper.Nz_ndate(txtStartDate.Text)
                If startDate.HasValue Then
                    startDate = New DateTime(startDate.Value.Year, startDate.Value.Month, 1)
                End If
                Dim endDate As Nullable(Of DateTime) = DataHelper.Nz_ndate(txtEndDate.Text)
                If endDate.HasValue Then
                    endDate = New DateTime(endDate.Value.Year, endDate.Value.Month, DateTime.DaysInMonth(endDate.Value.Year, endDate.Value.Month))
                End If

                'get deposit ids from chklist
                phRuleOverlaps.Controls.Clear()
                Dim tbl As New Table
                tbl.Style("width") = "75%"
                tbl.Style("class") = "entry"
                tbl.Style("margin") = "25px"
                tbl.CellPadding = 0
                tbl.CellSpacing = 0

                Dim hRow As TableHeaderRow = Nothing
                Dim hCell As TableHeaderCell = Nothing
                Dim tRow As TableRow = Nothing
                Dim tCell As TableCell = Nothing

                'got overlaps if dt has rows
                Dim dtOver As DataTable = MultiDepositHelper.getMultiDepositRuleOverlaps(startDate, endDate, ddlClientDepositID.SelectedItem.Value, RuleACHID)
                If dtOver.Rows.Count >= 1 Then
                    bAreThereOverLaps = True
                    'only add heeader row once
                    If hRow Is Nothing Then

                        Dim sbOverlap As New StringBuilder

                        sbOverlap.Append("<span style=""margin-left:25px; margin-top:10px; font-size:12px;"">")
                        sbOverlap.Append("The following rules overlap:")
                        sbOverlap.Append("</span></br>")

                        dv.Controls.Add(New LiteralControl(sbOverlap.ToString))
                        hRow = New TableHeaderRow
                        hCell = New TableHeaderCell
                        For Each c As DataColumn In dtOver.Columns
                            If "StartDate,EndDate,DepositAmount,DepositDay".Contains(c.ColumnName) = True Then
                                hCell = New TableHeaderCell
                                hCell.CssClass = "headItem5"
                                Select Case c.ColumnName
                                    Case "StartDate", "EndDate"
                                        hCell.HorizontalAlign = HorizontalAlign.Left
                                    Case "DepositAmount"
                                        hCell.HorizontalAlign = HorizontalAlign.Right
                                    Case "DepositDay"
                                        hCell.HorizontalAlign = HorizontalAlign.Center
                                End Select
                                hCell.Text = InsertSpaceAfterCap(c.ColumnName)
                                hRow.Cells.Add(hCell)
                            End If
                        Next
                        tbl.Rows.Add(hRow)
                    End If
                    'add to ph
                    For Each over As DataRow In dtOver.Rows
                        tRow = New TableRow
                        tRow.Style("cursor") = "hand"
                        tRow.Attributes.Add("onmouseover", "this.style.backgroundColor = '#f5f5f5';")
                        tRow.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                        tRow.CssClass = "entry2"
                        For Each c As DataColumn In over.Table.Columns
                            If "StartDate,EndDate,DepositAmount,DepositDay".Contains(c.ColumnName) = True Then
                                tCell = New TableCell
                                tCell.CssClass = "listItem"
                                Select Case c.ColumnName
                                    Case "StartDate", "EndDate"
                                        tCell.HorizontalAlign = HorizontalAlign.Left
                                        tCell.Text = FormatDateTime(over(c.ColumnName).ToString, DateFormat.ShortDate)
                                    Case "DepositAmount"
                                        tCell.HorizontalAlign = HorizontalAlign.Right
                                        tCell.Text = FormatCurrency(over(c.ColumnName).ToString, 2, TriState.True, TriState.False, TriState.True)
                                    Case "DepositDay"
                                        tCell.HorizontalAlign = HorizontalAlign.Center
                                        tCell.Text = over(c.ColumnName).ToString
                                    Case Else
                                        tCell.Text = over(c.ColumnName).ToString
                                End Select

                                tRow.Cells.Add(tCell)
                            End If
                        Next
                        tbl.Rows.Add(tRow)


                    Next
                End If

                If tbl.Rows.Count > 0 Then
                    dv.Controls.Add(tbl)
                    phRuleOverlaps.Controls.Add(dv)
                End If

                Return bAreThereOverLaps

            Case Else
                Return False

        End Select

    End Function

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        'delete check to print
        Select Case bMulti
            Case False
                DataHelper.Delete("tblRuleACH", "RuleACHId = " & RuleACHID)
            Case True
                DataHelper.Delete("tblDepositRuleAch", "RuleACHId = " & RuleACHID)
        End Select

        'drop back to ach
        Close()

    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub

    Public Overrides ReadOnly Property BaseQueryString() As String
        Get
            Return "ruleachid"
        End Get
    End Property

    Public Overrides ReadOnly Property BaseTable() As String
        Get
            Return "tblRuleACH"
        End Get
    End Property

    Protected Sub ddlBankName_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlBankName.SelectedIndexChanged
        trAccountDisabled.Style("Display") = "None"
        Select Case ddlBankName.SelectedItem.Value
            Case "add"
                txtBankAccountNumber.Text = String.Empty
                txtBankRoutingNumber.Text = String.Empty
                cboBankType.SelectedIndex = 0

                txtBankAccountNumber.Enabled = True
                txtBankRoutingNumber.Enabled = True
                cboBankType.Enabled = True

            Case "select"
                txtBankAccountNumber.Text = String.Empty
                txtBankRoutingNumber.Text = String.Empty
                cboBankType.SelectedIndex = 0
                lblBankName.Visible = False
            Case Else
                Dim sqlBank As String = String.Format("Select * from tblClientBankAccount where BankAccountID = {0}", ddlBankName.SelectedItem.Value)
                Dim dtBank As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlBank, ConfigurationManager.AppSettings("connectionstring").ToString)
                For Each bank As DataRow In dtBank.Rows
                    txtBankAccountNumber.Text = bank("AccountNumber")
                    txtBankRoutingNumber.Text = bank("RoutingNumber")
                    ListHelper.SetSelected(cboBankType, bank("BankType"))

                    If txtBankAccountNumber.Text.ToString <> "" Then
                        txtBankAccountNumber.Enabled = False
                        txtBankRoutingNumber.ReadOnly = True
                    Else
                        txtBankAccountNumber.Enabled = True
                        txtBankRoutingNumber.ReadOnly = False
                    End If
                    txtBankRoutingNumber.Enabled = False
                    cboBankType.Enabled = False
                    If Not bank("Disabled") Is DBNull.Value Then trAccountDisabled.Style("Display") = "block"
                    Exit For
                Next
                lblBankName.Visible = False
        End Select


    End Sub

    Protected Sub txtBankRoutingNumber_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtBankRoutingNumber.TextChanged
        If DirectCast(sender, TextBox).Text.Length = 9 And ddlBankName.SelectedItem.Value = "add" Then
            Dim sSQL As String = String.Format("Select CustomerName from tblroutingNumber where routingnumber = {0}", txtBankRoutingNumber.Text)

            lblBankName.Visible = True
            lblBankName.Style("padding-top") = "10px"
            lblBankName.Text = SharedFunctions.AsyncDB.executeScalar(sSQL, ConfigurationManager.AppSettings("connectionstring").ToString)
        End If
    End Sub
    Private Function InsertSpaceAfterCap(ByVal strToChange As String) As String
        Dim sChars() As Char = strToChange.ToCharArray()
        Dim strNew As String = ""
        For Each c As Char In sChars
            Select Case Asc(c)
                Case 65 To 95, 49 To 57   'upper caps or numbers
                    strNew += Space(1) & c.ToString
                Case 97 To 122  'lower caps
                    strNew += c.ToString
                Case Else
                    strNew += Space(1) & c.ToString
            End Select
        Next
        strNew = strNew.Replace("I D", "ID")
        Return strNew.Trim
    End Function

    Private Function GetLastDateUsed() As Nullable(Of DateTime)
        Dim d As New Nullable(Of DateTime)
        Dim dt As DataTable
        Dim tablename As String
        If bMulti Then
            tablename = "tbldepositruleach"
            dt = MultiDepositHelper.GetMultiDepositsForRule(RuleACHID)
            If dt.Rows.Count = 0 Then
                Dim oldRuleId As Integer = Val(Drg.Util.DataAccess.DataHelper.FieldLookup("tblDepositRuleACh", "OldRuleId", "RuleACHId = " & RuleACHID))
                If oldRuleId > 0 Then
                    tablename = "tblruleach"
                    dt = MultiDepositHelper.GetDepositsForRule(oldRuleId)
                End If
            End If
        Else
            tablename = "tblruleach"
            dt = MultiDepositHelper.GetDepositsForRule(RuleACHID)
        End If
        If dt.Rows.Count > 0 Then
            d = dt.Rows(0)("LastDateUsed")
        Else
            'Check for zero dollar rule in effect last month
            If DataHelper.FieldLookup(tablename, "ruleachid", String.Format("DepositAmount = 0 and ruleachid = {0} and startdate < cast('{1}' as datetime) and created < cast('{1}' as datetime)", RuleACHID, New DateTime(Now.Year, Now.Month, 1).ToShortDateString)).Trim.Length > 0 Then
                d = New DateTime(Now.Year, Now.Month, 1).AddDays(-1)
            End If
        End If
        Return d
    End Function

    Private Function SimilarRulesUsed() As Boolean
        Dim dt As DataTable
        If bMulti Then
            Return False
        Else
            Dim startDate As String = txtStartDate.Text.Substring(3, 4) & txtStartDate.Text.Substring(0, 2)
            Dim enddate As String = txtEndDate.Text.Substring(3, 4) & txtEndDate.Text.Substring(0, 2)
            dt = MultiDepositHelper.GetScheduledDepositsPosted(ClientID, startDate, enddate)
        End If
        Return dt.Rows.Count > 0
    End Function
End Class
