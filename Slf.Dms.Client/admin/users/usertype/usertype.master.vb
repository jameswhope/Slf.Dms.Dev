Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports System.Collections.Generic

Partial Class admin_users_usertype_usertype
    Inherits PermissionMasterPage


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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SetTabAndRollup()
    End Sub
    Private Sub SetTabAndRollup()

        Dim path As String = Page.Request.Url.LocalPath.Remove(0, ResolveUrl("~").Length)

        Dim segments() As String = path.Split("/")
        Dim segment As String = segments(segments.Length - 2).ToLower()

        Dim tabTableRows As New List(Of HtmlTableRow)
        Dim tabTableCells As New List(Of HtmlTableCell)
        Dim tabTables As New List(Of HtmlTable)
        Dim tabImages As New List(Of HtmlImage)

        tabTableRows.Add(trTabGeneralInfo)
        tabTableRows.Add(trTabPermissions)
        tabTableRows.Add(trTabMembers)

        tabTableCells.Add(tdTabGeneralInfo)
        tabTableCells.Add(tdTabPermissions)
        tabTableCells.Add(tdTabMembers)

        tabTables.Add(tblTabGeneralInfo)
        tabTables.Add(tblTabPermissions)
        tabTables.Add(tblTabMembers)

        tabImages.Add(imgTabGeneralInfo)
        tabImages.Add(imgTabPermissions)
        tabImages.Add(imgTabMembers)


        If _addmode Then 'only show general info and make it highlighted

            Dim DefaultRowIndex As Integer = 0

            For i As Integer = 0 To tabTableRows.Count - 1
                If Not i = DefaultRowIndex Then
                    tabTableRows(i).Visible = False
                End If
            Next

            tabTableCells(DefaultRowIndex).Attributes("class") = "sideTabCellSel"
            tabTables(DefaultRowIndex).Attributes("class") = "sideTabTableSel"
            tabImages(DefaultRowIndex).Src = "~/images/16x16_arrowright_clear.png"

        Else

            Dim qsb As New QueryStringBuilder()

            qsb("id") = New QueryStringBuilder(Request.Url.Query).Item("id")

            Dim qs As String = qsb.QueryString

            If qs.Length > 0 Then
                qs = "?" & qs
            End If

            Dim Found As Boolean = False

            For i As Integer = 0 To tabTableCells.Count - 1

                Dim td As HtmlTableCell = tabTableCells(i)

                Dim tdsegment As String = tabTableCells(i).ID.ToLower.Remove(0, "tdtab".Length)

                If tdsegment = segment Then

                    tabTableCells(i).Attributes("class") = "sideTabCellSel"
                    tabTables(i).Attributes("class") = "sideTabTableSel"
                    tabImages(i).Src = "~/images/16x16_arrowright_clear.png"

                    Found = True

                Else

                    tabTables(i).Attributes("onclick") = "javascript:window.navigate(""" & ResolveUrl("~/admin/users/usertype/" _
                        & IIf(tdsegment = "generalinfo", String.Empty, tdsegment & "/") & qs) & """);"

                    tabTables(i).Attributes("onmouseover") = "javascript:sideTab_OnMouseOver(this);"
                    tabTables(i).Attributes("onmouseout") = "javascript:sideTab_OnMouseOut(this);"

                    td.Attributes("class") = "sideTabCellUns"
                    tabTables(i).Attributes("class") = "sideTabTableUns"
                    tabImages(i).Src = "~/images/16x16_arrowright_clearlight.png"

                End If

            Next

            If Not Found Then

                tabTables(0).Attributes.Remove("onclick")
                tabTables(0).Attributes.Remove("onmouseover")
                tabTables(0).Attributes.Remove("onmouseout")

                tabTableCells(0).Attributes("class") = "sideTabCellSel"
                tabTables(0).Attributes("class") = "sideTabTableSel"
                tabImages(0).Src = "~/images/16x16_arrowright_clear.png"

            End If

        End If

        'fill out the rollups
        For Each t As String In Views

            Dim r As New HtmlTableRow()
            Dim c As New HtmlTableCell()

            c.InnerHtml = t

            r.Cells.Add(c)

            tblRollupViews.Rows.Add(r)

        Next

        For Each t As String In CommonTasks

            Dim r As New HtmlTableRow()
            Dim c As New HtmlTableCell()

            c.InnerHtml = t

            r.Cells.Add(c)

            tblRollupCommonTasks.Rows.Add(r)

        Next

        For Each l As String In RelatedLinks
            tdRollupRelatedLinks.InnerHtml += l
        Next

        pnlRollupViews.Visible = Views.Count > 0
        pnlRollupCommonTasks.Visible = CommonTasks.Count > 0
        pnlRollupRelatedLinks.Visible = RelatedLinks.Count > 0

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Admin-Users-User Type Single Record")
        AddControl(trTabGeneralInfo, c, "Admin-Users-User Type Single Record-General Information")
        AddControl(trTabPermissions, c, "Admin-Users-User Type Single Record-Permissions")
    End Sub
End Class