Imports Microsoft.VisualBasic
Imports System
Imports System.Collections
Imports System.Data
Imports Drg.Util.DataAccess
Imports System.Collections.Generic

Namespace Slf.Dms.Client.Agent
	''' <summary>
	''' Summary description for Client.
	''' </summary>
	Public NotInheritable Class Client
		Private _clientId As Integer
		Private _fullName As String
		Private _account As String

		Public Property ClientId() As Integer
			Get
				Return _clientId
			End Get
			Set
				_clientId = Value
			End Set
		End Property

		Public Property FullName() As String
			Get
				Return _fullName
			End Get
			Set
				_fullName = Value
			End Set
		End Property

		Public Property Account() As String
			Get
				Return _account
			End Get
			Set
				_account = Value
			End Set
		End Property

'INSTANT VB NOTE: The parameter clientId was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
'INSTANT VB NOTE: The parameter fullName was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
'INSTANT VB NOTE: The parameter account was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
		Public Sub New(ByVal clientId_Renamed As Integer, ByVal fullName_Renamed As String, ByVal account_Renamed As String)
			_clientId = clientId_Renamed
			_fullName = fullName_Renamed
			_account = account_Renamed
		End Sub

		Public Shared Function Load(ByVal rd As IDataReader) As Client
'INSTANT VB NOTE: The local variable clientId was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim clientId_Renamed As Integer = rd.GetInt32(0)
'INSTANT VB NOTE: The local variable fullName was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim fullName_Renamed As String = rd.GetString(1)
'INSTANT VB NOTE: The local variable account was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
			Dim account_Renamed As String = DataHelper.Nz_string(DatabaseHelper.Peel_string(rd, "Account"))

			Return New Client(clientId_Renamed, fullName_Renamed, account_Renamed)
		End Function

		Public Shared Function LoadMany(ByVal rd As IDataReader) As Dictionary(Of Integer, Client)
			Dim clients As Dictionary(Of Integer, Client) = New Dictionary(Of Integer, Client)()

			Do While rd.Read()
				Dim c As Client = Load(rd)

				If Not c Is Nothing Then
					clients.Add(c.ClientId, c)
				End If
			Loop

			Return clients
		End Function
	End Class
End Namespace