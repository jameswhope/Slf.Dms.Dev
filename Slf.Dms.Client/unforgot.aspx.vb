Option Explicit On

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data

Partial Class unforgot
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        lnkContactUs.HRef = PropertyHelper.Value("LoginContactUsLink")
        lnkContactUs2.HRef = lnkContactUs.HRef

    End Sub
    Protected Sub cmdGetUserName_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmdGetUserName.Click

        If RequiredExist() Then

            SendEmail()

            'show user
            pnlMain.Visible = False
            pnlSuccess.Visible = True
            lblEmail.Text = txtEmailAddress.Text

        End If

    End Sub
    Private Sub SendEmail()

        Dim UserID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblUser", "UserID", "EmailAddress = '" & txtEmailAddress.Text & "'"))
        Dim UserName As String = DataHelper.FieldLookup("tblUser", "UserName", "UserID = " & UserID)

        Dim Subject As String = "Your account User Name"

        Dim Message As String = "Your User Name is " & UserName _
            & vbCrLf & vbCrLf & vbCrLf & New String("-", 50) _
            & vbCrLf & PropertyHelper.Value("SystemEmailName") _
            & vbCrLf & "Development Team" _
            & vbCrLf & PropertyHelper.Value("SystemEmailContactUsLink") & vbCrLf & vbCrLf

        'EmailHelper.SendMessage(New Integer() {UserID}, Subject, Message)

    End Sub
    Private Function RequiredExist() As Boolean

        Dim Messages As New ArrayList

        If txtEmailAddress.Text.Length = 0 Then
            Messages.Add("Your Email Address is required.")
        Else
            If DataHelper.Nz_int(DataHelper.FieldCount("tblUser", "UserID", "EmailAddress = '" & txtEmailAddress.Text & "'")) = 0 Then
                Messages.Add("There is no record of the Email Address you entered in the system.")
            End If
        End If

        pnlError.Visible = Messages.Count > 0
        lblError.Text = String.Join("<br>", Messages.ToArray(GetType(String)))

        Return Messages.Count = 0

    End Function
End Class