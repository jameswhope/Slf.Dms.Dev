Imports Drg.Util.DataAccess
Imports System.Data
Imports System.IO

Partial Class research_queries_financial_accounting_controlledaccountactivity
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            Initialize()
            Requery()
        End If
    End Sub

    Private Sub Initialize()
        Me.txtBeginDate.Value = DateTime.Today.ToShortDateString
        Me.txtEndDate.Value = DateTime.Today.ToShortDateString
    End Sub

    Private Sub Requery()
        Dim objQuery As New WCFClient.QuerySvc
        Dim ds As DataSet = objQuery.GetControlledAccountTransactions(ddlControlledAccount.SelectedItem.Text, CDate(txtBeginDate.Text), CDate(txtEndDate.Text & " 23:59:59"))

        UltraWebGrid1.DataSource = ds.Tables("Transactions").DefaultView
        UltraWebGrid1.DataBind()

        lblItems.Text = "(" & ds.Tables("Transactions").Rows.Count & " transactions)"

        'SetAccountBalance
        Try
            objQuery = New WCFClient.QuerySvc
            Dim resp As WCFClient.CheckSite.Lexxiom.Entities.Ws.Queries.ControlledAccountBalanceResponse
            resp = objQuery.GetAccountBalance(ddlControlledAccount.SelectedItem.Text)
            If resp.Status <> WCFClient.CheckSite.Lexxiom.Entities.Ws.Queries.ControlledAccountBalanceResponse.StatusType.Succeeded Then Throw New Exception("Cannot get the balance information for this account.")
            lblBalance.Text = String.Format("Balance Date: {0:g}, Balance: <span style='color: {1}'>{2:c}</span>, Processed: <span style='color: {1}'>{2:c}</span>, Unprocessed: <span style='color: {3}'>{4:c}</span>, Net: <span style='color: {5}'>{6:c}</span>", resp.BalanceDate, IIf(resp.Balance > 0, "black", "red"), resp.Balance, IIf(resp.Processed > 0, "black", "black"), resp.Processed, IIf(resp.UnProcessed > 0, "black", "black"), resp.UnProcessed, IIf(resp.Balance + resp.Processed + resp.UnProcessed > 0, "black", "black"), resp.Balance + resp.Processed + resp.UnProcessed)
        Catch ex As Exception
            lblBalance.Text = "There was an error trying to get the account balance. Please, contact your system administrator."
        Finally
            If Not objQuery Is Nothing Then objQuery.Close()
        End Try
    End Sub

    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
        Requery()
    End Sub

    Protected Sub UltraWebGrid1_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles UltraWebGrid1.InitializeLayout
        With UltraWebGrid1
            .DisplayLayout.CellClickActionDefault = Infragistics.WebUI.UltraWebGrid.CellClickAction.RowSelect
            .DisplayLayout.SelectTypeRowDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single
            .DisplayLayout.SelectedRowStyleDefault.BorderStyle = BorderStyle.None
            .DisplayLayout.ViewType = Infragistics.WebUI.UltraWebGrid.ViewType.Hierarchical
            .DisplayLayout.BorderCollapseDefault = Infragistics.WebUI.UltraWebGrid.BorderCollapse.Collapse
            .DisplayLayout.GroupByBox.Hidden = True
            .DisplayLayout.AllowColumnMovingDefault = Infragistics.WebUI.UltraWebGrid.AllowColumnMoving.None
            .DisplayLayout.RowExpAreaStyleDefault.BackColor = System.Drawing.Color.White
            .DisplayLayout.RowExpAreaStyleDefault.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            .DisplayLayout.RowExpAreaStyleDefault.BorderDetails.StyleBottom = BorderStyle.Solid
            .DisplayLayout.RowSelectorStyleDefault.BackColor = System.Drawing.Color.White

            .Bands(0).SelectedRowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#f1f1f1")
            .Bands(0).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(0).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
            '.Bands(0).ColFootersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.Yes
            .Bands(0).Columns(0).Header.Caption = "Transaction Id"
            .Bands(0).Columns(1).Width = New Unit("200px")
            .Bands(0).Columns(2).Width = New Unit("200px")
            .Bands(0).Columns(3).Format = "g"
            .Bands(0).Columns(3).Width = New Unit("120px")
            .Bands(0).Columns(4).Format = "g"
            .Bands(0).Columns(4).Width = New Unit("120px")
            .Bands(0).Columns(5).Width = New Unit("80px")
            .Bands(0).Columns(6).Width = New Unit("80px")
            .Bands(0).Columns(7).Width = New Unit("80px")
            .Bands(0).Columns(8).Width = New Unit("80px")
            .Bands(0).Columns(8).Format = "c"
            .Bands(0).Columns(8).CellStyle.HorizontalAlign = HorizontalAlign.Right
            .Bands(0).Columns(8).Header.Style.HorizontalAlign = HorizontalAlign.Right
            .Bands(0).Columns(9).Width = New Unit("80px")
            .Bands(0).Columns(9).Format = "c"
            .Bands(0).Columns(9).CellStyle.HorizontalAlign = HorizontalAlign.Right
            .Bands(0).Columns(9).Header.Style.HorizontalAlign = HorizontalAlign.Right
            .Bands(0).RowStyle.BorderStyle = BorderStyle.None
            .Bands(0).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
            .Bands(0).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            .Bands(0).RowStyle.Padding.Right = Unit.Pixel(3)
            '.Bands(0).Columns(2).Header.ClickActionResolved = Infragistics.WebUI.UltraWebGrid.HeaderClickAction.Select

            .Bands(1).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(1).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
            .Bands(1).DefaultRowHeight = New Unit("304px")
            .Bands(1).RowStyle.BorderStyle = BorderStyle.None
            .Bands(1).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            .Bands(1).ColFootersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            .Bands(1).Columns(1).Width = Unit.Percentage(100) ' New Unit("100%")
            .Bands(1).RowStyle.BorderStyle = BorderStyle.None
            .DisplayLayout.Bands(1).Columns(0).Hidden = True

        End With
    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Dim objQuery As New WCFClient.QuerySvc
        Dim tblTransactions As DataTable = objQuery.GetControlledAccountTransactions(ddlControlledAccount.SelectedItem.Text, CDate(txtBeginDate.Text), CDate(txtEndDate.Text & " 23:59:59")).Tables("Transactions")
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

        For Each row As DataRow In tblTransactions.Rows
            tr = New TableRow
            For i As Integer = 0 To tblTransactions.Columns.Count - 1
                cell = New TableCell
                'cell.Attributes.Add("class", "text")
                cell.Text = row.Item(i).ToString
                tr.Cells.Add(cell)
            Next
            table.Rows.Add(tr)
        Next

        table.RenderControl(htw)

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.ContentType = "application/ms-excel"
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=Transactions.xls")
        'HttpContext.Current.Response.Write("<style>.text { mso-number-format:\@; } </style>")
        HttpContext.Current.Response.Write(sw.ToString)
        HttpContext.Current.Response.End()
    End Sub
End Class
