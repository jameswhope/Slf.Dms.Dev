Imports System.Data

Imports Microsoft.VisualBasic

Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports System.IO
Imports Drg.Util.DataAccess

Public Class ClientFileDocumentHelper
    Implements IDisposable
    Private Const INT_newTableWidth As Integer = 100
    Private Const INT_newTablePadding As Integer = 2


#Region "Fields"

    Public chapterFont As iTextSharp.text.Font = FontFactory.GetFont(FontFactory.HELVETICA, 12, Font.BOLDITALIC)
    Public fntNormalText As iTextSharp.text.Font = FontFactory.GetFont(FontFactory.HELVETICA, 8, Font.NORMAL)
    Public sectionFont As iTextSharp.text.Font = FontFactory.GetFont(FontFactory.HELVETICA, 10, Font.BOLDITALIC)
    Public subsectionFont As iTextSharp.text.Font = FontFactory.GetFont(FontFactory.HELVETICA, 9, Font.NORMAL)
    Public bf As BaseFont = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED)
    Private disposedValue As Boolean = False 'To detect redundant calls
    Private pdfFileName As String = ""
    Private strPlaintiff As String = String.Empty
#End Region 'Fields


#Region "Methods"

    Public Shared Function InsertSpaceAfterCap(ByVal strToChange As String) As String
        If strToChange.Contains("CityStateZip") Then
            strToChange = strToChange.Replace("CityStateZip", "City,StateZip")
        End If

        Dim strNew As String = ""

        For Each c As Char In strToChange.ToCharArray()
            Select Case Asc(c)
                Case 65 To 95, 49 To 57   'upper caps or numbers
                    strNew += Space(1) & c.ToString
                Case 97 To 122  'lower caps
                    strNew += c.ToString
                Case Else
                    strNew += Space(1) & c.ToString
            End Select
        Next

        strNew = strNew.Replace("I D", "ID")
        strNew = strNew.Replace("C S Z", "CSZ")
        strNew = strNew.Replace("S S N", "SSN")
        Return strNew.Trim
    End Function

    ' create PDF and send to client
    Public Shared Sub generateClientFile(ByVal dataClientId As Integer, ByVal resp As HttpResponse)
        ' the PDF document itself;
        Dim doc As New iTextSharp.text.Document()
        Dim writer As PdfWriter = PdfWriter.GetInstance(doc, resp.OutputStream)

        'Dim events As New pdfPageEvents
        'writer.PageEvent = events

        doc.SetPageSize(PageSize.LETTER)
        Using obj As New ClientFileDocumentHelper
            Try
                Dim header As New HeaderFooter(New Phrase("Client Data File", New iTextSharp.text.Font(iTextSharp.text.Font.HELVETICA, 18, Font.BOLDITALIC)), False)
                header.Border = iTextSharp.text.Rectangle.NO_BORDER
                header.Alignment = 1
                doc.Header = header
                doc.Open()

                Dim cb As PdfContentByte = writer.DirectContent

                doc.Add(obj.createClientSection(dataClientId))
                doc.NewPage()

                doc.Add(obj.createCreditorSection(dataClientId))
                doc.NewPage()

                doc.Add(obj.createFinancialSection(dataClientId))
                doc.NewPage()

                doc.Add(obj.createCommunicationsSection(dataClientId))
                doc.NewPage()

                doc.Add(obj.createDocumentsSection(dataClientId))
                doc.NewPage()
                doc.ResetHeader()
                obj.createClientDocuments(dataClientId, doc, cb, writer)

                doc.Close()
            Catch
            Finally
                If doc IsNot Nothing Then
                    doc.Close()
                End If
            End Try

            resp.ContentType = "application/pdf"
            resp.AddHeader("content-disposition", String.Format("attachment;filename={0}", obj.pdfFileName))
        End Using
    End Sub

    ' This code added by Visual Basic to correctly implement the disposable pattern.
    Public Sub Dispose() Implements IDisposable.Dispose
        ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
        Dispose(True)
        GC.SuppressFinalize(Me)
    End Sub

    ' IDisposable
    Protected Overridable Sub Dispose(ByVal disposing As Boolean)
        If Not Me.disposedValue Then
            If disposing Then
                ' TODO: free other state (managed objects).
            End If

            ' TODO: free your own state (unmanaged objects).
            ' TODO: set large fields to null.
        End If
        Me.disposedValue = True
    End Sub

    Private Function createAccountInfoTable(ByVal dtDataToUse As DataTable) As Table
        Dim newTable As New Table(2) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

        ' set *column* widths
        newTable.Widths = New Single() {0.3, 0.7}

        ' create the *table* header row
        Dim cell As New Cell(New Phrase("Account Information", sectionFont))
        cell.Header = True
        cell.Colspan = 2
        cell.BackgroundColor = New iTextSharp.text.Color(255, 255, 255)
        newTable.AddCell(cell)
        newTable.EndHeaders()

        For Each Row As DataRow In dtDataToUse.Rows
            pdfFileName = String.Format("{0}_client_data_file.pdf", Row("FirmAccount#").ToString)

            For colCnt As Integer = 0 To dtDataToUse.Columns.Count - 1
                Dim hdrCell As New Cell(New Phrase(InsertSpaceAfterCap(dtDataToUse.Columns(colCnt).ColumnName.ToString), fntNormalText)) With {.HorizontalAlignment = Element.ALIGN_RIGHT}
                newTable.AddCell(hdrCell)

                Dim cellText As String = Row.Item(colCnt).ToString()
                Select Case dtDataToUse.Columns(colCnt).ColumnName.ToLower
                    Case "depositamount"
                        cellText = FormatCurrency(cellText, 2)
                    Case "enrollmentdate", "depositstartdate"
                        cellText = FormatDateTime(cellText, DateFormat.ShortDate)
                End Select
                newTable.AddCell(New Phrase(cellText, fntNormalText))
            Next
        Next
        Return newTable
    End Function

    Private Function createApplicantInfoTable(ByVal drDataToUse As DataRow, ByVal tblColumnNames As DataColumnCollection) As Table
        Dim newTable As New Table(2) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True, .Widths = New Single() {0.3, 0.7}}

        ' create the *table* header row
        Dim hdrText As String = ""
        Select Case drDataToUse("relationship").ToString.ToLower
            Case "prime"
                hdrText = "Applicant Relationship - Primary"
            Case Else
                hdrText = String.Format("Applicant Relationship - {0}", drDataToUse("relationship").ToString)
        End Select
        Dim cell As New Cell(New Phrase(hdrText, sectionFont)) With {.Header = True, .Colspan = 2, .BackgroundColor = New iTextSharp.text.Color(255, 255, 255)}
        newTable.AddCell(cell)
        newTable.EndHeaders()

        For colCnt As Integer = 2 To tblColumnNames.Count - 1
            Dim hdrCell As New Cell(New Phrase(InsertSpaceAfterCap(tblColumnNames(colCnt).ColumnName.ToString), fntNormalText)) With {.HorizontalAlignment = Element.ALIGN_RIGHT}
            newTable.AddCell(hdrCell)
            newTable.AddCell(New Phrase(drDataToUse.Item(colCnt).ToString(), fntNormalText))
        Next

        Return newTable
    End Function

    Private Function createInfoTable(ByVal tableHeaderText As String, ByVal drDataToUse As DataRow, ByVal tblColumnNames As DataColumnCollection) As Table
        Dim newTable As New Table(2) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True, .Widths = New Single() {0.3, 0.7}}

        ' create the *table* header row
        Dim cell As New Cell(New Phrase(tableHeaderText, sectionFont)) With {.Header = True, .Colspan = 2, .BackgroundColor = New iTextSharp.text.Color(255, 255, 255)}
        newTable.AddCell(cell)
        newTable.EndHeaders()

        For colCnt As Integer = 0 To tblColumnNames.Count - 1
            Dim hdrCell As New Cell(New Phrase(InsertSpaceAfterCap(tblColumnNames(colCnt).ColumnName.ToString), fntNormalText)) With {.HorizontalAlignment = Element.ALIGN_RIGHT}
            newTable.AddCell(hdrCell)
            newTable.AddCell(New Phrase(drDataToUse.Item(colCnt).ToString(), fntNormalText))
        Next

        Return newTable
    End Function
    Private Function getClientFileList(ByVal clientPath As String) As Generic.List(Of String)
        Dim fList As New Generic.List(Of String)

        Dim tempDir As New DirectoryInfo(clientPath)

        For Each f As FileInfo In tempDir.GetFiles("*.pdf")
            fList.Add(f.FullName)
        Next

        For Each Dir As DirectoryInfo In tempDir.GetDirectories
            fList.AddRange(getClientFileList(Dir.FullName))
        Next

        fList.Sort()
        Return fList

    End Function
    Private Sub createClientDocuments(ByVal dataClientId As Integer, ByRef DocToUse As iTextSharp.text.Document, ByRef cbToUse As PdfContentByte, ByRef writerToUse As PdfWriter)
        Dim clientAcctNum As String = SharedFunctions.AsyncDB.executeScalar("Select accountnumber from tblclient where clientid = " & dataClientId, ConfigurationManager.AppSettings("connectionstring").ToString)
        Dim clientFiles As Generic.List(Of String) = getClientFileList(String.Format("\\nas02\ClientStorage\{0}", clientAcctNum))
        For Each cfile As String In clientFiles
            Dim pdfPath As String = cfile

            Dim docInfo() As String = Path.GetFileNameWithoutExtension(pdfPath).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
            Dim docName As String = SharedFunctions.AsyncDB.executeScalar(String.Format("select displayname  from tbldocumenttype where typeid = '{0}'", docInfo(1).ToString), ConfigurationManager.AppSettings("connectionstring").ToString)
            Dim clientdocs As New iTextSharp.text.pdf.PdfReader(pdfPath)
            Dim numberOfPages As Integer = clientdocs.NumberOfPages
            Dim currentPageNumber As Integer = 0
            Dim page As iTextSharp.text.pdf.PdfImportedPage
            Dim rotation As Integer
            Do While currentPageNumber < numberOfPages
                currentPageNumber += 1
                page = writerToUse.GetImportedPage(clientdocs, currentPageNumber)
                DocToUse.NewPage()
                DocToUse.SetPageSize(New Rectangle(page.Width, 1008))
                rotation = clientdocs.GetPageRotation(currentPageNumber)
                If rotation = 90 Or rotation = 270 Then
                    cbToUse.AddTemplate(page, 0, -1.0F, 1.0F, 0, 0, clientdocs.GetPageSizeWithRotation(currentPageNumber).Height)
                Else
                    cbToUse.AddTemplate(page, 1.0F, 0, 0, 1.0F, 0, 0)
                End If

                cbToUse.BeginText()
                cbToUse.SetFontAndSize(bf, 8)
                Dim docHdr As String = String.Format("Document Name : {0} | Created : {1} | Doc ID : {2}", docName, docInfo(3), docInfo(2))
                cbToUse.ShowTextAligned(PdfContentByte.ALIGN_LEFT, docHdr, 5, 5, 0)
                cbToUse.EndText()

            Loop
            clientdocs.Close()
        Next
        'Dim sSQL As String = ""
        'sSQL = String.Format("stp_ClientFile_getAllDocumentsInfo {0}", dataClientId)
        'Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("connectionstring").ToString)
        '    For Each Row As DataRow In dt.Rows
        '        Dim pdfPath As String = Row("pdfpath").ToString
        '        If IO.File.Exists(pdfPath) Then
        '            Dim clientdocs As New iTextSharp.text.pdf.PdfReader(pdfPath)

        '            Dim numberOfPages As Integer = clientdocs.NumberOfPages
        '            Dim currentPageNumber As Integer = 0
        '            Dim page As iTextSharp.text.pdf.PdfImportedPage
        '            Dim rotation As Integer

        '            'add doc info to header
        '            Dim docInfo As String = String.Format("Name:{0}" & Space(5) & "ID:{1}" & Space(5) & "Created:{2}", _
        '                                                  Row("displayname").ToString, _
        '                                                  Row("doctypeid").ToString, _
        '                                                  Row("created").ToString)

        '            Do While currentPageNumber < numberOfPages
        '                currentPageNumber += 1
        '                page = writerToUse.GetImportedPage(clientdocs, currentPageNumber)

        '                DocToUse.NewPage()
        '                DocToUse.SetPageSize(New Rectangle(page.Width, 1008))

        '                rotation = clientdocs.GetPageRotation(currentPageNumber)

        '                If rotation = 90 Or rotation = 270 Then
        '                    cbToUse.AddTemplate(page, 0, -1.0F, 1.0F, 0, 0, clientdocs.GetPageSizeWithRotation(currentPageNumber).Height)
        '                Else
        '                    cbToUse.AddTemplate(page, 1.0F, 0, 0, 1.0F, 0, 0)
        '                End If

        '                cbToUse.BeginText()
        '                cbToUse.SetFontAndSize(bf, 8)
        '                cbToUse.ShowTextAligned(PdfContentByte.ALIGN_LEFT, docInfo, 5, page.Height - 15, 0)
        '                cbToUse.EndText()

        '            Loop
        '            clientdocs.Close()
        '        End If
        '    Next
        'End Using
    End Sub

    Private Function createClientSection(ByVal dataClientId As Integer) As Table
        Dim sSQL As String = ""

        Dim newTable As New Table(1) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

        'create header row
        Dim cell As New Cell(New Phrase("Client Information", chapterFont)) With {.Header = True, .BackgroundColor = New iTextSharp.text.Color(220, 220, 220)}
        newTable.AddCell(cell)
        newTable.EndHeaders()

        sSQL = String.Format("stp_ClientFile_getGeneralInfo {0}", dataClientId)
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("connectionstring").ToString)
            newTable.InsertTable(createAccountInfoTable(dt))
        End Using

        sSQL = String.Format("stp_clientfile_getLSAInfo {0}", dataClientId)
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each rowData As DataRow In dt.Rows
                newTable.InsertTable(createInfoTable("Legal Service Agreement Information", rowData, dt.Columns))
            Next
        End Using

        sSQL = String.Format("stp_clientfile_getClientInfo {0}", dataClientId)
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each rowData As DataRow In dt.Rows
                newTable.InsertTable(createApplicantInfoTable(rowData, dt.Columns))
            Next
        End Using

        Return newTable
    End Function

    Private Function createCommunicationsSection(ByVal dataClientId As Integer) As Table
        Dim sSQL As String = ""

        ' set table style properties
        Dim newTable As New Table(4) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

        'create header row
        Dim Cell As New Cell(New Phrase("Communications", chapterFont)) With {.Header = True, .Colspan = 4, .BackgroundColor = New iTextSharp.text.Color(220, 220, 220)}
        newTable.AddCell(Cell)
        newTable.EndHeaders()

        ' set *column* widths
        newTable.Widths = New Single() {0.1, 0.1, 0.2, 0.6}

        sSQL = String.Format("stp_ClientFile_getAllCommunications {0}", dataClientId)
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("connectionstring").ToString)
            ' create the *table* header row
            For i As Integer = 0 To dt.Columns.Count - 1
                Cell = New Cell(New Phrase(dt.Columns(i).ColumnName.ToString, fntNormalText))
                Cell.Header = True
                Cell.BackgroundColor = New iTextSharp.text.Color(255, 255, 255)
                newTable.AddCell(Cell)
            Next
            newTable.EndHeaders()

            For Each Row As DataRow In dt.Rows
                For colCnt As Integer = 0 To dt.Columns.Count - 1
                    newTable.AddCell(New Phrase(Row.Item(colCnt).ToString(), fntNormalText))
                Next
            Next
        End Using

        Return newTable
    End Function

    Private Function createCreditorSection(ByVal dataClientId As Integer) As Table
        Dim sSQL As String = ""

        Dim newTable As New Table(1) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

        'create header row
        Dim cell As New Cell(New Phrase("Creditor Information", chapterFont)) With {.Header = True, .BackgroundColor = New iTextSharp.text.Color(220, 220, 220)}
        newTable.AddCell(cell)
        newTable.EndHeaders()

        newTable.InsertTable(createCreditorTable(dataClientId))

        Return newTable
    End Function

    Private Function createCreditorTable(ByVal dataClientID As Integer) As Table
        Dim col As String() = {"Current", "Original", "Account #", "Ref #", "Acquired", "Amt", "Orig Amt", "Address"}
        Dim table As New Table(8) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = 1, .Width = INT_newTableWidth, .CellsFitPage = True}
        table.TableFitsPage = True

        Dim ssql As String = String.Format("stp_ClientFile_getCreditorNames {0}", dataClientID)
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(ssql, ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each Row As DataRow In dt.Rows
                ' the column headings
                Dim hdrText As String = String.Format("Creditor Name : {0}" & Space(5) & "  Status : {1}", Row("CreditorName").ToString, Row("Accountstatus").ToString)
                Dim cell As New Cell(New Phrase(hdrText, sectionFont)) With {.Header = True, .Colspan = 8, .BackgroundColor = New iTextSharp.text.Color(255, 255, 255)}
                table.AddCell(cell)
                table.EndHeaders()

                ' set *column* widths
                table.Widths = New Single() {0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.2}

                For iCol As Integer = 0 To col.Length - 1
                    cell = New Cell(New Phrase(col(iCol), fntNormalText))
                    cell.Header = True
                    cell.BackgroundColor = New iTextSharp.text.Color(255, 255, 255)
                    table.AddCell(cell)
                Next
                table.EndHeaders()

                'add subsection
                ssql = String.Format("stp_ClientFile_getCreditorInfo {0}", Row("accountid").ToString)
                Using dtC As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(ssql, ConfigurationManager.AppSettings("connectionstring").ToString)

                    For Each cRow As DataRow In dtC.Rows
                        table.AddCell(New Phrase(cRow("current").ToString, fntNormalText))
                        table.AddCell(New Phrase(cRow("Original").ToString, fntNormalText))
                        table.AddCell(New Phrase(cRow("AccountNumber").ToString, fntNormalText))
                        table.AddCell(New Phrase(cRow("referencenumber").ToString, fntNormalText))
                        table.AddCell(New Phrase(FormatDateTime(cRow("DateAcquired").ToString, DateFormat.ShortDate), fntNormalText))
                        table.AddCell(New Phrase(FormatCurrency(cRow("CurrentAmt").ToString, 2), fntNormalText))
                        table.AddCell(New Phrase(FormatCurrency(cRow("OriginalAmt").ToString, 2), fntNormalText))
                        table.AddCell(New Phrase(cRow("Address").ToString, fntNormalText))
                    Next

                End Using
            Next
        End Using

        Return table
    End Function

    Private Function createDocumentsSection(ByVal dataClientId As Integer) As Table
        Dim sSQL As String = ""
        Dim col As String() = {"Type ID", "Name", "Created"}
        Dim newTable As New Table(3) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

        ' set *column* widths
        newTable.Widths = New Single() {0.1, 0.3, 0.1}

        'create header row
        Dim Cell As New Cell(New Phrase("Documents", chapterFont))
        Cell.Header = True
        Cell.Colspan = 3
        Cell.BackgroundColor = New iTextSharp.text.Color(220, 220, 220)
        newTable.AddCell(Cell)
        newTable.EndHeaders()

        ' create the *table* header row
        For i As Integer = 0 To col.Length - 1
            Cell = New Cell(New Phrase(col(i), fntNormalText))
            Cell.Header = True
            Cell.BackgroundColor = New iTextSharp.text.Color(255, 255, 255)
            newTable.AddCell(Cell)
        Next
        newTable.EndHeaders()

        sSQL = String.Format("stp_ClientFile_getAllDocumentsInfo {0}", dataClientId)
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each Row As DataRow In dt.Rows
                Dim pdfPath As String = Row("pdfpath").ToString
                If IO.File.Exists(pdfPath) Then
                    newTable.AddCell(New Phrase(Row("doctypeid").ToString, fntNormalText))
                    newTable.AddCell(New Phrase(Row("displayname").ToString, fntNormalText))
                    newTable.AddCell(New Phrase(Row("created").ToString, fntNormalText))
                End If
            Next
        End Using

        Return newTable
    End Function

    Private Function createFinancialSection(ByVal dataClientId As Integer) As Table
        Dim sSQL As String = ""

        ' the column headings
        Dim col As String() = {"Transaction Date", "Type", "Associated To", "Amount", "SDA Balance", "PFO Balance"}
        Dim table As New Table(6) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

        ' set *column* widths
        table.Widths = New Single() {0.1, 0.3, 0.3, 0.1, 0.1, 0.1}

        'create header row
        Dim cell As New Cell(New Phrase("Financial Transactions", chapterFont)) With {.Header = True, .Colspan = 6, .BackgroundColor = New iTextSharp.text.Color(220, 220, 220)}
        table.AddCell(cell)
        table.EndHeaders()

        ' create the *table* header row
        For i As Integer = 0 To col.Length - 1
            cell = New Cell(New Phrase(col(i), fntNormalText))
            cell.Header = True
            cell.BackgroundColor = New iTextSharp.text.Color(255, 255, 255)
            table.AddCell(cell)
        Next
        table.EndHeaders()

        sSQL = "stp_GetTransactions "
        sSQL += String.Format("'WHERE r.clientid = {0}'", dataClientId)
        sSQL += String.Format(",'WHERE r.clientid = {0}'", dataClientId)
        sSQL += ",'ORDER BY Date, RegisterFirst, ID'"
        Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("connectionstring").ToString)
            For Each Row As DataRow In dt.Rows
                table.AddCell(New Phrase(FormatDateTime(Row("Date").ToString, DateFormat.ShortDate), fntNormalText))
                table.AddCell(New Phrase(Row("entrytypename").ToString, fntNormalText))

                If IsDBNull(Row("accountcreditorname")) Then
                    table.AddCell(New Phrase(Row("description").ToString, fntNormalText))
                Else
                    table.AddCell(New Phrase(Row("accountcreditorname").ToString, fntNormalText))
                End If
                cell = New Cell(New Phrase(FormatCurrency(Row("amount").ToString, 2), fntNormalText)) With {.HorizontalAlignment = 2}
                table.AddCell(cell)

                cell = New Cell(New Phrase(FormatCurrency(Row("sdabalance").ToString, 2), fntNormalText)) With {.HorizontalAlignment = 2}
                table.AddCell(cell)

                cell = New Cell(New Phrase(FormatCurrency(Row("pfobalance").ToString, 2), fntNormalText)) With {.HorizontalAlignment = 2}
                table.AddCell(cell)
            Next
        End Using

        Return table
    End Function

