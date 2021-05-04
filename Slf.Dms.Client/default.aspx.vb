Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Client.Agent
Imports System.Linq
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic
Imports LocalHelper
Imports Slf.Dms.Controls
Imports System.IO
Imports System.Xml.Linq


Partial Class _default
    Inherits PermissionPage
    Implements System.Web.UI.ICallbackEventHandler

#Region "Variables"
    Public QueryString As String
    Public Mode As String = String.Empty
    Public tabIndex As Int16 = 0
    Public UserID As Integer
    Public UserTypeId As Integer
    Public UserGroupId As Integer
    Public AgencyId As Integer = -1
    Public AttorneyID As Integer = -1
    Public CommRecId As String
    Public companyName As String
    'Added to check user is a manager
    Public UserIsManager As Boolean
    Private qs As QueryStringCollection

#End Region

    Public Structure GridTask
        Dim TaskID As Integer
        Dim TaskType As String
        Dim ClientID As Integer
        Dim Client As String
        Dim TaskDescription As String
        Dim CreatedBy As String
        Dim AssignedTo As String
        Dim AssignedToGroupName As String
        Dim intAssignedToId As Integer
        Dim intAssignedToGroupId As Integer
        Dim StartDate As DateTime
        Dim DueDate As DateTime
        Dim ResolvedDate As Nullable(Of DateTime)
        Dim TaskResolutionId As Integer
        'Dim Duration As String
        Dim Value As String
        Dim Color As String
        Dim TextColor As String
        Dim BodyColor As String
        Dim Language As String
        Dim ClientState As String

        ReadOnly Property AssignedToId() As Integer
            Get
                Return intAssignedToId
            End Get
        End Property

        ReadOnly Property AssignedToGroupId() As Integer
            Get
                Return intAssignedToGroupId
            End Get
        End Property

        ReadOnly Property Status() As String
            Get

                If ResolvedDate.HasValue Then
                    If TaskResolutionId = 1 Then
                        'Return "RESOLVED"
                        Return "<font style=""color:rgb(0,129,0);"">RESOLVED</font>"
                    Else 'If TaskResolutionID = 5 Then
                        'Return "IN PROGRESS"
                        Return "<font style=""color:rgb(0,0,255);"">IN PROGRESS</font>"
                    End If
                Else
                    If DueDate < Now Then
                        'Return "PAST DUE"
                        Return "<font style=""color:red;"">PAST DUE</font>"
                    Else
                        'Return "OPEN"
                        Return "<font style=""color:rgb(0,0,159);"">OPEN</font>"
                    End If

                End If

            End Get
        End Property

        ReadOnly Property Duration() As String
            Get

                If ResolvedDate.HasValue Then
                    Dim Dur As TimeSpan
                    Dur = ResolvedDate - StartDate

                    'Return Math.Round(Dur.TotalHours, 2).ToString()
                    Return Dur.Days & "d:" & Dur.Hours & "h:" & Dur.Minutes & "m:" & Dur.Seconds & "s"

                Else
                    Return " "

                End If

            End Get
        End Property


    End Structure

    Public Function GetPage(ByVal type As String) As String
        Return type
    End Function
    Public Function GetImage(ByVal type As String) As String
        Select Case type
            Case "note"
                Return ResolveUrl("~/images/16x16_note.png")
            Case "email"
                Return ResolveUrl("~/images/16x16_email_read.png")
        End Select
        Return String.Empty
    End Function
    Public Function GetQSID(ByVal type As String) As String
        Select Case type
            Case "note"
                Return "nid"
            Case "email"
                Return "eid"
        End Select
        Return String.Empty
    End Function
    Public Overrides Sub AddPermissionControls(ByVal c As Dictionary(Of String, Control))

        AddControl(phBatches, c, "Research-Reports-Financial-Commission-Batch Payments-Agency")
        AddControl(phAgencyScenarios, c, "Home-Agency Scenarios")
        AddControl(phMenuBatchPayment, c, "Research-Reports-Financial-Commission-Batch Payments-Agency")
        'AddControl(phReceivables, c, "Home-Receivables")
        AddControl(phMenuServiceFees, c, "Research-Reports-Financial-Service Fees-Agency")
        AddControl(pnlSearchMyClients, c, "Research-Queries-Clients-Agency")
        'AddControl(phMoneyCharts, c, "Home-Charts-Money")

        AddControl(pnlMenuAttorney, c, "Home-Attorney Controls")
        'AddControl(phRightSidebar, c, "Home-Right Sidebar")

        AddControl(phSearchMyClientsAttorney, c, "Research-Queries-Clients-Attorney")
        AddControl(pnlMenuAgent, c, "Home-Agency Controls")
        'AddControl(phAgencyCharts, c, "Home-Agency Controls")

        AddControl(pnlMenuAgency, c, "Home-Agency Menu")

        AddControl(phTasks, c, "Home-Default Controls-Tasks")
        AddControl(pnlMenuDefault, c, "Home-Default Controls")
        AddControl(phRecentVisits, c, "Home-Default Controls")
        AddControl(phMasterFinancialAgency, c, "Home-Default Controls")
        AddControl(phCommunication, c, "Home-Default Controls-Communication")

        AddControl(phStatistics, c, "Home-Statistics")
        AddControl(dvStats0, c, "Home-Statistics-Master Financial")
        AddControl(dvStats1, c, "Home-Statistics-Financial")
        AddControl(dvStats2, c, "Home-Statistics-Clients")
        AddControl(dvStats3, c, "Home-Statistics-Global Roadmap")


        AddControl(pnlTrustAccounts, c, "Home-Statistics-Financial-Trust Account")
        AddControl(pnlFeesAndPayments, c, "Home-Statistics-Financial-Client Fees and Payments")
        AddControl(pnlDeposits, c, "Home-Statistics-Financial-Client Deposits")
        AddControl(pnlCommission, c, "Home-Statistics-Financial-Agent Fees Paid")

        AddControl(pnlValidateCreditors, c, "Home-Validate Creditors")
        'AddControl(phDefaultCharts, c, "Home-Default Controls")

        AddControl(pnlEnrollNewClient, c, "Clients-Client Enrollment")
        AddControl(tdAddNewTask, c, "Tasks-Add New Task")

        AddControl(tdSearch, c, "Client Search")
        AddControl(pnlSearch, c, "Client Search")
        AddControl(pnlSearchTasks, c, "Client Search-Tasks")
        AddControl(pnlSearchCommunication, c, "Client Search-Communication")
        'AddControl(phClientsPendingReview, c, "Home-Clients Pending Review")
        AddControl(phClientsIncompleteData, c, "Home-Clients Rejected by DE")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim useMobileSite As Boolean = False

        If Not IsNothing(Session("UseMobileSite")) Then
            If CStr(Session("UseMobileSite")) = "1" Then
                useMobileSite = True
            End If
        End If

        If useMobileSite Then
            Response.Redirect("mobile/home.aspx")
        Else
            Response.CacheControl = "no-cache"
            Response.AddHeader("Pragma", "no-cache")
            Response.Expires = -1

            tsStatistics.TabPages.Clear()

            UserID = DataHelper.Nz_int(Page.User.Identity.Name)
            CommRecId = CStr(DataHelper.Nz_int(DataHelper.FieldLookup("tblUser", "CommRecId", "UserId = " & UserID), 0))
            UserTypeId = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId = " & UserID))
            UserGroupId = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupId", "UserId = " & UserID))
            'Added to check user is a manager - Manager field in tblUser
            UserIsManager = Boolean.Parse(DataHelper.FieldLookup("tblUser", "Manager", "UserId = " & UserID))

            qs = LoadQueryString()

            PrepQuerystring()

            If Not qs Is Nothing Then
                Mode = DataHelper.Nz_string(qs("mode"))
            End If

            Dim url As String = DataHelper.FieldLookup("tblUserGroup", "DefaultPage", "UserGroupID = " & UserGroupId)
            If url <> "" Then
                'Temp workaround for dup phone bar
                If Not Request.QueryString("nophonebar") Is Nothing AndAlso Request.QueryString("nophonebar").ToString = "1" Then url = url.Replace("Main3.aspx", "default.aspx")
                Response.Redirect(url)
            End If

            If Not IsPostBack Then
                ddlCompany.Visible = False

                phSwitchGroup.Visible = SwitchGroupHelper.UserHasGroups(UserID)


                Dim cmpName As String
                Dim userPerm As Integer = UserID

                Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                    Using cmd.Connection
                        cmd.CommandText = "SELECT isnull(UserGroupID, 3) FROM tblUser WHERE UserID = " + UserID.ToString()
                        cmd.Connection.Open()
                        Dim permission As Integer = cmd.ExecuteScalar()
                        If permission = 6 Or permission = 11 Or permission = 20 Then
                            userPerm = -2
                            ddlCommRec.Items.Clear()

                            Dim rec As Integer
                            Dim abbr As String
                            Dim allrecs As String

                            cmd.CommandText = "SELECT CommRecID, Abbreviation FROM tblCommRec WHERE CompanyID is null"
                            Using recRead As IDataReader = cmd.ExecuteReader()
                                While recRead.Read()
                                    rec = DatabaseHelper.Peel_int(recRead, "CommRecID")
                                    abbr = DatabaseHelper.Peel_string(recRead, "Abbreviation")
                                    ddlCommRec.Items.Add(New ListItem(abbr, rec, True))
                                    allrecs += "," + rec.ToString()
                                End While
                            End Using

                            ddlCommRec.Items.Add(New ListItem("ALL", allrecs.Substring(1), True))

                            ddlCommRec.Visible = True
                        Else
                            userPerm = UserID
                            ddlCommRec.Visible = False
                        End If

                        If permission = 6 Or permission = 11 Or permission = 16 Or permission = 17 Or permission = 20 Then
                            ddlCompany.Items.Clear()

                            cmd.CommandText = "SELECT isnull(CompanyIDs, 0) FROM tblUserCompany WHERE UserID = " + userPerm.ToString()
                            Dim companies() As String = cmd.ExecuteScalar().ToString().Split(",")
                            For Each cmp As Integer In companies
                                cmd.CommandText = "SELECT lower(ShortCoName) FROM tblCompany WHERE CompanyID = " + cmp.ToString()
                                cmpName = cmd.ExecuteScalar()
                                ddlCompany.Items.Add(New ListItem(StrConv(cmpName, VbStrConv.ProperCase), cmpName, True))
                            Next

                            ddlCompany.Items.Add(New ListItem("ALL", "all", True))
                        End If
                    End Using
                End Using

                ddlCompany.Visible = True

                LoadFinancialCompanyList()
                LoadFinancialAgencyList()
            End If

            If UserTypeId = 5 Then
                AttorneyID = Integer.Parse(DataHelper.FieldLookup("tblAttorney", "AttorneyID", "UserId=" & UserID))
            ElseIf UserTypeId = 2 Then
                AgencyId = Integer.Parse(DataHelper.FieldLookup("tblUser", "AgencyID", "UserId=" & UserID))
                LoadClientsIncompleteData()
            ElseIf UserTypeId = 1 Then

                'load stuff for internal users
                If Not IsPostBack And Not IsCallback Then
                    LoadUpcomingTasks()
                    LoadTeamTasks()

                    'Code Commented on 08 FEB 2010 
                    'To disable to the feature displaying Tasks Created By Manager
                    'If UserIsManager Then
                    '    LoadManagerTasks()
                    'End If
                    'End of Code Commented on 08 FEB 2010

                    'If Mode = "E" Then
                    '    LoadAllEmails()
                    'ElseIf Mode = "N" Then
                    '    LoadAllNotes()
                    'Else
                    '    LoadAllCommunication()
                    'End If
                    phCommunication.Visible = False

                    LoadSearches()
                    LoadVisits()
                End If
                'LoadClientsPendingReview()
            End If

            If Not IsPostBack And Not IsCallback Then
                LoadValues(GetControls(), Me)
                LoadQuickPickDates()
                LoadMonthOffset()
                'LoadRecipients()
                'If Not AgencyId = -1 Then ListHelper.SetSelected(ddlMasterFinancialRecipient, AgencyId)
                LoadGlobalRoadmap()
                LoadRemainingReceivables()
                SetAttributes()
            End If

            If UserTypeId = 2 Then
                PushGraphSettings(Integer.Parse(ddlMonthOffset.Value), CommRecId)
            ElseIf UserTypeId = 1 Then
                PushGraphSettings(Integer.Parse(ddlMonthOffset.Value), ddlCommRec.SelectedValue)
            End If
        End If
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

    Private Sub PrepQuerystring()

        'prep querystring for pages that need those variables
        QueryString = New QueryStringBuilder(Request.Url.Query).QueryString

        If QueryString.Length > 0 Then
            QueryString = "?" & QueryString
        End If

    End Sub

    Private Sub LoadTabStrips()
        tsTasksView.TabPages.Clear()

        If phTasks.Visible Then
            If hdnTasksCount.Value <> "" And hdnTasksCount.Value <> "0" Then
                tsTasksView.TabPages.Add(New Slf.Dms.Controls.TabPage("Individual&nbsp;Tasks&nbsp;&nbsp;<font color='blue'>(" & hdnTasksCount.Value.ToString() & ")</font>", phTasks.ClientID))
            Else
                tsTasksView.TabPages.Add(New Slf.Dms.Controls.TabPage("Individual&nbsp;Tasks", phTasks.ClientID))
            End If

            If hdnTeamTasksCount.Value <> "" And hdnTeamTasksCount.Value <> "0" Then
                tsTasksView.TabPages.Add(New Slf.Dms.Controls.TabPage("Team&nbsp;Tasks&nbsp;&nbsp;<font color='blue'>(" & hdnTeamTasksCount.Value.ToString() & ")</font>", phTeamTasks.ClientID))
            Else
                tsTasksView.TabPages.Add(New Slf.Dms.Controls.TabPage("Team&nbsp;Tasks", phTeamTasks.ClientID))
            End If
        End If

        If tsTasksView.TabPages.Count = 0 Then
            tsTasksView.Visible = False
        End If

        '*** Disabled 2.8.10 *****
        'If UserIsManager Then

        '    If hdnManagerTasksCount.Value <> "" And hdnManagerTasksCount.Value <> "0" Then
        '        tsTasksView.TabPages.Add(New Slf.Dms.Controls.TabPage("Tasks&nbsp;Created&nbsp;By&nbsp;Manager&nbsp;&nbsp;<font color='blue'>(" & hdnManagerTasksCount.Value.ToString() & ")</font>", phManagerTasks.ClientID))
        '    Else
        '        tsTasksView.TabPages.Add(New Slf.Dms.Controls.TabPage("Tasks&nbsp;Created&nbsp;By&nbsp;Manager", phManagerTasks.ClientID))
        '    End If
        'End If
        '**** Disabled 2.8.10 ****

    End Sub

    Private Sub PendingCreditors()
        If pnlValidateCreditors.Visible Then
            Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetPendingValidations")
                Using cmd.Connection
                    Try
                        cmd.Connection.Open()
                        Dim dtTemp As New Data.DataTable
                        dtTemp.Load(cmd.ExecuteReader())
                        lblValidateCreditors.Text = "Validate Creditors (<font color='blue'>" & dtTemp.Rows.Count & "</font>)"
                    Catch ex As Exception
                        'do nothing
                    End Try
                End Using
            End Using
        End If
    End Sub
    Private Sub LoadFinancialCompanyList()
        Dim tbl As DataTable = SqlHelper.GetDataTable(String.Format("SELECT c.CompanyID, c.ShortCoName FROM tblCompany c join tblusercompanyaccess uc on uc.companyid = c.companyid and uc.userid = {0} ORDER BY c.CompanyID ASC", UserID))
        If tbl.Rows.Count > 1 Then
            Dim row As DataRow = tbl.NewRow
            row("shortconame") = " -- ALL --"
            row("companyid") = -1
            tbl.Rows.InsertAt(row, 0)
        End If
        With ddlCompanyFinancial
            .DataSource = tbl
            .DataTextField = "shortconame"
            .DataValueField = "companyid"
            .DataBind()
        End With
    End Sub
    Private Sub LoadFinancialAgencyList()
        Dim obj As New Drg.Util.DataHelpers.AgencyHelper
        Dim tbl As DataTable = obj.GetAgencies
        Dim row As DataRow = tbl.NewRow
        row("code") = " -- ALL --"
        row("agencyid") = -1
        tbl.Rows.InsertAt(row, 0)
        With ddlAgencyFinancial
            .DataSource = tbl
            .DataTextField = "code"
            .DataValueField = "agencyid"
            .DataBind()
        End With
    End Sub
    'Private Sub LoadClientsPendingReview()

    '    If Not IsPostBack And Not IsCallback Then
    '        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
    '            Using cmd.Connection
    '                cmd.Connection.Open()

    '                cmd.CommandText = "SELECT * FROM tblAgency ORDER BY [code]"

    '                cboAgencyID.Items.Clear()
    '                cboAgencyID.Items.Add(New ListItem("All Agencies", 0))

    '                Using rd As IDataReader = cmd.ExecuteReader()

    '                    While rd.Read()
    '                        cboAgencyID.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "code"), DatabaseHelper.Peel_int(rd, "AgencyID")))
    '                    End While
    '                End Using
    '            End Using
    '        End Using
    '    End If

    '    Dim grdcmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetClientsPendingReview")
    '    If cboAgencyID.SelectedIndex > 0 Then
    '        DatabaseHelper.AddParameter(grdcmd, "agencyid", Integer.Parse(cboAgencyID.SelectedValue))
    '    End If
    '    grdClientsPendingReview.DataCommand = grdcmd

    'End Sub
    Private Sub LoadClientsIncompleteData()

        Dim grdcmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetClientsIncompleteData")
        DatabaseHelper.AddParameter(grdcmd, "agencyid", AgencyId)
        grdClientsIncompleteData.DataCommand = grdcmd

    End Sub
