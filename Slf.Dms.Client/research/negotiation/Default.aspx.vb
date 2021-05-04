Imports Drg.Util.DataHelpers

Partial Class project_Default
    Inherits System.Web.UI.Page

#Region "Variables"
    Private Locked As Boolean
    Private UserID As Integer
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        Locked = False

        lblLocked.Text = ""
        pnlMessage.Visible = False

        If Boolean.TryParse(Request.QueryString("locked"), Locked) Then
            If Locked = True Then
                lblLocked.Text = "The Negotiation Interface is currently locked by " & UserHelper.GetName(NegotiationHelper.IsLockedBy()) & ".<br />" & _
                    "Please try again later."

                pnlMessage.Visible = True
            End If
        End If
    End Sub

    Protected Sub lnkUnlock_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUnlock.Click
        If NegotiationHelper.IsLockedBy() = UserID Then
            NegotiationHelper.Unlock(UserID)
        End If
    End Sub

    Protected Sub lnkLock_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLock.Click
        NegotiationHelper.Lock(UserID)
    End Sub
End Class