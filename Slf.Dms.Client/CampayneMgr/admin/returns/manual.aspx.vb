Imports System.Data
Imports System.Data.OleDb
Imports System.Data.SqlClient
Imports System.IO

Imports AnalyticsHelper

Imports ReturnsHelper
Imports System.Web.Services

Partial Class admin_returns
    Inherits System.Web.UI.Page
    <WebMethod()> _
    Public Shared Function DeleteTempFiles(tempfile As String) As String
        Dim result As String = String.Empty
        Try
            Dim idx As Integer = tempfile.LastIndexOf("/")
            Dim fname As String = tempfile.Substring(idx + 1)
            Dim FolderPath As String = ConfigurationManager.AppSettings("AdminDocumentPath")

            File.Delete(String.Format("{0}{1}", FolderPath, fname))
        Catch ex As Exception

        End Try

        Return result
    End Function
    <WebMethod()> _
    Public Shared Function CreateCSVForDownload(buyerid As String, fromdate As String, todate As String, searchtext As String) As String
        Dim result As String = "<a class=""downFile"" href=""{0}"" target=""_blank"" style=""color:blue; text-decoration:underline;"">Download</a>"
        result += "<br/>Right-click the link and choose ""Save Link As..."""

        Try
            Dim ssql As String = "stp_returns_getBuyerLeads"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("buyerid", buyerid))
            params.Add(New SqlParameter("from", fromdate))
            params.Add(New SqlParameter("to", todate))
            params.Add(New SqlParameter("searchTerm", searchtext))

            Dim FolderPath As String = ConfigurationManager.AppSettings("AdminDocumentPath")
            Dim fileName As String = String.Format("{0}_manualreturn.csv", Guid.NewGuid.ToString)
            Dim lnkPath As String = String.Format("../docs/{0}", fileName)
            Dim actualFilePath As String = (String.Format("{0}{1}", FolderPath, fileName))

            Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.StoredProcedure, params.ToArray)
                Using sw As New StreamWriter(actualFilePath)
                    Dim hdr As New List(Of String)
                    For Each dc As DataColumn In dt.Columns
                        hdr.Add(String.Format("""{0}""", dc.ColumnName.ToString))
                    Next
                    sw.WriteLine(Join(hdr.ToArray, ","))

                    For Each dr As DataRow In dt.Rows
                        Dim line As New List(Of String)
                        For Each dc As DataColumn In dt.Columns
                            line.Add(String.Format("""{0}""", dr(dc).ToString))
                        Next
                        sw.WriteLine(Join(line.ToArray, ","))
                    Next
                End Using
            End Using
            result = String.Format(result, lnkPath)
        Catch ex As Exception
            result = ex.Message
        End Try

        Return result
    End Function
#Region "Fields"

    Public resetValue As String

    Private _buyers As New Dictionary(Of Integer, String)
    Private _userid As Integer

#End Region 'Fields

#Region "Properties"

    Public Property FromDate() As String
        Get
            If String.IsNullOrEmpty(txtFrom.Text) Then
                txtFrom.Text = Now.ToString("MM/dd/yyyy")
            End If
            Return txtFrom.Text
        End Get
        Set(ByVal value As String)
            txtFrom.Text = value
        End Set
    End Property

    Public Property ToDate() As String
        Get
            If String.IsNullOrEmpty(txtTo.Text) Then
                txtTo.Text = Now.ToString("MM/dd/yyyy")
            End If
            Return txtTo.Text
        End Get
        Set(ByVal value As String)
            txtTo.Text = value
        End Set
    End Property

    Public Property Userid() As Integer
        Get
            Return _userid
        End Get
        Set(ByVal value As Integer)
            _userid = value
        End Set
    End Property

