Imports System.Data
Imports System.Data.SqlClient

Partial Class Clients_Enrollment_Dashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.QueryString("mobile") = "1" Then
            hdnNotab.Value = "1"
        End If

        If Not Page.IsPostBack Then
            LoadGrid()
        End If

        dvFilter.Style.Add("display", IIf(hdnFilter.Value = "1", "inline", "none"))
        lnkFilter.Text = IIf(hdnFilter.Value = "1", "Remove Filter ", "Add Filter")

    End Sub

    Private Sub LoadGridDateRange()
        Dim dateFrom As DateTime
        Dim dateTo As DateTime
        Dim dsOutput As DataSet
        Dim params(2) As SqlParameter

        dateFrom = CDate(Me.txtFromDate.Text)
        dateTo = CDate(Me.txtToDate.Text).AddDays(1)
        params(0) = New SqlParameter("@dateFrom", dateFrom)
        params(1) = New SqlParameter("@dateTo", dateTo)
        params(2) = New SqlParameter("@description", String.Format("{0} - {1}", Me.txtFromDate.Text, Me.txtToDate.Text))
        dsOutput = SqlHelper.GetDataSet("stp_MarketingDashboard", , params)

        BuildGrid(dsOutput)
    End Sub

    Private Sub LoadGridDateRangeDays()
        Dim dateFrom As DateTime
        Dim dateTo As DateTime
        Dim dsOutput As DataSet
        Dim params(2) As SqlParameter

        dateFrom = CDate(Me.txtFromDate.Text)
        dateTo = CDate(Me.txtToDate.Text)

        Dim days As Integer = dateTo.Subtract(dateFrom).Days

        For i As Integer = 0 To days
            params(0) = New SqlParameter("@dateFrom", dateTo)
            params(1) = New SqlParameter("@dateTo", dateTo.AddDays(1))
            params(2) = New SqlParameter("@description", String.Format("{0: MM/dd/yyyy}", dateTo))
            If i = 0 Then
                dsOutput = SqlHelper.GetDataSet("stp_MarketingDashboard", , params)
            Else
                dsOutput.Merge(SqlHelper.GetDataSet("stp_MarketingDashboard", , params))
            End If
            dateTo = dateTo.AddDays(-1)
        Next

        BuildGrid(dsOutput)
    End Sub

    Private Sub LoadGrid()
        Dim dateFrom As DateTime
        Dim dateTo As DateTime
        Dim dsOutput As DataSet
        Dim params(2) As SqlParameter

        'Today
        dateFrom = Today
        dateTo = DateAdd(DateInterval.Day, 1, Today)
        params(0) = New SqlParameter("@dateFrom", dateFrom)
        params(1) = New SqlParameter("@dateTo", dateTo)
        params(2) = New SqlParameter("@description", "Today")
        dsOutput = SqlHelper.GetDataSet("stp_MarketingDashboard", , params)

        'Yesterday
        dateFrom = DateAdd(DateInterval.Day, -1, Today)
        dateTo = Today
        params(0) = New SqlParameter("@dateFrom", dateFrom)
        params(1) = New SqlParameter("@dateTo", dateTo)
        params(2) = New SqlParameter("@description", "Yesterday")
        dsOutput.Merge(SqlHelper.GetDataSet("stp_MarketingDashboard", , params))

        'This Week - Mon-Sun
        If DatePart(DateInterval.Weekday, Today) = 1 Then 'Sunday
            dateFrom = DateAdd(DateInterval.Day, -6, Today)
        Else
            dateFrom = DateAdd(DateInterval.Day, -(DatePart(DateInterval.Weekday, Today) - 2), Today)
        End If
        dateTo = DateAdd(DateInterval.Day, 1, Today)
        params(0) = New SqlParameter("@dateFrom", dateFrom)
        params(1) = New SqlParameter("@dateTo", dateTo)
        params(2) = New SqlParameter("@description", "This Week")
        dsOutput.Merge(SqlHelper.GetDataSet("stp_MarketingDashboard", , params))

        'Last Week - Mon-Sun
        dateFrom = DateAdd(DateInterval.Day, -7, dateFrom)
        dateTo = DateAdd(DateInterval.Day, 7, dateFrom)
        params(0) = New SqlParameter("@dateFrom", dateFrom)
        params(1) = New SqlParameter("@dateTo", dateTo)
        params(2) = New SqlParameter("@description", "Last Week")
        dsOutput.Merge(SqlHelper.GetDataSet("stp_MarketingDashboard", , params))

        'This Month
        dateFrom = CDate(Month(Today) & "/1/" & Year(Today))
        dateTo = DateAdd(DateInterval.Day, 1, Today)
        params(0) = New SqlParameter("@dateFrom", dateFrom)
        params(1) = New SqlParameter("@dateTo", dateTo)
        params(2) = New SqlParameter("@description", "This Month")
        dsOutput.Merge(SqlHelper.GetDataSet("stp_MarketingDashboard", , params))

        'Last Month
        dateFrom = CDate(Month(DateAdd(DateInterval.Month, -1, Today)) & "/1/" & Year(DateAdd(DateInterval.Month, -1, Today)))
        dateTo = DateAdd(DateInterval.Month, 1, dateFrom)
        params(0) = New SqlParameter("@dateFrom", dateFrom)
        params(1) = New SqlParameter("@dateTo", dateTo)
        params(2) = New SqlParameter("@description", "Last Month")
        dsOutput.Merge(SqlHelper.GetDataSet("stp_MarketingDashboard", , params))

        BuildGrid(dsOutput)
        'UltraWebGrid1.Height = Unit.Pixel((dsOutput.Tables(3).Rows.Count * 25) + 50)
    End Sub

    Private Sub BuildGrid(ByVal dsOutput As DataSet)
        Dim parentCol(1) As DataColumn
        Dim childCol(1) As DataColumn

        dsOutput.Relations.Add("DateCategory", dsOutput.Tables(0).Columns("Description"), dsOutput.Tables(1).Columns("Description"))

        parentCol(0) = dsOutput.Tables(1).Columns("description")
        parentCol(1) = dsOutput.Tables(1).Columns("category")
        childCol(0) = dsOutput.Tables(2).Columns("description")
        childCol(1) = dsOutput.Tables(2).Columns("category")
        dsOutput.Relations.Add("CategoryVendor", parentCol, childCol)

        ReDim parentCol(2)
        ReDim childCol(2)

        parentCol(0) = dsOutput.Tables(2).Columns("description")
        parentCol(1) = dsOutput.Tables(2).Columns("category")
        parentCol(2) = dsOutput.Tables(2).Columns("vendorcode")
        childCol(0) = dsOutput.Tables(3).Columns("description")
        childCol(1) = dsOutput.Tables(3).Columns("category")
        childCol(2) = dsOutput.Tables(3).Columns("vendorcode")
        dsOutput.Relations.Add("VendorProduct", parentCol, childCol)

        ReDim parentCol(3)
        ReDim childCol(3)

        parentCol(0) = dsOutput.Tables(3).Columns("description")
        parentCol(1) = dsOutput.Tables(3).Columns("category")
        parentCol(2) = dsOutput.Tables(3).Columns("vendorcode")
        parentCol(3) = dsOutput.Tables(3).Columns("productdesc")
        childCol(0) = dsOutput.Tables(4).Columns("description")
        childCol(1) = dsOutput.Tables(4).Columns("category")
        childCol(2) = dsOutput.Tables(4).Columns("vendorcode")
        childCol(3) = dsOutput.Tables(4).Columns("productdesc")
        dsOutput.Relations.Add("ProductAffiliate", parentCol, childCol)

        UltraWebGrid1.Bands.Clear()
        UltraWebGrid1.DataSource = dsOutput.Tables(0)
        UltraWebGrid1.DataBind()
        UltraWebGrid1.Visible = True
        'UltraWebGrid1.Height = Unit.Pixel((dsOutput.Tables(3).Rows.Count * 25) + 50)
    End Sub

    Protected Sub UltraWebGrid_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles UltraWebGrid1.InitializeLayout
        With e.Layout
            .CellClickActionDefault = Infragistics.WebUI.UltraWebGrid.CellClickAction.RowSelect
            .SelectTypeRowDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single
            .SelectedRowStyleDefault.BorderStyle = BorderStyle.None
            .ViewType = Infragistics.WebUI.UltraWebGrid.ViewType.Hierarchical
            .BorderCollapseDefault = Infragistics.WebUI.UltraWebGrid.BorderCollapse.Collapse
            .GroupByBox.Hidden = True
            .AllowColumnMovingDefault = Infragistics.WebUI.UltraWebGrid.AllowColumnMoving.None
            .RowExpAreaStyleDefault.BackColor = System.Drawing.Color.White

            'Date
            .Bands(0).SelectedRowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#f1f1f1")
            .Bands(0).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(0).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
            .Bands(0).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#c7c7c7")
            .Bands(0).RowStyle.BorderStyle = BorderStyle.None
            .Bands(0).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
            .Bands(0).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            .Bands(0).RowStyle.Padding.Right = Unit.Pixel(3)
            .Bands(0).Columns(0).Width = Unit.Pixel(230)
            .Bands(0).Columns(0).Header.Caption = "Category/Vendor/Product/Affiliate"
            .Bands(0).HeaderStyle.Font.Bold = True
            .Bands(0).HeaderStyle.BackColor = Drawing.ColorTranslator.FromHtml("#C5D9F1")
            .Bands(0).HeaderStyle.BorderStyle = BorderStyle.None
            .Bands(0).HeaderStyle.BorderDetails.ColorBottom = System.Drawing.Color.Black
            .Bands(0).HeaderStyle.BorderDetails.WidthBottom = Unit.Pixel(2)

            'Category
            .Bands(1).Columns(0).Hidden = True
            .Bands(1).Columns(1).Width = Unit.Percentage(100)
            .Bands(1).SelectedRowStyle.BackColor = System.Drawing.Color.LightYellow
            .Bands(1).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(1).RowStyle.BackColor = System.Drawing.Color.White
            .Bands(1).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
            .Bands(1).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#dedede")
            .Bands(1).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
            .Bands(1).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            .Bands(1).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            .Bands(1).ColFootersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No

            'Vendor
            .Bands(2).Columns(0).Hidden = True
            .Bands(2).Columns(1).Hidden = True
            .Bands(2).Columns(2).Width = Unit.Percentage(100)
            .Bands(2).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            .Bands(2).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(2).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#ebebeb")
            .Bands(2).RowStyle.BorderStyle = BorderStyle.None
            .Bands(2).RowStyle.BorderDetails.StyleBottom = BorderStyle.Dotted

            'Product
            .Bands(3).Columns(0).Hidden = True
            .Bands(3).Columns(1).Hidden = True
            .Bands(3).Columns(2).Hidden = True
            .Bands(3).Columns(3).Width = Unit.Percentage(100)
            .Bands(3).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            .Bands(3).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(3).RowStyle.BackColor = System.Drawing.Color.LightYellow
            .Bands(3).RowStyle.BorderStyle = BorderStyle.None
            .Bands(3).RowStyle.BorderDetails.StyleBottom = BorderStyle.Dotted

            'Affiliate
            .Bands(4).Columns(0).Hidden = True
            .Bands(4).Columns(1).Hidden = True
            .Bands(4).Columns(2).Hidden = True
            .Bands(4).Columns(3).Hidden = True
            .Bands(4).Columns(4).Width = Unit.Percentage(100)
            .Bands(4).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            .Bands(4).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(4).RowStyle.BackColor = System.Drawing.Color.White
            .Bands(4).RowStyle.BorderStyle = BorderStyle.None
            .Bands(4).RowStyle.BorderDetails.StyleBottom = BorderStyle.Dotted
        End With
    End Sub

    Protected Sub UltraWebGrid_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles UltraWebGrid1.InitializeRow
        For Each cell As Infragistics.WebUI.UltraWebGrid.UltraGridCell In e.Row.Cells
            If Not IsNothing(cell.Text) Then
                If cell.Text.Contains(".00%") Then
                    cell.Text = cell.Text.Replace(".00%", "%")
                ElseIf cell.Text.Contains("%") Or cell.Key = "Total Leads" Or cell.Key = "Refund" Then
                    Dim statusgroup As String = ""

                    If cell.Key <> "Total Leads" Then
                        statusgroup = cell.Key
                    End If

                    Select Case e.Row.Cells.Count
                        Case 10
                            cell.Text = String.Format("<a href=""javascript:showModalPopup('{0}','{1}','','','','');"">{2}</a>", e.Row.Cells(0).Text, statusgroup, cell.Text.Replace("(0.00%)", "(0%)"))
                        Case 11
                            cell.Text = String.Format("<a href=""javascript:showModalPopup('{0}','{1}','{2}','','','');"">{3}</a>", e.Row.Cells(0).Text, statusgroup, e.Row.Cells(1).Text, cell.Text.Replace("(0.00%)", "(0%)"))
                        Case 12
                            cell.Text = String.Format("<a href=""javascript:showModalPopup('{0}','{1}','{2}','{3}','','');"">{4}</a>", e.Row.Cells(0).Text, statusgroup, e.Row.Cells(1).Text, e.Row.Cells(2).Text, cell.Text.Replace("(0.00%)", "(0%)"))
                        Case 13
                            cell.Text = String.Format("<a href=""javascript:showModalPopup('{0}','{1}','{2}','{3}','{4}','');"">{5}</a>", e.Row.Cells(0).Text, statusgroup, e.Row.Cells(1).Text, e.Row.Cells(2).Text, e.Row.Cells(3).Text, cell.Text.Replace("(0.00%)", "(0%)"))
                        Case 14
                            cell.Text = String.Format("<a href=""javascript:showModalPopup('{0}','{1}','{2}','{3}','{4}','{5}');"">{6}</a>", e.Row.Cells(0).Text, statusgroup, e.Row.Cells(1).Text, e.Row.Cells(2).Text, e.Row.Cells(3).Text, e.Row.Cells(4).Text, cell.Text.Replace("(0.00%)", "(0%)"))
                        Case Else
                            cell.Text = cell.Text.Replace("(0.00%)", "(0%)")
                    End Select
                End If
            End If
        Next
    End Sub

    Private Sub SortLeads(ByVal SortColumn As String, ByVal sortDirection As String)
        hdnSortField.Value = SortColumn
        hdnSortDirection.Value = sortDirection

        LoadLeads(String.Format("{0} {1}", SortColumn, sortDirection))

        'Set Sort Image
        Dim columnIndex As Integer = -1
        Dim headerText As String = SortColumn
        For Each col As DataControlField In gvLeads.Columns
            If col.SortExpression.ToLower = SortColumn.ToLower Then
                columnIndex = gvLeads.Columns.IndexOf(col)
                headerText = col.HeaderText
                Exit For
            End If
        Next
        If columnIndex <> -1 Then
            Dim c As LinkButton = CType(gvLeads.HeaderRow.Cells(columnIndex).FindControl("dvSort" & SortColumn), LinkButton)
            c.Text = String.Format("{0}<div class=""sortHeader sortHeader{1}""></div>", headerText, sortDirection)
        End If
    End Sub

    Private Sub LoadLeads(ByVal SortExpression As String)
        Dim params(6) As SqlParameter
        Dim dateFrom As DateTime
        Dim dateTo As DateTime

        lblFilters.Text = hdnDates.Value

        Select Case hdnDates.Value
            Case "This Week"
                If DatePart(DateInterval.Weekday, Today) = 1 Then 'Sunday
                    dateFrom = DateAdd(DateInterval.Day, -6, Today)
                Else
                    dateFrom = DateAdd(DateInterval.Day, -(DatePart(DateInterval.Weekday, Today) - 2), Today)
                End If
                dateTo = DateAdd(DateInterval.Day, 1, Today)
            Case "Last Week"
                If DatePart(DateInterval.Weekday, Today) = 1 Then 'Sunday
                    dateFrom = DateAdd(DateInterval.Day, -6, Today)
                Else
                    dateFrom = DateAdd(DateInterval.Day, -(DatePart(DateInterval.Weekday, Today) - 2), Today)
                End If
                dateFrom = DateAdd(DateInterval.Day, -7, dateFrom)
                dateTo = DateAdd(DateInterval.Day, 7, dateFrom)
            Case "This Month"
                dateFrom = CDate(Month(Today) & "/1/" & Year(Today))
                dateTo = DateAdd(DateInterval.Day, 1, Today)
            Case "Last Month"
                dateFrom = CDate(Month(DateAdd(DateInterval.Month, -1, Today)) & "/1/" & Year(DateAdd(DateInterval.Month, -1, Today)))
                dateTo = DateAdd(DateInterval.Month, 1, dateFrom)
            Case "Yesterday"
                dateFrom = DateAdd(DateInterval.Day, -1, Today)
                dateTo = Today
            Case "Today"
                dateFrom = Today
                dateTo = DateAdd(DateInterval.Day, 1, Today)
            Case Else 'Date Range
                Dim dates As String() = hdnDates.Value.Split("-")
                dateFrom = CDate(dates(0).Trim)
                dateTo = CDate(dates(1).Trim).AddDays(1)
                'Case Else 'Date Range
                'dateFrom = CDate(hdnDates.Value.Trim)
                'dateTo = dateFrom.AddDays(1)
        End Select

        params(0) = New SqlParameter("@datefrom", dateFrom)
        params(1) = New SqlParameter("@dateto", dateTo)

        If Len(hdnStatusGroup.Value) > 0 Then
            params(2) = New SqlParameter("@statusgroup", hdnStatusGroup.Value)
            lblFilters.Text &= " > " & hdnStatusGroup.Value
        Else
            params(2) = New SqlParameter("@statusgroup", DBNull.Value)
        End If
        If Len(hdnCategory.Value) > 0 Then
            params(3) = New SqlParameter("@category", hdnCategory.Value)
            lblFilters.Text &= " > " & hdnCategory.Value
        Else
            params(3) = New SqlParameter("@category", DBNull.Value)
        End If
        If Len(hdnVendor.Value) > 0 Then
            params(4) = New SqlParameter("@vendor", hdnVendor.Value)
            lblFilters.Text &= " > " & hdnVendor.Value
        Else
            params(4) = New SqlParameter("@vendor", DBNull.Value)
        End If
        If Len(hdnProductDesc.Value) > 0 Then
            params(5) = New SqlParameter("@productdesc", hdnProductDesc.Value)
            lblFilters.Text &= " > " & hdnProductDesc.Value
        Else
            params(5) = New SqlParameter("@productdesc", DBNull.Value)
        End If
        If Len(hdnAffiliateCode.Value) > 0 Then
            params(6) = New SqlParameter("@affiliatecode", hdnAffiliateCode.Value)
            lblFilters.Text &= " > " & hdnAffiliateCode.Value
        Else
            params(6) = New SqlParameter("@affiliatecode", DBNull.Value)
        End If

        Dim tbl As DataTable = SqlHelper.GetDataTable("stp_MarketingDashboardDetail", CommandType.StoredProcedure, params)
        lblFilters.Text &= String.Format(" (<font color='blue'>{0}</font>)", tbl.Rows.Count)

        Dim dv As New DataView(tbl)

        If SortExpression.Trim.Length <> 0 Then
            dv.Sort = SortExpression
        End If

        gvLeads.DataSource = dv
        gvLeads.DataBind()
    End Sub

    Protected Sub lnkLoadLeads_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLoadLeads.Click
        hdnSortField.Value = ""
        hdnSortDirection.Value = ""
        'LoadLeads("")
        SortLeads("Created", "Desc")
    End Sub

    Protected Sub lnkCheckAll_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCheckAll.Click
        Dim cb As CheckBox
        Dim img As Image
        Dim checked As Boolean = False

        For Each row As GridViewRow In gvLeads.Rows
            Select Case row.RowType
                Case DataControlRowType.Header
                    img = TryCast(row.FindControl("imgCheckAll"), Image)
                    If img.ImageUrl.Contains("uncheckall") Then
                        img.ImageUrl = "~/images/11x11_checkall.png"
                    Else
                        img.ImageUrl = "~/images/11x11_uncheckall.png"
                        checked = True
                    End If
                Case DataControlRowType.DataRow
                    cb = TryCast(row.FindControl("chkLead"), CheckBox)
                    cb.Checked = checked
            End Select
        Next
    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Dim sw As New IO.StringWriter
        Dim htw As New HtmlTextWriter(sw)
        Dim table As New System.Web.UI.WebControls.Table
        Dim tr As New System.Web.UI.WebControls.TableRow
        Dim cell As TableCell
        Dim chk As CheckBox

        For i As Integer = 1 To gvLeads.Columns.Count - 1
            cell = New TableCell
            cell.Text = gvLeads.Columns(i).HeaderText
            tr.Cells.Add(cell)
        Next

        table.Rows.Add(tr)

        For Each row As GridViewRow In gvLeads.Rows
            If row.RowType = DataControlRowType.DataRow Then
                chk = TryCast(row.FindControl("chkLead"), CheckBox)
                If chk.Checked Then
                    tr = New TableRow
                    For i As Integer = 1 To row.Cells.Count - 1
                        cell = New TableCell
                        cell.Attributes.Add("class", "text")
                        If row.Cells(i).Controls.Count = 0 Then
                            cell.Text = row.Cells(i).Text
                        Else
                            cell.Text = CType(row.Cells(i).Controls(0), DataBoundLiteralControl).Text.Trim
                        End If

                        tr.Cells.Add(cell)
                    Next
                    table.Rows.Add(tr)
                End If
            End If
        Next

        table.RenderControl(htw)

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.ContentType = "application/ms-excel"
        HttpContext.Current.Response.AddHeader("content-disposition", String.Format("attachment; filename={0}.xls", lblFilters.Text.Replace(" > ", "_").Replace(" ", "")))
        'HttpContext.Current.Response.Write("<style>.text { mso-number-format:\@; } </style>")
        HttpContext.Current.Response.Write(sw.ToString)
        HttpContext.Current.Response.End()
    End Sub

    Protected Sub lnkRefund_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRefund.Click
        Dim numToRefund As Integer = CInt(txtRefundCount.Text)
        Dim key As DataKey
        Dim n As Integer

        For Each row As GridViewRow In gvLeads.Rows
            If row.RowType = DataControlRowType.DataRow Then
                key = gvLeads.DataKeys(row.RowIndex)
                SqlHelper.ExecuteNonQuery(String.Format("update tblleadapplicant set refund = 1, refunddate = getdate(), cost = 0 where leadapplicantid = {0}", key(0)), CommandType.Text)
                n += 1
                If n = numToRefund Then
                    Exit For
                End If
            End If
        Next

        'ModalPopupExtender1.Hide()
        'LoadGrid()
        Response.Redirect("dashboard.aspx", False)
    End Sub

    Protected Sub btnFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilter.Click
        If hdnFilter.Value = "1" And Not (txtFromDate.Text.Trim.Length = 0 And txtToDate.Text.Trim.Length = 0) Then
            LoadGridDateRange()
        Else
            LoadGrid()
        End If
    End Sub

    Protected Sub gvLeads_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvLeads.RowCommand
        If e.CommandName = "Sort" Then
            Dim sortDirection As String = "Asc"
            If hdnSortField.Value.ToLower = e.CommandArgument.ToLower Then
                If hdnSortDirection.Value = "Asc" Then
                    sortDirection = "Desc"
                End If
            End If
            SortLeads(e.CommandArgument, sortDirection)
        End If
    End Sub


End Class
