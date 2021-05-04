Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports ultraGridPagerHelper
Imports System.Collections.Generic
Imports System.Data

Partial Class Clients_Enrollment_Default
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
            Dim showSwitchToGroup As Boolean = SwitchGroupHelper.UserHasGroups(UserID)
            tdSwithToGroup.Visible = showSwitchToGroup
            tdSwithToGroupSep.Visible = showSwitchToGroup

            If Request.QueryString("s") <> "" Then
                Search("%" & Replace(Request.QueryString("s"), " ", "%") & "%")
                txtSearch.Text = Request.QueryString("s")
            Else
                Search("%")
            End If

            aIncentives.HRef = "incentivedetail.aspx?id=" & UserID

            SetPermissions()
            SetProducts()
            SetReps()
            SetStatuses()
        End If
    End Sub

    Private Sub SetPermissions()
        If PermissionHelperLite.HasPermission(UserID, "Client Intake-Phone List") Then
            tdPhoneList.Visible = True
            tdPhoneListSep.Visible = True
        End If
        'If PermissionHelperLite.HasPermission(UserID, "Client Intake-New Applicant") Then
        tdNewApplicant.Visible = True
        tdNewApplicantSep.Visible = True
        'End If
        If PermissionHelperLite.HasPermission(UserID, "Client Intake-Lead Analysis") Then
            tdLeadAnalysis.Visible = True
            tdLeadAnalysisSep.Visible = True
        End If
        If PermissionHelperLite.HasPermission(UserID, "Client Intake-My Incentives") Then
            tdMyIncentives.Visible = True
            tdMyIncentivesSep.Visible = True
        End If
        tblAdminToolbar.Visible = PermissionHelperLite.HasPermission(UserID, "Client Intake-Admin toolbar")

        If Not (UserID = 310 OrElse UserID = 311 OrElse UserID = 1848 OrElse UserID = 2200) Then
            lnkGlobalTransfer.Visible = False
        End If

        'Shoe Reports Menu
        Dim xmllist As New XmlDataSource
        xmllist.ID = "reportsmenu"
        xmllist.CacheDuration = 0
        xmllist.EnableCaching = False
        xmllist.Data = GetCIDReports()

        If xmllist.Data.Length > 0 Then
            mnuReports.DataSource = xmllist
            tdmnuReportsSep.Visible = True
        Else
            mnuReports.DataSource = Nothing
            tdmnuReportsSep.Visible = False
        End If
        mnuReports.DataBind()

    End Sub

    Private Function GetEnrollmentPage(ByVal PageName As String) As String
        Dim enrollmentpage As String = "prompt.aspx"
        Select Case PageName.ToLower.Trim
            Case "newenrollment.aspx", "newenrollment2.aspx"
                enrollmentpage = PageName.ToLower.Trim
        End Select
        Return enrollmentpage
    End Function

    Protected Sub lnkSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearch.Click
        Search("%" & Replace(txtSearch.Text.Trim, " ", "%") & "%")
    End Sub

    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click
        Search("%")
        txtSearch.Text = ""
    End Sub

    Private Sub Search(ByVal strSearchtext As String)
        Dim id As Object = SqlHelper.ExecuteScalar("select userid from tbltestreps where userid = " & UserID, Data.CommandType.Text)

        Dim params As New List(Of SqlParameter)
        Dim params2 As New List(Of SqlParameter)

        params.Add(New SqlParameter("UserID", UserID))
        If txtSearch.Text.Trim.Length > 0 Then
            params.Add(New SqlParameter("SearchStr", strSearchtext))
        End If

        Dim dt As DataTable
        dt = SqlHelper.GetDataTable("stp_enrollment_getLeads", CommandType.StoredProcedure, params.ToArray())
        gvUnassignedLeads.DataSource = dt
        gvUnassignedLeads.DataBind()

        params2.Add(New SqlParameter("UserID", UserID))
        If txtSearch.Text.Trim.Length > 0 Then
            params2.Add(New SqlParameter("SearchStr", strSearchtext))
        End If
        If ddlProduct.SelectedIndex > 0 Then
            params2.Add(New SqlParameter("ProductId", ddlProduct.SelectedValue))
        End If
        If ddlStatus.SelectedIndex > 0 Then
            params2.Add(New SqlParameter("StatusId", ddlStatus.SelectedValue))
        End If
        If ddlAssignTo.SelectedIndex > 0 Then
            params2.Add(New SqlParameter("RepId", ddlAssignTo.SelectedValue))
        End If

        Dim dt2 As DataTable
        dt2 = SqlHelper.GetDataTable("stp_enrollment_getPipelines2", CommandType.StoredProcedure, params2.ToArray())
        gvPipelineLeads.DataSource = dt2
        gvPipelineLeads.DataBind()

        pipelineResults = dt2

        hNewLeads.InnerText = "New Leads (" + dt.Rows.Count.ToString + ")"
        hPipeline.InnerText = "Pipeline (" + dt2.Rows.Count.ToString + ")"
    End Sub

    Private Sub SetProducts()

        ddlProduct.Items.Clear()
        ddlProduct.Items.Add(New System.Web.UI.WebControls.ListItem("All Products", -1))
        ddlProduct.SelectedIndex = 0

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("UserId", UserID))

        Dim dt As DataTable

        dt = SqlHelper.GetDataTable("stp_clientIntake_overview_allProducts", CommandType.StoredProcedure, params.ToArray)

        _allProducts += ""
        For Each rw As DataRow In dt.Rows
            _allProducts += rw("ProductId").ToString + ","
            ddlProduct.Items.Add(New System.Web.UI.WebControls.ListItem(rw("ProductDesc"), rw("ProductId")))
        Next
        _allProducts.Remove(_allProducts.Length - 1)
        hdnProducts.Value = _allProducts
    End Sub

    Private Sub SetReps()

        ddlAssignTo.Items.Clear()
        ddlAssignTo.Items.Add(New System.Web.UI.WebControls.ListItem("All Reps", -1))
        ddlAssignTo.SelectedIndex = 0

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("UserId", UserID))

        Dim dt As DataTable

        dt = SqlHelper.GetDataTable("stp_clientIntake_overview_allReps", CommandType.StoredProcedure, params.ToArray)

        _allReps += ""
        For Each rw As DataRow In dt.Rows
            _allReps += rw("UserId").ToString + ","
            ddlAssignTo.Items.Add(New System.Web.UI.WebControls.ListItem(rw("FullName"), rw("UserId")))
        Next
        _allReps.Remove(_allReps.Length - 1)
        hdnReps.Value = _allReps
    End Sub

    Private Sub SetStatuses()

        ddlStatus.Items.Clear()
        ddlStatus.Items.Add(New System.Web.UI.WebControls.ListItem("All Statuses", -1))
        ddlStatus.SelectedIndex = 0

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("UserId", UserID))

        Dim dt As DataTable

        dt = SqlHelper.GetDataTable("stp_clientIntake_overview_allStatuses", CommandType.StoredProcedure, params.ToArray)

        _allStatuses += ""
        For Each rw As DataRow In dt.Rows
            _allStatuses += rw("StatusId").ToString + ","
            ddlStatus.Items.Add(New System.Web.UI.WebControls.ListItem(rw("Description"), rw("StatusId")))
        Next
        _allStatuses.Remove(_allStatuses.Length - 1)
        hdnStatuses.Value = _allStatuses
    End Sub

    Private Function GetCIDReports() As String

        Dim sb As New StringBuilder
        Dim tblreports As System.Data.DataTable = SmartDebtorHelper.GetCIDReports(UserID)
        For Each dr As System.Data.DataRow In tblreports.Rows
            sb.AppendFormat("<reportItem name=""{0}""></reportItem>", dr("reportname"))
            sb.AppendLine()
        Next

        If sb.Length > 0 Then
            Return "<Reports name=""Reports"">" & sb.ToString & "</Reports>"
        Else
            Return ""
        End If
    End Function

