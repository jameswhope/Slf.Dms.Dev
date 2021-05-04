Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls

Imports System.Data
Imports System.Collections.Generic
Imports LocalHelper

Partial Class research_metrics_financial_commissioncomparison
    Inherits PermissionPage

#Region "Variables"

    Private CommRecID As String
    Private UserTypeID As Integer
    Private UserID As Integer
    Public company As String

#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        UserTypeID = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserTypeId", "UserId=" & UserID))

        If Not IsPostBack Then
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
                        lblCommRec.Visible = True
                    Else
                        userPerm = UserID
                    End If

                    ddlCompany.Items.Clear()

                    cmd.CommandText = "SELECT isnull(CompanyIDs, 0) FROM tblUserCompany WHERE UserID = " + userPerm.ToString()
                    Dim companies() As String = cmd.ExecuteScalar().ToString().Split(",")
                    For Each cmp As Integer In companies
                        cmd.CommandText = "SELECT lower(ShortCoName) FROM tblCompany WHERE CompanyID = " + cmp.ToString()
                        cmpName = cmd.ExecuteScalar()
                        ddlCompany.Items.Add(New ListItem(StrConv(cmpName, VbStrConv.ProperCase), cmpName, True))
                    Next

                    ddlCompany.Items.Add(New ListItem("ALL", "all", True))
                End Using
            End Using

            company = Request.QueryString("company")

            If Len(company) > 0 Then
                ddlCompany.Items.FindByValue(company).Selected = True
            Else
                company = ddlCompany.Items(0).Value
            End If

            CommRecID = Request.QueryString("commrecs")

            If Len(CommRecID) > 0 Then
                ddlCommRec.Items.FindByValue(CommRecID).Selected = True
            Else
                If UserTypeID = 2 Then
                    CommRecID = CStr(DataHelper.Nz_int(DataHelper.FieldLookup("tblUser", "CommRecId", "UserId=" & UserID)))
                Else
                    CommRecID = ddlCommRec.Items(0).Value
                End If
            End If
        End If

        LoadRecipients()

        If Not IsPostBack Then
            'set default date
            Dim startdate As DateTime = New Date(Now.AddMonths(-2).Year, Now.AddMonths(-2).Month, 1)
            Dim enddate As DateTime = New Date(Now.Year, Now.Month, DateTime.DaysInMonth(Now.Year, Now.Month), 23, 59, 59)
            txtDate1.Text = startdate.ToString("MM/dd/yy")
            txtDate2.Text = enddate.ToString("MM/dd/yy")

            LoadValues(GetControls, Me)
        End If

        company = ddlCompany.SelectedValue

        PushSettings()

        If Not IsPostBack Then
            Requery()
        End If

        SetAttributes()

    End Sub
    Private Sub Save()

        'blow away current stuff first
        Clear()

        If optRecipientChoice.SelectedValue = 0 Then
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, optRecipientChoice.ID, "value", _
                optRecipientChoice.SelectedValue)
        End If

        QuerySettingHelper.Insert(Me.GetType().Name, UserID, csCommRecID.ID, "store", csCommRecID.SelectedStr)

        QuerySettingHelper.Insert(Me.GetType.Name, UserID, ddlGrouping.ID, "value", ddlGrouping.Value)
        QuerySettingHelper.Insert(Me.GetType.Name, UserID, ddlSplitting.ID, "value", ddlSplitting.Value)
        QuerySettingHelper.Insert(Me.GetType.Name, UserID, txtDate1.ID, "value", txtDate1.Text)
        QuerySettingHelper.Insert(Me.GetType.Name, UserID, txtDate2.ID, "value", txtDate2.Text)
        QuerySettingHelper.Insert(Me.GetType.Name, UserID, chkPointLabels.ID, "value", chkPointLabels.Checked)
        QuerySettingHelper.Insert(Me.GetType.Name, UserID, chkPointMarkers.ID, "value", chkPointMarkers.Checked)
        QuerySettingHelper.Insert(Me.GetType.Name, UserID, chkSpline.ID, "value", chkSpline.Checked)
        QuerySettingHelper.Insert(Me.GetType.Name, UserID, chk3D.ID, "value", chk3D.Checked)

        PushSettings()
    End Sub
    Private Sub PushSettings()
        If String.IsNullOrEmpty(txtDate1.Text) Then
            Context.Session.Remove("CommissionGraph_StartDate")
        Else
            Context.Session("CommissionGraph_StartDate") = DateTime.Parse(txtDate1.Text)
        End If
        If String.IsNullOrEmpty(txtDate2.Text) Then
            Context.Session.Remove("CommissionGraph_EndDate")
        Else
            Context.Session("CommissionGraph_EndDate") = DateTime.Parse(txtDate2.Text)
        End If

        If UserTypeID = 2 Then 'agency
            Context.Session("CommissionGraph_CommRecID") = CommRecID
            Context.Session("CommissionGraph_CommRecIDop") = ""
        ElseIf String.IsNullOrEmpty(csCommRecID.SelectedStr) Then
            Context.Session.Remove("CommissionGraph_CommRecID")
        Else
            Context.Session("CommissionGraph_CommRecID") = csCommRecID.SelectedStr.Replace("|", ",")
            Context.Session("CommissionGraph_CommRecIDop") = IIf(optRecipientChoice.SelectedIndex = 0, "not", "")
        End If

        Context.Session("CommissionGraph_SplitBy") = Integer.Parse(ddlSplitting.Value)
        Context.Session("CommissionGraph_GroupBy") = Integer.Parse(ddlGrouping.Value)
        Context.Session("CommissionGraph_3D") = chk3D.Checked
        Context.Session("CommissionGraph_Spline") = chkSpline.Checked
        Context.Session("CommissionGraph_PointLabels") = chkPointLabels.Checked
        Context.Session("CommissionGraph_PointMarkers") = chkPointMarkers.Checked
        Context.Session("CommissionGraph_Titles") = True
    End Sub
    Private Sub Clear()

        'delete all settings for this user on this query
        QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "'")

        If Not lnkShowFilter.Attributes("class") = "gridButtonSel" Then 'is selected

            'insert settings
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, tdFilter.ID, "style", "display:none")
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, lnkShowFilter.ID, "attribute", "class=gridButton")

        End If

        If Not lnkShowGrid.Attributes("class") = "gridButtonSel" Then 'is selected

            'insert settings
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, trGrid.ID, "style", "display:none")
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, lnkShowGrid.ID, "attribute", "class=gridButton")

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
    Protected Sub lnkShowGrid_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowGrid.Click

        If lnkShowGrid.Attributes("class") = "gridButtonSel" Then 'is selected

            'insert settings
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, trGrid.ID, "style", "display:none")
            QuerySettingHelper.Insert(Me.GetType().Name, UserID, lnkShowGrid.ID, "attribute", "class=gridButton")

        Else 'is NOT selected

            'just delete the settings  - which will select on refresh
            QuerySettingHelper.Delete("UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name _
                & "' AND [Object] IN ('" + trGrid.ID + "', 'lnkShowGrid')")

        End If

        Refresh()

    End Sub
    Protected Sub lnkRequery_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRequery.Click

        'insert settings to table
        Save()

        Refresh()

    End Sub
    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click

        'blow away all settings in table
        Clear()

        'reload page
        Refresh()

    End Sub
