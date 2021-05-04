
Partial Class research_queries_clients_default
    Inherits PermissionPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(tblBody, c, "Research-Queries-Clients")

        AddControl(tblDemographics, c, "Research-Queries-Clients-Demographics")
        AddControl(trSimpleOverview, c, "Research-Queries-Clients-Demographics-Simple Overview")

        AddControl(tblMyClients, c, "Research-Queries-Clients-My Clients")
        AddControl(trMyClients, c, "Research-Queries-Clients-Agency")
        AddControl(trMyClientsAttorney, c, "Research-Queries-Clients-Attorney")
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
        tblMyClients.Visible = Not ChildrenInvisible(tblMyClients)
    End Sub
End Class
