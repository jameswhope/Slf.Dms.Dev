Option Explicit On
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO

Imports GrapeCity.ActiveReports
Imports GrapeCity.ActiveReports.Export.Pdf

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports LexxiomLetterTemplates

Partial Class clients_client_reports_Default
    Inherits PermissionPage

    #Region "Fields"

    Private LexxiomReports As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionString").ToString)
    Private _IsManager As Boolean = False
    Private _PerAcctServiceFee As String
    Private _MaxServiceFeeAmt As String
    #End Region 'Fields

    #Region "Properties"

    Public Property CreditorAccountID() As String
        Get
            Return ViewState("CreditorAccountID")
        End Get
        Set(ByVal value As String)
            ViewState("CreditorAccountID") = value
        End Set
    End Property

    Public Property IsManager() As Boolean
        Get
            Return ViewState("IsManager")
        End Get
        Set(ByVal value As Boolean)
            ViewState("IsManager") = value
        End Set
    End Property

    Public Property UserID() As String
        Get
            Return ViewState("UserID")
        End Get
        Set(ByVal value As String)
            ViewState("UserID") = value
        End Set
    End Property

    Property DataClientID() As String
        Get
            Return ViewState("DataClientID")
        End Get
        Set(ByVal value As String)
            ViewState("DataClientID") = value
        End Set
    End Property

    Public Property AgencyID() As String
        Get
            Return ViewState("AgencyID")
        End Get
        Set(ByVal value As String)
            ViewState("AgencyID") = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        DataClientID = Request.QueryString("id")

        Dim dtTypes As DataTable
        If Not IsPostBack Then
            SetProperties()

            AgencyID = SharedFunctions.AsyncDB.executeScalar(String.Format("select isnull(agencyid,-1) from tblclient where clientid = {0}", DataClientID), ConfigurationManager.AppSettings("connectionstring").ToString)
            LoadCreditors()
            LoadSettlements()
            LoadLocalCounsel()
            LoadNonDepositReasons()
            storeReportArray()

            If sortDir.Value = "" Then
                sortDir.Value = "ASC"
            End If

            lstCreditorInstances.SelectedIndex = 0

            lnkClient.InnerText = ClientHelper.GetDefaultPersonName(Master.DataClientID)
            lnkClient.HRef = String.Format("~/clients/client/?id={0}", Master.DataClientID)

            Dim sqlMan As String = String.Format("Select Manager from tbluser where userid = {0}", UserID)
            IsManager = SharedFunctions.AsyncDB.executeScalar(sqlMan, ConfigurationManager.AppSettings("connectionstring").ToString)

        End If
        SetRollups()

        If ViewState("gridData") Is Nothing Then
            dtTypes = LexxiomReports.getReportTypes()
            ViewState("gridData") = dtTypes
        Else
            dtTypes = ViewState("gridData")
        End If

        'only show litigation reports certain groups
        Select Case UserHelper.GetUserRole(UserID)
            Case 3, 6, 11, 20, 30, 36, 37, 38, 39, 40, 41, 50, 27


            Case Else
                Dim lit As DataRow() = dtTypes.Select("ReportType Like 'Litigation%'")
                For Each dr As DataRow In lit
                    dtTypes.Rows.Remove(dr)
                Next
        End Select

        acReports.EnableViewState = True
        dtTypes.DefaultView.Sort = "ReportOrder asc"
        acReports.DataSource = dtTypes.DefaultView
        acReports.DataBind()
    End Sub

    Protected Sub acReports_ItemDataBound(ByVal sender As Object, ByVal e As AjaxControlToolkit.AccordionItemEventArgs) Handles acReports.ItemDataBound
        Select Case e.ItemType
            Case AccordionItemType.Content
                Dim rowView As DataRowView = CType(e.Item, DataRowView)

                Dim childGV As GridView = e.AccordionItem.FindControl("gvReportsChildren")
                AddHandler childGV.RowDataBound, AddressOf childGrid_RowDataBound
                AddHandler childGV.RowCreated, AddressOf childGrid_RowCreated

                Using dt As DataTable = LexxiomReports.BuildReportsDataTable(rowView("ReportType").ToString, DataClientID)
                    childGV.DataSource = dt
                    childGV.DataBind()
                End Using

                Dim childRowsCount As Integer = childGV.Rows.Count
                Dim s As HtmlGenericControl = e.AccordionItem.Parent.FindControl("spnHdr")
                Dim tempText As String = s.InnerText
                tempText = InsertSpaceAfterCap(tempText)
                s.InnerText = tempText.Replace(":", String.Format(" Templates ({0})", childRowsCount))
                
        End Select
    End Sub

    Protected Sub childGrid_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        e.Row.Cells(3).Visible = False
    End Sub
    ''' <summary>
    ''' Primary function doing actions to report rows
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub childGrid_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#f5f5f5';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                e.Row.Attributes.Add("id", String.Format("{0}_{1}", rowView("ReportType").ToString, rowView("ReportTypeName").ToString))

                Dim args As String() = rowView("ReportArguments").ToString().Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
                Dim reqs As String() = rowView("RequiredFieldsList").ToString().Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
                Dim argControl As Control = BuildArgTable(rowView("ReportType").ToString, args, rowView("ReportTypeName").ToString, reqs)
                phArgs.Controls.Add(argControl)

                Dim chk As System.Web.UI.WebControls.CheckBox = e.Row.FindControl("chk_select")
                Dim bCredNeeded As Boolean = False
                If Array.IndexOf(args, "CreditorInstanceIDsCommaSeparated") <> -1 Then
                    bCredNeeded = True
                End If
                Dim bSettlementsNeeded As Boolean = False
                If Array.IndexOf(args, "SettlementID") <> -1 Then
                    bSettlementsNeeded = True
                End If
                Dim bLocalCounselNeeded As Boolean = False
                If Array.IndexOf(args, "LocalCounselAttorneyID") <> -1 Then
                    bLocalCounselNeeded = True
                End If
                Dim bReasonNeeded As Boolean = False
                If Array.IndexOf(args, "ReasonID") <> -1 Then
                    bReasonNeeded = True
                End If

                chk.Attributes.Add("onclick", String.Format("chk_Select(this,'{0}','{1}','{2}','{3}','{4}');", argControl.ClientID, bCredNeeded, bSettlementsNeeded, bLocalCounselNeeded, bReasonNeeded))
                '"chk_Select(this,'" & argControl.ClientID & "','" & bCredNeeded & "','" & bSettlementsNeeded & "','" & bLocalCounselNeeded & "','" & bReasonNeeded + "'");")


                Dim compID As Integer = 0
                Dim clientStateID As Integer = 0

                Integer.TryParse(DataHelper.FieldLookup("tblClient", "Companyid", "Clientid = " & DataClientID), compID)
                Integer.TryParse(DataHelper.FieldLookup("tblperson", "stateid", "Personid = " & ClientHelper.GetDefaultPerson(DataClientID)), clientStateID)

                If rowView("ReportTypeName").ToLower = "BankingWithCreditorLetter".ToLower Or rowView("ReportTypeName").ToLower = "UtilityPhoneServiceLetter".ToLower Then
                    Select Case compID
                        Case 4, 6
                            chk.Enabled = True
                        Case Else
                            chk.Enabled = False
                    End Select
                End If
                If rowView("ReportTypeName").ToLower = "MosslerTransferPKGCT".ToLower Then
                    Select Case compID
                        Case 4
                            chk.Enabled = True
                        Case Else
                            chk.Enabled = False
                    End Select
                End If
                '10.7.09.ug
                'disable Pay Off LetterPer Ron F.
                If rowView("ReportTypeName").ToLower = "PayOffLetter".ToLower AndAlso IsManager = False Then
                    chk.Enabled = False
                End If

                If rowView("ReportTypeName").ToLower = "LitigationLSAAddendum".ToLower Then
                    Select Case clientStateID
                        Case 33
                            chk.Enabled = True
                        Case Else
                            chk.Enabled = False
                    End Select
                End If

                '**********************************
                Select Case rowView("ReportTypeName").ToLower
                    Case "LegalServiceAgreement".ToLower, "SettlementDepositAccountAgreement".ToLower, "LegalServiceAgreementOnlyScheduleA".ToLower, _
                    "TruthInServiceDisclosureStatement".ToLower, "FeeAddendum".ToLower
                        If AgencyID = "856" Then
                            chk.Enabled = True
                        Else
                            chk.Enabled = False
                        End If

                End Select

            Case DataControlRowType.Header
                Dim chk As HtmlInputCheckBox = e.Row.FindControl("chk_selectAll")
                chk.Attributes.Add("onclick", String.Format("GridCheckAll(this,'{0}');", e.Row.Parent.Parent.ClientID))
        End Select
    End Sub

    Protected Sub clients_client_reports_Default_Disposed(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Disposed
        LexxiomReports = Nothing
    End Sub

    Protected Sub lnkView_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrint.Click
        Dim ListOfReports As Dictionary(Of String, List(Of String))
        Dim finalReport As New SectionReport
        'if page is valid continue
        If Page.IsValid Then
            'get list of selected reports
            ListOfReports = getReports
            If ListOfReports.Count = 0 Then
                divMsg.InnerHtml = "Please select at least 1 report!"
                divMsg.Attributes("class") = "error"
                divMsg.Style("display") = "block"
                Exit Sub
            Else
                divMsg.InnerHtml = ""
                divMsg.Attributes("class") = ""
                divMsg.Style("display") = "none"
            End If

            Dim viewRpt As New StringBuilder

            For Each kvp As KeyValuePair(Of String, List(Of String)) In ListOfReports
                'get report name
                Select Case kvp.Key
                    Case "SettlementAcceptanceForm"
                        viewRpt.Append(kvp.Key)
                    Case Else
                        viewRpt.Append(kvp.Key & "_")
                End Select
                'get report arguments
                For i As Integer = 0 To kvp.Value.Count - 1
                    viewRpt.Append("_" & kvp.Value(i).ToString)
                Next

                viewRpt.Append("|")
            Next

            'show report
            Dim queryString As String = String.Format("report.aspx?clientid={0}&reports={1}&user={2}", DataClientID, viewRpt.ToString.Substring(0, viewRpt.Length - 1).Replace("__", "_"), UserID)
            Dim frm As HtmlControl = TryCast(dvReport.FindControl("frmReport"), HtmlControl)
            frm.Attributes("src") = queryString

            programmaticModalPopup.Show()
        End If
    End Sub

    Private Function AddCreditorArgumentSelection(ByVal ClientIDOfClient As String, ByVal ArgumentName As String, ByVal TypeOfReport As String, Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell
        Dim lbl As New LiteralControl(BuildLabelText("Select Creditor"))
        cell.Controls.Add(lbl)

        Dim ctl As New ListBox() With {.ID = "__tblCreditorInstances", .CssClass = "entry2", .Height = "150", .SelectionMode = ListSelectionMode.Multiple}

        Dim sqlCred As String = String.Format("stp_LetterTemplates_GetClientCreditors {0}", DataClientID)
        Dim creds As DataTable = LetterTemplates.GetDataTable(sqlCred)
        For Each crow As DataRow In creds.Rows
            ctl.Items.Add(New ListItem(String.Format("{0} ({1})", crow("Name").ToString, crow("AcctLast4").ToString), crow("CurrentCreditorInstanceID")))
        Next
        creds.Dispose()
        creds = Nothing
        ctl.Style("width") = "100%"
        ctl.EnableViewState = True
        cell.Controls.Add(ctl)

        If IsRequired = True Then
            Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = ctl.ClientID, .ErrorMessage = "Select at least (1) Creditor!"}
            cell.Controls.Add(rfv)
        End If
        row.Cells.Add(cell)
        Return row
    End Function

    Private Function AddCurrencyBoxArgument(ByVal ArgumentName As String, ByVal TypeOfReport As String, Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText(ArgumentName))
        cell.Controls.Add(lbl)

        Dim ctl As New System.Web.UI.WebControls.TextBox() With {.CssClass = "entry2", .ID = "__" & TypeOfReport & "_txt_" & ArgumentName, .Text = "0.00"}
        ctl.Attributes.Add("onfocus", "this.select();")
        cell.Controls.Add(ctl)
        Dim ftExt As New AjaxControlToolkit.FilteredTextBoxExtender() With {.TargetControlID = ctl.ClientID, .ID = "curExt_" & ctl.ClientID, .FilterType = FilterTypes.Custom, .ValidChars = "1234567890."}
        cell.Controls.Add(ftExt)
        AddRequiredField(ArgumentName, IsRequired, cell, ctl)
        cell.Style("width") = "100%"

        row.Cells.Add(cell)

        Return row
    End Function

    Private Function AddDateBoxArgument(ByVal ArgumentName As String, ByVal TypeOfReport As String, Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText(ArgumentName))
        cell.Controls.Add(lbl)

        Dim ctl As New System.Web.UI.WebControls.TextBox() With {.CssClass = "entry2", .ID = "__" & TypeOfReport & "_txt_" & ArgumentName, .Text = FormatDateTime(Now, DateFormat.ShortDate)}
        cell.Controls.Add(ctl)
        Dim calExt As New AjaxControlToolkit.CalendarExtender() With {.TargetControlID = ctl.ClientID, .ID = "dateExt_" & ctl.ClientID}
        cell.Controls.Add(calExt)

        AddRequiredField(ArgumentName, IsRequired, cell, ctl)

        cell.Style("width") = "100%"
        row.Cells.Add(cell)

        Return row
    End Function

    Private Function AddNumberTextBoxArgument(ByVal ArgumentName As String, ByVal TypeOfReport As String, Optional ByVal TextMode As TextBoxMode = TextBoxMode.SingleLine, Optional ByVal TextBoxValue As String = Nothing, Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText(ArgumentName))
        cell.Controls.Add(lbl)

        Dim ctl As New System.Web.UI.WebControls.TextBox() With {.CssClass = "entry2", .ID = "__" & TypeOfReport & "_txt_" & ArgumentName}
        If TextBoxValue IsNot Nothing Then
            ctl.ToolTip = TextBoxValue
        Else
            ctl.ToolTip = ArgumentName
        End If
        ctl.TextMode = TextMode
        If TextMode = TextBoxMode.MultiLine Then
            ctl.Style("height") = "75px"
        End If
        ctl.Style("width") = "75%"
        ctl.Attributes.Add("onkeypress", "return isNumberKey(event);")
        cell.Controls.Add(ctl)
        AddRequiredField(ArgumentName, IsRequired, cell, ctl)

        row.Cells.Add(cell)

        Return row
    End Function

    Private Sub AddRequiredField(ByVal ArgumentName As String, ByVal IsRequired As Boolean, ByVal cell As TableCell, ByVal ctl As System.Web.UI.WebControls.TextBox)
        If IsRequired = True Then
            Dim litBR As New LiteralControl("<BR/>")
            cell.Controls.Add(litBR)
            Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = ctl.ClientID, .ErrorMessage = InsertSpaceAfterCap(ArgumentName) & " is Required!"}
            cell.Controls.Add(rfv)
        End If
    End Sub

    Private Function AddTelBoxArgument(ByVal ArgumentName As String, ByVal TypeOfReport As String, Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText(ArgumentName))
        cell.Controls.Add(lbl)

        Dim ctl As New System.Web.UI.WebControls.TextBox() With {.CssClass = "entry2", .ID = "__" & TypeOfReport & "_txt_" & ArgumentName, .Text = "__________"}
        cell.Controls.Add(ctl)
        Dim calExt As New AjaxControlToolkit.MaskedEditExtender() With {.TargetControlID = ctl.ClientID, .ID = "telExt_" & ctl.ClientID, .Mask = "(999)999-9999", .ClearMaskOnLostFocus = False}
        cell.Controls.Add(calExt)

        AddRequiredField(ArgumentName, IsRequired, cell, ctl)
        cell.Style("width") = "100%"

        row.Cells.Add(cell)

        Return row
    End Function

    Private Function AddTextBoxArgument(ByVal ArgumentName As String, ByVal TypeOfReport As String, Optional ByVal TextMode As TextBoxMode = TextBoxMode.SingleLine, Optional ByVal TextBoxValue As String = Nothing, Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText(ArgumentName))
        cell.Controls.Add(lbl)

        Dim ctl As New System.Web.UI.WebControls.TextBox() With {.CssClass = "entry2", .ID = "__" & TypeOfReport & "_txt_" & ArgumentName}
        If TextBoxValue IsNot Nothing Then
            ctl.ToolTip = TextBoxValue
        Else
            ctl.ToolTip = ArgumentName
        End If
        ctl.TextMode = TextMode
        If TextMode = TextBoxMode.MultiLine Then
            ctl.Style("height") = "75px"
        End If
        ctl.Style("width") = "85%"
        cell.Controls.Add(ctl)
        AddRequiredField(ArgumentName, IsRequired, cell, ctl)

        row.Cells.Add(cell)

        Return row
    End Function
    Private Function AddTextBoxArgumentWithSampleText(ByVal ArgumentName As String, ByVal TypeOfReport As String, ByVal populateValue As String, ByVal TextMode As TextBoxMode, ByVal IsRequired As Boolean) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText(ArgumentName))
        cell.Controls.Add(lbl)

        Dim ctl As New System.Web.UI.WebControls.TextBox() With {.CssClass = "entry2", .ID = "__" & TypeOfReport & "_txt_" & ArgumentName}

        ctl.Text = populateValue
        
        ctl.TextMode = TextMode
        If TextMode = TextBoxMode.MultiLine Then
            ctl.Style("height") = "75px"
        End If
        ctl.Style("width") = "85%"
        cell.Controls.Add(ctl)
        AddRequiredField(ArgumentName, IsRequired, cell, ctl)

        row.Cells.Add(cell)

        Return row
    End Function
    
    Private Function BuildArgTable(ByVal reportGroup As String, ByVal ListofArgs As String(), ByVal rptTypeName As String, Optional ByVal listOfRequiredArgs As String() = Nothing) As Control
        Dim pnl As New Panel() With {.ID = String.Format("{0}_{1}", reportGroup, rptTypeName)}
        pnl.Style("display") = "none"

        Dim tbl As New Table() With {.CssClass = "entry", .ID = String.Format("tbl_{0}_{1}", reportGroup, rptTypeName), .BackColor = Color.LightGray, .BorderColor = Color.Gray, .BorderStyle = BorderStyle.Inset, .BorderWidth = New Unit(1)}
        tbl.Style("display") = "block"

        Dim row As TableRow = Nothing
        Dim cell As TableCell = Nothing

        For Each arg As String In ListofArgs
            Dim index As Integer
            Dim bRequired As Boolean = False
            index = Array.IndexOf(listOfRequiredArgs, arg)
            If index <> -1 Then
                bRequired = True
            End If

            Select Case arg.ToLower
                Case "bisthisacopy"

                Case "clientid"
                    'hide client prompt
                Case "MissingInfoReasonCode".ToLower
                    row = BuildVerificationReasonsList(New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionString").ToString))
                Case "CreditorInstanceIDsCommaSeparated".ToLower
                    'Dim ctl As ListBox = phArgs.FindControl("__tblCreditorInstances")
                    'If ctl Is Nothing Then
                    '    row = AddCreditorArgumentSelection(DataClientID, arg, rptTypeName, bRequired)
                    'End If
                Case "SettlementID".ToLower
                    'row = BuildSettlementList(rptTypeName, "SettlementID", bRequired)
                Case "TotalPages".ToLower, "FeePercentNumber".ToLower, "CustomerServiceRepExt".ToLower, "CompanyID".ToLower, _
                    "ClientServiceExt".ToLower, "ClientServiceRepExt".ToLower, "CustomerServiceExtenstion".ToLower
                    row = AddNumberTextBoxArgument(arg, rptTypeName, TextBoxMode.SingleLine, Nothing, bRequired)
                Case "DebtRejectionReason".ToLower
                    row = BuildDebtReasonsTable()
                Case "NewCompanyID".ToLower
                    row = BuildCompaniesTable(bRequired)
                Case "DepositMonth".ToLower
                    row = BuildMonthsTable(rptTypeName, bRequired)
                Case "DepositDay".ToLower
                    row = BuildDaysTable(rptTypeName, bRequired)
                Case "DocumentListCommaSeparated".ToLower, "Notes".ToLower
                    row = AddTextBoxArgument(arg, rptTypeName, TextBoxMode.MultiLine, IsRequired:=bRequired)
                Case "SettlementAgentFax".ToLower, "Phone".ToLower, "Fax".ToLower
                    row = AddTelBoxArgument(arg, rptTypeName, bRequired)
                Case "HasReturnedCheckFee".ToLower
                    row = BuildBooleanTable("HasReturnedCheckFee", bRequired)
                Case "BankAccountStatus".ToLower
                    row = BuildBankAccountStatusTable(bRequired)
                Case "ReturnedReason".ToLower
                    row = BuildReturnedReasonsList(bRequired)
                Case "ReasonID".ToLower
                    'row = BuildReasonsList(rptTypeName, bRequired)
                Case "AdditionalAccountFeeStatement".ToLower
                    row = BuildAdditionalAccountFeeStatementReasonList(bRequired)
                Case "LocalCounselAttorneyID".ToLower
                    'row = BuildLocalCounselTable(DataClientID, bRequired)
                Case "ClientAcctList".ToLower
                    row = AddTextBoxArgument(arg, rptTypeName, TextBoxMode.MultiLine, IsRequired:=bRequired)
                Case "BankAcctLastFour".ToLower
                    Dim bankAcct4 As String = GetClientBankAccountLastFour(DataClientID)
                    row = AddTextBoxArgumentWithSampleText(arg, rptTypeName, bankAcct4, TextBoxMode.SingleLine, bRequired)
                Case Else
                    If arg.ToLower.Contains("date") Then
                        row = AddDateBoxArgument(arg, rptTypeName, bRequired)
                    ElseIf arg.ToLower.Contains("amount") OrElse arg.ToLower.Contains("fees") OrElse arg.ToLower.Contains("costs") OrElse arg.ToLower.Contains("bal") Then
                        row = AddCurrencyBoxArgument(arg, rptTypeName, bRequired)
                    Else
                        row = AddTextBoxArgument(arg, rptTypeName, TextBoxMode.SingleLine, Nothing, bRequired)
                    End If
            End Select
            If row IsNot Nothing Then
                row.CssClass = "entry"
                tbl.Rows.Add(row)
            End If
        Next
        pnl.Controls.Add(tbl)

        Return pnl
    End Function
    Private Function GetClientBankAccountLastFour(ByVal dataClientIDToUse As Integer) As String
        Dim lastFour As String = SqlHelper.ExecuteScalar(String.Format("select right(accountnumber,4) from tblclientbankaccount where clientid = {0} order by created desc", DataClientID), CommandType.Text)
        If IsNothing(lastFour) Then
            lastFour = "XXXX"
        End If
        Return lastFour
    End Function

    Private Function BuildBankAccountStatusTable(Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText("BankAccountStatus"))
        cell.Controls.Add(lbl)

        Dim strSQL As String = "SELECT ReasonID, ReasonDesc  FROM tblLetterReasons WHERE (LetterName = 'NSFLetter')"
        Dim lst As New RadioButtonList
        'lstDebtReasons.Style("height") = "150px"
        lst.Style("width") = "100%"
        lst.ID = "arg_value_lst_BankAccountStatus"
        lst.Style("overflow") = "auto"

        lst.Font.Name = "tahoma"
        lst.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

        Using cmd As New SqlCommand(strSQL, New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString))
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        lst.Items.Add(New ListItem(reader("ReasonDesc"), CInt(reader("ReasonID"))))
                    End While
                End Using
            End Using
        End Using

        lst.SelectedIndex = 0
        cell.Controls.Add(lst)

        If IsRequired = True Then
            Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = lst.ClientID, .ErrorMessage = "Bank Account Status reason is required!"}
            cell.Controls.Add(rfv)
        End If

        row.Cells.Add(cell)

        Return row
    End Function

    Private Function BuildBooleanTable(ByVal controlName As String, Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText(controlName))
        cell.Controls.Add(lbl)

        'build dynamic table with radiobuttons to select the debt rejection reason
        Dim lstDebtReasons As New RadioButtonList() With {.ID = String.Format("arg_value_lst_{0}", controlName)}
        With lstDebtReasons
            .Font.Name = "tahoma"
            .Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")
            .Style("width") = "100%"
            .Style("overflow") = "auto"
            Dim itm As New ListItem("True")
            .Items.Add(itm)
            itm = New ListItem("False")
            itm.Selected = True
            .Items.Add(itm)
        End With
        cell.Controls.Add(lstDebtReasons)

        If IsRequired = True Then
            Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = lstDebtReasons.ClientID, .ErrorMessage = "Debt Rejection reason is Required!"}
            cell.Controls.Add(rfv)
        End If

        row.Cells.Add(cell)

        Return row
    End Function
    Private Function BuildLocalCounselTable(ByVal DataClientID As Integer, Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText("LocalCounselName") & " (Default Selected)")
        cell.Controls.Add(lbl)

        Dim d As New HtmlGenericControl("div style=""height:250px; overflow:auto; width:100%"" ")
        Dim lst As New DropDownList
        lst.Style("width") = "100%"
        lst.ID = "arg_value_lst_LocalCounselAttorneyID"
        lst.Height = 200
        lst.Style("overflow") = "auto"
        lst.Font.Name = "tahoma"
        lst.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")
        Dim ssql As New StringBuilder
        ssql.AppendFormat("select csp.attorneyid from tblclient c inner join tblperson p on p.personid = c.primarypersonid inner join tblstate s on s.stateid = p.stateid inner join tblcompanystateprimary csp on csp.companyid = c.companyid and csp.[state] = s.abbreviation where c.clientid = {0}", DataClientID)
        Dim clientLocalCounselID As Integer = SharedFunctions.AsyncDB.executeScalar(ssql.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(String.Format("stp_LetterTemplates_getLocalCounsel {0}", DataClientID), ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each drow As DataRow In dt.Rows
                Dim aName As String = drow("LocalCounselName").ToString
                Dim aid As String = drow("attorneyid").ToString
                Dim li As New ListItem(aName, aid)
                If aid = clientLocalCounselID Then
                    li.Selected = True
                End If

                lst.Items.Add(li)
            Next
        End Using

        cell.Controls.Add(lst)

        If IsRequired = True Then
            Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = lst.ClientID, .ErrorMessage = "Local Counsel Name is required!"}
            cell.Controls.Add(rfv)
        End If

        row.Cells.Add(cell)

        Return row
    End Function
    Private Function BuildDebtReasonsTable(Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText("Reason"))
        cell.Controls.Add(lbl)

        'build dynamic table with radiobuttons to select the debt rejection reason
        Dim strSQL As String = "SELECT ReasonID, ReasonDesc  FROM tblLetterReasons WHERE (LetterName = 'DebtRejectionLetter')"
        Dim lstDebtReasons As New RadioButtonList() With {.ID = "arg_value_lst_DebtRejectionReason"}
        With lstDebtReasons
            .Font.Name = "tahoma"
            .Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")
            .Style("height") = "150px"
            .Style("width") = "100%"
            .Style("overflow") = "auto"
            .CssClass = "radiobtn_list"
        End With

        Using cmd As New SqlCommand(strSQL, New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionString").ToString))
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        lstDebtReasons.Items.Add(New ListItem(reader("ReasonDesc"), CInt(reader("ReasonID"))))
                    End While
                End Using
            End Using
        End Using

        cell.Controls.Add(lstDebtReasons)

        If IsRequired = True Then
            Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = lstDebtReasons.ClientID, .ErrorMessage = "Debt Rejection reason is Required!"}
            cell.Controls.Add(rfv)
        End If

        row.Cells.Add(cell)

        Return row
    End Function

    Private Function BuildLabelText(ByVal labelText As String) As String
        Return "<div style=""padding-left:5px;width:100%;background-color:#006699;color:white;"">" & InsertSpaceAfterCap(labelText) & "</div>"
    End Function
    Private Function BuildCompaniesTable(Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell
        Dim lbl As New LiteralControl(BuildLabelText("New Company ID"))
        cell.Controls.Add(lbl)

        'build dynamic table with radiobuttons to select the debt rejection reason
        Dim lst As DropDownList = FindControl("arg_value_lst_NewCompanyID")

        If IsNothing(lst) Then

            lst = New DropDownList() With {.ID = "arg_value_lst_NewCompanyID"}
            With lst
                .Style("height") = "150px"
                .Style("width") = "100%"
                .Style("overflow") = "auto"
                .Font.Name = "tahoma"
                .Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")
            End With

            Dim sqlCompany As String = "select companyid, name from tblcompany order by companyid"
            Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlCompany, ConfigurationManager.AppSettings("connectionstring").ToString)
                For Each co As DataRow In dt.Rows
                    lst.Items.Add(New ListItem(co("name").ToString, co("companyid").ToString))
                Next
            End Using


        End If
        cell.Controls.Add(lst)

        If IsRequired = True Then
            Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = lst.ClientID, .ErrorMessage = "New Company is Required!"}
            cell.Controls.Add(rfv)
        End If

        row.Cells.Add(cell)

        Return row
    End Function
    Private Function BuildDaysTable(ByVal reportType As String, Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell
        Dim lbl As New LiteralControl(BuildLabelText("Deposit Day"))
        cell.Controls.Add(lbl)

        'build dynamic table with radiobuttons to select the debt rejection reason
        Dim lstDebtReasons As New DropDownList() With {.ID = String.Format("arg_value_{0}_lst_DepositDay", reportType)}
        With lstDebtReasons
            .Style("height") = "150px"
            .Style("width") = "100%"
            .Style("overflow") = "auto"
            .Font.Name = "tahoma"
            .Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")
        End With

        For i As Integer = 1 To 30
            lstDebtReasons.Items.Add(New ListItem(LetterTemplates.getNth(i), i))
        Next

        cell.Controls.Add(lstDebtReasons)

        If IsRequired = True Then
            Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = lstDebtReasons.ClientID, .ErrorMessage = "Day is Required!"}
            cell.Controls.Add(rfv)
        End If

        row.Cells.Add(cell)

        Return row
    End Function
    Private Function BuildMonthsTable(ByVal reportType As String, Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell
        Dim lbl As New LiteralControl(BuildLabelText("Deposit Month"))
        cell.Controls.Add(lbl)

        'build dynamic table with radiobuttons to select the debt rejection reason
        Dim lstDebtReasons As New RadioButtonList() With {.ID = String.Format("arg_value_lst_DepositMonth", reportType)}
        With lstDebtReasons
            .Style("height") = "150px"
            .Style("width") = "100%"
            .Style("overflow") = "auto"
            .Font.Name = "tahoma"
            .Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")
        End With

        For i As Integer = 1 To 12
            Dim sMonthName As String = MonthName(i, False)
            lstDebtReasons.Items.Add(sMonthName)
        Next

        cell.Controls.Add(lstDebtReasons)

        If IsRequired = True Then
            Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = lstDebtReasons.ClientID, .ErrorMessage = "Month is Required!"}
            cell.Controls.Add(rfv)
        End If

        row.Cells.Add(cell)

        Return row
    End Function
    Private Function BuildClientAccountList(Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim ht As New Hashtable
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell
        Dim lbl As New LiteralControl(BuildLabelText("SelectClientAccounts"))
        cell.Controls.Add(lbl)

        Dim cblCreditors As New ListBox
        cblCreditors.Style("height") = "150px"
        cblCreditors.Style("width") = "100%"
        cblCreditors.ID = "arg_value_lst_ClientAcctList"
        cblCreditors.SelectionMode = ListSelectionMode.Multiple
        cblCreditors.Font.Name = "tahoma"
        cblCreditors.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

        Dim sqlCred As String = String.Format("stp_LetterTemplates_GetClientCreditors {0}", DataClientID)
        Using creds As DataTable = LetterTemplates.GetDataTable(sqlCred)
            For Each crow As DataRow In creds.Rows
                If Not ht.ContainsKey(crow("Name").ToString) Then
                    Dim credName As String = crow("Name").ToString
                    Dim credDesc As String = String.Format("{0} ({1})", credName, crow("AcctLast4").ToString)
                    cblCreditors.Items.Add(New ListItem(String.Format("{0}", credDesc), credName))
                    ht.Add(credName, Nothing)
                End If

            Next
        End Using


        cell.Controls.Add(cblCreditors)

        'If IsRequired = True Then
        '    Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = cblCreditors.ClientID, .ErrorMessage = "At least one account must be selected!"}
        '    cell.Controls.Add(rfv)
        'End If

        row.Cells.Add(cell)

        Return row
    End Function
    Private Function BuildReturnedReasonsList(Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell
        Dim lbl As New LiteralControl(BuildLabelText("ReturnedReason"))
        cell.Controls.Add(lbl)

        Dim strSQL As String = "SELECT ReasonID, ReasonDesc  FROM tblLetterReasons WHERE (LetterName = 'DepositReturnedLetter')"

        Dim lstCreditors As New CheckBoxList
        lstCreditors.Style("height") = "150px"
        lstCreditors.Style("width") = "100%"
        lstCreditors.ID = "arg_value_lst_ReturnedReason"

        lstCreditors.Font.Name = "tahoma"
        lstCreditors.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

        Using cmd As New SqlCommand(strSQL, New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString))
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim reasonDesc As String = reader("ReasonDesc")
                        If reasonDesc.Contains("[!ClientName]") Then
                            Dim cName As String = PersonHelper.GetName(ClientHelper.GetDefaultPerson(DataClientID))
                            reasonDesc = reasonDesc.Replace("[!ClientName]", cName)
                        End If
                        lstCreditors.Items.Add(New ListItem(reasonDesc, reasonDesc))
                    End While
                End Using
            End Using
        End Using

        cell.Controls.Add(lstCreditors)

        If IsRequired = True Then
            Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = lstCreditors.ClientID, .ErrorMessage = "Missing Information reason is Required!"}
            cell.Controls.Add(rfv)
        End If

        row.Cells.Add(cell)

        Return row
    End Function
    
    Private Function BuildAdditionalAccountFeeStatementReasonList(Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText("AdditionalAccountFeeStatement"))
        cell.Controls.Add(lbl)

        Dim strSQL As String = "SELECT ReasonID, ReasonDesc  FROM tblLetterReasons WHERE (LetterName = 'ClientChangeForm')"
        Dim lst As New RadioButtonList
        'lstDebtReasons.Style("height") = "150px"
        lst.Style("width") = "100%"
        lst.ID = "arg_value_lst_AdditionalAccountFeeStatement"
        lst.Style("overflow") = "auto"

        lst.Font.Name = "tahoma"
        lst.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

        Using cmd As New SqlCommand(strSQL, New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString))
            Using cmd.Connection
                cmd.Connection.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim reasonDesc As String = reader("ReasonDesc").Replace("[!PerAcctServiceFee]", FormatCurrency(_PerAcctServiceFee, 2)).Replace("[!MaxServiceFeeAmt]", FormatCurrency(_MaxServiceFeeAmt, 2)).Replace("[!MaxNumAccts]", Math.Round(_MaxServiceFeeAmt / _PerAcctServiceFee))
                        lst.Items.Add(New ListItem(reasonDesc, CInt(reader("ReasonID").ToString)))
                    End While
                End Using
            End Using
        End Using

        lst.SelectedIndex = 0
        cell.Controls.Add(lst)

        If IsRequired = True Then
            Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = lst.ClientID, .ErrorMessage = "Additional Account Fee statement is required!"}
            cell.Controls.Add(rfv)
        End If

        row.Cells.Add(cell)

        Return row
    End Function

    Private Function BuildSettlementList(ByVal reportType As String, ByVal ctlName As String, Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell
        Dim lst As ListBox = Nothing
        Dim lbl As New LiteralControl(BuildLabelText("Settlements"))
        cell.Controls.Add(lbl)

        Dim sSQL As String = "select c.name + ' #' + right(ci.accountnumber,4) + ' ($' + cast(s.settlementamount as varchar) +')'[SettInfo],s.settlementid  "
        sSQL += "from tblsettlements s "
        sSQL += "inner join tblaccount a on a.accountid = s.creditoraccountid "
        sSQL += "inner join tblcreditorinstance ci on a.currentcreditorinstanceid = ci.creditorinstanceid "
        sSQL += "inner join tblcreditor c on c.creditorid = ci.creditorid "
        sSQL += "where [status] = 'a' and active = 1 and s.clientid = " & DataClientID

        Dim ctlNameString As String = String.Format("arg_value_{0}_lst_{1}", reportType, ctlName)
        lst = Me.FindControl(ctlNameString)
        If IsNothing(lst) Then
            lst = New ListBox
            lst.Style("height") = "150px"
            lst.Style("width") = "100%"
            lst.ID = ctlNameString
            lst.SelectionMode = ListSelectionMode.Single

            lst.Font.Name = "tahoma"
            lst.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

            Using cmd As New SqlCommand(sSQL, New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionString").ToString))
                Using cmd.Connection
                    cmd.Connection.Open()

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        While reader.Read()
                            lst.Items.Add(New ListItem(FormatSelect(CStr(reader("SettInfo")), reader("settlementid")), reader("settlementid")))
                        End While
                    End Using
                End Using
            End Using

            cell.Controls.Add(lst)

            If IsRequired = True Then
                Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = lst.ClientID, .ErrorMessage = "Settlement is Required!"}
                cell.Controls.Add(rfv)
            End If

            row.Cells.Add(cell)


        Else
            row = TryCast(lst.Parent.Parent, TableRow)
        End If


        Return row
    End Function

    Private Function BuildVerificationReasonsList(ByVal sqlConnection As SqlConnection, Optional ByVal IsRequired As Boolean = False) As TableRow
        Dim row As TableRow = New TableRow
        Dim cell As TableCell = New TableCell
        Dim lbl As New LiteralControl(BuildLabelText("Reason"))
        cell.Controls.Add(lbl)

        Dim strSQL As String = "SELECT ReasonID, ReasonDesc  FROM tblLetterReasons WHERE (LetterName = 'VerificationResponseLetter605')"

        Dim lstCreditors As New CheckBoxList() With {.ID = "arg_value_lst_MissingInfoReasonCode"}
        lstCreditors.Style("height") = "150px"
        lstCreditors.Style("width") = "100%"
        lstCreditors.Font.Name = "tahoma"
        lstCreditors.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

        Using cmd As New SqlCommand(strSQL, sqlConnection)
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        lstCreditors.Items.Add(New ListItem(reader("ReasonDesc"), CInt(reader("ReasonID"))))
                    End While
                End Using
            End Using
        End Using

        cell.Controls.Add(lstCreditors)

        If IsRequired = True Then
            Dim rfv As New RequiredFieldValidator() With {.ControlToValidate = lstCreditors.ClientID, .ErrorMessage = "Missing Information reason is Required!"}
            cell.Controls.Add(rfv)
        End If

        row.Cells.Add(cell)

        Return row
    End Function

    Private Function ConvertDateToString(ByVal dt As DateTime) As String
        Dim ext As String = "AM"
        Dim hour As String = dt.Hour.ToString().PadLeft(2, "0")

        If dt.Year.ToString() = "1900" Then
            Return ""
        End If

        If dt.Hour > 12 Then
            hour = CStr(dt.Hour - 12).PadLeft(2, "0")
            ext = "PM"
        End If

        Return dt.Month.ToString().PadLeft(2, "0") + dt.Day.ToString().PadLeft(2, "0") + dt.Year.ToString() + hour + dt.Minute.ToString().PadLeft(2, "0") + ext
    End Function

    Private Function FormatSelect(ByVal name As String, ByVal desc As String) As String
        If name.Length > 45 Then
            name = name.Substring(0, 45) + "..."
        End If

        desc = desc.Trim()

        Return name + RepeatString(" ", 65 - (name.Length + desc.Length)) + desc
    End Function

    Private Function InsertSpaceAfterCap(ByVal strToChange As String) As String
        If strToChange.Contains("CityStateZip") Then
            strToChange = strToChange.Replace("CityStateZip", "City,StateZip")
        End If

        Dim strNew As String = ""

        For Each c As Char In strToChange.ToCharArray()
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
        strNew = strNew.Replace("S D A", "SDA")
        Return strNew.Trim
    End Function
    Private Sub LoadNonDepositReasons()
        Dim bankAcct4 As String = GetClientBankAccountLastFour(DataClientID)
        Dim strSQL As String = "SELECT ReasonID, ReasonDesc  FROM tblLetterReasons WHERE (LetterName = 'NoticeOfNonDepositFirst')"
        Using creds As DataTable = LetterTemplates.GetDataTable(strSQL)
            For Each crow As DataRow In creds.Rows
                Dim reasonDesc As String = crow("ReasonDesc").ToString
                reasonDesc = reasonDesc.Replace("[!LastDepositDueDate]", FormatDateTime(Now, DateFormat.ShortDate)).Replace("[!BankAcctLastFour]", String.Format("#{0}", bankAcct4))
                ddlReason.Items.Add(New ListItem(reasonDesc, crow("reasonid").ToString))
            Next
        End Using
    End Sub
    Private Sub LoadCreditors()
        Dim sqlCred As String = String.Format("stp_LetterTemplates_GetClientCreditors {0}", DataClientID)
        Using creds As DataTable = LetterTemplates.GetDataTable(sqlCred)
            For Each crow As DataRow In creds.Rows
                Dim itmText As String = String.Format("{0} ({1})", crow("Name").ToString, crow("AcctLast4").ToString)
                Dim rowNumber As String = crow("roNum").ToString
                Select Case rowNumber
                    Case 1

                    Case Else
                        itmText = itmText.Insert(0, Server.HtmlDecode("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"))
                End Select
                
                lstCreditorInstances.Items.Add(New ListItem(itmText, crow("CurrentCreditorInstanceID")))
            Next
        End Using
    End Sub
    Private Sub LoadSettlements()
        Dim sSQL As New StringBuilder
        sSQL.Append("select c.name + ' #' + right(ci.accountnumber,4) + ' ($' + cast(s.settlementamount as varchar) +')'[SettInfo],s.settlementid  ")
        sSQL.Append("from tblsettlements s ")
        sSQL.Append("inner join tblaccount a on a.accountid = s.creditoraccountid ")
        sSQL.Append("inner join tblcreditorinstance ci on a.currentcreditorinstanceid = ci.creditorinstanceid ")
        sSQL.Append("inner join tblcreditor c on c.creditorid = ci.creditorid ")
        sSQL.AppendFormat("where [status] = 'a' and active = 1 and s.clientid = {0}", DataClientID)

        Using creds As DataTable = LetterTemplates.GetDataTable(sSQL.ToString)
            For Each crow As DataRow In creds.Rows
                lstClientSettlements.Items.Add(New ListItem(crow("SettInfo").ToString, crow("settlementid").ToString))
            Next
        End Using
    End Sub
    Private Sub LoadLocalCounsel()
        Dim ssql As New StringBuilder
        ssql.AppendFormat("select isnull(csp.attorneyid,-1)[attorneyid] from tblclient c inner join tblperson p on p.personid = c.primarypersonid inner join tblstate s on s.stateid = p.stateid inner join tblcompanystateprimary csp on csp.companyid = c.companyid and csp.[state] = s.abbreviation where c.clientid = {0}", DataClientID)
        Dim clientLocalCounselID As Integer = SharedFunctions.AsyncDB.executeScalar(ssql.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)

        Using creds As DataTable = LetterTemplates.GetDataTable(String.Format("stp_LetterTemplates_getLocalCounsel {0}", DataClientID))
            For Each drow As DataRow In creds.Rows
                Dim aName As String = drow("LocalCounselName").ToString
                Dim aid As String = drow("attorneyid").ToString
                Dim li As New ListItem(aName, aid)
                Try
                    lstLocalCounsel.Items.Add(li)
                Catch ex As Exception
                    Continue For
                End Try

            Next
            lstLocalCounsel.SelectedValue = clientLocalCounselID
            
        End Using
    End Sub
    
    Private Function RepeatString(ByVal str As String, ByVal count As Integer) As String
        Dim result As String = ""

        For i As Integer = 0 To count - 1
            result += str
        Next

        Return result
    End Function

    Private Sub SetRollups()
        If Master.UserEdit Then
            Master.CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Print_Reports();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>View Reports</a>")
        End If
    End Sub

    Private Function getReports() As Dictionary(Of String, List(Of String))
        Dim reports As New Dictionary(Of String, List(Of String))

        For Each reportType As AjaxControlToolkit.AccordionPane In acReports.Panes
            Dim gv As GridView = reportType.FindControl("gvReportsChildren")
            For Each row As GridViewRow In gv.Rows
                If row.RowType = DataControlRowType.DataRow Then
                    Dim chk As System.Web.UI.WebControls.CheckBox = TryCast(row.Controls(0).Controls(1), System.Web.UI.WebControls.CheckBox)
                    If chk.Checked = True Then
                        'get reprots args it was checked
                        Dim rARGS As New List(Of String)
                        Dim typeName As String = row.Cells(3).Text

                        'get creditor arg first
                        Dim args As List(Of String) = LexxiomReports.GetArgumentsByReportName(typeName)
                        If args.Contains("CreditorInstanceIDsCommaSeparated") Then
                            Dim iSelected As Integer() = lstCreditorInstances.GetSelectedIndices
                            Dim creditors As New List(Of String)
                            For Each idx As Integer In iSelected
                                creditors.Add(lstCreditorInstances.Items(idx).Value)
                            Next
                            rARGS.Add(Join(creditors.ToArray, ","))

                        End If

                        Dim tbl As Table = phArgs.FindControl("tbl_" & typeName)
                        For Each aRow As TableRow In tbl.Rows
                            Dim ctl As Control = aRow.Cells(0).Controls(1)
                            If TypeOf ctl Is System.Web.UI.WebControls.TextBox Then
                                rARGS.Add(TryCast(ctl, System.Web.UI.WebControls.TextBox).Text)
                            ElseIf TypeOf ctl Is ListBox Then
                                Dim lst As ListBox = TryCast(ctl, ListBox)
                                Dim iSelected As Integer() = lst.GetSelectedIndices
                                For Each idx As Integer In iSelected
                                    rARGS.Add(lst.Items(idx).Value)
                                Next
                            ElseIf TypeOf ctl Is CheckBoxList Then
                                Dim clst As CheckBoxList = TryCast(ctl, CheckBoxList)
                                Dim tempArgs As New List(Of String)
                                For Each itm As ListItem In clst.Items
                                    If itm.Selected = True Then
                                        tempArgs.Add(itm.Value)
                                    End If
                                Next
                                If tempArgs.Count > 0 Then
                                    rARGS.Add(Join(tempArgs.ToArray, ","))
                                End If

                            End If
                        Next
                        reports.Add(typeName.ToString, rARGS)
                    End If
                End If
            Next
        Next

        Return reports
    End Function

    Private Sub storeReportArray()
        Dim Reports As List(Of LetterTemplates.ReportInfo) = LexxiomReports.GetReports
        Dim arrReportArgs As String = "ReportArgsArray"
        Dim arrValues As String = ""
        For Each r As LetterTemplates.ReportInfo In Reports
            arrValues = r.ReportTypeName & "|"
            For Each arg As KeyValuePair(Of String, String) In r.ReportArguments
                arrValues += arg.Key & ","
            Next
            arrValues = arrValues.Substring(0, arrValues.Length - 1) & "|"

            If Not IsNothing(r.RequiredFieldsList) Then
                For Each s As String In r.RequiredFieldsList
                    arrValues += s.ToString & ","
                Next
            End If

            arrValues = arrValues.Substring(0, arrValues.Length - 1)
            arrValues = arrValues.Replace(")", "")

            ClientScript.RegisterArrayDeclaration(arrReportArgs, Chr(34) & arrValues & Chr(34))
        Next
    End Sub

    Private Sub SetProperties()

        Dim ssql As New StringBuilder
        ssql.Append("select [EnrollmentMaintenanceFeeCap] = (select value from tblproperty where [Name] = 'EnrollmentMaintenanceFeeCap')")
        ssql.Append(", [EnrollmentAddAccountFee2] = (select value from tblproperty where [Name] = 'EnrollmentAddAccountFee2')")

        Using dt As DataTable = LetterTemplates.GetDataTable(ssql.ToString)
            For Each var As DataRow In dt.Rows
                _PerAcctServiceFee = var("EnrollmentAddAccountFee2")
                _MaxServiceFeeAmt = var("EnrollmentMaintenanceFeeCap")

                Exit For
            Next
        End Using
    End Sub
    Public Shadows Function FindControl(ByVal id As String) As Control
        Return FindControl(Page, id)
    End Function
    Public Shared Shadows Function FindControl(ByVal startingControl As Control, ByVal id As String) As Control
        If id = startingControl.ID Then Return startingControl
        For Each ctl As Control In startingControl.Controls
            Dim found = FindControl(ctl, id)
            If found IsNot Nothing Then Return found
        Next
        Return Nothing
    End Function
    #End Region 'Methods
    Public Function AddDocIDToReportArguments() As String
        Return ReportsHelper.GetNewDocID
    End Function
End Class