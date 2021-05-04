Imports System.Collections.Generic
Imports System.Data
Imports System.IO

Partial Class research_reports_clients_ActiveClientsData
    Inherits PermissionPage

    #Region "Methods"

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub

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

    Protected Sub ddlFilter_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim filterText As New StringBuilder
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        Dim colName As String = ddl.ID.ToLower.Replace("ddl", "").Replace("filter", "")
        Select Case colName
            Case "account #"
                colName = "accountnumber"
            Case "client name"
                colName = "clientname"
            
        End Select

        filterText.AppendFormat("{0} like '%{1}%' ", colName, ddl.SelectedItem.Text)

        BindGrids(filterText.ToString)
    End Sub

    Protected Sub gvClients_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvClients.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvClients, e.Row, Me)
            Case DataControlRowType.Header
                For Each hdr As TableCell In e.Row.Cells
                    Dim ColText As String = TryCast(hdr.Controls(0), LinkButton).Text.ToLower
                    AddFilterControls(ColText, hdr, TryCast(sender, GridView).SortExpression, TryCast(sender, GridView).SortDirection)
                Next
        End Select
    End Sub

    Protected Sub gvClients_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvClients.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                'get row data
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

                'set row attributes
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#F0F5FB'; this.style.filter = 'alpha(opacity=30)';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")
            Case DataControlRowType.Header


        End Select
    End Sub

    Protected Sub gvClients_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvClients.Sorting
        GridViewHelper.AppendSortOrderImageToGridHeader(e.SortDirection, e.SortExpression, sender)
        BindGrids()
    End Sub

    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click
        ViewState("FilterExpression") = Nothing
        'txtFilter.Text = ""
        BindGrids("")
    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Dim dv As DataView = ds_Clients.Select(DataSourceSelectArguments.Empty)

        dv.Sort = "lawfirm,state"

        Dim tblTransactions As DataTable = dv.Table
        Dim gridRows() As DataRow = Nothing
        If Not IsNothing(ViewState("FilterExpression")) Then
            gridRows = tblTransactions.Select(ViewState("FilterExpression"), "lawfirm,state")
        Else
            gridRows = tblTransactions.Select("", "lawfirm,state")
        End If

        Dim sw As New StringWriter
        Dim htw As New HtmlTextWriter(sw)
        Dim table As New System.Web.UI.WebControls.Table
        Dim tr As New System.Web.UI.WebControls.TableRow
        Dim cell As TableCell

        For i As Integer = 0 To tblTransactions.Columns.Count - 1
            cell = New TableCell
            cell.Text = tblTransactions.Columns(i).ColumnName
            tr.Cells.Add(cell)
        Next
        table.Rows.Add(tr)

        For Each row As DataRow In gridRows
            tr = New TableRow
            For i As Integer = 0 To tblTransactions.Columns.Count - 1
                cell = New TableCell
                cell.Attributes.Add("class", "text")
                cell.Text = row.Item(i).ToString
                tr.Cells.Add(cell)
            Next
            table.Rows.Add(tr)
        Next

        table.RenderControl(htw)

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.ContentType = "application/ms-excel"
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=active_clients_by_state.xls")
        HttpContext.Current.Response.Write(sw.ToString)
        HttpContext.Current.Response.End()
    End Sub

    Protected Sub lnkSavePageSize_click(ByVal sender As Object, ByVal e As EventArgs)
        Dim pagerRow As GridViewRow = gvClients.BottomPagerRow
        Dim temp1 As TextBox = DirectCast(pagerRow.FindControl("txtPageSize"), TextBox)
        If temp1.Text <> "" Then
            gvClients.PageSize = Convert.ToInt32(temp1.Text)
        End If
        BindGrids()
    End Sub

    Protected Sub research_reports_clients_ActiveClientsData_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ViewState("FilterExpression") = Nothing
        End If

        SetRollups()
    End Sub

    Private Sub BindGrids()
        If Not IsNothing(ViewState("FilterExpression")) Then
            ds_Clients.FilterExpression = ViewState("FilterExpression").ToString
            lblCurrentFilter.Text = String.Format("Filter: {0}", ViewState("FilterExpression")).Replace("%", "")
        Else
            ds_Clients.FilterExpression = Nothing
            lblCurrentFilter.Text = ""
        End If

        ds_Clients.DataBind()
        ds_Clients.DataBind()
        gvClients.DataBind()
    End Sub

    Private Sub BindGrids(ByVal filterText As String)
        If IsNothing(ViewState("FilterExpression")) Then
            ds_Clients.FilterExpression = filterText.ToString
        Else
            If Not ViewState("FilterExpression").ToString = "" Then
                ds_Clients.FilterExpression = String.Format("{0} AND {1}", ViewState("FilterExpression").ToString, filterText.ToString)
            Else
                ds_Clients.FilterExpression = filterText.ToString
            End If
        End If
        ds_Clients.DataBind()
        ds_Clients.DataBind()
        gvClients.DataBind()
        ViewState("FilterExpression") = ds_Clients.FilterExpression
        lblCurrentFilter.Text = String.Format("Filter: {0}", ViewState("FilterExpression")).Replace("%", "")
    End Sub

    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = CType(Master, research_reports_reports).CommonTasks
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Export();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/icons/xls.png") & """ align=""absmiddle""/>Export to Excel&reg;</a>")
    End Sub

    Private Sub pageButton_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim lnk As LinkButton = TryCast(sender, LinkButton)
        If Not IsNothing(lnk) Then
            Select Case lnk.Text.ToLower
                Case "first"
                    gvClients.PageIndex = 0
                Case "previous"
                    gvClients.PageIndex -= 1
                Case "next"
                    gvClients.PageIndex += 1
                Case "last"
                    gvClients.PageIndex = gvClients.PageCount

            End Select
            'gvClients.DataBind()
            BindGrids()

        End If
    End Sub

    Private Sub pageSelector_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        gvClients.PageIndex = ddl.SelectedIndex
        'gvClients.DataBind()
        BindGrids()
    End Sub
    Private Sub AddFilterControls(ByVal columnName As String, ByRef hdr As TableCell, ByVal sortExp As String, ByVal sortDir As String)
        'clear existing controls
        hdr.Controls.Clear()

        'create table to hold header controls
        Dim tbl As New Table
        tbl.CssClass = "entry"
        Dim tr As New TableRow
        Dim td As New TableCell

        'main column button
        Dim lnkBtn As New LinkButton
        lnkBtn.ID = String.Format("lnk{0}", columnName).Replace(" #", "Number")
        lnkBtn.Text = Strings.StrConv(columnName, VbStrConv.ProperCase)
        lnkBtn.ForeColor = System.Drawing.Color.Black
        lnkBtn.CommandName = "Sort"
        lnkBtn.CommandArgument = columnName.ToLower.Replace("client name", "clientname").Replace(" #", "number")
        lnkBtn.Width = New Unit("90%")
        td.Controls.Add(lnkBtn)

        'add sort image
        If columnName = sortExp Then
            Dim iSort As New Image
            td.Controls.AddAt(1, iSort)
        End If
        'add column name cell
        tr.Cells.Add(td)

        'add filter popup
        td = New TableCell
        td.HorizontalAlign = HorizontalAlign.Right
        Dim img As New Image
        img.ID = String.Format("img{0}", columnName)
        img.ImageUrl = "~/images/16x16_filter.png"
        td.Controls.AddAt(0, img)

        Dim obo As New OboutInc.Flyout2.Flyout
        obo.AttachTo = img.ID
        obo.Position = OboutInc.Flyout2.PositionStyle.BOTTOM_CENTER

        Dim filterDiv As New HtmlGenericControl("DIV class=""filterBox"" ")
        Dim txt As New TextBox
        txt.ID = String.Format("txtFilter{0}", columnName)
        filterDiv.Controls.AddAt(0, txt)

        Dim lnkGo As New LinkButton
        lnkGo.ID = String.Format("lnkGo{0}", columnName)
        lnkGo.Text = "Filter"
        lnkGo.CssClass = "lnk"
        AddHandler lnkGo.Click, AddressOf lnkFilter_Click
        filterDiv.Controls.AddAt(1, lnkGo)
        obo.Controls.Add(filterDiv)

        td.Controls.AddAt(1, obo)
        tr.Cells.Add(td)
        tbl.Rows.Add(tr)
        hdr.Controls.Add(tbl)

    End Sub

    #End Region 'Methods
    Protected Sub lnkFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim filterText As New StringBuilder
        Dim filterTxt As String = ""
        Dim lnk As LinkButton = TryCast(sender, LinkButton)
        Dim colName As String = lnk.ID.ToLower.Replace("lnkgo", "")
        Select Case colName
            Case "client name"
                filterTxt = TryCast(lnk.Parent.FindControl(String.Format("txtFilter{0}", colName)), TextBox).Text
                colName = "clientname"
            Case "account #"
                filterTxt = TryCast(lnk.Parent.FindControl(String.Format("txtFilter{0}", colName)), TextBox).Text
                colName = "accountnumber"
            Case Else
                filterTxt = TryCast(lnk.Parent.FindControl(String.Format("txtFilter{0}", colName)), TextBox).Text
        End Select

        filterText.AppendFormat("{0} like '%{1}%' ", colName, filterTxt)

        BindGrids(filterText.ToString)
    End Sub
End Class