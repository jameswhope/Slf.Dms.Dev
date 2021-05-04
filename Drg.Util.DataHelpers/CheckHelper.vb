Imports Drg.Util.DataAccess

Imports System.Collections.Generic
Imports System.Configuration
Imports System.Data.SqlClient
Imports System.IO
Imports System.Xml

'** class not currently being used **

'Imports Winnovative.PdfCreator

Public Class CheckHelper

#Region "Variables"
    Private CheckXML As String
    Private UserParams As Dictionary(Of String, String)
    Private ImageURLs As List(Of String)

    Public WrittenAmountLength As Integer
#End Region

#Region "Constructors"
    Public Sub New()
        CheckXML = ""
        UserParams = New Dictionary(Of String, String)()
        ImageURLs = New List(Of String)()
    End Sub

    Public Sub New(ByVal checkID As Integer)
        CheckXML = ""
        UserParams = New Dictionary(Of String, String)()
        ImageURLs = New List(Of String)()
        WrittenAmountLength = 112

        LoadCheckXML(checkID)
    End Sub
#End Region

    Private Sub LoadCheckXML(ByVal checkID As Integer)
        Using cmd As New SqlCommand("SELECT [XML] FROM tblCheckWriterFormat WHERE CheckWriterFormatID = " & checkID, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        CheckXML = CStr(reader("XML"))

                        Using textRead As TextReader = New StringReader(CStr(reader("XML")))
                            Dim settings As New XmlReaderSettings()

                            settings.ProhibitDtd = False
                            settings.ValidationFlags = Schema.XmlSchemaValidationFlags.None

                            Using xmlRead As XmlReader = XmlReader.Create(textRead, settings)
                                While xmlRead.Read()
                                    If xmlRead.Name.ToLower() = "userparam" Then
                                        If Not UserParams.ContainsKey(xmlRead("name")) Then
                                            UserParams.Add(xmlRead("name"), GetOuterXML(CheckXML, xmlRead("name")))
                                        End If
                                    ElseIf xmlRead.Name.ToLower() = "img" Then
                                        If Not ImageURLs.Contains(xmlRead("src")) Then
                                            ImageURLs.Add(xmlRead("src"))
                                        End If
                                    End If
                                End While
                            End Using
                        End Using
                    End If
                End Using
            End Using
        End Using
    End Sub

    Public Sub ParseImages(ByVal imageDir As String)
        For Each src As String In ImageURLs
            CheckXML = CheckXML.Replace(src, Path.Combine(imageDir, src))
        Next
    End Sub

    Public Sub ParseUserParam(ByVal name As String, ByVal value As String)
        If UserParams.ContainsKey(name) Then
            CheckXML = CheckXML.Replace(UserParams(name), value)
        End If
    End Sub

    Public Sub SetCheckNumber(ByVal value As String)
        ParseUserParam("upCheckNumber", value)
    End Sub

    Public Sub SetPayee(ByVal value As String)
        ParseUserParam("upPayee", value)
    End Sub

    Public Sub SetDate(ByVal value As String)
        ParseUserParam("upDate", value)
    End Sub

    Public Sub SetMemo(ByVal value As String)
        ParseUserParam("upMemo", value)
    End Sub

    Public Sub SetAccountNumber(ByVal value As String)
        ParseUserParam("upAccountNumber", value)
    End Sub

    Public Sub SetRoutingNumber(ByVal value As String)
        ParseUserParam("upRoutingNumber", value)
    End Sub

    Public Sub SetAddress1(ByVal value As String)
        ParseUserParam("upAddress1", value)
    End Sub

    Public Sub SetAddress2(ByVal value As String)
        ParseUserParam("upAddress2", value)
    End Sub

    Public Sub SetPhoneNumber(ByVal value As String)
        ParseUserParam("upPhoneNumber", value)
    End Sub

    Public Sub SetBankName(ByVal value As String)
        ParseUserParam("upBankName", value)
    End Sub

    Public Sub SetBankLocation(ByVal value As String)
        ParseUserParam("upBankLocation", value)
    End Sub

    Public Sub SetAmount(ByVal value As Double)
        ParseUserParam("upAmount", value.ToString("N2"))

        ParseUserParam("upAmountWritten", FillLine(AmountToText(value) & " ", WrittenAmountLength))
    End Sub

    Private Function GetOuterXML(ByVal xml As String, ByVal name As String) As String
        Return "<userParam name=""" & name & """ />"
    End Function

    Public Function AmountToText(ByVal amount As Double) As String
        Dim str As String
        Dim truncatedAmount As Long = Math.Truncate(amount)
        Dim text As String = ""
        Dim largest As Long = 1

        While (largest <= Long.MaxValue / 10) And (amount / largest >= 1)
            largest = largest * 10
        End While

        largest = largest / 10

        Dim part As String

        While (largest > 10)
            part = ""

            Select Case largest
                Case 100
                    part = "hundred"
                Case 1000
                    part = "thousand"
                Case 1000000
                    part = "million"
                Case 1000000000
                    part = "billion"
                Case 1000000000000
                    part = "trillion"
                Case 1000000000000000
                    part = "quadrillion"
            End Select

            If Not String.IsNullOrEmpty(part) Then
                If Math.Truncate(truncatedAmount / largest) >= 1 Then
                    text = text & IIf(text.Length > 0, ", ", "") & NumberToWord(Math.Truncate(truncatedAmount / largest)) & " " & part
                End If

                truncatedAmount = truncatedAmount - (Math.Truncate(truncatedAmount / largest) * largest)
            End If

            largest = largest / 10
        End While

        If truncatedAmount >= 1 Then
            text = text & IIf(text.Length > 0, " ", "") & NumberToWord(truncatedAmount)
        End If

        str = IIf(text.Length > 0, text & " and ", "") & Math.Round(((amount - Math.Truncate(amount)) * 100), 0).ToString("00") & "/100"

        Return str.Substring(0, 1).ToUpper() & str.Remove(0, 1)
    End Function

    Private Function NumberToWord(ByVal number As Integer) As String
        Dim numStr As String = ""

        Select Case number
            Case 0
                numStr = ""
            Case 1
                numStr = "one"
            Case 2
                numStr = "two"
            Case 3
                numStr = "three"
            Case 4
                numStr = "four"
            Case 5
                numStr = "five"
            Case 6
                numStr = "six"
            Case 7
                numStr = "seven"
            Case 8
                numStr = "eight"
            Case 9
                numStr = "nine"
            Case 10
                numStr = "ten"
            Case 11
                numStr = "eleven"
            Case 12
                numStr = "twelve"
            Case 13
                numStr = "thirteen"
            Case 14
                numStr = "fourteen"
            Case 15
                numStr = "fifteen"
            Case 16
                numStr = "sixteen"
            Case 17
                numStr = "seventeen"
            Case 18
                numStr = "eighteen"
            Case 19
                numStr = "nineteen"
            Case Else
                Select Case number.ToString().Length
                    Case 2
                        Select Case number.ToString().Substring(0, 1)
                            Case 2
                                numStr = "twenty"
                            Case 3
                                numStr = "thirty"
                            Case 4
                                numStr = "forty"
                            Case 5
                                numStr = "fifty"
                            Case 6
                                numStr = "sixty"
                            Case 7
                                numStr = "seventy"
                            Case 8
                                numStr = "eighty"
                            Case 9
                                numStr = "ninety"
                        End Select

                        numStr = numStr & "-" & NumberToWord(CInt(number.ToString().Substring(1, 1)))
                    Case 3
                        numStr = NumberToWord(CInt(number.ToString().Substring(0, 1))) & " hundred " & NumberToWord(CInt(number.ToString().Substring(1, 2)))
                    Case Else
                        numStr = number.ToString()
                End Select
        End Select

        Return numStr
    End Function

    Private Function FillLine(ByVal str As String, ByVal length As Integer)
        Dim ret As String = str

        If length > 0 Then
            Dim ch As Char
            Dim idx As Integer

            While str.Length > length
                idx = length

                ch = str.Substring(idx, 1)

                While Not ch = " " And Not ch = "-" And idx >= 0
                    idx = idx - 1

                    ch = str.Substring(idx, 1)
                End While

                str = str.Substring(idx + 1)
            End While
        End If

        Return ret & New String("-", length - str.Length)
    End Function

#Region "Convert To PDF"
    Public Sub SavePDF(ByVal destination As String)
        'ConvertToPDF().Save(destination)
    End Sub

    Public Sub SavePDFToResponse(ByVal response As System.Web.HttpResponse, ByVal filename As String, Optional ByVal inline As Boolean = False)
        'ConvertToPDF().Save(response, inline, filename)
    End Sub

    Public Function SavePDFToStream() As Stream
        Dim s As New MemoryStream()

        'ConvertToPDF().Save(s)

        Return s
    End Function

    Public Sub SavePDFToStream(ByRef s As Stream)
        'ConvertToPDF().Save(s)
    End Sub

    'Private Function ConvertToPDF() As Document
    '    LicensingManager.LicenseKey = ConfigurationSettings.AppSettings("WinnovativePDFCreatorLic")

    '    Dim doc As New Document()

    '    doc.CompressionLevel = CompressionLevel.NoCompression
    '    doc.Margins = New Margins(0)

    '    Dim page As PdfPage = doc.Pages.AddNewPage(PageSize.A4, New Margins(10, 10, 0, 0), PageOrientation.Landscape)

    '    Dim pdfElement As New HtmlToPdfElement(-1, -1, -1, -1, CheckXML, Nothing)

    '    pdfElement.FitWidth = True
    '    pdfElement.EmbedFonts = True

    '    page.AddElement(pdfElement)

    '    Return doc
    'End Function
#End Region

#Region "Overrides"
    Public Overrides Function ToString() As String
        Return CheckXML
    End Function
#End Region

End Class