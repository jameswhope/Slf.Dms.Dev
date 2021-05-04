Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess

Partial Class Clients_Enrollment_IncentiveDetail
    Inherits System.Web.UI.Page

    Private groupList As New Hashtable
    Private UserID As Integer
    Private blnIsManager As Boolean

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        blnIsManager = Drg.Util.DataHelpers.SettlementProcessingHelper.IsManager(UserID)

        If Not Page.IsPostBack Then
            hName.InnerHtml = SqlHelper.ExecuteScalar("select firstname + ' ' + lastname from tbluser where userid = " & Request.QueryString("id"), CommandType.Text)
            LoadIncentives(True)
            LoadLeadStats()
            ShowTeamChart()
            If Request.QueryString("h") = "i" Then
                aBack.HRef = "incentives.aspx"
            End If
        End If
    End Sub

    Private Sub LoadLeadStats()
        Dim params(0) As SqlParameter

        params(0) = New SqlParameter("@repid", Request.QueryString("id"))
        gvNonDepositRetention.DataSource = SqlHelper.GetDataTable("stp_NonDepositRetention", CommandType.StoredProcedure, params)
        gvNonDepositRetention.DataBind()

        hdnMonth.Value = Month(Now)
        hdnYear.Value = Year(Now)
        hdnMonthYear.Value = Format(Now, "MMMM yyyy")
        lnkLoadConvDetail_Click(Nothing, Nothing)
    End Sub

    Private Sub LoadIncentives(ByVal bLoadDetail As Boolean)
        Dim params(5) As SqlParameter
        Dim params2(0) As SqlParameter
        Dim tblIncentives As DataTable
        Dim lastMonth As Integer = Month(DateAdd(DateInterval.Month, -1, Today))
        Dim lastYear As Integer = Year(DateAdd(DateInterval.Month, -1, Today))

        'Last month (if not approved)
        If Not Drg.Util.DataAccess.DataHelper.RecordExists("tblIncentives", String.Format("repid = {0} and incentivemonth = {1} and incentiveyear = {2}", Request.QueryString("id"), lastMonth, lastYear)) Then
            params(0) = New SqlParameter("@repid", Request.QueryString("id"))
            params(1) = New SqlParameter("@month", lastMonth)
            params(2) = New SqlParameter("@year", lastYear)
            params(3) = New SqlParameter("@userid", UserID)
            params(4) = New SqlParameter("@summaryonly", 1)
            params(5) = New SqlParameter("@initialcount", SqlDbType.Int)
            params(5).Direction = ParameterDirection.Output
            tblIncentives = SqlHelper.GetDataTable("stp_UnapprovedIncentives", CommandType.StoredProcedure, params)
            hdnMonth.Value = lastMonth
            hdnYear.Value = lastYear
            hdnMonthYear.Value = MonthName(lastMonth) & " " & lastYear
            If tblIncentives.Rows.Count = 0 Then
                GoTo this_month
            End If
        Else
