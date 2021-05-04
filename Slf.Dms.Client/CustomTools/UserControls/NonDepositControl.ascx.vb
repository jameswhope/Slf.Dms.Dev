Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Xml
Imports System.Xml.Linq
Imports System.Linq
Imports System.IO

Partial Class CustomTools_UserControls_NonDepositControl
    Inherits System.Web.UI.UserControl

    Private UserID As Integer
    Public NDtabIndex As Integer = -1

    Private Enum Tabs As Integer
        OpenNonDeposits = 1
        NonDepositExceptions = 2
        NonDepositCancellations = 3
    End Enum

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Not Page.IsPostBack Then
            If PermissionHelperLite.HasPermission(UserID, "Non Deposit") Then
                Me.divNonDeposit.Visible = True
                LoadTabsData()
            End If
        End If
    End Sub

    Private Sub LoadTabsData()
        If PermissionHelperLite.HasPermission(UserID, "Non Deposit") Then
            ViewState("SortNonDeposit") = "ASC"
            LoadFirms(ddlNonDepositFirmList)
            LoadNonDepositSubstatus()
            BindOpenNonDeposits("Due")
            If NDtabIndex = -1 Then
                NDtabIndex = Tabs.OpenNonDeposits
            End If
        End If

        If PermissionHelperLite.HasPermission(UserID, "Non Deposit-Manage Exceptions") Then
            ViewState("SortNonDepositExceptions") = "ASC"
            LoadFirms(ddlNonDepositExceptionsFirmList)
            BindNonDepositExceptions("")
            If NDtabIndex = -1 Then
                NDtabIndex = Tabs.NonDepositExceptions
            End If
        End If

        If PermissionHelperLite.HasPermission(UserID, "Non Deposit-Pending Cancellations") Then
            ViewState("SortNonDepositCancellations") = "ASC"
            LoadFirms(ddlNonDepositCancellationFirmList)
            BindNonDepositCancellations("")
            If NDtabIndex = -1 Then
                NDtabIndex = Tabs.NonDepositCancellations
            End If
        End If
    End Sub

    Public Sub LoadTabStrips()
        Me.tsNonDeposits.TabPages.Clear()
        If PermissionHelperLite.HasPermission(UserID, "Non Deposit") Then
            tsNonDeposits.TabPages.Add(New Slf.Dms.Controls.TabPage("Open&nbsp;Non&nbsp;Deposits&nbsp;&nbsp;<font color='blue'>(" & Val(hdnOpenNonDeposits.Value).ToString() & ")</font>", phOpenNonDeposits.ClientID))
        End If
        If PermissionHelperLite.HasPermission(UserID, "Non Deposit-Manage Exceptions") Then
            tsNonDeposits.TabPages.Add(New Slf.Dms.Controls.TabPage("Exceptions&nbsp;&nbsp;<font color='blue'>(" & Val(hdnNonDepositExceptions.Value).ToString() & ")</font>", phNonDepositExceptions.ClientID))
        End If
        If PermissionHelperLite.HasPermission(UserID, "Non Deposit-Pending Cancellations") Then
            tsNonDeposits.TabPages.Add(New Slf.Dms.Controls.TabPage("Termination&nbsp;Candidates&nbsp;&nbsp;<font color='blue'>(" & Val(hdnNonDepositCancellations.Value).ToString() & ")</font>", phNonDepositCanCellations.ClientID))
        End If
    End Sub

    Private Sub LoadFirms(ByVal ddl As DropDownList)
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            cmd.CommandText = "select ShortCoName [Name], companyid from tblcompany"
            Using cmd.Connection
                cmd.Connection.Open()
                ddl.ClearSelection()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        ddl.Items.Add(New ListItem(DatabaseHelper.Peel_string(rd, "Name"), DatabaseHelper.Peel_int(rd, "companyid")))
                    End While
                    ddl.Items.Insert(0, New ListItem(" -- All -- ", 0))
                End Using
            End Using
        End Using
    End Sub

