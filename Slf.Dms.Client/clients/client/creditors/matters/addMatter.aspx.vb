Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports SharedFunctions

Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_creditors_matters_addMatter
    Inherits PermissionPage

#Region "Variables"

    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Public PhoneCallID As Integer
    Public UserID As Integer
    Public UserGroupID As Integer
    Public AccountId As Integer
    Public MatterId As Integer
    Public CreditorInstanceId As Integer
    Public Type As String
    Public MatterTypeId As Integer
    Public MatterGroupId As Integer
    Public AssignedToGroup As Integer = 0
    Public ClientRegion As String

#End Region

    ReadOnly Property Control_txtPropagations() As WebControls.HiddenField
        Get
            Return txtPropagations
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserGroupID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupID", "UserId=" & UserID))
        qs = LoadQueryString()

        If Not qs Is Nothing Then
            ClientID = DataHelper.Nz_int(qs("id"), 0)
            AccountId = DataHelper.Nz_int(qs("aid"), 0)
            CreditorInstanceId = DataHelper.Nz_int(qs("ciid"), 0)
            Type = DataHelper.Nz_string(qs("type"))
            'MatterTypeId = DataHelper.Nz_string(qs("type"))
            'MatterGroupId = DataHelper.Nz_string(qs("group"))

            SetRollups()

            If Not IsPostBack Then

                ddlLocalCounsel.Attributes.Add("OnChange", "FillDetails();return false;")
                PopulateMatterTypes()
                LoadDocuments()
                SetAttributes()

                hdnTempAccountID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()
                hdnTempMatterID.Value = 0
                PopulateMatterStatusCode()
                PopulateMatterSubStatusCodes()
                PopulateValidLocalCounselforClient()

                LoadMatterNumber()
                'Added to display Related Tasks
                HandleAction()
                ResetPropagationsCounter()

                If CreditorInstanceId > 0 And hdnLatestCreditorId.Value <> CreditorInstanceId Then
                    txtCreditor.Visible = True
                    ddlCreditors.Visible = False

                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                        Using cmd.Connection
                            cmd.CommandText = "select cc.name+'-'+RIGHT(ci.accountnumber,4) as CreditorName from tblcreditorinstance ci left outer join tblcreditor cc on ci.creditorid=cc.creditorid where ci.CreditorInstanceId=@CreditorInstanceId"
                            DatabaseHelper.AddParameter(cmd, "CreditorInstanceId", CreditorInstanceId)
                            cmd.Connection.Open()
                            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                                While rd.Read()
                                    txtCreditor.Text = DatabaseHelper.Peel_string(rd, "CreditorName")
                                End While
                            End Using
                        End Using
                    End Using

                End If

            End If

        End If
    End Sub

    '2.11.2010 
    Private Sub PopulateAssignedToGroupList()
        Dim RegionUserGroupId As Integer = 0
        ddlAssignedToGroups.Items.Clear()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "stp_GetTaskAsignedToList"
                cmd.CommandType = CommandType.StoredProcedure
                'DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                DatabaseHelper.AddParameter(cmd, "UserGroupId", DBNull.Value)
                DatabaseHelper.AddParameter(cmd, "MatterTypeId", MatterTypeId)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()

                        If MatterTypeId = 1 Then
                            If DatabaseHelper.Peel_string(rd, "DisplayName").IndexOf(ClientRegion) >= 0 Then
                                RegionUserGroupId = DatabaseHelper.Peel_int(rd, "RowNumber")
                            End If
                        End If

                        ddlAssignedToGroups.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "DisplayName"), DatabaseHelper.Peel_int(rd, "RowNumber")))

                    End While

                    If RegionUserGroupId > 0 Then
                        ddlAssignedToGroups.SelectedIndex = ddlAssignedToGroups.Items.IndexOf(ddlAssignedToGroups.Items.FindByValue(RegionUserGroupId))
                        AssignedToGroup = ddlAssignedToGroups.SelectedValue
                    End If

                End Using
            End Using
        End Using

    End Sub

    Private Sub SetAttributes()
        '   txtOriginalAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"
        '    txtCurrentAmount.Attributes("onkeypress") = "AllowOnlyNumbers();"
        '    txtSetupFeePercentage.Attributes("onkeypress") = "AllowOnlyNumbers();"
    End Sub

    Private Sub PopulateMatterTypes()
        ddlMatterType.Items.Clear()
        ddlMatterType.Items.Add(New ListItem("Select Matter Type", "0"))

        Dim MatterId = DataHelper.FieldLookup("tblMatter", "MatterId", "MatterTypeId = 4 and MatterStatusId not in (2,4) and ClientId = " & ClientID)
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                'cmd.CommandText = "SELECT * FROM tblMatterType Where MatterGroupId=" & MatterGroupId & " and IsActive=1"
                cmd.CommandText = "stp_GetMatterTypes"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "UserGroupId", UserGroupID)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        If DatabaseHelper.Peel_int(rd, "MatterTypeId") <> 3 Then
                            If DatabaseHelper.Peel_int(rd, "MatterTypeId") <> 4 Or (DatabaseHelper.Peel_int(rd, "MatterTypeId") = 4 And String.IsNullOrEmpty(MatterId)) Then
                                ddlMatterType.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "MatterTypeCode"), DatabaseHelper.Peel_int(rd, "MatterTypeId")))
                            End If
                        End If
                    End While

                    If IsNothing(Request.QueryString("t")) Then
                        ddlMatterType.SelectedIndex = ddlMatterType.Items.IndexOf(ddlMatterType.Items.FindByText("Litigation"))
                    Else
                        If ddlMatterType.Items.Count > 1 Then
                            ddlMatterType.SelectedIndex = 1
                        End If
                    End If

                    MatterTypeId = ddlMatterType.SelectedValue

                    LoadMatterTypeChanges()

                End Using
            End Using
        End Using
    End Sub

    ''Added to populate MatterStatus Code
    Private Sub PopulateMatterStatusCode()
        ddlMatterStatusCode.Items.Clear()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblMatterStatus"
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        'ddlMatterStatusCode.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "MatterStatusCode"), DatabaseHelper.Peel_int(rd, "MatterStatusCodeId")))
                        ddlMatterStatusCode.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "MatterStatus"), DatabaseHelper.Peel_int(rd, "MatterStatusId")))
                    End While
                    ''Default MatterStatus is Pending 
                    ddlMatterStatusCode.SelectedIndex = ddlMatterStatusCode.Items.IndexOf(ddlMatterStatusCode.Items.FindByText("Open"))

                End Using
            End Using
        End Using
    End Sub

    ''Added to populate MattersubStatus Code
    Private Sub PopulateMatterSubStatusCodes()
        ddlMatterSubStatusCode.Items.Clear()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT ms.MatterSubStatus, ms.MatterSubStatusId FROM tblMatterSubStatus ms inner join tblMatterTypeSubStatus mt ON mt.MatterSubStatusId = ms.MatterSubStatusId and mt.MatterTypeId = @MatterTypeId Where MatterStatusId=@MatterStatusId order by [Order] desc"
                DatabaseHelper.AddParameter(cmd, "MatterStatusId", ddlMatterStatusCode.SelectedValue)
                DatabaseHelper.AddParameter(cmd, "MatterTypeId", ddlMatterType.SelectedValue)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        ddlMatterSubStatusCode.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "MatterSubStatus"), DatabaseHelper.Peel_int(rd, "MatterSubStatusId")))
                    End While
                    ''Default MatterStatus is Pending 
                    ddlMatterSubStatusCode.SelectedIndex = ddlMatterSubStatusCode.Items.IndexOf(ddlMatterSubStatusCode.Items.FindByText("Pending"))

                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadMatterNumber()
        'Adding code to pass null into creditor number
        Dim InsertedValue As Integer = 0

        If trCreditor.Style.Item("display") = "inline" AndAlso ddlCreditors.SelectedValue >= 0 Then
            InsertedValue = ddlCreditors.SelectedValue
        End If

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "stp_GenerateMatterNumber"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                DatabaseHelper.AddParameter(cmd, "AccountId", InsertedValue)
                'DatabaseHelper.AddParameter(cmd, "AccountId", ddlCreditors.SelectedValue)
                DatabaseHelper.AddParameter(cmd, "MatterTypeId", ddlMatterType.SelectedValue)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()

                        txtMatterNumber.Text = rd("MatterNumber")
                        txtAccountNumber.Text = rd("AccountNumber")
                        txtMatterDate.Text = rd("MatterDate")
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadTaskTypes(ByRef cboTaskType As DropDownList, ByVal SelectedTaskTypeID As Integer)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblTaskType Where TaskTypeCategoryID IN(0,9) ORDER BY [Name]"

        'cboTaskType().Items.Clear()
        cboTaskType.Items.Clear()

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

    Private Sub HandleAction()

        LoadTaskTypes(cboTaskType, 0)

    End Sub

    Private Sub PopulateValidCreditors()

        '2.10.2010 added load valid creditors - force user to select creditors if litigation matter is selected
        ddlCreditors.Items.Clear()
        ddlCreditors.Items.Add(New ListItem("--NONE--", "-1"))
        ddlCreditors.Items.Add(New ListItem("--TBD --", "0"))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                'cmd.CommandText = "get_ClientAccountOverviewList"
                cmd.CommandText = "get_ValidCreditorsList"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()

                        'ddlCreditors.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "CreditorName"), DatabaseHelper.Peel_int(rd, "AccountId")))
                        ddlCreditors.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "CreditorName"), DatabaseHelper.Peel_int(rd, "AccountId")))

                        If AccountId = DatabaseHelper.Peel_int(rd, "AccountId") Or CreditorInstanceId = DatabaseHelper.Peel_int(rd, "CreditorInstanceId") Then
                            ddlCreditors.SelectedIndex = ddlCreditors.Items.IndexOf(ddlCreditors.Items.FindByValue(DatabaseHelper.Peel_int(rd, "AccountId")))
                            hdnLatestCreditorId.Value = DatabaseHelper.Peel_int(rd, "CreditorInstanceId")
                        End If

                    End While

                End Using
            End Using
        End Using

    End Sub

    Private Sub PopulateValidLocalCounselforClient()
        ddlLocalCounsel.Items.Clear()
        ddlLocalCounsel.Items.Add(New ListItem("--NONE--", "-1"))
        ddlLocalCounsel.Items.Add(New ListItem("--TBD--", "0"))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                cmd.CommandText = "stp_GetLocalCounselListbyClient"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()

                        ddlLocalCounsel.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "LocalCounsel"), DatabaseHelper.Peel_int(rd, "AttorneyId").ToString() + "#" + DatabaseHelper.Peel_string(rd, "Details")))

                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub PopulateClassifications()
        ddlClassification.Items.Clear()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblClassifications"

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                    While rd.Read()
                        ddlClassification.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Classification"), DatabaseHelper.Peel_int(rd, "ClassificationID")))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        'add applicant tasks
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SaveConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save new Matter</a>")
        'newly added
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SaveAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save and close</a>")

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkAccounts.HRef = "~/clients/client/creditors/accounts/?id=" & ClientID

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:OpenScanning();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_remove.png") & """ align=""absmiddle""/>Scan Document</a>")
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
        If Not IsNothing(Request.QueryString("t")) Then
            Response.Redirect("~/clients/client/?id=" & ClientID)
        Else
            Response.Redirect("~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & AccountId & "&a=m")
        End If
        'If ddlMatterType.SelectedValue = 1 Then
        '    If AccountId > 0 Then
        '        Response.Redirect("~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & AccountId & "&a=m")
        '    Else
        '        Response.Redirect("~/clients/client/?id=" & ClientID)
        '    End If
        '    'Response.Redirect("~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & AccountId & "&a=m")
        'Else
        '    Response.Redirect("~/clients/client/?id=" & ClientID)
        'End If
    End Sub

    Private Function CreateAccount() As Integer

        'Dim AccountID As Integer = 0

        'Dim CurrentAmount As Single = Single.Parse(txtCurrentAmount.Value)
        'Dim SetupFeePercentage As Single = (Single.Parse(txtSetupFeePercentage.Value) / 100)

        'Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        '    Using cmd.Connection

        '        Dim AccountStatusID As Integer

        '        'set the status as "Insufficient Funds" from the beginning, if found
        '        AccountStatusID = StringHelper.ParseInt(DataHelper.FieldLookup("tblAccountStatus", "AccountStatusID", "Code = 'IF' AND Description = 'Insufficient Funds'"))

        '        If Not AccountStatusID = 0 Then
        '            DatabaseHelper.AddParameter(cmd, "AccountStatusID", AccountStatusID)
        '        End If

        '        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)
        '        DatabaseHelper.AddParameter(cmd, "OriginalAmount", Single.Parse(txtOriginalAmount.Value))
        '        DatabaseHelper.AddParameter(cmd, "CurrentAmount", CurrentAmount)
        '        DatabaseHelper.AddParameter(cmd, "SetupFeePercentage", DataHelper.FieldLookup("tblClient", "SetupFeePercentage", "ClientID = " + ClientID.ToString()))
        '        DatabaseHelper.AddParameter(cmd, "OriginalDueDate", DateTime.Parse(txtOriginalDueDate.Text))
        '        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        '        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)
        '        DatabaseHelper.AddParameter(cmd, "Created", Now)
        '        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

        '        DatabaseHelper.BuildInsertCommandText(cmd, "tblAccount", "AccountID", SqlDbType.Int)

        '        cmd.Connection.Open()
        '        cmd.ExecuteNonQuery()

        '        AccountID = DataHelper.Nz_int(cmd.Parameters("@AccountID").Value)

        '    End Using
        'End Using

        'Return AccountID

    End Function

    'Adding a new matter
    Private Function InsertOrUpdate() As Integer

        Dim AttorneyID As Integer = 0

        If ddlLocalCounsel.SelectedValue <> "0" And ddlLocalCounsel.SelectedValue <> "-1" Then
            AttorneyID = ddlLocalCounsel.SelectedValue.Split("#")(0)
        Else
            AttorneyID = ddlLocalCounsel.SelectedValue
        End If


        If ddlCreditors.SelectedValue > 0 Then
            If CreditorInstanceId = 0 Or CreditorInstanceId = hdnLatestCreditorId.Value Then

                CreditorInstanceId = hdnLatestCreditorId.Value

            End If
        Else
            CreditorInstanceId = ddlCreditors.SelectedValue
        End If

        Dim NewId As Integer

        If ddlMatterType.SelectedValue = 4 Then

            'NewId = PendingCancelHelper.PendingCancel(ClientID, UserID, 1)

            'Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            '    Using cmd.Connection

            '        DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
            '        DatabaseHelper.AddParameter(cmd, "ClientStatusId", 25)
            '        DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
            '        DatabaseHelper.AddParameter(cmd, "Reason", "Manually created")
            '        Dim CurrentRoadmapID As Integer = DataHelper.Nz_int(ClientHelper.GetRoadmap(ClientID, Now, "RoadmapID"))
            '        DatabaseHelper.AddParameter(cmd, "Created", Now)
            '        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            '        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)
            '        DatabaseHelper.BuildInsertCommandText(cmd, "tblRoadmap")
            '        cmd.Connection.Open()
            '        cmd.ExecuteNonQuery()
            '    End Using
            'End Using
        Else
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection

                    cmd.CommandText = "stp_InsertMatter"
                    cmd.CommandType = CommandType.StoredProcedure
                    DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                    DatabaseHelper.AddParameter(cmd, "AccountId", ddlCreditors.SelectedValue)
                    'DatabaseHelper.AddParameter(cmd, "MatterStatusCodeId", ddlMatterStatusCode.SelectedValue)
                    DatabaseHelper.AddParameter(cmd, "MatterStatusCodeId", ddlMatterSubStatusCode.SelectedValue)
                    DatabaseHelper.AddParameter(cmd, "MatterNumber", txtMatterNumber.Text)
                    DatabaseHelper.AddParameter(cmd, "MatterDate", txtMatterDate.Text)
                    ''DatabaseHelper.AddParameter(cmd, "MatterMemo", txtMatterMemo.Value)
                    DatabaseHelper.AddParameter(cmd, "MatterMemo", txtMatterMemo2.Text)
                    DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                    DatabaseHelper.AddParameter(cmd, "AttorneyId", AttorneyID)
                    DatabaseHelper.AddParameter(cmd, "CreditorInstanceId", CreditorInstanceId)
                    DatabaseHelper.AddParameter(cmd, "MatterTypeId", ddlMatterType.SelectedValue)
                    DatabaseHelper.AddParameter(cmd, "MatterStatusId", ddlMatterStatusCode.SelectedValue)
                    DatabaseHelper.AddParameter(cmd, "MatterSubStatusId", ddlMatterSubStatusCode.SelectedValue)
                    cmd.Connection.Open()
                    Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                        While rd.Read()

                            NewId = rd("NewId")

                        End While
                    End Using
                End Using
            End Using
        End If

        Return NewId

    End Function

    Private Sub InsertMatterTask(ByVal MatterId As Integer)

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
                Dim Description As String = Parts(5)
                Dim TaskId As Integer = Parts(6)
                'Dim DueHr As Integer = Parts(7)
                'Dim DueMin As Integer = Parts(8)
                'Dim DueZone As Integer = Parts(9)
                Dim strTimeBlock As String = Parts(12).ToString()
                Dim strReason As String = Parts(14).ToString()

                'build Due date with time
                'Dim dtDueDate As DateTime
                'dtDueDate = Convert.ToDateTime(DueDate + " " + Convert.ToString(DueHr) + ":" + Convert.ToString(DueMin))


                'figure out who the next task is assigned to
                'Dim AssignedTo As Integer

                'If AssignedToResolver = 1 Then

                'AssignedTo = DataHelper.Nz_int(DataHelper.FieldLookup("tblTask", "ResolvedBy", "TaskID = " & TaskID))

                'Else

                '    AssignedTo = DataHelper.Nz_int(DataHelper.FieldLookup("tblTask", "AssignedTo", "TaskID = " & TaskID))

                'End If

                Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                    Using cmd.Connection
                        cmd.Connection.Open()
                        cmd.CommandText = "stp_GetTaskAsignedToList"
                        cmd.CommandType = CommandType.StoredProcedure
                        DatabaseHelper.AddParameter(cmd, "RowNumber", AssignedToResolver)
                        DatabaseHelper.AddParameter(cmd, "UserGroupId", UserGroupID)
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
                    Description = DataHelper.FieldLookup("tblTaskType", "DefaultDescription", "TaskTypeID = " & TaskTypeID)
                End If

                Description = Description + " " + "-" + strTimeBlock

                'insert the new task against this client, with parent task, and against current roadmap
                If DueTypeID = 0 Then '0 - specific date


                    'TaskHelper.InsertTask(ClientID, CurrentRoadmapID, TaskTypeID, Description, AssignedTo, _
                    '    DateTime.Parse(DueDate), UserID, TaskID)

                Else '1 - days from now

                    'TaskHelper.InsertTask(ClientID, CurrentRoadmapID, TaskTypeID, Description, AssignedTo, _
                    '    Now.AddDays(Double.Parse(Due)), UserID, TaskID)

                End If

                Dim RealDueDate As Nullable(Of DateTime) = Nothing

                If DueDate.Length > 0 Then
                    RealDueDate = DateTime.Parse(DueDate)
                End If

                'save propagation values against task for legacy purposes
                'InsertPropagationSaved(TaskID, AssignedToResolver, DueTypeID, _
                '    DataHelper.Nz_double(Due), RealDueDate, TaskTypeID, Description)

                Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                    Using cmd.Connection

                        cmd.CommandText = "stp_InsertMatterTask"
                        cmd.CommandType = CommandType.StoredProcedure
                        DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                        DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                        DatabaseHelper.AddParameter(cmd, "Description", Description)
                        DatabaseHelper.AddParameter(cmd, "AssignedTo", AssignedTo)
                        DatabaseHelper.AddParameter(cmd, "DueDate", DueDate)
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
        Next

    End Sub

    Private Sub InsertMatterClassifications(ByVal MatterId As Integer)
        Dim ClassificationID As Int32

        If ddlClassification.SelectedIndex <> -1 Then
            Dim lcount As Int32 = 0
            For lcount = 0 To ddlClassification.Items.Count - 1
                If ddlClassification.Items(lcount).Selected Then
                    ClassificationID = ddlClassification.Items(lcount).Value

                    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                        Using cmd.Connection

                            cmd.CommandText = "[stp_InsertMatterClassification]"
                            cmd.CommandType = CommandType.StoredProcedure
                            DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
                            DatabaseHelper.AddParameter(cmd, "ClassificationId", ClassificationID)
                            DatabaseHelper.AddParameter(cmd, "UserId", UserID)

                            cmd.Connection.Open()
                            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                            End Using
                        End Using
                    End Using

                End If
            Next
        End If

    End Sub

    Private Sub ResetPropagationsCounter()

        Dim Count As Integer = 0

        If txtPropagations.Value.Length > 0 Then

            Count = txtPropagations.Value.Split("|").Length

            lblPropagations.Text = " (" & Count & ")"

        Else
            lblPropagations.Text = String.Empty
        End If

    End Sub

    'Private Function Save() As Integer

    '    Dim AccountID = CreateAccount()

    '    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
    '        Using cmd.Connection

    '            DatabaseHelper.AddParameter(cmd, "Acquired", DateTime.Parse(txtAcquired.Text))
    '            DatabaseHelper.AddParameter(cmd, "AccountNumber", txtAccountNumber.Value)
    '            DatabaseHelper.AddParameter(cmd, "ReferenceNumber", DataHelper.Zn(txtReferenceNumber.Value))
    '            DatabaseHelper.AddParameter(cmd, "OriginalAmount", Single.Parse(txtOriginalAmount.Value.Replace("$", "")))
    '            DatabaseHelper.AddParameter(cmd, "Amount", Single.Parse(txtCurrentAmount.Value.Replace("$", "")))

    '            Dim CreditorParts As String() = hdnCreditor.Value.Split("|")
    '            Dim CreditorID As Integer = CInt(CreditorParts(0))
    '            Dim CreditorGroupID As Integer = CInt(CreditorParts(7))

    '            If CreditorID = -1 Then
    '                If CreditorGroupID = -1 Then
    '                    CreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(CreditorParts(1), UserID)
    '                End If
    '                CreditorID = CreditorHelper.InsertCreditor(CreditorParts(1), CreditorParts(2), CreditorParts(3), CreditorParts(4), Integer.Parse(CreditorParts(5)), CreditorParts(6), UserID, CreditorGroupID)
    '            End If

    '            DatabaseHelper.AddParameter(cmd, "CreditorID", CreditorID)

    '            If hdnForCreditor.Value.Length > 0 Then
    '                Dim ForCreditorParts As String() = hdnForCreditor.Value.Split("|")
    '                Dim ForCreditorID As Integer = CInt(ForCreditorParts(0))
    '                Dim ForCreditorGroupID As Integer = CInt(ForCreditorParts(7))

    '                If ForCreditorID = -1 Then
    '                    If ForCreditorGroupID = -1 Then
    '                        ForCreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(ForCreditorParts(1), UserID)
    '                    End If
    '                    ForCreditorID = CreditorHelper.InsertCreditor(ForCreditorParts(1), ForCreditorParts(2), ForCreditorParts(3), ForCreditorParts(4), Integer.Parse(ForCreditorParts(5)), ForCreditorParts(6), UserID, ForCreditorGroupID)
    '                End If

    '                DatabaseHelper.AddParameter(cmd, "ForCreditorID", ForCreditorID)
    '            End If

    '            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
    '            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", UserID)

    '            DatabaseHelper.AddParameter(cmd, "AccountID", AccountID)
    '            DatabaseHelper.AddParameter(cmd, "Created", Now)
    '            DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)

    '            DatabaseHelper.BuildInsertCommandText(cmd, "tblCreditorInstance", "CreditorInstanceID", SqlDbType.Int)

    '            cmd.Connection.Open()
    '            cmd.ExecuteNonQuery()

    '        End Using

    '    End Using

    '    'update residue
    '    AccountHelper.SetWarehouseValues(AccountID)

    '    Dim SetupFeePercentage As Single = (Single.Parse(txtSetupFeePercentage.Value))

    '    Dim RtrChange As New RtrFeeAdjustmentHelper
    '    'collect new or adjust existing fee
    '    RtrChange.ShouldRtrFeeChange(ClientID, UserID)
    '    'AccountHelper.AdjustRetainerFee(AccountID, ClientID, UserID, False, SetupFeePercentage, 0)
    '    ClientHelper.CleanupRegister(ClientID)

    '    'if suppose to, lock verification
    '    If chkIsVerified.Checked Then

    '        Dim CurrentAmount As Single = Single.Parse(txtCurrentAmount.Value)

    '        Dim MinimumAdditionalAccountFee As Double = Math.Abs(StringHelper.ParseDouble(DataHelper.FieldLookup("tblClient", _
    '            "AdditionalAccountFee", "ClientID = " & ClientID)))

    '        SetupFeePercentage = SetupFeePercentage / 100

    '        Dim FeeAmount As Double = Math.Abs((CurrentAmount * SetupFeePercentage))

    '        If MinimumAdditionalAccountFee > FeeAmount Then
    '            FeeAmount = MinimumAdditionalAccountFee
    '        End If

    '        AccountHelper.LockVerification(AccountID, CurrentAmount, 0.0, DateTime.Now, UserID, _
    '            CurrentAmount, FeeAmount)

    '    End If

    '    If Not hdnTempAccountID.Value = 0 Then
    '        SharedFunctions.DocumentAttachment.SolidifyTempRelation(hdnTempAccountID.Value, "account", ClientID, AccountID)
    '    End If

    '    Return AccountID

    'End Function

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        SharedFunctions.DocumentAttachment.DeleteAllForItem(hdnTempAccountID.Value, "account", UserID)

        Close()
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        'a. InsertOrUpdate Matter
        MatterId = InsertOrUpdate()
        'b. InsertorAdd Tasks if applicables
        ''TaskHelper.InsertTask()
        InsertMatterTask(MatterId)

        'c.saving matter documents
        SaveMatterAttachments(MatterId)

        'd.Insert Matter classifications
        InsertMatterClassifications(MatterId)

        'e.Save matter phone note
        SaveMatterPhoneNote(MatterId)

        Response.Redirect("~/clients/client/creditors/matters/matterinstance.aspx?t=o&id=" & ClientID & "&aid=" & AccountId & "&mid=" & MatterId & "&ciid=" & CreditorInstanceId)
        ''Response.Redirect("~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & Save())
        'Close()

    End Sub

    Private Sub SaveMatterPhoneNote(ByVal MatterId As Integer)
        If txtPhoneNote.Value.Length > 0 Then
            Dim PropagationsList() As String = txtPhoneNote.Value.Split("|")
            Dim blnOutgoing As Boolean = Convert.ToBoolean(PropagationsList(0))
            dim blnIncoming As Boolean = Convert.ToBoolean(PropagationsList(1))
            Dim intInternal As Integer = PropagationsList(2)
            Dim intExternal As Integer = PropagationsList(3)
            Dim PhoneCallEntry As Integer = PropagationsList(4)
            Dim strMessage As String = PropagationsList(5)
            Dim strSubject As String = PropagationsList(6)
            Dim strPhoneNumber As String = PropagationsList(7)
            Dim strStarted As String = PropagationsList(8)
            Dim strEnded As String = PropagationsList(9)

            PhoneCallID = PhoneCallHelper.InsertPhoneCall(ClientID, UserID, intInternal, intExternal, blnOutgoing, strPhoneNumber, strMessage, strSubject, DateTime.Parse(strStarted), DateTime.Parse(strEnded))
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "PhoneCallID", PhoneCallID)
            ' Id 19 is Matter    
            DatabaseHelper.AddParameter(cmd, "RelationTypeID", 19)
            DatabaseHelper.AddParameter(cmd, "RelationID", MatterId)
            DatabaseHelper.BuildInsertCommandText(cmd, "tblPhoneCallRelation", "PhoneCallRelationId", SqlDbType.Int)

            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try
        End If
    End Sub

    Private Sub SaveMatterAttachments(ByVal MatterId As Integer)
        'Dim strAttachments As String() = hdnAttachments.Value.Split(";")
        Dim strAttachments As String() = hdnAttachmentsText.Value.Split(";")
        Dim strAttachmentTypes As String() = hdnAttachments.Value.Split(";")
        Dim iIndex As Int32 = 0
        For Each strAttachment In strAttachments
            If strAttachmentTypes(iIndex).Trim = "0" Then

                Dim filename As String = strAttachment
                Dim subFolder As String = ""
                Dim idx As Integer = filename.LastIndexOf("/")

                If idx > -1 Then
                    subFolder = filename.Substring(0, idx + 1)
                    filename = filename.Replace(subFolder, "")
                    subFolder = subFolder.Replace("//", "\")
                End If

                AttachDocumentToTemp("matter", MatterId, filename, UserID, subFolder)
            Else
                'saving new file type
                Dim filename As String = strAttachment
                If filename <> "" Then

                    ' filename = filename.Substring(filename.ToLower().IndexOf("legaldocs") + 10) 'legacydocs
                    'Dim strDocId As String = "A" & System.DateTime.Now.ToString("yyMMddhhmm")
                    Dim strdocid As String = ReportsHelper.GetNewDocID
                    Dim cmdStr As String = "INSERT INTO tblDocScan(DocID,ReceivedDate, Created,CreatedBy) VALUES ('" & strDocId & "',getdate(),getdate()," & UserID.ToString() & ")"

                    Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
                        Using cmd.Connection
                            cmd.Connection.Open()

                            cmd.ExecuteNonQuery()
                        End Using
                    End Using

                    Dim RelationType As String = "matter"
                    Dim RelationID As String = MatterId

                    cmdStr = "INSERT INTO tblDocRelation(ClientID, RelationID, RelationType, DocTypeID, DocID, DateString, SubFolder,RelatedDate, RelatedBy, DeletedFlag, deleteddate, deletedby)  VALUES (" & _
                    ClientID.ToString() + ", " + RelationID.ToString() + ", '" + RelationType + "', 'M030', '" + strDocId + "', '', '" + filename + "', getdate(), " + UserID.ToString() + ", 0,  null,0)" 'X001
                    Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
                        Using cmd.Connection
                            cmd.Connection.Open()

                            cmd.ExecuteNonQuery()
                        End Using
                    End Using
                End If

            End If
            iIndex = iIndex + 1
        Next
    End Sub

    Public Sub AttachDocumentToTemp(ByVal relationType As String, ByVal relationID As Integer, ByVal documentName As String, ByVal userID As Integer, Optional ByVal subFolder As String = "")
        AttachDocument(relationType, relationID, documentName, userID, subFolder)
    End Sub

    Public Sub AttachDocument(ByVal relationType As String, ByVal relationID As Integer, ByVal documentName As String, ByVal userID As Integer, Optional ByVal subFolder As String = "")

        Dim docTypeID As String
        Dim docID As String
        Dim dateStr As String
        Dim idx1 As Integer = 0
        Dim idx2 As Integer = documentName.IndexOf("_", 0)

        ' clientID = Integer.Parse(DataHelper.FieldLookup("tblClient", "ClientID", "AccountNumber = " + documentName.Substring(idx1, idx2))) 'Integer.Parse(documentName.Substring(idx1, idx2))
        idx1 = idx2 + 1
        idx2 = documentName.IndexOf("_", idx1)

        docTypeID = documentName.Substring(idx1, idx2 - idx1)
        idx1 = idx2 + 1
        idx2 = documentName.IndexOf("_", idx1)

        docID = documentName.Substring(idx1, idx2 - idx1)
        idx1 = idx2 + 1
        idx2 = documentName.IndexOf(".", idx1)
        dateStr = docID.Substring(1, 6) '  dateStr = docID.Substring(0, 6)

        'If idx2 = -1 Then
        '    dateStr = documentName.Substring(idx1).Substring(1, 6)
        'Else
        '    dateStr = documentName.Substring(idx1, idx2 - idx1).Substring(1, 6)
        'End If

        AttachDocument(relationType, relationID, docTypeID, docID, dateStr, ClientID, userID, subFolder)
    End Sub

    Public Sub AttachDocument(ByVal relationType As String, ByVal relationID As Integer, ByVal docTypeID As String, ByVal docID As String, ByVal dateStr As String, ByVal clientID As Integer, ByVal userID As Integer, Optional ByVal subFolder As String = "")
        Dim strCreditorInstance As String = String.Empty
        strCreditorInstance = DataHelper.FieldLookup("tblMatter", "CreditorInstanceId", "MatterID = " + relationID.ToString())

        'subFolder = strCreditorInstance & "\"

        Dim cmdStr As String = "INSERT INTO tblDocRelation VALUES (" + clientID.ToString() + ", " + relationID.ToString() + ", '" + _
        relationType + "', '" + docTypeID + "', '" + docID + "', '" + dateStr + "', " + IIf(subFolder.Length > 0, "'" + subFolder + "'", "null") + _
        ", getdate(), " + userID.ToString() + ", 0,  null,0)"
        '", getdate(), " + userID.ToString() + ", 0, null, null,0,null)"
        Using cmd As New SqlCommand(cmdStr, ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using

        Using cmd As New SqlCommand("UPDATE tblDocRelation SET DeletedFlag = 0, DeletedDate = getdate(), DeletedBy = -1 WHERE DeletedFlag = 0 and ClientID = " + clientID.ToString() + " and RelationID = " + relationID.ToString() + " and RelationType = '" + relationType + "'", ConnectionFactory.Create()) 'New SqlConnection("server=sql2;uid=sa;pwd=sql1login;database=DMS_OLDDEV;connect timeout=99999"))
            Using cmd.Connection
                cmd.Connection.Open()

                cmd.ExecuteNonQuery()
            End Using
        End Using

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    End Sub

    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        SharedFunctions.DocumentAttachment.DeleteAttachment(hdnCurrentDoc.Value, UserID)
        LoadDocuments()
    End Sub

    Private Sub LoadDocuments()

        'Dissable for now need hdnTempAccountID to make it work

        ''rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(Integer.Parse(hdnTempAccountID.Value), "account")
        'rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(Integer.Parse(hdnTempMatterID.Value), "matter")
        'rpDocuments.DataBind()

        'If rpDocuments.DataSource.Count > 0 Then
        '    hypDeleteDoc.Disabled = False
        'Else
        '    hypDeleteDoc.Disabled = True
        'End If
    End Sub

    Protected Sub lnkShowDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowDocs.Click
        LoadDocuments()
    End Sub

    Protected Sub ddlAssignedToGroups_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlAssignedToGroups.SelectedIndexChanged
        AssignedToGroup = ddlAssignedToGroups.SelectedValue
        MatterTypeId = ddlMatterType.SelectedValue
    End Sub

    Protected Sub ddlCreditors_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlCreditors.SelectedIndexChanged
        LoadMatterNumber()

        If ddlCreditors.SelectedValue > 0 Then
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandText = "get_ValidCreditorsList"
                    cmd.CommandType = CommandType.StoredProcedure
                    DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                    DatabaseHelper.AddParameter(cmd, "AccountId", ddlCreditors.SelectedValue)
                    cmd.Connection.Open()
                    Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                        While rd.Read()
                            hdnLatestCreditorId.Value = DatabaseHelper.Peel_int(rd, "CreditorInstanceId")
                        End While
                    End Using
                End Using
            End Using
        End If

    End Sub

    Protected Sub ddlMatterStatusCode_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlMatterStatusCode.SelectedIndexChanged
        PopulateMatterSubStatusCodes()
    End Sub

    Protected Sub ddlMatterType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlMatterType.SelectedIndexChanged
        LoadMatterTypeChanges()
    End Sub

    Private Sub LoadMatterTypeChanges()
        MatterTypeId = ddlMatterType.SelectedValue
        If MatterTypeId = 1 Then
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandText = "SELECT ts.Region FROM tblperson tp, tblClient tc, tblState ts Where tc.primarypersonid = tp.personid and tp.StateId=ts.StateId and tc.ClientId=@ClientId"
                    DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                    cmd.Connection.Open()
                    Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleResult)
                        While rd.Read()
                            ClientRegion = DatabaseHelper.Peel_string(rd, "Region")
                        End While
                    End Using
                End Using
            End Using
        End If

        If MatterTypeId = 3 Or MatterTypeId = 4 Then
            trAssignedToGroup.Style.Item("display") = "none"
            trClassifications.Style.Item("display") = "none"
        Else
            trAssignedToGroup.Style.Item("display") = "inline"
            PopulateAssignedToGroupList()
            trClassifications.Style.Item("display") = "inline"
            PopulateClassifications()
        End If

        If MatterTypeId = 4 Then
            trCreditor.Style.Item("display") = "none"
        Else
            trCreditor.Style.Item("display") = "inline"
            PopulateValidCreditors()
        End If

    End Sub

    Protected Sub ddlLocalCounsel_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlLocalCounsel.SelectedIndexChanged
        MatterTypeId = ddlMatterType.SelectedValue
    End Sub

    Protected Sub lnkSaveCose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveCose.Click
        'a. InsertOrUpdate Matter
        MatterId = InsertOrUpdate()
        'b. InsertorAdd Tasks if applicables
        ''TaskHelper.InsertTask()
        InsertMatterTask(MatterId)

        'c.saving matter documents
        SaveMatterAttachments(MatterId)

        'd.Insert Matter classifications
        InsertMatterClassifications(MatterId)

        'e.Save matter phone note
        SaveMatterPhoneNote(MatterId)

        ''Response.Redirect("~/clients/client/creditors/accounts/account.aspx?id=" & ClientID & "&aid=" & Save())
        Close()
    End Sub
End Class