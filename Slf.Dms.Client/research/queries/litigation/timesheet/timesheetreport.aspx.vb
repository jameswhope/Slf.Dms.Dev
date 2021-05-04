Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports LocalHelper

Structure sAgency
    Public AgencyName As String
    Public ParentCommRec As Dictionary(Of Integer, sParentCommRec)
End Structure

Structure sParentCommRec
    Public CommRec As Dictionary(Of Integer, sCommRec)
End Structure

Structure sCommRec
    Public Level As Integer
    Public IsLast As Boolean
    Public CommRec As String
    Public EntryType As Dictionary(Of Integer, sEntryType)
End Structure

Structure sEntryType
    Public Amount As Single
    Public TransferAmount As Single
    Public AmountPaid As Single
End Structure

Public Structure GridTask
    Dim TaskID As Integer
    Dim TaskType As String
    Dim TaskDescription As String
    Dim CreatedBy As String
    Dim AssignedTo As String
    Dim StartDate As DateTime
    Dim DueDate As DateTime
    Dim ResolvedDate As Nullable(Of DateTime)
    'Dim Duration As String
    Dim Value As String
    Dim Color As String
    Dim TextColor As String
    Dim BodyColor As String


    ReadOnly Property Status() As String
        Get

            If ResolvedDate.HasValue Then
                Return "RESOLVED"
            Else

                If DueDate < Now Then
                    Return "PAST DUE"
                Else
                    Return "OPEN"
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

Partial Class research_reports_matters_timesheet_timesheetreport
    Inherits PermissionPage


#Region "Variables"

    Private UserID As Integer
    Private qs As QueryStringCollection
    Private company As String
    Private trust As Integer
    Private SortField As String
    Private SortOrder As String
    Private Headers As Dictionary(Of String, HtmlTableCell)
    Private HeadersTasks As Dictionary(Of String, HtmlTableCell)
    Public MatterId As Integer

    Private strSortExp As String = String.Empty
    Private strSortDir As String = String.Empty
    Private strQuery As String = String.Empty

    Private Function GetFullyQualifiedNameForTasks(ByVal s As String) As String
        Select Case s
            Case "Th5"
                Return "TaskType"
            Case "Th6"
                Return "T.Description"
            Case "Th7"
                Return "CreatedBy"
            Case "Th8"
                Return "AssignedTo"
            Case "Th9"
                Return "CreatedDate"
            Case "Th10"
                Return "DueDate"
            Case "Th11"
                Return "T.Resolved"
        End Select
        Return "CreatedBy"
    End Function

#End Region

