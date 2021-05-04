Option Explicit On

Partial Class tasks_task_propagationsholder
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ifrmBody.Attributes("src") = "propagations.aspx" & Request.Url.Query

    End Sub
End Class