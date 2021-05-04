
Partial Class CustomTools_UserControls_controlTester
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim id As String = Request.QueryString("id")
        Dim sid As String = Request.QueryString("sid")

        PaymentArrangementControl1.ViewClientInfo()
        PaymentArrangementControl1.ViewCreditorInfo()
        PaymentArrangementControl1.ViewSettlementInfo()

        PaymentArrangementControl1.DataClientID = id
        PaymentArrangementControl1.SettlementID = sid
       
    End Sub
End Class
