Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Public Enum LeadAppointmentStatus
    Pending = 0
    Completed = 1
    NotCompleted = 2
    Cancelled = 3
    InQueue = 4
    Expired = 5
End Enum

Public Class CIDAppointmentHelper

    Public Shared Function GetLeadAppointments(ByVal LeadApplicantId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@LeadApplicanId", SqlDbType.Int)
        param.Value = LeadApplicantId
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_Dialer_GetAppointmentsForLead", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function GetLeadAppointment(ByVal AppointmentId As Integer) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@AppointmentId", SqlDbType.Int)
        param.Value = AppointmentId
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_Dialer_GetLeadAppointment", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function GetLeadDefaultData(ByVal LeadId As Integer) As DataTable
        Dim sSql As String = String.Format("Select leadname, leadphone, timezoneid from tblleadapplicant where leadapplicantid = {0}", LeadId)
        Return SqlHelper.GetDataTable(sSql, CommandType.Text, Nothing)
    End Function

    Public Shared Function GetTimeZones() As DataTable
        Dim sSql As String = "SELECT TimeZoneID, Name FROM tblTimeZone Order By Name Asc"
        Return SqlHelper.GetDataTable(sSql, CommandType.Text, Nothing)
    End Function

    Public Shared Function GetUTC(ByVal TimeZoneId As Integer) As Integer
        Dim sSql As String = "SELECT FromUtc FROM tblTimeZone Where TimeZoneId = " & TimeZoneId
        Dim utc As Integer
        Try
            Return CInt(SqlHelper.ExecuteScalar(sSql, CommandType.Text, Nothing))
        Catch ex As Exception
            Return -8
        End Try
    End Function

    Public Shared Function GetTimeZoneforAreaCode(ByVal AreaCode As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@AreaCode", SqlDbType.VarChar)
        param.Value = AreaCode
        params.Add(param)
        Return SqlHelper.GetDataTable("stp_Dialer_GetTimeZoneforAreaCode", CommandType.StoredProcedure, params.ToArray)
    End Function

    Public Shared Function InsertLeadAppointment(ByVal LeadApplicantId As Integer, ByVal PhoneNumber As String, ByVal AppointmentDate As DateTime, ByVal TimeZoneId As Integer, ByVal AppointmentNote As String, ByVal AppointmentStatusId As Integer, ByVal UserId As Integer) As Integer
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@LeadApplicantId", SqlDbType.Int)
        param.Value = LeadApplicantId
        params.Add(param)

        param = New SqlParameter("@PhoneNumber", SqlDbType.VarChar)
        param.Value = PhoneNumber
        params.Add(param)

        param = New SqlParameter("@AppointmentDate", SqlDbType.DateTime)
        param.Value = AppointmentDate
        params.Add(param)

        param = New SqlParameter("@TimeZoneId", SqlDbType.Int)
        param.Value = TimeZoneId
        params.Add(param)

        If AppointmentNote.Trim.Length > 0 Then
            param = New SqlParameter("@AppointmentNote", SqlDbType.VarChar)
            param.Value = AppointmentNote
            params.Add(param)
        End If

        param = New SqlParameter("@AppointmentStatusId", SqlDbType.Int)
        param.Value = AppointmentStatusId
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        Return CInt(SqlHelper.ExecuteScalar("stp_Dialer_InsertLeadAppointment", CommandType.StoredProcedure, params.ToArray))
    End Function

    Public Shared Sub UpdateLeadAppointment(ByVal AppointmentId As Integer, ByVal PhoneNumber As String, ByVal AppointmentDate As Nullable(Of Date), ByVal TimeZoneId As Nullable(Of Integer), ByVal AppointmentNote As String, ByVal AppointmentStatusId As Nullable(Of Integer), ByVal CallIdKey As String, ByVal CalledBy As Nullable(Of Integer), ByVal Calldate As Nullable(Of DateTime), ByVal CallResultId As Nullable(Of Integer), ByVal UserId As Integer)
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@AppointmentId", SqlDbType.Int)
        param.Value = AppointmentId
        params.Add(param)

        If PhoneNumber.Trim.Length > 0 Then
            param = New SqlParameter("@PhoneNumber", SqlDbType.VarChar)
            param.Value = PhoneNumber.Trim
            params.Add(param)
        End If

        If AppointmentDate.HasValue Then
            param = New SqlParameter("@AppointmentDate", SqlDbType.DateTime)
            param.Value = AppointmentDate.Value
            params.Add(param)
        End If

        If TimeZoneId.HasValue Then
            param = New SqlParameter("@TimeZoneId", SqlDbType.Int)
            param.Value = TimeZoneId.Value
            params.Add(param)
        End If

        If AppointmentNote.Trim.Length > 0 Then
            param = New SqlParameter("@AppointmentNote", SqlDbType.VarChar)
            param.Value = AppointmentNote.Trim
            params.Add(param)
        End If

        If AppointmentStatusId.HasValue Then
            param = New SqlParameter("@AppointmentStatusId", SqlDbType.Int)
            param.Value = AppointmentStatusId.Value
            params.Add(param)
        End If

        If CallIdKey.Trim.Length > 0 Then
            param = New SqlParameter("@CallIdKey", SqlDbType.VarChar)
            param.Value = CallIdKey.Trim
            params.Add(param)
        End If

        If CalledBy.HasValue Then
            param = New SqlParameter("@CalledBy", SqlDbType.Int)
            param.Value = CalledBy.Value
            params.Add(param)
        End If

        If Calldate.HasValue Then
            param = New SqlParameter("@CallDate", SqlDbType.DateTime)
            param.Value = Calldate.Value
            params.Add(param)
        End If

        If CallResultId.HasValue Then
            param = New SqlParameter("@CallResultId", SqlDbType.Int)
            param.Value = CallResultId.Value
            params.Add(param)
        End If

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_Dialer_UpdateLeadAppointment", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Function GetAppointmentIdByCallMade(ByVal CallMadeId As Integer) As Integer
        Try
            Return CInt(SqlHelper.ExecuteScalar("Select AppointmentId from tblLeadCallAppointment where CallMadeId = " & CallMadeId, CommandType.Text, Nothing))
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Public Shared Function UpdateAppointmentStatus4Result(ByVal CallMadeID As Integer, ByVal ResultID As Integer, ByVal UserId As Integer) As Integer
        'LeadUpdateAppointmentStatus4Result
        Dim params As New List(Of SqlParameter)

        Dim param As New SqlParameter("@CallMadeId", SqlDbType.Int)
        param.Value = CallMadeID
        params.Add(param)

        param = New SqlParameter("@ResultId", SqlDbType.Int)
        param.Value = ResultID
        params.Add(param)

        param = New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserID
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_Dialer_LeadUpdateAppointmentStatus4Result", CommandType.StoredProcedure, params.ToArray)

    End Function

    Public Shared Function GetPendingAppointmentCount(ByVal LeadApplicantId As Integer) As Integer
        Try
            Return CInt(SqlHelper.ExecuteScalar("Select CT = Count(AppointmentId) from tblLeadCallAppointment where AppointmentStatusId = 0 and AppointmentDate > getdate() and LeadApplicantId = " & LeadApplicantId, CommandType.Text, Nothing))
        Catch ex As Exception
            Return 0
        End Try
    End Function

End Class
