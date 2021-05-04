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
Imports System.Configuration
Imports System.Web.Configuration


Namespace Slf.Dms.Client.Agent
	''' <summary>
	''' Summary description for GlobalHelper.
	''' </summary>
	Public Class GlobalHelper
        Public Shared graphColor As Color() = New Color() {Color.Red, Color.Blue, Color.Green, Color.Yellow, Color.Cyan, Color.Purple, Color.Black, Color.Gray, Color.Orange, Color.White, Color.Beige, Color.HotPink, Color.LightBlue, Color.LightGreen, Color.LightYellow, Color.LimeGreen, Color.Orchid, Color.SeaGreen, Color.Sienna, Color.Teal, Color.WhiteSmoke, Color.Silver, Color.MintCream, Color.MistyRose}

        Public Shared Function GetMonth(ByVal Month As Integer, ByVal Length As Integer, ByVal ZeroBased As Boolean) As String
            Dim output As String = ""
            Dim i As Integer
            If ZeroBased Then
                i = Month + 1
            Else
                i = Month
            End If
            Select Case i
                Case 1
                    output = "January"
                    Exit Select
                Case 2
                    output = "February"
                    Exit Select
                Case 3
                    output = "March"
                    Exit Select
                Case 4
                    output = "April"
                    Exit Select
                Case 5
                    output = "May"
                    Exit Select
                Case 6
                    output = "June"
                    Exit Select
                Case 7
                    output = "July"
                    Exit Select
                Case 8
                    output = "August"
                    Exit Select
                Case 9
                    output = "September"
                    Exit Select
                Case 10
                    output = "October"
                    Exit Select
                Case 11
                    output = "November"
                    Exit Select
                Case 12
                    output = "December"
                    Exit Select
                Case Else
                    output = Month.ToString()
                    Exit Select
            End Select
            If Length >= output.Length Then
                Return output
            Else
                Return output.Substring(0, Length)
            End If
        End Function
	End Class


	Public Class cChartData : Inherits List(Of cChartLine)

		Public Sub New()
		End Sub
		Public Sub AddLine(ByVal Name As String)
			Me.Add(New cChartLine(Name))
		End Sub

		Public Function Line(ByVal Name As String) As cChartLine

			For Each l As cChartLine In Me
				If l.Name=Name Then
					Return l
				End If
			Next l
			Return Nothing
		End Function

		Public ReadOnly Property LineCount() As Integer
			Get
				Return Me.Count
			End Get
		End Property
	End Class
	Public Class cChartLine : Inherits List(Of cChartDataPoint)
		Private _name As String

		Public Sub New(ByVal Name As String)
			_name=Name
		End Sub

		Public ReadOnly Property Name() As String
			Get
				Return _name
			End Get
		End Property

		Public Sub AddDataPoint(ByVal X As Integer, ByVal Y As Single)
			Me.Add(New cChartDataPoint(X,Y))
		End Sub

		Public Function DataPoint(ByVal i As Integer) As cChartDataPoint
			If Me.Count-1>=i Then
				Return CType(Me(i), cChartDataPoint)
			Else
				Return Nothing
			End If
		End Function

		Public Sub ModifyDataPoint(ByVal X As Integer, ByVal IncrY As Single)
			For Each p As cChartDataPoint In Me
				If p.X=X Then
					p.Y += IncrY
				End If
			Next p
		End Sub

		Public Sub AddOrModifyDataPoint(ByVal X As Integer, ByVal YValue As Single)
			If DataPointExists(X) Then
				ModifyDataPoint(X,YValue)
			Else
				AddDataPoint(X,YValue)
			End If
		End Sub

		Public Function DataPointExists(ByVal X As Integer) As Boolean
			For Each p As cChartDataPoint In Me
				If p.X = X Then
					Return True
				End If
			Next p
			Return False
		End Function

		Public ReadOnly Property DataPointCount() As Integer
			Get
				Return Me.Count
			End Get
		End Property
		Public Function GetY(ByVal X As Integer) As Single
			For Each p As cChartDataPoint In Me
				If p.X = X Then
					Return p.Y
				End If
			Next p
			Return 0
		End Function
	End Class
	Public Class cChartDataPoint
		Private _x As Integer
		Private _y As Single

		Public Sub New(ByVal X As Integer, ByVal Y As Single)
			_x=X
			_y=Y
		End Sub

		Public Property X() As Integer
			Get
				Return _x
			End Get
			Set
				_x = Value
			End Set
		End Property
		Public Property Y() As Single
			Get
				Return _y
			End Get
			Set
				_y = Value
			End Set
		End Property
	End Class

End Namespace
