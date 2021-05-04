Imports Drg.Util.DataAccess


Partial Class Test_Test
    Inherits System.Web.UI.Page
    Dim UserID As Integer

    Dim DataclientID As Integer
    Dim CreditorId As Integer

    Protected Sub Test_Test_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'get current userid and store in session
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If

        If Request.QueryString("cid") IsNot Nothing Then
            DataclientID = Request.QueryString("cid")
        End If

        If Request.QueryString("crid") IsNot Nothing Then
            creditorID = Request.QueryString("crid")
        End If

        If Not IsPostBack Then

            'retrieve client and creditor accountid from url
            creditorID = Request.QueryString("crid")
            DataclientID = Request.QueryString("cid")

            'payment calculator control
            PaymentArrangementCalculator.DataClientID = DataclientID
            PaymentArrangementCalculator.AccountID = creditorID
            'PaymentArrangementCalculator.ViewInfoBlock(True)
            PaymentArrangementCalculator.Show()

        End If
    End Sub
End Class
