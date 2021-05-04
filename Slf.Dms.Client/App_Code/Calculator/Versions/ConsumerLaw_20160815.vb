Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Public Class ConsumerLaw_20160815 : Inherits SettlementCalculator

#Region "Fields"
    Dim _SettlementPercentages() As Double
    Dim _FixedFeePercentage As Double
    Dim _SettlementFees As Double
    Dim _TotalMonthlyFees As Double
#End Region 'Fields

#Region "Methods"

    Public Overrides Function Calculate() As List(Of Results)

        'Get Settlement Numbers
        Dim dtSettlementFees As DataTable = GetSettlementData()

        'Assign Settlement Values To Local Variables
        For Each dr As DataRow In dtSettlementFees.Rows
            _FixedFeePercentage = CDbl(dr("FixedFeeAmount").ToString)

            Dim percentages As String() = dr("SettlementPercentages").ToString.Split("|")
            Dim index As Integer = 0
            _SettlementPercentages = New Double(percentages.Length) {}
            For Each Str As String In percentages
                _SettlementPercentages(index) = CDbl(Str)
                index += 1
            Next
        Next

        Dim Deposits As Double() = GetDeposits()
        Dim ResultsList As New List(Of Results)

        ''Start Calculating        

        'For Each Deposit Amount (ex. $250, $300, $350)
        For Each Deposit As Double In Deposits

            'For Each Percentage (ex. 25%, 50%, 75%, 100%)
            For Each Percent As Double In _SettlementPercentages

                'Start off with reset values
                _Funds = 0
                _CurrentMonth = 0
                _Debt = 0
                _TotalPaid = 0
                _TotalMonthlyFees = 0

                'Initial Calculations
                _SettlementAmount = _Applicant.TotalDebt * Percent
                _SettlementFees = _Applicant.TotalDebt * _FixedFeePercentage

                'Collect Initial Values (Credits & Debit)
                _Funds += _Applicant.IntitialDeposit
                _Debt += _SettlementAmount
                _Debt += _SettlementFees

                Do Until _Debt < 0.01 Or _CurrentMonth > 1000
                    'Applicant Deposits
                    _Funds += Deposit

                    If _Debt >= _Funds Then
                        _TotalPaid += _Funds
                        _Debt -= _Funds
                        _Funds -= _Funds
                        _CurrentMonth += 1
                    Else
                        _TotalPaid += _Debt
                        _Funds -= _Debt
                        _Debt -= _Debt
                        _CurrentMonth += 1
                    End If
                Loop

                'Insert Results Into Container
                _Results = New Results()
                _Results.InititalFeeAmount = "0.00"
                _Results.MonthlyDeposit = Deposit.ToString("0.00")
                _Results.MonthlyRecurringFee = "0.00"
                _Results.Months = GetMonths(_CurrentMonth)
                _Results.PercentageOfSettlement = Percent
                _Results.PercentFeesToCost = TotalPercentPaid(_TotalPaid, _SettlementFees)
                _Results.SettleFeeAmount = _SettlementFees.ToString("0.00")
                _Results.SettlementAmount = _SettlementAmount.ToString("0.00")
                _Results.SettlementFeePercentage = "0"
                _Results.TotalAmountFees = _TotalPaid.ToString("0.00")
                _Results.TotalDebt = _Applicant.TotalDebt.ToString("0.00")
                _Results.TotalMonthlyFee = _TotalMonthlyFees.ToString("0.00")
                _Results.Years = GetYearsMonths(_CurrentMonth)

                ResultsList.Add(_Results)
            Next
        Next

        Return ResultsList

    End Function

    Public Overrides Function GetSettlementData() As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("LeadApplicantId", _Applicant.LeadApplicantId))

        Return SqlHelper.GetDataTable("stp_GetApplicantsSettlementFees_CLG_20160815", CommandType.StoredProcedure, params.ToArray)
    End Function

    Private Function TotalPercentPaid(TotalPaid As Double, TotalFixFee As Double) As String
        Return String.Format("{0}%", (((TotalFixFee) / TotalPaid) * 100).ToString("0.00"))
    End Function

    Private Function GetDeposits() As Double()
        Dim dt As DataTable = SqlHelper.GetDataTable("stp_GetDepositIncrements", CommandType.StoredProcedure)
        Dim indexnumber As Integer = dt.Rows.Count + 1
        Dim counter As Integer = 0
        Dim currentAmount As Double = 0
        Dim deposits(indexnumber) As Double

        currentAmount = _Applicant.MonthlyDeposit
        deposits(counter) = currentAmount

        For Each dr As DataRow In dt.Rows
            counter += 1
            currentAmount += CDbl(dr("Increments"))
            deposits(counter) = currentAmount
            currentAmount -= CDbl(dr("Increments"))
        Next

        Return deposits
    End Function

#End Region


End Class
