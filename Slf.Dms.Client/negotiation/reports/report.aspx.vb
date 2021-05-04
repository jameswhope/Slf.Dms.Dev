Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.Reporting
Imports Microsoft.Reporting.WebForms
Imports System.IO
Imports System.Drawing.Printing
Imports System.Drawing.Imaging
Imports System.Collections.Generic

Partial Class negotiation_reports_report
    Inherits System.Web.UI.Page
    Private settlementID As String


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim reportType As String = "PDF"
        Dim mimeType As String = "application/pdf"
        Dim encoding As String = ""
        Dim fileNameExtension As String = "PDF"
        Dim deviceInfo As String = "<DeviceInfo>" + " <OutputFormat>PDF</OutputFormat>" + " <PageWidth>8.5in</PageWidth>" + " <PageHeight>11in</PageHeight>" + " <MarginTop>0.5in</MarginTop>" + " <MarginLeft>1in</MarginLeft>" + " <MarginRight>1in</MarginRight>" + " <MarginBottom>0.5in</MarginBottom>" + "</DeviceInfo>"
        Dim warnings As Warning() = Nothing
        Dim streams As String() = Nothing
        Dim renderedBytes As Byte()

        If Not IsPostBack Then
            settlementID = Request.QueryString("sid")

            Dim dtSett As New DataTable
            Using saTemp = New SqlDataAdapter("stp_GetSettlementAcceptanceFormData " & settlementID, System.Configuration.ConfigurationManager.AppSettings("connectionstring"))
                saTemp.fill(dtSett)


                Dim lReport As New LocalReport
                lReport.ReportPath = "negotiation/reports/SettlementAcceptanceForm.rdlc"

                'get params
                Dim params(0) As ReportParameter
                params(0) = New ReportParameter("SettlementID", settlementID)

                Try

                    lReport.SetParameters(params)
                    Dim datasource As ReportDataSource = New ReportDataSource("dsReportData", dtSett)
                    lReport.DataSources.Clear()
                    lReport.DataSources.Add(datasource)

                    'Render the report 
                    renderedBytes = lReport.Render(reportType, deviceInfo, "application/pdf", encoding, fileNameExtension, streams, warnings)

                Catch ex As Exception

                End Try

                dtSett.Dispose()
                dtSett = Nothing
            End Using



            'Clear the response stream and write the bytes to the outputstream 
            'Set content-disposition to "attachment" so that user is prompted to take an action 
            'on the file (open or save) 

            Response.Clear()
            Response.ContentType = "application/pdf"
            'Response.AddHeader("content-disposition", "attachment; filename=SettlementAcceptanceForm." + fileNameExtension)
            Me.imgProc.Style("display") = "none"


            Response.BinaryWrite(renderedBytes)
            Response.Flush()
            Response.End()
        End If
    End Sub
End Class
