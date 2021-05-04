
Partial Class Clients_Enrollment_Incentives
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            gvReps.Sort("Rep", SortDirection.Ascending)
        End If
    End Sub

    Protected Sub gvReps_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvReps.RowCreated
        If e.Row.RowType = DataControlRowType.Header Then
            For Each cell As TableCell In e.Row.Cells
                If cell.HasControls Then
                    If cell.Controls.Count = 1 Then 'skip the icon header
                        Dim lnk As LinkButton = DirectCast(cell.Controls(0), LinkButton)
                        If Not lnk Is Nothing Then
                            Dim img As New Web.UI.WebControls.Image
                            img.ImageUrl = "~/images/sort-" & IIf(gvReps.SortDirection = SortDirection.Ascending, "asc", "desc") & ".png"
                            If gvReps.SortExpression = lnk.CommandArgument Then
                                cell.Controls.Add(New LiteralControl(" "))
                                cell.Controls.Add(img)
                            End If
                        End If
                    End If
                End If
            Next
        End If
    End Sub

    Protected Sub gvReps_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvReps.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim row As Data.DataRowView = CType(e.Row.DataItem, Data.DataRowView)
            e.Row.Style("cursor") = "hand"
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CAE1FF';")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
            e.Row.Attributes.Add("onclick", "window.location.href='IncentiveDetail.aspx?id=" & row("repid") & "&h=i';")
            If CInt(row("supid")) > 0 Then 'is supervisor?
                Dim imgTree As HtmlImage = TryCast(e.Row.FindControl("imgTree"), HtmlImage)
                imgTree.Src = "~/images/16x16_star.png"
                imgTree.Alt = "Current supervisor"
            End If
        End If
    End Sub

End Class
