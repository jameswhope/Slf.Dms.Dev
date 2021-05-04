Option Explicit On

Public Class CheckToPrint

#Region "Variables"

    Private _checktoprintid As Integer
    Private _clientid As Integer
    Private _firstname As String
    Private _lastname As String
    Private _spousefirstname As String
    Private _spouselastname As String
    Private _street As String
    Private _street2 As String
    Private _city As String
    Private _stateabbreviation As String
    Private _statename As String
    Private _zipcode As String
    Private _accountnumber As String
    Private _bankname As String
    Private _bankcity As String
    Private _bankstateabbreviation As String
    Private _bankstatename As String
    Private _bankzipcode As String
    Private _bankroutingnumber As String
    Private _bankaccountnumber As String
    Private _amount As Double
    Private _checknumber As String
    Private _checkdate As Nullable(Of DateTime)
    Private _fraction As String
    Private _printed As Nullable(Of DateTime)
    Private _printedby As Integer
    Private _printedbyname As String
    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String

#End Region

#Region "Properties"

    ReadOnly Property CheckToPrintID() As Integer
        Get
            Return _checktoprintid
        End Get
    End Property
    ReadOnly Property ClientID() As Integer
        Get
            Return _clientid
        End Get
    End Property
    ReadOnly Property FirstName() As String
        Get
            Return _firstname
        End Get
    End Property
    ReadOnly Property LastName() As String
        Get
            Return _lastname
        End Get
    End Property
    ReadOnly Property SpouseFirstName() As String
        Get
            Return _spousefirstname
        End Get
    End Property
    ReadOnly Property SpouseLastName() As String
        Get
            Return _spouselastname
        End Get
    End Property
    ReadOnly Property Street() As String
        Get
            Return _street
        End Get
    End Property
    ReadOnly Property Street2() As String
        Get
            Return _street2
        End Get
    End Property
    ReadOnly Property City() As String
        Get
            Return _city
        End Get
    End Property
    ReadOnly Property StateAbbreviation() As String
        Get
            Return _stateabbreviation
        End Get
    End Property
    ReadOnly Property StateName() As String
        Get
            Return _statename
        End Get
    End Property
    ReadOnly Property ZipCode() As String
        Get
            Return _zipcode
        End Get
    End Property
    ReadOnly Property AccountNumber() As String
        Get
            Return _accountnumber
        End Get
    End Property
    ReadOnly Property BankName() As String
        Get
            Return _bankname
        End Get
    End Property
    ReadOnly Property BankCity() As String
        Get
            Return _bankcity
        End Get
    End Property
    ReadOnly Property BankStateAbbreviation() As String
        Get
            Return _bankstateabbreviation
        End Get
    End Property
    ReadOnly Property BankStateName() As String
        Get
            Return _bankstatename
        End Get
    End Property
    ReadOnly Property BankZipCode() As String
        Get
            Return _bankzipcode
        End Get
    End Property
    ReadOnly Property BankRoutingNumber() As String
        Get
            Return _bankroutingnumber
        End Get
    End Property
    ReadOnly Property BankAccountNumber() As String
        Get
            Return _bankaccountnumber
        End Get
    End Property
    ReadOnly Property Amount() As Double
        Get
            Return _amount
        End Get
    End Property
    ReadOnly Property CheckNumber() As String
        Get
            Return _checknumber
        End Get
    End Property
    ReadOnly Property CheckDate() As Nullable(Of DateTime)
        Get
            Return _checkdate
        End Get
    End Property
    ReadOnly Property Fraction() As String
        Get
            Return _fraction
        End Get
    End Property
    ReadOnly Property Printed() As Nullable(Of DateTime)
        Get
            Return _printed
        End Get
    End Property
    ReadOnly Property PrintedBy() As Integer
        Get
            Return _printedby
        End Get
    End Property
    ReadOnly Property PrintedByName() As String
        Get
            Return _printedbyname
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
    ReadOnly Property Status() As String
        Get

            If _printed.HasValue Then
                Return "Printed"
            Else
                Return "Not Printed"
            End If

        End Get
    End Property
    ReadOnly Property StatusFormatted() As String
        Get

            If _printed.HasValue Then
                Return "<font style=""color:rgb(0,0,220);"">Printed</font><font style=""color:rgb(120,120,120);font-size:10px;""><br>" & _printed.Value.ToString("M/d/yyyy") & "</font>"
            Else
                Return "<font style=""color:red;"">Not Printed</font>"
            End If

        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal CheckToPrintID As Integer, ByVal ClientID As Integer, ByVal FirstName As String, _
        ByVal LastName As String, ByVal SpouseFirstName As String, ByVal SpouseLastName As String, _
        ByVal Street As String, ByVal Street2 As String, ByVal City As String, ByVal StateAbbreviation As String, _
        ByVal StateName As String, ByVal ZipCode As String, ByVal AccountNumber As String, _
        ByVal BankName As String, ByVal BankCity As String, ByVal BankStateAbbreviation As String, _
        ByVal BankStateName As String, ByVal BankZipCode As String, ByVal BankRoutingNumber As String, _
        ByVal BankAccountNumber As String, ByVal Amount As Double, ByVal CheckNumber As String, _
        ByVal CheckDate As Nullable(Of DateTime), ByVal Fraction As String, _
        ByVal Printed As Nullable(Of DateTime), ByVal PrintedBy As Integer, ByVal PrintedByName As String, _
        ByVal Created As DateTime, ByVal CreatedBy As Integer, ByVal CreatedByName As String)

        _checktoprintid = CheckToPrintID
        _clientid = ClientID
        _firstname = FirstName
        _lastname = LastName
        _spousefirstname = SpouseFirstName
        _spouselastname = SpouseLastName
        _street = Street
        _street2 = Street2
        _city = City
        _stateabbreviation = StateAbbreviation
        _statename = StateName
        _zipcode = ZipCode
        _accountnumber = AccountNumber
        _bankname = BankName
        _bankcity = BankCity
        _bankstateabbreviation = BankStateAbbreviation
        _bankstatename = BankStateName
        _bankzipcode = BankZipCode
        _bankroutingnumber = BankRoutingNumber
        _bankaccountnumber = BankAccountNumber
        _amount = Amount
        _checknumber = CheckNumber
        _checkdate = CheckDate
        _fraction = Fraction
        _printed = Printed
        _printedby = PrintedBy
        _printedbyname = PrintedByName
        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName

    End Sub

#End Region

End Class