#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        qs = LoadQueryString()

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT MatterID FROM tblMatter Where IsDeleted=0"
                cmd.Connection.Open()
                trust = CInt(cmd.ExecuteScalar())
            End Using
        End Using

        If Not qs Is Nothing Then

            If Not IsPostBack Then
                LoadCompanies()
                LoadLocalCounsel()
                Session("Exp1") = String.Empty 'AttorneyID
                Session("Exp2") = String.Empty 'Dates
                Session("Exp3") = String.Empty 'CompanyID
                LoadValues(GetControls(), Me)
                LoadQuickPickDates()

                Requery(False)

            End If

            SetAttributes()

        End If

    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        strQuery = "select tmt.MatterTimeExpenseId, tm.MatterId, tm.MatterNumber, ta.Firstname+' '+ta.LastName as Attorney, ta.attorneyid as AttorneyID, " & _
        " tp.FirstName+' ' +tp.LastName as [Client], tc.clientid, co.Companyid as CompanyID, co.Name [CompanyName], " & _
        " tmt.BillableTime, CONVERT(VARCHAR,tmt.billrate,1) BillRate, tmt.TimeExpenseDescription, tmt.TimeExpenseDatetime, " & _
        " cast(CONVERT(VARCHAR,cast(CONVERT(VARCHAR,tmt.BillableTime,0) as decimal(18,2)) * cast(CONVERT(VARCHAR,tmt.billrate,0) as decimal(18,2)),0) as decimal(18,2)) SubTotal  " & _
        " from dbo.tblClient tc INNER JOIN dbo.tblPerson tp ON tp.PersonId = tc.PrimaryPersonId INNER JOIN tblCompany co on co.CompanyId = tc.Companyid INNER JOIN " & _
        " tblMatter tm on tm.ClientId = tc.ClientId INNER JOIN tblMatterTimeExpense tmt on tm.matterid = tmt.matterid INNER JOIN " & _
        " tblAttorney ta on  tmt.attorneyid = ta.attorneyid where tm.IsDeleted=0"

        Response.Clear()

        Response.AddHeader("content-disposition", "attachment;filename=ExpenseEntryreport.xls")

        Response.Charset = ""

        Response.Cache.SetCacheability(HttpCacheability.NoCache)

        Response.ContentType = "application/vnd.xls"

        Dim stringWrite As System.IO.StringWriter = New System.IO.StringWriter

        Dim htmlWrite As System.Web.UI.HtmlTextWriter = New HtmlTextWriter(stringWrite)

        Dim dv As DataView = GetData()
        gvResults.AllowPaging = False
        gvResults.AllowSorting = False
        gvResults.DataSource = dv
        gvResults.DataBind()

        gvResults.RenderControl(htmlWrite)

        gvResults.AllowPaging = True
        gvResults.AllowSorting = True
        Requery(False)

        Response.Write(stringWrite.ToString())

        Response.End()
    End Sub

    Private Sub Save()

        'blow away current stuff first
        Clear()

        'If optMatterChoice.SelectedValue = 0 Then
        '    QuerySettingHelper.Insert(Me.GetType().Name, UserID, optMatterChoice.ID, "value", _
        '        optMatterChoice.SelectedValue)
        'End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, ddlCompany.ID, "store", ddlCompany.SelectedValue)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, ddlAttorney.ID, "store", ddlAttorney.SelectedValue)

        If txtTransDate1.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate1.ID, "value", _
                txtTransDate1.Text)
        End If

        If txtTransDate2.Text.Length > 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, txtTransDate2.ID, "value", _
                txtTransDate2.Text)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, ddlQuickPickDate.ID, "index", _
                    ddlQuickPickDate.SelectedIndex)

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkBreakdownFeeTypes.ID, "value", _
                    chkBreakdownFeeTypes.Checked)
        QuerySettingHelper.Insert(Me.GetType().Name, UserID, chkGroupByAgency.ID, "value", _
                    chkGroupByAgency.Checked)

    End Sub

    Private Sub Clear()

        'delete all settings for this user on this query
        QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "'")

        If Not lnkShowFilter.Attributes("class") = "gridButtonSel" Then 'is selected

            'insert settings
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "tdFilter", "style", "display:none")
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "lnkShowFilter", "attribute", "class=gridButton")

        End If

    End Sub

    Protected Sub lnkShowFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowFilter.Click

        If lnkShowFilter.Attributes("class") = "gridButtonSel" Then 'is selected

            'insert settings
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "tdFilter", "style", "display:none")
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, "lnkShowFilter", "attribute", "class=gridButton")

        Else 'is NOT selected

            'just delete the settings  - which will select on refresh
            QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name _
                & "' AND [Object] IN ('tdFilter', 'lnkShowFilter')")

        End If

        Refresh()

    End Sub

    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click

        'insert settings to table
        Save()

        'reload page
        ' Refresh()
        Requery(True)

    End Sub

    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click
        Session("Exp1") = String.Empty
        Session("Exp2") = String.Empty
        Session("Exp3") = String.Empty
        'Session("Exp4") = String.Empty
        'Session("Exp5") = String.Empty
        'Session("Exp6") = String.Empty
        'blow away all settings in table
        Clear()

        'reload page
        Refresh()

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

        AddControl(pnlBody, c, "Research-Reports-Litigation-TimeSheet-Matter Expense Entry")

    End Sub
