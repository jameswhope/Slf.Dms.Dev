Imports System
Imports System.Collections.Generic

''' <summary> 
''' Summary description for GridViewSummaryList 
''' </summary> 
Public Class GridViewSummaryList
	Inherits List(Of GridViewSummary)
	Default Public ReadOnly Property Item(ByVal name As String) As GridViewSummary
		Get
			Return Me.FindSummaryByColumn(name)
		End Get
	End Property

	Public Function FindSummaryByColumn(ByVal columnName As String) As GridViewSummary
		For Each s As GridViewSummary In Me
			If s.Column.ToLower() = columnName.ToLower() Then
				Return s
			End If
		Next

		Return Nothing
	End Function
End Class
