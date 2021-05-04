Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Imports System.Xml

Partial Class admin_users_default
    Inherits PermissionPage

#Region "Variables"
    Private UserID As Integer
    Private Const PageSize As Integer = 12
#End Region
#Region "Query"
    Private Function GetActivitiesList() As List(Of UserActivity)
        ' Returns the list used to populate the
        ' StandardGrid.List for the Activities Grid

        Dim Activities As New List(Of UserActivity)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetUserActivity")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "ReturnTop", 14)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Activities.Add(New UserActivity(DatabaseHelper.Peel_int(rd, "UserID"), _
                            DatabaseHelper.Peel_string(rd, "UserName"), _
                            DatabaseHelper.Peel_string(rd, "Type"), _
                            DatabaseHelper.Peel_int(rd, "TypeID"), _
                            DatabaseHelper.Peel_string(rd, "Activity"), _
                            DatabaseHelper.Peel_date(rd, "When"), _
                            ResolveUrl("~/")))
                    End While
                End Using
            End Using
        End Using
        Return Activities
    End Function
    Protected Sub grdActivities_OnFillTable(ByRef tbl As System.Data.DataTable) Handles grdActivities.OnFillTable
        'Create a list of rows, and assign it to the grid
        Dim Activities As List(Of UserActivity) = GetActivitiesList()
        Dim t As New DataTable
        t.Columns.Add("ClickableURL", GetType(String))
        t.Columns.Add("IconSrcURL", GetType(String))
        t.Columns.Add("UserName", GetType(String))
        t.Columns.Add("Activity", GetType(String))
        t.Columns.Add("Date", GetType(DateTime))

        For Each a As UserActivity In Activities
            Dim r As DataRow = t.NewRow
            r("ClickableURL") = a.Link
            r("IconSrcURL") = a.Icon
            r("UserName") = a.UserName
            r("Date") = a.When
            r("Activity") = a.Activity
            t.Rows.Add(r)
        Next a

        tbl = t
    End Sub
    Private Sub RequeryActivities(ByVal Setup As Boolean)
        ' The Activities Requery sets the grid list manually
        ' based on the custom data from GetActivitiesList(),
        ' utilizing StandardGridRow's ClickableURL and
        ' IconSrcURL properties for custom functionality.

        Dim grd As StandardGrid2 = grdActivities

        If Setup Then 'Call from Page_Load
        Else 'Call from Page_PreRender

            Dim SearchCount As Integer = grd.Table.Rows.Count

            pnlActivities.Visible = SearchCount > 0
            pnlNoActivities.Visible = SearchCount = 0

        End If

    End Sub
    Private Sub RequeryUsers(ByVal Setup As Boolean)
        ' The Users Grid uses StandardGrid's sorting abilities.
        ' There must be a @SortBy parameter in the stored proc
        ' used, and it is given in the form of @SortBy="FullyQualifiedDataField ASC".
        ' If the ORDER BY clause should be optional in the stored proc,
        ' the following logic should be used in the stored proc:
        '   
        '   if not @orderby=''
        '       set @orderby = ' ORDER BY ' + @orderby

        Dim grd As StandardGrid2 = grdUsers
        Dim strWhere As String

        If Setup Then 'Call from Page_Load

            'Set the DataCommand
            grd.DataCommand = ConnectionFactory.CreateCommand("stp_GetUsers")
            strWhere = GetUsersSQLWhere()
            If Not chkShowLocked_b.Checked Then
                strWhere &= " and tbluser.locked = 0"
            End If
            DatabaseHelper.AddParameter(grd.DataCommand, "where", strWhere)
        Else 'Call from Page_PreRender

            Dim SearchCount As Integer = grd.Table.Rows.Count
            If SearchCount > 0 Then
                tsUsers.TabPages(0).Caption = "<font style=""font-weight:bold;"">Users</font>&nbsp;&nbsp;<font style=""color:blue;"">(" & SearchCount & ")</font>"
            Else
                tsUsers.TabPages(0).Caption = "Users"
            End If

            pnlUsers.Visible = SearchCount > 0
            pnlNoUsers.Visible = SearchCount = 0

        End If
    End Sub
    Private Sub RequeryUserTypes(ByVal Setup As Boolean)
        ' The User Types Grid is limited, not allowing Add or
        ' Delete functionality.

        Dim grd As StandardGrid2 = grdUserTypes

        If Setup Then 'Call from Page_Load

            'Setup the DataCommand
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandText = "SELECT *, (SELECT COUNT(*) FROM tblUser WHERE UserTypeId=tblUserType.UserTypeId) as Users, (SELECT COUNT(*) FROM tblUser WHERE UserTypeId=tblUserType.UserTypeId and not locked=1) as ActiveUsers FROM tblUserType"
            grd.DataCommand = cmd

        Else 'Call from Page_PreRender
            'grd.Reset(False)
            Dim SearchCount As Integer = grd.Table.Rows.Count
            If SearchCount > 0 Then
                tsUsers.TabPages(2).Caption = "<font style=""font-weight:bold;"">User&nbsp;Types</font>&nbsp;&nbsp;<font style=""color:blue;"">(" & SearchCount & ")</font>"
            Else
                tsUsers.TabPages(2).Caption = "User&nbsp;Types"
            End If

            pnlUserTypes.Visible = SearchCount > 0
            pnlNoUserTypes.Visible = SearchCount = 0
        End If
    End Sub
    Private Sub RequeryGroups(ByVal Setup As Boolean)
        Dim grd As StandardGrid2 = grdGroups

        If Setup Then 'Call from Page_Load

            'Setup the DataCommand
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandText = "SELECT *, (SELECT COUNT(*) FROM tblUser WHERE UserGroupId=tblUserGroup.UserGroupId) as Users, (SELECT COUNT(*) FROM tblUser WHERE UserGroupId=tblUserGroup.UserGroupId and not locked=1) as ActiveUsers FROM tblUserGroup"
            grd.DataCommand = cmd

        Else 'Call from Page_PreRender
            grd.Reset(False)
            Dim SearchCount As Integer = grd.Table.Rows.Count
            If SearchCount > 0 Then
                tsUsers.TabPages(1).Caption = "<font style=""font-weight:bold;"">Groups</font>&nbsp;&nbsp;<font style=""color:blue;"">(" & SearchCount & ")</font>"
            Else
                tsUsers.TabPages(1).Caption = "Groups"
            End If

            pnlGroups.Visible = SearchCount > 0
            pnlNoGroups.Visible = SearchCount = 0

        End If
    End Sub
    Private Sub Save()

        'blow away current stuff first
        Clear()

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkShowLocked_b.ID, "value", _
            chkShowLocked_b.Checked)

    End Sub
    Private Sub Clear()

        'delete all settings for this user on this query
        QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "'")

    End Sub
    Private Function GetControls() As Dictionary(Of String, Control)
        Dim c As New Dictionary(Of String, Control)
        c.Add(chkShowLocked_b.ID, chkShowLocked_b)
        Return c
    End Function
