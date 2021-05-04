Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.IO
Imports Drg.Util.DataAccess

Public Class FilterSelection
    Private _Name As String
    Private _FromDate As String
    Private _ToDate As String

    Public Property FilterName() As String
        Get
            Return _Name
        End Get
        Set(ByVal value As String)
            _Name = value
        End Set
    End Property

    Public Property FromDate() As String
        Get
            Return _FromDate
        End Get
        Set(ByVal value As String)
            _FromDate = value
        End Set
    End Property

    Public Property ToDate() As String
        Get
            Return _ToDate
        End Get
        Set(ByVal value As String)
            _ToDate = value
        End Set
    End Property

End Class

Partial Class Clients_Enrollment_BoydMockup
    Inherits System.Web.UI.Page

    Private _agencyId As Integer
    Private _commrecid As Integer
    Private _allAgencies As String
    Private _allUsers As String

#Region "Page Event Handlers"

    Protected Sub btnExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        'Dim gvLeads As GridView
        ' Dim lblFilter As Label
        Dim filename As String = "IncomeFromAgencies.csv"

        Dim sw As StringWriter = New StringWriter

        sw.WriteLine("Report Date: {0:g}", Now)

        'If lvLeads.Items.Count = 1 Then
        '    sw.WriteLine("Date Range: {0:d}  -  {1:d}", txtDate1.Text, txtDate2.Text)
        'End If

        sw.WriteLine()

        'Dim rexp As New Regex("<br/>")

        'For Each l As ListViewDataItem In lvLeads.Items

        '    lblFilter = l.FindControl("lblFilter")
        '    sw.Write(rexp.Replace(lblFilter.Text, " "))

        '    sw.Write(Environment.NewLine)

        'gvLeads = l.FindControl("gvLeads")
        'For i As Integer = 0 To gvLeads.Columns.Count - 1
        '    sw.Write(rexp.Replace(gvLeads.Columns(i).HeaderText, " ") & ",")
        'Next
        'sw.Write(Environment.NewLine)

        For Each row As GridViewRow In gvLeads.Rows
            If row.RowType = DataControlRowType.DataRow Then
                For i As Integer = 0 To row.Cells.Count - 1
                    If row.Cells(i).Controls.Count = 0 Then
                        sw.Write(row.Cells(i).Text.Replace(",", String.Empty).Replace("&nbsp;", String.Empty) & ",")
                    Else
                        sw.Write(CType(row.Cells(i).Controls(0), DataBoundLiteralControl).Text.Trim.Replace(",", String.Empty).Replace("&nbsp;", String.Empty) & ",")
                    End If
                Next
                sw.Write(Environment.NewLine)
            End If
        Next

        'If Not gvLeads.FooterRow Is Nothing AndAlso gvLeads.FooterRow.Cells.Count > 0 Then
        '    For i As Integer = 0 To gvLeads.FooterRow.Cells.Count - 1
        '        sw.Write(gvLeads.FooterRow.Cells(i).Text.Replace(",", String.Empty).Replace("&nbsp;", String.Empty) & ",")
        '    Next
        'End If

        sw.Write(Environment.NewLine)

        'Next

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.AddHeader("content-disposition", String.Format("attachment; filename={0}", filename))
        HttpContext.Current.Response.ContentType = "text/csv"
        HttpContext.Current.Response.Write(sw.ToString)
        HttpContext.Current.Response.End()
    End Sub

    Public Sub btnFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilter.Click

        LoadLeads(gvLeads, txtDate1.Text, txtDate2.Text)

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        _agencyId = DataHelper.FieldLookup("tbluser", "agencyid", String.Format("userid={0}", DataHelper.Nz_int(Page.User.Identity.Name)))
        _commrecid = DataHelper.FieldLookup("tbluser", "commrecid", String.Format("userid={0}", DataHelper.Nz_int(Page.User.Identity.Name)))

        If Not IsPostBack Then
            SetDates()
            SetAgencies()
            SetUsers()
            LoadLeads(gvLeads, txtDate1.Text, txtDate2.Text)
        End If

        txtDate1.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        txtDate2.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        imgDate1.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        imgDate2.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower = "by month", "none", "inline")
        ddlMonthYear1.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower <> "by month", "none", "inline")
        ddlMonthYear2.Style("Display") = IIf(ddlQuickPickDate.SelectedItem.Text.ToLower <> "by month", "none", "inline")
    End Sub

#End Region

