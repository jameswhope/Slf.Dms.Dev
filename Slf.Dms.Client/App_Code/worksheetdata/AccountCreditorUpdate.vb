Option Explicit On

Namespace WorksheetData

    Public Class AccountCreditorUpdate

#Region "Variables"

        Private _accountid As Integer
        Private _name As String
        Private _street As String
        Private _street2 As String
        Private _city As String
        Private _stateid As Integer
        Private _zipcode As String
        Private _forname As String
        Private _forstreet As String
        Private _forstreet2 As String
        Private _forcity As String
        Private _forstateid As Integer
        Private _forzipcode As String
        Private _creditorid As Integer
        Private _creditorgroupid As Integer
        Private _forcreditorid As Integer
        Private _forcreditorgroupid As Integer

#End Region

#Region "Properties"

        ReadOnly Property AccountID() As Integer
            Get
                Return _accountid
            End Get
        End Property
        Property Name() As String
            Get
                Return _name
            End Get
            Set(ByVal value As String)
                _name = value
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
        Property ForName() As String
            Get
                Return _forname
            End Get
            Set(ByVal value As String)
                _forname = value
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
        Property CreditorGroupID() As Integer
            Get
                Return _creditorgroupid
            End Get
            Set(ByVal value As Integer)
                _creditorgroupid = value
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

        Public Sub New(ByVal AccountID As Integer)
            _accountid = AccountID
        End Sub
        Public Sub New(ByVal AccountID As Integer, ByVal Name As String, ByVal Street As String, _
            ByVal Street2 As String, ByVal City As String, ByVal StateID As Integer, ByVal ZipCode As String, _
            ByVal ForName As String, ByVal ForStreet As String, ByVal ForStreet2 As String, ByVal ForCity As String, ByVal ForStateID As Integer, ByVal ForZipCode As String, _
            ByVal CreditorID As Integer, ByVal CreditorGroupID As Integer, ByVal ForCreditorID As Integer, ByVal ForCreditorGroupID As Integer)

            _accountid = AccountID
            _name = Name
            _street = Street
            _street2 = Street2
            _city = City
            _stateid = StateID
            _zipcode = ZipCode
            _forname = ForName
            _forstreet = ForStreet
            _forstreet2 = ForStreet2
            _forcity = ForCity
            _forstateid = ForStateID
            _forzipcode = ForZipCode
            _creditorgroupid = CreditorGroupID
            _creditorid = CreditorID
            _forcreditorgroupid = ForCreditorGroupID
            _forcreditorid = ForCreditorID

        End Sub

#End Region

    End Class

End Namespace