Imports System.Data.SqlClient

Friend Class DataHelper
    Friend ReadOnly Property ConnStr() As String
        Get
            Return System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString
        End Get
    End Property

    Friend Function CreateTransaction() As SqlTransaction
        Dim conn As SqlConnection = New SqlConnection(Me.ConnStr)
        conn.Open()
        Return conn.BeginTransaction(System.Data.IsolationLevel.Serializable)
    End Function

    Friend Function GetUsStates() As DataTable
        Dim ds As New DataSet
        ds = SqlHelper.ExecuteDataset(Me.ConnStr, CommandType.Text, "select StateId, Abbreviation, Name from tblState order by Name")
        Return ds.Tables(0)
    End Function

    Friend Function GetAgencies() As DataTable
        Dim ds As New DataSet
        ds = SqlHelper.ExecuteDataset(Me.ConnStr, CommandType.Text, "select AgencyId, Code, Name from tblAgency order by Name")
        Return ds.Tables(0)
    End Function

    Friend Function GetCompanies() As DataTable
        Dim ds As New DataSet
        ds = SqlHelper.ExecuteDataset(Me.ConnStr, CommandType.Text, "select CompanyId, Name from tblCompany order by Name")
        Return ds.Tables(0)
    End Function

    Friend Function GetDefaultFees() As DataTable
        Dim ds As New DataSet
        Dim sb As New System.Text.StringBuilder
        sb.Append("select ")
        sb.Append("(select Value from tblProperty Where Name = 'EnrollmentReturnedCheckFee') [ReturnedCheckFee],")
        sb.Append("(select Value from tblProperty Where Name = 'EnrollmentOvernightFee') [OvernightFee],")
        sb.Append("(select Value from tblProperty Where Name = 'EnrollmentAddAccountFee') [AdditionalAccountFee],")
        sb.Append("(select Value from tblProperty Where Name = 'EnrollmentAddAccountFee2') [AdditionalAccountFee2],")
        sb.Append("(select Value from tblProperty Where Name = 'EnrollmentMonthlyFeeDay') [MonthlyFeeDay],")
        sb.Append("(select Value from tblProperty Where Name = 'EnrollmentRetainerPercentage') [RetainerPercentage],")
        sb.Append("(select top 1 Value from tblProperty Where Name = 'EnrollmentSettlementPercentage') [SettlementPercentage]")
        ds = SqlHelper.ExecuteDataset(Me.ConnStr, CommandType.Text, sb.ToString)
        Return ds.Tables(0)
    End Function

    Friend Function GetTrusts() As DataTable
        Dim ds As New DataSet
        ds = SqlHelper.ExecuteDataset(Me.ConnStr, CommandType.Text, "select TrustId, DisplayName as [Name] from tblTrust Where TrustId in (20,22,24,26,38) order by Name")
        Return ds.Tables(0)
    End Function

    Friend Function ClientAlreadyImported(ByVal SourceId As Integer, ByVal ExternalClientId As String) As Boolean
        Dim ds As New DataSet
        ds = SqlHelper.ExecuteDataset(Me.ConnStr, CommandType.Text, String.Format("select ExternalCLientId from tblImportedClient Where SourceId = {0} and ExternalCLientId = '{1}'", SourceId, ExternalClientId))
        Return (ds.Tables(0).Rows.Count <> 0)
    End Function

    Friend Function GetNextAccountNumber() As String
        Return SqlHelper.ExecuteScalar(Me.ConnStr, CommandType.StoredProcedure, "stp_GetAccountNumber").ToString
    End Function

    Friend Function GetAccountNumber(ByVal trans As SqlTransaction, ByVal clientId As Integer) As String
        Return SqlHelper.ExecuteScalar(trans, CommandType.Text, String.Format("select AccountNumber from tblClient Where ClientId = {0}", clientId))
    End Function

    Friend Function GetTrustIDByCompanyID(ByVal client As ClientInfo) As Integer
        Return SqlHelper.ExecuteScalar(Me.ConnStr, CommandType.Text = String.Format("SELECT TrustID FROM tblTrust WHERE EffectiveStartDate <= GETDATE()  AND CompanyIDs LIKE '%{0}%' AND (EffectiveEndDate IS NULL OR EffectiveEndDate > GETDATE())", client.LawFirm.Id))
    End Function

    Friend Function GetTrustIDByApplicantID(ByVal ApplicantID As Integer) As Integer
        Return SqlHelper.ExecuteScalar(Me.ConnStr, CommandType.Text = String.Format("SELECT LSATrustID FROM tblLeadApplicant WHERE LeadApplicantID = '{0}'", ApplicantID.ToString))
    End Function

    Friend Function InsertClient(ByVal trans As SqlTransaction, ByRef client As ClientInfo, ByVal catalog As CatalogInfo, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter
        'Enrollement
        If client.Enrollment Is Nothing Then Throw New Exception("Enrollment info is required for this client")
        If client.Enrollment.Id = 0 Then Throw New Exception("Enrollement has not been created for this client")
        param = New SqlParameter("@EnrollmentId", SqlDbType.Int)
        param.Value = client.Enrollment.Id
        params.Add(param)
        'Agency
        If client.Agency Is Nothing OrElse catalog.Agencies.FindById(client.Agency.Id) Is Nothing Then Throw New Exception("Agency info is required or is invalid for this client")
        param = New SqlParameter("@AgencyId", SqlDbType.Int)
        param.Value = client.Agency.Id
        params.Add(param)
        'CompanyId 
        If client.LawFirm Is Nothing OrElse catalog.Lawfirms.FindById(client.LawFirm.Id) Is Nothing Then Throw New Exception("Law Firm info is required or is invalid for this client")
        param = New SqlParameter("@CompanyId", SqlDbType.Int)
        param.Value = client.LawFirm.Id
        params.Add(param)
        'TrustId
        If client.Trust Is Nothing OrElse catalog.Trusts.FindById(client.Trust.ID) Is Nothing Then Throw New Exception("Trust info is required or is invalid for this client")
        param = New SqlParameter("@TrustId", SqlDbType.Int)
        'validate this Trustid is good for this attorney
        'If client.Trust.ID <> GetTrustIDByCompanyID(client) Then
        '    param.Value = GetTrustIDByCompanyID(client)
        'Else
        '    param.Value = client.Trust.ID
        'End If
        param.Value = client.Trust.ID
        params.Add(param)
        'Created By, LastModified By
        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)
        'Client Status: 2- started enrollment 
        param = New SqlParameter("@ClientStatusId", SqlDbType.Int)
        param.Value = catalog.DefaultValues.InitialClientStatusId
        params.Add(param)

        'Setup Data
        If client.SetupData.FirstDepositAmount > 0 Then
            param = New SqlParameter("@InitialDraftAmount", SqlDbType.Money)
            param.Value = client.SetupData.FirstDepositAmount
            params.Add(param)
        Else
            If client.SetupData.DepositMethod = DepositMethodType.ach Then
                Throw New Exception("Initial Draft Amount was not supplied for an ACH client.")
            End If
        End If
        If client.SetupData.FirstDepositDate <> New Date() Then
            'If client.SetupData.FirstDepositDate < Now Then Throw New Exception("The first draft deposit date is set to a past date")
            param = New SqlParameter("@InitialDraftDate", SqlDbType.DateTime)
            param.Value = client.SetupData.FirstDepositDate
            params.Add(param)
        Else
            If client.SetupData.DepositMethod = DepositMethodType.ach Then
                Throw New Exception("First Deposit Date was not supplied for an ACH client.")
            End If
        End If
        If client.SetupData.DepositsStartDate <> New Date() Then
            'If client.SetupData.DepositsStartDate < Now Then Throw New Exception("The startt deposit date is set to a past date")
            param = New SqlParameter("@DepositStartDate", SqlDbType.DateTime)
            param.Value = client.SetupData.DepositsStartDate
            params.Add(param)
        Else
            If client.SetupData.DepositMethod = DepositMethodType.ach Then
                Throw New Exception("First Deposit Date was not supplied for an ACH client.")
            End If
        End If
        param = New SqlParameter("@MonthlyFee", SqlDbType.Money)
        param.Value = client.SetupData.MaintenanceFeeAmount
        params.Add(param)
        'Monthly Fee Day = 1
        param = New SqlParameter("@MonthlyFeeDay", SqlDbType.Int)
        param.Value = catalog.DefaultValues.MonthlyFeeDay
        params.Add(param)

        'Subseq Maintemance Fee
        If client.SetupData.SubSeqMaintenanceFeeAmount.HasValue AndAlso client.SetupData.SubSeqMaintenanceFeeAmount.Value > 0 Then
            param = New SqlParameter("@SubsequentMaintFee", SqlDbType.Money)
            param.Value = client.SetupData.SubSeqMaintenanceFeeAmount.Value
            params.Add(param)

            If client.SetupData.SubSeqMaintenanceFeeStartDate <> New Date() Then
                param = New SqlParameter("@SubMaintFeeStart", SqlDbType.DateTime)
                param.Value = client.SetupData.SubSeqMaintenanceFeeStartDate
                params.Add(param)
            End If
        ElseIf client.SetupData.MaintenanceFeeCap.HasValue AndAlso client.SetupData.MaintenanceFeeCap.Value > 0 Then
            'Maint Fee Cap
            param = New SqlParameter("@MaintenanceFeeCap", SqlDbType.Money)
            param.Value = client.SetupData.MaintenanceFeeCap.Value
            params.Add(param)
        End If

        'Additional Accoutn Fee
        param = New SqlParameter("@AdditionalAccountFee", SqlDbType.Money)
        param.Value = client.SetupData.AdditionalAccountFee
        params.Add(param)
        'Returned Check fee
        param = New SqlParameter("@ReturnedCheckFee", SqlDbType.Money)
        param.Value = catalog.DefaultValues.ReturnedCheckFee
        params.Add(param)
        'Overnight Fee
        param = New SqlParameter("@OvernightDeliveryFee", SqlDbType.Money)
        param.Value = catalog.DefaultValues.OvernightFee
        params.Add(param)
        'Settlement Fee Percentage
        param = New SqlParameter("@SettlementFeePercentage", SqlDbType.Money)
        param.Value = client.SetupData.SettlementFeePercent / 100
        params.Add(param)
        'Setup Fee Percent
        param = New SqlParameter("@SetupFeePercentage", SqlDbType.Money)
        param.Value = client.SetupData.SetupFeePercent / 100
        params.Add(param)
        'Setup Fee Percent
        If client.SetupData.InitialAgencyPercent > 0 Then
            param = New SqlParameter("@InitialAgencyPercent", SqlDbType.Money)
            param.Value = client.SetupData.InitialAgencyPercent / 100
            params.Add(param)
        End If
        'Account number
        param = New SqlParameter("@AccountNumber", SqlDbType.VarChar)
        Dim accnumber As String = Me.GetNextAccountNumber()
        If accnumber.Trim.Length = 0 Then Throw New Exception("Could not create account number")
        client.SetAccountNumber(accnumber.Trim)
        param.Value = accnumber.Trim
        params.Add(param)
        'deposit Method
        If client.SetupData.DepositMethod <> DepositMethodType.unknown Then
            param = New SqlParameter("@DepositMethod", SqlDbType.VarChar)
            param.Value = SetupInfo.GetDepositMethodName(client.SetupData.DepositMethod)
            params.Add(param)
        End If
        'Deposit Day and Amount
        If client.SetupData.DepositDays.Count = 0 Then
            Throw New Exception("The deposit day is not provided")
        Else
            param = New SqlParameter("@DepositDay", SqlDbType.Int)
            param.Value = client.SetupData.DepositDays.Item(0).DepositDay
            params.Add(param)
            param = New SqlParameter("@DepositAmount", SqlDbType.Money)
            param.Value = client.SetupData.DepositDays.Item(0).Amount
            params.Add(param)
        End If
        'Banking Info          
        If client.SetupData.DepositMethod = DepositMethodType.ach Then
            If client.PrimaryBank Is Nothing Then Throw New Exception("The ach information is missing for this client")
            If client.PrimaryBank.AccountNumber.Trim.Length = 0 OrElse Not Int64.TryParse(client.PrimaryBank.AccountNumber, Nothing) OrElse Not Int64.Parse(client.PrimaryBank.AccountNumber) > 0 Then
                Throw New Exception("The bank account number is missing or invalid for this ach client")
            Else
                'validate account number
            End If
            If client.PrimaryBank.RoutingNumber.Trim.Length = 0 OrElse Not Int64.TryParse(client.PrimaryBank.RoutingNumber, Nothing) OrElse Not Int64.Parse(client.PrimaryBank.RoutingNumber) > 0 Then
                Throw New Exception("The bank account routing number is missing or invalid for this ach client")
            Else
                'validate routing number
                Dim validatedBankRouting As String = client.PrimaryBank.RoutingNumber.Trim
                Dim validatedBankName As String = client.PrimaryBank.Name.Trim
                If client.UseCheckSiteWS AndAlso Not BankAccountInfo.IsValidRouting(validatedBankRouting, validatedBankName) Then
                    Throw New Exception("The bank account routing number is not valid or it could not be validated against third party service.")
                Else
                    client.PrimaryBank.RoutingNumber = validatedBankRouting
                    client.PrimaryBank.Name = validatedBankName
                End If
            End If
        End If
        If Not client.PrimaryBank Is Nothing Then
            If client.PrimaryBank.AccountNumber.Trim.Length > 0 Then
                param = New SqlParameter("@BankAccountNumber", SqlDbType.VarChar)
                param.Value = client.PrimaryBank.AccountNumber.Trim
                params.Add(param)
            End If

            If client.PrimaryBank.RoutingNumber.Trim.Length <> 9 Then Throw New Exception("The bank routing number must have 9 digits!")

            If client.PrimaryBank.RoutingNumber.Trim.Length > 0 Then
                param = New SqlParameter("@BankRoutingNumber", SqlDbType.VarChar)
                param.Value = client.PrimaryBank.RoutingNumber.Trim
                params.Add(param)
            End If
            If client.PrimaryBank.Type <> BankAccountType.unknown Then
                param = New SqlParameter("@BankType", SqlDbType.VarChar)
                param.Value = BankAccountInfo.GetBankAccountTypeName(client.PrimaryBank.Type).Substring(0, 1)
                params.Add(param)
            End If
            If client.PrimaryBank.Name.Trim.Length > 0 Then
                param = New SqlParameter("@BankName", SqlDbType.VarChar)
                param.Value = client.PrimaryBank.Name.Trim
                params.Add(param)
            End If
            If Not client.PrimaryBank.Address Is Nothing Then
                If client.PrimaryBank.Address.City.Trim.Length > 0 Then
                    param = New SqlParameter("@BankCity", SqlDbType.VarChar)
                    param.Value = client.PrimaryBank.Address.City.Trim
                    params.Add(param)
                End If
                If Not client.PrimaryBank.Address.USState Is Nothing AndAlso Not catalog.States.FindById(client.PrimaryBank.Address.USState.Id) Is Nothing Then
                    param = New SqlParameter("@BankStateId", SqlDbType.Int)
                    param.Value = client.PrimaryBank.Address.USState.Id
                    params.Add(param)
                End If
            End If
        End If

        param = New SqlParameter("@MultiDeposit", SqlDbType.Bit)
        param.Value = IIf(client.MultiDeposit, 1, 0)
        params.Add(param)

        If client.AgentName.Trim.Length > 0 Then
            param = New SqlParameter("@AgentName", SqlDbType.NVarChar)
            param.Value = client.AgentName
            params.Add(param)
        End If

        If client.RemittanceName.Trim.Length > 0 Then
            param = New SqlParameter("@RemittName", SqlDbType.NVarChar)
            param.Value = client.RemittanceName
            params.Add(param)
        End If

        Dim clientid As Integer = SqlHelper.ExecuteScalar(trans, CommandType.StoredProcedure, "stp_ImportClientInsert", params.ToArray)
        Return clientid
    End Function

    Friend Sub AssignPrimaryPersonToClient(ByVal trans As SqlTransaction, ByVal clientid As Integer, ByVal personid As Integer)
        SqlHelper.ExecuteNonQuery(trans, CommandType.Text, String.Format("Update tblClient Set PrimaryPersonId = {0} Where ClientId = {1}", personid, clientid))
    End Sub

    Friend Sub AssignClientToEnrollment(ByVal trans As SqlTransaction, ByVal enrollmentid As Integer, ByVal clientid As Integer)
        SqlHelper.ExecuteNonQuery(trans, CommandType.Text, String.Format("Update tblEnrollment Set ClientId = {0} Where EnrollmentId = {1}", clientid, enrollmentid))
    End Sub

    Friend Function InsertPerson(ByVal trans As SqlTransaction, ByVal person As PersonInfo, ByVal catalog As CatalogInfo, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        If person Is Nothing Then Throw New Exception("Cannot import person because no data is present.")
        'ClientId 
        If person.ClientId = 0 Then Throw New Exception("Cannot import person because client id is invalid.")
        param = New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = person.ClientId
        params.Add(param)
        'SSN
        If person.SSN.Trim.Length > 0 Then
            param = New SqlParameter("@SSN", SqlDbType.VarChar)
            param.Value = person.SSN
            params.Add(param)
        End If
        'FirstName
        param = New SqlParameter("@FirstName", SqlDbType.VarChar)
        param.Value = person.FirstAndMidName
        params.Add(param)
        'FirstName
        param = New SqlParameter("@LastName", SqlDbType.VarChar)
        param.Value = person.LastName
        params.Add(param)
        'Gender 
        If person.Gender <> Genders.u Then
            param = New SqlParameter("@Gender", SqlDbType.VarChar)
            param.Value = person.GetGenderName(person.Gender).Substring(0, 1)
            params.Add(param)
        End If
        'DOB
        If person.DateOfBirth <> New Date() Then
            param = New SqlParameter("@DateOfBirth", SqlDbType.DateTime)
            param.Value = person.DateOfBirth
            params.Add(param)
        End If
        'Language
        param = New SqlParameter("@LanguageId", SqlDbType.Int)
        param.Value = person.Language
        params.Add(param)
        'Email
        If person.Email.Trim.Length > 0 Then
            param = New SqlParameter("@EmailAddress", SqlDbType.VarChar)
            param.Value = person.Email
            params.Add(param)
        End If
        'Address
        If Not person.Address Is Nothing Then
            If person.Address.Street.Trim.Length > 0 Then
                param = New SqlParameter("@Street", SqlDbType.VarChar)
                param.Value = person.Address.Street.Trim
                params.Add(param)
                param = New SqlParameter("@Street2", SqlDbType.VarChar)
                param.Value = person.Address.Street2.Trim
                params.Add(param)
            End If
            If person.Address.City.Trim.Length > 0 Then
                param = New SqlParameter("@City", SqlDbType.VarChar)
                param.Value = person.Address.City.Trim
                params.Add(param)
            End If
            If Not person.Address.USState Is Nothing AndAlso Not catalog.States.FindById(person.Address.USState.Id) Is Nothing Then
                param = New SqlParameter("@StateId", SqlDbType.Int)
                param.Value = person.Address.USState.Id
                params.Add(param)
            End If
            If person.Address.ZipCode.Trim.Length > 0 Then
                param = New SqlParameter("@ZipCode", SqlDbType.VarChar)
                param.Value = person.Address.ZipCode.Trim
                params.Add(param)
            End If
        End If
        'Relationship
        param = New SqlParameter("@Relationship", SqlDbType.VarChar)
        param.Value = PersonInfo.GetRelationshipName(person.RelationshipWithPrincipalApplicant)
        params.Add(param)
        'Can Authorize
        param = New SqlParameter("@CanAuthorize", SqlDbType.Bit)
        param.Value = person.CanAuthorize
        params.Add(param)
        'User Id
        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)
        'Third Party
        param = New SqlParameter("@ThirdParty", SqlDbType.Bit)
        param.Value = person.IsThirdParty
        params.Add(param)

        Dim personid As Integer = SqlHelper.ExecuteScalar(trans, CommandType.StoredProcedure, "stp_ImportPersonInsert", params.ToArray)
        Return personid
    End Function

    Friend Function InsertEnrollment(ByVal trans As SqlTransaction, ByVal enrollment As EnrollmentInfo, ByVal catalog As CatalogInfo, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        If enrollment Is Nothing Then Throw New Exception("Cannot import enrollment information because no data is present.")
        'Name
        If enrollment.ClientName.Trim.Length > 0 Then
            param = New SqlParameter("@Name", SqlDbType.VarChar)
            param.Value = enrollment.ClientName.Trim
            params.Add(param)
        End If
        'Phone
        If Not enrollment.Phone Is Nothing AndAlso enrollment.Phone.Number.Trim.Length > 0 Then
            param = New SqlParameter("@Phone", SqlDbType.VarChar)
            param.Value = enrollment.Phone.Number.Trim
            params.Add(param)
        End If
        'Zip Code
        If Not enrollment.Address Is Nothing AndAlso enrollment.Address.ZipCode.Trim.Length > 0 Then
            param = New SqlParameter("@ZipCode", SqlDbType.VarChar)
            param.Value = enrollment.Address.ZipCode.Trim
            params.Add(param)
        End If
        'Behind
        If enrollment.BehindReason <> BehindReasonType.unknown Then
            param = New SqlParameter("@Behind", SqlDbType.Bit)
            param.Value = True
            params.Add(param)
            param = New SqlParameter("@BehindId", SqlDbType.Int)
            param.Value = enrollment.BehindReason
            params.Add(param)
        End If
        'Concern
        If enrollment.Concern <> ConcernReasonType.unknown Then
            param = New SqlParameter("@ConcernId", SqlDbType.Int)
            param.Value = enrollment.Concern
            params.Add(param)
        End If
        'Total Debt
        If enrollment.TotalDebt > 0 Then
            param = New SqlParameter("@TotalUnsecuredDebt", SqlDbType.Money)
            param.Value = enrollment.TotalDebt
            params.Add(param)
        End If
        'Deposit Commitment
        If enrollment.DepositCommitment > 0 Then
            param = New SqlParameter("@DepositCommitment", SqlDbType.Money)
            param.Value = enrollment.DepositCommitment
            params.Add(param)
        End If
        'Qualified
        param = New SqlParameter("@Qualified", SqlDbType.Bit)
        param.Value = enrollment.Qualified
        params.Add(param)
        'Committed
        param = New SqlParameter("@Committed", SqlDbType.Bit)
        param.Value = enrollment.Committed
        params.Add(param)
        'Delivery Method 
        If enrollment.DeliveryMethod <> DeliveryMethodType.unknown Then
            param = New SqlParameter("@DeliveryMethod", SqlDbType.VarChar)
            param.Value = EnrollmentInfo.GetDeliveryMethodName(enrollment.DeliveryMethod)
            params.Add(param)
        End If
        'AgencyId
        If Not enrollment.Agency Is Nothing AndAlso Not catalog.Agencies.FindById(enrollment.Agency.Id) Is Nothing Then
            param = New SqlParameter("@AgencyId", SqlDbType.Int)
            param.Value = enrollment.Agency.Id
            params.Add(param)
        End If
        'CompanyId
        If Not enrollment.LawFirm Is Nothing AndAlso Not catalog.Lawfirms.FindById(enrollment.LawFirm.Id) Is Nothing Then
            param = New SqlParameter("@CompanyId", SqlDbType.Int)
            param.Value = enrollment.LawFirm.Id
            params.Add(param)
        End If
        'UserId
        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Dim enrollmentid As Integer = SqlHelper.ExecuteScalar(trans, CommandType.StoredProcedure, "stp_ImportEnrollmentInsert", params.ToArray)
        Return enrollmentid
    End Function

    Friend Function InsertPhone(ByVal trans As SqlTransaction, ByVal phone As PhoneInfo, ByVal personId As Integer, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter
        If phone Is Nothing Then Throw New Exception("Cannot import phone information because it was not provided")

        param = New SqlParameter("@PhoneTypeId", SqlDbType.Int)
        param.Value = phone.Type
        params.Add(param)

        param = New SqlParameter("@AreaCode", SqlDbType.VarChar)
        param.Value = phone.AreaCode.Trim
        params.Add(param)

        param = New SqlParameter("@Number", SqlDbType.VarChar)
        param.Value = phone.LocalNumber
        params.Add(param)

        If phone.Extension.Trim.Length > 0 Then
            param = New SqlParameter("@Extension", SqlDbType.VarChar)
            param.Value = phone.Extension
            params.Add(param)
        End If

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        param = New SqlParameter("@PersonId", SqlDbType.Int)
        param.Value = personId
        params.Add(param)

        Dim phoneid As Integer = SqlHelper.ExecuteScalar(trans, CommandType.StoredProcedure, "stp_ImportPersonPhoneInsert", params.ToArray)
        Return phoneid
    End Function

    Friend Function InsertCreditorPhone(ByVal trans As SqlTransaction, ByVal phone As PhoneInfo, ByVal creditorId As Integer, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter
        If phone Is Nothing Then Throw New Exception("Cannot import phone information because it was not provided")

        param = New SqlParameter("@PhoneTypeId", SqlDbType.Int)
        param.Value = phone.Type
        params.Add(param)

        param = New SqlParameter("@AreaCode", SqlDbType.VarChar)
        param.Value = phone.AreaCode.Trim
        params.Add(param)

        param = New SqlParameter("@Number", SqlDbType.VarChar)
        param.Value = phone.LocalNumber
        params.Add(param)

        If phone.Extension.Trim.Length > 0 Then
            param = New SqlParameter("@Extension", SqlDbType.VarChar)
            param.Value = phone.Extension
            params.Add(param)
        End If

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        param = New SqlParameter("@CreditorId", SqlDbType.Int)
        param.Value = creditorId
        params.Add(param)

        Dim phoneid As Integer = SqlHelper.ExecuteScalar(trans, CommandType.StoredProcedure, "stp_ImportCreditorPhoneInsert", params.ToArray)
        Return phoneid
    End Function

    Friend Sub InsertAgencyExtraFields(ByVal trans As SqlTransaction, ByVal ClientId As Integer, ByVal extraFields As AgencyExtensionData, ByVal UserID As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        If extraFields Is Nothing Then Throw New Exception("Cannot import agency extra field information because it was not provided")
        If ClientId = 0 Then Throw New Exception("Cannot import agency extra field information because there is no client associated with it")

        param = New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)

        If extraFields.LeadNumber > 0 Then
            param = New SqlParameter("@LeadNumber", SqlDbType.Int)
            param.Value = extraFields.LeadNumber
            params.Add(param)
        End If

        If extraFields.DateSent <> New Date() Then
            param = New SqlParameter("@DateSent", SqlDbType.DateTime)
            param.Value = extraFields.DateSent
            params.Add(param)
        End If

        If extraFields.DateReceived <> New Date() Then
            param = New SqlParameter("@DateReceived", SqlDbType.DateTime)
            param.Value = extraFields.DateReceived
            params.Add(param)
        End If

        If extraFields.SeidemanPullDate <> New Date() Then
            param = New SqlParameter("@SeidemanPullDate", SqlDbType.DateTime)
            param.Value = extraFields.SeidemanPullDate
            params.Add(param)
        End If

        If extraFields.DebtTotal <> 0 Then
            param = New SqlParameter("@DebtTotal", SqlDbType.Money)
            param.Value = extraFields.DebtTotal
            params.Add(param)
        End If

        If extraFields.MissingInfo.Trim.Length > 0 Then
            param = New SqlParameter("@MissingInfo", SqlDbType.VarChar)
            param.Value = extraFields.MissingInfo
            params.Add(param)
        End If

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserID
        params.Add(param)

        SqlHelper.ExecuteNonQuery(trans, CommandType.StoredProcedure, "stp_ImportAgencyExtraFieldsInsert", params.ToArray)
    End Sub

    Friend Sub ExecuteLoadClientSearch(ByVal trans As SqlTransaction, ByVal clientid As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter
        param = New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = clientid
        params.Add(param)
        SqlHelper.ExecuteNonQuery(trans, CommandType.StoredProcedure, "stp_LoadClientSearch", params.ToArray)
    End Sub

    Friend Sub CreateClientRoadMap(ByVal trans As SqlTransaction, ByVal clientid As Integer, ByVal UserId As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter
        param = New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = clientid
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        'Hotfix: Need to use web server datetime rather than getdate() to match RoadmapHelper.InsertRoadmap
        param = New SqlParameter("@Created", SqlDbType.DateTime)
        param.Value = Now
        params.Add(param)

        Dim clientstatus As Integer() = New Integer() {2, 5, 6} '2:Start Enrollement, 5:complete Enrollement, 6:waiting for lsa and deposit

        Dim paramClientStatusId As New SqlParameter("@ClientStatusId", SqlDbType.Int)
        params.Add(paramClientStatusId)

        Dim paramParentRoadMapId As New SqlParameter("@ParentRoadMapId", SqlDbType.Int)
        params.Add(paramParentRoadMapId)

        Dim parentroadmapid As Integer = 0

        For Each statusid As Integer In clientstatus
            If parentroadmapid = 0 Then
                paramParentRoadMapId.Value = DBNull.Value
            Else
                paramParentRoadMapId.Value = parentroadmapid
            End If
            paramClientStatusId.Value = statusid
            parentroadmapid = SqlHelper.ExecuteScalar(trans, CommandType.StoredProcedure, "stp_ImportCreateRoadmap", params.ToArray)
        Next
    End Sub

    Friend Sub CreateAdHocACH(ByVal trans As SqlTransaction, ByVal client As ClientInfo, ByVal UserId As Integer)
        If Not client Is Nothing AndAlso Not client.SetupData Is Nothing AndAlso client.SetupData.DepositMethod = DepositMethodType.ach Then

            Dim params As New List(Of SqlParameter)
            Dim param As SqlParameter

            If client.Id = 0 Then Throw New Exception("Cannot create Adhoc ACH transaction because the client info is invalid")
            param = New SqlParameter("@ClientId", SqlDbType.Int)
            param.Value = client.Id
            params.Add(param)

            If client.SetupData.FirstDepositDate = New Date() Then Throw New Exception("Cannot create ach for this client because deposit date is not provided")
            If client.SetupData.FirstDepositDate < Now.AddDays(1) Then Throw New Exception("Cannot create adhoc ach because the initial draft day is before " & Now.AddDays(1).ToString)

            param = New SqlParameter("@DepositDate", SqlDbType.DateTime)
            param.Value = client.SetupData.FirstDepositDate
            params.Add(param)

            param = New SqlParameter("@DepositAmount", SqlDbType.Money)
            param.Value = client.SetupData.FirstDepositAmount
            params.Add(param)

            param = New SqlParameter("@InitialDraftYN", SqlDbType.Bit)
            param.Value = True
            params.Add(param)

            If client.PrimaryBank Is Nothing Then Throw New Exception("Cannot create ach for this client because the banking information is not provided")

            If client.PrimaryBank.RoutingNumber.Trim.Length = 0 OrElse Not Int64.TryParse(client.PrimaryBank.RoutingNumber.Trim, Nothing) OrElse Not Int64.Parse(client.PrimaryBank.RoutingNumber) > 0 Then _
                Throw New Exception("Cannot create first draft adhoc ach for this client because the banking routing number is invalid")
            If client.PrimaryBank.RoutingNumber.Trim.Length <> 9 Then Throw New Exception("The bank routing number must be 9 digits!")
            param = New SqlParameter("@BankRoutingNumber", SqlDbType.VarChar)
            param.Value = client.PrimaryBank.RoutingNumber
            params.Add(param)

            If client.PrimaryBank.AccountNumber.Trim.Length = 0 OrElse Not Int64.TryParse(client.PrimaryBank.AccountNumber.Trim, Nothing) OrElse Not Int64.Parse(client.PrimaryBank.AccountNumber) > 0 Then _
                Throw New Exception("Cannot create first draft adhoc ach for this client because the banking account number is invalid")
            param = New SqlParameter("@BankAccountNumber", SqlDbType.VarChar)
            param.Value = client.PrimaryBank.AccountNumber
            params.Add(param)

            If client.PrimaryBank.Name.Trim.Length = 0 Then _
                Throw New Exception("Cannot create first draft adhoc ach for this client because the bank's name is not provided")
            param = New SqlParameter("@BankName", SqlDbType.VarChar)
            param.Value = client.PrimaryBank.Name
            params.Add(param)

            If client.PrimaryBank.Type <> BankAccountType.unknown Then
                param = New SqlParameter("@BankType", SqlDbType.VarChar)
                param.Value = BankAccountInfo.GetBankAccountTypeName(client.PrimaryBank.Type).Substring(0, 1)
                params.Add(param)
            End If

            param = New SqlParameter("@UserId", SqlDbType.Int)
            param.Value = UserId
            params.Add(param)

            SqlHelper.ExecuteNonQuery(trans, CommandType.StoredProcedure, "stp_ImportCreateAdHocAch", params.ToArray)
        End If
    End Sub

    Friend Function InsertAccount(ByVal trans As SqlTransaction, ByVal ClientId As Integer, ByVal account As AccountInfo, ByVal SetupFeePercentage As Double, ByVal UserId As Integer) As Integer

        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        If ClientId = 0 Then Throw New Exception("Cannot create creditor account because the client info is invalid")
        param = New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)


        If account.Creditor Is Nothing OrElse account.Creditor.Id = 0 Then Throw New Exception("Cannot create creditor instance because the creditor information is not available")
        param = New SqlParameter("@CreditorId", SqlDbType.Int)
        param.Value = account.Creditor.Id
        params.Add(param)

        If account.AccountNumber.Trim.Length = 0 Then Throw New Exception("Cannot create creditor instance because account number cannot be empty")
        param = New SqlParameter("@CreditorAccountNumber", SqlDbType.VarChar)
        param.Value = account.AccountNumber
        params.Add(param)

        param = New SqlParameter("@AccountStatusId", SqlDbType.Int)
        param.Value = 51 'Insuficient funds
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        If account.Balance = 0 Then Throw New Exception("Account balance cannot be zero")
        param = New SqlParameter("@Amount", SqlDbType.Money)
        param.Value = account.Balance
        params.Add(param)

        If account.DueDate = New Date Then account.DueDate = Today
        param = New SqlParameter("@DueDate", SqlDbType.DateTime)
        param.Value = account.DueDate
        params.Add(param)


        param = New SqlParameter("@SetupFeePercentage", SqlDbType.Decimal)
        param.Value = SetupFeePercentage / 100
        params.Add(param)

        If account.Acquired = New Date Then account.Acquired = Today
        param = New SqlParameter("@Acquired", SqlDbType.DateTime)
        param.Value = account.Acquired
        params.Add(param)

        Dim accountid As Integer = SqlHelper.ExecuteScalar(trans, CommandType.StoredProcedure, "stp_ImportAccountInsert", params.ToArray)
        Return accountid
    End Function

    Friend Function GetCreditor(ByVal trans As SqlTransaction, ByVal creditorid As Integer) As DataTable
        Dim dt As DataSet = SqlHelper.ExecuteDataset(Me.ConnStr, CommandType.Text, String.Format("Select CreditorId, Name, Street, Street2, City, StateId, ZipCode from tblCreditor Where CreditorId = {0}", creditorid))
        Return dt.Tables(0)
    End Function

    Friend Function GetCreditor(ByVal trans As SqlTransaction, ByVal creditorname As String) As DataTable
        Dim dt As DataSet = SqlHelper.ExecuteDataset(Me.ConnStr, CommandType.Text, String.Format("Select CreditorId, Name, Street, Street2, City, StateId, ZipCode from tblCreditor Where name = '{0}'", creditorname))
        Return dt.Tables(0)
    End Function

    Friend Function GetCreditor(ByVal creditorid As Integer) As DataTable
        Dim dt As DataSet = SqlHelper.ExecuteDataset(Me.ConnStr, CommandType.Text, String.Format("Select CreditorId, Name, Street, Street2, City, StateId, ZipCode from tblCreditor Where CreditorId = {0}", creditorid))
        Return dt.Tables(0)
    End Function

    Friend Function GetCreditor(ByVal creditorname As String) As DataTable
        Dim dt As DataSet = SqlHelper.ExecuteDataset(Me.ConnStr, CommandType.Text, String.Format("Select CreditorId, Name, Street, Street2, City, StateId, ZipCode from tblCreditor Where name = '{0}'", creditorname))
        Return dt.Tables(0)
    End Function

    Friend Function GetCreditor(ByVal creditor As CreditorInfo) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter
        If creditor.Id > 0 Then
            param = New SqlParameter("@CreditorId", SqlDbType.Int)
            param.Value = creditor.Id
            params.Add(param)
        End If

        param = New SqlParameter("@Name", SqlDbType.VarChar)
        param.Value = creditor.Name.Trim
        params.Add(param)

        If Not creditor.Address Is Nothing Then
            If creditor.Address.Street.Trim.Length > 0 Then
                param = New SqlParameter("@Street", SqlDbType.VarChar)
                param.Value = creditor.Address.Street.Trim
                params.Add(param)
            End If

            If creditor.Address.Street2.Trim.Length > 0 Then
                param = New SqlParameter("@Street2", SqlDbType.VarChar)
                param.Value = creditor.Address.Street.Trim
                params.Add(param)
            End If

            If creditor.Address.City.Trim.Length > 0 Then
                param = New SqlParameter("@City", SqlDbType.VarChar)
                param.Value = creditor.Address.City.Trim
                params.Add(param)
            End If

            If Not creditor.Address.USState Is Nothing Then
                param = New SqlParameter("@StateId", SqlDbType.Int)
                param.Value = creditor.Address.USState.Id
                params.Add(param)
            End If

            If creditor.Address.City.Trim.Length > 0 Then
                param = New SqlParameter("@ZipCode", SqlDbType.VarChar)
                param.Value = creditor.Address.ZipCode.Trim
                params.Add(param)
            End If

        End If

        Dim dt As DataSet = SqlHelper.ExecuteDataset(Me.ConnStr, CommandType.StoredProcedure, "stp_ImportGetCreditorFirstMatch", params.ToArray)
        Return dt.Tables(0)
    End Function

    Friend Function InsertCreditor(ByVal trans As SqlTransaction, ByVal creditor As CreditorInfo, ByVal catalog As CatalogInfo, ByVal UserId As Integer, ByVal InsertPhones As Boolean) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        If creditor Is Nothing Then Throw New Exception("Cannot create creditor because its information is not provided")

        param = New SqlParameter("@Name", SqlDbType.VarChar)
        param.Value = creditor.Name.Trim
        params.Add(param)

        If Not creditor.Address Is Nothing Then
            If creditor.Address.Street.Trim.Length > 0 Then
                param = New SqlParameter("@Street", SqlDbType.VarChar)
                param.Value = creditor.Address.Street.Trim
                params.Add(param)
                param = New SqlParameter("@Street2", SqlDbType.VarChar)
                param.Value = creditor.Address.Street2.Trim
                params.Add(param)
            End If
            If creditor.Address.City.Trim.Length > 0 Then
                param = New SqlParameter("@City", SqlDbType.VarChar)
                param.Value = creditor.Address.City.Trim
                params.Add(param)
            End If
            If Not creditor.Address.USState Is Nothing AndAlso Not catalog.States.FindById(creditor.Address.USState.Id) Is Nothing Then
                param = New SqlParameter("@StateId", SqlDbType.Int)
                param.Value = creditor.Address.USState.Id
                params.Add(param)
            End If
            If creditor.Address.ZipCode.Trim.Length > 0 Then
                param = New SqlParameter("@ZipCode", SqlDbType.VarChar)
                param.Value = creditor.Address.ZipCode.Trim
                params.Add(param)
            End If
        End If

        'Not used in order to comply with new creditor interface
        'param = New SqlParameter("@UserId", SqlDbType.Int)
        'param.Value = UserId
        'params.Add(param)

        param = New SqlParameter("@CreatedBy", SqlDbType.Int)
        param.Value = creditor.CreatedBy
        params.Add(param)

        param = New SqlParameter("@LastModifiedBy", SqlDbType.Int)
        param.Value = creditor.LastModifiedBy
        params.Add(param)

        param = New SqlParameter("@Created", SqlDbType.DateTime)
        param.Value = creditor.CreatedDate
        params.Add(param)

        param = New SqlParameter("@LastModified", SqlDbType.DateTime)
        param.Value = creditor.LastModifiedDate
        params.Add(param)

        If creditor.GroupId > 0 Then
            param = New SqlParameter("@GroupId", SqlDbType.Int)
            param.Value = creditor.GroupId
            params.Add(param)
        End If

        Dim creditorid As Integer = SqlHelper.ExecuteScalar(trans, CommandType.StoredProcedure, "stp_ImportCreditorInsert", params.ToArray)

        If InsertPhones AndAlso Not creditor.Phone Is Nothing Then InsertCreditorPhone(trans, creditor.Phone, creditorid, UserId)

        Return creditorid
    End Function

    Friend Function InsertCreditorGroup(ByVal trans As SqlTransaction, ByVal Name As String, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@Name", SqlDbType.VarChar)
        param.Value = Name
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Return SqlHelper.ExecuteScalar(trans, CommandType.StoredProcedure, "stp_InsertCreditorGroup", params.ToArray)
    End Function

    Friend Function InsertImportJob(ByVal SourceId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@SourceId", SqlDbType.Int)
        param.Value = SourceId
        params.Add(param)

        Return SqlHelper.ExecuteScalar(Me.ConnStr, CommandType.StoredProcedure, "stp_InsertImportClientJob", params.ToArray)

    End Function

    Friend Function InsertImportedClient(ByVal trans As SqlTransaction, ByVal JobId As Integer, ByVal SourceId As Integer, ByVal ExternalClientId As String) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter
        param = New SqlParameter("@JobId", SqlDbType.Int)
        param.Value = JobId
        params.Add(param)

        param = New SqlParameter("@SourceId", SqlDbType.Int)
        param.Value = SourceId
        params.Add(param)

        param = New SqlParameter("@ExternalClientId", SqlDbType.VarChar)
        param.Value = ExternalClientId
        params.Add(param)

        Return SqlHelper.ExecuteScalar(trans, CommandType.StoredProcedure, "stp_InsertImportedClient", params.ToArray)
    End Function

    Friend Sub UpdateClientImportId(ByVal trans As SqlTransaction, ByVal clientId As Integer, ByVal ImportId As Integer)
        SqlHelper.ExecuteNonQuery(trans, CommandType.Text, String.Format("Update tblClient Set ServiceImportId = {0} Where ClientId = {1}", ImportId, clientId))
    End Sub

    Friend Function GetUserById(ByVal UserId As Integer) As DataTable
        Dim dt As DataSet = SqlHelper.ExecuteDataset(Me.ConnStr, CommandType.Text, String.Format("Select UserId, FirstName, LastName from tblUser where userId = {0}", UserId))
        Return dt.Tables(0)
    End Function

    Friend Function InsertNote(ByVal trans As SqlTransaction, ByVal note As NoteInfo, ByVal clientId As Integer, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter
        If note Is Nothing Then Throw New Exception("Cannot import note information because it was not provided")

        If clientId = 0 Then Throw New Exception("Note with no client id")
        param = New SqlParameter("@Clientid", SqlDbType.Int)
        param.Value = clientId
        params.Add(param)

        If note.Subject.Trim.Length > 0 Then
            param = New SqlParameter("@Subject", SqlDbType.VarChar)
            param.Value = note.Subject.Trim
            params.Add(param)
        End If

        If note.Text.Trim.Length = 0 Then Throw New Exception("Note text cannot be empty")
        param = New SqlParameter("@Value", SqlDbType.VarChar)
        param.Value = note.Text.Trim
        params.Add(param)

        If note.DateCreated = New Date() Then note.DateCreated = Today
        param = New SqlParameter("@Created", SqlDbType.DateTime)
        param.Value = note.DateCreated
        params.Add(param)

        If note.LastModifiedDate = New Date() Then note.LastModifiedDate = Today
        param = New SqlParameter("@LastModified", SqlDbType.DateTime)
        param.Value = note.LastModifiedDate
        params.Add(param)

        param = New SqlParameter("@CreatedBy", SqlDbType.Int)
        If note.CreatedBy Is Nothing OrElse note.CreatedBy.Id = 0 Then
            param.Value = UserId
        Else
            param.Value = note.CreatedBy.Id
        End If
        params.Add(param)

        param = New SqlParameter("@LastModifiedBy", SqlDbType.Int)
        If note.LastModifiedBy Is Nothing OrElse note.LastModifiedBy.Id = 0 Then
            param.Value = UserId
        Else
            param.Value = note.LastModifiedBy.Id
        End If
        params.Add(param)

        If note.ExternalSource.Trim.Length > 0 Then
            param = New SqlParameter("@OldTable", SqlDbType.VarChar)
            param.Value = note.ExternalSource.Trim
            params.Add(param)
        End If

        If note.ExternalId <> 0 Then
            param = New SqlParameter("@OldId", SqlDbType.Int)
            param.Value = note.ExternalId
            params.Add(param)
        End If

        Dim noteid As Integer = SqlHelper.ExecuteScalar(trans, CommandType.StoredProcedure, "stp_ImportClientNoteInsert", params.ToArray)
        Return noteid
    End Function

    Friend Function InsertBankAccount(ByVal trans As SqlTransaction, ByVal Bank As BankAccountInfo, ByVal ClientId As Integer, ByVal UserId As Integer, ByVal ValidateRouting As Boolean) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        If ClientId = 0 Then Throw New Exception("Bank Account with no client id")
        If Bank Is Nothing Then Throw New Exception("Banking information not provided")

        param = New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)

        If Bank.RoutingNumber.Trim.Length = 0 OrElse Not Int64.TryParse(Bank.RoutingNumber, Nothing) OrElse Not Bank.RoutingNumber.Length = 9 Then
            Throw New Exception("The bank account routing number is missing or invalid for this ach client")
        Else
            'validate routing number
            Dim validatedBankRouting As String = Bank.RoutingNumber.Trim
            Dim validatedBankName As String = Bank.Name.Trim
            If ValidateRouting AndAlso Not BankAccountInfo.IsValidRouting(validatedBankRouting, validatedBankName) Then
                Throw New Exception("The bank account routing number is not valid or it could not be validated against third party service.")
            Else
                Bank.RoutingNumber = validatedBankRouting
            End If
        End If

        If Bank.RoutingNumber.Trim.Length <> 9 Then Throw New Exception("The bank routing number must have 9 digits!")

        param = New SqlParameter("@Routing", SqlDbType.VarChar)
        param.Value = Bank.RoutingNumber.Trim
        params.Add(param)

        If Bank.AccountNumber.Trim.Length = 0 Then Throw New Exception("Bank Account Number not provided")
        param = New SqlParameter("@Account", SqlDbType.VarChar)
        param.Value = Bank.AccountNumber.Trim
        params.Add(param)

        If Bank.Type <> BankAccountType.unknown Then
            param = New SqlParameter("@BankType", SqlDbType.VarChar)
            param.Value = BankAccountInfo.GetBankAccountTypeName(Bank.Type).Substring(0, 1)
            params.Add(param)
        End If

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Dim bankAccountId As Integer = SqlHelper.ExecuteScalar(trans, CommandType.StoredProcedure, "stp_InsertClientBankAccount", params.ToArray)
        Return bankAccountId
    End Function

    Friend Function InsertMultiDepositDay(ByVal trans As SqlTransaction, ByVal day As DepositDayInfo, ByVal clientId As Integer, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        If clientId = 0 Then Throw New Exception("Bank Account with no client id")
        If day Is Nothing Then Throw New Exception("Deposit day info not provided")

        param = New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = clientId
        params.Add(param)

        param = New SqlParameter("@frequency", SqlDbType.VarChar)
        param.Value = DepositDayInfo.GetFrequencyName(day.Frequency)
        params.Add(param)

        If day.DepositDay < 1 Or day.DepositDay > 30 Then Throw New Exception("Deposit day must be between 1 and 30")

        param = New SqlParameter("@DepositDay", SqlDbType.Int)
        param.Value = day.DepositDay
        params.Add(param)

        param = New SqlParameter("@Amount", SqlDbType.Money)
        param.Value = day.Amount
        params.Add(param)

        If day.Occurrence > 0 Then
            param = New SqlParameter("@Ocurrence", SqlDbType.Int)
            param.Value = day.Occurrence
            params.Add(param)
        End If

        Dim depositmethod As DepositMethodType = DepositMethodType.check
        Dim bankid As Integer = 0

        If day.DepositMethod = DepositMethodType.ach Then
            If (day.BankAccount Is Nothing OrElse day.BankAccount.Id = 0) Then
                Throw New Exception("ACH deposit without banking information")
            Else
                depositmethod = DepositMethodType.ach
                bankid = day.BankAccount.Id
            End If
        End If

        param = New SqlParameter("@DepositMethod", SqlDbType.VarChar)
        param.Value = SetupInfo.GetDepositMethodName(depositmethod)
        params.Add(param)

        If bankid > 0 Then
            param = New SqlParameter("@BankAccountId", SqlDbType.Int)
            param.Value = bankid
            params.Add(param)
        End If

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Dim depositId As Integer = SqlHelper.ExecuteScalar(trans, CommandType.StoredProcedure, "stp_InsertClientDepositDay", params.ToArray)
        Return depositId
    End Function
End Class
