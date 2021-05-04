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

Partial Class research_reports_matters_tasks_tasksreport
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

        If Not IsPostBack Then
            'Dim da As SqlDataAdapter
            'Dim ds As New DataSet
            'Dim CompanyIDs As String

            'Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            '    Using cmd.Connection
            '        CompanyIDs = DataHelper.FieldLookup("tblUserCompany", "CompanyIDs", "UserID = " & UserID)

            '        cmd.CommandText = "SELECT CompanyID, ShortCoName FROM tblCompany"

            '        If Len(CompanyIDs) > 0 Then
            '            cmd.CommandText &= " WHERE CompanyID in (" & CompanyIDs & ")"
            '        End If

            '        cmd.CommandText &= " ORDER BY ShortCoName"

            '        da = New SqlDataAdapter(cmd)
            '        da.Fill(ds)

            '        'ddlCompany.DataSource = ds.Tables(0)
            '        'ddlCompany.DataTextField = "ShortCoName"
            '        'ddlCompany.DataValueField = "CompanyID"
            '        'ddlCompany.DataBind()
            '    End Using
            'End Using

            company = Request.QueryString("company")

            'If Len(company) > 0 Then
            '    ddlCompany.Items.FindByValue(company).Selected = True
            'Else
            '    company = ddlCompany.Items(0).Value
            'End If
        End If

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT MatterID FROM tblMatter Where ActiveFlag=1"
                cmd.Connection.Open()
                trust = CInt(cmd.ExecuteScalar())
            End Using
        End Using

        If Not qs Is Nothing Then

            LoadMatterTasks()

            If Not IsPostBack Then
                Session("Exp1") = String.Empty
                Session("Exp2") = String.Empty
                LoadValues(GetControls(), Me)
                LoadQuickPickDates()

                Requery(False)

            End If

            SetAttributes()

        End If

    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        'Response.Redirect(ResolveUrl("~/research/reports/financial/commission/batchpaymentssummaryxls.ashx"))

        strQuery = "Select T.TaskID, M.MatterID, T.Created as CreatedDate, T.Due as DueDate," & _
     " Case T.TaskTypeID When 0 Then 'Ad Hoc'Else (Select [Name] from tbltasktype Where TaskTypeID=T.TaskTypeID) End as TaskType," & _
     " (Select FirstName+' '+ LastName from tbluser Where UserID=T.AssignedTo) as AssignedTo, T.Description," & _
     " (Select FirstName+' '+ LastName from tbluser Where UserID=T.CreatedBy) as CreatedBy, T.Resolved" & _
     " FROM dbo.tblMatter R, dbo.tblMatterTask M, dbo.tblTask T  Where (T.TaskID = M.TaskID AND M.MatterID=R.MatterID and R.ActiveFlag=1) "

        Response.Clear()

        Response.AddHeader("content-disposition", "attachment;filename=Taskreport.xls")

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

        If optMatterChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optMatterChoice.ID, "value", _
                optMatterChoice.SelectedValue)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csMatterNoteID.ID, "store", csMatterNoteID.SelectedStr)

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
        'Session("Exp3") = String.Empty
        'Session("Exp4") = String.Empty
        'Session("Exp5") = String.Empty
        'Session("Exp6") = String.Empty
        'blow away all settings in table
        Clear()

        'reload page
        Refresh()

    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

        AddControl(pnlBody, c, "Research-Reports-Litigation-Tasks-Tasks Report")

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
    Private Sub LoadMatterTasks()

        csMatterNoteID.Items.Clear()
        csMatterNoteID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT MatterId, MatterMemo as Name FROM tblMatter Where ActiveFlag=1 ORDER BY MatterId"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim MatterID As Integer = DatabaseHelper.Peel_int(rd, "MatterId")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "Name")
                        csMatterNoteID.AddItem(New ListItem(Name, MatterID))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csMatterNoteID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csMatterNoteID.ID + "'")
        End If
    End Sub

    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)

        c.Add(optMatterChoice.ID, optMatterChoice)
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
        Dim itemCount As Int32 = 0
        If optMatterChoice.Items(0).Selected Then
            For itemCount = 0 To csMatterNoteID.SelectedList.Count - 1
                If strExp1 = String.Empty Then
                    strExp1 = " MatterID = " & csMatterNoteID.SelectedList.Item(itemCount)
                Else
                    strExp1 = strExp1 & " and  MatterID = " & csMatterNoteID.SelectedList.Item(itemCount)
                End If
            Next itemCount
        ElseIf optMatterChoice.Items(1).Selected Then
            For itemCount = 0 To csMatterNoteID.SelectedList.Count - 1
                If strExp1 = String.Empty Then
                    strExp1 = " MatterID = " & csMatterNoteID.SelectedList.Item(itemCount)
                Else
                    strExp1 = strExp1 & " or  MatterID = " & csMatterNoteID.SelectedList.Item(itemCount)
                End If
            Next itemCount
        End If
        If strExp1 <> String.Empty Then
            ' dv.RowFilter = strExp
            Session("Exp1") = strExp1
        Else
            Session("Exp1") = String.Empty
        End If

        Dim strExp2 As String = String.Empty
        If txtTransDate1.Text <> "" And txtTransDate2.Text <> "" Then
            'strExp = "matterdate BETWEEN  '" & txtMatterDate1.Text & "' AND '" & txtMatterDate2.Text & "' "
            strExp2 = "DueDate >=  '" & txtTransDate1.Text & "' AND DueDate <='" & txtTransDate2.Text & "' "

        ElseIf txtTransDate1.Text <> "" Then
            strExp2 = "DueDate >= '" & txtTransDate1.Text & "'"
        ElseIf txtTransDate2.Text <> "" Then
            strExp2 = "DueDate <= '" & txtTransDate2.Text & "'"
        End If

        If strExp2 <> String.Empty Then
            ' dv.RowFilter = strExp
            Session("Exp2") = strExp2
        Else
            Session("Exp2") = String.Empty
        End If


        Dim strExp As String = String.Empty
        If strExp1 <> String.Empty Then
            strExp = " ( " & strExp1 & " ) "
        End If
        If strExp2 <> String.Empty Then
            strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp2 & " ) "
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
        strQuery = "Select T.TaskID, M.MatterID, T.Created as CreatedDate, T.Due as DueDate," & _
     " Case T.TaskTypeID When 0 Then 'Ad Hoc'Else (Select [Name] from tbltasktype Where TaskTypeID=T.TaskTypeID) End as TaskType," & _
     " (Select FirstName+' '+ LastName from tbluser Where UserID=T.AssignedTo) as AssignedTo, T.Description," & _
     " (Select FirstName+' '+ LastName from tbluser Where UserID=T.CreatedBy) as CreatedBy, T.Resolved" & _
     " FROM dbo.tblMatter R, dbo.tblMatterTask M, dbo.tblTask T  Where (T.TaskID = M.TaskID AND M.MatterID=R.MatterID and R.ActiveFlag=1) "

        If Reset = True Then
            gvResults.PageIndex = 0
            gvResults.DataSource = GetData()
            'requery build query process
        Else
            'get the conditions from session and build the command
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()  '   CreateCommand ("stp_GetMattertasks2")

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
                'If strExp <> String.Empty Then dv.RowFilter = strExp
            End If
            Dim strExp2 As String = String.Empty
            If Not IsNothing(Session("Exp2")) Then
                strExp2 = Session("Exp2").ToString()
                'If strExp <> String.Empty Then dv.RowFilter = strExp
            End If

            Dim strExp As String = String.Empty
            If strExp1 <> String.Empty Then
                strExp = " ( " & strExp1 & " ) "
            End If
            If strExp2 <> String.Empty Then
                strExp = strExp & IIf(strExp = String.Empty, "", " AND ").ToString() & " ( " & strExp2 & " ) "
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
        'Dim Tasks As New List(Of GridTask)
        'Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetMattertasks2")
        '    Using cmd.Connection

        '        DatabaseHelper.AddParameter(cmd, "MatterId", MatterId)
        '        'DatabaseHelper.AddParameter(cmd, "OrderBy", GetFullyQualifiedNameForCalls(SortField) + " " + SortOrder)
        '        DatabaseHelper.AddParameter(cmd, "OrderBy", GetFullyQualifiedNameForTasks(SortField) + " " + SortOrder)

        '        cmd.Connection.Open()
        '        Using rd As IDataReader = cmd.ExecuteReader()
        '            While rd.Read
        '                Dim tsk As New GridTask

        '                tsk.TaskID = DatabaseHelper.Peel_int(rd, "TaskID")
        '                tsk.AssignedTo = Convert.ToString(DatabaseHelper.Peel_string(rd, "AssignedTo"))
        '                tsk.TaskType = Convert.ToString(DatabaseHelper.Peel_string(rd, "TaskType"))
        '                tsk.TaskDescription = DatabaseHelper.Peel_string(rd, "Description")
        '                tsk.StartDate = DatabaseHelper.Peel_date(rd, "CreatedDate")
        '                tsk.DueDate = DatabaseHelper.Peel_date(rd, "DueDate")
        '                tsk.CreatedBy = Convert.ToString(DatabaseHelper.Peel_string(rd, "CreatedBy"))
        '                tsk.ResolvedDate = DatabaseHelper.Peel_ndate(rd, "Resolved")
        '                Tasks.Add(tsk)


        '            End While
        '        End Using
        '    End Using
        'End Using

        'rpTasks.DataSource = Tasks
        'rpTasks.DataBind()

        'rpTasks.Visible = rpTasks.Items.Count > 0
        If gvResults.Rows.Count = 0 Then
            pnlNoTasks.Visible = True ' Not (gvResults.Rows.Count > 0)
        Else
            pnlNoTasks.Visible = False ' Not (gvResults.Rows.Count > 0)

        End If
        'hdnTasksCount.Value = rpTasks.Items.Count

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

        Dim l As List(Of String) = csMatterNoteID.SelectedList
        If l.Count <= 0 Then l = csMatterNoteID.EntireList
        DatabaseHelper.AddParameter(cmd, "MatterIds", String.Join(",", l.ToArray()))
        'DatabaseHelper.AddParameter(cmd, "CompanyID", ddlCompany.SelectedItem.Value)
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
        ElseIf e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.Cells(6).Text.Trim() <> "&nbsp;" Then
                e.Row.Cells(6).Text = CType(e.Row.Cells(6).Text, DateTime).ToString("dd MMM, yyyy hh:mm:ss tt")
                e.Row.Cells(7).Text = "RESOLVED"
            ElseIf CType(e.Row.Cells(5).Text, DateTime) < Now() Then
                e.Row.Cells(7).Text = "PAST DUE"
            Else
                e.Row.Cells(7).Text = "OPEN"
            End If
            If e.Row.Cells(4).Text.Trim() <> "&nbsp;" And e.Row.Cells(6).Text.Trim() <> "&nbsp;" Then

                Dim Dur As TimeSpan
                Dur = CType(e.Row.Cells(6).Text, DateTime) - CType(e.Row.Cells(4).Text, DateTime)

                'Return Math.Round(Dur.TotalHours, 2).ToString()
                e.Row.Cells(8).Text = Dur.Days & "d:" & Dur.Hours & "h:" & Dur.Minutes & "m:" & Dur.Seconds & "s"

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
        Requery(False)
    End Sub
End Class