this_month:
            'load this month
            params(0) = New SqlParameter("@repid", Request.QueryString("id"))
            params(1) = New SqlParameter("@month", Month(Today))
            params(2) = New SqlParameter("@year", Year(Today))
            params(3) = New SqlParameter("@userid", UserID)
            params(4) = New SqlParameter("@summaryonly", 1)
            params(5) = New SqlParameter("@initialcount", SqlDbType.Int)
            params(5).Direction = ParameterDirection.Output
            tblIncentives = SqlHelper.GetDataTable("stp_UnapprovedIncentives", CommandType.StoredProcedure, params)
            hdnMonth.Value = Month(Today)
            hdnYear.Value = Year(Today)
            hdnMonthYear.Value = MonthName(Month(Today)) & " " & Year(Today)
        End If

        params2(0) = New SqlParameter("@repid", Request.QueryString("id"))
        tblIncentives.Merge(SqlHelper.GetDataTable("stp_ApprovedIncentives", CommandType.StoredProcedure, params2))

        GridView1.DataSource = tblIncentives
        GridView1.DataBind()

        If bLoadDetail Then
            lnkLoadDetail_Click(Nothing, Nothing)
        End If
    End Sub

    Private Sub ShowTeamChart()
        If Not blnIsManager Then
            divTeamChart.Visible = (SqlHelper.GetDataTable("select * from tblsupteam where supid = " & Request.QueryString("id")).Rows.Count > 0)
        End If
    End Sub

    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim imgApproved As HtmlImage = TryCast(e.Row.FindControl("imgApproved"), HtmlImage)

            If CInt(row("approved")) = 0 Then
                If blnIsManager Then
                    imgApproved.Src = "~/images/16x16_check_grey.png"
                    imgApproved.Style("cursor") = "hand"
                    imgApproved.Alt = "Click to approve"
                    imgApproved.Attributes.Add("onclick", String.Format("javascript: if (confirm('Click OK to approve this month.')) approve({0},{1});", row("month"), row("year")))
                Else
                    imgApproved.Visible = False
                End If
            End If

            If Not IsDBNull(row("adjustment")) Then
                e.Row.Cells(e.Row.Cells.Count - 1).Text &= "*"
            End If
        End If
    End Sub

    Protected Sub lnkApprove_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkApprove.Click
        Dim params(5) As SqlParameter
        params(0) = New SqlParameter("@repid", Request.QueryString("id"))
        params(1) = New SqlParameter("@month", hdnMonth.Value)
        params(2) = New SqlParameter("@year", hdnYear.Value)
        params(3) = New SqlParameter("@userid", UserID)
        params(4) = New SqlParameter("@approve", 1)
        params(5) = New SqlParameter("@initialcount", SqlDbType.Int)
        params(5).Direction = ParameterDirection.Output
        SqlHelper.ExecuteNonQuery("stp_UnapprovedIncentives", CommandType.StoredProcedure, params)
        LoadIncentives(False)
    End Sub

    Protected Sub lnkLoadDetail_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLoadDetail.Click
        Dim ds As DataSet

        hMonthYear.InnerHtml = hdnMonthYear.Value

        If hdnApproved.Value = "1" Then
            Dim params(2) As SqlParameter
            params(0) = New SqlParameter("@repid", Request.QueryString("id"))
            params(1) = New SqlParameter("@month", hdnMonth.Value)
            params(2) = New SqlParameter("@year", hdnYear.Value)
            ds = SqlHelper.GetDataSet("stp_ApprovedIncentiveDetail", , params)
            gvInitial.DataSource = ds.Tables(0)
            gvInitial.DataBind()
            gvResiduals.DataSource = ds.Tables(1)
            gvResiduals.DataBind()
            gvTeam.DataSource = ds.Tables(2)
            gvTeam.DataBind()
        Else 'Unapproved
            Dim params(5) As SqlParameter
            params(0) = New SqlParameter("@repid", Request.QueryString("id"))
            params(1) = New SqlParameter("@month", hdnMonth.Value)
            params(2) = New SqlParameter("@year", hdnYear.Value)
            params(3) = New SqlParameter("@userid", UserID)
            params(4) = New SqlParameter("@summaryonly", 0)
            params(5) = New SqlParameter("@initialcount", SqlDbType.Int)
            params(5).Direction = ParameterDirection.Output
            ds = SqlHelper.GetDataSet("stp_UnapprovedIncentives", CommandType.StoredProcedure, params)
            gvInitial.DataSource = ds.Tables(0)
            gvInitial.DataBind()
            gvResiduals.DataSource = ds.Tables(1)
            gvResiduals.DataBind()
            gvTeam.DataSource = ds.Tables(2)
            gvTeam.DataBind()
        End If

        lblInitialCnt.Text = ds.Tables(0).Rows.Count
        lblResidualCnt.Text = ds.Tables(1).Rows.Count

        If Not Page.IsPostBack Then
            divIncentiveChart.Visible = (ds.Tables(0).Rows.Count > 0)
            gvIncentiveChart.Visible = (ds.Tables(0).Rows.Count > 0)
            divTeamChart.Visible = (ds.Tables(2).Rows.Count > 0)
            gvTeamChart.Visible = (ds.Tables(2).Rows.Count > 0)
        End If
    End Sub

    Protected Sub gvInitial_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvInitial.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CAE1FF';")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
            Dim r As DataRowView = CType(e.Row.DataItem, DataRowView)
            If r("currentclientstatusid") = 17 Then
                For i As Integer = 0 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).Style("background-color") = "#FFD2D2"
                Next
            End If
        End If
    End Sub

    Protected Sub gvResiduals_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvResiduals.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CAE1FF';")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
        End If
    End Sub

    Protected Sub gvTeam_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvTeam.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CAE1FF';")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
        End If
    End Sub

    Protected Sub lnkLoadConvDetail_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLoadConvDetail.Click

        hConvMonthYear.InnerHtml = hdnMonthYear.Value

        Dim params(2) As SqlParameter
        params(0) = New SqlParameter("@repid", Request.QueryString("id"))
        params(1) = New SqlParameter("@month", hdnMonth.Value)
        params(2) = New SqlParameter("@year", hdnYear.Value)

        gvConversionDetail.DataSource = SqlHelper.GetDataTable("stp_NonDepositRetentionDetail", CommandType.StoredProcedure, params)
        gvConversionDetail.DataBind()
    End Sub

    Protected Sub gvConversionDetail_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvConversionDetail.DataBound
        lblLeads.Text = gvConversionDetail.Rows.Count
    End Sub

    Protected Sub gvConversionDetail_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvConversionDetail.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)
            If CInt(row("seq")) < 2 Then
                e.Row.Style("color") = "#999999"
            End If
            If CBool(row("bounced")) Then
                e.Row.Style("background-color") = "#FFD2D2"
            End If
        End If
    End Sub

    Protected Sub gvIncentiveChart_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvIncentiveChart.DataBound
        tdRepChart.Visible = gvIncentiveChart.Rows.Count > 0
    End Sub

    Protected Sub gvTeamChart_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvTeamChart.DataBound
        tdSupChart.Visible = gvTeamChart.Rows.Count > 0
    End Sub

    Protected Sub gvIncentiveChart_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvIncentiveChart.RowDataBound, gvTeamChart.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                For i As Integer = 0 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).CssClass = "chartHead"
                Next
            Case DataControlRowType.DataRow
                For i As Integer = 0 To e.Row.Cells.Count - 1
                    e.Row.Cells(i).CssClass = "chartItem"
                    If i > 0 Then
                        e.Row.Cells(i).Text = FormatCurrency(Val(e.Row.Cells(i).Text))
                    End If
                Next
        End Select
    End Sub
End Class
