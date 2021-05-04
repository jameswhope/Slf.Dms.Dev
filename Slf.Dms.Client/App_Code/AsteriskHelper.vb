Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data
Imports System.Collections.Generic

Public Class AsteriskHelper
    Public Shared Function GetAsteriskDBConnStr() As String
        Return ConfigurationManager.ConnectionStrings("AsteriskConnString").ToString
    End Function

    Public Shared Function GetCDR(ByVal uniqueid As String) As DataTable
        Dim cmd As New SqlCommand(String.Format("select * from  cdr where uniqueid = '{0}'", uniqueid), New SqlConnection(AsteriskHelper.GetAsteriskDBConnStr()))
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet
        da.Fill(ds)
        Return ds.Tables(0)
    End Function

    Public Shared Function GetHistory(ByVal Username As String, ByVal TopN As Integer) As DataTable
        Dim cmd As New SqlCommand("", New SqlConnection(AsteriskHelper.GetAsteriskDBConnStr()))
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_asterisk_getcallhistory"
        cmd.Parameters.Add(New SqlParameter("@N", TopN))
        cmd.Parameters.Add(New SqlParameter("ext", Username))
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet
        da.Fill(ds)
        Return ds.Tables(0)
    End Function

    Public Shared Function GetAllPresences() As DataTable
        Dim cmd As New SqlCommand(String.Format("select * from tblasteriskpresence"), New SqlConnection(AsteriskHelper.GetAsteriskDBConnStr()))
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet
        da.Fill(ds)
        Return ds.Tables(0)
    End Function


    Public Shared Function GetDirectory(ByVal FirstName As String, ByVal LastName As String, ByVal Ext As String, ByVal Dept As String, ByVal Status As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter
        If FirstName.Trim.Length > 0 Then
            param = New SqlParameter("@FirstName", SqlDbType.VarChar)
            param.Value = FirstName.Trim
            params.Add(param)
        End If
        If LastName.Trim.Length > 0 Then
            param = New SqlParameter("@LastName", SqlDbType.VarChar)
            param.Value = LastName.Trim
            params.Add(param)
        End If
        If Ext.Trim.Length > 0 Then
            param = New SqlParameter("@Ext", SqlDbType.VarChar)
            param.Value = Ext.Trim
            params.Add(param)
        End If
        If Dept.Trim.Length > 0 Then
            param = New SqlParameter("@Dept", SqlDbType.VarChar)
            param.Value = Dept.Trim
            params.Add(param)
        End If
        If Status.Trim.Length > 0 Then
            param = New SqlParameter("@Status", SqlDbType.VarChar)
            param.Value = Status.Trim
            params.Add(param)
        End If
        Return SqlHelper.GetDataTable("stp_Asterisk_GetDirectory", CommandType.StoredProcedure, params.ToArray)
    End Function


    Public Shared Function GetUserPresence(ByVal UserName As String) As DataTable
        Dim cmd As New SqlCommand(String.Format("select presenceid, lastmodified from tblasteriskuserpresence where username = '{0}'", UserName), New SqlConnection(AsteriskHelper.GetAsteriskDBConnStr()))
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet
        da.Fill(ds)
        Return ds.Tables(0)
    End Function

    Public Shared Sub UpdateUserPresence(ByVal UserName As String, ByVal PresenceId As Integer)
        Using conn As New SqlConnection(AsteriskHelper.GetAsteriskDBConnStr())
            Dim cmd As New SqlCommand(String.Format("Update tblasteriskuserpresence set presenceid = {0}, lastmodified = getdate() where username = '{1}'", PresenceId, UserName), conn)
            Try
                conn.Open()
                cmd.ExecuteNonQuery()
            Catch
                Throw
            End Try
        End Using
    End Sub

    Public Shared Sub InsertUserPresence(ByVal UserName As String, ByVal PresenceId As Integer)
        Using conn As New SqlConnection(AsteriskHelper.GetAsteriskDBConnStr())
            Dim cmd As New SqlCommand(String.Format("Insert into tblasteriskuserpresence (username, presenceid) values('{0}',{1})", UserName, PresenceId), conn)
            Try
                conn.Open()
                cmd.ExecuteNonQuery()
            Catch
                Throw
            End Try
        End Using
    End Sub

    Public Shared Function GetChannel(ByVal UniqueId As String, ByVal SIPPrefix As String) As String
        Dim channel As String = ""
        Dim dt As DataTable = AsteriskHelper.GetCDR(UniqueId)

        If Not dt Is Nothing AndAlso dt.Rows.Count > 0 Then
            If dt.Rows(0)("channel").ToString.Trim.ToLower.Contains(SIPPrefix.Trim.ToLower) Then
                channel = dt.Rows(0)("channel").ToString.Trim
            ElseIf dt.Rows(0)("dstchannel").ToString.Trim.ToLower.Contains(SIPPrefix.Trim.ToLower) Then
                channel = dt.Rows(0)("dstchannel").ToString.Trim
            End If
        End If

        Return channel
    End Function

    Public Shared Function GetIncomingDID(ByVal PhoneNumber As String) As String
        Dim DID As String = ""
        Using conn As New SqlConnection(AsteriskHelper.GetAsteriskDBConnStr())
            Dim cmd As New SqlCommand(String.Format("select top 1 DID from Asterisk.dbo.tblIncomingCall where PhoneNumber = '{0}' order by Created desc", PhoneNumber), conn)
            Try
                conn.Open()
                DID = cmd.ExecuteScalar().ToString
            Catch
                'Do Nothing
            End Try
        End Using
        Return DID
    End Function

    Public Shared Function IsGeneratedNumber(ByVal PhoneNumber As String) As Boolean
        Dim IsGenPhone As Boolean = False
        Using conn As New SqlConnection(AsteriskHelper.GetAsteriskDBConnStr())
            Dim cmd As New SqlCommand(String.Format("select count(*) from tblIncomingCall where PhoneNumber = 'G{0}'", PhoneNumber.Trim), conn)
            Try
                conn.Open()
                IsGenPhone = CInt(cmd.ExecuteScalar() > 0)
            Catch
                'Do Nothing
            End Try
        End Using
        Return IsGenPhone
    End Function

End Class
