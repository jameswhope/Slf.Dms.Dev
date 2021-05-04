
Imports System.Drawing
Imports System.Drawing.Drawing2D
Imports System.Drawing.Imaging

Partial Class public_mySignatureTyped
    Inherits System.Web.UI.Page

    Dim tmp1 As String = ""
    Dim tmp2 As String = ""
    Dim pcolor As String = ""
    Dim pwidth As String = ""
    Dim bgcolor As String = ""
    Dim signaturefile As String = ""
    Dim cWidth As String = ""
    Dim cHeight As String = ""
    Dim sSavePath As String = ""
    Dim signature As String = ""
    Public _type As String
    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs)

    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _type = Request.QueryString("t")
    End Sub

    'Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
    '    Try
    '        tmp1 = l_x.Value
    '        tmp2 = l_y.Value
    '        pwidth = l_Width.Value
    '        pcolor = l_Color.Value
    '        bgcolor = l_BGColor.Value
    '        signaturefile = l_File.Value
    '        cWidth = l_CanvasW.Value
    '        cHeight = l_CanvasH.Value
    '        sSavePath = Convert.ToString(l_SavePath.Value).Replace("_", "/")
    '    Catch generatedExceptionName As Exception
    '        Response.Redirect(Page.ResolveUrl("~/"))
    '    End Try

    '    GenerateImage()
    'End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Try

            signature = tbSignature.Text
            pwidth = l_Width.Value
            pcolor = l_Color.Value
            bgcolor = l_BGColor.Value
            signaturefile = l_File.Value
            cWidth = l_CanvasW.Value
            cHeight = l_CanvasH.Value
            sSavePath = Convert.ToString(l_SavePath.Value).Replace("_", "/")

            CreateBitmapImage(signature)

        Catch ex As Exception
            Response.Redirect(Page.ResolveUrl("~/"))
        End Try

    End Sub

    Private Sub CreateBitmapImage(sImageText As String)
        Dim objBmpImage As New Bitmap(1, 1)

        Dim intWidth As Integer = 0
        Dim intHeight As Integer = 0

        ' Create the Font object for the image text drawing.
        Dim objFont As New Font("La Belle Aurore", 30, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Pixel)

        ' Create a graphics object to measure the text's width and height.
        Dim objGraphics As Graphics = Graphics.FromImage(objBmpImage)

        ' This is where the bitmap size is determined.
        intWidth = CInt(objGraphics.MeasureString(sImageText, objFont).Width)
        intHeight = CInt(objGraphics.MeasureString(sImageText, objFont).Height)

        ' Create the bmpImage again with the correct size for the text and font.
        objBmpImage = New Bitmap(objBmpImage, New Size(intWidth, intHeight))

        ' Add the colors to the new bitmap.
        objGraphics = Graphics.FromImage(objBmpImage)

        ' Set Background color
        objGraphics.Clear(Color.White)
        objGraphics.SmoothingMode = Drawing2D.SmoothingMode.AntiAlias
        objGraphics.TextRenderingHint = Text.TextRenderingHint.AntiAlias
        objGraphics.DrawString(sImageText, objFont, New SolidBrush(Color.FromArgb(102, 102, 102)), 0, 0)
        objGraphics.Flush()

        Dim formatExt As String = signaturefile.Split("."c)(1)

        Try
            Dim imgFormat As ImageFormat = ParseImageFormat(formatExt)
            Dim outPath As String = (Server.MapPath(sSavePath) & "\temp\") + signaturefile

            objBmpImage.Save(outPath, imgFormat)

            'If Color.FromName(bgcolor) = Color.White AndAlso imgFormat.Equals(ImageFormat.Gif) Then
            '    MakeTransparent(outPath)
            'End If

            'Response.ContentType = "image/" & formatExt
            'objBmpImage.Save(Response.OutputStream, imgFormat)

            '' dispose bitmap object 
            'objBmpImage.Dispose()
            'Response.[End]()
        Catch ex As Exception
            Dim err As String = ex.Message.ToString()
            Response.Write(err)
            'isErr = True
        End Try

    End Sub

    'Private Sub GenerateImage()
    '    Response.Clear()
    '    Dim arrX As String() = tmp1.Split(","c)
    '    Dim arrY As String() = tmp2.Split(","c)

    '    Dim CurrX As Integer = 0
    '    Dim CurrY As Integer = 0

    '    Dim NextX As Integer = 0
    '    Dim NextY As Integer = 0

    '    Dim currCount As Integer = 0

    '    Dim isErr As Boolean = False

    '    Dim bmp As New Bitmap(Convert.ToInt32(cWidth), Convert.ToInt32(cHeight), PixelFormat.Format24bppRgb)
    '    Dim g As Graphics = Nothing

    '    Try
    '        g = Graphics.FromImage(bmp)

    '        g.FillRectangle(New SolidBrush(Color.FromName(bgcolor)), 0, 0, bmp.Width, bmp.Height)

    '        Dim pn As New Pen(New SolidBrush(Color.FromName(pcolor)), Convert.ToInt32(pwidth))

    '        For i As Integer = 0 To arrX.Length - 4

    '            If IsNumeric(arrX(i), arrY(i), arrX(i + 1), arrY(i + 1)) Then
    '                CurrX = Convert.ToInt32(arrX(i))
    '                CurrY = Convert.ToInt32(arrY(i))

    '                currCount = i

    '                NextX = Convert.ToInt32(arrX(i + 1))
    '                NextY = Convert.ToInt32(arrY(i + 1))

    '                g.DrawLine(pn, CurrX, CurrY, NextX, NextY)
    '            End If

    '        Next
    '    Catch ex As Exception
    '        Dim err As String = ex.Message.ToString()
    '        isErr = True
    '    Finally
    '        If g IsNot Nothing Then
    '            g.Dispose()
    '        End If
    '    End Try

    '    Dim formatExt As String = signaturefile.Split("."c)(1)

    '    Try
    '        Dim imgFormat As ImageFormat = ParseImageFormat(formatExt)
    '        Dim outPath As String = (Server.MapPath(sSavePath) & "\temp\") + signaturefile

    '        bmp.Save(outPath, imgFormat)

    '        'If Color.FromName(bgcolor) = Color.White AndAlso imgFormat = ImageFormat.Gif Then
    '        '    MakeTransparent(outPath)
    '        'End If

    '        'Response.ContentType = "image/" & formatExt
    '        'bmp.Save(Response.OutputStream, imgFormat)

    '        ' dispose bitmap object 
    '        bmp.Dispose()
    '        'Response.[End]()
    '    Catch ex As Exception
    '        Dim err As String = ex.Message.ToString()
    '        Response.Write(err)
    '        isErr = True

    '    End Try
    'End Sub

    Private Function MakeTransparent(ByVal outPath As String) As Bitmap
        Dim bmpIn As New Bitmap(outPath)

        Try
            Dim mImageAttributes As New ImageAttributes()
            mImageAttributes.SetColorKey(bmpIn.GetPixel(0, 0), bmpIn.GetPixel(0, 0))
            Dim dstRect As New Rectangle(0, 0, bmpIn.Width, bmpIn.Height)

            Dim bmnew As New Bitmap(bmpIn.Width, bmpIn.Height)
            Dim g As Graphics = Graphics.FromImage(bmnew)
            g.DrawImage(bmpIn, dstRect, 0, 0, bmpIn.Width, bmpIn.Height, _
            GraphicsUnit.Pixel, mImageAttributes)

            bmpIn.Dispose()
            System.IO.File.Delete(outPath)
            bmnew.Save(outPath)
            Return bmnew
        Catch ex As Exception
            Dim transErr As String = ex.Message.ToString()
        End Try
        Return bmpIn
    End Function

    Private Function IsNumeric(ByVal str1 As String, ByVal str2 As String, ByVal str3 As String, ByVal str4 As String) As Boolean
        Try
            Dim i As Integer = Convert.ToInt32(str1)
            i = Convert.ToInt32(str2)
            i = Convert.ToInt32(str3)
            i = Convert.ToInt32(str4)
            Return True
        Catch
            Return False
        End Try
    End Function

    Private Function ParseImageFormat(ByVal format As String) As ImageFormat
        Select Case format.ToLower()
            Case "jpg"
                Return ImageFormat.Jpeg
            Case "jpeg"
                Return ImageFormat.Jpeg
            Case "bmp"
                Return ImageFormat.Bmp
            Case "gif"
                Return ImageFormat.Gif
            Case "png"
                Return ImageFormat.Png
            Case "tiff"
                Return ImageFormat.Tiff
            Case "wmf"
                Return ImageFormat.Wmf
            Case "emf"
                Return ImageFormat.Emf
            Case "icon"
                Return ImageFormat.Icon
            Case "ico"
                Return ImageFormat.Icon
            Case "exif"
                Return ImageFormat.Exif
            Case Else
                Return ImageFormat.Jpeg

        End Select
    End Function
End Class
