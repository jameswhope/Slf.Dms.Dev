
Partial Class side_commsholder
    Inherits System.Web.UI.Page
    Public QueryString As String


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        QueryString = Request.QueryString.ToString()
        Session("Comms_LastURL") = Request.Url.AbsoluteUri
        Session("Comms_LastPage") = "side_commsholder"
        Session("Comms_LastQS") = Request.QueryString.ToString()
        Session("Comms_IsOpen") = True
    End Sub
End Class
