
Partial Class Password
    Inherits System.Web.UI.Page

    Protected Sub btnChangePwd_Click(sender As Object, e As System.EventArgs) Handles btnChangePwd.Click
        Try
            Using u As UserHelper.UserObj = UserHelper.GetUserObject(Session("UserId"))
                Dim oPwd As String = UserHelper.GenerateSHAHash(txtOldPassword.Text.Trim)
                Dim nPwd As String = txtNewPassword.Text.Trim
                If oPwd.ToUpper = u.Password.ToUpper Then
                    If UserHelper.ChangePassword(u.UserId, oPwd, nPwd) Then
                        FormsAuthentication.RedirectFromLoginPage(u.UserId, True)
                    End If
                End If
            End Using
        Catch ex As Exception
            Response.Redirect("login.aspx")
        End Try
        
    End Sub
    
End Class