#End Region
#Region "Util"
    Private Sub SetAttributes()

        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"

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

    Private Sub Refresh()
        'Dim redir As String = "http://" + Request.ServerVariables("SERVER_NAME") + Request.ServerVariables("URL") + "?company=" + ddlCompany.SelectedItem.Value
        'Dim redir As String = Request.ServerVariables("URL") + "?company=" + ddlCompany.SelectedItem.Value

        Response.Redirect(Request.Url.AbsoluteUri)
        'Response.Redirect(redir)
    End Sub

    Protected Function GetArrowImg(ByVal b As BatchPaymentsSummary_Recipient) As String
        Dim result As String = ""

        Dim parent As BatchPaymentsSummary_Recipient = b.Parent
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


        If b.ParentCommRecId.HasValue And b.Parent IsNot Nothing Then
            result += "&nbsp;&nbsp;<img src=""" & ResolveUrl("~/images/arrow_" & IIf(b.IsLast, "end", "connector")) & ".png"" border=""0""/>"
        End If

        Return result
    End Function

    Private Sub LoadQuickPickDates()
        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yyyy") & "," & Now.ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yyyy") & "," & Now.AddDays(-1).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yyyy")))

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

    Private Sub LoadLocalCounsel()
        ddlAttorney.Items.Clear()
        ddlAttorney.Items.Add(New ListItem(" -- Select --", "0"))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                'cmd.CommandText = "SELECT A.AttorneyID, A.FirstName, A.LastName FROM tblAttorney A, tblMatter M Where A.AttorneyID=M.AttorneyID order by FirstName"
                cmd.CommandText = "SELECT distinct A.AttorneyID, A.FirstName, A.LastName FROM tblAttorney A order by A.FirstName"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim EntryTypeID As Integer = DatabaseHelper.Peel_int(rd, "AttorneyID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "FirstName") & " " & DatabaseHelper.Peel_string(rd, "LastName")
                        ddlAttorney.Items.Add(New ListItem(Name, EntryTypeID))
                    End While
                End Using
            End Using
        End Using
        'If Not IsPostBack Then
        '    ddlAttorney.SelectedValue = DataHelper.FieldLookup("tblQuerySetting", "Value", _
        '        "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & ddlAttorney.ID + "'")
        'End If
    End Sub

    Private Sub LoadCompanies()
        ddlCompany.Items.Clear()
        ddlCompany.Items.Add(New ListItem(" -- Select --", "0"))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT CompanyID, Name FROM tblCompany order by Name"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim EntryTypeID As Integer = DatabaseHelper.Peel_int(rd, "CompanyID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
                        ddlCompany.Items.Add(New ListItem(Name, EntryTypeID))
                    End While
                End Using
            End Using
        End Using
        'If Not IsPostBack Then
        '    ddlCompany.SelectedValue = DataHelper.FieldLookup("tblQuerySetting", "Value", _
        '        "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & ddlCompany.ID + "'")
        'End If
    End Sub

    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        'c.Add(optMatterChoice.ID, optMatterChoice)
        c.Add(chkBreakdownFeeTypes.ID, chkBreakdownFeeTypes)
        c.Add(chkGroupByAgency.ID, chkGroupByAgency)
        c.Add(lnkShowFilter.ID, lnkShowFilter)
        c.Add(tdFilter.ID, tdFilter)
        c.Add(txtTransDate1.ID, txtTransDate1)
        c.Add(txtTransDate2.ID, txtTransDate2)

        Return c

    End Function
#End Region
#Region "Query"

    Public Sub SetSortImageTasks()
        HeadersTasks(SortField).Controls.Add(GetSortImage(SortOrder))
    End Sub
    Private Function GetSortImage(ByVal SortOrder As String) As HtmlImage
        Dim img As HtmlImage = New HtmlImage()
        img.Src = ResolveUrl("~/images/sort-" & SortOrder & ".png")
        img.Align = "absmiddle"
        img.Border = 0
        img.Style("margin-left") = "5px"
        Return img
    End Function
    Private Sub LoadHeadersTasks()
        'HeadersTasks = New System.Collections.Generic.Dictionary(Of String, HtmlTableCell)()
        'AddHeader(HeadersTasks, Th5)
        'AddHeader(HeadersTasks, Th6)
        'AddHeader(HeadersTasks, Th7)
        'AddHeader(HeadersTasks, Th8)
        'AddHeader(HeadersTasks, Th9)
        'AddHeader(HeadersTasks, Th10)
        'AddHeader(HeadersTasks, Th11)
    End Sub

    Private Sub AddHeader(ByVal c As System.Collections.Generic.Dictionary(Of String, HtmlTableCell), ByVal td As HtmlTableCell)
        c.Add(td.ID, td)
    End Sub

    Private Function GetData() As DataView
        ''Setup the DataCommand
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand() '   CreateCommand ("stp_GetMattertasks2")
        cmd.CommandText = strQuery
        cmd.CommandType = CommandType.Text
        'cmd.CommandTimeout = 180
        Dim ds As New DataSet
        Dim sqlDA As New SqlDataAdapter(cmd)
        sqlDA.Fill(ds)
        Dim dv As DataView = ds.Tables(0).DefaultView

        Dim strExp1 As String = String.Empty

        If ddlAttorney.SelectedValue > 0 Then
            If strExp1 = String.Empty Then
                strExp1 = " AttorneyID = " & ddlAttorney.SelectedValue
            Else
                strExp1 = strExp1 & " and  AttorneyID = " & ddlAttorney.SelectedValue
            End If
        End If

        Dim strExp2 As String = String.Empty
        If txtTransDate1.Text <> "" And txtTransDate2.Text <> "" Then
            strExp2 = "TimeExpenseDatetime >=  '" & txtTransDate1.Text & "' AND TimeExpenseDatetime <='" & txtTransDate2.Text & "' "
        ElseIf txtTransDate1.Text <> "" Then
            strExp2 = "TimeExpenseDatetime >= '" & txtTransDate1.Text & "'"
        ElseIf txtTransDate2.Text <> "" Then
            strExp2 = "TimeExpenseDatetime <= '" & txtTransDate2.Text & "'"
        End If

        If strExp2 <> String.Empty Then
            Session("Exp2") = strExp2
        Else
            Session("Exp2") = String.Empty
        End If

        Dim strExp3 As String = String.Empty
        If strExp3 <> String.Empty Then
            Session("Exp3") = strExp3
        Else
            Session("Exp3") = String.Empty
        End If

        If ddlCompany.SelectedValue > 0 Then
            If strExp3 = String.Empty Then
                strExp3 = " CompanyID = " & ddlCompany.SelectedValue
            Else
                strExp3 = strExp3 & " and  CompanyID = " & ddlCompany.SelectedValue
            End If
        End If

        Dim strExp As String = String.Empty
        If strExp1 <> String.Empty Then
            strExp = " ( " & strExp1 & " ) "
        End If
        If strExp2 <> String.Empty Then
            strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp2 & " ) "
        End If

        If strExp3 <> String.Empty Then
            strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp3 & " ) "
        End If

        If strExp <> String.Empty Then
            dv.RowFilter = strExp
        End If

        If Not IsNothing(ViewState("strSortExp")) Then
            strSortExp = ViewState("strSortExp")
        End If
        If Not IsNothing(ViewState("strSortDir")) Then
            strSortDir = ViewState("strSortDir")
        End If
        If strSortExp <> "" Then
            dv.Sort = strSortExp & IIf(strSortDir = "0", " asc", " desc")
        End If
        Return dv
    End Function

    Private Sub Requery(ByVal Reset As Boolean)
        'strQuery = "Select T.TaskID, M.MatterID, T.Created as CreatedDate, T.Due as DueDate," & _
        '" Case T.TaskTypeID When 0 Then 'Ad Hoc'Else (Select [Name] from tbltasktype Where TaskTypeID=T.TaskTypeID) End as TaskType," & _
        '" (Select FirstName+' '+ LastName from tbluser Where UserID=T.AssignedTo) as AssignedTo, T.Description," & _
        '" (Select FirstName+' '+ LastName from tbluser Where UserID=T.CreatedBy) as CreatedBy, T.Resolved" & _
        '" FROM dbo.tblMatterTask M, dbo.tblTask T     Where(M.TaskID = T.TaskID)"

        strQuery = "select tmt.MatterTimeExpenseId, tm.MatterId, tm.MatterNumber, ta.Firstname+' '+ta.LastName as Attorney, ta.attorneyid as AttorneyID, " & _
        " tp.FirstName+' ' +tp.LastName as [Client], tc.clientid, co.Companyid as CompanyID, co.Name [CompanyName], " & _
        " tmt.BillableTime, CONVERT(VARCHAR,tmt.billrate,1) BillRate, tmt.TimeExpenseDescription, tmt.TimeExpenseDatetime, " & _
        " cast(CONVERT(VARCHAR,cast(CONVERT(VARCHAR,tmt.BillableTime,0) as decimal(18,2)) * cast(CONVERT(VARCHAR,tmt.billrate,0) as decimal(18,2)),0) as decimal(18,2)) SubTotal  " & _
        " from dbo.tblClient tc INNER JOIN dbo.tblPerson tp ON tp.PersonId = tc.PrimaryPersonId INNER JOIN tblCompany co on co.CompanyId = tc.Companyid INNER JOIN " & _
        " tblMatter tm on tm.ClientId = tc.ClientId INNER JOIN tblMatterTimeExpense tmt on tm.matterid = tmt.matterid INNER JOIN " & _
        " tblAttorney ta on  tmt.attorneyid = ta.attorneyid where tm.IsDeleted=0"

        If Reset = True Then
            gvResults.PageIndex = 0
            gvResults.DataSource = GetData()
            'requery build query process
        Else
            'get the conditions from session and build the command
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            cmd.CommandText = strQuery
            cmd.CommandType = CommandType.Text
            'cmd.CommandTimeout = 180
            Dim ds As New DataSet
            Dim sqlDA As New SqlDataAdapter(cmd)
            sqlDA.Fill(ds)
            Dim dv As DataView = ds.Tables(0).DefaultView

            Dim strExp1 As String = String.Empty
            If Not IsNothing(Session("Exp1")) Then
                strExp1 = Session("Exp1").ToString()
            End If

            Dim strExp2 As String = String.Empty
            If Not IsNothing(Session("Exp2")) Then
                strExp2 = Session("Exp2").ToString()
            End If

            Dim strExp3 As String = String.Empty
            If Not IsNothing(Session("Exp3")) Then
                strExp3 = Session("Exp3").ToString()
            End If

            Dim strExp As String = String.Empty
            If strExp1 <> String.Empty Then
                strExp = " ( " & strExp1 & " ) "
            End If
            If strExp2 <> String.Empty Then
                strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp2 & " ) "
            End If

            If strExp3 <> String.Empty Then
                strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp3 & " ) "
            End If

            If strExp <> String.Empty Then
                dv.RowFilter = strExp
            End If

            If Not IsNothing(ViewState("strSortExp")) Then
                strSortExp = ViewState("strSortExp")
            End If
            If Not IsNothing(ViewState("strSortDir")) Then
                strSortDir = ViewState("strSortDir")
            End If
            If strSortExp <> "" Then
                dv.Sort = strSortExp & IIf(strSortDir = "0", " asc", " desc")
            End If
            gvResults.DataSource = dv
        End If
        gvResults.DataBind()
        If gvResults.Rows.Count = 0 Then
            pnlNoTasks.Visible = True ' Not (gvResults.Rows.Count > 0)
        Else
            pnlNoTasks.Visible = False ' Not (gvResults.Rows.Count > 0)

        End If
    End Sub

    Private Sub GroupAsOne(ByRef Agencies As Dictionary(Of Integer, sAgency))
        Dim finalAgencies As New Dictionary(Of Integer, sAgency)
        Dim newAgency As New sAgency
        Dim newParentCommRec As sParentCommRec
        Dim newCommRec As sCommRec
        Dim newEntryType As sEntryType

        newAgency.AgencyName = "All Agencies"
        newAgency.ParentCommRec = New Dictionary(Of Integer, sParentCommRec)
        finalAgencies.Add(0, newAgency)

        For Each agency As sAgency In Agencies.Values
            For Each parentcommrecid As Integer In agency.ParentCommRec.Keys
                If Not finalAgencies(0).ParentCommRec.TryGetValue(parentcommrecid, Nothing) Then
                    newParentCommRec = New sParentCommRec
                    newParentCommRec.CommRec = New Dictionary(Of Integer, sCommRec)
                    finalAgencies(0).ParentCommRec.Add(parentcommrecid, newParentCommRec)
                End If
                For Each commrecid As Integer In agency.ParentCommRec(parentcommrecid).CommRec.Keys
                    If Not finalAgencies(0).ParentCommRec(parentcommrecid).CommRec.TryGetValue(commrecid, Nothing) Then
                        newCommRec = New sCommRec
                        newCommRec.CommRec = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).CommRec
                        newCommRec.EntryType = New Dictionary(Of Integer, sEntryType)
                        newCommRec.Level = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).Level
                        newCommRec.IsLast = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).IsLast
                        finalAgencies(0).ParentCommRec(parentcommrecid).CommRec.Add(commrecid, newCommRec)
                    End If
                    For Each entrytypeid As Integer In agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType.Keys
                        If Not finalAgencies(0).ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType.TryGetValue(entrytypeid, Nothing) Then
                            newEntryType = New sEntryType
                            newEntryType.Amount = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).Amount
                            newEntryType.TransferAmount = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).TransferAmount
                            newEntryType.AmountPaid = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).AmountPaid
                            finalAgencies(0).ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType.Add(entrytypeid, newEntryType)
                        Else
                            newEntryType = New sEntryType
                            newEntryType.Amount = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).Amount
                            newEntryType.TransferAmount = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).TransferAmount
                            newEntryType.AmountPaid = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).AmountPaid + finalAgencies(0).ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType(entrytypeid).AmountPaid
                            finalAgencies(0).ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType.Remove(entrytypeid)
                            finalAgencies(0).ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType.Add(entrytypeid, newEntryType)
                        End If
                    Next
                Next
            Next
        Next

        Agencies.Clear()
        Agencies = finalAgencies
    End Sub

    Private Sub OrderTree(ByRef Agencies As Dictionary(Of Integer, sAgency))
        Dim newAgency As New sAgency
        Dim newAgencies As New Dictionary(Of Integer, sAgency)
        Dim newParent As New sParentCommRec

        newAgency.AgencyName = "All Agencies"
        newAgency.ParentCommRec = New Dictionary(Of Integer, sParentCommRec)
        newAgencies.Add(0, newAgency)

        newParent.CommRec = New Dictionary(Of Integer, sCommRec)
        newAgencies(0).ParentCommRec.Add(0, newParent)

        For Each agency As sAgency In Agencies.Values
            AddRecursive(agency, newAgencies, trust, 0)
        Next

        Agencies.Clear()
        Agencies = newAgencies
    End Sub

    Private Sub AddRecursive(ByVal agency As sAgency, ByRef newAgencies As Dictionary(Of Integer, sAgency), ByVal parentcommrecid As Integer, ByVal level As Integer)
        If agency.ParentCommRec.TryGetValue(parentcommrecid, Nothing) Then
            Dim newRec As New sCommRec
            Dim count As Integer = 0
            level += 1
            For Each commrecid As Integer In agency.ParentCommRec(parentcommrecid).CommRec.Keys
                count += 1
                newRec = agency.ParentCommRec(parentcommrecid).CommRec(commrecid)
                newRec.Level = level
                If count = agency.ParentCommRec(parentcommrecid).CommRec.Count Then
                    newRec.IsLast = True
                End If
                newAgencies(0).ParentCommRec(0).CommRec.Add(newAgencies(0).ParentCommRec(0).CommRec.Count, newRec)
                AddRecursive(agency, newAgencies, commrecid, level)
            Next
        End If
    End Sub

    Private Sub RenderGrid(ByRef sb As StringBuilder, ByVal Agencies As Dictionary(Of Integer, sAgency), ByVal entryTypeNames As Dictionary(Of Integer, String))
        Dim netPayments As Single
        Dim grossDeposits As Single
        Dim entryTypeAmounts As sEntryType
        Dim totalFees As Dictionary(Of Integer, Single)
        Dim totalNet As Single
        Dim tempTotal As Single
        Dim lastLevel As Integer
        Dim even As Boolean

        sb = New StringBuilder

        For Each agency As sAgency In Agencies.Values
            If Not agency.AgencyName Is Nothing And agency.AgencyName.Length > 0 Then
                totalFees = New Dictionary(Of Integer, Single)
                If chkGroupByAgency.Checked = True Then
                    sb.Append("<tr><td>&nbsp;</td></tr>")
                    sb.Append("<tr><td><b>Agency: <u>" + agency.AgencyName + "</u></b></td></tr>")
                End If

                sb.Append("<tr><td>")

                sb.Append("<table class=""fixedlist"" onselectstart=""return false;"" style=""font-size:11px;font-family:tahoma"" cellspacing=""0"" cellpadding=""3"" width=""100%"" border=""0"">")
                sb.Append("<thead>")
                sb.Append("<tr><th style=""width:150px"">&nbsp;</th>")

                If chkBreakdownFeeTypes.Checked = True Then
                    For Each feetype As String In entryTypeNames.Values
                        sb.Append("<th align=""right"" style=""width:80px""><b>" + feetype + "</b></th>")
                    Next
                End If

                sb.Append("<th align=""right""><b>Gross Deposits</b></th>")
                sb.Append("<th style=""width:70px"" align=""right""><b>Net Payments</b></th>")
                sb.Append("</tr>")
                sb.Append("</thead>")
                sb.Append("<tbody>")

                even = True
                totalNet = 0

                For Each parentcommrecid As Integer In agency.ParentCommRec.Keys
                    For Each commrecid As Integer In agency.ParentCommRec(parentcommrecid).CommRec.Keys
                        netPayments = 0
                        grossDeposits = 0
                        even = Not even
                        sb.Append("<tr " + IIf(even, "style=""background-color:#f1f1f1;""", "") + "><td>")
                        If agency.ParentCommRec(parentcommrecid).CommRec(commrecid).Level > 1 Then
                            lastLevel = agency.ParentCommRec(parentcommrecid).CommRec(commrecid).Level
                            For i As Integer = 1 To agency.ParentCommRec(parentcommrecid).CommRec(commrecid).Level - 1
                                sb.Append("&nbsp;")
                            Next
                            If Not agency.ParentCommRec(parentcommrecid).CommRec(commrecid).Level > lastLevel And lastLevel > 2 Then
                                sb.Append("<img src=""" + ResolveUrl("~/images/arrow_vertical.png") + """ border=""0""/>")
                            End If
                            sb.Append("&nbsp;<img src=""" & ResolveUrl("~/images/arrow_" + IIf(agency.ParentCommRec(parentcommrecid).CommRec(commrecid).IsLast, "end", "connector")) + ".png"" border=""0""/>")
                        End If
                        sb.Append(agency.ParentCommRec(parentcommrecid).CommRec(commrecid).CommRec + "</td>")
                        For Each entrytypeid As Integer In entryTypeNames.Keys
                            If agency.ParentCommRec(parentcommrecid).CommRec(commrecid).EntryType.TryGetValue(entrytypeid, entryTypeAmounts) Then
                                If chkBreakdownFeeTypes.Checked = True Then
                                    sb.Append("<td align=""right"">" + entryTypeAmounts.AmountPaid.ToString("c") + "</td>")
                                End If
                                netPayments += entryTypeAmounts.AmountPaid
                                If totalFees.TryGetValue(entrytypeid, Nothing) Then
                                    tempTotal = totalFees.Item(entrytypeid) + entryTypeAmounts.AmountPaid
                                    totalFees.Remove(entrytypeid)
                                    totalFees.Add(entrytypeid, tempTotal)
                                Else
                                    totalFees.Add(entrytypeid, entryTypeAmounts.AmountPaid)
                                End If
                                grossDeposits = entryTypeAmounts.TransferAmount
                            Else
                                If chkBreakdownFeeTypes.Checked = True Then
                                    sb.Append("<td align=""right"">$0.00</td>")
                                End If
                                If Not totalFees.TryGetValue(entrytypeid, Nothing) Then
                                    totalFees.Add(entrytypeid, 0.0)
                                End If
                            End If
                        Next

                        totalNet += netPayments
                        sb.Append("<td align=""right"">")
                        sb.Append(grossDeposits.ToString("c"))
                        sb.Append("</td><td align=""right"">")
                        sb.Append(netPayments.ToString("c"))
                        sb.Append("</td></tr>")
                    Next
                Next

                sb.Append("</tbody><tfoot>")
                sb.Append("<tr><td><b>Total</b></td>")

                If chkBreakdownFeeTypes.Checked = True Then
                    For Each totalfee As Single In totalFees.Values
                        sb.Append("<td align=""right""><b>" + totalfee.ToString("c") + "</b></td>")
                    Next
                End If

                sb.Append("<td align=""right"">&nbsp;</td>")
                sb.Append("<td align=""right""><b>" + totalNet.ToString("c") + "</b></td>")

                sb.Append("</tfoot>")
                sb.Append("</table></td></tr>")
            End If
        Next
    End Sub

    Private Sub AddStdParams(ByVal cmd As IDbCommand)
        If txtTransDate1.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date1", DateTime.Parse(txtTransDate1.Text))
        If txtTransDate2.Text.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Date2", DateTime.Parse(txtTransDate2.Text))

        DatabaseHelper.AddParameter(cmd, "CompanyID", ddlCompany.SelectedItem.Value)
    End Sub

