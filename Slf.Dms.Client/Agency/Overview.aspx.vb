Imports System.Data
Imports System.Data.SqlClient
Imports Infragistics.UltraGauge.Resources
Imports SharedFunctions.AsyncDB
Imports Drg.Util.DataAccess

Partial Class Agency_Overview
    Inherits System.Web.UI.Page

    Private UserID As Integer
    Private CompanyID As Integer = -1

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsNumeric(Request.QueryString("id")) Then
            UserID = CInt(Request.QueryString("id"))
        Else
            UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        End If

        If IsNumeric(Request.QueryString("c")) Then
            CompanyID = CInt(Request.QueryString("c"))
        End If

        FormatNetIncomeGrid()
        FormatClientGauge()

        UltraChart2.TitleTop.Font = New Drawing.Font("tahoma", 12, Drawing.FontStyle.Bold, Drawing.GraphicsUnit.Point)
        UltraChart2.TitleTop.Text = MonthName(Now.Month) & Space(1) & Now.Year.ToString

        ucCurrentClientStatus.Tooltips.Display = Infragistics.UltraChart.Shared.Styles.TooltipDisplay.MouseMove
        ucCurrentClientStatus.Tooltips.FormatString = "<DATA_VALUE:00> client(s)"

        If Now > "#" & Format(Now, "MM/dd/yyyy") & " 10:00:00 AM#" Then
            Me.lblNotes.Text = ""
        Else
            Me.lblNotes.Text = "Today's fee breakdown will be available after 10:00 AM PST."
        End If

        'gvNetIncome.Caption = "<span style=""font-family:tahoma;font-size:12pt;font-weight:400;"">Income " & Now.Year.ToString & "</span>"
    End Sub

    Private Sub FormatClientGauge()
        'Dim cnString As String = System.Configuration.ConfigurationManager.ConnectionStrings("DMS_RESTOREDConnectionString").ToString
        'Dim NewClientsCount As String = executeScalar("stp_Agency_Dashboard_NewClients " & UserID & ", " & CompanyID, cnString)

        ''Dim gauge As LinearGauge = Me.UltraGauge1.Gauges(0)

        'gauge.Scales(0).Axis.SetEndValue(2500)
        'gauge.Scales(0).Axis.SetTickmarkInterval(250)


        'Dim marker As LinearGaugeMarker = gauge.Scales(0).Markers(0)
        'Dim value As Integer = Convert.ToInt32(NewClientsCount)
        'marker.Value = value
        ''Dim annot As BoxAnnotation = UltraGauge1.Annotations(0)

        'annot.Label.FormatString = MonthName(Now.Month) & Space(1) & Now.Year.ToString & vbCrLf & value & " Recv'd Clients"
    End Sub

    Private Sub FormatNetIncomeGrid()
        Dim dw As DataView = ds_IncomeGrid.Select(DataSourceSelectArguments.Empty)
        Dim field As BoundField

        gvNetIncome.Columns.Clear()

        For Each col As DataColumn In dw.Table.Columns
            field = New BoundField
            field.HeaderStyle.HorizontalAlign = HorizontalAlign.Right

            field.ItemStyle.HorizontalAlign = HorizontalAlign.Right
            field.DataField = col.ColumnName

            If col.ColumnName = "Label" Then
                field.HeaderText = ""
            Else
                field.HeaderText = col.ColumnName
                field.DataFormatString = "{0:C}"
            End If

            gvNetIncome.Columns.Add(field)
        Next
    End Sub

    'Protected Sub UltraGauge1_AsyncRefresh(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGauge.RefreshEventArgs) Handles UltraGauge1.AsyncRefresh
    '    Dim cnString As String = System.Configuration.ConfigurationManager.ConnectionStrings("DMS_RESTOREDConnectionString").ToString
    '    Dim NewClientsCount As String = executeScalar("stp_Agency_Dashboard_NewClients", cnString)

    '    Dim gauge As LinearGauge = Me.UltraGauge1.Gauges(0)
    '    Dim marker As LinearGaugeMarker = gauge.Scales(0).Markers(0)
    '    Dim value As Integer = Convert.ToInt32(NewClientsCount)
    '    marker.Value = value

    '    Dim annot As BoxAnnotation = UltraGauge1.Annotations(0)
    '    annot.Label.FormatString = MonthName(Now.Month) & Space(1) & Now.Year.ToString & vbCrLf & value & " Recv'd Clients"
    'End Sub

    Protected Sub ds_IncomeGrid_Selecting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceSelectingEventArgs) Handles ds_IncomeGrid.Selecting
        e.Command.CommandTimeout = 90
    End Sub

    Protected Sub ds_NetIncome_Selecting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceSelectingEventArgs) Handles ds_NetIncome.Selecting
        e.Command.CommandTimeout = 90
    End Sub
End Class
