Imports System.Collections.Generic
Imports Drg.Util.DataAccess

Partial Class research_tools_harassment_Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CreditorHarassmentFormSearchControl1.UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        End If
    End Sub

    Public Overloads Overrides Sub VerifyRenderingInServerForm(ByVal control As System.Web.UI.Control)
        'confirms that an HtmlForm control is rendered for the
        'specified ASP.NET server control at run time.
    End Sub
End Class