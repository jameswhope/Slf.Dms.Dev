Option Explicit On

Public Class CreditorInstance

#Region "Variables"

    Private _creditorinstanceid As Integer
    Private _accountid As Integer
    Private _creditorid As Integer
    Private _acquired As DateTime
    Private _accountnumber As String
    Private _referencenumber As String
    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String
    Private _iscurrent As Boolean
    Private _originalduedate As DateTime
    Private _originalamount As Double
    Private _currentamount As Double
    Private _creditorname As String

    Private _approot As String
    Private _showoriginalamount As Boolean
    Private _showcurrentamount As Boolean

#End Region

#Region "Properties"

    ReadOnly Property CreditorInstanceID() As Integer
        Get
            Return _creditorinstanceid
        End Get
    End Property
    ReadOnly Property AccountID() As Integer
        Get
            Return _accountid
        End Get
    End Property
    ReadOnly Property CreditorID() As Integer
        Get
            Return _creditorid
        End Get
    End Property
    ReadOnly Property Acquired() As DateTime
        Get
            Return _acquired
        End Get
    End Property
    ReadOnly Property AccountNumber() As String
        Get
            Return _accountnumber
        End Get
    End Property
    ReadOnly Property ReferenceNumber() As String
        Get
            Return _referencenumber
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
    ReadOnly Property IsCurrent() As Boolean
        Get
            Return _iscurrent
        End Get
    End Property
    ReadOnly Property OriginalDueDate() As DateTime
        Get
            Return _originalduedate
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
    ReadOnly Property CreditorName() As String
        Get
            Return _creditorname
        End Get
    End Property
    Property ShowOriginalAmount() As Boolean
        Get
            Return _showoriginalamount
        End Get
        Set(ByVal value As Boolean)
            _showoriginalamount = value
        End Set
    End Property
    Property ShowCurrentAmount() As Boolean
        Get
            Return _showcurrentamount
        End Get
        Set(ByVal value As Boolean)
            _showcurrentamount = value
        End Set
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal CreditorInstanceID As Integer, ByVal AccountID As Integer, ByVal CreditorID As Integer, _
        ByVal Acquired As DateTime, ByVal AccountNumber As String, _
        ByVal ReferenceNumber As String, ByVal Created As DateTime, _
        ByVal CreatedBy As Integer, ByVal CreatedByName As String, ByVal LastModified As DateTime, _
        ByVal LastModifiedBy As Integer, ByVal LastModifiedByName As String, ByVal IsCurrent As Boolean, _
        ByVal OriginalDueDate As DateTime, ByVal OriginalAmount As Double, ByVal CurrentAmount As Double, _
        ByVal CreditorName As String, ByVal AppRoot As String)

        _creditorinstanceid = CreditorInstanceID
        _accountid = AccountID
        _creditorid = CreditorID
        _acquired = Acquired
        _accountnumber = AccountNumber
        _referencenumber = ReferenceNumber
        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName
        _iscurrent = IsCurrent
        _originalduedate = OriginalDueDate
        _originalamount = OriginalAmount
        _currentamount = CurrentAmount
        _creditorname = CreditorName

        _approot = AppRoot

    End Sub

#End Region

End Class