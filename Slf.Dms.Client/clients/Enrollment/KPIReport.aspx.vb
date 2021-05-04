Imports System.Data
Imports System.Data.SqlClient

Partial Class Clients_Enrollment_KPIReport
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadGrid()
            LoadKPIRevShare()
            LoadRevShare()
            LoadPersistency()
        End If
    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        tsKPI.TabPages.Clear()
        tsKPI.TabPages.Add(New Slf.Dms.Controls.TabPage("KPI&nbsp;Report", phKPI.ClientID))
        tsKPI.TabPages.Add(New Slf.Dms.Controls.TabPage("Rev&nbsp;Share&nbsp;KPI", phKPIRev.ClientID))
        tsKPI.TabPages.Add(New Slf.Dms.Controls.TabPage("Rev&nbsp;Share&nbsp;Report", phRev.ClientID))
        tsKPI.TabPages.Add(New Slf.Dms.Controls.TabPage("KPI&nbsp;Persistency", phPer.ClientID))
    End Sub

    Private Sub LoadGrid()
        Dim dsOutput As DataSet
        Dim parent(1) As DataColumn
        Dim child(1) As DataColumn

        dsOutput = SqlHelper.GetDataSet("exec stp_KPIReport 0", CommandType.Text)
        dsOutput.Relations.Add("MonthDay", dsOutput.Tables(0).Columns("StartEnd"), dsOutput.Tables(1).Columns("StartEnd"))

        parent(0) = dsOutput.Tables(1).Columns("StartEnd")
        parent(1) = dsOutput.Tables(1).Columns("ConnectDate")
        child(0) = dsOutput.Tables(2).Columns("StartEnd")
        child(1) = dsOutput.Tables(2).Columns("ServiceFee")
        dsOutput.Relations.Add("DayService", parent, child)

        lblLastMod.Text = CStr(SqlHelper.ExecuteScalar("select top 1 lastrefresh from tblKPI order by lastrefresh desc", CommandType.Text))

        UltraWebGrid1.Bands.Clear()
        UltraWebGrid1.DataSource = dsOutput.Tables(0)
        UltraWebGrid1.DataBind()
        UltraWebGrid1.Visible = True
    End Sub

    Private Sub LoadKPIRevShare()
        Dim dsOutput As DataSet
        Dim parent(1) As DataColumn
        Dim child(1) As DataColumn

        dsOutput = SqlHelper.GetDataSet("exec stp_KPIReport 1", CommandType.Text)
        dsOutput.Relations.Add("MonthDay", dsOutput.Tables(0).Columns("StartEnd"), dsOutput.Tables(1).Columns("StartEnd"))

        parent(0) = dsOutput.Tables(1).Columns("StartEnd")
        parent(1) = dsOutput.Tables(1).Columns("ConnectDate")
        child(0) = dsOutput.Tables(2).Columns("StartEnd")
        child(1) = dsOutput.Tables(2).Columns("ServiceFee")
        dsOutput.Relations.Add("DayService", parent, child)

        uwgKPIRevShare.Bands.Clear()
        uwgKPIRevShare.DataSource = dsOutput.Tables(0)
        uwgKPIRevShare.DataBind()
        uwgKPIRevShare.Visible = True
    End Sub

    Private Sub LoadRevShare()
        Dim dsOutput As DataSet
        Dim parent(1) As DataColumn
        Dim child(1) As DataColumn

        dsOutput = SqlHelper.GetDataSet("stp_RevShareReport")
        dsOutput.Relations.Add("Relation1", dsOutput.Tables(0).Columns("monthyr"), dsOutput.Tables(1).Columns("monthyr"))

        parent(0) = dsOutput.Tables(1).Columns("monthyr")
        parent(1) = dsOutput.Tables(1).Columns("servicefee")
        child(0) = dsOutput.Tables(2).Columns("monthyr")
        child(1) = dsOutput.Tables(2).Columns("servicefee")
        dsOutput.Relations.Add("Relation2", parent, child)

        lblLastMod.Text = CStr(SqlHelper.ExecuteScalar("select top 1 lastrefresh from tblKPI order by lastrefresh desc", CommandType.Text))

        UltraWebGrid2.Bands.Clear()
        UltraWebGrid2.DataSource = dsOutput.Tables(0)
        UltraWebGrid2.DataBind()
        UltraWebGrid2.Visible = True
    End Sub

    Private Sub LoadPersistency()
        Dim ds As DataSet
        Dim dv As DataView

        ds = SqlHelper.GetDataSet("stp_KPIPersistency")
        ds.Relations.Add("Relation1", ds.Tables(0).Columns("mthyr"), ds.Tables(1).Columns("mthyr"))

        dv = ds.Tables(0).DefaultView

        Accordion1.DataSource = dv
        Accordion1.DataBind()
        Accordion1.SelectedIndex = -1

        rptFooter.DataSource = ds.Tables(2)
        rptFooter.DataBind()
    End Sub

    Protected Sub UltraWebGrid1_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles UltraWebGrid1.InitializeLayout, uwgKPIRevShare.InitializeLayout
        Try
            With e.Layout
                .CellClickActionDefault = Infragistics.WebUI.UltraWebGrid.CellClickAction.RowSelect
                .SelectTypeRowDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single
                .SelectedRowStyleDefault.BorderStyle = BorderStyle.None
                .ViewType = Infragistics.WebUI.UltraWebGrid.ViewType.Hierarchical
                .BorderCollapseDefault = Infragistics.WebUI.UltraWebGrid.BorderCollapse.Collapse
                .GroupByBox.Hidden = True
                .AllowColumnMovingDefault = Infragistics.WebUI.UltraWebGrid.AllowColumnMoving.None
                .RowExpAreaStyleDefault.BackColor = System.Drawing.Color.White

                .Bands(0).SelectedRowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#f1f1f1")
                .Bands(0).RowExpAreaStyle.BackColor = System.Drawing.Color.White
                .Bands(0).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
                .Bands(0).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#B9D3EE")
                .Bands(0).RowStyle.BorderStyle = BorderStyle.None
                .Bands(0).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
                .Bands(0).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
                .Bands(0).RowStyle.Padding.Right = Unit.Pixel(3)
                .Bands(0).Columns(0).Width = Unit.Pixel(165)
                .Bands(0).Columns(0).CellStyle.HorizontalAlign = HorizontalAlign.Left
                .Bands(0).Columns(0).Header.Caption = ""
                .Bands(0).Columns(0).Header.Style.HorizontalAlign = HorizontalAlign.Left
                .Bands(0).HeaderStyle.Font.Bold = True
                .Bands(0).HeaderStyle.BackColor = Drawing.ColorTranslator.FromHtml("#C5D9F1")
                .Bands(0).HeaderStyle.BorderStyle = BorderStyle.None
                .Bands(0).HeaderStyle.BorderDetails.ColorBottom = System.Drawing.Color.Black
                .Bands(0).HeaderStyle.BorderDetails.WidthBottom = Unit.Pixel(2)

                .Bands(1).Columns(0).Hidden = True
                .Bands(1).Columns(1).Width = Unit.Percentage(100)
                .Bands(1).Columns(1).CellStyle.HorizontalAlign = HorizontalAlign.Left
                .Bands(1).SelectedRowStyle.BackColor = System.Drawing.Color.LightYellow
                .Bands(1).RowExpAreaStyle.BackColor = System.Drawing.Color.White
                .Bands(1).RowStyle.BackColor = System.Drawing.Color.White
                .Bands(1).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
                .Bands(1).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#ebebeb")
                .Bands(1).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
                .Bands(1).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
                .Bands(1).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
                .Bands(1).ColFootersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No

                .Bands(2).Columns(0).Hidden = True
                .Bands(2).Columns(1).Width = Unit.Percentage(100)
                .Bands(2).Columns(2).Hidden = True
                .Bands(2).SelectedRowStyle.BackColor = System.Drawing.Color.LightYellow
                .Bands(2).RowExpAreaStyle.BackColor = System.Drawing.Color.White
                .Bands(2).RowStyle.BackColor = System.Drawing.Color.White
                .Bands(2).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
                .Bands(2).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#fff")
                .Bands(2).RowStyle.BorderDetails.StyleBottom = BorderStyle.Dotted
                .Bands(2).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
                .Bands(2).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
                .Bands(2).ColFootersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            End With
        Catch nex As NullReferenceException

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub UltraWebGrid1_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles UltraWebGrid1.InitializeRow, uwgKPIRevShare.InitializeRow
        For Each cell As Infragistics.WebUI.UltraWebGrid.UltraGridCell In e.Row.Cells
            If cell.Column.Header.Caption.Contains("Pct") Or cell.Column.Header.Caption = "ConversionPercent" Or cell.Column.Header.Caption.Contains("$") Then
                cell.Text = FormatPercent(cell.Text, 2)
                cell.Style.HorizontalAlign = HorizontalAlign.Right
            ElseIf cell.Column.Header.Caption.Contains("Budget") Or cell.Column.Header.Caption.Contains("Cost") Or cell.Column.Header.Caption.Contains("Avg") Then
                If IsNumeric(cell.Text) Then
                    cell.Text = FormatCurrency(cell.Text, 2)
                    cell.Style.HorizontalAlign = HorizontalAlign.Right
                End If
            End If

            If IsNumeric(cell.Value) Then
                cell.Style.HorizontalAlign = HorizontalAlign.Right
            End If

            If e.Row.Band.Index > 0 And IsDate(cell.Text) And cell.Column.Index > 0 Then
                If CDate(cell.Text).DayOfWeek = DayOfWeek.Saturday Or CDate(cell.Text).DayOfWeek = DayOfWeek.Sunday Then
                    e.Row.Style.BackColor = Drawing.ColorTranslator.FromHtml("#dbdbdb")
                Else
                    e.Row.Style.BackColor = Drawing.ColorTranslator.FromHtml("#EBEBEB")
                End If
            ElseIf e.Row.Band.Index = 1 And cell.Column.Index = 1 Then
                e.Row.Style.BackColor = Drawing.ColorTranslator.FromHtml("#B0E2FF")
                cell.Text = FormatCurrency(cell.Text, 2)
                cell.Style.HorizontalAlign = HorizontalAlign.Left
            ElseIf cell.Column.Index >= e.Row.Cells.Count - 3 Then 'last 3 columns
                cell.Style.HorizontalAlign = HorizontalAlign.Center
                cell.Column.Header.Style.HorizontalAlign = HorizontalAlign.Center
                cell.Column.Width = Unit.Pixel(50)
            End If
        Next
    End Sub

    Protected Sub UltraWebGrid_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles UltraWebGrid2.InitializeLayout
        Try
            With e.Layout
                .CellClickActionDefault = Infragistics.WebUI.UltraWebGrid.CellClickAction.RowSelect
                .SelectTypeRowDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single
                .SelectedRowStyleDefault.BorderStyle = BorderStyle.None
                .ViewType = Infragistics.WebUI.UltraWebGrid.ViewType.Hierarchical
                .BorderCollapseDefault = Infragistics.WebUI.UltraWebGrid.BorderCollapse.Collapse
                .GroupByBox.Hidden = True
                .AllowColumnMovingDefault = Infragistics.WebUI.UltraWebGrid.AllowColumnMoving.None
                .RowExpAreaStyleDefault.BackColor = System.Drawing.Color.White

                .Bands(0).SelectedRowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#f1f1f1")
                .Bands(0).RowExpAreaStyle.BackColor = System.Drawing.Color.White
                .Bands(0).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
                .Bands(0).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#B9D3EE")
                .Bands(0).RowStyle.BorderStyle = BorderStyle.None
                .Bands(0).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
                .Bands(0).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
                .Bands(0).RowStyle.Padding.Right = Unit.Pixel(3)
                .Bands(0).Columns(0).Width = Unit.Pixel(165)
                .Bands(0).Columns(0).CellStyle.HorizontalAlign = HorizontalAlign.Left
                .Bands(0).Columns(0).Header.Caption = ""
                .Bands(0).Columns(0).Header.Style.HorizontalAlign = HorizontalAlign.Left
                .Bands(0).HeaderStyle.Font.Bold = True
                .Bands(0).HeaderStyle.BackColor = Drawing.ColorTranslator.FromHtml("#C5D9F1")
                .Bands(0).HeaderStyle.BorderStyle = BorderStyle.None
                .Bands(0).HeaderStyle.BorderDetails.ColorBottom = System.Drawing.Color.Black
                .Bands(0).HeaderStyle.BorderDetails.WidthBottom = Unit.Pixel(2)

                .Bands(1).Columns(0).Hidden = True
                .Bands(1).Columns(1).Width = Unit.Percentage(100)
                .Bands(1).Columns(1).CellStyle.HorizontalAlign = HorizontalAlign.Left
                .Bands(1).SelectedRowStyle.BackColor = System.Drawing.Color.LightYellow
                .Bands(1).RowExpAreaStyle.BackColor = System.Drawing.Color.White
                .Bands(1).RowStyle.BackColor = System.Drawing.Color.White
                .Bands(1).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
                .Bands(1).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#ebebeb")
                .Bands(1).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
                .Bands(1).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
                .Bands(1).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
                .Bands(1).ColFootersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No

                .Bands(2).Columns(0).Hidden = True
                .Bands(2).Columns(1).Hidden = True
                .Bands(2).Columns(2).Width = Unit.Percentage(100)
                .Bands(2).SelectedRowStyle.BackColor = System.Drawing.Color.LightYellow
                .Bands(2).RowExpAreaStyle.BackColor = System.Drawing.Color.White
                .Bands(2).RowStyle.BackColor = System.Drawing.Color.White
                .Bands(2).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
                .Bands(2).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#fff")
                .Bands(2).RowStyle.BorderDetails.StyleBottom = BorderStyle.Dotted
                .Bands(2).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
                .Bands(2).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
                .Bands(2).ColFootersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            End With
        Catch nex As NullReferenceException

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Sub UltraWebGrid_InitializeRow(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.RowEventArgs) Handles UltraWebGrid2.InitializeRow
        For Each cell As Infragistics.WebUI.UltraWebGrid.UltraGridCell In e.Row.Cells
            If cell.Column.Header.Caption.Contains("Pct") Then
                cell.Text = FormatPercent(cell.Text, 2)
                cell.Style.HorizontalAlign = HorizontalAlign.Right
            ElseIf cell.Column.Header.Caption.Contains("Budget") Then
                cell.Text = FormatCurrency(cell.Text, 2)
                cell.Style.HorizontalAlign = HorizontalAlign.Right
            ElseIf IsNumeric(cell.Value) Then
                cell.Style.HorizontalAlign = HorizontalAlign.Right
            End If

            If e.Row.Band.Index = 1 And cell.Column.Index = 1 Then
                cell.Text = FormatCurrency(cell.Text)
                cell.Style.HorizontalAlign = HorizontalAlign.Left
            ElseIf e.Row.Band.Index = 2 And IsDate(cell.Text) And cell.Column.Index > 0 Then
                If CDate(cell.Text).DayOfWeek = DayOfWeek.Saturday Or _
                           CDate(cell.Text).DayOfWeek = DayOfWeek.Sunday Then
                    e.Row.Style.BackColor = Drawing.ColorTranslator.FromHtml("#dbdbdb")
                End If
                'ElseIf e.Row.Band.Index = 1 And cell.Column.Index = 1 Then
                '    e.Row.Style.BackColor = Drawing.ColorTranslator.FromHtml("#B0E2FF")
                '    cell.Text = FormatCurrency(cell.Text, 2)
                '    cell.Style.HorizontalAlign = HorizontalAlign.Left
                'ElseIf e.Row.Band.Index = 2 And cell.Column.Index = 3 Then
                '    cell.Text = FormatCurrency(cell.Text, 2)
                '    cell.Style.HorizontalAlign = HorizontalAlign.Left
            End If
        Next
    End Sub

End Class
