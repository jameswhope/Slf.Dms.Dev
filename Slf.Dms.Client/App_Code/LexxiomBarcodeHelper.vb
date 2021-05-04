Imports System.Drawing
Imports iTextSharp.text.pdf
Imports iTextSharp.text
Imports System.IO

Public Class LexxiomBarcodeHelper
#Region "itextsharp Barcodes"
    Public Enum barcodeOrientation
        enumHorizontal = 0
        enumVertical = 1
    End Enum
    Public Shared Function buildbarcodeImageFile(ByVal barValue As String, ByVal PathToSaveImageTo As String) As String

        Dim mem As MemoryStream = buildbarcodeImage(barValue)
        Dim img As Drawing.Image = Drawing.Image.FromStream(mem)
        Dim imgPath As String = String.Format("{0}\{1}.png", PathToSaveImageTo, Format(Now, "yyyyMMdd_hhss"))
        img.Save(imgPath, Drawing.Imaging.ImageFormat.Png)
        Return imgPath
    End Function
    Public Shared Function buildbarcodeImage(ByVal barValue As String, Optional ByVal barOrientation As barcodeOrientation = barcodeOrientation.enumHorizontal) As MemoryStream
        Dim stream As New MemoryStream
        Dim doc As New iTextSharp.text.Document(iTextSharp.text.PageSize.A4, 50, 50, 50, 50)
        Dim writer As PdfWriter = PdfWriter.GetInstance(doc, stream)

        doc.Open()
        Dim cb As PdfContentByte = writer.DirectContent
        Dim bc As New Barcode128
        bc.Code = barValue
        bc.CodeType = Barcode.CODE128_UCC
        bc.ChecksumText = True
        bc.StartStopText = True
        bc.GenerateChecksum = True
        bc.Font = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED)
        bc.TextAlignment = Element.ALIGN_CENTER

        Dim mem As New MemoryStream
        Dim imgBC As Drawing.Image = bc.CreateDrawingImage(System.Drawing.Color.Black, System.Drawing.Color.White)
        If barOrientation = barcodeOrientation.enumVertical Then
            imgBC.RotateFlip(RotateFlipType.Rotate90FlipNone)
        End If

        imgBC.Save(mem, Imaging.ImageFormat.Png)
        Return mem

    End Function
    Public Shared Function extractBarcodes(ByVal aPath As String) As System.Collections.ArrayList
        Dim barcodes As New System.Collections.ArrayList
        Dim dtStart As DateTime = DateTime.Now
        Dim iScans As Integer = 100
        Dim img As Drawing.Image = Drawing.Image.FromFile(aPath.ToString)
        'BarcodeScanner.ScanPage(barcodes, CType(img, Bitmap), iScans, BarcodeScanner.ScanDirection.Horizontal, BarcodeScanner.BarcodeType.Code128)
        BarcodeScanner.FullScanPage(barcodes, CType(img, Bitmap), iScans, BarcodeScanner.BarcodeType.Code128)
        Return barcodes
    End Function
    Public Shared Function RemoveInvalidCharactersFromBarcode(ByVal bCode As String) As String
        Dim decodeString As String = String.Empty
        For i As Integer = 0 To bCode.Length - 1
            If AscW(bCode(i)) >= 32 AndAlso AscW(bCode(i)) < 127 Then
                decodeString &= bCode(i)
            End If
        Next
        Return decodeString
    End Function
#End Region
End Class