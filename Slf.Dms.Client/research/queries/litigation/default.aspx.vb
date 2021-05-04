
Partial Class research_queries_matter_default
    Inherits PermissionPage

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(tblBody, c, "Research-Queries-Litigation")

        AddControl(tblMatters, c, "Research-Queries-Litigation")

        AddControl(trAllMatters, c, "Research-Queries-Litigation-Matters-All Matters")
       
    End Sub
End Class
