Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Partial Class admin_users_user_talents_default
    Inherits PermissionPage


#Region "Variables"

    Private UserID As Integer
    Private RecordUserID As Integer
    Private qs As QueryStringCollection

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            RecordUserID = DataHelper.Nz_int(qs("id"))

        End If

        If Not IsPostBack Then

            LoadTabStrips()
            LoadPositions()
            LoadLanguages()

            lblUser.Text = UserHelper.GetName(RecordUserID)

        End If

        SetRollups()
        SetAttributes()

        trInfoBoxPositions.Visible = DataHelper.FieldCount("tblUserInfoBox", "UserInfoBoxID", _
            "UserID = " & UserID & " AND InfoBoxID = " & 4) = 0

        trInfoBoxLanguages.Visible = DataHelper.FieldCount("tblUserInfoBox", "UserInfoBoxID", _
            "UserID = " & UserID & " AND InfoBoxID = " & 5) = 0

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = CType(Master, admin_users_user_user).CommonTasks

        'add applicant tasks
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save user</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SaveAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save_close.png") & """ align=""absmiddle""/>Save and close</a>")

    End Sub
    Private Sub SetAttributes()

        lboAvailablePositions.Attributes("ondblclick") = "lboAdd_Click(this);"
        lboCurrentPositions.Attributes("ondblclick") = "lboRemove_Click(this);"
        lboAvailablePositions.Attributes("ondblclick") = "lboAdd_Click(this);"
        lboCurrentPositions.Attributes("ondblclick") = "lboRemove_Click(this);"

        lboAvailableLanguages.Attributes("ondblclick") = "lboAdd_Click(this);"
        lboCurrentLanguages.Attributes("ondblclick") = "lboRemove_Click(this);"
        lboAvailableLanguages.Attributes("ondblclick") = "lboAdd_Click(this);"
        lboCurrentLanguages.Attributes("ondblclick") = "lboRemove_Click(this);"

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
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        'set the proper pane on, others off
        Dim Panes As New List(Of HtmlTable)

        Panes.Add(dvTalent0)
        Panes.Add(dvTalent1)

        For Each Pane As HtmlTable In Panes

            If Pane.ID.Substring(Pane.ID.Length - 1, 1) = tsTalents.SelectedIndex Then
                Pane.Style("display") = "inline"
            Else
                Pane.Style("display") = "none"
            End If

        Next

    End Sub
    Private Sub LoadTabStrips()

        tsTalents.TabPages.Clear()

        tsTalents.TabPages.Add(New Slf.Dms.Controls.TabPage("Positions", dvTalent0.ClientID))
        tsTalents.TabPages.Add(New Slf.Dms.Controls.TabPage("Languages", dvTalent1.ClientID))

    End Sub
    Private Sub LoadPositions()

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetAllPositionsWithUserFlag")

            DatabaseHelper.AddParameter(cmd, "UserID", RecordUserID)

            lboCurrentPositions.Items.Clear()
            lboAvailablePositions.Items.Clear()
            txtSelectedPositions.Value = String.Empty

            Using cmd.Connection

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        Dim PositionID As Integer = DatabaseHelper.Peel_int(rd, "PositionID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")

                        If rd.IsDBNull(rd.GetOrdinal("UserID")) Then

                            lboAvailablePositions.Items.Add(New ListItem(Name, PositionID))

                        Else

                            lboCurrentPositions.Items.Add(New ListItem(Name, PositionID))

                            If txtSelectedPositions.Value.Length > 0 Then
                                txtSelectedPositions.Value += "," & PositionID
                            Else
                                txtSelectedPositions.Value = PositionID
                            End If

                        End If

                    End While

                End Using
            End Using
        End Using

    End Sub
    Private Sub LoadLanguages()

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetAllLanguagesWithUserFlag")

            DatabaseHelper.AddParameter(cmd, "UserID", RecordUserID)

            lboCurrentLanguages.Items.Clear()
            lboAvailableLanguages.Items.Clear()
            txtSelectedLanguages.Value = String.Empty

            Using cmd.Connection

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        Dim LanguageID As Integer = DatabaseHelper.Peel_int(rd, "LanguageID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")

                        If rd.IsDBNull(rd.GetOrdinal("UserID")) Then

                            lboAvailableLanguages.Items.Add(New ListItem(Name, LanguageID))

                        Else

                            lboCurrentLanguages.Items.Add(New ListItem(Name, LanguageID))

                            If txtSelectedLanguages.Value.Length > 0 Then
                                txtSelectedLanguages.Value += "," & LanguageID
                            Else
                                txtSelectedLanguages.Value = LanguageID
                            End If

                        End If

                    End While

                End Using
            End Using
        End Using

    End Sub
    Protected Sub lnkCloseInformationPositions_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCloseInformationPositions.Click

        'insert flag record
        UserInfoBoxHelper.Insert(4, UserID)

        Refresh()

    End Sub
    Protected Sub lnkCloseInformationLanguages_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCloseInformationLanguages.Click

        'insert flag record
        UserInfoBoxHelper.Insert(5, UserID)

        Refresh()

    End Sub
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Private Sub Refresh()
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub
    Private Sub Close()
        Response.Redirect("~/admin/users/")
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        UpdateUser()
        Refresh()
    End Sub
    Protected Sub lnkSaveAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveAndClose.Click
        UpdateUser()
        Close()
    End Sub
    Private Sub UpdateUser()
        SavePositions()
        SaveLanguages()
    End Sub
    Private Sub SavePositions()

        'delete all existing positions against this user
        UserPositionHelper.DeleteForUser(RecordUserID)

        'save each position anew
        If txtSelectedPositions.Value.Length > 0 Then
            For Each PositionID As String In txtSelectedPositions.Value.Split(",")
                UserPositionHelper.Insert(PositionID, RecordUserID)
            Next
        End If

    End Sub
    Private Sub SaveLanguages()

        'delete all existing language against this user
        UserLanguageHelper.DeleteForUser(RecordUserID)

        'save each language anew
        If txtSelectedLanguages.Value.Length > 0 Then
            For Each LanguageID As String In txtSelectedLanguages.Value.Split(",")
                UserLanguageHelper.Insert(LanguageID, RecordUserID)
            Next
        End If

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Users-User Single Record-Talents")
    End Sub
End Class