#End Region 'Properties

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

    Public Sub pageSelector_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        Using gv As GridView = ddl.Parent.Parent.Parent.Parent
            If Not IsNothing(gv) Then
                gv.PageIndex = ddl.SelectedIndex
                gv.DataBind()
            End If
        End Using
    End Sub

    Protected Sub admin_returns_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Userid = CInt(Page.User.Identity.Name)
        resetValue = "0.00"
        If Not IsPostBack Then
            SetDates()
            LoadReturnReasons()
        End If

    End Sub

    Protected Sub admin_returns_PreRender(sender As Object, e As System.EventArgs) Handles Me.PreRender
        GridViewHelper.AddJqueryUI(gvManualReturns)
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        gvManualReturns.DataBind()
    End Sub

    Protected Sub dsManualReturns_Selected(sender As Object, e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsManualReturns.Selected
        If Not IsNothing(ddlBuyer.SelectedItem) Then
            lblLeadsFound.Text = String.Format(":::  Found {0} lead(s) for {1}", e.AffectedRows.ToString, ddlBuyer.SelectedItem.Text)
            If Not String.IsNullOrEmpty(txtFindLead.Text) Then
                lblLeadsFound.Text += String.Format(" matching '{0}' ", txtFindLead.Text)
            End If
        End If
    End Sub

    Protected Sub gvManualReturns_RowCreated(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvManualReturns.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvManualReturns, e.Row, Me.Page)

        End Select
    End Sub

    Protected Sub lnkClearSearch_Click(sender As Object, e As System.EventArgs) Handles lnkClearSearch.Click
        txtFindLead.Text = ""
        If Not ddlBuyer.SelectedItem.Value = -1 Then
            BindData()
        End If
        ShowToastFromCodeBehind("Search Reset!", "notice")
    End Sub

    Protected Sub lnkFindLeads_Click(sender As Object, e As System.EventArgs) Handles lnkFindLeads.Click
        If Not ddlBuyer.SelectedItem.Value = -1 Then
            If Not String.IsNullOrEmpty(txtFindLead.Text) Then
                BindData(txtFindLead.Text)
            End If
        End If
    End Sub

    Protected Sub lnkGetReturns_Click(sender As Object, e As System.EventArgs) Handles lnkGetReturns.Click
        If Not ddlBuyer.SelectedItem.Value = -1 Then
            BindData()
            portlet_filter.Style("display") = "block"
            lnkExport.Enabled = True
        Else
            ShowToastFromCodeBehind("Please select a buyer!", "warning")
            lnkExport.Enabled = False
        End If
    End Sub

    Protected Sub lnkReturnLeads_Click(sender As Object, e As System.EventArgs) Handles lnkReturnLeads.Click
        Dim iCnt As Integer = 0
        For index As Integer = 0 To gvManualReturns.Rows.Count - 1
            'Programmatically access the CheckBox from the TemplateField
            Dim cb As System.Web.UI.HtmlControls.HtmlInputCheckBox = CType(gvManualReturns.Rows(index).FindControl("chk_select"), System.Web.UI.HtmlControls.HtmlInputCheckBox)

            'If it's checked, return it...
            If cb.Checked Then
                Dim soid As Integer = gvManualReturns.DataKeys(index).Item(0).ToString
                Dim buyerid As Integer = gvManualReturns.DataKeys(index).Item(1).ToString
                Dim leadid As Integer = gvManualReturns.DataKeys(index).Item(2).ToString
                Dim txt As TextBox = gvManualReturns.Rows(index).FindControl("txtPrice")

                If soid > 0 Then
                    Dim ssql As String = "stp_returns_returnSubmittedOffer"
                    Dim params As New List(Of SqlParameter)
                    params.Add(New SqlParameter("SubmittedOfferID", soid))
                    params.Add(New SqlParameter("reason", ddlReturnReasons.SelectedItem.Value))
                    params.Add(New SqlParameter("undo", 0))
                    SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)

                    If Not IsNothing(txt) Then
                        If Not String.IsNullOrEmpty(txt.Text) Then
                            Dim newPrice As String = txt.Text.Replace("$", "").Replace(",", "")
                            Dim newSQL As String = "stp_returns_updateSubmittedPrice"
                            params = New List(Of SqlParameter)
                            params.Add(New SqlParameter("SubmittedOfferID", soid))
                            params.Add(New SqlParameter("newPrice", newPrice))
                            SqlHelper.ExecuteNonQuery(newSQL, CommandType.StoredProcedure, params.ToArray)
                        End If
                    End If

                    iCnt += 1
                End If

            End If
        Next
        BindData()
        ShowToastFromCodeBehind(String.Format("Successfully returned {0} lead(s)!", iCnt))
    End Sub

    Protected Sub lnkUndoReturn_Click(sender As Object, e As System.EventArgs) Handles lnkUndoReturn.Click
        Dim iCnt As Integer = 0
        For index As Integer = 0 To gvManualReturns.Rows.Count - 1
            'Programmatically access the CheckBox from the TemplateField
            Dim cb As System.Web.UI.HtmlControls.HtmlInputCheckBox = CType(gvManualReturns.Rows(index).FindControl("chk_select"), System.Web.UI.HtmlControls.HtmlInputCheckBox)

            'If it's checked, return it...
            If cb.Checked Then
                Dim soid As Integer = gvManualReturns.DataKeys(index).Item(0).ToString
                Dim buyerid As Integer = gvManualReturns.DataKeys(index).Item(1).ToString
                Dim leadid As Integer = gvManualReturns.DataKeys(index).Item(2).ToString
                Dim txt As TextBox = gvManualReturns.Rows(index).FindControl("txtPrice")

                Dim ssql As String = "stp_returns_returnSubmittedOffer"
                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("SubmittedOfferID", soid))
                params.Add(New SqlParameter("reason", ddlReturnReasons.SelectedItem.Value))
                params.Add(New SqlParameter("undo", 1))
                SqlHelper.ExecuteNonQuery(ssql, CommandType.StoredProcedure, params.ToArray)

                If Not IsNothing(txt) Then
                    If Not String.IsNullOrEmpty(txt.Text) Then
                        Dim newPrice As String = txt.Text.Replace("$", "").Replace(",", "")
                        Dim newSQL As String = "stp_returns_updateSubmittedPrice"
                        params = New List(Of SqlParameter)
                        params.Add(New SqlParameter("SubmittedOfferID", soid))
                        params.Add(New SqlParameter("newPrice", newPrice))
                        SqlHelper.ExecuteNonQuery(newSQL, CommandType.StoredProcedure, params.ToArray)
                    End If
                End If
                iCnt += 1
            End If
        Next
        BindData()
        ShowToastFromCodeBehind(String.Format("Successfully reversed {0} lead(s)!", iCnt))
    End Sub

    Private Sub BindData(Optional searchText As String = Nothing)
        dsManualReturns.SelectParameters("buyerid").DefaultValue = ddlBuyer.SelectedItem.Value
        dsManualReturns.SelectParameters("from").DefaultValue = txtFrom.Text
        dsManualReturns.SelectParameters("to").DefaultValue = txtTo.Text
        If IsNothing(searchText) Then
            dsManualReturns.SelectParameters("searchTerm").DefaultValue = DBNull.Value.ToString
        Else
            dsManualReturns.SelectParameters("searchTerm").DefaultValue = searchText
        End If

        dsManualReturns.DataBind()
        gvManualReturns.DataBind()
    End Sub

    Private Sub LoadReturnReasons()
        Using dt As DataTable = SqlHelper.GetDataTable("select distinct returnreason from tblreturnreasons order BY returnreason", CommandType.Text)
            For Each dr As DataRow In dt.Rows
                ddlReturnReasons.Items.Add(dr("returnreason").ToString)
            Next
        End Using
    End Sub

    Private Sub SetDates()
        'This week
        FromDate = Now.ToString("MM/dd/yyyy")
        ToDate = Now.ToString("MM/dd/yyyy")

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

        ddlQuickPickDate.Attributes("onchange") = "SetDates(this);"
        ddlQuickPickDate.SelectedIndex = 0
    End Sub

    Private Sub ShowToastFromCodeBehind(ByVal msgText As String, Optional msgType As String = "success", Optional bSticky As Boolean = False)
        Dim sb As New StringBuilder()
        sb.Append("$(function() { ")
        sb.AppendFormat("   showToast('{0}', '{1}',{2});", msgText, msgType, bSticky.ToString.ToLower)
        sb.Append("});")

        Dim sm As ScriptManager = ScriptManager.GetCurrent(Page)
        If sm.IsInAsyncPostBack Then
            ScriptManager.RegisterStartupScript(Page, Me.GetType, "myscript", sb.ToString(), True)
        End If
    End Sub

