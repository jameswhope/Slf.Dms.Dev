Imports Microsoft.VisualBasic
Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports System.Data

Public Class CallControlsHelper

    Public Shared Function InsertCallEvent(ByVal CallIdKey As String, ByVal PhoneNumber As String, ByVal EventName As String, ByVal UserID As Integer) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_InsertCallEvent"
        If Not CallIdKey Is Nothing AndAlso CallIdKey.Trim.Length > 0 Then DatabaseHelper.AddParameter(cmd, "CallIdKey", CallIdKey)
        If Not PhoneNumber Is Nothing AndAlso PhoneNumber.Trim.Length > 0 Then DatabaseHelper.AddParameter(cmd, "PhoneNumber", PhoneNumber.Trim)
        DatabaseHelper.AddParameter(cmd, "EventName", EventName)
        DatabaseHelper.AddParameter(cmd, "UserId", UserID)
        Return DatabaseHelper.ExecuteScalar(cmd)
    End Function

    Public Shared Function InsertCallMessageLog(ByVal Message As String, ByVal UserID As Integer) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_InsertCallMessageLog"
        DatabaseHelper.AddParameter(cmd, "Message", Message)
        DatabaseHelper.AddParameter(cmd, "UserId", UserID)
        Return DatabaseHelper.ExecuteScalar(cmd)
    End Function

    Public Shared Function InsertStatusChangeLog(ByVal StatusName As String, ByVal UserID As Integer) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_InsertPhoneStatusLog"
        DatabaseHelper.AddParameter(cmd, "StatusName", StatusName)
        DatabaseHelper.AddParameter(cmd, "UserId", UserID)
        Return DatabaseHelper.ExecuteScalar(cmd)
    End Function

    Public Shared Sub LogUserLogin(ByVal UserId As Integer)

    End Sub

    Public Shared Function GetDnis(ByVal CallIdKey As String) As String
        Dim conn As New SqlConnection(ConfigurationManager.AppSettings("I3ConnString"))
        Dim cmdText As String = String.Format("select dnis from calldetail where callid = '{0}'", CallIdKey)
        Dim cmd As New SqlCommand(cmdText, conn)
        'Dim params(0) As SqlParameter
        Dim dnis As String

        'params(0) = New SqlParameter("CallIdKey", SqlDbType.VarChar)
        'params(0).Value = CallIdKey
        cmd.Connection.Open()
        cmd.CommandType = CommandType.Text
        'cmd.Parameters.Add(params)
        Try
            dnis = cmd.ExecuteScalar.ToString
            If Not cmd.Connection.State = ConnectionState.Closed Then
                cmd.Connection.Close()
            End If
        Catch ex As Exception
            dnis = ""
        End Try

        Return dnis
    End Function

    Public Shared Sub InsertLeadNote(ByVal noteText As String, ByVal LeadId As Integer, ByVal UserId As Integer)
        Dim cmd As SqlCommand = Nothing
        Dim strSQL As String = String.Format("INSERT INTO tblLeadNotes (LeadApplicantID, notetypeid, NoteType, Value, Created, CreatedByID, Modified, ModifiedBy) VALUES ({0}, 0 ,'Phone', '{1}', GetDate(), {2}, GetDate(), {2})", LeadId, noteText, UserId)
        Try
            cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            If cmd.Connection.State <> Data.ConnectionState.Closed Then cmd.Connection.Close()
        End Try
    End Sub

    Public Shared Function GetLeadProductFromDNIS(ByVal CallIdKey As String) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_getProductSourceFromDNIS"
        DatabaseHelper.AddParameter(cmd, "CallIdKey", CallIdKey)
        Return DatabaseHelper.ExecuteDataset(cmd).Tables(0)
    End Function

    Public Shared Function GetCallClient(ByVal CallIdKey As String) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_getCallClient"
        DatabaseHelper.AddParameter(cmd, "CallIdKey", CallIdKey)
        Return DatabaseHelper.ExecuteDataset(cmd).Tables(0)
    End Function

    'stp_GetCallClientSearches
    Public Shared Function GetClientSearches(ByVal PhoneNumber As String) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_GetCallClientSearches"
        DatabaseHelper.AddParameter(cmd, "PhoneNumber", PhoneNumber)
        Return DatabaseHelper.ExecuteDataset(cmd).Tables(0)
    End Function

    Public Shared Function InsertCallClient(ByVal CallIdKey As String, ByVal ClientId As Integer) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_InsertCallClient"
        DatabaseHelper.AddParameter(cmd, "CallIdKey", CallIdKey)
        DatabaseHelper.AddParameter(cmd, "ClientId", ClientId)
        Return DatabaseHelper.ExecuteScalar(cmd)
    End Function

    Public Shared Function GetCIDDialerResultTypes() As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_Dialer_GetLeadCallResultTypes"
        Return DatabaseHelper.ExecuteDataset(cmd).Tables(0)
    End Function

    Public Shared Function ExistsClient(ByVal ClientId As Integer) As Boolean
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.Text
        cmd.CommandText = String.Format("Select Count(clientid) from tblclient where clientid = {0}", ClientId)
        Return (CInt(DatabaseHelper.ExecuteScalar(cmd)) > 0)
    End Function

    Public Shared Function GetUserExt(ByVal UserName As String) As String
        Try
            Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
            cmd.CommandType = CommandType.Text
            cmd.CommandText = String.Format("Select ext from tbluserext where [login] = '{0}'", UserName)
            Return DatabaseHelper.ExecuteScalar(cmd).ToString
        Catch ex As Exception
            Return ""
        End Try
    End Function

    Public Shared Function GetLeadCustomAni(ByVal PhoneNumber As String) As String
        Dim DID As String = ""
        Try
            Dim AreaCode As String = GetAreaCode(PhoneNumber)
            If AreaCode.Length > 0 Then
                Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
                cmd.CommandType = CommandType.Text
                cmd.CommandText = String.Format("Select DID From tblLeadAreaCodeDID Where AreaCode = '{0}'", AreaCode)
                DID = DatabaseHelper.ExecuteScalar(cmd).ToString
            End If
        Catch ex As Exception
            'Ignore Error
        End Try
        Return DID
    End Function

    Public Shared Function GetAreaCode(ByVal PhoneNumber As String) As String
        Dim AreaCode As String = ""
        If PhoneNumber.Length >= 1 Then
            If PhoneNumber.StartsWith("1") Then
                PhoneNumber = PhoneNumber.Substring(1)
            End If
        End If
        If PhoneNumber.Length >= 3 Then
            AreaCode = PhoneNumber.Substring(0, 3)
        End If
        Return AreaCode
    End Function

    Public Shared Function InsertCallRecording(ByVal CallIdKey As String, ByVal RecCallIdKey As String, ByVal RecFile As String, ByVal ReferenceName As String, ByVal referenceId As Integer, ByVal DocTypeId As String, ByVal userid As Integer) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_InsertCallRecording"
        DatabaseHelper.AddParameter(cmd, "CallIdKey", CallIdKey)

        If RecCallIdKey.Trim.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "RecCallIdKey", RecCallIdKey)
        End If
        If RecFile.Trim.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "RecFile", RecCallIdKey)
        End If
        If ReferenceName.Trim.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "Reference", ReferenceName)
            DatabaseHelper.AddParameter(cmd, "ReferenceId", referenceId)
        End If
        If DocTypeId.Trim.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "DocTypeId", DocTypeId)
        End If
        DatabaseHelper.AddParameter(cmd, "UserID", userid)

        Return CInt(DatabaseHelper.ExecuteScalar(cmd))
    End Function

    Public Shared Sub UpdateCallRecording(ByVal RecId As Integer, ByVal RecCallIdKey As String, ByVal RecFile As String, ByVal ReferenceName As String, ByVal referenceId As Integer, ByVal DocTypeId As String)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_UpdateCallRecording"
        DatabaseHelper.AddParameter(cmd, "RecId", RecId)
        If RecCallIdKey.Trim.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "RecCallIdKey", RecCallIdKey)
        End If
        If RecFile.Trim.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "RecFile", RecFile)
        End If
        If ReferenceName.Trim.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "Reference", RecCallIdKey)
            DatabaseHelper.AddParameter(cmd, "ReferenceId", referenceId)
        End If
        If DocTypeId.Trim.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "DocTypeId", DocTypeId)
        End If
        DatabaseHelper.ExecuteNonQuery(cmd)
    End Sub
End Class
