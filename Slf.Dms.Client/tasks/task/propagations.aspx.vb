Option Explicit On
Imports Slf.Dms.Records
Imports Drg.Util.DataHelpers

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports System.Data

Partial Class tasks_task_propagations
    Inherits System.Web.UI.Page

#Region "Variables"
    Public pTitle As String
    Public TaskID As Integer
    Private qs As QueryStringCollection
    Public DataClientID As Integer = 0
    Private UserID As Integer
    Private UserGroupId As Integer
    Private MatterTypeId As Integer
    Public MatterId As Integer
    Public AssignedToGroup As Integer = 0
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserGroupId = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupId", "UserId=" & UserID))
        qs = LoadQueryString()

        pTitle = DataHelper.Nz_string(qs("t"))

        If Not qs Is Nothing Then

            TaskID = DataHelper.Nz_int(qs("id"), 0)
            MatterId = DataHelper.Nz_int(qs("mid"), 0)
            DataClientID = DataHelper.Nz_int(qs("cid"), 0)
            If TaskID > 0 Then
                MatterId = DataHelper.Nz_int(DataHelper.FieldLookup("tblMatterTask", _
                    "MatterId", "TaskID =" & TaskID))
                MatterTypeId = DataHelper.Nz_int(DataHelper.FieldLookup("tblMatter", _
                 "MatterTypeId", "MatterID =" & MatterId))

            Else
                MatterTypeId = DataHelper.Nz_int(qs("type"), 0)
            End If


            AssignedToGroup = DataHelper.Nz_int(qs("gid"), 0)
            If Not IsPostBack Then

                LoadTaskTypes(cboTaskType, 0)
                LoadTimeZones(cboDueZone, 6)
                'If pTitle = "Add Matter Task " Or pTitle = "Edit Matter Task " Then
                LoadAssignedTo(cboAssignedTo, 0)
                'End If

                'LoadPropagations()

            End If

        End If

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

    Private Sub LoadTaskTypes(ByRef cboTaskType As DropDownList, ByVal SelectedTaskTypeID As Integer)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        'cmd.CommandText = "SELECT * FROM tblTaskType Where TaskTypeCategoryID in (0,9)"
        cmd.CommandText = "stp_GetValidTaskTypeList"
        cmd.CommandType = CommandType.StoredProcedure
        DatabaseHelper.AddParameter(cmd, "UserId", UserID)
        DatabaseHelper.AddParameter(cmd, "UsergroupId", UserGroupId)
        DatabaseHelper.AddParameter(cmd, "MatterTypeId", MatterTypeId)
        cboTaskType.Items.Clear()

        cboTaskType.Items.Add(New ListItem(" -- Ad Hoc -- ", 0))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboTaskType.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "TaskTypeID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        ListHelper.SetSelected(cboTaskType, SelectedTaskTypeID)

    End Sub

    Private Sub LoadTimeZones(ByRef cboDueZone As DropDownList, ByVal SelectedDueZoneID As Integer)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT TimeZoneID, Name FROM tblTimeZone Order By Name Asc"

        cboDueZone.Items.Clear()

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboDueZone.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "TimeZoneID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        ListHelper.SetSelected(cboDueZone, SelectedDueZoneID)

    End Sub

    Private Sub LoadAssignedTo(ByRef cboAssignedTo As DropDownList, ByVal SelectedAssignedToId As Integer)

        ' UserID = DataHelper.Nz_int(Page.User.Identity.Name)


        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        ' UserTypeId=7 is Litigation
        '  cmd.CommandText = "SELECT TOP 10 * FROM dbo.tblUser Where UserTypeId =7 and Locked=0 order by lastName"

        ' 1.14.10 allow only valid users (not locked temp or system)
        'cmd.CommandText = " select * from tblUser u2 where u2.UserTypeId=(Select UserTypeId from tblUser where UserId ='" + UserID.ToString() _
        '                  + "') and Locked=0 and Temporary=0 and System=0 and u2.UserGroupId = (Select UserGroupId from tblUser where UserId ='" + UserID.ToString() + "')" + "order by FirstName"

        '2.09.10 For assigning individual and group users
        cmd.CommandText = "stp_GetTaskAsignedToList"
        cmd.CommandType = CommandType.StoredProcedure

        '03.08.2010 Put all the parameters
        DatabaseHelper.AddParameter(cmd, "RowNumber", DBNull.Value)
        DatabaseHelper.AddParameter(cmd, "UserGroupId", UserGroupId)
        DatabaseHelper.AddParameter(cmd, "UserId", DBNull.Value)
        DatabaseHelper.AddParameter(cmd, "MatterTypeId", MatterTypeId)

        cboAssignedTo.Items.Clear()

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboAssignedTo.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "DisplayName"), DatabaseHelper.Peel_int(rd, "RowNumber")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        ListHelper.SetSelected(cboAssignedTo, SelectedAssignedToId)

    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        If Not TaskID = 0 Then
            SaveFollowUpTask()
            If MatterId > 0 Then
                ClientScript.RegisterStartupScript(Me.GetType, "onload", "ReturnStatus(3);", True)
            Else
                ClientScript.RegisterStartupScript(Me.GetType, "onload", "ReturnStatus(2);", True)
            End If
        ElseIf Not MatterId = 0 Then
            UpdateMatterTask()
            ClientScript.RegisterStartupScript(Me.GetType, "onload", "ReturnStatus(1);", True)
        End If
    End Sub

    Public Sub SaveFollowUpTask()
        Dim Propagations() As String
        Propagations = txtPropagations.Value.Split("|")
        For Each Propagation As String In Propagations
            If Propagation.Length > 0 Then
                Dim Parts() As String = Propagation.Split(",")
                Dim AssignedToGroupId As Integer
                Dim AssignedTo As Integer
                Dim AssignedToResolver As Integer = DataHelper.Nz_int(Parts(0))
                Dim DueTypeID As Integer = DataHelper.Nz_int(Parts(1))
                Dim DueDate As String = Parts(2)
                Dim Due As String = Parts(3)
                Dim TaskTypeID As Integer = DataHelper.Nz_int(Parts(4))
                Dim Description As String = Parts(5).Replace("[cm]", ",")
                'Dim TaskId As Integer = Parts(6)
                Dim ParentTaskID As Integer = TaskID

                '' Get the ClientId from the ParentTask
                DataClientID = DataHelper.Nz_int(DataHelper.FieldLookup("tblClientTask", "ClientId", "TaskID =" & TaskID))

                Dim dtDueDate As DateTime
                dtDueDate = Convert.ToDateTime(DueDate + " 0:0")

                'Dim DueHr As Integer = Parts(7)
                'Dim DueMin As Integer = Parts(8)
                'Dim DueZone As Integer = Parts(9)
                Dim strTimeBlock As String = Parts(12).ToString()
                Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                    Using cmd.Connection
                        cmd.Connection.Open()
                        cmd.CommandText = "stp_GetTaskAsignedToList"
                        cmd.CommandType = CommandType.StoredProcedure
                        DatabaseHelper.AddParameter(cmd, "RowNumber", AssignedToResolver)
                        DatabaseHelper.AddParameter(cmd, "UserGroupId", UserGroupId)
                        DatabaseHelper.AddParameter(cmd, "UserId", DBNull.Value)
                        DatabaseHelper.AddParameter(cmd, "MatterTypeId", MatterTypeId)
                        Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                            While rd.Read()
                                AssignedTo = rd("UserId")
                                AssignedToGroupId = rd("UserGroupId")
                            End While
                        End Using
                    End Using
                End Using

                'build description
                If Not TaskTypeID = 0 Then 'not ad hoc, predefined by tasktype
                    Dim tskType As String = DataHelper.FieldLookup("tblTaskType", "DefaultDescription", "TaskTypeID = " & TaskTypeID)
                    If Not Description.Contains(tskType) AndAlso tskType.ToString <> "" Then
                        Description = String.Format("{0}.  {1}", Description, tskType)
                    End If
                End If
                Description = Description + " " + "-" + strTimeBlock



                Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                    Using cmd.Connection

                        cmd.CommandText = "stp_InsertMatterTask"
                        cmd.CommandType = CommandType.StoredProcedure
                        DatabaseHelper.AddParameter(cmd, "ClientId", DataClientID)
                        DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                        DatabaseHelper.AddParameter(cmd, "Description", Description)
                        DatabaseHelper.AddParameter(cmd, "AssignedTo", AssignedTo)
                        DatabaseHelper.AddParameter(cmd, "DueDate", dtDueDate)
                        DatabaseHelper.AddParameter(cmd, "TaskTypeId", TaskTypeID)
                        DatabaseHelper.AddParameter(cmd, "UserId", UserID)
                        DatabaseHelper.AddParameter(cmd, "DueZoneDisplay", 0)
                        DatabaseHelper.AddParameter(cmd, "AssignedToGroupId", AssignedToGroupId)
                        DatabaseHelper.AddParameter(cmd, "ParentTaskID", TaskID)

                        cmd.Connection.Open()
                        Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                        End Using
                    End Using
                End Using

                'TaskHelper.InsertTask(TaskTypeID, Description, AssignedTo, DueDate, UserID, TaskID)
                'ClientHelper.InsertClientTask(ClientID, TaskID, UserID)

                ''Code to close the parent task and redirec to matter instance if matterid>0 else redirect to home page


                Dim cmdTaskClose As IDbCommand = ConnectionFactory.Create().CreateCommand()
                cmdTaskClose.Connection.Open()
                cmdTaskClose.CommandText = "UPDATE tbltask SET TaskResolutionID=1, Resolved=getdate(), ResolvedBy=@UserId WHERE taskId=@TaskID"
                cmdTaskClose.CommandType = CommandType.Text
                DatabaseHelper.AddParameter(cmdTaskClose, "TaskID", TaskID)
                DatabaseHelper.AddParameter(cmdTaskClose, "UserId", UserID)
                cmdTaskClose.ExecuteNonQuery()

                'harassment task
                Select Case TaskTypeID
                    Case 44, 54, 61, 62, 60, 85, 86
                        'process harassment
                        HarassmentHelper.ProcessHarassment(DataClientID, MatterId, TaskTypeID, UserID)

                    Case Else
                        'do nothing
                End Select

            End If
        Next
    End Sub

    Private Sub UpdateMatterTask()

        Dim Propagations() As String

        Propagations = txtPropagations.Value.Split("|")

        For Each Propagation As String In Propagations

            If Propagation.Length > 0 Then

                Dim Parts() As String = Propagation.Split(",")
                Dim AssignedToGroupId As Integer
                Dim AssignedTo As Integer
                Dim AssignedToResolver As Integer = DataHelper.Nz_int(Parts(0))
                Dim DueTypeID As Integer = DataHelper.Nz_int(Parts(1))
                Dim DueDate As String = Parts(2)
                Dim Due As String = Parts(3)
                Dim TaskTypeID As Integer = DataHelper.Nz_int(Parts(4))
                Dim Description As String = Parts(5).Replace("[cm]", ",")
                Dim TaskId As Integer = Parts(6)
                'Dim DueHr As Integer = Parts(7)
                'Dim DueMin As Integer = Parts(8)
                'Dim DueZone As Integer = Parts(9)
                Dim strTimeBlock As String = Parts(12).ToString()
                Dim strReason As String = Parts(14).ToString()

                'build Due date with time
                Dim dtDueDate As DateTime
                dtDueDate = Convert.ToDateTime(DueDate + " 0:0")

                'build description
                If Not TaskTypeID = 0 Then 'not ad hoc, predefined by tasktype
                    Dim tskType As String = DataHelper.FieldLookup("tblTaskType", "DefaultDescription", "TaskTypeID = " & TaskTypeID)
                    If Not Description.Contains(tskType) AndAlso tskType.ToString <> "" Then
                        Description = String.Format("{0}.  {1}", Description, tskType)
                    End If
                End If

                Description = Description + " " + "-" + strTimeBlock

                Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                    Using cmd.Connection
                        cmd.Connection.Open()
                        cmd.CommandText = "stp_GetTaskAsignedToList"
                        cmd.CommandType = CommandType.StoredProcedure
                        DatabaseHelper.AddParameter(cmd, "RowNumber", AssignedToResolver)
                        DatabaseHelper.AddParameter(cmd, "UserGroupId", UserGroupId)
                        DatabaseHelper.AddParameter(cmd, "UserId", DBNull.Value)
                        DatabaseHelper.AddParameter(cmd, "MatterTypeId", MatterTypeId)
                        Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                            While rd.Read()
                                AssignedTo = rd("UserId")
                                AssignedToGroupId = rd("UserGroupId")
                            End While
                        End Using
                    End Using
                End Using

                If TaskId > 0 Then
                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                        Using cmd.Connection

                            cmd.CommandText = "stp_UpdateMatterTask"
                            cmd.CommandType = CommandType.StoredProcedure
                            DatabaseHelper.AddParameter(cmd, "ClientId", DataClientID)
                            DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                            DatabaseHelper.AddParameter(cmd, "Description", Description)
                            DatabaseHelper.AddParameter(cmd, "AssignedTo", AssignedTo)
                            DatabaseHelper.AddParameter(cmd, "DueDate", dtDueDate)
                            DatabaseHelper.AddParameter(cmd, "TaskTypeId", TaskTypeID)
                            DatabaseHelper.AddParameter(cmd, "UserId", UserID)
                            DatabaseHelper.AddParameter(cmd, "TaskId", TaskId)
                            DatabaseHelper.AddParameter(cmd, "DueZoneDisplay", 0)
                            DatabaseHelper.AddParameter(cmd, "AssignedToGroupId", AssignedToGroupId)
                            cmd.Connection.Open()
                            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                            End Using
                        End Using
                    End Using

                    If strReason.Trim().Length > 0 Then
                        'Save the reason to tblTaskNotes table 

                        Dim NoteID As Integer = NoteHelper.InsertNote(strReason, UserID, DataClientID)

                        'link this note to current task
                        TaskHelper.InsertTaskNote(TaskId, NoteID, UserID)

                    End If

                Else
                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                        Using cmd.Connection

                            cmd.CommandText = "stp_InsertMatterTask"
                            cmd.CommandType = CommandType.StoredProcedure
                            DatabaseHelper.AddParameter(cmd, "ClientId", DataClientID)
                            DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                            DatabaseHelper.AddParameter(cmd, "Description", Description)
                            DatabaseHelper.AddParameter(cmd, "AssignedTo", AssignedTo)
                            DatabaseHelper.AddParameter(cmd, "DueDate", dtDueDate)
                            DatabaseHelper.AddParameter(cmd, "TaskTypeId", TaskTypeID)
                            DatabaseHelper.AddParameter(cmd, "UserId", UserID)
                            DatabaseHelper.AddParameter(cmd, "DueZoneDisplay", 0)
                            DatabaseHelper.AddParameter(cmd, "AssignedToGroupId", AssignedToGroupId)
                            cmd.Connection.Open()
                            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                            End Using
                        End Using
                    End Using
                End If

                Select Case TaskTypeID
                    Case 44, 54, 61, 62, 60, 85, 86
                        'process harassment
                        HarassmentHelper.ProcessHarassment(DataClientID, MatterId, TaskTypeID, UserID)

                    Case Else
                        'do nothing
                End Select
            End If


        Next

    End Sub

End Class