#Region "Statistics"
    Private Sub LoadMonthOffset()
        Dim d As DateTime = Now.AddMonths(-6)
        For i As Integer = -6 To 6
            If i = -1 Then
                ddlMonthOffset.Items.Add(New ListItem("Last Month", i))
            ElseIf i = 0 Then
                ddlMonthOffset.Items.Add(New ListItem("This Month", i))
            ElseIf i = 1 Then
                ddlMonthOffset.Items.Add(New ListItem("Next Month", i))
            Else
                ddlMonthOffset.Items.Add(New ListItem(d.ToString("MMMM yy"), i))
            End If
            d = d.AddMonths(1)
        Next
        ddlMonthOffset.SelectedIndex = 6
    End Sub
    Protected Structure ClientStat
        Dim TimeUnits As Dictionary(Of Integer, TimeUnit)
        Dim Name As String
        Dim Type As String
        Structure TimeUnit
            Dim TimeUnit As Integer
            Dim Val As Single
        End Structure
    End Structure
    Private Sub AddClientStatTimeUnit(ByVal stats As Dictionary(Of String, ClientStat), ByVal Val As Single, ByVal Statistic As String, ByVal TimeUnits As Integer, ByVal Type As String)
        Dim stat As ClientStat = Nothing

        If Not stats.TryGetValue(Statistic, stat) Then
            stat = New ClientStat
            stat.Name = Statistic
            stat.Type = Type
            stat.TimeUnits = New Dictionary(Of Integer, ClientStat.TimeUnit)
            stats.Add(stat.Name, stat)
        End If

        Dim tu As New ClientStat.TimeUnit
        tu.Val = Val
        tu.TimeUnit = TimeUnits
        stat.TimeUnits.Add(tu.TimeUnit, tu)
    End Sub
    Private Function GetControls() As Dictionary(Of String, Control)
        Dim c As New Dictionary(Of String, Control)
        c.Add(txtTransDate1.ID, txtTransDate1)
        c.Add(txtTransDate2.ID, txtTransDate2)
        c.Add(txtDataPoints.ID, txtDataPoints)
        c.Add(ddlChartGrouping_Stat.ID, ddlChartGrouping_Stat)
        c.Add(ddlMonthOffset.ID, ddlMonthOffset)
        'c.Add(ddlQuickPickDate.ID, ddlQuickPickDate)
        c.Add(chkCumulative.ID, chkCumulative)
        'c.Add(tsStatistics.ID, tsStatistics)
        Return c
    End Function
    Private Sub Save()

        'blow away current stuff first
        QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "'")

        If txtTransDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate1.ID, "value", _
                txtTransDate1.Text)
        End If

        If txtTransDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate2.ID, "value", _
                txtTransDate2.Text)
        End If

        If txtDataPoints.Value.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtDataPoints.ID, "value", _
                txtDataPoints.Value)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, ddlChartGrouping_Stat.ID, "value", _
            ddlChartGrouping_Stat.Value)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, ddlQuickPickDate.ID, "index", _
            ddlQuickPickDate.SelectedIndex)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, ddlMonthOffset.ID, "value", _
            ddlMonthOffset.Value)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkCumulative.ID, "value", _
            chkCumulative.Checked.ToString())

        'QuerySettingHelper.Insert(Me.GetType().Name, UserID, tsStatistics.ID, "value", _
        '    tsStatistics.SelectedIndex.ToString())

    End Sub
    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click
        Save()
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub

    Private Sub LoadTrusts()
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Statistic_TrustAccount")
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    rpTrustAccounts.DataSource = rd
                    rpTrustAccounts.DataBind()
                End Using
            End Using
        End Using
    End Sub
    Private Sub LoadDeposits(ByVal date1 As DateTime, ByVal date2 As DateTime, ByVal companyid As Integer, ByVal agencyid As Integer)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Statistic_Deposits")
            DatabaseHelper.AddParameter(cmd, "date1", date1)
            DatabaseHelper.AddParameter(cmd, "date2", date2.AddDays(1).AddSeconds(-1))
            If companyid > 0 Then
                DatabaseHelper.AddParameter(cmd, "companyid", companyid)
            End If
            If agencyid > 0 Then
                DatabaseHelper.AddParameter(cmd, "agencyid", agencyid)
            End If
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    rpDeposits.DataSource = rd
                    rpDeposits.DataBind()
                End Using
            End Using
        End Using
    End Sub
    Private Sub LoadFeesAndPayments(ByVal date1 As DateTime, ByVal date2 As DateTime, ByVal companyid As Integer, ByVal agencyid As Integer)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Statistic_FeesAndPayments")
            DatabaseHelper.AddParameter(cmd, "date1", date1)
            DatabaseHelper.AddParameter(cmd, "date2", date2.AddDays(1).AddSeconds(-1))
            If companyid > 0 Then
                DatabaseHelper.AddParameter(cmd, "companyid", companyid)
            End If
            If agencyid > 0 Then
                DatabaseHelper.AddParameter(cmd, "agencyid", agencyid)
            End If
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    rpFeesAndPayments.DataSource = rd
                    rpFeesAndPayments.DataBind()
                End Using
            End Using
        End Using
    End Sub
    Private Sub LoadCommission(ByVal date1 As DateTime, ByVal date2 As DateTime, ByVal companyid As Integer, ByVal agencyid As Integer)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Statistic_Commission")
            DatabaseHelper.AddParameter(cmd, "date1", date1)
            DatabaseHelper.AddParameter(cmd, "date2", date2.AddDays(1).AddSeconds(-1))
            If companyid > 0 Then
                DatabaseHelper.AddParameter(cmd, "companyid", companyid)
            End If
            If agencyid > 0 Then
                DatabaseHelper.AddParameter(cmd, "agencyid", agencyid)
            End If
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    rpCommission.DataSource = rd
                    rpCommission.DataBind()
                End Using
            End Using
        End Using
    End Sub
    Private Function LoadClientStats(ByVal DateGrouping As Integer, ByVal DataPoints As Integer, ByVal Cumulative As Boolean) As String
        Dim stats As New Dictionary(Of String, ClientStat)
        Dim AllTimeUnits As New List(Of Integer)
        Dim ClientCount As Single = DataHelper.FieldCount("tblClient", "ClientID")
        Dim sb As New StringBuilder
        Dim Unit As String = GetUnit()

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Statistic_ClientGrouped")
            DatabaseHelper.AddParameter(cmd, "dategrouping", DateGrouping)
            DatabaseHelper.AddParameter(cmd, "datapoints", DataPoints)

            If Not AgencyId = -1 Then DatabaseHelper.AddParameter(cmd, "agencyid", AgencyId)
            If Not AttorneyID = -1 Then DatabaseHelper.AddParameter(cmd, "attorneyid", AttorneyID)

            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    Dim names As String() = {"Commitments", "Completions", "New Cases", "Cancellations"}

                    For i As Integer = 0 To names.Length - 1
                        Dim stat As String = names(i)
                        If i > 0 Then rd.NextResult()

                        Dim manual As Boolean = True

                        While (rd.Read)
                            Dim tu As Integer = DatabaseHelper.Peel_int(rd, "TimeUnits")
                            Dim val As Single = DatabaseHelper.Peel_int(rd, "Count")
                            AddClientStatTimeUnit(stats, val, stat, tu, "Count")
                            If Not AllTimeUnits.Contains(tu) Then AllTimeUnits.Add(tu)
                            manual = False
                        End While

                        If manual Then AddClientStatTimeUnit(stats, 0, stat, 0, "Count")
                    Next

                End Using
            End Using
        End Using


        For i As Integer = 0 To DataPoints - 1
            If Not AllTimeUnits.Contains(i) Then
                AllTimeUnits.Add(i)
            End If
        Next

        'sort list
        AllTimeUnits.Sort()

        sb.Append("<table style=""font-family:tahoma;font-size:11px;width:100%;table-layout:fixed"" cellspacing=""0"" cellpadding=""0"" >")

        'render headers
        sb.Append("<tr style=""font-weight:bold"">")
        sb.Append("<th align=""left"" style=""width:100px"" class=""StatHeadItem"">Statistic</th>")
        For Each tu As Integer In AllTimeUnits
            sb.Append("<th nowrap=""true"" align=""left"" class=""StatHeadItem"">")
            Select Case tu
                Case 0
                    sb.Append("This " & Unit)
                Case 1
                    sb.Append("Last " & Unit)
                Case Else
                    Select Case ddlChartGrouping_Stat.Value
                        Case 0
                            sb.Append(Now.AddDays(-tu).ToString("MM/dd"))
                        Case 1
                            Dim base As DateTime = Now.AddDays(-Now.DayOfWeek)
                            sb.Append(Unit & " " & base.AddDays(-(tu * 7)).ToString("MM/dd"))
                        Case 2
                            Dim base As DateTime = Now.AddDays(-Now.Day + 1)
                            sb.Append(base.AddMonths(-tu).ToString("MMM"))
                        Case 3
                            Dim base As DateTime = Now.AddDays(-Now.DayOfYear + 1)
                            sb.Append(base.AddYears(-tu).ToString("yyyy"))
                    End Select
            End Select

            sb.Append("</th>")
        Next
        sb.Append("</tr><tr>")

        'render content
        For Each stat As ClientStat In stats.Values
            sb.Append("<td class=""StatListItem"">" & stat.Name & "</td>")
            Dim sum As Single = 0
            For Each i As Integer In AllTimeUnits
                Dim tu As ClientStat.TimeUnit = Nothing
                If stat.TimeUnits.TryGetValue(i, tu) Then
                    sum += tu.Val
                    Select Case stat.Type
                        Case "Count"
                            If Cumulative Then
                                sb.Append("<td class=""StatListItem"">" & sum & "</td>")
                            Else
                                sb.Append("<td class=""StatListItem"">" & tu.Val & "</td>")
                            End If
                        Case "-Percent"
                            If Cumulative Then
                                sb.Append("<td class=""StatListItem"">" & (1.0F - sum).ToString("p") & "</td>")
                            Else
                                sb.Append("<td class=""StatListItem"">" & (1.0F - tu.Val).ToString("p") & "</td>")
                            End If
                    End Select

                Else
                    sb.Append("<td class=""StatListItem"">0</td>")
                End If
            Next
            sb.Append("<tr><td colspan=""" & (AllTimeUnits.Count + 1) & """ style=""height:2;background-image:url(" & ResolveUrl("~/images/dot.png") & ");background-position:bottom bottom;background-repeat:repeat-x;""><img src=""" & ResolveUrl("~/images/spacer.gif") & """ border=""0"" width=""1"" height=""1""/></td></tr>")
        Next
        sb.Append("</table>")

        Return sb.ToString

    End Function
    Private Function LoadClientDeposits(ByVal DataPoints As Integer) As String
        Dim stats As New Dictionary(Of String, ClientStat)
        Dim AllTimeUnits As New List(Of Integer)

        Dim ClientCount As Single
        If AgencyId = -1 Then
            ClientCount = DataHelper.FieldCount("tblClient", "ClientID")
        Else
            ClientCount = DataHelper.FieldCount("tblClient", "ClientID", "agencyid=" + AgencyId.ToString)
        End If


        Dim sb As New StringBuilder

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Statistic_ClientDeposit")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "datapoints", DataPoints)

                If Not AgencyId = -1 Then DatabaseHelper.AddParameter(cmd, "agencyid", AgencyId)
                If Not AttorneyID = -1 Then DatabaseHelper.AddParameter(cmd, "attorneyid", AttorneyID)

                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    Dim names As String() = {"Dep Consistency", "Last Dep"}

                    For i As Integer = 0 To names.Length - 1
                        Dim stat As String = names(i)
                        Dim Type As String = IIf(i = 0, "-Percent", "Count")
                        If i > 0 Then rd.NextResult()

                        Dim manual As Boolean = True

                        While (rd.Read)
                            Dim tu As Integer = DatabaseHelper.Peel_int(rd, "MonthsAgo")
                            Dim val As Single = DatabaseHelper.Peel_int(rd, "Count")
                            If i = 0 Then val = val / ClientCount
                            AddClientStatTimeUnit(stats, val, stat, tu, Type)
                            If Not AllTimeUnits.Contains(tu) Then AllTimeUnits.Add(tu)
                            manual = False
                        End While

                        If manual Then
                            AddClientStatTimeUnit(stats, 0, stat, 0, Type)
                        End If
                    Next

                End Using
            End Using
        End Using

        'sort list
        AllTimeUnits.Sort()

        sb.Append("<table style=""font-family:tahoma;font-size:11px;width:100%;table-layout:fixed"" cellspacing=""0"" cellpadding=""0"" >")

        'render headers
        sb.Append("<tr style=""font-weight:bold"">")
        sb.Append("<th align=""left"" style=""width:100px"" class=""StatHeadItem"">Statistic</th>")
        For Each tu As Integer In AllTimeUnits
            sb.Append("<th nowrap=""true"" align=""left"" class=""StatHeadItem"">")
            Select Case tu
                Case -1
                    sb.Append("Never")
                Case 0
                    sb.Append("This Mo")
                Case 1
                    sb.Append("Last Mo")
                Case Else
                    Dim base As DateTime = Now.AddDays(-Now.Day + 1)
                    sb.Append(base.AddMonths(-tu).ToString("MMM"))
            End Select

            sb.Append("</th>")
        Next
        sb.Append("</tr><tr>")

        'render content
        For Each stat As ClientStat In stats.Values
            sb.Append("<td class=""StatListItem"">" & stat.Name & "</td>")
            Dim sum As Single = 0
            For Each i As Integer In AllTimeUnits
                Dim tu As ClientStat.TimeUnit = Nothing
                If stat.TimeUnits.TryGetValue(i, tu) Then
                    If Not tu.Val = -1 Then sum += tu.Val
                    Select Case stat.Type
                        Case "Count"
                            sb.Append("<td class=""StatListItem"">" & sum & "</td>")
                        Case "-Percent"
                            If tu.TimeUnit = -1 Then
                                sb.Append("<td class=""StatListItem"">" & tu.Val.ToString("p") & "</td>")
                            Else
                                sb.Append("<td class=""StatListItem"">" & (sum).ToString("p") & "</td>")
                            End If

                    End Select

                Else
                    sb.Append("<td class=""StatListItem"">0</td>")
                End If
            Next
            sb.Append("<tr><td colspan=""" & (AllTimeUnits.Count + 1) & """ style=""height:2;background-image:url(" & ResolveUrl("~/images/dot.png") & ");background-position:bottom bottom;background-repeat:repeat-x;""><img src=""" & ResolveUrl("~/images/spacer.gif") & """ border=""0"" width=""1"" height=""1""/></td></tr>")
        Next
        sb.Append("</table>")

        Return sb.ToString

    End Function
    Private Function LoadClientLongevity(ByVal DateGrouping As Integer, ByVal DataPoints As Integer) As String
        Dim stats As New Dictionary(Of String, ClientStat)
        Dim AllTimeUnits As New List(Of Integer)

        Dim ClientCount As Single
        If AgencyId = -1 Then
            ClientCount = DataHelper.FieldCount("tblClient", "ClientID")
        Else
            ClientCount = DataHelper.FieldCount("tblClient", "ClientID", "agencyid=" + AgencyId.ToString)
        End If

        Dim sb As New StringBuilder
        Dim Unit As String = GetUnit()

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Statistic_CaseRetention")
            DatabaseHelper.AddParameter(cmd, "dategrouping", DateGrouping)
            DatabaseHelper.AddParameter(cmd, "datapoints", DataPoints)

            If Not AgencyId = -1 Then DatabaseHelper.AddParameter(cmd, "agencyid", AgencyId)
            If Not AttorneyID = -1 Then DatabaseHelper.AddParameter(cmd, "attorneyid", AttorneyID)

            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    Dim names As String() = {"Case Retention"}

                    For i As Integer = 0 To names.Length - 1
                        Dim stat As String = names(i)
                        Dim Type As String = "-Percent"
                        If i > 0 Then rd.NextResult()

                        Dim manual As Boolean = True

                        While (rd.Read)
                            Dim tu As Integer = DatabaseHelper.Peel_int(rd, "TimeUnits")
                            Dim val As Single = DatabaseHelper.Peel_int(rd, "Count")

                            'percentage
                            val = val / ClientCount

                            AddClientStatTimeUnit(stats, val, stat, tu, Type)
                            If Not AllTimeUnits.Contains(tu) Then AllTimeUnits.Add(tu)
                            manual = False
                        End While

                        If manual Then
                            AddClientStatTimeUnit(stats, 0, stat, 0, Type)
                        End If
                    Next

                End Using
            End Using
        End Using

        For i As Integer = 0 To DataPoints - 1
            If Not AllTimeUnits.Contains(i) Then
                AllTimeUnits.Add(i)
            End If
        Next

        'sort list
        AllTimeUnits.Sort()
        sb.Append("<table style=""font-family:tahoma;font-size:11px;width:100%;table-layout:fixed"" cellspacing=""0"" cellpadding=""0"" >")

        'render headers
        sb.Append("<tr style=""font-weight:bold"">")
        sb.Append("<th align=""left"" style=""width:100px"" class=""StatHeadItem"">Statistic</th>")
        For Each tu As Integer In AllTimeUnits
            sb.Append("<th nowrap=""true"" align=""left"" class=""StatHeadItem"">")
            Select Case tu
                Case 0
                    sb.Append("First " & Unit)
                Case Else
                    sb.Append(Unit & " " & (tu + 1))
            End Select

            sb.Append("</th>")
        Next
        sb.Append("</tr><tr>")

        'render content
        For Each stat As ClientStat In stats.Values
            sb.Append("<td class=""StatListItem"">" & stat.Name & "</td>")
            Dim sum As Single = 0
            For Each i As Integer In AllTimeUnits
                Dim tu As ClientStat.TimeUnit = Nothing
                If stat.TimeUnits.TryGetValue(i, tu) Then
                    sum += tu.Val
                    sb.Append("<td class=""StatListItem"">" & (1.0F - sum).ToString("p") & "</td>")
                Else
                    sb.Append("<td class=""StatListItem"">0</td>")
                End If
            Next
            sb.Append("<tr><td colspan=""" & (AllTimeUnits.Count + 1) & """ style=""height:2;background-image:url(" & ResolveUrl("~/images/dot.png") & ");background-position:bottom bottom;background-repeat:repeat-x;""><img src=""" & ResolveUrl("~/images/spacer.gif") & """ border=""0"" width=""1"" height=""1""/></td></tr>")
        Next
        sb.Append("</table>")

        Return sb.ToString

    End Function
    Private Function GetUnit() As String
        Select Case ddlChartGrouping_Stat.Value
            Case 0
                Return "Day"
            Case 1
                Return "Wk"
            Case 2
                Return "Mo"
            Case 3
                Return "Yr"
            Case Else
                Return ""
        End Select
    End Function

    Private Function OneOf(ByVal o As Object, ByVal a As Array) As Boolean
        For Each obj As Object In a
            If o.Equals(obj) Then
                Return True
            End If
        Next

        Return False

    End Function

    Private Function LoadProjectedCommission(ByVal MonthOffset As Integer, ByVal iCommRecID As String, ByVal company As String) As String
        Dim MonthDate As New DateTime(Now.Year, Now.Month, 1)
        MonthDate = MonthDate.AddMonths(MonthOffset)

        'add all columns
        Dim dt As New DataTable
        For i As Integer = 1 To 8
            dt.Columns.Add(i.ToString, GetType(Object))
        Next

        'add all rows
        While (dt.Rows.Count < 6)
            dt.Rows.Add(dt.NewRow)
        End While

        Dim sb As New StringBuilder

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Statistic_ProjectedCommission")
            DatabaseHelper.AddParameter(cmd, "monthdate", MonthDate)
            'DatabaseHelper.AddParameter(cmd, "company", "'" + company + "'")

            If Not iCommRecID = "-1" Then DatabaseHelper.AddParameter(cmd, "commrecid", iCommRecID)
            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read
                        Dim row As Integer = DatabaseHelper.Peel_int(rd, "Row")
                        Dim col As Integer = DatabaseHelper.Peel_int(rd, "Col")
                        Dim val As Object = rd("Value")
                        dt.Rows(row - 1)(col - 1) = val
                    End While
                End Using
            End Using
        End Using

        'set exception values
        'For i As Integer = 0 To 3
        'Dim r As DataRow = dt.Rows(i)
        'r(1) = LocalHelper.IsNull(r(0), 0) - LocalHelper.IsNull(r(2), 0)
        'Next

        'set totals
        For y As Integer = 4 To 5
            For x As Integer = 0 To dt.Columns.Count - 1
                dt.Rows(y)(x) = LocalHelper.IsNull(dt.Rows(y - 2)(x), 0) + LocalHelper.IsNull(dt.Rows(y - 4)(x), 0)
            Next
        Next

        sb.Append("<table style=""font-family:tahoma;font-size:11px;width:100%;"" cellspacing=""0"" cellpadding=""0"" >")

        Dim names() As String = {"Potential", "Exceptions", "Planned", "Exceptions", "Missed", "Void/Bounce", "Actual", "Pending"}
        Dim cols() As String = {"ACH (sum)", "ACH (count)", "Non-ACH (sum)", "Non-ACH (count)", "Total (sum)", "Total (count)"}

        sb.Append("<thead><tr><th style=""background-color:white"">&nbsp;</th><th colspan=""3"" style=""background-color:rgb(255,255,174)"">Planned</th><td>&nbsp;&nbsp;&nbsp;</td><th style=""background-color:rgb(187,255,187)"" colspan=""6"">Actual</th></tr>")
        sb.Append("<tr style=""font-weight:bold"">")
        sb.Append("<th style=""background-color:white"">&nbsp;</th>")
        For i As Integer = 0 To names.Length - 1
            If i = 3 Then
                sb.Append("<td>&nbsp;&nbsp;&nbsp;</td>")
            End If
            Dim s As String = names(i)
            Dim bc As String
            If i >= 3 Then bc = "rgb(187,255,187)" Else bc = "rgb(255,255,174)"
            sb.Append("<th align=""right"" style=""background-color:" & bc & """ nowrap=""true"" align=""left"" class=""StatHeadItem"">")
            sb.Append(s)
            sb.Append("</th>")
        Next
        sb.Append("</tr></thead><tbody>")


        For i As Integer = 0 To dt.Rows.Count - 1
            Dim dr As DataRow = dt.Rows(i)
            sb.Append("<tr>")
            sb.Append("<td align=""right"" nowrap=""true"" class=""StatListItem"">")
            sb.Append(cols(i))
            sb.Append("</td>")

            For j As Integer = 0 To dt.Columns.Count - 1
                If j = 3 Then
                    sb.Append("<td>&nbsp;&nbsp;&nbsp;</td>")
                End If

                Dim ACH As Nullable(Of Boolean) = Nothing
                If i <= 1 Then
                    ACH = True
                ElseIf i <= 3 Then
                    ACH = False
                End If
                Dim resultID As String = j & "_"
                If ACH.HasValue Then resultID += ACH.Value.ToString()
                Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_QueryResults_ProjectedCommission")
                If Not iCommRecID = "-1" Then DatabaseHelper.AddParameter(cmd, "commrecid", iCommRecID)
                DatabaseHelper.AddParameter(cmd, "monthdate", MonthDate)
                DatabaseHelper.AddParameter(cmd, "col", j)
                If ACH.HasValue Then DatabaseHelper.AddParameter(cmd, "ach", ACH.Value)
                Session("queryresults_" & resultID) = cmd

                Dim dc As DataColumn = dt.Columns(j)

                Dim bc As String

                If j >= 3 Then
                    If i Mod 2 = 1 Then bc = "rgb(187,255,187)" Else bc = "rgb(221,255,221)"
                Else
                    If i Mod 2 = 1 Then bc = "rgb(255,255,174)" Else bc = "rgb(255,255,210)"
                End If

                sb.Append("<td align=""right"" style=""background-color:" & bc & """ class=""StatListItem"">")
                '& IIf(j = 2, ";border-right:gray 1px solid", "")


                sb.Append("<a class=""lnk"" href=""javascript:ShowResult('" & resultID & "');"">")
                Dim o As Object = dr(dc.ColumnName)
                If i Mod 2 = 0 Then
                    If IsDBNull(o) Then
                        sb.Append("$0.00")
                    Else
                        sb.Append(CType(o, Single).ToString("c"))
                    End If
                Else
                    If IsDBNull(o) OrElse CType(o, Integer) = 0 Then
                        sb.Append("0")
                    Else
                        sb.Append(CType(o, Integer).ToString("#,###"))
                    End If
                End If
                sb.Append("</a>")
                sb.Append("</td>")
            Next
            sb.Append("</tr>")
            sb.Append("<tr><td colspan=""4"" style=""height:2;background-image:url(" & ResolveUrl("~/images/dot.png") & ");background-position:bottom bottom;background-repeat:repeat-x;""><img src=""" & ResolveUrl("~/images/spacer.gif") & """ border=""0"" width=""1"" height=""1""/></td><td></td><td colspan=""" & (dt.Columns.Count + 1 - 4) & """ style=""height:2;background-image:url(" & ResolveUrl("~/images/dot.png") & ");background-position:bottom bottom;background-repeat:repeat-x;""><img src=""" & ResolveUrl("~/images/spacer.gif") & """ border=""0"" width=""1"" height=""1""/></td></tr>")
        Next

        sb.Append("</tbody></table>")

        Return sb.ToString

    End Function

    'Private Sub LoadRecipients()
    'Dim ddl As DropDownList = ddlMasterFinancialRecipient
    'ddl.Items.Clear()
    'ddl.Items.Add(New ListItem(" --All Recipients--", -1))
    'Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
    'cmd.CommandText = "SELECT * FROM tblCommRec ORDER BY abbreviation"
    'Using cmd.Connection
    'cmd.Connection.Open()
    'Using rd As IDataReader = cmd.ExecuteReader()
    'While rd.Read()
    'ddl.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "abbreviation"), DatabaseHelper.Peel_int(rd, "CommRecID")))
    'End While
    'End Using
    'End Using
    'End Using

    'End Sub

    Private Sub LoadQuickPickDates()
        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yy") & "," & Now.ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yy") & "," & Now.AddDays(-1).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        Dim SelectedIndex As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblQuerySetting", "Value", _
                  "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = 'ddlQuickPickDate'"), 0)

        ddlQuickPickDate.SelectedIndex = SelectedIndex
        If Not ddlQuickPickDate.Items(SelectedIndex).Value = "Custom" Then
            Dim parts As String() = ddlQuickPickDate.Items(SelectedIndex).Value.Split(",")
            txtTransDate1.Text = parts(0)
            txtTransDate2.Text = parts(1)
        End If
    End Sub
#End Region
#Region "Default"
    Private Sub LoadVisits()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT TOP 8 * FROM tblUserVisit WHERE UserID = @UserID ORDER BY [Visit] DESC, UserVisitID DESC"

        DatabaseHelper.AddParameter(cmd, "UserID", UserID)

        Dim Visits As New List(Of UserVisit)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Visits.Add(New UserVisit(DatabaseHelper.Peel_int(rd, "UserVisitID"), _
                    DatabaseHelper.Peel_int(rd, "UserID"), _
                    DatabaseHelper.Peel_string(rd, "Type"), _
                    DatabaseHelper.Peel_int(rd, "TypeID"), _
                    DatabaseHelper.Peel_string(rd, "Display"), _
                    DatabaseHelper.Peel_date(rd, "Visit")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If Visits.Count > 0 Then

            rpVisits.DataSource = Visits
            rpVisits.DataBind()

        End If

        rpVisits.Visible = Visits.Count > 0
        trNoVisits.Visible = Visits.Count = 0

    End Sub

    Private Sub LoadSearches()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT TOP 4 * FROM tblUserSearch WHERE UserID = @UserID ORDER BY [Search] DESC, UserSearchID DESC"

        DatabaseHelper.AddParameter(cmd, "UserID", UserID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            rpSearches.DataSource = rd
            rpSearches.DataBind()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        rpSearches.Visible = rpSearches.Items.Count > 0
        trNoSearches.Visible = rpSearches.Items.Count = 0

    End Sub

    Private Sub LoadUpcomingTasks()
        Dim Tasks As New List(Of GridTask)
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTasks")

        If chkOpenOnly.Checked Then
            DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblTask.AssignedTo = " & UserID & " AND ((Resolved IS NULL AND Due > '" & Now.ToString("MM/dd/yyyy hh:mm tt") & "') OR (Resolved is Not Null AND tblTask.TaskResolutionID<>1) ) ")
        Else
            DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblTask.AssignedTo = " & UserID & " AND ((Resolved IS NULL)  OR (Resolved is Not Null AND tblTask.TaskResolutionID<>1) ) ")
        End If

        DatabaseHelper.AddParameter(cmd, "OrderBy", "ORDER BY Due")

        'Dim Tasks As New List(Of Task)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                'Tasks.Add(New Task(DatabaseHelper.Peel_int(rd, "TaskID"), _
                '    DatabaseHelper.Peel_int(rd, "ParentTaskID"), _
                '    DatabaseHelper.Peel_int(rd, "ClientID"), _
                '    DatabaseHelper.Peel_string(rd, "ClientName"), _
                '    DatabaseHelper.Peel_int(rd, "TaskTypeID"), _
                '    DatabaseHelper.Peel_string(rd, "TaskTypeName"), _
                '    DatabaseHelper.Peel_int(rd, "TaskTypeCategoryID"), _
                '    DatabaseHelper.Peel_string(rd, "TaskTypeCategoryName"), _
                '    DatabaseHelper.Peel_string(rd, "Description"), _
                '    DatabaseHelper.Peel_int(rd, "AssignedTo"), _
                '    DatabaseHelper.Peel_string(rd, "AssignedToName"), _
                '    DatabaseHelper.Peel_date(rd, "Due"), _
                '    DatabaseHelper.Peel_ndate(rd, "Resolved"), _
                '    DatabaseHelper.Peel_int(rd, "ResolvedBy"), _
                '    DatabaseHelper.Peel_string(rd, "ResolvedByName"), _
                '    DatabaseHelper.Peel_int(rd, "TaskResolutionID"), _
                '    DatabaseHelper.Peel_string(rd, "TaskResolutionName"), _
                '    DatabaseHelper.Peel_date(rd, "Created"), _
                '    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                '    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                '    DatabaseHelper.Peel_date(rd, "LastModified"), _
                '    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                '    DatabaseHelper.Peel_string(rd, "LastModifiedByName")))

                Dim tsk As New GridTask

                tsk.TaskID = DatabaseHelper.Peel_int(rd, "TaskID")
                tsk.AssignedTo = DatabaseHelper.Peel_string(rd, "AssignedToName")
                tsk.TaskType = DatabaseHelper.Peel_string(rd, "TaskTypeName")
                tsk.TaskDescription = DatabaseHelper.Peel_string(rd, "Description").Replace("-Not Available", "")
                tsk.StartDate = DatabaseHelper.Peel_date(rd, "Created")
                tsk.DueDate = DatabaseHelper.Peel_date(rd, "Due")
                tsk.CreatedBy = DatabaseHelper.Peel_string(rd, "CreatedByName")
                tsk.ResolvedDate = DatabaseHelper.Peel_ndate(rd, "Resolved")
                tsk.TaskResolutionId = DatabaseHelper.Peel_int(rd, "TaskResolutionID")
                tsk.ClientID = DatabaseHelper.Peel_int(rd, "ClientID")
                tsk.Client = DatabaseHelper.Peel_string(rd, "ClientName")
                tsk.Language = DatabaseHelper.Peel_string(rd, "Language")
                tsk.ClientState = DatabaseHelper.Peel_string(rd, "ClientState")
                Tasks.Add(tsk)

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If Tasks.Count > 0 Then

            rpUpcomingTasks.DataSource = Tasks
            rpUpcomingTasks.DataBind()
            If Tasks.Count > 5 Then
                dvUpcomingTasks.Style("overflow") = "auto"
                dvUpcomingTasks.Style("height") = "150"
            End If

        End If

        rpUpcomingTasks.Visible = Tasks.Count > 0
        pnlNoUpcomingTasks.Visible = Tasks.Count = 0
        hdnTasksCount.Value = Tasks.Count
    End Sub

    Private Sub LoadTeamTasks()
        Dim Tasks As New List(Of GridTask)
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTasks")

        'For Team Tasks
        'If chkTeamOpenOnly.Checked Then
        '    DatabaseHelper.AddParameter(cmd, "returntop", "200")
        '    DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblassignedto.UserGroupId = " & UserGroupId & " AND Resolved IS NULL AND Due > '" & Now.ToString("MM/dd/yyyy hh:mm tt") & "'")
        'Else
        '    DatabaseHelper.AddParameter(cmd, "returntop", "200")
        '    DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblassignedto.UserGroupId = " & UserGroupId & " AND Resolved IS NULL")
        'End If

        If chkTeamOpenOnly.Checked Then
            DatabaseHelper.AddParameter(cmd, "returntop", "200")
            DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblassignedtogroup.UserGroupId " & IIf(UserIsManager, "is not null", "= " & UserGroupId) & " AND ((Resolved IS NULL AND Due > '" & Now.ToString("MM/dd/yyyy hh:mm tt") & "') OR (Resolved is Not Null AND tblTask.TaskResolutionID<>1) ) ")
        Else
            DatabaseHelper.AddParameter(cmd, "returntop", "200")
            DatabaseHelper.AddParameter(cmd, "Where", "WHERE tblassignedtogroup.UserGroupId " & IIf(UserIsManager, "is not null", "= " & UserGroupId) & " AND ((Resolved IS NULL)  OR (Resolved is Not Null AND tblTask.TaskResolutionID<>1) ) ")
        End If

        DatabaseHelper.AddParameter(cmd, "OrderBy", "ORDER BY Due")

        'Dim Tasks As New List(Of Task)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                'Tasks.Add(New Task(DatabaseHelper.Peel_int(rd, "TaskID"), _
                '    DatabaseHelper.Peel_int(rd, "ParentTaskID"), _
                '    DatabaseHelper.Peel_int(rd, "ClientID"), _
                '    DatabaseHelper.Peel_string(rd, "ClientName"), _
                '    DatabaseHelper.Peel_int(rd, "TaskTypeID"), _
                '    DatabaseHelper.Peel_string(rd, "TaskTypeName"), _
                '    DatabaseHelper.Peel_int(rd, "TaskTypeCategoryID"), _
                '    DatabaseHelper.Peel_string(rd, "TaskTypeCategoryName"), _
                '    DatabaseHelper.Peel_string(rd, "Description"), _
                '    DatabaseHelper.Peel_int(rd, "AssignedTo"), _
                '    DatabaseHelper.Peel_string(rd, "AssignedtoGroup"), _
                '    DatabaseHelper.Peel_date(rd, "Due"), _
                '    DatabaseHelper.Peel_ndate(rd, "Resolved"), _
                '    DatabaseHelper.Peel_int(rd, "ResolvedBy"), _
                '    DatabaseHelper.Peel_string(rd, "ResolvedByName"), _
                '    DatabaseHelper.Peel_int(rd, "TaskResolutionID"), _
                '    DatabaseHelper.Peel_string(rd, "TaskResolutionName"), _
                '    DatabaseHelper.Peel_date(rd, "Created"), _
                '    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                '    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                '    DatabaseHelper.Peel_date(rd, "LastModified"), _
                '    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                '    DatabaseHelper.Peel_string(rd, "LastModifiedByName"), DatabaseHelper.Peel_int(rd, "AssignedToGroupId")))

                Dim tsk As New GridTask

                tsk.TaskID = DatabaseHelper.Peel_int(rd, "TaskID")
                tsk.AssignedTo = DatabaseHelper.Peel_string(rd, "AssignedToName")
                tsk.TaskType = DatabaseHelper.Peel_string(rd, "TaskTypeName")
                tsk.TaskDescription = DatabaseHelper.Peel_string(rd, "Description").Replace("-Not Available", "")
                tsk.StartDate = DatabaseHelper.Peel_date(rd, "Created")
                tsk.DueDate = DatabaseHelper.Peel_date(rd, "Due")
                tsk.CreatedBy = DatabaseHelper.Peel_string(rd, "CreatedByName")
                tsk.ResolvedDate = DatabaseHelper.Peel_ndate(rd, "Resolved")
                tsk.TaskResolutionId = DatabaseHelper.Peel_int(rd, "TaskResolutionID")
                tsk.ClientID = DatabaseHelper.Peel_int(rd, "ClientID")
                tsk.Client = DatabaseHelper.Peel_string(rd, "ClientName")
                tsk.AssignedToGroupName = DatabaseHelper.Peel_string(rd, "AssignedtoGroup")
                tsk.intAssignedToId = DatabaseHelper.Peel_int(rd, "AssignedTo")
                tsk.intAssignedToGroupId = DatabaseHelper.Peel_int(rd, "AssignedToGroupId")
                Tasks.Add(tsk)


            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If Tasks.Count > 0 Then

            rpTeamTasks.DataSource = Tasks
            rpTeamTasks.DataBind()
            If Tasks.Count > 5 Then
                dvTeamTasks.Style("overflow") = "auto"
                dvTeamTasks.Style("height") = "150"
            End If

        End If

        rpTeamTasks.Visible = Tasks.Count > 0
        pnlNoTeamTasks.Visible = Tasks.Count = 0
        hdnTeamTasksCount.Value = Tasks.Count

        If UserIsManager Then
            lnkUpdateTaskUsers.Visible = True
            tdAssignHeader.Visible = True
        Else
            lnkUpdateTaskUsers.Visible = False
            tdAssignHeader.Visible = False
        End If

    End Sub

    Private Sub LoadManagerTasks()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetTasks")

        'For Tasks Created by users (Manager's Task)
        If chkManagerOpenOnly.Checked Then
            DatabaseHelper.AddParameter(cmd, "returntop", "200")
            DatabaseHelper.AddParameter(cmd, "Where", "WHERE tbltask.createdby = " & UserID & " AND Resolved IS NULL AND Due > '" & Now.ToString("MM/dd/yyyy hh:mm tt") & "'")
        Else
            DatabaseHelper.AddParameter(cmd, "returntop", "200")
            DatabaseHelper.AddParameter(cmd, "Where", "WHERE tbltask.createdby = " & UserID & " AND Resolved IS NULL")
        End If


        DatabaseHelper.AddParameter(cmd, "OrderBy", "ORDER BY Due")

        Dim Tasks As New List(Of Task)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            While rd.Read()

                Tasks.Add(New Task(DatabaseHelper.Peel_int(rd, "TaskID"), _
                    DatabaseHelper.Peel_int(rd, "ParentTaskID"), _
                    DatabaseHelper.Peel_int(rd, "ClientID"), _
                    DatabaseHelper.Peel_string(rd, "ClientName"), _
                    DatabaseHelper.Peel_int(rd, "TaskTypeID"), _
                    DatabaseHelper.Peel_string(rd, "TaskTypeName"), _
                    DatabaseHelper.Peel_int(rd, "TaskTypeCategoryID"), _
                    DatabaseHelper.Peel_string(rd, "TaskTypeCategoryName"), _
                    DatabaseHelper.Peel_string(rd, "Description").Replace("-Not Available", ""), _
                    DatabaseHelper.Peel_int(rd, "AssignedTo"), _
                    DatabaseHelper.Peel_string(rd, "AssignedToName"), _
                    DatabaseHelper.Peel_date(rd, "Due"), _
                    DatabaseHelper.Peel_ndate(rd, "Resolved"), _
                    DatabaseHelper.Peel_int(rd, "ResolvedBy"), _
                    DatabaseHelper.Peel_string(rd, "ResolvedByName"), _
                    DatabaseHelper.Peel_int(rd, "TaskResolutionID"), _
                    DatabaseHelper.Peel_string(rd, "TaskResolutionName"), _
                    DatabaseHelper.Peel_date(rd, "Created"), _
                    DatabaseHelper.Peel_int(rd, "CreatedBy"), _
                    DatabaseHelper.Peel_string(rd, "CreatedByName"), _
                    DatabaseHelper.Peel_date(rd, "LastModified"), _
                    DatabaseHelper.Peel_int(rd, "LastModifiedBy"), _
                    DatabaseHelper.Peel_string(rd, "LastModifiedByName")))

            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        If Tasks.Count > 0 Then

            rpManagerTasks.DataSource = Tasks
            rpManagerTasks.DataBind()
            If Tasks.Count > 5 Then
                dvManagerTasks.Style("overflow") = "auto"
                dvManagerTasks.Style("height") = "150"
            End If

        End If

        rpManagerTasks.Visible = Tasks.Count > 0
        pnlNoManagerTasks.Visible = Tasks.Count = 0
        hdnManagerTasksCount.Value = Tasks.Count
    End Sub

    Private Sub LoadAllNotes()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetAllCommunicationForUser")

        DatabaseHelper.AddParameter(cmd, "ReturnTop", "5")
        DatabaseHelper.AddParameter(cmd, "Type", "type='note'")
        DatabaseHelper.AddParameter(cmd, "UserID", UserID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            rpCommunication.DataSource = rd
            rpCommunication.DataBind()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        rpCommunication.Visible = rpCommunication.Items.Count > 0
        pnlNoCommunication.Visible = rpCommunication.Items.Count = 0

    End Sub

    Private Sub LoadAllCommunication()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("[stp_GetAllCommunicationForUser]")

        DatabaseHelper.AddParameter(cmd, "ReturnTop", "5")
        DatabaseHelper.AddParameter(cmd, "UserID", UserID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            rpCommunication.DataSource = rd
            rpCommunication.DataBind()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        rpCommunication.Visible = rpCommunication.Items.Count > 0
        pnlNoCommunication.Visible = rpCommunication.Items.Count = 0

    End Sub

    Private Sub LoadAllEmails()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("[stp_GetAllCommunicationForUser]")

        DatabaseHelper.AddParameter(cmd, "ReturnTop", "5")
        DatabaseHelper.AddParameter(cmd, "Type", "type='email'")
        DatabaseHelper.AddParameter(cmd, "UserID", UserID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            rpCommunication.DataSource = rd
            rpCommunication.DataBind()

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

        rpCommunication.Visible = rpCommunication.Items.Count > 0
        pnlNoCommunication.Visible = rpCommunication.Items.Count = 0

    End Sub

    Protected Sub chkOpenOnly_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkOpenOnly.CheckedChanged
        LoadUpcomingTasks()
        LoadTabStrips()
        tsTasksView.TabPages(0).Selected = True
        tabIndex = 0
    End Sub

    Protected Sub chkTeamOpenOnly_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkTeamOpenOnly.CheckedChanged
        LoadTeamTasks()
        LoadTabStrips()
        tsTasksView.TabPages(1).Selected = True
        tabIndex = 1
    End Sub

    Protected Sub chkManagerOpenOnly_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkManagerOpenOnly.CheckedChanged
        LoadManagerTasks()
        LoadTabStrips()
        tsTasksView.TabPages(2).Selected = True
        tabIndex = 2
    End Sub

    Protected Sub rpSearches_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles rpSearches.ItemCommand

        Select Case e.CommandName.ToLower
            Case "search"

                SearchFor(e.CommandArgument)

        End Select

    End Sub

    Protected Sub lnkSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearch.Click

        SearchFor(txtSearch.Text)

    End Sub

    Private Sub SearchFor(ByVal Value As String)

        Dim qsb As New QueryStringBuilder()

        If Value.Length > 0 Then
            qsb("q") = Value
        Else
            qsb.Remove("q")
        End If

        Response.Redirect("~/search.aspx" & IIf(qsb.QueryString.Length > 0, "?" & qsb.QueryString, String.Empty))

    End Sub

    Private Sub SetAttributes()
        txtSearch.Attributes("onkeydown") = "if (window.event.keyCode == 13) {" & ClientScript.GetPostBackEventReference(lnkSearch, Nothing) & ";return false;}"
        txtSearchMyClients.Attributes("onkeydown") = "if (window.event.keyCode == 13) {" & ClientScript.GetPostBackEventReference(lnkSearchMyClients, Nothing) & ";return false;}"
        txtSearchMyClientsAttorney.Attributes("onkeydown") = "if (window.event.keyCode == 13) {" & ClientScript.GetPostBackEventReference(lnkSearchMyClientsAttorney, Nothing) & ";return false;}"
        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
    End Sub
#End Region
#Region "Agency"
    Protected Function GetBatchNumber(ByVal CommBatchId As Integer) As String
        Dim length As Integer = CType(Session("MaxBatchId"), Integer).ToString.Length
        Dim id As String = CommBatchId.ToString
        Return id.PadLeft(length, "0"c)
    End Function
    Private Sub LoadRemainingReceivables()
        'Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetRemainingReceivablesTotal")
        '    Using cmd.Connection
        '        DatabaseHelper.AddParameter(cmd, "commrecid", CommRecId)

        '        cmd.Connection.Open()
        '        cmd.CommandTimeout = 90

        '        Using rd As IDataReader = cmd.ExecuteReader()

        '            If rd.Read() Then
        '                ' lblReceivables.Text = DatabaseHelper.Peel_float(rd, "total").ToString("c")
        '            End If
        '        End Using
        '    End Using
        'End Using
        ''lblNow.Text = Now.ToString("dd MMM yyyy")
    End Sub
    Private Sub LoadGlobalRoadmap()
        Dim All As New Dictionary(Of Integer, Roadmap)

        'Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetGlobalRoadmap")
        '    Using cmd.Connection

        '        If Not AgencyId = -1 Then DatabaseHelper.AddParameter(cmd, "AgencyId", AgencyId)
        '        If Not AttorneyID = -1 Then DatabaseHelper.AddParameter(cmd, "attorneyid", AttorneyID)

        '        cmd.Connection.Open()

        '        Using rd As IDataReader = cmd.ExecuteReader()
        '            While rd.Read()
        '                Dim b As New Roadmap
        '                b.ClientStatusId = DatabaseHelper.Peel_int(rd, "ClientStatusID")
        '                b.ParentClientStatusId = DatabaseHelper.Peel_nint(rd, "ParentClientStatusId")
        '                b.Name = DatabaseHelper.Peel_string(rd, "ClientStatusName")
        '                b.Count = DatabaseHelper.Peel_int(rd, "Total")

        '                All.Add(b.ClientStatusId, b)

        '            End While
        '        End Using
        '    End Using
        'End Using

        Dim ToRemove As New List(Of Integer)

        'link up transfers to their parents
        For Each i As Integer In All.Keys
            Dim b As Roadmap = All(i)
            If b.ParentClientStatusId.HasValue Then
                Dim ParentClientStatusId As Integer = b.ParentClientStatusId.Value
                If All.ContainsKey(ParentClientStatusId) Then
                    Dim Parent As Roadmap = All(ParentClientStatusId)
                    Parent.Children.Add(b)
                    b.Parent = Parent
                    ToRemove.Add(i)
                End If
            End If
        Next

        'remove those now under their parents
        For Each i As Integer In ToRemove
            All.Remove(i)
        Next

        Dim Ordered As New List(Of Roadmap)
        For Each b As Roadmap In All.Values
            AddRecursive(b, Ordered, 0)
        Next

        rpGlobalRoadmap.DataSource = Ordered
        rpGlobalRoadmap.DataBind()
    End Sub
    Protected Function GetGRImg(ByVal b As Roadmap) As String
        Dim result As String = ""

        Dim parent As Roadmap = b.Parent
        While Not parent Is Nothing
            If parent.Parent IsNot Nothing Then
                If Not parent.IsLast Then
                    result = "&nbsp;&nbsp;<img src=""" & ResolveUrl("~/images/arrow_vertical.png") & """ border=""0""/>" & result
                Else
                    result = "&nbsp;&nbsp;<img src=""" & ResolveUrl("~/images/blank.png") & """ border=""0""/>" & result
                End If
            End If
            parent = parent.Parent

        End While


        If b.ParentClientStatusId.HasValue Then
            result += "&nbsp;&nbsp;<img src=""" & ResolveUrl("~/images/root" & IIf(b.IsLast, "end", "connector")) & "3.png"" border=""0""/>"
        End If

        Return result
    End Function
    Private Sub AddRecursive(ByVal b As Roadmap, ByVal lst As List(Of Roadmap), ByVal Level As Integer)
        lst.Add(b)
        b.Level = Level
        If b.Children.Count > 0 Then
            For Each child As Roadmap In b.Children

                AddRecursive(child, lst, Level + 1)
                b.Count += child.Count
            Next
            b.Children(b.Children.Count - 1).IsLast = True
        End If
    End Sub
    Protected Class Roadmap
        Private _ClientStatusId As Integer
        Private _ParentClientStatusId As Nullable(Of Integer)
        Private _Name As String
        Private _Children As New List(Of Roadmap)
        Private _Level As Integer
        Private _IsLast As Boolean
        Private _Count As Integer
        Private _parent As Roadmap

        Public Property Parent() As Roadmap
            Get
                Return _parent
            End Get
            Set(ByVal value As Roadmap)
                _parent = value
            End Set
        End Property
        Public Property Count() As Integer
            Get
                Return _Count
            End Get
            Set(ByVal value As Integer)
                _Count = value
            End Set
        End Property
        Public Property IsLast() As Boolean
            Get
                Return _IsLast
            End Get
            Set(ByVal value As Boolean)
                _IsLast = value
            End Set
        End Property
        Public Property Level() As Integer
            Get
                Return _Level
            End Get
            Set(ByVal value As Integer)
                _Level = value
            End Set
        End Property
        Public Property ClientStatusId() As Integer
            Get
                Return _ClientStatusId
            End Get
            Set(ByVal value As Integer)
                _ClientStatusId = value
            End Set
        End Property
        Public Property ParentClientStatusId() As Nullable(Of Integer)
            Get
                Return _ParentClientStatusId
            End Get
            Set(ByVal value As Nullable(Of Integer))
                _ParentClientStatusId = value
            End Set
        End Property
        Public Property Name() As String
            Get
                Return _Name
            End Get
            Set(ByVal value As String)
                _Name = value
            End Set
        End Property
        Public Property Children() As List(Of Roadmap)
            Get
                Return _Children
            End Get
            Set(ByVal value As List(Of Roadmap))
                _Children = value
            End Set
        End Property
    End Class
    Protected Sub lnkSearchMyClients_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchMyClients.Click
        Session("research_queries_clients_agency_aspx_s") = txtSearchMyClients.Text
        Response.Redirect("~/research/queries/clients/agency.aspx")
    End Sub
    Protected Sub lnkSearch_Roadmap_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearch_Roadmap.Click
        Select Case UserTypeId
            Case 5 'attorney
                Session("research_queries_clients_attorney_aspx_c") = txtRoadmap_ClientStatusId.Value
                Response.Redirect("~/research/queries/clients/attorney.aspx")
            Case 2 'agency
                Session("research_queries_clients_agency_aspx_c") = txtRoadmap_ClientStatusId.Value
                Response.Redirect("~/research/queries/clients/agency.aspx")
            Case 1 'internal
                Session("research_queries_clients_demographics_aspx_c") = txtRoadmap_ClientStatusId.Value
                Response.Redirect("~/research/queries/clients/demographics.aspx")
        End Select
    End Sub
#End Region
    Private Sub PushGraphSettings(ByVal mOffset As Integer, ByVal iCommRecID As String)
        Dim startdate As DateTime = New Date(Now.AddMonths(-2).Year, Now.AddMonths(-2).Month, 1)
        Dim enddate As DateTime = New Date(Now.Year, Now.Month, DateTime.DaysInMonth(Now.Year, Now.Month), 23, 59, 59)

        Session("CommissionGraph_EndDate") = enddate
        Session("CommissionGraph_StartDate") = startdate

        Context.Session("CommissionGraph_CommRecIDs") = iCommRecID
        Context.Session("CommissionGraph_CommRecIDop") = ""
        Context.Session("CommissionGraph_SplitBy") = 2
        Context.Session("CommissionGraph_GroupBy") = 0
        Context.Session("CommissionGraph_Spline") = False
        Context.Session("CommissionGraph_3D") = False
        Context.Session("CommissionGraph_PointLabels") = False
        Context.Session("CommissionGraph_PointMarkers") = False
        Context.Session("CommissionGraph_Titles") = False
    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        Dim ControlCol As New List(Of HtmlControl)

        If dvStats0.Visible Then
            tsStatistics.TabPages.Add(New TabPage("Master&nbsp;Financial", dvStats0.ClientID))
            ControlCol.Add(dvStats0)
        End If
        If dvStats1.Visible Then
            tsStatistics.TabPages.Add(New TabPage("Financial", dvStats1.ClientID))
            ControlCol.Add(dvStats1)
        End If
        If dvStats2.Visible Then
            tsStatistics.TabPages.Add(New TabPage("Clients", dvStats2.ClientID))
            ControlCol.Add(dvStats2)
        End If
        If dvStats3.Visible Then
            tsStatistics.TabPages.Add(New TabPage("Global&nbsp;Roadmap", dvStats3.ClientID))
            ControlCol.Add(dvStats3)
        End If

        For i As Integer = 0 To tsStatistics.TabPages.Count - 1
            ControlCol(i).Style("display") = IIf(tsStatistics.SelectedIndex = i, "block", "none")
        Next

        PendingCreditors()
        LoadTabStrips()
        If PermissionHelperLite.HasPermission(UserID, "Settlement Processing") Then
            SettlementProcessing1.LoadSettlementProcTabStrips()
        End If
        If PermissionHelperLite.HasPermission(UserID, "Non Deposit") Then
            NonDepositControl1.LoadTabStrips()
        End If
    End Sub
    Private Sub RenderToStringBuilder(ByVal sb As StringBuilder, ByVal c As Control)
        Dim vis As Boolean = c.Visible
        c.Visible = True
        Using sw As New StringWriter(sb)
            Using tw As New HtmlTextWriter(sw)
                c.RenderControl(tw)
            End Using
        End Using
        c.Visible = vis
    End Sub

    Dim CallBackResult As String = ""
    Public Function GetCallbackResult() As String Implements System.Web.UI.ICallbackEventHandler.GetCallbackResult
        Return CallBackResult
    End Function

    Public Sub RaiseCallbackEvent(ByVal eventArgument As String) Implements System.Web.UI.ICallbackEventHandler.RaiseCallbackEvent
        Dim sb As New StringBuilder

        Dim args() As String = eventArgument.Split("|")
        Dim type As String = args(0)

        Dim date1 As DateTime
        Dim date2 As DateTime
        Dim DateGrouping As Integer
        Dim DataPoints As Integer
        Dim Cumulative As Boolean
        Dim MonthOffset As Integer
        Dim iCommRecID As String
        Dim companyid As Integer
        Dim agencyid As Integer
        Dim li As ListItem

        If type.StartsWith("financial") Then
            date1 = DateTime.Parse(args(1))
            date2 = DateTime.Parse(args(2))
            txtTransDate1.Text = args(1)
            txtTransDate2.Text = args(2)
            companyid = CInt(Val(args(3)))
            li = ddlCompanyFinancial.Items.FindByValue(args(3))
            If Not IsNothing(li) Then
                li.Selected = True
            End If
            agencyid = CInt(args(4))
            li = ddlAgencyFinancial.Items.FindByValue(args(4))
            If Not IsNothing(li) Then
                li.Selected = True
            End If
        ElseIf type.StartsWith("clients") Then
            DateGrouping = args(1)
            ListHelper.SetSelected(ddlChartGrouping_Stat, args(1))
            DataPoints = args(2)
            txtDataPoints.Value = args(2)
            Cumulative = Boolean.Parse(args(3))
            chkCumulative.Checked = Cumulative
        ElseIf type.StartsWith("master") Then
            MonthOffset = args(1)
            companyName = args(2)
            iCommRecID = args(3)
            ListHelper.SetSelected(ddlMonthOffset, args(1))
        End If

        Save()

        Dim FunctionId As Integer = DataHelper.Nz_string(DataHelper.FieldLookup("tblFunction", "FunctionID", "FullName='Home-Statistics'"))
        Dim p As PermissionHelper.Permission = PermissionHelper.GetPermission(Context, Me.GetType.Name, FunctionId, UserID)
        If p Is Nothing OrElse p.CanDo(PermissionHelper.PermissionType.View) Then
            Select Case type
                Case "financial0" 'Trust accounts
                    LoadTrusts()
                    RenderToStringBuilder(sb, rpTrustAccounts)
                Case "financial1" 'Fees and Payments
                    LoadFeesAndPayments(date1, date2, companyid, agencyid)
                    RenderToStringBuilder(sb, rpFeesAndPayments)
                Case "financial2" 'Deposits
                    LoadDeposits(date1, date2, companyid, agencyid)
                    RenderToStringBuilder(sb, rpDeposits)
                Case "financial3" 'Commission
                    LoadCommission(date1, date2, companyid, agencyid)
                    RenderToStringBuilder(sb, rpCommission)
                Case "clients0" 'Clients
                    sb.Append(LoadClientStats(DateGrouping, DataPoints, Cumulative))
                Case "clients1" 'Client Deposits
                    sb.Append(LoadClientDeposits(DataPoints))
                Case "clients2" 'Longevity
                    sb.Append(LoadClientLongevity(DateGrouping, DataPoints))
                Case "masterfinancial0" 'Projected Commission
                    'If UserTypeId = 2 Then
                    'sb.Append(LoadProjectedCommission(MonthOffset, CommRecId, companyName))
                    'PushGraphSettings(MonthOffset, CommRecId)
                    sb.Append(LoadProjectedCommission(MonthOffset, iCommRecID, companyName))
                    PushGraphSettings(MonthOffset, iCommRecID)
            End Select
        End If

        CallBackResult = sb.ToString
    End Sub

    Protected Sub lnkSearchMyClientsAttorney_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchMyClientsAttorney.Click
        Session("research_queries_clients_attorney_aspx_s") = txtSearchMyClientsAttorney.Text
        Response.Redirect("~/research/queries/clients/attorney.aspx")
    End Sub

    Protected Sub lnkAllEmail_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAllEmail.Click
        Response.Redirect("~/default.aspx?mode=E")
    End Sub

    Protected Sub lnkAllNotes_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAllNotes.Click
        Response.Redirect("~/default.aspx?mode=N")
    End Sub

    Protected Sub rpTeamTasks_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rpTeamTasks.ItemDataBound
        If e.Item.ItemType = ListItemType.AlternatingItem Or e.Item.ItemType = ListItemType.Item Then
            Dim tsk As New GridTask
            Dim ddlGroupUsers As DropDownList = CType(e.Item.FindControl("ddlGroupUsers"), DropDownList)
            Dim UserGroupId As String = DataBinder.Eval(e.Item.DataItem, "AssignedToGroupId").ToString()
            'Convert.ToString(DataBinder.Eval(e.Item.DataItem, "AssignedToGroupId"))
            Dim cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetUsers")
            DatabaseHelper.AddParameter(cmd, "where", "tbluser.usergroupid=" & UserGroupId & " and tbluser.Locked=0 and tbluser.Temporary=0 and tbluser.System=0 ")

            Dim UserAssignId As String = DataBinder.Eval(e.Item.DataItem, "AssignedToId").ToString()
            'Convert.ToString(DataBinder.Eval(e.Item.DataItem, "AssignedTo"))

            Dim rd As IDataReader = Nothing
            Try

                cmd.Connection.Open()
                rd = cmd.ExecuteReader()

                While rd.Read()
                    ddlGroupUsers.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "FirstName") & " " & DatabaseHelper.Peel_string(rd, "LastName"), DatabaseHelper.Peel_int(rd, "UserId")))
                End While
                ddlGroupUsers.Items.Insert(0, New ListItem(" -- Select -- ", 0))
                ddlGroupUsers.SelectedIndex = ddlGroupUsers.Items.IndexOf(ddlGroupUsers.Items.FindByValue(UserAssignId))
            Finally
                DatabaseHelper.EnsureReaderClosed(rd)
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try

            If UserIsManager Then
                CType(e.Item.FindControl("tdAssignItem"), HtmlControls.HtmlTableCell).Visible = True
            Else
                CType(e.Item.FindControl("tdAssignItem"), HtmlControls.HtmlTableCell).Visible = False
            End If
        End If
    End Sub

    Protected Sub lnkUpdateTaskUsers_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUpdateTaskUsers.Click
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
        cmd.CommandText = "Update tbltask set AssignedTo=@AssignedTo where taskid=@taskid"
        cmd.Connection.Open()
        Try
            For Each item In rpTeamTasks.Items
                Dim ddlGroupUsers As DropDownList = CType(item.FindControl("ddlGroupUsers"), DropDownList)
                Dim AssignedUserId As Int32 = Convert.ToInt32(ddlGroupUsers.SelectedValue)
                Dim TaskId As Int32 = Convert.ToInt32(CType(item.FindControl("hdnTaskID"), HtmlInputHidden).Value.Trim())
                cmd.Parameters.Clear()
                DatabaseHelper.AddParameter(cmd, "taskid", TaskId)
                DatabaseHelper.AddParameter(cmd, "AssignedTo", AssignedUserId)
                cmd.ExecuteNonQuery()
            Next
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
        Response.Redirect("~/default.aspx")
    End Sub

End Class