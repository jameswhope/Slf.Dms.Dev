Imports System.Drawing
Imports System.Net
Imports System.IO

Partial Class image_tn
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim fullSizeImg As Image
        Dim imgPath As String = System.Configuration.ConfigurationManager.AppSettings("C21ImageVirtualPath") & "NoAccountNumber\" & Request.QueryString("f")
        Dim maxHeight As Integer = CType(Request.QueryString("h"), Integer)
        Dim req As HttpWebRequest = WebRequest.Create(imgPath)
        Dim resp As HttpWebResponse
        Dim respstream As IO.Stream

        Try
            resp = req.GetResponse
            respstream = resp.GetResponseStream
            fullSizeImg = Image.FromStream(respstream)

            Dim fmt As Imaging.ImageFormat = fullSizeImg.RawFormat
            Dim io As New MemoryStream

            If fullSizeImg.Height > maxHeight Then
                Dim dummyCallBack As Image.GetThumbnailImageAbort
                Dim thumbNailImg As Image
                Dim newWidth As Integer
                Dim newHeight As Integer
                Dim scalePct As Double

                'rescale based on width
                scalePct = maxHeight / fullSizeImg.Height
                newWidth = fullSizeImg.Width * scalePct
                newHeight = fullSizeImg.Height * scalePct

                dummyCallBack = New Image.GetThumbnailImageAbort(AddressOf ThumbnailCallback)
                thumbNailImg = fullSizeImg.GetThumbnailImage(newWidth, newHeight, dummyCallBack, IntPtr.Zero)
                thumbNailImg.Save(io, fmt)
                thumbNailImg.Dispose()
            Else
                fullSizeImg.Save(io, fmt)
            End If

            Dim buffer As Byte() = io.GetBuffer
            Response.BinaryWrite(buffer)
        Catch ex As Exception
            'do nothing, image just wont display
        Finally
            If Not IsNothing(fullSizeImg) Then
                fullSizeImg.Dispose()
            End If
        End Try
    End Sub

    Function ThumbnailCallback() As Boolean
        Return False
    End Function

End Class
