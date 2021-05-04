Imports AnalyticsHelper

Partial Class reports_click_report
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            SetDates()
            LoadReport()
        End If
    End Sub

    Private Sub SetDates()
        'This week
        txtDate1.Text = Now.ToString("M/d/yy")
        txtDate2.Text = Now.ToString("M/d/yy")

        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("M/d/yy") & "," & Now.ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("M/d/yy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("M/d/yy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("M/d/yy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("M/d/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("M/d/yy") & "," & Now.AddDays(-1).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("M/d/yy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("M/d/yy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("M/d/yy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("M/d/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = 0
    End Sub

    Private Sub LoadReport()
        Try
            ds_ClickReport.SelectParameters("from").DefaultValue = txtDate1.Text
            ds_ClickReport.SelectParameters("to").DefaultValue = txtDate2.Text & " 23:59"
            ds_ClickReport.DataBind()
            gvClickReport.DataBind()
        Catch ex As Exception
            LeadHelper.LogError("Click Report", ex.Message, ex.StackTrace)
        End Try
    End Sub

    Protected Sub btnApply_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnApply.Click
        LoadReport()
    End Sub

    Protected Sub gvClickReport_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvClickReport.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
            If e.Row.RowState = DataControlRowState.Alternate Then
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
            Else
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
            End If
        End If
    End Sub

End Class
