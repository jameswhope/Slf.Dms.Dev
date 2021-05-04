
Partial Class Clients_Enrollment_DialerCall
    Inherits System.Web.UI.Page

    Private _CallMadeId As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _CallMadeId = Request.QueryString("callId")
    End Sub
End Class