#End Region

    Protected Sub gvResults_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvResults.PageIndexChanging
        gvResults.PageIndex = e.NewPageIndex
        Requery(False)
    End Sub

    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)

    End Sub

    Protected Sub gvResults_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvResults.RowDataBound
        If e.Row.RowType = DataControlRowType.Header Then
            If Not IsNothing(ViewState("strSortExp")) Then
                strSortExp = ViewState("strSortExp")
            End If
            If Not IsNothing(ViewState("strSortDir")) Then
                strSortDir = ViewState("strSortDir")
            End If
            Dim field As DataControlField
            Dim cellIndex As Integer = -1
            For Each field In gvResults.Columns
                If field.SortExpression = strSortExp Then
                    cellIndex = gvResults.Columns.IndexOf(field)
                    Exit For
                End If
            Next
            If cellIndex > -1 Then
                'this is a header row,set the sort style
                e.Row.Cells(cellIndex).CssClass += IIf(strSortDir = "0", " sortasc", " sortdesc")
            End If
        End If
    End Sub

    Protected Sub gvResults_Sorted(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvResults.Sorted

    End Sub

    Protected Sub gvResults_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvResults.Sorting
        ViewState("strSortExp") = e.SortExpression
        If Not IsNothing(ViewState("strSortDir")) Then
            If ViewState("strSortDir") = "0" Then
                ViewState("strSortDir") = "1"
            Else
                ViewState("strSortDir") = "0"
            End If
        Else
            ViewState("strSortDir") = "0"
        End If
    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        'Requery(False)
    End Sub
End Class