#End Region
#Region "Event"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        tsUsers.TabPages.Clear()

        tsUsers.TabPages.Add(New Slf.Dms.Controls.TabPage("Users", dvSearch0.ClientID))
        tsUsers.TabPages.Add(New Slf.Dms.Controls.TabPage("Groups", dvSearch1.ClientID))
        tsUsers.TabPages.Add(New Slf.Dms.Controls.TabPage("User&nbsp;Types", dvSearch2.ClientID))

        If Not IsPostBack Then
            LocalHelper.LoadValues(GetControls(), Me)
        End If

        ' Requery is run in Page_Load to setup the grid,
        ' and again in Page_PreRender with Setup = False
        ' to actually evaluate the results and record them
        ' on the tab. This is necessary because the 
        ' MultiDelete  event fires before Page_PreRender 
        ' and after Page_Load.
        RequeryUsers(True)
        RequeryGroups(True)
        RequeryUserTypes(True)

    End Sub
    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

    End Sub
    Protected Sub Page_PreLoad(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreLoad
        RequeryActivities(True)

    End Sub
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        'set the proper pane on, others off
        Dim Panes As New List(Of HtmlGenericControl)

        Panes.Add(dvSearch0)
        Panes.Add(dvSearch1)
        Panes.Add(dvSearch2)
        For Each Pane As HtmlGenericControl In Panes

            If Pane.ID.Substring(Pane.ID.Length - 1, 1) = tsUsers.SelectedIndex Then
                Pane.Style("display") = "inline"
            Else
                Pane.Style("display") = "none"
            End If

        Next

        ' Requery is run in Page_Load to setup the grid,
        ' and again in Page_PreRender with Setup = False
        ' to actually evaluate the results and record them
        ' on the tab. This is necessary because the 
        ' MultiDelete  event fires before Page_PreRender 
        ' and after Page_Load.
        RequeryActivities(False)
        RequeryUsers(False)
        RequeryGroups(False)
        RequeryUserTypes(False)
    End Sub
    Protected Sub grdUsers_MultiDelete(ByVal IDs As System.Collections.Generic.List(Of Integer)) Handles grdUsers.MultiDelete
        UserHelper.Delete(IDs.ToArray())
    End Sub
    Protected Sub grdGroups_MultiDelete(ByVal IDs As System.Collections.Generic.List(Of Integer)) Handles grdGroups.MultiDelete
        For Each i As Integer In IDs
            DataHelper.Delete("tblUserGroup", "UserGroupId=" & i)
        Next
    End Sub
#End Region

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(grdActivities, c, "Admin-Users-Activities")
        AddControl(phActivities, c, "Admin-Users-Activities")

        AddControl(grdUsers, c, "Users-User Single Record")
        AddControl(pnlUsers, c, "Users-User Single Record")
    End Sub

    Protected Sub chkShowLocked_b_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkShowLocked_b.CheckedChanged
        Save()

    End Sub

    Private Function GetUsersSQLWhere() As String
        Dim Values() As String = StringHelper.SplitQuoted(txtSearch.Text, " ", """").ToArray(GetType(String))
        Dim strWhere As String
        Dim Section As String = String.Empty
        Dim Sections As New List(Of String)

        For Each Value As String In Values
            If Value.ToLower = "and" Then
                'add section to sections
                If Section.Length > 0 Then
                    Sections.Add("(" & Section & ")")
                End If

                'reset section
                Section = String.Empty
            Else
                If Section.Length > 0 Then
                    Section += " OR "
                End If

                Section += "tblUser.UserName LIKE '%" & Value.Replace("'", "''") & "%' " _
                    & "OR tblUser.FirstName LIKE '%" & Value.Replace("'", "''") & "%' " _
                    & "OR tblUser.LastName LIKE '%" & Value.Replace("'", "''") & "%' " _
                    & "OR tblUser.EmailAddress LIKE '%" & Value.Replace("'", "''") & "%'"
            End If
        Next

        'add section to sections
        If Section.Length > 0 Then
            Sections.Add("(" & Section & ")")
        End If

        If Sections.Count > 0 Then
            strWhere = String.Join(" AND ", Sections.ToArray())
        Else
            strWhere = "1=1"
        End If

        Return strWhere
    End Function
End Class