Imports Infragistics.WebUI.UltraWebChart
Imports Infragistics.UltraChart.Shared.Styles
Imports Infragistics.UltraChart.Resources.Appearance
Imports Infragistics.UltraChart.Core.Layers
Imports System.Data
Imports System.Drawing
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess

Partial Class Clients_Enrollment_SDClientRetention
    Inherits System.Web.UI.Page

#Region "Declares"
    Private UserID As Integer = -1
    Private AgencyID As Integer = 856
    Dim sSQL As String = ""
    Dim dtData As DataTable = Nothing
    Private RepID As Integer
#End Region

#Region "Events"
    Protected Sub Agency_client_retention_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If IsNumeric(Request.QueryString("id")) Then
            UserID = CInt(Request.QueryString("id"))
        Else
            UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        End If

        If IsNumeric(Request.QueryString("c")) Then
            AgencyID = CInt(Request.QueryString("c"))
        End If

        If Not IsPostBack Then
            LoadDates()
            LoadData()
        End If
    End Sub
#End Region

#Region "Utils"

    Private Sub LoadDates(Optional ByVal AgencyID As Integer = 856, Optional ByVal RepID As Integer = 0, Optional ByVal MonthStarted As Integer = 12, Optional ByVal YearStarted As Integer = 2009, Optional ByVal SourceID As Integer = 0, Optional ByVal MarketID As Integer = 0)
        Dim minyear, maxyear As Integer
        Dim params(1) As SqlParameter
        Dim tbl As New DataTable

        tbl = SqlHelper.GetDataTable(CancellationRptHelper.ClientMinMaxCreated(AgencyID, MonthStarted, YearStarted, RepID, SourceID, MarketID), CommandType.Text)
        minyear = CInt(tbl.Rows(0)(0))
        maxyear = CInt(tbl.Rows(0)(1))
        For y As Integer = maxyear To minyear Step -1
            ddlYears.Items.Add(y)
        Next
    End Sub

    Private Function BuildRetentionDataTable(ByVal dt As DataTable) As DataTable
        Dim newDT As DataTable = dt.Clone
        For c As Integer = 2 To newDT.Columns.Count - 1
            newDT.Columns(c).DataType = System.Type.GetType("System.String")
        Next

        Dim monthRow As DataRow = newDT.NewRow
        If dt.Rows.Count > 0 Then

            newDT.ImportRow(dt.Rows(0))
            newDT.ImportRow(dt.Rows(1))

            monthRow("status") = "Per Month"
            monthRow("totalCLients") = dt.Rows(0)(1).ToString
            Dim totalEnrolled As Integer = CInt(dt.Rows(0)(1))

            For c As Integer = 2 To dt.Columns.Count - 1
                'percent is cancelled / prior month remaining except for 1st month, uses total
                Select Case c
                    Case 2
                        monthRow(c) = FormatPercent(CInt(dt.Rows(0)(c)) / totalEnrolled, 1)
                    Case Else
                        monthRow(c) = FormatPercent(CInt(dt.Rows(0)(c)) / CInt(dt.Rows(1)(c - 1)), 1)
                End Select
            Next

            newDT.Rows.Add(monthRow)

            Dim dblTotal As Integer
            Dim totalRow As DataRow = newDT.NewRow
            totalRow("status") = "Total"
            totalRow("totalClients") = dt.Rows(0)(1).ToString

            For c As Integer = 2 To dt.Columns.Count - 1
                dblTotal += CInt(dt.Rows(0)(c))
                totalRow(c) = FormatPercent(dblTotal / totalEnrolled, 1)
            Next
            newDT.Rows.Add(totalRow)
        End If
        Return newDT
    End Function

    Private Sub LoadData()
        LoadDropDowns()
        LoadRollingData()
        LoadMonthData()
    End Sub

    Private Sub LoadRollingData(Optional ByVal AgencyID As Integer = 856, Optional ByVal RepID As Integer = 0, Optional ByVal SourceID As Integer = 0, Optional ByVal MarketID As Integer = 0, Optional ByVal MonthNo As Integer = 12, Optional ByVal Year As Integer = 2009)
        Dim dtTemp As DataTable = Nothing
        dtData = Nothing

        sSQL = CancellationRptHelper.RollingCancellations24(AgencyID, MonthNo, Year, RepID, SourceID, MarketID)
        dtData = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("ConnectionString").ToString)
        dtTemp = BuildRetentionDataTable(dtData)
        lblRollingTot.Text = "Total Leads Converted : " & dtTemp.Rows(0)(1).ToString

        AddHandler gvRolling.RowDataBound, AddressOf gv_RowDataBound

        gvRolling.DataSource = dtTemp
        gvRolling.DataBind()

        dtData.Clear()

        dtData.Dispose()
        dtData = Nothing

        dtTemp.Clear()
        dtTemp.Dispose()
        dtTemp = Nothing
    End Sub

    Private Sub LoadMonthData(Optional ByVal AgencyID As Integer = 856, Optional ByVal RepID As Integer = 0, Optional ByVal SourceID As Integer = 0, Optional ByVal MarketID As Integer = 0, Optional ByVal MonthNo As Integer = 12, Optional ByVal Year As Integer = 2009)

        PlaceHolder1.Controls.Clear()

        For m As Integer = 1 To 12

            Dim dtTemp As DataTable = Nothing
            Dim gvMonth As New GridView
            Dim month As Date
            Dim month1 As Date

            dtData = Nothing

            If m = 1 Then
                month1 = New Date(ddlYears.SelectedItem.Value, m + 11, 1)
            Else
                month = New Date(ddlYears.SelectedItem.Value, m - 1, 1)
            End If

            If m = 1 Then
                sSQL = CancellationRptHelper.RollingCancellationsByCreated(AgencyID, m + 11, ddlYears.SelectedValue, RepID, SourceID, MarketID)
            Else
                sSQL = CancellationRptHelper.RollingCancellationsByCreated(AgencyID, m - 1, ddlYears.SelectedValue, RepID, SourceID, MarketID)
            End If

            dtData = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("ConnectionString").ToString)
            dtTemp = BuildRetentionDataTable(dtData)

            If dtTemp.Columns.Count > 2 AndAlso CInt(dtTemp.Rows(0)(1)) > 0 Then
                AddHandler gvMonth.RowDataBound, AddressOf gv_RowDataBound

                gvMonth.DataSource = dtTemp
                gvMonth.DataBind()
                If m = 1 Then
                    PlaceHolder1.Controls.Add(New LiteralControl("Enrollment Class: <b>" & month1.ToString("MMM") & " " & ddlYears.SelectedItem.Value & "</b><br>"))
                Else
                    PlaceHolder1.Controls.Add(New LiteralControl("Enrollment Class: <b>" & month.ToString("MMM") & " " & ddlYears.SelectedItem.Value & "</b><br>"))
                End If

                PlaceHolder1.Controls.Add(New LiteralControl("Enrolled This Month: " & dtTemp.Rows(0)(1) & "<br>"))
                PlaceHolder1.Controls.Add(gvMonth)
                PlaceHolder1.Controls.Add(New LiteralControl("<br>"))
            End If

            dtData.Clear()
            dtData.Dispose()
            dtData = Nothing

            dtTemp.Clear()
            dtTemp.Dispose()
            dtTemp = Nothing
        Next

    End Sub

    Private Sub LoadDropDowns()
        Dim dr As SqlDataReader
        Dim strSQL As String
        Dim cmd As SqlCommand
        Dim cn As SqlConnection
        Dim i As Integer = 1

        'Reps
        strSQL = "SELECT FirstName + ' ' + LastName, UserID FROM tblUser WHERE UserGroupID = 25 ORDER BY LastName"
        cn = New SqlConnection(ConfigurationManager.AppSettings("ConnectionString").ToString)
        cn.Open()
        cmd = New SqlCommand(strSQL, cn)
        dr = cmd.ExecuteReader
        If dr.HasRows Then
            Do While dr.Read
                Me.ddlRep.Items.Insert(i, New ListItem(dr.Item(0).ToString(), dr.Item(1).ToString()))
                i += 1
            Loop
            dr.Close()
            cn.Close()
            strSQL = ""
            i = 1
        End If

        strSQL = "SELECT Source, LeadSourceID, LeadMarketID FROM tblLeadSource ORDER BY Source"
        cn = New SqlConnection(ConfigurationManager.AppSettings("ConnectionString").ToString)
        cn.Open()
        cmd = New SqlCommand(strSQL, cn)
        dr = cmd.ExecuteReader
        If dr.HasRows Then
            Do While dr.Read
                Me.ddlSource.Items.Insert(i, New ListItem(dr.Item(0).ToString(), dr.Item(1).ToString))
                i += 1
            Loop
            dr.Close()
            cn.Close()
            strSQL = ""
            i = 1
        End If

        strSQL = "SELECT Market, LeadMarketID FROM tblLeadMarket ORDER BY Market"
        cn = New SqlConnection(ConfigurationManager.AppSettings("ConnectionString").ToString)
        cn.Open()
        cmd = New SqlCommand(strSQL, cn)
        dr = cmd.ExecuteReader
        If dr.HasRows Then
            Do While dr.Read
                Me.ddlMarket.Items.Insert(i, New ListItem(dr.Item(0).ToString(), dr.Item(1).ToString))
                i += 1
            Loop
            dr.Close()
            cn.Close()
            strSQL = ""
        End If

    End Sub

