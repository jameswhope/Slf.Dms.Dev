Imports AnalyticsHelper

Partial Class reports_revenue
    Inherits System.Web.UI.Page

    Private _clicks As Integer
    Private _conversions As Integer
    Private _billable As Integer
    Private _totalCost As Double
    Private _revenue As Double

    Protected Sub reports_revenue_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            txtDate1.Text = Format(Today, "M/d/yyyy")
            SetDates()
            LoadReport()
        End If
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

        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = 0
    End Sub

    Private Sub LoadReport()
        Try
            Repeater1.DataSource = ReportsHelper.RevSnapshot(txtDate1.Text, txtDate2.Text, Page.User.Identity.Name, txtTime1.Text, txtTime2.Text)
            Repeater1.DataBind()
            RptTotals.DataSource = ReportsHelper.RevTotals(txtDate1.Text, txtDate2.Text, Page.User.Identity.Name, txtTime1.Text, txtTime2.Text)
            RptTotals.DataBind()
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(phrJsRunner, phrJsRunner.GetType(), "msg", "$().toastmessage('showErrorToast', 'Error loading report. Please check your date and time.');", True)
        End Try
    End Sub

    Protected Sub btnView_Click(sender As Object, e As System.EventArgs) Handles btnView.Click
        LoadReport()
        btnSave.Enabled = DateDiff(DateInterval.Day, CDate(txtDate1.Text), CDate(txtDate2.Text)).Equals(0)
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As System.EventArgs) Handles btnSave.Click
        For Each item As RepeaterItem In Repeater1.Items
            Dim hdnRevReportID As HiddenField = TryCast(item.FindControl("hdnRevReportID"), HiddenField)
            Dim txtEmailRev As TextBox = TryCast(item.FindControl("txtEmailRev"), TextBox)
            Dim txtAdsenseRev As TextBox = TryCast(item.FindControl("txtAdsenseRev"), TextBox)
            ReportsHelper.SaveRevReport(hdnRevReportID.Value, Page.User.Identity.Name, txtEmailRev.Text, txtAdsenseRev.Text)
        Next

        'Dim startDate As DateTime = CDate(txtDate1.Text)
        'Dim Year As Integer = startDate.Year
        'Dim Month As Integer = startDate.Month

        'For Each item As RepeaterItem In RptTotals.Items
        '    Dim txtCorpCost As TextBox = TryCast(item.FindControl("txtCorpCost"), TextBox)
        '    If txtCorpCost.Visible Then
        '        ReportsHelper.SaveRevTotals(Page.User.Identity.Name, txtCorpCost.Text, Year, Month)
        '    End If
        'Next

        LoadReport()
        ScriptManager.RegisterStartupScript(phrJsRunner, phrJsRunner.GetType(), "msg", "$().toastmessage('showSuccessToast', 'Report saved!');", True)
    End Sub

    Protected Sub Repeater1_ItemCommand(source As Object, e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles Repeater1.ItemCommand

        If DateDiff(DateInterval.Day, CDate(txtDate1.Text), CDate(txtDate2.Text)).Equals(0) Then 'And DateDiff(DateInterval.Day, CDate(txtDate1.Text), Today) < 8 Then
            Select Case e.CommandName
                Case "ShowOnlineRev"
                    gvOnline.DataSource = ReportsHelper.GetOnlineBreakdown(e.CommandArgument, txtDate1.Text, txtDate2.Text, txtTime1.Text, txtTime2.Text)
                    gvOnline.DataBind()
                Case "ShowInternalCost", "ShowAffiliateCost"
                    Dim internal As Boolean
                    If e.CommandName.Equals("ShowInternalCost") Then
                        internal = True
                    End If
                    gvCampaigns.DataSource = ReportsHelper.GetCostBreakdown(e.CommandArgument, internal, txtDate1.Text, txtDate2.Text, txtTime1.Text, txtTime2.Text)
                    gvCampaigns.DataBind()
            End Select
        End If

        'save for refresh
        ViewState("category") = e.CommandArgument
        ViewState("itemcmd") = e.CommandName
    End Sub

    Protected Sub Repeater1_ItemDataBound(sender As Object, e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles Repeater1.ItemDataBound
        Select Case e.Item.ItemType
            Case ListItemType.Item, ListItemType.AlternatingItem
                Dim btnAffiliateCost As LinkButton = e.Item.FindControl("btnAffiliateCost")
                Dim btnInternalCost As LinkButton = e.Item.FindControl("btnInternalCost")
                Dim btnOnlineRev As LinkButton = e.Item.FindControl("btnOnlineRev")

                'can only edit single day and within the last 7 days
                If DateDiff(DateInterval.Day, CDate(txtDate1.Text), CDate(txtDate2.Text)).Equals(0) Then 'And DateDiff(DateInterval.Day, CDate(txtDate1.Text), Today) < 8 Then
                    btnAffiliateCost.OnClientClick = String.Format("ShowCampaigns('{0}','Affiliate','{1}')", e.Item.DataItem("Category"), Format(e.Item.DataItem("RevDate"), "MMMM d, yyyy"))
                    btnAffiliateCost.Font.Underline = True
                    btnInternalCost.OnClientClick = String.Format("ShowCampaigns('{0}','Internal','{1}')", e.Item.DataItem("Category"), Format(e.Item.DataItem("RevDate"), "MMMM d, yyyy"))
                    btnInternalCost.Font.Underline = True
                    btnOnlineRev.OnClientClick = String.Format("ShowOnline('{0}','{1}')", e.Item.DataItem("Category"), Format(e.Item.DataItem("RevDate"), "MMMM d, yyyy"))
                    btnOnlineRev.Font.Underline = True
                Else
                    btnAffiliateCost.Font.Underline = False
                    btnInternalCost.Font.Underline = False
                    btnOnlineRev.Font.Underline = False
                End If
        End Select
    End Sub

    Protected Sub RptTotals_ItemDataBound(sender As Object, e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles RptTotals.ItemDataBound
        Select Case e.Item.ItemType
            Case ListItemType.Item, ListItemType.AlternatingItem
                Dim lbDescription As Label = e.Item.FindControl("lbDescription")
                Dim btnCorpCost As LinkButton = e.Item.FindControl("lnkCorpCost")

                'can only edit single day and within the last 7 days
                If lbDescription.Text = "Date Span" Then
                    btnCorpCost.OnClientClick = "#"
                    btnCorpCost.Font.Underline = False
                Else
                    btnCorpCost.OnClientClick = "showCorporate()"
                    btnCorpCost.Font.Underline = True
                End If
        End Select
    End Sub

    Protected Sub btnRefresh_Click(sender As Object, e As System.EventArgs) Handles btnRefresh.Click
        LoadReport()
    End Sub

    Protected Sub gvCampaigns_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvCampaigns.RowCommand
        Select Case e.CommandName
            Case "ShowSubIDs"
                Dim campaignid As Integer = CInt(e.CommandArgument)
                gvSubIds.DataSource = ReportsHelper.GetCostBreakdownBySubId(campaignid, txtDate1.Text, txtDate2.Text, txtTime1.Text, txtTime2.Text)
                gvSubIds.DataBind()
                Session("campaignid") = campaignid
                ScriptManager.RegisterStartupScript(phrJsRunner, phrJsRunner.GetType(), "show", "ShowSubIdDialog();", True)
        End Select
    End Sub

    Protected Sub gvCampaigns_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvCampaigns.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                _clicks += Val(e.Row.DataItem("Clicks"))
                _conversions += Val(e.Row.DataItem("Conversions"))
                _billable += Val(e.Row.DataItem("Billable"))
                _totalCost += Val(e.Row.DataItem("Cost"))

                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
                If e.Row.RowState = DataControlRowState.Alternate Then
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
                Else
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If
            Case DataControlRowType.Footer
                e.Row.Cells(3).Text = FormatNumber(_clicks, 0)
                e.Row.Cells(3).Style("text-align") = "center"
                e.Row.Cells(4).Text = FormatNumber(_conversions, 0)
                e.Row.Cells(4).Style("text-align") = "center"
                e.Row.Cells(5).Text = FormatNumber(_billable, 0)
                e.Row.Cells(5).Style("text-align") = "center"
                e.Row.Cells(7).Text = FormatCurrency(_totalCost, 2)
        End Select
    End Sub

    Protected Sub lnkRefreshCampaigns_Click(sender As Object, e As System.EventArgs) Handles lnkRefreshCampaigns.Click
        Dim internal As Boolean
        If ViewState("itemcmd").ToString.Equals("ShowInternalCost") Then
            internal = True
        End If
        gvCampaigns.DataSource = ReportsHelper.GetCostBreakdown(ViewState("category").ToString, internal, txtDate1.Text, txtDate2.Text, txtTime1.Text, txtTime2.Text)
        gvCampaigns.DataBind()
    End Sub

    Protected Sub gvSubIds_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSubIds.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                _clicks += Val(e.Row.DataItem("Clicks"))
                _conversions += Val(e.Row.DataItem("Conversions"))
                _billable += Val(e.Row.DataItem("Billable"))
                _totalCost += Val(e.Row.DataItem("Cost"))

                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
                If e.Row.RowState = DataControlRowState.Alternate Then
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
                Else
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If
            Case DataControlRowType.Footer
                e.Row.Cells(3).Text = FormatNumber(_clicks, 0)
                e.Row.Cells(3).Style("text-align") = "center"
                e.Row.Cells(5).Text = FormatNumber(_conversions, 0)
                e.Row.Cells(5).Style("text-align") = "center"
                e.Row.Cells(6).Text = FormatNumber(_billable, 0)
                e.Row.Cells(6).Style("text-align") = "center"
                e.Row.Cells(9).Text = FormatCurrency(_totalCost, 2)
        End Select
    End Sub

    Protected Sub lnkRefreshSubIds_Click(sender As Object, e As System.EventArgs) Handles lnkRefreshSubIds.Click
        gvSubIds.DataSource = ReportsHelper.GetCostBreakdownBySubId(CInt(Session("CampaignID")), txtDate1.Text, txtDate2.Text, txtTime1.Text, txtTime2.Text)
        gvSubIds.DataBind()
    End Sub

    Protected Sub gvOnline_RowCommand(sender As Object, e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvOnline.RowCommand
        Select Case e.CommandName
            Case "ShowSrcIDs"
                Dim args() As String = Split(e.CommandArgument, ";")
                Dim campaignid As Integer = CInt(args(0))
                Dim offer As String = args(1)
                Dim category As String = args(2)
                gvOnlineSrc.DataSource = ReportsHelper.GetOnlineBreakdownBySrcId(campaignid, txtDate1.Text, txtDate2.Text, category, txtTime1.Text, txtTime2.Text)
                gvOnlineSrc.DataBind()
                Session("campaignid") = campaignid
                Session("category") = category
                ScriptManager.RegisterStartupScript(phrJsRunner, phrJsRunner.GetType(), "show", String.Format("ShowOnlineSrc('{0}',{1});", offer, campaignid), True)
        End Select
    End Sub

    Protected Sub gvOnline_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvOnline.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                _clicks += Val(e.Row.DataItem("Clicks"))
                _conversions += Val(e.Row.DataItem("Conversions"))
                _revenue += Val(e.Row.DataItem("Received"))
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
                If e.Row.RowState = DataControlRowState.Alternate Then
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
                Else
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If
            Case DataControlRowType.Footer
                e.Row.Cells(3).Text = FormatNumber(_clicks, 0)
                e.Row.Cells(3).Style("text-align") = "center"
                e.Row.Cells(4).Text = FormatNumber(_conversions, 0)
                e.Row.Cells(4).Style("text-align") = "center"
                e.Row.Cells(6).Text = FormatCurrency(_revenue, 2)
        End Select
    End Sub

    Protected Sub lnkRefreshOnline_Click(sender As Object, e As System.EventArgs) Handles lnkRefreshOnline.Click
        gvOnline.DataSource = ReportsHelper.GetOnlineBreakdown(ViewState("category"), txtDate1.Text, txtDate2.Text, txtTime1.Text, txtTime2.Text)
        gvOnline.DataBind()
    End Sub

    Protected Sub gvOnlineSrc_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvOnlineSrc.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                _clicks += Val(e.Row.DataItem("Clicks"))
                _conversions += Val(e.Row.DataItem("Conversions"))
                _revenue += Val(e.Row.DataItem("Received"))
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
                If e.Row.RowState = DataControlRowState.Alternate Then
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
                Else
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If
            Case DataControlRowType.Footer
                e.Row.Cells(2).Text = FormatNumber(_clicks, 0)
                e.Row.Cells(2).Style("text-align") = "center"
                e.Row.Cells(4).Text = FormatNumber(_conversions, 0)
                e.Row.Cells(4).Style("text-align") = "center"
                e.Row.Cells(7).Text = FormatCurrency(_revenue, 2)
        End Select
    End Sub

    Protected Sub lnkRefreshOnlineSrc_Click(sender As Object, e As System.EventArgs) Handles lnkRefreshOnlineSrc.Click
        gvOnlineSrc.DataSource = ReportsHelper.GetOnlineBreakdownBySrcId(CInt(Session("campaignid")), txtDate1.Text, txtDate2.Text, CStr(Session("category")), txtTime1.Text, txtTime2.Text)
        gvOnlineSrc.DataBind()
    End Sub

    Public Function CheckZero(ByVal value As Integer) As Integer
        If value = 0 Then
            Return 1
        Else
            Return value
        End If
    End Function
    
End Class