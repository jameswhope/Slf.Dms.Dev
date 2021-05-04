Option Explicit On

Public Class Mediation

#Region "Variables"

    Private _mediationid As Integer
    Private _accountid As Integer
    Private _clientid As Integer
    Private _originalamount As Double
    Private _currentamount As Double
    Private _currentcreditorinstanceid As Integer
    Private _accountnumber As String
    Private _currentcreditorid As Integer
    Private _currentcreditorname As String
    Private _registerbalance As Double
    Private _accountbalance As Double
    Private _settlementpercentage As Double
    Private _settlementamount As Double
    Private _amountavailable As Double
    Private _amountbeingsent As Double
    Private _duedate As Nullable(Of DateTime)
    Private _savings As Double
    Private _settlementfee As Double
    Private _overnightdeliveryamount As Double
    Private _settlementcost As Double
    Private _availableaftersettlement As Double
    Private _amountbeingpaid As Double
    Private _amountstillowed As Double
    Private _status As String
    Private _frozenamount As Double
    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String

#End Region

#Region "Properties"

    ReadOnly Property MediationID() As Integer
        Get
            Return _mediationid
        End Get
    End Property
    ReadOnly Property AccountID() As Integer
        Get
            Return _accountid
        End Get
    End Property
    ReadOnly Property ClientID() As Integer
        Get
            Return _clientid
        End Get
    End Property
    ReadOnly Property OriginalAmount() As Double
        Get
            Return _originalamount
        End Get
    End Property
    ReadOnly Property CurrentAmount() As Double
        Get
            Return _currentamount
        End Get
    End Property
    ReadOnly Property CurrentCreditorInstanceID() As Integer
        Get
            Return _currentcreditorinstanceid
        End Get
    End Property
    ReadOnly Property AccountNumber() As String
        Get
            Return _accountnumber
        End Get
    End Property
    ReadOnly Property CurrentCreditorID() As Integer
        Get
            Return _currentcreditorid
        End Get
    End Property
    ReadOnly Property CurrentCreditorName() As String
        Get
            Return _currentcreditorname
        End Get
    End Property
    ReadOnly Property RegisterBalance() As Double
        Get
            Return _registerbalance
        End Get
    End Property
    ReadOnly Property AccountBalance() As Double
        Get
            Return _accountbalance
        End Get
    End Property
    ReadOnly Property SettlementPercentage() As Double
        Get
            Return _settlementpercentage
        End Get
    End Property
    ReadOnly Property SettlementAmount() As Double
        Get
            Return _settlementamount
        End Get
    End Property
    ReadOnly Property AmountAvailable() As Double
        Get
            Return _amountavailable
        End Get
    End Property
    ReadOnly Property AmountBeingSent() As Double
        Get
            Return _amountbeingsent
        End Get
    End Property
    ReadOnly Property DueDate() As Nullable(Of DateTime)
        Get
            Return _duedate
        End Get
    End Property
    ReadOnly Property Savings() As Double
        Get
            Return _savings
        End Get
    End Property
    ReadOnly Property SettlementFee() As Double
        Get
            Return _settlementfee
        End Get
    End Property
    ReadOnly Property OvernightDeliveryAmount() As Double
        Get
            Return _overnightdeliveryamount
        End Get
    End Property
    ReadOnly Property SettlementCost() As Double
        Get
            Return _settlementcost
        End Get
    End Property
    ReadOnly Property AvailableAfterSettlement() As Double
        Get
            Return _availableaftersettlement
        End Get
    End Property
    ReadOnly Property AmountBeingPaid() As Double
        Get
            Return _amountbeingpaid
        End Get
    End Property
    ReadOnly Property AmountStillOwed() As Double
        Get
            Return _amountstillowed
        End Get
    End Property
    ReadOnly Property Status() As String
        Get
            Return _status
        End Get
    End Property
    ReadOnly Property FrozenAmount() As Double
        Get
            Return _frozenamount
        End Get
    End Property
    ReadOnly Property Created() As DateTime
        Get
            Return _created
        End Get
    End Property
    ReadOnly Property CreatedBy() As Integer
        Get
            Return _createdby
        End Get
    End Property
    ReadOnly Property CreatedByName() As String
        Get
            Return _createdbyname
        End Get
    End Property
    ReadOnly Property LastModified() As DateTime
        Get
            Return _lastmodified
        End Get
    End Property
    ReadOnly Property LastModifiedBy() As Integer
        Get
            Return _lastmodifiedby
        End Get
    End Property
    ReadOnly Property LastModifiedByName() As String
        Get
            Return _lastmodifiedbyname
        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal MediationID As Integer, ByVal AccountID As Integer, ByVal ClientID As Integer, _
        ByVal OriginalAmount As Double, ByVal CurrentAmount As Double, ByVal CurrentCreditorInstanceID As Integer, _
        ByVal AccountNumber As String, ByVal CurrentCreditorID As Integer, ByVal CurrentCreditorName As String, _
        ByVal RegisterBalance As Double, _
        ByVal AccountBalance As Double, ByVal SettlementPercentage As Double, ByVal SettlementAmount As Double, _
        ByVal AmountAvailable As Double, ByVal AmountBeingSent As Double, ByVal DueDate As Nullable(Of DateTime), _
        ByVal Savings As Double, ByVal SettlementFee As Double, ByVal OvernightDeliveryAmount As Double, _
        ByVal SettlementCost As Double, ByVal AvailableAfterSettlement As Double, ByVal AmountBeingPaid As Double, _
        ByVal AmountStillOwed As Double, ByVal Status As String, ByVal FrozenAmount As Double, _
        ByVal Created As DateTime, ByVal CreatedBy As Integer, ByVal CreatedByName As String, _
        ByVal LastModified As DateTime, ByVal LastModifiedBy As Integer, ByVal LastModifiedByName As String)

        _mediationid = MediationID
        _accountid = AccountID
        _clientid = ClientID
        _originalamount = OriginalAmount
        _currentamount = CurrentAmount
        _currentcreditorinstanceid = CurrentCreditorInstanceID
        _accountnumber = AccountNumber
        _currentcreditorid = CurrentCreditorID
        _currentcreditorname = CurrentCreditorName
        _registerbalance = RegisterBalance
        _accountbalance = AccountBalance
        _settlementpercentage = SettlementPercentage
        _settlementamount = SettlementAmount
        _amountavailable = AmountAvailable
        _amountbeingsent = AmountBeingSent
        _duedate = DueDate
        _savings = Savings
        _settlementfee = SettlementFee
        _overnightdeliveryamount = OvernightDeliveryAmount
        _settlementcost = SettlementCost
        _availableaftersettlement = AvailableAfterSettlement
        _amountbeingpaid = AmountBeingPaid
        _amountstillowed = AmountStillOwed
        _status = Status
        _frozenamount = FrozenAmount
        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName

    End Sub

#End Region

End Class