#End Region 'Methods

    Protected Sub lnkFixPrice_Click(sender As Object, e As System.EventArgs) Handles lnkFixPrice.Click
        Dim iCnt As Integer = 0
        For index As Integer = 0 To gvManualReturns.Rows.Count - 1
            'Programmatically access the CheckBox from the TemplateField
            Dim cb As System.Web.UI.HtmlControls.HtmlInputCheckBox = CType(gvManualReturns.Rows(index).FindControl("chk_select"), System.Web.UI.HtmlControls.HtmlInputCheckBox)

            'If it's checked, return it...
            If cb.Checked Then
                Dim soid As Integer = gvManualReturns.DataKeys(index).Item(0).ToString
                Dim buyerid As Integer = gvManualReturns.DataKeys(index).Item(1).ToString
                Dim leadid As Integer = gvManualReturns.DataKeys(index).Item(2).ToString
                Dim txt As TextBox = gvManualReturns.Rows(index).FindControl("txtPrice")
                If Not IsNothing(txt) Then
                    If Not String.IsNullOrEmpty(txt.Text) Then
                        Dim newPrice As String = txt.Text.Replace("$", "").Replace(",", "")
                        Dim newSQL As String = "stp_returns_updateSubmittedPrice"
                        Dim params As New List(Of SqlParameter)
                        params = New List(Of SqlParameter)
                        params.Add(New SqlParameter("SubmittedOfferID", soid))

                        If chkAllPrice.Checked = True AndAlso Not String.IsNullOrEmpty(txtAllPrice.Text) Then
                            newPrice = txtAllPrice.Text
                        End If
                        params.Add(New SqlParameter("newPrice", newPrice))

                        SqlHelper.ExecuteNonQuery(newSQL, CommandType.StoredProcedure, params.ToArray)
                    End If
                End If
                iCnt += 1
            End If
        Next
        BindData()
        ShowToastFromCodeBehind(String.Format("Successfully update the price for {0} lead(s)!", iCnt))
    End Sub
End Class