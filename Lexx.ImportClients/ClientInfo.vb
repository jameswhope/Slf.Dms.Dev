Public Enum ClientImportStatus
    noaction = 0
    succeded = 1
    failed = 2
End Enum

Public Class AgencyExtensionData
    Private _leadNumber As Integer
    Private _dateSent As DateTime
    Private _dateReceived As DateTime
    Private _seidemanPullDate As DateTime
    Private _debtTotal As Decimal
    Private _missingInfo As String = String.Empty

    Public Property LeadNumber() As Integer
        Get
            Return _leadNumber
        End Get
        Set(ByVal value As Integer)
            _leadNumber = value
        End Set
    End Property

    Public Property DateSent() As DateTime
        Get
            Return _dateSent
        End Get
        Set(ByVal value As DateTime)
            _dateSent = value
        End Set
    End Property

    Public Property DateReceived() As DateTime
        Get
            Return _dateReceived
        End Get
        Set(ByVal value As DateTime)
            _dateReceived = value
        End Set
    End Property

    Public Property SeidemanPullDate() As DateTime
        Get
            Return _seidemanPullDate
        End Get
        Set(ByVal value As DateTime)
            _seidemanPullDate = value
        End Set
    End Property

    Public Property DebtTotal() As Decimal
        Get
            Return _debtTotal
        End Get
        Set(ByVal value As Decimal)
            _debtTotal = value
        End Set
    End Property

    Public Property MissingInfo() As String
        Get
            Return _missingInfo
        End Get
        Set(ByVal value As String)
            _missingInfo = value
        End Set
    End Property

End Class

