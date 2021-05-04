Imports System.Data.SqlClient

Public Class Applicant
    Inherits Person

#Region "Fields"

    Dim _LeadApplicantId As Integer
    Dim _Accounts As New List(Of Account)
    Dim _TotalDebt As Double

    Dim _IntitialDeposit As Double
    Dim _MonthlyDeposit As Double

#End Region 'Fields

#Region "Property"

    Public Property LeadApplicantId() As Integer
        Get
            Return _LeadApplicantId
        End Get
        Set(value As Integer)
            _LeadApplicantId = value
        End Set
    End Property

    Public Property TotalDebt() As Double
        Get
            Return _TotalDebt
        End Get
        Set(ByVal value As Double)
            _TotalDebt = value
        End Set
    End Property

    Public Property IntitialDeposit() As Double
        Get
            Return _IntitialDeposit
        End Get
        Set(ByVal value As Double)
            _IntitialDeposit = value
        End Set
    End Property

    Public Property MonthlyDeposit() As Double
        Get
            Return _MonthlyDeposit
        End Get
        Set(ByVal value As Double)
            _MonthlyDeposit = value
        End Set
    End Property

#End Region 'Property

#Region "Constructors"

    Public Sub New()

    End Sub

    Public Sub New(LeadApplicant As Integer)
        GetSettlementDetails(LeadApplicant)
    End Sub

#End Region 'Constructors

#Region "Methods"

    Public Sub GetSettlementDetails(IdentificationNumber As Integer)

        Dim params As New List(Of SqlParameter)
        Dim params2 As New List(Of SqlParameter)
        Dim dtAccounts As DataTable
        Dim dtDeposits As DataTable

        params.Add(New SqlParameter("LeadApplicantId", IdentificationNumber))
        params2.Add(New SqlParameter("LeadApplicantId", IdentificationNumber))

        dtAccounts = SqlHelper.GetDataTable("stp_GetApplicantsAccountData", CommandType.StoredProcedure, params.ToArray)
        dtDeposits = SqlHelper.GetDataTable("stp_GetApplicantsDepositData", CommandType.StoredProcedure, params2.ToArray)

        For Each dr As DataRow In dtAccounts.Rows
            Dim accts As New Account

            accts.AccountBalance = dr("AccountBalance").ToString
            accts.AccountNumber = dr("AccountNumber").ToString
            accts.AccountStatus = dr("AccountStatus").ToString
            accts.AccountType = dr("AccountType").ToString
            accts.ApplicantId = CInt(dr("ApplicantId").ToString)
            accts.City = dr("City").ToString
            accts.CreditorGroup = dr("CreditorGroupName").ToString
            accts.CreditorId = CInt(dr("CreditorId").ToString)
            accts.CreditorName = dr("CreditorName").ToString
            accts.Extension = dr("Extension").ToString
            accts.InterestRate = CDbl(dr("InterestRate").ToString)
            accts.LateThirtyDays = CBool(dr("LateThirtyDays").ToString)
            accts.LateSixtyDays = CBool(dr("LateSixtyDays").ToString)
            accts.LateNinetyDays = CBool(dr("LateNinetyDays").ToString)
            accts.LateOneTwentyDays = CBool(dr("LateOneTwentyDays").ToString)
            accts.LoanType = dr("LoanType").ToString
            accts.MinimumPayment = CDbl(dr("MinPayment").ToString)
            accts.Phone = dr("Phone").ToString
            accts.State = CInt(dr("StateId").ToString)
            accts.Street1 = dr("Street1").ToString
            accts.Street2 = dr("Street2").ToString
            accts.ZipCode = dr("ZipCode").ToString

            _Accounts.Add(accts)
        Next

        For Each dr As DataRow In dtDeposits.Rows
            _IntitialDeposit = CDbl(dr("InitialDeposit").ToString)
            _MonthlyDeposit = CDbl(dr("DepositCommittment").ToString)
        Next

        GetTotalDebt()

    End Sub

    Private Sub GetTotalDebt()

        _TotalDebt = 0

        For Each acct As Account In _Accounts
            _TotalDebt += acct.AccountBalance
        Next

    End Sub


#End Region 'Methods


End Class
