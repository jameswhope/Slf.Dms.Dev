Imports System.Data
Imports System.Collections.Generic

Public Class PdfManipulation

    ''' <summary>
    ''' Extract the text from pdf pages and return it as a string
    ''' </summary>
    ''' <param name="sourcePDF">Full path to the source pdf file</param>
    ''' <param name="fromPageNum">[Optional] the page number (inclusive) to start text extraction </param>
    ''' <param name="toPageNum">[Optional] the page number (inclusive) to stop text extraction</param>
    ''' <returns>A string containing the text extracted from the specified pages</returns>
    ''' <remarks>If fromPageNum is not specified, text extraction will start from page 1. If
    ''' toPageNum is not specified, text extraction will end at the last page of the source pdf file.</remarks>
    Public Shared Function ParsePdfText(ByVal sourcePDF As String, _
                                  Optional ByVal fromPageNum As Integer = 0, _
                                  Optional ByVal toPageNum As Integer = 0) As String

        Dim sb As New System.Text.StringBuilder()
        Try
            Dim reader As New iTextSharp.text.pdf.PdfReader(sourcePDF)
            Dim pageBytes() As Byte = Nothing
            Dim token As iTextSharp.text.pdf.PRTokeniser = Nothing
            Dim tknType As Integer = -1
            Dim tknValue As String = String.Empty

            If fromPageNum = 0 Then
                fromPageNum = 1
            End If
            If toPageNum = 0 Then
                toPageNum = reader.NumberOfPages
            End If

            If fromPageNum > toPageNum Then
                Throw New ApplicationException("Parameter error: The value of fromPageNum can " & _
                                           "not be larger than the value of toPageNum")
            End If

            For i As Integer = fromPageNum To toPageNum Step 1
                pageBytes = reader.GetPageContent(i)
                If Not IsNothing(pageBytes) Then
                    token = New iTextSharp.text.pdf.PRTokeniser(pageBytes)
                    While token.NextToken()
                        tknType = token.TokenType()
                        tknValue = token.StringValue
                        If tknType = iTextSharp.text.pdf.PRTokeniser.TK_STRING Then
                            sb.Append(token.StringValue)
                            'I need to add these additional tests to properly add whitespace to the output string
                        ElseIf tknType = 1 AndAlso tknValue = "-600" Then
                            sb.Append(" ")
                        ElseIf tknType = 10 AndAlso tknValue = "TJ" Then
                            sb.Append(" ")
                        End If
                    End While
                End If
            Next i
        Catch ex As Exception
            Throw
            Return String.Empty
        End Try
        Return sb.ToString()
    End Function

    ''' <summary>
    ''' Textually compare 2 pdf files page by page and write the difference to a text file.
    ''' </summary>
    ''' <param name="pdf1">the full path to 1st pdf file</param>
    ''' <param name="pdf2">the full path to 2nd pdf file</param>
    ''' <param name="resultFile">the full path to the result file</param>
    ''' <param name="fromPageNum">page number to start comparing</param>
    ''' <param name="toPageNum">page number to stop comparing</param>
    ''' <remarks>If no values are specified for fromPageNum and toPageNum, the sub will
    ''' compare every page in the input pdfs.</remarks>
    Public Shared Sub ComparePdfs(ByVal pdf1 As String, ByVal pdf2 As String, _
                                  ByVal resultFile As String, _
                                  Optional ByVal fromPageNum As Integer = 0, _
                                  Optional ByVal toPageNum As Integer = 0)
        Try
            'For pdf1
            Dim reader1 As New iTextSharp.text.pdf.PdfReader(pdf1)
            Dim pageCount1 As Integer = reader1.NumberOfPages
            Dim pageBytes1() As Byte = Nothing
            Dim token1 As iTextSharp.text.pdf.PRTokeniser = Nothing
            Dim tknType1 As Integer = -1
            Dim tknValue1 As String = String.Empty

            'For pdf2
            Dim reader2 As New iTextSharp.text.pdf.PdfReader(pdf2)
            Dim pageCount2 As Integer = reader2.NumberOfPages
            Dim pageBytes2() As Byte = Nothing
            Dim token2 As iTextSharp.text.pdf.PRTokeniser = Nothing
            Dim tknType2 As Integer = -1
            Dim tknValue2 As String = String.Empty

            If fromPageNum = 0 Then
                fromPageNum = 1
            End If

            If toPageNum = 0 Then
                toPageNum = Math.Min(pageCount1, pageCount2)
            Else
                If toPageNum > pageCount1 OrElse toPageNum > pageCount2 Then
                    toPageNum = Math.Min(pageCount1, pageCount2)
                End If
            End If

            If fromPageNum > toPageNum Then
                Throw New ApplicationException("Parameter error: The value of fromPageNum can " & _
                                           "not be larger than the value of toPageNum")
            End If

            Dim writer As New System.IO.StreamWriter(resultFile)
            For i As Integer = fromPageNum To toPageNum Step 1
                writer.WriteLine("Differences found in page " & i)
                pageBytes1 = reader1.GetPageContent(i)
                pageBytes2 = reader2.GetPageContent(i)
                If Not IsNothing(pageBytes1) AndAlso Not IsNothing(pageBytes2) Then
                    token1 = New iTextSharp.text.pdf.PRTokeniser(pageBytes1)
                    token2 = New iTextSharp.text.pdf.PRTokeniser(pageBytes2)
                    While token1.NextToken() AndAlso token2.NextToken()

                        tknType1 = token1.TokenType()
                        tknValue1 = token1.StringValue

                        tknType2 = token2.TokenType()
                        tknValue2 = token2.StringValue

                        If tknType1 = iTextSharp.text.pdf.PRTokeniser.TK_STRING AndAlso _
                           tknType2 = iTextSharp.text.pdf.PRTokeniser.TK_STRING Then
                            If String.Compare(tknValue1, tknValue2) <> 0 Then
                                writer.WriteLine("Pdf1: " & tknValue1 & " <> Pdf2: " & tknValue2)
                            End If
                        End If
                    End While
                End If
            Next i
            writer.Close()
            reader1.Close()
            reader2.Close()
        Catch ex As Exception
            Throw
        End Try
    End Sub

    ''' <summary>
    ''' Extract a single page from source pdf to a new pdf
    ''' </summary>
    ''' <param name="sourcePdf">the full path to source pdf file</param>
    ''' <param name="pageNumberToExtract">the page number to extract</param>
    ''' <param name="outPdf">the full path for the output pdf</param>
    ''' <remarks></remarks>
    Public Shared Sub ExtractPdfPage(ByVal sourcePdf As String, ByVal pageNumberToExtract As Integer, ByVal outPdf As String)
        Dim reader As iTextSharp.text.pdf.PdfReader = Nothing
        Dim doc As iTextSharp.text.Document = Nothing
        Dim pdfCpy As iTextSharp.text.pdf.PdfCopy = Nothing
        Dim page As iTextSharp.text.pdf.PdfImportedPage = Nothing
        Try
            reader = New iTextSharp.text.pdf.PdfReader(sourcePdf)
            doc = New iTextSharp.text.Document(reader.GetPageSizeWithRotation(1))
            pdfCpy = New iTextSharp.text.pdf.PdfCopy(doc, New IO.FileStream(outPdf, IO.FileMode.Create))
            doc.Open()
            page = pdfCpy.GetImportedPage(reader, pageNumberToExtract)
            pdfCpy.AddPage(page)
            doc.Close()
            reader.Close()
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' Extract selected pages from a source pdf to a new pdf
    ''' </summary>
    ''' <param name="sourcePdf">the full path to source pdf to a new pdf</param>
    ''' <param name="pageNumbersToExtract">the page numbers to extract (i.e {1, 3, 5, 6})</param>
    ''' <param name="outPdf">The full path for the output pdf</param>
    ''' <remarks>The output pdf will contains the extracted pages in the order of the page numbers listed
    ''' in pageNumbersToExtract parameter.</remarks>
    Public Shared Sub ExtractPdfPage(ByVal sourcePdf As String, ByVal pageNumbersToExtract As Integer(), ByVal outPdf As String)
        Dim reader As iTextSharp.text.pdf.PdfReader = Nothing
        Dim doc As iTextSharp.text.Document = Nothing
        Dim pdfCpy As iTextSharp.text.pdf.PdfCopy = Nothing
        Dim page As iTextSharp.text.pdf.PdfImportedPage = Nothing
        Try
            reader = New iTextSharp.text.pdf.PdfReader(sourcePdf)
            doc = New iTextSharp.text.Document(reader.GetPageSizeWithRotation(1))
            pdfCpy = New iTextSharp.text.pdf.PdfCopy(doc, New IO.FileStream(outPdf, IO.FileMode.Create))
            doc.Open()
            For Each pageNum As Integer In pageNumbersToExtract
                page = pdfCpy.GetImportedPage(reader, pageNum)
                pdfCpy.AddPage(page)
            Next
            doc.Close()
            reader.Close()
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' Split a single pdf file into multiple pdfs with equal number of pages.
    ''' </summary>
    ''' <param name="sourcePdf">the full path to the source pdf</param>
    ''' <param name="parts">the number of splitted pdfs to split to</param>
    ''' <param name="baseNameOutPdf">the base file name (full path) for splitted pdfs.
    ''' The actual output pdf file names will be serialized. </param>
    ''' <remarks>The last splitted pdf may not have
    ''' the same number of pages as the rest, depending on the combination of number of pages in the source pdf 
    ''' and the number of parts to be splitted. For example, if the original pdf has 9 pages and it is to be 
    ''' splitted into 5 parts, the last splitted pdf will have only 1 page while all others have 2 pages.</remarks>
    Public Shared Sub SplitPdfByParts(ByVal sourcePdf As String, ByVal parts As Integer, ByVal baseNameOutPdf As String)
        Dim reader As iTextSharp.text.pdf.PdfReader = Nothing
        Dim doc As iTextSharp.text.Document = Nothing
        Dim pdfCpy As iTextSharp.text.pdf.PdfCopy = Nothing
        Dim page As iTextSharp.text.pdf.PdfImportedPage = Nothing
        Dim pageCount As Integer = 0
        Try
            reader = New iTextSharp.text.pdf.PdfReader(sourcePdf)
            pageCount = reader.NumberOfPages
            If pageCount < parts Then
                Throw New ArgumentException("Not enough pages in source pdf to split")
            Else
                Dim n As Integer = pageCount \ parts
                Dim currentPage As Integer = 1
                Dim ext As String = IO.Path.GetExtension(baseNameOutPdf)
                Dim outfile As String = String.Empty
                For i As Integer = 1 To parts
                    outfile = baseNameOutPdf.Replace(ext, "_" & i & ext)
                    doc = New iTextSharp.text.Document(reader.GetPageSizeWithRotation(currentPage))
                    pdfCpy = New iTextSharp.text.pdf.PdfCopy(doc, New IO.FileStream(outfile, IO.FileMode.Create))
                    doc.Open()
                    If i < parts Then
                        For j As Integer = 1 To n
                            page = pdfCpy.GetImportedPage(reader, currentPage)
                            pdfCpy.AddPage(page)
                            currentPage += 1
                        Next j
                    Else
                        For j As Integer = currentPage To pageCount
                            page = pdfCpy.GetImportedPage(reader, j)
                            pdfCpy.AddPage(page)
                        Next j
                    End If
                    doc.Close()
                Next
            End If
            reader.Close()
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' Split source pdf into multiple pdfs with specifc number of pages
    ''' </summary>
    ''' <param name="sourcePdf">the full path to source pdf</param>
    ''' <param name="numOfPages">the number of pages each splitted pdf should contain</param>
    ''' <param name="baseNameOutPdf">the base file name (full path) for splitted pdfs.
    ''' The actual output pdf file names will be serialized. </param>
    ''' <remarks>The last splitted pdf may not have
    ''' the same number of pages as the rest, depending on the combination of number of pages in the source pdf 
    ''' and the number of target pages in each splitted pdf. For example, if the original pdf has 9 pages and it is to be 
    ''' splitted with 2 pages for each pdf, the last splitted pdf will have only 1 page while all others have 2 pages.</remarks>
    Public Shared Sub SplitPdfByPages(ByVal sourcePdf As String, ByVal numOfPages As Integer, ByVal baseNameOutPdf As String)
        Dim reader As iTextSharp.text.pdf.PdfReader = Nothing
        Dim doc As iTextSharp.text.Document = Nothing
        Dim pdfCpy As iTextSharp.text.pdf.PdfCopy = Nothing
        Dim page As iTextSharp.text.pdf.PdfImportedPage = Nothing
        Dim pageCount As Integer = 0
        Try
            reader = New iTextSharp.text.pdf.PdfReader(sourcePdf)
            pageCount = reader.NumberOfPages
            If pageCount < numOfPages Then
                Throw New ArgumentException("Not enough pages in source pdf to split")
            Else
                Dim ext As String = IO.Path.GetExtension(baseNameOutPdf)
                Dim outfile As String = String.Empty
                Dim n As Integer = CInt(Math.Ceiling(pageCount / numOfPages))
                Dim currentPage As Integer = 1
                For i As Integer = 1 To n
                    outfile = baseNameOutPdf.Replace(ext, "_" & i & ext)
                    doc = New iTextSharp.text.Document(reader.GetPageSizeWithRotation(currentPage))
                    pdfCpy = New iTextSharp.text.pdf.PdfCopy(doc, New IO.FileStream(outfile, IO.FileMode.Create))
                    doc.Open()
                    If i < n Then
                        For j As Integer = 1 To numOfPages
                            page = pdfCpy.GetImportedPage(reader, currentPage)
                            pdfCpy.AddPage(page)
                            currentPage += 1
                        Next j
                    Else
                        For j As Integer = currentPage To pageCount
                            page = pdfCpy.GetImportedPage(reader, j)
                            pdfCpy.AddPage(page)
                        Next j
                    End If
                    doc.Close()
                Next
            End If
            reader.Close()
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' Extract pages from multiple pdf's file and merge them into 
    ''' a single pdf
    ''' </summary>
    ''' <param name="sourceTable">the datatable containing source pfd paths and the pages to extract
    ''' from each of them. This datatable should have 2 datacolumns of type String. The 1st column (column 0)
    ''' is for the file (full) path while the 2nd column (column 1) is for the list of pages to extract from
    ''' the source pdf in column 1. This list is a string of integer values separated by commas 
    ''' (ex: "1, 3, 2, 5 , 8, 7, 9") </param>
    ''' <param name="outPdf">the path to save the output pdf</param>
    ''' <remarks>the pdf pages are extracted and merged in the order list in the source datatable.
    ''' That is, for source pdf files, they will be merged from top row down, and for pages, they will be merged
    ''' by the order listed in the csv string</remarks>
    Public Shared Sub ExtractAndMergePdfPages(ByVal sourceTable As DataTable, ByVal outPdf As String)
        Dim rowCount As Integer = sourceTable.Rows.Count
        Dim sourcePdf As String = String.Empty
        Dim pageNumbersToExtract() As Integer = Nothing
        Dim reader As iTextSharp.text.pdf.PdfReader = Nothing
        Dim doc As iTextSharp.text.Document = Nothing
        Dim pdfCpy As iTextSharp.text.pdf.PdfCopy = Nothing
        Dim page As iTextSharp.text.pdf.PdfImportedPage = Nothing
        Select Case rowCount
            Case 0  'Nothing to extract and merge
                Exit Sub
            Case 1  'only 1 source pdf
                sourcePdf = CStr(sourceTable.Rows(0).Item(0))
                pageNumbersToExtract = ConvertToIntegerArray(CStr(sourceTable.Rows(0).Item(1)))
                ExtractPdfPage(sourcePdf, pageNumbersToExtract, outPdf)
            Case Else   'multiple source pdf's
                Try
                    sourcePdf = CStr(sourceTable.Rows(0).Item(0))
                    pageNumbersToExtract = ConvertToIntegerArray(CStr(sourceTable.Rows(0).Item(1)))

                    reader = New iTextSharp.text.pdf.PdfReader(sourcePdf)
                    If CStr(sourceTable.Rows(0).Item(1)) = "0" Then
                        Dim lPages As New List(Of Integer)
                        For ipage As Integer = 0 To reader.NumberOfPages - 1
                            lPages.Add(ipage + 1)
                        Next
                        pageNumbersToExtract = lPages.ToArray
                    End If
                    doc = New iTextSharp.text.Document(reader.GetPageSizeWithRotation(1))
                    pdfCpy = New iTextSharp.text.pdf.PdfCopy(doc, New IO.FileStream(outPdf, IO.FileMode.Create))
                    doc.Open()
                    For Each pageNum As Integer In pageNumbersToExtract
                        page = pdfCpy.GetImportedPage(reader, pageNum)
                        pdfCpy.AddPage(page)
                    Next
                    reader.Close()
                    For i As Integer = 1 To rowCount - 1
                        sourcePdf = CStr(sourceTable.Rows(i).Item(0))
                        If CStr(sourceTable.Rows(i).Item(1)) = "0" Then
                            Dim lPages As New List(Of Integer)
                            For ipage As Integer = 0 To reader.NumberOfPages - 1
                                lPages.Add(ipage + 1)
                            Next
                            pageNumbersToExtract = lPages.ToArray
                        Else
                            pageNumbersToExtract = ConvertToIntegerArray(CStr(sourceTable.Rows(i).Item(1)))
                        End If
                        reader = New iTextSharp.text.pdf.PdfReader(sourcePdf)
                        doc.SetPageSize(reader.GetPageSizeWithRotation(1))
                        For Each pageNum As Integer In pageNumbersToExtract
                            page = pdfCpy.GetImportedPage(reader, pageNum)
                            pdfCpy.AddPage(page)
                        Next
                        reader.Close()
                    Next
                    doc.Close()
                Catch ex As Exception
                    Throw ex
                End Try
        End Select
    End Sub

    ''' <summary>
    ''' Helper function to convert a csv integer string to an integer array
    ''' </summary>
    ''' <param name="csvNumbers">the integer string in csv format (ex: "1, 5, 7, 4")</param>
    ''' <returns>Integer array converted from the csv string (ex: {1, 5, 7, 4}</returns>
    ''' <remarks>No error checking/handling. If the input string contains non-numeric values
    ''' the function will crash. It's up to you to handle this error.</remarks>
    Private Shared Function ConvertToIntegerArray(ByVal csvNumbers As String) As Integer()
        Dim numbers() As String = csvNumbers.Split(",".ToCharArray, System.StringSplitOptions.RemoveEmptyEntries)
        Dim upperBound As Integer = numbers.Length - 1
        Dim output(upperBound) As Integer
        For i As Integer = 0 To upperBound
            output(i) = Integer.Parse(numbers(i))
        Next
        Return output
    End Function

End Class
