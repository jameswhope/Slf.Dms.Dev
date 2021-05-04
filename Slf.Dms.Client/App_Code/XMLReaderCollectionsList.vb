Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Imports Microsoft.VisualBasic

Public Class XMLReaderCollectionsList
    Public Shared Function Read(ByVal XML As String) As List(Of CreditorAccount)

        Dim xmlDoc As XmlDocument = New XmlDocument()
        xmlDoc.LoadXml(XML.ToString())

        Dim CreditorCollectionsList As New List(Of CreditorAccount)

        Dim tradeInfo As XmlNodeList = xmlDoc.GetElementsByTagName("collection")

        For i As Integer = 0 To tradeInfo.Count - 1
            Dim creditorCollections As New CreditorAccount
            creditorCollections.CreditorName = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("collection_agency_name").InnerText) 'Originally creditors_name. Changed to output agency name (real creditor name)
            creditorCollections.MemberCode = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("member_code").InnerText)
            creditorCollections.AccountType = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("account_type").InnerText)
            creditorCollections.AccountNumber = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("account_number").InnerText)
            creditorCollections.AccountDesignator = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("account_designator").InnerText)
            creditorCollections.DateOpened = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("date_opened").InnerText)
            creditorCollections.DateVerified = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("date_verified").InnerText)
            creditorCollections.TradeVerificationIndicator = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("verification_indicator").InnerText)
            creditorCollections.DateClosed = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("date_closed").InnerText)
            creditorCollections.DateClosedIndicator = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("date_closed_indicator").InnerText)
            creditorCollections.DatePaidOut = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("date_paid_out").InnerText)
            creditorCollections.CollectionAgencyName = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("collection_agency_name").InnerText)
            creditorCollections.CurrentMannerOfPayment = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("current_manner_of_payment").InnerText)
            creditorCollections.TradeBalance = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("current_balance").InnerText)
            creditorCollections.CurrentBalance = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("current_balance").InnerText)
            creditorCollections.OriginalBalance = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("original_balance").InnerText)
            creditorCollections.RemarksCode = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("remarks_code").InnerText)
            creditorCollections.LoanType = Convert.ToString(tradeInfo.Item(i).SelectSingleNode("current_manner_of_payment").InnerText) 'set to fix an error

            CreditorCollectionsList.Add(creditorCollections)
        Next

        Return CreditorCollectionsList
    End Function

End Class
