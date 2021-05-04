Imports Microsoft.VisualBasic

Public Class CreditorCollections
#Region "Fields"
    'Collections
    Protected _memberCode As String
    Protected _collection_agency_name As String
    Protected _AccountType As String
    Protected _AccountNumber As String
    Protected _AccountDesignator As String
    Protected _CreditorName As String
    Protected _DateOpened As String
    Protected _DateVerified As String
    Protected _verification_indicator As String
    Protected _DateClosed As String
    Protected _DateClosedIndicator As String
    Protected _DatePaidOut As String
    Protected _CurrentMannerOfPayment As String
    Protected _CurrentBalance As String
    Protected _OriginalBalance As String
    Protected _remarks_code As String

#End Region 'Fields

#Region "Properties"
    Public Property MemberCode() As String
        Get
            Return _memberCode
        End Get
        Set(value As String)
            _memberCode = value
        End Set
    End Property
    Public Property CreditorName() As String
        Get
            Return _CreditorName
        End Get
        Set(value As String)
            _CreditorName = value
        End Set
    End Property
    Public Property AccountType() As String
        Get
            Return _AccountType
        End Get
        Set(value As String)
            _AccountType = value
        End Set
    End Property
    Public Property AccountNumber() As String
        Get
            Return _AccountNumber
        End Get
        Set(value As String)
            _AccountNumber = value
        End Set
    End Property
    Public Property AccountDesignator() As String
        Get
            Return _AccountDesignator
        End Get
        Set(value As String)
            _AccountDesignator = value
        End Set
    End Property
    Public Property DateOpened() As String
        Get
            Return _DateOpened
        End Get
        Set(value As String)
            _DateOpened = value
        End Set
    End Property
    Public Property DateVerified() As String
        Get
            Return _DateVerified
        End Get
        Set(value As String)
            _DateVerified = value
        End Set
    End Property
    Public Property VerificationIndicator() As String
        Get
            Return _verification_indicator
        End Get
        Set(value As String)
            _verification_indicator = value
        End Set
    End Property
    Public Property DateClosed() As String
        Get
            Return _DateClosed
        End Get
        Set(value As String)
            _DateClosed = value
        End Set
    End Property
    Public Property DateClosedIndicator() As String
        Get
            Return _DateClosedIndicator
        End Get
        Set(value As String)
            _DateClosedIndicator = value
        End Set
    End Property
    Public Property DatePaidOut() As String
        Get
            Return _DatePaidOut
        End Get
        Set(value As String)
            _DatePaidOut = value
        End Set
    End Property
    Public Property CurrentMannerOfPayment() As String
        Get
            Return _CurrentMannerOfPayment
        End Get
        Set(value As String)
            _CurrentMannerOfPayment = value
        End Set
    End Property
    Public Property CurrentBalance() As String
        Get
            Return _CurrentBalance
        End Get
        Set(value As String)
            _CurrentBalance = value
        End Set
    End Property
    Public Property OriginalBalance() As String
        Get
            Return _OriginalBalance
        End Get
        Set(value As String)
            _OriginalBalance = value
        End Set
    End Property
    Public Property CollectionAgencyName() As String
        Get
            Return _collection_agency_name
        End Get
        Set(value As String)
            _collection_agency_name = value
        End Set
    End Property
    Public Property RemarksCode() As String
        Get
            Return _remarks_code
        End Get
        Set(value As String)
            _remarks_code = value
        End Set
    End Property

#End Region 'Properties

#Region "Constructors"

    Public Sub New()

    End Sub

#End Region 'Constructors

End Class