#Region "gvNonDeposits"
    Private Function GetNonDeposits() As DataTable
        Dim CompanyId As Nullable(Of Integer) = Nothing
        Dim MatterSubstatusId As Nullable(Of Integer) = Nothing
        Dim NonDepositType As Nullable(Of Integer) = Nothing
        If CInt(ddlNonDepositFirmList.SelectedValue) > 0 Then
            CompanyId = CInt(ddlNonDepositFirmList.SelectedValue)
        End If
        If CInt(Me.ddlNonDepositMatterStatus.SelectedValue) > 0 Then
            MatterSubstatusId = CInt(Me.ddlNonDepositMatterStatus.SelectedValue)
        End If
        If CInt(ddlNonDepositType.SelectedValue) > 0 Then
            NonDepositType = CInt(ddlNonDepositType.SelectedValue)
        End If
        Return NonDepositHelper.GetOpenNonDeposits(CompanyId, MatterSubstatusId, NonDepositType, chk4plus.Checked)
    End Function

    Private Sub BindOpenNonDeposits(ByVal SortExpr As String)
        Dim dt As DataTable = GetNonDeposits()

        If Not IsNothing(dt) Then
            If SortExpr.Trim.Length > 0 Then
                dt = SortNondeposits(dt, SortExpr)
            End If
            'Apply filter to Letter Type
            Dim dv As New DataView(dt)
            If ddlLetter.SelectedValue.ToUpper = "ALL" Then
                dv.RowFilter = ""
            Else
                dv.RowFilter = String.Format("Letter = '{0}'", ddlLetter.SelectedValue)
            End If
            gvNonDeposits.DataSource = dv
            gvNonDeposits.DataBind()
            hdnOpenNonDeposits.Value = dv.Count
        Else
            hdnOpenNonDeposits.Value = 0
        End If
    End Sub

    Private Sub LoadNonDepositSubstatus()
        ddlNonDepositMatterStatus.DataSource = NonDepositHelper.GetActiveMatterSubstatus()
        ddlNonDepositMatterStatus.DataTextField = "MatterSubStatus"
        ddlNonDepositMatterStatus.DataValueField = "mattersubstatusid"
        ddlNonDepositMatterStatus.DataBind()
        ddlNonDepositMatterStatus.Items.Insert(0, New ListItem("-- All --", "0"))
        ddlNonDepositMatterStatus.SelectedIndex = 0
    End Sub

    Protected Sub gvNonDeposits_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvNonDeposits.PageIndexChanging
        gvNonDeposits.PageIndex = e.NewPageIndex
        BindOpenNonDeposits("")
        NDtabIndex = Tabs.OpenNonDeposits
    End Sub

    Protected Sub lnkNonDepositFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNonDepositFilter.Click
        gvNonDeposits.PageIndex = 0
        ViewState("SortNonDeposit") = "ASC"
        BindOpenNonDeposits("Due")
        NDtabIndex = Tabs.OpenNonDeposits
    End Sub

    Protected Sub gvNonDeposits_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNonDeposits.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim strMatterID As String = CType(e.Row.FindControl("hdnNonDepositMatterId"), HtmlInputHidden).Value
            Dim strClientID As String = CType(e.Row.FindControl("hdnNonDepositClientId"), HtmlInputHidden).Value
            Dim slink As String = String.Format("javascript:window.navigate('{0}?id={1}&aid=0&mid={2}&ciid=0');", ResolveUrl("~/clients/client/creditors/matters/nondepositmatterinstance.aspx"), strClientID, strMatterID)
            e.Row.Cells(0).Attributes.Add("onClick", slink)
            e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
            e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this);"
        End If
    End Sub

    Private Function SortNondeposits(ByVal dt As DataTable, ByVal SortExpression As String) As DataTable
        Dim rdt As DataTable = dt
        If dt.Rows.Count > 0 Then
            Dim dataView As DataView = New DataView(dt)
            Dim sortExp As String = "[" & SortExpression & "]"

            If ViewState("SortNonDeposit") = "ASC" Then
                sortExp += " DESC"
                ViewState("SortNonDeposit") = "DESC"
            Else
                sortExp += " ASC"
                ViewState("SortNonDeposit") = "ASC"
            End If

            dataView.Sort = sortExp
            rdt = dataView.ToTable
        End If
        Return rdt
    End Function

    Protected Sub gvNonDeposits_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvNonDeposits.Sorting
        BindOpenNonDeposits(e.SortExpression)
        NDtabIndex = Tabs.OpenNonDeposits
    End Sub

    Protected Sub gvNonDeposits_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNonDeposits.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                Dim srcString As String
                If ViewState("SortNonDeposit").ToString().Equals("DESC") Then
                    srcString = "~/images/sort-desc.png"
                Else
                    srcString = "~/images/sort-asc.png"
                End If

                For Each dataCell As DataControlFieldHeaderCell In e.Row.Cells
                    If Not String.IsNullOrEmpty(dataCell.ContainingField.SortExpression) Then
                        Dim img As New HtmlImage()
                        img.Src = srcString
                        dataCell.Controls.Add(img)
                        dataCell.HorizontalAlign = HorizontalAlign.Center
                    End If
                Next
        End Select
    End Sub

