Imports Microsoft.VisualBasic
Imports System
Imports System.Collections
Imports System.Collections.Specialized
Imports System.ComponentModel
Imports System.Data
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports System.Reflection
Imports System.Web
Imports System.Web.SessionState
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls
Imports Drg.Util.DataAccess
Imports System.Configuration
Imports System.Web.Configuration

Imports WebChart


Namespace Slf.Dms.Client.Agent

	Public Class SummaryChart : Implements IHttpHandler
		Public Sub setupChartStyle(ByVal engine As ChartEngine, ByVal chart As String)
			If engine.Charts.Count > 0 Then
				If TypeOf engine.Charts(0) Is WebChart.LineChart OrElse TypeOf engine.Charts(0) Is WebChart.SmoothLineChart Then
					engine.ShowXValues = True
					engine.ShowYValues = True
					engine.Legend.Position = LegendPosition.Left
					engine.Legend.Width = 150
					engine.HasChartLegend = True
					Select Case chart
						Case "commo"
								engine.YValuesFormat = "{0:C}"
								Exit Select
					End Select
				Else If TypeOf engine.Charts(0) Is WebChart.ColumnChart Then
					engine.ShowXValues = False
					engine.ShowYValues = True
					engine.Legend.Position = LegendPosition.Bottom
					engine.HasChartLegend = True

					Select Case chart
						Case "comytd"
								engine.Legend.Width = 76
								engine.YValuesFormat = "{0:C}"
								Exit Select
						Case "refytd"
								engine.Legend.Width = 140
								Exit Select
					End Select
				End If
			End If
		End Sub

		Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
            Dim str As String = context.Request.QueryString.ToString()


			Dim chart As String = context.Request.QueryString("chart")
			Dim widthString As String = context.Request.QueryString("width")
			Dim heightString As String = context.Request.QueryString("height")
			Dim yearString As String = context.Request.QueryString("year")
            Dim agencyIdString As String = context.Request.QueryString("agencyId")


            Dim year As Integer
            Dim agencyId As Integer
			Dim width As Integer = Integer.Parse(widthString)
			Dim height As Integer = Integer.Parse(heightString)

            If Integer.TryParse(yearString, year) AndAlso Integer.TryParse(agencyIdString, agencyId) Then

                If Not chart Is Nothing OrElse chart.Length > 0 Then

                    Dim engine As ChartEngine = New ChartEngine()
                    engine.Size = New Size(width, height)
                    Dim charts As ChartCollection = New ChartCollection(engine)
                    engine.GridLines = WebChart.GridLines.Both

                    engine.Background.Color = Color.Transparent

                    engine.Border.Width = 40
                    engine.Border.Color = Color.Transparent

                    engine.LeftChartPadding = 30
                    engine.RightChartPadding = 3
                    engine.TopChartPadding = 10
                    engine.BottomChartPadding = 10

                    engine.Padding = 30
                    engine.TopPadding = 10

                    engine.PlotBackground.Color = Color.Transparent

                    Select Case chart
                        Case "refscrmo"
                            For Each c As Chart In RefMo(year, agencyId, False)
                                charts.Add(c)
                            Next c
                            Exit Select
                        Case "refenrmo"
                            For Each c As Chart In RefMo(year, agencyId, True)
                                charts.Add(c)
                            Next c
                            Exit Select
                        Case "reftotal"
                            For Each c As Chart In RefTotal(year, agencyId)
                                charts.Add(c)
                            Next c
                            Exit Select
                        Case "commo"
                            For Each c As Chart In ComMo(yearString, agencyIdString)
                                charts.Add(c)
                            Next c
                            Exit Select
                        Case "comytd"
                            For Each c As Chart In ComYTD(yearString, agencyIdString)
                                charts.Add(c)
                            Next c
                            Exit Select
                        Case "refytd"
                            For Each c As Chart In RefYTD(year, agencyId)
                                charts.Add(c)
                            Next c
                            Exit Select
                    End Select
                    engine.Charts = charts
                    setupChartStyle(engine, chart)




                    Dim bitmap As Bitmap = engine.GetBitmap()
                    context.Response.ContentType = "image/png"
                    Dim ms As MemoryStream = New MemoryStream()
                    bitmap.Save(ms, ImageFormat.Png)
                    ms.WriteTo(context.Response.OutputStream)

                    ' Clean up and return.
                    ms.Close()
                    bitmap.Dispose()
                End If
            End If
        End Sub

		Private Function RefMo(ByVal Year As Integer, ByVal agencyId As Integer, ByVal committed As Boolean) As ArrayList
			Dim data As cChartData = New cChartData()

			Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AgencyGetReferralData_Year")
				Using cmd.Connection
					DatabaseHelper.AddParameter(cmd,"agencyId", agencyId)
					DatabaseHelper.AddParameter(cmd,"year", Year)

					cmd.Connection.Open()
					Using rd As IDataReader = cmd.ExecuteReader()
						Do While rd.Read()
							If DatabaseHelper.Peel_bool(rd, "committed") = committed Then
								If data.Line(DatabaseHelper.Peel_string(rd, "ClientStatusName")) Is Nothing Then
									data.AddLine(DatabaseHelper.Peel_string(rd, "ClientStatusName"))
								End If
								data.Line(DatabaseHelper.Peel_string(rd, "ClientStatusName")).AddDataPoint(DatabaseHelper.Peel_int(rd, "Month") - 1, DatabaseHelper.Peel_int(rd, "ReferralCount"))
							End If
						Loop
					End Using
				End Using
			End Using

			data = syncMonths(data)

			Dim charts As ArrayList = New ArrayList()
			Dim counter As Integer=0
			For Each l As cChartLine In data
				Dim chart As SmoothLineChart = New SmoothLineChart()
				chart.Fill.Color = Color.Transparent
				chart.Line.Color = GlobalHelper.graphColor(counter)
				chart.Legend = l.Name
				chart.LineMarker = New DiamondLineMarker(8, Color.LightGray, GlobalHelper.graphColor(counter))

				chart.ShowLineMarkers=True
				For Each p As cChartDataPoint In l
					chart.Data.Add(New ChartPoint(GlobalHelper.GetMonth(p.X, 3, True), p.Y))
				Next p

				charts.Add(chart)

				counter += 1
			Next l
			Return charts
		End Function
		Private Function RefTotal(ByVal Year As Integer, ByVal agencyId As Integer) As ArrayList
			Dim data As cChartData = New cChartData()
			data.AddLine("Screening")
			data.AddLine("Enrollment")
			Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AgencyGetReferralData_Year")
				Using cmd.Connection
					DatabaseHelper.AddParameter(cmd,"agencyId", agencyId)
					DatabaseHelper.AddParameter(cmd,"year", Year)

					cmd.Connection.Open()
					Using rd As IDataReader = cmd.ExecuteReader()
						Do While rd.Read()
							If DataHelper.Nz_bool(DatabaseHelper.Peel_bool(rd, "committed")) Then
								data.Line("Enrollment").AddOrModifyDataPoint(DatabaseHelper.Peel_int(rd, "Month") - 1, DatabaseHelper.Peel_float(rd, "ReferralCount"))
							Else
								data.Line("Screening").AddOrModifyDataPoint(DatabaseHelper.Peel_int(rd, "Month") - 1, DatabaseHelper.Peel_float(rd, "ReferralCount"))
							End If
						Loop
					End Using
				End Using
			End Using

			data = syncMonths(data)

			Dim charts As ArrayList = New ArrayList()
			Dim counter As Integer=0
			For Each l As cChartLine In data
				Dim chart As SmoothLineChart = New SmoothLineChart()
				chart.Fill.Color = Color.Transparent
				chart.Line.Color = GlobalHelper.graphColor(counter)
				chart.Legend = l.Name
				chart.LineMarker = New DiamondLineMarker(8, Color.LightGray, GlobalHelper.graphColor(counter))

				chart.ShowLineMarkers=True
				For Each p As cChartDataPoint In l
					chart.Data.Add(New ChartPoint(GlobalHelper.GetMonth(p.X,3,True), p.Y))

				Next p

				charts.Add(chart)

				counter += 1
			Next l
			Return charts
		End Function
		Private Function RefYTD(ByVal Year As Integer, ByVal agencyId As Integer) As ArrayList
			Dim charts As ArrayList = New ArrayList()
			Dim screening As ReferralMonth_TypeSet = New ReferralMonth_TypeSet(1)
			Dim enrollment As ReferralMonth_TypeSet = New ReferralMonth_TypeSet(1)
			Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AgencyGetReferralData_Year")
				Using cmd.Connection
					DatabaseHelper.AddParameter(cmd,"agencyId", agencyId)
					DatabaseHelper.AddParameter(cmd,"year", Year)

					cmd.Connection.Open()

					Using rd As IDataReader = cmd.ExecuteReader()
						Do While rd.Read()
