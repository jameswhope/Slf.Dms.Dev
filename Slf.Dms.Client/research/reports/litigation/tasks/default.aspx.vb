Imports System.Data
Imports System.Data.SqlClient

Imports LocalHelper
Imports System.Collections.Generic

Partial Class research_reports_litigation_tasks_default
    Inherits System.Web.UI.Page

#Region "Methods"

    Public Sub SetPagerButtonStates(ByVal gridView As GridView, ByVal gvPagerRow As GridViewRow, ByVal page As Page)
        Dim pageIndex As Integer = gridView.PageIndex
        Dim pageCount As Integer = gridView.PageCount

        Dim btnFirst As LinkButton = TryCast(gvPagerRow.FindControl("btnFirst"), LinkButton)
        Dim btnPrevious As LinkButton = TryCast(gvPagerRow.FindControl("btnPrevious"), LinkButton)
        Dim btnNext As LinkButton = TryCast(gvPagerRow.FindControl("btnNext"), LinkButton)
        Dim btnLast As LinkButton = TryCast(gvPagerRow.FindControl("btnLast"), LinkButton)
        Dim lblNumber As Label = TryCast(gvPagerRow.FindControl("lblNumber"), Label)

        lblNumber.Text = pageCount.ToString()

        btnFirst.Enabled = btnPrevious.Enabled = (pageIndex <> 0)
        btnLast.Enabled = btnNext.Enabled = (pageIndex < (pageCount - 1))

        btnPrevious.Enabled = (pageIndex <> 0)
        btnNext.Enabled = (pageIndex < (pageCount - 1))

        If btnNext.Enabled = False Then
            btnNext.Attributes.Remove("CssClass")
        End If
        Dim ddlPageSelector As DropDownList = DirectCast(gvPagerRow.FindControl("ddlPageSelector"), DropDownList)
        ddlPageSelector.Items.Clear()

        For i As Integer = 1 To gridView.PageCount
            ddlPageSelector.Items.Add(i.ToString())
        Next

        ddlPageSelector.SelectedIndex = pageIndex

        'Used delegates over here
        AddHandler ddlPageSelector.SelectedIndexChanged, AddressOf pageSelector_SelectedIndexChanged
    End Sub

    Public Overloads Overrides Sub VerifyRenderingInServerForm(ByVal control As System.Web.UI.Control)
        'confirms that an HtmlForm control is rendered for the
        'specified ASP.NET server control at run time.
    End Sub

    Public Sub pageSelector_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        Using gv As GridView = ddl.Parent.Parent.Parent.Parent
            If Not IsNothing(gv) Then
                gv.PageIndex = ddl.SelectedIndex
                gv.DataBind()
            End If
        End Using
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadQuickPickDates(ddlQuickPickDate, txtTransDate1, txtTransDate2)
            LoadQuickPickDates(ddlDueDate, txtDueStart, txtDueEnd)
            LoadQuickPickDates(ddlResolvedDate, txtResolveStart, txtResolveEnd)

            GetResults()
        End If
        ddlQuickPickDate.Attributes("onchange") = String.Format("SetDatesGeneric(this,'{0}','{1}');", txtTransDate1.ClientID, txtTransDate2.ClientID)
        ddlDueDate.Attributes("onchange") = String.Format("SetDatesGeneric(this,'{0}','{1}');", txtDueStart.ClientID, txtDueEnd.ClientID)
        ddlResolvedDate.Attributes("onchange") = String.Format("SetDatesGeneric(this,'{0}','{1}');", txtResolveStart.ClientID, txtResolveEnd.ClientID)
    End Sub

    Protected Sub btnExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnExport.Click
        Dim stringWrite As New System.IO.StringWriter()
        Dim htmlWrite As New HtmlTextWriter(stringWrite)

        Response.Clear()
        Response.AddHeader("content-disposition", "attachment;filename=tasks.xls")
        Response.Charset = ""
        Response.ContentType = "application/ms-excel"

        gvExport.DataSourceID = dsResults.ID
        gvExport.AllowPaging = False
        gvExport.DataBind()

        PrepareGridViewForExport(gvExport)
        gvExport.RenderControl(htmlWrite)

        Response.Write(stringWrite.ToString())
        Response.End()

        Response.Write(stringWrite.ToString())
        Response.End()
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        GetResults()
    End Sub

    Protected Sub dsResults_Selected(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsResults.Selected
        lblResults.Text = String.Format("{0} tasks found.", e.AffectedRows)
    End Sub

    Protected Sub gvResults_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvResults.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvResults, e.Row, Me.Page)
        End Select
    End Sub

    Protected Sub gvResults_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvResults.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim row As Data.DataRowView = CType(e.Row.DataItem, Data.DataRowView)
            e.Row.Style("cursor") = "hand"
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CAE1FF';")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
            Dim dcid As String = If(row("clientid"), -1)
            Dim acctid As String = IIf(IsDBNull(row("accountid")), -1, row("accountid").ToString)
            Dim credid As String = IIf(IsDBNull(row("creditorid")), -1, row("creditorid").ToString) 'If(row("creditorid"), -1)
            Dim credinstiid As String = IIf(IsDBNull(row("creditorinstanceid")), -1, row("creditorinstanceid").ToString) 'If(row("creditorid"), -1)
            Dim tid As String = IIf(IsDBNull(row("taskid")), -1, row("taskid").ToString) 'If(row("taskid"), -1)

            Dim mUrl As String = buildMatterFrameUrl(row("matterid"), dcid, acctid, credinstiid, tid)
            e.Row.Attributes.Add("onclick", String.Format("ShowMatterPopup('{0}');", mUrl))

            'If Not IsDBNull(row("accountid")) AndAlso Not IsDBNull(row("creditorid")) Then
            '    Dim mUrl As String = buildMatterFrameUrl(row("matterid"), row("clientid"), row("accountid"), row("creditorid"), row("taskid"))
            '    e.Row.Attributes.Add("onclick", String.Format("ShowMatterPopup('{0}');", mUrl))
            'Else
            '    e.Row.Attributes.Add("onclick", String.Format("alert('{0}');", "Matter not fully attached."))
            'End If
        End If
    End Sub

    Protected Sub gvResults_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvResults.Sorting
        GridViewHelper.AppendSortOrderImageToGridHeader(e.SortDirection, e.SortExpression, gvResults)
    End Sub

    Protected Sub lbAssignedTo_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbAssignedTo.DataBound
        lbAssignedTo.Items(0).Selected = True
    End Sub

    Protected Sub lbCompany_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbCompany.DataBound
        lbCompany.Items(0).Selected = True
    End Sub

    Protected Sub lbCreatedBy_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbCreatedBy.DataBound
        lbCreatedBy.Items(0).Selected = True
    End Sub

    Protected Sub lbTaskResolution_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbTaskResolution.DataBound
        lbTaskResolution.Items(0).Selected = True
    End Sub

    Protected Sub lbTaskType_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbTaskType.DataBound
        lbTaskType.Items(0).Selected = True
    End Sub

    Protected Sub lbUserGroup_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbUserGroup.DataBound
        lbUserGroup.Items(0).Selected = True
    End Sub

    Private Function GetCommaSeparatedText(ByVal tb As TextBox, ByVal column As String) As String
        Dim CommaSeparatedText As String = ""
        Dim arr() As String = tb.Text.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)

        If arr.Length > 0 Then
            If arr(0).Length > 0 Then
                CommaSeparatedText &= " and ("
                For i As Integer = 0 To arr.Length - 1
                    If arr(i).Length > 0 Then
                        If i > 0 Then
                            CommaSeparatedText &= " or "
                        End If
                        CommaSeparatedText &= String.Format(" {0} like '%{1}%'", column, arr(i).Replace("'", "''"))
                    End If
                Next
                CommaSeparatedText &= ")"
            End If
        End If
        Return CommaSeparatedText
    End Function

    Private Sub GetMultiLines(ByVal tb As TextBox, ByVal column As String, ByRef criteria As String)
        Dim arr() As String = Split(tb.Text, vbCrLf)

        If arr.Length > 0 Then
            If arr(0).Length > 0 Then
                criteria &= " and ("
                For i As Integer = 0 To arr.Length - 1
                    If arr(i).Length > 0 Then
                        If i > 0 Then
                            criteria &= " or "
                        End If
                        criteria &= String.Format(" {0} like '%{1}%'", column, arr(i).Replace("'", "''"))
                    End If
                Next
                criteria &= ")"
            End If
        End If
    End Sub

    Private Sub GetResults()
        Dim criteria As New StringBuilder
        Dim selText As New List(Of String)

        Dim params(0) As SqlParameter

        If ddlQuickPickDate.SelectedItem.Text <> "ALL" Then
            criteria.AppendFormat(" and (t.Created between '{0}' and '{1} 23:59')", txtTransDate1.Text, txtTransDate2.Text)
            selText.Add(String.Format("Created: {0} - {1}" & vbCrLf, txtTransDate1.Text, txtTransDate2.Text))
        End If
        If ddlDueDate.SelectedItem.Text <> "ALL" Then
            criteria.AppendFormat(" and (t.Due between '{0}' and '{1} 23:59')", txtDueStart.Text, txtDueEnd.Text)
            selText.Add(String.Format("Due: {0} - {1}" & vbCrLf, txtDueStart.Text, txtDueEnd.Text))
        End If
        If ddlResolvedDate.SelectedItem.Text <> "ALL" Then
            criteria.AppendFormat(" and (t.Resolved between '{0}' and '{1} 23:59')", txtResolveStart.Text, txtResolveEnd.Text)
            selText.Add(String.Format("Resolved: {0} - {1}" & vbCrLf, txtResolveStart.Text, txtResolveEnd.Text))
        End If

        If chkResolved.Checked Then
            criteria.Append(" and t.Resolved is not null")
            selText.Add("Only Resolved")

            criteria.Append(GetSelectedIDsText(lbResolvedBy, "t.ResolvedBy", "Resolved By", selText))
        End If
        If chkOnlyUnresolved.Checked Then
            selText.Add("Only Unresolved")
            criteria.Append(" and t.Resolved is null")
        End If

        criteria.Append(GetCommaSeparatedText(txtCreditors, "g.name"))
        criteria.Append(GetCommaSeparatedText(txtDescriptions, "t.Description"))
        criteria.Append(GetCommaSeparatedText(txtMatters, "m.matterid"))

        criteria.Append(GetSelectedIDsText(lbTaskType, "t.tasktypeid", "Task Type(s): ", selText))
        criteria.Append(GetSelectedIDsText(lbTaskResolution, "t.TaskResolutionID", "Task Resolution:  ", selText))
        criteria.Append(GetSelectedIDsText(lbAssignedTo, "t.assignedto", "Assigned To: ", selText))
        criteria.Append(GetSelectedIDsText(lbCreatedBy, "t.Createdby", "Created By: ", selText))
        criteria.Append(GetSelectedIDsText(lbCompany, "cp.companyid", "Firm(s): ", selText))
        criteria.Append(GetSelectedIDsText(lbUserGroup, "t.assignedtogroupid", "Assigned To Group(s): ", selText))
        criteria.Append(GetSelectedIDsText(lbClassifications, "mc.classificationid", "Classification(s): ", selText))

        lblSelection.Text = String.Format("{0}", Join(selText.ToArray, "<br>"))

        dsResults.SelectParameters("criteria").DefaultValue = criteria.ToString
        dsResults.DataBind()
        gvResults.DataBind()
    End Sub

    Private Sub GetSelectedIDs(ByVal listbox1 As ListBox, ByVal column As String, ByRef where As String)
        Dim ids As String = ""

        For Each li As ListItem In listbox1.Items
            If li.Selected Then
                If li.Text = "All" Then
                    ids = ""
                    Exit For
                Else
                    If Len(ids) = 0 Then
                        ids &= String.Format("'{0}'", li.Value)
                    Else
                        ids &= String.Format(",'{0}'", li.Value)
                    End If
                End If
            End If
        Next

        If Len(ids) > 0 Then
            where &= String.Format(" and {0} in ({1})", column, ids)
        End If
    End Sub

    Private Function GetSelectedIDsText(ByVal listbox1 As ListBox, ByVal column As String) As String
        Dim where As New StringBuilder
        Dim ids As String = ""

        For Each li As ListItem In listbox1.Items
            If li.Selected Then
                If li.Text = "All" Then
                    ids = ""
                    Exit For
                Else
                    If Len(ids) = 0 Then
                        ids &= String.Format("'{0}'", li.Value)
                    Else
                        ids &= String.Format(",'{0}'", li.Value)
                    End If
                End If
            End If
        Next

        If Len(ids) > 0 Then
            where.AppendFormat(" and {0} in ({1})", column, ids)
        End If
        Return where.ToString
    End Function
    Private Function GetSelectedIDsText(ByVal listbox1 As ListBox, ByVal column As String, ByVal filterName As String, ByRef lstText As List(Of String)) As String
        Dim where As New StringBuilder
        Dim ids As String = ""
        Dim vals As String = ""

        For Each li As ListItem In listbox1.Items
            If li.Selected Then
                If li.Text = "All" Then
                    ids = ""
                    vals = "All"
                    Exit For
                Else
                    If Len(ids) = 0 Then
                        ids &= String.Format("'{0}'", li.Value)
                        vals &= String.Format("'{0}'", li.Text)
                    Else
                        ids &= String.Format(",'{0}'", li.Value)
                        vals &= String.Format(",'{0}'", li.Text)
                    End If
                End If
            End If
        Next

        If Len(ids) > 0 Then
            where.AppendFormat(" and {0} in ({1})", column, ids)
            lstText.Add(String.Format("{0} {1}", filterName, vals))
        End If
        Return where.ToString
    End Function
    Private Sub LoadQuickPickDates()
        ddlQuickPickDate.Items.Clear()

        ddlQuickPickDate.Items.Add(New ListItem("ALL", -1))
        ddlQuickPickDate.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yyyy") & "," & Now.ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddlQuickPickDate.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yyyy") & "," & Now.AddDays(-1).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddlQuickPickDate.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddlQuickPickDate.Items.Add(New ListItem("Custom", "Custom"))

        txtTransDate1.Text = Now.ToString("MM/dd/yyyy")
        txtTransDate2.Text = Now.ToString("MM/dd/yyyy")
    End Sub

    Private Sub LoadQuickPickDates(ByVal ddl As DropDownList, ByVal startTextbox As TextBox, ByVal endTextbox As TextBox)
        ddl.Items.Clear()

        ddl.Items.Add(New ListItem("Today", Now.ToString("MM/dd/yyyy") & "," & Now.ToString("MM/dd/yyyy")))
        ddl.Items.Add(New ListItem("This Week", RoundDate(Now, -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddl.Items.Add(New ListItem("This Month", RoundDate(Now, -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddl.Items.Add(New ListItem("This Year", RoundDate(Now, -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now, 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddl.Items.Add(New ListItem("Yesterday", Now.AddDays(-1).ToString("MM/dd/yyyy") & "," & Now.AddDays(-1).ToString("MM/dd/yyyy")))
        ddl.Items.Add(New ListItem("Last Week", RoundDate(Now.AddDays(-7), -1, DateUnit.Week).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddDays(-7), 1, DateUnit.Week).ToString("MM/dd/yyyy")))
        ddl.Items.Add(New ListItem("Last Month", RoundDate(Now.AddMonths(-1), -1, DateUnit.Month).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddMonths(-1), 1, DateUnit.Month).ToString("MM/dd/yyyy")))
        ddl.Items.Add(New ListItem("Last Year", RoundDate(Now.AddYears(-1), -1, DateUnit.Year).ToString("MM/dd/yyyy") & "," & RoundDate(Now.AddYears(-1), 1, DateUnit.Year).ToString("MM/dd/yyyy")))

        ddl.Items.Add(New ListItem("Custom", "Custom"))
        ddl.Items.Add(New ListItem("ALL", -1))

        startTextbox.Text = Now.ToString("MM/dd/yyyy")
        endTextbox.Text = Now.ToString("MM/dd/yyyy")
    End Sub

    Private Sub PrepareGridViewForExport(ByVal gv As Control)
        Dim lb As New LinkButton()
        Dim l As New Literal()
        Dim name As String = [String].Empty
        Dim i As Integer = 0
        While i < gv.Controls.Count
            If TypeOf gv.Controls(i) Is LinkButton Then
                l.Text = (TryCast(gv.Controls(i), LinkButton)).Text
                gv.Controls.Remove(gv.Controls(i))
                gv.Controls.AddAt(i, l)
            ElseIf TypeOf gv.Controls(i) Is DropDownList Then
                l.Text = (TryCast(gv.Controls(i), DropDownList)).SelectedItem.Text
                gv.Controls.Remove(gv.Controls(i))
                gv.Controls.AddAt(i, l)
            ElseIf TypeOf gv.Controls(i) Is CheckBox Then
                l.Text = If((TryCast(gv.Controls(i), CheckBox)).Checked, "True", "False")
                gv.Controls.Remove(gv.Controls(i))
                gv.Controls.AddAt(i, l)
            End If
            If gv.Controls(i).HasControls() Then
                PrepareGridViewForExport(gv.Controls(i))
            End If
            System.Math.Max(System.Threading.Interlocked.Increment(i), i - 1)
        End While
    End Sub

    Private Function buildMatterFrameUrl(ByVal matterID As Integer, ByVal dataclientid As Integer, ByVal accountid As Integer, ByVal creditorid As Integer, ByVal taskID As Integer) As String
        Dim sUrl As New StringBuilder
        Dim svr As String = String.Format("http://{0}", Request.ServerVariables("server_name"))
        If svr.Contains("local") Then
            svr += String.Format(":{0}", Request.ServerVariables("server_port"))
        End If

        Dim siteBase As String = String.Format("{0}{1}", svr, Request.ApplicationPath)

        sUrl.AppendFormat("{0}/util/pop/matterpop.aspx?t=o&", siteBase)
        sUrl.AppendFormat("id={0}&aid={1}&mid={2}&ciid={3}&tid={4}", dataclientid, accountid, matterID, creditorid, taskID)

        Return sUrl.ToString
    End Function

#End Region 'Methods

    Protected Sub lbUserGroup_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbUserGroup.SelectedIndexChanged


        ds_AssignedTo.SelectParameters("ugroupid").DefaultValue = TryCast(sender, ListBox).SelectedItem.Value
        ds_AssignedTo.DataBind()
        lbAssignedTo.DataBind()



    End Sub
End Class