Imports Microsoft.VisualBasic
Imports System
Imports System.Collections
Imports System.Collections.Generic
Imports System.Data

Imports Drg.Util.DataAccess

Namespace Slf.Dms.Client.Agent

	''' <summary>
	''' Summary description for Client.
	''' </summary>
    Public NotInheritable Class EnrollmentTransactionDetail : Implements ICloneable

#Region "Instance Field0"
        Private _clientId As Integer
        Private _totalFees As Single
        Private _beginBalance As Single
        Private _periodTotal As Single
        Private _startDate As DateTime
#End Region
#Region "Property"
        Public Property ClientId() As Integer
            Get
                Return _clientId
            End Get
            Set(ByVal value As Integer)
                _clientId = Value
            End Set
        End Property

        Public Property TotalFees() As Single
            Get
                Return _totalFees
            End Get
            Set(ByVal value As Single)
                _totalFees = Value
            End Set
        End Property

        Public Property BeginBalance() As Single
            Get
                Return _beginBalance
            End Get
            Set(ByVal value As Single)
                _beginBalance = Value
            End Set
        End Property

        Public Property PeriodTotal() As Single
            Get
                Return _periodTotal
            End Get
            Set(ByVal value As Single)
                _periodTotal = Value
            End Set
        End Property

        Public Property StartDate() As DateTime
            Get
                Return _startDate
            End Get
            Set(ByVal value As DateTime)
                _startDate = Value
            End Set
        End Property

        Public ReadOnly Property EndBalance() As Single
            Get
                Return BeginBalance - PeriodTotal
            End Get
        End Property
#End Region
        'INSTANT VB NOTE: The parameter clientId was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
        'INSTANT VB NOTE: The parameter totalFees was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
        'INSTANT VB NOTE: The parameter beginBalance was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
        'INSTANT VB NOTE: The parameter startDate was renamed since Visual Basic will not uniquely identify class members when parameters have the same name:
        Public Sub New(ByVal clientId_Renamed As Integer, ByVal totalFees_Renamed As Single, ByVal beginBalance_Renamed As Single, ByVal startDate_Renamed As DateTime)
            _clientId = clientId_Renamed
            _totalFees = totalFees_Renamed
            _beginBalance = beginBalance_Renamed
            _startDate = startDate_Renamed
        End Sub

#Region "Data"
        Public Shared Function Load(ByVal rd As IDataReader) As EnrollmentTransactionDetail
            'INSTANT VB NOTE: The local variable clientId was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
            Dim clientId_Renamed As Integer = DatabaseHelper.Peel_int(rd, "ClientId")
            'INSTANT VB NOTE: The local variable totalFees was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
            Dim totalFees_Renamed As Single = CSng(DatabaseHelper.Peel_decimal(rd, "TotalFees"))
            'INSTANT VB NOTE: The local variable beginBalance was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
            Dim beginBalance_Renamed As Single = CSng(DatabaseHelper.Peel_decimal(rd, "EndingBalance")) - totalFees_Renamed
            'INSTANT VB NOTE: The local variable startDate was renamed since Visual Basic will not uniquely identify class members when local variables have the same name:
            Dim startDate_Renamed As DateTime = DatabaseHelper.Peel_date(rd, "EnrollDate")

            Return New EnrollmentTransactionDetail(clientId_Renamed, totalFees_Renamed, beginBalance_Renamed, startDate_Renamed)
        End Function

        Public Shared Function LoadMany(ByVal rd As IDataReader) As List(Of EnrollmentTransactionDetail)
            Dim enrollmentDetails As List(Of EnrollmentTransactionDetail) = New List(Of EnrollmentTransactionDetail)()

            Do While rd.Read()
                Dim d As EnrollmentTransactionDetail = Load(rd)

                If Not d Is Nothing Then
                    enrollmentDetails.Add(d)
                End If
            Loop

            Return enrollmentDetails
        End Function

        'Public Function Clone() As EnrollmentTransactionDetail Implements ICloneable.Clone
        '    Return New EnrollmentTransactionDetail(ClientId, TotalFees, BeginBalance, StartDate)
        'End Function

        Public Function Clone() As Object Implements System.ICloneable.Clone
            Return New EnrollmentTransactionDetail(ClientId, TotalFees, BeginBalance, StartDate)
        End Function

        Public Shared Function CreateTable(ByVal clients As Dictionary(Of Integer, Client), ByVal enrollmentDetails As List(Of EnrollmentTransactionDetail), ByVal percentage As Single) As DataTable
            Return CreateTable(clients, enrollmentDetails, percentage, "EnrollmentDetail")
        End Function

        Public Shared Function CreateTable(ByVal clients As Dictionary(Of Integer, Client), ByVal enrollmentDetails As List(Of EnrollmentTransactionDetail), ByVal percentage As Single, ByVal tableName As String) As DataTable
            Dim table As DataTable = New DataTable(tableName)

            table.Columns.Add("Account", GetType(String))
            table.Columns.Add("Name", GetType(String))
            table.Columns.Add("StartDate", GetType(DateTime))
            table.Columns.Add("EnrollFees", GetType(Single))
            table.Columns.Add("BeginBalance", GetType(Single))
            table.Columns.Add("TransactionAmount", GetType(Single))
            table.Columns.Add("EndBalance", GetType(Single))
            table.Columns.Add("PayoutRate", GetType(Single))
            table.Columns.Add("Commission", GetType(Single))

            For Each detail As EnrollmentTransactionDetail In enrollmentDetails
                Dim client As Client = CType(clients(detail.ClientId), Client)

                table.Rows.Add(New Object() {client.Account, client.FullName, detail.StartDate, detail.TotalFees, detail.BeginBalance, detail.PeriodTotal, detail.EndBalance, percentage, detail.PeriodTotal * percentage})
            Next detail

            Return table
        End Function
#End Region

       
    End Class
End Namespace