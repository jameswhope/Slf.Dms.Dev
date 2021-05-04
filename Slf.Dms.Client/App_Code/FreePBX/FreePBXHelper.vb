Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports System.IO

Public Class FreePBXHelper

    Public Const PhoneSystem As String = "FreePBX"

    Public Shared Function InsertCall(ByVal PhoneNumber As String, ByVal Inbound As Boolean, ByVal UserID As Integer, ByVal CallerId As String, ByVal RefType As String, ByVal RefId As Nullable(Of Integer), ByVal CallReasonId As Integer) As Integer

        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@PhoneNumber", SqlDbType.VarChar)
        param.Value = PhoneNumber.Trim
        params.Add(param)

        param = New SqlParameter("@Inbound", SqlDbType.Bit)
        param.Value = IIf(Inbound, 1, 0)
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserID
        params.Add(param)

        If CallerId.Trim.Length > 0 Then
            param = New SqlParameter("@CallerId", SqlDbType.VarChar)
            param.Value = CallerId.Trim
            params.Add(param)
        End If

        If RefType.Trim.Length > 0 Then
            param = New SqlParameter("@RefType", SqlDbType.VarChar)
            param.Value = RefType.Trim
            params.Add(param)
        End If

        If RefId.HasValue Then
            param = New SqlParameter("@RefId", SqlDbType.Int)
            param.Value = RefId
            params.Add(param)
        End If

        param = New SqlParameter("@CallReasonId", SqlDbType.Int)
        param.Value = CallReasonId
        params.Add(param)

        param = New SqlParameter("@PhoneSystem", SqlDbType.VarChar)
        param.Value = FreePBXHelper.PhoneSystem
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_AsteriskCallLogInsert", CommandType.StoredProcedure, params.ToArray))

    End Function

    Public Shared Function InsertLeadDialerCall(ByVal LeadId As Integer, ByVal PhoneNumber As String, ByVal UserId As Integer, ByVal CallId As Integer) As Integer

        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@LeadApplicantId", SqlDbType.Int)
        param.Value = LeadId
        params.Add(param)

        param = New SqlParameter("@PhoneNumber", SqlDbType.VarChar)
        param.Value = PhoneNumber.Trim
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        param = New SqlParameter("@AutoDial", SqlDbType.Bit)
        param.Value = 0
        params.Add(param)

        param = New SqlParameter("@CallId", SqlDbType.Int)
        param.Value = CallId
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_Dialer_InsertLeadCall", CommandType.StoredProcedure, params.ToArray))
    End Function

    Public Shared Function InsertConferenceCall(ByVal CallId As Integer, ByVal PhoneNumber As String, ByVal UserId As Integer, ByVal CallerId As String) As Integer

        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@CallId", SqlDbType.Int)
        param.Value = CallId
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        param = New SqlParameter("@PhoneNumber", SqlDbType.VarChar)
        param.Value = PhoneNumber.Trim
        params.Add(param)

        param = New SqlParameter("@PhoneSystem", SqlDbType.VarChar)
        param.Value = FreePBXHelper.PhoneSystem
        params.Add(param)

        If CallerId.Trim.Length > 0 Then
            param = New SqlParameter("@CallerId", SqlDbType.VarChar)
            param.Value = CallerId.Trim
            params.Add(param)
        End If

        Return CInt(SqlHelper.ExecuteScalar("stp_AsteriskInsertConference", CommandType.StoredProcedure, params.ToArray))
    End Function

    Public Shared Sub UpdateCallRef(ByVal CallId As Integer, ByVal RefType As String, ByVal RefId As Integer, ByVal UserId As Integer)

        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@CallId", SqlDbType.Int)
        param.Value = CallId
        params.Add(param)

        param = New SqlParameter("@RefType", SqlDbType.VarChar)
        param.Value = RefType.Trim
        params.Add(param)

        param = New SqlParameter("@RefId", SqlDbType.Int)
        param.Value = RefId
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_AsteriskCallLogUpdateRef", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Sub InsertLeadNote(ByVal noteText As String, ByVal LeadId As Integer, ByVal UserId As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("INSERT INTO tblLeadNotes (LeadApplicantID, notetypeid, NoteType, Value, Created, CreatedByID, Modified, ModifiedBy) VALUES ({0}, 0 ,'Phone', '{1}', GetDate(), {2}, GetDate(), {2})", LeadId, noteText, UserId), Data.CommandType.Text)
    End Sub

    Public Shared Function GetDepartmentByDID(ByVal DID As String) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select d.* from tblDepartment d inner join tblDepartmentDID dd on dd.DepartmentId = d.DepartmentId where dd.DID = '{0}'", DID.Trim), CommandType.Text)
    End Function

    Public Shared Function GetUserData(ByVal UserId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select u.usergroupid, g.departmentid, g.searchonpickup, d.defaultpage from tbluser u inner join tblusergroup g on u.usergroupid = g.usergroupid left join tbldepartment d on g.departmentid = d.departmentid where u.userid = {0}", UserId), CommandType.Text)
    End Function

    Public Shared Function SearchLeadByPhone(ByVal PhoneNumber As String) As Integer
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@PhoneNumber", SqlDbType.VarChar)
        param.Value = PhoneNumber.Trim
        params.Add(param)
        Try
            Return CInt(SqlHelper.ExecuteScalar("stp_SearchLeadByPhone", CommandType.StoredProcedure, params.ToArray))
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function SearchClientByPhone(ByVal PhoneNumber As String) As Integer
        Dim dtClients As DataTable = CallControlsHelper.GetClientSearches(PhoneNumber)
        If Not dtClients Is Nothing AndAlso dtClients.Rows.Count > 0 Then
            Return CInt(dtClients.Rows(0)("ClientId"))
        Else
            Return 0
        End If
    End Function

    Public Shared Function GetDepartmentIdByUserId(ByVal UserId As Integer) As Integer
        Try
            Return CInt(SqlHelper.ExecuteScalar(String.Format("Select departmentid from tblusergroup ug inner join tbluser u on u.usergroupid = ug.usergroupid where u.userid = {0}", UserId), CommandType.Text))
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function GetOutboundCallerIdByLawfirm(ByVal CompanyId As Integer, ByVal DepartmentId As Integer) As String
        Try
            Return CInt(SqlHelper.ExecuteScalar(String.Format("Select outcallerid from tblcompanydepartment where companyid = {0} and departmentid = {1}", CompanyId, DepartmentId), CommandType.Text))
        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Function GetOutboundCallerIdByDepartment(ByVal DepartmentId As Integer) As String
        Try
            Return SqlHelper.ExecuteScalar(String.Format("Select outcallerid from tbldepartment where departmentid = {0}", DepartmentId), CommandType.Text).ToString.Trim
        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Function GetClientCompany(ByVal ClientId As Integer) As Integer
        Try
            Return CInt(SqlHelper.ExecuteScalar(String.Format("Select companyid from tblclient where clientid = {0}", ClientId), CommandType.Text))
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function GetDefaultCallerId(ByVal CompanyId As Integer, ByVal UserId As Integer) As String
        Dim outcallerid As String = ""
        'Get User DepartmentId
        Dim depid As Integer = FreePBXHelper.GetDepartmentIdByUserId(UserId)
        If depid > 0 Then
            'Get callerid by law firm and department
            If CompanyId > 0 Then
                outcallerid = FreePBXHelper.GetOutboundCallerIdByLawfirm(CompanyId, depid).Trim()
            End If
            'If no callerid by company then by department only
            outcallerid = FreePBXHelper.GetOutboundCallerIdByDepartment(depid).Trim
        End If
        Return outcallerid
    End Function

    Public Shared Function GetCallData(ByVal CallId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select * from tblAstCallLog Where CallId = {0}", CallId), CommandType.Text)
    End Function

    Public Shared Function AttachRecordedDocument(ByVal ClientID As Integer, ByVal UserID As Integer, ByVal SourceFile As String, ByVal DocTypeId As String, ByVal DocFolder As String, ByVal FileExt As String) As String
        Dim destFile As String = String.Empty
        Try
            Dim destDir As String = SharedFunctions.DocumentAttachment.CreateDirForClient(ClientID) & String.Format("{0}\", DocFolder)
            Dim docName As String
            If IO.File.Exists(SourceFile) Then
                docName = SharedFunctions.DocumentAttachment.GetUniqueDocumentName(DocTypeId, ClientID)
                docName = docName.Replace(".pdf", FileExt)
                destFile = Path.Combine(destDir, docName)
                IO.File.Move(SourceFile, destFile)
                SharedFunctions.DocumentAttachment.AttachDocument("client", ClientID, docName, UserID, DocFolder)
                SharedFunctions.DocumentAttachment.CreateScan(docName, UserID, Now, "")
            End If
        Catch ex As Exception
            destFile = ""
            Throw
        End Try
        Return destFile
    End Function

    Public Shared Sub AttachDocToReference(ByVal ReferenceType As String, ByVal ReferenceId As Integer, ByVal UserId As Integer, ByVal DocName As String, ByVal DocFolder As String)
        Try
            Dim subFolder As String = ""
            Dim idx As Integer = DocName.LastIndexOf("/")
            Dim filename As String = DocName
            If idx > -1 Then
                subFolder = filename.Substring(0, idx + 1)
                filename = filename.Replace(subFolder, "")
                subFolder = subFolder.Replace("//", "\")
            End If

            SharedFunctions.DocumentAttachment.AttachDocument(ReferenceType, ReferenceId, filename, UserId, subFolder)
        Catch ex As Exception
            'Could not attach file
        End Try
    End Sub

    Public Shared Function GetCallReasons() As DataTable
        Return SqlHelper.GetDataTable("Select callreasonid, reason, description from tblastcallreason order by callreasonid", CommandType.Text)
    End Function

    Public Shared Sub UpdateCallReason(ByVal CallId As Integer, ByVal ReasonId As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("Update tblAstCallLog Set CallReasonID = {1} Where CallId = {0}", CallId, ReasonId), CommandType.Text)
    End Sub

End Class
