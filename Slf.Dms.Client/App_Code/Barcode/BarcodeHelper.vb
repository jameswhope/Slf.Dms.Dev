Imports Microsoft.VisualBasic
Imports System
Imports System.Configuration
Imports TechnoRiver.SmartCodeWeb
Imports Vintasoft.Barcode
Imports Vintasoft.Barcode.BarcodeInfo
Imports Vintasoft.Pdf
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports AttachSifHelper
Imports Drg.Util.DataHelpers
Imports Drg.Util.DataAccess
Imports System.Drawing
Imports iTextSharp.text.pdf
Imports iTextSharp.text

Public Class BarcodeHelper

#Region "Variables"
    Private ClientAcctNo As Integer
    Private DocumentType As Integer
    Private DocumentID As String
    Private Path As String
#End Region

#Region "Write Methods"
    ''' <summary>
    ''' Creates a barcode using Vintasoft barcode SDK
    ''' </summary>
    ''' <param name="NewDocFileName">Document ID</param>
    ''' <param name="OldDocPath">Path to the OldDocument</param>
    ''' <param name="NewDocPath">Path to the NewDocument</param>
    ''' <param name="DocType">Doc Type</param>
    ''' <param name="ServerPath">ServerPath</param>
    ''' <param name="X">Optional X location of barcode image</param>
    ''' <param name="Y">Optional Y location of barcode image</param>
    ''' <remarks>The barcode image will be created and applied to the document</remarks>
    Public Function CreateVintaBarcode(ByVal NewDocFileName As String, ByVal OldDocPath As String, ByVal NewDocPath As String, ByVal DocType As String, ByVal ServerPath As String, ByVal SessionID As String, Optional ByVal X As Integer = 0, Optional ByVal Y As Integer = 0) As String

        ' create the barcode writer
        Dim barcodeWriter As New BarcodeWriter()
        ' using DataMatrix 2D barcode
        barcodeWriter.Settings.Barcode = BarcodeType.PDF417
        ' barcode padding
        Dim padding As Single = 5

        '' open PDF document
        'Dim document As New PdfDocument(pdfFilename)
        '' foreach pages
        'For i As Integer = 0 To document.Pages.Count - 1
        '    Dim page As PdfPage = document.Pages(i)
        '    ' barcode value - page number
        '    barcodeWriter.Settings.Value = (i + 1).ToString()
        '    ' write barcode graphics path
        '    Dim barcodePath As GraphicsPath = barcodeWriter.GetBarcodeAsGraphicsPath()
        '    ' translate barcode to right-bottom page corner
        '    Using m As New Matrix()
        '        Dim barcodeWidth As Single = barcodePath.GetBounds().Width
        '        m.Translate(page.MediaBox.Right - barcodeWidth - padding, padding)
        '        barcodePath.Transform(m)
        '    End Using
        '    ' fill barcode path
        '    Using g As PdfGraphics = page.GetGraphics()
        '        Dim brush As New PdfBrush(Color.Black)
        '        g.FillPath(brush, barcodePath)
        '    End Using
        '    barcodePath.Dispose()
        'Next

        '' save PDF document
        'Dim resultFileName As String = Path.GetFileNameWithoutExtension(pdfFilename) & "_marked.pdf"
        'document.Save(Path.Combine(Path.GetDirectoryName(pdfFilename), resultFileName))
        ' free resources
        'document.Dispose()


        'Dim barcodeWriter As New BarcodeWriter

        'With barcodeWriter.Settings
        '    .Barcode = BarcodeType.Code39
        '    .Value = NewDocFileName
        '    .Value.Trim()
        '    If .Value = String.Empty Then
        '        Return "No document name."
        '    End If
        '    ' Background and foreground color of barcode
        '    Dim flagColorImage1 As Boolean = False
        '    Dim flagColorImage2 As Boolean = False
        '    barcodeWriter.Settings.BackColor = GetColor("White", flagColorImage1)
        '    barcodeWriter.Settings.ForeColor = GetColor("Black", flagColorImage2)
        '    If flagColorImage1 Or flagColorImage2 Then
        '        barcodeWriter.Settings.PixelFormat = Imaging.PixelFormat.Format24bppRgb
        '    End If
        '    ' Barcode height
        '    Dim str As String
        '    str = "50"
        '    Dim barcodeHeight As Integer = GetIntegerValue(str, 100, 1, 1000)
        '    .Height = barcodeHeight
        '    ' Barcode padding
        '    str = "1"
        '    .Padding = GetIntegerValue(str, 1, 1, 100)
        '    ' Minimal value of bar cell width
        '    str = ".5"
        '    .MinWidth = GetIntegerValue(str, 3, 1, 20)
        '    'Set the height and width of the barcode
        '    .SetWidth(2.25, UnitOfMeasure.Inches)
        '    .SetHeight(0.65, UnitOfMeasure.Inches)
        '    ' Settings of barcode text
        '    .ValueVisible = True
        '    ' Font of barcode text
        '    str = "10"
        '    Dim textFontSize As Integer = GetIntegerValue(str, 12, 1, 40)
        '    .ValueFont = New System.Drawing.Font("Arial", textFontSize, FontStyle.Regular, GraphicsUnit.Pixel)
        '    ' Gap of barcode text
        '    str = "0"
        '    .ValueGap = GetIntegerValue(str, 0, -40, 40)
        '    ' Auto letter spacing
        '    .ValueAutoLetterSpacing = GetBooleanValue("Yes")
        '    .ValueVisible = False
        '    ' Optional checksum for Code 39 barcodes
        '    .OptionalCheckSum = GetBooleanValue("Yes")
        '    ' Use extended encode table (Code 39)
        '    .UseCode39ExtendedEncodeTable = GetBooleanValue("Yes")
        '    ' Enable numeric mode (Telepen)
        '    .EnableTelepenNumericMode = GetBooleanValue("No")
        '    ' Segments per row (RSS Expanded Stacked)
        '    str = "4"
        '    .RSSExpandedStackedSegmentPerRow = GetIntegerValue(str, 4, 2, 20)
        '    ' Omnidirectional compatible (RSS-14 Stacked)
        '    .RSS14StackedOmnidirectional = GetBooleanValue("No")
        'End With

        'Dim imageWithBarcode As System.Drawing.Image = Nothing
        'Try
        '    imageWithBarcode = barcodeWriter.GetBarcodeAsBitmap()
        'Catch ex As Exception
        '    'labelWriteBarcodeResult.ForeColor = Color.Red
        '    'labelWriteBarcodeResult.Text = ex.Message
        '    Return ""
        'End Try

        '' Rotate the image with barcode if necessary
        'Select Case DocType
        '    Case "D006"
        '        imageWithBarcode.RotateFlip(RotateFlipType.Rotate270FlipNone)
        '        Exit Select
        '    Case Else
        '        imageWithBarcode.RotateFlip(RotateFlipType.RotateNoneFlipNone)
        'End Select

        '' Save the barcode to the disk on the server
        'Dim fileName As String = Nothing
        'Dim filePath As String = Nothing
        'fileName = "Barcode-" + SessionID & ".png"
        'filePath = ServerPath + fileName
        'Try
        '    imageWithBarcode.Save(filePath)
        'Catch ex As Exception
        '    'labelWriteBarcodeResult.ForeColor = Color.Red
        '    'labelWriteBarcodeResult.Text = "<br />You do not have writing access to path """ & filePath & """."
        '    Return ""
        'End Try

        'Return filePath

    End Function

    ''' <summary>
    ''' Creates and applies Barcode to document using TechnoRiver SDK
    ''' </summary>
    ''' <param name="NewDocFileName">Document ID</param>
    ''' <param name="OldDocPath">Path to the OldDocument</param>
    ''' <param name="NewDocPath">Path to the NewDocument</param>
    ''' <param name="DocType">Doc Type</param>
    ''' <param name="ServerPath">ServerPath</param>
    ''' <param name="X">Optional X location of barcode image</param>
    ''' <param name="Y">Optional Y location of barcode image</param>
    ''' <remarks>The barcode image will be created and applied to the document</remarks>
    Public Function CreateTechnoBarcode(ByVal NewDocFileName As String, ByVal OldDocPath As String, ByVal NewDocPath As String, ByVal DocType As String, ByVal ServerPath As String, Optional ByVal X As Integer = 0, Optional ByVal Y As Integer = 0) As String
        Dim sc As TechnoRiver.SmartCodeWeb.SmartCodeWebControl = New TechnoRiver.SmartCodeWeb.SmartCodeWebControl()
        Dim it As iTextSharp.text.Image = Nothing
        sc.BarcodeImageDirectory = "Images/barcodeimages"
        sc.Symbology = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeSymbology.CODE39ASCII

        'This is the NewDocName
        sc.BarcodeData = NewDocFileName

        'Barcode rotation based on document type and be None, 90, 180 or 270
        Select Case DocType
            Case "D006"
                sc.Rotation = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeRotation.Rotate270
            Case Else
                sc.Rotation = SmartCodeWebControl.BarcodeRotation.None
        End Select

        sc.DisplayText = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeDisplayText.No
        sc.TextAlignment = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeTextAlignment.Left
        sc.TextPlacement = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeTextPlacement.Bottom
        sc.DisplayCheckBar = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeDisplayCheckBar.Yes
        sc.DisplayCheckDigitText = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeDisplayCheckDigitText.No
        sc.ImageType = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeImageType.PNG
        sc.BarRatio = 3.0

        'keep the ratio of aprox 3 1/2 to 1 width to height just looks better.
        sc.BarcodeWidthInch = 2.25
        sc.BarcodeHeightInch = 0.65

        sc.NarrowBarWidth = "75"

        sc.CodabarStartCharacter = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeCodabarStartCharacter.B
        sc.CodabarStopCharacter = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeCodabarStopCharacter.B
        sc.DisplayStartStopCharacter = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeDisplayStartStopCharacter.No

        sc.SaveImage()

        Return sc.BarcodeVirtualFileName

    End Function

    ''' <summary>
    ''' Gets a barcode from the web service - BarcodeService using TechnoRiver SDK
    ''' </summary>
    ''' <param name="FullPath">the full path to the source pdf</param>
    ''' <param name="DocName">the document name including type</param>
    ''' <remarks>The barcode image will be created by the service and returned as a Byte array</remarks>
    Public Function GetBarcodeFromService(ByVal fullPath As String, ByVal DocName As String) As Byte()
        Dim bc As New BarcodeService
        Dim barcode As Byte() = bc.CreateBarCode(fullPath, "Left")
        Dim ms As New System.IO.MemoryStream(barcode)
        Return barcode
    End Function