#End Region 'Methods

#Region "Nested Types"

    Public Class pdfPageEvents
        Inherits PdfPageEventHelper

#Region "Fields"

        'this is the BaseFont we are going to use for the header / footer
        Dim bf As BaseFont = Nothing

        ' This is the contentbyte object of the writer
        Dim cb As PdfContentByte

        'we will put the final number of pages in a template
        Dim template As PdfTemplate

#End Region 'Fields

#Region "Methods"

        Public Overrides Sub OnCloseDocument(ByVal writer As iTextSharp.text.pdf.PdfWriter, ByVal document As iTextSharp.text.Document)
            template.BeginText()
            template.SetFontAndSize(bf, 8)
            template.ShowText((writer.PageNumber - 1).ToString())
            template.EndText()
            'MyBase.OnCloseDocument(writer, document)
        End Sub

        Public Overrides Sub OnEndPage(ByVal writer As iTextSharp.text.pdf.PdfWriter, ByVal document As iTextSharp.text.Document)
            Dim pageN As Integer = writer.PageNumber
            Dim text As String = String.Format("Page {0} of ", pageN)
            Dim len As Double = bf.GetWidthPoint(text, 8)
            cb.BeginText()
            cb.SetFontAndSize(bf, 8)
            cb.SetTextMatrix(280, 15)
            cb.ShowText(text)
            cb.EndText()
            cb.AddTemplate(template, 280 + len, 15)
            'MyBase.OnEndPage(writer, document)
        End Sub

        Public Overrides Sub OnOpenDocument(ByVal writer As iTextSharp.text.pdf.PdfWriter, ByVal document As iTextSharp.text.Document)
            Try
                bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED)
                cb = writer.DirectContent
                template = cb.CreateTemplate(50, 50)

            Catch ex As Exception

            End Try

            'MyBase.OnOpenDocument(writer, document)
        End Sub

