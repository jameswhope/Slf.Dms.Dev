Option Explicit On

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Data.SqlClient
Imports System.Reflection
Imports System.Collections.Generic

Partial Class admin_settings_singlemattergroup
    Inherits System.Web.UI.Page

#Region "Variables"
    Private UserID As Integer
    Private MatterGroupID As Integer

    Public Action As String
    Public DocIDs As String
    Public DocNames As String
#End Region
    Dim strAssociations As String = String.Empty
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Action = Request.QueryString("a")

        If Action = "e" Then
            MatterGroupID = DataHelper.Nz_int(Request.QueryString("id"), 0)
        End If

        SetDisplay()

        If Not IsPostBack Then
            LoadAssociations()
            LoadMatterTypes()
            LoadMatterTypeNames()
            If Action = "e" Then
                LoadDocument()
            End If
        End If
    End Sub

    Private Sub SetDisplay()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Cancel();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Matter Group</a>")

        If Action = "a" Then
            lblTitle.Text = "Add Matter Group"
        Else
            lblTitle.Text = "Edit Matter Group"
        End If


        'If Not Action = "a" Then
        '    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Delete();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this Document</a>")
        'End If
    End Sub

    Private Sub LoadDocument()
        Using cmd As New SqlCommand("SELECT dt.MatterGroupID, dt.MatterGroup, dt.MatterGroupDescr, dt.Created, uc.FirstName + ' ' + uc.LastName as CreatedBy, " & _
        "dt.LastModified, ul.FirstName + ' ' + ul.LastName as LastModifiedBy, dt.MatterGroupId FROM tblMatterGroup as dt left join tblUser as uc on " & _
        "uc.UserID = dt.CreatedBy left join tblUser as ul on ul.UserID = dt.LastModifiedBy WHERE dt.MatterGroupID = " & MatterGroupID, _
        ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        lblID.Text = MatterGroupID
                        txtTypeID.Text = reader("MatterGroup")
                        txtName.Text = reader("MatterGroupDescr")
                        lblCreated.Text = DateTime.Parse(reader("Created")).ToString("g")
                        lblCreatedBy.Text = reader("CreatedBy")
                        lblLastModified.Text = DateTime.Parse(reader("LastModified")).ToString("g")
                        lblLastModifiedBy.Text = reader("LastModifiedBy")
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadMatterTypes()
        DocIDs = ""

        Using cmd As New SqlCommand("SELECT DISTINCT MatterGroup FROM tblMatterGroup" & IIf(Action = "e", " WHERE not MatterGroupID = " & _
        MatterGroupID, ""), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        DocIDs += "," & reader("MatterGroup")
                    End While
                End Using
            End Using
        End Using

        DocIDs = DocIDs.Remove(0, 1).Replace("'", "\'")
    End Sub

    Private Sub LoadMatterTypeNames()
        DocNames = ""

        Using cmd As New SqlCommand("SELECT DISTINCT MatterGroupID, MatterGroup FROM tblMatterGroup", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        DocNames += "," & reader("MatterGroup") & "|" & reader("MatterGroupID")
                    End While
                End Using
            End Using
        End Using

        DocNames = DocNames.Remove(0, 1).Replace("'", "\'")
    End Sub

    Private Sub LoadAssociations()
        Using cmd As New SqlCommand("SELECT tt.UserGroupID, tt.Name, " & _
        "(CASE WHEN xref.Checked > 0 THEN 'checked=""checked""' ELSE '' END) as Checked FROM tblUserGroup as tt left outer join " & _
        "(SELECT UserGroupID, count(*) as Checked FROM tblMatterGroupUserGroupXRef WHERE MatterGroupID = " & MatterGroupID & _
        " GROUP BY UserGroupID) as xref on xref.UserGroupID = tt.UserGroupID ORDER BY tt.Name", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    rptAssociations.DataSource = reader
                    rptAssociations.DataBind()
                End Using
            End Using
        End Using
    End Sub

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub

    Private Sub Close()
        Response.Redirect("~/admin/settings/mattergroups.aspx")
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Using cmd As New SqlCommand("", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                If Action = "e" Then
                    cmd.CommandText = "UPDATE tblMatterGroup SET MatterGroup = '" & txtTypeID.Text & "', MatterGroupDescr = '" & txtName.Text.Replace("'", "''") & "', LastModified = getdate(), LastModifiedBy = " & UserID & " WHERE MatterGroupID = " & MatterGroupID

                    cmd.ExecuteNonQuery()
                Else
                    cmd.CommandText = "INSERT INTO tblMatterGroup VALUES ('" & txtTypeID.Text & "', '" & txtName.Text.Replace("'", "''") & "', getdate(), " & UserID & ", getdate(), " & UserID & ") SELECT scope_identity()"

                    MatterGroupID = cmd.ExecuteScalar()
                End If

                If hdnAssociations.Value.Trim().Length > 0 Then
                    cmd.CommandText = "INSERT INTO tblMatterGroupUserGroupXRef select " & MatterGroupID & " , u.usergroupid  from tblusergroup as u left join" & _
                                    "(select mattergroupid, usergroupid, count(*) as num from tblMatterGroupUserGroupXRef GROUP BY usergroupid,mattergroupid ) as rel on " & _
                                    "  rel.usergroupid = u.usergroupid And rel.mattergroupid = " & MatterGroupID & "where rel.num is null and u.usergroupid in ( " & hdnAssociations.Value & " )"
                    cmd.ExecuteNonQuery()

                    cmd.CommandText = "DELETE tblMatterGroupUserGroupXRef WHERE usergroupid in  (SELECT rel.usergroupid FROM tblusergroup as rel inner join tblMatterGroupUserGroupXRef as srt on srt.usergroupid = rel.usergroupid " & _
                     " WHERE srt.usergroupid not in (" & hdnAssociations.Value & ") and srt.mattergroupid = " & MatterGroupID & ")"
                    cmd.ExecuteNonQuery()
                Else
                    cmd.CommandText = "DELETE tblMatterGroupUserGroupXRef WHERE MatterGroupID = " & MatterGroupID

                    cmd.ExecuteNonQuery()
                End If

            End Using
        End Using

        Close()
    End Sub

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        Close()
    End Sub

End Class