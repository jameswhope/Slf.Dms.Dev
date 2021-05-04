Imports Drg.Util.DataAccess
Partial Class Settlement
    Inherits System.Web.UI.Page
    Private CreditorID As String
    Private ClientID As String
    Private UserID As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            sc.SettlementClientID = Page.Request.QueryString("id")
            sc.SettlementCreditorAccountID = Page.Request.QueryString("aid")
            sc.SettlementUserID = DataHelper.Nz_int(Page.User.Identity.Name)
            sc.LoadSettlementInfo()

        End If
    End Sub
End Class
