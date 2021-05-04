Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Public Class MinimumPaymentVersion0001 : Inherits SettlementCalculator

#Region "Fields"
    Dim _TotalDebt As Double
    Dim _NumberOfDebts As Integer
    Dim _MinimumPaymentAmount As Double
    Dim _MinimumPaymentPercentage As Double
    Dim _APR As Double
    Dim _CurrentAPR As Double
    Dim _TotalAPR As Double

#End Region 'Fields

#Region "Methods"

    Public Overrides Function Calculate() As List(Of Results)

        'Get Variables From Applicant Needed to Calculate
        _TotalDebt = _Applicant.TotalDebt
        _NumberOfDebts = _Applicant.NumberOfDebts

        'Get Variables From System Needed to Calculate
        GetSystemVariables()

        'Start off with reset values
        _Funds = 0
        _CurrentMonth = 0
        _Debt = 0
        _TotalPaid = 0
        _CurrentAPR = 0
        _TotalAPR = 0

        'Initial Calculations
        _Debt = _TotalDebt

        ''Start Calculating  
        Do Until _Debt < 0.01 Or _CurrentMonth > 1000
            'Applicant Deposits
            Dim Deposit As Double

            If _Debt * _MinimumPaymentPercentage > _MinimumPaymentAmount Then
                Deposit = _Debt * _MinimumPaymentPercentage
            Else
                Deposit = _MinimumPaymentAmount
            End If

            _Funds += Deposit

            If _CurrentMonth <> 0 Then
                _CurrentAPR = _Debt * (_APR / 12)
            Else
                _CurrentAPR = 0.0
            End If

            _Debt += _CurrentAPR
            _TotalAPR += _CurrentAPR

            If _Debt >= _Funds Then
                _Debt -= _Funds
                _Funds -= _Funds
                _CurrentMonth += 1
            Else
                _Funds -= _Debt
                _Debt -= _Debt
                _CurrentMonth += 1
            End If
        Loop

        'Insert Results Into Container

        Dim ResultsList As New List(Of Results)
        _Results = New Results()
        _Results.TotalDebt = _Applicant.TotalDebt.ToString("0.00")
        _Results.MinimumPaymentTotalInterestPaid = _TotalAPR.ToString
        _Results.MinimumPaymentTotalAmount = _Applicant.TotalDebt + _TotalAPR
        _Results.NumberOfDebts = _Applicant.NumberOfDebts
        _Results.Months = GetMonths(_CurrentMonth)
        _Results.Years = GetYearsMonths(_CurrentMonth)

        ResultsList.Add(_Results)

        Return ResultsList

    End Function

    Public Sub GetSystemVariables()

        _MinimumPaymentAmount = 0.0
        _MinimumPaymentPercentage = 0.0
        _APR = 0.0

        Dim dt As DataTable = SqlHelper.GetDataTable("stp_GetSystemMinCalculatorRequirements", CommandType.StoredProcedure)
        For Each dr As DataRow In dt.Rows
            Select Case dr("Name").ToString
                Case "EnrollmentPBMAPR"
                    _APR = CDbl(dr("value").ToString)
                Case "EnrollmentPBMMinimum"
                    _MinimumPaymentAmount = CDbl(dr("value").ToString)
                Case "EnrollmentPBMPercentage"
                    _MinimumPaymentPercentage = CDbl(dr("value").ToString)
            End Select
        Next
    End Sub

    Public Overrides Function GetSettlementData() As DataTable
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("TotalDebt", _Applicant.TotalDebt))

        Return SqlHelper.GetDataTable("stp_GetApplicantsSettlementFees", CommandType.StoredProcedure, params.ToArray)
    End Function

#End Region


End Class
