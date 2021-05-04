Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Partial Class admin_users_user_history_default
    Inherits PermissionPage


#Region "Variables"

    Private Const PageSize As Integer = 10

    Private VisitsPageIndex As Integer
    Private SearchesPageIndex As Integer

    Dim ResultsVisits As Integer
    Dim ResultsSearches As Integer

    Private UserID As Integer
    Private RecordUserID As Integer
    Private qs As QueryStringCollection

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            RecordUserID = DataHelper.Nz_int(qs("id"))
            VisitsPageIndex = DataHelper.Nz_int(qs("vp"))
            SearchesPageIndex = DataHelper.Nz_int(qs("sp"))

        End If

        If Not IsPostBack Then

            LoadTabStrips()
            Requery()

            lnkUser.InnerHtml = UserHelper.GetName(RecordUserID)
            lnkUser.HRef = ResolveUrl("~/admin/users/user/?id=" & RecordUserID)

        End If

        SetRollups()
        SetAttributes()

    End Sub
    Private Sub Requery()

        Dim Results As Integer

        ResultsVisits += RequeryVisits()
        ResultsSearches += RequerySearches()

        Results = ResultsVisits + ResultsSearches

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = CType(Master, admin_users_user_user).CommonTasks

        'add applicant tasks
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_clear.png") & """ align=""absmiddle""/>Clear all history</a>")

    End Sub
    Private Sub SetAttributes()


    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        'set the proper pane on, others off
        Dim Panes As New List(Of HtmlGenericControl)

        Panes.Add(dvHistory0)
        Panes.Add(dvHistory1)

        For Each Pane As HtmlGenericControl In Panes

            If Pane.ID.Substring(Pane.ID.Length - 1, 1) = tsHistory.SelectedIndex Then
                Pane.Style("display") = "inline"
            Else
                Pane.Style("display") = "none"
            End If

        Next

    End Sub
    Private Sub LoadTabStrips()

        tsHistory.TabPages.Clear()

        tsHistory.TabPages.Add(New Slf.Dms.Controls.TabPage("Visits", dvHistory0.ClientID))
        tsHistory.TabPages.Add(New Slf.Dms.Controls.TabPage("Searches", dvHistory1.ClientID))

    End Sub
    Private Function RequeryVisits() As Integer

        Dim UserVisits As New List(Of UserVisit)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblUserVisit WHERE UserID = @UserID ORDER BY Visit DESC"

            DatabaseHelper.AddParameter(cmd, "UserID", RecordUserID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        UserVisits.Add(New UserVisit(DatabaseHelper.Peel_int(rd, "UserVisitID"), _
                            DatabaseHelper.Peel_int(rd, "UserID"), _
                            DatabaseHelper.Peel_string(rd, "Type"), _
                            DatabaseHelper.Peel_int(rd, "TypeID"), _
                            DatabaseHelper.Peel_string(rd, "Display"), _
                            DatabaseHelper.Peel_date(rd, "Visit")))

                    End While

                End Using
            End Using
        End Using

        Dim searchCount As Integer = UserVisits.Count

        If UserVisits.Count > 0 Then

            If VisitsPageIndex * PageSize > (UserVisits.Count + UserVisits.Count Mod 2) Then
                VisitsPageIndex = 0
            End If

            If VisitsPageIndex = -1 Then

                VisitsPageIndex = ((UserVisits.Count + UserVisits.Count Mod 2) \ PageSize) - 1

                SetSearchPage(VisitsPageIndex, "vp")

            End If

            If VisitsPageIndex = 0 Then
                lnkFirstVisit.Enabled = False
                lnkPrevVisit.Enabled = False
            End If

            If VisitsPageIndex = ((UserVisits.Count + UserVisits.Count Mod 2) \ PageSize) - 1 Then
                lnkLastVisit.Enabled = False
                lnkNextVisit.Enabled = False
            End If

            If UserVisits.Count <= PageSize Then
                lnkFirstVisit.Visible = False
                lnkNextVisit.Visible = False
                lnkLastVisit.Visible = False
                lnkPrevVisit.Visible = False
                labLocationVisits.Visible = False
            End If

            labLocationVisits.Text = " Page " + (VisitsPageIndex + 1).ToString() + " of " + ((UserVisits.Count + UserVisits.Count Mod 2) \ PageSize).ToString()

            SetPage(UserVisits, VisitsPageIndex, PageSize)

            rpVisits.DataSource = UserVisits
            rpVisits.DataBind()

        End If

        pnlVisits.Visible = UserVisits.Count > 0
        pnlNoVisits.Visible = UserVisits.Count = 0

        If UserVisits.Count > 0 Then
            tsHistory.TabPages(0).Caption = "<font style=""font-weight:normal;"">Visits</font>&nbsp;&nbsp;<font style=""color:blue;"">(" & searchCount & ")</font>"
        Else
            tsHistory.TabPages(0).Caption = "Users"
        End If

        Return searchCount

    End Function
    Private Function RequerySearches() As Integer

        Dim UserSearches As New List(Of UserSearch)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = "SELECT * FROM tblUserSearch WHERE UserID = @UserID ORDER BY Search DESC"

            DatabaseHelper.AddParameter(cmd, "UserID", RecordUserID)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        UserSearches.Add(New UserSearch(DatabaseHelper.Peel_int(rd, "UserSearchID"), _
                            DatabaseHelper.Peel_int(rd, "UserID"), _
                            DatabaseHelper.Peel_date(rd, "Search"), _
                            DatabaseHelper.Peel_string(rd, "Terms"), _
                            DatabaseHelper.Peel_int(rd, "Results"), _
                            DatabaseHelper.Peel_int(rd, "ResultsClients"), _
                            DatabaseHelper.Peel_int(rd, "ResultsNotes"), _
                            DatabaseHelper.Peel_int(rd, "ResultsCalls"), _
                            DatabaseHelper.Peel_int(rd, "ResultsTasks"), _
                            DatabaseHelper.Peel_int(rd, "ResultsEmail"), _
                            DatabaseHelper.Peel_int(rd, "ResultsPersonnel")))

                    End While

                End Using
            End Using
        End Using

        Dim searchCount As Integer = UserSearches.Count

        If UserSearches.Count > 0 Then

            If SearchesPageIndex * PageSize > (UserSearches.Count + UserSearches.Count Mod 2) Then
                SearchesPageIndex = 0
            End If

            If SearchesPageIndex = -1 Then

                SearchesPageIndex = ((UserSearches.Count + UserSearches.Count Mod 2) \ PageSize) - 1

                SetSearchPage(SearchesPageIndex, "sp")

            End If

            If SearchesPageIndex = 0 Then
                lnkFirstSearch.Enabled = False
                lnkPrevSearch.Enabled = False
            End If

            If SearchesPageIndex = ((UserSearches.Count + UserSearches.Count Mod 2) \ PageSize) - 1 Then
                lnkLastSearch.Enabled = False
                lnkNextSearch.Enabled = False
            End If

            If UserSearches.Count <= PageSize Then
                lnkFirstVisit.Visible = False
                lnkNextVisit.Visible = False
                lnkLastVisit.Visible = False
                lnkPrevVisit.Visible = False
                labLocationVisits.Visible = False
            End If

            labLocationSearches.Text = " Page " + (SearchesPageIndex + 1).ToString() + " of " + ((UserSearches.Count + UserSearches.Count Mod 2) \ PageSize).ToString()

            SetPage(UserSearches, SearchesPageIndex, PageSize)

            rpSearches.DataSource = UserSearches
            rpSearches.DataBind()

        End If

        pnlSearches.Visible = UserSearches.Count > 0
        pnlNoSearches.Visible = UserSearches.Count = 0

        If UserSearches.Count > 0 Then
            tsHistory.TabPages(1).Caption = "<font style=""font-weight:normal;"">Searches</font>&nbsp;&nbsp;<font style=""color:blue;"">(" & searchCount & ")</font>"
        Else
            tsHistory.TabPages(1).Caption = "Searches"
        End If

        Return searchCount

    End Function
    Private Sub SetPage(ByVal col As IList, ByVal index As Integer, ByVal size As Integer)

        For i As Integer = col.Count - 1 To (index + 1) * size Step -1
            col.RemoveAt(i)
        Next i

        For i As Integer = Math.Min(index * size - 1, col.Count - 1) To 0 Step -1
            col.RemoveAt(i)
        Next i

    End Sub
    Private Sub SetSearchPage(ByVal index As Integer, ByVal type As String)

        Dim qsb As New QueryStringBuilder(Request.Url.Query)

        qsb(type) = index.ToString()

        Response.Redirect("default.aspx" & IIf(qsb.QueryString.Length > 0, "?" & qsb.QueryString, String.Empty))

    End Sub
    Protected Sub lnkFirstVisit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFirstVisit.Click
        SetSearchPage(0, "vp")
    End Sub
    Protected Sub lnkLastVisit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLastVisit.Click
        SetSearchPage(-1, "vp")
    End Sub
    Protected Sub lnkNextVisit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNextVisit.Click
        SetSearchPage(VisitsPageIndex + 1, "vp")
    End Sub
    Protected Sub lnkPrevVisit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrevVisit.Click
        SetSearchPage(VisitsPageIndex - 1, "vp")
    End Sub
    Protected Sub lnkFirstSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkFirstSearch.Click
        SetSearchPage(0, "sp")
    End Sub
    Protected Sub lnkLastSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLastSearch.Click
        SetSearchPage(-1, "sp")
    End Sub
    Protected Sub lnkNextSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNextSearch.Click
        SetSearchPage(SearchesPageIndex + 1, "sp")
    End Sub
    Protected Sub lnkPrevSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkPrevSearch.Click
        SetSearchPage(SearchesPageIndex - 1, "sp")
    End Sub
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Private Sub Refresh()
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub
    Private Sub Close()
        Response.Redirect("~/admin/users/")
    End Sub
    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click

        UserVisitHelper.DeleteForUser(RecordUserID)
        UserSearchHelper.DeleteForUser(RecordUserID)

        Refresh()

    End Sub
    Protected Sub lnkDeleteSearches_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteSearches.Click

        If txtSelectedSearches.Value.Length > 0 Then

            'get selected "," delimited UserSearches's
            Dim UserSearches() As String = txtSelectedSearches.Value.Split(",")

            'build an actual integer array
            Dim UserSearchIDs As New List(Of Integer)

            For Each UserSearch As String In UserSearches
                UserSearchIDs.Add(DataHelper.Nz_int(UserSearch))
            Next

            'delete array of UserSearchIDs's
            UserSearchHelper.Delete(UserSearchIDs.ToArray())

        End If

        Refresh()

    End Sub
    Protected Sub lnkDeleteVisits_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteVisits.Click

        If txtSelectedVisits.Value.Length > 0 Then

            'get selected "," delimited UserVisit's
            Dim UserVisits() As String = txtSelectedVisits.Value.Split(",")

            'build an actual integer array
            Dim UserVisitIDs As New List(Of Integer)

            For Each UserVisit As String In UserVisits
                UserVisitIDs.Add(DataHelper.Nz_int(UserVisit))
            Next

            'delete array of UserVisitID's
            UserVisitHelper.Delete(UserVisitIDs.ToArray())

        End If

        Refresh()

    End Sub
    Protected Sub lnkClearSearches_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClearSearches.Click

        UserSearchHelper.DeleteForUser(RecordUserID)

        Refresh()

    End Sub
    Protected Sub lnkClearVisits_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClearVisits.Click

        UserVisitHelper.DeleteForUser(RecordUserID)

        Refresh()

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Users-User Single Record-History")
    End Sub
End Class