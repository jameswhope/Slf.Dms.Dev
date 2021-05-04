Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions

Imports Slf.Dms.Records

Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_communication_side_note
    Inherits Page

#Region "Variables"

    Private Action As String
    Public NoteID As Integer
    Private qs As QueryStringCollection
    Private baseTable As String = "tblNote"
    Private UserID As Integer

    Public DataClientID As Integer
    Public RelationTypeID As Integer
    Public RelationTypeName As String
    Public RelationID As Integer
    Public ClientName As String
    Public EntityName As String
    Public ContextSensitive As String
    Public AddRelationType As String
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        DataClientID = DataHelper.Nz_int(Request.QueryString("ClientID"), -1)
        ClientName = ClientHelper.GetDefaultPersonName(DataClientID)
        RelationTypeID = DataHelper.Nz_int(Request.QueryString("RelationTypeID"), -1)
        RelationID = DataHelper.Nz_int(Request.QueryString("RelationID"), -1)
        EntityName = Request.QueryString("EntityName")
        RelationTypeName = DataHelper.FieldLookup("tblRelationType", "Name", "relationtypeid=" & RelationTypeID)

        If RelationTypeID = 2 Then
            ContextSensitive = "account"
        Else
            ContextSensitive = "all"
        End If

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        qs = LoadQueryString()

        If Not qs Is Nothing Then
            NoteID = DataHelper.Nz_int(qs("noteid"), 0)
            Action = DataHelper.Nz_string(qs("a"))

            HandleAction()

            If Not IsPostBack Then
                Select Case Action
                    Case "a"
                        hdnTempNoteID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()
                    Case Else
                        hdnTempNoteID.Value = 0
                End Select

                GetRelationType()

                LoadDocuments()
            End If
        End If

    End Sub
    Private Sub GetRelationType()
        Using cmd As New SqlCommand("SELECT DocRelation FROM tblRelationType WHERE RelationTypeID = " + RelationTypeID.ToString(), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                AddRelationType = cmd.ExecuteScalar().ToString()
            End Using
        End Using
    End Sub
    Private Sub HandleAction()
        Select Case Action
            Case "a"    'add
                ltrNew.Text = "New&nbsp;"
                Dim now As DateTime = DateTime.Now
                txtCreatedBy.Text = UserHelper.GetName(UserID)
                txtCreatedDate.Text = now.ToShortDateString() '+ " at " + now.ToShortTimeString()
                txtLastModifiedBy.Text = UserHelper.GetName(UserID)
                txtLastModifiedDate.Text = now.ToShortDateString() '+ " at " + now.ToShortTimeString()
            Case Else   'edit
                LoadRecord()
        End Select
    End Sub
    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        SharedFunctions.DocumentAttachment.DeleteAttachment(hdnCurrentDoc.Value, UserID)
        LoadDocuments()
    End Sub
    Private Sub LoadDocuments()

        Dim statusID As String = DataHelper.FieldLookup("tblClient", "CurrentClientstatusid", "ClientID = " + DataClientID.ToString())

        If statusID = "17" Then
            Dim r As New HtmlTableRow
            Dim c As New HtmlTableCell
            Dim p As New HtmlGenericControl("div class=""info""")
            p.InnerHtml = "Documents have been archived."
            c.Controls.Add(p)
            c.ColSpan = 2
            r.Cells.Add(c)
            tblDocuments.Rows.Add(r)
        Else


            If NoteID = 0 Then
                'rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(Integer.Parse(hdnTempNoteID.Value), "note", Request.Url.AbsoluteUri)
                rpDocuments.DataSource = documentHelper.GetDocumentsForRelation(Integer.Parse(hdnTempNoteID.Value), "note", Request.Url.AbsoluteUri)
            Else
                'rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(NoteID, "note", Request.Url.AbsoluteUri)
                rpDocuments.DataSource = documentHelper.GetDocumentsForRelation(NoteID, "note", Request.Url.AbsoluteUri)
            End If

            rpDocuments.DataBind()

            If rpDocuments.DataSource.Count > 0 Then
                hypDeleteDoc.Disabled = False
            Else
                hypDeleteDoc.Disabled = True
            End If
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
            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

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
        If Not Session("Comms_LastURL") Is Nothing Then
            Response.Write("<script>self.location='" & Session("Comms_LastURL").ToString.Replace("'", "%60") & "';</script>")
        Else
            Response.Write("<script>self.location='" & Session("Comms_LastURL") & "';</script>")
        End If
        Session("note_back") = True
    End Sub
    Private Function InsertOrUpdateNote() As Integer

        Dim nh As New NewNoteHelper

        If Action = "a" Then
            NoteID = nh.InsertNote(txtMessage.Text, UserID, DataClientID)
            SharedFunctions.DocumentAttachment.SolidifyTempRelation(hdnTempNoteID.Value, "note", DataClientID, NoteID)

            If RelationTypeID > 1 Then
                nh.RelateNote(NoteID, RelationTypeID, RelationID)
            End If
        Else
            nh.UpdateNote(NoteID, txtMessage.Text, UserID)
        End If

        Return NoteID
    End Function
    Protected Sub lnkCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancel.Click
        SharedFunctions.DocumentAttachment.DeleteAllForItem(hdnTempNoteID.Value, "note", UserID)

        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        Save()

        Close()

    End Sub
    Protected Sub lnkShowDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowDocs.Click
        LoadDocuments()
    End Sub
    Private Sub Save()

        'save record
        InsertOrUpdateNote()

    End Sub
End Class