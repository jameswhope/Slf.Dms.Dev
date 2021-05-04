Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Imports MultiDepositHelper

Partial Class clients_client_finances_ach_checkrule
    Inherits EntityPage

    Private Enum RuleStatusType
        Expired = 0
        Current = 1
        Future = 2
    End Enum

#Region "Variables"

    Private Action As String
    Private RulecheckID As Integer
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Private ruleStatus As RuleStatusType = RuleStatusType.Current
    Private bMulti As Boolean = False

    Public UserID As Integer
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            ClientID = DataHelper.Nz_int(qs("id"), 0)
            RulecheckID = DataHelper.Nz_int(qs("rulecheckid"), 0)
            Action = DataHelper.Nz_string(qs("a"))
            bMulti = MultiDepositHelper.IsMultiDepositClient(ClientID)

            If Not IsPostBack Then
                LoadMulti()
                SetDefaults()
                HandleAction()
            End If

            SetRollups()


        End If

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
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#""" & IIf(ruleStatus = RuleStatusType.Expired Or (hdnLastUsed.Value.Trim.Length > 0), " disabled ", " onclick=""Record_DeleteConfirm();return false;"" ") & "><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this rule</a>")
            End If

            'add normal tasks

        End If

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkFinances.HRef = "~/clients/client/finances/?id=" & ClientID
        lnkcheck.HRef = "~/clients/client/finances/ach/?id=" & ClientID

    End Sub

    Private Sub HandleAction()

        Select Case Action
            Case "a"    'add
                lblcheckRule.Text = "Add New Rule"
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
            LoadDepositDays(ddlClientDepositID.SelectedItem.Text)
        Else
            LoadDepositDays(1)
        End If
    End Sub
    Private Sub LoadRecord()
        Dim enableBank As Boolean = True
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        If bMulti = False Then
            cmd.CommandText = "SELECT ra.*, left(u.firstname, 1) + '. ' + u.lastname [uCreatedBy], LEFT(u1.FirstName,1) + '. ' + u1.LastName [uLastModifiedBy], ra.Created, ra.LastModified FROM tblRulecheck ra join tbluser u on u.userid = ra.createdby join tbluser u1 on u1.userid = ra.lastmodifiedby WHERE RulecheckId = @RulecheckId"
            DatabaseHelper.AddParameter(cmd, "RulecheckId", RulecheckID)
            Try
                cmd.Connection.Open()
                rd = cmd.ExecuteReader(CommandBehavior.SingleRow)
                If rd.Read() Then
                    lblcheckRule.Text = "Rule " & DatabaseHelper.Peel_int(rd, "RulecheckId")
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
                    ListHelper.SetSelected(ddlDepositDay, DatabaseHelper.Peel_int(rd, "DepositDay"))
                    ruleStatus = GetRuleStatus(rd("StartDate"), EndDate)
                    If Not rd("DateUsed") Is DBNull.Value Then hdnLastUsed.Value = rd("DateUsed")
                End If
            Finally
                DatabaseHelper.EnsureReaderClosed(rd)
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try
        Else
            Dim rule As DataRow = MultiDepositHelper.getMultiDepositRuleByCheckRuleID(RulecheckID)
            If rule IsNot Nothing Then
                lblcheckRule.Text = "Rule " & rule("RulecheckId")
                txtDepositAmount.Text = rule("DepositAmount")
                txtStartDate.Text = Format(rule("StartDate"), "MM/yyyy")
                lblCreated.Text = Format(rule("Created"), "MM/dd/yyyy")
                lblCreatedBy.Text = rule("uCreatedBy")
                lblModified.Text = Format(rule("LastModified"), "MM/dd/yyyy")
                lblModifiedBy.Text = rule("uLastModifiedBy")
                Dim EndDate As Nullable(Of DateTime) = rule("EndDate")
                ListHelper.SetSelected(ddlDepositDay, rule("DepositDay"))
                ListHelper.SetSelected(ddlClientDepositID, rule("ClientDepositID"))
                ruleStatus = GetRuleStatus(rule("StartDate"), EndDate)
                If Not rule("DateUsed") Is DBNull.Value Then hdnLastUsed.Value = rule("DateUsed")
            End If
        End If
        DisableFromEdit()
    End Sub

    Private Sub DisableFromEdit()
        Dim LastUsed As Boolean = (hdnLastUsed.Value.Trim.Length > 0)
        Me.txtStartDate.Enabled = ruleStatus <> RuleStatusType.Expired And Not LastUsed
        Me.ddlClientDepositID.Enabled = ruleStatus <> RuleStatusType.Expired And Not LastUsed
        Me.ddlDepositDay.Enabled = ruleStatus <> RuleStatusType.Expired And Not LastUsed
        Me.txtDepositAmount.Enabled = ruleStatus <> RuleStatusType.Expired And Not LastUsed
        If ruleStatus = RuleStatusType.Expired Or LastUsed Then
            'lnkSetToNowStart.Attributes.Add("disabled", "true")
            'lnkSetToNowStart.Attributes.Add("onclick", "return false;")
        End If
        'If ruleStatus = RuleStatusType.Expired Then
        '    lnkSetToNowEnd.Attributes.Add("disabled", "true")
        '    lnkSetToNowEnd.Attributes.Add("onclick", "return false;")
        'End If
        If txtDepositAmount.Text <> 0 And LastUsed Then
            Me.lblLastUsed.Text = "Last time this rule was used: " & CDate(hdnLastUsed.Value).ToShortDateString
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
                        ruleTable = "tblRulecheck"
                        clientIDType = "ClientID"
                        clientIDTypeValue = ClientID

                    Case True
                        ruleTable = "tblDepositRulecheck"
                        clientIDType = "ClientDepositID"
                        clientIDTypeValue = ddlClientDepositID.SelectedItem.Value
                End Select

                DatabaseHelper.AddParameter(cmd, "DepositAmount", DataHelper.Nz_double(txtDepositAmount.Text))

                Dim startDate As Nullable(Of DateTime) = DataHelper.Nz_ndate(txtStartDate.Text)
                If startDate.HasValue Then
                    startDate = New DateTime(startDate.Value.Year, startDate.Value.Month, 1)
                End If
                Dim endDate As Nullable(Of DateTime) = DataHelper.Nz_ndate(txtStartDate.Text)
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
                    DatabaseHelper.BuildInsertCommandText(cmd, ruleTable, "RulecheckId", SqlDbType.Int)
                Else 'edit
                    DatabaseHelper.BuildUpdateCommandText(cmd, ruleTable, "RulecheckId = " & RulecheckID)
                End If
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

            End Using

            If Action = "a" Then 'add
                RulecheckID = DataHelper.Nz_int(cmd.Parameters("@RulecheckId").Value)
            End If
        End Using

        Return RulecheckID

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
        Dim LastUsed As Boolean = (hdnLastUsed.Value.Trim.Length > 0)
        Dim endDate As Nullable(Of DateTime) = DataHelper.Nz_ndate(txtStartDate.Text)

        If LastUsed Then
            'Do not allow to save the enddate a previous end date
            If endDate.HasValue Then
                endDate = New DateTime(endDate.Value.Year, endDate.Value.Month, DateTime.DaysInMonth(endDate.Value.Year, endDate.Value.Month))
            End If
            Dim LastUsedDate As DateTime = New Date(Year(hdnLastUsed.Value), Month(hdnLastUsed.Value), 1)
            If endDate < LastUsedDate Then
                DisplayError("This rule has been used so the end date cannot be changed to before " & LastUsedDate.ToShortDateString, txtStartDate)
                Return False
            End If
        End If

        'Check to see if first time rule is prior the next deposit business date
        If Action = "a" OrElse Not LastUsed Then
            Try
                Dim NextBusDate As String = LocalHelper.AddBusinessDays(Now, 1).ToString("MM/dd/yyyy")
                Dim startDate As Nullable(Of DateTime) = DataHelper.Nz_ndate(txtStartDate.Text)
                Dim compStartDate As DateTime = GetFirstEffectiveDate()
                If compStartDate < CDate(NextBusDate) Then Throw New Exception("The rule you are creating or changing must be any date after " & NextBusDate)
            Catch ex As Exception
                DisplayError(ex.Message, ddlDepositDay)
                Return False
            End Try
        End If

        'Check if there are rules used that match the new rule to add.
        If Action = "a" Then
            If LastUsed Then
                DisplayError("There is a similar rule already used for the current month. Try changing the date range", txtStartDate)
                Return False
            End If
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
    
    Private Function areThereOverLaps() As Boolean

        Select Case bMulti
            Case True
                Dim bAreThereOverLaps As Boolean = False
                Dim dv As New HtmlGenericControl("div class=""warning"" width=""60%"" ")

                Dim startDate As Nullable(Of DateTime) = DataHelper.Nz_ndate(txtStartDate.Text)
                If startDate.HasValue Then
                    startDate = New DateTime(startDate.Value.Year, startDate.Value.Month, 1)
                End If
                Dim endDate As Nullable(Of DateTime) = DataHelper.Nz_ndate(txtStartDate.Text)
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
                Dim dtOver As DataTable = MultiDepositHelper.getMultiDepositCheckRuleOverlaps(startDate, endDate, ddlClientDepositID.SelectedItem.Value, RulecheckID)
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
                DataHelper.Delete("tblRulecheck", "RulecheckId = " & RulecheckID)
            Case True
                DataHelper.Delete("tblDepositRulecheck", "RulecheckId = " & RulecheckID)
        End Select

        'drop back to check
        Close()

    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub

    Public Overrides ReadOnly Property BaseQueryString() As String
        Get
            Return "rulecheckid"
        End Get
    End Property

    Public Overrides ReadOnly Property BaseTable() As String
        Get
            Return "tblRulecheck"
        End Get
    End Property

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

     
End Class
