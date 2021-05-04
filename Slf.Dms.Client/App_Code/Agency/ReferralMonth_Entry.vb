Imports Microsoft.VisualBasic
Imports System

Namespace Slf.Dms.Client.Agent
	''' <summary>
	''' Summary description for ReferralMonth_Entry.
	''' </summary>
	Public Class ReferralMonth_Entry : Implements ICloneable
		Private _year As Integer
		Private _month As Integer
		Private _description As String
		Private _referralCount As Single
		Private _debtTotal As Single
		Private _percentCategory As Single
		Private _percentMonth As Single
		Private _clientStatusId As Integer

'INSTANT VB NOTE: The parameter clientStatusId was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
		Public Sub New(ByVal Year As Integer, ByVal Month As Integer, ByVal Description As String, ByVal ReferralCount As Single, ByVal DebtTotal As Single, ByVal clientStatusId_Renamed As Integer)
			_year = Year
			_month = Month
			_description = Description
			_referralCount = ReferralCount
			_debtTotal= DebtTotal
			_clientStatusId = clientStatusId_Renamed
		End Sub

		Public Property ClientStatusId() As Integer
			Get
				Return _clientStatusId
			End Get
			Set
				_clientStatusId = Value
			End Set
		End Property
		Public Property PercentCategory() As Single
			Get
				Return _percentCategory
			End Get
			Set
				_percentCategory = Value
			End Set
		End Property
		Public Property PercentMonth() As Single
			Get
				Return _percentMonth
			End Get
			Set
				_percentMonth = Value
			End Set
		End Property
		Public Property Year() As Integer
			Get
				Return _year
			End Get
			Set
				_year = Value
			End Set
		End Property
		Public Property Month() As Integer
			Get
				Return _month
			End Get
			Set
				_month = Value
			End Set
		End Property
		Public Property Description() As String
			Get
				Return _description
			End Get
			Set
				_description = Value
			End Set
		End Property
		Public Property ReferralCount() As Single
			Get
				Return _referralCount
			End Get
			Set
				_referralCount = Value
			End Set
		End Property

		Public Property DebtTotal() As Single
			Get
				Return _debtTotal
			End Get
			Set
				_debtTotal = Value
			End Set
		End Property
		#Region "ICloneable Members"

        Public Function Clone() As Object Implements ICloneable.Clone
            ' TODO:  Add ReferralMonth_Entry.Clone implementation
            Return New ReferralMonth_Entry(_year, _month, _description, _referralCount, _debtTotal, _clientStatusId)
        End Function

        'Public Function Clone() As ReferralMonth_Entry Implements ICloneable.Clone
        '	Return New ReferralMonth_Entry(_year, _month, _description, _referralCount, _debtTotal, _clientStatusId)
        'End Function
		#End Region
	End Class
End Namespace