Public Class ClientInfo
    Private _enrollment As EnrollmentInfo
    Private _primary As PersonInfo
    Private _coApplicants As List(Of PersonInfo)
    Private _bankAccounts As List(Of BankAccountInfo)
    Private _primaryBank As BankAccountInfo
    Private _exception As ExceptionInfo
    Private _accounts As List(Of AccountInfo)
    Private _trust As TrustInfo
    Private _agency As AgencyInfo
    Private _lawfirm As LawFirmInfo
    Private _setupdata As SetupInfo
    Private _status As ClientImportStatus = ClientImportStatus.noaction
    Private _agentName As String = String.Empty
    Private _id As Integer = 0
    Private _agencyextrafields As AgencyExtensionData
    Private _sourceId As Integer
    Private _jobId As Integer
    Private _ExternalClientId As String = String.Empty
    Private _notes As List(Of NoteInfo)
    Private _accountNumber As String = String.Empty
    Private _useCheckSite As Boolean = False
    Private _multideposit As Boolean = False
    Private _RemittanceName As String = String.Empty
    Private _IsBofA As Boolean = False
    Private _CommScenId As Integer = 147
    Private _ProcessingPattern As String = String.Empty

    Public Sub New(ByVal ExtId As String)
        Me.ExternalID = ExtId
    End Sub

    Public Property Id() As Integer
        Get
            Return _id
        End Get
        Set(ByVal value As Integer)
            _id = value
        End Set
    End Property

   Public Property MultiDeposit() As Boolean
      Get
         Return _multideposit
      End Get
      Set(ByVal value As Boolean)
         _multideposit = value
      End Set
   End Property

   Public Property Enrollment() As EnrollmentInfo
      Get
         Return _enrollment
      End Get
      Set(ByVal value As EnrollmentInfo)
         _enrollment = value
      End Set
   End Property

    Public Property PrimaryApplicant() As PersonInfo
        Get
            Return _primary
        End Get
        Set(ByVal value As PersonInfo)
            _primary = value
        End Set
    End Property

    Public Property CoApplicants() As List(Of PersonInfo)
        Get
            Return _coApplicants
        End Get
        Set(ByVal value As List(Of PersonInfo))
            _coApplicants = value
        End Set
    End Property

    Public Property BankAccounts() As List(Of BankAccountInfo)
        Get
            Return _bankAccounts
        End Get
        Set(ByVal value As List(Of BankAccountInfo))
            _bankAccounts = value
        End Set
    End Property

    Public Property PrimaryBank() As BankAccountInfo
        Get
            Return _primaryBank
        End Get
        Set(ByVal value As BankAccountInfo)
            If _bankAccounts Is Nothing OrElse Not _bankAccounts.Contains(value) Then Throw New Exception("Can not set primary bank account. Could not find specific bank account in list.")
            _primaryBank = value
        End Set
    End Property

    Public ReadOnly Property AccountNumber() As String
        Get
            Return _accountNumber
        End Get
    End Property

    Friend Sub SetAccountNumber(ByVal AccNumber As String)
        _accountNumber = AccNumber
    End Sub

    Public Property ClientImportException() As ExceptionInfo
        Get
            Return _exception
        End Get
        Set(ByVal value As ExceptionInfo)
            _exception = value
        End Set
    End Property

    Public Property ClientImportStatus() As ClientImportStatus
        Get
            Return _status
        End Get
        Set(ByVal value As ClientImportStatus)
            _status = value
        End Set
    End Property

    Public Property Accounts() As List(Of AccountInfo)
        Get
            Return _accounts
        End Get
        Set(ByVal value As List(Of AccountInfo))
            _accounts = value
        End Set
    End Property

    Public Property Notes() As List(Of NoteInfo)
        Get
            Return _notes
        End Get
        Set(ByVal value As List(Of NoteInfo))
            _notes = value
        End Set
    End Property

    Public Property Trust() As TrustInfo
        Get
            Return _trust
        End Get
        Set(ByVal value As TrustInfo)
            _trust = value
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

    Public Property SetupData() As SetupInfo
        Get
            Return _setupdata
        End Get
        Set(ByVal value As SetupInfo)
            _setupdata = value
        End Set
    End Property

    Public Property AgentName() As String
        Get
            Return _agentName
        End Get
        Set(ByVal value As String)
            _agentName = value
        End Set
    End Property

    Public ReadOnly Property NeedsShadowStored() As Boolean
        Get
            'If Not IsBofA Then
            Return (Trust.ID = 22)
            'Else
            'Return (Trust.ID = 24)
            'End If
        End Get
    End Property

    Public Property IsBofA() As Boolean
        Get
            Return _IsBofA
        End Get
        Set(ByVal value As Boolean)
            _IsBofA = value
        End Set
    End Property

    Public Property AgencyExtraFields() As AgencyExtensionData
        Get
            Return _agencyextrafields
        End Get
        Set(ByVal value As AgencyExtensionData)
            _agencyextrafields = value
        End Set
    End Property

    Friend Property SourceId() As Integer
        Get
            Return _sourceId
        End Get
        Set(ByVal value As Integer)
            _sourceId = value
        End Set
    End Property

    Public Property JobId() As Integer
        Get
            Return _jobId
        End Get
        Set(ByVal value As Integer)
            _jobId = value
        End Set
    End Property

    Public Property ExternalID() As String
        Get
            Return _ExternalClientId.Trim
        End Get
        Set(ByVal value As String)
            _ExternalClientId = value
        End Set
    End Property

    Friend ReadOnly Property UseCheckSiteWS() As Boolean
        Get
            Return _useCheckSite
        End Get
    End Property

    Public ReadOnly Property DebtSum() As Decimal
        Get
            Dim debt As Decimal = 0
            For Each acc As AccountInfo In Me.Accounts
                debt += acc.Balance
            Next
            Return debt
        End Get
    End Property

    Public Property RemittanceName() As String
        Get
            Return _RemittanceName
        End Get
        Set(ByVal value As String)
            _RemittanceName = value
        End Set
    End Property

    Private Function IsValidForImport() As Boolean
        'Validate that all required info is provided
        If Me.JobId = 0 Then Throw New Exception("There is no import job for this client")
        If Me.SourceId = 0 Then Throw New Exception("There is no source for this client or source is unknown")
        If Me.ExternalID.Trim.Length = 0 Then Throw New Exception("There no external id provided")
        Dim dh As New DataHelper
        If dh.ClientAlreadyImported(Me.SourceId, Me.ExternalID.Trim) Then Throw New Exception("This client was imported before")
        Return True
    End Function

    Public Shared Function GetTrust(ByVal client As ClientInfo, ByVal catalog As CatalogInfo) As TrustInfo
        Dim trust As TrustInfo
        Dim dh As New DataHelper
        If client.LawFirm Is Nothing Then
            Throw New Exception("Cannot assign a trustid for this client because the Settlement Attorney information is not supplied.")
        ElseIf catalog.Lawfirms.FindById(client.LawFirm.Id) Is Nothing Then
            Throw New Exception("Cannot assign a trustid for this client because the Settlement Attorney information supplied is invalid")
        Else
            'Get trust id from tables.
            Dim trustid As Integer = dh.GetTrustIDByCompanyID(client)
            If trustid <= 0 Then trustid = dh.GetTrustIDByApplicantID(client.Id)
            trust = catalog.Trusts.FindById(trustid)
        End If
        Return trust
    End Function

    Private Sub ActivateCSIUse()
        Dim useCsi As String = System.Configuration.ConfigurationManager.AppSettings("ImportServiceUseCSI")
        If Not UseCsi Is Nothing AndAlso UseCsi.ToString.Trim.ToLower = "true" Then
            _useCheckSite = True
        End If
    End Sub

    Friend Function Import(ByVal catalog As CatalogInfo, ByVal UserId As Integer) As Boolean
        'Import 
        ActivateCSIUse()
        Dim dh As New DataHelper
        Dim trans As SqlClient.SqlTransaction = dh.CreateTransaction()
        Try
            IsValidForImport()
            'Import Enrollment
            If Me.Enrollment Is Nothing Then Throw New Exception("Cannot import enrollment information because it was not supplied.")
            Dim enrollentId As Integer = dh.InsertEnrollment(trans, Me.Enrollment, catalog, UserId)
            Me.Enrollment.Id = enrollentId
            'Import Client
            'Prepare trust
            If Me.Trust Is Nothing Then Me.Trust = ClientInfo.GetTrust(Me, catalog)
            'Prepare mandatory SetupData
            If Me.SetupData Is Nothing Then Me.SetupData = New SetupInfo()
            'Validate or define rule for retainer fee percent
            'If Me.SetupData.SetupFeePercent = 0 Then Me.SetupData.SetupFeePercent = catalog.DefaultValues.SetupFeePercentage
            If Me.SetupData.SetupFeePercent = 10 Then Me.SetupData.InitialAgencyPercent = 2
            If Me.SetupData.SettlementFeePercent = 0 Then Me.SetupData.SettlementFeePercent = catalog.DefaultValues.SettlementFeePercentage
            Me.Id = dh.InsertClient(trans, Me, catalog, UserId)
            If Me.Id = 0 Then Throw New Exception("Client was not created.")
            dh.AssignClientToEnrollment(trans, Me.Enrollment.Id, Me.Id)
            'Import Primary Applicant. Enforce some constraints
            If Me.PrimaryApplicant Is Nothing Then Throw New Exception("Cannot import primary applicant information because it was not supplied.")
            Me.PrimaryApplicant.ClientId = Me.Id
            Me.PrimaryApplicant.RelationshipWithPrincipalApplicant = PersonalRelationType.self
            Me.PrimaryApplicant.IsThirdParty = False
            Me.PrimaryApplicant.CanAuthorize = True
            Me.PrimaryApplicant.ID = dh.InsertPerson(trans, Me.PrimaryApplicant, catalog, UserId)
            'Update Client Primary
            dh.AssignPrimaryPersonToClient(trans, Me.Id, Me.PrimaryApplicant.ID)
            'Enter phone numbers
            If Not Me.PrimaryApplicant.Phones Is Nothing Then
                For Each phone As PhoneInfo In Me.PrimaryApplicant.Phones
                    dh.InsertPhone(trans, phone, Me.PrimaryApplicant.ID, UserId)
                Next
            End If
            'Import Co-Applicants
            If Not Me.CoApplicants Is Nothing Then
                For Each coapp As PersonInfo In Me.CoApplicants
                    If coapp.RelationshipWithPrincipalApplicant = PersonalRelationType.self Then _
                        coapp.RelationshipWithPrincipalApplicant = PersonalRelationType.other
                    coapp.ClientId = Me.Id
                    coapp.ID = dh.InsertPerson(trans, coapp, catalog, UserId)

                    'Enter phone numbers
                    If Not coapp.Phones Is Nothing Then
                        For Each phone As PhoneInfo In coapp.Phones
                            dh.InsertPhone(trans, phone, coapp.ID, UserId)
                        Next
                    End If
                Next
            End If

            'Add Multideposit information
            If Me.MultiDeposit Then
                'Add banking info is any
                If Not Me.BankAccounts Is Nothing Then
                    Dim banks As New Dictionary(Of String, Integer)
                    Dim bankKey As String = String.Empty
                    Dim bankid As Integer = 0
                    For Each bank In Me.BankAccounts
                        bankKey = bank.RoutingNumber.Trim & bank.AccountNumber.Trim
                        If Not banks.ContainsKey(bankKey) Then
                            bankid = dh.InsertBankAccount(trans, bank, Me.Id, UserId, Me.UseCheckSiteWS)
                            banks.Add(bankKey, bankid)
                        Else
                            bankid = banks(bankKey)
                        End If
                        bank.Id = bankid
                    Next
                End If
                'Add Deposit days
                If Me.SetupData.DepositDays Is Nothing Then Throw New Exception("Deposit day info is required for a Multideposit client")
                For Each depday In Me.SetupData.DepositDays
                    depday.Id = dh.InsertMultiDepositDay(trans, depday, Me.Id, UserId)
                Next
            End If

            'Insert Agency Extra Fields
            If Not Me.AgencyExtraFields Is Nothing Then
                dh.InsertAgencyExtraFields(trans, Me.Id, Me.AgencyExtraFields, UserId)
            End If
            dh.ExecuteLoadClientSearch(trans, Me.Id)
            dh.CreateClientRoadMap(trans, Me.Id, UserId)

            'Create Accounts and creditor Instances. Retainer Fees
            If Not Me.Accounts Is Nothing Then

                'Verify the creditors against the DB and reset to zero the id's of those which dont exist  
                For Each acc As AccountInfo In Me.Accounts
                    If acc.Creditor Is Nothing Then Throw New Exception("Account does not have a creditor")
                    acc.Creditor.Id = CreditorInfo.GetDBMatchId(acc.Creditor)
                    'Create Group if necessary
                    If acc.Creditor.GroupId <= 0 Then acc.Creditor.GroupId = dh.InsertCreditorGroup(trans, acc.Creditor.Name, UserId)
                Next

                'Add Creditors and Accounts
                Dim creditorscache As New CreditorList
                Dim match As CreditorInfo
                For Each acc As AccountInfo In Me.Accounts
                    'If could not find a matching creditor then create one
                    If acc.Creditor.Id <= 0 Then
                        'try to find a matching record in the cache first
                        match = creditorscache.FindFirstMatch(acc.Creditor, True)
                        If Not match Is Nothing Then
                            acc.Creditor.Id = match.Id
                        Else
                            'Create creditor  and insert phones
                            acc.Creditor.Id = dh.InsertCreditor(trans, acc.Creditor, catalog, UserId, False)
                            'Update list
                            creditorscache.Add(acc.Creditor)
                        End If
                    End If
                    'insert creditor's phone if it doesnt exist
                    If Not acc.Creditor.Phone Is Nothing Then dh.InsertCreditorPhone(trans, acc.Creditor.Phone, acc.Creditor.Id, UserId)

                    'create account
                    acc.Id = dh.InsertAccount(trans, Me.Id, acc, Me.SetupData.SetupFeePercent, UserId)
                Next

            End If
            'if initial draft info and method is ach, insert adhoc ach
            If Me.SetupData.DepositMethod = DepositMethodType.ach Then
                If Me.SetupData.FirstDepositAmount > 0 Then
                    dh.CreateAdHocACH(trans, Me, UserId)
                End If
            End If
            'Add Notes
            If Not Me.Notes Is Nothing Then
                For Each note In Me.Notes
                    note.ID = dh.InsertNote(trans, note, Me.Id, UserId)
                Next
            End If
            'Add Import record
            Dim importid = dh.InsertImportedClient(trans, Me.JobId, Me.SourceId, Me.ExternalID)
            dh.UpdateClientImportId(trans, Me.Id, importid)
            'Create Shadow Store if Needed
            If Me.NeedsShadowStored() Then CreateShadowStore(trans, UserId)
            trans.Commit()
            Me.ClientImportStatus = ImportClients.ClientImportStatus.succeded
            Return True
        Catch ex As Exception
            trans.Rollback()
            Me.ClientImportException = New ExceptionInfo(ex.Message)
            Me.ClientImportStatus = ImportClients.ClientImportStatus.failed
        Finally
            If Not trans.Connection Is Nothing AndAlso trans.Connection.State <> ConnectionState.Closed Then trans.Connection.Close()
        End Try
        Return False
    End Function

    Private Sub CreateShadowStore(ByVal trans As System.Data.SqlClient.SqlTransaction, ByVal UserId As Integer)

        If Trust.ID = 24 Then
            IsBofA = True
            Return '24 is BofA - Woolery EMS is created in nightly process
        End If

        If Not UseCheckSiteWS Then Return
        Dim store As New WCFClient.Store
        Dim dh As New DataHelper
        'Dim account As String = dh.GetAccountNumber(trans, Me.Id)
        Dim account As String = Me.AccountNumber.Trim
        If account.Length = 0 Then Throw New Exception("Cannot create shadow store because there is no account number for this client.")
        If Not store.StoreExists(New String() {account}) Then
            If Not store.OpenAccount(Me.Id, UserId) Then
                Throw New Exception("Cannot create shadow store because there was a third party service error.")
            End If
        End If
    End Sub

    Private Function CreateRetainerFees() As Integer
        'Create a retainer fee per account
        If Me.SetupData.SetupFeePercent > 0 Then
            'Pending
        End If
        Return 0
   End Function

End Class
