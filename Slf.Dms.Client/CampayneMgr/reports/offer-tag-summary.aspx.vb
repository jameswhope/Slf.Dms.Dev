Imports AnalyticsHelper
Imports System.Data

Partial Class reports_offer_tag_summary
    Inherits System.Web.UI.Page

    Private _totalNew As Double
    Private _totalRevisit As Double
    Private _totalRev As Double

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            SetDates()
            LoadReport()
        End If
    End Sub

    Private Sub SetDates()
        'Today
        txtDate1.Text = "04/01/2012" 'Now.ToString("M/d/yyyy")
        txtDate2.Text = "04/15/2012" 'Now.ToString("M/d/yyyy")

        ddlQuickPickDate.Items.Clear()
        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("M/d/yyyy") & "," & Now.AddDays(-1).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("M/d/yyyy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("M/d/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("M/d/yyyy")))
        'ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("M/d/yyyy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("M/d/yyyy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("M/d/yyyy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("M/d/yyyy")))
        'ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("M/d/yyyy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("M/d/yyyy")))
        'ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = 0
    End Sub

    Private Sub LoadReport()
        gvTags.DataSource = OfferHelper.GetOfferTagSummary(txtDate1.Text, txtDate2.Text, txtTime1.Text, txtTime2.Text)
        gvTags.DataBind()
    End Sub

    Protected Sub btnApply_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnApply.Click
        LoadReport()
    End Sub

    Protected Sub gvTags_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvTags.DataBound
        Dim row As New GridViewRow(-1, -1, DataControlRowType.Header, DataControlRowState.Normal)
        Dim table As Table = DirectCast(gvTags.Controls(0), Table)
        Dim hdr As TableRow = table.Rows(0)
        Dim cell As TableHeaderCell

        cell = New TableHeaderCell
        cell.Text = "&nbsp;"
        cell.CssClass = "headitem3"
        row.Cells.Add(cell)

        cell = New TableHeaderCell
        cell.Text = "New Leads"
        cell.CssClass = "headitem3"
        cell.HorizontalAlign = HorizontalAlign.Center
        cell.ColumnSpan = 4
        row.Cells.Add(cell)

        cell = New TableHeaderCell
        cell.Text = "Revisits"
        cell.CssClass = "headitem3"
        cell.HorizontalAlign = HorizontalAlign.Center
        cell.ColumnSpan = 4
        row.Cells.Add(cell)

        cell = New TableHeaderCell
        cell.Text = "All"
        cell.CssClass = "headitem2"
        cell.HorizontalAlign = HorizontalAlign.Center
        cell.ColumnSpan = 4
        row.Cells.Add(cell)

        table.Controls.AddAt(0, row)
    End Sub

    Protected Sub gvTags_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvTags.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
            If e.Row.RowState = DataControlRowState.Alternate Then
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
            Else
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
            End If

            Dim row As DataRowView = TryCast(e.Row.DataItem, DataRowView)
            _totalNew += Val(row("newreceived"))
            _totalRevisit += Val(row("revisitreceived"))
            _totalRev += Val(row("received"))

            e.Row.Cells(0).Attributes.Add("onclick", String.Format("return ShowOffers('{0}');", row("tag")))
            e.Row.Cells(0).Style("cursor") = "pointer"

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            'e.Row.Cells(0).Text = "*"
            'e.Row.Cells(0).Style("text-align") = "left"
            'For i As Integer = 1 To e.Row.Cells.Count - 2
            '    e.Row.Cells(i).Text = "*"
            '    e.Row.Cells(i).Style("text-align") = "right"
            'Next
            e.Row.Cells(4).Text = FormatCurrency(_totalNew)
            e.Row.Cells(8).Text = FormatCurrency(_totalRevisit)
            e.Row.Cells(12).Text = FormatCurrency(_totalRev)
        End If
    End Sub

    <System.Web.Services.WebMethod()> _
    Public Shared Function ClickReport(ID As Integer, StartDate As String, EndDate As String, Tag As String) As String
        Dim FolderPath As String = ConfigurationManager.AppSettings("PublisherDocumentPath")
        Dim fileName As String = String.Format("{0}_{1}.csv", ID, StartDate.Replace("/", ""))
        Dim lnkPath As String = String.Format("../pub/docs/{0}", fileName)
        Dim actualFilePath As String = (String.Format("{0}{1}", FolderPath, fileName))
        Dim result As String
        Dim connStr As SqlHelper.ConnectionString = SqlHelper.ConnectionString.IDENTIFYLEDB
        Dim params As New List(Of SqlClient.SqlParameter)
        Dim sql As String

        params.Add(New SqlClient.SqlParameter("from", StartDate))
        params.Add(New SqlClient.SqlParameter("to", EndDate))
        If Tag.ToLower.Equals("online") Then
            params.Add(New SqlClient.SqlParameter("offerid", ID))
            sql = "stp_ClickReportOnline"
        Else
            params.Add(New SqlClient.SqlParameter("campaignid", ID))
            sql = "stp_ClickReportLeadConv"
        End If

        If Not CDate(StartDate).Equals(Today) Then
            connStr = SqlHelper.ConnectionString.IDENTIFYLEWHSE
        End If

        Using dt As DataTable = SqlHelper.GetDataTable(sql, CommandType.StoredProcedure, params.ToArray, connStr)
            PortalHelper.CreateDownloadFile(actualFilePath, dt)
        End Using

        result = "<a class=""downFile"" href=""{0}"" target=""_blank"" style=""color:#fff; text-decoration:underline;"">Download</a>"
        result += "<br/><br/>Right-click the link above and choose ""Save target as..."""
        result = String.Format(result, lnkPath)

        Return result
    End Function

    <System.Web.Services.WebMethod()> _
    Public Shared Function DeleteTempFiles(tempfile As String) As String
        Dim result As String = String.Empty
        Try
            Dim idx As Integer = tempfile.LastIndexOf("/")
            Dim fname As String = tempfile.Substring(idx + 1)
            Dim FolderPath As String = ConfigurationManager.AppSettings("PublisherDocumentPath")
            IO.File.Delete(String.Format("{0}{1}", FolderPath, fname))
        Catch ex As Exception
            'get mad
        End Try

        Return result
    End Function

End Class
