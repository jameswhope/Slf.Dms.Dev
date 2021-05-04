Imports Drg.Util.DataAccess
Imports System.Data
Imports System.IO

Partial Class research_queries_financial_accounting_transfers
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            Initialize()
            Requery()
        End If
    End Sub

    Private Sub Initialize()
        txtFromDate.Value = DateTime.Today.ToShortDateString
        txtToDate.Value = DateTime.Today.ToShortDateString

        ddlFromCompany.Items.Add(New ListItem("PALMER", "2"))
        ddlFromCompany.Items.Add(New ListItem("SIEDEMAN", "1"))

        ddlToCompany.Items.Add(New ListItem("IÑIGUEZ", "3"))
        ddlToCompany.Items.Add(New ListItem("MOSSLER", "4"))
        ddlToCompany.Items.Add(New ListItem("PEAVEY", "5"))
    End Sub

    Private Sub Requery()
        UltraWebGrid1.DataSource = BankTransfers.DefaultView
        UltraWebGrid1.DataBind()
    End Sub

    Private Function BankTransfers() As DataTable
        Dim ds As New DataSet

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetBankTransfers")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "DateFrom", CDate(txtFromDate.Text))
                DatabaseHelper.AddParameter(cmd, "DateTo", CDate(txtToDate.Text).AddDays(1))
                DatabaseHelper.AddParameter(cmd, "FromCompanyID", CInt(ddlFromCompany.SelectedItem.Value))
                DatabaseHelper.AddParameter(cmd, "ToCompanyID", CInt(ddlToCompany.SelectedItem.Value))

                Dim da As New Data.SqlClient.SqlDataAdapter(cmd)

                da.SelectCommand = cmd
                da.Fill(ds)

                If Not cmd.Connection.State = ConnectionState.Closed Then
                    cmd.Connection.Close()
                End If
            End Using
        End Using

        lblItems.Text = "(" & ds.Tables(0).Rows.Count & " transfers)"

        Return ds.Tables(0)
    End Function

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
            .Bands(0).Columns(0).Width = New Unit("170px")
            .Bands(0).Columns(1).Format = "c"
            .Bands(0).RowStyle.BorderStyle = BorderStyle.None
            .Bands(0).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
            .Bands(0).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            .Bands(0).RowStyle.Padding.Right = Unit.Pixel(3)
        End With
    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Dim tblTransactions As DataTable = BankTransfers()
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
