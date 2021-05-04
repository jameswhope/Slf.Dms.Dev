Imports Microsoft.VisualBasic
Imports System
Imports System.Collections
Imports System.Collections.Generic
Imports System.Data

Namespace Slf.Dms.Client.Agent
	''' <summary>
	''' Summary description for Client.
	''' </summary>
	Public NotInheritable Class SettlementTransactionDetail ' : ICloneable
		Private _clientId As Integer
		Private _beginBalance As Single
		Private _periodTotal As Single
		Private _creditors As List(Of CreditorDetail) = New List(Of CreditorDetail)()
		Private _rowCount As Integer

		Public Property ClientId() As Integer
			Get
				Return _clientId
			End Get
			Set
				_clientId = Value
			End Set
		End Property

		Public Property BeginBalance() As Single
			Get
				Return _beginBalance
			End Get
			Set
				_beginBalance = Value
			End Set
		End Property

		Public Property PeriodTotal() As Single
			Get
				Return _periodTotal
			End Get
			Set
				_periodTotal = Value
			End Set
		End Property

		Public ReadOnly Property EndBalance() As Single
			Get
				Return BeginBalance - PeriodTotal
			End Get
		End Property

		Public ReadOnly Property Creditors() As List(Of CreditorDetail)
			Get
				Return _creditors
			End Get
		End Property

		Public ReadOnly Property RowCount() As Integer
			Get
				If _rowCount = 0 Then
					For Each detail As CreditorDetail In Creditors
						_rowCount += detail.Settlements.Count
					Next detail
				End If

				Return _rowCount
			End Get
		End Property

		Public Function RemoveFirstCreditor() As String
			_creditors.RemoveAt(0)

			Return String.Empty
		End Function

'INSTANT VB NOTE: The parameter clientId was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
'INSTANT VB NOTE: The parameter beginBalance was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
		Public Sub New(ByVal clientId_Renamed As Integer, ByVal beginBalance_Renamed As Single)
			_clientId = clientId_Renamed
			_beginBalance = beginBalance_Renamed
		End Sub

		Public Shared Function Load(ByVal rd As IDataReader) As SettlementTransactionDetail
'INSTANT VB NOTE: The local variable clientId was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim clientId_Renamed As Integer = rd.GetInt32(0)
'INSTANT VB NOTE: The local variable beginBalance was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim beginBalance_Renamed As Single = CSng(rd.GetDecimal(1))

			Return New SettlementTransactionDetail(clientId_Renamed, beginBalance_Renamed)
		End Function

		Public Shared Function LoadMany(ByVal rd As IDataReader) As List(Of SettlementTransactionDetail)
			Dim settlementDetails As List(Of SettlementTransactionDetail) = New List(Of SettlementTransactionDetail)()

			Do While rd.Read()
				Dim d As SettlementTransactionDetail = Load(rd)

				If Not d Is Nothing Then
					settlementDetails.Add(d)
				End If
			Loop

			rd.NextResult()

			Do While rd.Read()
				Dim creditorId As Integer = rd.GetInt32(0)
				Dim d As SettlementTransactionDetail = GetSettlementDetail(settlementDetails, creditorId)

				Dim credD As CreditorDetail = d.GetCreditorDetail(creditorId)

				If credD Is Nothing Then
					credD = CreditorDetail.Load(rd)

					d.Creditors.Add(credD)
				End If

				credD.Settlements.Add(SettlementDetail.Load(rd))
			Loop

			Return settlementDetails
		End Function

		Public Function GetCreditorDetail(ByVal creditorId As Integer) As CreditorDetail
			For Each detail As CreditorDetail In _creditors
				If detail.CreditorId = creditorId Then
					Return detail
				End If
			Next detail

			Return Nothing
		End Function

'INSTANT VB NOTE: The parameter clientId was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
		Public Shared Function GetSettlementDetail(ByVal settlementDetails As List(Of SettlementTransactionDetail), ByVal clientId_Renamed As Integer) As SettlementTransactionDetail
			For Each detail As SettlementTransactionDetail In settlementDetails
				If detail.ClientId = clientId_Renamed Then
					Return detail
				End If
			Next detail

			Return Nothing
		End Function

		'public EnrollmentTransactionDetail Clone()
'{
'return new EnrollmentTransactionDetail(ClientId, TotalFees, BeginBalance, StartDate);
'}

'object ICloneable.Clone()
'{
'return new EnrollmentTransactionDetail(ClientId, TotalFees, BeginBalance, StartDate);
'}

		Public Shared Function CreateTable(ByVal clients As Dictionary(Of Integer, Client), ByVal settlementDetails As List(Of SettlementTransactionDetail), ByVal percentage As Single) As DataTable
			Dim table As DataTable = New DataTable("SettlementDetail")

			table.Columns.Add("ClientId", GetType(Integer))
			table.Columns.Add("Account", GetType(String))
			table.Columns.Add("Name", GetType(String))
			table.Columns.Add("CreditorId", GetType(Integer))
			table.Columns.Add("Creditor", GetType(String))
			table.Columns.Add("SettlementId", GetType(Integer))
			table.Columns.Add("AmountOwed", GetType(Single))
			table.Columns.Add("AmountSettled", GetType(Single))
			table.Columns.Add("Savings", GetType(Single))
			table.Columns.Add("SettlementFees", GetType(Single))
			table.Columns.Add("BeginBalance", GetType(Single))
			table.Columns.Add("TransactionAmount", GetType(Single))
			table.Columns.Add("EndBalance", GetType(Single))
			table.Columns.Add("PayoutRate", GetType(Single))
			table.Columns.Add("Commission", GetType(Single))

			For Each detail As SettlementTransactionDetail In settlementDetails
				Dim client As Client = CType(clients(detail.ClientId), Client)

				For Each creditor As CreditorDetail In detail.Creditors
					For Each settlement As SettlementDetail In creditor.Settlements
						table.Rows.Add(New Object() { client.ClientId, client.Account, client.FullName, creditor.CreditorId, creditor.CreditorName, settlement.SettlementId, settlement.AmountOwed, settlement.AmountSettled, settlement.AmountSaved, settlement.TotalFees, detail.BeginBalance, detail.PeriodTotal, detail.EndBalance, percentage, (detail.PeriodTotal * percentage) })
					Next settlement
				Next creditor
			Next detail

			Return table
		End Function
	End Class
End Namespace