#End Region 'Methods

    End Class

#End Region 'Nested Types

#Region " Generate PDF of ClientIntakeForm"


    Public Shared Function generateClientIntakeFile(ByVal AccountID As Int64, ByVal resp As HttpResponse, ByVal strFileName As String, ByVal strFolder As String, ByVal strFirm As String, ByVal strAccNo As String, ByVal strClientName As String, ByVal strAddress1 As String, ByVal strAddress2 As String, ByVal strPhone As String, ByVal strEmail As String, ByVal strAmount As String, ByVal strSDA As String, ByVal MatterID As Int64, ByVal ClientID As Int64, ByVal strCreatedBy As String) As Boolean

        ' the PDF document itself;
        Dim doc As New iTextSharp.text.Document()
        'Dim writer As PdfWriter = PdfWriter.GetInstance(doc, resp.OutputStream)
        'Dim writer As PdfWriter = PdfWriter.GetInstance(doc, New FileStream(String.Format(HttpContext.Current.Server.MapPath(".\ClientStorage\") & "{0}", strFolder), FileMode.Create))

        ' Local Dev box
        '2.25.2010
        Dim clientAcctNum As String = SharedFunctions.AsyncDB.executeScalar("Select accountnumber from tblclient where clientid = " & ClientID, ConfigurationManager.AppSettings("connectionstring").ToString)

        'If Not Directory.Exists(String.Format(HttpContext.Current.Server.MapPath("~/ClientStorage/") & "{0}/{1}/{2}/", clientAcctNum & "/" & strFolder, strMatterTypeCode, MatterID)) Then
        '    Directory.CreateDirectory(String.Format(HttpContext.Current.Server.MapPath("~/ClientStorage/") & "{0}/{1}/{2}/", clientAcctNum & "/" & strFolder, strMatterTypeCode, MatterID))
        'End If
        'Dim writer As PdfWriter = PdfWriter.GetInstance(doc, New FileStream(String.Format(HttpContext.Current.Server.MapPath("~/ClientStorage/") & "{0}/{1}/{2}/", clientAcctNum & "/" & strFolder, strMatterTypeCode, MatterID) & "/" & clientAcctNum & strFileName & ".pdf", FileMode.Create))

        '2.25.2010 end comment




        '**** 2.26.2010  read directory based on the definition on table
        Dim strStorageServer As String = DataHelper.FieldLookup("tblClient", "StorageServer", "ClientID = " & ClientID)
        Dim strStorageRoot As String = DataHelper.FieldLookup("tblClient", "StorageRoot", "ClientID = " & ClientID)

        If Not Directory.Exists("\\" + strStorageServer + "\" + strStorageRoot + "\" + strFolder) Then
            Directory.CreateDirectory("\\" + strStorageServer + "\" + strStorageRoot + "\" + strFolder)

        End If
        Dim writer As PdfWriter = PdfWriter.GetInstance(doc, New FileStream(String.Format("\\" + strStorageServer + "\" + strStorageRoot + "\" + strFolder) & "/" & strFileName & ".pdf", FileMode.Create))
        'Dim writer As PdfWriter = PdfWriter.GetInstance(doc, New FileStream(String.Format("\\lex-dev-30\ClientStorage\" + strFolder) & "/" & strFileName & ".pdf", FileMode.Create))

        doc.SetPageSize(PageSize.LETTER)
        Using obj As New ClientFileDocumentHelper
            Try
                Dim header As New HeaderFooter(New Phrase("Client Intake File", New iTextSharp.text.Font(iTextSharp.text.Font.HELVETICA, 18, Font.BOLDITALIC)), False)
                header.Border = iTextSharp.text.Rectangle.NO_BORDER
                header.Alignment = 1
                doc.Header = header
                doc.Open()


                Dim cb As PdfContentByte = writer.DirectContent

                'ClientInfo section
                doc.Add(obj.createClientInfoSection(AccountID, strFirm, strAccNo, strClientName, strAddress1, strAddress2, strPhone, strEmail, strAmount, strCreatedBy))
                'doc.NewPage()
                'realestate section
                doc.Add(obj.createRealEstateInfoSection(AccountID))
                'employement section
                doc.Add(obj.createEmployementInfoSection(AccountID))

                'bank info section
                doc.Add(obj.createBankInfoSection(AccountID))
                'doc.NewPage()
                'Assets info section
                doc.Add(obj.createAssetsInfoSection(AccountID))
                'doc.NewPage()
                doc.Add(obj.createVerificationSection(AccountID, strSDA))
                'Note section 
                doc.Add(obj.createNoteSection(AccountID))
                doc.NewPage()


                'doc.Add(obj.createClientIntakeSection(AccountID))
                'doc.NewPage()
                doc.Close()
                Return True
            Catch
                Return False
            Finally
                If doc IsNot Nothing Then
                    doc.Close()
                End If
            End Try

            'resp.ContentType = "application/pdf"
            'resp.AddHeader("content-disposition", String.Format("attachment;filename={0}", obj.pdfFileName))
            'resp.AddHeader("content-disposition", String.Format("attachment;filename={0}", strFileName))

        End Using
    End Function

    Private Function createClientInfoSection(ByVal AccountId As Int64, ByVal strFirm As String, ByVal strAccNo As String, ByVal strClientName As String, ByVal strAddress1 As String, ByVal strAddress2 As String, ByVal strPhone As String, ByVal strEmail As String, ByVal strAmount As String, ByVal strCreatedBy As String) As Table
        Dim sSQL As String = ""

        Dim newTable As New Table(1) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}
        Dim fn As iTextSharp.text.Font
        fn = getFont(8, iTextSharp.text.Font.NORMAL) 'arial

        Dim cellc As New Cell(New Phrase("Created by :" & strCreatedBy, fn)) With {.Header = False, .BackgroundColor = New iTextSharp.text.Color(255, 255, 255)}
        newTable.AddCell(cellc)
        Dim celld As New Cell(New Phrase("Date Printed: " & System.DateTime.Now.ToString("MM/dd/yyyy"), fn)) With {.Header = False, .BackgroundColor = New iTextSharp.text.Color(255, 255, 255)}
        newTable.AddCell(celld)
        Dim cellt As New Cell(New Phrase("Time Printed: " & System.DateTime.Now.ToString("hh:mmtt"), fn)) With {.Header = False, .BackgroundColor = New iTextSharp.text.Color(255, 255, 255)}
        newTable.AddCell(cellt)

        'create header row
        Dim cell As New Cell(New Phrase("1. Client Info                                                                                                           " & strAccNo, chapterFont)) With {.Header = True, .BackgroundColor = New iTextSharp.text.Color(220, 220, 220)}
        newTable.AddCell(cell)
        'cell = New Cell(New Phrase(strAccNo, chapterFont)) With {.Header = True, .BackgroundColor = New iTextSharp.text.Color(220, 220, 220)}
        'newTable.AddCell(cell)

        newTable.EndHeaders()

        newTable.InsertTable(createClientInfoTable(AccountId, strFirm, strAccNo, strClientName, strAddress1, strAddress2, strPhone, strEmail, strAmount))

        Return newTable
    End Function
    Private Function createRealEstateInfoSection(ByVal AccountId As Int64) As Table
        Dim sSQL As String = ""

        Dim newTable As New Table(1) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

        'create header row
        Dim cell As New Cell(New Phrase("2. Real Estate Info", chapterFont)) With {.Header = True, .BackgroundColor = New iTextSharp.text.Color(220, 220, 220)}
        newTable.AddCell(cell)
        newTable.EndHeaders()

        newTable.InsertTable(createRealEstateInfoTable(AccountId))

        Return newTable
    End Function
    Private Function createEmployementInfoSection(ByVal AccountId As Int64) As Table
        Dim sSQL As String = ""

        Dim newTable As New Table(1) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

        'create header row
        Dim cell As New Cell(New Phrase("3. Employment Info", chapterFont)) With {.Header = True, .BackgroundColor = New iTextSharp.text.Color(220, 220, 220)}
        newTable.AddCell(cell)
        newTable.EndHeaders()

        newTable.InsertTable(createEmployementInfoTable(AccountId))

        Return newTable
    End Function

    Private Function createEmployementInfoTable(ByVal AccountId As Integer) As Table
        Dim table As New Table(4) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = 1, .Width = INT_newTableWidth, .CellsFitPage = True}
        table.TableFitsPage = True
        Dim ssql As String = String.Format("stp_GetClientIntakeInfo {0}", AccountId)
        Dim dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(ssql, ConfigurationManager.AppSettings("connectionstring").ToString)

        Dim fb As iTextSharp.text.Font
        fb = getFont(8, iTextSharp.text.Font.BOLD) 'arial
        Dim fn As iTextSharp.text.Font
        fn = getFont(8, iTextSharp.text.Font.NORMAL) 'arial

        Dim strEmp As String = String.Empty
        Dim strsEmp As String = String.Empty
        Dim strAid As String = String.Empty
        If Not IsNothing(dt) Then
            If dt.Rows.Count > 0 Then
                If Not IsDBNull(dt.Rows(0)("Are you employed?")) Then
                    strEmp = dt.Rows(0)("Are you employed?")
                End If
                If Not IsDBNull(dt.Rows(0)("Are you self employed?")) Then
                    strsEmp = dt.Rows(0)("Are you self employed?")
                End If
                If Not IsDBNull(dt.Rows(0)("Receiving any type of Aid?")) Then
                    strAid = dt.Rows(0)("Receiving any type of Aid?")
                End If
            End If
        End If
        table.AddCell(CreateCell("Are you employed?     " & strEmp, fb, 4, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        ' table.AddCell(CreateCell(strEmp, fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

        If strEmp = "Yes" Then

            table.AddCell(CreateCell("Are you self employed?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(strsEmp, fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("Employer/Company", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(dt.Rows(0)("Employer/Company"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

            table.AddCell(CreateCell("length of employment", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(dt.Rows(0)("Length of the current employment"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("Take home pay", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("$ " & dt.Rows(0)("Take home pay"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

            table.AddCell(CreateCell("Per", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(dt.Rows(0)("Per"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("any wage garnishment", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(dt.Rows(0)("Any other wage garnishments"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

            If Not IsDBNull(dt.Rows(0)("WageVal")) Then
                If Convert.ToString(dt.Rows(0)("WageVal")) = "Yes" Then
                    table.AddCell(CreateCell("Enter Info", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell(dt.Rows(0)("WageVal"), fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

                End If
            End If

            table.AddCell(CreateCell("Other sources of income", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(dt.Rows(0)("Other sources of income"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("***(HAVE CLIENT SEND IN PROOF OF S.S.I., DISABILITY, ETC.)***", fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

        ElseIf strEmp = "No" Then
            table.AddCell(CreateCell("Receiving any type of Aid ?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(strAid, fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            Dim strIR As String = String.Empty
            If strAid = "Yes" Then
                'table.AddCell(CreateCell("Type of Aid?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                'table.AddCell(CreateCell(dt.Rows(0)("Type of Aid?"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

                'If Convert.ToString(dt.Rows(0)("Type of Aid?")) = "Retirement" Then
                '    table.AddCell(CreateCell("Income Received", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                '    table.AddCell(CreateCell("$ " & strIR, fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                'Else
                '    table.AddCell(CreateCell(" ", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                '    table.AddCell(CreateCell(" ", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                'End If

                If Not IsDBNull(dt.Rows(0)("Type of Aid?")) Then
                    strIR = Convert.ToString(dt.Rows(0)("IReceived"))
                    If Convert.ToString(dt.Rows(0)("Type of Aid?")) = "Yes" Then
                        table.AddCell(CreateCell("SSI", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                        table.AddCell(CreateCell("$ " & strIR, fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    End If
                End If
                If Not IsDBNull(dt.Rows(0)("TypeOfAidPension")) Then
                    strIR = Convert.ToString(dt.Rows(0)("AmtReceivedPension"))
                    If Convert.ToString(dt.Rows(0)("TypeOfAidPension")) = "Yes" Then
                        table.AddCell(CreateCell("Pension", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                        table.AddCell(CreateCell("$ " & strIR, fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    End If
                End If
                If Not IsDBNull(dt.Rows(0)("TypeOfAidUnemp")) Then
                    strIR = Convert.ToString(dt.Rows(0)("AmtReceivedUnemp"))
                    If Convert.ToString(dt.Rows(0)("TypeOfAidUnemp")) = "Yes" Then
                        table.AddCell(CreateCell("Unemployment", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                        table.AddCell(CreateCell("$ " & strIR, fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    End If
                End If
                If Not IsDBNull(dt.Rows(0)("TypeOfAidRetire")) Then
                    strIR = Convert.ToString(dt.Rows(0)("AmtReceivedRetire"))
                    If Convert.ToString(dt.Rows(0)("TypeOfAidRetire")) = "Yes" Then
                        table.AddCell(CreateCell("Retirement", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                        table.AddCell(CreateCell("$ " & strIR, fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    End If
                End If
            End If
            'table.AddCell(CreateCell(strIR, fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        End If


        Return table

    End Function

    Private Function createBankInfoSection(ByVal AccountId As Int64) As Table
        Dim sSQL As String = ""

        Dim newTable As New Table(1) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

        'create header row
        Dim cell As New Cell(New Phrase("4. Bank Info", chapterFont)) With {.Header = True, .BackgroundColor = New iTextSharp.text.Color(220, 220, 220)}
        newTable.AddCell(cell)
        newTable.EndHeaders()

        newTable.InsertTable(createBankInfoTable(AccountId))

        Return newTable
    End Function
    Private Function createAssetsInfoSection(ByVal AccountId As Int64) As Table
        Dim sSQL As String = ""

        Dim newTable As New Table(1) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

        'create header row
        Dim cell As New Cell(New Phrase("5. Assets Info", chapterFont)) With {.Header = True, .BackgroundColor = New iTextSharp.text.Color(220, 220, 220)}
        newTable.AddCell(cell)
        newTable.EndHeaders()

        newTable.InsertTable(createAssetsInfoTable(AccountId))

        Return newTable
    End Function
    Private Function createVerificationSection(ByVal AccountId As Int64, ByVal strSDA As String) As Table
        Dim sSQL As String = ""

        Dim newTable As New Table(1) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

        'create header row
        Dim cell As New Cell(New Phrase("6. Verification", chapterFont)) With {.Header = True, .BackgroundColor = New iTextSharp.text.Color(220, 220, 220)}
        newTable.AddCell(cell)
        newTable.EndHeaders()

        newTable.InsertTable(createVerificationTable(AccountId, strSDA))

        Return newTable
    End Function
    Private Function createNoteSection(ByVal AccountId As Int64) As Table
        Dim sSQL As String = ""

        Dim newTable As New Table(1) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

        'create header row
        Dim cell As New Cell(New Phrase("7. Note/Hardship information", chapterFont)) With {.Header = True, .BackgroundColor = New iTextSharp.text.Color(220, 220, 220)}
        newTable.AddCell(cell)
        newTable.EndHeaders()

        newTable.InsertTable(createNoteTable(AccountId))

        Return newTable
    End Function
    Private Function createNoteTable(ByVal AccountId As Integer) As Table
        Dim table As New Table(2) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = 1, .Width = INT_newTableWidth, .CellsFitPage = True}
        table.TableFitsPage = True
        Dim ssql As String = String.Format("stp_GetClientIntakeInfo {0}", AccountId)
        Dim dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(ssql, ConfigurationManager.AppSettings("connectionstring").ToString)

        Dim fb As iTextSharp.text.Font
        fb = getFont(8, iTextSharp.text.Font.BOLD) 'arial
        Dim fn As iTextSharp.text.Font
        fn = getFont(8, iTextSharp.text.Font.NORMAL) 'arial

        'Dim strls As String = String.Empty
        'Dim strlc As String = String.Empty
        'If Not IsNothing(dt) Then
        '    If dt.Rows.Count > 0 Then
        '        If Not IsDBNull(dt.Rows(0)("Client declined additional legal services?")) Then
        '            strls = dt.Rows(0)("Client declined additional legal services?")
        '        End If
        '        If Not IsDBNull(dt.Rows(0)("Client sent to local counsel?")) Then
        '            strlc = dt.Rows(0)("Client sent to local counsel?")
        '        End If
        '    End If
        'End If

        If Not IsNothing(dt) Then
            If dt.Rows.Count > 0 Then
                table.AddCell(CreateCell(dt.Rows(0)("Note"), fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If
        End If
        Return table

    End Function
    Private Function createVerificationTable(ByVal AccountId As Integer, ByVal strSDA As String) As Table
        Dim table As New Table(3) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = 1, .Width = INT_newTableWidth, .CellsFitPage = True}
        table.TableFitsPage = True
        Dim ssql As String = String.Format("stp_GetClientIntakeInfo {0}", AccountId)
        Dim dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(ssql, ConfigurationManager.AppSettings("connectionstring").ToString)

        Dim fb As iTextSharp.text.Font
        fb = getFont(8, iTextSharp.text.Font.BOLD) 'arial
        Dim fn As iTextSharp.text.Font
        fn = getFont(8, iTextSharp.text.Font.NORMAL) 'arial

        Dim strls As String = String.Empty
        Dim strlc As String = String.Empty
        If Not IsNothing(dt) Then
            If dt.Rows.Count > 0 Then
                If Not IsDBNull(dt.Rows(0)("Client declined additional legal services?")) Then
                    strls = Convert.ToString(dt.Rows(0)("Client declined additional legal services?"))
                End If
                If Not IsDBNull(dt.Rows(0)("Client sent to local counsel?")) Then
                    strlc = Convert.ToString(dt.Rows(0)("Client sent to local counsel?"))
                End If
            End If
        End If

        If Not IsNothing(dt) Then
            If dt.Rows.Count > 0 Then
                table.AddCell(CreateCell("Client declined additional legal services", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell(strls, fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

                If strls = "Yes" Then
                    table.AddCell(CreateCell("Verified by", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell(Convert.ToString(dt.Rows(0)("LegalServicesClient")), fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    'Else
                    '    table.AddCell(CreateCell("", fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                End If

                table.AddCell(CreateCell("Is plaintiff a collection company?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell(strPlaintiff, fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

                table.AddCell(CreateCell("Client sent to local counsel", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell(strlc, fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                If strlc = "Yes" Then
                    table.AddCell(CreateCell("Local counsel fees to be paid by", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell(Convert.ToString(dt.Rows(0)("FeePaid")), fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                Else
                    table.AddCell(CreateCell("", fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                End If

                table.AddCell(CreateCell("SDA Balance", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("$ " & strSDA, fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))


                ' table.AddCell(CreateCell("Notes", fb, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                ' table.AddCell(CreateCell(dt.Rows(0)("Note"), fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))




            End If
        End If
        Return table

    End Function

    Private Function createAssetsInfoTable(ByVal AccountId As Integer) As Table
        Dim table As New Table(4) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = 1, .Width = INT_newTableWidth, .CellsFitPage = True}
        table.TableFitsPage = True
        Dim ssql As String = String.Format("stp_GetClientIntakeInfo {0}", AccountId)
        Dim dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(ssql, ConfigurationManager.AppSettings("connectionstring").ToString)

        Dim fb As iTextSharp.text.Font
        fb = getFont(8, iTextSharp.text.Font.BOLD) 'arial
        Dim fn As iTextSharp.text.Font
        fn = getFont(8, iTextSharp.text.Font.NORMAL) 'arial

        Dim strAss As String = String.Empty
        If Not IsNothing(dt) Then
            If dt.Rows.Count > 0 Then
                If Not IsDBNull(dt.Rows(0)("Do you have other assets?")) Then
                    strAss = dt.Rows(0)("Do you have other assets?")
                End If
            End If
        End If
        table.AddCell(CreateCell("Do you have other assets?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell(strAss, fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

        If strAss = "Yes" Then
            table.AddCell(CreateCell("Assets", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(dt.Rows(0)("Assets"), fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        End If


        Return table

    End Function
    Private Function createRealEstateInfoTable(ByVal AccountId As Integer) As Table
        Dim table As New Table(4) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = 1, .Width = INT_newTableWidth, .CellsFitPage = True}
        table.TableFitsPage = True
        Dim ssql As String = String.Format("stp_GetClientIntakeInfo {0}", AccountId)
        Dim dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(ssql, ConfigurationManager.AppSettings("connectionstring").ToString)

        Dim fb As iTextSharp.text.Font
        fb = getFont(8, iTextSharp.text.Font.BOLD) 'arial
        Dim fn As iTextSharp.text.Font
        fn = getFont(8, iTextSharp.text.Font.NORMAL) 'arial

        Dim strREstate As String = String.Empty
        Dim strPirme1 As String = String.Empty
        Dim strPirme2 As String = String.Empty
        Dim strrent1 As String = String.Empty
        Dim strrent2 As String = String.Empty

        If Not IsNothing(dt) Then
            If dt.Rows.Count > 0 Then
                If Not IsDBNull(dt.Rows(0)("Do you own any real estate?")) Then
                    strREstate = dt.Rows(0)("Do you own any real estate?")
                End If
                If Not IsDBNull(dt.Rows(0)("is this your primary residence1?")) Then
                    strPirme1 = dt.Rows(0)("is this your primary residence1?")
                End If
                If Not IsDBNull(dt.Rows(0)("is this your primary residence2?")) Then
                    strPirme2 = dt.Rows(0)("is this your primary residence2?")
                End If
                If Not IsDBNull(dt.Rows(0)("Is this a rental property1?")) Then
                    strrent1 = dt.Rows(0)("Is this a rental property1?")
                End If
                If Not IsDBNull(dt.Rows(0)("Is this a rental property2?")) Then
                    strrent2 = dt.Rows(0)("Is this a rental property2?")
                End If


            End If
        End If
        table.AddCell(CreateCell("Do you own any real estate?       " & strREstate, fb, 4, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        ' table.AddCell(CreateCell(strREstate, fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

        If strREstate = "Yes" Then
            table.AddCell(CreateCell("Property 1", fb, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("Property 2", fb, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

            'done
            table.AddCell(CreateCell("Is this your primary residence?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(strPirme1, fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

            table.AddCell(CreateCell("Do you own additional property?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(strPirme2, fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

            If strPirme1 = "Yes" Then
                table.AddCell(CreateCell("What year was property purchased?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell(dt.Rows(0)("How long have you owned it1?"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            Else
                table.AddCell(CreateCell("Is this a rental property?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell(strrent1, fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If

            If strPirme2 = "Yes" Then
                table.AddCell(CreateCell("Is second property a rental unit?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell(strrent2, fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            Else
                table.AddCell(CreateCell(" ", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell(" ", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If

            If strPirme1 = "Yes" Then
                table.AddCell(CreateCell("Market value", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                If dt.Rows(0)("Approximate fair market value1") >= 0 Then
                    table.AddCell(CreateCell("$ " & dt.Rows(0)("Approximate fair market value1"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                Else
                    table.AddCell(CreateCell("Unknown", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                End If
            Else
                If strrent1 = "Yes" Then
                    table.AddCell(CreateCell("How much is the rent?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell("$ " & dt.Rows(0)("How much is the rent1?"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                Else
                    table.AddCell(CreateCell("Market value", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                End If
            End If

            If strPirme2 = "Yes" Then
                If strrent2 = "Yes" Then
                    table.AddCell(CreateCell("Monthly income received", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell("$ " & dt.Rows(0)("How much is the rent2?"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                Else

                    table.AddCell(CreateCell("What year was property purchased?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell(dt.Rows(0)("How long have you owned it2?"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                End If
            Else
                table.AddCell(CreateCell("Monthly income received", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If

            If strPirme1 = "Yes" Then
                table.AddCell(CreateCell("Payoff", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("$ " & dt.Rows(0)("What is the payoff1"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            Else
                table.AddCell(CreateCell("Payoff", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If

            If strPirme2 = "Yes" Then
                If strrent2 = "Yes" Then
                    table.AddCell(CreateCell("Market value", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                Else
                    table.AddCell(CreateCell("Market value", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    If dt.Rows(0)("Approximate fair market value2") >= 0 Then
                        table.AddCell(CreateCell("$ " & dt.Rows(0)("Approximate fair market value2"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    Else
                        table.AddCell(CreateCell("Unknown", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    End If
                End If
            Else
                table.AddCell(CreateCell("Market value", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If

            If strPirme1 = "Yes" Then
                table.AddCell(CreateCell("Any liens on property?(Taxes Judgments, etc.)", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell(dt.Rows(0)("Any liens on property1"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            Else
                table.AddCell(CreateCell("Any liens on property?(Taxes Judgments, etc.)", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If
            If strPirme2 = "Yes" Then
                If strrent2 = "Yes" Then
                    table.AddCell(CreateCell("Payoff", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                Else
                    table.AddCell(CreateCell("Payoff", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell("$ " & dt.Rows(0)("What is the payoff2"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                End If
            Else
                table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If

            If strPirme1 = "Yes" Then
                table.AddCell(CreateCell("Mortgage Payment", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("$ " & dt.Rows(0)("Mortgage Payment1"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            Else
                table.AddCell(CreateCell("Mortgage Payment", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If
            If strPirme2 = "Yes" Then
                If strrent2 = "Yes" Then
                    table.AddCell(CreateCell("Any liens on property?(Taxes Judgments, etc.)", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                Else
                    table.AddCell(CreateCell("Any liens on property?(Taxes Judgments, etc.)", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell(dt.Rows(0)("Any liens on property2"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                End If
            Else
                table.AddCell(CreateCell("Any liens on property?(Taxes Judgments, etc.)", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If

            If strPirme1 = "Yes" Then
                table.AddCell(CreateCell("House payment current?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell(dt.Rows(0)("Are you current on house payments1"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            Else
                table.AddCell(CreateCell("House payment current?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If
            If strPirme2 = "Yes" Then
                If strrent2 = "Yes" Then
                    table.AddCell(CreateCell("Mortgage Payment", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                Else
                    table.AddCell(CreateCell("Mortgage Payment", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell("$ " & dt.Rows(0)("Mortgage Payment2"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                End If
            Else
                table.AddCell(CreateCell("Mortgage Payment", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If

            If strPirme1 = "Yes" Then
                table.AddCell(CreateCell("How many people live there?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell(dt.Rows(0)("How many people live there1"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            Else
                table.AddCell(CreateCell("How many people live there?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If
            If strPirme2 = "Yes" Then
                If strrent2 = "Yes" Then
                    table.AddCell(CreateCell("House payment current?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                Else
                    table.AddCell(CreateCell("House payment current?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell(dt.Rows(0)("Are you current on house payments2"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                End If
            Else
                table.AddCell(CreateCell("House payment current?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If
            table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            If strPirme2 = "Yes" Then
                If strrent2 = "Yes" Then
                    table.AddCell(CreateCell("How many people live there?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                Else
                    table.AddCell(CreateCell("How many people live there?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                    table.AddCell(CreateCell(dt.Rows(0)("How many people live there2"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                End If
            Else
                table.AddCell(CreateCell("How many people live there?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If
        Else
            table.AddCell(CreateCell("Is this a rental property?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(strrent1, fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            If strrent1.ToLower = "yes" Then
                table.AddCell(CreateCell("How much is the rent?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
                table.AddCell(CreateCell("$ " & dt.Rows(0)("How much is the rent1?"), fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            End If
        End If

            Return table

    End Function

    Private Function createBankInfoTable(ByVal AccountId As Integer) As Table
        Dim table As New Table(4) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = 1, .Width = INT_newTableWidth, .CellsFitPage = True}
        table.TableFitsPage = True
        Dim ssql As String = String.Format("stp_GetClientIntakeInfo {0}", AccountId)
        Dim dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(ssql, ConfigurationManager.AppSettings("connectionstring").ToString)

        Dim fb As iTextSharp.text.Font
        fb = getFont(8, iTextSharp.text.Font.BOLD) 'arial
        Dim fn As iTextSharp.text.Font
        fn = getFont(8, iTextSharp.text.Font.NORMAL) 'arial

        Dim strAcc As String = String.Empty
        If Not IsNothing(dt) Then
            If dt.Rows.Count > 0 Then
                If Not IsDBNull(dt.Rows(0)("Do you have bank accounts?")) Then
                    strAcc = dt.Rows(0)("Do you have bank accounts?")
                End If
            End If
        End If
        table.AddCell(CreateCell("Is your name on any bank account?      " & strAcc, fb, 4, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        'table.AddCell(CreateCell(strAcc, fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

        If strAcc = "Yes" Then
            table.AddCell(CreateCell("Account 1", fb, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("Account 2", fb, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

            table.AddCell(CreateCell("Name of the bank", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(Convert.ToString(dt.Rows(0)("Name of the bank1")), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("Name of the bank", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(Convert.ToString(dt.Rows(0)("Name of the bank2")), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

            table.AddCell(CreateCell("Source of money deposited in account", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(dt.Rows(0)("Source of money deposited in account1"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("Source of money deposited in account", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(Convert.ToString(dt.Rows(0)("Source of money deposited in account2")), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

            table.AddCell(CreateCell("Approximate balance in account", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("$ " & dt.Rows(0)("Approximate balance in account1"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("Approximate balance in account", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("$ " & Convert.ToString(dt.Rows(0)("Approximate balance in account2")), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

            table.AddCell(CreateCell("Account Type", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(dt.Rows(0)("Account Type1"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("Account Type", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(Convert.ToString(dt.Rows(0)("Account Type2")), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

            table.AddCell(CreateCell("Any current bank levies?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(dt.Rows(0)("Levies1"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("Any current bank levies?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(Convert.ToString(dt.Rows(0)("Levies2")), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))


        End If


        Return table

    End Function
    Private Function createClientInfoTable(ByVal AccountId As Integer, ByVal strFirm As String, ByVal strAccNo As String, ByVal strClientName As String, ByVal strAddress1 As String, ByVal strAddress2 As String, ByVal strPhone As String, ByVal strEmail As String, ByVal strAmount As String) As Table
        Dim table As New Table(6) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = 1, .Width = INT_newTableWidth, .CellsFitPage = True}
        table.TableFitsPage = True
        Dim ssql As String = String.Format("stp_GetClientIntakeInfo {0}", AccountId)
        Dim dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(ssql, ConfigurationManager.AppSettings("connectionstring").ToString)

        Dim fb As iTextSharp.text.Font
        fb = getFont(8, iTextSharp.text.Font.BOLD) 'arial
        Dim fn As iTextSharp.text.Font
        fn = getFont(8, iTextSharp.text.Font.NORMAL) 'arial

        Dim strLD As String = String.Empty
        'Dim strPlaintiff As String = String.Empty
        Dim strDis As String = String.Empty
        Dim strHowDocReceived As String = String.Empty
        Dim strDocReceivedDate As String = String.Empty
        Dim strWhoisPlaintiff As String = String.Empty
        Dim strLanguage As String = String.Empty

        If Not IsNothing(dt) Then
            If dt.Rows.Count > 0 Then
                strLD = dt.Rows(0)("Litigation Document")
                If Not IsDBNull(dt.Rows(0)("Is plaintiff a collection company?")) Then
                    strPlaintiff = dt.Rows(0)("Is plaintiff a collection company?")
                End If
                If Not IsDBNull(dt.Rows(0)("Do you dispute the amount?")) Then
                    strDis = dt.Rows(0)("Do you dispute the amount?")
                End If
                If Not IsDBNull(dt.Rows(0)("How Documents Received")) Then
                    strHowDocReceived = dt.Rows(0)("How Documents Received")
                End If
                If Not IsDBNull(dt.Rows(0)("Date Client Received Document")) Then
                    strDocReceivedDate = dt.Rows(0)("Date Client Received Document") '.ToString("MM/dd/yyyy")
                End If
                If Not IsDBNull(dt.Rows(0)("who is the plantiff?")) Then
                    strWhoisPlaintiff = dt.Rows(0)("who is the plantiff?") '.ToString("MM/dd/yyyy")
                End If
                If Not IsDBNull(dt.Rows(0)("Language")) Then
                    strLanguage = dt.Rows(0)("Language") '.ToString("MM/dd/yyyy")
                End If
            End If
        End If


        table.AddCell(CreateCell("Date", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell(System.DateTime.Now.ToString("MM/dd/yyyy"), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell("Firm", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell(strFirm, fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        'table.AddCell(CreateCell("Client/Account Number", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell("Client/Account No.", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

        Dim clientaccountno As String = strAccNo
        If strAccNo.IndexOf("-") > -1 Then
            clientaccountno = strAccNo.Substring(0, strAccNo.IndexOf("-"))
        End If

        'table.AddCell(CreateCell(strAccNo, fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell(clientaccountno, fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

        table.AddCell(CreateCell("Client Name", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell(strClientName, fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        'table.AddCell(CreateCell("Primary address one", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell("Primary address 1", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

        table.AddCell(CreateCell(strAddress1, fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

        Dim strAddresses() As String = strAddress2.Split(",")
        If strAddresses.Length = 3 Then
            table.AddCell(CreateCell("City", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(strAddresses(0), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("State", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(strAddresses(1), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell("Zip Code", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
            table.AddCell(CreateCell(strAddresses(2), fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        End If

        table.AddCell(CreateCell("Primary Phone", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell(strPhone, fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell("Email", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell(strEmail, fn, 3, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

        table.AddCell(CreateCell("Litigation Document", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell(strLD, fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell("Lawsuit amount", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell(FormatCurrency(strAmount, 2, TriState.False, TriState.False, TriState.True), fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

        table.AddCell(CreateCell("Language?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell(strLanguage, fn, 5, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

        table.AddCell(CreateCell("Date Client Received Document", fb, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell(strDocReceivedDate, fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell("How Documents Received", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        table.AddCell(CreateCell(strHowDocReceived, fn, 2, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))

        'table.AddCell(CreateCell("Do you dispute the amount?", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        'table.AddCell(CreateCell(strDis, fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        ' table.AddCell(CreateCell("", fb, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))
        '  table.AddCell(CreateCell("", fn, 1, Rectangle.BOX, iTextSharp.text.Cell.ALIGN_LEFT))


        Return table

    End Function
    Public Function CreateCell(ByVal StrVal As String, ByVal reqFont As iTextSharp.text.Font, ByVal ColSpan As Int32, ByVal Border As Int32, ByVal Align As Int32) As iTextSharp.text.Cell
        Dim phnData As Phrase = New Phrase(StrVal, reqFont)
        Dim cell As Cell = New Cell(phnData)
        cell.Border = Border
        cell.Colspan = ColSpan
        cell.HorizontalAlignment = Align
        Return cell
    End Function
    Public Function getFont(ByVal size As Int16, ByVal type As Int16) As iTextSharp.text.Font
        Dim fontReq As iTextSharp.text.Font
        fontReq = New Font(iTextSharp.text.Font.HELVETICA, size, type, iTextSharp.text.Color.BLACK)
        Return fontReq
    End Function



#End Region

#Region "Generate PDF of Verification Call"

    Public Shared Function GenerateVerificationCallPdf(ByVal VerificationCallID As Integer, ByVal dtQuestions As DataTable, ByVal dtPersonInfo As DataTable) As String

        Dim pathname As String = ConfigurationManager.AppSettings("leadDocumentsDir").ToString '.Replace("\", "\\")
        Dim pdfName As String = Path.Combine(pathname, "VER" & "_" & VerificationCallID & ".pdf")

        ' the PDF document itself;
        Dim doc As New iTextSharp.text.Document()

        Dim writer As PdfWriter = PdfWriter.GetInstance(doc, New FileStream(pdfName, FileMode.Create))

        doc.SetPageSize(PageSize.LETTER)
        Try
            Dim header As New HeaderFooter(New Phrase("Verification Call", New iTextSharp.text.Font(iTextSharp.text.Font.HELVETICA, 12, Font.BOLDITALIC)), False)
            header.Border = iTextSharp.text.Rectangle.NO_BORDER
            header.Alignment = 1
            doc.Header = header
            doc.Open()

            Dim fd As New ClientFileDocumentHelper

            doc.Add(New Paragraph("Verification #: " & VerificationCallID, fd.fntNormalText))
            doc.Add(New Paragraph("Verified By: " & dtPersonInfo.Rows(0)("VerifiedBy"), fd.fntNormalText))
            doc.Add(New Paragraph("Account #: " & dtPersonInfo.Rows(0)("AccountNumber"), fd.fntNormalText))
            doc.Add(New Paragraph("Date: " & Now.ToString, fd.fntNormalText))
            doc.Add(New Paragraph("Primary Client Name: " & dtPersonInfo.Rows(0)("FullName"), fd.fntNormalText))
            doc.Add(New Paragraph("Call Id: " & dtPersonInfo.Rows(0)("CallIdKey"), fd.fntNormalText))

            ' set table style properties
            Dim newTable As New Table(3) With {.BorderWidth = 1, .BorderColor = New iTextSharp.text.Color(0, 0, 255), .Padding = INT_newTablePadding, .Width = INT_newTableWidth, .CellsFitPage = True}

            ' set *column* widths
            newTable.Widths = New Single() {0.1, 0.8, 0.2}

            ' create the *table* header row
            Dim c As Cell
            For i As Integer = 0 To dtQuestions.Columns.Count - 1
                c = New Cell(New Phrase(dtQuestions.Columns(i).ColumnName.ToString, fd.fntNormalText))
                c.Header = True
                newTable.AddCell(c)
            Next
            newTable.EndHeaders()

            For Each Row As DataRow In dtQuestions.Rows
                For colCnt As Integer = 0 To dtQuestions.Columns.Count - 1
                    newTable.AddCell(New Phrase(Row.Item(colCnt).ToString(), fd.fntNormalText))
                Next
            Next
            doc.Add(newTable)
            doc.NewPage()

            doc.Close()
        Catch ex As Exception
            pdfName = ""
        Finally
            If doc IsNot Nothing Then
                doc.Close()
            End If
        End Try

        Return pdfName
    End Function
#End Region
End Class