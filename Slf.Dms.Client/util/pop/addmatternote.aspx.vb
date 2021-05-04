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
Partial Class util_pop_addmatternote
    Inherits System.Web.UI.Page
    Private UserID As Integer
    Private UserTypeID As Integer
    Private UserGroupID As Integer
    Private qs As QueryStringCollection
    Public NoteID As Integer
    Public MatterId As Integer
    Public Shadows ClientID As Integer
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        Dim nh As New NewNoteHelper

        NoteID = nh.InsertNote(txtMessage.Text, UserID, ClientID)
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "NoteID", NoteID)
        DatabaseHelper.AddParameter(cmd, "RelationTypeID", 19)
        DatabaseHelper.AddParameter(cmd, "RelationID", MatterId)
        DatabaseHelper.BuildInsertCommandText(cmd, "tblNoteRelation", "NoteRelationId", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
            RegisterClientScriptBlock("onload", "<script> window.onload = function() { CloseMatterNote(); } </script>")

            Using cmd1 As New SqlCommand("UPDATE tblNote SET UserGroupID = " + UserGroupID.ToString() + " WHERE NoteID = " + NoteID.ToString(), ConnectionFactory.Create())
                Using cmd.Connection
                    cmd1.Connection.Open()

                    cmd1.ExecuteNonQuery()
                End Using
            End Using

        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserTypeID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID))
        UserGroupID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupId", "UserId=" & UserID))
        qs = LoadQueryString()
        MatterId = DataHelper.Nz_int(qs("mid"), 0)
        ClientID = DataHelper.Nz_int(qs("id"), 0)
        If Not IsPostBack Then
            Dim now As DateTime = DateTime.Now

            txtCreatedBy.Text = UserHelper.GetName(UserID)
            txtCreatedDate.Text = now.ToShortDateString() + " at " + now.ToShortTimeString()
            txtLastModifiedBy.Text = UserHelper.GetName(UserID)
            txtLastModifiedDate.Text = now.ToShortDateString() + " at " + now.ToShortTimeString()
        End If
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
End Class
