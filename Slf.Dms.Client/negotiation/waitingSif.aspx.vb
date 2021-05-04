Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports ultraGridPagerHelper
Imports System.Collections.Generic
Imports System.Data

Partial Class negotiation_waitingSif
    Inherits System.Web.UI.Page

    Public UserID As Integer
    Private blnIsManager As Boolean
    Private SearchBy As String
    Private pipelineResults As DataTable = Nothing
    Private unassignedResults As DataTable = Nothing

    Private _allProducts As String
    Private _allReps As String
    Private _allStatuses As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        Page.Form.DefaultButton = lnkSearch.UniqueID
        blnIsManager = Drg.Util.DataHelpers.SettlementProcessingHelper.IsManager(UserID)
        If Not Page.IsPostBack Then
            'Dim showSwitchToGroup As Boolean = SwitchGroupHelper.UserHasGroups(UserID)
            'tdSwithToGroup.Visible = showSwitchToGroup
            'tdSwithToGroupSep.Visible = showSwitchToGroup

            If Request.QueryString("s") <> "" Then
                Search("%" & Replace(Request.QueryString("s"), " ", "%") & "%")
                txtSearch.Text = Request.QueryString("s")
            Else
                Search("%")
            End If

        End If
    End Sub

    Private Function GetEnrollmentPage(ByVal PageName As String) As String
        Dim enrollmentpage As String = "prompt.aspx"
        Select Case PageName.ToLower.Trim
            Case "newenrollment.aspx", "newenrollment2.aspx"
                enrollmentpage = PageName.ToLower.Trim
        End Select
        Return enrollmentpage
    End Function

    Private Sub Search(ByVal strSearchtext As String)

        Dim params2 As New List(Of SqlParameter)
        params2.Add(New SqlParameter("UserID", UserID))
        params2.Add(New SqlParameter("SearchTerm", DBNull.Value))

        Dim dt2 As DataTable
        dt2 = SqlHelper.GetDataTable("stp_NegotiationsSearchGetSettlementsWaitingOnSIF", CommandType.StoredProcedure, params2.ToArray())
        gvPipelineLeads.DataSource = dt2
        gvPipelineLeads.DataBind()

        'pipelineResults = dt2

        'hNewLeads.InnerText = "New Leads (" + dt.Rows.Count.ToString + ")"
        'hPipeline.InnerText = "Pipeline (" + dt2.Rows.Count.ToString + ")"
    End Sub

#Region "Non Deposits"

    Public Function FormatPhone(ByVal PhoneNumber As String) As String
        Try
            Return LocalHelper.FormatPhone(PhoneNumber)
        Catch ex As Exception
            Return PhoneNumber
        End Try
    End Function

#End Region

    Protected Sub gvPipelineLeads_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvPipelineLeads.PageIndexChanging
        gvPipelineLeads.PageIndex = e.NewPageIndex
        Search("%" & Replace(txtSearch.Text.Trim, " ", "%") & "%")
    End Sub

    Protected Sub gvPipelineLeads_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvPipelineLeads.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.RowState = DataControlRowState.Alternate Then
                Dim drv As DataRowView = DirectCast(e.Row.DataItem, DataRowView)
                Dim slink As String = String.Format("javascript:window.navigate('{0}?id={1}&aid={2}');", ResolveUrl("~/clients/client/creditors/accounts/account.aspx"), drv("clientid"), drv("creditoraccountid"))
                e.Row.Attributes.Add("onClick", slink)
                SetAlternateMouseOverColor(e)
            Else
                Dim drv As DataRowView = DirectCast(e.Row.DataItem, DataRowView)
                Dim slink As String = String.Format("javascript:window.navigate('{0}?id={1}&aid={2}');", ResolveUrl("~/clients/client/creditors/accounts/account.aspx"), drv("clientid"), drv("creditoraccountid"))
                e.Row.Attributes.Add("onClick", slink)
                SetMouseOverColor(e)
            End If

        End If
    End Sub

    Private Sub SetMouseOverColor(ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
            e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this);"
        End If
    End Sub

    Private Sub SetAlternateMouseOverColor(ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
            e.Row.Attributes("onmouseout") = "javascript:setAlternateMouseOutColor(this);"
        End If
    End Sub

    Protected Sub gvPipelineLeads_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvPipelineLeads.Sorting

        Dim sortingDirection As String = String.Empty
        If direction = SortDirection.Ascending Then
            direction = SortDirection.Descending
            sortingDirection = "Desc"
        Else
            direction = SortDirection.Ascending
            sortingDirection = "Asc"
        End If
        Dim dv As DataView = New DataView(GetPipelineResults())
        dv.Sort = e.SortExpression + " " + sortingDirection
        Session("objects") = dv
        gvPipelineLeads.DataSource = dv
        gvPipelineLeads.DataBind()

    End Sub

    Public Function GetPipelineResults() As DataTable
        Dim params2 As New List(Of SqlParameter)

        params2.Add(New SqlParameter("UserID", UserID))
        'If txtSearch.Text.Trim.Length > 0 Then
        params2.Add(New SqlParameter("SearchTerm", "%" & Replace(txtSearch.Text.Trim, " ", "%") & "%"))
        'End If

        Dim dt As DataTable
        dt = SqlHelper.GetDataTable("stp_enrollment_getPipelines2", CommandType.StoredProcedure, params2.ToArray())

        hPipeline.InnerText = "Pipeline (" + dt.Rows.Count.ToString + ")"

        Return dt
    End Function

    Public Property direction As SortDirection
        Get
            If ViewState("directionState") Is Nothing Then
                ViewState("directionState") = SortDirection.Ascending
            End If
            Return DirectCast(ViewState("directionState"), SortDirection)
        End Get
        Set(value As SortDirection)
            ViewState("directionState") = value
        End Set
    End Property


End Class



