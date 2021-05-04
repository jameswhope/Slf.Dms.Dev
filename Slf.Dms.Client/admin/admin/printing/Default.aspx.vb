Imports Drg.Util.DataAccess
Imports PrintQueueControl


Partial Class admin_printing_Default
    Inherits PermissionPage
    Private _UserID As Integer


    Protected Sub Clients_client_reports_printQueue_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        PrintQueueControl1.CurrentUserID = _UserID

    End Sub

    Protected Sub lnkPrintQueue_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrintQueue.Click

        PrintQueueControl1.PrintSelected()

    End Sub


    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(PrintQueueControl1, c, "Admin-Printing")
    End Sub
End Class