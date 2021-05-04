Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Net
Imports System.Web.Services

Imports DataManagerHelper
Imports System.Web.Script.Serialization
Imports AdminHelper
Imports BuyerHelper
Imports AnalyticsHelper

Partial Class reports_debtanalysis
    Inherits System.Web.UI.Page

#Region "Methods"

    Private Sub SetDates()
        txtDate1.Text = Now.ToString("M/d/yyyy")
        txtDate2.Text = Now.ToString("M/d/yyyy")
        ddlQuickPickDate.Items.Clear()
        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("M/d/yyyy") & "," & Now.AddDays(-1).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("M/d/yyyy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("M/d/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("M/d/yyyy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("M/d/yyyy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last 30 days", RoundDate(Now.AddDays(-30), -1, DateUnit.Day).ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last 60 days", RoundDate(Now.AddDays(-60), -1, DateUnit.Day).ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last 90 days", RoundDate(Now.AddDays(-90), -1, DateUnit.Day).ToString("M/d/yyyy") & "," & Now.ToString("M/d/yyyy")))
        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = 0
    End Sub

    Public Sub SetPagerButtonStates(ByVal gridView As GridView, ByVal gvPagerRow As GridViewRow, ByVal page As Page)
        Dim pageIndex As Integer = gridView.PageIndex
        Dim pageCount As Integer = gridView.PageCount

        Dim btnFirst As LinkButton = TryCast(gvPagerRow.FindControl("btnFirst"), LinkButton)
        Dim btnPrevious As LinkButton = TryCast(gvPagerRow.FindControl("btnPrevious"), LinkButton)
        Dim btnNext As LinkButton = TryCast(gvPagerRow.FindControl("btnNext"), LinkButton)
        Dim btnLast As LinkButton = TryCast(gvPagerRow.FindControl("btnLast"), LinkButton)
        Dim lblNumber As Label = TryCast(gvPagerRow.FindControl("lblNumber"), Label)

        lblNumber.Text = pageCount.ToString()

        btnFirst.Enabled = btnPrevious.Enabled = (pageIndex <> 0)
        btnLast.Enabled = btnNext.Enabled = (pageIndex < (pageCount - 1))

        btnPrevious.Enabled = (pageIndex <> 0)
        btnNext.Enabled = (pageIndex < (pageCount - 1))

        If btnNext.Enabled = False Then
            btnNext.Attributes.Remove("CssClass")
        End If
        Dim ddlPageSelector As DropDownList = DirectCast(gvPagerRow.FindControl("ddlPageSelector"), DropDownList)
        ddlPageSelector.Items.Clear()

        For i As Integer = 1 To gridView.PageCount
            ddlPageSelector.Items.Add(i.ToString())
        Next

        ddlPageSelector.SelectedIndex = pageIndex

        'Used delegates over here
        AddHandler ddlPageSelector.SelectedIndexChanged, AddressOf pageSelector_SelectedIndexChanged
    End Sub

    Public Sub pageSelector_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        Using gv As GridView = ddl.Parent.Parent.Parent.Parent
            If Not IsNothing(gv) Then
                gv.PageIndex = ddl.SelectedIndex
            End If
        End Using
    End Sub

    Protected Sub reports_debtanalysis_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            SetDates()
        End If
    End Sub

    Private Function GetLeads() As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("FromDate", txtDate1.Text))
        params.Add(New SqlParameter("ToDate", txtDate2.Text & " 23:59"))
        params.Add(New SqlParameter("AdvertiserId", ddlAdvertisers.SelectedValue))

        Dim dts As New DataTable
        dts.Columns.Add("value", GetType(Int32))

        If ddlAffiliates.SelectedValue = 0 Then
            For Each itm As ListItem In ddlAffiliates.Items
                If CInt(itm.Value) > 0 Then dts.Rows.Add(New Object() {CInt(itm.Value)})
            Next
            params.Add(New SqlParameter("AffiliateIds", dts))
        Else
            dts.Rows.Add(New Object() {CInt(ddlAffiliates.SelectedValue)})
            Dim param As New SqlParameter("AffiliateIds", SqlDbType.Structured)
            param.Value = dts
            params.Add(param)
        End If

        Dim dt As DataTable
        If CDate(txtDate1.Text) >= Date.Today.AddDays(-7) Then
            dt = SqlHelper.GetDataTable("stp_reports_debtanalysis_cid2", CommandType.StoredProcedure, params.ToArray)
        Else
            dt = SqlHelper.GetDataTable("stp_reports_debtanalysis_cid2", CommandType.StoredProcedure, params.ToArray, SqlHelper.ConnectionString.IDENTIFYLEWHSE)
        End If
        Return dt
    End Function

    Private Sub LoadReport()
        Try
            gvLeads.DataSource = GetLeads()
            gvLeads.DataBind()
        Catch ex As Exception
            LeadHelper.LogError("Debt Analysis", ex.Message, ex.StackTrace)
        End Try
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        LoadReport()
    End Sub

    Protected Sub gvLeads_PageIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvLeads.PageIndexChanged
        Session("CurrentLeadPageIdx") = gvLeads.PageIndex
    End Sub

    Protected Sub gvLeads_PageIndexChanging(sender As Object, e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvLeads.PageIndexChanging
        gvLeads.PageIndex = e.NewPageIndex
        LoadReport()
    End Sub

    Protected Sub gvLeads_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvLeads.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvLeads, e.Row, Me.Page)
        End Select
    End Sub

    Protected Sub gvLeads_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvLeads.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
                If e.Row.RowState = DataControlRowState.Alternate Then
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
                Else
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If
        End Select
    End Sub

    Protected Sub gvLeads_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs)
        If ViewState("sortOrder") = "ASC" Then
            ViewState("sortOrder") = "DESC"
        Else
            ViewState("sortOrder") = "ASC"
        End If

        Dim dv As New DataView(GetLeads)
        dv.Sort = e.SortExpression & " " & ViewState("sortOrder")
        gvLeads.DataSource = dv
        gvLeads.DataBind()
    End Sub

    Public Shared Function RoundDate(ByVal d As DateTime, ByVal Direction As Integer, ByVal Unit As DateUnit) As DateTime
        Dim result As DateTime = d

        If Unit = DateUnit.Week Then
            If Direction = 1 Then
                While Not result.DayOfWeek = DayOfWeek.Saturday
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.DayOfWeek = DayOfWeek.Sunday
                    result = result.AddDays(-1)
                End While
            Else
                If result.DayOfWeek = DayOfWeek.Wednesday Or result.DayOfWeek = DayOfWeek.Thursday Or result.DayOfWeek = DayOfWeek.Friday Then
                    While Not result.DayOfWeek = DayOfWeek.Saturday
                        result = result.AddDays(1)
                    End While
                ElseIf result.DayOfWeek = DayOfWeek.Monday Or result.DayOfWeek = DayOfWeek.Tuesday Then
                    While Not result.DayOfWeek = DayOfWeek.Sunday
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        ElseIf Unit = DateUnit.Month Then
            If Direction = 1 Then
                While Not result.Day = Date.DaysInMonth(result.Year, result.Month)
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.Day = 1
                    result = result.AddDays(-1)
                End While
            Else
                Dim DaysInMonth As Integer = Date.DaysInMonth(result.Year, result.Month)
                Dim Midpoint As Integer = DaysInMonth / 2

                If result.Day >= Midpoint And result.Day < DaysInMonth Then
                    While Not result.Day = DaysInMonth
                        result = result.AddDays(1)
                    End While
                ElseIf result.Day < Midpoint And result.Day > 1 Then
                    While Not result.Day = 1
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        ElseIf Unit = DateUnit.Year Then
            Dim DaysInYear As Integer
            For i As Integer = 1 To 12
                DaysInYear += Date.DaysInMonth(result.Year, i)
            Next
            If Direction = 1 Then
                While Not result.DayOfYear = DaysInYear
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.DayOfYear = 1
                    result = result.AddDays(-1)
                End While
            Else
                Dim Midpoint As Integer = DaysInYear / 2

                If result.DayOfYear >= Midpoint And result.DayOfYear < DaysInYear Then
                    While Not result.DayOfYear = DaysInYear
                        result = result.AddDays(1)
                    End While
                ElseIf result.DayOfYear < Midpoint And result.DayOfYear > 1 Then
                    While Not result.DayOfYear = 1
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        End If

        Return result
    End Function

    Private Sub DisableAffilates()
        ddlAffiliates.Items.Insert(0, New ListItem("Select Affiliate...", "-1"))
        ddlAffiliates.Enabled = False
    End Sub

    Private Sub GetAffiliates(AdvertiserId As Integer)
        ddlAffiliates.Items.Clear()

        If AdvertiserId = -1 Then
            DisableAffilates()
        Else
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("AdvertiserId", AdvertiserId))
            ddlAffiliates.Items.Clear()
            ddlAffiliates.DataSource = SqlHelper.GetDataTable("stp_reports_debtanalysis_getaffiliates", CommandType.StoredProcedure, params.ToArray)
            ddlAffiliates.DataBind()

            ddlAffiliates.Enabled = True
            Select Case ddlAffiliates.Items.Count
                Case 0
                    DisableAffilates()
                Case 1
                    'DO Nothing
                Case Else
                    ddlAffiliates.Items.Insert(0, New ListItem("All", "0"))
            End Select

        End If

    End Sub

