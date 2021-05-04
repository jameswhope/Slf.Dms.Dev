Imports Microsoft.VisualBasic
Imports System
Imports System.Collections
Imports System.Collections.Specialized
Imports System.Collections.Generic
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

Imports WebChart

Namespace Slf.Dms.Client.Agent
	''' <summary>
	''' Summary description for WebForm1.
	''' </summary>
	Public Class ReferralChart : Implements IHttpHandler
		Public agencyId As Integer
		Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
			Dim chart As String = context.Request.QueryString("chart")
			Dim widthString As String = context.Request.QueryString("width")
			Dim heightString As String = context.Request.QueryString("height")
			Dim yearString As String = context.Request.QueryString("year")
			Dim monthString As String = context.Request.QueryString("month")
			Dim agencyIdString As String = context.Request.QueryString("agencyId")
			Dim agencyId As Integer = Integer.Parse(agencyIdString)
			Dim year As Integer = Integer.Parse(yearString)
			Dim month As Integer = Integer.Parse(monthString)

			Dim width As Integer = Integer.Parse(widthString)
			Dim height As Integer = Integer.Parse(heightString)

			If Not chart Is Nothing OrElse chart.Length > 0 Then

				Dim engine As ChartEngine = New ChartEngine()
				engine.Size = New Size(width, height)
				Dim charts As ChartCollection = New ChartCollection(engine)


				Select Case chart
					Case "screeningmonth"
						For Each c As Chart In ChartMonth(year,month,agencyId,False)
							charts.Add(c)
						Next c
						Exit Select
					Case "enrollmentmonth"
						For Each c As Chart In ChartMonth(year,month,agencyId,True)
							charts.Add(c)
						Next c
						Exit Select
					Case "screeningyear"
						For Each c As Chart In ChartYear(year, agencyId, False)
							charts.Add(c)
						Next c
						Exit Select
					Case "enrollmentyear"
						For Each c As Chart In ChartYear(year,agencyId, True)
							charts.Add(c)
						Next c
						Exit Select
				End Select

				engine.Charts = charts
				engine.GridLines = WebChart.GridLines.None
				engine.Background.Color=Color.Transparent

				engine.Border.Width=0
				engine.Border.Color=Color.Transparent
				engine.LeftChartPadding=1
				engine.RightChartPadding=3
				engine.TopChartPadding=3
				engine.BottomChartPadding=3
				engine.Padding=3


				engine.PlotBackground.Color=Color.Transparent

				Dim bitmap As Bitmap = engine.GetBitmap()
				context.Response.ContentType = "image/png"
				Dim ms As MemoryStream = New MemoryStream()
				bitmap.Save(ms, ImageFormat.Png)
				ms.WriteTo(context.Response.OutputStream)

				' Clean up and return.
				ms.Close()
				bitmap.Dispose()
			End If
		End Sub

		Private Function ChartMonth(ByVal Year As Integer, ByVal Month As Integer, ByVal agencyId As Integer, ByVal committed As Boolean) As List(Of Chart)
			Dim Details As ReferralMonth_TypeSet = New ReferralMonth_TypeSet(Month)
			Dim charts As List(Of Chart) = New List(Of Chart)()
			Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AgencyGetReferralData_Month")
				Using cmd.Connection
					DatabaseHelper.AddParameter(cmd,"agencyId", agencyId)
					DatabaseHelper.AddParameter(cmd,"year", Year)
					DatabaseHelper.AddParameter(cmd,"month", Month)

					cmd.Connection.Open()

					Using rd As IDataReader = cmd.ExecuteReader()
						Do While rd.Read()
							If committed = DatabaseHelper.Peel_bool(rd, "Committed") Then
								Dim description As String = DatabaseHelper.Peel_string(rd, "ClientStatusName")
								Dim referralCount As Single = DatabaseHelper.Peel_float(rd, "ReferralCount")
								Dim debtTotal As Single = DatabaseHelper.Peel_float(rd, "DebtTotal")
								Dim clientStatusId As Integer = DatabaseHelper.Peel_int(rd, "ClientStatusId")

								Dim e As ReferralMonth_Entry = New ReferralMonth_Entry(Year, Month, description, referralCount, debtTotal, clientStatusId)
								Details.addEntry(e, False)
							End If
						Loop
					End Using
				End Using
			End Using

			Dim counter As Integer = 0
			For Each e As ReferralMonth_Entry In Details
				Dim chart As ColumnChart = New ColumnChart()
				chart.Fill.Color = GlobalHelper.graphColor(counter)
				chart.Line.Color = Color.Black
				chart.Data.Add(New ChartPoint(counter.ToString(), e.ReferralCount))
				chart.MaxColumnWidth = 100
				charts.Add(chart)
				counter += 1
			Next e
			Return charts
		End Function
		Private Function ChartYear(ByVal Year As Integer, ByVal agencyId As Integer, ByVal committed As Boolean) As List(Of Chart)
			Dim charts As List(Of Chart) = New List(Of Chart)()
			Dim Summary As ReferralMonth_TypeSet = New ReferralMonth_TypeSet(1)
			Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_AgencyGetReferralData_Year")
				Using cmd.Connection
					DatabaseHelper.AddParameter(cmd,"agencyId", agencyId)
					DatabaseHelper.AddParameter(cmd,"year", Year)

					cmd.Connection.Open()

					Using rd As IDataReader = cmd.ExecuteReader()
						Do While rd.Read()
							Dim month As Integer = DatabaseHelper.Peel_int(rd, "Month")
							Dim com As Boolean = DatabaseHelper.Peel_bool(rd, "Committed")
							Dim description As String = DatabaseHelper.Peel_string(rd, "ClientStatusName")
							Dim referralCount As Single = DatabaseHelper.Peel_float(rd, "ReferralCount")
							Dim debtTotal As Single = DatabaseHelper.Peel_float(rd, "DebtTotal")
							Dim clientStatusId As Integer = DatabaseHelper.Peel_int(rd, "ClientStatusId")

							Dim e As ReferralMonth_Entry = New ReferralMonth_Entry(Year, month, description, referralCount, debtTotal, clientStatusId)

							If com = committed Then
								Summary.addEntry(e, True)
							End If
						Loop
					End Using
				End Using
			End Using

			Dim counter As Integer = 0
			For Each e As ReferralMonth_Entry In Summary
				Dim chart As ColumnChart = New ColumnChart()
				chart.Fill.Color = GlobalHelper.graphColor(counter)
				chart.Line.Color = Color.Black
				chart.Data.Add(New ChartPoint(counter.ToString(), e.ReferralCount))
				chart.MaxColumnWidth = 100
				charts.Add(chart)
				counter += 1

			Next e
			Return charts
		End Function
		Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
			Get
				' TODO:  Add ChartHandler.IsReusable getter implementation
				Return True
			End Get
		End Property


	End Class
End Namespace