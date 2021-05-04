Imports Drg.Util.DataAccess

Partial Class Clients_Enrollment_Prompt
    Inherits System.Web.UI.Page

    Private UserId As Integer
    Private LeadId As Integer
    Private Dialog As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserId = DataHelper.Nz_int(Page.User.Identity.Name)
        LeadId = Request.QueryString("id")
        Dialog = Not Request.QueryString("dialog") Is Nothing
        If Not IsPostBack AndAlso Not Me.Request.UrlReferrer Is Nothing Then Me.hdnPageReferrer.Value = Me.Request.UrlReferrer.AbsoluteUri
    End Sub

    Protected Sub btnAccept_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAccept.Click
        Dim model As String
        If Me.rdNewEnrollment.Checked Then
            model = "newenrollment.aspx"
        Else
            model = "newenrollment2.aspx"
        End If
        SDModelHelper.ConvertToModel(model, LeadId, UserId)
        If Not Dialog Then
            Me.Response.Redirect(String.Format("{0}?id={1}", model, LeadId))
        Else
            Me.Page.ClientScript.RegisterStartupScript(GetType(Page), "redirectwind", String.Format("window.opener.location.href='{0}?id={1}';window.close();", model, LeadId), True)
        End If
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        If Not Dialog Then
            Me.Response.Redirect(Me.hdnPageReferrer.Value)
        Else
            Me.Page.ClientScript.RegisterStartupScript(GetType(Page), "closewind", "window.close();", True)
        End If
    End Sub
End Class
