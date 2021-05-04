Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Xml
Imports System.Data

Partial Class login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If MobileHelper.IsMobileDevice(Request.UserAgent) Then
            Response.Redirect("mobile/login.aspx")
        Else
            Try

                'check for proper browser (must be IE 5.5+)
                '3.23.09.ug.turn off ie check per Chris N.
                'If Not BrowserHelper.GetProperty(Page, BrowserProperty.Browser) = "IE" Or _
                '    Double.Parse(BrowserHelper.GetProperty(Page, BrowserProperty.Version)) < 5.5 Then
                '    Response.Redirect("ieonly.aspx")
                'End If

            Catch ex As Exception
                Response.Redirect("ieonly.aspx")
            End Try

            'lnkContactUs.HRef = PropertyHelper.Value("LoginContactUsLink")

            If Request.QueryString("l") = "1" Then
                ShowMessage("You have been logged out of the system due to inactivity.")
            ElseIf Not Me.IsPostBack Then
                If Not Request.QueryString("VD_user") Is Nothing AndAlso Not Request.QueryString("VD_pass") Is Nothing Then
                    Login(Request.QueryString("VD_user").ToString.Trim, Request.QueryString("VD_pass").ToString.Trim, False)
                End If
            End If

            'LoadNews()
        End If
    End Sub
    'Private Function GetRSSData(ByVal strRSSURL As String, ByVal TableIndex As Integer) As DataTable
    '    Dim reader As XmlTextReader = New XmlTextReader(strRSSURL)
    '    Dim ds As DataSet = New DataSet
    '    Try
    '        ds.ReadXml(reader)
    '    Catch
    '    End Try
    '    Return ds.Tables(TableIndex)
    'End Function
    'Private Sub LoadNews()

    '    Dim strRSSURL As String = DataHelper.FieldLookup("tblProperty", "Value", "[Name] = 'LoginNewsRSSURL'")
    '    Dim strRSSNum As Integer = DataHelper.Nz_double(DataHelper.FieldLookup("tblProperty", "Value", "[Name] = 'LoginNewsToDisplay'"))

    '    Dim dtNews As DataTable = GetRSSData(strRSSURL, 3)

    '    'delete all past first strRSSNum
    '    While dtNews.Rows.Count > strRSSNum
    '        dtNews.Rows(dtNews.Rows.Count - 1).Delete()
    '    End While

    '    Try
    '        rpNews.DataSource = dtNews
    '        rpNews.DataBind()
    '    Catch ex As Exception
    '        'Response.Write(ex.message)
    '    End Try

    'End Sub
    Protected Sub cmdLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmdLogin.Click
        Login(txtUsername.Text, DataHelper.GenerateSHAHash(txtPassword.Text), chkRememberMe.Checked)
    End Sub

    Private Sub ShowMessage(ByVal [Error] As String)
        pnlError.Visible = True
        lblError.Text = [Error]
    End Sub

    Private Sub Login(ByVal username As String, ByVal userpassword As String, ByVal persistcookie As Boolean)
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand

        cmd.CommandText = "stp_Login"
        cmd.CommandType = CommandType.StoredProcedure

        DatabaseHelper.AddParameter(cmd, "UserName", username)
        DatabaseHelper.AddParameter(cmd, "Password", userpassword)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim UserID As Integer = DatabaseHelper.Peel_int(rd, "UserID")
                Dim UserTypeID As Integer = DatabaseHelper.Peel_int(rd, "UserTypeID")
                Dim Locked As Boolean = DatabaseHelper.Peel_bool(rd, "Locked")
                Dim Temporary As Boolean = DatabaseHelper.Peel_bool(rd, "Temporary")

                If Locked = True Then
                    ShowMessage("Your account has been locked. Contact your administrator.")
                    'ElseIf UserTypeID = 2 AndAlso String.IsNullOrEmpty(DataHelper.FieldLookup("tblAgency", "AgencyId", "UserId=" & UserID)) Then
                    '    ShowMessage("Your account has been disassociated with your organization. Please contact your administrator.")
                ElseIf UserTypeID = 5 AndAlso String.IsNullOrEmpty(DataHelper.FieldLookup("tblAttorney", "AttorneyId", "UserId=" & UserID)) Then
                    ShowMessage("Your account has been disassociated with your organization. Please contact your administrator.")
                Else
                    If Temporary = True Then
                        Response.Redirect("passchange.aspx")
                    Else

                        'Clear the session
                        Session.Clear()

                        'Load user info
                        Session("UserID") = UserID

                        'authenticate and redirect
                        FormsAuthentication.RedirectFromLoginPage(UserID, persistcookie)

                    End If
                End If

            Else
                ShowMessage("Your user name or password is incorrect. Please try again.")
            End If

        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            DatabaseHelper.EnsureReaderClosed(rd)
        End Try
    End Sub

End Class