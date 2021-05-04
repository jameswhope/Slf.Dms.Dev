Imports System.Data

Imports Drg.Util.DataAccess

Imports LocalHelper

Partial Class CustomTools_UserControls_CreditorHarassmentFormSearchControl
    Inherits System.Web.UI.UserControl

    #Region "Fields"

    Private _UserID As Integer

    #End Region 'Fields

    #Region "Properties"

    Public Property GridViewSortDirection() As SortDirection
        Get
            If IsNothing(ViewState("sortDirection")) Then
                ViewState("sortDirection") = SortDirection.Ascending
            End If

            Return ViewState("sortDirection")
        End Get
        Set(ByVal value As SortDirection)
            ViewState("sortDirection") = value
        End Set
    End Property

    Public Property SortColumn() As String
        Get
            If IsNothing(ViewState("SortColumn")) Then
                ViewState("SortColumn") = "ClientAccountNumber"
            End If

            Return ViewState("SortColumn")
        End Get
        Set(ByVal value As String)
            ViewState("SortColumn") = value
        End Set
    End Property

    Public Property UserID() As Integer
        Get
            Return _UserID
        End Get
        Set(ByVal value As Integer)
            _UserID = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Public Function AddHeaderRow(ByVal gridHeaderRow As System.Web.UI.WebControls.GridViewRowEventArgs) As GridViewRow
        'Add another Header Row
        Dim row As New GridViewRow(-1, -1, DataControlRowType.Header, DataControlRowState.Normal)
        row.BackColor = System.Drawing.ColorTranslator.FromHtml("#3376AB")
        row.ForeColor = System.Drawing.Color.White
        row.CssClass = "entry2"
        row.Style("height") = "30px"
        row.Style("padding") = "3px"

        Dim sortcell As New TableCell()
        sortcell.ColumnSpan = gridHeaderRow.Row.Cells.Count - 1 / 2

        Dim dvRt As New HtmlGenericControl("div style=""float:right; white-space:nowrap;"" ")
        Dim lbl As New Label
        lbl.CssClass = "entry2"
        lbl.Text = "Sort By Column:"
        dvRt.Controls.Add(lbl)

        Dim ddl As New DropDownList
        ddl.AutoPostBack = True
        ddl.ID = "ddlSortColumn"
        ddl.CssClass = "entry2"
        AddHandler ddl.SelectedIndexChanged, AddressOf ddlsort_selectedindexChanged
        For Each col As DataControlField In gvSearch.Columns
            If TypeOf col Is BoundField Then
                If col.HeaderText.ToLower <> "clientsubmissionid" Then
                    Dim li As New ListItem(col.HeaderText, col.SortExpression)
                    If Not IsNothing(ViewState("sortcolumn")) Then
                        If ViewState("sortcolumn").ToString = col.SortExpression Then
                            ddl.ClearSelection()
                            li.Selected = True
                        End If
                    End If
                    ddl.Items.Add(li)
                End If
            End If
        Next

        Dim sd As New ListItem("Status Description", "StatusDescription")
        If Not IsNothing(ViewState("sortcolumn")) Then
            If ViewState("sortcolumn").ToString = "StatusDescription" Then
                ddl.ClearSelection()
                sd.Selected = True
            End If
        End If
        ddl.Items.Add(sd)
        dvRt.Controls.Add(ddl)

        Dim lnkAsc As New ImageButton
        With lnkAsc
            .ID = "lnkAsc"
            .ImageUrl = ResolveUrl("~/images/12x13_arrow_down.png")
            AddHandler .Click, AddressOf imgButton_Click
        End With
        dvRt.Controls.Add(lnkAsc)

        Dim lnkDesc As New ImageButton
        With lnkDesc
            .ID = "lnkDesc"
            .ImageUrl = ResolveUrl("~/images/12x13_arrow_up.png")
            AddHandler .Click, AddressOf imgButton_Click
        End With

        dvRt.Controls.Add(lnkDesc)

        sortcell.Controls.Add(dvRt)
        row.Cells.Add(sortcell)

        Dim lnkExportExcel As New LinkButton() With {.Text = "Export to Excel", .ID = "lnkExportExcel", .ForeColor = System.Drawing.Color.White, .CssClass = "lnk"}
        AddHandler lnkExportExcel.Click, AddressOf lnkExportExcel_Click
        Dim sm As ScriptManager = ScriptManager.GetCurrent(Me.Page)
        sm.RegisterPostBackControl(lnkExportExcel)
        Dim dvleft As New HtmlGenericControl("div style=""float:left"" ")
        dvleft.Controls.Add(New HtmlImage() With {.Src = ResolveUrl("~/images/16x16_edit.gif")})
        dvleft.Controls.Add(lnkExportExcel)
        sortcell.Controls.Add(dvleft)

        row.Cells.Add(sortcell)

        Return row
    End Function

    ''' <summary>
    ''' set gridview pager buttons
    ''' </summary>
    ''' <param name="gridView"></param>
    ''' <param name="gvPagerRow"></param>
    ''' <param name="page"></param>
    ''' <remarks></remarks>
    Public Sub SetPagerButtonStates(ByVal gridView As GridView, ByVal gvPagerRow As GridViewRow, ByVal page As Page)
        Dim pageIndex As Integer = gridView.PageIndex
        Dim pageCount As Integer = gridView.PageCount

        Dim btnFirst As LinkButton = TryCast(gvPagerRow.FindControl("btnFirst"), LinkButton)
        Dim btnPrevious As LinkButton = TryCast(gvPagerRow.FindControl("btnPrevious"), LinkButton)
        Dim btnNext As LinkButton = TryCast(gvPagerRow.FindControl("btnNext"), LinkButton)
        Dim btnLast As LinkButton = TryCast(gvPagerRow.FindControl("btnLast"), LinkButton)
        Dim lblNumber As Label = TryCast(gvPagerRow.FindControl("lblNumber"), Label)

        lblNumber.Text = pageCount.ToString()

        btnFirst.Enabled = btnPrevious.Enabled = (pageIndex <> 0)
        btnLast.Enabled = btnNext.Enabled = (pageIndex < (pageCount - 1))

        btnPrevious.Enabled = (pageIndex <> 0)
        btnNext.Enabled = (pageIndex < (pageCount - 1))

        If btnNext.Enabled = False Then
            btnNext.Attributes.Remove("CssClass")
        End If
        Dim ddlPageSelector As DropDownList = DirectCast(gvPagerRow.FindControl("ddlPageSelector"), DropDownList)
        ddlPageSelector.Items.Clear()

        For i As Integer = 1 To gridView.PageCount
            ddlPageSelector.Items.Add(i.ToString())
        Next

        ddlPageSelector.SelectedIndex = pageIndex

        'Used delegates over here
        AddHandler ddlPageSelector.SelectedIndexChanged, AddressOf pageSelector_SelectedIndexChanged
    End Sub

    Public Sub pageSelector_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        Using gv As GridView = ddl.Parent.Parent.Parent.Parent
            If Not IsNothing(gv) Then
                gv.PageIndex = ddl.SelectedIndex
                gv.DataBind()
            End If
        End Using
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        AddHandler ddlSearchColumn.SelectedIndexChanged, AddressOf ddl_selectedindexChanged
        If Not IsPostBack Then
            BuildSearchBox()
            dsStats.DataBind()
            gvStats.DataBind()
        End If

        Dim sm As ScriptManager = ScriptManager.GetCurrent(Me.Page)
        sm.RegisterPostBackControl(imgExportStatsBtn)

    End Sub

    Protected Sub ddlQuickPickDate_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = DirectCast(sender, DropDownList)
        If ddl.SelectedValue.ToString <> "Custom" Then
            Dim parts As String() = ddl.SelectedValue.Split(",")
            txtStart.Text = parts(0)
            txtEnd.Text = parts(1)
        End If
    End Sub

    Protected Sub dsSearch_Selected(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsSearch.Selected
        lblResultCnt.Text = String.Format("{0} Record(s)", e.AffectedRows)
    End Sub

    Protected Sub gvSearch_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvSearch.RowCommand
        Select Case e.CommandName.ToLower
            Case "update"
                dsSearch.UpdateParameters("clientsubmissionid").DefaultValue = e.CommandArgument

                Dim row As GridViewRow
                row = CType(CType(e.CommandSource, LinkButton).Parent.Parent, GridViewRow)
                Dim ddl As System.Web.UI.WebControls.DropDownList = gvSearch.Rows(row.RowIndex).FindControl("ddlStatus")
                dsSearch.UpdateParameters("statusid").DefaultValue = ddl.SelectedItem.Value

                Dim ddldecline As System.Web.UI.WebControls.DropDownList = gvSearch.Rows(row.RowIndex).FindControl("ddlDeclineReason")
                dsSearch.UpdateParameters("declinereasonid").DefaultValue = ddldecline.SelectedItem.Value

        End Select
    End Sub

    Protected Sub gvSearch_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSearch.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvSearch, e.Row, Me.Page)
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
                gvSearch.Controls(0).Controls.AddAt(0, AddHeaderRow(e))
        End Select
    End Sub

    Protected Sub gvSearch_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSearch.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                e.Row.Style("cursor") = "hand"
                Select Case e.Row.RowState
                    Case DataControlRowState.Alternate
                        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#F3F3F3';")
                    Case DataControlRowState.Normal
                        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End Select

                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';")

                e.Row.Attributes.Add("ondblclick", String.Format("showDetail('{0}');", Server.HtmlEncode(rowView("docpath").ToString.Replace("\", "\\"))))
        End Select
    End Sub

    Protected Sub gvStats_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvStats.RowCreated
         Select e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvStats, e.Row, Me.Page)
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
        End Select

    End Sub

    Protected Sub gvStats_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvStats.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';")

        End Select
    End Sub

    Private Sub BindData(Optional ByVal SearchColumn As String = "ClientAccountNumber", Optional ByVal SearchTerm As String = " ")
        dsSearch.SelectParameters("searchColumn").DefaultValue = SearchColumn
        dsSearch.SelectParameters("searchTerm").DefaultValue = SearchTerm

        dsSearch.DataBind()
        gvSearch.DataBind()
    End Sub

    Private Sub BuildSearchBox()
        For Each col As DataControlField In gvSearch.Columns
            If TypeOf col Is BoundField Then
                If col.HeaderText.ToLower <> "clientsubmissionid" Then
                    ddlSearchColumn.Items.Add(New ListItem(col.HeaderText, col.SortExpression))
                End If
            End If
        Next

        ddlSearchColumn.Items.Add(New ListItem("Status Description", "StatusDescription"))

        LoadQuickPickDates()
    End Sub

    Private Sub LoadQuickPickDates()
        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yyyy") & "," & Now.ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yyyy") & "," & Now.AddDays(0).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        Dim SelectedIndex As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblQuerySetting", "Value", _
                  "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'ddlQuickPickDate'"), 0)

        ddlQuickPickDate.SelectedIndex = SelectedIndex
        If Not ddlQuickPickDate.Items(SelectedIndex).Value = "Custom" Then
            Dim parts As String() = ddlQuickPickDate.Items(SelectedIndex).Value.Split(",")
            txtStart.Text = parts(0)
            txtEnd.Text = parts(1)
        End If
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

    Private Sub ddl_selectedindexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)

        Select Case ddl.SelectedItem.Value
            Case "DateFormSubmitted", "IndividualCallingDateOfCall", "HarassmentStatusDate"
                divDateSearch.Style("display") = "inline-block"
                txtSearch.Visible = False
                ddlSearch.Visible = False
            Case "StatusDescription"
                Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync("select HarassmentStatusID,StatusDescription from tblharassmentstatusreasons", ConfigurationManager.AppSettings("Connectionstring").ToString)
                    ddlSearch.DataTextField = "StatusDescription"
                    ddlSearch.DataValueField = "StatusDescription"
                    ddlSearch.DataSource = dt
                    ddlSearch.DataBind()
                End Using
                divDateSearch.Style("display") = "none"
                txtSearch.Visible = False
                ddlSearch.Visible = True
            Case "ClientState"
                Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync("select name,abbreviation from tblstate order by abbreviation", ConfigurationManager.AppSettings("Connectionstring").ToString)
                    ddlSearch.DataTextField = "name"
                    ddlSearch.DataValueField = "abbreviation"
                    ddlSearch.DataSource = dt
                    ddlSearch.DataBind()
                End Using
                divDateSearch.Style("display") = "none"
                txtSearch.Visible = False
                ddlSearch.Visible = True
            Case Else
                ddlSearch.Visible = False
                divDateSearch.Style("display") = "none"
                txtSearch.Visible = True
        End Select
    End Sub

    Private Sub ddlsort_selectedindexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        SortColumn = ddl.SelectedItem.Value
    End Sub

    Private Sub imgButton_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim img As ImageButton = TryCast(sender, ImageButton)

        Select Case img.ID.ToLower
            Case "lnkAsc".ToLower
                GridViewSortDirection = SortDirection.Ascending

            Case Else
                GridViewSortDirection = SortDirection.Descending
        End Select
        gvSearch.Sort(SortColumn, GridViewSortDirection)
    End Sub

    Private Sub lnkExportExcel_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim stringWrite As New System.IO.StringWriter()
        Dim htmlWrite As New HtmlTextWriter(stringWrite)

        'Dim dv As DataView = dsSearch.Select(DataSourceSelectArguments.Empty)
        Response.Clear()
        Response.AddHeader("content-disposition", "attachment;filename=harass.xls")
        Response.Charset = ""
        Response.ContentType = "application/ms-excel"
        gvExport.DataSourceID = dsSearch.ID
        gvExport.AllowPaging = False
        gvExport.DataBind()
        PrepareGridViewForExport(gvExport)
        gvExport.RenderControl(htmlWrite)
       
        Response.Write(stringWrite.ToString())
        Response.End()
    End Sub

    Private Sub lnkSearchReset_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkClear.Click
        ddlSearch.Visible = False
        divDateSearch.Style("display") = "none"
        txtSearch.Visible = False
        ddlSearchColumn.SelectedIndex = 0
        BindData()
    End Sub

    Private Sub lnkSearch_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkSearch.Click
        Dim searchCol As String = ddlSearchColumn.SelectedItem.Value
        Dim searchVal As String
        Select Case searchCol
            Case "DateFormSubmitted", "IndividualCallingDateOfCall", "HarassmentStatusDate"
                searchVal = String.Format("{0}|{1}", txtStart.Text, txtEnd.Text)
            Case "StatusDescription", "ClientState"
                searchVal = ddlSearch.SelectedItem.Value
            Case Else
                searchVal = txtSearch.Text
        End Select

        BindData(searchCol, searchVal)
    End Sub

    #End Region 'Methods

    Protected Sub imgExportStatsBtn_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgExportStatsBtn.Click
        Dim stringWrite As New System.IO.StringWriter()
        Dim htmlWrite As New HtmlTextWriter(stringWrite)

        'Dim dv As DataView = dsSearch.Select(DataSourceSelectArguments.Empty)
        Response.Clear()
        Response.AddHeader("content-disposition", "attachment;filename=harassstats.xls")
        Response.Charset = ""
        Response.ContentType = "application/ms-excel"
        gvExport.DataSourceID = dsStats.ID
        gvExport.AllowPaging = False
        gvExport.DataBind()
        PrepareGridViewForExport(gvExport)
        gvExport.RenderControl(htmlWrite)
        Response.Write(stringWrite.ToString())
        Response.End()
    End Sub
End Class