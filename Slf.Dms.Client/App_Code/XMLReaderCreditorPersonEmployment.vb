Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Imports Microsoft.VisualBasic

Public Class XMLReaderCreditorPersonEmployment
    Public Shared Function Read(ByVal XML As String) As List(Of CreditorPersonEmployment)

        Dim xmlDoc As XmlDocument = New XmlDocument()
        xmlDoc.LoadXml(XML.ToString())

        Dim PersonEmploymentList As New List(Of CreditorPersonEmployment)

        Dim addressInfo As XmlNodeList = xmlDoc.GetElementsByTagName("employment_information")

        For i As Integer = 0 To addressInfo.Count - 1
            Dim person As New CreditorPersonEmployment
            person.employer_name = Convert.ToString(addressInfo.Item(i).SelectSingleNode("employer_name").InnerText)
            person.source_indicator = Convert.ToString(addressInfo.Item(i).SelectSingleNode("source_indicator").InnerText)
            person.occupation = Convert.ToString(addressInfo.Item(i).SelectSingleNode("occupation").InnerText)
            person.date_hired = Convert.ToString(addressInfo.Item(i).SelectSingleNode("date_hired").InnerText)
            person.date_separated = Convert.ToString(addressInfo.Item(i).SelectSingleNode("date_separated").InnerText)
            person.date_verified_or_reported = Convert.ToString(addressInfo.Item(i).SelectSingleNode("date_verified_or_reported").InnerText)
            person.date_verified_or_reported_code = Convert.ToString(addressInfo.Item(i).SelectSingleNode("date_verified_or_reported_code").InnerText)
            person.income = Convert.ToString(addressInfo.Item(i).SelectSingleNode("income").InnerText)
            person.pay_basis = Convert.ToString(addressInfo.Item(i).SelectSingleNode("pay_basis").InnerText)
            PersonEmploymentList.Add(person)
        Next


        Return PersonEmploymentList

    End Function
End Class

