Imports System.Collections.Generic

Partial Class admin_settlementtrackerimport_trackerimport
    Inherits PermissionMasterPage

    #Region "Fields"

    Private _addPnlBody As Boolean
    Private _commontasks As List(Of String)
    Private _relatedlinks As List(Of String)
    Private _views As List(Of String)

    #End Region 'Fields

    #Region "Properties"

    Public WriteOnly Property AddPnlBody() As Boolean
        Set(ByVal value As Boolean)
            _addPnlBody = value
        End Set
    End Property

    Public ReadOnly Property CommonTasks() As List(Of String)
        Get

            If _commontasks Is Nothing Then
                _commontasks = New List(Of String)
            End If

            Return _commontasks

        End Get
    End Property

    Public ReadOnly Property RelatedLinks() As List(Of String)
        Get

            If _relatedlinks Is Nothing Then
                _relatedlinks = New List(Of String)
            End If

            Return _relatedlinks

        End Get
    End Property

    Public ReadOnly Property Views() As List(Of String)
        Get

            If _views Is Nothing Then
                _views = New List(Of String)
            End If

            Return _views

        End Get
    End Property

    #End Region 'Properties

    #Region "Methods"

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        If _addPnlBody Then
            AddControl(pnlBody, c, "Admin-SettlementTrackerImports")
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SetTabAndRollup()
    End Sub

    Private Sub SetTabAndRollup()
        Dim path As String = Page.Request.Url.LocalPath.Remove(0, ResolveUrl("~").Length)

        Dim segments() As String = path.Split("/")
        Dim segment As String = segments(segments.Length - 2).ToLower()

        Dim tabTableCells As New List(Of HtmlTableCell)
        Dim tabTables As New List(Of HtmlTable)
        Dim tabImages As New List(Of HtmlImage)

        tabTableCells.Add(tdTabReports)
        tabTableCells.Add(tdTabMaster)

        tabTables.Add(tblTabReports)
        tabTables.Add(tblTabMaster)

        tabImages.Add(imgTabReports)
        tabImages.Add(imgTabMaster)

        For i As Integer = 0 To tabTableCells.Count - 1
            Dim td As HtmlTableCell = tabTableCells(i)
            Dim tdsegment As String = tabTableCells(i).ID.ToLower.Remove(0, "tdtab".Length)
            If tdsegment = segment Then
                tabTableCells(i).Attributes("class") = "sideTabCellSel"
                tabTables(i).Attributes("class") = "sideTabTableSel"
                tabImages(i).Src = "~/images/16x16_arrowright_clear.png"
            Else
                tabTables(i).Attributes("onclick") = "javascript:window.navigate(""" & ResolveUrl("~/admin/settlementtrackerimport/" & tdsegment) & """);"
                tabTables(i).Attributes("onmouseover") = "javascript:sideTab_OnMouseOver(this);"
                tabTables(i).Attributes("onmouseout") = "javascript:sideTab_OnMouseOut(this);"
                td.Attributes("class") = "sideTabCellUns"
                tabTables(i).Attributes("class") = "sideTabTableUns"
                tabImages(i).Src = "~/images/16x16_arrowright_clearlight.png"
            End If
        Next
        'fill out the rollups
        For Each t As String In CommonTasks
            Dim r As New HtmlTableRow()
            Dim c As New HtmlTableCell()
            c.InnerHtml = t
            r.Cells.Add(c)
            tblRollupCommonTasks.Rows.Add(r)
        Next
        pnlRollupCommonTasks.Visible = CommonTasks.Count > 0
    End Sub
#End Region 'Methods

End Class