#End Region

    'Protected Sub ddlMonths_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlMonths.SelectedIndexChanged
    '    LoadMonthData()
    'End Sub

    Protected Sub ddlYears_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlYears.SelectedIndexChanged
        LoadMonthData()
    End Sub

    Protected Sub RefreshAll(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        Dim iSource As Integer = ddlSource.SelectedValue
        Dim iMarket As Integer = ddlMarket.SelectedValue
        Dim iRep As Integer = ddlRep.SelectedValue
        Dim iAgencyID As Integer = 856
        Dim iMonth As Integer = 12
        Dim iYear As Integer = CInt(Val(ddlYears.SelectedValue))

        gvRolling.DataSource = Nothing

        LoadRollingData(AgencyID, iRep, iSource, iMarket, iMonth, iYear)
        LoadMonthData(AgencyID, iRep, iSource, iMarket, iMonth, iYear)

    End Sub

    Protected Sub gv_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        e.Row.CssClass = "entry2"
        'hide total client count
        e.Row.Cells(1).Visible = False

        Select Case e.Row.RowType
            Case DataControlRowType.Header
                e.Row.Style("background-color") = "#4791C5"
                e.Row.Style("color") = "#FFF"
                e.Row.Style("white-space") = "nowrap"
            Case DataControlRowType.DataRow
                For Each tc As TableCell In e.Row.Cells
                    tc.HorizontalAlign = HorizontalAlign.Center
                Next
                e.Row.Cells(0).BackColor = System.Drawing.ColorTranslator.FromHtml("#4791C5")
                e.Row.Cells(0).ForeColor = Color.White
                e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Right
        End Select
    End Sub

End Class
