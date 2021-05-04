Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class admin_users_group_default
    Inherits PermissionPage


#Region "Variables"

    Private Action As String
    Private UserGroupID As Integer
    Private qs As QueryStringCollection

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            Action = DataHelper.Nz_string(qs("a"))
            UserGroupID = DataHelper.Nz_int(qs("id"), 0)

            If Not IsPostBack Then
                HandleAction()
            End If

            SetRollups()

        End If

    End Sub

    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = CType(Master, admin_users_group_group).CommonTasks

        'add applicant tasks
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save group</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SaveAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save_close.png") & """ align=""absmiddle""/>Save and close</a>")

        If Not Action = "a" Then

            'add delete task
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this group</a>")

        End If

    End Sub
    Private Sub HandleAction()

        SetAttributes()

        Select Case Action
            Case "a"    'add

                lblUser.Text = "Add New Group"

                tblAuditTrail.Visible = False

                bodMain.Attributes("onload") = "SetFocus('" & txtUserName.ClientID & "');"

                CType(Master, admin_users_group_group).AddMode = True

            Case Else   'edit

                LoadRecord()

                lblUser.Text = DataHelper.FieldLookup("tblUserGroup", "Name", "UserGroupId=" & UserGroupID)

                tblAuditTrail.Visible = True

                bodMain.Attributes("onload") = "SetFocus('" & txtUserName.ClientID & "');"

        End Select

    End Sub
    Private Sub SetAttributes()

    End Sub
    Private Sub LoadRecord()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "SELECT * FROM tblUserGroup WHERE UserGroupID = @UserGroupID"

                DatabaseHelper.AddParameter(cmd, "UserGroupID", UserGroupID)

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)

                    If rd.Read() Then

                        txtUserName.Text = DatabaseHelper.Peel_string(rd, "Name")

                        lblCreated.Text = DatabaseHelper.Peel_datestring(rd, "Created", "MM/dd/yyyy hh:mm tt")
                        lblCreatedByName.Text = UserHelper.GetName(DatabaseHelper.Peel_int(rd, "CreatedBy"))
                        lblLastModified.Text = DatabaseHelper.Peel_datestring(rd, "LastModified", "MM/dd/yyyy hh:mm tt")
                        lblLastModifiedByName.Text = UserHelper.GetName(DatabaseHelper.Peel_int(rd, "LastModifiedBy"))

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
        Response.Redirect("~/admin/users")
    End Sub
    Private Function InsertOrUpdateUser() As Integer

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)
        DatabaseHelper.AddParameter(cmd, "Name", txtUserName.Text)

        If Action = "a" Then 'add

            DatabaseHelper.AddParameter(cmd, "Created", Now)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

            DatabaseHelper.BuildInsertCommandText(cmd, "tblUserGroup", "UserGroupID", SqlDbType.Int)

        Else 'edit
            DatabaseHelper.BuildUpdateCommandText(cmd, "tblUserGroup", "UserGroupID = " & UserGroupID)
        End If

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If Action = "a" Then 'add
            UserGroupID = DataHelper.Nz_int(cmd.Parameters("@UserGroupID").Value)
        End If

        Return UserGroupID

    End Function
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        Save()

        'reload same page without add action
        Response.Redirect("~/admin/users/group/?id=" & UserGroupID)

    End Sub
    Private Sub ShowErrors(ByVal Message As String)

        tdError.InnerHtml = Message
        dvError.Style("display") = "inline"

    End Sub
    Protected Sub lnkSaveAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveAndClose.Click

        Save()


            'return to all users
        Close()

    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        'delete user
        DataHelper.Delete("tblUserGroup", "UserGroupId=" & UserGroupID)

        Close()

    End Sub
    Private Sub Save()

        'save record
        InsertOrUpdateUser()

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Admin-Users-Group Single Record-General Information")
    End Sub
End Class