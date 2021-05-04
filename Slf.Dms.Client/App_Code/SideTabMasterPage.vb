Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports Microsoft.VisualBasic

Public MustInherit Class SideTabMasterPage
    Inherits PermissionMasterPage

    '    Public MustOverride Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
    Public MustOverride Sub AddTabControls(ByVal tabTableCells As List(Of HtmlTableCell), ByVal tabTables As List(Of HtmlTable), ByVal tabImages As List(Of HtmlImage))
    Public MustOverride Function GetRollups() As Dictionary(Of String, Control)
    Public MustOverride Function BaseDir() As String

#Region "Variables"

    Private _addmode As Boolean

    Private _views As List(Of String)
    Private _commontasks As List(Of String)
    Private _relatedlinks As List(Of String)

#End Region

#Region "Properties"

    Public ReadOnly Property Views() As List(Of String)
        Get

            If _views Is Nothing Then
                _views = New List(Of String)
            End If

            Return _views

        End Get
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
    Public Property AddMode() As Boolean
        Get
            Return _addmode
        End Get
        Set(ByVal value As Boolean)
            _addmode = value
        End Set
    End Property

#End Region

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        SetTabAndRollup()
    End Sub

    Private Sub SetTabAndRollup()

        Dim path As String = Page.Request.Url.LocalPath.Remove(0, ResolveUrl("~").Length)

        Dim segments() As String = path.Split("/")
        Dim segment As String = segments(segments.Length - 2).ToLower()

        Dim tabTableCells As New List(Of HtmlTableCell)
        Dim tabTables As New List(Of HtmlTable)
        Dim tabImages As New List(Of HtmlImage)

        AddTabControls(tabTableCells, tabTables, tabImages)

        For i As Integer = 0 To tabTableCells.Count - 1

            Dim td As HtmlTableCell = tabTableCells(i)

            Dim tdsegment As String = tabTableCells(i).ID.ToLower.Remove(0, "tdtab".Length)

            If tdsegment = segment Then
                If tabTableCells(i).Visible = False Then 'curent tab disabled
                    'find first available tab
                    For j As Integer = 0 To tabTableCells.Count - 1
                        If tabTableCells(j).Visible Then
                            'redirect to here
                            Response.Redirect(ResolveUrl(BaseDir & tabTableCells(j).ID.ToLower.Remove(0, "tdtab".Length)))
                        End If
                    Next
                Else
                    tabTableCells(i).Attributes("class") = "sideTabCellSel"
                    tabTables(i).Attributes("class") = "sideTabTableSel"
                    tabImages(i).Src = "~/images/16x16_arrowright_clear.png"
                End If
            Else

                tabTables(i).Attributes("onclick") = "javascript:window.navigate(""" & ResolveUrl(BaseDir & tdsegment) & """);"
                tabTables(i).Attributes("onmouseover") = "javascript:sideTab_OnMouseOver(this);"
                tabTables(i).Attributes("onmouseout") = "javascript:sideTab_OnMouseOut(this);"

                td.Attributes("class") = "sideTabCellUns"
                tabTables(i).Attributes("class") = "sideTabTableUns"
                tabImages(i).Src = "~/images/16x16_arrowright_clearlight.png"

            End If

        Next

        'fill out the rollups
        Dim Rollups As Dictionary(Of String, Control) = GetRollups()
        For Each t As String In Views

            Dim r As New HtmlTableRow()
            Dim c As New HtmlTableCell()

            c.InnerHtml = t

            r.Cells.Add(c)

            CType(Rollups("tblRollupViews"), HtmlTable).Rows.Add(r)

        Next

        For Each t As String In CommonTasks

            Dim r As New HtmlTableRow()
            Dim c As New HtmlTableCell()

            c.InnerHtml = t

            r.Cells.Add(c)

            CType(Rollups("tblRollupCommonTasks"), HtmlTable).Rows.Add(r)

        Next

        For Each l As String In RelatedLinks
            CType(Rollups("tdRollupRelatedLinks"), HtmlTableCell).InnerHtml += l
        Next

        CType(Rollups("pnlRollupViews"), Panel).Visible = Views.Count > 0
        CType(Rollups("pnlRollupCommonTasks"), Panel).Visible = CommonTasks.Count > 0
        CType(Rollups("pnlRollupRelatedLinks"), Panel).Visible = RelatedLinks.Count > 0

    End Sub
End Class
