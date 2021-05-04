<%@ WebHandler Language="VB" Class="container" %>

Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports GrapeCity.ActiveReports
Imports GrapeCity.ActiveReports.Export.Pdf
Imports GrapeCity.ActiveReports.Export.Html
Imports GrapeCity.ActiveReports.Export.Rtf
Imports GrapeCity.ActiveReports.Export.Text

Imports System
Imports System.Web
Imports System.Data
Imports System.Data.SqlClient
Imports System.Reflection
Imports System.Collections
Imports System.Collections.Generic

Public Class container : Implements IHttpHandler : Implements IReadOnlySessionState

    Private strRpts() As String
    Private strLog As New StringBuilder()

    Private Function LoadReport(ByVal name As String) As ActiveReport3
        If Not name Is Nothing Then
            Dim a As Assembly = Assembly.Load("Slf.Dms.Reports")

            If Not a Is Nothing Then
                Dim t As Type = a.GetType(name)

                If Not t Is Nothing Then
                    Dim c As ConstructorInfo = t.GetConstructor(Type.EmptyTypes)
                    Dim o As Object = c.Invoke(Nothing)
                                                                      
                    a = Nothing
                    t = Nothing
                    c = Nothing
                    
                    Return TryCast(o, ActiveReport3)
                End If
            End If
        End If

        Return Nothing
    End Function
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim report As ActiveReport3
        
        'get the reports string array
        strRpts = context.Request.QueryString("rpt").Split(",")
        
        'get the actual report array
        Dim reports As List(Of ActiveReport3) = New List(Of ActiveReport3)
        
        For Each strRpt As String In strRpts
            report = LoadReport("Slf.Dms.Reports." & strRpt)
            reports.Add(report)
            
            report.Document.Dispose()
            report.Dispose()
        Next
        
        'clean up the reports string array for filename use
        For i As Integer = 0 To strRpts.Length - 1
            Dim str() As String = strRpts(i).Split(".")
            strRpts(i) = str.GetValue(str.Length - 1)
        Next
        
        If Not reports.Count = 0 AndAlso Not reports(0) Is Nothing Then
            Output(context, reports, DataHelper.Nz(context.Request.QueryString("f"), "html"), _
                DataHelper.Nz_bool(context.Request.QueryString("d")))
        Else
            context.Response.Clear()
            context.Response.Write("<h1>Could not find report!</h1>")
        End If
        
        '08.15.07.UG  Changed variable name from Report to tempRpt to prevent conflicting names
        For Each tRpt As ActiveReport3 In reports
            tRpt.Document.Dispose()
            tRpt.Dispose()
            tRpt = Nothing
        Next
        
        reports.Clear()
        reports = Nothing
    End Sub
    
    Private Sub RunReport(ByVal context As HttpContext, ByVal report As ActiveReport3, ByVal strReport As String)
        If Not context.Session("rptcmd_" + strReport) Is Nothing Then
            Using cmd As IDbCommand = CommandHelper.DeepClone(CType(context.Session("rptcmd_" + strReport), IDbCommand))
                strLog.Append("<br>Running " & report.GetType.Name & "<br>&nbsp;&nbsp;&nbsp;&nbsp;Sproc " & cmd.CommandText)
                Dim myParams As New List(Of SqlParameter)
                                
                For Each pm As SqlParameter In cmd.Parameters
                    myParams.Add(New SqlParameter(pm.ParameterName, pm.Value))
                Next

                Using dt As DataTable = SqlHelper.GetDataTable(cmd.CommandText, cmd.CommandType, myParams.ToArray)
                    report.DataSource.ds = dt
                    report.DataSource = dt
                    report.Run(False)
                End Using
                
                'Using cmd.Connection
                '    cmd.Connection.Open()

                '    Using rd As IDataReader = cmd.ExecuteReader
                '        report.DataSource = rd
                '        report.Run(False)
                '    End Using
                'End Using
            End Using
        Else
            report.Run(False)
        End If
    End Sub
    
    Private Sub Output(ByVal context As HttpContext, ByVal reports As List(Of ActiveReport3), ByVal format As String, ByVal booDownload As Boolean)
        Try
            RunReport(context, reports(0), strRpts(0))
            
            If reports.Count > 1 Then
                For i As Integer = 1 To reports.Count - 1
                    RunReport(context, reports(i), strRpts(i))
                    
                    'add the pages to first report
                    For j As Integer = 0 To reports(i).Document.Pages.Count - 1
                        reports(0).Document.Pages.Insert(reports(0).Document.Pages.Count, reports(i).Document.Pages.Item(j))
                    Next
                Next
            End If
            
            Select Case format.ToString()
                Case "html"
                    OutputHtml(context, reports(0), booDownload)
                Case "pdf"
                    OutputPdf(context, reports(0), booDownload)
                Case "rtf"
                    OutputRTF(context, reports(0), booDownload)
                Case "txt"
                    OutputTXT(context, reports(0), booDownload)
            End Select
        Catch ex As Exception
            context.Response.Clear()
            context.Response.Write("<h1>Error running report:</h1>")
            context.Response.Write(ex.ToString())
            context.Response.Write("<br>-------------------------------<br>")
            context.Response.Write(strLog.ToString())
        End Try
    End Sub
    
    Private Sub OutputHtml(ByVal context As HttpContext, ByVal rpt As ActiveReport3, ByVal booDownload As Boolean)
        Using html As HtmlExport = New HtmlExport
            If booDownload Then
                Using m_stream As System.IO.MemoryStream = New System.IO.MemoryStream
                    html.Export(rpt.Document, m_stream)

                    context.Response.AddHeader("Content-Disposition", "attachment;filename=" & strRpts(0) & ".htm")

                    context.Response.ContentType = "text/html"
                    context.Response.BinaryWrite(m_stream.GetBuffer())
                End Using
            Else
                html.Export(rpt.Document, New ReportHtmlOutputter(context), "")
            End If
        End Using
    End Sub
    
    Private Sub OutputTXT(ByVal context As HttpContext, ByVal rpt As ActiveReport3, ByVal booDownload As Boolean)
        Using m_stream As New System.IO.MemoryStream
            Using txt As TextExport = New TextExport
                txt.Export(rpt.Document, m_stream)

                If booDownload Then
                    context.Response.AddHeader("Content-Disposition", "attachment;filename=" & strRpts(0) & ".txt")
                End If

                context.Response.ContentType = "text/html"
                context.Response.BinaryWrite(m_stream.GetBuffer())
            End Using
        End Using
    End Sub
    Private Sub OutputRTF(ByVal context As HttpContext, ByVal rpt As ActiveReport3, ByVal booDownload As Boolean)
        Using m_stream As New System.IO.MemoryStream
            Using rtf As RtfExport = New RtfExport
                rtf.Export(rpt.Document, m_stream)

                If booDownload Then
                    context.Response.AddHeader("Content-Disposition", "attachment;filename=" & strRpts(0) & ".rtf")
                End If

                context.Response.ContentType = "application/msword"
                context.Response.BinaryWrite(m_stream.GetBuffer())
            End Using
        End Using
    End Sub
    
    Private Sub OutputPdf(ByVal context As HttpContext, ByVal rpt As ActiveReport3, ByVal booDownload As Boolean)
        Using m_stream As New System.IO.MemoryStream
            Using pdf As PdfExport = New PdfExport
                pdf.Export(rpt.Document, m_stream)

                If booDownload Then
                    context.Response.AddHeader("Content-Disposition", "attachment;filename=" & strRpts(0) & ".pdf")
                End If

                context.Response.ContentType = "application/pdf"
                context.Response.BinaryWrite(m_stream.GetBuffer)
            End Using
        End Using
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class