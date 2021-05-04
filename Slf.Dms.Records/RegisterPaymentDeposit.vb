Option Explicit On

Public Class RegisterPaymentDeposit

#Region "Variables"

    Private _registerpaymentdepositid As Integer
    Private _registerpaymentid As Integer
    Private _depositregisterid As Integer
    Private _depositregisterentrytypeid As Integer
    Private _depositregisterentrytypename As String
    Private _depositregistertransactiondate As DateTime
    Private _depositregisterchecknumber As String
    Private _depositregisteramount As Double
    Private _depositregisterisfullypaid As Boolean
    Private _amount As Double
    Private _voided As Boolean
    Private _bounced As Boolean

#End Region

#Region "Properties"

    ReadOnly Property RegisterPaymentDepositID() As Integer
        Get
            Return _registerpaymentdepositid
        End Get
    End Property
    ReadOnly Property RegisterPaymentID() As Integer
        Get
            Return _registerpaymentid
        End Get
    End Property
    ReadOnly Property DepositRegisterID() As Integer
        Get
            Return _depositregisterid
        End Get
    End Property
    ReadOnly Property DepositRegisterEntryTypeID() As Integer
        Get
            Return _depositregisterentrytypeid
        End Get
    End Property
    ReadOnly Property DepositRegisterEntryTypeName() As String
        Get
            Return _depositregisterentrytypename
        End Get
    End Property
    ReadOnly Property DepositRegisterTransactionDate() As DateTime
        Get
            Return _depositregistertransactiondate
        End Get
    End Property
    ReadOnly Property DepositRegisterCheckNumber() As String
        Get
            Return _depositregisterchecknumber
        End Get
    End Property
    ReadOnly Property DepositRegisterAmount() As Double
        Get
            Return _depositregisteramount
        End Get
    End Property
    ReadOnly Property DepositRegisterIsFullyPaid() As Boolean
        Get
            Return _depositregisterisfullypaid
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

    Public Sub New(ByVal RegisterPaymentDepositID As Integer, ByVal RegisterPaymentID As Integer, _
        ByVal DepositRegisterID As Integer, ByVal DepositRegisterEntryTypeID As Integer, _
        ByVal DepositRegisterEntryTypeName As String, ByVal DepositRegisterTransactionDate As DateTime, _
        ByVal DepositRegisterCheckNumber As String, ByVal DepositRegisterAmount As Double, _
        ByVal DepositRegisterIsFullyPaid As Boolean, ByVal Amount As Double, ByVal Voided As Boolean, _
        ByVal Bounced As Boolean)

        _registerpaymentdepositid = RegisterPaymentDepositID
        _registerpaymentid = RegisterPaymentID
        _depositregisterid = DepositRegisterID
        _depositregisterentrytypeid = DepositRegisterEntryTypeID
        _depositregisterentrytypename = DepositRegisterEntryTypeName
        _depositregistertransactiondate = DepositRegisterTransactionDate
        _depositregisterchecknumber = DepositRegisterCheckNumber
        _depositregisteramount = DepositRegisterAmount
        _depositregisterisfullypaid = DepositRegisterIsFullyPaid
        _amount = Amount
        _voided = Voided
        _bounced = Bounced

    End Sub

#End Region

End Class