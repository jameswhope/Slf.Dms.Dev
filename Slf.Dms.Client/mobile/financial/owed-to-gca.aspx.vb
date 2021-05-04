Imports System.Data
Imports System.IO

Partial Class mobile_financial_owed_to_gca
    Inherits System.Web.UI.Page

    Dim totals(6) As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub gvOwed_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvOwed.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
                For i As Integer = 1 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Right
                    e.Row.Cells(i).Font.Bold = False
                Next
            Case DataControlRowType.DataRow
                Dim amt As Integer
                For i As Integer = 1 To e.Row.Cells.Count - 1
                    amt = CInt(e.Row.Cells(i).Text)
                    e.Row.Cells(i).Text = FormatCurrency(amt, 0)
                    e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Right
                    totals(i - 1) += amt
                Next
            Case DataControlRowType.Footer
                For i As Integer = 1 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).Text = FormatCurrency(totals(i - 1), 0)
                    e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Right
                Next
        End Select
    End Sub
End Class
