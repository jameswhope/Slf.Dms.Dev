Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Data.SqlClient

Partial Class CustomTools_UserControls_Verification
    Inherits System.Web.UI.UserControl

    Private hDates As New Hashtable 'keeps track of groups
    Private hDatesVer As New Hashtable
    Private hCompany As New Hashtable
    Private hCompanyVer As New Hashtable
    Private hReps As New Hashtable
    Private hRepsVer As New Hashtable
    Private UserID As Integer
    Public tabIndex As Integer = -1

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Page.IsPostBack Then
            divVerification.Visible = HasPermission(UserID, "Home-Verification")
            If divVerification.Visible Then
                ds_MyClientIntake.SelectParameters("UserID").DefaultValue = UserID
                tabIndex = 0
                LoadTabStrips()
                tsVerification.TabPages(0).Selected = True
                'LoadTransferHistory()
            End If
        End If
    End Sub

    Private Sub LoadTabStrips()
        Dim tempIndex As Integer

        tsVerification.TabPages.Clear()

        If HasPermission(UserID, "Home-Verification-New CID Clients") Then
            tsVerification.TabPages.Add(New Slf.Dms.Controls.TabPage(String.Format("New&nbsp;CID&nbsp;Clients&nbsp;<font color='blue'>({0})</font>", gvNewClientIntake.Rows.Count), tabNewClientIntake.ClientID))
        End If
        If HasPermission(UserID, "Home-Verification-My CID Clients") Then
            tsVerification.TabPages.Add(New Slf.Dms.Controls.TabPage(String.Format("My&nbsp;CID&nbsp;Clients&nbsp;<font color='blue'>({0})</font>", gvMyClientIntake.Rows.Count), tabMyClientIntake.ClientID))
        End If
        If HasPermission(UserID, "Home-Verification-Assigned CID Clients") Then
            tsVerification.TabPages.Add(New Slf.Dms.Controls.TabPage(String.Format("Assigned&nbsp;CID&nbsp;Clients&nbsp;<font color='blue'>({0})</font>", gvAssignedClientIntake.Rows.Count), tabAssignedClientIntake.ClientID))
        End If
        If HasPermission(UserID, "Home-Verification-CID Transfer History") Then
            tsVerification.TabPages.Add(New Slf.Dms.Controls.TabPage("CID&nbsp;Transfer&nbsp;History", tabTransferHistory.ClientID))
            If tsVerification.TabPages.Count = 1 Then
                tempIndex = 3
            End If
        End If
        If HasPermission(UserID, "Home-Verification-Verification History") Then
            tsVerification.TabPages.Add(New Slf.Dms.Controls.TabPage("Verification&nbsp;History", tabVerificationHistory.ClientID))
            If tsVerification.TabPages.Count = 1 Then
                tempIndex = 4
            End If
        End If

        If tempIndex > 0 Then
            tabIndex = tempIndex
        End If
    End Sub

    Protected Sub gvNewClientIntake_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNewClientIntake.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Style("cursor") = "hand"
            e.Row.Attributes("onmouseover") = "this.style.backgroundColor = '#f3f3f3';"
            e.Row.Attributes("onmouseout") = "this.style.backgroundColor = '';"
            e.Row.Attributes("title") = "Click to assign yourself as the Underwriter.."
            e.Row.Attributes("onclick") = Page.ClientScript.GetPostBackClientHyperlink(Me.gvNewClientIntake, "Select$" & e.Row.RowIndex)
        End If
    End Sub

    Protected Sub gvMyClientIntake_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvMyClientIntake.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)
            e.Row.Style("cursor") = "hand"
            e.Row.Attributes("onmouseover") = "this.style.backgroundColor = '#f3f3f3';"
            e.Row.Attributes("onmouseout") = "this.style.backgroundColor = '';"
            e.Row.Attributes("onclick") = "window.location.href='clients/client/underwriting.aspx?id=" & row("clientid") & "';"
        End If
    End Sub

    Protected Sub gvAssignedClientIntake_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAssignedClientIntake.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)
            e.Row.Style("cursor") = "hand"
            e.Row.Attributes("onmouseover") = "this.style.backgroundColor = '#f3f3f3';"
            e.Row.Attributes("onmouseout") = "this.style.backgroundColor = '';"
            For i As Integer = 1 To e.Row.Cells.Count - 1
                e.Row.Cells(i).Attributes("onclick") = "window.location.href='clients/client/underwriting.aspx?id=" & row("clientid") & "';"
            Next
        End If
    End Sub

    Protected Sub gvNewClientIntake_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvNewClientIntake.RowCommand
        Dim keys As DataKey = gvNewClientIntake.DataKeys(e.CommandArgument)
        Dim clientID As Integer = CInt(keys(0))

        If DataHelper.RecordExists("tblclient", String.Format("clientid={0} and AssignedUnderwriter > 0", clientID)) Then
            Page.ClientScript.RegisterStartupScript(Me.GetType, "hasunderwriter", "alert('This client is already assigned to an Underwriter.');", True)
            gvNewClientIntake.DataBind()
        Else
            'setup welcome interview task
            Dim Description As String = DataHelper.FieldLookup("tblTaskType", "DefaultDescription", "TaskTypeID = " & 4) 'Welcome interview
            Dim TaskDue As DateTime = LocalHelper.AddBusinessDays(Now, DataHelper.Nz_int(PropertyHelper.Value("DaysTillLSAFollowupDue")))

            'get current roadmap location
            Dim CurrentRoadmapID As Integer = DataHelper.Nz_int(ClientHelper.GetRoadmap(clientID, Now, "RoadmapID"))

            'send task to newly assigned underwriter
            'TaskHelper.InsertTask(clientID, CurrentRoadmapID, 4, Description, UserID, TaskDue, UserID) 'Welcome interview

            'assign underwriter on client record
            ClientHelper.UpdateField(clientID, "AssignedUnderwriter", UserID, UserID)
            SqlHelper.ExecuteNonQuery("update tblClient set AssignedUnderwriterDate = getdate() where clientid = " & clientID, CommandType.Text)

            'update search results table for this client
            ClientHelper.LoadSearch(clientID)

            Response.Redirect("clients/client/underwriting.aspx?id=" & clientID)
        End If
    End Sub

    Public Function SetImg(ByVal file As String) As String
        Return String.Format("<img src='images/{0}' />", file)
    End Function

    'Protected Sub btnUnassign_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
    Protected Sub lnkUnassign_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkUnassign.Click
        Dim row As GridViewRow
        Dim dk As DataKey
        Dim clientID As Integer
        Dim taskID As Integer
        Dim userID As Integer
        Dim chk As CheckBox

        For Each row In gvAssignedClientIntake.Rows
            If row.RowType = DataControlRowType.DataRow Then
                dk = gvAssignedClientIntake.DataKeys(row.RowIndex)
                clientID = CInt(dk(0))
                userID = CInt(dk(1))
                chk = CType(row.Cells(0).FindControl("chkUnassign"), CheckBox)
                If chk.Checked Then
                    SqlHelper.ExecuteNonQuery("update tblClient set AssignedUnderwriter = null, AssignedUnderwriterDate = null where clientid = " & clientID, CommandType.Text)
                    taskID = CInt(SqlHelper.ExecuteScalar(String.Format("select t.taskid from tblroadmap r join tblroadmaptask t on t.roadmapid = r.roadmapid join tbltask k on k.taskid = t.taskid and k.tasktypeid = 4 and k.assignedto = {0} where r.clientid = {1}", userID, clientID), CommandType.Text))
                    TaskHelper.Delete(taskID, True)
                End If
            End If
        Next

        gvNewClientIntake.DataBind()
        gvMyClientIntake.DataBind()
        gvAssignedClientIntake.DataBind()
        gvTransferHistory.DataBind()
        'LoadTransferHistory()
        LoadTabStrips()
        tsVerification.TabPages(2).Selected = True
        tabIndex = 2
    End Sub

    'Private Sub LoadTransferHistory()
    '    Dim dsOutput As DataSet = SqlHelper.GetDataSet("stp_TransferHistory")
    '    Dim params(2) As SqlParameter
    '    Dim parentCol(1) As DataColumn
    '    Dim childCol(1) As DataColumn

    '    dsOutput.Relations.Add("TransferredCompany", dsOutput.Tables(0).Columns("transferred"), dsOutput.Tables(1).Columns("transferred"))

    '    parentCol(0) = dsOutput.Tables(1).Columns("transferred")
    '    parentCol(1) = dsOutput.Tables(1).Columns("company")
    '    childCol(0) = dsOutput.Tables(2).Columns("transferred")
    '    childCol(1) = dsOutput.Tables(2).Columns("company")
    '    dsOutput.Relations.Add("CompanyRep", parentCol, childCol)

    '    ReDim parentCol(2)
    '    ReDim childCol(2)

    '    parentCol(0) = dsOutput.Tables(2).Columns("transferred")
    '    parentCol(1) = dsOutput.Tables(2).Columns("company")
    '    parentCol(2) = dsOutput.Tables(2).Columns("rep")
    '    childCol(0) = dsOutput.Tables(3).Columns("transferred")
    '    childCol(1) = dsOutput.Tables(3).Columns("company")
    '    childCol(2) = dsOutput.Tables(3).Columns("rep")
    '    dsOutput.Relations.Add("RepClient", parentCol, childCol)

    '    'wgTransferHistory.Bands.Clear()
    '    wgTransferHistory.DataSource = dsOutput.Tables(0)
    '    wgTransferHistory.DataBind()
    'End Sub

    'Protected Sub wgTransferHistory_InitializeLayout(ByVal sender As Object, ByVal e As Infragistics.WebUI.UltraWebGrid.LayoutEventArgs) Handles wgTransferHistory.InitializeLayout
    '    With e.Layout
    '        .CellClickActionDefault = Infragistics.WebUI.UltraWebGrid.CellClickAction.RowSelect
    '        .SelectTypeRowDefault = Infragistics.WebUI.UltraWebGrid.SelectType.Single
    '        .SelectedRowStyleDefault.BorderStyle = BorderStyle.None
    '        .ViewType = Infragistics.WebUI.UltraWebGrid.ViewType.Hierarchical
    '        .BorderCollapseDefault = Infragistics.WebUI.UltraWebGrid.BorderCollapse.Collapse
    '        .GroupByBox.Hidden = True
    '        .AllowColumnMovingDefault = Infragistics.WebUI.UltraWebGrid.AllowColumnMoving.None
    '        .RowExpAreaStyleDefault.BackColor = System.Drawing.Color.White

    '        'By Date
    '        .Bands(0).RowExpAreaStyle.BackColor = System.Drawing.Color.White
    '        .Bands(0).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
    '        .Bands(0).RowStyle.BackColor = System.Drawing.Color.White
    '        .Bands(0).RowStyle.BorderStyle = BorderStyle.None
    '        .Bands(0).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
    '        .Bands(0).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#d3d3d3")
    '        .Bands(0).RowStyle.Padding.Right = Unit.Pixel(3)
    '        .Bands(0).Columns(0).Width = Unit.Pixel(275)
    '        .Bands(0).Columns(0).Header.Caption = "Transferred"
    '        .Bands(0).Columns(0).Format = "M/d/yyyy"
    '        .Bands(0).HeaderStyle.Font.Bold = False
    '        .Bands(0).HeaderStyle.BackColor = Drawing.ColorTranslator.FromHtml("#dcdcdc")
    '        .Bands(0).HeaderStyle.BorderStyle = BorderStyle.None
    '        .Bands(0).HeaderStyle.BorderDetails.ColorBottom = System.Drawing.Color.Black
    '        .Bands(0).HeaderStyle.BorderDetails.WidthBottom = Unit.Pixel(2)

    '        'By Company
    '        .Bands(1).Columns(0).Hidden = True
    '        .Bands(1).Columns(1).Width = Unit.Percentage(100)
    '        .Bands(1).RowExpAreaStyle.BackColor = System.Drawing.Color.White
    '        .Bands(1).RowStyle.BackColor = System.Drawing.Color.White
    '        .Bands(1).AllowUpdate = Infragistics.WebUI.UltraWebGrid.AllowUpdate.No
    '        .Bands(1).RowStyle.BackColor = System.Drawing.Color.White
    '        .Bands(1).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
    '        .Bands(1).RowStyle.BorderDetails.ColorBottom = Drawing.ColorTranslator.FromHtml("#d3d3d3")
    '        .Bands(1).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
    '        .Bands(1).ColFootersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No

    '        'By Rep
    '        .Bands(2).Columns(0).Hidden = True
    '        .Bands(2).Columns(1).Hidden = True
    '        .Bands(2).Columns(2).Width = Unit.Percentage(100)
    '        .Bands(2).RowExpAreaStyle.BackColor = System.Drawing.Color.White
    '        .Bands(2).RowStyle.BackColor = System.Drawing.Color.White
    '        .Bands(2).RowStyle.BorderStyle = BorderStyle.None
    '        .Bands(2).RowStyle.BorderDetails.StyleBottom = BorderStyle.Solid
    '        .Bands(2).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
    '        .Bands(2).ColFootersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No

    '        'By Client
    '        .Bands(3).Columns(0).Hidden = True
    '        .Bands(3).Columns(1).Hidden = True
    '        .Bands(3).Columns(2).Hidden = True
    '        .Bands(3).Columns(3).Width = Unit.Percentage(100)
    '        .Bands(3).RowExpAreaStyle.BackColor = System.Drawing.Color.White
    '        .Bands(3).RowStyle.BackColor = System.Drawing.Color.White
    '        .Bands(3).RowStyle.BorderStyle = BorderStyle.None
    '        .Bands(3).RowStyle.BorderDetails.StyleBottom = BorderStyle.Dotted
    '        .Bands(3).ColHeadersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
    '        .Bands(3).ColFootersVisible = Infragistics.WebUI.UltraWebGrid.ShowMarginInfo.No
    '    End With
    'End Sub

