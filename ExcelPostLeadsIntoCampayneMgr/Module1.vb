Imports Microsoft.Office.Interop.Excel

Module Module1

    Sub Main()
        ''Global Varibles

        'Create An Application
        Dim excelFile As Application = New Application

        'Open Excel SpreadSheet
        Dim totalWorksheets As Workbook = excelFile.Workbooks.Open("Location of File")

        'For each sheet puul all data
        For i As Integer = 1 To totalWorksheets.Sheets.Count

            'Isolated sheet
            Dim sheet As Worksheet = totalWorksheets.Sheets(i)


        Next




    End Sub

End Module
