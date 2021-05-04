Imports System.Data

Imports LocalHelper
Imports System.Collections.Generic
Imports Drg.Util.DataAccess

Partial Class research_reports_litigation_documents_Default
    Inherits System.Web.UI.Page
    Private _UserID As Integer

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

    Protected Sub btnExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnExport.Click
        Dim stringWrite As New System.IO.StringWriter()
        Dim htmlWrite As New HtmlTextWriter(stringWrite)

        Response.Clear()
        Response.AddHeader("content-disposition", "attachment;filename=documents.xls")
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
        lblResults.Text = String.Format("{0} documents found.", e.AffectedRows)
    End Sub

    Protected Sub gvResults_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvResults.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvResults, e.Row, Me.Page)
        End Select
    End Sub

    Protected Sub gvResults_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvResults.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim row As Data.DataRowView = CType(e.Row.DataItem, Data.DataRowView)
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CAE1FF';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")

                Dim credNum As String = row("creditor last 4").ToString
                If credNum.Length > 4 Then
                    e.Row.Cells(4).Text = String.Format("{0}{1}", StrDup(credNum.Length - 4, "*"), Right(credNum.ToString, 4))
                End If

                Dim newName As String = ""
                newName = LocalHelper.GetVirtualDocFullPath(row("pdfPAth").ToString)
                'newName = String.Format("file:///{0}", row("pdfPAth").ToString.Replace("\", "\\"))
                e.Row.Attributes.Add("ondblclick", "javascript:OpenDocument('" + newName + "');")
                e.Row.ToolTip = "Double click to view document."

        End Select
    End Sub

    Protected Sub research_reports_litigation_documents_Default_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        If Not Page.IsPostBack Then
            LoadQuickPickDates(ddlQuickPickDate, txtTransDate1, txtTransDate2)
            GetResults()
        End If
        ddlQuickPickDate.Attributes("onchange") = String.Format("SetDatesGeneric(this,'{0}','{1}');", txtTransDate1.ClientID, txtTransDate2.ClientID)
    End Sub

    Private Sub GetResults()
        Dim criteria As New StringBuilder
        If ddlQuickPickDate.SelectedItem.Text <> "ALL" Then
            criteria.AppendFormat(" and (dr.relateddate between '{0}' and '{1} 23:59')", txtTransDate1.Text, txtTransDate2.Text)
        End If

        criteria.Append(GetSelectedIDsText(lbDocumentType, "dt.typeid"))
        criteria.Append(GetSelectedIDsText(lbCreatedBy, "dr.relatedby"))
        criteria.Append(GetSelectedIDsText(lbCompany, "co.companyid"))
        criteria.Append("")

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

#End Region 'Methods

    Protected Sub btnZipDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnZipDocs.Click

        Dim zipFilePath As String = String.Format("\\lex-dev-30\clientstorage\archivelogs\LitigationZippedDocuments_{0}.zip", Format(Now, "yyyyMMddhhss"))
        Using dt As DataTable = TryCast(dsResults.Select(DataSourceSelectArguments.Empty), DataView).ToTable
            If dt.Rows.Count > 0 Then
                Using z As New Ionic.Zip.ZipFile
                    For Each dr As DataRow In dt.Rows
                        Dim demandFilePath As String = dr("pdfPath").ToString
                        z.AddFile(demandFilePath.Replace("lex-dev-30", "nas02"), "Documents")
                    Next
                    z.Save(zipFilePath)
                End Using
            End If
        End Using
        Dim sBody As New StringBuilder
        sBody.AppendFormat("The following zipped file is ready:<br>{0}", zipFilePath)
        Dim sTo As String = SqlHelper.ExecuteScalar(String.Format("select emailaddress from tbluser where userid = {0}", _UserID), CommandType.Text)

        EmailHelper.SendMessage("noreply@lexxiom.com", sTo, "Litigation Documents - Zipped", sBody.ToString)
    End Sub
End Class