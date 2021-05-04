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

Partial Class admin_settings_singletasktype
    Inherits System.Web.UI.Page

#Region "Variables"
    Private UserID As Integer
    Private TaskTypeID As Integer

    Public Action As String
    Public TaskTypeIDs As String
    Public TaskTypes As String
#End Region
    Dim strAssociations As String = String.Empty
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        Action = Request.QueryString("a")

        If Action = "e" Then
            TaskTypeID = DataHelper.Nz_int(Request.QueryString("id"), 0)
        End If

        SetDisplay()

        If Not IsPostBack Then
            LoadCategories()
            LoadTaskTypes()
            LoadTaskNames()
            If Action = "e" Then
                LoadTaskTypeDetails()
            End If
        End If
    End Sub

    Private Sub SetDisplay()
        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Cancel();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save Task Type</a>")

        If Action = "e" Then
            lblTitle.Text = "Edit Task Type"
        Else
            lblTitle.Text = "Add Task Type"
        End If


        'If Not Action = "a" Then
        '    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Delete();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this Document</a>")
        'End If
    End Sub

    Private Sub LoadTaskTypes()
        TaskTypeIDs = ""

        Using cmd As New SqlCommand("SELECT DISTINCT Name FROM tblTaskType" & IIf(Action = "e", " WHERE not TaskTypeID = " & _
        TaskTypeID, ""), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        TaskTypeIDs += "," & reader("Name")
                    End While
                End Using
            End Using
        End Using

        TaskTypeIDs = TaskTypeIDs.Remove(0, 1).Replace("'", "\'")
    End Sub

    Private Sub LoadTaskNames()
        TaskTypes = ""

        Using cmd As New SqlCommand("SELECT DISTINCT TaskTypeID, Name FROM tblTaskType", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        TaskTypes += "," & reader("Name") & "|" & reader("TaskTypeID")
                    End While
                End Using
            End Using
        End Using

        TaskTypes = TaskTypes.Remove(0, 1).Replace("'", "\'")
    End Sub


    Private Sub LoadTaskTypeDetails()
        Using cmd As New SqlCommand("SELECT dt.TaskTypeID, dt.TaskTypeCategoryID, dt.Name, dt.DefaultDescription, dt.Created, uc.FirstName + ' ' + uc.LastName as CreatedBy, " & _
        "dt.LastModified, ul.FirstName + ' ' + ul.LastName as LastModifiedBy, dt.TaskInstruction FROM tblTaskType as dt left join tblUser as uc on " & _
        "uc.UserID = dt.CreatedBy left join tblUser as ul on ul.UserID = dt.LastModifiedBy WHERE dt.TaskTypeID = " & TaskTypeID, _
        ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        lblID.Text = TaskTypeID
                        txtTaskType.Text = reader("Name")
                        txtDescription.Text = reader("DefaultDescription")
                        lblCreated.Text = DateTime.Parse(reader("Created")).ToString("g")
                        lblCreatedBy.Text = reader("CreatedBy")
                        lblLastModified.Text = DateTime.Parse(reader("LastModified")).ToString("g")
                        lblLastModifiedBy.Text = reader("LastModifiedBy")
                        ddlCategory.Items.FindByValue(Integer.Parse(reader("TaskTypeCategoryID"))).Selected = True
                        txtTaskInstruction.Text = reader("TaskInstruction")
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadCategories()
        ddlCategory.Items.Clear()
        ddlCategory.Items.Add(New ListItem("--Select Category--", "-1"))
        Using cmd As New SqlCommand("SELECT TaskTypeCategoryID, Name FROM tblTaskTypeCategory", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlCategory.Items.Add(New ListItem(reader("Name"), reader("TaskTypeCategoryID")))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub

    Private Sub Close()
        Response.Redirect("~/admin/settings/tasktypes.aspx")
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Using cmd As New SqlCommand("", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                If Action = "e" Then
                    cmd.CommandText = "UPDATE tblTaskType SET TaskTypeCategoryID=" & ddlCategory.SelectedValue & ", Name = '" & txtTaskType.Text.Replace("'", "''") & "', DefaultDescription = '" & txtDescription.Text.Replace("'", "''") & "', TaskInstruction = '" & txtTaskInstruction.Text & "', LastModified = getdate(), LastModifiedBy = " & UserID & " WHERE TaskTypeID = " & TaskTypeID

                    cmd.ExecuteNonQuery()
                Else
                    cmd.CommandText = "INSERT INTO tblTaskType VALUES (" & ddlCategory.SelectedValue & ", '" & txtTaskType.Text.Replace("'", "''") & "',  '" & txtDescription.Text.Replace("'", "''") & "', getdate(), " & UserID & ", getdate(), " & UserID & ",'" & txtTaskInstruction.Text & "') SELECT scope_identity()"

                    TaskTypeID = cmd.ExecuteScalar()
                End If

            End Using
        End Using

        Close()
    End Sub

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        Close()
    End Sub

End Class