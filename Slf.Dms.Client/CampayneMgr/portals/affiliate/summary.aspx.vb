Imports System.Data

Imports AnalyticsHelper
Imports System.Web.Services
Imports System.Data.SqlClient

Partial Class portals_affiliate_Summary
    Inherits System.Web.UI.Page

#Region "Fields"

    Private Userid As Integer
    Private gridSummary As New Hashtable

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

#End Region 'Properties

#Region "Methods"
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

    Protected Sub btnFilter_Click(sender As Object, e As System.EventArgs) Handles btnFilter.Click
        'dsTraffic.SelectParameters("userid").DefaultValue = Userid
        'dsTraffic.SelectParameters("from").DefaultValue = String.Format("{0} 0:00 AM", txtFrom.Text)
        'dsTraffic.SelectParameters("to").DefaultValue = String.Format("{0} 11:59 PM", txtTo.Text)
        'dsTraffic.DataBind()
        'gvTraffic.DataBind()
        BindData()
    End Sub

    Protected Sub gvTraffic_PreRender(sender As Object, e As System.EventArgs) Handles gvTraffic.PreRender
        GridViewHelper.AddJqueryUI(gvTraffic)
    End Sub

    Protected Sub gvTraffic_RowCreated(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvTraffic.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvTraffic, e.Row, Me.Page)
        End Select
    End Sub

    Protected Sub gvTraffic_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvTraffic.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowview As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                GridViewHelper.addHandOnHover(e)
        End Select
    End Sub

    Protected Sub portals_affiliate_Default_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Userid = Page.User.Identity.Name
        If Not IsPostBack Then
            SetDates()
            BindData()
        End If
    End Sub
    Private Sub BindData()
        dsTraffic.SelectParameters("userid").DefaultValue = Userid
        dsTraffic.SelectParameters("from").DefaultValue = String.Format("{0} 12:00 AM", txtFrom.Text)
        dsTraffic.SelectParameters("to").DefaultValue = String.Format("{0} 11:59 PM", txtTo.Text)
        dsTraffic.DataBind()

        gvTraffic.DataBind()

        GetSummaryRow()

    End Sub
    Private Sub GetSummaryRow()
        gvTraffic.Columns(0).FooterStyle.HorizontalAlign = HorizontalAlign.Left
        gvTraffic.Columns(0).FooterText = "TOTAL"
        Using dv As DataView = dsTraffic.Select(DataSourceSelectArguments.Empty)
            Using dt As DataTable = dv.ToTable
                If dt.Rows.Count > 0 Then
                    gvTraffic.Columns(2).FooterText = dt.Compute("sum(conversions)", Nothing).ToString
                    gvTraffic.Columns(3).FooterText = FormatCurrency(dt.Compute("sum(revenue)", Nothing).ToString, 2)
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
        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yyyy") & "," & Now.AddDays(-1).ToString("MM/dd/yyyy")))

        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        'ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        'ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        'ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = 0
    End Sub

#End Region 'Methods

   
End Class