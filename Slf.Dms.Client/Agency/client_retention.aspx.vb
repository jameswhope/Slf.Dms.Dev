Imports Infragistics.WebUI.UltraWebChart
Imports Infragistics.UltraChart.Shared.Styles
Imports Infragistics.UltraChart.Resources.Appearance
Imports Infragistics.UltraChart.Core.Layers
Imports System.Data
Imports System.Drawing
Imports System.Data.SqlClient
Imports Drg.Util.DataAccess

Partial Class Agency_client_retention
    Inherits System.Web.UI.Page
#Region "Declares"
    Private UserID As Integer
    Private CompanyID As Integer = -1
    Dim sSQL As String = ""
    Dim dtData As DataTable = Nothing
#End Region
#Region "Events"
    Protected Sub Agency_client_retention_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsNumeric(Request.QueryString("id")) Then
            UserID = CInt(Request.QueryString("id"))
        Else
            UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        End If

        If IsNumeric(Request.QueryString("c")) Then
            CompanyID = CInt(Request.QueryString("c"))
        End If

        If Not IsPostBack Then
            LoadDates()
            LoadData()
        End If
    End Sub
#End Region
#Region "Utils"
    Private Sub LoadDates()
        Dim minyear, maxyear As Integer
        Dim params(1) As SqlParameter
        Dim tbl As DataTable

        params(0) = New SqlParameter("UserID", UserID)
        params(1) = New SqlParameter("CompanyID", CompanyID)
        tbl = SqlHelper.GetDataTable("stp_ClientMinMaxCreated", CommandType.StoredProcedure, params)
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
        LoadRollingData()
        LoadMonthData()
    End Sub
    Private Sub LoadRollingData()
        Dim dtTemp As DataTable = Nothing

        sSQL = "stp_Agency_Dashboard_ClientRetentionRolling24 " & UserID & "," & CompanyID
        dtData = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("ConnectionString").ToString)
        dtTemp = BuildRetentionDataTable(dtData)
		lblRollingTot.Text = "Total Enrolled : " & dtTemp.Rows(0)(1).ToString


		AddHandler gvRolling.RowDataBound, AddressOf gv_RowDataBound

		gvRolling.DataSource = dtTemp
		gvRolling.DataBind()

        dtData.Clear()

        dtData.Dispose()
        dtData = Nothing

        dtTemp.Dispose()
        dtTemp = Nothing
    End Sub

    Private Sub LoadMonthData()
        For m As Integer = 1 To 12
            Dim dtTemp As DataTable = Nothing
            Dim gvMonth As New GridView
            Dim month As New Date(ddlYears.SelectedItem.Value, m, 1)

            sSQL = "stp_Agency_Dashboard_ClientRetentionRollingByCreated " & UserID & "," & m & "," & ddlYears.SelectedValue & "," & CompanyID
            dtData = SharedFunctions.AsyncDB.executeDataTableAsync(sSQL, ConfigurationManager.AppSettings("ConnectionString").ToString)
            dtTemp = BuildRetentionDataTable(dtData)

            If dtTemp.Columns.Count > 2 AndAlso CInt(dtTemp.Rows(0)(1)) > 0 Then
                AddHandler gvMonth.RowDataBound, AddressOf gv_RowDataBound

                gvMonth.DataSource = dtTemp
                gvMonth.DataBind()

                PlaceHolder1.Controls.Add(New LiteralControl("Enrollment Class: <b>" & month.ToString("MMM") & " " & ddlYears.SelectedItem.Value & "</b><br>"))
                PlaceHolder1.Controls.Add(New LiteralControl("Enrolled This Month: " & dtTemp.Rows(0)(1) & "<br>"))
                PlaceHolder1.Controls.Add(gvMonth)
                PlaceHolder1.Controls.Add(New LiteralControl("<br>"))
            End If

            dtData.Clear()
            dtData.Dispose()
            dtData = Nothing

            dtTemp.Dispose()
            dtTemp = Nothing
        Next
    End Sub

    
#End Region

 
    'Protected Sub ddlMonths_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlMonths.SelectedIndexChanged
    '    LoadMonthData()
    'End Sub

    Protected Sub ddlYears_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlYears.SelectedIndexChanged
        LoadMonthData()
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