#Region "Non Deposits"

    Public Function FormatPhone(ByVal PhoneNumber As String) As String
        Try
            Return LocalHelper.FormatPhone(PhoneNumber)
        Catch ex As Exception
            Return PhoneNumber
        End Try
    End Function

#End Region

    Protected Sub mnuReports_MenuItemClick(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.MenuEventArgs) Handles mnuReports.MenuItemClick
        Select Case e.Item.Text.ToLower
            Case "sales dashboard"
                If UserID = 2203 Then
                    Me.Response.Redirect("DashboardAgencyWC.aspx")
                Else
                    Me.Response.Redirect("DashboardAgencyJQ.aspx")
                End If
            Case "pending clients"
                Me.Response.Redirect("AttorneyPendingQueue.aspx")
            Case "deposit analysis"
                Me.Response.Redirect("DepositAnalysisReport.aspx")
            Case "deposit analysis totals"
                Me.Response.Redirect("DashboardAgencyTotal.aspx")
            Case "lead dashboard"
                Me.Response.Redirect("DashboardAgencyRep.aspx")
            Case "income by agency"
                Me.Response.Redirect("IncomeByAgency.aspx")
            Case "draft analysis"
                Me.Response.Redirect("DraftAnalysis.aspx")
            Case "agency projection"
                Me.Response.Redirect("ProjectionByAgency.aspx")
            Case "deposit commitment"
                Me.Response.Redirect("DepositHistory.aspx")
            Case "deposit analysis snapshot"
                Me.Response.Redirect("DepositAnalysisSnapshot.aspx")
        End Select
    End Sub


    Protected Sub gvUnassignedLeads_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvUnassignedLeads.PageIndexChanging
        gvUnassignedLeads.PageIndex = e.NewPageIndex
        Search("%" & Replace(txtSearch.Text.Trim, " ", "%") & "%")
    End Sub

    Protected Sub gvPipelineLeads_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvPipelineLeads.PageIndexChanging
        gvPipelineLeads.PageIndex = e.NewPageIndex
        Search("%" & Replace(txtSearch.Text.Trim, " ", "%") & "%")
    End Sub

    Protected Sub gvUnassignedLeads_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvUnassignedLeads.Sorting
        Dim dt As DataTable = gvUnassignedLeads.DataSource

        If Not dt Is Nothing Then
            Dim dv As DataView = New DataView(dt)
            'dv.Sort = e.SortExpression + " " + ConvertingSortDirectionToSql(e.SortExpression)

            Search("%" & Replace(txtSearch.Text.Trim, " ", "%") & "%")
        End If
    End Sub

    Protected Sub gvUnassignedLeads_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvUnassignedLeads.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.RowState = DataControlRowState.Alternate Then
                Dim drv As DataRowView = DirectCast(e.Row.DataItem, DataRowView)
                Dim slink As String = String.Format("javascript:window.navigate('{0}?id={1}&p1=1&p2=1&s=');", ResolveUrl("~/clients/enrollment/newenrollment3.aspx"), drv("leadapplicantid"))
                e.Row.Attributes.Add("onClick", slink)
                SetAlternateMouseOverColor(e)
            Else
                Dim drv As DataRowView = DirectCast(e.Row.DataItem, DataRowView)
                Dim slink As String = String.Format("javascript:window.navigate('{0}?id={1}&p1=1&p2=1&s=');", ResolveUrl("~/clients/enrollment/newenrollment3.aspx"), drv("leadapplicantid"))
                e.Row.Attributes.Add("onClick", slink)
                SetMouseOverColor(e)
            End If

        End If
    End Sub

    Protected Sub gvPipelineLeads_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvPipelineLeads.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.RowState = DataControlRowState.Alternate Then
                Dim drv As DataRowView = DirectCast(e.Row.DataItem, DataRowView)
                Dim slink As String = String.Format("javascript:window.navigate('{0}?id={1}&p1=1&p2=1&s=');", ResolveUrl("~/clients/enrollment/newenrollment3.aspx"), drv("leadapplicantid"))
                e.Row.Attributes.Add("onClick", slink)
                SetAlternateMouseOverColor(e)
            Else
                Dim drv As DataRowView = DirectCast(e.Row.DataItem, DataRowView)
                Dim slink As String = String.Format("javascript:window.navigate('{0}?id={1}&p1=1&p2=1&s=');", ResolveUrl("~/clients/enrollment/newenrollment3.aspx"), drv("leadapplicantid"))
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
        If txtSearch.Text.Trim.Length > 0 Then
            params2.Add(New SqlParameter("SearchStr", "%" & Replace(txtSearch.Text.Trim, " ", "%") & "%"))
        End If

        If ddlProduct.SelectedIndex > 0 Then
            params2.Add(New SqlParameter("ProductId", ddlProduct.SelectedValue))
        End If
        If ddlStatus.SelectedIndex > 0 Then
            params2.Add(New SqlParameter("StatusId", ddlStatus.SelectedValue))
        End If
        If ddlAssignTo.SelectedIndex > 0 Then
            params2.Add(New SqlParameter("RepId", ddlAssignTo.SelectedValue))
        End If

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
