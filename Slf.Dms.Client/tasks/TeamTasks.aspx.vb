Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Client.Agent

Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic
Imports LocalHelper
Imports Slf.Dms.Controls
Imports System.IO
Partial Class tasks_TeamTasks
    Inherits System.Web.UI.Page

#Region "Variables"
    Public UserID As Integer
    Public UserTypeId As Integer
    Public UserGroupId As Integer
    'Added to check user is a manager
    Public UserIsManager As Boolean
    Private SortField As String
    Private SortOrder As String
    Private HeadersTasks As Dictionary(Of String, HtmlTableCell)

    Protected ReadOnly Property Identity() As String
        Get
            Return Me.Page.GetType.Name & "_" & Me.ID
        End Get
    End Property

    Protected Property Setting(ByVal s As String) As Object
        Get
            Return Session(Identity & "_" & s)
        End Get
        Set(ByVal value As Object)
            Session(Identity & "_" & s) = value
        End Set
    End Property

    Protected ReadOnly Property Setting(ByVal s As String, ByVal d As Object) As Object
        Get
            Dim o As Object = Setting(s)
            If o Is Nothing Then
                Return d
            Else
                Return o
            End If
        End Get
    End Property

#End Region

    Public Structure GridTask
        Dim TaskID As Integer
        Dim TaskType As String
        Dim ClientID As Integer
        Dim Client As String
        Dim TaskDescription As String
        Dim CreatedBy As String
        Dim AssignedTo As String
        Dim AssignedToGroupName As String

        Dim intAssignedToId As Integer
        Dim intAssignedToGroupId As Integer
        Dim Language As String
        Dim AccountNumber As String
        Dim StartDate As DateTime
        Dim DueDate As DateTime
        Dim ResolvedDate As Nullable(Of DateTime)
        Dim TaskResolutionId As Integer
        'Dim Duration As String
        Dim Value As String
        Dim Color As String
        Dim TextColor As String
        Dim BodyColor As String
        Dim CIAccountNumber As String

        ReadOnly Property AssignedToId() As Integer
            Get
                Return intAssignedToId
            End Get
        End Property
        ReadOnly Property AssignedToGroupId() As Integer
            Get
                Return intAssignedToGroupId
            End Get
        End Property

        ReadOnly Property Status() As String
            Get

                If ResolvedDate.HasValue Then
                    If TaskResolutionId = 1 Then
                        'Return "RESOLVED"
                        Return "<font style=""color:rgb(0,129,0);"">RESOLVED</font>"
                    Else 'If TaskResolutionID = 5 Then
                        'Return "IN PROGRESS"
                        Return "<font style=""color:rgb(0,0,255);"">IN PROGRESS</font>"
                    End If
                Else
                    If DueDate < Now Then
                        'Return "PAST DUE"
                        Return "<font style=""color:red;"">PAST DUE</font>"
                    Else
                        'Return "OPEN"
                        Return "<font style=""color:rgb(0,0,159);"">OPEN</font>"
                    End If

                End If

            End Get
        End Property

        ReadOnly Property Duration() As String
            Get

                If ResolvedDate.HasValue Then
                    Dim Dur As TimeSpan
                    Dur = ResolvedDate - StartDate

                    'Return Math.Round(Dur.TotalHours, 2).ToString()
                    Return Dur.Days & "d:" & Dur.Hours & "h:" & Dur.Minutes & "m:" & Dur.Seconds & "s"

                Else
                    Return " "

                End If

            End Get
        End Property


    End Structure

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        UserGroupId = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupId", "UserId = " & UserID))
        'Added to check user is a manager - Manager field in tblUser
        UserIsManager = Boolean.Parse(DataHelper.FieldLookup("tblUser", "Manager", "UserId = " & UserID))

        If UserIsManager Then
            pnlAssignTask.Visible = True
        Else
            pnlAssignTask.Visible = False
        End If

    End Sub

    Private Function GetFullyQualifiedNameForTasks(ByVal s As String) As String
        Select Case s
            Case "ThPrefLang"
                Return "Language"
            Case "ThTaskDesc"
                Return "Description"
            Case "ThDueDate"
                Return "Due"
            Case "ThAssignedGroupName"
                Return "AssignedtoGroup"
            Case "ThCreatedBy"
                Return "CreatedByName"
            Case "ThClientAccNum"
                Return "ClientAccountNumber"
            Case "ThClientName"
                Return "ClientName"
            Case "ThAccNum"
                Return "CIAccountNumber"
            Case "ThStatus"
                Return "seq"
            Case "tdAssignHeader"
                Return "assignedtoname"
        End Select
        Return "CreatedBy"
    End Function

    Public Sub SetSortImageTasks()
        HeadersTasks(SortField).Controls.Add(GetSortImage(SortOrder))
    End Sub

    Private Function GetSortImage(ByVal SortOrder As String) As HtmlImage
        Dim img As HtmlImage = New HtmlImage()
        img.Src = ResolveUrl("~/images/sort-" & SortOrder & ".png")
        img.Align = "absmiddle"
        img.Border = 0
        img.Style("margin-left") = "5px"
        Return img
    End Function

    Private Sub LoadHeadersTasks()
        HeadersTasks = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        AddHeader(HeadersTasks, ThPrefLang)
        AddHeader(HeadersTasks, ThTaskDesc)
        AddHeader(HeadersTasks, ThCreatedBy)
        AddHeader(HeadersTasks, ThAssignedGroupName)
        AddHeader(HeadersTasks, ThClientAccNum)
        AddHeader(HeadersTasks, ThDueDate)
        AddHeader(HeadersTasks, ThClientName)
        AddHeader(HeadersTasks, ThAccNum)
        AddHeader(HeadersTasks, ThStatus)
        AddHeader(HeadersTasks, tdAssignHeader)

    End Sub

    Private Sub AddHeader(ByVal c As System.Collections.Generic.Dictionary(Of String, HtmlTableCell), ByVal td As HtmlTableCell)
        c.Add(td.ID, td)
    End Sub

    Private Sub LoadTeamTasks()
        SortField = Setting("SortField", "ThDueDate")
        SortOrder = Setting("SortOrder", "DESC")

        Dim Tasks As New List(Of GridTask)
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTasks")

        'For Team Tasks
        'If chkTeamOpenOnly.Checked Then
        '    DatabaseHelper.AddParameter(cmd, "returntop", "200")
        '    DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblassignedto.UserGroupId = " & UserGroupId & " AND Resolved IS NULL AND Due > '" & Now.ToString("MM/dd/yyyy hh:mm tt") & "'")
        'Else
        '    DatabaseHelper.AddParameter(cmd, "returntop", "200")
        '    DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblassignedto.UserGroupId = " & UserGroupId & " AND Resolved IS NULL")
        'End If

        If chkTeamOpenOnly.Checked Then
            DatabaseHelper.AddParameter(cmd, "returntop", "200")
            If chkDueOnly.Checked Then
                DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblassignedtogroup.UserGroupId = " & UserGroupId & " AND ((Resolved IS NULL AND Due > '" & Now.ToString("MM/dd/yyyy hh:mm tt") & "') OR (Resolved is Not Null AND tblTask.TaskResolutionID<>1) ) and convert(varchar,tbltask.due,101)= convert(varchar,getdate(),101)")

            Else
                DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblassignedtogroup.UserGroupId = " & UserGroupId & " AND ((Resolved IS NULL AND Due > '" & Now.ToString("MM/dd/yyyy hh:mm tt") & "') OR (Resolved is Not Null AND tblTask.TaskResolutionID<>1) ) ")
            End If
        Else
            DatabaseHelper.AddParameter(cmd, "returntop", "200")
            If chkDueOnly.Checked Then
                DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblassignedtogroup.UserGroupId = " & UserGroupId & " AND ((Resolved IS NULL)  OR (Resolved is Not Null AND tblTask.TaskResolutionID<>1) ) and convert(varchar,tbltask.due,101)= convert(varchar,getdate(),101) ")

            Else
                DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblassignedtogroup.UserGroupId = " & UserGroupId & " AND ((Resolved IS NULL)  OR (Resolved is Not Null AND tblTask.TaskResolutionID<>1) ) ")
            End If
        End If



        DatabaseHelper.AddParameter(cmd, "OrderBy", "ORDER BY " + GetFullyQualifiedNameForTasks(SortField) + " " + SortOrder)
        ' DatabaseHelper.AddParameter(cmd, "OrderBy", "ORDER BY seq")

        'Dim Tasks As New List(Of Task)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Dim tsk As New GridTask

                tsk.TaskID = DatabaseHelper.Peel_int(rd, "TaskID")
                tsk.AssignedTo = DatabaseHelper.Peel_string(rd, "AssignedToName")
                tsk.TaskType = DatabaseHelper.Peel_string(rd, "TaskTypeName")
                tsk.TaskDescription = DatabaseHelper.Peel_string(rd, "Description").Replace("-Not Available", "")
                tsk.StartDate = DatabaseHelper.Peel_date(rd, "Created")
                tsk.DueDate = DatabaseHelper.Peel_date(rd, "Due")
                tsk.CreatedBy = DatabaseHelper.Peel_string(rd, "CreatedByName")
                tsk.ResolvedDate = DatabaseHelper.Peel_ndate(rd, "Resolved")
                tsk.TaskResolutionId = DatabaseHelper.Peel_int(rd, "TaskResolutionID")
                tsk.ClientID = DatabaseHelper.Peel_int(rd, "ClientID")
                tsk.Client = DatabaseHelper.Peel_string(rd, "ClientName")
                tsk.AssignedToGroupName = DatabaseHelper.Peel_string(rd, "AssignedtoGroup")
                tsk.intAssignedToId = DatabaseHelper.Peel_int(rd, "AssignedTo")
                tsk.intAssignedToGroupId = DatabaseHelper.Peel_int(rd, "AssignedToGroupId")
                tsk.Language = DatabaseHelper.Peel_string(rd, "Language")
                tsk.AccountNumber = DatabaseHelper.Peel_string(rd, "ClientAccountNumber")
                tsk.CIAccountNumber = DatabaseHelper.Peel_string(rd, "CIAccountNumber")
                Tasks.Add(tsk)

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If Tasks.Count > 0 Then
            rpTeamTasks.DataSource = Tasks
            rpTeamTasks.DataBind()
        End If

        lnkUpdateTaskUsers.Visible = Tasks.Count > 0
        rpTeamTasks.Visible = Tasks.Count > 0
        pnlNoTeamTasks.Visible = Tasks.Count = 0

        hdnTeamTasksCount.Value = Tasks.Count

        LoadHeadersTasks()
        SetSortImageTasks()

    End Sub

    Protected Sub lnkResort_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkResort.Click
        If txtSortField.Value = Setting("SortField") Then
            'toggle sort order
            If Setting("SortOrder") = "ASC" Then
                SortOrder = "DESC"
            Else
                SortOrder = "ASC"
            End If
        Else
            SortField = txtSortField.Value
            SortOrder = "ASC"
        End If
        SortField = txtSortField.Value

        Setting("SortField") = SortField
        Setting("SortOrder") = SortOrder
    End Sub


    Protected Sub rpTeamTasks_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpTeamTasks.ItemDataBound
        If e.Item.ItemType = ListItemType.AlternatingItem Or e.Item.ItemType = ListItemType.Item Then
            Dim tsk As New GridTask
            Dim ddlGroupUsers As DropDownList = CType(e.Item.FindControl("ddlGroupUsers"), DropDownList)
            Dim UserGroupId As String = DataBinder.Eval(e.Item.DataItem, "AssignedToGroupId").ToString()
            'Convert.ToString(DataBinder.Eval(e.Item.DataItem, "AssignedToGroupId"))
            Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetUsers")
            DatabaseHelper.AddParameter(cmd, "where", "tbluser.usergroupid=" & UserGroupId & " and tbluser.Locked=0 and tbluser.Temporary=0 and tbluser.System=0 ")

            Dim UserAssignId As String = DataBinder.Eval(e.Item.DataItem, "AssignedToId").ToString()
            'Convert.ToString(DataBinder.Eval(e.Item.DataItem, "AssignedTo"))

            Dim rd As IDataReader = Nothing
            Try

                cmd.Connection.Open()
                rd = cmd.ExecuteReader()

                While rd.Read()
                    ddlGroupUsers.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "FirstName") & " " & DatabaseHelper.Peel_string(rd, "LastName"), DatabaseHelper.Peel_int(rd, "UserId")))
                End While
                ddlGroupUsers.Items.Insert(0, New ListItem(" -- Select -- ", 0))
                ddlGroupUsers.SelectedIndex = ddlGroupUsers.Items.IndexOf(ddlGroupUsers.Items.FindByValue(UserAssignId))
            Finally
                DatabaseHelper.EnsureReaderClosed(rd)
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try

        End If
    End Sub

    Protected Sub lnkUpdateTaskUsers_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUpdateTaskUsers.Click
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        cmd.CommandText = "Update tbltask set AssignedTo=@AssignedTo where taskid=@taskid"
        cmd.Connection.Open()
        Try
            For Each item In rpTeamTasks.Items
                Dim ddlGroupUsers As DropDownList = CType(item.FindControl("ddlGroupUsers"), DropDownList)
                Dim AssignedUserId As Int32 = Convert.ToInt32(ddlGroupUsers.SelectedValue)
                Dim TaskId As Int32 = Convert.ToInt32(CType(item.FindControl("hdnTaskID"), HtmlInputHidden).Value.Trim())
                cmd.Parameters.Clear()
                DatabaseHelper.AddParameter(cmd, "taskid", TaskId)
                DatabaseHelper.AddParameter(cmd, "AssignedTo", AssignedUserId)
                cmd.ExecuteNonQuery()
            Next
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
        ' Response.Redirect("~/default.aspx")
    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        LoadTeamTasks()
    End Sub

    Protected Sub chkTeamOpenOnly_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkTeamOpenOnly.CheckedChanged

    End Sub

    Protected Sub chkDueOnly_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkDueOnly.CheckedChanged

    End Sub
End Class
