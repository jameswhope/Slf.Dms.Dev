Option Explicit On

Public Class RegisterPayment

#Region "Variables"

    Private _registerpaymentid As Integer
    Private _paymentdate As DateTime
    Private _feeregisterid As Integer
    Private _feeregisterentrytypeid As Integer
    Private _feeregisterentrytypename As String
    Private _feeregistertransactiondate As DateTime
    Private _feeregisterchecknumber As String
    Private _feeregisteramount As Double
    Private _feeregisterisfullypaid As Boolean
    Private _amount As Double
    Private _voided As Boolean
    Private _bounced As Boolean

    Private _deposits As List(Of RegisterPaymentDeposit)

#End Region

#Region "Properties"

    ReadOnly Property Deposits() As List(Of RegisterPaymentDeposit)
        Get

            If _deposits Is Nothing Then
                _deposits = New List(Of RegisterPaymentDeposit)
            End If

            Return _deposits

        End Get
    End Property
    ReadOnly Property RegisterPaymentID() As Integer
        Get
            Return _registerpaymentid
        End Get
    End Property
    ReadOnly Property PaymentDate() As DateTime
        Get
            Return _paymentdate
        End Get
    End Property
    ReadOnly Property FeeRegisterID() As Integer
        Get
            Return _feeregisterid
        End Get
    End Property
    ReadOnly Property FeeRegisterEntryTypeID() As Integer
        Get
            Return _feeregisterentrytypeid
        End Get
    End Property
    ReadOnly Property FeeRegisterEntryTypeName() As String
        Get
            Return _feeregisterentrytypename
        End Get
    End Property
    ReadOnly Property FeeRegisterTransactionDate() As DateTime
        Get
            Return _feeregistertransactiondate
        End Get
    End Property
    ReadOnly Property FeeRegisterCheckNumber() As String
        Get
            Return _feeregisterchecknumber
        End Get
    End Property
    ReadOnly Property FeeRegisterAmount() As Double
        Get
            Return _feeregisteramount
        End Get
    End Property
    ReadOnly Property FeeRegisterIsFullyPaid() As Double
        Get
            Return _feeregisterisfullypaid
        End Get
    End Property
    ReadOnly Property Amount() As Double
        Get
            Return _amount
        End Get
    End Property
    ReadOnly Property Voided() As Boolean
        Get
            Return _voided
        End Get
    End Property
    ReadOnly Property Bounced() As Boolean
        Get
            Return _bounced
        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal RegisterPaymentID As Integer, ByVal PaymentDate As DateTime, _
        ByVal FeeRegisterID As Integer, ByVal FeeRegisterEntryTypeID As Integer, _
        ByVal FeeRegisterEntryTypeName As String, ByVal FeeRegisterTransactionDate As DateTime, _
        ByVal FeeRegisterCheckNumber As String, ByVal FeeRegisterAmount As Double, _
        ByVal FeeRegisterIsFullyPaid As Boolean, ByVal Amount As Double, ByVal Voided As Boolean, _
        ByVal Bounced As Boolean)

        _registerpaymentid = RegisterPaymentID
        _paymentdate = PaymentDate
        _feeregisterid = FeeRegisterID
        _feeregisterentrytypeid = FeeRegisterEntryTypeID
        _feeregisterentrytypename = FeeRegisterEntryTypeName
        _feeregistertransactiondate = FeeRegisterTransactionDate
        _feeregisterchecknumber = FeeRegisterCheckNumber
        _feeregisteramount = FeeRegisterAmount
        _feeregisterisfullypaid = FeeRegisterIsFullyPaid
        _amount = Amount
        _voided = Voided
        _bounced = Bounced

    End Sub

#End Region

End Class