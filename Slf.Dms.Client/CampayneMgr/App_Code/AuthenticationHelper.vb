Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient

Public Class AuthenticationHelper

    Public Shared Function Authenticate(ByVal UserName As String, ByVal Password As String, ByRef UserId As Integer) As Boolean
        Dim bAuthenticated As Boolean = False
        Dim dt As DataTable = AuthenticationHelper.GetUserByNameandPassword(UserName, Password)
        If dt.Rows.Count > 0 Then
            UserId = CInt(dt.Rows(0)("userid"))
            bAuthenticated = True
        End If
        Return bAuthenticated
    End Function

    Public Shared Function GetUserByNameandPassword(ByVal UserName As String, ByVal Password As String) As DataTable
        Dim params As New List(Of SqlParameter)
        Dim param As SqlParameter

        param = New SqlParameter("@UserName", SqlDbType.VarChar)
        param.Value = UserName.Trim
        params.Add(param)

        param = New SqlParameter("@Password", SqlDbType.VarChar)
        param.Value = Password.Trim
        params.Add(param)

        Return SqlHelper.GetDataTable("stp_GetUserByCredentials", CommandType.StoredProcedure, params.ToArray)
    End Function

End Class
