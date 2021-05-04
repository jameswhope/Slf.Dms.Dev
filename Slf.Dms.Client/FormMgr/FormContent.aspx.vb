Imports Drg.Util.DataAccess

Partial Class FormMgr_FormContent
    Inherits System.Web.UI.Page

    Private UserID As Integer
    Private FormID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If IsNumeric(Request.QueryString("fid")) Then
            FormID = CInt(Request.QueryString("fid"))
        Else
            Response.Redirect("Default.aspx")
        End If

        If Not Page.IsPostBack Then
            LoadFormContent()
        End If
    End Sub

    Private Sub LoadFormContent()
        Dim name As String = FormHelper.GetFormName(FormID)
        hFormName.InnerHtml = name
        lblFormName.Text = name
        With gvFormContent
            .DataSource = FormHelper.GetFormContent(FormID)
            .DataBind()
        End With
    End Sub

    Protected Sub gvFormContent_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvFormContent.RowCommand
        Select Case e.CommandName.ToLower
            Case "delete"
                Dim dk As DataKey = gvFormContent.DataKeys(e.CommandArgument)
                FormHelper.DeleteFormContent(CInt(dk(0)))
                LoadFormContent()
        End Select
    End Sub

    Protected Sub gvFormContent_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvFormContent.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim btn As ImageButton = e.Row.Cells(1).Controls(0)
            btn.OnClientClick = "if (!confirm('Are you sure you want to delete this entry?')) return false;"
            btn.ToolTip = "Delete"

            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#efefef';")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
        End If
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim txtSeq As TextBox
        Dim dk As DataKey
        Dim chk As CheckBox

        For Each row As GridViewRow In gvFormContent.Rows
            If row.RowType = DataControlRowType.DataRow Then
                dk = gvFormContent.DataKeys(row.DataItemIndex)
                txtSeq = CType(row.FindControl("txtSeq"), TextBox)
                chk = CType(row.FindControl("chkShow"), CheckBox)
                FormHelper.UpdateFormContentSeq(CInt(dk(0)), CInt(Val(txtSeq.Text)), chk.Checked)
            End If
        Next

        LoadFormContent()
    End Sub

    Protected Sub lnkAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAdd.Click
        Response.Redirect("AddEdit.aspx?fid=" & FormID)
    End Sub

    Protected Sub gvFormContent_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles gvFormContent.RowDeleting

    End Sub
End Class
