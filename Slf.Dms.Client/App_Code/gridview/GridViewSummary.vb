Imports System
Imports System.Web.UI
Imports System.Web.UI.WebControls


Public Enum SummaryOperation
	Sum
	Avg
	Count
	[Custom]
End Enum
Public Delegate Sub CustomSummaryOperation(ByVal column As String, ByVal groupName As String, ByVal value As Object)
Public Delegate Function SummaryResultMethod(ByVal column As String, ByVal groupName As String) As Object

''' <summary> 
''' A class that represents a summary operation defined to a column 
''' </summary> 
Public Class GridViewSummary
#Region "Fields"

	Private _column As String
	Private _operation As SummaryOperation
	Private _customOperation As CustomSummaryOperation
	Private _getSummaryMethod As SummaryResultMethod
	Private _group As GridViewGroup
	Private _value As Object
	Private _formatString As String
	Private _quantity As Integer
	Private _automatic As Boolean
	Private _treatNullAsZero As Boolean

#End Region

#Region "Properties"

	Public ReadOnly Property Column() As String
		Get
			Return _column
		End Get
	End Property

	Public ReadOnly Property Operation() As SummaryOperation
		Get
			Return _operation
		End Get
	End Property

	Public ReadOnly Property CustomOperation() As CustomSummaryOperation
		Get
			Return _customOperation
		End Get
	End Property

	Public ReadOnly Property GetSummaryMethod() As SummaryResultMethod
		Get
			Return _getSummaryMethod
		End Get
	End Property

	Public ReadOnly Property Group() As GridViewGroup
		Get
			Return _group
		End Get
	End Property

	Public ReadOnly Property Value() As Object
		Get
			Return _value
		End Get
	End Property

	Public Property FormatString() As String
		Get
			Return _formatString
		End Get
		Set(ByVal value As String)
			_formatString = value
		End Set
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

	Public Property TreatNullAsZero() As Boolean
		Get
			Return _treatNullAsZero
		End Get
		Set(ByVal value As Boolean)
			_treatNullAsZero = value
		End Set
	End Property

#End Region

#Region "Constructors"

	Private Sub New(ByVal col As String, ByVal grp As GridViewGroup)
		Me._column = col
		Me._group = grp
		Me._value = Nothing
		Me._quantity = 0
		Me._automatic = True
		Me._treatNullAsZero = False
	End Sub

	Public Sub New(ByVal col As String, ByVal formatString As String, ByVal op As SummaryOperation, ByVal grp As GridViewGroup)
		Me.New(col, grp)
		Me._formatString = formatString
		Me._operation = op
		Me._customOperation = Nothing
		Me._getSummaryMethod = Nothing
	End Sub

	Public Sub New(ByVal col As String, ByVal op As SummaryOperation, ByVal grp As GridViewGroup)
		Me.New(col, [String].Empty, op, grp)
	End Sub

	Public Sub New(ByVal col As String, ByVal formatString As String, ByVal op As CustomSummaryOperation, ByVal getResult As SummaryResultMethod, ByVal grp As GridViewGroup)
		Me.New(col, grp)
		Me._formatString = formatString
		Me._operation = SummaryOperation.[Custom]
		Me._customOperation = op
		Me._getSummaryMethod = getResult
	End Sub

	Public Sub New(ByVal col As String, ByVal op As CustomSummaryOperation, ByVal getResult As SummaryResultMethod, ByVal grp As GridViewGroup)
		Me.New(col, [String].Empty, op, getResult, grp)
	End Sub

#End Region

	Friend Sub SetGroup(ByVal g As GridViewGroup)
		Me._group = g
	End Sub

	Public Function Validate() As Boolean
		If Me._operation = SummaryOperation.[Custom] Then
			Return (Me._customOperation IsNot Nothing AndAlso Me._getSummaryMethod IsNot Nothing)
		Else
			Return (Me._customOperation Is Nothing AndAlso Me._getSummaryMethod Is Nothing)
		End If
	End Function

	Public Sub Reset()
		Me._quantity = 0
		Me._value = Nothing
	End Sub

	Public Sub AddValue(ByVal newValue As Object)
		' Increment to (later) calc the Avg or for other calcs 
		Me._quantity += 1

		' Built-in operations 
		If Me._operation = SummaryOperation.Sum OrElse Me._operation = SummaryOperation.Avg Then
			If Me._value Is Nothing Then
				Me._value = newValue
			Else
				Me._value = PerformSum(Me._value, newValue)
			End If
		Else
			' Custom operation 
			If Me._customOperation IsNot Nothing Then
				' Call the custom operation 
				If Me._group IsNot Nothing Then
					Me._customOperation(Me._column, Me._group.Name, newValue)
				Else
					Me._customOperation(Me._column, Nothing, newValue)
				End If
			End If
		End If
	End Sub

	Public Sub Calculate()
		If Me._operation = SummaryOperation.Avg Then
			Me._value = PerformDiv(Me._value, Me._quantity)
		End If
		If Me._operation = SummaryOperation.Count Then
			Me._value = Me._quantity
		ElseIf Me._operation = SummaryOperation.[Custom] Then
			If Me._getSummaryMethod IsNot Nothing Then
				Me._value = Me._getSummaryMethod(Me._column, Nothing)
			End If
			' if this.Operation == SummaryOperation.Avg 
			' this.Value already contains the correct value 
		End If
	End Sub

#Region "Built-in Summary Operations"

	Private Function PerformSum(ByVal a As Object, ByVal b As Object) As Object
		Dim zero As Object = 0

		If a Is Nothing Then
			If _treatNullAsZero Then
				a = 0
			Else
				Return Nothing
			End If
		End If

		If b Is Nothing Then
			If _treatNullAsZero Then
				b = 0
			Else
				Return Nothing
			End If
		End If

		' Convert to proper type before add 
		Select Case a.[GetType]().FullName
			Case "System.Int16"
				Return Convert.ToInt16(a) + Convert.ToInt16(b)
			Case "System.Int32"
				Return Convert.ToInt32(a) + Convert.ToInt32(b)
			Case "System.Int64"
				Return Convert.ToInt64(a) + Convert.ToInt64(b)
			Case "System.UInt16"
				Return Convert.ToUInt16(a) + Convert.ToUInt16(b)
			Case "System.UInt32"
				Return Convert.ToUInt32(a) + Convert.ToUInt32(b)
			Case "System.UInt64"
				Return Convert.ToUInt64(a) + Convert.ToUInt64(b)
			Case "System.Single"
				Return Convert.ToSingle(a) + Convert.ToSingle(b)
			Case "System.Double"
				Return Convert.ToDouble(a) + Convert.ToDouble(b)
			Case "System.Decimal"
				Return Convert.ToDecimal(a) + Convert.ToDecimal(b)
			Case "System.Byte"
				Return Convert.ToByte(a) + Convert.ToByte(b)
			Case "System.String"
				Return a.ToString() + b.ToString()
		End Select

		Return Nothing
	End Function

	Private Function PerformDiv(ByVal a As Object, ByVal b As Integer) As Object
		Dim zero As Object = 0

		If a Is Nothing Then
			Return (If(_treatNullAsZero, zero, Nothing))
		End If

		' Don't raise an exception, just return null 
		If b = 0 Then
			Return Nothing
		End If

		' Convert to proper type before div 
		Select Case a.[GetType]().FullName
			Case "System.Int16"
				Return Convert.ToInt16(a) / b
			Case "System.Int32"
				Return Convert.ToInt32(a) / b
			Case "System.Int64"
				Return Convert.ToInt64(a) / b
			Case "System.UInt16"
				Return Convert.ToUInt16(a) / b
			Case "System.UInt32"
				Return Convert.ToUInt32(a) / b
			Case "System.Single"
				Return Convert.ToSingle(a) / b
			Case "System.Double"
				Return Convert.ToDouble(a) / b
			Case "System.Decimal"
				Return Convert.ToDecimal(a) / b
			Case "System.Byte"
				Return Convert.ToByte(a) / b
				' Operator '/' cannot be applied to operands of type 'ulong' and 'int' 
				'case "System.UInt64": return Convert.ToUInt64(a) / b; 
		End Select

		Return Nothing
	End Function

#End Region

End Class