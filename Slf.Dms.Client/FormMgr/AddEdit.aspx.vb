Imports System.Data
Imports Drg.Util.DataAccess

Partial Class FormMgr_AddEdit
    Inherits System.Web.UI.Page

    Private UserID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Page.IsPostBack Then
            LoadFormFields()

            If IsNumeric(Request.QueryString("id")) Then
                LoadFormContent()
                lblAddEdit.Text = "Edit"
            Else
                aFormName.InnerHtml = FormHelper.GetFormName(CInt(Request.QueryString("fid")))
                aFormName.HRef = "FormContent.aspx?fid=" & Request.QueryString("fid")
                aCancel.HRef = "FormContent.aspx?fid=" & Request.QueryString("fid")
                lblAddEdit.Text = "Add"
            End If
        End If
    End Sub

    Private Sub LoadFormFields()
        Dim tbl As DataTable = FormHelper.GetFormFields
        Dim row As DataRow

        row = tbl.NewRow
        row("FormFieldID") = -1
        row("DisplayName") = ""
        tbl.Rows.InsertAt(row, 0)

        ddlFormField.DataSource = tbl
        ddlFormField.DataTextField = "DisplayName"
        ddlFormField.DataValueField = "FormFieldID"
        ddlFormField.DataBind()
    End Sub

    Private Sub LoadFormContent()
        Dim tbl As DataTable = FormHelper.GetFormContentDetail(CInt(Request.QueryString("id")))
        Dim li As ListItem

        If tbl.Rows.Count = 1 Then
            aFormName.InnerHtml = tbl.Rows(0)("FormName")
            aFormName.HRef = "FormContent.aspx?fid=" & tbl.Rows(0)("FormID")
            aCancel.HRef = "FormContent.aspx?fid=" & tbl.Rows(0)("FormID")
            hdnFormID.Value = tbl.Rows(0)("FormID")
            li = ddlFormField.Items.FindByValue(tbl.Rows(0)("FormFieldID"))
            If Not IsNothing(li) Then
                li.Selected = True
            End If
            WebHtmlEditor1.Text = tbl.Rows(0)("Html")
        End If
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim title As String = Left(WebHtmlEditor1.TextPlain, 65) & ".."

        If IsNumeric(Request.QueryString("id")) Then
            'update
            FormHelper.UpdateFormContent(CInt(Request.QueryString("id")), title, WebHtmlEditor1.Text, UserID, CInt(ddlFormField.SelectedItem.Value))
            Response.Redirect("FormContent.aspx?fid=" & hdnFormID.Value)
        Else
            'add
            FormHelper.AddFormContent(title, WebHtmlEditor1.Text, CInt(Request.QueryString("fid")), UserID, CInt(ddlFormField.SelectedItem.Value))
            Response.Redirect("FormContent.aspx?fid=" & Request.QueryString("fid"))
        End If
    End Sub
End Class
