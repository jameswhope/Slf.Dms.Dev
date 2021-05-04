
Partial Class FormMgr_Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            ListForms()
        End If
    End Sub

    Private Sub ListForms()
        With gvForms
            .DataSource = FormHelper.GetFormsList
            .DataBind()
        End With
    End Sub

    Protected Sub lnkAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAdd.Click

    End Sub

    Protected Sub gvForms_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvForms.RowCommand
        Select Case e.CommandName.ToLower
            Case "delete"
                Dim dk As DataKey = gvForms.DataKeys(e.CommandArgument)
                '..
        End Select
    End Sub

    Protected Sub gvForms_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvForms.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim btn As ImageButton = e.Row.Cells(1).Controls(0)
            btn.OnClientClick = "if (!confirm('Are you sure you want to delete this entry?')) return false;"
            btn.ToolTip = "Delete"

            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#efefef';")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
        End If
    End Sub
End Class