#End Region

#Region "gvExceptions"
    Private Function GetNonDepositExceptions() As DataTable
        Dim CompanyId As Nullable(Of Integer) = Nothing
        If CInt(ddlNonDepositFirmList.SelectedValue) > 0 Then
            CompanyId = CInt(ddlNonDepositExceptionsFirmList.SelectedValue)
        End If
        Return NonDepositHelper.GetPendingExceptions(CompanyId)
    End Function

    Private Sub BindNonDepositExceptions(ByVal SortExpr As String)
        Dim dt As DataTable = GetNonDepositExceptions()

        If Not IsNothing(dt) Then
            If SortExpr.Trim.Length > 0 Then
                dt = SortNondepositExceptions(dt, SortExpr)
            End If
            gvNondepositExceptions.DataSource = dt
            gvNondepositExceptions.DataBind()
            hdnNonDepositExceptions.Value = dt.Rows.Count
        Else
            hdnNonDepositExceptions.Value = 0
        End If
    End Sub

    Protected Sub gvNonDepositExceptions_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvNondepositExceptions.PageIndexChanging
        gvNondepositExceptions.PageIndex = e.NewPageIndex
        BindNonDepositExceptions("")
        NDtabIndex = Tabs.NonDepositExceptions
    End Sub

    Protected Sub lnkNonDepositExceptionFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNonDepositExceptionsFilter.Click
        gvNondepositExceptions.PageIndex = 0
        BindNonDepositExceptions("")
        NDtabIndex = Tabs.NonDepositExceptions
    End Sub

    Protected Sub gvNondepositExceptions_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNondepositExceptions.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
            e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this);"
        End If
    End Sub

    Private Function SortNondepositExceptions(ByVal dt As DataTable, ByVal SortExpression As String) As DataTable
        Dim rdt As DataTable = dt
        If dt.Rows.Count > 0 Then
            Dim dataView As DataView = New DataView(dt)
            Dim sortExp As String = "[" & SortExpression & "]"

            If ViewState("SortNonDepositExceptions") = "ASC" Then
                sortExp += " DESC"
                ViewState("SortNonDepositExceptions") = "DESC"
            Else
                sortExp += " ASC"
                ViewState("SortNonDepositExceptions") = "ASC"
            End If

            dataView.Sort = sortExp
            rdt = dataView.ToTable
        End If
        Return rdt
    End Function

    Protected Sub gvNondepositExceptions_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvNondepositExceptions.Sorting
        BindNonDepositExceptions(e.SortExpression)
        NDtabIndex = Tabs.NonDepositExceptions
    End Sub

    Protected Sub gvNondepositExceptions_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNondepositExceptions.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                Dim srcString As String
                If ViewState("SortNonDepositExceptions").ToString().Equals("DESC") Then
                    srcString = "~/images/sort-desc.png"
                Else
                    srcString = "~/images/sort-asc.png"
                End If

                For Each dataCell As DataControlFieldHeaderCell In e.Row.Cells
                    If Not String.IsNullOrEmpty(dataCell.ContainingField.SortExpression) Then
                        Dim img As New HtmlImage()
                        img.Src = srcString
                        dataCell.Controls.Add(img)
                        dataCell.HorizontalAlign = HorizontalAlign.Center
                    End If
                Next
        End Select
    End Sub

    Protected Sub gvNondepositExceptions_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvNondepositExceptions.RowCommand
        If e.CommandName.ToLower = "fixexception" Then
            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvNondepositExceptions.Rows(index)
            FixException(row)
        ElseIf e.CommandName.ToLower = "fixselectedexceptions" Then
            For Each row As GridViewRow In gvNondepositExceptions.Rows
                FixException(row)
            Next
        End If
        BindNonDepositExceptions("")
        NDtabIndex = Tabs.NonDepositExceptions
    End Sub

    Private Function FixException(ByVal row As GridViewRow) As Boolean
        Dim success As Boolean = True
        Dim ExceptionID As Integer = CInt(gvNondepositExceptions.DataKeys(row.RowIndex).Value)
        If CType(row.FindControl("rdCreateYes"), RadioButton).Checked Then
            NonDepositHelper.ResolveException(ExceptionID, True, UserID)
        ElseIf CType(row.FindControl("rdCreateNo"), RadioButton).Checked Then
            NonDepositHelper.ResolveException(ExceptionID, False, UserID)
        Else
            success = False
        End If
        Return success
    End Function

