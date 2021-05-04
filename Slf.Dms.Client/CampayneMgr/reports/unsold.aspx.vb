Imports AnalyticsHelper

Partial Class reports_unsold
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            SetDates()
            LoadReport()
        End If
    End Sub

    Private Sub SetDates()
        txtDate1.Text = Now.ToString("M/d/yyyy")
        txtDate2.Text = Now.ToString("M/d/yyyy")

        ddlQuickPickDate.Items.Clear()
        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("M/d/yyyy") & "," & Now.AddDays(-1).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("M/d/yyyy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("M/d/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("M/d/yyyy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("M/d/yyyy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("M/d/yyyy")))

        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = 0
    End Sub

    Private Sub LoadReport()
        Try
            gvSummary.DataSource = ReportsHelper.UnsoldDataSummary(txtDate1.Text, txtDate2.Text, txtTime1.Text, txtTime2.Text)
            gvSummary.DataBind()
            gvAttempts.DataSource = ReportsHelper.UnsoldDataAnalysis(txtDate1.Text, txtDate2.Text, txtTime1.Text, txtTime2.Text)
            gvAttempts.DataBind()
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(phrJsRunner, phrJsRunner.GetType(), "msg", "$().toastmessage('showErrorToast', 'Error loading report. Please check your date and time.');", True)
        End Try
    End Sub

    Protected Sub gvAttempts_DataBound(sender As Object, e As System.EventArgs) Handles gvAttempts.DataBound

        Dim arow As New GridViewRow(-1, -1, DataControlRowType.Header, DataControlRowState.Normal)
        Dim table As Table = DirectCast(gvAttempts.Controls(0), Table)
        Dim hdr As TableRow = table.Rows(0)
        Dim cell As TableHeaderCell

        cell = New TableHeaderCell
        cell.Text = "&nbsp;"
        cell.CssClass = "headitem3"
        cell.ColumnSpan = 5
        arow.Cells.Add(cell)

        cell = New TableHeaderCell
        cell.Text = "RealTime Leads"
        cell.CssClass = "headitem3"
        cell.HorizontalAlign = HorizontalAlign.Center
        cell.ColumnSpan = 4
        arow.Cells.Add(cell)

        cell = New TableHeaderCell
        cell.Text = "Aged Leads"
        cell.CssClass = "headitem3"
        cell.HorizontalAlign = HorizontalAlign.Center
        cell.ColumnSpan = 4
        arow.Cells.Add(cell)

        cell = New TableHeaderCell
        cell.Text = "All"
        cell.CssClass = "headitem2"
        cell.HorizontalAlign = HorizontalAlign.Center
        cell.ColumnSpan = 1
        arow.Cells.Add(cell)

        table.Controls.AddAt(0, arow)
    End Sub

    Protected Sub gvAttempts_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAttempts.RowDataBound

        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
                If e.Row.RowState = DataControlRowState.Alternate Then
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
                Else
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If

                Dim row As Data.DataRowView = TryCast(e.Row.DataItem, Data.DataRowView)
                If CInt(row("rt_accepted")) + CInt(row("a_accepted")) >= CInt(row("DailyCap")) Then
                    e.Row.ForeColor = System.Drawing.Color.Blue
                End If
                If Val(row("rt_rate")) > 0.5 Then
                    e.Row.Cells(8).Style("color") = "red"
                End If
                If Val(row("a_rate")) > 0.5 Then
                    e.Row.Cells(12).Style("color") = "red"
                End If
                If Val(row("total_rate")) > 0.5 Then
                    e.Row.Cells(13).Style("color") = "red"
                End If
        End Select
    End Sub

    Protected Sub btnApply_Click(sender As Object, e As System.EventArgs) Handles btnApply.Click
        LoadReport()
    End Sub

    Protected Sub gvSummary_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSummary.RowDataBound

        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                For i As Integer = 0 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Center
                Next
        End Select
    End Sub

End Class