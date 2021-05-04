Imports System.Data
Imports System.Data.SqlClient

Partial Class research_reports_dialer_calls_dialercalls
    Inherits System.Web.UI.Page

    Protected Sub ddlDialerGroup_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlDialerGroup.SelectedIndexChanged
        Me.ddlQueue.DataBind()
        DisplayQueue()
    End Sub

    Private Sub DisplayQueue()
        Select Case ddlDialerGroup.SelectedValue
            Case 1
                'Clients
                Me.tdQueue.Visible = False
                Me.tdQueue1.Visible = False
                Me.tdCallReason.Visible = True
                Me.tdCallReason1.Visible = True
            Case 2
                'CID
                Me.tdCallReason.Visible = False
                Me.tdCallReason1.Visible = False
                Me.tdQueue.Visible = True
                Me.tdQueue1.Visible = True
        End Select
    End Sub

    Private Sub LoadQuickPickDates(ByVal ddl As DropDownList, ByVal startTextbox As TextBox, ByVal endTextbox As TextBox)
        ddl.Items.Clear()

        ddl.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yyyy") & "," & Now.ToString("MM/dd/yyyy")))
        ddl.Items.Add(New ListItem("This Week", LocalHelper.RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & LocalHelper.RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddl.Items.Add(New ListItem("This Month", LocalHelper.RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & LocalHelper.RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddl.Items.Add(New ListItem("This Year", LocalHelper.RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & LocalHelper.RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddl.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yyyy") & "," & Now.AddDays(-1).ToString("MM/dd/yyyy")))
        ddl.Items.Add(New ListItem("Last Week", LocalHelper.RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & LocalHelper.RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddl.Items.Add(New ListItem("Last Month", LocalHelper.RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & LocalHelper.RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddl.Items.Add(New ListItem("Last Year", LocalHelper.RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & LocalHelper.RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddl.Items.Add(New ListItem("Custom", "Custom"))
        'ddl.Items.Add(New ListItem("ALL", -1))

        startTextbox.Text = Now.ToString("MM/dd/yyyy")
        endTextbox.Text = Now.ToString("MM/dd/yyyy")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Me.LoadQuickPickDates(Me.ddlQuickPickDate, Me.txtTransDate1, Me.txtTransDate2)
        End If
        ddlQuickPickDate.Attributes("onchange") = String.Format("SetDatesGeneric(this,'{0}','{1}');", txtTransDate1.ClientID, txtTransDate2.ClientID)
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        DisplayCriteria()
        LoadGrid()
    End Sub

    Private Sub LoadGrid()
        Dim spName As String = ""
        Dim dsOutput As DataSet
        Dim params(2) As SqlParameter

        Select Case ddlDialerGroup.SelectedValue
            Case 1
                params(0) = New SqlParameter("@ReasonId", Me.ddlDialerReason.SelectedValue)
                spName = "stp_Dialer_GetCallStats"
            Case 2
                params(0) = New SqlParameter("@QueueId", Me.ddlQueue.SelectedValue)
                spName = "stp_Dialer_GetLeadCallStats"
        End Select

        params(1) = New SqlParameter("@From", Me.txtTransDate1.Text)
        params(2) = New SqlParameter("@To", CDate(Me.txtTransDate2.Text).AddDays(1))

        dsOutput = SqlHelper.GetDataSet(spName, CommandType.StoredProcedure, params)

        dsOutput.Relations.Add("DateRelation", dsOutput.Tables(0).Columns("Date"), dsOutput.Tables(1).Columns("Date"))

        UltraWebGrid1.Bands.Clear()
        UltraWebGrid1.DataSource = dsOutput.Tables(0)
        UltraWebGrid1.DataBind()
        UltraWebGrid1.Visible = True
    End Sub

    Protected Sub UltraWebGrid1_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles UltraWebGrid1.InitializeLayout
        With e.Layout
            .CellClickActionDefault = Infragistics.WebUI.UltraWebGrid.CellClickAction.RowSelect
            .SelectTypeRowDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single
            .SelectedRowStyleDefault.BorderStyle = BorderStyle.None
            .ViewType = Infragistics.WebUI.UltraWebGrid.ViewType.Hierarchical
            .BorderCollapseDefault = Infragistics.WebUI.UltraWebGrid.BorderCollapse.Collapse
            .GroupByBox.Hidden = True
            .AllowColumnMovingDefault = Infragistics.WebUI.UltraWebGrid.AllowColumnMoving.None
            .RowExpAreaStyleDefault.BackColor = System.Drawing.Color.White

            'Date
            .Bands(0).SelectedRowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#f1f1f1")
            .Bands(0).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(0).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
            .Bands(0).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#c7c7c7")
            .Bands(0).RowStyle.BorderStyle = BorderStyle.None
            .Bands(0).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
            .Bands(0).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            .Bands(0).RowStyle.Padding.Right = Unit.Pixel(3)
            .Bands(0).Columns(0).Width = Unit.Pixel(80)
            .Bands(0).Columns(1).Width = Unit.Pixel(120)
            .Bands(0).HeaderStyle.Font.Bold = True
            .Bands(0).HeaderStyle.BackColor = Drawing.ColorTranslator.FromHtml("#C5D9F1")
            .Bands(0).HeaderStyle.BorderStyle = BorderStyle.None
            .Bands(0).HeaderStyle.BorderDetails.ColorBottom = System.Drawing.Color.Black
            .Bands(0).HeaderStyle.BorderDetails.WidthBottom = Unit.Pixel(2)

            'Users
            .Bands(1).Columns(0).Hidden = True
            .Bands(1).Columns(1).Hidden = True
            .Bands(1).Columns(2).Width = Unit.Pixel(120)
            .Bands(1).Indentation = 80
            .Bands(1).SelectedRowStyle.BackColor = System.Drawing.Color.LightYellow
            .Bands(1).RowExpAreaStyle.BackColor = System.Drawing.Color.White
            .Bands(1).RowStyle.BackColor = System.Drawing.Color.White
            .Bands(1).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
            .Bands(1).RowStyle.BackColor = Drawing.ColorTranslator.FromHtml("#dedede")
            .Bands(1).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
            .Bands(1).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#c1c1c1")
            .Bands(1).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
            .Bands(1).ColFootersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No

        End With
    End Sub

    Private Sub DisplayCriteria()
        Dim DialerName As String = ""
        Select Case ddlDialerGroup.SelectedValue
            Case 1
                DialerName = ddlDialerReason.SelectedItem.Text
            Case 2
                DialerName = ddlQueue.SelectedItem.Text
        End Select
        lblFilter.Text = String.Format("Statistics for  {0} dialer from {1} to {2}", DialerName, txtTransDate1.Text, txtTransDate2.Text)
    End Sub

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete
        If Not IsPostBack Then
            DisplayQueue()
        End If
    End Sub
End Class
