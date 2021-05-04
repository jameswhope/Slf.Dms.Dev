Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class admin_settings_negotiation_commcolor
    Inherits PermissionPage

#Region "Variables"

    Private Action As String
    Private RuleCommColorID As Integer
    Private qs As QueryStringCollection

    Public UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            RuleCommColorID = DataHelper.Nz_int(qs("ccid"), 0)
            Action = DataHelper.Nz_string(qs("a"))

            If Not IsPostBack Then

                'setup entity type ddl
                ddlEntityType.Items.Clear()
                ddlEntityType.Items.Add("Relation Type")
                ddlEntityType.Items.Add("User Type")
                ddlEntityType.Items.Add("User Group")
                ddlEntityType.Items.Add("User")
              
                HandleAction()
            End If

            SetRollups()
            SetAttributes()

        End If

    End Sub
    Private Sub LoadDDLs(ByVal EntityType As String, ByVal EntityID As Integer)

        Using cmd As IDbCommand = ConnectionFactory.Create.CreateCommand
            Using cmd.Connection
                ddlRelationTypes.Items.Clear()
                cmd.CommandText = "select name,relationtypeid from tblrelationtype where not relationtypeid in (select entityid from tblrulecommcolor where entitytype='Relation Type')"
                If EntityType = "Relation Type" Then
                    cmd.CommandText += " or relationtypeid=" & EntityID
                End If
                cmd.CommandText += " order by name"
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader
                    While rd.Read
                        ddlRelationTypes.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "name"), DatabaseHelper.Peel_int(rd, "relationtypeid")))
                    End While
                End Using
            End Using
        End Using

        Using cmd As IDbCommand = ConnectionFactory.Create.CreateCommand
            Using cmd.Connection
                ddlUsers.Items.Clear()
                cmd.CommandText = "select name,usergroupid from tblusergroup where not usergroupid in (select entityid from tblrulecommcolor where entitytype='User Group')"
                If EntityType = "User Group" Then
                    cmd.CommandText += " or usergroupid=" & EntityID
                End If
                cmd.CommandText += " order by name"
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader
                    While rd.Read
                        ddlUserGroups.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "name"), DatabaseHelper.Peel_int(rd, "usergroupid")))
                    End While
                End Using
            End Using
        End Using

        Using cmd As IDbCommand = ConnectionFactory.Create.CreateCommand
            Using cmd.Connection
                ddlUsers.Items.Clear()
                cmd.CommandText = "select name,usertypeid from tblusertype where not usertypeid in (select entityid from tblrulecommcolor where entitytype='User Type')"
                If EntityType = "User Type" Then
                    cmd.CommandText += " or usertypeid=" & EntityID
                End If
                cmd.CommandText += " order by name"
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader
                    While rd.Read
                        ddlUserTypes.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "name"), DatabaseHelper.Peel_int(rd, "usertypeid")))
                    End While
                End Using
            End Using
        End Using

        Using cmd As IDbCommand = ConnectionFactory.Create.CreateCommand
            Using cmd.Connection
                ddlUsers.Items.Clear()
                cmd.CommandText = "select firstname + ' ' + lastname as fullname, userid from tbluser where not userid in (select entityid from tblrulecommcolor where entitytype='User')"
                If EntityType = "User" Then
                    cmd.CommandText += " or userid=" & EntityID
                End If
                cmd.CommandText += " order by lastname"
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader
                    While rd.Read
                        ddlUsers.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "fullname"), DatabaseHelper.Peel_int(rd, "userid")))
                    End While
                End Using
            End Using
        End Using
    End Sub
    Private Sub SetAttributes()
        txtTextColor.Attributes("onkeyup") = "FixColor(this,'" & dvTextColor.ClientID & "');"
        txtColor.Attributes("onkeyup") = "FixColor(this,'" & dvColor.ClientID & "');"
    End Sub
    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = Master.CommonTasks

        'add applicant tasks
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this rule</a>")

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this rule</a>")

    End Sub
    Private Sub HandleAction()

        Select Case Action
            Case "a"    'add
                ltrNew.Visible = True
                LoadDDLs("", -1)
            Case Else   'edit
                LoadRecord()
        End Select

    End Sub
    Private Sub LoadRecord()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblRuleCommColor WHERE RuleCommColorId = @RuleCommColorId"

                DatabaseHelper.AddParameter(cmd, "RuleCommColorId", RuleCommColorID)

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)
                    If rd.Read() Then
                        

                        ListHelper.SetSelected(ddlEntityType, DatabaseHelper.Peel_string(rd, "EntityType"))
                        Dim EntityId As Integer = DatabaseHelper.Peel_int(rd, "EntityID")

                        LoadDDLs(ddlEntityType.SelectedValue, EntityId)

                        Select Case ddlEntityType.SelectedValue
                            Case "Relation Type"
                                ListHelper.SetSelected(ddlRelationTypes, EntityId)
                            Case "User Type"
                                ListHelper.SetSelected(ddlUserTypes, EntityId)
                                ddlRelationTypes.Style("display") = "none"
                                ddlUserTypes.Style("display") = "block"
                            Case "User Group"
                                ListHelper.SetSelected(ddlUserGroups, EntityId)
                                ddlRelationTypes.Style("display") = "none"
                                ddlUserGroups.Style("display") = "block"
                            Case "User"
                                ListHelper.SetSelected(ddlUsers, EntityId)
                                ddlRelationTypes.Style("display") = "none"
                                ddlUsers.Style("display") = "block"
                        End Select

                        txtTextColor.Value = DatabaseHelper.Peel_string(rd, "TextColor")
                        dvTextColor.Style("background-color") = txtTextColor.Value
                        If txtTextColor.Value.Length = 0 Then dvTextColor.InnerHtml = "default color"

                        txtColor.Value = DatabaseHelper.Peel_string(rd, "Color")
                        dvColor.Style("background-color") = txtColor.Value
                        If txtColor.Value.Length = 0 Then dvColor.InnerHtml = "default color"
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
        Response.Redirect("~/admin/settings/rules/commcolors.aspx")
    End Sub
    Private Function InsertOrUpdate() As Integer

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                DatabaseHelper.AddParameter(cmd, "EntityType", ddlEntityType.SelectedValue)
                Dim EntityID As Integer
                Select Case ddlEntityType.SelectedValue
                    Case "Relation Type"
                        EntityID = ddlRelationTypes.SelectedValue
                    Case "User Type"
                        EntityID = ddlUserTypes.SelectedValue
                    Case "User Group"
                        EntityID = ddlUserGroups.SelectedValue
                    Case "User"
                        EntityID = ddlUsers.SelectedValue
                End Select
                DatabaseHelper.AddParameter(cmd, "EntityID", EntityID)
                DatabaseHelper.AddParameter(cmd, "Color", DataHelper.Zn(txtColor.Value))
                DatabaseHelper.AddParameter(cmd, "TextColor", DataHelper.Zn(txtTextColor.Value))

                DatabaseHelper.AddParameter(cmd, "LastModified", Now)
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

                If Action = "a" Then 'add

                    DatabaseHelper.AddParameter(cmd, "Created", Now)
                    DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

                    DatabaseHelper.BuildInsertCommandText(cmd, "tblRuleCommColor", "RuleCommColorID", SqlDbType.Int)

                Else 'edit
                    DatabaseHelper.BuildUpdateCommandText(cmd, "tblRuleCommColor", "RuleCommColorID= " & RuleCommColorID)
                End If

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            End Using

            If Action = "a" Then 'add
                RuleCommColorID = DataHelper.Nz_int(cmd.Parameters("@RuleCommColorID").Value)
            End If

        End Using

        Return RuleCommColorID

    End Function
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        InsertOrUpdate()
        Close()

    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        'delete check to print
        DataHelper.Delete("tblRuleCommColor", "RuleCommColorID = " & RuleCommColorID)

        'drop back to ach
        Close()

    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub
End Class