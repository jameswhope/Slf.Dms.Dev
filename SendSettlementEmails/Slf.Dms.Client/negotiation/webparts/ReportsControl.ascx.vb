Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports LexxiomLetterTemplates
Imports System.Data
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.Drawing
Imports DataDynamics.ActiveReports
Imports DataDynamics.ActiveReports.Export.Pdf
Imports System.IO
Partial Class negotiation_webparts_ReportsControl
    Inherits System.Web.UI.UserControl
#Region "Declares"
    Private rpt As LexxiomLetterTemplates.LetterTemplates
    Private creds As Dictionary(Of Integer, LetterTemplates.CreditorInfo)
    Private negReports As New List(Of String)
#End Region
#Region "Properties"
    Property DataClientID() As String
        Get
            Return ViewState("DataClientID")
        End Get
        Set(ByVal value As String)
            ViewState("DataClientID") = value
        End Set
    End Property
    Public Property CreditorAccountID() As String
        Get
            Return ViewState("CreditorAccountID")
        End Get
        Set(ByVal value As String)
            ViewState("CreditorAccountID") = value
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
#End Region
    Protected Sub gvReports_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvReports.DataBound

        Dim childRowsCount As Integer = gvReports.Rows.Count
        spnHdr.Text = "Creditor Services Reports (" & childRowsCount & ")"

    End Sub

    Protected Sub gvReports_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvReports.RowCreated
        e.Row.Cells(3).Visible = False
    End Sub

    Protected Sub gvReports_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvReports.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                ' Retrieve the underlying data item. In this example
                ' the underlying data item is a DataRowView object. 
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

                Dim args As String() = rowView("ReportArguments").ToString().Split("|")
                Dim argControl As Control = BuildArgTable(args, rowView("ReportTypeName").ToString)
                e.Row.Cells(5).Controls.Add(argControl)

        End Select
    End Sub

    Protected Sub gvReports_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvReports.Sorting

        Dim dtTypes As DataTable = TryCast(TryCast(sender, GridView).DataSource, DataTable)

        If sortDir.Value = "ASC" Then
            dtTypes.DefaultView.Sort = e.SortExpression & " DESC"
            sortDir.Value = "DESC"
        Else
            dtTypes.DefaultView.Sort = e.SortExpression & " ASC"
            sortDir.Value = "ASC"
        End If

        gvReports.DataSource = dtTypes
        gvReports.DataBind()
    End Sub

    Protected Sub lnkView_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkView.Click
        Dim ListOfReports As New Dictionary(Of String, List(Of String))
        Dim finalReport As New ActiveReport3

        For Each row As GridViewRow In gvReports.Rows
            If row.RowType = DataControlRowType.DataRow Then

                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = TryCast(row.Controls(0).Controls(1), System.Web.UI.HtmlControls.HtmlInputCheckBox)

                If chk.Checked = True Then
                    Dim rARGS As New List(Of String)
                    Dim typeName As String = row.Cells(3).Text
                    Dim tbl As Table = row.FindControl("tbl_" & typeName)
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
                        End If
                    Next
                    ListOfReports.Add(typeName.ToString, rARGS)
                End If
            End If
        Next

        If ListOfReports.Count = 0 Then
            lblMsg.Text = "Please select at least 1 report!"
            Exit Sub
        Else
            lblMsg.Text = ""
        End If

        Dim viewRpt As New StringBuilder
        Dim credInstID As Integer = AccountHelper.GetCurrentCreditorInstanceID(CreditorAccountID)

        For Each kvp As KeyValuePair(Of String, List(Of String)) In ListOfReports
            Select Case kvp.Key
                Case "SettlementAcceptanceForm", "RestrictiveEndorsementLetter"
                    viewRpt.Append(kvp.Key)
                Case Else
                    viewRpt.AppendFormat("{0}_{1}", kvp.Key, credInstID)
            End Select


            For i As Integer = 0 To kvp.Value.Count - 1
                If kvp.Value(i).ToString.ToLower = "settlementid" Then
                    lblMsg.Text = "Please enter a settlementid!"
                    Exit Sub
                Else
                    viewRpt.AppendFormat("_{0}", kvp.Value(i).ToString)
                End If
            Next
            viewRpt.AppendFormat("_{0}|", ReportsHelper.GetNewDocID)
        Next


        Dim queryString As String = "../../Clients/client/reports/report.aspx?clientid=" & DataClientID & "&reports=" & Server.UrlEncode(viewRpt.ToString.Substring(0, viewRpt.Length - 1)) & "&user=" & UserID
        Dim frm As HtmlControl = TryCast(dvReport.FindControl("frmReport"), HtmlControl)
        frm.Attributes("src") = queryString

        programmaticModalPopup.Show()

    End Sub

    Protected Sub negotiation_webparts_ReportsControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        rpt = New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionString").ToString)

        If ViewState("creds") Is Nothing And DataClientID IsNot Nothing Then
            creds = LetterTemplates.GetCreditors(DataClientID)
            ViewState("creds") = creds
        End If

        If DataClientID IsNot Nothing AndAlso DataClientID.ToString <> "" Then
            'load reports by type (creditor,client,welcomepkg)
            'Dim dtTypes As DataTable = rpt.BuildReportsDataTable("Creditor", DataClientID)

            'load specific reports
            negReports.Add("CreditorPOARefusalNotice")
            negReports.Add("DisputeLetter")
            negReports.Add("ModifiedLetterOfRepresentation")
            negReports.Add("LetterOfRepresentation")
            negReports.Add("ElectronicSignatureLetter")
            negReports.Add("SettlementInFullLetter")
            negReports.Add("NonRepresentationOfDebtLetter")
            negReports.Add("FormalSettlementOfferLetterVerify")
            negReports.Add("FormalSettlementOfferLetterValidate")
            negReports.Add("RestrictiveEndorsementLetter")
            negReports.Add("AuthorizationToFaxLetter")
            negReports.Add("SettlementOfferLetter")


            Dim dtTypes As DataTable = rpt.BuildReportsDataTable(negReports, DataClientID)
            gvReports.DataSource = dtTypes
            gvReports.DataBind()

            If sortDir.Value = "" Then
                sortDir.Value = "ASC"
            End If

        End If

    End Sub
