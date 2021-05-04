<%@ WebHandler Language="VB" Class="commissiongraph" %>

Imports System
Imports System.IO
Imports System.Web
Imports System.Data
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.Collections.Generic

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Dundas.Charting.WebControl

Public Class commissiongraph
    Implements IHttpHandler
    Implements IRequiresSessionState
    
#Region "Variables"

    Private _width As Integer
    Private _height As Integer
    Private _endDate As Nullable(Of DateTime)
    Private _startDate As Nullable(Of DateTime)
    Private _commRecID As String
    Private _commRecIDop As String
    Private _splitBy As Integer
    Private _groupBy As Integer
    private _spline as Boolean
    Private _pointLabels As Boolean
    Private _pointMarkers As Boolean
    Private _titles As Boolean = True
    Private _3d As Boolean = False

#End Region
    
    Public Sub ProcessRequest(ByVal context As System.Web.HttpContext) Implements System.Web.IHttpHandler.ProcessRequest

        _width = DataHelper.Nz(context.Request.QueryString("w"), 600)
        if _width < 1 Then _width = 1
        _height = DataHelper.Nz(context.Request.QueryString("h"), 240)
        If _height < 1 Then _height = 1
        
        If context.Session("CommissionGraph_EndDate") IsNot Nothing Then
            _endDate = context.Session("CommissionGraph_EndDate")
        End If
        If context.Session("CommissionGraph_StartDate") IsNot Nothing Then
            _startDate = context.Session("CommissionGraph_StartDate")
        End If
        
        _commRecID = context.Request.QueryString("commrecs")
        
        If _commRecID Is Nothing Then
            _commRecID = context.Session("CommissionGraph_CommRecIDs")
        End If
        
        _commRecIDop = context.Session("CommissionGraph_CommRecIDop")
        _splitBy = context.Session("CommissionGraph_SplitBy")
        _groupBy = context.Session("CommissionGraph_GroupBy")
        _3d = context.Session("CommissionGraph_3D")
        _spline = context.Session("CommissionGraph_Spline")
        _pointLabels = context.Session("CommissionGraph_PointLabels")
        _pointMarkers = context.Session("CommissionGraph_PointMarkers")
        _titles = context.Session("CommissionGraph_Titles")
        
        Using chart As New Chart

            BuildChart(chart, context)
            ConfigureChart(chart)
            
            if context.Request.QueryString("download")="true" then
                context.Response.AddHeader("Content-Disposition", "attachment;filename=Commission Comparison Chart.png")
            End If
            context.Response.ContentType = "image/png"

            Using ms As MemoryStream = New MemoryStream()

                'send bmp to memory stream
                chart.Save(ms, ChartImageFormat.png)

                'send memory stream to output stream
                ms.WriteTo(context.Response.OutputStream)
            End Using
        End Using
    End Sub

    Private Sub BuildChart(ByVal chart As Chart, ByVal context As System.Web.HttpContext)
        Dim Serieses As New Dictionary(Of String, Series)

        'Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ChartCommissionComparision_" + context.Request.QueryString("company"))
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ChartCommissionComparision")
            Using cmd.Connection
                cmd.Connection.Open()

                If _startDate.HasValue Then DatabaseHelper.AddParameter(cmd, "startdate", _startDate)
                If _endDate.HasValue Then DatabaseHelper.AddParameter(cmd, "enddate", _endDate)
                DatabaseHelper.AddParameter(cmd, "groupby", _groupBy) 'day
                DatabaseHelper.AddParameter(cmd, "splitby", _splitBy) 'month
                
                If Not String.IsNullOrEmpty(_commRecID) AndAlso Not _commRecID = "-1" Then
                    DatabaseHelper.AddParameter(cmd, "commrecids", _commRecID)
                    DatabaseHelper.AddParameter(cmd, "commrecidsop", _commRecIDop)
                End If
                
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()

                        'Get the data point
                        Dim SeriesDT As DateTime = DatabaseHelper.Peel_date(rd, "splitdate")
                        Dim Group As Integer = DatabaseHelper.Peel_int(rd, "group")
                        Dim Amount As Double = DatabaseHelper.Peel_float(rd, "amount")
                    
                        'Set the series label and ID
                        Dim SeriesStr As String = ""
                        If _splitBy = 2 Then
                            SeriesStr = SeriesDT.ToString("MMM, yy")
                        ElseIf _splitBy = 3 Then
                            SeriesStr = SeriesDT.ToString("yyyy")
                        Else
                            SeriesStr = SeriesDT.ToString("dd MMM, yy")
                        End If
                        
                        'Find/Create the series
                        Dim s As Series = Nothing
                        If Not Serieses.TryGetValue(SeriesStr, s) Then
                            s = New Series(SeriesStr)
                            Serieses.Add(SeriesStr, s)
                        End If
                        
                        'Set the axis label
                        Dim pntNew As New DataPoint
                        If _groupBy = 2 And _splitBy = 3 Then 'Monthly / Yearly
                            pntNew.AxisLabel = New DateTime(Now.Year, Group, 1).ToString("MMM")
                        ElseIf _groupBy = 0 And _splitBy = 1 Then 'Daily / Weekly
                            pntNew.AxisLabel = WeekdayName(Group, True, Microsoft.VisualBasic.FirstDayOfWeek.Sunday)
                            'ElseIf _groupBy = 0 And (_splitBy = 2 Or _splitBy = 3) Then 'Daily / (Monthly or Yearly)
                            '    pntNew.AxisLabel = Group
                        ElseIf _groupBy = 1 Then 'Weekly / (Monthly or Yearly)
                            pntNew.AxisLabel = "Wk " & Group
                        End If
                        
                        'Set the x/y values, and add the point to the series
                        pntNew.XValue = Group
                        pntNew.YValues = New Double() {Amount / 1000}
                        If _pointLabels Then
                            pntNew.Label = (Amount / 1000).ToString("c") + "k"
                        End If
                        s.Points.Add(pntNew)
                    End While
                End Using
            End Using
        End Using

        chart.ChartAreas.Add("Default")

        For Each s As Series In Serieses.Values
            s.ChartArea = "Default"
            chart.Series.Add(s)
        Next
    End Sub
    Private Function Transparent(ByVal c As Color, ByVal alpha As Integer) As Color
        Return Color.FromArgb(alpha, c.R, c.G, c.B)
    End Function
    Private Sub ConfigureChart(ByVal chart As Chart)

        With chart

            .Width = _width
            .Height = _height

            .AntiAliasing = AntiAliasing.All
            .TextAntiAliasingQuality = TextAntiAliasingQuality.High

            Dim graphColor As Color() = New Color() {Color.Blue, Color.Red, Color.Yellow, Color.Green, Color.Orange, Color.Cyan, Color.Purple, Color.Black, Color.Gray, Color.White, Color.Beige, Color.HotPink, Color.LightBlue, Color.LightGreen, Color.LightYellow, Color.LimeGreen, Color.Orchid, Color.SeaGreen, Color.Sienna, Color.Teal, Color.WhiteSmoke, Color.Silver, Color.MintCream, Color.MistyRose}
            
            For Each s As Series In .Series
                If _spline Then
                    s.Type = SeriesChartType.Spline
                Else
                    s.Type = SeriesChartType.Line
                End If
                
                s.ShowLabelAsValue = False
                s("PointWidth") = "0.7"
                
                s.Font = New Font("Tahoma", 11, FontStyle.Regular, GraphicsUnit.Pixel)
                s.BorderColor = Color.Black
                s.Color = Transparent(graphColor(.Series.Count - 1 - .Series.IndexOf(s)), 180)
                If _pointMarkers Then
                    s.MarkerStyle = MarkerStyle.Diamond
                End If
            Next

            With .Legends("Default")
                .Docking = LegendDocking.Bottom
                .ShadowColor = Color.FromArgb(200, 200, 200)
                .ShadowOffset = 5
                .BorderColor = Color.Gray
                .Alignment = StringAlignment.Center
                .Font = New Font("Tahoma", 11, FontStyle.Regular, GraphicsUnit.Pixel)
            End With

            If _titles Then
                .Titles.Add(New Title("Commission Comparison", Docking.Top, _
                    New Font("Tahoma", 12, FontStyle.Bold, GraphicsUnit.Pixel), Color.Black))
            
                Dim by As String = ""
                Dim per As String = ""
                Select Case _groupBy
                    Case 0
                        by = "Day"
                    Case 1
                        by = "Week"
                    Case 2
                        by = "Month"
                End Select
            
                Select Case _splitBy
                    Case 1
                        per = "Week"
                    Case 2
                        per = "Month"
                    Case 3
                        per = "Year"
                End Select
            
                .Titles.Add(New Title("(By " & by & " Per " & per & ")", Docking.Top, _
                    New Font("Tahoma", 11, FontStyle.Regular, GraphicsUnit.Pixel), Color.Black))
            End If
            
            With .ChartAreas("Default")
                
                .BackColor = Color.FromArgb(245, 245, 245)
                
                With .AxisY
                    .TitleFont = New Font("Tahoma", 11, FontStyle.Regular, GraphicsUnit.Pixel)
                    
                    .LabelStyle.Font = New Font("Tahoma", 11, FontStyle.Regular, GraphicsUnit.Pixel)
                    .IntervalAutoMode = IntervalAutoMode.VariableCount
                    
                    If _titles Then
                        .Title = "Dollars (Thousands)"
                        .LabelStyle.Format = "$#,##0.##"
                    Else
                        .LabelStyle.Format = "$#,##0.## k"
                    End If
                    
                    With .MajorGrid
                        .LineColor = Color.LightGray
                    End With
                End With

                With .AxisX
                    .LabelStyle.Font = New Font("Tahoma", 9, FontStyle.Regular, GraphicsUnit.Pixel)
                    .Interval = 1
                    .MajorGrid.Enabled = False
                End With
                
                If _3d Then
                    With .Area3DStyle
                        .Enable3D = True
                        .Perspective = 5
                        .PointDepth = 200
                        .PointGapDepth = 0
                    End With
                End If
            End With
        End With

    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class
