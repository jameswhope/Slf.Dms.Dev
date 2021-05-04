
Partial Class research_metrics_clients_default
    Inherits PermissionPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(tblBody, c, "Research-Metrics-Clients")
    End Sub


    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

    End Sub

    Private Function ChildrenInvisible(ByVal c As Control) As Boolean
        For i As Integer = 1 To c.Controls.Count - 1
            Dim child As Control = c.Controls(i)
            If child.Visible Then
                Return False
            End If
        Next
        Return True
    End Function

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete

    End Sub
End Class
