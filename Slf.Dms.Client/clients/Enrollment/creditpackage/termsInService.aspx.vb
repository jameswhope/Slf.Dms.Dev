Imports System.Collections.Generic

Partial Class Clients_Enrollment_creditpackage_termsInService
    Inherits System.Web.UI.Page

    Private _LeadApplicant As New LeadNameInfo
    Private _Applicant As New Applicant
    Private _Results As New List(Of Results)
    Private _Results2 As New List(Of Results)
    Private _Calculator As SettlementCalculator
    Private _MinimunPaymentCalculator As SettlementCalculator

    Protected Sub Clients_Enrollment_creditpackage_termsInService_PreLoad(sender As Object, e As System.EventArgs) Handles Me.PreLoad
        'Applicant ID
        Dim ApplicantID As Integer = 0
        ApplicantID = Request.QueryString("aid")

        'Calculate
        _Applicant = New Applicant(ApplicantID)
        _Calculator = SettlementCalculator.Create("SetCalVersion0001")
        _Calculator.Applicant = _Applicant
        _Results = _Calculator.Calculate()

        _MinimunPaymentCalculator = SettlementCalculator.Create("MinimumPaymentVersion0001")
        _MinimunPaymentCalculator.Applicant = _Applicant
        _Results2 = _MinimunPaymentCalculator.Calculate()

        'Assign Values
        AssignValues()
    End Sub

    Protected Sub AssignValues()
        'Header Values
        clientsNames.Text = _Applicant.FirstName + " " + _Applicant.LastName
        LawFirmName.Text = "Thomas Kerns McKnight LLP"
        Address1.Text = _Applicant.Street1
        CityStateZip.Text = _Applicant.City + " " + _Applicant.StateAbbreviation + ", " + _Applicant.ZipCode.ToString

        'Calculator Values
        'Minimum Payment
        TotalDebt.Text = FormatCurrency(_Results2(0).TotalDebt)
        TotalDebt2.Text = FormatCurrency(_Results2(0).TotalDebt)
        TotalInterest.Text = FormatCurrency(_Results2(0).MinimumPaymentTotalInterestPaid)
        TotalPaid.Text = FormatCurrency(_Results2(0).MinimumPaymentTotalAmount)
        MinMonths.Text = _Results2(0).Months
        MinYears.Text = _Results2(0).Years

        TotalNumberOfDebts.Text = _Results2(0).NumberOfDebts

        'Table 1
        One_MonthlyDeposit.Text = FormatCurrency(_Results(0).MonthlyDeposit)

        One_25_SettleAmount.Text = FormatCurrency(_Results(0).SettlementAmount)
        One_50_SettleAmount.Text = FormatCurrency(_Results(1).SettlementAmount)
        One_75_SettleAmount.Text = FormatCurrency(_Results(2).SettlementAmount)
        One_100_SettleAmount.Text = FormatCurrency(_Results(3).SettlementAmount)

        One_25_SettleCost.Text = FormatCurrency(_Results(0).TotalAmountFees)
        One_50_SettleCost.Text = FormatCurrency(_Results(1).TotalAmountFees)
        One_75_SettleCost.Text = FormatCurrency(_Results(2).TotalAmountFees)
        One_100_SettleCost.Text = FormatCurrency(_Results(3).TotalAmountFees)

        One_25_Months.Text = _Results(0).Months
        One_50_Months.Text = _Results(1).Months
        One_75_Months.Text = _Results(2).Months
        One_100_Months.Text = _Results(3).Months

        One_25_Years.Text = _Results(0).Years
        One_50_Years.Text = _Results(1).Years
        One_75_Years.Text = _Results(2).Years
        One_100_Years.Text = _Results(3).Years

        'Table 2
        Two_MonthlyDeposit.Text = FormatCurrency(_Results(5).MonthlyDeposit)

        Two_25_SettleAmount.Text = FormatCurrency(_Results(5).SettlementAmount)
        Two_50_SettleAmount.Text = FormatCurrency(_Results(6).SettlementAmount)
        Two_75_SettleAmount.Text = FormatCurrency(_Results(7).SettlementAmount)
        Two_100_SettleAmount.Text = FormatCurrency(_Results(8).SettlementAmount)

        Two_25_SettleCost.Text = FormatCurrency(_Results(5).TotalAmountFees)
        Two_50_SettleCost.Text = FormatCurrency(_Results(6).TotalAmountFees)
        Two_75_SettleCost.Text = FormatCurrency(_Results(7).TotalAmountFees)
        Two_100_SettleCost.Text = FormatCurrency(_Results(8).TotalAmountFees)

        Two_25_Months.Text = _Results(5).Months
        Two_50_Months.Text = _Results(6).Months
        Two_75_Months.Text = _Results(7).Months
        Two_100_Months.Text = _Results(8).Months

        Two_25_Years.Text = _Results(5).Years
        Two_50_Years.Text = _Results(6).Years
        Two_75_Years.Text = _Results(7).Years
        Two_100_Years.Text = _Results(8).Years

        'Table 3
        Three_MonthlyDeposit.Text = FormatCurrency(_Results(10).MonthlyDeposit)

        Three_25_SettlementAmount.Text = FormatCurrency(_Results(10).SettlementAmount)
        Three_50_SettlementAmount.Text = FormatCurrency(_Results(11).SettlementAmount)
        Three_75_SettlementAmount.Text = FormatCurrency(_Results(12).SettlementAmount)
        Three_100_SettlementAmount.Text = FormatCurrency(_Results(13).SettlementAmount)

        Three_25_SettlementCost.Text = FormatCurrency(_Results(10).TotalAmountFees)
        Three_50_SettlementCost.Text = FormatCurrency(_Results(11).TotalAmountFees)
        Three_75_SettlementCost.Text = FormatCurrency(_Results(12).TotalAmountFees)
        Three_100_SettlementCost.Text = FormatCurrency(_Results(13).TotalAmountFees)

        Three_25_Months.Text = _Results(10).Months
        Three_50_Months.Text = _Results(11).Months
        Three_75_Months.Text = _Results(12).Months
        Three_100_Months.Text = _Results(13).Months

        Three_25_Years.Text = _Results(10).Years
        Three_50_Years.Text = _Results(11).Years
        Three_75_Years.Text = _Results(12).Years
        Three_100_Years.Text = _Results(13).Years
    End Sub
End Class
