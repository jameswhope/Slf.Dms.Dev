Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Imports Microsoft.VisualBasic

Public Class XMLReaderCreditorAccountList
    Public Shared Function Read(ByVal XML As String) As List(Of CreditorAccount)

        Dim xmlDoc As XmlDocument = New XmlDocument()
        xmlDoc.LoadXml(XML.ToString())

        Dim CreditorAccountList As New List(Of CreditorAccount)

        Dim tradeInfo As XmlNodeList = xmlDoc.GetElementsByTagName("trade")

        For i As Integer = 0 To tradeInfo.Count - 1
            Dim creditorAccount As New CreditorAccount
            creditorAccount.CreditorName = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("subscriber_name").InnerText)
            creditorAccount.MemberCode = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("member_code").InnerText)
            creditorAccount.AccountType = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("account_type").InnerText)
            creditorAccount.AccountNumber = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("account_number").InnerText)
            creditorAccount.AccountDesignator = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("account_designator").InnerText)
            creditorAccount.DateOpened = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("date_opened").InnerText)
            creditorAccount.DateVerified = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("date_verified").InnerText)
            creditorAccount.TradeVerificationIndicator = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("trade_verification_indicator").InnerText)
            creditorAccount.DateClosed = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("date_closed").InnerText)
            creditorAccount.DateClosedIndicator = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("date_closed_indicator").InnerText)
            creditorAccount.DatePaidOut = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("date_paid_out").InnerText)
            creditorAccount.DateOfLastActivity = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("date_of_last_activity").InnerText)
            creditorAccount.CurrentMannerOfPayment = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("current_manner_of_payment").InnerText)
            creditorAccount.Currency = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("currency").InnerText)
            creditorAccount.TradeBalance = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("balance").InnerText)
            creditorAccount.TradeHighCredit = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("high_credit").InnerText)
            creditorAccount.TradeCreditLimit = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("credit_limit").InnerText)
            creditorAccount.TermsDuration = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("terms_duration").InnerText)
            creditorAccount.TermsFrequency = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("terms_frequency").InnerText)
            creditorAccount.AmountOfPayment = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("amount_of_payment").InnerText)
            creditorAccount.Collateral = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("collateral").InnerText)
            creditorAccount.LoanType = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("loan_type").InnerText)
            creditorAccount.RemarksCode = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("remarks_code").InnerText)
            creditorAccount.TradeAmountPastDue = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("amount_past_due").InnerText)
            creditorAccount.NumberOfPaymentsPastDue = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("number_payments_past_due").InnerText)
            creditorAccount.MaxDelinquencyAmount = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("max_delinquency_amount").InnerText)
            creditorAccount.MaxDelinquencyDate = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("max_delinquency_date").InnerText)
            creditorAccount.MaxDelinquencyMOP = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("max_delinquency_MOP").InnerText)
            creditorAccount.PaymentPatternStartDate = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("payment_pattern_start_date").InnerText)
            creditorAccount.PaymentPattern = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("payment_pattern").InnerText)
            creditorAccount.NumberMonthsReviewed = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("number_months_reviewed").InnerText)
            creditorAccount.Times30DaysLate = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("times_30_days_late").InnerText)
            creditorAccount.Times60DaysLate = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("times_60_days_late").InnerText)
            creditorAccount.Times90DaysLate = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("times_90_days_late").InnerText)
            creditorAccount.HistoricalCountersVerificationIndicator = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("historical_counters_verification_indicator").InnerText)
            CreditorAccountList.Add(creditorAccount)

        Next

        Return CreditorAccountList
    End Function
End Class
