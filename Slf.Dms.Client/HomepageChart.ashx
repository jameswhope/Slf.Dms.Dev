<%@ WebHandler Language="VB" Class="HomepageChart" %>

Imports System
Imports System.Drawing
Imports System.Data
Imports System.Web

Imports WebChart

Imports Drg.Util.DataAccess
Imports Drg.Util.Helpers

Public Class HomepageChart : Inherits BaseGraphHandler
    
    Private HighestValue As Single = 0
    Private XTitle As String = String.Empty
    
    Public graphColor As Color() = New Color() {Color.Red, Color.Blue, Color.Green, Color.Yellow, Color.Cyan, Color.Purple, Color.Black, Color.Gray, Color.Orange, Color.White, Color.Beige, Color.HotPink, Color.LightBlue, Color.LightGreen, Color.LightYellow, Color.LimeGreen, Color.Orchid, Color.SeaGreen, Color.Sienna, Color.Teal, Color.WhiteSmoke, Color.Silver, Color.MintCream, Color.MistyRose}
    
    Private Function GetAreaChart(ByVal data As ChartPointCollection) As Chart
        Dim c As Chart = New AreaChart(data, Color.Black)
        With c
            .ShowLineMarkers = False
            .Line.Width = 0.5
            .Line.Color = Color.FromArgb(100, 100, 100)
            .Fill.Type = InteriorType.LinearGradient
            .Fill.EndPoint = New Point(200, 50)
            .Fill.ForeColor = Color.FromArgb(136, 204, 175)
        End With
        Return c
    End Function

    Private Function GetBarChart(ByVal data As ChartPointCollection) As Chart
        Dim c As Chart = New ColumnChart(data, Color.Black)
        With c
            .Line.Color = Color.FromArgb(175, 175, 175)
            .ShowLineMarkers = False
            .Fill.Type = InteriorType.LinearGradient
            .Fill.EndPoint = New Point(700, 300)
            .Fill.ForeColor = Color.FromArgb(136, 204, 175)
            .Fill.Color = Color.White
        End With
        Return c
    End Function

    Private Function GetEnrollmentData(ByVal cmd As IDbCommand, ByVal Grouping As Integer) As ChartPointCollection
        Dim data As ChartPointCollection = New ChartPointCollection
        Using cmd
            DatabaseHelper.AddParameter(cmd, "DateGrouping", Grouping)
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()

                    Dim Format As String = Nothing
                    
                    Select Case Grouping
                        Case 2 'monthly
                            Format = "MMM yyyy"
                        Case 3 'annually
                            Format = "yyyy"
                        Case Else
                            Format = "MM/dd/yy"
                    End Select

                    While rd.Read()

                        Dim Time As String = DatabaseHelper.Peel_datestring(rd, "Time", Format)
                        Dim CountEnrollment As Integer = DatabaseHelper.Peel_int(rd, "CountEnrollment")

                        data.Add(New ChartPoint(Time, CountEnrollment))

                        If CountEnrollment > HighestValue Then
                            HighestValue = CountEnrollment
                        End If

                    End While

                    If data.Count > 0 Then
                        If data.Count = 1 Then
                            XTitle = data(0).XValue
                        Else
                            XTitle = data(0).XValue & " - " & data(data.Count - 1).XValue
                        End If
                    Else
                        XTitle = "No Data"
                    End If

                End Using
            End Using
        End Using
        Return data
    End Function
    
    Private Function GetServiceFeesData(ByVal cmd As IDbCommand, ByVal Grouping As Integer) As ChartPointCollection
        Dim data As ChartPointCollection = New ChartPointCollection
        Using cmd
            DatabaseHelper.AddParameter(cmd, "DateGrouping", Grouping)
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()

                    Dim Format As String = Nothing
                    
                    Select Case Grouping
                        Case 2 'monthly
                            Format = "MMM yyyy"
                        Case 3 'annually
                            Format = "yyyy"
                        Case Else
                            Format = "MM/dd/yy"
                    End Select

                    While rd.Read()

                        Dim Time As String = DatabaseHelper.Peel_datestring(rd, "Time", Format)
                        Dim Amount As Single = DatabaseHelper.Peel_float(rd, "Amount")

                        data.Add(New ChartPoint(Time, Amount))

                        If Amount > HighestValue Then
                            HighestValue = Amount
                        End If

                    End While

                    If data.Count > 0 Then
                        If data.Count = 1 Then
                            XTitle = data(0).XValue
                        Else
                            XTitle = data(0).XValue & " - " & data(data.Count - 1).XValue
                        End If
                    Else
                        XTitle = "No Data"
                    End If

                End Using
            End Using
        End Using
        Return data
    End Function

    Private Function GetEnrollmentSummary(ByVal cmd As IDbCommand, ByVal Grouping As Integer) As ArrayList

        Dim charts As ArrayList = New ArrayList

        Dim dataEnrolled As New ChartPointCollection
        Dim dataWouldNotCommit As New ChartPointCollection
        Dim dataDidNotQualify As New ChartPointCollection

        Using cmd
            Using cmd.Connection

                DatabaseHelper.AddParameter(cmd, "DateGrouping", Grouping)

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    Dim Format As String = Nothing

                    Select Case Grouping
                        Case 2 'monthly
                            Format = "MMM yyyy"
                        Case 3 'annually
                            Format = "yyyy"
                        Case Else
                            Format = "MM/dd/yy"
                    End Select

                    While rd.Read

                        Dim Time As String = DatabaseHelper.Peel_datestring(rd, "Time", Format)

                        Dim CountEnrolled As Integer = DataHelper.Nz_int(DatabaseHelper.Peel_int(rd, "CountEnrolled"))
                        Dim CountWouldNotCommit As Integer = DataHelper.Nz_int(DatabaseHelper.Peel_int(rd, "CountWouldNotCommit"))
                        Dim CountDidNotQualify As Integer = DataHelper.Nz_int(DatabaseHelper.Peel_int(rd, "CountDidNotQualify"))

                        dataEnrolled.Add(New ChartPoint(Time, CountEnrolled))
                        dataWouldNotCommit.Add(New ChartPoint(Time, CountWouldNotCommit))
                        dataDidNotQualify.Add(New ChartPoint(Time, CountDidNotQualify))

                        If CountEnrolled > HighestValue Then
                            HighestValue = CountEnrolled
                        End If

                        If CountWouldNotCommit > HighestValue Then
                            HighestValue = CountWouldNotCommit
                        End If

                        If CountDidNotQualify > HighestValue Then
                            HighestValue = CountDidNotQualify
                        End If

                    End While
                End Using
            End Using
        End Using

        If dataEnrolled.Count > 0 Then
            If dataEnrolled.Count = 1 Then
                XTitle = dataEnrolled(0).XValue
            Else
                XTitle = dataEnrolled(0).XValue & " - " & dataEnrolled(dataEnrolled.Count - 1).XValue
            End If
        Else
            XTitle = "No Data"
        End If

        Dim chartEnrolled As New SmoothLineChart(dataEnrolled)
        Dim chartWouldNotCommit As New SmoothLineChart(dataWouldNotCommit)
        Dim chartDidNotQualify As New SmoothLineChart(dataDidNotQualify)

        With chartEnrolled
            .Line.Color = Color.Green
            .ShowLineMarkers = False
        End With

        With chartWouldNotCommit
            .Line.Color = Color.Blue
            .ShowLineMarkers = False
        End With

        With chartDidNotQualify
            .Line.Color = Color.Red
            .ShowLineMarkers = False
        End With

        charts.Add(chartEnrolled)
        charts.Add(chartWouldNotCommit)
        charts.Add(chartDidNotQualify)

        Return charts

    End Function

    Protected Overrides Sub PostProcess(ByVal ChartImage As Bitmap)

        Using g As Graphics = Graphics.FromImage(ChartImage)

            Dim f As New Font("Tahoma", 11, FontStyle.Regular, GraphicsUnit.Pixel)

            Dim s As SizeF = g.MeasureString(XTitle, f)

            g.DrawString(XTitle, f, Brushes.Black, (ChartImage.Width - s.Width) / 2, 140)

        End Using

    End Sub
    
    Protected Overrides Sub SetupChart(ByVal engine As WebChart.ChartEngine, ByVal queryString As NameValueCollection)

        Dim UserID As Integer = DataHelper.Nz_int(HttpContext.Current.User.Identity.Name)
        Dim AgencyID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblAgency", "AgencyId", "UserId=" & UserID))
                
        Dim chartId As Integer = StringHelper.ParseInt(queryString("chartid"), 0)
        Dim width As Integer = StringHelper.ParseInt(queryString("w"), 200)
        Dim height As Integer = StringHelper.ParseInt(queryString("h"), 160)
        Dim grouping As Integer = StringHelper.ParseInt(queryString("g"), 1)
        
        Dim range As String = CreateRange("tblenrollment.Created", DataHelper.Nz_string(queryString("r")))
        Dim rangeCommBatch As String = CreateRange("tblcommbatch.batchdate", DataHelper.Nz_string(queryString("r")))
        Dim rangeRegister As String = CreateRange("tblregister.transactiondate", DataHelper.Nz_string(queryString("r")))

        engine.Size = New Size(width, height)

        Select Case chartId
            Case 0 'Prospects - Entered (All)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentEntered")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range)
                engine.Charts.Add(GetAreaChart(GetEnrollmentData(cmd, grouping)))
                ConfigureChartColors(engine)
            Case 1 'Prospects - Entered (Mine)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentEntered")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range & " AND tblenrollment.CreatedBy=" & UserID)
                engine.Charts.Add(GetAreaChart(GetEnrollmentData(cmd, grouping)))
                ConfigureChartColors(engine)
            Case 2 'Prospects - Enrolled (All)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentEnrolled")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range)
                engine.Charts.Add(GetAreaChart(GetEnrollmentData(cmd, grouping)))
                ConfigureChartColors(engine)
            Case 3 'Prospects - Enrolled (Mine)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentEnrolled")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range & " AND tblenrollment.CreatedBy=" & UserID)
                engine.Charts.Add(GetAreaChart(GetEnrollmentData(cmd, grouping)))
                ConfigureChartColors(engine)
            Case 4 'Prospects - Did Not Qualify (All)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentDidNotQualify")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range)
                engine.Charts.Add(GetAreaChart(GetEnrollmentData(cmd, grouping)))
                ConfigureChartColors(engine)
            Case 5 'Prospects - Did Not Qualify (Mine)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentDidNotQualify")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range & " AND tblenrollment.CreatedBy=" & UserID)
                engine.Charts.Add(GetAreaChart(GetEnrollmentData(cmd, grouping)))
                ConfigureChartColors(engine)
            Case 6 'Prospects - Would Not Commit (All)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentWouldNotCommit")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range)
                engine.Charts.Add(GetAreaChart(GetEnrollmentData(cmd, grouping)))
                ConfigureChartColors(engine)
            Case 7 'Prospects - Would Not Commit (Mine)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentWouldNotCommit")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range & " AND tblenrollment.CreatedBy=" & UserID)
                engine.Charts.Add(GetAreaChart(GetEnrollmentData(cmd, grouping)))
                ConfigureChartColors(engine)
            Case 8 'Prospects - Success Rate (All)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentSummary")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range)
                For Each c As Chart In GetEnrollmentSummary(cmd, grouping)
                    engine.Charts.Add(c)
                Next
                ConfigureChartColors(engine)
            Case 9 'Prospects - Success Rate (Mine)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentSummary")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range & " AND tblenrollment.CreatedBy=" & UserID)
                For Each c As Chart In GetEnrollmentSummary(cmd, grouping)
                    engine.Charts.Add(c)
                Next
                ConfigureChartColors(engine)
            Case 10 'Prospects - Entered (Agency)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentEntered")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range & " AND tblClient.AgencyId=" & AgencyID)
                engine.Charts.Add(GetAreaChart(GetEnrollmentData(cmd, grouping)))
                ConfigureChartColors(engine)
            Case 11 'Prospects - Enrolled (Agency)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentEnrolled")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range & " AND tblClient.AgencyId=" & AgencyID)
                engine.Charts.Add(GetAreaChart(GetEnrollmentData(cmd, grouping)))
                ConfigureChartColors(engine)
            Case 12 'Prospects - Did Not Qualify (Agency)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentDidNotQualify")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range & " AND tblClient.AgencyId=" & AgencyID)
                engine.Charts.Add(GetAreaChart(GetEnrollmentData(cmd, grouping)))
                ConfigureChartColors(engine)
            Case 13 'Prospects - Would Not Commit (Agency)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentWouldNotCommit")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range & " AND tblClient.AgencyId=" & AgencyID)
                engine.Charts.Add(GetAreaChart(GetEnrollmentData(cmd, grouping)))
                ConfigureChartColors(engine)
            Case 14 'Prospects - Success Rate (Agency)
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartEnrollmentSummary")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & range & " AND tblClient.AgencyId=" & AgencyID)
                For Each c As Chart In GetEnrollmentSummary(cmd, grouping)
                    engine.Charts.Add(c)
                Next
                ConfigureChartColors(engine)
            Case 15 'Service Fees - Payments Made
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartServiceFees")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & rangeCommBatch & " AND agencyid=" & AgencyID)
                engine.Charts.Add(GetAreaChart(GetServiceFeesData(cmd, grouping)))
                ConfigureChartColors(engine)
            Case 16 'Service Fees - New Receivables
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_HomepageChartReceivable")
                DatabaseHelper.AddParameter(cmd, "RefWhere", "AND " & rangeRegister & " AND tblClient.agencyid=" & AgencyID)
                engine.Charts.Add(GetAreaChart(GetServiceFeesData(cmd, grouping)))
                ConfigureChartColors(engine)
        End Select
    End Sub

    Private Sub ConfigureChartColors(ByVal e As ChartEngine)
        With e
            .Padding = 0
            .ChartPadding = 10
            .TopPadding = 0
            .TopChartPadding = 5
            .RightChartPadding = 10
            .BottomChartPadding = 20
            .GridLines = WebChart.GridLines.Horizontal
            .Background.Color = Color.FromArgb(214, 231, 243)
            .Border.Color = Color.Gainsboro
            .Border.Width = 1

            If (HighestValue > 0 AndAlso HighestValue >= 8) Or (.Charts(0).Data.Count = 0) Then
                .YValuesInterval = CType(HighestValue / 8, Integer)
            Else
                .YValuesInterval = 1
            End If

            With .YAxisFont
                .StringFormat.Alignment = StringAlignment.Far
                .Font = New Font("Arial", 10, FontStyle.Regular, GraphicsUnit.Pixel)
            End With
            With .XAxisFont
                .StringFormat.Alignment = StringAlignment.Center
                .StringFormat.FormatFlags = StringFormatFlags.DirectionVertical
                .StringFormat.HotkeyPrefix = System.Drawing.Text.HotkeyPrefix.None
                .StringFormat.LineAlignment() = StringAlignment.Center
                .StringFormat.Trimming = StringTrimming.Character
                .Font = New Font("Arial", 10, FontStyle.Regular, GraphicsUnit.Pixel)
            End With
            With .PlotBackground
                .Color = Color.White 'Color.FromArgb(214, 231, 243)
                .CenterPoint = New Point(0, 0)
                .EndPoint = New Point(200, 200)
                .ForeColor = Color.Black
                .Type = InteriorType.Solid
            End With

            e.ShowYValues = True
            e.ShowXValues = False

            If HighestValue > 0 Then
                e.LeftChartPadding = HighestValue.ToString.Length * 5
            Else
                e.LeftChartPadding = 15
            End If

            If e.Charts.Count > 0 AndAlso e.Charts(0).Data.Count > 0 Then
                e.XTicksInterval = e.Charts(0).Data.Count
            End If

        End With
    End Sub

    Private Function CreateRange(ByVal Field As String, ByVal QueryStringRange As String) As String

        Field = DataHelper.StripTime(Field)

        Select Case QueryStringRange.ToLower
            Case "0" 'Past 360 Days
                Return Field & " >= '" & Now.AddDays(-360).ToString("MM/dd/yyyy") & "'"
            Case "1" 'Past 180 Days
                Return Field & " >= '" & Now.AddDays(-180).ToString("MM/dd/yyyy") & "'"
            Case "2" 'Past 90 Days
                Return Field & " >= '" & Now.AddDays(-90).ToString("MM/dd/yyyy") & "'"
            Case "3" 'This Calendar Year
                Return Field & " BETWEEN '1/1/" & Now.Year & "' AND '12/31/" & Now.Year & "'"
            Case "4" 'This Month
                Return Field & " BETWEEN '" & Now.Month & "/1/" & Now.Year & "' AND '" & Now.Month & "/" & DateTime.DaysInMonth(Now.Year, Now.Month) & "/" & Now.Year & "'"
            Case "5" 'This Week

                Dim FirstDayOfWeek As DateTime = Now
                Dim LastDayOfWeek As DateTime = Now

                While Not FirstDayOfWeek.DayOfWeek = DayOfWeek.Sunday
                    FirstDayOfWeek = FirstDayOfWeek.AddDays(-1)
                End While

                While Not LastDayOfWeek.DayOfWeek = DayOfWeek.Saturday
                    LastDayOfWeek = LastDayOfWeek.AddDays(1)
                End While

                Return Field & " BETWEEN '" & FirstDayOfWeek.ToString("MM/dd/yyyy") & "' AND '" & LastDayOfWeek.ToString("MM/dd/yyyy") & "'"

            Case "6" 'Today
                Return Field & " = '" & Now.ToString("MM/dd/yyyy") & "'"
            Case "7" 'Last Calendar Year
                Return Field & " BETWEEN '1/1/" & (Now.Year - 1) & "' AND '12/31/" & (Now.Year - 1) & "'"
            Case "8" 'Last Month
                Return Field & " BETWEEN '" & (Now.Month - 1) & "/1/" & Now.Year & "' AND '" & (Now.Month - 1) & "/" & DateTime.DaysInMonth(Now.Year, Now.Month - 1) & "/" & Now.Year & "'"
            Case "9" 'Last Week

                Dim FirstDayOfLastWeek As DateTime = Now.AddDays(-7)
                Dim LastDayOfLastWeek As DateTime = Now.AddDays(-7)

                While Not FirstDayOfLastWeek.DayOfWeek = DayOfWeek.Sunday
                    FirstDayOfLastWeek = FirstDayOfLastWeek.AddDays(-1)
                End While

                While Not LastDayOfLastWeek.DayOfWeek = DayOfWeek.Saturday
                    LastDayOfLastWeek = LastDayOfLastWeek.AddDays(1)
                End While

                Return Field & " BETWEEN '" & FirstDayOfLastWeek.ToString("MM/dd/yyyy") & "' AND '" & LastDayOfLastWeek.ToString("MM/dd/yyyy") & "'"

            Case "10" 'Yesterday
                Return Field & " = '" & Now.AddDays(-1).ToString("MM/dd/yyyy") & "'"
            Case Else
                Return Field & " >= '" & Now.AddDays(-360).ToString("MM/dd/yyyy") & "'"
        End Select
        
    End Function

