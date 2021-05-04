Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class admin_users_user_history_search
    Inherits PermissionPage


#Region "Variables"

    Private Action As String
    Private RecordUserID As Integer
    Private UserSearchID As Integer
    Private qs As QueryStringCollection

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            Action = DataHelper.Nz_string(qs("a"))
            RecordUserID = DataHelper.Nz_int(qs("id"), 0)
            UserSearchID = DataHelper.Nz_int(qs("usid"), 0)

            If Not IsPostBack Then
                HandleAction()
            End If

            SetRollups()

        End If

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = CType(Master, admin_users_user_user).CommonTasks

        'add applicant tasks
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this search</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_ExecuteSearch();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_exclamationpoint.png") & """ align=""absmiddle""/>Execute this search</a>")

    End Sub
    Private Sub HandleAction()

        LoadRecord()

        lnkUser.InnerHtml = UserHelper.GetName(RecordUserID)
        lnkUser.HRef = ResolveUrl("~/admin/users/user/?id=" & RecordUserID)
        lnkUserHistory.HRef = ResolveUrl("~/admin/users/user/history/?id=" & RecordUserID)

    End Sub
    Private Sub LoadRecord()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblUserSearch WHERE UserSearchID = @UserSearchID"

            DatabaseHelper.AddParameter(cmd, "UserSearchID", UserSearchID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)

                    If rd.Read() Then

                        lblSearch.Text = DatabaseHelper.Peel_datestring(rd, "Search", "MM/dd/yyyy hh:mm:ss tt")
                        lblTerms.Text = DatabaseHelper.Peel_string(rd, "Terms")

                        lblResultsClients.Text = DatabaseHelper.Peel_double(rd, "ResultsClients").ToString("#,##0")
                        lblResultsNotes.Text = DatabaseHelper.Peel_double(rd, "ResultsNotes").ToString("#,##0")
                        lblResultsCalls.Text = DatabaseHelper.Peel_double(rd, "ResultsCalls").ToString("#,##0")
                        lblResultsTasks.Text = DatabaseHelper.Peel_double(rd, "ResultsTasks").ToString("#,##0")
                        lblResultsEmail.Text = DatabaseHelper.Peel_double(rd, "ResultsEmail").ToString("#,##0")
                        lblResultsPersonnel.Text = DatabaseHelper.Peel_double(rd, "ResultsPersonnel").ToString("#,##0")

                    End If

                End Using
            End Using
        End Using

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Private Sub Close()
        Response.Redirect("~/admin/users/user/history/?id=" & RecordUserID)
    End Sub
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        'delete user search
        UserSearchHelper.Delete(UserSearchID)

        'drop back to user history
        Close()

    End Sub
    Protected Sub lnkExecuteSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExecuteSearch.Click

        Dim Terms As String = DataHelper.FieldLookup("tblUserSearch", "Terms", "UserSearchID = " & UserSearchID)

        Response.Redirect("~/search.aspx?q=" & Terms)

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Users-User Single Record-History")
    End Sub
End Class