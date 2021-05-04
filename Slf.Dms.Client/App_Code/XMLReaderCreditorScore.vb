Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Xml
Imports Microsoft.VisualBasic

Public Class XMLReaderCreditorScore
    Public Shared Function Read(ByVal XML As String) As CreditorScore

        Dim xmlDoc As XmlDocument = New XmlDocument()
        xmlDoc.LoadXml(XML.ToString())

        Dim CreditorScoreList As New CreditorScore

        CreditorScoreList.score_product_code = Convert.ToString(xmlDoc.SelectSingleNode("TU_Report/subject_segments/scoring_segments/scoring/product_code").InnerText)
        CreditorScoreList.score_sign = Convert.ToString(xmlDoc.SelectSingleNode("TU_Report/subject_segments/scoring_segments/scoring/sign").InnerText)
        CreditorScoreList.score_score = Convert.ToString(xmlDoc.SelectSingleNode("TU_Report/subject_segments/scoring_segments/scoring/score").InnerText)
        CreditorScoreList.score_indicator_flag = Convert.ToString(xmlDoc.SelectSingleNode("TU_Report/subject_segments/scoring_segments/scoring/indicator_flag").InnerText)
        CreditorScoreList.score_derogatory_alert_flag = Convert.ToString(xmlDoc.SelectSingleNode("TU_Report/subject_segments/scoring_segments/scoring/derogatory_alert_flag").InnerText)
        CreditorScoreList.score_factor1 = Convert.ToString(xmlDoc.SelectSingleNode("TU_Report/subject_segments/scoring_segments/scoring/factor1").InnerText)
        CreditorScoreList.score_factor2 = Convert.ToString(xmlDoc.SelectSingleNode("TU_Report/subject_segments/scoring_segments/scoring/factor2").InnerText)
        CreditorScoreList.score_factor3 = Convert.ToString(xmlDoc.SelectSingleNode("TU_Report/subject_segments/scoring_segments/scoring/factor3").InnerText)
        CreditorScoreList.score_factor4 = Convert.ToString(xmlDoc.SelectSingleNode("TU_Report/subject_segments/scoring_segments/scoring/factor4").InnerText)
        CreditorScoreList.score_score_card_indicator = Convert.ToString(xmlDoc.SelectSingleNode("TU_Report/subject_segments/scoring_segments/scoring/score_card_indicator").InnerText)

        Return CreditorScoreList
    End Function
End Class