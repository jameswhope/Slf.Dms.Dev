
Partial Class processing_popups_RejectionDetails
    Inherits System.Web.UI.Page

    Public UserID As Integer
    Public SettlementID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Request.QueryString("sid") Is Nothing Then
            Response.Redirect("~/processing/")
        Else
            SettlementID = Integer.Parse(Request.QueryString("sid"))
        End If

        If Not Page.IsPostBack AndAlso SettlementID <> 0 Then
            Me.SettCalcs.LoadSettlementInfo(SettlementID)
        End If

    End Sub

End Class
