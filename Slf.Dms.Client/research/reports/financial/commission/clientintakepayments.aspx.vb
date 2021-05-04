Imports System.Data
Imports System.Data.SqlClient
Imports LocalHelper
Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Partial Class research_reports_financial_commission_clientintakepayments
    Inherits System.Web.UI.Page

    Private UserId As Integer
    Private totals() As Double

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserId = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Page.IsPostBack Then
            LoadQuickPickDates()
            ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
            Requery()
        End If
    End Sub

    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
        Requery()
    End Sub

    Private Sub Requery()
        Dim params(2) As SqlParameter
        Dim ds As DataSet
        Dim tbl As New DataTable
        Dim row As DataRow
        Dim rows() As DataRow
        Dim net As Double

        params(0) = New SqlParameter("@from", txtTransDate1.Text)
        params(1) = New SqlParameter("@to", txtTransDate2.Text & " 23:59:59")
        params(2) = New SqlParameter("@agencyid", 856)

        ds = SqlHelper.GetDataSet("stp_PaymentsToLexxiom", , params)

        tbl.Columns.Add("Attorney")
        For Each r As DataRow In ds.Tables(0).Rows
            tbl.Columns.Add(r(0))
        Next
        tbl.Columns.Add("Net Payments")
        tbl.AcceptChanges()

        For Each r As DataRow In ds.Tables(1).Rows
            rows = ds.Tables(2).Select("company = '" & r(0) & "'")

            row = tbl.NewRow
            row("Attorney") = r(0)

            net = 0
            For Each c As DataRow In rows
                row(c("feetype")) = FormatCurrency(Val(c("amountpaid")), 2)
                net += Val(c("amountpaid"))
            Next

            row("Net Payments") = FormatCurrency(net, 2)
            tbl.Rows.Add(row)
        Next

        ReDim totals(tbl.Columns.Count - 2)

        gvPayments.DataSource = tbl
        gvPayments.DataBind()

        gvPaymentsByClient.DataSource = ds.Tables(3)
        gvPaymentsByClient.DataBind()
    End Sub

    Private Sub LoadQuickPickDates()
        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yy") & "," & Now.ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yy") & "," & Now.AddDays(-1).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        Dim SelectedIndex As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblQuerySetting", "Value", _
                  "UserID = " & UserId & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'ddlQuickPickDate'"), 0)

        ddlQuickPickDate.SelectedIndex = SelectedIndex
        If Not ddlQuickPickDate.Items(SelectedIndex).Value = "Custom" Then
            Dim parts As String() = ddlQuickPickDate.Items(SelectedIndex).Value.Split(",")
            txtTransDate1.Text = parts(0)
            txtTransDate2.Text = parts(1)
        End If
    End Sub

    Protected Sub gvPayments_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPayments.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                e.Row.Cells(0).Text = ""
            Case DataControlRowType.DataRow
                For c As Integer = 1 To e.Row.Cells.Count - 1
                    totals(c - 1) += Val(e.Row.Cells(c).Text.Replace("$", "").Replace(",", ""))
                Next

                e.Row.Cells(0).Style("text-align") = "left"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#E3E3E3';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
            Case DataControlRowType.Footer
                For c As Integer = 1 To e.Row.Cells.Count - 1
                    e.Row.Cells(c).Text = FormatCurrency(totals(c - 1), 2)
                Next
        End Select
    End Sub

    Protected Sub gvPaymentsByClient_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPaymentsByClient.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                e.Row.Cells(0).Style("text-align") = "left"
                e.Row.Cells(1).Style("text-align") = "left"
                e.Row.Cells(2).Style("text-align") = "left"
            Case DataControlRowType.DataRow
                e.Row.Cells(0).Style("text-align") = "left"
                e.Row.Cells(1).Style("text-align") = "left"
                e.Row.Cells(2).Style("text-align") = "left"
                e.Row.Cells(3).Text = FormatCurrency(Val(e.Row.Cells(3).Text))
                e.Row.Cells(4).Text = FormatCurrency(Val(e.Row.Cells(4).Text))
                e.Row.Cells(5).Text = FormatCurrency(Val(e.Row.Cells(5).Text))
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#E3E3E3';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
        End Select
    End Sub
End Class
