
Partial Class Clients_Enrollment_ViewPDF
	Inherits System.Web.UI.Page

	Protected Sub Clients_Enrollment_ViewPDF_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		Dim extension As String = "PDF"

		Response.ContentType = "application/pdf"

		'set the MIME type here
		'Response.AddHeader("content-disposition", "attachment; filename=LSAAgreenment." + extension)
		Response.BinaryWrite(DirectCast(Session("ViewPDF"), Byte()))


	End Sub
End Class
