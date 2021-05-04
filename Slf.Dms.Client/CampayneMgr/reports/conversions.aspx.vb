Imports AnalyticsHelper
Imports System.Data

Partial Class admin_conversions
    Inherits System.Web.UI.Page

    Private _totalConv As Integer = 0
    Private _totalRev As Double

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
            ds_Conversions.SelectParameters("from").DefaultValue = txtDate1.Text
            ds_Conversions.SelectParameters("to").DefaultValue = txtDate2.Text & " 23:59"
            ds_Conversions.DataBind()
            gvConversions.DataBind()
        Catch ex As Exception
            LeadHelper.LogError("Conversions Rpt", ex.Message, ex.StackTrace)
        End Try
    End Sub

    Protected Sub btnApply_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnApply.Click
        LoadReport()
    End Sub

    Protected Sub gvConversions_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvConversions.RowCreated

        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
        End Select

    End Sub

    Protected Sub gvConversions_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvConversions.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
            If e.Row.RowState = DataControlRowState.Alternate Then
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
            Else
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
            End If

            If Val(e.Row.Cells(2).Text) >= Val(e.Row.Cells(3).Text) AndAlso txtDate1.Text.Equals(txtDate2.Text) Then
                e.Row.Style("color") = "blue"
            End If

            If Not txtDate1.Text.Equals(txtDate2.Text) Then
                e.Row.Cells(4).Text = "-"
            End If
            Dim row As DataRowView = TryCast(e.Row.DataItem, DataRowView)
            _totalConv += CInt(row("Conversions"))
            _totalRev += Val(row("Revenue"))
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).Text = "*"
            e.Row.Cells(0).Style("text-align") = "left"
            e.Row.Cells(1).Text = "*"
            e.Row.Cells(1).Style("text-align") = "left"
            e.Row.Cells(2).Text = _totalConv
            e.Row.Cells(3).Text = "*"
            e.Row.Cells(3).Style("text-align") = "right"
            e.Row.Cells(4).Text = "*"
            e.Row.Cells(5).Text = "*"
            e.Row.Cells(6).Text = FormatCurrency(_totalRev)
        End If
    End Sub

End Class