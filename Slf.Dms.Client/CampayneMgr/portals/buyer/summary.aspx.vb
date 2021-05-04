Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Services

Imports AnalyticsHelper

Partial Class portals_buyer_Summary
    Inherits System.Web.UI.Page

#Region "Fields"

    Private _userid As Integer

#End Region 'Fields

#Region "Properties"

    Public Property FromDate() As String
        Get
            If String.IsNullOrEmpty(txtFrom.Text) Then
                txtFrom.Text = Now.ToString("MM/dd/yyyy")
            End If
            Return txtFrom.Text
        End Get
        Set(ByVal value As String)
            txtFrom.Text = value
        End Set
    End Property

    Public Property ToDate() As String
        Get
            If String.IsNullOrEmpty(txtTo.Text) Then
                txtTo.Text = Now.ToString("MM/dd/yyyy")
            End If
            Return txtTo.Text
        End Get
        Set(ByVal value As String)
            txtTo.Text = value
        End Set
    End Property

    Public Property Userid() As Integer
        Get
            Return _userid
        End Get
        Set(ByVal value As Integer)
            _userid = value
        End Set
    End Property

#End Region 'Properties

#Region "Methods"

    <WebMethod()> _
    Public Shared Function getChartData(userid As String, contractid As String) As String
        Dim result As New List(Of Array)
        Dim ssql As String = "stp_buyer_getLeadsPerDayCount"

        Dim c As System.Globalization.Calendar

        Dim fromdate As String = String.Format("{0} 12:00 AM", FormatDateTime(DateAdd(DateInterval.Day, -Now.DayOfWeek, Now), DateFormat.ShortDate))
        Dim todate As String = String.Format("{0} 11:59 PM", FormatDateTime(DateAdd(DateInterval.Day, 6 - Now.DayOfWeek, Now), DateFormat.ShortDate))

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("userid", userid))
        params.Add(New SqlParameter("from", fromdate))
        params.Add(New SqlParameter("to", todate))
        If Not String.IsNullOrEmpty(contractid) Then
            params.Add(New SqlParameter("ContractID", contractid))
        End If

        Dim dayList As New Hashtable
        For i As Integer = 0 To 6
            dayList.Add(DateAdd(DateInterval.Day, i, CDate(fromdate)).DayOfWeek.ToString, Nothing)
        Next

        Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)
            For Each dr As DataRow In dt.Rows
                Dim ldata As New List(Of String)
                Dim dname As String = CDate(dr("submittedDate").ToString).DayOfWeek.ToString
                If dayList.ContainsKey(dname) Then
                    dayList.Remove(dname)
                End If
                ldata.Add(String.Format("{0}", dname))
                ldata.Add(String.Format("{0}", dr("total").ToString))
                result.Add(ldata.ToArray)
            Next
        End Using

        For Each d As DictionaryEntry In dayList
            Dim ldata As New List(Of String)
            ldata.Add(String.Format("{0}", d.Key))
            ldata.Add(String.Format("{0}", 0))
            result.Add(ldata.ToArray)
        Next

        Return Newtonsoft.Json.JsonConvert.SerializeObject(result) 'jsonHelper.SerializeObjectIntoJson(result)
    End Function

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
                gv.DataBind()
            End If
        End Using
    End Sub

    Protected Sub gvLeadSummary_PreRender(sender As Object, e As System.EventArgs) Handles gvLeadSummary.PreRender
        GridViewHelper.AddJqueryUI(gvLeadSummary)
    End Sub

    Protected Sub gvLeadSummary_RowCreated(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvLeadSummary.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvLeadSummary, e.Row, Me.Page)

        End Select
    End Sub

    Protected Sub lnkGetCounts_Click(sender As Object, e As System.EventArgs) Handles lnkGetCounts.Click
        BindData()
    End Sub

    Protected Sub portals_buyer_Default_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Userid = CInt(Page.User.Identity.Name)
        If Not IsPostBack Then
            SetDates()

            BindData()


        End If
    End Sub
    


    Private Sub BindData()
        dsLeadSummary.SelectParameters("userid").DefaultValue = Userid
        dsLeadSummary.SelectParameters("from").DefaultValue = String.Format("{0} 12:00 AM", txtFrom.Text)
        dsLeadSummary.SelectParameters("to").DefaultValue = String.Format("{0} 11:59 PM", txtTo.Text)
        dsLeadSummary.DataBind()
        gvLeadSummary.DataBind()
        GetSummaryRow()

        dsContracts.SelectParameters("userid").DefaultValue = Userid
        dsContracts.DataBind()
    End Sub
    Private Sub GetSummaryRow()
        For i As Integer = 0 To gvLeadSummary.Columns.Count - 1
            gvLeadSummary.Columns(i).FooterText = ConfigurationManager.AppSettings("SummaryFooterText").ToString
        Next
        Using dv As DataView = dsLeadSummary.Select(DataSourceSelectArguments.Empty)
            Using dt As DataTable = dv.ToTable
                If dt.Rows.Count > 0 Then
                    gvLeadSummary.Columns(3).FooterText = dt.Compute("sum(delivered)", Nothing).ToString
                    gvLeadSummary.Columns(4).FooterText = FormatCurrency(dt.Compute("sum(total)", Nothing).ToString, 2)
                End If
            End Using
        End Using

    End Sub
    Private Sub SetDates()
        'This week
        FromDate = Now.ToString("MM/dd/yyyy")
        ToDate = Now.ToString("MM/dd/yyyy")

        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yyyy") & "," & Now.ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yyyy") & "," & Now.AddDays(-1).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = 0
    End Sub

#End Region 'Methods

End Class