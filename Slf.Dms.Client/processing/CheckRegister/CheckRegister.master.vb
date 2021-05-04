Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Partial Class processing_CheckRegister_CheckRegister
    Inherits PermissionMasterPage

#Region "Variables"

    Private _commontasks As List(Of String)
    Public AccountNumber As String

#End Region

#Region "Properties"

    Public ReadOnly Property UserEdit() As Boolean
        Get
            Return Permission.UserEdit(IsMy)
        End Get
    End Property
    Public ReadOnly Property MasterNavigator() As Navigator
        Get
            Return CType(Master, Site).Navigator
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
    
    Public ReadOnly Property DataClientID() As Integer
        Get
            '*******************************************************************
            'BUG ID: 560
            'Fixed By: Bereket S. Data
            'Validate Id before proceeding with subsequent operation.
            '*******************************************************************
            If (IsNumeric(Request.QueryString("id")) = True) Then
                Return DataHelper.Nz_int(Request.QueryString("id"))
            Else
                Return 0
            End If
        End Get
    End Property
    Public ReadOnly Property UserID() As Integer
        Get
            Return DataHelper.Nz_int(Page.User.Identity.Name)
        End Get
    End Property
    Private _IsMy As Nullable(Of Boolean)
    Public ReadOnly Property IsMy() As Integer
        Get
            If Not _IsMy.HasValue Then
                _IsMy = (DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "CreatedBy", "Clientid=" & DataClientID)) = UserID)
            End If
            Return _IsMy
        End Get
    End Property
#End Region

#Region "Methods"
    Public Overrides Sub AddPermissionControls(ByVal c As Dictionary(Of String, Control))
        AddControl(pnlMenu, c, "Clients-Client Single Record")
        AddControl(pnlBody, c, "Clients-Client Single Record")
        AddControl(pnlSearch, c, "Client Search")

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SetTabAndRollup()

        'load search and visit logs
        If Not Request.QueryString("id") Is Nothing AndAlso IsNumeric(Request.QueryString("id")) Then
            'redo search records
            ClientHelper.LoadSearch(DataClientID)

            Dim Display As String = ClientHelper.GetDefaultPersonName(DataClientID)

            If Not Display Is Nothing AndAlso Display.Length > 0 Then

                'redo user visit log
                UserHelper.StoreVisit(UserID, "Client", DataClientID, Display)

            End If

            'LoadQuickInfo()

            AccountNumber = DataHelper.FieldLookup("tblClient", "AccountNumber", "ClientID = " + DataClientId.ToString())
        End If

    End Sub
    Private Sub SetTabAndRollup()

        Dim path As String = Page.Request.Url.LocalPath.Remove(0, ResolveUrl("~").Length)

        Dim segments() As String = path.Split("/")

        Dim segment As String = Nothing
        Dim subsegment As String = Nothing

        If segments.Length = 3 Then

            segment = segments(1).ToLower()
            subsegment = segments(2).ToLower()

        Else

            segment = segments(2).ToLower()
            subsegment = segments(3).ToLower()

        End If

        Dim tabTableCells As New List(Of HtmlTableCell)
        Dim tabTables As New List(Of HtmlTable)
        Dim tabImages As New List(Of HtmlImage)


        Dim qsb As New QueryStringBuilder()

        qsb("id") = New QueryStringBuilder(Request.Url.Query).Item("id")

        Dim qs As String = qsb.QueryString

        If qs.Length > 0 Then
            qs = "?" & qs
        End If

        For i As Integer = 0 To tabTableCells.Count - 1

            Dim td As HtmlTableCell = tabTableCells(i)

            Dim tdsegment As String = tabTableCells(i).ID.ToLower.Remove(0, "tdtab".Length)

            If tdsegment = segment Or (tdsegment = "overview" And segment = "client") Then

                tabTableCells(i).Attributes("class") = "sideTabCellSel"
                tabTables(i).Attributes("class") = "sideTabTableSel"
                tabImages(i).Src = "~/images/16x16_arrowright_clear.png"

            Else

                'stay on web1
                tabTables(i).Attributes("onclick") = "javascript:window.navigate(""" & ResolveUrl("~/clients/client/" _
                    & IIf(tdsegment = "overview", String.Empty, tdsegment & "/") & qs) & """);"
                '*****************************************

                tabTables(i).Attributes("onmouseover") = "javascript:sideTab_OnMouseOver(this);"
                tabTables(i).Attributes("onmouseout") = "javascript:sideTab_OnMouseOut(this);"

                td.Attributes("class") = "sideTabCellUns"
                tabTables(i).Attributes("class") = "sideTabTableUns"
                tabImages(i).Src = "~/images/16x16_arrowright_clearlight.png"

            End If

            'cycle table and set any additional rows 
            For r As Integer = 1 To tabTables(i).Rows.Count - 1

                If tdsegment = segment Or (tdsegment = "overview" And segment = "client") Then 'sel

                    tabTables(i).Rows(r).Attributes.Remove("class")

                    Dim tdc As HtmlTableCell = tabTables(i).Rows(r).Cells(0)

                    If tdc.Controls.Count > 0 Then

                        If TypeOf tdc.Controls(0) Is HtmlAnchor Then

                            Dim lnk As HtmlAnchor = tdc.Controls(0)

                            Dim lnksegment As String = lnk.ID.ToLower.Remove(0, "lnktab".Length)

                            If lnksegment = subsegment Then

                                lnk.Attributes("class") = "sideTabLnkSel"
                                lnk.HRef = String.Empty

                            Else

                                lnk.Attributes("class") = "sideTabLnkUns"
                                lnk.HRef = ResolveUrl("~/clients/client/" & tdsegment & "/" & lnksegment & "/") & qs

                            End If

                        End If

                    End If

                Else 'uns

                    tabTables(i).Rows(r).Attributes("class") = "sideTabTrUns"

                End If

            Next

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

    Public Sub SetUpLegend(ByVal IsVisible As Boolean)
        pnlLegend.Visible = IsVisible
    End Sub
#End Region
End Class

