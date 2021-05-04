Imports Microsoft.VisualBasic
Imports System
Imports System.Collections
Imports System.Collections.Generic
Imports System.Data

Namespace Slf.Dms.Client.Agent
	''' <summary>
	''' Summary description for Client.
	''' </summary>
	Public NotInheritable Class CreditorDetail ' : ICloneable
		Private _creditorId As Integer
		Private _creditorName As String
		Private _settlements As List(Of SettlementDetail) = New List(Of SettlementDetail)()

		Public Property CreditorId() As Integer
			Get
				Return _creditorId
			End Get
			Set
				_creditorId = Value
			End Set
		End Property

		Public Property CreditorName() As String
			Get
				Return _creditorName
			End Get
			Set
				_creditorName = Value
			End Set
		End Property

		Public ReadOnly Property Settlements() As List(Of SettlementDetail)
			Get
				Return _settlements
			End Get
		End Property

		Public Function RemoveFirstSettlement() As String
			_settlements.RemoveAt(0)

			Return String.Empty
		End Function

'INSTANT VB NOTE: The parameter creditorId was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
'INSTANT VB NOTE: The parameter creditorName was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
		Public Sub New(ByVal creditorId_Renamed As Integer, ByVal creditorName_Renamed As String)
			_creditorId = creditorId_Renamed
			_creditorName = creditorName_Renamed
		End Sub

		Public Shared Function Load(ByVal rd As IDataReader) As CreditorDetail
'INSTANT VB NOTE: The local variable creditorId was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim creditorId_Renamed As Integer = rd.GetInt32(1)

'INSTANT VB NOTE: The local variable creditorName was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim creditorName_Renamed As String

			If (Not rd.IsDBNull(3)) Then
				creditorName_Renamed = rd.GetString(3)
			Else
				creditorName_Renamed = "[unknown]"
			End If

			Return New CreditorDetail(creditorId_Renamed, creditorName_Renamed)
		End Function
	End Class
End Namespace