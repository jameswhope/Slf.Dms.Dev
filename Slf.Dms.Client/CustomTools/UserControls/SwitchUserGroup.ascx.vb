Imports System.Data
Imports Drg.Util.DataAccess

Partial Class CustomTools_UserControls_SwitchUserGroup
    Inherits System.Web.UI.UserControl

    Private _UserId As Integer

    Public Event UserGroupChanged()

    Public Sub LoadUserGroups()
        Dim dt As DataTable = SwitchGroupHelper.GetUserGroups(_UserId)
        ddlUserGroup.DataSource = dt
        ddlUserGroup.DataTextField = "GroupName"
        ddlUserGroup.DataValueField = "UserGroupId"
        ddlUserGroup.DataBind()
        If ddlUserGroup.Items.Count > 0 Then ddlUserGroup.SelectedIndex = ddlUserGroup.Items.IndexOf(ddlUserGroup.Items.FindByValue(SwitchGroupHelper.GetAssignedUserGroup(_UserId)))
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _UserId = DataHelper.Nz_int(Page.User.Identity.Name)
        If Not Me.IsPostBack Then
            LoadUserGroups()
        End If
    End Sub

    Protected Sub btnSwitch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSwitch.Click
        SwitchGroupHelper.SwitchUserGroup(_UserId, ddlUserGroup.SelectedValue, _UserId)
        ScriptManager.RegisterStartupScript(Me.Page, GetType(Page), "redirectfromswitch", "DoSwitchRedirect();", True)
    End Sub

    Protected Sub lnkSwitchRedirect_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSwitchRedirect.Click
        Response.Redirect("~/Redirect.aspx")
    End Sub
End Class
