Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Partial Class research_reports_financial_commission_WithholdingReport
    Inherits System.Web.UI.Page

    Dim totals(6) As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            LoadCommRec()
        End If
    End Sub

    Protected Sub gvWithheld_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvWithheld.RowDataBound
        'Select Case e.Row.RowType
        '    Case DataControlRowType.Header
        '        e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
        '        e.Row.Cells(0).Font.Bold = False
        '        e.Row.Cells(0).Width = Unit.Pixel(300)
        '        e.Row.Cells(e.Row.Cells.Count - 1).Width = Unit.Pixel(100)
        '        For i As Integer = 1 To e.Row.Cells.Count - 1
        '            e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Right
        '            e.Row.Cells(i).Font.Bold = False
        '        Next
        '    Case DataControlRowType.DataRow
        '        Dim amt As Integer
        '        e.Row.Cells(0).CssClass = "listItem4"
        '        For i As Integer = 1 To e.Row.Cells.Count - 1
        '            amt = CInt(e.Row.Cells(i).Text)
        '            e.Row.Cells(i).Text = FormatCurrency(amt, 0)
        '            e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Right
        '            e.Row.Cells(i).CssClass = "listItem4"
        '            totals(i - 1) += amt
        '        Next
        '        e.Row.Style("cursor") = "default"
        '        e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#f5f5f5';")
        '        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
        '    Case DataControlRowType.Footer
        '        e.Row.Cells(0).CssClass = "headItem4"
        '        For i As Integer = 1 To e.Row.Cells.Count - 1
        '            e.Row.Cells(i).Text = FormatCurrency(totals(i - 1), 0)
        '            e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Right
        '            e.Row.Cells(i).CssClass = "headItem4"
        '        Next
        'End Select
    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        'Dim dv As DataView = ds_Withheld.Select(DataSourceSelectArguments.Empty)
        'dv.Sort = "Totals"

        'Dim tblTransactions As DataTable = dv.Table
        'Dim sw As New StringWriter
        'Dim htw As New HtmlTextWriter(sw)
        'Dim table As New System.Web.UI.WebControls.Table
        'Dim tr As New System.Web.UI.WebControls.TableRow
        'Dim cell As TableCell

        'For i As Integer = 0 To tblTransactions.Columns.Count - 1
        '    cell = New TableCell
        '    cell.Text = tblTransactions.Columns(i).ColumnName
        '    tr.Cells.Add(cell)
        'Next
        'table.Rows.Add(tr)

        'For Each row As DataRow In tblTransactions.Rows
        '    tr = New TableRow
        '    For i As Integer = 0 To tblTransactions.Columns.Count - 1
        '        cell = New TableCell
        '        cell.Attributes.Add("class", "text")
        '        cell.Text = row.Item(i).ToString
        '        tr.Cells.Add(cell)
        '    Next
        '    table.Rows.Add(tr)
        'Next

        'table.RenderControl(htw)

        'HttpContext.Current.Response.Clear()
        'HttpContext.Current.Response.ContentType = "application/ms-excel"
        'HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=owed.xls")
        'HttpContext.Current.Response.Write(sw.ToString)
        'HttpContext.Current.Response.End()
    End Sub

    Protected Sub LoadCommRec()
        'Dim dt As DataTable

        'Me.ddlAgency.Items.Add(New ListItem("All Recieptients", "0"))

        'dt = App_Code.HoldbackHelper.LoadCommRec
        'For Each row As DataRow In dt.Rows
        '    'If row("AccountNumber").ToString <> "" Then
        '    Me.ddlAgency.Items.Add(New ListItem(row.Item("Display"), row.Item("AccountNumber")))
        '    'End If
        'Next

    End Sub

    Protected Sub LoadRptData(ByVal sDate As String, ByVal eDate As String, ByVal AccountNumber As String)
        Dim dt As New DataTable

        If sDate = "" Then
            sDate = "#" & Format(Now, "MM/dd/yyyy") & " 12:01AM#"
        Else
            sDate = "#" & sDate & " 12:01AM#"
        End If
        If eDate = "" Then
            eDate = "#" & Format(Now, "MM/dd/yyyy") & " 11:59PM#"
        Else
            eDate = "#" & eDate & " 11:59PM#"
        End If

        dt = App_Code.HoldbackHelper.LoadRptData(sDate, eDate, AccountNumber)

        If Not dt Is Nothing Then
            If dt.Rows.Count <= 0 Then
                Me.dvData.Visible = True
                Me.gvWithheld.DataSource = Nothing
                Me.gvWithheld.DataBind()
            Else
                Me.dvData.Visible = False
                Me.gvWithheld.DataSource = dt
                Me.gvWithheld.DataBind()
            End If
        End If
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ibRefresh.Click
        If Me.ddlAgency.SelectedIndex > 0 Then
            LoadRptData(Me.txtStart.Text, Me.txtEnd.Text, Me.ddlAgency.SelectedIndex)
        Else
            Alert.Show("Please select a report to run.")
        End If
    End Sub

End Class
