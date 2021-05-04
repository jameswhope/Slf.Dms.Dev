Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Net
Imports System.IO
Imports System.Data.SqlClient
Imports System.Xml
Imports System.Xml.Serialization
Imports System.Security.Cryptography.X509Certificates
Imports System.Linq
Imports System.Collections.Generic
Imports System.Configuration
Imports System.Xml.Linq

Public Class CredStarHelper2
    Public Shared creditorList As New List(Of Creditor)()
    Public Shared creditorAccountList As New List(Of CreditorAccount)()
    Public Shared creditorCollectionsList As New List(Of CreditorAccount)()
    Public Shared creditorScore As New CreditorScore()
    Public Shared PersonEmploymentList As New List(Of CreditorPersonEmployment)




    Private Class ReportDoc
        Public PdfFile As String
        Public FirstName As String
        Public Lastname As String
    End Class

    Private Shared Function GetPerson() As TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicative
        Dim person As New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicative
        With person
            .name = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicativeName
            With .name

                .person = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicativeNamePerson
                With .person
                    .first = "Zelnino".ToUpper
                    .middle = "xx".ToUpper
                    .last = "Winter".ToUpper
                End With
            End With

            .address = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicativeAddress
            With .address
                .status = "current"

                .street = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicativeAddressStreet
                With .street
                    .number = "760".ToUpper
                    .name = "Sproul".ToUpper
                    .preDirectional = "W".ToUpper
                    .type = "RD"
                End With

                .location = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicativeAddressLocation
                With .location
                    .city = "Fantasy Island".ToUpper
                    .state = "IL".ToUpper
                    .zipCode = "60750"
                End With
            End With

            .socialSecurity = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicativeSocialSecurity
            With .socialSecurity
                .number = "666125812"
            End With

            .dateOfBirth = "1967-04-17"
        End With
        Return person
    End Function

    Private Shared Function GetPerson(ByVal borrower As Borrower) As TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicative
        Dim person As New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicative
        With person
            .name = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicativeName
            With .name

                .person = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicativeNamePerson
                With .person
                    .first = borrower.FirstName.Trim.ToUpper
                    '.middle = "" middle name optional
                    .last = borrower.LastName.Trim.ToUpper
                End With

            End With

            .address = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicativeAddress
            With .address
                .status = "current"

                .street = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicativeAddressStreet
                With .street
                    '.number = "760".ToUpper
                    '.name = "Sproul".ToUpper
                    '.preDirectional = "W".ToUpper
                    '.type = "RD"
                    .unparsed = borrower.Street.Trim.Replace(".", "").ToUpper
                End With

                .location = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicativeAddressLocation
                With .location
                    .city = borrower.City.Trim.ToUpper
                    .state = borrower.State.Trim.ToUpper
                    .zipCode = borrower.PostalCode.Trim.ToUpper
                End With
            End With

            .socialSecurity = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicativeSocialSecurity
            With .socialSecurity
                .number = borrower.SSN.Replace("-", "")
            End With

            '.dateOfBirth = borrower. 'needs to add date of birth to borrower
        End With
        Return person
    End Function

    Private Shared Function GetAccountLoanType(ByVal accountcode As String) As String
        Try
            Return SqlHelper.ExecuteScalar(String.Format("Select [description] from tblTuLoanType where typecode='{0}'", accountcode), CommandType.Text).ToString
        Catch ex As Exception
            Return "UnknownLoanType"
        End Try
    End Function

    Private Shared Function GetXmlDocs(ByVal ReportId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select creditsourceid, xmlfile, firstname, lastname from tblcreditsource where reportid = {0} and isnull(xmlfile,'') <> ''  and status in ('OK') order by coborrower, creditsourceid", ReportId), CommandType.Text)
    End Function

    Private Shared Sub SaveCreditLiabilities(ByVal ReportID As Integer, ByVal tblCreditors As DataTable, ByVal borrower As Borrower)
        For Each creditor As DataRow In tblCreditors.Rows
            CredStarHelper.SaveCreditLiabilities(ReportID, creditor, borrower.CreditSourceID)
        Next
    End Sub

    Private Shared Function CreateCreditorsTable() As DataTable
        Dim tblCreditors As New DataTable
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
            .Columns.Add("UnpaidBalance", GetType(System.Decimal))
            .Columns.Add("MonthlyPayment", GetType(System.Int32))
            .Columns.Add("LateThirtyDays", GetType(System.Int32))
            .Columns.Add("LateSixtyDays", GetType(System.Int32))
            .Columns.Add("LateNinetyDays", GetType(System.Int32))
            .Columns.Add("LateOneTwentyDays", GetType(System.Int32))
            .Columns.Add("OriginalCreditor", GetType(System.String))
            .Columns.Add("Opened", GetType(System.String))
            .Columns.Add("HighCredit", GetType(System.Int32))
            .Columns.Add("AccountOwnershipType", GetType(System.String))
            '.Columns.Add("Exists", GetType(System.String)) 'cholt 9/8/2020
            .Columns.Add("Street2", GetType(System.String))
            'Add default values
            .Columns("AccountType").DefaultValue = "Unknown"
            .Columns("AccountStatus").DefaultValue = "Unknown"
            .Columns("LoanType").DefaultValue = "UNK"
            .Columns("UnpaidBalance").DefaultValue = 0
            .Columns("MonthlyPayment").DefaultValue = 0
            .Columns("LateThirtyDays").DefaultValue = 0
            .Columns("LateSixtyDays").DefaultValue = 0
            .Columns("LateNinetyDays").DefaultValue = 0
            .Columns("LateOneTwentyDays").DefaultValue = 0
            .Columns("HighCredit").DefaultValue = 0
            .Columns("OriginalCreditor").DefaultValue = ""
        End With
        Return tblCreditors
    End Function

    'Private Shared Sub FillFileSummary(ByVal borrower As Borrower) 'ByVal creditReport As TUXML.Response.creditBureau, 
    '    Try
    '        With creditReport.product.subject.subjectRecord.fileSummary
    '            borrower.FileHitIndicator = .fileHitIndicator
    '            borrower.DataFlags = 0
    '            If Not .creditDataStatus Is Nothing Then
    '                With .creditDataStatus
    '                    If .disputed Then borrower.DataFlags += 4
    '                    If .minor Then borrower.DataFlags += 2
    '                    If .suppressed Then borrower.DataFlags += 1
    '                    If Not .freeze Is Nothing Then
    '                        If .freeze.indicator Then borrower.DataFlags += 8
    '                    End If
    '                End With
    '            End If
    '        End With
    '    Catch ex As Exception
    '        'Ignore exception
    '    End Try
    'End Sub

    'Private Shared Function GetCreditorContact(ByVal creditorName As String, ByVal creditorType As String) As TUXML.Response.creditBureauProductSubjectSubjectRecordAddOnProductCreditorContact 'ByVal creditReport As TUXML.Response.creditBureau
    '    ' If creditReport.product.subject.subjectRecord.addOnProduct Is Nothing Then Exit Function
    '    Try
    '        Dim addonQry = From addonproduct In creditReport.product.subject.subjectRecord.addOnProduct
    '                       Where addonproduct.code = "07500" AndAlso
    '                       addonproduct.creditorContact IsNot Nothing AndAlso
    '                       addonproduct.creditorContact.Count > 0
    '                       Select addonproduct.creditorContact

    '        Dim creditorContactQry = From creditorContact In addonQry.ToList().First
    '                                 Where creditorContact.subscriber.name.unparsed = creditorName AndAlso
    '                                 creditorContact.decodeData = creditorType
    '                                 Select creditorContact

    '        Return creditorContactQry.ToList.First
    '    Catch ex As Exception
    '        Return Nothing
    '    End Try
    'End Function

    'Private Shared Sub FillCreditorInfo(ByRef row As DataRow) 'ByVal creditReport As TUXML.Response.creditBureau , ByVal creditorType As String
    '    Try
    '        For i As Integer = 0 To creditorList.Count - 1
    '            'If Not row("CreditorName") Is DBNull.Value AndAlso row("CreditorName").ToString.Trim.Length > 0 Then
    '            '    'Dim contact As TUXML.Response.creditBureauProductSubjectSubjectRecordAddOnProductCreditorContact = GetCreditorContact(row("CreditorName").ToString.Trim, creditorType) 'creditReport
    '            '    'Get Contact Info
    '            '    If Not creditorAccountList Is Nothing AndAlso Not contact.subscriber Is Nothing Then
    '            '        With contact.subscriber
    '            '            If Not .address Is Nothing Then
    '            '                With .address
    '            '                    If Not .street Is Nothing Then
    '            row("Street") = creditorList(i).Address.ToString
    '            '                    End If
    '            '                    If Not .location Is Nothing Then
    '            row("City") = creditorList(i).City.ToString
    '            row("StateCode") = creditorList(i).State.ToString
    '            row("PostalCode") = creditorList(i).ZipCode.ToString                '                    End If
    '            '                End With
    '            '            End If
    '            '            If Not .phone Is Nothing Then
    '            '                With .phone
    '            '                    If Not .number Is Nothing Then
    '            row("Contact") = String.Format("{0}{1}{2}", creditorList(i).AreaCode, creditorList(i).PhoneType, creditorList(i).ExtensionNumber)
    '            '                    End If
    '            '                End With
    '            '            End If
    '            '        End With
    '            '    End If
    '            'End If

    '        Next
    '    Catch ex As Exception
    '        'Ignore this error
    '    End Try

    'End Sub

    Public Shared Function CreditorExists(ByVal ReportId As Integer, ByVal creditor As DataRow, ByVal CreditorLookUpId As Integer) As Boolean
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ReportId", SqlDbType.Int)
        param.Value = ReportId
        params.Add(param)

        param = New SqlParameter("@CreditLiabilityLookupId", SqlDbType.Int)
        param.Value = CreditorLookUpId
        params.Add(param)

        param = New SqlParameter("@AccountNumber", SqlDbType.VarChar)
        param.Value = creditor("AccountNumber")
        params.Add(param)

        param = New SqlParameter("@AccountType", SqlDbType.VarChar)
        param.Value = creditor("AccountType")
        params.Add(param)

        param = New SqlParameter("@AccountStatus", SqlDbType.VarChar)
        param.Value = creditor("AccountStatus")
        params.Add(param)

        param = New SqlParameter("@LoanType", SqlDbType.VarChar)
        param.Value = creditor("LoanType")
        params.Add(param)

        param = New SqlParameter("@OriginalCreditor", SqlDbType.VarChar)
        param.Value = creditor("OriginalCreditor")
        params.Add(param)

        param = New SqlParameter("@AccountOwnershipType", SqlDbType.VarChar)
        param.Value = creditor("AccountOwnershipType")
        params.Add(param)

        param = New SqlParameter("@UnpaidBalance", SqlDbType.Money)
        param.Value = creditor("UnpaidBalance")
        params.Add(param)

        Return (CInt(SqlHelper.ExecuteScalar("stp_CreditLiabilityExists", CommandType.StoredProcedure, params.ToArray)) > 0)
    End Function

    Private Shared Sub FillTrades(ByVal LeadApplicantId As Integer, ByRef tblcreditors As DataTable) 'ByVal creditReport As TUXML.Response.creditBureau
        Dim row As DataRow
        For i As Integer = 0 To creditorList.Count - 1
            For j As Integer = 0 To creditorList(i).CreditorAccount.Count - 1
                row = tblcreditors.NewRow
                row("BorrowerID") = LeadApplicantId
                If String.IsNullOrEmpty(creditorList(i).CreditorAccount(j).TradeBalance) Then
                    'do nothing
                ElseIf Decimal.TryParse(creditorList(i).CreditorAccount(j).TradeBalance, Nothing) Then
                    row("UnpaidBalance") = Decimal.Parse(creditorList(i).CreditorAccount(j).TradeBalance)
                End If
                If String.IsNullOrEmpty(creditorList(i).CreditorAccount(j).AmountOfPayment) Then
                    'do nothing
                ElseIf Int32.TryParse(creditorList(i).CreditorAccount(j).AmountOfPayment, Nothing) Then
                    row("MonthlyPayment") = Int32.Parse(creditorList(i).CreditorAccount(j).AmountOfPayment)
                End If
                If String.IsNullOrEmpty(creditorList(i).CreditorAccount(j).AccountNumber.ToString) Then
                    'do nothing
                Else
                    row("AccountNumber") = creditorList(i).CreditorAccount(j).AccountNumber.ToString
                End If
                If String.IsNullOrEmpty(creditorList(i).CreditorAccount(j).AccountType.ToString) Then
                    'do nothing
                Else
                    row("AccountType") = creditorList(i).CreditorAccount(j).AccountType.ToString
                End If
                If IsNothing(creditorList(i).CreditorAccount(j).LoanType.ToString) Then
                    row("LoanType") = "UNK"
                ElseIf String.IsNullOrEmpty(creditorList(i).CreditorAccount(j).LoanType.ToString) Then
                    row("LoanType") = "UNK"
                Else
                    row("LoanType") = creditorList(i).CreditorAccount(j).LoanType.ToString
                End If
                If String.IsNullOrEmpty(creditorList(i).CreditorAccount(j).DateOpened.ToString) Then
                    'do nothing
                Else
                    row("Opened") = creditorList(i).CreditorAccount(j).DateOpened.ToString
                End If
                If row("AccountStatus") = "Unknown" Then
                    row("AccountStatus") = "open"
                End If
                If String.IsNullOrEmpty(creditorList(i).CreditorAccount(j).TradeHighCredit) Then
                    'do nothing
                ElseIf Int32.TryParse(creditorList(i).CreditorAccount(j).TradeHighCredit, Nothing) Then
                    row("HighCredit") = Int32.Parse(creditorList(i).CreditorAccount(j).TradeHighCredit)
                End If
                If String.IsNullOrEmpty(creditorList(i).CreditorAccount(j).Times30DaysLate) Then
                    'do nothing
                ElseIf Int32.TryParse(creditorList(i).CreditorAccount(j).Times30DaysLate, Nothing) Then
                    row("LateThirtyDays") = Int32.Parse(creditorList(i).CreditorAccount(j).Times30DaysLate)
                End If
                If String.IsNullOrEmpty(creditorList(i).CreditorAccount(j).Times60DaysLate) Then
                    'do nothing
                ElseIf Int32.TryParse(creditorList(i).CreditorAccount(j).Times60DaysLate, Nothing) Then
                    row("LateSixtyDays") = Int32.Parse(creditorList(i).CreditorAccount(j).Times60DaysLate)
                End If
                If String.IsNullOrEmpty(creditorList(i).CreditorAccount(j).Times90DaysLate) Then
                    'do nothing
                ElseIf Int32.TryParse(creditorList(i).CreditorAccount(j).Times90DaysLate, Nothing) Then
                    row("LateNinetyDays") = Int32.Parse(creditorList(i).CreditorAccount(j).Times90DaysLate)
                End If
                If String.IsNullOrEmpty(creditorList(i).CreditorAccount(j).CreditorName.ToString) Then
                    'do nothing
                Else
                    row("CreditorName") = creditorList(i).CreditorAccount(j).CreditorName.ToString
                End If
                If String.IsNullOrEmpty(creditorList(i).CreditorAccount(j).AccountType.ToString) Then
                    'do nothing
                Else
                    row("AccountOwnershipType") = creditorList(i).CreditorAccount(j).AccountType.ToString
                End If
                If String.IsNullOrEmpty(creditorList(i).CreditorAccount(j).DateClosed.ToString) Then
                    'do nothing
                ElseIf Not creditorList(i).CreditorAccount(j).DateClosed.ToString Is Nothing Then
                    row("AccountStatus") = "closed"
                End If

                row("Street") = creditorList(i).Address.ToString
                If String.IsNullOrEmpty(creditorList(i).Address2.ToString) Then
                    row("Street2") = " "
                Else
                    row("Street2") = creditorList(i).Address2.ToString
                End If

                row("City") = creditorList(i).City.ToString
                row("StateCode") = creditorList(i).State.ToString
                row("PostalCode") = creditorList(i).ZipCode.ToString
                row("Contact") = String.Format("{0}{1}{2}", creditorList(i).AreaCode, creditorList(i).PhoneType, creditorList(i).ExtensionNumber)

                'row("Exists") = creditorList(i).Exists.ToString cholt 9/8/2020
                tblcreditors.Rows.Add(row)
            Next
        Next


    End Sub

    'Private Shared Sub FillCollections(ByVal LeadApplicantId As Integer, ByRef tblcreditors As DataTable) 'ByVal creditReport As TUXML.Response.creditBureau,
    '    'If creditReport.product.subject.subjectRecord.custom.credit.collection Is Nothing Then Exit Sub
    '    Dim row As DataRow
    '    For i As Integer = 0 To creditorList.Count - 1
    '        row = tblcreditors.NewRow
    '        row("BorrowerID") = LeadApplicantId
    '        'If Not creditorList(i).CreditorAccount(0).TradeBalance Is Nothing AndAlso Int32.TryParse(creditorList(i).CreditorAccount(0).TradeBalance, Nothing) Then
    '        row("UnpaidBalance") = creditorList(i).CreditorAccount(0).TradeBalance
    '        'End If
    '        'row("MonthlyPayment") 
    '        'If Not creditorList(i).CreditorAccount(0).AccountNumber Is Nothing Then
    '        row("AccountNumber") = creditorList(i).CreditorAccount(0).AccountNumber
    '        'End If
    '        'If Not creditorList(i).CreditorAccount(0).AccountType Is Nothing Then
    '        row("AccountType") = creditorList(i).CreditorAccount(0).AccountType
    '        'End If
    '        'If Not creditorList(i).CreditorAccount(0).LoanType Is Nothing AndAlso Not creditorList(i).CreditorAccount(0).LoanType Is Nothing Then
    '        row("LoanType") = creditorList(i).CreditorAccount(0).LoanType
    '        'End If
    '        If Not creditorList(i).CreditorAccount(0).DateOpened Is Nothing AndAlso Date.TryParse(creditorList(i).CreditorAccount(0).DateOpened.ToString, Nothing) Then
    '            row("Opened") = creditorList(i).CreditorAccount(0).DateOpened
    '            If row("AccountStatus") = "Unknown" Then
    '                row("AccountStatus") = "open"
    '            End If
    '        End If
    '        'row("HighCredit")  
    '        'row("LateThirtyDays")
    '        'row("LateSixtyDays")
    '        'row("LateNinetyDays")
    '        'row("LateOneTwentyDays")
    '        'If Not creditorList(i).CreditorAccount(0).CreditorName Is Nothing AndAlso Not creditorList(i).CreditorAccount(0).CreditorName Is Nothing AndAlso Not creditorList(i).CreditorAccount(0).CreditorName Is Nothing Then
    '        row("CreditorName") = creditorList(i).CreditorAccount(0).CreditorName
    '        'End If
    '        'If Not creditorList(i).CreditorAccount(0).AccountDesignator Is Nothing Then row("AccountOwnershipType") = creditorList(i).CreditorAccount(0).AccountDesignator
    '        'row("AccountStatus") = creditorList(i).CreditorAccount(0).
    '        'If Not creditorList(i).CreditorAccount(0).CreditorName Is Nothing AndAlso Not creditorList(i).CreditorAccount(0).CreditorName Is Nothing AndAlso Not creditorList(i).CreditorAccount(0).CreditorName Is Nothing Then
    '        row("OriginalCreditor") = creditorList(i).CreditorAccount(0).CreditorName
    '        'End If

    '        If Not creditorList(i).CreditorAccount(0).DateClosed Is Nothing AndAlso Date.TryParse(creditorList(i).CreditorAccount(0).DateClosed.ToString, Nothing) Then
    '            row("AccountStatus") = "closed"
    '        End If
    '        FillCreditorInfo(row) 'creditReport , "collection"
    '        'row("LoanType") = liabilityNode.Attributes.GetNamedItem("CreditLoanType").Value.Replace("VeteransAdministrationRealEstateMortgage", "Mortgage")
    '        tblcreditors.Rows.Add(row)
    '    Next
    'End Sub

    Private Shared Sub FillCreditScore(ByRef borrower As Borrower) ' ByVal creditReport As TUXML.Response.creditBureau,
        ' If creditReport.product.subject.subjectRecord.addOnProduct Is Nothing Then Exit Sub
        'List(Of TUXML.Response.creditBureauProductSubjectSubjectRecordAddOnProduct) = creditReport.product.subject.subjectRecord.addOnProduct.AsQueryable.Where(Function(p) p.code = "0P02" And p.status = "delivered").ToList()
        If Double.TryParse(creditorScore.score_score, Nothing) Then
            If Double.Parse(creditorScore.score_score) > 0 Then
                borrower.TransUnion = Double.Parse(creditorScore.score_score)
            End If
        End If
    End Sub

    Private Shared Sub SaveEmploymentHistory(ByVal CreditSourceId As Integer) ', ByVal creditReport As TUXML.Response.creditBureau
        'For Each person As CreditorPersonEmployment In PersonEmploymentList
        '    If PersonEmploymentList Is Nothing Then Exit Sub
        'Next

        For Each employer As CreditorPersonEmployment In PersonEmploymentList 'TUXML.Response.creditBureauProductSubjectSubjectRecordIndicativeEmployment In creditReport.product.subject.subjectRecord.indicative.employment
            Dim sql As String
            Dim employername As String = ""
            Dim employerAddress As String = "" 'Needs to be Added to Schema
            Dim reporteddate As Date = New Date(1900, 1, 1)
            If Not employer.employer_name Is Nothing Then
                employername = employer.employer_name
            End If
            If Not String.IsNullOrEmpty(employer.date_verified_or_reported) Then
                If Not employer.date_verified_or_reported Is Nothing Then
                    reporteddate = Date.ParseExact(employer.date_verified_or_reported, "yyyyMMdd", System.Globalization.DateTimeFormatInfo.InvariantInfo)
                End If
            End If
            sql = String.Format("insert tblCreditEmployer (creditsourceid,employer,streetaddress,selfemployed,employmentreporteddate) values ({0},'{1}','{2}','{3}','{4}')", CreditSourceId, CleanupText(employername), CleanupText(employerAddress), "N", reporteddate)
            SqlHelper.ExecuteNonQuery(sql, CommandType.Text)
        Next
    End Sub

    Private Shared Sub SaveInquiryHistory(ByVal CreditSourceId As Integer) 'ByVal creditReport As TUXML.Response.creditBureau
        'If creditReport.product.subject.subjectRecord.custom Is Nothing OrElse
        '    creditReport.product.subject.subjectRecord.custom.credit.inquiry Is Nothing Then Exit Sub
        For Each inquiry As Creditor In creditorList 'TUXML.Response.creditBureauProductSubjectSubjectRecordCustomCreditInquiry In creditReport.product.subject.subjectRecord.custom.credit.inquiry
            Dim sql As String
            Dim inquiryname As String = ""
            Dim inquirydate As Date = New Date(1900, 1, 1)
            If Not inquiry.CreditorName Is Nothing _
                AndAlso Not inquiry.CreditorName Is Nothing _
                    AndAlso Not inquiry.CreditorName Is Nothing Then
                inquiryname = inquiry.CreditorName
            End If
            'If Not inquiry.date Is Nothing Then
            '    inquirydate = inquiry.date.Value
            'End If
            sql = String.Format("insert tblCreditInquiry (CreditSourceID,MadeBy,InquiryDate) values ({0},'{1}','{2}')", CreditSourceId, CleanupText(inquiryname), inquirydate)
            SqlHelper.ExecuteNonQuery(sql, CommandType.Text)
        Next
    End Sub

    Private Shared Sub ConvertHtmlToPDF(ByVal html As String, ByVal pdfpath As String, ByVal DateIssued As String)
        'Create html file
        Dim htmlfilepath As String = Path.Combine(Path.GetDirectoryName(pdfpath), "temp")
        If Not Directory.Exists(htmlfilepath) Then Directory.CreateDirectory(htmlfilepath)
        Dim htmlfilename As String = Path.Combine(htmlfilepath, Path.GetFileNameWithoutExtension(pdfpath) & ".html")
        Dim headerfilename As String = String.Format("http://{0}{1}?date1={2}", HttpContext.Current.Request.Url.Authority, System.Web.VirtualPathUtility.ToAbsolute("~/clients/enrollment/TUHeader.htm"), HttpUtility.UrlEncode(DateIssued))
        File.WriteAllText(htmlfilename, html, System.Text.Encoding.UTF8)
        'Convert to pdf using converter
        Dim process As System.Diagnostics.Process = New System.Diagnostics.Process()
        process.StartInfo.UseShellExecute = False
        process.StartInfo.CreateNoWindow = True
        'set the executable location
        process.StartInfo.FileName = ConfigurationManager.AppSettings("htmltopdfconverter").ToString
        'set the arguments to the exectuable
        ' wkhtmltopdf [OPTIONS]... <input fileContent> [More input fileContents] <output fileContent>
        'process.StartInfo.Arguments = htmlfilename & " " & pdfpath & " --header-html "
        'process.StartInfo.Arguments = String.Format("{0} {1}", htmlfilename, pdfpath)
        process.StartInfo.Arguments = String.Format("{0} {1} -H --header-html {2}", htmlfilename, pdfpath, headerfilename)
        process.StartInfo.RedirectStandardOutput = True
        process.StartInfo.RedirectStandardError = True
        process.StartInfo.RedirectStandardInput = True
        'run the executable
        process.Start()
        'wait until the conversion is done
        process.WaitForExit()
        'read the exit code, close process     
        Dim returnCode As Integer = process.ExitCode
        process.Close()
        'Delete html file
        If File.Exists(htmlfilename) Then File.Delete(htmlfilename)
    End Sub

    Private Shared Function CombineInHtml(ByVal xmlfiles As String()) As String
        Dim sb As New StringBuilder
        sb.AppendLine("<!DOCTYPE html>")
        sb.AppendLine("<html>")
        sb.AppendLine("<head><title>Credit Report</title>")
        sb.AppendFormat("<link rel=""stylesheet"" type=""text/css"" href=""http://{0}{1}""/>", HttpContext.Current.Request.Url.Authority, System.Web.VirtualPathUtility.ToAbsolute("~/css/TUStyle.css"))
        sb.AppendLine("<style type=""text/css"">")
        sb.AppendFormat(".tuLogoUrl {{background-image: url('http://{0}{1}');}}", HttpContext.Current.Request.Url.Authority, System.Web.VirtualPathUtility.ToAbsolute("~/images/TULogo.png"))
        sb.AppendLine("</style>")
        sb.AppendLine("</head>")
        sb.AppendLine("<body>")
        For Each xml As String In xmlfiles
            sb.Append(XmlHelper.ConvertToTUHtml(xml))
        Next
        sb.AppendLine("</body>")
        sb.AppendLine("</html>")
        Return sb.ToString
    End Function

    Private Shared Sub SaveDocument(ByVal LeadApplicantid As Integer, ByVal DocumentId As String, ByVal RequestBy As Integer, ByVal xmlfiles As String())
        Try
            'From the xml file get the html file
            Dim html As String = CredStarHelper2.CombineInHtml(xmlfiles)
            Dim path As String = System.IO.Path.Combine(System.IO.Path.Combine(ConfigurationManager.AppSettings("LeadDocumentsDir").ToString, "pdf"), String.Format("{0}.pdf", DocumentId))
            'Dim path As String = System.IO.Path.Combine(ConfigurationManager.AppSettings("LeadDocumentsDir").ToString, String.Format("{0}.pdf", DocumentId))
            CredStarHelper2.ConvertHtmlToPDF(html, path, "")
            SmartDebtorHelper.SaveLeadDocument(LeadApplicantid, DocumentId, RequestBy, SmartDebtorHelper.DocType.CreditReport)

        Catch ex As Exception
            'Document creation failed
        End Try
    End Sub

    Private Shared Function GetLocalDateTime(ByVal xmlFile As String) As String
        'Needs to find a better way to get the date
        Try
            Dim xmlDoc As XmlDocument = New XmlDocument()
            xmlDoc.Load(xmlFile)
            Dim ns As New XmlNamespaceManager(xmlDoc.NameTable)
            ns.AddNamespace("myns", "https://api.creditly.co/v2")
            Dim datenode As XmlNode = xmlDoc.SelectSingleNode(String.Format("//{0}:transactionTimeStamp", "myns"), ns)
            Return CDate(datenode.InnerText).ToLocalTime().ToString("MM/dd/yy hh:mm:ss tt") & " PT"
        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Sub SaveDocuments(ByVal ReportId As String, ByVal LeadApplicantId As String, ByVal RequestBy As Integer)
        Try
            'Instead of creating a single document. Create a document per applicant
            Dim dt As DataTable = CredStarHelper2.GetXmlDocs(ReportId)
            If dt.Rows.Count > 0 Then
                For Each dr As DataRow In dt.Rows
                    If Not dr("xmlfile") Is DBNull.Value AndAlso File.Exists(dr("xmlfile")) Then
                        'From the xml file get the html file
                        Dim DocumentId As String = System.IO.Path.GetFileNameWithoutExtension(dr("xmlfile")).ToString
                        Dim html As String = CredStarHelper2.CombineInHtml(New String() {dr("xmlfile")})
                        Dim path As String = System.IO.Path.Combine(System.IO.Path.Combine(ConfigurationManager.AppSettings("LeadDocumentsDir").ToString, ""), String.Format("{0}.pdf", DocumentId))
                        'Dim path As String = System.IO.Path.Combine(ConfigurationManager.AppSettings("LeadDocumentsDir").ToString, String.Format("{0}.pdf", DocumentId))
                        CredStarHelper2.ConvertHtmlToPDF(html, path, GetLocalDateTime(dr("xmlfile")))
                        SmartDebtorHelper.SaveLeadDocument(LeadApplicantId, DocumentId, RequestBy, SmartDebtorHelper.DocType.CreditReport)
                    End If
                Next
            End If
        Catch ex As Exception
            'Document creation failed
        End Try
    End Sub

    Public Shared Function GetFlagsDescription(ByVal flags As Integer) As String
        Dim aflags As New List(Of String)
        If flags And 1 Then
            aflags.Add("Suppresed")
        End If
        If flags And 2 Then
            aflags.Add("Minor")
        End If
        If flags And 4 Then
            aflags.Add("Disputed")
        End If
        If flags And 8 Then
            aflags.Add("Frozen")
        End If
        Return String.Join(", ", aflags.ToArray)
    End Function

    Public Shared Function InsertCreditReport(ByVal LeadApplicantId As Integer, ByVal CreditReportId As String, ByVal RequestBy As Integer) As Integer
        Dim cmdText As String = String.Format("insert tblCreditReport (LeadApplicantId, CreditReportId,RequestBy) values ({0},'{1}',{2}) select scope_identity()", LeadApplicantId, CreditReportId, RequestBy)
        Return CInt(SqlHelper.ExecuteScalar(cmdText, CommandType.Text))
    End Function

    Public Shared Sub UpdateLeadLastCreditReport(ByVal LeadApplicantId As Integer, ByVal ReportId As Integer)
        If ReportId <> -1 Then
            Dim cmdText As String = String.Format("Update tblLeadApplicant Set LastReportId = {1} Where LeadApplicantid = {0}", LeadApplicantId, ReportId)
            SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
        End If
    End Sub

    Private Shared Sub SaveCreditReport(ByVal LeadApplicantId As Integer, ByVal ReportId As Integer, ByVal CreditReportId As String, ByVal creditResponse As TUResponse, ByRef borrower As Borrower)
        'Dim creditReport As TUXML.Response.creditBureau = creditResponse.Response

        'CredStarHelper2.FillFileSummary(borrower) 'file indicator code... could possibly replace with scoring summary indicator code? creditReport
        'UpdateFileSummary(borrower) 'updates tblsource for fite hits

        Dim tblcreditors As DataTable = CredStarHelper2.CreateCreditorsTable 'creates table liabilities seen by client intake

        'If Not creditReport.product.subject.subjectRecord.custom Is Nothing AndAlso
        '    Not creditReport.product.subject.subjectRecord.custom.credit Is Nothing Then
        CredStarHelper2.FillTrades(LeadApplicantId, tblcreditors) 'fills trades 'creditReport
        'CredStarHelper2.FillCollections(LeadApplicantId, tblcreditors) 'fills creditor information 'creditReport
        CredStarHelper2.FillCreditScore(borrower) 'fills score information ' creditReport
            borrower.ReportStatus = "OK"
            borrower.StatusMessage = ""
        'Else

        '    Dim validhit As Boolean = CredStarHelper2.IsValidFileHit(borrower.FileHitIndicator)
        '    If validhit AndAlso borrower.DataFlags = 0 Then
        '        Throw New Exception("credit information not found in report")
        '    Else
        '        borrower.ReportStatus = "Warning"
        '        borrower.StatusMessage = String.Format("File Hit Indicator: {0} {1}", borrower.FileHitIndicator, IIf(borrower.DataFlags <> 0, ". Credit Data Status: " & GetFlagsDescription(borrower.DataFlags), ""))
        '    End If

        'End If

        CredStarHelper2.SaveCreditLiabilities(ReportId, tblcreditors, borrower)
        CredStarHelper2.SaveInquiryHistory(borrower.CreditSourceID) ', creditReport
        CredStarHelper2.SaveEmploymentHistory(borrower.CreditSourceID) ', creditReport

        UpdateStatus(borrower)
    End Sub

    Private Shared Sub InsertCreditSource(ByVal ReportID As Integer, ByRef borrower As Borrower)
        Dim cmdText As String
        cmdText = String.Format("insert tblCreditSource (ReportID,SSN,FirstName,LastName,Equifax,TransUnion,Experian,CoBorrower,CreditSource,ReuseId) values ({0},'{1}','{2}','{3}',{4},{5},{6},'{7}','{8}',{9}) select scope_identity()", ReportID, borrower.SSN.Replace("-", ""), borrower.FirstName, borrower.LastName, borrower.Equifax, borrower.TransUnion, borrower.Experian, IIf(borrower.CoApp, 1, 0), borrower.CreditSource, IIf(borrower.ReuseSourceId = 0, "NULL", borrower.ReuseSourceId))
        borrower.CreditSourceID = CInt(SqlHelper.ExecuteScalar(cmdText, CommandType.Text))
    End Sub

    Private Shared Sub UpdateRequestStatus(ByVal borrower As Borrower)
        Dim cmdText As String = String.Format("update tblCreditSource set RequestStatus = '{1}' where creditsourceid = {0}", borrower.CreditSourceID, borrower.RequestStatus)
        SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
    End Sub

    Private Shared Sub UpdateXmlFile(ByVal borrower As Borrower)
        Dim cmdText As String = String.Format("update tblCreditSource set XmlFile = '{1}' where creditsourceid = {0}", borrower.CreditSourceID, borrower.LastXMLFileName)
        SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
    End Sub

    Private Shared Sub UpdateStatus(ByVal borrower As Borrower)
        Dim cmdText As String = String.Format("update tblCreditSource set Status = '{1}', StatusMessage='{2}' where creditsourceid = {0}", borrower.CreditSourceID, borrower.ReportStatus, CleanupText(borrower.StatusMessage))
        SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
    End Sub

    Private Shared Sub UpdateFileSummary(ByVal borrower As Borrower)
        Dim cmdText As String = String.Format("update tblCreditSource set FileHitIndicator = '{1}', Flags = {2} where creditsourceid = {0}", borrower.CreditSourceID, borrower.FileHitIndicator, borrower.DataFlags)
        SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
    End Sub

    Public Shared Function GetSettings(ByVal IsTest As Boolean) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@TestMode", SqlDbType.Bit)
        param.Value = IIf(IsTest, 1, 0)
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_GetTransUnionSettings", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Sub ValidateBorrower(ByVal lead As Borrower)

        Dim leadStr As String = String.Format("{0} {1} {2}", IIf(lead.CoApp, "co-applicant", "main applicant"), lead.FirstName, lead.LastName)

        If lead.SSN.Replace("-", "").Trim.Length <> 9 Then
            Throw New Exception(String.Format("The SSN of {0} is invalid", leadStr))
        End If

        If lead.Street.Trim.Length < 4 Then
            Throw New Exception(String.Format("The address of {0} is invalid", leadStr))
        End If
        If lead.City.Trim.Length = 0 Then
            Throw New Exception(String.Format("The city of {0} is required", leadStr))
        End If
        If lead.State.Trim.Length = 0 Then
            Throw New Exception(String.Format("The state of {0} is required", leadStr))
        End If
        If lead.PostalCode.Trim.Length < 5 Then
            Throw New Exception(String.Format("The zip code of {0} is invalid", leadStr))
        End If

    End Sub

    Public Shared Function GetCreditReportId(ByVal reportid As Integer) As String
        Try
            Return SqlHelper.ExecuteScalar(String.Format("Select creditreportid from tblcreditreport where reportid={0}", reportid), CommandType.Text).ToString
        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Function IsValidFileHit(ByVal FileHitIndicator As String) As Boolean
        Select Case FileHitIndicator.Trim.ToLower
            Case "regularnohit",
                 "califnohit",
                 "nohit",
                 "fraudnohit",
                 "privatenohit",
                 "residentialnohit",
                 "businessnohit",
                 "nonamenohit",
                 "nonmailablenohit",
                 "error"
                Return False
            Case Else
                Return True
        End Select
    End Function

    Public Shared Function GetBorrowerCollection(ByVal LeadApplicantID As Integer) As Collections.Generic.Dictionary(Of String, Borrower)
        Dim tblBorrowers As DataTable = CredStarHelper2.GetBorrowers(LeadApplicantID)
        Dim borrowers As New Collections.Generic.Dictionary(Of String, Borrower)
        Dim borrower As Borrower

        For Each row As DataRow In tblBorrowers.Rows
            borrower = New Borrower
            borrower.FirstName = CleanupText(row("firstname").ToString)
            borrower.LastName = CleanupText(row("lastname").ToString)
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
            borrower.ReuseSourceId = Nothing
            borrower.LastXMLFileName = Nothing
            If Not row("reuseid") Is DBNull.Value Then borrower.ReuseSourceId = row("reuseid")
            If Not row("xmlfile") Is DBNull.Value Then borrower.LastXMLFileName = row("xmlfile")
            borrowers.Add(row("ssn").ToString.Replace("-", ""), borrower)
        Next

        Return borrowers
    End Function


    'This function takes the list of borrowers amd converts them into objects to send in.
    Public Shared Sub RequestCreditReport(ByRef reportid As Integer, ByVal LeadApplicantID As Integer, ByVal CreditReportId As String, ByVal RequestBy As Integer, ByRef borrowers As Collections.Generic.Dictionary(Of String, Borrower), ByVal reuselist As String(), ByVal excludelist As String())
        Dim TestMode As Boolean = (ConfigurationManager.AppSettings("TransUnion_Mode").ToString.ToLower = "test")

        reportid = CredStarHelper2.InsertCreditReport(LeadApplicantID, CreditReportId, RequestBy)

        For Each lead As Borrower In borrowers.Values
            ValidateBorrower(lead)
            lead.CreditSource = "TransUnion"
            If Not reuselist.Contains(lead.SSN) Then lead.ReuseSourceId = 0
            CredStarHelper2.InsertCreditSource(reportid, lead)
        Next

        Dim index As Integer = 0
        'Dim xmlfiles As New List(Of String)
        Dim resp As TUResponse = New TUResponse(TUResponseStatus.Statuses.OK)
        Dim xml As String = Nothing
        For Each lead As Borrower In borrowers.Values
            Try
                If excludelist.Contains(lead.SSN) Then
                    lead.ReportStatus = "Excluded"
                    UpdateStatus(lead)
                    Continue For
                End If
                Dim reusexmlfile As Boolean = reuselist.Contains(lead.SSN)
                Dim person As TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicative
                'Dim req As TURequest

                If Not reusexmlfile Then
                    'Send a new Request, creates a person object by use of borrower data
                    person = CredStarHelper2.GetPerson(lead)
                    Dim refNumber As String = String.Format("{0}{1}", CreditReportId, Convert.ToChar(65 + index).ToString)

                    ''manual credit report debugging
                    'Dim books = XDocument.Load("C:\\xml\\CreditReport_AUNDRE_LEWIS_380054.xml")
                    'xml = books.ToString()

                    ''runs the sterling credit report
                    xml = SterlingCreditReport.Index(person.name.person.first, person.name.person.last, person.address.street.unparsed, person.address.location.city, person.address.location.zipCode, person.address.location.state, person.socialSecurity.number, LeadApplicantID)


                    'req = TURequest.CreateRequest(refNumber, TestMode, person)

                Else
                    'Reuse recent existing xml file
                    xml = File.ReadAllText(lead.LastXMLFileName)
                End If



                'Detects if the credit report is locked and needs to be unlcoked by the credit report firm (TransUnion)
                Try
                    Dim xmlDoc As XmlDocument = New XmlDocument()
                    xmlDoc.LoadXml(xml.ToString())
                    Dim suppression As String = Convert.ToString(xmlDoc.SelectSingleNode("TU_Report/subject_segments/subject_header/suppression_ind").Attributes.Item(0).Value)
                    If suppression = "F" Then
                        Throw New System.Exception("Credit Report is locked. Please have your client contact TransUnion to unblock their credit report.")
                    End If
                Catch e As Exception
                    lead.ReportStatus = "Error"
                    lead.StatusMessage = e.Message
                    UpdateStatus(lead)
                    Dim strMsg As String = "Credit Report Is locked.Please have your client contact TransUnion to unblock their credit report."
                    Throw New Exception(strMsg)
                    Exit Sub
                End Try



                'creates and fill lists from the credit report XML based on sections Creditor, Trade, and collections
                creditorList = XMLReaderCreditorList.Read(xml)
                creditorAccountList = XMLReaderCreditorAccountList.Read(xml)
                creditorScore = XMLReaderCreditorScore.Read(xml)
                PersonEmploymentList = XMLReaderCreditorPersonEmployment.Read(xml)
                creditorCollectionsList = XMLReaderCollectionsList.Read(xml)

                'merges the creditor with trade information
                For i As Integer = 0 To creditorList.Count - 1
                    For j As Integer = 0 To creditorAccountList.Count - 1
                        If creditorList(i).MemberCode = creditorAccountList(j).MemberCode Then
                            creditorList(i).CreditorAccount.Add(creditorAccountList(j))
                        End If
                    Next
                Next

                'merges the creditor with collections information
                For i As Integer = 0 To creditorList.Count - 1
                    For j As Integer = 0 To creditorCollectionsList.Count - 1
                        If creditorList(i).MemberCode = creditorCollectionsList(j).MemberCode Then
                            creditorList(i).CreditorAccount.Add(creditorCollectionsList(j))
                        End If
                    Next
                Next

                'Update Request Status
                lead.RequestStatus = [Enum].GetName(GetType(TUResponseStatus.Statuses), resp.Status.Status)
                'lead.RequestStatus = [Enum].GetName(GetType(TUResponseStatus.Statuses), req)
                UpdateRequestStatus(lead)

                'If resp.Status.Status = TUResponseStatus.Statuses.OK Then
                'If Not reusexmlfile Then
                '    'resp.AddRequestParameters(req)
                '    'Save Document
                '    lead.LastXMLFileName = resp.SaveXmlAsDocument()
                'End If

                'If lead.LastXMLFileName.Trim.Length > 0 Then
                '    UpdateXmlFile(lead)
                'End If

                'Parse Response
                SaveCreditReport(LeadApplicantID, reportid, CreditReportId, resp, lead)

                ''only create pdf for valid files
                'If lead.LastXMLFileName.Length > 0 AndAlso lead.DataFlags = 0 AndAlso CredStarHelper2.IsValidFileHit(lead.FileHitIndicator) Then
                '    xmlfiles.Add(lead.LastXMLFileName)
                'End If

                'Else
                '    'Send Error
                '    Throw New Exception("Code:   " & resp.Status.Code & " " & resp.Status.Message)
                'End If

            Catch ex As Exception
                lead.ReportStatus = "Error"
                lead.StatusMessage = ex.Message
                UpdateStatus(lead)
                Dim strMsg As String = String.Format("Error getting credit report for {0} {1}. {2}", lead.FirstName, lead.LastName, ex.Message)
                Throw New Exception(strMsg)
            End Try

            index += 1
        Next

        'Comment out because files have to be per lead
        'If xmlfiles.Count > 0 Then CredStarHelper2.SaveDocument(LeadApplicantID, CreditReportId, RequestBy, xmlfiles.ToArray)

    End Sub

    Public Shared Function GetBorrowers(ByVal LeadApplicantID As Integer) As DataTable
        Dim params(0) As SqlParameter
        params(0) = New SqlParameter("LeadApplicantID", LeadApplicantID)
        Return SqlHelper.GetDataTable("stp_GetLeadBorrowers2", CommandType.StoredProcedure, params)
    End Function

    Public Shared Sub UpdateReportErrorMessage(ByVal reportId As Integer, ByVal errorMessage As String)
        SqlHelper.ExecuteNonQuery(String.Format("update tblCreditReport set ErrorMessage = '{1}' where reportid = {0}", reportId, CleanupText(errorMessage)), CommandType.Text)
    End Sub

    Public Shared Function ShowCreditReport(ByVal reportId As Integer) As String
        Dim dt As DataTable = CredStarHelper2.GetXmlDocs(reportId)
        Dim pdfs As New List(Of ReportDoc)
        If dt.Rows.Count > 0 Then
            For Each dr As DataRow In dt.Rows
                Dim DocumentId As String = System.IO.Path.GetFileNameWithoutExtension(dr("xmlfile")).ToString
                Dim uncdir As String = ConfigurationManager.AppSettings("LeadDocumentsDir").ToString
                Dim virtualdir As String = ConfigurationManager.AppSettings("LeadDocumentsVirtualDir").ToString
                Dim filename As String = System.IO.Path.Combine(System.IO.Path.Combine(uncdir, ""), String.Format("{0}.pdf", DocumentId))

                If File.Exists(filename) Then
                    filename = filename.Replace(uncdir, virtualdir).Replace("\", "/")
                    pdfs.Add(New ReportDoc With {.PdfFile = filename, .FirstName = dr("FirstName"), .Lastname = dr("LastName")})
                End If
            Next
        End If

        Select Case pdfs.Count
            Case 0
                Return ""
            Case 1
                Return String.Format("<a href=""{0}""  class=""lnk"" target=""_blank""><img style=""margin-right: 5;"" src=""{1}"" border=""0"" align=""absmiddle"" />Credit Report</a>", pdfs(0).PdfFile, VirtualPathUtility.ToAbsolute("~/images/16x16_pdf.png"))
            Case Else
                Dim sb As New StringBuilder
                sb.Append("<ul id = ""mnuCreditReport"" >")
                sb.Append("<li>")
                sb.AppendFormat("<a href=""#""><span></span>Credit Reports ({0})</a>", pdfs.Count)
                sb.Append("<ul>")
                For Each pdf As ReportDoc In pdfs
                    sb.AppendFormat("<li><a href=""{0}"" target=""_blank"">{1} {2}</a></li>", pdf.PdfFile, pdf.FirstName, pdf.Lastname)
                Next
                sb.Append("</ul>")
                sb.Append("</li>")
                sb.Append("</ul>")
                Return sb.ToString
        End Select
    End Function

    Public Shared Function CleanupText(ByVal text As String) As String
        Return text.Replace("'", "")
    End Function
End Class
