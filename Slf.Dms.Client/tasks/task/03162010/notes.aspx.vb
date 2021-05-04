Option Explicit On

Partial Class tasks_task_notes
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        txtNote.Attributes("onkeydown") = "if (window.event.keyCode == 13) {AddNote(this);return false;}"
    End Sub
End Class