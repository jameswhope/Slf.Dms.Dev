Imports System.Configuration
Imports System.Data.SqlClient
Imports System.Security.Permissions
Imports Microsoft.Win32
Imports System.Data
Imports System.Net.Dns

Public Class ConnectionContext
    Public Shared Function GetIninServer() As String
        Return ConfigurationManager.AppSettings("IninServer").ToString()
    End Function

    Public Shared Function GetUserPassword(ByVal username As String) As String
        Dim pwd As String = ""
        Dim cmd As New SqlCommand(String.Format("select BusinessPhone from indivdetails where icuserid='{0}'", username), New SqlConnection(GetI3ConnStr))
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet
        da.Fill(ds)
        If ds.Tables(0).Rows.Count > 0 Then
            pwd = ds.Tables(0).Rows(0)("BusinessPhone").ToString.Replace("/", "")
            pwd = pwd & pwd
        End If
        Return pwd
    End Function

    Public Shared Function GetUserPassword2(ByVal username As String) As String
        Dim pwd As String = CallControlsHelper.GetUserExt(username)
        Return pwd & pwd
    End Function

    Public Shared Function GetUserExtension(ByVal username As String) As String
        Dim pwd As String = ""
        Dim cmd As New SqlCommand(String.Format("select BusinessPhone from indivdetails where icuserid='{0}'", username), New SqlConnection(GetI3ConnStr))
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet
        da.Fill(ds)
        If ds.Tables(0).Rows.Count > 0 Then
            pwd = ds.Tables(0).Rows(0)("BusinessPhone").ToString.Replace("/", "")
        End If
        Return pwd
    End Function

    Public Shared Function GetI3ConnStr() As String
        Return ConfigurationManager.AppSettings("I3ConnString").ToString
    End Function

    Public Shared Function GetMachineName(ByVal http_Context As HttpContext) As String
        Return GetHostEntry(http_Context.Request("REMOTE_HOST")).HostName.Split(".")(0)
    End Function

    Private Shared Function GetConnStr() As String
        Return ConfigurationManager.AppSettings("connectionstring").ToString
    End Function

    Public Shared Function GetWorkGroupQueues() As DataTable
        Dim pwd As String = ""
        Dim cmd As New SqlCommand("SELECT distinct  workgroup from userworkgroups where queueflag = 1", New SqlConnection(GetI3ConnStr))
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet
        da.Fill(ds)
        return ds.Tables(0) 
    End Function

    Public Shared Function GetWorkGroupQueues(ByVal DefaultWorkgroup As String) As DataTable
        Dim pwd As String = ""
        Dim cmd As New SqlCommand(String.Format("SELECT distinct  workgroup, Case when workgroup = '{0}' then 0 else 1 end  from userworkgroups where queueflag = 1 order by 2, workgroup", DefaultWorkgroup), New SqlConnection(GetI3ConnStr))
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet
        da.Fill(ds)
        Return ds.Tables(0)
    End Function

    Public Shared Function GetUserDetails(ByVal username As String) As DataTable
        Dim pwd As String = ""
        Dim cmd As New SqlCommand(String.Format("select LastName, FirstName, BusinessPhone from  indivdetails where icuserid = '{0}'", username), New SqlConnection(GetI3ConnStr))
        Dim da As New SqlDataAdapter(cmd)
        Dim ds As New DataSet
        da.Fill(ds)
        Return ds.Tables(0)
    End Function

End Class
