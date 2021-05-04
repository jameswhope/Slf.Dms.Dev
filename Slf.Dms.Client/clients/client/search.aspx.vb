Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Partial Class search
    Inherits PermissionPage

#Region "Variables"
    Private Const PageSize As Integer = 5

    Private ClientPager As SmallPagerWrapper
    Private NotePager As SmallPagerWrapper
    Private CallPager As SmallPagerWrapper

    Dim ResultsClients As Integer
    Dim ResultsNotes As Integer
    Dim ResultsCalls As Integer
    Dim ResultsTasks As Integer

    Dim TabStripPage As Integer

    Private Mode As Byte
    Private Value As String
    Private UserID As Integer
    Private qs As QueryStringCollection
#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        ClientPager = New SmallPagerWrapper(lnkSearchFirstClients, lnkSearchPrevCalls, lnkSearchNextClients, lnkSearchLastClients, labSearchClientsLocation, Context, "cp")
        NotePager = New SmallPagerWrapper(lnkSearchFirstNotes, lnkSearchPrevNotes, lnkSearchNextNotes, lnkSearchLastClients, labSearchNotesLocation, Context, "np")
        CallPager = New SmallPagerWrapper(lnkSearchFirstCalls, lnkSearchPrevCalls, lnkSearchNextCalls, lnkSearchLastCalls, labSearchCallsLocation, Context, "lp")


        If Not qs Is Nothing Then

            Mode = DataHelper.Nz_int(qs("m"))
            Value = DataHelper.Nz_string(qs("q"))

            TabStripPage = DataHelper.Nz_int(qs("tsp"))

        End If

        If Not IsPostBack Then

            LoadTabStrips()

            txtSearch.Text = Value

            Requery()

        End If

        SetAttributes()

    End Sub
    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        'check to make sure that the selected tab has results
        If rpSearchClients.Items.Count = 0 And tsSearch.SelectedIndex = 0 Then 'clients tab selected, 0 results
            AutoSelectFirst()
        ElseIf rpSearchNotes.Items.Count = 0 And tsSearch.SelectedIndex = 1 Then 'notes tab selected, 0 results
            AutoSelectFirst()
        ElseIf rpSearchCalls.Items.Count = 0 And tsSearch.SelectedIndex = 2 Then 'calls tab selected, 0 results
            AutoSelectFirst()
        End If

        'set the proper pane on, others off
        Dim SearchPanes As New List(Of HtmlGenericControl)

        SearchPanes.Add(dvSearch0)
        SearchPanes.Add(dvSearch1)
        SearchPanes.Add(dvSearch2)
        SearchPanes.Add(dvSearch3)
        SearchPanes.Add(dvSearch4)

        For Each SearchPane As HtmlGenericControl In SearchPanes

            If SearchPane.ID.Substring(SearchPane.ID.Length - 1, 1) = tsSearch.SelectedIndex Then
                SearchPane.Style("display") = "inline"
            Else
                SearchPane.Style("display") = "none"
            End If

        Next

    End Sub
    Protected Sub lnkSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearch.Click

        Dim qsb As New QueryStringBuilder(Request.Url.Query)

        If txtSearch.Text.Length > 0 Then
            qsb("q") = txtSearch.Text
        Else
            qsb.Remove("q")
        End If

        If Not tsSearch.SelectedIndex = 0 Then
            qsb("tsp") = tsSearch.SelectedIndex
        Else
            qsb.Remove("tsp")
        End If

        Response.Redirect("~/search.aspx" & IIf(qsb.QueryString.Length > 0, "?" & qsb.QueryString, String.Empty))

    End Sub
