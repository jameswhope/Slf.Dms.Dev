Imports System.Data.SqlClient

Partial Class Login
    Inherits System.Web.UI.Page



    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLogin.Click
        If Me.IsValid Then

            Dim user, pass, ipaddress As String
            user = txtUserName.Text
            pass = txtPassword.Text
            ipaddress = GetUserIP()

            Dim Pwd As String = FormsAuthentication.HashPasswordForStoringInConfigFile(txtPassword.Text, "SHA1")
            Dim UserId As Integer = 0
            divMsg.InnerHtml = ""
            If AuthenticationHelper.Authenticate(txtUserName.Text.Trim, Pwd, UserId) Then
                Session.Clear()
                Session("UserId") = UserId

                'Dim ticket As New FormsAuthenticationTicket(1, UserId, DateTime.Now, DateTime.Now.AddMinutes(30), False, String.Empty, FormsAuthentication.FormsCookiePath)
                'Dim encryptedTicket As String = FormsAuthentication.Encrypt(ticket)
                'Dim authCookie As HttpCookie = New HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket)
                'Response.Cookies.Add(authCookie)

                Dim u As UserHelper.UserObj = UserHelper.GetUserObject(UserId)

                pass = Pwd.ToString
                'LogEvent(user, pass, ipaddress, DateTime.Now, 1)
                If u.HasTempPassword Then
                    Response.Redirect("password.aspx")
                Else
                    'authenticate and redirect
                    FormsAuthentication.RedirectFromLoginPage(UserId, True)
                End If
            Else
                'LogEvent(user, pass, ipaddress, DateTime.Now, 0)
                divMsg.InnerHtml = "Invalid username or password!"
            End If
        End If
    End Sub

    Public Shared Function GetUserIP() As String
        Dim userIP As String
        Dim forwardIP As String = HttpContext.Current.Request.ServerVariables("HTTP_X_FORWARDED_FOR")
        If String.IsNullOrEmpty(forwardIP) Then
            userIP = HttpContext.Current.Request.UserHostAddress
        Else
            userIP = forwardIP.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)(0)
        End If
        Return userIP
    End Function

    'Private Sub LogEvent(user As String, Pass As String, ipaddress As String, submissionTime As DateTime, success As Boolean)
    '    Dim params As New List(Of SqlParameter)
    '    params.Add(New SqlParameter("username", user))
    '    params.Add(New SqlParameter("passwrd", Pass))
    '    params.Add(New SqlParameter("ipaddress", ipaddress))
    '    params.Add(New SqlParameter("submissionTime", submissionTime))
    '    params.Add(New SqlParameter("accessed", success))
    '    SqlHelper.ExecuteNonQuery("stp_InsertAuthenicationAttempt", Data.CommandType.StoredProcedure, params.ToArray)
    'End Sub

End Class
