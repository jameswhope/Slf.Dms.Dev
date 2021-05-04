Imports System.Data
Imports System.Data.SqlClient

Partial Class public_vendor_lead_analysis
    Inherits System.Web.UI.Page

    Private _vendorID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Session("vendor") Is Nothing Then
            hHeader.InnerHtml = String.Format("Lead Analysis ({0})", CStr(Session("vendor")))
            _vendorID = CInt(Session("vendorID"))
            If Not Page.IsPostBack Then
                LoadGrid()
            End If
        Else
            Response.Redirect("login.aspx", False)
        End If
    End Sub

    Private Sub LoadGrid()
        Dim dateFrom As DateTime
        Dim dateTo As DateTime
        Dim dsOutput As DataSet
        Dim params(3) As SqlParameter
        Dim parentCol(3) As DataColumn
        Dim childCol(3) As DataColumn

        'Today
        dateFrom = Today
        dateTo = DateAdd(DateInterval.Day, 1, Today)
        params(0) = New SqlParameter("@dateFrom", dateFrom)
        params(1) = New SqlParameter("@dateTo", dateTo)
        params(2) = New SqlParameter("@description", "Today")
        params(3) = New SqlParameter("@vendorid", _vendorID)
        dsOutput = SqlHelper.GetDataSet("stp_MarketingDashboard", , params)

        'Yesturday
        dateFrom = DateAdd(DateInterval.Day, -1, Today)
        dateTo = Today
        params(0) = New SqlParameter("@dateFrom", dateFrom)
        params(1) = New SqlParameter("@dateTo", dateTo)
        params(2) = New SqlParameter("@description", "Yesturday")
        params(3) = New SqlParameter("@vendorid", _vendorID)
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
        params(3) = New SqlParameter("@vendorid", _vendorID)
        dsOutput.Merge(SqlHelper.GetDataSet("stp_MarketingDashboard", , params))

        'Last Week - Mon-Sun
        dateFrom = DateAdd(DateInterval.Day, -7, dateFrom)
        dateTo = DateAdd(DateInterval.Day, 7, dateFrom)
        params(0) = New SqlParameter("@dateFrom", dateFrom)
        params(1) = New SqlParameter("@dateTo", dateTo)
        params(2) = New SqlParameter("@description", "Last Week")
        params(3) = New SqlParameter("@vendorid", _vendorID)
        dsOutput.Merge(SqlHelper.GetDataSet("stp_MarketingDashboard", , params))

        'This Month
        dateFrom = CDate(Month(Today) & "/1/" & Year(Today))
        dateTo = DateAdd(DateInterval.Day, 1, Today)
        params(0) = New SqlParameter("@dateFrom", dateFrom)
        params(1) = New SqlParameter("@dateTo", dateTo)
        params(2) = New SqlParameter("@description", "This Month")
        params(3) = New SqlParameter("@vendorid", _vendorID)
        dsOutput.Merge(SqlHelper.GetDataSet("stp_MarketingDashboard", , params))

        'Last Month
        dateFrom = CDate(Month(DateAdd(DateInterval.Month, -1, Today)) & "/1/" & Year(DateAdd(DateInterval.Month, -1, Today)))
        dateTo = DateAdd(DateInterval.Month, 1, dateFrom)
        params(0) = New SqlParameter("@dateFrom", dateFrom)
        params(1) = New SqlParameter("@dateTo", dateTo)
        params(2) = New SqlParameter("@description", "Last Month")
        params(3) = New SqlParameter("@vendorid", _vendorID)
        dsOutput.Merge(SqlHelper.GetDataSet("stp_MarketingDashboard", , params))

        'Date-Product
        dsOutput.Relations.Add("DateCategory", dsOutput.Tables(0).Columns("Description"), dsOutput.Tables(3).Columns("Description"))

        'Product-Affiliate
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
            .Bands(0).Columns(0).Header.Caption = ""
            .Bands(0).Columns(0).CellStyle.HorizontalAlign = HorizontalAlign.Left
            .Bands(0).HeaderStyle.Font.Bold = True
            .Bands(0).HeaderStyle.BackColor = Drawing.ColorTranslator.FromHtml("#C5D9F1")
            .Bands(0).HeaderStyle.BorderStyle = BorderStyle.None
            .Bands(0).HeaderStyle.BorderDetails.ColorBottom = System.Drawing.Color.Black
            .Bands(0).HeaderStyle.BorderDetails.WidthBottom = Unit.Pixel(2)

            'Product
            .Bands(1).Columns(0).Hidden = True
            .Bands(1).Columns(1).Hidden = True
            .Bands(1).Columns(2).Hidden = True
            .Bands(1).Columns(3).Width = Unit.Pixel(209) 'Unit.Percentage(100)
            .Bands(1).Columns(3).CellStyle.HorizontalAlign = HorizontalAlign.Left
            .Bands(1).SelectedRowStyle.BackColor = System.Drawing.Color.LightYellow
            .Bands(1).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(1).RowStyle.BackColor = System.Drawing.Color.White
            .Bands(1).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
            .Bands(1).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#dedede")
            .Bands(1).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
            .Bands(1).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            .Bands(1).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            .Bands(1).ColFootersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No

            'Affiliate
            .Bands(2).Columns(0).Hidden = True
            .Bands(2).Columns(1).Hidden = True
            .Bands(2).Columns(2).Hidden = True
            .Bands(2).Columns(3).Hidden = True
            .Bands(2).Columns(4).Width = Unit.Pixel(189) 'Unit.Percentage(100)
            .Bands(2).Columns(4).CellStyle.HorizontalAlign = HorizontalAlign.Left
            .Bands(2).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            .Bands(2).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(2).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#ebebeb")
            .Bands(2).RowStyle.BorderStyle = BorderStyle.None
            .Bands(2).RowStyle.BorderDetails.StyleBottom = BorderStyle.Dotted
        End With
    End Sub

    Protected Sub UltraWebGrid_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles UltraWebGrid1.InitializeRow
        For Each cell As Infragistics.WebUI.UltraWebGrid.UltraGridCell In e.Row.Cells
            If Not IsNothing(cell.Text) Then
                If cell.Text.Contains(".00%") Then
                    cell.Text = cell.Text.Replace(".00%", "%")
                End If
            End If
        Next
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        LoadGrid()
    End Sub
End Class
