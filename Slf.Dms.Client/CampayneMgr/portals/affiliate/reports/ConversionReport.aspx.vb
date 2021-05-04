Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.Services

Imports AnalyticsHelper

Partial Class portals_affiliate_reports_ConversionReport
    Inherits System.Web.UI.Page

#Region "Fields"

    Public UserID As Integer

    Private _affiliateID As Integer
    Private intDaily As Integer

#End Region 'Fields

#Region "Properties"

    Public Property AffiliateID() As Integer
        Get
            Return _affiliateID
        End Get
        Set(ByVal value As Integer)
            _affiliateID = value
        End Set
    End Property

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

    Protected Sub gv_PreRender(sender As Object, e As System.EventArgs)
        GridViewHelper.AddJqueryUI(sender)
    End Sub

    Protected Sub dsConversions_Selected(sender As Object, e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsConversions.Selected
        lblViewConv.Text = String.Format(" ({0})", e.AffectedRows)
    End Sub

    Protected Sub ds_Selecting(sender As Object, e As System.Web.UI.WebControls.SqlDataSourceSelectingEventArgs)
        e.Command.CommandTimeout = 300
    End Sub

    Protected Sub gv_RowCreated(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
            Case DataControlRowType.Pager
                SetPagerButtonStates(sender, e.Row, Me.Page)
        End Select
    End Sub

    Protected Sub gv_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                GridViewHelper.addHandOnHover(e)
        End Select
    End Sub

    Protected Sub lnkSearch_Click(sender As Object, e As System.EventArgs) Handles lnkSearch.Click
        BindData()
    End Sub

    Protected Sub portals_affiliate_reports_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        UserID = Page.User.Identity.Name

        If Not IsPostBack Then
            SetupGrids()

            SetDates()
            loadOptions()

            BindData()
        End If
    End Sub

    Private Sub BindData()

        dsConversions.SelectParameters("UserID").DefaultValue = UserID
        dsConversions.SelectParameters("from").DefaultValue = String.Format("{0} 12:00 AM", txtFrom.Text.Trim)
        dsConversions.SelectParameters("to").DefaultValue = String.Format("{0} 11:59 PM", txtTo.Text.Trim)
        dsConversions.SelectParameters("campaign").DefaultValue = ddlCampaigns.SelectedItem.Value
        dsConversions.DataBind()

     
        gvConversions.DataBind()

        getSummaryTotals()


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

    Private Sub SetupGrids()
    
        AddHandler dsConversions.Selecting, AddressOf ds_Selecting
      
        AddHandler gvConversions.RowDataBound, AddressOf gv_RowDataBound

    End Sub

    Private Sub getSummaryTotals()
     

      
    End Sub

    Private Sub loadOptions()
        AffiliateID = SqlHelper.ExecuteScalar(String.Format("select UserTypeUniqueID from tbluser where UserId = {0}", UserID), Data.CommandType.Text)

        dsCampaigns.SelectParameters("affiliateid").DefaultValue = AffiliateID
        dsCampaigns.DataBind()
    End Sub

#End Region 'Methods

End Class