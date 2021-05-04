Imports System.Data.SqlClient

Public Class Calculator2

    Dim _Applicant As Applicant
    Dim _Results As DataTable
    Dim _Wallet As Double
    Dim _CurrentMonth As Integer
    Dim _Debt As Double
    Dim _TotalPaid As Double
    Dim _SettlementAmount As Double

    Dim _InitialServiceFees As Double
    Dim _SettlementPercentages() As Double
    Dim _SettlementFees As Double
    Dim _SettlementFeePercentage As Double
    Dim _MonthlyServiceFee As Double
    Dim _TotalMonthlyFees As Double

    Public Function CalculateSettlementFees(ByVal IdentificationNumber As Integer) As DataTable

        _Applicant = New Applicant(IdentificationNumber) 'Global Varible

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("leadapplicantid", _Applicant.LeadApplicantId))
        'Dim version As String = CStr(SqlHelper.ExecuteScalar("stp_GetCalculatorVersion", CommandType.StoredProcedure, params.ToArray))

        'Return CalculateVersion(version)
        Return CalculateVersion("SettleFeesVersion1")

    End Function

    Private Function CalculateVersion(ByVal Version As String) As DataTable

        Select Case Version
            Case "SettleFeesVersion1"
                Return CalculateSettleFeesVersion1()
                End
            Case Else 'Default Case
                Return CalculateSettleFeesVersion1()
                End
        End Select
    End Function

    ''' <summary>
    ''' TKM's original 4 Tier System
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function CalculateSettleFeesVersion1() As DataTable

        Dim results As New DataTable
        results.Columns.Add("MonthlyDeposit", GetType(String))
        results.Columns.Add("PercentSettled", GetType(String))
        results.Columns.Add("SettlementAmount", GetType(String))
        results.Columns.Add("TotalDebt", GetType(String))
        results.Columns.Add("SettlementPercentage", GetType(String))
        results.Columns.Add("SettlementFee", GetType(String))
        results.Columns.Add("InititialFees", GetType(String))
        results.Columns.Add("TotalMonthlyFees", GetType(String))
        results.Columns.Add("MonthlyFee", GetType(String))
        results.Columns.Add("TotalFees", GetType(String))
        results.Columns.Add("PercentFeesToCost", GetType(String))
        results.Columns.Add("Months", GetType(String))
        results.Columns.Add("Years", GetType(String))

        Dim dtSettlementFees As DataTable = GetSettlementFees()
        'Dim dtFinancials As DataTable = GetFinancials()

        For Each dr As DataRow In dtSettlementFees.Rows
            _InitialServiceFees = CDbl(dr("InitialServiceFees").ToString)
            _SettlementFeePercentage = dr("SettlementFees").ToString
            _MonthlyServiceFee = dr("MonthlyServiceFee").ToString

            Dim percentages As String() = dr("SettlementPercentages").ToString.Split("|")
            Dim index As Integer = 0
            _SettlementPercentages = New Double(percentages.Length) {}
            For Each Str As String In percentages
                _SettlementPercentages(index) = CDbl(Str)
                index += 1
            Next
        Next

        'Start Calculating

        Dim Deposits As Double() = {250.0, 300.0, 350.0}                              '***************************FIX*****************************

        'For Each Deposit Amount (ex. $250, $300, $350)
        For Each Deposit As Double In Deposits

            'For Each Percentage (ex. 25%, 50%, 75%, 100%)
            For Each Percent As Double In _SettlementPercentages

                'Start off with reset values
                _Wallet = 0
                _CurrentMonth = 0
                _Debt = 0
                _TotalPaid = 0
                _TotalMonthlyFees = 0

                'Initial Calculations
                _SettlementAmount = _Applicant.TotalDebt * Percent
                _SettlementFees = _Applicant.TotalDebt * _SettlementFeePercentage

                'Collect Initial Values (Credits & Debit)
                _Wallet += _Applicant.IntitialDeposit
                _Debt += _SettlementAmount
                _Debt += _SettlementFees
                _Debt += _InitialServiceFees

                Do Until _Debt < 0.01 Or _CurrentMonth > 1000
                    'Applicant Deposits
                    _Wallet += Deposit
                    _Debt += _MonthlyServiceFee
                    _TotalMonthlyFees += _MonthlyServiceFee

                    If _Debt >= _Wallet Then
                        _TotalPaid += _Wallet
                        _Debt -= _Wallet
                        _Wallet -= _Wallet
                        _CurrentMonth += 1
                    Else
                        _TotalPaid += _Debt
                        _Wallet -= _Debt
                        _Debt -= _Debt
                        _CurrentMonth += 1
                    End If
                Loop

                'Insert Record
                results.Rows.Add(Deposit.ToString("0.00"), Percent, _SettlementAmount.ToString("0.00"), _Applicant.TotalDebt.ToString("0.00"), _SettlementFeePercentage, _SettlementFees.ToString("0.00"), _
                                 _InitialServiceFees.ToString("0.00"), _MonthlyServiceFee.ToString("0.00"), _TotalMonthlyFees.ToString("0.00"), _TotalPaid.ToString("0.00"), _
                                 TotalPercentPaid(_TotalPaid, _InitialServiceFees, _TotalMonthlyFees, _SettlementFees), GetMonths(_CurrentMonth), GetYearsMonths(_CurrentMonth))

            Next
        Next

        Return results

    End Function

    'Dynamic
    Private Function TotalPercentPaid(TotalPaid As Double, InitialServiceFees As Double, TotalMonthlyFee As Double, SettlementFee As Double) As String
        Return String.Format("{0}%", (((InitialServiceFees + TotalMonthlyFee + SettlementFee) / TotalPaid) * 100).ToString("0.00"))
    End Function

    'Generic Function
    Private Function GetMonths(Months As Integer) As String
        Return String.Format("{0} mos", Months)
    End Function

    'Generic Function
    Private Function GetYearsMonths(Months As Integer) As String
        Dim NumberOfYears As Integer = Math.Floor(Months / 12)
        Dim NumberOfMonths As Integer = Months - (NumberOfYears * 12)
        Return String.Format("{0} yrs {1} mos", NumberOfYears, NumberOfMonths)
    End Function

    'Dynamic
    Private Function GetSettlementFees() As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("TotalDebt", _Applicant.TotalDebt))

        Return SqlHelper.GetDataTable("stp_GetApplicantsSettlementFees", CommandType.StoredProcedure, params.ToArray)
    End Function
End Class