End Class

Public Class cChartData
    Implements IEnumerable
    Private lines As ArrayList = New ArrayList

    Public Sub New()
    End Sub

    Public Sub AddLine(ByVal Name As String)
        lines.Add(New cChartLine(Name))
    End Sub

    Public Function Line(ByVal Name As String) As cChartLine
        For Each l As cChartLine In lines
            If l.Name = Name Then
                Return l
            End If
        Next
        Return Nothing
    End Function

    Public ReadOnly Property LineCount() As Integer
        Get
            Return lines.Count
        End Get
    End Property

    Public Function GetEnumerator() As System.Collections.IEnumerator Implements System.Collections.IEnumerable.GetEnumerator
        Return lines.GetEnumerator
    End Function
End Class

Public Class cChartLine
    Implements IEnumerable
    
    Private _name As String
    Private _dataPoints As ArrayList = New ArrayList

    Public Sub New(ByVal Name As String)
        _name = Name
    End Sub

    Public ReadOnly Property Name() As String
        Get
            Return _name
        End Get
    End Property

    Public Sub AddDataPoint(ByVal X As Integer, ByVal Y As Single)
        DataPoints.Add(New cChartDataPoint(X, Y))
    End Sub

    Public ReadOnly Property DataPoints() As ArrayList
        Get
            Return _dataPoints
        End Get
    End Property

    Public Function DataPoint(ByVal i As Integer) As cChartDataPoint
        If DataPoints.Count - 1 >= i Then
            Return CType((DataPoints(i)), cChartDataPoint)
        Else
            Return Nothing
        End If
    End Function

    Public Sub ModifyDataPoint(ByVal X As Integer, ByVal IncrY As Single)
        For Each p As cChartDataPoint In DataPoints
            If p.X = X Then
                p.Y += IncrY
            End If
        Next
    End Sub

    Public Sub AddOrModifyDataPoint(ByVal X As Integer, ByVal YValue As Single)
        If DataPointExists(X) Then
            ModifyDataPoint(X, YValue)
        Else
            AddDataPoint(X, YValue)
        End If
    End Sub

    Public Function DataPointExists(ByVal X As Integer) As Boolean
        For Each p As cChartDataPoint In DataPoints
            If p.X = X Then
                Return True
            End If
        Next
        Return False
    End Function

    Public ReadOnly Property DataPointCount() As Integer
        Get
            Return DataPoints.Count
        End Get
    End Property

    Public Function GetY(ByVal X As Integer) As Single
        For Each p As cChartDataPoint In DataPoints
            If p.X = X Then
                Return p.Y
            End If
        Next
        Return 0
    End Function

    Public Function GetEnumerator() As System.Collections.IEnumerator Implements System.Collections.IEnumerable.GetEnumerator
        Return DataPoints.GetEnumerator
    End Function
End Class

Public Class cChartDataPoint
    Private _x As Integer
    Private _y As Single

    Public Sub New(ByVal X As Integer, ByVal Y As Single)
        _x = X
        _y = Y
    End Sub

    Public Property X() As Integer
        Get
            Return _x
        End Get
        Set(ByVal value As Integer)
            _x = value
        End Set
    End Property

    Public Property Y() As Single
        Get
            Return _y
        End Get
        Set(ByVal value As Single)
            _y = value
        End Set
    End Property
End Class
