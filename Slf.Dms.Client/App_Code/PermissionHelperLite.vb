Imports Microsoft.VisualBasic
Imports System.Data
Imports Drg.Util.DataAccess
Imports System.Data.SqlClient

Public Class PermissionHelperLite

    'Note: Does not currently check for User Type permissions, can be added. View permission must be checked for 
    'HasPermission to return true. We can modify this logic to acknowledge permissions if no View permissions are set. 
    'Does not address Add/Edit/Delete permissions, not commonly used. Using this method doesn't require logging out/in 
    'either.

    Public Shared Function HasPermission(ByVal UserID As Integer, ByVal FullFunctionName As String) As Boolean
        Dim tbl As DataTable
        Dim bHasPermission As Boolean
        Dim UserGroupId As Integer

        'First check for user-specific permissions
        tbl = SqlHelper.GetDataTable(String.Format("select p.value from tbluserpermission u join tblpermission p on p.permissionid = u.permissionid join tblfunction f on f.functionid = p.functionid and f.fullname = '{0}' join tblpermissiontype t on t.permissiontypeid = p.permissiontypeid and t.name = 'View' where u.userid = {1}", FullFunctionName, UserID))

        If tbl.Rows.Count = 1 Then
            'User-specific permissions have been set
            bHasPermission = Boolean.Parse(tbl.Rows(0)(0))
        Else
            'Check for group-specific permissions
            UserGroupId = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupId", "UserId = " & UserID))
            tbl = SqlHelper.GetDataTable(String.Format("select p.value from tblgrouppermission g join tblpermission p on p.permissionid = g.permissionid join tblfunction f on f.functionid = p.functionid and f.fullname = '{0}' join tblpermissiontype t on t.permissiontypeid = p.permissiontypeid and t.name = 'View' where g.usergroupid = {1}", FullFunctionName, UserGroupId))
            If tbl.Rows.Count = 1 Then
                'Group-specific permissions have been set
                bHasPermission = Boolean.Parse(tbl.Rows(0)(0))
            End If
        End If

        Return bHasPermission
    End Function

    Public Shared Function UsersWithPermission(ByVal FullFunctionName As String) As DataTable
        Dim tbl As DataTable
        Dim params As New Collections.Generic.List(Of SqlClient.SqlParameter)

        'Checks for user and group-specific permissions
        params.Add(New SqlClient.SqlParameter("FullFunctionName", FullFunctionName))
        tbl = SqlHelper.GetDataTable("stp_UsersWithPermission", CommandType.StoredProcedure, params.ToArray)

        Return tbl
    End Function

    Public Shared Function NegotiationTeams() As DataTable
        Dim tbl As DataTable = Nothing
        Try
            'Gets the team lead and team members for negotiation into a table in memory
            tbl = SqlHelper.GetDataTable("stp_GetNegotiationTeams", CommandType.StoredProcedure)
        Catch ex As SqlException
            Throw New Exception("Error getting negotiation team lists.")
        End Try

        Return tbl
    End Function

End Class
