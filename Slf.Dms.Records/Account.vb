Option Explicit On

Public Class Account

#Region "Variables"

    Private _accountid As Integer
    Private _clientid As Integer
    Private _originalamount As Double
    Private _currentamount As Double
    Private _currentcreditorinstanceid As Integer
    Private _setupfeepercentage As Double
    Private _originalduedate As DateTime

    Private _creditorid As Integer
    Private _creditorname As String
    Private _creditorstreet As String
    Private _creditorstreet2 As String
    Private _creditorcity As String
    Private _creditorstateid As Integer
    Private _creditorstatename As String
    Private _creditorstateabbreviation As String
    Private _creditorzipcode As String
    Private _creditorvalidated As Boolean
    Private _creditorgroupid As Integer

    Private _forcreditorid As Integer
    Private _forcreditorname As String
    Private _forcreditorstreet As String
    Private _forcreditorstreet2 As String
    Private _forcreditorcity As String
    Private _forcreditorstateid As Integer
    Private _forcreditorstatename As String
    Private _forcreditorstateabbreviation As String
    Private _forcreditorzipcode As String
    Private _forcreditorvalidated As Boolean
    Private _forcreditorgroupid As Integer

    Private _acquired As DateTime
    Private _accountnumber As String
    Private _referencenumber As String

    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String
    Private _settled As Nullable(Of DateTime)
    Private _settledby As Integer
    Private _settledbyname As String

    Private _canvalidatecreditor As Boolean
    Private _canvalidateforcreditor As Boolean

#End Region

#Region "Properties"

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
    ReadOnly Property CurrentCreditorInstanceID() As Integer
        Get
            Return _currentcreditorinstanceid
        End Get
    End Property
    ReadOnly Property SetupFeePercentage() As Double
        Get
            Return _setupfeepercentage
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
    ReadOnly Property CreditorID() As Integer
        Get
            Return _creditorid
        End Get
    End Property
    ReadOnly Property CreditorGroupID() As Integer
        Get
            Return _creditorgroupid
        End Get
    End Property
    ReadOnly Property CreditorName() As String
        Get
            Return _creditorname
        End Get
    End Property
    ReadOnly Property CreditorStreet() As String
        Get
            Return _creditorstreet
        End Get
    End Property
    ReadOnly Property CreditorStreet2() As String
        Get
            Return _creditorstreet2
        End Get
    End Property
    ReadOnly Property CreditorCity() As String
        Get
            Return _creditorcity
        End Get
    End Property
    ReadOnly Property CreditorStateID() As Integer
        Get
            Return _creditorstateid
        End Get
    End Property
    ReadOnly Property CreditorStateName() As String
        Get
            Return _creditorstatename
        End Get
    End Property
    ReadOnly Property CreditorStateAbbreviation() As String
        Get
            Return _creditorstateabbreviation
        End Get
    End Property
    ReadOnly Property CreditorZipCode() As String
        Get
            Return _creditorzipcode
        End Get
    End Property
    ReadOnly Property CreditorValidated() As Boolean
        Get
            Return _creditorvalidated
        End Get
    End Property
    ReadOnly Property CreditorCanValidate() As Boolean
        Get

        End Get
    End Property
    ReadOnly Property ForCreditorID() As Integer
        Get
            Return _forcreditorid
        End Get
    End Property
    ReadOnly Property ForCreditorGroupID() As Integer
        Get
            Return _forcreditorgroupid
        End Get
    End Property
    ReadOnly Property ForCreditorName() As String
        Get
            Return _forcreditorname
        End Get
    End Property
    ReadOnly Property ForCreditorStreet() As String
        Get
            Return _forcreditorstreet
        End Get
    End Property
    ReadOnly Property ForCreditorStreet2() As String
        Get
            Return _forcreditorstreet2
        End Get
    End Property
    ReadOnly Property ForCreditorCity() As String
        Get
            Return _forcreditorcity
        End Get
    End Property
    ReadOnly Property ForCreditorStateID() As Integer
        Get
            Return _forcreditorstateid
        End Get
    End Property
    ReadOnly Property ForCreditorStateName() As String
        Get
            Return _forcreditorstatename
        End Get
    End Property
    ReadOnly Property ForCreditorStateAbbreviation() As String
        Get
            Return _forcreditorstateabbreviation
        End Get
    End Property
    ReadOnly Property ForCreditorZipCode() As String
        Get
            Return _forcreditorzipcode
        End Get
    End Property
    ReadOnly Property ForCreditorValidated() As Boolean
        Get
            Return _forcreditorvalidated
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
    ReadOnly Property Settled() As Nullable(Of DateTime)
        Get
            Return _settled
        End Get
    End Property
    ReadOnly Property SettledBy() As Integer
        Get
            Return _settledby
        End Get
    End Property
    ReadOnly Property SettledByName() As String
        Get
            Return _settledbyname
        End Get
    End Property
    ReadOnly Property CanValidateCreditor() As Boolean
        Get
            Return _canvalidatecreditor
        End Get
    End Property
    ReadOnly Property CanValidateForCreditor() As Boolean
        Get
            Return _canvalidateforcreditor
        End Get
    End Property
#End Region

