Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Collections.Generic
'Imports Drg.Utilities

Partial Class Site
    Inherits PermissionMasterPage

#Region "Variables"

    Private UserID As Integer

#End Region

#Region "Properties"

    ReadOnly Property Navigator() As Navigator
        Get

            If Session("Navigator") Is Nothing Then
                Session("Navigator") = New Navigator
            End If

            Return Session("Navigator")

        End Get
    End Property

#End Region

    Public Overrides Sub AddPermissionControls(ByVal c As Dictionary(Of String, Control))
        AddControl(tabAdmin, c, "Admin")
        AddControl(tabAdminBot, c, "Admin")
        AddControl(tabAdminMid, c, "Admin")

        AddControl(tabClients, c, "Clients")
        AddControl(tabClientsBot, c, "Clients")
        AddControl(tabClientsMid, c, "Clients")

        AddControl(tabDefault, c, "Home")
        AddControl(tabDefaultBot, c, "Home")
        AddControl(tabDefaultMid, c, "Home")

        'AddControl(tabEmail, c, "Email")
        'AddControl(tabEmailBot, c, "Email")
        'AddControl(tabEmailMid, c, "Email")

        'AddControl(tabMy, c, "My Account")
        'AddControl(tabMyBot, c, "My Account")
        'AddControl(tabMyMid, c, "My Account")

        AddControl(tabResearch, c, "Research")
        AddControl(tabResearchBot, c, "Research")
        AddControl(tabResearchMid, c, "Research")

        AddControl(tabTasks, c, "Tasks")
        AddControl(tabTasksBot, c, "Tasks")
        AddControl(tabTasksMid, c, "Tasks")

        AddControl(tabCredServ, c, "Creditor Services")
        AddControl(tabCredServBot, c, "Creditor Services")
        AddControl(tabCredServMid, c, "Creditor Services")
	
        AddControl(tabCID, c, "Client Intake")
        AddControl(tabCIDBot, c, "Client Intake")
        AddControl(tabCIDMid, c, "Client Intake")
	
    End Sub

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        SetupTimeout()
        SetTab()
        lblUser.Text = UserHelper.GetName(UserID)

        Page.Header.Databind()


    End Sub

    Private Sub SetupTimeout()

        Dim TimeOut As Integer = CType(StringHelper.ParseDouble(PropertyHelper.Value("ApplicationTimeout"), 0), Integer)

        If TimeOut > 0 Then
            ltrTimeoutJscrpt.Text = "<script type=""text/javascript"">" _
                & "window.StartTimeOut = StartTimeOut; AddHandler(window, ""load"", ""StartTimeOut"");" _
                & "function StartTimeOut()" _
                & "{" _
                & "     window.setTimeout(""PopupTimeOut()"", " & TimeOut & ");" _
                & "}" _
                & "function PopupTimeOut()" _
                & "{" _
                & "     showModalDialog(""" & ResolveUrl("~/util/pop/holder.aspx?t=Timeout Notice&p=") & ResolveUrl("~/util/pop/timeout.aspx") & """, window, ""status:off;help:off;dialogWidth:400px;dialogHeight:225px;"");" _
                & "}" _
                & "</script>"
        Else
            ltrTimeoutJscrpt.Visible = False
        End If

    End Sub

    Private Sub RemoveFromAll(ByVal t As Object(), ByVal i As Integer)
        For Each o As Object In t
            If TypeOf (o) Is List(Of LinkButton) Then
                Dim list As List(Of LinkButton) = CType(o, List(Of LinkButton))
                list(i).Visible = False
                list.RemoveAt(i)
            ElseIf TypeOf (o) Is List(Of HtmlTableCell) Then
                Dim list As List(Of HtmlTableCell) = CType(o, List(Of HtmlTableCell))
                list(i).Visible = False
                list.RemoveAt(i)
            End If
        Next
    End Sub
    Private Sub SetTab()
        Dim path As String = Page.Request.Url.PathAndQuery.Remove(0, ResolveUrl("~").Length)

        Dim segment As String = path.Split("/")(0).ToLower.Replace("negotiation", "credserv")

        If path.Split("/").Length > 1 Then
            If path.Split("/")(1).ToLower = "enrollment" Then
                segment = "cid"
            End If
        End If

        Dim LinkButtons As New List(Of LinkButton)
        Dim TableCellTabs As New List(Of HtmlTableCell)
        Dim TableCellMids As New List(Of HtmlTableCell)
        Dim TableCellBots As New List(Of HtmlTableCell)

        If tabDefault.Visible Then
            TableCellTabs.Add(tabDefault)
            TableCellMids.Add(tabDefaultMid)
            TableCellBots.Add(tabDefaultBot)
            LinkButtons.Add(tabDefaultLnk)
        End If
        If tabClients.Visible Then
            TableCellTabs.Add(tabClients)
            TableCellMids.Add(tabClientsMid)
            TableCellBots.Add(tabClientsBot)
            LinkButtons.Add(tabClientsLnk)
        End If
        If tabResearch.Visible Then
            TableCellTabs.Add(tabResearch)
            TableCellMids.Add(tabResearchMid)
            TableCellBots.Add(tabResearchBot)
            LinkButtons.Add(tabResearchLnk)
        End If
        If tabCID.Visible Then
            TableCellTabs.Add(tabCID)
            TableCellMids.Add(tabCIDMid)
            TableCellBots.Add(tabCIDBot)
            LinkButtons.Add(tabCIDLnk)
        End If
        If tabTasks.Visible Then
            TableCellTabs.Add(tabTasks)
            TableCellMids.Add(tabTasksMid)
            TableCellBots.Add(tabTasksBot)
            LinkButtons.Add(tabTasksLnk)
        End If
        If tabCredServ.Visible Then
            TableCellTabs.Add(tabCredServ)
            TableCellMids.Add(tabCredServMid)
            TableCellBots.Add(tabCredServBot)
            LinkButtons.Add(tabCredServLnk)
        End If
        If tabAdmin.Visible Then
            TableCellTabs.Add(tabAdmin)
            TableCellMids.Add(tabAdminMid)
            TableCellBots.Add(tabAdminBot)
            LinkButtons.Add(tabAdminLnk)
        End If

        Dim SetOne As Boolean
        For i As Integer = 0 To TableCellTabs.Count - 1

            Dim tab As HtmlTableCell = TableCellTabs(i)

            If tab.ID.ToLower = "tab" & segment Then

                tab.Attributes("class") = "tabMainSel"
                TableCellMids(i).Attributes("class") = "tabMidSel"
                TableCellBots(i).Attributes("class") = "tabBotSel"
                LinkButtons(i).CssClass = "tabBtnSel"

                Navigator.Store(LinkButtons(i).Text, Request.Url.AbsoluteUri, Page.Title)

                SetOne = True

            Else

                tab.Attributes("class") = "tabMainUns"
                TableCellBots(i).Attributes("class") = "tabBotUns"
                LinkButtons(i).CssClass = "tabBtnUns"

                If i = 0 Then 'first tab
                    TableCellMids(i).Attributes("class") = "tabMidLeftUns"
                ElseIf i = TableCellTabs.Count - 1 Then 'last tab
                    TableCellMids(i).Attributes("class") = "tabMidRightUns"
                Else
                    TableCellMids(i).Attributes("class") = "tabMidUns"
                End If

            End If

        Next

        If Not SetOne Then 'didn't find a tab, so set the HOME tab

            TableCellTabs(0).Attributes("class") = "tabMainSel"
            TableCellMids(0).Attributes("class") = "tabMidSel"
            TableCellBots(0).Attributes("class") = "tabBotSel"
            LinkButtons(0).CssClass = "tabBtnSel"

            'Navigator.Store(LinkButtons(0).Text, Request.Url.AbsoluteUri, Page.Title)

        End If

    End Sub
    Protected Sub tabDefaultLnk_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles tabDefaultLnk.Click
        Navigate("Home", "~/?nophonebar=1")
    End Sub
    Protected Sub tabClientsLnk_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles tabClientsLnk.Click
        Dim UserTypeId As Integer = DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID)
        If UserTypeId = 2 Then
            Navigate("Clients", "~/clients/new/agencydefault.aspx")
        Else
            Navigate("Clients", "~/clients")
        End If
    End Sub
    Protected Sub tabResearchLnk_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles tabResearchLnk.Click
        Navigate("Research", "~/research")
    End Sub
    Protected Sub tabcidLnk_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles tabCIDLnk.Click
        Navigate("Client Intake", "~/clients/enrollment")
    End Sub
    Protected Sub tabTasksLnk_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles tabTasksLnk.Click
        Navigate("Tasks", "~/tasks")
    End Sub
    Protected Sub tabCredServLnk_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles tabCredServLnk.Click
        Navigate("Creditor Services", "~/negotiation")
    End Sub
    Protected Sub tabAdminLnk_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles tabAdminLnk.Click
        Navigate("Admin", "~/admin")
    End Sub
    Private Sub Navigate(ByVal Menu As String, ByVal [Default] As String)

        Dim m As NavigatorMenu = Nothing

        If Navigator.Menus.TryGetValue(Menu, m) Then
            Response.Redirect(m.LastUrlIn)
        Else
            Response.Redirect([Default])
        End If

    End Sub
    Protected Sub lnkLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLogout.Click

        FormsAuthentication.SignOut()
        Response.Redirect("~/")

    End Sub

End Class