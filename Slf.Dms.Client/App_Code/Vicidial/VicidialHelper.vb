Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Public Class VicidialHelper

    Public Shared Sub InsertLeadNote(ByVal noteText As String, ByVal LeadId As Integer, ByVal UserId As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("INSERT INTO tblLeadNotes (LeadApplicantID, notetypeid, NoteType, Value, Created, CreatedByID, Modified, ModifiedBy) VALUES ({0}, 0 ,'Phone', '{1}', GetDate(), {2}, GetDate(), {2})", LeadId, noteText, UserId), Data.CommandType.Text)
    End Sub

    Public Shared Function GetLeadByPhone(ByVal PhoneNumber As String) As Integer
        Try
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter With {.ParameterName = "@phonenumber", .SqlDbType = Data.SqlDbType.VarChar, .Value = PhoneNumber})
            Return (CInt(SqlHelper.ExecuteScalar("stp_Vici_GetLeadByPhone", Data.CommandType.StoredProcedure, params.ToArray)))
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function GetClientByPhone(ByVal PhoneNumber As String) As Integer
        Try
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter With {.ParameterName = "@phonenumber", .SqlDbType = Data.SqlDbType.VarChar, .Value = PhoneNumber})
            Return CInt(SqlHelper.GetDataTable("stp_GetCallClientSearches", Data.CommandType.StoredProcedure, params.ToArray).Rows(0)("ClientId"))
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Private Shared Function IsAutoGenPhoneNumber(ByVal ViciLeadId As Integer) As Boolean
        Try
            Dim phonenumber As String = MySqlHelper.ExecuteScalar(String.Format("Select phone_number from vicidial_list where lead_id = {0};", ViciLeadId), CommandType.Text)
            Return (phonenumber.Trim.Length = "9" AndAlso AsteriskHelper.IsGeneratedNumber(phonenumber.Trim))
        Catch ex As Exception
            Return False
        End Try
    End Function

    Public Shared Function GetCallDirection(ByVal ViciLeadId As Integer) As String
        Dim direction As String = "OUT"
        If CInt(MySqlHelper.ExecuteScalar(String.Format("Select Count(lead_id) from vicidial_closer_log where lead_id = '{0}' and status='INCALL';", ViciLeadId), CommandType.Text)) > 0 Then
            direction = "IN"
        Else
            direction = "OUT"
        End If
        Return direction
    End Function

    Public Shared Sub ConnectCallWithLead(ByVal ViciLeadId As Integer, ByVal LeadId As Integer, ByVal SourceId As String)
        If LeadId > 0 Then
            'Link Call
            VicidialHelper.UpdateVendorCode(ViciLeadId, LeadId, SourceId)
            'Cancel other pending dialer calls for 
            VicidialHelper.CancelPendingLeadCalls(ViciLeadId, LeadId, SourceId)
            'Update phone number if auto-generated
            If VicidialHelper.IsAutoGenPhoneNumber(ViciLeadId) Then
                Dim ph As String = VicidialHelper.GetLeadPhoneNumber(LeadId, SourceId)
                If ph.Trim.Length > 0 Then
                    VicidialHelper.UpdatePhoneNumber(ViciLeadId, ph.Trim)
                End If
            End If
        End If
    End Sub

    Public Shared Function GetLeadPhoneNumber(ByVal LeadId As Integer, ByVal SourceId As String) As String
        Dim PhoneNumber As String = ""
        Try
            Dim sqlStr As String = ""
            Select Case SourceId.ToLower
                Case VicidialGlobals.ViciLeadSource.ToLower
                    sqlStr = String.Format("Select leadphone from tblleadapplicant where leadapplicantid = {0}", LeadId)
                Case VicidialGlobals.ViciMatterSource.ToLower
                    sqlStr = String.Format("select top 1 cp.phone from tblmatter m left join vw_Vici_Client_Phones cp on cp.clientid = m.clientid and cp.ranked = 1 where m.matterid = {0}", LeadId)
                Case VicidialGlobals.ViciClientSource.ToLower
                    sqlStr = String.Format("select top 1 cp.phone from vw_Vici_Client_Phones cp where cp.ranked=1 and cp.clientid = {0}", LeadId)
                Case Else
                    Throw New Exception("sql command not defined yet.")
            End Select
            PhoneNumber = SqlHelper.ExecuteScalar(sqlStr, CommandType.Text).ToString.Trim()
        Catch ex As Exception
            'Return Empty String
        End Try
        Return PhoneNumber
    End Function

    Public Shared Function GetSourceByDID(ByVal DID As String) As String
        Try
            Return SqlHelper.ExecuteScalar(String.Format("Select top 1 SourceId from tblViciSourceDID  Where DID = '{0}'", DID), CommandType.Text).ToString.Trim
        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Function GetDefaultPageByDID(ByVal DID As String) As String
        Try
            Return SqlHelper.ExecuteScalar(String.Format("Select top 1 s.DefaultPage from tblViciSourceDID d inner join tblViciSource s on s.SourceId = d.SourceId Where d.DID = '{0}'", DID.Trim), CommandType.Text).ToString.Trim
        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Function GetDefaultPageByCampaign(ByVal Campaign As String) As String
        Try
            Return MySqlHelper.ExecuteScalar(String.Format("select web_form_address_two from vicidial_campaigns where campaign_id = '{0}';", Campaign.Trim), CommandType.Text).ToString.Trim
        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Sub InsertStopLeadRequest(ByVal LeadId As Integer, ByVal SourceId As String, ByVal RequestingProcess As String)
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@LeadId", SqlDbType.Int)
        param.Value = LeadId
        params.Add(param)

        param = New SqlParameter("@SourceId", SqlDbType.VarChar)
        param.Value = SourceId
        params.Add(param)

        param = New SqlParameter("@RequestingProcess", SqlDbType.VarChar)
        param.Value = RequestingProcess
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_Vici_InsertStopLeadRequest", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Private Shared Sub UpdateVendorCode(ByVal ViciLeadId As Integer, ByVal LeadId As Integer, ByVal SourceId As String)
        MySqlHelper.ExecuteNonQuery(String.Format("Update vicidial_list Set vendor_lead_code = '{1}', source_id = '{2}', security_phrase='' Where lead_id = {0} and (vendor_lead_code='' or vendor_lead_code='0' or vendor_lead_code is null) limit 1;", ViciLeadId, LeadId, SourceId), CommandType.Text)
    End Sub

    Public Shared Sub CancelPendingLeadCalls(ByVal ViciLeadId As Integer, ByVal LeadId As Integer, ByVal SourceId As String)
        Dim Status As String = "OTHERC"
        Dim sb As New StringBuilder
        sb.Append("Update vicidial_list Set ")
        sb.AppendFormat("status = '{0}', ", Status)
        sb.Append("modify_date = now(), ")
        sb.Append("called_since_last_reset = 'Y' ")
        Dim statuses As String = "'NEW','PND'"
        Select Case SourceId.ToLower
            Case VicidialGlobals.ViciLeadSource.ToLower
                statuses = "'NEW','PND','CBHOLD','CALLBK'"
                sb.AppendFormat(String.Format("Where lead_id <> {0} and vendor_lead_code = '{1}' and source_id = '{2}' and status in ({3}) ;", ViciLeadId, LeadId, SourceId, statuses))
            Case VicidialGlobals.ViciMatterSource.ToLower
                Dim clientid As Integer = NonDepositHelper.GetClientId(LeadId)
                sb.AppendFormat(String.Format("Where lead_id <> {0} and ((vendor_lead_code = '{1}' and source_id = '{2}') or (client_id = '{3}')) and status in ({4});", ViciLeadId, LeadId, SourceId, clientid, statuses))
            Case VicidialGlobals.ViciClientSource.ToLower
                sb.AppendFormat(String.Format("Where lead_id <> {0} and ((vendor_lead_code = '{1}' and source_id = '{2}') or (client_id = '{1}')) and status in ({3});", ViciLeadId, LeadId, SourceId, statuses))
            Case Else
                Return
        End Select
        MySqlHelper.ExecuteNonQuery(sb.ToString, CommandType.Text)
    End Sub

    Private Shared Function GetViciStatus(ByVal ViciStatusCode As String) As DataTable
        Dim sqlStr = String.Format("Select * from tblViciStatus where ViciStatusCode = '{0}'", ViciStatusCode)
        Return SqlHelper.GetDataTable(sqlStr, CommandType.Text)
    End Function

    Public Shared Function CIDCanChangeStatusOnDisconnect(ByVal LeadApplicantId As Integer, ByVal ViciStatusCode As String, ByVal UserId As Integer) As Boolean

        Dim oldLeadStatusId As Integer = DialerHelper.GetLeadStatus(LeadApplicantId)
        Dim dt As DataTable = GetViciStatus(ViciStatusCode)
        Dim newLeadStatusId As Integer = 0
        Dim reasonId As Nullable(Of Integer) = Nothing

        If dt.Rows.Count > 0 Then
            If Not dt.Rows(0)("LeadStatusId") Is DBNull.Value Then newLeadStatusId = dt.Rows(0)("LeadStatusId")
            If Not dt.Rows(0)("LeadReasonId") Is DBNull.Value Then reasonId = dt.Rows(0)("LeadReasonId")
        End If

        Dim CanChangeToStatus As Boolean = (newLeadStatusId = 9)

        If Not CanChangeToStatus Then
            'Change to new Status if allowed transitions
            Select Case oldLeadStatusId
                Case 2, 16, 17  'new(16) or recycled(17) -> left message(13), NoAnswer(15), BadLead(14)
                    CanChangeToStatus = (newLeadStatusId = 13) OrElse (newLeadStatusId = 15) OrElse (newLeadStatusId = 14)
                Case 13 'left message(13)  ->  BadLead(14)
                    CanChangeToStatus = (newLeadStatusId = 14)
                Case 15 'no answer(15) ->  left message(13), BadLead(14)
                    CanChangeToStatus = (newLeadStatusId = 13) OrElse (newLeadStatusId = 14)
            End Select
        End If

        If CanChangeToStatus Then
            DialerHelper.ChangeLeadStatus(LeadApplicantId, newLeadStatusId, reasonId, "CID Dialer call result", UserId)
        End If

        Return CanChangeToStatus

    End Function

    Public Shared Sub PostponeDialerForLead(ByVal LeadId As Integer)
        DialerHelper.UpdateLeadApplicant(LeadId, Now.AddHours(1), Nothing)
    End Sub

    Public Shared Function GetVendorCode(ByVal ViciLeadId As Integer) As String
        Try
            Return MySqlHelper.ExecuteScalar(String.Format("Select vendor_lead_code from  vicidial_list where lead_id = '{0}'", ViciLeadId), CommandType.Text).trim
        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Function GetAuthenticationToken(ByVal username As String, ByVal Password As String) As String
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@username", SqlDbType.VarChar)
        param.Value = username.Trim
        params.Add(param)

        param = New SqlParameter("@password", SqlDbType.VarChar)
        param.Value = Password
        params.Add(param)

        Return SqlHelper.ExecuteScalar("stp_Vici_GetAuthenticationToken", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function GetLeadStatusByDisposition(ByVal vicistatuscode As String) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select LeadStatusId, LeadReasonId from tblViciLeadStatus where ViciLeadStatusCode='{0}'", vicistatuscode), CommandType.Text)
    End Function

    Public Shared Function GetLeadReasonsByStatus(ByVal statusid As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select LeadReasonsID, Description from tblLeadReasons where StatusID={0} order by DisplayOrder", statusid), CommandType.Text)
    End Function

    Public Shared Function CIDDialerChangeStatusOnDisconnect(ByVal LeadApplicantId As Integer, ByVal StatusId As Integer, ByVal ReasonId As Integer, ByVal UserId As Integer) As Boolean
        Dim oldLeadStatusId As Integer = DialerHelper.GetLeadStatus(LeadApplicantId)
        Dim newLeadStatusId As Integer = StatusId
        Dim CanChangeToStatus As Boolean = DialerHelper.CanChangeLeadStatus(oldLeadStatusId, newLeadStatusId)
        If CanChangeToStatus Then
            Dim rs As Nullable(Of Integer) = Nothing
            If ReasonId > 0 Then rs = ReasonId
            DialerHelper.ChangeLeadStatus(LeadApplicantId, newLeadStatusId, rs, "CID Dialer call result", UserId)
        End If
        Return CanChangeToStatus
    End Function

    Public Shared Sub UpdatePhoneNumber(ByVal ViciLeadId As Integer, ByVal PhoneNumber As String)
        MySqlHelper.ExecuteNonQuery(String.Format("Update vicidial_list Set phone_number = '{1}' Where lead_id = {0} limit 1;", ViciLeadId, PhoneNumber), CommandType.Text)
    End Sub

    Public Shared Function IsAutoInsertDID(ByVal DID As String) As Boolean
        Try
            Return CBool(SqlHelper.ExecuteScalar(String.Format("Select top 1 AutoInsert from tblViciSourceDID  Where DID = '{0}'", DID), CommandType.Text))
        Catch ex As Exception
            Return False
        End Try
    End Function

    Public Shared Function GetLeadProductByDID(ByVal DID As String) As Integer
        Try
            Return CInt(SqlHelper.ExecuteScalar(String.Format("Select ProductId from tblLeadProductDID  Where DID = '{0}'", DID), CommandType.Text).ToString)
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function AutoInsertLeadByDID(ByVal phonenumber As String, ByVal did As String, ByVal UserId As Integer) As Integer
        Try
            Dim params As New List(Of SqlParameter)
            Dim param As SqlParameter

            param = New SqlParameter("@phonenumber", SqlDbType.VarChar)
            param.Value = phonenumber.Trim
            params.Add(param)

            param = New SqlParameter("@did", SqlDbType.VarChar)
            param.Value = did.Trim
            params.Add(param)

            param = New SqlParameter("@UserId", SqlDbType.Int)
            param.Value = UserId
            params.Add(param)

            Return CInt(SqlHelper.ExecuteScalar("stp_Vici_AutoInsertLeadApplicant", CommandType.StoredProcedure, params.ToArray))

        Catch ex As Exception
            Return 0
        End Try

    End Function

    Public Shared Sub StartManualRecording(ByVal ServerIp As String, ByVal Filename As String, ByVal Channel As String)
        Dim sb As New System.Text.StringBuilder
        sb.Append("insert into vicidial_manager(")

        sb.Append("uniqueid,entry_date, status, response,")
        sb.Append("server_ip, channel, action, callerid,")
        sb.Append("cmd_line_b, cmd_line_c, cmd_line_d,")
        sb.Append("cmd_line_e, cmd_line_f, cmd_line_g,")
        sb.Append("cmd_line_h, cmd_line_i, cmd_line_j, cmd_line_k)")

        sb.Append(" values ('', NOW(), 'NEW', 'N',")
        sb.AppendFormat("'{0}', '', 'Originate', '{1}',", ServerIp, Filename)
        sb.AppendFormat("'Channel: {0}', 'Context: default', 'Exten: {1}',", Channel, 8311)
        sb.AppendFormat("'Priority: 1', 'Callerid: {0}','','','','','');", Filename)

        MySqlHelper.ExecuteNonQuery(sb.ToString, CommandType.Text)
    End Sub

    Public Shared Sub StopManualRecording(ByVal ServerIp As String, ByVal Channel As String)
        Dim sb As New System.Text.StringBuilder
        sb.Append("insert into vicidial_manager(")

        sb.Append("uniqueid,entry_date, status, response,")
        sb.Append("server_ip, channel, action, callerid,")
        sb.Append("cmd_line_b, cmd_line_c, cmd_line_d,")
        sb.Append("cmd_line_e, cmd_line_f, cmd_line_g,")
        sb.Append("cmd_line_h, cmd_line_i, cmd_line_j, cmd_line_k)")

        sb.Append(" values ('', NOW(), 'NEW', 'N',")
        sb.AppendFormat("'{0}', '', 'Hangup', '{1}',", ServerIp, "RH12345")
        sb.AppendFormat("'Channel: {0}', '', '','', '','','','','','');", Channel)

        MySqlHelper.ExecuteNonQuery(sb.ToString, CommandType.Text)
    End Sub

    Public Shared Function GetManualRecording(ByVal Filename As String) As DataTable
        Return MySqlHelper.GetDataTable(String.Format("select * from manual_recording where filename = '{0}' order by idmanual_recording desc limit  1;", Filename), CommandType.Text)
    End Function

    Public Shared Function CloseManualRecording(ByVal Filename As String) As DataTable
        Return MySqlHelper.GetDataTable(String.Format("update manual_recording set ended = NOW() where filename = '{0}' limit  1;", Filename), CommandType.Text)
    End Function

    Public Shared Function GetMatterData(ByVal MatterId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select clientid, mattertypeid from tblmatter where matterId = {0}", MatterId), CommandType.Text)
    End Function

    Public Shared Function GetMatterTaskId(ByVal MatterId As Integer) As Integer
        Try
            Return SqlHelper.ExecuteScalar(String.Format("select top 1 mt.taskid from tblmattertask mt join tbltask t on t.taskid = mt.taskid where mt.matterId = {0} and t.tasktypeid in (72) order by t.taskid desc", MatterId), CommandType.Text)
        Catch ex As Exception
            Return 0
        End Try
    End Function

End Class