#End Region

#Region "Read Methods"

    ''' <summary>
    ''' Reads a barcode from a PDF document using Vintasoft SDK
    ''' </summary>
    ''' <param name="DocPath">the full path to the source pdf</param>
    ''' <returns>Returns the results</returns>
    ''' <remarks>The barcode image is searched for and read from each page</remarks>
    Public Function ReadBarcodes(ByVal DocPath As String) As String
        Dim infos2 As IBarcodeInfo()
        'For the return trip create a string builder
        Dim resultString As StringBuilder = Nothing
        'Open the PDF document
        Dim pdfImageViewer As New PdfImageViewer(DocPath)
        ' Create a BarcodeReader object
        Dim barcodeReader As New BarcodeReader()
        ' Code 39, EAN, PDF417, DataMatrix and QR barcodes are extracted
        barcodeReader.Settings.ScanBarcodeTypes = BarcodeType.PDF417 Or BarcodeType.PDF417Compact
        barcodeReader.Settings.ScanDirection = ScanDirection.TopToBottom Or ScanDirection.LeftToRight Or ScanDirection.TopToBottom Or ScanDirection.BottomToTop
        barcodeReader.Settings.ScanInterval = 5

        For i As Integer = 0 To pdfImageViewer.PageCount - 1
            'get an array of names of image resources from page i
            Dim imageNames As String() = pdfImageViewer.GetImageNames(i)
            'for each image resource on page i
            For k As Integer = 0 To imageNames.Length - 1
                Dim imageWithBarcode As System.Drawing.Image
                'get image of image resource
                Try
                    imageWithBarcode = pdfImageViewer.GetImage(i, imageNames(k))
                    ' read barcodes
                    infos2 = barcodeReader.ReadBarcodes(imageWithBarcode)
                Catch e As Exception
                    'not supported image format
                    Continue For
                End Try

                ' Show results
                resultString = New StringBuilder("Barcodes read time: " + barcodeReader.RecognizeTime.TotalSeconds.ToString("0.000") & " seconds." & Environment.NewLine)
            Next k
            If infos2.Length = 0 Then
                resultString.Append("Barcodes are not detected." & Environment.NewLine)
            Else
                resultString.Append(infos2.Length.ToString() + " codes detected:" & Environment.NewLine & Environment.NewLine)
                For j As Integer = 0 To infos2.Length - 1
                    Dim info As IBarcodeInfo = infos2(i)
                    Dim confidence As String
                    If info.Confidence <> ReaderSettings.ConfidenceNotAviable Then
                        confidence = info.Confidence.ToString()
                    Else
                        confidence = "N/A (no checksum)"
                    End If
                    resultString.Append(String.Format("{0}: [{1}]" & Environment.NewLine, i + 1, info.BarcodeType))
                    resultString.Append(String.Format("   Value           : {0}" & Environment.NewLine, info.Value))
                    resultString.Append(String.Format("   Confidence      : {0}" & Environment.NewLine, confidence))
                    resultString.Append(String.Format("   Reading Quality : {0}" & Environment.NewLine, info.ReadingQuality.ToString("F3")))
                    resultString.Append(String.Format("   Bound rectangle : {0}" & Environment.NewLine, info.Region.Rectangle))
                    resultString.Append(String.Format("   Rotation Angle  : {0}°" & Environment.NewLine, info.Region.Angle.ToString("F3")))
                    resultString.Append(Environment.NewLine)
                Next j
            End If
        Next i
        pdfImageViewer.Dispose()
        Return resultString.ToString
    End Function

