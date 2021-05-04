Imports Microsoft.VisualBasic
Imports iTextSharp
Imports System.Data
Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports System.Drawing
Imports System.IO

Public Class BillingHelper
    'Public fntNormalText As iTextSharp.text.Font = FontFactory.GetFont(FontFactory.HELVETICA, 8, iTextSharp.text.Font.NORMAL)
    'Public Shared Function CreateStatement(invoiceid As String) As String
    '    Dim statementPath As String = String.Format("docs/{0}.pdf", Guid.NewGuid.ToString)
    '    Dim docStatement As New Document(PageSize.LETTER)
    '    PdfWriter.GetInstance(docStatement, New FileStream(HttpContext.Current.Server.MapPath(statementPath), FileMode.Create))
    '    docStatement.Open()

    '    docStatement.Add(New Paragraph("My first PDF"))

    '    docStatement.Close()


    '    Return statementPath
    'End Function
    'Private Function createTextTable(dtOfData As DataTable) As PdfPTable
    '    Dim sSQL As String = ""

    '    ' set table style properties
    '    Dim newTable As New iTextSharp.text.pdf.PdfPTable(dtOfData.Columns.Count)

    '    ' set *column* widths
    '    Dim colWidth As Single() = {0.1, 0.1, 0.2, 0.6}
    '    newTable.SetWidths(colWidth)

    '    ' create the *table* header row
    '    For i As Integer = 0 To dtOfData.Columns.Count - 1
    '        Dim Cell As New PdfPCell(New Phrase(dtOfData.Columns(i).ColumnName.ToString, fntNormalText))
    '        Cell.BackgroundColor = New iTextSharp.text.BaseColor(255, 255, 255)
    '        newTable.AddCell(Cell)
    '    Next

    '    For Each Row As DataRow In dtOfData.Rows
    '        For colCnt As Integer = 0 To dtOfData.Columns.Count - 1
    '            newTable.AddCell(New Phrase(Row.Item(colCnt).ToString(), fntNormalText))
    '        Next
    '    Next

    '    Return newTable
    'End Function
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
End Class