#End Region

#Region "Cancellations"
    Private Function GetNonDepositCancellations() As DataTable
        Dim CompanyId As Nullable(Of Integer) = Nothing
        If CInt(ddlNonDepositCancellationFirmList.SelectedValue) > 0 Then
            CompanyId = CInt(ddlNonDepositCancellationFirmList.SelectedValue)
        End If
        Return NonDepositHelper.GetPendingCancellations(CompanyId)
    End Function

    Private Sub BindNonDepositCancellations(ByVal SortExpr As String)
        Dim dt As DataTable = GetNonDepositCancellations()

        If Not IsNothing(dt) Then
            If SortExpr.Trim.Length > 0 Then
                dt = SortNondepositCancellations(dt, SortExpr)
            End If
            gvNondepositCancellations.DataSource = dt
            gvNondepositCancellations.DataBind()
            hdnNonDepositCancellations.Value = dt.Rows.Count
        Else
            hdnNonDepositCancellations.Value = 0
        End If
    End Sub

    Protected Sub gvNonDepositCancellations_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvNondepositCancellations.PageIndexChanging
        gvNondepositExceptions.PageIndex = e.NewPageIndex
        BindNonDepositCancellations("")
        NDtabIndex = Tabs.NonDepositCancellations
    End Sub

    Protected Sub lnkNonDepositCancellationsFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkNonDepositCancellationFilter.Click
        gvNondepositCancellations.PageIndex = 0
        BindNonDepositCancellations("")
        NDtabIndex = Tabs.NonDepositCancellations
    End Sub

    Protected Sub gvNondepositCancellations_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNondepositCancellations.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Attributes("onmouseover") = "javascript:setMouseOverColor(this);"
            e.Row.Attributes("onmouseout") = "javascript:setMouseOutColor(this);"
        End If
    End Sub

    Private Function SortNondepositCancellations(ByVal dt As DataTable, ByVal SortExpression As String) As DataTable
        Dim rdt As DataTable = dt
        If dt.Rows.Count > 0 Then
            Dim dataView As DataView = New DataView(dt)
            Dim sortExp As String = "[" & SortExpression & "]"

            If ViewState("SortNonDepositCancellations") = "ASC" Then
                sortExp += " DESC"
                ViewState("SortNonDepositCancellations") = "DESC"
            Else
                sortExp += " ASC"
                ViewState("SortNonDepositCancellations") = "ASC"
            End If

            dataView.Sort = sortExp
            rdt = dataView.ToTable
        End If
        Return rdt
    End Function

    Protected Sub gvNondepositCancellations_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvNondepositCancellations.Sorting
        BindNonDepositCancellations(e.SortExpression)
        NDtabIndex = Tabs.NonDepositCancellations
    End Sub

    Protected Sub gvNondepositCancellations_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNondepositCancellations.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                Dim srcString As String
                If ViewState("SortNonDepositCancellations").ToString().Equals("DESC") Then
                    srcString = "~/images/sort-desc.png"
                Else
                    srcString = "~/images/sort-asc.png"
                End If

                For Each dataCell As DataControlFieldHeaderCell In e.Row.Cells
                    If Not String.IsNullOrEmpty(dataCell.ContainingField.SortExpression) Then
                        Dim img As New HtmlImage()
                        img.Src = srcString
                        dataCell.Controls.Add(img)
                        dataCell.HorizontalAlign = HorizontalAlign.Center
                    End If
                Next
        End Select
    End Sub

    Protected Sub gvNondepositCancellation_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvNondepositCancellations.RowCommand
        If e.CommandName.ToLower = "removendcancel" Then
            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvNondepositCancellations.Rows(index)
            RemoveCancellation(row)
        End If
        BindNonDepositCancellations("")
        NDtabIndex = Tabs.NonDepositCancellations
    End Sub

    Private Sub RemoveCancellation(ByVal row As GridViewRow)  
        Dim CancellationID As Integer = CInt(gvNondepositCancellations.DataKeys(row.RowIndex).Value)
        NonDepositHelper.DeleteFromCancellation(CancellationID, UserID)
     End Sub

#End Region


End Class
