Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://CampayneMgr.com/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
<System.Web.Script.Services.ScriptService()> _
Public Class PortalService
    Inherits System.Web.Services.WebService

#Region "Methods"
    <WebMethod()> _
    Public Function CreateCSVForDownload(csvargs As PortalHelper.downloadArgs) As String

        Dim result As String = "<a class=""downFile"" href=""{0}"" target=""_blank"" style=""color:blue; text-decoration:underline;"">Download</a>"
        result += "<br/>Right-click the link and choose ""Save Link As..."""

        Try
            Dim ssql As String = String.Empty
            Dim params As New List(Of SqlParameter)
            Dim typeDownload As String = String.Empty
            Dim removeCols As New List(Of String)
            Select Case csvargs.DownloadType
                Case 0 'DailySummaryReport
                    typeDownload = "DailySummaryReport"
                    ssql = "stp_affiliate_getDailySummaryReport"
                    params.Add(New SqlParameter("UserID", csvargs.DataArguments(0)))
                    params.Add(New SqlParameter("Offer", IIf(String.IsNullOrEmpty(csvargs.DataArguments(1)), DBNull.Value, csvargs.DataArguments(1))))
                    params.Add(New SqlParameter("Campaign", IIf(String.IsNullOrEmpty(csvargs.DataArguments(2)), DBNull.Value, csvargs.DataArguments(2))))
                    params.Add(New SqlParameter("from", csvargs.DataArguments(3)))
                    params.Add(New SqlParameter("to", csvargs.DataArguments(4)))
                    removeCols.Add("Conv_pct")
                    removeCols.Add("epc")
                Case 1  'SubAffiliateSummaryReport
                    typeDownload = "SubAffiliateSummaryReport"
                    ssql = "stp_affiliate_getSubAffiliateSummaryReport"
                    params.Add(New SqlParameter("UserID", csvargs.DataArguments(0)))
                    params.Add(New SqlParameter("Offer", IIf(String.IsNullOrEmpty(csvargs.DataArguments(1)), DBNull.Value, csvargs.DataArguments(1))))
                    params.Add(New SqlParameter("Campaign", IIf(String.IsNullOrEmpty(csvargs.DataArguments(2)), DBNull.Value, csvargs.DataArguments(2))))
                    params.Add(New SqlParameter("from", csvargs.DataArguments(3)))
                    params.Add(New SqlParameter("to", csvargs.DataArguments(4)))
                    removeCols.Add("clicks")
                    removeCols.Add("Conv_pct")
                    removeCols.Add("epc")
                Case 2  'ConversionReport
                    typeDownload = "ConversionReport"
                    ssql = "stp_affiliate_getConversionReport"
                    params.Add(New SqlParameter("UserID", csvargs.DataArguments(0)))
                    params.Add(New SqlParameter("Offer", IIf(String.IsNullOrEmpty(csvargs.DataArguments(1)), DBNull.Value, csvargs.DataArguments(1))))
                    params.Add(New SqlParameter("Campaign", IIf(String.IsNullOrEmpty(csvargs.DataArguments(2)), DBNull.Value, csvargs.DataArguments(2))))
                    params.Add(New SqlParameter("from", csvargs.DataArguments(3)))
                    params.Add(New SqlParameter("to", csvargs.DataArguments(4)))
                Case 3  'ClickReport
                    typeDownload = "ClickReport"
                    ssql = "stp_affiliate_getClickReport"
                    params.Add(New SqlParameter("UserID", csvargs.DataArguments(0)))
                    params.Add(New SqlParameter("Offer", IIf(String.IsNullOrEmpty(csvargs.DataArguments(1)), DBNull.Value, csvargs.DataArguments(1))))
                    params.Add(New SqlParameter("Campaign", IIf(String.IsNullOrEmpty(csvargs.DataArguments(2)), DBNull.Value, csvargs.DataArguments(2))))
                    params.Add(New SqlParameter("from", csvargs.DataArguments(3)))
                    params.Add(New SqlParameter("to", csvargs.DataArguments(4)))
                Case 4 'download unsubscribe
                    ssql = "stp_portals_GetUnsubscribeData"
                    If Not String.IsNullOrEmpty(csvargs.DataArguments(0)) Then
                        params.Add(New SqlParameter("userid", csvargs.DataArguments(0)))
                        If Not String.IsNullOrEmpty(csvargs.DataArguments(1)) Then
                            params.Add(New SqlParameter("website", csvargs.DataArguments(1)))
                        End If

                    End If
                Case 5  'stp_buyer_getLeadReport
                    typeDownload = "LeadReport"
                    ssql = "stp_buyer_getLeadReport"
                    params.Add(New SqlParameter("userid", csvargs.DataArguments(0)))
                    params.Add(New SqlParameter("from", String.Format("{0} 12:00 AM", csvargs.DataArguments(1))))
                    params.Add(New SqlParameter("to", String.Format("{0} 11:59 PM", csvargs.DataArguments(2))))
            End Select

            Dim FolderPath As String = ConfigurationManager.AppSettings("PortalDocumentPath")
            Dim fileName As String = String.Format("{0}_{1}.csv", Guid.NewGuid.ToString, typeDownload)
            Dim lnkPath As String = String.Format("../../docs/{0}", fileName)
            Dim actualFilePath As String = (String.Format("{0}{1}", FolderPath, fileName))

            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)

                If removeCols.Count > 0 Then
                    For Each col As String In removeCols
                        dt.Columns.Remove(col)
                    Next
                End If

                PortalHelper.CreateDownloadFile(actualFilePath, dt)
            End Using
            result = String.Format(result, lnkPath)
        Catch ex As Exception
            result = ex.Message
        End Try

        Return result
    End Function
    <WebMethod()> _
    Public Function DeleteTempFiles(tempfile As String) As String
        Dim result As String = String.Empty
        Try
            Dim idx As Integer = tempfile.LastIndexOf("/")
            Dim fname As String = tempfile.Substring(idx + 1)
            Dim FolderPath As String = ConfigurationManager.AppSettings("PortalDocumentPath")

            File.Delete(String.Format("{0}{1}", FolderPath, fname))
        Catch ex As Exception

        End Try

        Return result
    End Function

    <WebMethod()> _
    Public Function GetNotifications(userid As String) As String
        Dim result As String = String.Empty
        Try
            Dim notices As List(Of PortalHelper.PortalNotification) = PortalHelper.GetPortalNofications(userid)
            For Each pn As PortalHelper.PortalNotification In notices
                Dim icn As String = ""
                Select Case pn.NotificationType
                    Case PortalHelper.PortalNotification.enumTypeNotification.pnError
                        icn = "error"
                    Case PortalHelper.PortalNotification.enumTypeNotification.pnWarning
                        icn = "info"
                    Case Else
                        icn = "lightbulb"
                End Select

                Dim strMsg As String = String.Format("{0}", pn.NotificationText)
                Dim divNotice As String = "<div class=""ui-widget""><div class=""ui-state-highlight ui-corner-all"" style=""margin-top: 20px; padding: 0 .7em;"">"
                divNotice += String.Format("<p><span class=""ui-icon ui-icon-info"" style=""float: left; margin-right: .3em;""></span>{0}</p>", strMsg)
                divNotice += String.Format("<a href=""#"" onclick=""MarkAsRead('{0}',this);"" style=""display:block;text-align:right;"">Mark as Read</a>", pn.NotificationID)
                divNotice += "</div></div>"
                result += divNotice
            Next

            If notices.Count = 0 Then
                Dim divNotice As String = "<div class=""ui-widget""><div class=""ui-state-highlight ui-corner-all"" style=""margin-top: 20px; padding: 0 .7em;"">"
                divNotice += String.Format("<p><span class=""ui-icon ui-icon-info"" style=""float: left; margin-right: .3em;""></span>{0}</p>", "None at this time.")
                'divNotice += String.Format("<a href=""#"" onclick=""MarkAsRead('{0}',this);"" style=""display:block;text-align:right;"">Mark as Read</a>", -1)
                divNotice += "</div></div>"
                result += divNotice
            End If
        Catch ex As Exception
            result = ex.Message.ToString
        End Try

        Return result
    End Function

    <WebMethod()> _
    Public Function LoadMetricData(userid As String) As String
        Dim result As String = String.Empty

        Try
            Dim ssql As String = "stp_affiliate_getDailySummaryReport"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("UserID", userid))
            params.Add(New SqlParameter("from", String.Format("{0} 12:00 AM", FormatDateTime(Now, DateFormat.ShortDate))))
            params.Add(New SqlParameter("to", String.Format("{0} 11:59 PM", FormatDateTime(Now, DateFormat.ShortDate))))
            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)
                Dim newDt As New DataTable
                newDt.Columns.Add("Clicks")
                newDt.Columns.Add("Conversions")
                newDt.Columns.Add("conv_pct")
                newDt.Columns.Add("Revenue")
                If dt.Rows.Count > 0 Then
                    For Each dr As DataRow In dt.Rows
                        Dim nr As DataRow = newDt.NewRow
                        nr("clicks") = dr("clicks").ToString
                        nr("conversions") = dr("conversions").ToString
                        nr("conv_pct") = FormatPercent(dr("conv_pct").ToString, 2)
                        nr("revenue") = FormatCurrency(dr("revenue").ToString, 2)
                        newDt.Rows.Add(nr)
                        Exit For
                    Next
                Else
                    Dim nr As DataRow = newDt.NewRow
                    nr("clicks") = 0
                    nr("conversions") = 0
                    nr("conv_pct") = FormatPercent(0, 2)
                    nr("revenue") = FormatCurrency(0, 2)
                    newDt.Rows.Add(nr)
                End If
                

                newDt.TableName = "AffiliateQuickMetric"
                result = jsonHelper.ConvertDataTableToJSON(newDt)
            End Using

        Catch ex As Exception
            result = ex.Message.ToString
        End Try

        Return result
    End Function

    <WebMethod()> _
    Public Function MarkAsRead(notificationid As String, userid As String) As String
        Dim result As String = String.Empty
        Dim iCnt As Integer = 1
        Try
            result = "Marked as Read!"
            PortalHelper.PortalNotification.MarkAsRead(notificationid, userid)
        Catch ex As Exception
            result = ex.Message.ToString
        End Try

        Return result
    End Function

#End Region 'Methods

End Class