#End Region
#Region "Util"
    Private Sub SetAttributes()

    End Sub
    Private Sub LoadRecipients()
        csCommRecID.Items.Clear()
        csCommRecID.AddItem(New ListItem(" -- Select --", 0))

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "SELECT * FROM tblCommRec ORDER BY abbreviation"
                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        Dim CommRecID As Integer = DatabaseHelper.Peel_int(rd, "CommRecID")
                        Dim Name As String = DatabaseHelper.Peel_string(rd, "abbreviation")
                        csCommRecID.AddItem(New ListItem(Name, CommRecID))
                    End While
                End Using
            End Using
        End Using
        If Not IsPostBack Then
            csCommRecID.SelectedStr = DataHelper.FieldLookup("tblQuerySetting", "Value", _
                "UserID = " & UserID & " AND ClassName = '" & Me.GetType().Name & "' AND [Object] = '" & csCommRecID.ID + "'")

        End If
    End Sub
    Private Function GetControls() As Dictionary(Of String, Control)

        Dim c As New Dictionary(Of String, Control)


        c.Add(optRecipientChoice.ID, optRecipientChoice)
        c.Add(ddlGrouping.ID, ddlGrouping)
        c.Add(ddlSplitting.ID, ddlSplitting)
        c.Add(txtDate1.ID, txtDate1)
        c.Add(txtDate2.ID, txtDate2)

        c.Add(lnkShowFilter.ID, lnkShowFilter)
        c.Add(tdFilter.ID, tdFilter)
        c.Add(lnkShowGrid.ID, lnkShowGrid)
        c.Add(trGrid.ID, trGrid)
        c.Add(chkPointLabels.ID, chkPointLabels)
        c.Add(chkPointMarkers.ID, chkPointMarkers)
        c.Add(chkSpline.ID, chkSpline)
        c.Add(chk3D.ID, chk3D)

        Return c

    End Function
    Private Sub Refresh()
        Dim redir As String = "http://" + Request.ServerVariables("SERVER_NAME") + Request.ServerVariables("URL") + "?company=" + ddlCompany.SelectedItem.Value

        If ddlCommRec.Visible Then
            redir += "&commrecs=" + ddlCommRec.SelectedItem.Value
        End If
        Response.Redirect(redir)
    End Sub
    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Research-Metrics-Financial-Commission Comparison")
        AddControl(phrecipientcriteria, c, "Research-Metrics-Financial-Commission Comparison-Recipient Criteria")
    End Sub
