
Partial Class side_notesholder
    Inherits System.Web.UI.Page
    Public QueryString As String


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        QueryString = Request.QueryString.ToString()
        Session("Notes_LastURL") = Request.Url.AbsoluteUri
        Session("Comms_LastPage") = "side_notesholder"
        Session("Comms_LastQS") = Request.QueryString.ToString()
        Session("Comms_IsOpen") = True
    End Sub
End Class
