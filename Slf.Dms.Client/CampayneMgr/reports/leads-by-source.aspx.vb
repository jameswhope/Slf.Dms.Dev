Imports System.Data
Imports AnalyticsHelper
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.IO

Partial Class admin_leads_by_source
    Inherits System.Web.UI.Page

    Private _totalLeads As Integer = 0
    Private _totalDials As Integer = 0
    Private _totalContacted As Integer = 0
    Private _totalLeadsSold As Integer = 0
    Private _totalSold As Integer = 0
    <System.Web.Services.WebMethod()> _
    <System.Web.Script.Services.ScriptMethod()> _
    Public Shared Function PM_getData(ByVal dataType As String, ByVal dataIdentifier As String, ByVal fromDate As String, ByVal toDate As String) As String

        Dim dd As New App_Code.DetailData
        Dim sbTbl As New StringBuilder
        Dim sqlData As String = "stp_LeadStatsBySource_detail"
        Dim params As New List(Of SqlParameter)
        Dim di As String() = dataIdentifier.Split(New Char() {":"}, StringSplitOptions.RemoveEmptyEntries)

        Try
            params.Add(New SqlParameter("type", dataType))
            params.Add(New SqlParameter("affiliate", di(0)))
            params.Add(New SqlParameter("source", di(1)))
            params.Add(New SqlParameter("from", fromDate))
            params.Add(New SqlParameter("to", toDate & " 23:59"))

            dd.GridCaption = dataType
            Using dtData As DataTable = SqlHelper.GetDataTable(sqlData, CommandType.StoredProcedure, params.ToArray)
                dd.GridCaption = String.Format("<b>Type:</b> {0}&nbsp;&nbsp;<b>Filter:</b> {1}&nbsp;&nbsp;<b>Total Record(s):</b> {2}", dataType.ToUpper, dataIdentifier, dtData.Rows.Count)
                Dim gv As New GridView
                gv.CssClass = ""
                gv.ID = "gvDetailData"
                gv.RowStyle.Font.Size = New FontUnit(8)
                gv.AutoGenerateColumns = False
                For Each dc As DataColumn In dtData.Columns
                    Dim bc As New BoundField
                    bc.DataField = dc.ColumnName
                    bc.HeaderText = dc.ColumnName
                    bc.SortExpression = dc.ColumnName
                    If dc.ColumnName.ToLower = "fullname" Then
                        bc.HeaderStyle.Wrap = False

                    ElseIf dc.ColumnName.ToLower.Contains("created") Then
                        bc.DataFormatString = "{0:d}"
                        bc.ItemStyle.HorizontalAlign = HorizontalAlign.Center
                    ElseIf dc.ColumnName.ToLower.Contains("count") Then
                        bc.HeaderStyle.HorizontalAlign = HorizontalAlign.Center
                        bc.ItemStyle.HorizontalAlign = HorizontalAlign.Center
                    End If
                    bc.ItemStyle.Wrap = False
                    bc.HeaderStyle.CssClass = "headitem"
                    bc.ItemStyle.CssClass = "griditem"
                    bc.HeaderStyle.Font.Size = New FontUnit(8)
                    bc.ItemStyle.Font.Size = New FontUnit(8)
                    gv.Columns.Add(bc)
                Next

                gv.DataSource = dtData
                gv.DataBind()
                dd.GridviewData = ControlToHTML(gv)
            End Using
        Catch ex As Exception
            dd.GridCaption = "ERROR"
            dd.GridviewData = String.Format("<p>{0}</p>", ex.Message.ToString)
        End Try

     


        Return jsonHelper.SerializeObjectIntoJson(dd)
    End Function
    Private Shared Function ControlToHTML(ByVal ctl As Control) As String
        Dim SB As New StringBuilder()
        Dim SW As New StringWriter(SB)
        Dim htmlTW As New HtmlTextWriter(SW)
        ctl.RenderControl(htmlTW)
        Return SB.ToString()
    End Function
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            SetDates()
            LoadReport()
        End If
    End Sub

    Private Sub SetDates()
        'This week
        txtDate1.Text = Now.ToString("M/d/yy")
        txtDate2.Text = Now.ToString("M/d/yy")

        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("M/d/yy") & "," & Now.ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("M/d/yy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("M/d/yy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("M/d/yy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("M/d/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("M/d/yy") & "," & Now.AddDays(-1).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("M/d/yy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("M/d/yy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("M/d/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("M/d/yy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("M/d/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = 0
    End Sub

    Private Sub LoadReport()
        Try
            ds_LeadsBySource.SelectParameters("from").DefaultValue = txtDate1.Text
            ds_LeadsBySource.SelectParameters("to").DefaultValue = txtDate2.Text & " 23:59"
            ds_LeadsBySource.DataBind()
            gvLeadsBySource.DataBind()
        Catch ex As Exception
            LeadHelper.LogError("Leads By Source", ex.Message, ex.StackTrace)
        End Try
    End Sub

    Protected Sub btnApply_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnApply.Click
        LoadReport()
    End Sub

    Protected Sub gvLeadsBySource_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvLeadsBySource.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
            If e.Row.RowState = DataControlRowState.Alternate Then
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
            Else
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
            End If

            Dim row As DataRowView = TryCast(e.Row.DataItem, DataRowView)
            _totalLeads += CInt(row("leads"))
            _totalDials += CInt(row("dials"))
            _totalContacted += CInt(row("contacted"))
            _totalLeadsSold += CInt(row("leads_sold"))
            _totalSold += CInt(row("total_sold"))

            'add cell click event
            e.Row.Cells(2).Style("cursor") = "pointer"
            e.Row.Cells(7).Style("cursor") = "pointer"
            e.Row.Cells(9).Style("cursor") = "pointer"
            Dim dataArgs As String = String.Format("{0}:{1}", row(0).ToString, row(1).ToString)
            e.Row.Cells(2).Attributes.Add("onclick", String.Format("ShowDetailData('leads','{0}')", dataArgs))
            e.Row.Cells(7).Attributes.Add("onclick", String.Format("ShowDetailData('contacted','{0}')", dataArgs))
            e.Row.Cells(9).Attributes.Add("onclick", String.Format("ShowDetailData('sold','{0}')", dataArgs))

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(2).Text = _totalLeads
            e.Row.Cells(3).Text = "100 %"
            e.Row.Cells(4).Text = _totalDials
            e.Row.Cells(7).Text = _totalContacted
            e.Row.Cells(8).Text = FormatPercent(_totalContacted / _totalLeads, 1)
            e.Row.Cells(9).Text = _totalLeadsSold
            e.Row.Cells(10).Text = FormatPercent(_totalLeadsSold / _totalContacted, 1)
            e.Row.Cells(11).Text = _totalSold
        End If
    End Sub
    

  
End Class