#Region "Constructor"

    Public Sub New(ByVal AccountID As Integer, ByVal ClientID As Integer, _
        ByVal OriginalAmount As Double, ByVal CurrentAmount As Double, _
        ByVal CurrentCreditorInstanceID As Integer, ByVal SetupFeePercentage As Double, _
        ByVal OriginalDueDate As DateTime, ByVal CreditorID As Integer, ByVal CreditorName As String, _
        ByVal CreditorStreet As String, ByVal CreditorStreet2 As String, ByVal CreditorCity As String, _
        ByVal CreditorStateID As Integer, ByVal CreditorStateName As String, _
        ByVal CreditorStateAbbreviation As String, ByVal CreditorZipCode As String, _
        ByVal ForCreditorID As Integer, ByVal ForCreditorName As String, ByVal ForCreditorStreet As String, _
        ByVal ForCreditorStreet2 As String, ByVal ForCreditorCity As String, ByVal ForCreditorStateID As Integer, _
        ByVal ForCreditorStateName As String, ByVal ForCreditorStateAbbreviation As String, _
        ByVal ForCreditorZipCode As String, ByVal Acquired As DateTime, ByVal AccountNumber As String, _
        ByVal ReferenceNumber As String, ByVal Created As DateTime, _
        ByVal CreatedBy As Integer, ByVal CreatedByName As String, ByVal LastModified As DateTime, _
        ByVal LastModifiedBy As Integer, ByVal LastModifiedByName As String, _
        ByVal Settled As Nullable(Of DateTime), ByVal SettledBy As Integer, ByVal SettledByName As String)

        _accountid = AccountID
        _clientid = ClientID
        _originalamount = OriginalAmount
        _currentamount = CurrentAmount
        _currentcreditorinstanceid = CurrentCreditorInstanceID
        _setupfeepercentage = SetupFeePercentage
        _originalduedate = OriginalDueDate

        _creditorid = CreditorID
        _creditorname = CreditorName
        _creditorstreet = CreditorStreet
        _creditorstreet2 = CreditorStreet2
        _creditorcity = CreditorCity
        _creditorstateid = CreditorStateID
        _creditorstatename = CreditorStateName
        _creditorstateabbreviation = CreditorStateAbbreviation
        _creditorzipcode = CreditorZipCode

        _forcreditorid = ForCreditorID
        _forcreditorname = ForCreditorName
        _forcreditorstreet = ForCreditorStreet
        _forcreditorstreet2 = ForCreditorStreet2
        _forcreditorcity = ForCreditorCity
        _forcreditorstateid = ForCreditorStateID
        _forcreditorstatename = ForCreditorStateName
        _forcreditorstateabbreviation = ForCreditorStateAbbreviation
        _forcreditorzipcode = ForCreditorZipCode

        _acquired = Acquired
        _accountnumber = AccountNumber
        _referencenumber = ReferenceNumber

        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName
        _settled = Settled
        _settledby = SettledBy
        _settledbyname = SettledByName

    End Sub

    Public Sub New(ByVal AccountID As Integer, ByVal ClientID As Integer, _
        ByVal OriginalAmount As Double, ByVal CurrentAmount As Double, _
        ByVal CurrentCreditorInstanceID As Integer, ByVal SetupFeePercentage As Double, _
        ByVal OriginalDueDate As DateTime, ByVal CreditorID As Integer, ByVal CreditorName As String, _
        ByVal CreditorStreet As String, ByVal CreditorStreet2 As String, ByVal CreditorCity As String, _
        ByVal CreditorStateID As Integer, ByVal CreditorStateName As String, _
        ByVal CreditorStateAbbreviation As String, ByVal CreditorZipCode As String, _
        ByVal ForCreditorID As Integer, ByVal ForCreditorName As String, ByVal ForCreditorStreet As String, _
        ByVal ForCreditorStreet2 As String, ByVal ForCreditorCity As String, ByVal ForCreditorStateID As Integer, _
        ByVal ForCreditorStateName As String, ByVal ForCreditorStateAbbreviation As String, _
        ByVal ForCreditorZipCode As String, ByVal Acquired As DateTime, ByVal AccountNumber As String, _
        ByVal ReferenceNumber As String, ByVal Created As DateTime, _
        ByVal CreatedBy As Integer, ByVal CreatedByName As String, ByVal LastModified As DateTime, _
        ByVal LastModifiedBy As Integer, ByVal LastModifiedByName As String, _
        ByVal Settled As Nullable(Of DateTime), ByVal SettledBy As Integer, ByVal SettledByName As String, _
        ByVal CreditorValidated As Object, ByVal ForCreditorValidated As Object, _
        ByVal CreditorGroupID As Integer, ByVal ForCreditorGroupID As Integer)

        Me.New(AccountID, ClientID, _
             OriginalAmount, CurrentAmount, _
             CurrentCreditorInstanceID, SetupFeePercentage, _
             OriginalDueDate, CreditorID, CreditorName, _
             CreditorStreet, CreditorStreet2, CreditorCity, _
             CreditorStateID, CreditorStateName, _
             CreditorStateAbbreviation, CreditorZipCode, _
             ForCreditorID, ForCreditorName, ForCreditorStreet, _
             ForCreditorStreet2, ForCreditorCity, ForCreditorStateID, _
             ForCreditorStateName, ForCreditorStateAbbreviation, _
             ForCreditorZipCode, Acquired, AccountNumber, _
             ReferenceNumber, Created, _
             CreatedBy, CreatedByName, LastModified, _
             LastModifiedBy, LastModifiedByName, _
             Settled, SettledBy, SettledByName)

        If CreditorValidated Is DBNull.Value Then
            _creditorvalidated = False
            _canvalidatecreditor = False 'this creditor is not flagged for validation
        Else
            _creditorvalidated = CBool(CreditorValidated)
            _canvalidatecreditor = True 'if needed
        End If

        If ForCreditorValidated Is DBNull.Value Then
            _forcreditorvalidated = False
            _canvalidateforcreditor = False
        Else
            _forcreditorvalidated = CBool(ForCreditorValidated)
            _canvalidateforcreditor = True 'if needed
        End If

        _creditorgroupid = CreditorGroupID
        _forcreditorgroupid = ForCreditorGroupID
    End Sub

#End Region

End Class