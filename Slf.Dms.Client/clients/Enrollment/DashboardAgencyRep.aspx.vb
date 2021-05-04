Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess
Imports System.Collections.Generic

Partial Class Clients_Enrollment_DashboardAgencyRep
    Inherits System.Web.UI.Page

    Private _userid As Integer
    Private _allAgencies As String
    Private _fromDate As DateTime
    Private _toDate As DateTime

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _userid = DataHelper.Nz_int(Page.User.Identity.Name)

        _toDate = Date.Now
        _fromDate = DateAdd(DateInterval.Year, -1, _toDate)

        If Request.QueryString("mobile") = "1" Then
            hdnNotab.Value = "1"
        End If

        If Not Page.IsPostBack Then
            SetProducts()
            If ddlProduct.Items.Count > 0 Then
                ddlProduct.SelectedIndex = ddlProduct.Items.IndexOf(ddlProduct.Items.FindByText("CareOne Debt Relief"))
            End If
            LoadGrid()
        End If

    End Sub

    Private Sub LoadGrid()
        Dim dateFrom As DateTime
        Dim dateTo As DateTime
        Dim dsOutput As DataSet
        Dim products As String
        Dim params(4) As SqlParameter

        If ddlProduct.SelectedValue = -1 Then
            products = hdnProduct.Value
            Else
            products = ddlProduct.SelectedValue
            End If

        'Today
        dateFrom = Today
        dateTo = DateAdd(DateInterval.Day, 1, Today)
        params(0) = New SqlParameter("@dateFrom", dateFrom)
        params(1) = New SqlParameter("@dateTo", dateTo)
        params(2) = New SqlParameter("@description", "Today")
        params(3) = New SqlParameter("@userid", _userid)
        params(4) = (New SqlParameter("productid", products))
        dsOutput = SqlHelper.GetDataSet("stp_MarketingDashboardExternalBySource", , params)

        For i As Integer = 0 To 11
            dateFrom = CDate(Month(DateAdd(DateInterval.Month, -1 * i, Today)) & "/1/" & Year(DateAdd(DateInterval.Month, -1 * i, Today)))
            dateTo = DateAdd(DateInterval.Month, 1, dateFrom)
            params(0) = New SqlParameter("@dateFrom", dateFrom)
            params(1) = New SqlParameter("@dateTo", dateTo)
            params(2) = New SqlParameter("@description", String.Format("{0:MMMM yyyy}", dateFrom))
            params(3) = New SqlParameter("@userid", _userid)
            params(4) = (New SqlParameter("productid", products))
            dsOutput.Merge(SqlHelper.GetDataSet("stp_MarketingDashboardExternalBySource", , params))
        Next

        BuildGrid(dsOutput)
    End Sub

    Private Sub BuildGrid(ByVal dsOutput As DataSet)

        dsOutput.Relations.Add("DateDescription", dsOutput.Tables(0).Columns("description"), dsOutput.Tables(1).Columns("description"))

        Dim parentCol(1) As DataColumn
        Dim childCol(1) As DataColumn

        parentCol(0) = dsOutput.Tables(1).Columns("description")
        parentCol(1) = dsOutput.Tables(1).Columns("product")

        childCol(0) = dsOutput.Tables(2).Columns("description")
        childCol(1) = dsOutput.Tables(2).Columns("product")

        dsOutput.Relations.Add("DescriptionRep", parentCol, childCol)

        'Create PlaceHolder
        Dim sb As New StringBuilder
        Dim rowid As Integer = 0
        For Each dr As DataRow In dsOutput.Tables(0).Rows
            rowid += 1
            RenderChildRows(sb, dr, "row" & rowid, "", 0)
        Next
        ltrTree.Text = "<table id=""tbtree"" class=""rawtb""><thead><tr><th>Date/Vendor/Rep.</th><th>Total<br/>Leads</th><th>Working</th><th>LSA<br/>Pending</th><th>3PV<br/>Pending</th><th>Approval<br/>Pending</th><th>Attorney<br/>Returned</th><th style=""background-color:#CCFFCC"">Accepted</th><th style=""background-color:#CC6666"">Do Not<br/>Call</th><th style=""background-color:#CC6666"">Not<br/>Qualified</th><th style=""background-color:#CC6666"">Declined<br/>Services</th><th style=""background-color:#8F5B4F"">Bad<br/>Transfer</th></tr></thead>" & sb.ToString & "</table>"
    End Sub

    Private Sub RenderChildRows(ByRef sb As StringBuilder, ByVal dr As DataRow, ByVal rowid As String, ByVal parentrowid As String, ByVal level As Integer)
        Dim sbcells As New StringBuilder
        For Each col As DataColumn In dr.Table.Columns
            If dr.Table.Columns.IndexOf(col) >= level Then
                sbcells.AppendFormat("<td>{0}</td>", GetCellValue(dr, col, level))
            End If
        Next
        'Write Row
        sb.AppendFormat("<tr data-tt-id=""{0}"" {1} class=""level{3}"">{2}</tr>", rowid, IIf(level > 0, String.Format("data-tt-parent-id=""{0}""", parentrowid), ""), sbcells, level)
        'Write Children 
        If level <= dr.Table.DataSet.Relations.Count - 1 Then
            Dim id As Integer = 0
            For Each drchild As DataRow In dr.GetChildRows(dr.Table.DataSet.Relations(level).RelationName)
                id += 1
                RenderChildRows(sb, drchild, rowid & "_" & id, rowid, level + 1)
            Next
        End If
    End Sub

    Private Function GetCellValue(ByVal dr As DataRow, ByVal col As DataColumn, ByVal level As Integer) As String
        Dim emptyreptext As String = "[Not Assigned]"
        Dim cellvalue As String = IIf(dr(col) Is DBNull.Value, "", dr(col).ToString)
        Dim colname As String = col.ColumnName

        If cellvalue.Contains(".00%") Then
            cellvalue = cellvalue.Replace(".00%", "%")
        End If

        If cellvalue.Contains("%") Or colname = "Total Leads" Then
            Dim statusgroup As String = ""

            If colname <> "Total Leads" Then
                statusgroup = colname
            End If

            If Not (cellvalue = "0" OrElse cellvalue.StartsWith("0 ")) Then
                Select Case level
                    Case 0
                        cellvalue = String.Format("<a href=""javascript:showModalPopup('{0}','{1}','','');"">{2}</a>", dr(0), statusgroup, cellvalue.Replace("(0.00%)", "(0%)"))
                    Case 1
                        'cellvalue = String.Format("<a href=""javascript:showModalPopup('{0}','{1}','{2}','');"">{3}</a>", dr(0), statusgroup, dr(1), cellvalue.Replace("(0.00%)", "(0%)"))
                        cellvalue = String.Format("<a href=""javascript:showModalPopup('{0}','{1}','{2}','');"">{3}</a>", dr(0), statusgroup, dr(2), cellvalue.Replace("(0.00%)", "(0%)"))
                    Case 2
                        'cellvalue = String.Format("<a href=""javascript:showModalPopup('{0}','{1}','{2}','{3}');"">{4}</a>", dr(0), statusgroup, dr(1), dr(2).Replace(emptyreptext, " "), cellvalue.Replace("(0.00%)", "(0%)"))
                        cellvalue = String.Format("<a href=""javascript:showModalPopup('{0}','{1}','{2}','{3}');"">{4}</a>", dr(0), statusgroup, dr(2), dr(1), cellvalue.Replace("(0.00%)", "(0%)"))
                End Select
            End If

        ElseIf cellvalue.Trim.Length = 0 AndAlso colname.ToLower.Trim = "rep" Then
            cellvalue = emptyreptext
        End If

        Return cellvalue
    End Function

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
        Dim params(5) As SqlParameter
        Dim dateFrom As DateTime
        Dim dateTo As DateTime

        lblFilters.Value = hdnDates.Value

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
                If dates.Length = 1 Then
                    'Month
                    dateFrom = CDate(dates(0).Trim)
                    dateTo = dateFrom.AddMonths(1)
                Else
                    'Date Range
                    dateFrom = CDate(dates(0).Trim)
                    dateTo = CDate(dates(1).Trim).AddDays(1)
                End If
        End Select

        params(0) = New SqlParameter("@datefrom", dateFrom)
        params(1) = New SqlParameter("@dateto", dateTo)

        If Len(hdnStatusGroup.Value) > 0 Then
            params(2) = New SqlParameter("@statusgroup", hdnStatusGroup.Value)
            lblFilters.Value &= " > " & hdnStatusGroup.Value
        Else
            params(2) = New SqlParameter("@statusgroup", DBNull.Value)
        End If

        If Len(hdnProduct.Value) > 0 Then
            params(3) = New SqlParameter("@product", hdnProduct.Value)
            lblFilters.Value &= " > " & hdnProduct.Value
        Else
            params(3) = New SqlParameter("@product", DBNull.Value)
        End If
        If Len(hdnRep.Value) > 0 Then
            params(4) = New SqlParameter("@rep", hdnRep.Value)
            lblFilters.Value &= " > " & hdnRep.Value
        Else
            params(4) = New SqlParameter("@rep", DBNull.Value)
        End If

        params(5) = New SqlParameter("@userid", _userid)

        Dim tbl As DataTable = SqlHelper.GetDataTable("stp_MarketingDashboardDetailExternal", CommandType.StoredProcedure, params)
        lblFilters.Value &= String.Format(" ({0})", tbl.Rows.Count)

        Dim dv As New DataView(tbl)

        If SortExpression.Trim.Length <> 0 Then
            dv.Sort = SortExpression
        End If

        gvLeads.DataSource = dv
        gvLeads.DataBind()
    End Sub

    Private Sub SetProducts()

        ddlProduct.Items.Clear()
        ddlProduct.Items.Add(New System.Web.UI.WebControls.ListItem("All Sources", -1))
        ddlProduct.SelectedIndex = 0

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("fromDate", _fromDate))
        params.Add(New SqlParameter("toDate", _toDate))

        Dim dt As DataTable
        dt = SqlHelper.GetDataTable("stp_enrollment_getProductsOfLeadsByDate", CommandType.StoredProcedure, params.ToArray)

        _allAgencies += ""
        For Each rw As DataRow In dt.Rows
            _allAgencies += rw("ProductId").ToString + ","
            ddlProduct.Items.Add(New System.Web.UI.WebControls.ListItem(rw("ProductDesc"), rw("ProductId")))
        Next
        _allAgencies.Remove(_allAgencies.Length - 1)
        hdnProduct.Value = _allAgencies
    End Sub

    Protected Sub lnkLoadLeads_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLoadLeads.Click
        hdnSortField.Value = ""
        hdnSortDirection.Value = ""
        LoadLeads("")
        SortLeads("Created", "Desc")
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "jscompleteloadleads", "ModalPopupCompleted();", True)
    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Dim sw As New IO.StringWriter
        Dim htw As New HtmlTextWriter(sw)
        Dim table As New System.Web.UI.WebControls.Table
        Dim tr As New System.Web.UI.WebControls.TableRow
        Dim cell As TableCell

        For i As Integer = 1 To gvLeads.Columns.Count - 1
            cell = New TableCell
            cell.Text = gvLeads.Columns(i).HeaderText
            tr.Cells.Add(cell)
        Next

        table.Rows.Add(tr)

        For Each row As GridViewRow In gvLeads.Rows
            If row.RowType = DataControlRowType.DataRow Then
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
        Next

        table.RenderControl(htw)

        Dim Afilename As String() = lblFilters.Value.Split("(")
        Dim filename As String = Afilename(0).Trim.Replace("<", "_").Replace(" ", "")

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.ContentType = "application/ms-excel"
        HttpContext.Current.Response.AddHeader("content-disposition", String.Format("attachment; filename={0}.xls", filename))
        HttpContext.Current.Response.Write(sw.ToString)
        HttpContext.Current.Response.End()
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


    Protected Sub btnFilter_Click(sender As Object, e As EventArgs) Handles btnFilter.Click
        LoadGrid()
    End Sub
End Class
