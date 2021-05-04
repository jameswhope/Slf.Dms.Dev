Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Net.Mail
Imports System.Data

Partial Class mobile_login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Request.QueryString("action") = "logout" Then
                Session.Clear()
                Session.Abandon()
                FormsAuthentication.SignOut()
                ShowMessage("You are now logged out.")
            End If
        End If
    End Sub

    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLogin.Click
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

        cmd.CommandText = "stp_Login"
        cmd.CommandType = CommandType.StoredProcedure

        DatabaseHelper.AddParameter(cmd, "UserName", txtUsername.Text)
        DatabaseHelper.AddParameter(cmd, "Password", DataHelper.GenerateSHAHash(txtPassword.Text))

        Try
            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then
                Dim UserID As Integer = DatabaseHelper.Peel_int(rd, "UserID")
                Dim UserTypeID As Integer = DatabaseHelper.Peel_int(rd, "UserTypeID")
                Dim Locked As Boolean = DatabaseHelper.Peel_bool(rd, "Locked")
                Dim Temporary As Boolean = DatabaseHelper.Peel_bool(rd, "Temporary")

                If Locked Then
                    ShowMessage("Your account has been locked. Contact your administrator.")
                ElseIf UserTypeID = 5 AndAlso String.IsNullOrEmpty(DataHelper.FieldLookup("tblAttorney", "AttorneyId", "UserId=" & UserID)) Then
                    ShowMessage("Your account has been disassociated with your organization. Please contact your administrator.")
                Else
                    If Not Temporary Then
                        If Drg.Util.DataHelpers.SettlementProcessingHelper.IsManager(UserID) Then
                            'Clear the session
                            Session.Clear()

                            'Load user info
                            Session("UserID") = UserID
                            Session("UseMobileSite") = IIf(chkFullSite.Checked, "0", "1")

                            'authenticate and redirect
                            FormsAuthentication.RedirectFromLoginPage(UserID, False)
                        Else
                            ShowMessage("You are not authorized to enter this site.")
                        End If
                    End If
                End If
            Else
                ShowMessage("Your username or password is incorrect. Please try again.")
            End If

        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            DatabaseHelper.EnsureReaderClosed(rd)
        End Try

    End Sub

    Private Sub ShowMessage(ByVal [Error] As String)
        lblMsgs.Text = [Error]
    End Sub
End Class