#Region "GUI Utils"
    Function GetRandomColor() As Color
        Dim rand As New Random
        Return Color.FromArgb(rand.Next(0, 256), rand.Next(0, 256), rand.Next(0, 256))
    End Function
    Private Function BuildArgTable(ByVal ListofArgs As String(), ByVal rptTypeName As String) As Control
        Dim pnl As New Panel


        Dim tbl As New Table
        tbl.Style("width") = "100%"
        tbl.ID = "tbl_" & rptTypeName
        tbl.BackColor = Color.LightGray
        tbl.BorderColor = Color.Gray
        tbl.BorderStyle = BorderStyle.Inset
        tbl.BorderWidth = New Unit(1)

        Dim row As TableRow = Nothing
        Dim cell As TableCell = Nothing

        For Each arg As String In ListofArgs
            Select Case arg.ToLower
                Case "bisthisacopy"

                Case "clientid"
                    'hide client prompt
                    'row = AddTextBoxArgument(arg, rptTypeName, TextBoxMode.SingleLine, DataclientID)

                    'Case "CreditorContactDate".ToLower, "DueDate".ToLower, "ConversationDate".ToLower, "ContactDate".ToLower, "SignBeforeDate".ToLower
                    '    row = AddDateBoxArgument(arg, rptTypeName)
                Case "MissingInfoReasonCode".ToLower

                Case "CreditorInstanceIDsCommaSeparated".ToLower
                    'hide creditor prompt
                    'row = AddCreditorArgumentSelection(DataclientID, arg, rptTypeName)
                Case "DebtRejectionReason".ToLower
                    row = New TableRow
                    cell = New TableCell
                    cell.Style("width") = "25%"
                    cell.Text = "Reason"
                    row.Cells.Add(cell)
                    cell = New TableCell
                    cell.Controls.Add(BuildDebtReasonsTable(New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionString").ToString)))
                    row.Cells.Add(cell)
                Case "DepositMonth".ToLower
                    row = New TableRow
                    cell = New TableCell
                    cell.Style("width") = "25%"
                    cell.Text = "Deposit Month"
                    row.Cells.Add(cell)
                    cell = New TableCell
                    cell.Controls.Add(BuildMonthsTable)
                    row.Cells.Add(cell)
                Case "DocumentListCommaSeparated".ToLower, "Notes".ToLower
                    row = AddTextBoxArgument(arg, rptTypeName, TextBoxMode.MultiLine)
   
                Case "SettlementAgentFax".ToLower
                    row = AddTelBoxArgument(arg, rptTypeName)
                Case Else
                    If arg.ToLower.Contains("date") Then
                        row = AddDateBoxArgument(arg, rptTypeName)
                    ElseIf arg.ToLower.Contains("amount") OrElse arg.ToLower.Contains("fees") OrElse arg.ToLower.Contains("costs") OrElse arg.ToLower.Contains("bal") Then
                        row = AddCurrencyBoxArgument(arg, rptTypeName)
                    Else
                        row = AddTextBoxArgument(arg, rptTypeName, TextBoxMode.SingleLine, Nothing)
                    End If

            End Select
            If row IsNot Nothing Then
                tbl.Rows.Add(row)
            End If
        Next
        pnl.Controls.Add(tbl)

        Return pnl
    End Function
    Private Function AddDateBoxArgument(ByVal ArgumentName As String, ByVal TypeOfReport As String) As TableRow
        Dim row As TableRow = Nothing
        Dim cell As TableCell = Nothing

        row = New TableRow
        cell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText(ArgumentName))
        cell.Controls.Add(lbl)

        Dim ctl As New System.Web.UI.WebControls.TextBox
        ctl.ID = "__" & TypeOfReport & "_txt_" & ArgumentName
        ctl.Text = FormatDateTime(Now, DateFormat.ShortDate)
        cell.Controls.Add(ctl)
        Dim calExt As New AjaxControlToolkit.CalendarExtender
        calExt.TargetControlID = ctl.ClientID
        calExt.ID = "dateExt_" & ctl.ClientID
        cell.Controls.Add(calExt)

        cell.Style("width") = "100%"

        row.Cells.Add(cell)

        Return row
    End Function
    Private Function AddTelBoxArgument(ByVal ArgumentName As String, ByVal TypeOfReport As String) As TableRow
        Dim row As TableRow = Nothing
        Dim cell As TableCell = Nothing

        row = New TableRow
        cell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText(ArgumentName))
        cell.Controls.Add(lbl)

        Dim ctl As New System.Web.UI.WebControls.TextBox
        ctl.ID = "__" & TypeOfReport & "_txt_" & ArgumentName
        ctl.Text = "__________"
        cell.Controls.Add(ctl)
        Dim calExt As New AjaxControlToolkit.MaskedEditExtender
        calExt.TargetControlID = ctl.ClientID
        calExt.ID = "telExt_" & ctl.ClientID
        calExt.Mask = "(999)999-9999"
        calExt.ClearMaskOnLostFocus = False
        cell.Controls.Add(calExt)

        cell.Style("width") = "100%"

        row.Cells.Add(cell)

        Return row
    End Function
    Private Function AddCurrencyBoxArgument(ByVal ArgumentName As String, ByVal TypeOfReport As String) As TableRow
        Dim row As TableRow = Nothing
        Dim cell As TableCell = Nothing

        row = New TableRow
        cell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText(ArgumentName))
        cell.Controls.Add(lbl)

        Dim ctl As New System.Web.UI.WebControls.TextBox
        ctl.Attributes.Add("onfocus", "this.select();")
        ctl.ID = "__" & TypeOfReport & "_txt_" & ArgumentName
        ctl.Text = "0.00"
        cell.Controls.Add(ctl)

        Dim ftExt As New AjaxControlToolkit.FilteredTextBoxExtender() With {.TargetControlID = ctl.ClientID, .ID = "curExt_" & ctl.ClientID, .FilterType = FilterTypes.Custom, .ValidChars = "1234567890."}
        cell.Controls.Add(ftExt)

        cell.Style("width") = "100%"

        row.Cells.Add(cell)

        Return row
    End Function
    Private Function AddCreditorArgumentSelection(ByVal ClientIDOfClient As String, ByVal ArgumentName As String, ByVal TypeOfReport As String) As TableRow
        Dim row As TableRow = Nothing
        Dim cell As TableCell = Nothing

        row = New TableRow

        cell = New TableCell
        cell.Style("width") = "25%"
        cell.Text = "Select Creditor"
        row.Cells.Add(cell)

        cell = New TableCell
        Dim ctl As New ListBox
        ctl.Height = "90"
        ctl.SelectionMode = ListSelectionMode.Multiple

        creds = TryCast(ViewState("creds"), Dictionary(Of Integer, LetterTemplates.CreditorInfo))

        For Each kvp As KeyValuePair(Of Integer, LetterTemplates.CreditorInfo) In creds
            ctl.Items.Add(New ListItem(kvp.Value.Name, kvp.Value.CreditorID))
        Next

        ctl.Style("width") = "100%"
        ctl.ID = "__" & TypeOfReport & "_lst_" & ArgumentName
        cell.Controls.Add(ctl)

        row.Cells.Add(cell)
        Return row
    End Function
    Private Function AddTextBoxArgument(ByVal ArgumentName As String, ByVal TypeOfReport As String, Optional ByVal TextMode As TextBoxMode = TextBoxMode.SingleLine, Optional ByVal TextBoxValue As String = Nothing) As TableRow
        Dim row As TableRow = Nothing
        Dim cell As TableCell = Nothing

        row = New TableRow
        cell = New TableCell

        Dim lbl As New LiteralControl(BuildLabelText(ArgumentName))
        cell.Controls.Add(lbl)


        Dim ctl As New System.Web.UI.WebControls.TextBox
        ctl.ID = "__" & TypeOfReport & "_txt_" & ArgumentName
        If TextBoxValue IsNot Nothing Then
            ctl.Text = TextBoxValue
        Else
            ctl.Text = ArgumentName
        End If
        ctl.TextMode = TextMode
        If TextMode = TextBoxMode.MultiLine Then
            ctl.Style("height") = "75px"
        End If
        ctl.Style("width") = "75%"
        cell.Controls.Add(ctl)
        row.Cells.Add(cell)

        Return row
    End Function
    Private Function BuildDebtReasonsTable(ByVal sqlConnection As SqlConnection) As RadioButtonList
        'build dynamic table with radiobuttons to select the debt rejection reason
        Dim strSQL As String = "SELECT ReasonID, ReasonDesc  FROM tblLetterReasons WHERE (LetterName = 'DebtRejectionLetter')"
        Dim lstDebtReasons As New RadioButtonList
        lstDebtReasons.Style("height") = "150px"
        lstDebtReasons.Style("width") = "100%"
        lstDebtReasons.ID = "arg_value_lst_DebtRejectionReason"
        lstDebtReasons.Style("overflow") = "auto"

        lstDebtReasons.Font.Name = "tahoma"
        lstDebtReasons.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

        Using cmd As New SqlCommand(strSQL, sqlConnection)
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        lstDebtReasons.Items.Add(New ListItem(reader("ReasonDesc"), CInt(reader("ReasonID"))))
                    End While
                End Using
            End Using
        End Using

        Return lstDebtReasons
    End Function
    Private Function BuildVerificationReasonsList(ByVal sqlConnection As SqlConnection) As CheckBoxList

        Dim strSQL As String = "SELECT ReasonID, ReasonDesc  FROM tblLetterReasons WHERE (LetterName = 'VerificationResponseLetter605')"

        Dim lstCreditors As New CheckBoxList
        lstCreditors.Style("height") = "150px"
        lstCreditors.Style("width") = "100%"
        lstCreditors.ID = "arg_value_lst_MissingInfoReasonCode"

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

        Return lstCreditors

    End Function
    Private Function BuildMonthsTable() As RadioButtonList
        'build dynamic table with radiobuttons to select the debt rejection reason
        Dim lstDebtReasons As New RadioButtonList
        lstDebtReasons.Style("height") = "150px"
        lstDebtReasons.Style("width") = "100%"
        lstDebtReasons.ID = "arg_value_lst_DepositMonth"
        lstDebtReasons.Style("overflow") = "auto"

        lstDebtReasons.Font.Name = "tahoma"
        lstDebtReasons.Font.Size = New System.Web.UI.WebControls.FontUnit("8pt")

        For i As Integer = 1 To 12
            Dim sMonthName As String = MonthName(i, False)
            lstDebtReasons.Items.Add(sMonthName)
        Next

        Return lstDebtReasons
    End Function
    Private Function InsertSpaceAfterCap(ByVal strToChange As String) As String

        If strToChange.Contains("CityStateZip") Then
            strToChange = strToChange.Replace("CityStateZip", "City,StateZip")
        End If

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
    Private Function BuildLabelText(ByVal labelText As String) As String
        Dim strTemp As String = "<div style=""padding-left:5px;width:98%;background-color:#006699;color:white;"">" & InsertSpaceAfterCap(labelText) & "</div>"
        Return strTemp
    End Function
#End Region

    
End Class

