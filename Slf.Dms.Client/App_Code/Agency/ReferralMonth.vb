Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.Collections

Namespace Slf.Dms.Client.Agent
	''' <summary>
	''' Summary description for ReferralMonth.
	''' </summary>
	Public Class ReferralMonth : Implements IEnumerable
		Private _Month As Integer
		Private _Total As Single = 0
		Private _AvDebt As Single

		Public _typeSets As ArrayList = New ArrayList()

		Public Sub New(ByVal TypeSets As ArrayList, ByVal Month As Integer)
			_typeSets = TypeSets


			For Each s As ReferralMonth_TypeSet In _typeSets
				_Total += s.subtotalAmount
			Next s


			Dim totalDebt As Single = 0
			Dim totalEntries As Single = 0

			'calculate percents
			If _Total <> 0 Then
				For Each s As ReferralMonth_TypeSet In _typeSets
					s.PercentMonth = s.subtotalAmount * 100 / _Total
					s.PercentMonth=s.PercentMonth/100


					For Each e As ReferralMonth_Entry In s
						e.PercentMonth = e.ReferralCount / _Total
						e.PercentCategory = e.ReferralCount / s.subtotalAmount
						totalDebt += e.DebtTotal
						totalEntries += e.ReferralCount
					Next e
				Next s
			End If

			_AvDebt = totalDebt / totalEntries
			_Month = Month
		End Sub

		Public Sub Clear()
			_typeSets.Clear()
		End Sub

		Public ReadOnly Property ScreeningDetails() As ReferralMonth_TypeSet
			Get
				Return CType(_typeSets(0), ReferralMonth_TypeSet)
			End Get
		End Property
		Public ReadOnly Property EnrollmentDetails() As ReferralMonth_TypeSet
			Get
				Return CType(_typeSets(1), ReferralMonth_TypeSet)
			End Get
		End Property

		Public Property AverageDebt() As Single
			Get
				Return _AvDebt
			End Get
			Set
				_AvDebt = Value
			End Set
		End Property
		Public ReadOnly Property Total() As Single
			Get
				Return _Total
			End Get
		End Property
		Public ReadOnly Property Month() As String
			Get
				Select Case _Month
					Case 1
						Return "January"

					Case 2
						Return "February"

					Case 3
						Return "March"

					Case 4
						Return "April"

					Case 5
						Return "May"

					Case 6
						Return "June"

					Case 7
						Return "July"

					Case 8
						Return "August"

					Case 9
						Return "September"

					Case 10
						Return "October"

					Case 11
						Return "November"

					Case 12
						Return "December"

				End Select
				Return "Unknown"
			End Get
		End Property
		Public Function GetEnumerator() As IEnumerator Implements IEnumerable.GetEnumerator
			Return _typeSets.GetEnumerator()
		End Function
	End Class
End Namespace
