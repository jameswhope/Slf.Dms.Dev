
Partial Class admin_creditors_useractivity
    Inherits System.Web.UI.Page

    Private sumValidated As Integer = 0
    Private sumApproved As Integer = 0
    Private sumDuplicates As Integer = 0
    Private sumPending As Integer = 0
    Private sumTotal As Integer = 0

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim dk As DataKey = GridView1.DataKeys(e.Row.RowIndex)

                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#ffffda';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                e.Row.Attributes.Add("onclick", String.Format("javascript:window.location.href='validationdetail.aspx?id={0}';", dk(0)))

                sumValidated += Convert.ToInt16(DataBinder.Eval(e.Row.DataItem, "validated"))
                sumApproved += Convert.ToInt16(DataBinder.Eval(e.Row.DataItem, "approved"))
                sumDuplicates += Convert.ToInt16(DataBinder.Eval(e.Row.DataItem, "duplicates"))
                sumPending += Convert.ToInt16(DataBinder.Eval(e.Row.DataItem, "pending"))
                sumTotal += Convert.ToInt16(DataBinder.Eval(e.Row.DataItem, "total"))
            Case DataControlRowType.Footer
                e.Row.Cells(3).Text = sumValidated
                e.Row.Cells(4).Text = sumApproved
                e.Row.Cells(5).Text = sumDuplicates
                e.Row.Cells(6).Text = sumpending
                e.Row.Cells(7).Text = sumTotal
        End Select
    End Sub
End Class
