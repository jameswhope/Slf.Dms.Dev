Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic

Partial Class research_reports_reports
    Inherits SideTabMasterPage
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Research-Reports")
        AddControl(tdTabFinancial, c, "Research-Reports-Financial")
        AddControl(tdTabClients, c, "Research-Reports-Clients")
    End Sub
    Public Overrides Function BaseDir() As String
        Return "~/research/reports/"
    End Function

    Public Overrides Function GetRollups() As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control)
        Dim d As New Dictionary(Of String, Control)

        d.Add(tblRollupViews.ID, tblRollupViews)
        d.Add(tblRollupCommonTasks.ID, tblRollupCommonTasks)
        d.Add(tdRollupRelatedLinks.ID, tdRollupRelatedLinks)

        d.Add(pnlRollupViews.ID, pnlRollupViews)
        d.Add(pnlRollupCommonTasks.ID, pnlRollupCommonTasks)
        d.Add(pnlRollupRelatedLinks.ID, pnlRollupRelatedLinks)

        Return d
    End Function

    Public Overrides Sub AddTabControls(ByVal tabTableCells As System.Collections.Generic.List(Of System.Web.UI.HtmlControls.HtmlTableCell), ByVal tabTables As System.Collections.Generic.List(Of System.Web.UI.HtmlControls.HtmlTable), ByVal tabImages As System.Collections.Generic.List(Of System.Web.UI.HtmlControls.HtmlImage))
        tabTableCells.Add(tdTabClients)
        tabTableCells.Add(tdTabFinancial)

        tabTables.Add(tblTabClients)
        tabTables.Add(tblTabFinancial)

        tabImages.Add(imgTabClients)
        tabImages.Add(imgTabFinancial)
    End Sub
End Class

