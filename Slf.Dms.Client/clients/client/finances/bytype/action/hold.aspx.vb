Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data

Partial Class clients_client_finances_bytype_action_hold
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim UserID As Integer = DataHelper.Nz_int(User.Identity.Name)
        Dim ClientID As Integer = DataHelper.Nz_int(Request.QueryString("id"))

        lblBy.Text = UserHelper.GetName(UserID)
        imHold.Text = DateTime.Now.ToString("MM/dd/yyyy hh:mm tt")

    End Sub
End Class