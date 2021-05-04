Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Partial Class clients_client_creditors_accounts_action_settle
    Inherits System.Web.UI.Page

    Public CurrentFee As Double

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim ClientID As Integer = StringHelper.ParseInt(Request.QueryString("id"))
        Dim AccountID As Integer = StringHelper.ParseInt(Request.QueryString("aid"))

    End Sub
End Class