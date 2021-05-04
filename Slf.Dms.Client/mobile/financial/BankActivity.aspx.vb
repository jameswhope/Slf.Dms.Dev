
Partial Class mobile_financial_BankActivity
    Inherits System.Web.UI.Page
    Dim totals(6) As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub gvActivity_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvActivity.RowDataBound
        Dim i As Integer

        Select Case e.Row.RowType
            Case DataControlRowType.Header
                For i = 0 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Left
                    e.Row.Cells(i).Font.Bold = True
                Next i
                For i = 5 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Right
                    e.Row.Cells(i).Font.Bold = True
                Next i
            Case DataControlRowType.DataRow
                Dim amt As Integer
                For i = 5 To e.Row.Cells.Count - 1
                    amt = CInt(e.Row.Cells(i).Text)
                    If amt = 0 Or e.Row.Cells(i).Text.Contains(">>>>") Then
                        e.Row.Cells(i).Text = ""
                    Else
                        e.Row.Cells(i).Text = FormatCurrency(amt, 2)
                        e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Right
                        If amt < 0 Then
                            e.Row.Cells(i).ForeColor = System.Drawing.Color.Red
                        End If
                    End If
                Next i
        End Select
    End Sub

    Protected Sub gvSummary_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSummary.RowDataBound
        Dim i As Integer

        Select Case e.Row.RowType
            Case DataControlRowType.Header
                For i = 0 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Left
                    e.Row.Cells(i).Font.Bold = True
                Next i
                For i = 3 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Right
                    e.Row.Cells(i).Font.Bold = True
                Next i
            Case DataControlRowType.DataRow
                Dim amt As Integer
                For i = 3 To e.Row.Cells.Count - 1
                    amt = CInt(e.Row.Cells(i).Text)
                    e.Row.Cells(i).Text = FormatCurrency(amt, 2)
                    e.Row.Cells(i).HorizontalAlign = HorizontalAlign.Right
                    If amt < 0 Then
                        e.Row.Cells(i).ForeColor = System.Drawing.Color.Red
                    End If
                Next i
        End Select
    End Sub

End Class
