Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic

Public Class SwitchGroupHelper

    Public Shared Function GetUserGroups(ByVal UserId As Integer) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select gs.usergroupId, g.name as [GroupName] from tblusergroups gs inner join tblusergroup g on gs.usergroupid = g.usergroupid Where gs.UserId = {0} Order by gs.IsDefaultGroup  desc", UserId), CommandType.Text)
    End Function

    Public Shared Function GetAssignedUserGroup(ByVal UserId As Integer) As Integer
        Return CInt(SqlHelper.GetDataTable(String.Format("Select usergroupId from tbluser where userid = {0}", UserId), CommandType.Text).Rows(0)("UserGroupId"))
    End Function

    Public Shared Function GetAllGroups() As DataTable
        Return SqlHelper.GetDataTable("Select g.usergroupid, g.name as [GroupName] from tblusergroup g Order by g.name", CommandType.Text)
    End Function

    Public Shared Function UserHasGroups(ByVal UserId As Integer) As Boolean
        Return (SwitchGroupHelper.GetUserGroups(UserId).Rows.Count > 0)
    End Function

    Public Shared Sub DeleteUserGroups(ByVal UserID As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("Delete from tblUserGroups Where UserId = {0}", UserID), CommandType.Text)
    End Sub

    Public Shared Sub RebuildUserGroups(ByVal UserId As Integer, ByVal UserGroups As List(Of Integer), ByVal DefaultGroupId As Integer, ByVal ByUserId As Integer)
        SwitchGroupHelper.DeleteUserGroups(UserId)
        For Each ugid As Integer In UserGroups
            SwitchGroupHelper.InsertUserGroup(UserId, ugid, (ugid = DefaultGroupId), ByUserId)
        Next
    End Sub

    Public Shared Sub InsertUserGroup(ByVal UserId As Integer, ByVal UserGroupId As Integer, ByVal IsDefaultGroup As Boolean, ByVal ByUserId As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        param = New SqlParameter("@UserGroupId", SqlDbType.Int)
        param.Value = UserGroupId
        params.Add(param)

        param = New SqlParameter("@IsDefaultGroup", SqlDbType.Bit)
        param.Value = IIf(IsDefaultGroup, 1, 0)
        params.Add(param)

        param = New SqlParameter("@ByUserId", SqlDbType.Int)
        param.Value = ByUserId
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_Switch_UserGroups_Insert", CommandType.StoredProcedure, params.ToArray)

    End Sub

    Public Shared Sub SetDefaultGroup(ByVal UserId As Integer, ByVal DefaultGroupId As Integer, ByVal ByUserId As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        param = New SqlParameter("@DefaultGroupId", SqlDbType.Int)
        param.Value = DefaultGroupId
        params.Add(param)


        param = New SqlParameter("@ByUserId", SqlDbType.Int)
        param.Value = ByUserId
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_Switch_SetDefaultUserGroup", CommandType.StoredProcedure, params.ToArray)
    End Sub

    Public Shared Sub SwitchUserGroup(ByVal UserId As Integer, ByVal UserGroupId As Integer, ByVal ByUserId As Integer)
        Dim params As New List(Of SqlParameter)
        Dim param As New SqlParameter("@UserId", SqlDbType.Int)
        param.Value = UserId
        params.Add(param)

        param = New SqlParameter("@UserGroupId", SqlDbType.Int)
        param.Value = UserGroupId
        params.Add(param)

        param = New SqlParameter("@ByUserId", SqlDbType.Int)
        param.Value = ByUserId
        params.Add(param)

        SqlHelper.ExecuteNonQuery("stp_Switch_UserGroup", CommandType.StoredProcedure, params.ToArray)
    End Sub

End Class
