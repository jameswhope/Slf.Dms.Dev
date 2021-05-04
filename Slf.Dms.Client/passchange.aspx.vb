Option Explicit On

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data

Partial Class passchange
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        lnkContactUs.HRef = PropertyHelper.Value("LoginContactUsLink")
    End Sub
    Protected Sub cmdGetPassword_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmdGetPassword.Click

        If RequiredExist() Then

            UpdateAccount()

            'login
            Dim UserID As Integer = DataHelper.FieldLookup("tblUser", "UserID", "UserName = '" & txtUsername.Text & "'")

            FormsAuthentication.SetAuthCookie(UserID, False)

            'show success
            pnlMain.Visible = False
            pnlSuccess.Visible = True

        End If

    End Sub
    Private Sub UpdateAccount()

        Dim UserID As Integer = DataHelper.FieldLookup("tblUser", "UserID", "UserName = '" & txtUsername.Text & "'")

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Password", DataHelper.GenerateSHAHash(txtNewPassword.Text))
        DatabaseHelper.AddParameter(cmd, "Temporary", False)

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblUser", "UserID = " & UserID)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Function RequiredExist() As Boolean

        Dim Messages As New ArrayList

        If txtUsername.Text.Length = 0 Then
            Messages.Add("Your User Name is required.")
        Else
            If txtCurrentPassword.Text.Length = 0 Then
                Messages.Add("Your Current Password is required.  This may be a temporary password you were recently emailed.")
            Else
                If txtNewPassword.Text.Length = 0 Then
                    Messages.Add("Your New Password is required.  This is the new password you want to login with.")
                Else
                    If txtConfirmPassword.Text.Length = 0 Then
                        Messages.Add("The Confirm Password is required.")
                    Else
                        If Not txtNewPassword.Text = txtConfirmPassword.Text Then
                            Messages.Add("The New Password and Confirm Password do not match.  Please re-enter.")
                        Else
                            If DataHelper.Nz_int(DataHelper.FieldCount("tblUser", "UserID", "UserName = '" & txtUsername.Text & "' AND [Password] = '" & DataHelper.GenerateSHAHash(txtCurrentPassword.Text) & "'")) = 0 Then
                                Messages.Add("There is no record of the User Name you entered in the system." _
                                    & " If you would like to register for a new account, using that User Name, please " _
                                    & "<a class=""lnk"" href=""register.aspx"">go here</a> " _
                                    & "to do so.")
                            End If
                        End If
                    End If
                End If
            End If
        End If

        pnlError.Visible = Messages.Count > 0
        lblError.Text = String.Join("<br>", Messages.ToArray(GetType(String)))

        Return Messages.Count = 0

    End Function
End Class