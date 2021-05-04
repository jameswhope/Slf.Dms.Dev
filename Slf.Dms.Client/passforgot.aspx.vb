Option Explicit On

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data

Partial Class passforgot
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        lnkContactUs.HRef = PropertyHelper.Value("LoginContactUsLink")
        lnkContactUs2.HRef = lnkContactUs.HRef

    End Sub
    Protected Sub cmdGetPassword_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmdGetPassword.Click

        If RequiredExist Then

            SendEmail()

            'show user
            pnlMain.Visible = False
            pnlSuccess.Visible = True
            lblEmail.Text = DataHelper.FieldLookup("tblUser", "EmailAddress", "UserName = '" & txtUsername.Text & "'")

        End If

    End Sub
    Private Sub SendEmail()

        Dim UserID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblUser", "UserID", "UserName = '" & txtUsername.Text & "'"))
        Dim UserEmail As String = DataHelper.Nz_string(DataHelper.FieldLookup("tblUser", "EmailAddress", "UserID = " & UserID & ""))

        Dim ContactUs As String = PropertyHelper.Value("LoginContactUsLink")

        Dim NewPassword As Integer = New Random().Next

        'reset the account temp password to a random number
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "Password", DataHelper.GenerateSHAHash(NewPassword))
        DatabaseHelper.AddParameter(cmd, "Temporary", True)

        DatabaseHelper.BuildUpdateCommandText(cmd, "tblUser", "UserID = " & UserID)

        DatabaseHelper.ExecuteNonQuery(cmd)

        Dim Subject As String = "New temporary password"

        Dim Message As String = "Because of the advanced security techniques that are used by the " _
            & "Debt Mediation Portal, it is impossible for the development team to know what " _
            & "your previous password was.  All passwords are hashed and compared under encryption by the server." _
            & "  So instead we have reset your password with a random value as is listed below." _
            & vbCrLf & vbCrLf & "Please use this information the next time you login:" _
            & vbCrLf & vbCrLf & "User Name:" & vbTab & txtUsername.Text _
            & vbCrLf & "Password: " & vbTab & NewPassword.ToString() _
            & vbCrLf & vbCrLf & vbCrLf & "After you have logged in, you will be prompted to enter " _
            & "a new permanent password for future use." _
            & vbCrLf & vbCrLf & vbCrLf & New String("-", 50) _
            & vbCrLf & PropertyHelper.Value("SystemEmailName") _
            & vbCrLf & "Development Team" _
            & vbCrLf & PropertyHelper.Value("SystemEmailContactUsLink") & vbCrLf & vbCrLf

        EmailHelper.SendMessage("itgroup@lexxiom.com", UserEmail, Subject, Message)

    End Sub
    Private Function RequiredExist() As Boolean

        Dim Messages As New ArrayList

        If txtUsername.Text.Length = 0 Then
            Messages.Add("Your User Name is required.")
        Else
            If DataHelper.Nz_int(DataHelper.FieldCount("tblUser", "UserID", "UserName = '" & txtUsername.Text & "'")) = 0 Then
                Messages.Add("There is no record of the User Name you entered in the system." _
                    & " If you would like to register for a new account, using that User Name, please " _
                    & "<a class=""lnk"" href=""register.aspx"">go here</a> " _
                    & "to do so.")
            End If
        End If

        pnlError.Visible = Messages.Count > 0
        lblError.Text = String.Join("<br>", Messages.ToArray(GetType(String)))

        Return Messages.Count = 0

    End Function
End Class