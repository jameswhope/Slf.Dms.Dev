Imports System.Data
Imports System.Net
Imports System.IO
Imports System.Data.SqlClient
Imports System.Xml

Public Class CredStarHelper

    Const VersionID As String = "2.3.1"
    Const LoginId As String = "kparkerson"
    Const LoginPwd As String = "welcome1"
    Const InternalAccountId As String = "600000102"
    Const SubmittingParty As String = "Lexxiom"
    Const RequestUri As String = "https://client.credstar.com/wsmismo/MismoBankruptcyService.aspx"
    'Const LoginId As String = "lexxiomTest"
    'Const LoginPwd As String = "pass9876"
    'Const InternalAccountId As String = "600000102"
    'Const SubmittingParty As String = "EZFiling"
    'Const RequestUri As String = "https://client.staging.credstar.com/wsmismo/MismoBankruptcyService.aspx"

    Private Enum CreditReportType
        Merge
        Other
    End Enum

    Public Structure Question
        Public Line As String
        Public Choices As Collections.Generic.Dictionary(Of String, String)
    End Structure

    Private Enum AccountType
        Mortgage
        Revolving
        Installment
    End Enum

    Private Enum AccountStatus
        Open
        Closed
        Paid
    End Enum

    Private Enum CreditLoanType
        VeteransAdministrationRealEstateMortgage
        CreditLineSecured
        Automobile
        UnknownLoanType
        CreditCard
        ChargeAccount
        Unsecured
        Other
        InstallmentSalesContract
        Lease
        Secured
    End Enum

    Public Shared Function CreditRequest(ByVal LeadApplicantID As Integer, ByRef CreditReportId As String) As Collections.Generic.Dictionary(Of String, Question)
        Dim sw As New StringWriter
        Dim writer As New XmlTextWriter(sw)
        Dim borrowers As Collections.Generic.Dictionary(Of String, Borrower) = GetBorrowerCollection(LeadApplicantID)

        StartRequest(writer)
        StartRequestData(writer, borrowers, CreditReportType.Merge)
        EndRequest(writer)

        Dim xmlDoc As XmlDocument = SendRequest(writer, sw)
        Dim keyNodes As XmlNodeList = xmlDoc.SelectNodes("/RESPONSE_GROUP/RESPONSE/KEY")
        Dim responseNode As XmlNode = xmlDoc.SelectSingleNode("/RESPONSE_GROUP/RESPONSE/RESPONSE_DATA/CREDIT_RESPONSE")
        Dim questions As New Collections.Generic.Dictionary(Of String, Question)
        Dim question As Question
        Dim q As Question
        Dim CreditQuestionID As Integer
        Dim i As Integer = 1

        For Each node As XmlNode In keyNodes
            Dim _name() As String = node.Attributes.GetNamedItem("_Name").Value.Split(",")
            Dim _value As String = node.Attributes.GetNamedItem("_Value").Value

            If questions.ContainsKey(_name(0)) Then
                q = questions.Item(_name(0))
                If _name(1).Contains("line") Then
                    q.Line &= " " & _value
                Else
                    Dim choice() As String = Trim(_name(1)).Split(" ")
                    q.Choices.Add(choice(1), _value)
                End If
                questions.Item(_name(0)) = q
            Else
                question = New Question
                question.Line = _value
                question.Choices = New Collections.Generic.Dictionary(Of String, String)
                questions.Add(_name(0), question)
            End If
        Next

        If Not responseNode.Attributes.GetNamedItem("CreditReportIdentifier") Is Nothing Then
            CreditReportId = responseNode.Attributes.GetNamedItem("CreditReportIdentifier").Value

            For Each qstn In questions
                CreditQuestionID = SaveQuestion(CreditReportId, qstn.Value.Line, i)
                For Each choice In qstn.Value.Choices
                    SaveChoice(CreditQuestionID, choice.Value, CInt(choice.Key))
                Next
                i += 1
            Next
        Else
            Dim errorNode As XmlNode = responseNode.SelectSingleNode("CREDIT_ERROR_MESSAGE/_Text")
            CreditReportId = "<font color='red'>" & errorNode.InnerText & "</font>"
        End If

        Return questions
    End Function

    Public Shared Function AuthenticationAnswers(ByVal LeadApplicantID As Integer, ByVal Answers As Collections.Generic.Dictionary(Of String, String), ByVal CreditReportId As String, ByRef ErrorMessage As String, ByVal RequestBy As Integer) As Integer
        Dim sw As New StringWriter
        Dim writer As New XmlTextWriter(sw)
        Dim seq As Integer = 1
        Dim borrowers As Collections.Generic.Dictionary(Of String, Borrower) = GetBorrowerCollection(LeadApplicantID)

        StartRequest(writer, True)

        For Each answer In Answers
            With writer
                .WriteStartElement("KEY")
                .WriteAttributeString("_Name", answer.Key)
                .WriteAttributeString("_Value", answer.Value)
                .WriteEndElement() 'KEY
            End With
            SaveAnswer(CreditReportId, seq, CInt(answer.Value))
            seq += 1
        Next

        StartRequestData(writer, borrowers, CreditReportType.Other, CreditReportId)
        EndRequest(writer)

        Dim xmlDoc As XmlDocument = SendRequest(writer, sw)
        Dim liabilityNodes As XmlNodeList = xmlDoc.SelectNodes("/RESPONSE_GROUP/RESPONSE/RESPONSE_DATA/CREDIT_RESPONSE/CREDIT_LIABILITY")
        Dim creditorNode As XmlNode
        Dim contactNode As XmlNode
        Dim lateNode As XmlNode
        Dim tblCreditors As New DataTable
        Dim row As DataRow

        'Save xml file
        Try
            Dim xmlPath As String = ConfigurationManager.AppSettings("LeadDocumentsDir").ToString & String.Format("xml\{0}.xml", CreditReportId)
            xmlDoc.Save(xmlPath)
        Catch ex As Exception
            'do nothing
        End Try

        With tblCreditors
            .Columns.Add("CreditorName", GetType(System.String))
            .Columns.Add("Street", GetType(System.String))
            .Columns.Add("City", GetType(System.String))
            .Columns.Add("StateCode", GetType(System.String))
            .Columns.Add("PostalCode", GetType(System.String))
            .Columns.Add("Contact", GetType(System.String))
            .Columns.Add("BorrowerID", GetType(System.String))
            .Columns.Add("AccountNumber", GetType(System.String))
            .Columns.Add("AccountType", GetType(System.String))
            .Columns.Add("AccountStatus", GetType(System.String))
            .Columns.Add("LoanType", GetType(System.String))
            .Columns.Add("UnpaidBalance", GetType(System.Int32))
            .Columns.Add("MonthlyPayment", GetType(System.Int32))
            .Columns.Add("LateThirtyDays", GetType(System.Int32))
            .Columns.Add("LateSixtyDays", GetType(System.Int32))
            .Columns.Add("LateNinetyDays", GetType(System.Int32))
            .Columns.Add("LateOneTwentyDays", GetType(System.Int32))
            .Columns.Add("OriginalCreditor", GetType(System.String))
            .Columns.Add("Opened", GetType(System.String))
            .Columns.Add("HighCredit", GetType(System.Int32))
            .Columns.Add("AccountOwnershipType", GetType(System.String))
        End With

        If liabilityNodes.Count = 0 Then
            Dim errorNode As XmlNode = xmlDoc.SelectSingleNode("/RESPONSE_GROUP/RESPONSE/RESPONSE_DATA/CREDIT_RESPONSE/CREDIT_ERROR_MESSAGE/_Text")
            If Not IsNothing(errorNode) Then
                ErrorMessage = errorNode.InnerText
                Return -1
            End If
        End If

        For Each liabilityNode As XmlNode In liabilityNodes
            row = tblCreditors.NewRow

            Dim borrowerIDs() As String = liabilityNode.Attributes.GetNamedItem("BorrowerID").Value.Split(" ")
            row("BorrowerID") = borrowerIDs(0) 'on joint accounts, account owner could be both. only associate with the primary

            If Not IsNothing(liabilityNode.Attributes.GetNamedItem("_MonthlyPaymentAmount")) Then
                row("MonthlyPayment") = liabilityNode.Attributes.GetNamedItem("_MonthlyPaymentAmount").Value
            End If
            If Not IsNothing(liabilityNode.Attributes.GetNamedItem("_UnpaidBalanceAmount")) Then
                row("UnpaidBalance") = liabilityNode.Attributes.GetNamedItem("_UnpaidBalanceAmount").Value
            End If
            row("AccountNumber") = liabilityNode.Attributes.GetNamedItem("_AccountIdentifier").Value
            row("AccountStatus") = liabilityNode.Attributes.GetNamedItem("_AccountStatusType").Value
            row("AccountType") = liabilityNode.Attributes.GetNamedItem("_AccountType").Value
            row("LoanType") = liabilityNode.Attributes.GetNamedItem("CreditLoanType").Value.Replace("VeteransAdministrationRealEstateMortgage", "Mortgage")
            If Not IsNothing(liabilityNode.Attributes.GetNamedItem("_AccountOpenedDate")) Then
                If IsDate(liabilityNode.Attributes.GetNamedItem("_AccountOpenedDate").Value) Then
                    row("Opened") = Format(CDate(liabilityNode.Attributes.GetNamedItem("_AccountOpenedDate").Value), "M/d/yyyy")
                Else
                    row("Opened") = "1/1/1900"
                End If
            Else
                row("Opened") = "1/1/1900"
            End If
            If Not IsNothing(liabilityNode.Attributes.GetNamedItem("_HighCreditAmount")) Then
                row("HighCredit") = liabilityNode.Attributes.GetNamedItem("_HighCreditAmount").Value
            Else
                row("HighCredit") = "0"
            End If
            If Not IsNothing(liabilityNode.Attributes.GetNamedItem("_OriginalCreditorName")) Then
                row("OriginalCreditor") = StrConv(liabilityNode.Attributes.GetNamedItem("_OriginalCreditorName").Value, VbStrConv.ProperCase)
            End If
            If Not IsNothing(liabilityNode.Attributes.GetNamedItem("_AccountOwnershipType")) Then
                row("AccountOwnershipType") = liabilityNode.Attributes.GetNamedItem("_AccountOwnershipType").Value
            End If

            creditorNode = liabilityNode.SelectSingleNode("_CREDITOR")
            row("CreditorName") = StrConv(creditorNode.Attributes.GetNamedItem("_Name").Value, VbStrConv.ProperCase)
            row("Street") = StrConv(creditorNode.Attributes.GetNamedItem("_StreetAddress").Value, VbStrConv.ProperCase)
            row("City") = StrConv(creditorNode.Attributes.GetNamedItem("_City").Value, VbStrConv.ProperCase)
            row("StateCode") = creditorNode.Attributes.GetNamedItem("_State").Value
            row("PostalCode") = creditorNode.Attributes.GetNamedItem("_PostalCode").Value

            contactNode = creditorNode.SelectSingleNode("CONTACT_DETAIL/CONTACT_POINT")
            If Not contactNode Is Nothing Then
                If Not contactNode.Attributes.GetNamedItem("_Value") Is Nothing Then
                    row("Contact") = contactNode.Attributes.GetNamedItem("_Value").Value
                End If
            End If

            lateNode = liabilityNode.SelectSingleNode("_LATE_COUNT")
            If Not lateNode Is Nothing Then
                row("LateThirtyDays") = lateNode.Attributes.GetNamedItem("_30Days").Value
                row("LateSixtyDays") = lateNode.Attributes.GetNamedItem("_60Days").Value
                row("LateNinetyDays") = lateNode.Attributes.GetNamedItem("_90Days").Value
                row("LateOneTwentyDays") = lateNode.Attributes.GetNamedItem("_120Days").Value
            End If

            tblCreditors.Rows.Add(row)
        Next

        Dim reportID As Integer = SaveCreditReport(CreditReportId, RequestBy)
        Dim scoreNodes As XmlNodeList = xmlDoc.SelectNodes("/RESPONSE_GROUP/RESPONSE/RESPONSE_DATA/CREDIT_RESPONSE/CREDIT_SCORE")
        Dim borrower As Borrower
        Dim sourceType As String

        For Each scoreNode As XmlNode In scoreNodes
            borrower = borrowers.Item(scoreNode.Attributes.GetNamedItem("BorrowerID").Value)
            If Not scoreNode.Attributes.GetNamedItem("_Value") Is Nothing Then
                sourceType = scoreNode.Attributes.GetNamedItem("CreditRepositorySourceType").Value
                Select Case sourceType
                    Case "Experian"
                        borrower.Experian = CInt(scoreNode.Attributes.GetNamedItem("_Value").Value)
                    Case "TransUnion"
                        borrower.TransUnion = CInt(scoreNode.Attributes.GetNamedItem("_Value").Value)
                    Case Else 'Equifax
                        borrower.Equifax = CInt(scoreNode.Attributes.GetNamedItem("_Value").Value)
                End Select
            End If
        Next

        SaveCreditSource(reportID, borrowers)
        SaveCreditLiabilities(reportID, tblCreditors, borrowers)

        'Save Employers
        Try
            Dim borrowerNodes As XmlNodeList = xmlDoc.SelectNodes("/RESPONSE_GROUP/RESPONSE/RESPONSE_DATA/CREDIT_RESPONSE/BORROWER")
            Dim employerNodes As XmlNodeList
            Dim sql As String
            Dim reportedDate As String

            For Each borrowerNode As XmlNode In borrowerNodes
                borrower = borrowers.Item(borrowerNode.Attributes.GetNamedItem("BorrowerID").Value)
                employerNodes = borrowerNode.SelectNodes("EMPLOYER")
                For Each employerNode As XmlNode In employerNodes
                    If Len(employerNode.Attributes.GetNamedItem("EmploymentReportedDate").Value) = 8 Then
                        reportedDate = Left(employerNode.Attributes.GetNamedItem("EmploymentReportedDate").Value, 4) & "-" & Mid(employerNode.Attributes.GetNamedItem("EmploymentReportedDate").Value, 5, 2) & "-" & Right(employerNode.Attributes.GetNamedItem("EmploymentReportedDate").Value, 2)
                    Else
                        reportedDate = "1900-01-01"
                    End If
                    sql = String.Format("insert tblCreditEmployer (creditsourceid,employer,streetaddress,selfemployed,employmentreporteddate) values ({0},'{1}','{2}','{3}','{4}')", borrower.CreditSourceID, employerNode.Attributes.GetNamedItem("_Name").Value, employerNode.Attributes.GetNamedItem("_StreetAddress").Value, employerNode.Attributes.GetNamedItem("EmploymentBorrowerSelfEmployedIndicator").Value, reportedDate)
                    SqlHelper.ExecuteNonQuery(sql, CommandType.Text)
                Next
            Next
        Catch ex As Exception
            'do nothing
        End Try

        'Credit Inquiries
        Try
            Dim inquiryNodes As XmlNodeList = xmlDoc.SelectNodes("/RESPONSE_GROUP/RESPONSE/RESPONSE_DATA/CREDIT_RESPONSE/CREDIT_INQUIRY")
            Dim sql As String
            Dim inquiryDate As String

            For Each inquiryNode As XmlNode In inquiryNodes
                borrower = borrowers.Item(inquiryNode.Attributes.GetNamedItem("BorrowerID").Value)
                If Len(inquiryNode.Attributes.GetNamedItem("_Date").Value) = 8 Then
                    inquiryDate = inquiryNode.Attributes.GetNamedItem("_Date").Value
                Else
                    inquiryDate = "1900-01-01"
                End If
                sql = String.Format("insert tblCreditInquiry (CreditSourceID,MadeBy,InquiryDate) values ({0},'{1}','{2}')", borrower.CreditSourceID, inquiryNode.Attributes.GetNamedItem("_Name").Value, inquiryDate)
                SqlHelper.ExecuteNonQuery(sql, CommandType.Text)
            Next
        Catch ex As Exception
            'do nothing
        End Try

        Dim documentNode As XmlNode = xmlDoc.SelectSingleNode("/RESPONSE_GROUP/RESPONSE/RESPONSE_DATA/CREDIT_RESPONSE/EMBEDDED_FILE/DOCUMENT")
        Dim cdataNode As XmlNode = documentNode.FirstChild

        If Not cdataNode.Value.Contains("<html>") Then
            Dim bytes() As Byte = System.Convert.FromBase64String(cdataNode.Value)
            Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir").ToString & String.Format("{0}.pdf", CreditReportId)
            Dim fs As New IO.FileStream(path, IO.FileMode.Create)
            fs.Write(bytes, 0, bytes.Length - 1)
            fs.Close()
            SmartDebtorHelper.SaveLeadDocument(LeadApplicantID, CreditReportId, RequestBy, SmartDebtorHelper.DocType.CreditReport)
        End If

        Return reportID
    End Function

    Public Shared Sub ImportCreditLiability(ByVal CreditLiabilityID As Integer, ByVal LeadApplicantID As Integer, ByVal ImportedBy As Integer, ByVal represented As Boolean, ByVal AccountNumber As String, ByVal IntRate As String, ByVal MinPmt As String)
        Dim params(6) As SqlParameter
        params(0) = New SqlParameter("CreditLiabilityID", CreditLiabilityID)
        params(1) = New SqlParameter("LeadApplicantID", LeadApplicantID)
        params(2) = New SqlParameter("ImportedBy", ImportedBy)
        params(3) = New SqlParameter("Represented", represented)
        params(4) = New SqlParameter("AccountNumber", AccountNumber)
        params(5) = New SqlParameter("IntRate", IntRate)
        params(6) = New SqlParameter("MinPmt", MinPmt)
        SqlHelper.ExecuteNonQuery("stp_ImportCreditLiability", CommandType.StoredProcedure, params)
    End Sub

    Public Shared Function GetFilteredCreditLiabilities(ByVal ReportID As Integer) As DataTable
        Dim params(0) As SqlParameter
        params(0) = New SqlParameter("ReportID", ReportID)
        Return SqlHelper.GetDataTable("stp_GetFilteredCreditLiabilities", CommandType.StoredProcedure, params)
    End Function

    Private Shared Sub StartRequest(ByRef writer As XmlWriter, Optional ByVal bAddPreferredResponse As Boolean = False)
        With writer
            .WriteStartDocument()
            .WriteStartElement("REQUEST_GROUP")
            .WriteAttributeString("MISMOVersionID", VersionID)

            .WriteStartElement("REQUESTING_PARTY")
            .WriteAttributeString("_Name", "Lexxiom") 'Test Law Firm
            .WriteAttributeString("_StreetAddress", "11690 Pacific Avenue") 'PO Box 32 1400 Main St
            .WriteAttributeString("_City", "Fontana") 'Barrington
            .WriteAttributeString("_State", "CA") 'IL
            .WriteAttributeString("_PostalCode", "92337-0000") '60010-0000
            If bAddPreferredResponse Then
                .WriteStartElement("PREFERRED_RESPONSE")
                .WriteAttributeString("_Format", "PDF")
                .WriteEndElement() 'PREFERRED_RESPONSE
            End If
            .WriteEndElement() 'REQUESTING_PARTY

            .WriteStartElement("SUBMITTING_PARTY")
            .WriteAttributeString("_Name", SubmittingParty)
            .WriteEndElement() 'SUBMITTING_PARTY

            .WriteStartElement("REQUEST")
            .WriteAttributeString("RequestDatetime", Format(Now, "yyyy-mm-ddThh:mm:ss"))
            .WriteAttributeString("InternalAccountIdentifier", InternalAccountId)
            .WriteAttributeString("LoginAccountIdentifier", LoginId)
            .WriteAttributeString("LoginAccountPassword", LoginPwd)
        End With
    End Sub

    Private Shared Sub EndRequest(ByRef writer As XmlWriter)
        With writer
            .WriteEndElement() 'REQUEST
            .WriteEndElement() 'REQUEST_GROUP
        End With
    End Sub

    Private Shared Function SendRequest(ByVal writer As XmlWriter, ByVal sw As StringWriter) As XmlDocument
        Dim req As HttpWebRequest = WebRequest.Create(requestUri)
        Dim xml As String

        writer.Flush()
        xml = sw.ToString
        xml = xml.Replace("utf-16", "utf-8")
        writer.Close()
        sw.Close()

        req.Method = "POST"
        req.ContentType = "text/xml"

        Dim sw2 As New StreamWriter(req.GetRequestStream)
        sw2.Write(xml)
        sw2.Close()

        Dim resp As HttpWebResponse = req.GetResponse
        Dim sr As New StreamReader(resp.GetResponseStream)
        Dim results As String = sr.ReadToEnd
        sr.Close()
        Dim xmlDoc As New System.Xml.XmlDocument
        xmlDoc.LoadXml(results)

        Return xmlDoc
    End Function

    Private Shared Sub StartRequestData(ByRef writer As XmlWriter, ByVal borrowers As Collections.Generic.Dictionary(Of String, Borrower), ByVal reportType As CreditReportType, Optional ByVal CreditReportId As String = "")
        With writer
            .WriteStartElement("REQUEST_DATA")

            .WriteStartElement("CREDIT_REQUEST")
            .WriteAttributeString("MISMOVersionID", VersionID)

            .WriteStartElement("CREDIT_REQUEST_DATA")
            .WriteAttributeString("CreditReportRequestActionType", "Submit")
            .WriteAttributeString("CreditReportType", [Enum].GetName(GetType(CreditReportType), reportType))
            If borrowers.Count > 1 Then
                .WriteAttributeString("CreditRequestType", "Joint")
            Else
                .WriteAttributeString("CreditRequestType", "Individual")
            End If
            Select Case reportType
                Case CreditReportType.Merge
                    .WriteAttributeString("CreditReportProductDescription", "3 Bureau Merge")
                    .WriteAttributeString("CreditReportTypeOtherDescription", "")
                Case CreditReportType.Other
                    .WriteAttributeString("CreditReportTypeOtherDescription", "Authentication Answers")
                    .WriteAttributeString("CreditReportIdentifier", CreditReportId)
            End Select

            If reportType = CreditReportType.Merge Then
                .WriteStartElement("CREDIT_REPOSITORY_INCLUDED")
                .WriteAttributeString("_EquifaxIndicator", "Y")
                .WriteAttributeString("_ExperianIndicator", "Y")
                .WriteAttributeString("_TransUnionIndicator", "Y")
                .WriteEndElement() 'CREDIT_REPOSITORY_INCLUDED
            End If

            .WriteEndElement() 'CREDIT_REQUEST_DATA

            .WriteStartElement("LOAN_APPLICATION")

            For Each bwr In borrowers
                .WriteStartElement("BORROWER")
                .WriteAttributeString("BorrowerID", bwr.Value.SSN)
                .WriteAttributeString("_FirstName", bwr.Value.FirstName)
                .WriteAttributeString("_LastName", bwr.Value.LastName)
                .WriteAttributeString("_SSN", bwr.Value.SSN)

                .WriteStartElement("_RESIDENCE")
                .WriteAttributeString("_StreetAddress", bwr.Value.Street)
                .WriteAttributeString("_City", bwr.Value.City)
                .WriteAttributeString("_State", bwr.Value.State)
                .WriteAttributeString("_PostalCode", bwr.Value.PostalCode)
                .WriteAttributeString("BorrowerResidencyType", "Current")
                .WriteEndElement() '_RESIDENCE

                .WriteEndElement() 'BORROWER
            Next

            .WriteEndElement() 'LOAN_APPLICATION
            .WriteEndElement() 'CREDIT_REQUEST
            .WriteEndElement() 'REQUEST_DATA
        End With
    End Sub

    Public Shared Function SaveCreditReport(ByVal CreditReportId As String, ByVal RequestBy As Integer) As Integer
        Dim cmdText As String = String.Format("insert tblCreditReport (CreditReportId,RequestBy) values ('{0}',{1}) select scope_identity()", CreditReportId, RequestBy)
        Return CInt(SqlHelper.ExecuteScalar(cmdText, CommandType.Text))
    End Function

    Public Shared Sub SaveCreditSource(ByVal ReportID As Integer, ByRef borrower As Borrower)
        Dim cmdText As String
        cmdText = String.Format("insert tblCreditSource (ReportID,SSN,FirstName,LastName,Equifax,TransUnion,Experian,CoBorrower,CreditSource,xmlfile,filehitindicator,flags) values ({0},'{1}','{2}','{3}',{4},{5},{6},'{7}','{8}','{9}','{10}',{11}) select scope_identity()", ReportID, borrower.SSN.Replace("-", ""), borrower.FirstName, borrower.LastName, borrower.Equifax, borrower.TransUnion, borrower.Experian, IIf(borrower.CoApp, 1, 0), borrower.CreditSource, borrower.LastXMLFileName, borrower.FileHitIndicator, borrower.DataFlags)
        borrower.CreditSourceID = CInt(SqlHelper.ExecuteScalar(cmdText, CommandType.Text))
     End Sub

    Public Shared Sub SaveCreditSource(ByVal ReportID As Integer, ByRef Borrowers As Collections.Generic.Dictionary(Of String, Borrower))
        For Each bwr In Borrowers
            CredStarHelper.SaveCreditSource(ReportID, bwr.Value)
        Next
    End Sub

    Public Shared Sub SaveCreditLiabilities(ByVal ReportID As Integer, ByVal creditor As DataRow, ByVal CreditSourceId As Integer)
        Dim cmdText As New Text.StringBuilder
        Dim creditLiabilityLookupId As Integer
        Dim params(5) As SqlParameter
        Dim value As String

        For i As Integer = 0 To 5
            Select Case creditor.Table.Columns(i).ColumnName
                Case "CreditorName"
                    If creditor(i).ToString.Contains(" (or") Then
                        value = Left(creditor(i), creditor(i).ToString.IndexOf(" (or"))
                    Else
                        value = creditor(i).ToString
                    End If
                Case "Street"
                    value = creditor(i).ToString.Replace("PO BOX", "P.O. Box").Replace("POB", "P.O. Box")
                Case Else
                    value = creditor(i).ToString
            End Select
            If creditor.Table.Columns(i).DataType Is GetType(System.String) AndAlso Not creditor(i) Is DBNull.Value Then
                value = CredStarHelper2.CleanupText(value)
            End If
            params(i) = New SqlParameter(creditor.Table.Columns(i).ColumnName, value)
        Next

        creditLiabilityLookupId = CInt(SqlHelper.ExecuteScalar("stp_SaveCreditLiabilityLookup", , params))

        If CredStarHelper2.CreditorExists(ReportID, creditor, creditLiabilityLookupId) Then
            Exit Sub
        End If

        cmdText.Append("insert tblCreditLiability (ReportID,CreditSourceID,CreditLiabilityLookupID")
        For i As Integer = 7 To creditor.Table.Columns.Count - 3
            cmdText.Append("," & creditor.Table.Columns(i).ColumnName)
        Next
        cmdText.Append(") ")
        cmdText.Append("values (" & ReportID & "," & CreditSourceId & "," & creditLiabilityLookupId)
        For i As Integer = 7 To creditor.Table.Columns.Count - 3
            Select Case True
                Case creditor.Table.Columns(i).DataType Is GetType(System.String)
                    If creditor(i) Is DBNull.Value Then creditor(i) = ""
                    cmdText.Append(",'" & CredStarHelper2.CleanupText(creditor(i)) & "'")
                Case Else
                    If creditor(i) Is DBNull.Value Then creditor(i) = 0
                    cmdText.Append(", " & creditor(i))
            End Select
        Next
        cmdText.Append(") ")

        SqlHelper.ExecuteNonQuery(cmdText.ToString, CommandType.Text)
    End Sub

    Public Shared Sub SaveCreditLiabilities(ByVal ReportID As Integer, ByVal tblCreditors As DataTable, ByVal Borrowers As Collections.Generic.Dictionary(Of String, Borrower))
        For Each row As DataRow In tblCreditors.Rows
            CredStarHelper.SaveCreditLiabilities(ReportID, row, Borrowers.Item(row("BorrowerID")).CreditSourceID)
        Next
    End Sub

    Public Shared Sub UpdateCreditLiabilityLookup(ByVal CreditLiabilityLookupID As Integer, ByVal CreditorID As Integer)
        Dim cmdText As String = String.Format("update tblCreditLiabilityLookup set CreditorID={0}, CreditorIdUpdated=getdate() where CreditLiabilityLookupID={1}", CreditorID, CreditLiabilityLookupID)
        SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
    End Sub

    Private Shared Function SaveQuestion(ByVal CreditReportId As String, ByVal Question As String, ByVal Seq As Integer) As Integer
        Dim cmdText As String = String.Format("insert tblCreditQuestions (CreditReportId,Question,Seq) values ('{0}','{1}',{2}) select scope_identity()", CreditReportId, Question.Replace("'", "''"), Seq)
        Return CInt(SqlHelper.ExecuteScalar(cmdText, CommandType.Text))
    End Function

    Private Shared Sub SaveChoice(ByVal CreditQuestionID As Integer, ByVal Value As String, ByVal Choice As Integer)
        Dim cmdText As String = String.Format("insert tblCreditAnswers (CreditQuestionID,Value,Choice) values ({0},'{1}',{2})", CreditQuestionID, Value.Replace("'", "''"), Choice)
        SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
    End Sub

    Private Shared Sub SaveAnswer(ByVal CreditReportId As String, ByVal Seq As Integer, ByVal Answer As Integer)
        Dim cmdText As String = String.Format("update tblCreditQuestions set Answer={0} where CreditReportID='{1}' and Seq={2}", Answer, CreditReportId, Seq)
        SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
    End Sub

    Public Shared Function ValidateBorrowers(ByVal LeadApplicantID As Integer, ByRef InvalidBorrowers As String) As Boolean
        Dim tblBorrowers As DataTable = GetBorrowers(LeadApplicantID)
        Dim isValid As Boolean = True

        For Each row As DataRow In tblBorrowers.Rows
            If row("address").ToString.Trim.Length < 4 _
                    Or row("city").ToString.Trim.Length = 0 _
                        Or row("state").ToString.Length = 0 _
                            Or row("zipcode").ToString.Replace("-", "").Trim.Length < 5 _
                                Or row("ssn").ToString.Replace("-", "").Trim.Length <> 9 Then
                If Len(InvalidBorrowers) > 0 Then
                    InvalidBorrowers &= ", " & row("firstname") & " " & row("lastname")
                Else
                    InvalidBorrowers = row("firstname") & " " & row("lastname")
                End If

                isValid = False
            End If
        Next

        If tblBorrowers.Rows.Count = 0 Then
            isValid = False
        End If

        Return isValid
    End Function

    Public Shared Function GetBorrowerCollection(ByVal LeadApplicantID As Integer) As Collections.Generic.Dictionary(Of String, Borrower)
        Dim tblBorrowers As DataTable = GetBorrowers(LeadApplicantID)
        Dim borrowers As New Collections.Generic.Dictionary(Of String, Borrower)
        Dim borrower As Borrower

        For Each row As DataRow In tblBorrowers.Rows
            borrower = New Borrower
            borrower.FirstName = row("firstname").ToString.Replace("'", "")
            borrower.LastName = row("lastname").ToString.Replace("'", "")
            borrower.Street = row("address")
            borrower.City = row("city")
            borrower.State = row("state")
            borrower.PostalCode = row("zipcode")
            borrower.SSN = row("ssn").ToString.Replace("-", "")
            borrower.CoApp = (CInt(row("seq")) > 1)
            borrower.CreditScore = 0
            borrower.CreditSource = ""
            borrower.Equifax = 0
            borrower.Experian = 0
            borrower.TransUnion = 0
            borrowers.Add(row("ssn").ToString.Replace("-", ""), borrower)
        Next

        Return borrowers
    End Function

    Public Shared Function GetBorrowers(ByVal LeadApplicantID As Integer) As DataTable
        Dim params(0) As SqlParameter
        params(0) = New SqlParameter("LeadApplicantID", LeadApplicantID)
        Return SqlHelper.GetDataTable("stp_GetLeadBorrowers", CommandType.StoredProcedure, params)
    End Function
