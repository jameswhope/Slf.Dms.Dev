Public Enum DeliveryMethodType
    unknown = 0
    mail = 1
    fax = 2
    email = 3
    other = 99
End Enum

Public Enum BehindReasonType
    unknown = 0
    current = 1
    late1to3months = 2
    late3to6months = 3
    latemorethan6months = 4
    other = 99
End Enum

Public Enum ConcernReasonType
    unknown = 0
    creditorcalls = 1
    unabletokeepup = 2
    payments = 3
    minimumonly = 4
End Enum

Public Class EnrollmentInfo
   Private _id As Integer = 0
   Private _phone As PhoneInfo
   Private _address As AddressInfo
   Private _deliverymethod As DeliveryMethodType = DeliveryMethodType.unknown
   Private _qualyfied As Boolean = True
   Private _committed As Boolean = True
   Private _behindreson As BehindReasonType = BehindReasonType.unknown
   Private _concern As ConcernReasonType = ConcernReasonType.unknown
   Private _totaldebt As Decimal = 0
   Private _clientName As String = String.Empty
   Private _assignedTo As RepresentativeInfo
   Private _depositCommitment As Decimal = 0
   Private _agency As AgencyInfo
   Private _lawfirm As LawFirmInfo

   Public Property Id() As Integer
      Get
         Return _id
      End Get
      Set(ByVal value As Integer)
         _id = value
      End Set
   End Property

   Public Property ClientName() As String
      Get
         Return _clientName
      End Get
      Set(ByVal value As String)
         _clientName = value
      End Set
   End Property

   Public Property Phone() As PhoneInfo
      Get
         Return _phone
      End Get
      Set(ByVal value As PhoneInfo)
         _phone = value
      End Set
   End Property

   Public Property Address() As AddressInfo
      Get
         Return _address
      End Get
      Set(ByVal value As AddressInfo)
         _address = value
      End Set
   End Property

   Public Property DeliveryMethod() As DeliveryMethodType
      Get
         Return _deliverymethod
      End Get
      Set(ByVal value As DeliveryMethodType)
         _deliverymethod = value
      End Set
   End Property

   Public Property Qualified() As Boolean
      Get
         Return _qualyfied
      End Get
      Set(ByVal value As Boolean)
         _qualyfied = value
      End Set
   End Property

   Public Property Committed() As Boolean
      Get
         Return _committed
      End Get
      Set(ByVal value As Boolean)
         _committed = value
      End Set
   End Property

   Public Property BehindReason() As BehindReasonType
      Get
         Return _behindreson
      End Get
      Set(ByVal value As BehindReasonType)
         _behindreson = value
      End Set
   End Property

   Public Property Concern() As ConcernReasonType
      Get
         Return _concern
      End Get
      Set(ByVal value As ConcernReasonType)
         _concern = value
      End Set
   End Property

   Public Property TotalDebt() As Decimal
      Get
         Return _totaldebt
      End Get
      Set(ByVal value As Decimal)
         _totaldebt = value
      End Set
   End Property

   Public Property AssignedTo() As RepresentativeInfo
      Get
         Return _assignedTo
      End Get
      Set(ByVal value As RepresentativeInfo)
         _assignedTo = value
      End Set
   End Property

   Public Property DepositCommitment() As Decimal
      Get
         Return _depositCommitment
      End Get
      Set(ByVal value As Decimal)
         _depositCommitment = value
      End Set
   End Property

   Public Property Agency() As AgencyInfo
      Get
         Return _agency
      End Get
      Set(ByVal value As AgencyInfo)
         _agency = value
      End Set
   End Property

   Public Property LawFirm() As LawFirmInfo
      Get
         Return _lawfirm
      End Get
      Set(ByVal value As LawFirmInfo)
         _lawfirm = value
      End Set
   End Property

   Public Shared Function GetDeliveryMethodName(ByVal EnrollmentDeliveryMethod As DeliveryMethodType) As String
      Select Case EnrollmentDeliveryMethod
         Case DeliveryMethodType.email
            Return "EMAIL"
         Case DeliveryMethodType.fax
            Return "FAX"
         Case DeliveryMethodType.mail
            Return "MAIL"
         Case DeliveryMethodType.other
            Return "OTHER"
         Case Else
            Return "UNKNOWN"
      End Select
   End Function

End Class
