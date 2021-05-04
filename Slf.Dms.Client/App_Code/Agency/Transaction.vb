Imports Microsoft.VisualBasic
Imports System
Imports System.Collections
Imports System.Collections.Generic
Imports System.Data

Namespace Slf.Dms.Client.Agent
	''' <summary>
	''' Summary description for Client.
	''' </summary>
	Public NotInheritable Class Transaction
		Private _clientId As Integer
		Private _amount As Single
		Private _entryTypeId As Integer

		Public Property ClientId() As Integer
			Get
				Return _clientId
			End Get
			Set
				_clientId = Value
			End Set
		End Property

		Public Property Amount() As Single
			Get
				Return _amount
			End Get
			Set
				_amount = Value
			End Set
		End Property

		Public Property EntryTypeId() As Integer
			Get
				Return _entryTypeId
			End Get
			Set
				_entryTypeId = Value
			End Set
		End Property

'INSTANT VB NOTE: The parameter clientId was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
'INSTANT VB NOTE: The parameter amount was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
'INSTANT VB NOTE: The parameter entryTypeId was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
		Public Sub New(ByVal clientId_Renamed As Integer, ByVal amount_Renamed As Single, ByVal entryTypeId_Renamed As Integer)
			_clientId = clientId_Renamed
			_amount = amount_Renamed
			_entryTypeId = entryTypeId_Renamed
		End Sub

		Public Shared Function Load(ByVal rd As IDataReader) As Transaction
'INSTANT VB NOTE: The local variable clientId was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim clientId_Renamed As Integer = rd.GetInt32(0)
'INSTANT VB NOTE: The local variable amount was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim amount_Renamed As Single = CSng(rd.GetDouble(1))
'INSTANT VB NOTE: The local variable entryTypeId was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim entryTypeId_Renamed As Integer = rd.GetInt32(2)

			Return New Transaction(clientId_Renamed, amount_Renamed, entryTypeId_Renamed)
		End Function

		Public Shared Function LoadMany(ByVal rd As IDataReader) As List(Of Transaction)
			Dim transactions As List(Of Transaction) = New List(Of Transaction)()

			Do While rd.Read()
				Dim t As Transaction = Load(rd)

				If Not t Is Nothing Then
					transactions.Add(t)
				End If
			Loop

			Return transactions
		End Function
	End Class
End Namespace