End Class

Public Class Borrower

    Private _FirstName As String
    Private _LastName As String
    Private _Street As String
    Private _City As String
    Private _State As String
    Private _PostalCode As String
    Private _SSN As String
    Private _CoApp As Boolean
    Private _CreditScore As Integer
    Private _CreditSource As String
    Private _CreditSourceID As Integer
    Private _Equifax As Integer
    Private _Experian As Integer
    Private _TransUnion As Integer
    Private _LastXmlFileName As String = ""
    Private _FileHitIndicator As String
    Private _DataFlags As Integer
    Private _RequestStatus As String = ""
    Private _ReportStatus As String = ""
    Private _StatusMessage As String = ""
    Private _ReuseSourceId As Integer = 0

    Public Property FirstName() As String
        Get
            Return _FirstName
        End Get
        Set(ByVal value As String)
            _FirstName = Trim(StrConv(value, VbStrConv.ProperCase))
        End Set
    End Property

    Public Property LastName() As String
        Get
            Return _LastName
        End Get
        Set(ByVal value As String)
            _LastName = Trim(StrConv(value, VbStrConv.ProperCase))
        End Set
    End Property

    Public Property Street() As String
        Get
            Return _Street
        End Get
        Set(ByVal value As String)
            _Street = Trim(value)
        End Set
    End Property

    Public Property City() As String
        Get
            Return _City
        End Get
        Set(ByVal value As String)
            _City = Trim(value)
        End Set
    End Property

    Public Property State() As String
        Get
            Return _State
        End Get
        Set(ByVal value As String)
            _State = Trim(value)
        End Set
    End Property

    Public Property PostalCode() As String
        Get
            Return _PostalCode
        End Get
        Set(ByVal value As String)
            _PostalCode = value
        End Set
    End Property

    Public Property SSN() As String
        Get
            Return _SSN
        End Get
        Set(ByVal value As String)
            _SSN = value.Replace("-", "").Trim
        End Set
    End Property

    Public Property CoApp() As Boolean
        Get
            Return _CoApp
        End Get
        Set(ByVal value As Boolean)
            _CoApp = value
        End Set
    End Property

    Public Property CreditScore() As Integer
        Get
            Return _CreditScore
        End Get
        Set(ByVal value As Integer)
            _CreditScore = value
        End Set
    End Property

    Public Property CreditSource() As String
        Get
            Return _CreditSource
        End Get
        Set(ByVal value As String)
            _CreditSource = value
        End Set
    End Property

    Public Property CreditSourceID() As Integer
        Get
            Return _CreditSourceID
        End Get
        Set(ByVal value As Integer)
            _CreditSourceID = value
        End Set
    End Property

    Public Property Equifax() As Integer
        Get
            Return _Equifax
        End Get
        Set(ByVal value As Integer)
            _Equifax = value
        End Set
    End Property

    Public Property Experian() As Integer
        Get
            Return _Experian
        End Get
        Set(ByVal value As Integer)
            _Experian = value
        End Set
    End Property

    Public Property TransUnion() As Integer
        Get
            Return _TransUnion
        End Get
        Set(ByVal value As Integer)
            _TransUnion = value
        End Set
    End Property

    Public Property LastXMLFileName() As String
        Get
            Return _LastXmlFileName
        End Get
        Set(ByVal value As String)
            _LastXmlFileName = value
        End Set
    End Property

    Public Property FileHitIndicator() As String
        Get
            Return _FileHitIndicator
        End Get
        Set(ByVal value As String)
            _FileHitIndicator = value
        End Set
    End Property

    Public Property DataFlags() As Integer
        Get
            Return _DataFlags
        End Get
        Set(ByVal value As Integer)
            _DataFlags = value
        End Set
    End Property

    Public Property RequestStatus() As String
        Get
            Return _RequestStatus
        End Get
        Set(ByVal value As String)
            _RequestStatus = value
        End Set
    End Property

    Public Property ReportStatus() As String
        Get
            Return _ReportStatus
        End Get
        Set(ByVal value As String)
            _ReportStatus = value
        End Set
    End Property

    Public Property StatusMessage() As String
        Get
            Return _StatusMessage
        End Get
        Set(ByVal value As String)
            _StatusMessage = value
        End Set
    End Property

    Public Property ReuseSourceId() As Integer
        Get
            Return _ReuseSourceId
        End Get
        Set(ByVal value As Integer)
            _ReuseSourceId = value
        End Set
    End Property

End Class