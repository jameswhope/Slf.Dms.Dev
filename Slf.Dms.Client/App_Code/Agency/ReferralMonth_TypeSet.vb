Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.Collections
Imports WebChart

Namespace Slf.Dms.Client.Agent
	''' <summary>
	''' Summary description for ReferralMonth_TypeSet.
	''' </summary>
	Public Class ReferralMonth_TypeSet : Implements IEnumerable
		Private _entries As ArrayList = New ArrayList()
		Private _percentMonth As Single = New Single()
		Private _month As Integer = 0

		Public Sub New(ByVal Month As Integer)
			_percentMonth = 0
			_month = Month
		End Sub

		Public ReadOnly Property intMonth() As Integer
			Get
				Return _month
			End Get
		End Property

		Public Property PercentMonth() As Single
			Get
				Return _percentMonth
			End Get
			Set
				_percentMonth = Value
			End Set
		End Property

		Public Sub Clear()
			_entries.Clear()
		End Sub

		Public Sub addEntry(ByVal newEntry As ReferralMonth_Entry, ByVal summary As Boolean)
			If summary Then 'check for duplicates
				Dim Combined As Boolean = False
				For Each e As ReferralMonth_Entry In _entries
					If e.Description= newEntry.Description Then 'this is already added. combine them.
						e.DebtTotal += newEntry.DebtTotal
						e.ReferralCount += newEntry.ReferralCount
						Combined = True
						Exit For
					End If
				Next e
				If Combined = False Then
					_entries.Add(newEntry)
				End If
			Else
				_entries.Add(newEntry)
			End If
		End Sub

		Public ReadOnly Property numEntries() As Integer
			Get
				Return _entries.Count
			End Get
		End Property
		Public ReadOnly Property subtotalAmount() As Single
			Get
				Dim i As Single = 0
				For Each e As ReferralMonth_Entry In _entries
					i += e.ReferralCount
				Next e
				Return i
			End Get
		End Property
		Public Function GetEnumerator() As IEnumerator Implements IEnumerable.GetEnumerator
			Return _entries.GetEnumerator()
		End Function
	End Class
End Namespace