#End Region
#Region "Requery"
    Private Sub Requery()

        Dim Values() As String = StringHelper.SplitQuoted(txtSearch.Text, " ", """").ToArray(GetType(String))

        Dim Results As Integer
        Dim ResultsEmail As Integer
        Dim ResultsPersonnel As Integer

        ResultsClients += RequeryClients(Values)
        ResultsNotes += RequeryNotes(Values)
        ResultsCalls += RequeryCalls(Values)
        ResultsTasks += 0
        ResultsEmail += 0
        ResultsPersonnel += 0

        Results = ResultsClients + ResultsNotes + ResultsCalls + ResultsTasks + ResultsEmail + ResultsPersonnel

        'store this search to table
        If txtSearch.Text.Length > 0 Then

            UserHelper.StoreSearch(UserID, txtSearch.Text, Results, ResultsClients, ResultsNotes, _
                ResultsCalls, ResultsTasks, ResultsEmail, ResultsPersonnel)

        End If

    End Sub
    Private Function RequeryClients(ByVal Values() As String) As Integer

        Dim Where As String = String.Empty

        Dim Section As String = String.Empty
        Dim Sections As New List(Of String)

        For Each Value As String In Values

            If Value.ToLower = "and" Then

                'add section to sections
                If Section.Length > 0 Then
                    Sections.Add("(" & Section & ")")
                End If

                'reset section
                Section = String.Empty

            Else

                If Section.Length > 0 Then
                    Section += " OR "
                End If

                Section += "tblclientsearch.[Name] LIKE '%" & Value.Replace("'", "''") & "%' " _
                    & "OR tblclientsearch.[AccountNumber] LIKE '%" & Value.Replace("'", "''") & "%' " _
                    & "OR tblclientsearch.[SSN] LIKE '%" & Value.Replace("'", "''") & "%' " _
                    & "OR tblclientsearch.[Address] LIKE '%" & Value.Replace("'", "''") & "%' " _
                    & "OR tblclientsearch.[ContactNumber] LIKE '%" & Value.Replace("'", "''") & "%'"

            End If

        Next

        'add section to sections
        If Section.Length > 0 Then
            Sections.Add("(" & Section & ")")
        End If

        If Sections.Count > 0 Then
            Where = "WHERE " & String.Join(" AND ", Sections.ToArray())
        Else
            Where = "WHERE 0=1"
        End If

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetClientSearches")

        DatabaseHelper.AddParameter(cmd, "Where", Where)
        DatabaseHelper.AddParameter(cmd, "UserID", UserID)

        Dim ClientSearches As New List(Of ClientSearch)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                ClientSearches.Add(New ClientSearch(DatabaseHelper.Peel_int(rd, "ClientID"), _
                    DatabaseHelper.Peel_string(rd, "ClientStatus"), _
                    DatabaseHelper.Peel_string(rd, "Type"), _
                    DatabaseHelper.Peel_string(rd, "Name"), _
                    DatabaseHelper.Peel_string(rd, "Address"), _
                    DatabaseHelper.Peel_string(rd, "ContactType"), _
                    DatabaseHelper.Peel_string(rd, "ContactNumber"), ResolveUrl("~/")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        PagerHelper.Handle(ClientSearches, rpSearchClients, ClientPager, PageSize)

        pnlSearchClients.Visible = ClientSearches.Count > 0
        pnlNoSearchClients.Visible = ClientSearches.Count = 0

        If ClientSearches.Count > 0 Then

            tsSearch.TabPages(0).Caption = "<font style=""font-weight:bold;"">Clients</font>&nbsp;&nbsp;<font style=""color:blue;"">(" & ClientSearches.Count & ")</font>"

        Else

            tsSearch.TabPages(0).Caption = "Clients"

        End If

        Return ClientSearches.Count

    End Function
    Private Function RequeryNotes(ByVal Values() As String) As Integer

        Dim Where As String = String.Empty

        Dim Section As String = String.Empty
        Dim Sections As New List(Of String)

        For Each Value As String In Values

            If Value.ToLower = "and" Then

                'add section to sections
                If Section.Length > 0 Then
                    Sections.Add("(" & Section & ")")
                End If

                'reset section
                Section = String.Empty

            Else

                If Section.Length > 0 Then
                    Section += " OR "
                End If

                Section += "[Value] LIKE '%" & Value.Replace("'", "''") & "%'"

            End If

        Next

        'add section to sections
        If Section.Length > 0 Then
            Sections.Add("(" & Section & ")")
        End If

        If Sections.Count > 0 Then
            Where = "WHERE " & String.Join(" AND ", Sections.ToArray())
        Else
            Where = "WHERE 0=1"
        End If

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetNotes")

        DatabaseHelper.AddParameter(cmd, "Where", Where)
        DatabaseHelper.AddParameter(cmd, "UserID", UserID)

        Dim NoteSearches As New List(Of NoteSearch)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                NoteSearches.Add(New NoteSearch(DatabaseHelper.Peel_int(rd, "NoteID"), _
                    DatabaseHelper.Peel_string(rd, "Value"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName"), ResolveUrl("~/"), DatabaseHelper.Peel_int(rd, "ClientID")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        PagerHelper.Handle(NoteSearches, rpSearchNotes, NotePager, PageSize)

        pnlSearchNotes.Visible = NoteSearches.Count > 0
        pnlNoSearchNotes.Visible = NoteSearches.Count = 0

        If NoteSearches.Count > 0 Then

            tsSearch.TabPages(1).Caption = "<font style=""font-weight:bold;"">Notes</font>&nbsp;&nbsp;<font style=""color:blue;"">(" & NoteSearches.Count & ")</font>"

        Else

            tsSearch.TabPages(1).Caption = "Notes"

        End If

        Return NoteSearches.Count

    End Function
    Private Function RequeryCalls(ByVal Values() As String) As Integer

        Dim Where As String = String.Empty

        Dim Section As String = String.Empty
        Dim Sections As New List(Of String)

        For Each Value As String In Values

            If Value.ToLower = "and" Then

                'add section to sections
                If Section.Length > 0 Then
                    Sections.Add("(" & Section & ")")
                End If

                'reset section
                Section = String.Empty

            Else

                If Section.Length > 0 Then
                    Section += " OR "
                End If

                Section += "Subject LIKE '%" & Value.Replace("'", "''") & "%' OR " _
                    & "Body LIKE '%" & Value.Replace("'", "''") & "%'"

            End If

        Next

        'add section to sections
        If Section.Length > 0 Then
            Sections.Add("(" & Section & ")")
        End If

        If Sections.Count > 0 Then
            Where = "WHERE " & String.Join(" AND ", Sections.ToArray())
        Else
            Where = "WHERE 0=1"
        End If

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPhoneCalls")

        DatabaseHelper.AddParameter(cmd, "Where", Where)
        DatabaseHelper.AddParameter(cmd, "UserID", UserID)

        Dim PhoneCalls As New List(Of PhoneCall)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                PhoneCalls.Add(New PhoneCall(DatabaseHelper.Peel_int(rd, "PhoneCallID"), _
                    DatabaseHelper.Peel_int(rd, "PersonID"), _
                    DatabaseHelper.Peel_string(rd, "PersonFirstName"), _
                    DatabaseHelper.Peel_string(rd, "PersonLastName"), _
                    DatabaseHelper.Peel_int(rd, "UserID"), _
                    DatabaseHelper.Peel_string(rd, "UserFirstName"), _
                    DatabaseHelper.Peel_string(rd, "UserLastName"), _
                    DatabaseHelper.Peel_string(rd, "PhoneNumber"), _
                    DatabaseHelper.Peel_bool(rd, "Direction"), _
                    DatabaseHelper.Peel_string(rd, "Subject"), _
                    DatabaseHelper.Peel_string(rd, "Body"), _
                    DatabaseHelper.Peel_date(rd, "StartTime"), _
                    DatabaseHelper.Peel_date(rd, "EndTime"), _
                    DatabaseHelper.Peel_int(rd, "ClientID"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName"), ResolveUrl("~/")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        Dim searchCount As Integer = PhoneCalls.Count

        PagerHelper.Handle(PhoneCalls, rpSearchCalls, CallPager, PageSize)

        pnlSearchCalls.Visible = PhoneCalls.Count > 0
        pnlNoSearchCalls.Visible = PhoneCalls.Count = 0

        If PhoneCalls.Count > 0 Then

            tsSearch.TabPages(2).Caption = "<font style=""font-weight:bold;"">Calls</font>&nbsp;&nbsp;<font style=""color:blue;"">(" & PhoneCalls.Count & ")</font>"

        Else

            tsSearch.TabPages(2).Caption = "Calls"

        End If

        Return PhoneCalls.Count

    End Function
#End Region
#Region "Util"
    Private Sub SetAttributes()

        Dim q As String = String.Empty

        If Value.Length > 0 Then
            q = "q=" & HttpUtility.UrlEncode(Value)
        End If

        If Mode = 0 Then

            lnkSimple.Style("font-weight") = "bold"

            lnkAdvanced.Attributes("class") = "lnk"

            If q.Length > 0 Then
                lnkAdvanced.HRef = ResolveUrl("~/search.aspx?m=1&" & q)
            Else
                lnkAdvanced.HRef = ResolveUrl("~/search.aspx?m=1")
            End If

        Else

            lnkAdvanced.Style("font-weight") = "bold"

            lnkSimple.Attributes("class") = "lnk"

            If q.Length > 0 Then
                lnkSimple.HRef = ResolveUrl("~/search.aspx?" & q)
            Else
                lnkSimple.HRef = ResolveUrl("~/search.aspx")
            End If

        End If

        txtSearch.Attributes("onkeydown") = "if (event.keyCode == 13){window.event.returnValue = false;" & ClientScript.GetPostBackEventReference(lnkSearch, Nothing) & ";}"

    End Sub
    Private Sub AutoSelectFirst()

        If rpSearchClients.Items.Count > 0 Then
            tsSearch.SelectedIndex = 0
        Else
            If rpSearchNotes.Items.Count > 0 Then
                tsSearch.SelectedIndex = 1
            Else
                If rpSearchCalls.Items.Count > 0 Then
                    tsSearch.SelectedIndex = 2
                End If
            End If
        End If

    End Sub
    Private Sub LoadTabStrips()

        tsSearch.TabPages.Clear()

        tsSearch.TabPages.Add(New Slf.Dms.Controls.TabPage("Clients", dvSearch0.ClientID))
        tsSearch.TabPages.Add(New Slf.Dms.Controls.TabPage("Notes", dvSearch1.ClientID))
        tsSearch.TabPages.Add(New Slf.Dms.Controls.TabPage("Calls", dvSearch2.ClientID))
        tsSearch.TabPages.Add(New Slf.Dms.Controls.TabPage("Tasks", dvSearch3.ClientID))
        tsSearch.TabPages.Add(New Slf.Dms.Controls.TabPage("Email", dvSearch4.ClientID))
        tsSearch.TabPages.Add(New Slf.Dms.Controls.TabPage("Personnel", dvSearch5.ClientID))

        If TabStripPage > tsSearch.TabPages.Count Then
            tsSearch.TabPages(tsSearch.TabPages.Count - 1).Selected = True
        Else
            tsSearch.TabPages(TabStripPage).Selected = True
        End If

    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""search.aspx""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
#End Region
#Region "Pager Link Events"
    Protected Sub lnkSearchFirstClients_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchFirstClients.Click, lnkSearchFirstNotes.Click
        ClientPager.First()
    End Sub
    Protected Sub lnkSearchLastClients_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchLastClients.Click
        ClientPager.Last()
    End Sub
    Protected Sub lnkSearchNextClients_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchNextClients.Click
        ClientPager.Next()
    End Sub
    Protected Sub lnkSearchPrevClients_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchPrevClients.Click
        ClientPager.Previous()
    End Sub
    Protected Sub lnkSearchFirstNotes_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchFirstNotes.Click
        NotePager.First()
    End Sub
    Protected Sub lnkSearchLastNotes_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchLastNotes.Click
        NotePager.Last()
    End Sub
    Protected Sub lnkSearchNextNotes_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchNextNotes.Click
        NotePager.Next()
    End Sub
    Protected Sub lnkSearchPrevNotes_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchPrevNotes.Click
        NotePager.Previous()
    End Sub
    Protected Sub lnkSearchFirstCalls_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchFirstCalls.Click
        CallPager.First()
    End Sub
    Protected Sub lnkSearchLastCalls_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchLastCalls.Click
        CallPager.Last()
    End Sub
    Protected Sub lnkSearchNextCalls_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchNextCalls.Click
        CallPager.Next()
    End Sub
    Protected Sub lnkSearchPrevCalls_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchPrevCalls.Click
        CallPager.Previous()
    End Sub
#End Region

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Client Search")
        AddControl(pnlMenu, c, "Client Search")

        AddControl(pnlEnrollNewClient, c, "Clients-Client Enrollment")
    End Sub
End Class