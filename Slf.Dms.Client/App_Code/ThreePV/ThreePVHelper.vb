Imports Microsoft.VisualBasic
Imports Drg.Util.DataAccess
Imports System.Collections.Generic
Imports System.Security
Imports System.Data
Imports System.Data.SqlClient

'c:\program files\microsoft sdks\windows\v6.0a\bin\svcutil https://www.3pv.net/3pvwebservices/3pvwebservices.asmx /l:vb

Public Class ThreePVHelper

    Public Shared Function SendRequest(ByVal LeadApplicantID As Integer, ByVal CompanyID As Integer, ByVal StateID As Integer, ByVal Name As String, ByVal Phone As String, ByVal SubmittedID As Integer, ByRef AccessNumber As String, ByRef PVN As String, ByVal DraftDate As String, ByVal DraftAmount As String) As Boolean
        Dim client As New ThreePVWebServicesSoapClient
        Dim reqXml As String
        Dim resp As System.Xml.XmlElement
        Dim result As String = ""
        Dim vReq As New verificationRequest
        Dim viList As New List(Of verifyRequestItem)
        Dim vi As New verifyRequestItem()
        Dim BTN As String = Phone.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "")

        vReq.cname = Trim(Name)
        vReq.clientOrder = CStr(LeadApplicantID)
        vReq.centerId = Format(CompanyID, "0#")
        vReq.lawStateCode = Format(StateID, "0#")
        vReq.btn = BTN
        vReq.draftAmount = DraftAmount
        vReq.draftDate = Format(CDate(DraftDate), "M-d-yyyy")

        vi.ANI = BTN
        vi.verifyItem = "DEBT"
        viList.Add(vi)

        vReq.verifyRequestItems = viList.ToArray()
        reqXml = vReq.ToXml

        Try
            resp = client.directXML(reqXml)
            result = resp.Attributes("result").Value
            PVN = resp.Attributes("PVN").Value
            AccessNumber = resp.Attributes("access-number").Value
            LogVerification(LeadApplicantID, PVN, result, AccessNumber, SubmittedID)
        Catch ex As Exception
            PVN = "ERROR"
        End Try

        Return (result = "0")
    End Function

    Public Shared Sub SaveConfNum(ByVal leadApplicantID As Integer, ByVal pvn As String, ByVal confNum As String)
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        Dim criteria As String = String.Format("LeadApplicantID={0} and PVN='{1}'", leadApplicantID, pvn)

        DatabaseHelper.AddParameter(cmd, "ConfNum", confNum)
        DatabaseHelper.AddParameter(cmd, "ConfEntered", Now)
        DatabaseHelper.BuildUpdateCommandText(cmd, "tblLeadVerification", criteria)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Private Shared Sub LogVerification(ByVal LeadApplicantID As Integer, ByVal PVN As String, ByVal Result As String, ByVal AccessNumber As String, ByVal SubmittedBy As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "LeadApplicantID", LeadApplicantID)
        DatabaseHelper.AddParameter(cmd, "PVN", PVN)
        DatabaseHelper.AddParameter(cmd, "VDate", Format(Now, "yyyyMMdd"))
        DatabaseHelper.AddParameter(cmd, "Result", Result)
        DatabaseHelper.AddParameter(cmd, "AccessNumber", AccessNumber)
        DatabaseHelper.AddParameter(cmd, "SubmittedBy", SubmittedBy)
        DatabaseHelper.BuildInsertCommandText(cmd, "tblLeadVerification", "LeadVerificationID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

End Class

