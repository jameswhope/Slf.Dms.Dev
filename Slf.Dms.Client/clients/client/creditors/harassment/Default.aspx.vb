Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Partial Class Clients_client_creditors_harassment_Default
    Inherits System.Web.UI.Page
    Private UserID As Integer
    Private DataClientID As String
    Private AccountID As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        DataClientID = Request.QueryString("id")
        AccountID = Request.QueryString("aid")
        If AccountID.Contains("/") Then
            AccountID = AccountID.Substring(0, AccountID.IndexOf("/"))
        End If

        'Me.harassment1.DataClientID = DataClientID
        'Me.harassment1.CreditorAccountID = AccountID
        'Me.harassment1.CreatedBy = UserID

    End Sub

    'Protected Sub harassment1_ReloadDocuments(ByVal sender As Object, ByVal e As CreditorHarassmentFormControl.harassDocumentEventArgs) Handles harassment1.ReloadDocuments
    '    Response.Redirect(String.Format("~/clients/client/creditors/harassment/?id={0}&aid={1}", DataClientID, AccountID))
    'End Sub
End Class