#Region "Private Routines"

    Private Sub LoadLeads(ByVal gvLeads As GridView, ByVal FromDate As String, ByVal ToDate As String)
        Try
            Dim params2 As New List(Of SqlParameter)
            Dim procname As String = "stp_FixedFeeProjections"
            params2.Add(New SqlParameter("commrecid", _commrecid))

            Dim ds As DataSet
            ds = SqlHelper.GetDataSet(procname, CommandType.StoredProcedure, params2.ToArray)

            ' Create a Table.
            Dim dt As New DataTable
            Dim index As Integer = 0
            Dim DefaultCommRecName As String = ""

            Dim ind1 As Double = 0, ind2 As Double = 0, ind3 As Double = 0, ind4 As Double = 0, ind5 As Double = 0, ind6 As Double = 0
            Dim ind7 As Double = 0, ind8 As Double = 0, ind9 As Double = 0, ind10 As Double = 0, ind11 As Double = 0, ind12 As Double = 0

            dt.Columns.Add("Sub-Servicer", GetType(String))
            dt.Columns.Add("Month 1", GetType(Double))
            dt.Columns.Add("Month 2", GetType(Double))
            dt.Columns.Add("Month 3", GetType(Double))
            dt.Columns.Add("Month 4", GetType(Double))
            dt.Columns.Add("Month 5", GetType(Double))
            dt.Columns.Add("Month 6", GetType(Double))
            dt.Columns.Add("Month 7", GetType(Double))
            dt.Columns.Add("Month 8", GetType(Double))
            dt.Columns.Add("Month 9", GetType(Double))
            dt.Columns.Add("Month 10", GetType(Double))
            dt.Columns.Add("Month 11", GetType(Double))
            dt.Columns.Add("Month 12", GetType(Double))

            For Each rw As DataRow In ds.Tables(0).Rows
                If index = 0 Then
                    index += 1
                    DefaultCommRecName = rw("CommRecName").ToString
                End If

                If rw("CommRecName").ToString = DefaultCommRecName Then
                    Select Case CInt(rw("Months").ToString)
                        Case 1
                            ind1 = CDbl(rw("Amount").ToString)
                        Case 2
                            ind2 = CDbl(rw("Amount").ToString)
                        Case 3
                            ind3 = CDbl(rw("Amount").ToString)
                        Case 4
                            ind4 = CDbl(rw("Amount").ToString)
                        Case 5
                            ind5 = CDbl(rw("Amount").ToString)
                        Case 6
                            ind6 = CDbl(rw("Amount").ToString)
                        Case 7
                            ind7 = CDbl(rw("Amount").ToString)
                        Case 8
                            ind8 = CDbl(rw("Amount").ToString)
                        Case 9
                            ind9 = CDbl(rw("Amount").ToString)
                        Case 10
                            ind10 = CDbl(rw("Amount").ToString)
                        Case 11
                            ind11 = CDbl(rw("Amount").ToString)
                        Case 12
                            ind12 = CDbl(rw("Amount").ToString)
                    End Select
                Else
                    dt.Rows.Add(DefaultCommRecName, ind1, ind2, ind3, ind4, ind5, ind6, ind7, ind8, ind9, ind10, ind11, ind12)
                    DefaultCommRecName = rw("CommRecName").ToString
                    index = 1
                    ResetValues(ind1, ind2, ind3, ind4, ind5, ind6, ind7, ind8, ind9, ind10, ind11, ind12)
                End If
                ' Add four entries.
            Next
            dt.Rows.Add(DefaultCommRecName, ind1, ind2, ind3, ind4, ind5, ind6, ind7, ind8, ind9, ind10, ind11, ind12)

            gvLeads.DataSource = dt
            gvLeads.DataBind()

        Catch ex As Exception
            'LeadHelper.LogError("Debt Analysis", ex.Message, ex.StackTrace)
        End Try
    End Sub

    Private Sub ResetValues(ByRef ind1 As Double, ByRef ind2 As Double, ByRef ind3 As Double, ByRef ind4 As Double, _
                                                    ByRef ind5 As Double, ByRef ind6 As Double, ByRef ind7 As Double, ByRef ind8 As Double, _
                                                    ByRef ind9 As Double, ByRef ind10 As Double, ByRef ind11 As Double, ByRef ind12 As Double)
        ind1 = 0
        ind2 = 0
        ind3 = 0
        ind4 = 0
        ind5 = 0
        ind6 = 0
        ind7 = 0
        ind8 = 0
        ind9 = 0
        ind10 = 0
        ind11 = 0
        ind12 = 0
    End Sub

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
        ddlQuickPickDate.SelectedIndex = ddlQuickPickDate.Items.Count - 9

    End Sub

    Private Sub SetAgencies()

        ddlAgency.Items.Add(New System.Web.UI.WebControls.ListItem("All Agencies", -1))
        ddlAgency.SelectedIndex = 0

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("CommRecId", _commrecid))

        Dim dt As DataTable

        dt = SqlHelper.GetDataTable("stp_GetChildCommRecIds", CommandType.StoredProcedure, params.ToArray)

        _allAgencies += ""
        For Each rw As DataRow In dt.Rows
            _allAgencies += rw("CommRecid").ToString + ","
            ddlAgency.Items.Add(New System.Web.UI.WebControls.ListItem(rw("display"), rw("CommRecid")))
        Next
        _allAgencies.Remove(_allAgencies.Length - 1)
        hdnAgencies.Value = _allAgencies
    End Sub

    Private Sub SetUsers()

        ddlUser.Items.Clear()
        ddlUser.Items.Add(New System.Web.UI.WebControls.ListItem("All Users", -1))
        ddlUser.SelectedIndex = 0

        Dim selectedAgency As String = ""
        If ddlAgency.SelectedValue = -1 Then
            selectedAgency = hdnAgencies.Value
        Else
            selectedAgency = ddlAgency.SelectedValue
        End If

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("CommRecIds", selectedAgency))

        Dim dt As DataTable
        dt = SqlHelper.GetDataTable("stp_GetUsersFromCommRecIds", CommandType.StoredProcedure, params.ToArray)

        For Each rw As DataRow In dt.Rows
            _allUsers += rw("UserId").ToString + ","
            ddlUser.Items.Add(New System.Web.UI.WebControls.ListItem(rw("SalesName"), rw("UserId")))
        Next
        _allUsers.Remove(_allUsers.Length - 1)
        hdnUsers.Value = _allUsers
    End Sub

#End Region

#Region "Public Routines"

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

#End Region

    Protected Sub ddlAgency_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlAgency.SelectedIndexChanged
        SetUsers()
    End Sub

End Class
