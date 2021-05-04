
Partial Class side_noteholder
    Inherits System.Web.UI.Page
    Public QueryString As String


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        QueryString = Request.QueryString.ToString()
        Session("Comms_LastPage") = "side_phonecallsholder"
        Session("Comms_IsOpen") = False
    End Sub
End Class
