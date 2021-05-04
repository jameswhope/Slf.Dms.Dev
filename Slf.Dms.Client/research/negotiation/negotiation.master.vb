Option Explicit On

Imports Drg.Util.DataHelpers

Partial Class negotiation
    Inherits PermissionMasterPage

#Region "Variables"
    Private UserID As Integer
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        If Request.QueryString("locked") Is Nothing Then
            If NegotiationHelper.IsLocked(UserID) Then
                Response.Redirect("~/research/negotiation/default.aspx?locked=true")
            Else
                NegotiationHelper.Lock(UserID)
            End If
        End If
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub
End Class