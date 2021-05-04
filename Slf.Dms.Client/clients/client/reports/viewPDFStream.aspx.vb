
Partial Class reports_viewPDFStream
    Inherits System.Web.UI.Page
    Private pdfType As String

    Protected Sub reports_viewPDFStream_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim extension As String = "PDF"
        Response.ContentType = "application/pdf"

        pdfType = Request.QueryString("type")

        Select Case pdfType.ToLower
            Case "statement"
                If Not IsNothing(Session("statement")) Then
                    Response.BinaryWrite(DirectCast(Session("statement"), Byte()))
                End If

            Case Else
                If Not IsNothing(Session("viewPDFStream")) Then
                    Response.BinaryWrite(DirectCast(Session("viewPDFStream"), Byte()))
                End If
        End Select


    End Sub
End Class
