Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Imports System.Text
Imports Slf.Dms.Controls.PermissionHelper
Imports System.Data.SqlClient

Partial Class admin_users_user_default
    Inherits PermissionPage


#Region "Variables"

    Private Action As String
    Private RecordUserID As Integer
    Private qs As QueryStringCollection

    Private UserID As Integer
    Dim IsMy As Boolean
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GlobalFiles.AddScriptFiles(Me.Page, New String() {GlobalFiles.JQuery.JQuery, _
                                                  GlobalFiles.JQuery.UI, _
                                                  "~/jquery/json2.js", _
                                                  "~/jquery/jquery.modaldialog.js" _
                                                  })
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        qs = LoadQueryString()

        If Not qs Is Nothing Then
            Action = DataHelper.Nz_string(qs("a"))
            RecordUserID = DataHelper.Nz_int(qs("id"), 0)

            If Not IsPostBack Then
                PopulateUserTypes()
                PopulateUserGroups()
                HandleAction()
                LoadUserCompanies()
                LoadUserCommRecs()
                LoadUserAgency()
                LoadUserClient()
                LoadExtension()
            End If

            SetRollups()
        End If
    End Sub

    Private Function GetCol0(ByVal dr As System.Data.DataRow) As String
        Return dr(0).ToString
    End Function

    Private Function GetCol1(ByVal dr As System.Data.DataRow) As String
        Return dr(1).ToString
    End Function

    Private Sub LoadUserCompanies()
        Dim tbl As DataTable = Drg.Util.DataHelpers.UserHelper.UserCompanies(RecordUserID)
        Dim ar As System.Array

        If tbl.Rows.Count > 0 Then
            ar = Array.ConvertAll(tbl.Select(), New Converter(Of System.Data.DataRow, String)(AddressOf GetCol0))
            hdnCompanyIDs.Value = String.Join(",", ar)
            ar = Array.ConvertAll(tbl.Select(), New Converter(Of System.Data.DataRow, String)(AddressOf GetCol1))
            divCompanys.InnerHtml = String.Join("<br>", ar)
            'trCompany.Visible = True
        Else
            hdnCompanyIDs.Value = "-1"
            divCompanys.InnerHtml = "None"
            'trCompany.Visible = False
        End If
    End Sub

    Private Sub LoadUserCommRecs()
        Dim tbl As DataTable = Drg.Util.DataHelpers.UserHelper.UserCommRecs(RecordUserID)
        Dim commrecs As String = "None"
        Dim ids As String = "-1"

        For Each row As DataRow In tbl.Rows
            If ids = "-1" Then
                ids = row(0).ToString
            Else
                ids &= "," & row(0).ToString
            End If
            If commrecs = "None" Then
                commrecs = row(2).ToString
            Else
                commrecs &= "<br>" & row(2).ToString
            End If
        Next

        divCommRecs.InnerHtml = commrecs
        hdnCommRecIDs.Value = ids
    End Sub

    Private Sub LoadUserAgency()
        Dim tbl As DataTable = Drg.Util.DataHelpers.UserHelper.UserAgency(RecordUserID)
        Dim agencys As String = "None"
        Dim ids As String = "-1"

        For Each row As DataRow In tbl.Rows
            If ids = "-1" Then
                ids = row(0).ToString
            Else
                ids &= "," & row(0).ToString
            End If
            If agencys = "None" Then
                agencys = row(2).ToString
            Else
                agencys &= "<br>" & row(2).ToString
            End If
        Next

        divAgency.InnerHtml = agencys
        hdnAgencyIDs.Value = ids
    End Sub

    Private Sub LoadUserClient()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblUserClientAccess where UserID = " & RecordUserID
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        txtClientCreatedFrom.Text = CStr(rd("ClientCreatedFrom"))
                        txtClientCreatedTo.Text = CStr(rd("ClientCreatedTo"))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub PopulateUserTypes()
        ddlUserType.Items.Clear()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblUserType"

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        ddlUserType.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "UserTypeId")))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub PopulateUserGroups()
        ddlUserGroup.Items.Clear()
        ddlUserGroup.Items.Add(" ")
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT g.* FROM tblUserGroup g join tblUserTypeXref x on x.UserGroupId = g.UserGroupId and x.UserTypeId = " & ddlUserType.SelectedItem.Value & " ORDER BY g.Name"

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        ddlUserGroup.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "UserGroupId")))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = CType(Master, admin_users_user_user).CommonTasks

        'add applicant tasks
        If Permission.UserEdit(IsMy) Then
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save user</a>")
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SaveAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save_close.png") & """ align=""absmiddle""/>Save and close</a>")
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_RandomizePassword();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_dataentrytype.png") & """ align=""absmiddle""/>Randomize Password</a>")
        Else
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
        End If

        If Not Action = "a" Then
            'add delete task
            If Permission.UserDelete(IsMy) Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this user</a>")
            End If
        End If

    End Sub

    Private Sub HandleAction()
        SetAttributes()

        Select Case Action
            Case "a"    'add
                lblUser.Text = "Add New User"

                trPassword.Visible = True
                trSetPassword.Visible = False
                lblUserName.Visible = False
                txtUserName.Visible = True
                tblAuditTrail.Visible = False

                chkTemporary.Checked = True
                chkTemporary.Enabled = False

                bodMain.Attributes("onload") = "SetFocus('" & txtUserName.ClientID & "');"

                CType(Master, admin_users_user_user).AddMode = True

                IsMy = True
            Case Else   'edit

                LoadRecord()

                lblUser.Text = UserHelper.GetName(RecordUserID)

                trPassword.Visible = False
                lblUserName.Visible = True
                txtUserName.Visible = False
                tblAuditTrail.Visible = True

                bodMain.Attributes("onload") = "SetFocus('" & txtFirstName.ClientID & "');"
        End Select

    End Sub
    Private Sub SetAttributes()

    End Sub
    Private Sub LoadRecord()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "SELECT * FROM tblUser WHERE UserID = @UserID"

                DatabaseHelper.AddParameter(cmd, "UserID", RecordUserID)

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)

                    If rd.Read() Then

                        lblUserName.Text = DatabaseHelper.Peel_string(rd, "UserName")
                        txtFirstName.Text = DatabaseHelper.Peel_string(rd, "FirstName")
                        txtLastName.Text = DatabaseHelper.Peel_string(rd, "LastName")
                        txtEmailAddress.Text = DatabaseHelper.Peel_string(rd, "EmailAddress")

                        chkSuperUser.Checked = DatabaseHelper.Peel_bool(rd, "SuperUser")
                        chkLocked.Checked = DatabaseHelper.Peel_bool(rd, "Locked")
                        chkTemporary.Checked = DatabaseHelper.Peel_bool(rd, "Temporary")
                        chkManager.Checked = DatabaseHelper.Peel_bool(rd, "Manager")

                        lblCreated.Text = DatabaseHelper.Peel_datestring(rd, "Created", "MM/dd/yyyy hh:mm tt")
                        lblCreatedByName.Text = UserHelper.GetName(DatabaseHelper.Peel_int(rd, "CreatedBy"))
                        lblLastModified.Text = DatabaseHelper.Peel_datestring(rd, "LastModified", "MM/dd/yyyy hh:mm tt")
                        lblLastModifiedByName.Text = UserHelper.GetName(DatabaseHelper.Peel_int(rd, "LastModifiedBy"))

                        ListHelper.SetSelected(ddlUserType, DatabaseHelper.Peel_int(rd, "UserTypeId"))
                        PopulateUserGroups()
                        ListHelper.SetSelected(ddlUserGroup, DatabaseHelper.Peel_int(rd, "UserGroupId"))
                        'ListHelper.SetSelected(ddlCommRec, DatabaseHelper.Peel_int(rd, "CommRecId"))

                        IsMy = (DatabaseHelper.Peel_int(rd, "CreatedBy") = UserID)

                        'If ddlUserType.SelectedItem.Text.ToLower = "auditor" Then
                        '    trCommRec.Visible = False
                        'End If

                        'If rd("UserTypeID").ToString = "2" Then 'Agency
                        '    ListHelper.SetSelected(ddlAgency, DatabaseHelper.Peel_int(rd, "AgencyId"))
                        '    trAgency.Visible = True
                        'End If
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

        DatabaseHelper.AddParameter(cmd, "FirstName", txtFirstName.Text)
        DatabaseHelper.AddParameter(cmd, "LastName", txtLastName.Text)
        DatabaseHelper.AddParameter(cmd, "EmailAddress", txtEmailAddress.Text)
        DatabaseHelper.AddParameter(cmd, "SuperUser", chkSuperUser.Checked)
        DatabaseHelper.AddParameter(cmd, "Locked", chkLocked.Checked)
        DatabaseHelper.AddParameter(cmd, "Temporary", chkTemporary.Checked)
        DatabaseHelper.AddParameter(cmd, "Manager", chkManager.Checked)
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)
        DatabaseHelper.AddParameter(cmd, "UserTypeId", ddlUserType.SelectedValue)

        If Not txtNewPassword.Text Is Nothing And txtNewPassword.Text.Length > 0 Then
            DatabaseHelper.AddParameter(cmd, "Password", DataHelper.GenerateSHAHash(txtNewPassword.Text))
        End If

        If Not ddlUserGroup.SelectedIndex = 0 Then
            DatabaseHelper.AddParameter(cmd, "UserGroupId", ddlUserGroup.SelectedValue)
        Else
            DatabaseHelper.AddParameter(cmd, "UserGroupId", DBNull.Value, DbType.Int32)
        End If

        'Add the first CompanyID in the list to tblUser
        Dim companyids() As String = hdnCompanyIDs.Value.Split(",")
        DatabaseHelper.AddParameter(cmd, "CompanyID", companyids(0), DbType.Int32)

        'Add the first AgencyID in the list to tblUser
        Dim agencyids() As String = hdnAgencyIDs.Value.Split(",")
        DatabaseHelper.AddParameter(cmd, "AgencyID", agencyids(0), DbType.Int32)

        'Add the first CommRecID in the list to tblUser
        Dim commrecids() As String = hdnCommRecIDs.Value.Split(",")
        DatabaseHelper.AddParameter(cmd, "CommRecID", commrecids(0), DbType.Int32)

        If Action = "a" Then 'add
            DatabaseHelper.AddParameter(cmd, "UserName", txtUserName.Text)
            DatabaseHelper.AddParameter(cmd, "Password", DataHelper.GenerateSHAHash(txtPassword.Text))
            DatabaseHelper.AddParameter(cmd, "Created", Now)
            DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

            DatabaseHelper.BuildInsertCommandText(cmd, "tblUser", "UserID", SqlDbType.Int)
        Else 'edit
            DatabaseHelper.BuildUpdateCommandText(cmd, "tblUser", "UserID = " & RecordUserID)
        End If

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If Action = "a" Then 'add
            RecordUserID = DataHelper.Nz_int(cmd.Parameters("@UserID").Value)
        End If

        Drg.Util.DataHelpers.UserHelper.SaveUserAgencyAccess(RecordUserID, hdnAgencyIDs.Value)
        Drg.Util.DataHelpers.UserHelper.SaveUserCompanyAccess(RecordUserID, hdnCompanyIDs.Value)
        Drg.Util.DataHelpers.UserHelper.SaveUserCommRecAccess(RecordUserID, hdnCommRecIDs.Value)
        Drg.Util.DataHelpers.UserHelper.SaveUserClientAccess(RecordUserID, txtClientCreatedFrom.Text, txtClientCreatedTo.Text)

        Return RecordUserID
    End Function
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        If RequiredExist() Then

            Save()

            'reload same page without add action
            Response.Redirect("~/admin/users/user/?id=" & RecordUserID)

        End If

    End Sub
    Private Function RequiredExist() As Boolean

        Dim Messages As New List(Of String)

        If Action = "a" Then

            If UserHelper.Exists(txtUserName.Text) Then
                Messages.Add("The User Name you entered already exists in the system.  Please enter a different User Name.")
            End If

        End If

        If Messages.Count > 0 Then
            ShowErrors(String.Join("<br>", Messages.ToArray()))
        End If

        Return Messages.Count = 0

    End Function
    Private Sub ShowErrors(ByVal Message As String)

        tdError.InnerHtml = Message
        dvError.Style("display") = "inline"

    End Sub
    Protected Sub lnkSaveAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveAndClose.Click

        If RequiredExist() Then

            Save()

            'return to all users
            Close()

        End If

    End Sub
    Protected Sub lnkRandomizePassword_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRandomizePassword.Click
        Dim accChars As String = "abcdefghijklmnopqrstuvwxyz0123456789"
        Dim randObj As New Random()
        Dim newPass As String = ""

        For passLength As Integer = 0 To 8
            newPass += accChars.Substring(randObj.Next(0, len(accChars)), 1)
        Next

        txtNewPassword.Text = newPass
    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        'delete user
        UserHelper.Delete(RecordUserID)
        DeleteUserExtension()

        'drop back to applicants
        Close()

    End Sub
    Private Sub Save()

        'save record
        InsertOrUpdateUser()
        'Save user extension
        SaveUserExtension()

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Users-User Single Record-General Information")
        AddControl(bodMain, c, "Users-User Single Record", 3, True)
        AddControl(bodReadOnly, c, "Users-User Single Record", 3, False)
        
    End Sub

    Private Function GetPairs() As List(Of Pair(Of Control))
        Dim l As New List(Of Pair(Of Control))

        l.Add(New Pair(Of Control)(ro_chkLocked, chkLocked))
        l.Add(New Pair(Of Control)(ro_chkSuperUser, chkSuperUser))
        l.Add(New Pair(Of Control)(ro_chkTemporary, chkTemporary))
        'l.Add(New Pair(Of Control)(ro_ddlCommRec, ddlCommRec))
        l.Add(New Pair(Of Control)(ro_ddlUserGroup, ddlUserGroup))
        l.Add(New Pair(Of Control)(ro_ddlUserType, ddlUserType))
        l.Add(New Pair(Of Control)(ro_lblCreated, lblCreated))
        l.Add(New Pair(Of Control)(ro_lblCreatedByName, lblCreatedByName))
        l.Add(New Pair(Of Control)(ro_lblLastModified, lblLastModified))
        l.Add(New Pair(Of Control)(ro_lblLastModifiedByName, lblLastModifiedByName))
        l.Add(New Pair(Of Control)(ro_lblUser, lblUser))
        l.Add(New Pair(Of Control)(ro_lblUserName, lblUserName))    
        l.Add(New Pair(Of Control)(ro_txtEmailAddress, txtEmailAddress))
        l.Add(New Pair(Of Control)(ro_txtFirstName, txtFirstName))
        l.Add(New Pair(Of Control)(ro_txtLastName, txtLastName))
        l.Add(New Pair(Of Control)(ro_chkManager, chkManager))

        Return l
    End Function
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        If Permission.UserEdit(IsMy) Then
            'editable
            bodMain.Visible = True
            bodReadOnly.Visible = False
        Else 'uneditable
            bodMain.Visible = False
            bodReadOnly.Visible = True
            Dim l As List(Of Pair(Of Control)) = GetPairs()
            LocalHelper.CopyValues(l)
        End If
    End Sub

    Protected Sub ddlUserType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlUserType.SelectedIndexChanged
        'Select Case ddlUserType.SelectedItem.Text.ToLower
        '    Case "agency"
        '        trCommRec.Visible = True
        '        trAgency.Visible = True
        '        trCompany.Visible = True
        '        LoadUserCompanies()
        '    Case "auditor"
        '        'ddlCommRec.SelectedIndex = 0
        '        trCommRec.Visible = False
        '        trAgency.Visible = False
        '        trCompany.Visible = False
        '    Case Else
        '        trCommRec.Visible = True
        '        trAgency.Visible = False
        '        trCompany.Visible = False
        'End Select

        chkManager.Enabled = False
        chkManager.Checked = False

        PopulateUserGroups()
    End Sub

    Protected Sub ddlUserGroup_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlUserGroup.SelectedIndexChanged
        If ddlUserGroup.SelectedIndex > 0 Then
            chkManager.Enabled = True
        Else
            chkManager.Enabled = False
        End If

        'If ddlUserType.SelectedItem.Text.ToLower = "agency" Or ddlUserGroup.SelectedItem.Text.ToLower = "state bar personnel" Then
        '    trCompany.Visible = True
        'Else
        '    trCompany.Visible = False
        'End If

        chkManager.Checked = False
    End Sub

    Private Sub SaveUserExtension()

        Dim params(2) As SqlParameter
        params(0) = New SqlParameter("@username", SqlDbType.VarChar)
        params(0).Value = lblUserName.Text
        params(1) = New SqlParameter("@ext", SqlDbType.VarChar)
        params(1).Value = Val(txtExtension.Text.Trim)
        params(2) = New SqlParameter("@fullname", SqlDbType.VarChar)
        params(2).Value = String.Format("{0} {1}", txtFirstName.Text.Trim, txtLastName.Text.Trim)
        SqlHelper.ExecuteNonQuery("stp_UpdateUserExtension", CommandType.StoredProcedure, params)

    End Sub

    Protected Sub DeleteUserExtension()
        SqlHelper.ExecuteNonQuery(String.Format("delete from tbluserext Where Login='{0}'", lblUserName.Text), CommandType.Text)
    End Sub

    Private Function GetUserExtension() As String
        Dim ext As String = "0"
        Try
            If lblUserName.Text.Trim.Length > 0 Then
                ext = SqlHelper.ExecuteScalar(String.Format("Select ext from tbluserext Where Login='{0}'", lblUserName.Text), CommandType.Text).ToString()
            End If
        Catch ex As Exception
            ext = "0"
        End Try
        Return ext
    End Function

    Private Sub LoadExtension()
        Dim ext As String = GetUserExtension()
        If ext = "0" Then
            txtExtension.Text = ""
        Else
            txtExtension.Text = ext
        End If
    End Sub
End Class
