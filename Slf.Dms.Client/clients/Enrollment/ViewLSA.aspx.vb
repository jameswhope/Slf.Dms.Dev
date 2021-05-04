
Partial Class Clients_Enrollment_ViewLSA
    Inherits System.Web.UI.Page
	Private pdfType As String

    Protected Sub Clients_Enrollment_ViewLSA_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		Dim extension As String = "PDF"
		Response.ContentType = "application/pdf"

		pdfType = Request.QueryString("type")

		Select Case pdfType.ToLower
			Case "lsa"
				Response.BinaryWrite(DirectCast(Session("LSAAgreement"), Byte()))
			Case "info"
				Response.BinaryWrite(DirectCast(Session("InfoSheet"), Byte()))
		End Select


    End Sub
End Class
