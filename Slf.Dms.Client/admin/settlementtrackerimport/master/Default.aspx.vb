Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient

Imports Drg.Util.DataAccess

Partial Class admin_settlementtrackerimport_master_Default
    Inherits PermissionPage

    #Region "Properties"

    Public Property ReportMonth() As Integer
        Get
            Return ViewState("ReportMonth")
        End Get
        Set(ByVal value As Integer)
            ViewState("ReportMonth") = value
        End Set
    End Property

    Public Property ReportYear() As Integer
        Get
            Return ViewState("ReportYear")
        End Get
        Set(ByVal value As Integer)
            ViewState("ReportYear") = value
        End Set
    End Property

    Public Property UserID() As Integer
        Get
            Return ViewState("UserID")
        End Get
        Set(ByVal value As Integer)
            ViewState("UserID") = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Public Shadows Shared Function FindControl(ByVal startingControl As Control, ByVal id As String) As Control
        If id = startingControl.ID Then Return startingControl
        For Each ctl As Control In startingControl.Controls
            Dim found = FindControl(ctl, id)
            If found IsNot Nothing Then Return found
        Next
        Return Nothing
    End Function

    Public Function AddHeaderRow(ByVal gridHeaderRow As System.Web.UI.WebControls.GridViewRowEventArgs) As GridViewRow
        'Add another Header Row
        Dim row As New GridViewRow(-1, -1, DataControlRowType.Header, DataControlRowState.Normal)
        row.BackColor = System.Drawing.ColorTranslator.FromHtml("#3376AB")
        row.ForeColor = System.Drawing.Color.White
        row.CssClass = "entry2"

        Dim cell As New TableCell()
        cell.Style("Padding-left") = "10px"
        cell.HorizontalAlign = HorizontalAlign.Left
        cell.ColumnSpan = gridHeaderRow.Row.Cells.Count / 2

        Dim lblFilter As New Label With {.Text = "Filter : "}
        cell.Controls.Add(lblFilter)

        Dim lblFilterText As New TextBox With {.Text = "", .ID = "txtFilterText", .Width = 200, .CssClass = "entry2"}
        cell.Controls.Add(lblFilterText)

        Dim lnkFilter As New LinkButton With {.Text = "Go", .ID = "txtFilter", .ForeColor = System.Drawing.Color.White, .CssClass = "lnk"}
        lnkFilter.Style("Padding-left") = "10px"
        AddHandler lnkFilter.Click, AddressOf lnkFilter_Click
        cell.Controls.Add(lnkFilter)
        cell.Controls.Add(New LiteralControl(" | "))
        Dim lnkFilterReset As New LinkButton With {.Text = "Reset", .ID = "txtFilterReset", .ForeColor = System.Drawing.Color.White, .CssClass = "lnk"}
        AddHandler lnkFilterReset.Click, AddressOf lnkClear_Click
        cell.Controls.Add(lnkFilterReset)

        row.Cells.Add(cell)

        cell = New TableCell()
        cell.Style("Padding-right") = "10px"
        cell.HorizontalAlign = HorizontalAlign.Right
        cell.ColumnSpan = gridHeaderRow.Row.Cells.Count / 2

        Dim lnkDelete As New LinkButton() With {.Text = "Delete Selected", .ID = "lnkDeleteSelected", .ForeColor = System.Drawing.Color.White, .CssClass = "lnk"}
        lnkDelete.OnClientClick = "return confirm('Are you sure you want to delete selected settlement(s)?');"
        AddHandler lnkDelete.Click, AddressOf lnkDeleteSelected_click
        cell.Controls.Add(New HtmlImage() With {.Src = ResolveUrl("~/images/16x16_delete.png")})
        cell.Controls.Add(lnkDelete)
        cell.Controls.Add(New LiteralControl(" | "))

        Dim lnkCancel As New LinkButton() With {.Text = "Cancel Selected", .ID = "lnkCancelSelected", .ForeColor = System.Drawing.Color.White, .CssClass = "lnk"}
        lnkCancel.OnClientClick = "return confirm('Are you sure you want to cancel selected settlement(s)?');"
        AddHandler lnkCancel.Click, AddressOf lnkCancelSelected_click
        cell.Controls.Add(New HtmlImage() With {.Src = ResolveUrl("~/images/16x16_cancel.png")})
        cell.Controls.Add(lnkCancel)
        cell.Controls.Add(New LiteralControl(" | "))

        Dim lnkBulkEdit As New LinkButton() With {.Text = "Bulk Edit Selected", .ID = "lnkBulkEditSelected", .ForeColor = System.Drawing.Color.White, .CssClass = "lnk"}
        lnkBulkEdit.OnClientClick = "alert('Not Implemented Yet');return false; "
        cell.Controls.Add(New HtmlImage() With {.Src = ResolveUrl("~/images/16x16_edit.gif")})
        cell.Controls.Add(lnkBulkEdit)
        cell.Controls.Add(New LiteralControl(" | "))

        Dim lnkExportExcel As New LinkButton() With {.Text = "Export To Excel", .ID = "lnkExportExcel", .ForeColor = System.Drawing.Color.White, .CssClass = "lnk"}
        AddHandler lnkExportExcel.Click, AddressOf lnkExportExcel_Click
        Dim sm As ScriptManager = ScriptManager.GetCurrent(Me.Page)
        sm.RegisterPostBackControl(lnkExportExcel)
        cell.Controls.Add(New HtmlImage() With {.Src = ResolveUrl("~/images/16x16_worksheet.png")})
        cell.Controls.Add(lnkExportExcel)

        row.Cells.Add(cell)

        Return row
    End Function
    Public Overloads Overrides Sub VerifyRenderingInServerForm(ByVal control As System.Web.UI.Control)
        'confirms that an HtmlForm control is rendered for the
        'specified ASP.NET server control at run time.
    End Sub
    Private Sub lnkExportExcel_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim stringWrite As New System.IO.StringWriter()
        Dim htmlWrite As New HtmlTextWriter(stringWrite)

        'Dim dv As DataView = dsSearch.Select(DataSourceSelectArguments.Empty)
        Response.Clear()
        Response.AddHeader("content-disposition", "attachment;filename=master.xls")
        Response.Charset = ""
        ' If you want the option to open the Excel file without saving then
        ' comment out the line below
        ' Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.ContentType = "application/ms-excel"

        gvExport.DataSourceID = dsMaster.ID

        gvExport.AllowPaging = False
        gvExport.DataBind()

        'PrepareGridViewForExport(gvExport)
        gvExport.RenderControl(htmlWrite)

        Response.Write(stringWrite.ToString())
        Response.End()

        Response.Write(stringWrite.ToString())
        Response.End()

    End Sub
    Private Sub PrepareGridViewForExport(ByVal gv As Control)

        Dim lb As New LinkButton()
        Dim l As New Literal()
        Dim name As String = [String].Empty
        Dim i As Integer = 0
        While i < gv.Controls.Count
            If TypeOf gv.Controls(i) Is LinkButton Then
                l.Text = (TryCast(gv.Controls(i), LinkButton)).Text
                gv.Controls.Remove(gv.Controls(i))
                gv.Controls.AddAt(i, l)
            ElseIf TypeOf gv.Controls(i) Is DropDownList Then
                l.Text = (TryCast(gv.Controls(i), DropDownList)).SelectedItem.Text
                gv.Controls.Remove(gv.Controls(i))
                gv.Controls.AddAt(i, l)
            ElseIf TypeOf gv.Controls(i) Is CheckBox Then
                l.Text = If((TryCast(gv.Controls(i), CheckBox)).Checked, "True", "False")
                gv.Controls.Remove(gv.Controls(i))
                gv.Controls.AddAt(i, l)
            End If
            If gv.Controls(i).HasControls() Then
                PrepareGridViewForExport(gv.Controls(i))
            End If
            System.Math.Max(System.Threading.Interlocked.Increment(i), i - 1)
        End While
    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub

    Public Shadows Function FindControl(ByVal id As String) As Control
        Return FindControl(Page, id)
    End Function

    Public Sub SetPagerButtonStates(ByVal gridView As GridView, ByVal gvPagerRow As GridViewRow, ByVal page As Page)
        Dim pageIndex As Integer = gridView.PageIndex
        Dim pageCount As Integer = gridView.PageCount

        Dim btnFirst As LinkButton = TryCast(gvPagerRow.FindControl("btnFirst"), LinkButton)
        Dim btnPrevious As LinkButton = TryCast(gvPagerRow.FindControl("btnPrevious"), LinkButton)
        Dim btnNext As LinkButton = TryCast(gvPagerRow.FindControl("btnNext"), LinkButton)
        Dim btnLast As LinkButton = TryCast(gvPagerRow.FindControl("btnLast"), LinkButton)
        Dim lblNumber As Label = TryCast(gvPagerRow.FindControl("lblNumber"), Label)
        Dim txtPageSize As TextBox = TryCast(gvPagerRow.FindControl("txtPageSize"), TextBox)
        'lblNumber.Text = "Pages " + Convert.ToString(pageIndex + 1) + " of " + pageCount.ToString()
        lblNumber.Text = pageCount.ToString()

        btnFirst.Enabled = btnPrevious.Enabled = (pageIndex <> 0)
        btnNext.Enabled = btnLast.Enabled = (pageIndex < (pageCount - 1))

        If btnNext.Enabled = False Then
            btnNext.Attributes.Remove("CssClass")
        End If
        Dim ddlPageSelector As DropDownList = DirectCast(gvPagerRow.FindControl("ddlPageSelector"), DropDownList)
        ddlPageSelector.Items.Clear()

        For i As Integer = 1 To gridView.PageCount
            ddlPageSelector.Items.Add(i.ToString())
        Next

        ddlPageSelector.SelectedIndex = pageIndex
        txtPageSize.Text = gridView.PageSize.ToString()

        'Used delegates over here
        Dim lnk As LinkButton = TryCast(gvPagerRow.FindControl("lnkSavePageSize"), LinkButton)
        AddHandler lnk.Click, AddressOf lnkSavePageSize_click
        AddHandler ddlPageSelector.SelectedIndexChanged, AddressOf pageSelector_SelectedIndexChanged

        AddHandler btnFirst.Click, AddressOf pageButton_Click
        AddHandler btnPrevious.Click, AddressOf pageButton_Click
        AddHandler btnNext.Click, AddressOf pageButton_Click
        AddHandler btnLast.Click, AddressOf pageButton_Click
    End Sub

    Public Sub ShowMsg(ByVal msgText As String)
        dvMsg.InnerHtml = msgText
        dvMsg.Style("display") = "block"
        dvMsg.Style("class") = "warning"
    End Sub

    Protected Sub admin_settlementtrackerimport_master_Default_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If hdnMonth.Value = "" Then
            hdnMonth.Value = Now.Month
        End If
        If hdnYear.Value = "" Then
            hdnYear.Value = Now.Year
        End If
        ReportMonth = hdnMonth.Value
        ReportYear = hdnYear.Value

        If Not IsPostBack Then
            'LoadMonths()
            BindGrids()
        End If

        If Not IsNothing(ViewState("FilterExpression")) Then
            BindGrids(ViewState("FilterExpression").ToString)
        End If

        SetRollups()
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Dim sqlUpdate As String = String.Format("UPDATE tblSettlementTrackerImports SET CancelDate = getdate(), CancelBy = {0}, lastmodified=getdate(), lastmodifiedby = {0}, status = 'CS' " & _
                                                "WHERE (TrackerImportID = {1})", UserID, txtTrackerImportID.Text)
        Dim results As Integer = SharedFunctions.AsyncDB.executeScalar(sqlUpdate.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
        ShowMsg("Settlement Cancelled!")
        BindGrids()
    End Sub

    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        Dim sqlDel As String = String.Format("DELETE FROM tblSettlementTrackerImports WHERE (TrackerImportID = {0})", txtTrackerImportID.Text)
        Dim results As Integer = SharedFunctions.AsyncDB.executeScalar(sqlDel, ConfigurationManager.AppSettings("connectionstring").ToString)
        ShowMsg("Settlement Deleted!")
        BindGrids()
    End Sub

    Protected Sub btnReactivate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnReactivate.Click
        Dim sqlUpdate As String = String.Format("UPDATE tblSettlementTrackerImports SET CancelDate = NULL, CancelBy = NULL, lastmodified=getdate(), lastmodifiedby = {0},Status= case when paid is not null then 'SA' else 'IF' END  WHERE (TrackerImportID = {1})", UserID, txtTrackerImportID.Text)
        Dim results As Integer = SharedFunctions.AsyncDB.executeScalar(sqlUpdate.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
        ShowMsg("Settlement Reactivated!")
        BindGrids()
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSave.Click
        Dim sqlUpdate As New StringBuilder
        sqlUpdate.Append("UPDATE tblSettlementTrackerImports SET ")

        Dim cols As String = "Team,Negotiator,AgencyID,LawFirm,Date,Status,Due,ClientAcctNumber,Name,CreditorAccountNum," & _
        "OriginalCreditor,CurrentCreditor,BALANCE,SettlementAmt,SettlementPercent,FundsAvail,Note,sent,paid,ClientSavings,SettlementFees,SettlementSavingsPct"

        Dim argList As New List(Of String)
        For Each arg As String In cols.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
            Try
                Select Case arg.ToLower
                    Case "Negotiator".ToLower, "AgencyID".ToLower, "LawFirm".ToLower, "team", "status"
                        argList.Add(arg & "='" & TryCast(FindControl("ddl" & arg), DropDownList).SelectedItem.Value & "'")
                    Case "SettlementPercent".ToLower, "SettlementSavingsPct".ToLower
                        argList.Add(arg & "='" & TryCast(FindControl("txt" & arg), TextBox).Text.Replace("'", "''").Replace("$", "").Replace(",", "").Replace("%", "") / 100 & "'")
                    Case Else
                        argList.Add(arg & "='" & TryCast(FindControl("txt" & arg), TextBox).Text.Replace("'", "''").Replace("$", "").Replace(",", "").Replace("%", "") & "'")
                End Select

            Catch ex As Exception
                argList.Add(arg & "=''")
                Continue For
            End Try

        Next
        argList.Add(String.Format("LastModifiedBy = {0}", UserID))
        argList.Add("LastModified = getdate()")

        sqlUpdate.Append(Join(argList.ToArray, ","))
        sqlUpdate.AppendFormat(" WHERE (TrackerImportID = {0})", txtTrackerImportID.Text)

        Dim results As Integer = SharedFunctions.AsyncDB.executeScalar(sqlUpdate.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)

        ShowMsg("Settlement Updated!")
        BindGrids()
    End Sub

    Protected Sub dsMaster_Updating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceCommandEventArgs) Handles dsMaster.Updating
        e.Command.Parameters(1).Value = CDate(e.Command.Parameters(1).Value)
    End Sub

    Protected Sub gvMaster_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvMaster.RowCommand

        Select Case e.CommandName.ToLower
            Case "select".ToLower
                LoadSettlementPopupInfo(e.CommandArgument)
                ModalPopupExtender1.Show()
        End Select


    End Sub
    Private Sub SelectDDL(ByVal ddlToUse As DropDownList, ByVal valueToFind As String)
        Try
            ddlToUse.SelectedValue = valueToFind
        Catch ex As Exception
            ddlToUse.SelectedValue = ""
        End Try

    End Sub
    Private Function FormatDateBox(ByVal dateString As String) As String
        If Not dateString.ToString = "" Then
            If Year(dateString) <> 1900 Then
                Return FormatDateTime(dateString, DateFormat.ShortDate)
            Else
                Return ""
            End If
        Else
            Return ""
        End If

    End Function
    Private Sub LoadSettlementPopupInfo(ByVal trackID As Integer)
        Dim sqlTrackers As String = String.Format("select * from tblsettlementtrackerimports with(nolock) where trackerimportid = {0}", trackID)
        Using dt As DataTable = SqlHelper.GetDataTable(sqlTrackers, CommandType.Text)
            For Each sett As DataRow In dt.Rows
                txtTrackerImportID.Text = trackID
                SelectDDL(ddlTeam, sett("team").ToString)
                SelectDDL(ddlNegotiator, sett("Negotiator").ToString)
                SelectDDL(ddlAgencyID, sett("agencyid").ToString)
                SelectDDL(ddlLawFirm, sett("lawfirm").ToString)
                SelectDDL(ddlStatus, sett("status").ToString)

                txtDate.Text = FormatDateTime(sett("Date").ToString, DateFormat.ShortDate)
                txtDue.Text = FormatDateTime(sett("due").ToString, DateFormat.ShortDate)
                txtClientAcctNumber.Text = sett("ClientAcctNumber").ToString
                txtName.Text = sett("Name").ToString
                txtCreditorAccountNum.Text = sett("CreditorAccountNum").ToString
                txtOriginalCreditor.Text = sett("OriginalCreditor").ToString
                txtCurrentCreditor.Text = sett("CurrentCreditor").ToString
                txtBALANCE.Text = FormatCurrency(sett("BALANCE").ToString, 2, TriState.True, TriState.False, TriState.True)
                txtSettlementAmt.Text = FormatCurrency(sett("SettlementAmt").ToString, 2, TriState.True, TriState.False, TriState.True)
                txtSettlementPercent.Text = FormatPercent(sett("SettlementPercent").ToString, 2)
                txtFundsAvail.Text = FormatCurrency(sett("FundsAvail").ToString, 2, TriState.True, TriState.False, TriState.True)
                txtNote.Text = sett("Note").ToString
                txtsent.Text = FormatDateBox(sett("sent").ToString)
                txtpaid.Text = FormatDateBox(sett("paid").ToString)
                txtClientSavings.Text = FormatCurrency(sett("ClientSavings").ToString, 2, TriState.True, TriState.False, TriState.True)
                txtSettlementFees.Text = FormatCurrency(sett("SettlementFees").ToString, 2, TriState.True, TriState.False, TriState.True)
                txtSettlementSavingsPct.Text = FormatPercent(sett("SettlementSavingsPct").ToString, 2)

                Exit For
            Next
        End Using
    End Sub
    Protected Sub gvMaster_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvMaster.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvMaster, e.Row, Me)
            Case DataControlRowType.Header
                gvMaster.Controls(0).Controls.AddAt(0, AddHeaderRow(e))
        End Select
    End Sub

    Protected Sub gvMaster_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvMaster.RowDataBound
        Select Case e.Row.RowType

            Case DataControlRowType.DataRow
                'get row data
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

                'set row attributes
                e.Row.Style("cursor") = "hand"

                If Not IsDBNull(rowView("canceldate")) Then
                    e.Row.Style("background-color") = "#FF6A6A"
                    e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#FF6A6A'; this.style.filter = 'alpha(opacity=30)';")
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#FF6A6A'; this.style.filter = '';")
                Else
                    e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#F0F5FB'; this.style.filter = 'alpha(opacity=30)';")
                    'e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")
                    e.Row.Attributes.Add("onmouseout", "this.className='RowReset';")
                End If

                e.Row.Cells(11).BackColor = If(Double.Parse(rowView("fundsAvail").ToString) < Double.Parse(rowView("settlementamt").ToString), Drawing.ColorTranslator.FromHtml("#ff0000"), Drawing.ColorTranslator.FromHtml("#008000"))

                'add javascript to row event
                e.Row.Attributes.Add("ondblclick", Page.ClientScript.GetPostBackEventReference(sender, "Select$" + rowView("TrackerImportID").ToString))

                'build tooltip text
                Dim ToolTip As New StringBuilder

                ToolTip.AppendFormat("Cancel Date: {0}" & vbCrLf, rowView("CancelDate").ToString)
                ToolTip.AppendFormat("Agency Code: {0}" & vbCrLf, rowView("AgencyID").ToString)
                ToolTip.AppendFormat("Original Creditor: {0}" & vbCrLf, rowView("OriginalCreditor").ToString)
                ToolTip.AppendFormat("Settlement Percent: {0}" & vbCrLf, rowView("SettlementPercent").ToString)
                ToolTip.AppendFormat("Client Savings: {0}" & vbCrLf, FormatCurrency(If(rowView("ClientSavings").ToString = "", "0", rowView("ClientSavings").ToString), 2))
                ToolTip.AppendFormat("Settlement Fees: {0}" & vbCrLf, FormatCurrency(If(rowView("SettlementFees").ToString = "", "0", rowView("SettlementFees").ToString), 2))
                ToolTip.AppendFormat("Notes: {0}" & vbCrLf, rowView("note").ToString)
                e.Row.ToolTip = ToolTip.ToString

                Dim chk As HtmlInputCheckBox = e.Row.FindControl("chk_select")
                chk.Attributes.Add("trackerID", rowView("TrackerImportID").ToString)

        End Select
    End Sub

    Protected Sub gvMaster_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvMaster.Sorting
        ResetMsg()
        GridViewHelper.AppendSortOrderImageToGridHeader(e.SortDirection, e.SortExpression, DirectCast(sender, GridView))
    End Sub

    Protected Sub lnkCancelSelected_click(ByVal sender As Object, ByVal e As EventArgs)
        ResetMsg()

        Dim ids As New List(Of String)

        For Each row As GridViewRow In gvMaster.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = TryCast(row.Controls(0).Controls(1), System.Web.UI.HtmlControls.HtmlInputCheckBox)
                If chk.Checked = True Then
                    Dim tID As String = chk.Attributes("trackerID").ToString
                    ids.Add(tID)
                End If
            End If
        Next

        If ids.Count > 0 Then
            Dim sqlUpdate As String = String.Format("UPDATE tblSettlementTrackerImports SET CancelDate = getdate(), CancelBy = {0}, lastmodified=getdate(), lastmodifiedby = {0} " & _
                                                  "WHERE (TrackerImportID in ({1}))", UserID, Join(ids.ToArray, ","))
            Dim results As Integer = SharedFunctions.AsyncDB.executeScalar(sqlUpdate.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
            ShowMsg(String.Format("{0} Settlement(s) Cancelled!", results))
            BindGrids()
        End If
    End Sub

    Protected Sub lnkChangeMonth_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeMonth.Click
        BindGrids()
    End Sub

    Protected Sub lnkChangeYear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeYear.Click
        BindGrids()
    End Sub

    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        ResetMsg()
        BindGrids("")
        ViewState("FilterExpression") = Nothing
        Using temp1 As TextBox = DirectCast(FindControl("txtFilterText"), TextBox)
            If Not IsNothing(temp1) Then
                temp1.Text = ""
            End If
        End Using

    End Sub

    Protected Sub lnkDeleteSelected_click(ByVal sender As Object, ByVal e As EventArgs)
        ResetMsg()

        Dim ids As New List(Of String)

        For Each row As GridViewRow In gvMaster.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = TryCast(row.Controls(0).Controls(1), System.Web.UI.HtmlControls.HtmlInputCheckBox)
                If chk.Checked = True Then
                    Dim tID As String = chk.Attributes("trackerID").ToString
                    ids.Add(tID)
                End If
            End If
        Next
        If ids.Count > 0 Then
            Dim sqlDel As String = String.Format("DELETE FROM tblSettlementTrackerImports WHERE (TrackerImportID in ({0}))", Join(ids.ToArray, ","))
            Dim results As Integer = SharedFunctions.AsyncDB.executeScalar(sqlDel, ConfigurationManager.AppSettings("connectionstring").ToString)
            ShowMsg(String.Format("{0} Settlement(s) Deleted!", results))
            BindGrids()
        End If
    End Sub

    Protected Sub lnkFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        ResetMsg()
        Dim searchText As String = ""
        Dim temp1 As TextBox = DirectCast(FindControl("txtFilterText"), TextBox)
        If Not IsNothing(temp1) Then
            If temp1.Text <> "" Then
                searchText = temp1.Text
            End If
        End If
        Dim filterText As New StringBuilder
        filterText.AppendFormat("team like '%{0}%' ", searchText)
        filterText.AppendFormat("or negotiator like '%{0}%' ", searchText)
        filterText.AppendFormat("or currentcreditor like '%{0}%' ", searchText)
        filterText.AppendFormat("or agencyid like '%{0}%' ", searchText)
        filterText.AppendFormat("or ClientAcctNumber like '%{0}%' ", searchText)
        filterText.AppendFormat("or CreditorAccountNum like '%{0}%' ", searchText)
        filterText.AppendFormat("or Name like '%{0}%' ", searchText)

        BindGrids(filterText.ToString)
    End Sub

    Protected Sub lnkSavePageSize_click(ByVal sender As Object, ByVal e As EventArgs)
        ResetMsg()
        Dim pagerRow As GridViewRow = gvMaster.BottomPagerRow
        Dim temp1 As TextBox = DirectCast(pagerRow.FindControl("txtPageSize"), TextBox)
        If temp1.Text <> "" Then
            gvMaster.PageSize = Convert.ToInt32(temp1.Text)
        End If
    End Sub

    Private Sub BindGrids()
        dsMaster.SelectParameters("year").DefaultValue = ReportYear
        dsMaster.SelectParameters("month").DefaultValue = ReportMonth
        dsMaster.DataBind()
        gvMaster.DataBind()
    End Sub

    Private Sub BindGrids(ByVal filterText As String)
        dsMaster.FilterExpression = filterText.ToString
        dsMaster.DataBind()
        gvMaster.DataBind()
        ViewState("FilterExpression") = dsMaster.FilterExpression
    End Sub

    Private Sub ResetMsg()
        dvMsg.InnerHtml = ""
        dvMsg.Style("display") = "none"
        dvMsg.Style("class") = "warning"
    End Sub

    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settlementtrackerimport_trackerimport).CommonTasks
        Dim selectCode As New StringBuilder
        selectCode.Append("Select Month<br/>")
        selectCode.Append("<select id=""cboMonth"" runat=""server"" class=""entry"" onchange=""MonthChanged(this);"">")
        For i As Integer = 1 To 12
            Dim optText As String = ""
            If i = ReportMonth Then
                optText = String.Format("<option label=""{0}"" value=""{1}"" selected=""selected"" />", MonthName(i, False), i)
            Else
                optText = String.Format("<option label=""{0}"" value=""{1}"" />", MonthName(i, False), i)
            End If
            selectCode.Append(optText)
        Next
        selectCode.Append("</select><br/>")
        selectCode.Append("Select Year<br/>")
        selectCode.Append("<select id=""cboYear"" runat=""server"" class=""entry"" onchange=""YearChanged(this);"">")
        For i As Integer = Now.AddYears(-3).Year To Now.Year
            Dim optText As String = ""
            If i = ReportYear Then
                optText = String.Format("<option label=""{0}"" value=""{1}"" selected=""selected"" />", i, i)
            Else
                optText = String.Format("<option label=""{0}"" value=""{1}"" />", i, i)
            End If
            selectCode.Append(optText)
        Next
        selectCode.Append("</select>")

        selectCode.Append("<br/><br/>")
        selectCode.Append("<Table class=""entry2"">")
        selectCode.Append("<tr><td colspan=""2"" style=""background-color:#3D3D3D;color:white; text-align:center;"">Legend</td></tr>")
        selectCode.Append("<tr><td>Sett. Cancelled</td><td style=""width:10px;background-color:#FF6A6A;""></td></tr>")
        selectCode.Append("<tr><td>Client Bal > Sett.</td><td style=""width:10px;background-color:#008000;""></td></tr>")
        selectCode.Append("<tr><td>Client Bal < Sett.</td><td style=""width:10px;background-color:#ff0000;""></td></tr>")
        selectCode.Append("<tr><td colspan=""2"" style=""border-top:1px solid black;""><strong>PA = Payment Arrangement</strong></td></tr>")
        selectCode.Append("</Table>")

        CommonTasks.Add(selectCode.ToString)
    End Sub

    Private Sub pageButton_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        ResetMsg()
        Dim lnk As LinkButton = TryCast(sender, LinkButton)
        If Not IsNothing(lnk) Then
            Select Case lnk.Text.ToLower
                Case "first"
                    gvMaster.PageIndex = 0
                Case "previous"
                    gvMaster.PageIndex -= 1
                Case "next"
                    gvMaster.PageIndex += 1
                Case "last"
                    gvMaster.PageIndex = gvMaster.PageCount

            End Select
            gvMaster.DataBind()

        End If
    End Sub

    Private Sub pageSelector_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        ResetMsg()
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        gvMaster.PageIndex = ddl.SelectedIndex
        gvMaster.DataBind()
    End Sub

    #End Region 'Methods

End Class