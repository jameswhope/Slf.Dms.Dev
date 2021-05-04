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

Partial Class admin_settings_singlemattertype
    Inherits System.Web.UI.Page

#Region "Variables"
    Private UserID As Integer
    Private MatterTypeID As Integer

    Public Action As String
    Public DocIDs As String
    Public DocNames As String
#End Region
    Dim strAssociations As String = String.Empty
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Action = Request.QueryString("a")

        If Action = "e" Then
            MatterTypeID = DataHelper.Nz_int(Request.QueryString("id"), 0)
        End If

        SetDisplay()

        If Not IsPostBack Then
            LoadFolders()
            LoadAssociations()
            LoadMatterTypes()
            LoadMatterTypeNames()
            LoadMatterGroups()

            If Action = "e" Then
                LoadDocument()
            End If
        End If
    End Sub

    Private Sub SetDisplay()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Cancel();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Matter Type</a>")

        If Action = "a" Then
            lblTitle.Text = "Add Matter Type"
        Else
            lblTitle.Text = "Edit Matter Type"
        End If


        'If Not Action = "a" Then
        '    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Delete();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this Document</a>")
        'End If
    End Sub

    Private Sub LoadDocument()
        Using cmd As New SqlCommand("SELECT dt.MatterTypeID, dt.MatterTypeCode, dt.MatterTypeShortDescr, dt.IsActive, dt.Created, uc.FirstName + ' ' + uc.LastName as CreatedBy, " & _
        "dt.LastModified, ul.FirstName + ' ' + ul.LastName as LastModifiedBy, dt.MatterGroupId FROM tblMatterType as dt left join tblUser as uc on " & _
        "uc.UserID = dt.CreatedBy left join tblUser as ul on ul.UserID = dt.LastModifiedBy WHERE dt.MatterTypeID = " & MatterTypeID, _
        ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        lblID.Text = MatterTypeID
                        txtTypeID.Text = reader("MatterTypeCode")
                        txtName.Text = reader("MatterTypeShortDescr")
                        chkActive.Checked = DataHelper.Nz_bool(reader("IsActive"))
                        lblCreated.Text = DateTime.Parse(reader("Created")).ToString("g")
                        lblCreatedBy.Text = reader("CreatedBy")
                        lblLastModified.Text = DateTime.Parse(reader("LastModified")).ToString("g")
                        lblLastModifiedBy.Text = reader("LastModifiedBy")
                        ddlMatterGroup.SelectedIndex = ddlMatterGroup.Items.IndexOf(ddlMatterGroup.Items.FindByValue(DatabaseHelper.Peel_int(reader, "MatterGroupId")))
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadMatterGroups()
        ddlMatterGroup.Items.Clear()
        ddlMatterGroup.Items.Add(New ListItem("Select Group", "0"))
        Using cmd As New SqlCommand("SELECT MatterGroupId, MatterGroup FROM tblMatterGroup", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlMatterGroup.Items.Add(New ListItem(reader("MatterGroup"), reader("MatterGroupId")))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadFolders()
        Using cmd As New SqlCommand("SELECT DocFolderID, Name FROM tblDocFolder", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlDocFolder.Items.Add(New ListItem(reader("Name"), reader("DocFolderID")))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadMatterTypes()
        DocIDs = ""

        Using cmd As New SqlCommand("SELECT DISTINCT MatterTypeCode FROM tblMatterType" & IIf(Action = "e", " WHERE not MatterTypeID = " & _
        MatterTypeID, ""), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        DocIDs += "," & reader("MatterTypeCode")
                    End While
                End Using
            End Using
        End Using

        DocIDs = DocIDs.Remove(0, 1).Replace("'", "\'")
    End Sub

    Private Sub LoadMatterTypeNames()
        DocNames = ""

        Using cmd As New SqlCommand("SELECT DISTINCT MatterTypeID, MatterTypeCode FROM tblMatterType", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        DocNames += "," & reader("MatterTypeCode") & "|" & reader("MatterTypeID")
                    End While
                End Using
            End Using
        End Using

        DocNames = DocNames.Remove(0, 1).Replace("'", "\'")
    End Sub

    Private Sub LoadAssociations()
        'Using cmd As New SqlCommand("SELECT tt.TaskTypeID, tt.Name, " & _
        '"(CASE WHEN xref.Checked > 0 THEN 'checked=""checked""' ELSE '' END) as Checked FROM tblTaskType as tt left outer join " & _
        '"(SELECT TaskTypeID, count(*) as Checked FROM tblMatterTypeTaskXRef WHERE MatterTypeID = " & MatterTypeID & _
        '" GROUP BY TaskTypeID) as xref on xref.TaskTypeID = tt.TaskTypeID ORDER BY tt.Name", ConnectionFactory.Create())
        Using cmd As New SqlCommand("SELECT * from tblTaskTypecategory ", ConnectionFactory.Create())
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
        Response.Redirect("~/admin/settings/mattertypes.aspx")
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Using cmd As New SqlCommand("", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                If Action = "e" Then
                    cmd.CommandText = "UPDATE tblMatterType SET MatterTypeCode = '" & txtTypeID.Text & "', MatterTypeShortDescr = '" & txtName.Text.Replace("'", "''") & "', IsActive = '" & chkActive.Checked & "', LastModified = getdate(), LastModifiedBy = " & UserID & ", MatterGroupId=" & ddlMatterGroup.SelectedValue & " WHERE MatterTypeID = " & MatterTypeID

                    cmd.ExecuteNonQuery()
                Else
                    cmd.CommandText = "INSERT INTO tblMatterType VALUES ('" & txtTypeID.Text & "', '" & txtName.Text.Replace("'", "''") & "', 1, getdate(), " & UserID & ", getdate(), " & UserID & ", " & ddlMatterGroup.SelectedValue & ") SELECT scope_identity()"

                    MatterTypeID = cmd.ExecuteScalar()
                End If

                Dim item As RepeaterItem
                For Each item In rptAssociations.Items
                    Dim rpt As Repeater = CType(item.FindControl("rptTaskType"), Repeater)
                    Dim citem As RepeaterItem
                    For Each citem In rpt.Items
                        Dim taskTypeId As Int32 = Convert.ToInt32(CType(citem.FindControl("hdnTaskTypeId"), HtmlInputHidden).Value)
                        If CType(citem.FindControl("chkTaskType"), HtmlInputCheckBox).Checked Then
                            cmd.CommandText = "select COUNT(*) from  tblMatterTypeTaskXRef WHERE TaskTypeID=" & taskTypeId & " and mattertypeid= " & MatterTypeID
                            Dim ircount As Int32 = Convert.ToInt32(cmd.ExecuteScalar())
                            If ircount = 0 Then
                                'insert 
                                If CType(citem.FindControl("chkTaskTypeAuto"), HtmlInputCheckBox).Checked Then
                                    cmd.CommandText = "INSERT  into tblMatterTypeTaskXRef values(" & MatterTypeID & "," & taskTypeId & ",1)"
                                    cmd.ExecuteNonQuery()
                                Else
                                    cmd.CommandText = "INSERT  into tblMatterTypeTaskXRef values(" & MatterTypeID & "," & taskTypeId & ",0)"
                                    cmd.ExecuteNonQuery()
                                End If
                            Else
                                'update
                                If CType(citem.FindControl("chkTaskTypeAuto"), HtmlInputCheckBox).Checked Then
                                    cmd.CommandText = "update tblMatterTypeTaskXRef set isauto=1  WHERE  TaskTypeID=" & taskTypeId & " and mattertypeid= " & MatterTypeID
                                    cmd.ExecuteNonQuery()
                                Else
                                    cmd.CommandText = "update tblMatterTypeTaskXRef set isauto=0 WHERE  TaskTypeID=" & taskTypeId & " and mattertypeid= " & MatterTypeID
                                    cmd.ExecuteNonQuery()
                                End If
                            End If
                        Else
                            'delete
                            cmd.CommandText = "DELETE tblMatterTypeTaskXRef WHERE TaskTypeID=" & taskTypeId & " and mattertypeid= " & MatterTypeID
                            cmd.ExecuteNonQuery()
                        End If
                    Next

                Next

                'If hdnAssociations.Value.Trim().Length > 0 Then
                '    cmd.CommandText = "INSERT INTO tblMatterTypeTaskXRef SELECT  " & MatterTypeID & ",srt.TaskTypeID  FROM tblTaskType as srt left join (SELECT TaskTypeID, MatterTypeID, count(*) as Num FROM tblMatterTypeTaskXRef GROUP BY TaskTypeID, MatterTypeID) as rel on rel.TaskTypeID = srt.TaskTypeID and rel.MatterTypeID = " & MatterTypeID & " WHERE rel.Num is null and srt.TaskTypeID in (" & hdnAssociations.Value & ")"

                '    cmd.ExecuteNonQuery()

                '    cmd.CommandText = "DELETE tblMatterTypeTaskXRef WHERE TaskTypeID in (SELECT rel.TaskTypeID FROM tblTaskType as rel inner join tblMatterTypeTaskXRef as srt on srt.TaskTypeID = rel.TaskTypeID WHERE srt.TaskTypeID not in (" & hdnAssociations.Value & ") and srt.MatterTypeID = " & MatterTypeID & ")"

                '    cmd.ExecuteNonQuery()
                'Else
                '    cmd.CommandText = "DELETE tblMatterTypeTaskXRef WHERE MatterTypeID = " & MatterTypeID

                '    cmd.ExecuteNonQuery()
                'End If
            End Using
        End Using

        Close()
    End Sub

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        Close()
    End Sub

    Protected Sub rptAssociations_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptAssociations.ItemDataBound
        If e.Item.ItemType = ListItemType.AlternatingItem Or e.Item.ItemType = ListItemType.Item Then
            Dim strTaskCategoryID = DataBinder.Eval(e.Item.DataItem, "TaskTypeCategoryID")
            Dim rptTaskType As Repeater = CType(e.Item.FindControl("rptTaskType"), Repeater)
            Using cmd As New SqlCommand("SELECT tt.TaskTypeCategoryID,tt.TaskTypeID, tt.Name, isnull((select case when isauto is null then 'false' else isauto end from tblMatterTypeTaskXRef where  TaskTypeID=tt.TaskTypeID and MatterTypeID=" & MatterTypeID & ") ,'false') isauto, " & _
            "(CASE WHEN xref.Checked > 0 THEN 'true' ELSE 'false' END) as Checked FROM tblTaskType as tt left outer join " & _
            "(SELECT TaskTypeID, count(*) as Checked FROM tblMatterTypeTaskXRef WHERE MatterTypeID = " & MatterTypeID & _
            " GROUP BY TaskTypeID) as xref on xref.TaskTypeID = tt.TaskTypeID where tt.TaskTypeCategoryID=" & strTaskCategoryID & " ORDER BY tt.Name", ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()

                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        rptTaskType.DataSource = reader
                        rptTaskType.DataBind()
                    End Using
                End Using
            End Using

        End If

        'If e.Item.ItemType = ListItemType.AlternatingItem Or e.Item.ItemType = ListItemType.Item Then
        '    strAssociations = strAssociations & DataBinder.Eval(e.Item.DataItem, "TaskTypeID") & ","
        'ElseIf e.Item.ItemType = ListItemType.Footer Then
        '    hdnInitialAssociations.Value = strAssociations
        'End If
    End Sub
End Class