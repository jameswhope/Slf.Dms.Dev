Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Lexxiom.BusinessServices
Partial Class negotiation_master_default
    Inherits System.Web.UI.Page

    Dim bsCriteriaBuilder As Lexxiom.BusinessServices.CriteriaBuilder = New Lexxiom.BusinessServices.CriteriaBuilder()
#Region "Variables"
    Private UserID As Integer
#End Region


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim entityId As Integer
        Dim t As String = ""

        UserID = Integer.Parse(Page.User.Identity.Name)
        If Not Request.QueryString("entityId") Is Nothing Then t = Request.QueryString("entityId")
        If (Not Page.IsPostBack) Then
            If (t.Trim() <> "") Then
                CommonRedirect(t)
            Else
                entityId = bsCriteriaBuilder.GetEntityId(UserID)

                If entityId > 0 AndAlso DataHelper.Nz_int(DataHelper.FieldLookup("tblNegotiationEntity", "ParentNegotiationEntityID", "NegotiationEntityID = " & entityId), -1) = -1 Then
                    entityId = 0
                End If

                If (entityId = 0) Then
                    ' Continue
                ElseIf (entityId < 0) Then
                    CommonRedirect("999999")
                Else
                    CommonRedirect(entityId)
                End If
            End If
        End If
    End Sub
    Protected Sub CommonRedirect(ByVal t As String)
        Response.Redirect("criteriadistribution.aspx?entityId=" & t)
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