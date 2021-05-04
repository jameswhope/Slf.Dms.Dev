Imports Microsoft.VisualBasic
Imports System
Imports System.Collections
Imports System.Data

Namespace Slf.Dms.Client.Agent
	''' <summary>
	''' Summary description for Client.
	''' </summary>
	Public NotInheritable Class SettlementDetail
		Private _settlementId As Integer
		Private _amountOwed As Single
		Private _amountSettled As Single
		Private _totalFees As Single

		Public Property SettlementId() As Integer
			Get
				Return _settlementId
			End Get
			Set
				_settlementId = Value
			End Set
		End Property

		Public Property AmountOwed() As Single
			Get
				Return _amountOwed
			End Get
			Set
				_amountOwed = Value
			End Set
		End Property

		Public Property AmountSettled() As Single
			Get
				Return _amountSettled
			End Get
			Set
				_amountSettled = Value
			End Set
		End Property

		Public ReadOnly Property AmountSaved() As Single
			Get
				Return AmountOwed - AmountSettled
			End Get
		End Property

		Public Property TotalFees() As Single
			Get
				Return _totalFees
			End Get
			Set
				_totalFees = Value
			End Set
		End Property

'INSTANT VB NOTE: The parameter settlementId was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
'INSTANT VB NOTE: The parameter amountOwed was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
'INSTANT VB NOTE: The parameter amountSettled was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
'INSTANT VB NOTE: The parameter totalFees was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
		Public Sub New(ByVal settlementId_Renamed As Integer, ByVal amountOwed_Renamed As Single, ByVal amountSettled_Renamed As Single, ByVal totalFees_Renamed As Single)
			_settlementId = settlementId_Renamed
			_amountOwed = amountOwed_Renamed
			_amountSettled = amountSettled_Renamed
			_totalFees = totalFees_Renamed
		End Sub

		Public Shared Function Load(ByVal rd As IDataReader) As SettlementDetail
'INSTANT VB NOTE: The local variable settlementId was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim settlementId_Renamed As Integer = rd.GetInt32(2)
'INSTANT VB NOTE: The local variable amountOwed was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim amountOwed_Renamed As Single = CSng(rd.GetDecimal(4))
'INSTANT VB NOTE: The local variable amountSettled was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim amountSettled_Renamed As Single = CSng(rd.GetDecimal(5))
'INSTANT VB NOTE: The local variable totalFees was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim totalFees_Renamed As Single = CSng(rd.GetDecimal(6))

			Return New SettlementDetail(settlementId_Renamed, amountOwed_Renamed, amountSettled_Renamed, totalFees_Renamed)
		End Function

' public static ArrayList LoadMany(IDataReader rd)
'{
'ArrayList enrollmentDetails = new ArrayList();

'while (rd.Read())
'{
'EnrollmentTransactionDetail d = Load(rd);

'if (d != null)
'enrollmentDetails.Add(d);
'}

'return enrollmentDetails;
'}

'public EnrollmentTransactionDetail Clone()
'{
'return new EnrollmentTransactionDetail(ClientId, TotalFees, BeginBalance, StartDate);
'}

'object ICloneable.Clone()
'{
'return new EnrollmentTransactionDetail(ClientId, TotalFees, BeginBalance, StartDate);
'}
'
	End Class
End Namespace