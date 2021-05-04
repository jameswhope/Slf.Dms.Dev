Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Text
Imports System.Data
Imports System.Collections.Generic

Partial Class tasks_workflows_5
    Inherits System.Web.UI.UserControl

#Region "Variables"

    Private TaskID As Integer
    Private qs As QueryStringCollection
    Private baseTable As String = "tblTask"

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            TaskID = DataHelper.Nz_int(qs("id"), 0)

            If Not IsPostBack Then
                LoadTaskResolutions()
            End If

        End If

    End Sub
    Private Sub LoadTaskResolutions()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblTaskResolution"

        cboTaskResolutionID.Items.Clear()

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()
                cboTaskResolutionID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "TaskResolutionID")))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        'get associated client
        Dim ClientID As Integer = TaskHelper.GetClients(TaskID)(0)

        'Assign CS Rep

        'get this client's preferred language
        Dim LanguageID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPerson", _
            "LanguageID", "PersonID = " & ClientHelper.GetDefaultPerson(ClientID)))

        'get the next CS Rep who speaks this language
        Dim CSRepUserID As Integer = UserHelper.GetNextUser(LanguageID, 3)

        'get current roadmap location
        Dim CurrentRoadmapID As Integer = DataHelper.Nz_int(ClientHelper.GetRoadmap(ClientID, Now, _
            "RoadmapID"))


        'Update the client - set the new CS Rep
        DataHelper.FieldUpdate("tblClient", "AssignedCSRep", CSRepUserID, "ClientID=" & ClientID)

        'Insert task for "familiarize yourself with your new assignment" (tasktype 6) against this client/CS Rep
        Dim TaskTypeID As Integer = 6
        Dim Description As String = DataHelper.FieldLookup("tblTaskType", "DefaultDescription", _
            "TaskTypeID = " & TaskTypeID)
        TaskHelper.InsertTask(ClientID, CurrentRoadmapID, TaskTypeID, Description, _
            CSRepUserID, Now, UserID)


        'insert roadmap for "Assigned CS Rep"
        RoadmapHelper.InsertRoadmap(ClientID, 12, Nothing, UserID)

        'insert roadmap for "Underwriting Complete"
        RoadmapHelper.InsertRoadmap(ClientID, 11, Nothing, UserID)

        'insert roadmap for "Active"
        RoadmapHelper.InsertRoadmap(ClientID, 14, Nothing, UserID)


        'Resolve the Task
        TaskHelper.Resolve(TaskID, txtResolved.Value, cboTaskResolutionID.SelectedValue, UserID, _
            Regex.Split(txtNotes.Value, "\|--\$--\|"), txtPropagations.Value.Split("|"))

        CType(Page, tasks_task_resolve).ReturnToReferrer()

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
End Class