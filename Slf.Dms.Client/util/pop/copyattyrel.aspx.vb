Imports Drg.Util.DataAccess

Partial Class util_pop_copyattyrel
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadCompanyies()
        End If
    End Sub

    Private Sub LoadCompanyies()
        Dim objCompany As New Lexxiom.BusinessServices.Company
        Dim li As ListItem
        Dim intSourceId As Integer

        ddlSource.DataSource = objCompany.CompanyList
        ddlSource.DataTextField = "Name"
        ddlSource.DataValueField = "CompanyID"
        ddlSource.DataBind()

        ddlDest.DataSource = objCompany.CompanyList
        ddlDest.DataTextField = "Name"
        ddlDest.DataValueField = "CompanyID"
        ddlDest.DataBind()

        If IsNumeric(Request.QueryString("id")) Then
            intSourceId = CType(Request.QueryString("id"), Integer)
            li = ddlSource.Items.FindByValue(intSourceId.ToString)
            If Not li Is Nothing Then
                li.Selected = True
            End If
        End If

        objCompany = Nothing
    End Sub

    Protected Sub lnkDone_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDone.Click
        Dim objCompany As New Lexxiom.BusinessServices.Company
        Dim intSourceId As Integer = CType(ddlSource.SelectedItem.Value, Integer)
        Dim intDestId As Integer = CType(ddlDest.SelectedItem.Value, Integer)
        Dim intUserID As Integer = DataHelper.Nz_int(Page.User.Identity.Name)

        objCompany.CopyRelationships(intSourceId, intDestId, intUserID, chkPrimary.Checked)

        ScriptManager.RegisterStartupScript(Me, Me.GetType, "Done", "window.opener.CopyRelationships_Back(" & intDestId.ToString & "); window.close();", True)
    End Sub
End Class
