Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports iTextSharp.text.PageSize
Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports System.IO


Public Class CallVerificationHelper
    Public Const FailedVerificationStatus As Integer = 23

    Public Shared Function GetClientLexxPVVersion(ByVal ClientId As Integer) As Integer
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)
 
        Return CInt(SqlHelper.ExecuteScalar("stp_Verification_GetLexxPVVersion", CommandType.StoredProcedure, params.ToArray))
    End Function

    Public Shared Function GetLeadLexxPVVersion(ByVal LeadId As Integer) As Integer
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@LeadId", SqlDbType.Int)
        param.Value = LeadId
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_Verification_GetLeadLexxPVVersion", CommandType.StoredProcedure, params.ToArray))
    End Function

    Public Shared Function GetCallVerificationQuestions(ByVal LanguageId As Integer, ByVal VersionId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@LanguageId", SqlDbType.Int)
        param.Value = LanguageId
        params.Add(param)

        param = New SqlParameter("@VersionId", SqlDbType.Int)
        param.Value = VersionId
        params.Add(param)

        Return SqlHelper.GetDataTable("stp_VerificationCall_GetQuestions", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function InsertVerficationCall(ByVal ClientId As Integer, ByVal CallIdKey As String, ByVal LanguageId As Integer, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)

        param = New SqlParameter("@CallIdKey", SqlDbType.VarChar)
        param.Value = CallIdKey
        params.Add(param)

        param = New SqlParameter("@LanguageId", SqlDbType.Int)
        param.Value = LanguageId
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Return SqlHelper.ExecuteScalar("stp_VerificationCall_Insert", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function InsertVerficationCallThirdParty(ByVal LeadAplicantId As Integer, ByVal CallIdKey As String, ByVal LanguageId As Integer, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@LeadApplicant", SqlDbType.Int)
        param.Value = LeadAplicantId
        params.Add(param)

        param = New SqlParameter("@CallIdKey", SqlDbType.VarChar)
        param.Value = CallIdKey
        params.Add(param)

        param = New SqlParameter("@LanguageId", SqlDbType.Int)
        param.Value = LanguageId
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Return SqlHelper.ExecuteScalar("stp_VerificationCall_InsertThirdParty", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Sub UpdateVerificationCall(ByVal VerificationCallId As Integer, ByVal EndDate As Nullable(Of DateTime), ByVal Completed As Nullable(Of Boolean), ByVal RecCallIdKey As String, ByVal RecordedCallPath As String, ByVal LastStep As String, ByVal DocPath As String, ByVal ViciFileName As String)
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@VerificationCallId", SqlDbType.Int)
        param.Value = VerificationCallId
        params.Add(param)

        If EndDate.HasValue Then
            param = New SqlParameter("@EndDate", SqlDbType.DateTime)
            param.Value = EndDate.Value
            params.Add(param)
        End If

        If Completed.HasValue Then
            param = New SqlParameter("@Completed", SqlDbType.Bit)
            param.Value = IIf(Completed.Value, 1, 0)
            params.Add(param)
        End If

        If RecCallIdKey.Trim.Length > 0 Then
            param = New SqlParameter("@RecCallIdKey", SqlDbType.VarChar)
            param.Value = RecCallIdKey.Trim
            params.Add(param)
        End If

        If RecordedCallPath.Trim.Length > 0 Then
            param = New SqlParameter("@RecordedCallPath", SqlDbType.VarChar)
            param.Value = RecordedCallPath.Trim
            params.Add(param)
        End If

        If LastStep.Trim.Length > 0 Then
            param = New SqlParameter("@LastStep", SqlDbType.VarChar)
            param.Value = LastStep.Trim
            params.Add(param)
        End If

        If DocPath.Trim.Length > 0 Then
            param = New SqlParameter("@DocumentPath", SqlDbType.VarChar)
            param.Value = DocPath.Trim
            params.Add(param)
        End If

        If ViciFileName.Trim.Length > 0 Then
            param = New SqlParameter("@ViciFileName", SqlDbType.VarChar)
            param.Value = ViciFileName.Trim
            params.Add(param)
        End If

        SqlHelper.ExecuteNonQuery("stp_VerificationCall_Update", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Sub UpdateClientId(LeadApplicantId As Integer, ClientId As Integer)
        Dim sb As New StringBuilder
        sb.Append("update tblVerificationCall ")
        sb.AppendFormat("set ClientId = {0} ", ClientId)
        sb.AppendFormat("where LeadApplicantId = {0}", LeadApplicantId)

        SqlHelper.ExecuteNonQuery(sb.ToString, CommandType.Text)
    End Sub

    Public Shared Sub UpdateRecordedCallPath(Identification As Integer, RecordedCallPath As String, IsLead As Boolean)
        Dim sb As New StringBuilder
        sb.Append("update tblVerificationCall ")
        sb.AppendFormat("set RecordedCallPath = '{0}' ", RecordedCallPath)
        If IsLead Then
            sb.AppendFormat("where LeadApplicantId = {0} and Completed = 1", Identification)
        Else
            sb.AppendFormat("where ClientId = {0} and Completed = 1", Identification)
        End If

        SqlHelper.ExecuteNonQuery(sb.ToString, CommandType.Text)
    End Sub

    Public Shared Sub UpdateRecordedCallPath(ByVal VerificationCallId As Integer, ByVal RecordedCallPath As String)
        Dim sb As New StringBuilder
        sb.Append("update tblVerificationCall ")
        sb.AppendFormat("set RecordedCallPath = '{0}' ", RecordedCallPath)
        sb.AppendFormat("where VerificationCallId = {0}", VerificationCallId)
        SqlHelper.ExecuteNonQuery(sb.ToString, CommandType.Text)
    End Sub

    Public Shared Function InsertVerficationCallLog(ByVal VerificationCallId As Integer, ByVal QuestionNo As Integer, ByVal AnsweredNo As Boolean) As Integer
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@VerificationCallId", SqlDbType.Int)
        param.Value = VerificationCallId
        params.Add(param)

        param = New SqlParameter("@QuestionNo", SqlDbType.Int)
        param.Value = QuestionNo
        params.Add(param)

        param = New SqlParameter("@AnsweredNo", SqlDbType.Bit)
        param.Value = IIf(AnsweredNo, 1, 0)
        params.Add(param)

        Return SqlHelper.ExecuteScalar("stp_VerificationCallLog_Insert", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function GetClientData(ByVal ClientId As Integer) As DataTable
        Dim sb As New StringBuilder
        sb.Append("select l.[name] as LawFirm, isnull(s.[Name], 'Not Provided') as [State], isnull(sta.SAState, 'Not Provided') as [SAState], IsNull(c.InitialDraftAmount, 0.00) as InitialDraftAmount ,c.InitialDraftDate, c.depositMethod from tblclient c ")
        sb.Append("inner join tblcompany l on l.companyId = c.companyId ")
        sb.Append("inner join tblperson p on p.PersonId = c.PrimaryPersonId ")
        sb.Append("Left join tblState s on s.stateId = p.stateid ")
        sb.Append("Left join (select ca.[State], ca.CompanyId, st.[Name] as SAState  from dbo.tblCompanyAddresses ca inner join tblstate st on st.abbreviation = ca.state Where addresstypeid = 8) sta on sta.CompanyId = c.CompanyId ")
        sb.AppendFormat("where c.clientid = {0}", ClientId)
        Return SqlHelper.GetDataTable(sb.ToString, CommandType.Text)
    End Function

    Public Shared Function GetClientData2(ByVal ClientId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@Clientid", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_VerificationCall_GetClientData2", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function GetLeadData(ByVal LeadApplicantId As Integer) As DataTable
        Dim sb As New StringBuilder
        sb.Append("select ")
        sb.Append("l.[name] as LawFirm, ")
        sb.Append("c.[ssn] as SSN, ")
        sb.Append("c.[LeadName] as FullName, ")
        sb.Append("isnull(s.[Name], 'Not Provided') as [State], ")
        sb.Append("isnull(sta.SAState, 'Not Provided') as [SAState], ")
        sb.Append("isnull(cast(lc.InitialDeposit as money), 0.00) as [InitialDraftAmount], ")
        sb.Append("lc.DateOfFirstDeposit as [InitialDraftDate], ")
        sb.Append("'ACH' as [depositMethod] ")
        sb.Append("from tblleadapplicant c ")
        sb.Append("inner join tblcompany l on l.companyId = c.companyId ")
        sb.Append("left join tblState s on s.stateId = c.stateid ")
        sb.Append("left join tblLeadCalculator lc on lc.LeadApplicantId = c.LeadApplicantId ")
        sb.Append("left join (select ca.[State], ca.CompanyId, st.[Name] as SAState ")
        sb.Append("from dbo.tblCompanyAddresses ca ")
        sb.Append("inner join tblstate st on st.abbreviation = ca.state ")
        sb.Append("where addresstypeid = 8) sta on sta.CompanyId = c.CompanyId ")
        sb.AppendFormat("where c.leadapplicantId = {0}", LeadApplicantId)
        Return SqlHelper.GetDataTable(sb.ToString, CommandType.Text)
    End Function

    Public Shared Function GetLeadData2(ByVal LeadApplicantId As Integer) As DataTable
        Dim sb As New StringBuilder
        sb.Append("select ")
        sb.Append("[TotalDebt]=(SELECT sum(balance) FROM tblLeadcreditorinstance WHERE LeadApplicantID =  lc.LeadApplicantID), ")
        sb.Append("[MonthlyDepositAmount]=lc.DepositCommittment, ")
        sb.Append("[DepositMethod] = (SELECT TOP 1 [depositmethod] = case when ACH = 0 then 'Check' else 'ACH' end FROM tblleadbanks WHERE LeadApplicantID =  lc.LeadApplicantID),")
        sb.Append("[DepositDay] = lc.ReoccurringDepositDay, ")
        sb.Append("[MaintenanceFee] = lc.MaintenanceFeeCap, ")
        sb.Append("[SettlementFeePct] = lc.SettlementFeePct, ")
        sb.Append("[BankAccountNumber] = (SELECT TOP 1 AccountNumber FROM tblleadbanks WHERE LeadApplicantID =  lc.LeadApplicantID ), ")
        sb.Append("[BankName] = (SELECT TOP 1 BankName FROM tblleadbanks WHERE LeadApplicantID =  lc.LeadApplicantID ) ")
        sb.Append("From tblLeadCalculator lc ")
        sb.AppendFormat("where lc.leadapplicantId = {0}", LeadApplicantId)
        Return SqlHelper.GetDataTable(sb.ToString, CommandType.Text)
    End Function

    Public Shared Function GetApplicantsData(ByVal ClientId As Integer) As DataTable
        Dim sb As New StringBuilder
        sb.Append("select isnull(p.FirstName,'') + ' ' + isnull(p.LastName,'') as FullName, p.SSN, ")
        sb.AppendFormat("[Primary] = Case When p.PersonID = (Select c.PrimaryPersonId  from tblclient c where c.clientId = {0}) Then 1 else 0 end, ", ClientId)
        sb.AppendFormat("[Title] = Case When p.Gender = 'M' Then 'Mr.' When p.Gender = 'F' Then 'Mrs.' else 'Mr./Mrs.' end ", ClientId)
        sb.AppendFormat("from tblperson p where p.ClientId = {0} order by 3 desc", ClientId)
        Return SqlHelper.GetDataTable(sb.ToString, CommandType.Text)
    End Function

    Public Shared Function GetLeadApplicantsData(ByVal LeadId As Integer) As DataTable
        Dim sb As New StringBuilder
        sb.Append("select [fullname] = case when isnull(fullname,'') = '' then isnull(firstname,'') + ' ' + isnull(lastname,'') else fullname end , ")
        sb.Append("[ssn] = replace(replace(ssn,' ',''),'-',''), ")
        sb.Append("[Primary] = 1, ")
        sb.Append("[Title] = 'Mr./Mrs.' ")
        sb.AppendFormat("from tblleadapplicant where leadapplicantid = {0} ", LeadId)
        sb.Append("union ")
        sb.Append("select [fullname] = case when isnull([full name],'') = '' then isnull(firstname,'') + ' ' + isnull(lastname,'') else [full name] end , ")
        sb.Append("[ssn] = replace(replace(ssn,' ',''),'-',''), ")
        sb.Append("[Primary] = 0, ")
        sb.Append("[Title] = 'Mr./Mrs.' ")
        sb.AppendFormat("from tblleadcoapplicant where leadapplicantid = {0} ", LeadId)
        sb.Append("order by 3 desc")
        Return SqlHelper.GetDataTable(sb.ToString, CommandType.Text)
    End Function

    Public Shared Function GetCallVerificationByClientId(ByVal ClientID As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientID
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_VerificationCall_GetForClient", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function GetClientIntakeRep(ByVal Clientid As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = Clientid
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_verificationCall_GetClientIntakeAgent", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function GetCallVerificationClientInfo(ByVal VerificationID As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@VerificationId", SqlDbType.Int)
        param.Value = VerificationID
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_VerificationCall_GetClientInfo", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function GetCallVerificationLeadInfo(ByVal VerificationID As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@VerificationId", SqlDbType.Int)
        param.Value = VerificationID
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_VerificationCall_GetLeadInfo", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function UsedOldVerification(ByVal LeadApplicantId As Integer) As Boolean
        If SqlHelper.ExecuteScalar(String.Format("Select count(v.leadapplicantid) from  (select LeadApplicantID, max(completed) [Completed] from tblleadverification group by leadapplicantid) v where v.LeadApplicantId = {0} and v.completed is not null", LeadApplicantId), CommandType.Text) > 0 Then
            Return True
        Else
            Return False
        End If
    End Function

    Public Shared Function GetClientPreferredLanguage(ByVal ClientId As Integer) As Integer
        Return SqlHelper.ExecuteScalar(String.Format("Select isnull(languageid,1) as languageid from tblperson  where clientId = {0} and relationship = 'prime'", ClientId), CommandType.Text)
    End Function

    Public Shared Function GetLeadPreferredLanguage(ByVal LeadId As Integer) As Integer
        Return SqlHelper.ExecuteScalar(String.Format("Select isnull(languageid,1) as languageid from tblleadapplicant  where leadapplicantId = {0}", LeadId), CommandType.Text)
    End Function

    Public Shared Function GetLeadIdfromClientId(ByVal ClientId As Integer) As Integer
        Return SqlHelper.ExecuteScalar(String.Format("Select leadapplicantid from vw_LeadApplicant_Client  where clientId = {0} ", ClientId), CommandType.Text)
    End Function

    Public Shared Sub ReturnToCID(ByVal ClientId As Integer, ByVal Notes As String, ByVal UserId As Integer)
        Dim leadApplicantId As Integer = GetLeadIdfromClientId(ClientId)
        SmartDebtorHelper.ReturnToCID(leadApplicantId, Notes, CallVerificationHelper.FailedVerificationStatus, UserId)
    End Sub

    Public Shared Function CreatePDFfromHTML(ByVal HtmlText As String, ByVal filename As String) As String
        Dim pathname As String = ConfigurationManager.AppSettings("leadDocumentsDir").ToString.Replace("\", "\\")
        Dim pdfName As String = Path.Combine(pathname, filename & "_" & Guid.NewGuid.ToString & ".pdf")
        Dim sr As StringReader = Nothing
        Dim Doc As iTextSharp.text.Document = Nothing

        Try
            sr = New StringReader(HtmlText)
            Doc = New iTextSharp.text.Document(PageSize.A4, 5, 5, 5, 5)
            Dim wr As PdfWriter = PdfWriter.GetInstance(Doc, New FileStream(pdfName, FileMode.Create))
            Doc.Open()
            Dim worker As html.simpleparser.HTMLWorker = New iTextSharp.text.html.simpleparser.HTMLWorker(Doc)
            Dim lElements As ArrayList = html.simpleparser.HTMLWorker.ParseToList(sr, Nothing)
            Dim ct As ColumnText = New ColumnText(wr.DirectContent)
            ct.SetSimpleColumn(5, 5, PageSize.A4.Width - 5, PageSize.A4.Height - 5)
            For Each Element As IElement In lElements
                ct.AddElement(Element)
            Next
            Doc.NewPage()
        Catch ex As Exception
            pdfName = ""
        Finally
            If Not Doc Is Nothing Then Doc.Close()
            If Not sr Is Nothing Then sr.Close()
        End Try

        Return pdfName
    End Function

    Public Shared Function CreatePDF(ByVal VerificationId As Integer, ByVal dtQuestions As DataTable) As String
        Dim dtClientInfo As DataTable
        Try
            dtClientInfo = CallVerificationHelper.GetCallVerificationClientInfo(VerificationId)
        Catch ex As Exception
            Return ""
        End Try
        Return ClientFileDocumentHelper.GenerateVerificationCallPdf(VerificationId, dtQuestions, dtClientInfo)
    End Function

    Public Shared Function AttachPDFDocument(ByVal ClientID As Integer, ByVal UserID As Integer, ByVal SourceFile As String) As String
        Dim destFile As String = String.Empty
        Dim DocTypeId As String = "9072"
        Dim DocFolder As String = "ClientDocs"
        Dim destDir As String = SharedFunctions.DocumentAttachment.CreateDirForClient(ClientID) & String.Format("{0}\", DocFolder)
        Dim docName As String
        If IO.File.Exists(SourceFile) Then
            docName = ReportsHelper.GetUniqueDocumentName(ClientID, DocTypeId)
            destFile = Path.Combine(destDir, docName)
            IO.File.Move(SourceFile, destFile)
            SharedFunctions.DocumentAttachment.AttachDocument("client", ClientID, docName, UserID, DocFolder)
            SharedFunctions.DocumentAttachment.CreateScan(docName, UserID, Now, "")
            InsertCompletionNote(ClientID, UserID)
        End If
        Return destFile
    End Function

    Private Shared Sub InsertCompletionNote(ByVal Clientid As Integer, ByVal UserId As Integer)
        Try
            Dim username As String = Drg.Util.DataAccess.DataHelper.FieldLookup("tbluser", "username", "userid = " & UserId)
            Dim NoteID As Integer = Drg.Util.DataHelpers.NoteHelper.InsertNote(String.Format("Verification Call completed successfully on {0} by {1}.", Now.ToString, username), UserId, Clientid)
        Catch ex As Exception
            'Ignore error
        End Try
    End Sub

    Public Shared Function GetCallVerificationAnswers(ByVal VerificationId As Integer) As DataTable
        Return SqlHelper.GetDataTable("Select QuestionNo, AnsweredNo from tblverificationcalllog Where VerificationCallId = " & VerificationId, CommandType.Text, Nothing)
    End Function

    Public Shared Function GetInitialFeeCategory(ByVal TotalDebt As Decimal) As Integer
        If TotalDebt > 12500 Then
            Return 12
        ElseIf TotalDebt >= 7500 Then
            Return 14
        ElseIf TotalDebt >= 5000 Then
            Return 11
        Else
            Return 10
        End If
    End Function

    Public Shared Function GetInitialFeeAmount(ByVal PropertyCategoryID As Integer) As Decimal
        Return SqlHelper.ExecuteScalar(String.Format("Select [InitialFees] = sum(cast(value as money)) from tblproperty Where propertycategoryid = {0} and IsInitialFee = 1 ", PropertyCategoryID), CommandType.Text)
    End Function

    Public Shared Function GetVerificationRecordedCall(ByVal VerificationCallId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select c.clientid, c.leadapplicantid, c.executedby as userid, vicifilename from tblverificationcall c where c.verificationcallid = {0}", VerificationCallId), CommandType.Text)
    End Function

End Class
