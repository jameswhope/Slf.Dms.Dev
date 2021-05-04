Imports System
Imports System.Collections.Generic
Imports System.Web.UI
Imports System.Web.UI.WebControls


Public Delegate Sub GroupEvent(ByVal groupName As String, ByVal values As Object(), ByVal row As GridViewRow)

''' <summary> 
''' A class that represents a group consisting of a set of columns 
''' </summary> 
Public Class GridViewGroup
#Region "Fields"

	Private _columns As String()
	Private _actualValues As Object()
	Private _quantity As Integer
	Private _automatic As Boolean
	Private _hideGroupColumns As Boolean
	Private _isSuppressGroup As Boolean
	Private _generateAllCellsOnSummaryRow As Boolean
	Private mSummaries As GridViewSummaryList

#End Region

#Region "Properties"

	Public ReadOnly Property Columns() As String()
		Get
			Return _columns
		End Get
	End Property

	Public ReadOnly Property ActualValues() As Object()
		Get
			Return _actualValues
		End Get
	End Property

	Public ReadOnly Property Quantity() As Integer
		Get
			Return _quantity
		End Get
	End Property

	Public Property Automatic() As Boolean
		Get
			Return _automatic
		End Get
		Set(ByVal value As Boolean)
			_automatic = value
		End Set
	End Property

	Public Property HideGroupColumns() As Boolean
		Get
			Return _hideGroupColumns
		End Get
		Set(ByVal value As Boolean)
			_hideGroupColumns = value
		End Set
	End Property

	Public ReadOnly Property IsSuppressGroup() As Boolean
		Get
			Return _isSuppressGroup
		End Get
	End Property

	Public Property GenerateAllCellsOnSummaryRow() As Boolean
		Get
			Return _generateAllCellsOnSummaryRow
		End Get
		Set(ByVal value As Boolean)
			_generateAllCellsOnSummaryRow = value
		End Set
	End Property

	Public ReadOnly Property Name() As String
		Get
			Return [String].Join("+", Me._columns)
		End Get
	End Property

	Public ReadOnly Property Summaries() As GridViewSummaryList
		Get
			Return mSummaries
		End Get
	End Property

#End Region

#Region "Constructors"

	Public Sub New(ByVal cols As String(), ByVal isSuppressGroup As Boolean, ByVal auto As Boolean, ByVal hideGroupColumns As Boolean, ByVal generateAllCellsOnSummaryRow As Boolean)
		Me.mSummaries = New GridViewSummaryList()
		Me._actualValues = Nothing
		Me._quantity = 0
		Me._columns = cols
		Me._isSuppressGroup = isSuppressGroup
		Me._automatic = auto
		Me._hideGroupColumns = hideGroupColumns
		Me._generateAllCellsOnSummaryRow = generateAllCellsOnSummaryRow
	End Sub

	Public Sub New(ByVal cols As String(), ByVal auto As Boolean, ByVal hideGroupColumns As Boolean, ByVal generateAllCellsOnSummaryRow As Boolean)
		Me.New(cols, False, auto, hideGroupColumns, generateAllCellsOnSummaryRow)
	End Sub

	Public Sub New(ByVal cols As String(), ByVal auto As Boolean, ByVal hideGroupColumns As Boolean)
		Me.New(cols, auto, hideGroupColumns, False)
	End Sub

#End Region

	Friend Sub SetActualValues(ByVal values As Object())
		Me._actualValues = values
	End Sub

	Public Function ContainsSummary(ByVal s As GridViewSummary) As Boolean
		Return mSummaries.Contains(s)
	End Function

	Public Sub AddSummary(ByVal s As GridViewSummary)
		If Me.ContainsSummary(s) Then
			Throw New Exception("Summary already exists in this group.")
		End If

		If Not s.Validate() Then
			Throw New Exception("Invalid summary.")
		End If

		'''s._group = this; 
		s.SetGroup(Me)
		Me.mSummaries.Add(s)
	End Sub

	Public Sub Reset()
		Me._quantity = 0

		For Each s As GridViewSummary In mSummaries
			s.Reset()
		Next
	End Sub

	Public Sub AddValueToSummaries(ByVal dataitem As Object)
		Me._quantity += 1

		For Each s As GridViewSummary In mSummaries
			s.AddValue(DataBinder.Eval(dataitem, s.Column))
		Next
	End Sub

	Public Sub CalculateSummaries()
		For Each s As GridViewSummary In mSummaries
			s.Calculate()
		Next
	End Sub
End Class