#End Region

#Region "Utils"

    ''' <summary>
    ''' Get color utiliity used with the Vintasoft SDK
    ''' </summary>
    ''' <param name="text">The color desired</param>
    ''' <param name="flagColorImage">Returns a flag of True if the color is set or False if not</param>
    ''' <returns>Returns the results as System.Drawing.Color</returns>
    Public Function GetColor(ByVal text As String, ByRef flagColorImage As Boolean) As System.Drawing.Color
        GetColor = System.Drawing.Color.White
        flagColorImage = False
        Select Case text
            Case "Black"
                GetColor = System.Drawing.Color.Black
            Case "Red"
                GetColor = System.Drawing.Color.Red
                flagColorImage = True
            Case "Green"
                GetColor = System.Drawing.Color.Green
                flagColorImage = True
            Case "Blue"
                GetColor = System.Drawing.Color.Blue
                flagColorImage = True
            Case "Yellow"
                GetColor = System.Drawing.Color.Yellow
                flagColorImage = True
        End Select
    End Function

    ''' <summary>
    ''' Returns an integer value from a string used with Vintasoft SDK
    ''' </summary>
    ''' <param name="text"></param>
    ''' <param name="defaultValue"></param>
    ''' <param name="minValue"></param>
    ''' <param name="maxValue"></param>
    ''' <returns>Returns an integer value from a string</returns>
    ''' <remarks></remarks>
    Public Function GetIntegerValue(ByRef text As String, ByVal defaultValue As Integer, ByVal minValue As Integer, ByVal maxValue As Integer) As Integer
        Dim value As Integer = defaultValue
        If Not Int32.TryParse(text, value) Then
            text = defaultValue.ToString
            value = defaultValue
        End If
        If value < minValue Or value > maxValue Then
            text = defaultValue.ToString
            value = defaultValue
        End If
        GetIntegerValue = value
    End Function

    ''' <summary>
    ''' Used with Vintasoft SDK
    ''' </summary>
    ''' <param name="text"></param>
    ''' <returns></returns>
    ''' <remarks>Returns a boolean value from Yes or No</remarks>
    Public Function GetBooleanValue(ByVal text As String) As Boolean
        GetBooleanValue = False
        If text = "Yes" Then
            GetBooleanValue = True
        End If
    End Function

#End Region

End Class