#End Region 'Methods

    Protected Sub btnFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilter.Click
        LoadReport()
    End Sub

    Protected Sub btnExport_Click(sender As Object, e As System.EventArgs) Handles lnkExport.Click
        Dim dt As DataTable = GetLeads()
        Dim filename As String = "DebtAnalysis.csv"

        Dim sw As StringWriter = New StringWriter

        sw.WriteLine("Report Date: {0:g}", Now)
        sw.WriteLine("Advertiser: {0}", ddlAdvertisers.SelectedItem.Text.Replace(",", String.Empty))
        sw.WriteLine("Affiliate: {0}", ddlAffiliates.SelectedItem.Text.Replace(",", String.Empty))
        sw.WriteLine("Date Range: {0:d}  -  {1:d}", txtDate1.Text, txtDate2.Text)
        sw.WriteLine()

        For i As Integer = 1 To dt.Columns.Count - 1
            sw.Write(dt.Columns(i).ColumnName & ",")
        Next
        sw.Write(Environment.NewLine)

        For Each row As DataRow In dt.Rows
            For i As Integer = 1 To dt.Columns.Count - 1
                sw.Write(row(i).ToString().Replace(",", String.Empty) & ",")
            Next
            sw.Write(Environment.NewLine)
        Next

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.AddHeader("content-disposition", String.Format("attachment; filename={0}", filename))
        HttpContext.Current.Response.ContentType = "text/csv"
        HttpContext.Current.Response.Write(sw.ToString)
        HttpContext.Current.Response.End()
    End Sub

    Protected Sub ddlAdvertisers_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlAdvertisers.SelectedIndexChanged
        GetAffiliates(ddlAdvertisers.SelectedValue)
    End Sub
End Class