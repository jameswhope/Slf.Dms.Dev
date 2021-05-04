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
Imports System.IO

Partial Class clients_client_applicants_applicant
    Inherits PermissionPage
    Implements IEntityPageOverrideSync

#Region "Variables"
    Private strNavigation As String
    Private Action As String
    Public AccountID As Integer
    Public NoteID As Integer
    Public MatterId As Integer

    Public CreditorInstanceId As Integer
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Private baseTable As String = "tblNote"
    Private IsMy As Boolean
    Private UserID As Integer
    Private UserTypeID As Integer
    Private UserGroupID As Integer
    Public AddRelation As Integer
    Public AddRelationType As String

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserTypeID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID))
        UserGroupID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupId", "UserId=" & UserID))
        qs = LoadQueryString()



        If Not qs Is Nothing Then
            ClientID = DataHelper.Nz_int(qs("id"), 0)
            AccountID = DataHelper.Nz_int(qs("aid"), 0)
            NoteID = DataHelper.Nz_int(qs("nid"), 0)
            Action = DataHelper.Nz_string(qs("a"))
            strNavigation = DataHelper.Nz_string(qs("t"))
            ''Added for MatterId 
            If Not qs("mid") Is Nothing Then
                MatterId = DataHelper.Nz_string(qs("mid"))
                CreditorInstanceId = DataHelper.Nz_int(qs("ciid"), 0)
            Else
                MatterId = 0
                CreditorInstanceId = 0
            End If

            HandleAction()

            If Not IsPostBack Then
                AddRelation = 0

                Select Case Action
                    Case "a"
                        hdnTempNoteID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()
                    Case "am" 'Add Matter Note
                        hdnTempNoteID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()
                        MatterId = DataHelper.Nz_string(qs("mid"))
                    Case Else
                        hdnTempNoteID.Value = 0
                        LoadCreditorRelations()
                End Select

                LoadDocuments()
            End If

        End If

    End Sub
    Private Sub LoadCreditorRelations()
        Using cmd As New SqlCommand("SELECT rt.DocRelation, nr.RelationID FROM tblNoteRelation as nr inner join tblRelationType as rt on rt.RelationTypeID = nr.RelationTypeID WHERE not rt.DocRelation is null and nr.NoteID = " + NoteID.ToString(), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        AddRelation = Integer.Parse(reader("RelationID"))
                        AddRelationType = reader("DocRelation").ToString()
                    End If
                End Using
            End Using
        End Using
    End Sub
    Private Sub HandleAction()

        Dim CommonTasks As List(Of String) = Master.CommonTasks

        Select Case Action
            Case "a"    'add
                lblNote.Text = "Add New Note"

                Dim now As DateTime = DateTime.Now

                txtCreatedBy.Text = UserHelper.GetName(UserID)
                txtCreatedDate.Text = now.ToShortDateString() + " at " + now.ToShortTimeString()
                txtLastModifiedBy.Text = UserHelper.GetName(UserID)
                txtLastModifiedDate.Text = now.ToShortDateString() + " at " + now.ToShortTimeString()

                trRelations.Visible = False
            Case "am"    'add Matter Note
                lblNote.Text = "Add New Note for a Matter"

                Dim now As DateTime = DateTime.Now

                txtCreatedBy.Text = UserHelper.GetName(UserID)
                txtCreatedDate.Text = now.ToShortDateString() + " at " + now.ToShortTimeString()
                txtLastModifiedBy.Text = UserHelper.GetName(UserID)
                txtLastModifiedDate.Text = now.ToShortDateString() + " at " + now.ToShortTimeString()

                trRelations.Visible = False
            Case Else   'edit
                LoadRecord()

                lblNote.Text = "Note"

                'add delete task
                If (Master.UserEdit And Permission.UserDelete(IsMy)) Or UserTypeID = 5 Then
                    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this note</a>")
                End If
                trRelations.Visible = True
        End Select

        'add applicant tasks
        If Master.UserEdit Or UserTypeID = 5 Then
            If Permission.UserEdit(IsMy) Or UserTypeID = 5 Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this note</a>")

            Else
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
            End If
            If Master.UserEdit Then
                'add normal tasks

            End If
        Else
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
        End If

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkCommunications.HRef = "~/clients/client/communication/?id=" & ClientID

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:OpenScanning();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_remove.png") & """ align=""absmiddle""/>Scan Document</a>")
    End Sub

    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        SharedFunctions.DocumentAttachment.DeleteAttachment(hdnCurrentDoc.Value, UserID)
        LoadDocuments()
    End Sub

    Private Sub LoadDocuments()
        If NoteID = 0 Then
            rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(Integer.Parse(hdnTempNoteID.Value), "note", Request.Url.AbsoluteUri)
        Else
            rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(NoteID, "note", Request.Url.AbsoluteUri)
        End If

        rpDocuments.DataBind()

        If rpDocuments.DataSource.Count > 0 Then
            hypDeleteDoc.Disabled = False
        Else
            hypDeleteDoc.Disabled = True
        End If
    End Sub

    Private Sub LoadRecord()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT Created, CreatedBy, LastModified, LastModifiedBy, Value FROM tblNote WHERE NoteID = @NoteID"

        DatabaseHelper.AddParameter(cmd, "NoteID", NoteID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then
                Dim created As DateTime = DatabaseHelper.Peel_date(rd, "Created")
                Dim lastModified As DateTime = DatabaseHelper.Peel_date(rd, "LastModified")

                txtCreatedBy.Text = UserHelper.GetName(DatabaseHelper.Peel_int(rd, "CreatedBy"))
                txtCreatedDate.Text = created.ToShortDateString() + " at " + created.ToShortTimeString()
                txtLastModifiedBy.Text = UserHelper.GetName(DatabaseHelper.Peel_int(rd, "LastModifiedBy"))
                txtLastModifiedDate.Text = lastModified.ToShortDateString() + " at " + lastModified.ToShortTimeString()

                If txtMessage.Text.Length = 0 Then
                    txtMessage.Text = DatabaseHelper.Peel_string(rd, "Value")
                End If


                IsMy = (DatabaseHelper.Peel_int(rd, "CreatedBy") = UserID)
            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        LoadRelations()
    End Sub

    Private Sub LoadRelations()
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetRelationsForNote")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "noteid", NoteID)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    rpRelations.DataSource = rd
                    rpRelations.DataBind()
                End Using
            End Using
        End Using
    End Sub

    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""clients_client_applicants_applicant_default""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Private Sub Close()
        If strNavigation = "m" Then
            Response.Redirect("~/clients/client/creditors/matters/matterinstance.aspx?id=" & ClientID & "&aid=" & AccountID & "&mid=" & MatterId & "&ciid=" & CreditorInstanceId)
        End If
        If Action = "am" And MatterId > 0 Then
            Response.Redirect("~/clients/client/creditors/matters/matterinstance.aspx?id=" & ClientID & "&aid=" & AccountID & "&mid=" & MatterId & "&ciid=" & CreditorInstanceId)
        Else
            Response.Redirect("~/clients/client/communication/?id=" & ClientID)
        End If
    End Sub
    Private Function InsertOrUpdateNote() As Integer
        If Action = "am" And MatterId > 0 Then
            NoteID = NoteHelper.InsertNote(txtMessage.Text, UserID, ClientID)
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "NoteID", NoteID)
            DatabaseHelper.AddParameter(cmd, "RelationTypeID", 19)
            DatabaseHelper.AddParameter(cmd, "RelationID", MatterId)
            DatabaseHelper.BuildInsertCommandText(cmd, "tblNoteRelation", "NoteRelationId", SqlDbType.Int)

            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try


        ElseIf Action = "a" Then

            NoteID = NoteHelper.InsertNote(txtMessage.Text, UserID, ClientID)
            SharedFunctions.DocumentAttachment.SolidifyTempRelation(hdnTempNoteID.Value, "note", ClientID, NoteID)
        Else
            NoteHelper.UpdateNote(NoteID, txtMessage.Text, UserID)
        End If

        Return NoteID
    End Function
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        SharedFunctions.DocumentAttachment.DeleteAllForItem(hdnTempNoteID.Value, "note", UserID)

        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        Save()

        'If Action = "a" Then 'new record was just added


        'End If

        Close()

    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        SharedFunctions.DocumentAttachment.DeleteAllForItem(NoteID, "note", UserID)

        'delete applicant
        NoteHelper.Delete(NoteID)

        'drop back to applicants
        Close()

    End Sub
    Private Sub Save()

        'save record
        InsertOrUpdateNote()

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(phBody, c, "Clients-Client Single Record-Communication-Note")
        AddControl(trRelations, c, "Clients-Client Single Record-Communication-Relations")
    End Sub

    Protected Sub lnkDeleteRelation_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteRelation.Click

        If txtSelectedIDs.Value.Length > 0 Then

            'get selected "," delimited NoteId's
            Dim ids() As String = txtSelectedIDs.Value.Split(",")

            For Each id As String In ids
                DataHelper.Delete("tblNoteRelation", "noterelationid=" & id)
            Next

        End If

        'reload same page (of applicants)
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub

    Protected Sub lnkShowDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowDocs.Click
        LoadDocuments()
    End Sub


End Class