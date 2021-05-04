Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO
Imports System.Runtime.Serialization.Json
Imports System.Web.UI.DataVisualization.Charting

Imports Drg.Util.DataAccess

Partial Class admin_settlementtrackerimport_reports_Default
    Inherits PermissionPage

    #Region "Fields"

    Private _userid As Integer

    #End Region 'Fields

    #Region "Properties"

    Public Property ReportMonth() As Integer
        Get
            Return ViewState("ReportMonth")
        End Get
        Set(ByVal value As Integer)
            ViewState("ReportMonth") = value
        End Set
    End Property

    Public Property ReportYear() As Integer
        Get
            Return ViewState("ReportYear")
        End Get
        Set(ByVal value As Integer)
            ViewState("ReportYear") = value
        End Set
    End Property

    Public Property TrendTotalUnits() As Integer
        Get
            Return ViewState("_TrendTotalUnits")
        End Get
        Set(ByVal value As Integer)
            ViewState("_TrendTotalUnits") = value
        End Set
    End Property

    Public Property TrendUniqueCreditors() As Integer
        Get
            Return ViewState("_TrendUniqueCreditors")
        End Get
        Set(ByVal value As Integer)
            ViewState("_TrendUniqueCreditors") = value
        End Set
    End Property

    Public Property Userid() As Integer
        Get
            Return _userid
        End Get
        Set(ByVal value As Integer)
            _userid = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub

    Public Function getReportDate(ByVal reportDate As String) As String
        Dim dString As String = reportDate
        If IsDate(reportDate) Then
            dString = DateTime.Parse(reportDate).DayOfWeek
        Else
            dString = ""
        End If
        Return dString
    End Function

    Protected Sub admin_settlementtrackerimport_reports_Default_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Userid = DataHelper.Nz_int(Page.User.Identity.Name)

        If hdnMonth.Value = "" Then
            hdnMonth.Value = Now.Month
        End If
        If hdnYear.Value = "" Then
            hdnYear.Value = Now.Year
        End If
        ReportMonth = hdnMonth.Value
        ReportYear = hdnYear.Value
        If Not IsPostBack Then
            LoadCharts()
        End If



        SetRollups()
    End Sub

    Protected Sub chartStream_Click(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.ImageMapEventArgs) Handles chartFees.Click
        Dim pointIndex As Int32 = Int32.Parse(e.PostBackValue)
        Dim series As Series = chartFees.Series("Default")
        If (pointIndex >= 0 AndAlso pointIndex < series.Points.Count) Then
            series.Points(pointIndex)("Exploded") = "True"
        End If
    End Sub

    Protected Sub lnkChangeMonth_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeMonth.Click
        LoadCharts()
    End Sub

    Protected Sub lnkChangeYear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeYear.Click
        LoadCharts()
    End Sub

    Private Function BuildDateSelectionsHTMLControlString() As StringBuilder
        Dim selectCode As New StringBuilder
        selectCode.Append("Select Month <br/>")
        selectCode.Append("<select id=""cboMonth"" runat=""server"" class=""entry"" onchange=""MonthChanged(this);"">")
        For i As Integer = 1 To 12
            Dim optText As String = ""
            If i = ReportMonth Then
                optText = String.Format("<option label=""{0}"" value=""{1}"" selected=""selected"" />", MonthName(i, False), i)
            Else
                optText = String.Format("<option label=""{0}"" value=""{1}"" />", MonthName(i, False), i)
            End If
            selectCode.Append(optText)
        Next
        selectCode.Append("</select><br/>")
        selectCode.Append("Select Year<br/>")
        selectCode.Append("<select id=""cboYear"" runat=""server"" class=""entry"" onchange=""YearChanged(this);"">")
        For i As Integer = Now.AddYears(-3).Year To Now.Year
            Dim optText As String = ""
            If i = ReportYear Then
                optText = String.Format("<option label=""{0}"" value=""{1}"" selected=""selected"" />", i, i)
            Else
                optText = String.Format("<option label=""{0}"" value=""{1}"" />", i, i)
            End If
            selectCode.Append(optText)
        Next
        selectCode.Append("</select><br/>")
        selectCode.AppendFormat("<br/><a href=""{0}"">Home</a>", ResolveUrl("../../settlementtrackerimport/default.aspx"))
        Return selectCode
    End Function

    Private Sub CreatePaidFeesChart(ByVal dv As DataView)
        'paid fees
        Using dtPaidFees As DataTable = dv.ToTable()
            If dtPaidFees.Rows.Count > 0 Then
                For Each row As DataRow In dtPaidFees.Rows
                    Dim seriesName As String = row("paid").ToString
                    If seriesName.ToLower <> "total" Then
                        Dim feeAmt As Double = row("fees").ToString
                        chartFees.Series("Default").Points.AddXY(seriesName, feeAmt)
                    End If
                Next
                With chartFees
                    .DataSource = dtPaidFees
                    .DataBind()

                    .ChartAreas("ChartArea1").Area3DStyle.Inclination = 35
                    .ChartAreas("ChartArea1").Area3DStyle.Enable3D = True
                    .ChartAreas("ChartArea1").InnerPlotPosition.Auto = False
                    .ChartAreas("ChartArea1").InnerPlotPosition.X = 0
                    .ChartAreas("ChartArea1").InnerPlotPosition.Y = 0
                    .ChartAreas("ChartArea1").InnerPlotPosition.Width = 100
                    .ChartAreas("ChartArea1").InnerPlotPosition.Height = 100

                    .Series("Default").ChartType = SeriesChartType.Pie
                    .Series("Default").LabelFormat = "C2"

                    .Series("Default").IsValueShownAsLabel = True
                    .Series("Default").ToolTip = "#VALX" + ControlChars.Lf + "#VALY{C2}"
                    .Series("Default").LegendPostBackValue = "#INDEX"

                    'Add header separator of type line
                    .Legends("Default").HeaderSeparator = LegendSeparatorStyle.Line
                    .Legends("Default").HeaderSeparatorColor = Color.Gray

                    'Add Color column
                    Dim firstColumn As New LegendCellColumn()
                    firstColumn.ColumnType = LegendCellColumnType.SeriesSymbol
                    firstColumn.HeaderText = "Color"
                    firstColumn.HeaderBackColor = Color.WhiteSmoke
                    .Legends("Default").CellColumns.Add(firstColumn)

                    'Add Legend Text column
                    Dim secondColumn As New LegendCellColumn
                    secondColumn.ColumnType = LegendCellColumnType.Text
                    secondColumn.HeaderText = "Team"
                    secondColumn.Alignment = ContentAlignment.BottomLeft
                    secondColumn.Text = "#LEGENDTEXT"
                    secondColumn.HeaderBackColor = Color.WhiteSmoke
                    .Legends("Default").CellColumns.Add(secondColumn)

                    'Add Total cell column
                    Dim totalColumn As New LegendCellColumn()
                    totalColumn.Text = "#VALY{C2}"
                    totalColumn.HeaderText = "Total"
                    totalColumn.Alignment = ContentAlignment.MiddleRight
                    'totalColumn.Name = "TotalColumn"
                    totalColumn.HeaderBackColor = Color.WhiteSmoke
                    .Legends("Default").CellColumns.Add(totalColumn)

                End With

            End If
        End Using
    End Sub

    Private Sub CreatePaidUnitChart(ByVal dv As DataView)
        'paid sett
        Using dtPaid As DataTable = dv.ToTable()

            If dtPaid.Rows.Count > 0 Then
                For Each row As DataRow In dtPaid.Rows
                    Dim seriesName As String = row("paid").ToString
                    If seriesName.ToLower <> "total" Then
                        Dim unitTot As Integer = row("units").ToString
                        chartPaid.Series("Series1").ChartType = DataVisualization.Charting.SeriesChartType.Bar
                        chartPaid.Series("Series1").Points.AddXY(seriesName, unitTot)
                    End If
                Next
                chartPaid.DataSource = dtPaid
                chartPaid.DataBind()
                chartPaid.Series("Series1").IsValueShownAsLabel = True
                chartPaid.Series("Series1").ToolTip = "Units : #VALY{N0}"
                chartPaid.ChartAreas("ChartArea1").InnerPlotPosition.Auto = False
                chartPaid.ChartAreas("ChartArea1").InnerPlotPosition.X = 15
                chartPaid.ChartAreas("ChartArea1").InnerPlotPosition.Y = 5
                chartPaid.ChartAreas("ChartArea1").InnerPlotPosition.Width = 80
                chartPaid.ChartAreas("ChartArea1").InnerPlotPosition.Height = 85
                chartPaid.ChartAreas("ChartArea1").AxisY.LabelAutoFitStyle = LabelAutoFitStyles.DecreaseFont
                chartPaid.ChartAreas("ChartArea1").AxisX.LabelAutoFitStyle = LabelAutoFitStyles.DecreaseFont

            End If
        End Using
    End Sub

    Private Sub Create_YTD_Charts(ByVal dtYTD As DataTable)
        For Each row As DataRow In dtYTD.Rows
            Dim feeAmt As Double = row("fees").ToString
            Dim monName As String = MonthName(row("settmonth").ToString, True)
            If monName.ToLower <> "total" Then
                Dim unitCnt As Integer = row("units").ToString
                chartYTDFees.Series("Series1").Points.AddXY(monName, feeAmt)
                chartYTDUnits.Series("Series1").Points.AddXY(monName, unitCnt)
            End If
            
        Next
        chartYTDFees.Series("Series1").ChartType = SeriesChartType.Line
        chartYTDFees.Series("Series1").IsValueShownAsLabel = False
        chartYTDFees.Series("Series1")("ShowMarkerLines") = "True"
        chartYTDFees.Series("Series1").SmartLabelStyle.Enabled = True
        chartYTDFees.Series("Series1").SmartLabelStyle.CalloutStyle = LabelCalloutStyle.None
        chartYTDFees.Series("Series1").LabelFormat = "C2"

        chartYTDFees.ChartAreas("ChartArea1").AxisX.IsMarginVisible = True
        chartYTDFees.ChartAreas("ChartArea1").Area3DStyle.Enable3D = False
        chartYTDFees.ChartAreas("ChartArea1").AxisY.LabelStyle.Format = "C2"
        chartYTDFees.ChartAreas("ChartArea1").AxisY.LabelAutoFitStyle = LabelAutoFitStyles.DecreaseFont
        chartYTDFees.ChartAreas("ChartArea1").AxisX.LabelAutoFitStyle = LabelAutoFitStyles.DecreaseFont

        chartYTDUnits.Series("Series1").ChartType = SeriesChartType.Line
        chartYTDUnits.Series("Series1").IsValueShownAsLabel = False
        chartYTDUnits.Series("Series1").SmartLabelStyle.Enabled = True
        chartYTDUnits.Series("Series1").SmartLabelStyle.CalloutStyle = LabelCalloutStyle.None
        chartYTDUnits.ChartAreas("ChartArea1").AxisY.LabelAutoFitStyle = LabelAutoFitStyles.DecreaseFont
        chartYTDUnits.ChartAreas("ChartArea1").AxisX.LabelAutoFitStyle = LabelAutoFitStyles.DecreaseFont

        chartYTDUnits.Series("Series1").ToolTip = "#VALY"
        chartYTDFees.Series("Series1").ToolTip = "#VALY{C2}"
    End Sub

    Private Sub LoadCharts()
        dsPaid.SelectParameters("year").DefaultValue = ReportYear
        dsPaid.SelectParameters("month").DefaultValue = ReportMonth

        Using dv As DataView = dsPaid.Select(DataSourceSelectArguments.Empty)
            CreatePaidUnitChart(dv)
            CreatePaidFeesChart(dv)
        End Using

        Using dtYTD As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync("stp_settlementimport_reports_getYTD", ConfigurationManager.AppSettings("connectionstring").ToString)
            Create_YTD_Charts(dtYTD)
        End Using

        For Each Series As Series In chartFees.Series
            Series.PostBackValue = "#INDEX"
        Next
    End Sub

    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settlementtrackerimport_trackerimport).CommonTasks

        Dim selectCode As StringBuilder = BuildDateSelectionsHTMLControlString()

        CommonTasks.Add(selectCode.ToString)
    End Sub

    #End Region 'Methods

End Class