#End Region
    Private Sub Requery()

        If Not UserTypeID = 2 Then
            CommRecID = ddlCommRec.SelectedItem.Value
        End If

        'Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ChartCommissionComparision_" + company)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ChartCommissionComparision")
            Using cmd.Connection
                cmd.Connection.Open()

                Dim _splitBy As Integer = Integer.Parse(ddlSplitting.Value)
                Dim _groupBy As Integer = Integer.Parse(ddlGrouping.Value)

                If Not String.IsNullOrEmpty(txtDate1.Text) Then
                    DatabaseHelper.AddParameter(cmd, "startdate", DateTime.Parse(txtDate1.Text))
                End If
                If Not String.IsNullOrEmpty(txtDate1.Text) Then
                    DatabaseHelper.AddParameter(cmd, "enddate", DateTime.Parse(txtDate2.Text))
                End If
                DatabaseHelper.AddParameter(cmd, "groupby", _groupBy) 'day
                DatabaseHelper.AddParameter(cmd, "splitby", _splitBy) 'month


                'If UserTypeID = 2 Then 'agency
                DatabaseHelper.AddParameter(cmd, "commrecids", CommRecID)
                DatabaseHelper.AddParameter(cmd, "commrecidsop", "")
                'ElseIf Not String.IsNullOrEmpty(csCommRecID.SelectedStr) Then
                'DatabaseHelper.AddParameter(cmd, "commrecids", csCommRecID.SelectedStr.Replace("|", ","))
                'DatabaseHelper.AddParameter(cmd, "commrecidsop", IIf(optRecipientChoice.SelectedIndex = 0, "not", ""))
                'End If

                Dim dt As DataTable = New DataTable

                Dim minRow As Integer = -1

                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()

                        Dim ColumnDT As DateTime = DatabaseHelper.Peel_date(rd, "splitdate")
                        Dim ColumnStr As String = ColumnDT.ToString("dd MMM, yy")
                        If _splitBy = 2 Then
                            ColumnStr = ColumnDT.ToString("MMM, yy")
                        ElseIf _splitBy = 3 Then
                            ColumnStr = ColumnDT.ToString("yyyy")
                        End If

                        Dim row As Integer = DatabaseHelper.Peel_int(rd, "group")
                        Dim Amount As Double = DatabaseHelper.Peel_float(rd, "amount")

                        If minRow > row Or minRow = -1 Then
                            minRow = row
                        End If

                        Dim dc As DataColumn = dt.Columns(ColumnStr)
                        If dc Is Nothing Then
                            dc = New DataColumn(ColumnStr, GetType(Double))
                            dt.Columns.Add(dc)
                        End If

                        Dim dr As DataRow
                        While dt.Rows.Count < row
                            dr = dt.NewRow
                            dt.Rows.Add(dr)
                        End While

                        dr = dt.Rows(row - 1)


                        dr(dc.ColumnName) = Amount

                    End While
                End Using

                Dim sb As New StringBuilder
                Dim sbXls As New StringBuilder

                sbXls.Append("<table border=""1"">")

                'render headers
                sb.Append("<thead><tr style=""font-weight:bold""><th class=""StatHeadItem"">&nbsp;</th>")
                sbXls.Append("<tr><td></td>")
                For x As Integer = 0 To dt.Columns.Count - 1
                    sb.Append("<th nowrap=""true"" align=""left"" class=""StatHeadItem"">")
                    sb.Append(dt.Columns(x).ColumnName)
                    sb.Append("</th>")
                    sbXls.Append("<td>" & dt.Columns(x).ColumnName & "</td>")
                Next
                sbXls.Append("</tr>")
                sb.Append("</tr><thead>")


                For y As Integer = minRow - 1 To dt.Rows.Count - 1
                    sb.Append("<tr>")
                    sbXls.Append("<tr>")

                    sb.Append("<td nowrap=""true""><b>")
                    sbXls.Append("<td>")
                    If _groupBy = 0 Then
                        sb.Append("Day ")
                        sbXls.Append("Day ")
                    ElseIf _groupBy = 1 Then
                        sb.Append("Week ")
                        sbXls.Append("Week ")
                    ElseIf _groupBy = 2 Then
                        sb.Append("Month ")
                        sbXls.Append("Month ")
                    End If

                    sb.Append((y + 1) & "</b></td>")
                    sbXls.Append((y + 1) & "</td>")

                    For x As Integer = 0 To dt.Columns.Count - 1
                        sb.Append("<td class=""StatListItem"">")
                        sbXls.Append("<td>")
                        If Not IsDBNull(dt.Rows(y)(x)) Then
                            sb.Append(CType(dt.Rows(y)(x), Double).ToString("c"))
                            sbXls.Append(CType(dt.Rows(y)(x), Double).ToString("c"))
                        End If
                        sb.Append("</td>")
                        sbXls.Append("</td>")

                    Next
                    sb.Append("</tr>")
                    sbXls.Append("</tr>")
                    sb.Append("<tr><td colspan=""" & dt.Columns.Count + 1 & """ style=""height:2;background-image:url(" & ResolveUrl("~/images/dot.png") & ");background-position:bottom bottom;background-repeat:repeat-x;""><img src=""" & ResolveUrl("~/images/spacer.gif") & """ border=""0"" width=""1"" height=""1""/></td></tr>")
                Next
                sbXls.Append("</table")

                Session("xls_" + Me.GetType.Name) = sbXls.ToString
                ltrGrid.Text = sb.ToString
            End Using
        End Using
    End Sub
    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Response.Redirect(ResolveUrl("~/queryxls.ashx?Query=" & Me.GetType.Name))
    End Sub
End Class
