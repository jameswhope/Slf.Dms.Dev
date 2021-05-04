<%@ WebHandler Language="VB" Class="clients_client_reports_viewer" %>
Imports LexxiomLetterTemplates

Imports GrapeCity.ActiveReports
Imports GrapeCity.ActiveReports.Export.Pdf

Imports Drg.Util.DataAccess

Imports System
Imports System.Configuration
Imports System.Collections
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Text
Imports System.Web
Imports System.Web.Security
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.WebControls.WebParts
Imports System.Web.UI.HtmlControls

imports System.Threading
Imports ReportsHelper

Public Class clients_client_reports_viewer : Implements IHttpHandler : Implements IReadOnlySessionState

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.Buffer = True

        'get client/user info
        Dim ClientID As Integer = CInt(context.Session("clients_client_reports_clientid"))
        Dim UserID As Integer = CInt(context.Session("clients_client_reports_userid"))

        Dim URL_ReportString As String = ""
        Dim charSeparators() As Char = {"|"c}
        Dim ListOfReportsToPrint() As String

        Dim outStream As New MemoryStream()
        Dim bytes() As Byte
        Dim finalReport As New SectionReport
        Dim rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("ReportConnString"))
        Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing


        If ExtractedReportUrlString(context, URL_ReportString ) = False Then
            Return
        End If

        'split url string to extract reports & args
        ListOfReportsToPrint = URL_ReportString.Split(charSeparators, StringSplitOptions.RemoveEmptyEntries)

        Try
            Dim newReportString As New List(Of String)
            For Each PrintingReport As String In ListOfReportsToPrint
                'get args
                ''append docid to pass to template for barcode
                'Dim docID As String = GetNewDocID
                'newReportString.Add(string.Format("{0}_{1}",PrintingReport,docID))

                Dim aArgs() As String = PrintingReport.Split("_")
                Dim docID As String = aArgs(aArgs.Length - 1)
                ReDim Preserve aArgs(aArgs.Length - 2)
                'run reports
                Select Case aArgs(0).ToUpper
                    Case "NCCONVPKG"
                        rptDoc = rptTemplates.GenerateConversionPackage(ClientID, aArgs(1), UserID, docID)
                    Case Else
                        'main call for reports
                        rptDoc = rptTemplates.ViewTemplate(aArgs(0), ClientID, aArgs, False, UserID, docID)
                End Select

                'save every page in new report document to temp report obj
                finalReport.Document.Pages.AddRange(rptDoc.Pages)
            Next


            'save report to stream to show in viewer
            finalReport.Document.Save(outStream, GrapeCity.ActiveReports.Document.Section.RdfFormat.AR20)
            bytes = New Byte(outStream.Length) {}
            outStream.Seek(0, SeekOrigin.Begin)
            outStream.Read(bytes, 0, outStream.Length)
            context.Response.BinaryWrite(bytes)

        Catch eRunReport As GrapeCity.ActiveReports.ReportException
            context.Trace.Warn("Report failed to run:" + vbCrLf + eRunReport.ToString())
        Catch err As Exception
            context.Trace.Warn("Report failed to run:" + vbCrLf + err.ToString())
        Finally
            context.Response.End()
            outStream.Close()

            bytes = Nothing

            finalReport.Document.Dispose()
            finalReport.Dispose()
            finalReport = Nothing

            rptDoc.Dispose()
            rptDoc = Nothing

            rptTemplates.Dispose()
            rptTemplates = Nothing

        End Try


    End Sub


    Private Shared Function ExtractedReportUrlString(ByVal context As HttpContext, ByRef URL_ReportString As String) As Boolean
        ExtractedReportUrlString = True
        If Not IsNothing(context.Session("clients_client_reports_reports")) Then
            'get reports
            URL_ReportString = CStr(context.Session("clients_client_reports_reports"))
            'remove not needed info
            URL_ReportString = URL_ReportString.Replace("chkClient|", "").Replace("chkCreditor|", "").Replace("chkPackage|", "")
            'if no reports exit sub
            If URL_ReportString.ToString = "" Then ExtractedReportUrlString = false
        Else
            'if no reports exit sub
            ExtractedReportUrlString = false
        End If

        Return ExtractedReportUrlString
    End Function
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class
