Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Public Class DialerHelper

    Public Shared Function GetLastCalls(ByVal UserId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)
        Dim dt As DataTable = SqlHelper.GetDataTable("stp_Dialer_GetLastCalls", CommandType.StoredProcedure, params.ToArray)
        Return dt
    End Function

    Public Shared Function GetClientIssuesSettlements(ByVal ClientId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)
        Dim dt As DataTable = SqlHelper.GetDataTable("stp_Dialer_GetClientIssues_Settlements", CommandType.StoredProcedure, params.ToArray)
        Return dt
    End Function

    Public Shared Function GetCallResolutions4Settlements(ByVal CallMadeId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@CallMadeId", SqlDbType.Int)
        param.Value = CallMadeId
        params.Add(param)
        Dim dt As DataTable = SqlHelper.GetDataTable("stp_Dialer_GetCallResolutions4Settl", CommandType.StoredProcedure, params.ToArray)
        Return dt
    End Function

    Public Shared Function GetTopSettlementCallResolutionIssue(ByVal CallMadeId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@CallMadeId", SqlDbType.Int)
        param.Value = CallMadeId
        params.Add(param)
        Dim dt As DataTable = SqlHelper.GetDataTable("stp_Dialer_GetTopSettlementCallResolution", CommandType.StoredProcedure, params.ToArray)
        Return dt
    End Function

    Public Shared Function GetClientIssuesNonDeposits(ByVal ClientId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)
        Dim dt As DataTable = SqlHelper.GetDataTable("stp_NonDeposit_GetClientIssues_NonDeposits", CommandType.StoredProcedure, params.ToArray)
        Return dt
    End Function

    Public Shared Function GetCallResolutions4NonDeposits(ByVal CallMadeId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@CallMadeId", SqlDbType.Int)
        param.Value = CallMadeId
        params.Add(param)
        Dim dt As DataTable = SqlHelper.GetDataTable("stp_NonDeposit_GetCallResolutions4NonDeposit", CommandType.StoredProcedure, params.ToArray)
        Return dt
    End Function

    Public Shared Function GetClientBankInfo(ByVal ClientId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)
        Dim dt As DataTable = SqlHelper.GetDataTable("stp_Dialer_GetBankInfo", CommandType.StoredProcedure, params.ToArray)
        Return dt
    End Function

    Public Shared Function GetCreditorInfo(ByVal AccountId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@AccountId", SqlDbType.Int)
        param.Value = AccountId
        params.Add(param)
        Dim dt As DataTable = SqlHelper.GetDataTable("stp_GetSettlementCreditorInfo", CommandType.StoredProcedure, params.ToArray)
        Return dt
    End Function

    Public Shared Function GetClientData(ByVal ClientId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select c.clientid, c.companyId, isnull(p.FirstName,'') + ' ' + isnull(p.LastName,'') as ClientName, c.AccountNumber as [ClientAccountNumber], s.Name as [Status], m.[Name] as LawFirm, isnull(p.SSN,'') as SSN, p.DateOfBirth, c.SDABalance, c.PFOBalance, isnull( p.LanguageId,1) as LanguageId, Hardship=(select max(hardshipdate) from tblhardshipdata where clientid = {0}), [Address]= isnull(p.Street,'') + ' ' + isnull(street2, '') + ' ' + isnull((select s.Abbreviation from tblstate s where s.stateid=p.stateid),'') + ' ' + isnull(zipcode,'') from tblclient c inner join tblperson p on p.personid = c.primarypersonid inner join tblclientstatus s on s.clientstatusid = c.currentclientstatusid inner join tblcompany m on m.companyid = c.companyid where c.clientid = {0} ", ClientId), CommandType.Text)
    End Function

    Public Shared Function GetCIDRep(ByVal ClientId As Integer) As String
        Try
            Return SqlHelper.ExecuteScalar(String.Format("Select Substring(isnull(u.FirstName,''),1,1) + '. '  + isnull(u.LastName,'') as CIDRep from vw_leadapplicant_client w inner join tblleadapplicant l on l.leadapplicantid = w.leadapplicantid inner join tbluser u on u.userid = l.repid  where w.clientid = {0}", ClientId), CommandType.Text)
        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Function GetClientServicesPhoneNumber(ByVal CompanyId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select top 1 PhoneNumber  from tblcompanyphones where CompanyId = {0} and PhoneType = 46", CompanyId), CommandType.Text)
    End Function

    Public Shared Function IsSettlementStipulation(ByVal SettlementId As Integer) As Boolean
        Return SqlHelper.ExecuteScalar(String.Format("select isnull(isclientstipulation,0) from tblsettlements where settlementid = {0}", SettlementId), CommandType.Text)
    End Function

    Public Shared Function GetPersonData(ByVal PersonId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select p.SSN as SSN, p.DateOfBirth, [Address]= isnull(p.Street,'') + ' ' + isnull(street2, '') + ' ' + isnull((select s.Abbreviation from tblstate s where s.stateid=p.stateid),'') + ' ' + isnull(zipcode,'') from tblperson p  where p.personid = {0} ", PersonId), CommandType.Text)
    End Function

    Public Shared Function GetClientDialerResumeAfterDate(ByVal ClientId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select c.dialerresumeafter from tblclient c where c.clientid = {0}", ClientId), CommandType.Text)
    End Function

    Public Shared Function GetMatterDialerResumeAfterDate(ByVal MatterId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select m.dialerretryafter as dialerresumeafter from tblmatter m where m.matterid = {0}", MatterId), CommandType.Text)
    End Function

    Public Shared Function GetUserFullName(ByVal UserId As Integer) As String
        Return SqlHelper.ExecuteScalar(String.Format("Select isnull(FirstName,'') + ' ' + isnull(LastName,'') as UserFullName  from tbluser where userid = {0} ", UserId), CommandType.Text)
    End Function

    Public Shared Function GetUserId(ByVal UserName As String, ByVal Password As String) As Integer
        Try
            Return SqlHelper.ExecuteScalar(String.Format("Select userid from tbluser where username = '{0}' and password = '{1}'", UserName, Password), CommandType.Text)
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function GetDialerCall(ByVal CallMadeId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select d.*, isnull(u.firstname, '') + ' ' + isnull(u.lastname, '') as [FirstAnsweredBy], isnull(u1.firstname,'') + ' ' + isnull(u1.lastname,'') as [ModifiedBy], [PhoneId] = p.PhoneId, p.areacode + p.number as [phone], t.[name] as [phonetype], [ext] = isnull(p.extension,'') from tblDialerCall d left join tbluser u on u.userid = d.answeredby left join tbluser u1 on u1.userid = d.lastmodifiedby inner join tblPhone p on d.phoneid = p.phoneid inner join tblphonetype t on t.phonetypeid = p.phonetypeid where d.CallMadeId = {0} ", CallMadeId), CommandType.Text)
    End Function

    Public Shared Function GetResultTypes() As DataTable
        Return SqlHelper.GetDataTable("Select * from tblDialerCallResultType order by Result", CommandType.Text)
    End Function

    Public Shared Function GetReasons() As DataTable
        Return SqlHelper.GetDataTable("Select * from tblDialerCallReasonType", CommandType.Text)
    End Function

    Public Shared Function GetReason(ByVal ReasonId As Integer) As DataRow
        Return SqlHelper.GetDataTable("Select * from tblDialerCallReasonType where reasonId = " & ReasonId, CommandType.Text).Rows(0)
    End Function

    Public Shared Function GetFilteredResultTypes() As DataTable
        Return SqlHelper.GetDataTable("Select * from tblDialerCallResultType Where ResultTypeId in (1,3) order by Result", CommandType.Text)
    End Function

    Public Shared Function GetRejectReasons() As DataTable
        Return SqlHelper.GetDataTable("Select * from tblClientRejectionReason", CommandType.Text)
    End Function

    Public Shared Function GetLeadDialerCall(ByVal IntercomParty As String) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select top 1 * from tblLeadDialerCall where CallidKey Like '{0}%' and exception is null and created > dateadd(d,-3, getdate())  order by created desc", IntercomParty), CommandType.Text)
    End Function

    Public Shared Function GetLeadDialerCallById(ByVal CallMadeId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select * from tblLeadDialerCall where CallMadeId = {0}", CallMadeId), CommandType.Text)
    End Function

    Public Shared Function GetDialerCall(ByVal CallIdKey As String) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select * from tblDialerCall where CallidKey = '{0}' ", CallIdKey), CommandType.Text)
    End Function

    Public Shared Function CallIssuesCreated(ByVal CallMadeId As Integer, ByVal ReasonId As Integer) As Boolean
        Return CInt(SqlHelper.ExecuteScalar(String.Format("Select  count(callresolutionid) as ct  from tblDialerCallResolution where CallMadeId = {0} and ReasonId = {1}", CallMadeId, ReasonId), CommandType.Text)) > 0
    End Function

    Public Shared Function CallPickedUp(ByVal CallIdKey As String) As Boolean
        Return CInt(SqlHelper.ExecuteScalar(String.Format("Select  count(callmadeid) as ct  from tblDialerCall where CallidKey = '{0}' and Answeredby is not null", CallIdKey), CommandType.Text)) > 0
    End Function

    Public Shared Function InsertCallMade(ByVal ClientId As Integer, ByVal PhoneId As Integer, ByVal ReasonId As Integer, ByVal WorkGroupQueueId As Integer, ByVal CreatedBy As Integer, ByVal PrimaryCallMadeId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)

        param = New SqlParameter("@PhoneId", SqlDbType.Int)
        param.Value = PhoneId
        params.Add(param)

        param = New SqlParameter("@ReasonId", SqlDbType.Int)
        param.Value = ReasonId
        params.Add(param)

        param = New SqlParameter("@WorkGroupQueueId", SqlDbType.Int)
        param.Value = WorkGroupQueueId
        params.Add(param)

        param = New SqlParameter("@CreatedBy", SqlDbType.Int)
        param.Value = CreatedBy
        params.Add(param)

        param = New SqlParameter("@PrimaryCallMadeId", SqlDbType.Int)
        param.Value = PrimaryCallMadeId
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_Dialer_InsertCallMade", CommandType.StoredProcedure, params.ToArray))
    End Function

    Public Shared Sub UpdateCallMade(ByVal CallMadeId As Integer, ByVal Result As Integer, ByVal RetryAfter As Nullable(Of DateTime), ByVal PickupDate As Nullable(Of DateTime), ByVal PickupBy As Integer, ByVal LastModified As Nullable(Of DateTime), ByVal LastModifiedBy As Integer, ByVal OutboundCallKey As String)
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@CallMadeId", SqlDbType.Int)
        param.Value = CallMadeId
        params.Add(param)

        If Result > 0 Then
            param = New SqlParameter("@ResultId", SqlDbType.Int)
            param.Value = Result
            params.Add(param)
        End If

        If RetryAfter.HasValue Then
            param = New SqlParameter("@RetryAfter", SqlDbType.DateTime)
            param.Value = RetryAfter.Value
            params.Add(param)
        End If

        If PickupDate.HasValue Then
            param = New SqlParameter("@AnsweredDate", SqlDbType.DateTime)
            param.Value = PickupDate.Value
            params.Add(param)
        End If

        If PickupBy <> 0 Then
            param = New SqlParameter("@AnsweredBy", SqlDbType.Int)
            param.Value = PickupBy
            params.Add(param)
        End If

        If LastModified.HasValue Then
            param = New SqlParameter("@LastModified", SqlDbType.DateTime)
            param.Value = LastModified.Value
            params.Add(param)
        End If

        If LastModifiedBy <> 0 Then
            param = New SqlParameter("@LastModifiedBy", SqlDbType.Int)
            param.Value = LastModifiedBy
            params.Add(param)
        End If

        If OutboundCallKey.Trim.Length > 0 Then
            param = New SqlParameter("@OutboundCallKey", SqlDbType.VarChar)
            param.Value = OutboundCallKey
            params.Add(param)
        End If

        SqlHelper.ExecuteNonQuery("stp_Dialer_UpdateCallMade", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Function InsertCallResolution(ByVal CallMadeId As Integer, ByVal ReasonId As Integer, ByVal TableName As String, ByVal FieldName As String, ByVal FieldValue As String, ByVal Expiration As DateTime, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@CallMadeId", SqlDbType.Int)
        param.Value = CallMadeId
        params.Add(param)

        param = New SqlParameter("@ReasonId", SqlDbType.Int)
        param.Value = ReasonId
        params.Add(param)

        If TableName.Trim.Length > 0 Then
            param = New SqlParameter("@TableName", SqlDbType.VarChar)
            param.Value = TableName
            params.Add(param)
        End If

        If FieldName.Trim.Length > 0 Then
            param = New SqlParameter("@FieldName", SqlDbType.VarChar)
            param.Value = FieldName
            params.Add(param)
        End If

        param = New SqlParameter("@FieldValue", SqlDbType.VarChar)
        param.Value = FieldValue
        params.Add(param)

        param = New SqlParameter("@Expiration", SqlDbType.DateTime)
        param.Value = Expiration
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_Dialer_InsertCallResolution", CommandType.StoredProcedure, params.ToArray))

    End Function

    Public Shared Sub UpdateCallResolution(ByVal CallResolutionId As Integer, ByVal Expiration As Nullable(Of DateTime), ByVal RecordingId As Integer, ByVal UserId As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@CallResolutionId", SqlDbType.Int)
        param.Value = CallResolutionId
        params.Add(param)

        If Expiration.HasValue Then
            param = New SqlParameter("@Expiration", SqlDbType.DateTime)
            param.Value = Expiration.Value
            params.Add(param)
        End If

        If RecordingId > 0 Then
            param = New SqlParameter("@RecordingId", SqlDbType.Int)
            param.Value = RecordingId
            params.Add(param)
        End If

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_DialerUpdateCallResolution", CommandType.StoredProcedure, params.ToArray)

    End Sub

    Public Shared Sub ApproveSettlement(ByVal SettlementId As Integer, ByVal IsApproved As Boolean, ByVal Note As String, ByVal ApprovalType As String, ByVal ReasonName As String, ByVal DateString As String, ByVal DocId As String, ByVal SubFolder As String, ByVal DocTypeId As String, ByVal UserId As Integer)

        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@SettlementId", SqlDbType.Int)
        param.Value = SettlementId
        params.Add(param)

        param = New SqlParameter("@IsApproved", SqlDbType.Bit)
        param.Value = IIf(IsApproved, 1, 0)
        params.Add(param)

        param = New SqlParameter("@Note", SqlDbType.VarChar)
        param.Value = Note
        params.Add(param)

        param = New SqlParameter("@CreatedBy", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        param = New SqlParameter("@ApprovalType", SqlDbType.VarChar)
        param.Value = ApprovalType
        params.Add(param)

        If ReasonName.Trim.Length > 0 Then
            param = New SqlParameter("@ReasonName", SqlDbType.VarChar)
            param.Value = ReasonName
            params.Add(param)
        End If

        param = New SqlParameter("@DateString", SqlDbType.NVarChar)
        param.Value = DateString
        params.Add(param)

        param = New SqlParameter("@DocId", SqlDbType.NVarChar)
        param.Value = DocId
        params.Add(param)

        param = New SqlParameter("@SubFolder", SqlDbType.NVarChar)
        param.Value = SubFolder
        params.Add(param)

        param = New SqlParameter("@DocTypeId", SqlDbType.NVarChar)
        param.Value = DocTypeId
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_ResolveClientApprovalTask", CommandType.StoredProcedure, params.ToArray)

    End Sub

    Public Shared Function GetClientLanguageForSett(ByVal SettlementId As Integer) As Integer
        Try
            Return CInt(SqlHelper.ExecuteScalar(String.Format("Select p.LanguageId from tblperson p inner join tblclient c on p.personid = c.primarypersonid inner join tblsettlements s on s.clientid = c.clientid and s.settlementid = {0}", SettlementId), CommandType.Text))
        Catch ex As Exception
            Return 1
        End Try
    End Function

    Public Shared Function InsertSettlementRecordedCall(ByVal SettlementId As Integer, ByVal CallIdKey As String, ByVal LanguageId As Integer, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@SettlementId", SqlDbType.Int)
        param.Value = SettlementId
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

        Return CInt(SqlHelper.ExecuteScalar("stp_InsertSettlementRecordedCall", CommandType.StoredProcedure, params.ToArray))

    End Function

    Public Shared Function UpdateSettlementRecordedCall(ByVal SettlementRecId As Integer, ByVal EndDate As Nullable(Of DateTime), ByVal Completed As Nullable(Of Boolean), ByVal RecId As Integer, ByVal LastStep As String, ByVal ViciFileName As String) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@SettlementRecId", SqlDbType.Int)
        param.Value = SettlementRecId
        params.Add(param)

        If EndDate.HasValue Then
            param = New SqlParameter("@EndDate", SqlDbType.DateTime)
            param.Value = EndDate.Value
            params.Add(param)
        End If

        If RecId > 0 Then
            param = New SqlParameter("@RecId", SqlDbType.Int)
            param.Value = RecId
            params.Add(param)
        End If

        If Completed.HasValue Then
            param = New SqlParameter("@Completed", SqlDbType.Bit)
            param.Value = IIf(Completed.Value, 1, 0)
            params.Add(param)
        End If

        If LastStep.Trim.Length > 0 Then
            param = New SqlParameter("@LastStep", SqlDbType.VarChar)
            param.Value = LastStep
            params.Add(param)
        End If

        If ViciFileName.Trim.Length > 0 Then
            param = New SqlParameter("@ViciFileName", SqlDbType.VarChar)
            param.Value = ViciFileName.Trim
            params.Add(param)
        End If

        Return CInt(SqlHelper.ExecuteScalar("stp_UpdateSettlementRecordedCall", CommandType.StoredProcedure, params.ToArray))

    End Function

    Public Shared Function GetNotSettleAccountCount(ByVal ClientId As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar(String.Format("Select  count(accountid) as ct  from tblAccount where ClientId = {0} and AccountStatusId not in (54, 55)", ClientId), CommandType.Text))
    End Function

    Public Shared Sub UpdateDialerRetryDate(ByVal Clientid As Integer, ByVal RetryDate As Nullable(Of DateTime))
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = Clientid
        params.Add(param)

        If RetryDate.HasValue Then
            param = New SqlParameter("@DialerResumeAfter", SqlDbType.DateTime)
            param.Value = RetryDate.Value
            params.Add(param)
        End If

        SqlHelper.ExecuteNonQuery("stp_Dialer_UpdateClient", CommandType.StoredProcedure, params.ToArray)

        CancelVicidialPendingCalls(Clientid, VicidialGlobals.ViciClientSource.ToUpper)
    End Sub

    Public Shared Sub UpdateMatterRetryDate(ByVal Matterid As Integer, ByVal RetryDate As Nullable(Of DateTime))
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@MatterId", SqlDbType.Int)
        param.Value = Matterid
        params.Add(param)

        If RetryDate.HasValue Then
            param = New SqlParameter("@DialerRetryAfter", SqlDbType.DateTime)
            param.Value = RetryDate.Value
            params.Add(param)
        End If

        SqlHelper.ExecuteNonQuery("Update tblMatter Set DialerRetryAfter = @DialerRetryAfter Where MatterId = @MatterId", CommandType.Text, params.ToArray)

        CancelVicidialPendingCalls(Matterid, VicidialGlobals.ViciMatterSource.ToUpper)
    End Sub

    Public Shared Function GetApplicants(ByVal ClientId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_GetPersonsForClient", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function GetPersonIdByPhone(ByVal PhoneId As Integer) As Integer
        Dim sqlStr = String.Format("Select top 1 personid from tblpersonphone where phoneid = {0}", PhoneId)
        Return CInt(SqlHelper.ExecuteScalar(sqlStr, CommandType.Text))
    End Function


    Public Shared Sub UpdateLeadCallMade(ByVal CallMadeId As Integer, ByVal CallIdKey As String, ByVal Exception As String, ByVal UserId As Nullable(Of Integer), ByVal OutboundCallId As String, ByVal ResultId As Nullable(Of Integer))
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@CallMadeId", SqlDbType.Int)
        param.Value = CallMadeId
        params.Add(param)

        If CallIdKey.Trim.Length > 0 Then
            param = New SqlParameter("@CallIdKey", SqlDbType.VarChar)
            param.Value = CallIdKey
            params.Add(param)
        End If

        If OutboundCallId.Trim.Length > 0 Then
            param = New SqlParameter("@OutboundCallKey", SqlDbType.VarChar)
            param.Value = OutboundCallId.Trim
            params.Add(param)
        End If

        If Exception.Trim.Length > 0 Then
            param = New SqlParameter("@Exception", SqlDbType.VarChar)
            param.Value = Exception
            params.Add(param)
        End If

        If UserId.HasValue Then
            param = New SqlParameter("@PickedupDate", SqlDbType.DateTime)
            param.Value = Now
            params.Add(param)

            param = New SqlParameter("@PickedupBy", SqlDbType.Int)
            param.Value = UserId.Value
            params.Add(param)
        End If

        If ResultId.HasValue Then
            param = New SqlParameter("@ResultId", SqlDbType.Int)
            param.Value = ResultId
            params.Add(param)
        End If

        SqlHelper.ExecuteNonQuery("stp_Dialer_UpdateLeadCall", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Sub UpdateLeadApplicant(ByVal LeadApplicantId As Integer, ByVal RetryAfter As Nullable(Of DateTime), ByVal RecycleDate As Nullable(Of DateTime))
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@LeadApplicantId", SqlDbType.Int)
        param.Value = LeadApplicantId
        params.Add(param)

        If RetryAfter.HasValue Then
            param = New SqlParameter("@RetryAfter", SqlDbType.DateTime)
            param.Value = RetryAfter.Value
            params.Add(param)
        End If

        If RecycleDate.HasValue Then
            param = New SqlParameter("@RecycleDate", SqlDbType.DateTime)
            param.Value = RecycleDate.Value
            params.Add(param)
        End If

        SqlHelper.ExecuteNonQuery("stp_Dialer_UpdateLead", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Sub SetDialerUnableContactLead(ByVal LeadApplicantId As Integer, ByVal UserId As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("update tblleadapplicant set statusid=1 where leadapplicantid={0}", LeadApplicantId), CommandType.Text)
        Dim parentID As Integer = LeadRoadmapHelper.GetRoadmapID(LeadApplicantId)
        LeadRoadmapHelper.InsertRoadmap(LeadApplicantId, 1, parentID, "Dialer unable to contact lead.", UserId)
    End Sub


    Public Shared Sub ChangeLeadStatus(ByVal LeadApplicantId As Integer, ByVal StatusId As Integer, ByVal ReasonId As Nullable(Of Integer), ByVal Reason As String, ByVal UserId As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@LeadApplicantId", SqlDbType.Int)
        param.Value = LeadApplicantId
        params.Add(param)

        param = New SqlParameter("@StatusId", SqlDbType.Int)
        param.Value = StatusId
        params.Add(param)

        If ReasonId.HasValue Then
            param = New SqlParameter("@ReasonId", SqlDbType.Int)
            param.Value = ReasonId.Value
            params.Add(param)
        End If

        If Reason.Trim.Length > 0 Then
            param = New SqlParameter("@Reason", SqlDbType.VarChar)
            param.Value = Reason.Trim
            params.Add(param)
        End If

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_Dialer_LeadChangeStatus", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Function GetLeadStatusForCallResult(ByVal CallResultId As Integer) As Integer
        Try
            Dim sqlStr = String.Format("Select LeadStatusid from tblLeadDialerCallResultType where LeadResultTypeId = {0}", CallResultId)
            Return CInt(SqlHelper.ExecuteScalar(sqlStr, CommandType.Text))
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function GetLeadReasonForCallResult(ByVal CallResultId As Integer) As Nullable(Of Integer)
        Try
            Dim sqlStr = String.Format("Select LeadReasonid from tblLeadDialerCallResultType where LeadResultTypeId = {0}", CallResultId)
            Return CInt(SqlHelper.ExecuteScalar(sqlStr, CommandType.Text))
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    Public Shared Function GetLeadReason(ByVal LeadApplicantId As Integer) As Nullable(Of Integer)
        Try
            Dim sqlStr = String.Format("Select ReasonId from tblLeadApplicant  where LeadApplicantId = {0}", LeadApplicantId)
            Return CInt(SqlHelper.ExecuteScalar(sqlStr, CommandType.Text))
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    Public Shared Function GetLeadStatus(ByVal LeadApplicantId As Integer) As Integer
        Try
            Dim sqlStr = String.Format("Select Statusid from tblLeadApplicant where LeadApplicantId = {0}", LeadApplicantId)
            Return CInt(SqlHelper.ExecuteScalar(sqlStr, CommandType.Text))
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function CIDDialerChangeStatusOnDisconnect(ByVal LeadApplicantId As Integer, ByVal CallResultId As Integer, ByVal UserId As Integer) As Boolean

        Dim oldLeadStatusId As Integer = GetLeadStatus(LeadApplicantId)
        Dim newLeadStatusId As Integer = GetLeadStatusForCallResult(CallResultId)
        Dim CanChangeToStatus As Boolean = CanChangeLeadStatus(oldLeadStatusId, newLeadStatusId)
        If CanChangeToStatus Then
            Dim reasonId As Nullable(Of Integer) = Nothing
            'Get Reason for bad Lead
            If newLeadStatusId = 14 Then
                reasonId = GetLeadReasonForCallResult(CallResultId)
            End If
            ChangeLeadStatus(LeadApplicantId, newLeadStatusId, reasonId, "CID Dialer call result", UserId)
        End If

        Return CanChangeToStatus

    End Function

    Public Shared Function CanChangeLeadStatus(ByVal OldStatusId As Integer, ByVal NewStatusId As Integer) As Boolean
        Return CBool(SqlHelper.ExecuteScalar(String.Format("select dbo.fn_Vici_AllowLeadStatusTransition({0},{1})", OldStatusId, NewStatusId), CommandType.Text))
    End Function

    Public Shared Function GetCIDCallOutboundKey(ByVal CallMadeId As Integer) As String
        Try
            Dim sqlStr = String.Format("Select OutboundCallKey from tblLeadDialerCall where CallMadeId = {0}", CallMadeId)
            Return SqlHelper.ExecuteScalar(sqlStr, CommandType.Text).ToString
        Catch ex As Exception
            Return String.Empty
        End Try
    End Function

    Public Shared Sub ExcludePhoneNumberFromDialer(ByVal PhoneId As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("Update tblPhone Set ExcludeFromDialer = 1 Where PhoneId = {0} ", PhoneId), CommandType.Text)
    End Sub

    Public Shared Function GetTodayMessagesLeftCount(ByVal ClientId As Integer, ByVal PhoneId As Integer) As Integer
        Try
            Dim sqlStr As String = String.Format("Select Count(CallMadeId) as Ct from tblDialerCall Where ClientId = {0} and resultid = 3 and Convert(varchar, Started, 101) = Convert(varchar, GetDate(), 101) and PhoneId = {1}", ClientId, PhoneId)
            Return CInt(SqlHelper.ExecuteScalar(sqlStr, CommandType.Text, Nothing))
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function GetOutboundAni(ByVal ClientId As Integer, ByVal ReasonId As Integer) As String
        Try
            Dim params As New List(Of SqlParameter)
            Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
            param.Value = ClientId
            params.Add(param)

            param = New SqlParameter("@ReasonId", SqlDbType.Int)
            param.Value = ReasonId
            params.Add(param)

            Dim dt As DataTable = SqlHelper.GetDataTable("stp_DialerGetClientLawFirmAni", CommandType.StoredProcedure, params.ToArray)

            Return dt.Rows(0)("CustomAni")

        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Sub UpdateMatterDialerResumeTime(ByVal MatterId As Integer, ByVal ScheduledDate As DateTime, ByVal usernote As String, ByVal UserId As Integer, ByVal ClientId As Integer)
        DialerHelper.UpdateMatterRetryDate(MatterId, ScheduledDate)
        Dim note As String = String.Format("Matter #{0} has been excluded from dialer until {1} {2}. {3}", MatterId, ScheduledDate.ToShortDateString, ScheduledDate.ToShortTimeString, usernote)
        Dim noteID As Integer = Drg.Util.DataHelpers.NoteHelper.InsertNote(note, UserId, ClientId)
        Drg.Util.DataHelpers.NoteHelper.RelateNote(noteID, 19, MatterId)
    End Sub

    Public Shared Sub UpdateMattersNextTimeToCall(ByVal CallMadeId As Integer, ByVal ReasonId As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@CallMadeId", SqlDbType.Int)
        param.Value = CallMadeId
        params.Add(param)

        param = New SqlParameter("@ReasonId", SqlDbType.Int)
        param.Value = ReasonId
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_Dialer_UpdateNextMatterCallTime", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Function GetMonthlyFee(ByVal ClientId As Integer) As Double
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)
        Return CDbl(SqlHelper.ExecuteScalar("stp_GetMonthlyFee", CommandType.StoredProcedure, params.ToArray))
    End Function

    Public Shared Function InsertMatterLog(ByVal PrimaryCallMadeId As Integer, ByVal MatterId As Integer, ByVal ReasonId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@PrimaryCallMadeId", SqlDbType.Int)
        param.Value = PrimaryCallMadeId
        params.Add(param)

        param = New SqlParameter("@MatterId", SqlDbType.Int)
        param.Value = MatterId
        params.Add(param)

        param = New SqlParameter("@ReasonId", SqlDbType.Int)
        param.Value = ReasonId
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_Dialer_InsertMatterLog", CommandType.StoredProcedure, params.ToArray))
    End Function

    Public Shared Function InsertClientLog(ByVal ClientId As Integer, ByVal ReasonId As Integer) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)

        param = New SqlParameter("@ReasonId", SqlDbType.Int)
        param.Value = ReasonId
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_Dialer_InsertClientLog", CommandType.StoredProcedure, params.ToArray))
    End Function

    Public Shared Function GetClientMatters(ByVal ClientId As Integer, ByVal reasonId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@ClientId", SqlDbType.Int)
        param.Value = ClientId
        params.Add(param)
        Dim sp As String = String.Empty
        Select Case reasonId
            Case 1
                sp = "stp_Dialer_GetClientIssues_Settlements"
            Case 2, 3
                sp = "stp_NonDeposit_GetClientIssues_NonDeposits"
        End Select
        Return SqlHelper.GetDataTable(sp, CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Sub LogMatterCall(ByVal ClientId As Integer, ByVal ReasonId As Integer, ByVal PrimaryCallId As Integer)
        Dim dt As DataTable = DialerHelper.GetClientMatters(ClientId, ReasonId)
        If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
            For Each dr As DataRow In dt.Rows
                DialerHelper.InsertMatterLog(PrimaryCallId, dr("matterid"), ReasonId)
            Next
        End If
    End Sub

    Public Shared Function GetSettlementRecordedCall(ByVal SettlementRecId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select s.clientid, s.matterid, c.recid, c.executedby as userid from tblsettlementrecordedcall c join tblsettlements s on c.settlementid = s.settlementid where c.settlementrecid = {0}", SettlementRecId), CommandType.Text)
    End Function

    Private Shared Sub CancelVicidialPendingCalls(ByVal LeadId As Integer, ByVal SourceId As String)
        Try
            VicidialHelper.CancelPendingLeadCalls(0, LeadId, SourceId)
        Catch ex As Exception
            'Ignore
        End Try
    End Sub

End Class
