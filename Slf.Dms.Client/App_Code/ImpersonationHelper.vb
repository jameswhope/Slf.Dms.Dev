Imports Microsoft.VisualBasic
Imports System.Security.Principal
Imports System.Security.Permissions

Public Class ImpersonationHelper

    Public Declare Auto Function LogonUser Lib "advapi32.dll" (ByVal lpszUsername As String, ByVal lpszDomain As String, ByVal lpszPassword As String, ByVal dwLogonType As Integer, ByVal dwLogonProvider As Integer, ByRef phToken As IntPtr) As Integer
    Public Declare Auto Function DuplicateToken Lib "advapi32.dll" (ByVal ExistingTokenHandle As IntPtr, ByVal ImpersonationLevel As Integer, ByRef DuplicateTokenHandle As IntPtr) As Integer
    Private LOGON32_LOGON_INTERACTIVE As Integer = 2
    Private LOGON32_PROVIDER_DEFAULT As Integer = 0
    Private moImpersonationContext As WindowsImpersonationContext

    Public Function ImpersonateUser(ByVal userName As String, ByVal domain As String, ByVal password As String) As Boolean
        '------------------------------------------------
        'PURPOSE: Impersonate a specific user
        'INPUTS: username(str), domain (str), pwd(str)
        'OUTPUTS: Boolean
        '------------------------------------------------
        Try
            Dim otempWindowsIdentity As WindowsIdentity
            Dim token As IntPtr
            Dim tokenDuplicate As IntPtr
            If LogonUser(userName, domain, password, LOGON32_LOGON_INTERACTIVE, _
            LOGON32_PROVIDER_DEFAULT, token) <> 0 Then
                If DuplicateToken(token, 2, tokenDuplicate) <> 0 Then
                    otempWindowsIdentity = New WindowsIdentity(tokenDuplicate)
                    moImpersonationContext = otempWindowsIdentity.Impersonate()
                    If moImpersonationContext Is Nothing Then
                        ImpersonateUser = False
                    Else
                        ImpersonateUser = True
                    End If
                Else
                    ImpersonateUser = False
                End If
            Else
                ImpersonateUser = False
            End If
        Catch ex As Exception
            Throw New System.Exception("Error Occurred in ImpersonateUser() : " & ex.ToString)
        End Try
    End Function

    Public Sub UndoImpersonation()
        '------------------------------------------------
        'PURPOSE: Undo the impersonation
        'INPUTS: None
        'OUTPUTS: None
        '------------------------------------------------

        Try
            moImpersonationContext.Undo()
        Catch ex As Exception
            Throw New System.Exception("Error Occurred in UndoImpersonation() : " & ex.ToString)
        End Try

    End Sub

End Class