#Region "Permission Helper (simplified)"

    Private Function HasPermission(ByVal UserID As Integer, ByVal FullFunctionName As String) As Boolean
        Dim tbl As DataTable
        Dim bHasPermission As Boolean
        Dim UserGroupId As Integer

        'First check for user-specific permissions
        tbl = SqlHelper.GetDataTable(String.Format("select p.value from tbluserpermission u join tblpermission p on p.permissionid = u.permissionid join tblfunction f on f.functionid = p.functionid and f.fullname = '{0}' join tblpermissiontype t on t.permissiontypeid = p.permissiontypeid and t.name = 'View' where u.userid = {1}", FullFunctionName, UserID))

        If tbl.Rows.Count = 1 Then
            'User-specific permissions have been set
            bHasPermission = Boolean.Parse(tbl.Rows(0)(0))
        Else
            'Check for group-specific permissions
            UserGroupId = Integer.Parse(DataHelper.FieldLookup("tblUser", "UserGroupId", "UserId = " & UserID))
            tbl = SqlHelper.GetDataTable(String.Format("select p.value from tblgrouppermission g join tblpermission p on p.permissionid = g.permissionid join tblfunction f on f.functionid = p.functionid and f.fullname = '{0}' join tblpermissiontype t on t.permissiontypeid = p.permissiontypeid and t.name = 'View' where g.usergroupid = {1}", FullFunctionName, UserGroupId))
            If tbl.Rows.Count = 1 Then
                'Group-specific permissions have been set
                bHasPermission = Boolean.Parse(tbl.Rows(0)(0))
            End If
        End If

        Return bHasPermission
    End Function

