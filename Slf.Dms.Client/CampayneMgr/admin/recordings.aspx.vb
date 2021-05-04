Imports AnalyticsHelper
Imports System.Data

Partial Class admin_recordings
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            SetDates()
            txtTime1.Text = Format(DateAdd(DateInterval.Hour, -2, Now), "h:mm tt")
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
            gvLeads.DataSource = ReportsHelper.ViciRecordings(txtDate1.Text, txtDate2.Text, txtTime1.Text, txtTime2.Text)
            gvLeads.DataBind()
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(phrJsRunner, phrJsRunner.GetType(), "msg", String.Format("$().toastmessage('showErrorToast', 'Error loading report.<br />{0}');", ex.Message), True)
        End Try
    End Sub

    Protected Sub btnApply_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnApply.Click
        LoadReport()
    End Sub

    Protected Sub gvLeads_DataBound(sender As Object, e As System.EventArgs) Handles gvLeads.DataBound
        If Page.IsPostBack Then
            ScriptManager.RegisterStartupScript(phrJsRunner, phrJsRunner.GetType(), "msg", String.Format("$().toastmessage('showSuccessToast', '{0} transfers found');", gvLeads.Rows.Count), True)
        End If
    End Sub

    Protected Sub gvLeads_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvLeads.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                For i As Integer = 0 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Left
                Next
            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
                If e.Row.RowState = DataControlRowState.Alternate Then
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
                Else
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If
        End Select
    End Sub

End Class