'INSTANT VB NOTE: The local variable year was renamed since Visual Basic will not uniquely identify local variables when other local variables have the same name:
							Dim year_Renamed As Integer = DatabaseHelper.Peel_int(rd, "Year")
							Dim month As Integer = DatabaseHelper.Peel_int(rd, "Month")
							Dim committed As Boolean = DatabaseHelper.Peel_bool(rd, "Committed")
							Dim clientStatusName As String = DatabaseHelper.Peel_string(rd, "ClientStatusName")
							Dim referralCount As Single = DatabaseHelper.Peel_float(rd, "ReferralCount")
							Dim debtTotal As Single = DatabaseHelper.Peel_float(rd, "DebtTotal")
							Dim clientStatusId As Integer = DatabaseHelper.Peel_int(rd, "ClientStatusId")

							Dim e As ReferralMonth_Entry = New ReferralMonth_Entry(year_Renamed, month, clientStatusName, referralCount, debtTotal, clientStatusId)

							If committed Then
								enrollment.addEntry(e, True)
							Else
								screening.addEntry(e, True)
							End If
						Loop
					End Using
				End Using
			End Using

			Dim counter As Integer = 0
			For Each e As ReferralMonth_Entry In screening
				Dim chart As ColumnChart = New ColumnChart()
				chart.Fill.Color = GlobalHelper.graphColor(counter)
				chart.Line.Color = Color.Black
				chart.Data.Add(New ChartPoint(counter.ToString(), e.ReferralCount))
				chart.Legend = "Screening - " & e.Description
				chart.MaxColumnWidth = 100

				charts.Add(chart)
				counter += 1
			Next e
			For Each e As ReferralMonth_Entry In enrollment
				Dim chart As ColumnChart = New ColumnChart()
				chart.Fill.Color = GlobalHelper.graphColor(counter)
				chart.Line.Color = Color.Black
				chart.Data.Add(New ChartPoint(counter.ToString(), e.ReferralCount))
				chart.Legend = "Enrollment - " & e.Description
				chart.MaxColumnWidth = 1000
				charts.Add(chart)
				counter += 1
			Next e

			Return charts
		End Function

		Private Function ComMo(ByVal Year As String, ByVal agencyId As String) As ArrayList
			Dim charts As ArrayList = New ArrayList()
			Dim data As cChartData = New cChartData()
			data.AddLine("Enrollment")
			data.AddLine("Settlement")
			data.AddLine("Reversal Enrollment")
			data.AddLine("Total")

			Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AgencyGetCommissionDataSummary")
				Using cmd.Connection
					DatabaseHelper.AddParameter(cmd,"agencyId", agencyId)
					DatabaseHelper.AddParameter(cmd,"year", Year)

					cmd.Connection.Open()

					Using rd As IDataReader = cmd.ExecuteReader()
						Do While rd.Read()
							Select Case rd.GetInt32(0)
								Case 2 ' Enrollment
									data.Line("Enrollment").AddOrModifyDataPoint(rd.GetInt32(1),CSng(rd.GetDecimal(2)))
									data.Line("Total").AddOrModifyDataPoint(rd.GetInt32(1),CSng(rd.GetDecimal(2)))
									Exit Select
								Case 4 ' Settlement
									data.Line("Settlement").AddOrModifyDataPoint(rd.GetInt32(1), CSng(rd.GetDecimal(2)))
									data.Line("Total").AddOrModifyDataPoint(rd.GetInt32(1), CSng(rd.GetDecimal(2)))
									Exit Select
								Case 9 ' Enrollment reversal
									data.Line("Reversal Enrollment").AddOrModifyDataPoint(rd.GetInt32(1), CSng(-rd.GetDecimal(2)))
									data.Line("Total").AddOrModifyDataPoint(rd.GetInt32(1), CSng(-rd.GetDecimal(2)))
									Exit Select
							End Select
						Loop
					End Using
				End Using
			End Using

			data = syncMonths(data)

			Dim counter As Integer=0

			For Each l As cChartLine In data
				Dim chart As SmoothLineChart = New SmoothLineChart()
				chart.Fill.Color = Color.Transparent
				chart.LineMarker = New DiamondLineMarker(6, GlobalHelper.graphColor(counter), GlobalHelper.graphColor(counter))
				If l.Name="Total" Then
					chart.LineMarker = New DiamondLineMarker(6,Color.Black, Color.Black)
					chart.Line.Color=Color.Black
					chart.Line.Width=2
				Else
					chart.Line.Color = GlobalHelper.graphColor(counter)
				End If
				chart.Legend = l.Name

				chart.ShowLineMarkers=True
				For Each p As cChartDataPoint In l
					chart.Data.Add(New ChartPoint(GlobalHelper.GetMonth(p.X,3,False), p.Y))
				Next p

				charts.Add(chart)

				counter += 1
			Next l

			Return charts
		End Function
		Private Function ComYTD(ByVal Year As String, ByVal agencyId As String) As ArrayList
			Dim charts As ArrayList = New ArrayList()

			Dim data As cChartData = New cChartData()
			data.AddLine("Total Enrollment")
			data.AddLine("Total Settlement")
			data.AddLine("Total Reversal Enrollment")

			Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AgencyGetCommissionDataSummary")
				Using cmd.Connection
					DatabaseHelper.AddParameter(cmd, "agencyId", agencyId)
					DatabaseHelper.AddParameter(cmd, "year", Year)

					cmd.Connection.Open()

					Using rd As IDataReader = cmd.ExecuteReader()
						Do While rd.Read()
							Select Case rd.GetInt32(0)
								Case 2 ' Enrollment
									data.Line("Total Enrollment").AddOrModifyDataPoint(0,CSng(rd.GetDecimal(2)))
									Exit Select
								Case 4 ' Settlement
									data.Line("Total Settlement").AddOrModifyDataPoint(0,CSng(rd.GetDecimal(2)))
									Exit Select
								Case 7 ' Enrollment reversal
									data.Line("Total Reversal Enrollment").AddOrModifyDataPoint(0,CSng(-rd.GetDecimal(2)))
									Exit Select
							End Select
						Loop
					End Using
				End Using
			End Using

			Dim counter As Integer = 0
			For Each l As cChartLine In data
				If l.DataPointCount > 0 Then
					Dim chart As ColumnChart = New ColumnChart()
					chart.MaxColumnWidth = 50
					chart.Fill.Color = GlobalHelper.graphColor(counter)
					chart.Line.Color = Color.Black
					chart.Data.Add(New ChartPoint(counter.ToString(), l.DataPoint(0).Y))
					chart.Legend = "Enrollment - " & l.Name

					charts.Add(chart)
					counter += 1
				End If
			Next l

			Return charts
		End Function

		Private Function syncMonths(ByVal data As cChartData) As cChartData
			Dim min As Integer = 12
			Dim max As Integer = 0

			For Each l As cChartLine In data
				For Each p As cChartDataPoint In l
					If p.X > max Then
						max = p.X
					End If
					If p.X < min Then
						min = p.X
					End If
				Next p
			Next l


			Dim dataNew As cChartData = New cChartData()


			For Each l As cChartLine In data
				dataNew.AddLine(l.Name)
				Dim X As Integer = min
				Do While X <= max
					dataNew.Line(l.Name).AddDataPoint(X, l.GetY(X))
					X += 1
				Loop
			Next l

			Return dataNew
		End Function
		Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
			Get
				' TODO:  Add ChartHandler.IsReusable getter implementation
				Return True
			End Get
		End Property
	End Class


End Namespace