#End Region

    Protected Sub gvTransferHistory_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvTransferHistory.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            'e.Row.Style("cursor") = "hand"
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#d3d3d3'; this.style.filter = 'alpha(opacity=75)';")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")

            Dim imgTreeDate As HtmlImage = TryCast(e.Row.Cells(0).FindControl("imgTreeDate"), HtmlImage)
            Dim imgTreeCompany As HtmlImage = TryCast(e.Row.FindControl("imgTreeCompany"), HtmlImage)
            Dim imgTreeRep As HtmlImage = TryCast(e.Row.FindControl("imgTreeRep"), HtmlImage)
            Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim transferred As String = CStr(row("transferred")).Replace("/", "")
            Dim company As String = CStr(row("company"))
            Dim rep As String = CStr(row("rep"))

            If hDates.Contains(transferred) Then
                If hCompany.Contains(transferred & company) Then
                    If hReps.Contains(transferred & company & rep) Then
                        e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", transferred & company & rep, e.Row.RowIndex))
                        e.Row.Cells(5).Text = ""
                        e.Row.Cells(7).Text = ""
                        imgTreeRep.Visible = False
                    Else
                        hReps.Add(transferred & company & rep, Nothing)
                        e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", transferred & company, e.Row.RowIndex))
                        imgTreeRep.Attributes.Add("onclick", "toggleDocument('" & transferred & company & rep & "','" & gvTransferHistory.ClientID & "', 4, '" & String.Format("tr_{0}_child{1}", transferred & company, e.Row.RowIndex) & "');")
                    End If
                    e.Row.Cells(3).Text = ""
                    imgTreeCompany.Visible = False
                Else
                    hCompany.Add(transferred & company, Nothing)
                    e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", transferred, e.Row.RowIndex))
                    imgTreeCompany.Attributes.Add("onclick", "toggleDocument('" & transferred & company & "','" & gvTransferHistory.ClientID & "', 2, '" & String.Format("tr_{0}_child{1}", transferred, e.Row.RowIndex) & "');")
                    imgTreeRep.Visible = False
                End If
                e.Row.Style("display") = "none"
                e.Row.Cells(1).Text = ""
                imgTreeDate.Visible = False
            Else
                hDates.Add(transferred, Nothing)
                e.Row.Attributes.Add("id", String.Format("tr_{0}_parent", transferred))
                imgTreeDate.Attributes.Add("onclick", "toggleDocument('" & transferred & "','" & gvTransferHistory.ClientID & "', 0, '" & String.Format("tr_{0}_parent", transferred) & "');")
                imgTreeCompany.Visible = False
                imgTreeRep.Visible = False
            End If
        End If
    End Sub

    Protected Sub gvVerificationHistory_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvVerificationHistory.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            'e.Row.Style("cursor") = "hand"
            e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#d3d3d3'; this.style.filter = 'alpha(opacity=75)';")
            e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")

            Dim imgTreeDate As HtmlImage = TryCast(e.Row.Cells(0).FindControl("imgTreeDate"), HtmlImage)
            Dim imgTreeCompany As HtmlImage = TryCast(e.Row.FindControl("imgTreeCompany"), HtmlImage)
            Dim imgTreeRep As HtmlImage = TryCast(e.Row.FindControl("imgTreeRep"), HtmlImage)
            Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim transferred As String = CStr(row("completed")).Replace("/", "")
            Dim company As String = CStr(row("company"))
            Dim rep As String = CStr(row("rep"))

            If hDatesVer.Contains(transferred) Then
                If hCompanyVer.Contains(transferred & company) Then
                    If hRepsVer.Contains(transferred & company & rep) Then
                        e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", transferred & company & rep, e.Row.RowIndex))
                        e.Row.Cells(5).Text = ""
                        e.Row.Cells(7).Text = ""
                        imgTreeRep.Visible = False
                    Else
                        hRepsVer.Add(transferred & company & rep, Nothing)
                        e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", transferred & company, e.Row.RowIndex))
                        imgTreeRep.Attributes.Add("onclick", "toggleDocument('" & transferred & company & rep & "','" & gvVerificationHistory.ClientID & "', 4, '" & String.Format("tr_{0}_child{1}", transferred & company, e.Row.RowIndex) & "');")
                    End If
                    e.Row.Cells(3).Text = ""
                    imgTreeCompany.Visible = False
                Else
                    hCompanyVer.Add(transferred & company, Nothing)
                    e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", transferred, e.Row.RowIndex))
                    imgTreeCompany.Attributes.Add("onclick", "toggleDocument('" & transferred & company & "','" & gvVerificationHistory.ClientID & "', 2, '" & String.Format("tr_{0}_child{1}", transferred, e.Row.RowIndex) & "');")
                    imgTreeRep.Visible = False
                End If
                e.Row.Style("display") = "none"
                e.Row.Cells(1).Text = ""
                imgTreeDate.Visible = False
            Else
                hDatesVer.Add(transferred, Nothing)
                e.Row.Attributes.Add("id", String.Format("tr_{0}_parent", transferred))
                imgTreeDate.Attributes.Add("onclick", "toggleDocument('" & transferred & "','" & gvVerificationHistory.ClientID & "', 0, '" & String.Format("tr_{0}_parent", transferred) & "');")
                imgTreeCompany.Visible = False
                imgTreeRep.Visible = False
            End If
        End If
    End Sub
End Class
