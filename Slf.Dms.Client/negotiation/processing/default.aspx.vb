Imports Drg.Util.DataAccess

Partial Class negotiation_processing_default
    Inherits System.Web.UI.Page

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        If PermissionHelperLite.HasPermission(DataHelper.Nz_int(Page.User.Identity.Name), "Settlement Processing") Then
            SettlementProcessing1.LoadSettlementProcTabStrips()
        End If
    End Sub
End Class
