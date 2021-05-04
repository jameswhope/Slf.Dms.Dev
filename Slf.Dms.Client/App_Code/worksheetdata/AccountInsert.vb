Option Explicit On

Namespace WorksheetData

    Public Class AccountInsert

#Region "Variables"

        Private _creditorname As String
        Private _forcreditorname As String
        Private _amount As Double
        Private _accountnumber As String
        Private _referencenumber As String
        Private _street As String
        Private _street2 As String = ""
        Private _city As String
        Private _stateid As Integer
        Private _zipcode As String
        Private _phonenumber As String
        Private _faxnumber As String
        Private _forstreet As String
        Private _forstreet2 As String = ""
        Private _forcity As String
        Private _forstateid As Integer
        Private _forzipcode As String
        Private _creditorid As Integer
        Private _forcreditorid As Integer
        Private _creditorgroupid As Integer
        Private _forcreditorgroupid As Integer

#End Region

#Region "Properties"

        Property CreditorName() As String
            Get
                Return _creditorname
            End Get
            Set(ByVal value As String)
                _creditorname = value
            End Set
        End Property
        Property ForCreditorName() As String
            Get
                Return _forcreditorname
            End Get
            Set(ByVal value As String)
                _forcreditorname = value
            End Set
        End Property
        Property Amount() As Double
            Get
                Return _amount
            End Get
            Set(ByVal value As Double)
                _amount = value
            End Set
        End Property
        Property AccountNumber() As String
            Get
                Return _accountnumber
            End Get
            Set(ByVal value As String)
                _accountnumber = value
            End Set
        End Property
        Property ReferenceNumber() As String
            Get
                Return _referencenumber
            End Get
            Set(ByVal value As String)
                _referencenumber = value
            End Set
        End Property
        Property Street() As String
            Get
                Return _street
            End Get
            Set(ByVal value As String)
                _street = value
            End Set
        End Property
        Property Street2() As String
            Get
                Return _street2
            End Get
            Set(ByVal value As String)
                _street2 = value
            End Set
        End Property
        Property City() As String
            Get
                Return _city
            End Get
            Set(ByVal value As String)
                _city = value
            End Set
        End Property
        Property StateID() As Integer
            Get
                Return _stateid
            End Get
            Set(ByVal value As Integer)
                _stateid = value
            End Set
        End Property
        Property ZipCode() As String
            Get
                Return _zipcode
            End Get
            Set(ByVal value As String)
                _zipcode = value
            End Set
        End Property
        Property PhoneNumber() As String
            Get
                Return _phonenumber
            End Get
            Set(ByVal value As String)
                _phonenumber = value
            End Set
        End Property
        Property FaxNumber() As String
            Get
                Return _faxnumber
            End Get
            Set(ByVal value As String)
                _faxnumber = value
            End Set
        End Property
        Property ForStreet() As String
            Get
                Return _forstreet
            End Get
            Set(ByVal value As String)
                _forstreet = value
            End Set
        End Property
        Property ForStreet2() As String
            Get
                Return _forstreet2
            End Get
            Set(ByVal value As String)
                _forstreet2 = value
            End Set
        End Property
        Property ForCity() As String
            Get
                Return _forcity
            End Get
            Set(ByVal value As String)
                _forcity = value
            End Set
        End Property
        Property ForStateID() As Integer
            Get
                Return _forstateid
            End Get
            Set(ByVal value As Integer)
                _forstateid = value
            End Set
        End Property
        Property ForZipCode() As String
            Get
                Return _forzipcode
            End Get
            Set(ByVal value As String)
                _forzipcode = value
            End Set
        End Property
        Property CreditorID() As Integer
            Get
                Return _creditorid
            End Get
            Set(ByVal value As Integer)
                _creditorid = value
            End Set
        End Property
        Property ForCreditorID() As Integer
            Get
                Return _forcreditorid
            End Get
            Set(ByVal value As Integer)
                _forcreditorid = value
            End Set
        End Property
        Property CreditorGroupID() As Integer
            Get
                Return _creditorgroupid
            End Get
            Set(ByVal value As Integer)
                _creditorgroupid = value
            End Set
        End Property
        Property ForCreditorGroupID() As Integer
            Get
                Return _forcreditorgroupid
            End Get
            Set(ByVal value As Integer)
                _forcreditorgroupid = value
            End Set
        End Property

#End Region

#Region "Constructor"

        Public Sub New()

        End Sub
        Public Sub New(ByVal CreditorName As String, ByVal ForCreditorName As String, ByVal Amount As Double, _
            ByVal AccountNumber As String, ByVal ReferenceNumber As String, ByVal Street As String, ByVal Street2 As String, _
            ByVal City As String, ByVal StateID As Integer, ByVal ZipCode As String, ByVal PhoneNumber As String, ByVal FaxNumber As String, _
            ByVal ForStreet As String, ByVal ForStreet2 As String, ByVal ForCity As String, ByVal ForStateID As String, ByVal ForZipCode As String, _
            ByVal CreditorID As Integer, ByVal ForCreditorID As Integer, ByVal CreditorGroupID As Integer, ByVal ForCreditorGroupID As Integer)

            _creditorname = CreditorName
            _forcreditorname = ForCreditorName
            _amount = Amount
            _accountnumber = AccountNumber
            _referencenumber = ReferenceNumber
            _street = Street
            _street2 = Street2
            _city = City
            _stateid = StateID
            _zipcode = ZipCode
            _phonenumber = PhoneNumber
            _faxnumber = FaxNumber
            _forstreet = ForStreet
            _forstreet2 = ForStreet2
            _forcity = ForCity
            _forstateid = ForStateID
            _forzipcode = ForZipCode
            _creditorid = CreditorID
            _forcreditorid = ForCreditorID
            _creditorgroupid = CreditorGroupID
            _forcreditorgroupid = ForCreditorGroupID

        End Sub

#End Region

    End Class

End Namespace