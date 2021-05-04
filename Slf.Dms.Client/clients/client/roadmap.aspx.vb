Option Explicit On

Imports System.Web
Imports System.Text

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Imports Microsoft.VisualBasic

Partial Class clients_client_roadmap
    Inherits System.Web.UI.Page

#Region "Variables"

    Public QueryString As String
    Private Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Private baseTable As String = "tblClient"
    Private UserID As Integer

    Private grdRoadmap As New Slf.Dms.Controls.RoadmapGrid

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        qs = LoadQueryString()
        PrepQuerystring()

        UserID = Integer.Parse(Page.User.Identity.Name)

        If Not qs Is Nothing Then
            ClientID = DataHelper.Nz_int(qs("id"), 0)
            If Not IsPostBack Then
                LoadClientStatuses()
                LoadRoadmaps()
                LoadPrimaryPerson()
                SetRollups()

                ddlNewClientStatusId.SelectedIndex = CInt(Request.QueryString("status"))
                Me.txtOldRoadmapId.Value = DataHelper.FieldLookup("tblClient", "CurrentClientStatusID", "ClientID = " & ClientID)
                imDate.Text = DateTime.Now.ToString("MMddyyyyhhmmtt")
            End If
        End If

    End Sub
    Private Sub PrepQuerystring()

        'prep querystring for pages that need those variables
        QueryString = New QueryStringBuilder(Request.Url.Query).QueryString

        If QueryString.Length > 0 Then
            QueryString = "?" & QueryString
        End If

    End Sub
    Private Sub SetRollups()

        Dim Views As List(Of String) = CType(Master, clients_client).Views
        Dim CommonTasks As List(Of String) = CType(Master, clients_client).CommonTasks

        Views.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/clients/client/") & QueryString & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_objectbrowser.png") & """ align=""absmiddle""/>Show main overview</a>")
        Views.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""" & ResolveUrl("~/clients/client/enrollment.aspx") & QueryString & """><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_form_setup.png") & """ align=""absmiddle""/>Show screening</a>")

    End Sub
    Private Sub LoadClientStatuses()
        ddlNewClientStatusId.Items.Clear()
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand
            Using cmd.Connection
                cmd.Connection.Open()
                cmd.CommandText = "SELECT * FROM tblClientStatus WHERE Display = 1"
                Using rd As IDataReader = cmd.ExecuteReader
                    While rd.Read()
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
                        Dim Id As Integer = DatabaseHelper.Peel_int(rd, "ClientStatusId")
                        ddlNewClientStatusId.Items.Add(New ListItem(Name, Id))
                    End While
                End Using
            End Using
        End Using
    End Sub
    Private Sub LoadRoadmaps()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetRoadmapsForClient")

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Dim Roadmap As New Roadmap(DatabaseHelper.Peel_int(rd, "RoadmapID"), _
                    DatabaseHelper.Peel_int(rd, "ParentRoadmapID"), _
                    DatabaseHelper.Peel_int(rd, "ClientID"), _
                    DatabaseHelper.Peel_int(rd, "ClientStatusID"), _
                    DatabaseHelper.Peel_int(rd, "ParentClientStatusID"), _
                    DatabaseHelper.Peel_string(rd, "ClientStatusName"), _
                    DatabaseHelper.Peel_string(rd, "Reason"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName"))

                LoadNotesForRoadmap(DatabaseHelper.Peel_int(rd, "RoadmapID"), Roadmap)
                LoadTasksForRoadmap(DatabaseHelper.Peel_int(rd, "RoadmapID"), Roadmap)

                grdRoadmap.AddRoadmap(Roadmap)

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        pnlRoadmap.Controls.Add(grdRoadmap)

    End Sub
    Private Sub LoadNotesForRoadmap(ByVal RoadmapID As Integer, ByVal Roadmap As Roadmap)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNotesForRoadmap")

        DatabaseHelper.AddParameter(cmd, "RoadmapID", RoadmapID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Roadmap.Notes.Add(DatabaseHelper.Peel_int(rd, "NoteID"), _
                    New Note(DatabaseHelper.Peel_int(rd, "NoteID"), _
                    DatabaseHelper.Peel_string(rd, "Value"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadTasksForRoadmap(ByVal RoadmapID As Integer, ByVal Roadmap As Roadmap)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTasksForRoadmap")

        DatabaseHelper.AddParameter(cmd, "RoadmapID", RoadmapID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Dim Task As New Task(DatabaseHelper.Peel_int(rd, "TaskID"), _
                    DatabaseHelper.Peel_int(rd, "ParentTaskID"), _
                    DatabaseHelper.Peel_int(rd, "ClientID"), _
                    DatabaseHelper.Peel_string(rd, "ClientName"), _
                    DatabaseHelper.Peel_int(rd, "TaskTypeID"), _
                    DatabaseHelper.Peel_string(rd, "TaskTypeName"), _
                    DatabaseHelper.Peel_int(rd, "TaskTypeCategoryID"), _
                    DatabaseHelper.Peel_string(rd, "TaskTypeCategoryName"), _
                    DatabaseHelper.Peel_string(rd, "Description"), _
                    DatabaseHelper.Peel_int(rd, "AssignedTo"), _
                    DatabaseHelper.Peel_string(rd, "AssignedToName"), _
                    DatabaseHelper.Peel_date(rd, "Due"), _
                    DatabaseHelper.Peel_ndate(rd, "Resolved"), _
                    DatabaseHelper.Peel_int(rd, "ResolvedBy"), _
                    DatabaseHelper.Peel_string(rd, "ResolvedByName"), _
                    DatabaseHelper.Peel_int(rd, "TaskResolutionID"), _
                    DatabaseHelper.Peel_string(rd, "TaskResolutionName"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName"))

                LoadNotesForTask(Task.TaskID, Task)

                Roadmap.Tasks.Add(Task.TaskID, Task)

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadNotesForTask(ByVal TaskID As Integer, ByVal Task As Task)

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNotesForTask")

        DatabaseHelper.AddParameter(cmd, "TaskID", TaskID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Task.Notes.Add(DatabaseHelper.Peel_int(rd, "NoteID"), _
                    New Note(DatabaseHelper.Peel_int(rd, "NoteID"), _
                    DatabaseHelper.Peel_string(rd, "Value"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub
    Private Sub LoadPrimaryPerson()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPerson WHERE PersonID = @PersonID"

        DatabaseHelper.AddParameter(cmd, "PersonID", ClientHelper.GetDefaultPerson(ClientID))

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim StateID As Integer = DatabaseHelper.Peel_int(rd, "StateID")
                Dim State As String = DataHelper.FieldLookup("tblState", "Name", "StateID = " & StateID)

                lblName.Text = PersonHelper.GetName(DatabaseHelper.Peel_string(rd, "FirstName"), _
                    DatabaseHelper.Peel_string(rd, "LastName"), _
                    DatabaseHelper.Peel_string(rd, "SSN"), _
                    DatabaseHelper.Peel_string(rd, "EmailAddress"))

                lblAddress.Text = PersonHelper.GetAddress(DatabaseHelper.Peel_string(rd, "Street"), _
                    DatabaseHelper.Peel_string(rd, "Street2"), _
                    DatabaseHelper.Peel_string(rd, "City"), State, _
                    DatabaseHelper.Peel_string(rd, "ZipCode")).Replace(vbCrLf, "<br>")

                lblSSN.Text = "SSN: " & StringHelper.PlaceInMask(DatabaseHelper.Peel_string(rd, "SSN"), "___-__-____")

            Else
                lblName.Text = "No Applicant"
                lblAddress.Text = "No Address"
            End If

            lnkStatus.Text = ClientHelper.GetStatus(ClientID, Now)

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Dim NumApplicants As Integer = DataHelper.FieldCount("tblPerson", "PersonID", "ClientID = " & ClientID)

        If NumApplicants > 1 Then
            lnkNumApplicants.InnerText = "(" & NumApplicants & ")"
            lnkNumApplicants.HRef = "~/clients/client/applicants/" & QueryString
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

    Protected Sub lnkChangeStatus_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkChangeStatus.Click
        Dim cancel As New PendingCancelHelper
        Try
            'Is this client status Pending Cancellation
            If ddlNewClientStatusId.SelectedValue = 25 And txtOldRoadmapId.Value <> 25 Then
                cancel.PendingCancel(ClientID, UserID)
            ElseIf ddlNewClientStatusId.SelectedValue <> 25 And txtOldRoadmapId.Value = 25 Then 'Changing from PC
                cancel.ReActivateClient(ClientID, UserID)
            End If
        Catch ex As Exception

        End Try

        If ddlNewClientStatusId.SelectedValue >= 15 AndAlso ddlNewClientStatusId.SelectedValue <= 18 Then
            VicidialHelper.InsertStopLeadRequest(ClientID, VicidialGlobals.ViciClientSource.ToUpper, "roadmap.aspx: Cancel Client")
        End If

        If ddlNewClientStatusId.SelectedValue = 17 Then
            Response.Redirect("reasonsTree.aspx?id=" + ClientID.ToString() + "&date=" + imDate.Text)
        End If

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection

                DatabaseHelper.AddParameter(cmd, "ClientId", ClientID)
                DatabaseHelper.AddParameter(cmd, "ClientStatusId", ddlNewClientStatusId.SelectedValue)
                DatabaseHelper.AddParameter(cmd, "CreatedBy", Integer.Parse(Page.User.Identity.Name))
                DatabaseHelper.AddParameter(cmd, "Reason", "Manually created")
                Dim CurrentRoadmapID As Integer = DataHelper.Nz_int(ClientHelper.GetRoadmap(ClientID, Now, "RoadmapID"))
                If Not chkAsRoot.Checked And Not CurrentRoadmapID = 0 Then
                    DatabaseHelper.AddParameter(cmd, "ParentRoadmapId", CurrentRoadmapID)
                End If
                If Not String.IsNullOrEmpty(imDate.Text) Then
                    DatabaseHelper.AddParameter(cmd, "Created", DateTime.Parse(imDate.Text))
                    DatabaseHelper.AddParameter(cmd, "LastModified", DateTime.Parse(imDate.Text))
                    ' imDate.Text = Date.Now.ToString("MMddyyyy")
                Else
                    DatabaseHelper.AddParameter(cmd, "Created", Now)
                    DatabaseHelper.AddParameter(cmd, "LastModified", Now)

                End If
                DatabaseHelper.AddParameter(cmd, "LastModifiedBy", Integer.Parse(Page.User.Identity.Name))

                DatabaseHelper.BuildInsertCommandText(cmd, "tblRoadmap")
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        Response.Redirect("roadmap.aspx?id=" + ClientID.ToString() + "&status=" + ddlNewClientStatusId.SelectedIndex.ToString())
    End Sub

    Private Sub AddRoadmapIdsRecursive(ByVal l As List(Of Integer), ByVal RoadmapId As Integer)
        l.Add(RoadmapId)
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT RoadmapId FROM tblRoadmap WHERE ParentRoadmapId=@RoadmapId"
                DatabaseHelper.AddParameter(cmd, "RoadmapId", RoadmapId)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read
                        AddRoadmapIdsRecursive(l, DatabaseHelper.Peel_int(rd, "RoadmapID"))
                    End While
                End Using
            End Using
        End Using
    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        Dim RoadmapIds As New List(Of Integer)
        AddRoadmapIdsRecursive(RoadmapIds, Integer.Parse(txtRoadmapId.Value))

        For Each RoadmapId As Integer In RoadmapIds
            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandText = "DELETE FROM tblRoadmap WHERE RoadmapId=@RoadmapId"
                    DatabaseHelper.AddParameter(cmd, "RoadmapId", RoadmapId)
                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Next
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub

End Class