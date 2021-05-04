Imports System.Data

Partial Class reports_emailstats
    Inherits System.Web.UI.Page
    <System.Web.Services.WebMethod()> _
    Public Shared Function GetDailyBySite(ByVal reportingdate As String) As String
        Dim result As String = String.Empty
        Dim ssql As String = "select v.Website,count(distinct ers.LeadID) [Sent], count(distinct eml.EmailAddress) [Returned] "
        ssql += ",[Return %]=cast((cast(count(distinct eml.EmailAddress) AS float)/cast(count(distinct ers.LeadID)  as float))*100 as numeric(18,2)) "
        ssql += "from tblLeads l WITH(NOLOCK) "
        ssql += "inner join tblVisits v WITH(NOLOCK) on l.VisitID = v.VisitID "
        ssql += "LEFT JOIN tblEmailResultSent ers WITH(NOLOCK) ON l.LeadID = ers.LeadID "
        ssql += "left join tblEmailMonitorLog eml WITH(NOLOCK) ON eml.EmailAddress = l.Email "
        ssql += "where(repid = -1) "
        ssql += String.Format("and datediff(d,ers.Created,'{0}')=0 ", reportingdate)
        ssql += "group BY v.Website "
        ssql += "order by count(distinct ers.LeadID) desc"

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)

            Dim gv As New GridView
            gv.Width = New Unit("100%")
            gv.CssClass = "GridViewHoverStyle"
            gv.HeaderStyle.CssClass = "ui-widget-header"
            gv.RowStyle.CssClass = "ui-widget-content"
            gv.RowStyle.HorizontalAlign = HorizontalAlign.Center
            gv.DataSource = dt
            gv.DataBind()

            result = AdminHelper.ControlToHTML(gv)

        End Using

        Return result 'jsonHelper.SerializeObjectIntoJson(result)
    End Function
    <System.Web.Services.WebMethod()> _
    Public Shared Function GetDailyBreakDown(ByVal reportingdate As String) As String
        Dim result As String = String.Empty
        Dim ssql As String = "select convert(varchar,ers.Created,101)[Sent Date],count(distinct ers.LeadID) [Sent], count(distinct eml.EmailAddress) [Returned] "
        ssql += ",[Return %]=cast((cast(count(distinct eml.EmailAddress) AS float)/cast(count(distinct ers.LeadID)  as float))*100 as numeric(18,2)) "
        ssql += "from tblLeads l WITH(NOLOCK)  "
        ssql += "inner join tblVisits v WITH(NOLOCK) on l.VisitID = v.VisitID "
        ssql += "LEFT JOIN tblEmailResultSent ers WITH(NOLOCK) ON l.LeadID = ers.LeadID "
        ssql += "left join tblEmailMonitorLog eml WITH(NOLOCK) ON eml.EmailAddress = l.Email "
        ssql += "where (repid = -1) "
        ssql += "and datediff(d,ers.Created,getdate())< 7 "
        ssql += "group BY convert(varchar,ers.Created,101) "
        ssql += "order by convert(varchar,ers.Created,101) desc "

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
            
            Dim gv As New GridView
            gv.Width = New Unit("100%")
            gv.CssClass = "GridViewHoverStyle"
            gv.HeaderStyle.CssClass = "ui-widget-header"
            gv.RowStyle.CssClass = "ui-widget-content"
            gv.RowStyle.HorizontalAlign = HorizontalAlign.Center
            gv.DataSource = dt
            gv.DataBind()

            result = AdminHelper.ControlToHTML(gv)
            
        End Using

        Return result 'jsonHelper.SerializeObjectIntoJson(result)
    End Function
    <System.Web.Services.WebMethod()> _
    Public Shared Function GetEmailStatisticsChartData(ByVal reportingdate As String) As String
        Dim result As New List(Of String)
        Dim ssql As String = String.Format("stp_email_stats_SentReturned '{0}'", reportingdate)

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
            Dim cats As New List(Of String)
            Dim ts As New List(Of String)
            Dim tr As New List(Of String)
            Dim tp As New List(Of String)
            For Each dr As DataRow In dt.Rows
                cats.Add(dr("website").ToString)
                ts.Add(dr("totalsent").ToString)
                tr.Add(dr("totalreturned").ToString)
                tp.Add(dr("returnPCT").ToString)
            Next
            result.Add(String.Format("Categories:{0}", Join(cats.ToArray, ",")))
            result.Add(String.Format("TotalSent:{0}", Join(ts.ToArray, ",")))
            result.Add(String.Format("TotalReturned:{0}", Join(tr.ToArray, ",")))
            result.Add(String.Format("ReturnPct:{0}", Join(tp.ToArray, ",")))
        End Using

        Return Newtonsoft.Json.JsonConvert.SerializeObject(result) 'jsonHelper.SerializeObjectIntoJson(result)
    End Function
    Protected Sub reports_emailstats_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            txtDate1.Text = FormatDateTime(Now, DateFormat.ShortDate)
        End If

    End Sub
End Class
