Imports AnalyticsHelper
Imports System.Data

Partial Class reports_disposition
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            SetDates()
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
            gvCampaigns.DataSource = ReportsHelper.DispositionReport(ddlCategory.SelectedItem.Text, txtDate1.Text, txtDate2.Text, txtTime1.Text, txtTime2.Text)
            gvCampaigns.DataBind()
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(phrJsRunner, phrJsRunner.GetType(), "msg", String.Format("$().toastmessage('showErrorToast', 'Error loading report.<br />{0}');", ex.Message), True)
        End Try
    End Sub

    Protected Sub btnApply_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnApply.Click
        LoadReport()
    End Sub

    Protected Sub gvCampaigns_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvCampaigns.RowDataBound

        Select Case e.Row.RowType
            Case DataControlRowType.Header
                e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
                e.Row.Cells(1).HorizontalAlign = HorizontalAlign.Left

            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
                If e.Row.RowState = DataControlRowState.Alternate Then
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
                Else
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If

                Dim row As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                Dim leads As Integer = CInt(row("Leads"))
                Dim pct As Double

                For i As Integer = 2 To e.Row.Cells.Count - 2
                    pct = Val(e.Row.Cells(i).Text) / leads
                    e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Center
                    If chkShowPct.Checked Then
                        e.Row.Cells(i).Text = String.Concat(e.Row.Cells(i).Text, " (", FormatPercent(pct, 0), ")")
                    End If
                Next

                e.Row.Cells(e.Row.Cells.Count - 1).HorizontalAlign = HorizontalAlign.Center

                e.Row.Cells(1).Font.Underline = True
                e.Row.Cells(1).Attributes.Add("onclick", String.Format("return ShowSubIds({0},'{1}');", row("ID"), row("Campaign")))
                e.Row.Cells(1).Style("cursor") = "pointer"

            Case DataControlRowType.Footer

        End Select

    End Sub

    Protected Sub ddlCategory_DataBound(sender As Object, e As System.EventArgs) Handles ddlCategory.DataBound
        LoadReport()
    End Sub

End Class