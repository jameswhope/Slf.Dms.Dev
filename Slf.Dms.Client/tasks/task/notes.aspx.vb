
Option Explicit On
Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports Slf.Dms.Records
Imports Drg.Util.DataHelpers
Partial Class tasks_task_notes
    Inherits System.Web.UI.Page

    Private UserID As Integer
    Private qs As QueryStringCollection
    Private TaskID As Integer
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        txtNote.Attributes("onkeydown") = "if (window.event.keyCode == 13) {AddNote(this);return false;}"
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        qs = LoadQueryString()


        If Not qs Is Nothing Then
            TaskID = DataHelper.Nz_int(qs("id"), 0)
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
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Dim Notes As String() = Regex.Split(txtNotes.Value, "\|--\$--\|")
        Dim ClientIDs() As Integer = TaskHelper.GetClients(TaskID)
        For Each Note As String In Notes

            If Note.Length > 0 Then

                'Todo:  Fix ClientID logic.  Defaulting to 0 in order to build
                Dim NoteID As Integer = NoteHelper.InsertNote(Note, UserID, 0)

                'link this note to current task
                TaskHelper.InsertTaskNote(TaskID, NoteID, UserID)

                'link this note to all associated clients, NOT to roadmap
                For Each ClientID As Integer In ClientIDs
                    NoteHelper.RelateNote(NoteID, 1, ClientID)
                Next

            End If

        Next
        RegisterClientScriptBlock("onload", "<script>  CloseNotes();  </script>")
    End Sub
End Class