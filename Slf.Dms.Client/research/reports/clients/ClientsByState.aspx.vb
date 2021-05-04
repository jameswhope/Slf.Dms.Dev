Imports System.IO
Imports System.Data
Imports Drg.Util.DataAccess
Imports System.Collections.Generic

Partial Class ClientsByState
    Inherits PermissionPage

    Private groupList As New Hashtable

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ds_Clients.SelectParameters("UserID").DefaultValue = Page.User.Identity.Name
        SetRollups()
    End Sub

    Private Sub SetRollups()
        Dim CommonTasks As List(Of String) = CType(Master, research_reports_reports).CommonTasks
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Export();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/icons/xls.png") & """ align=""absmiddle""/>Export to Excel</a>")
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))

    End Sub

    Protected Sub lnkExport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExport.Click
        Dim dv As DataView = ds_Clients.Select(DataSourceSelectArguments.Empty)
        dv.Sort = "company,state"

        Dim tblTransactions As DataTable = dv.Table
        Dim sw As New StringWriter
        Dim htw As New HtmlTextWriter(sw)
        Dim table As New System.Web.UI.WebControls.Table
        Dim tr As New System.Web.UI.WebControls.TableRow
        Dim cell As TableCell

        For i As Integer = 0 To tblTransactions.Columns.Count - 1
            cell = New TableCell
            cell.Text = tblTransactions.Columns(i).ColumnName
            tr.Cells.Add(cell)
        Next
        table.Rows.Add(tr)

        For Each row As DataRow In tblTransactions.Rows
            tr = New TableRow
            For i As Integer = 0 To tblTransactions.Columns.Count - 1
                cell = New TableCell
                cell.Attributes.Add("class", "text")
                cell.Text = row.Item(i).ToString
                tr.Cells.Add(cell)
            Next
            table.Rows.Add(tr)
        Next

        table.RenderControl(htw)

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.ContentType = "application/ms-excel"
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=active_clients_by_state.xls")
        HttpContext.Current.Response.Write(sw.ToString)
        HttpContext.Current.Response.End()
    End Sub

    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
            Dim company As String = rowView("company").ToString.ToLower.Replace(" ", "")
            Dim count As Integer = CInt(rowView("count"))
            Dim childCount As Integer = rowView("rowNum").ToString
            Dim imgTree As HtmlImage = TryCast(e.Row.FindControl("imgTree"), HtmlImage)
            Dim dk As DataKey = GridView1.DataKeys(e.Row.RowIndex)

            If groupList.Contains(company) Then
                imgTree.Visible = False
                e.Row.Attributes.Add("id", String.Format("tr_{0}_child{1}", company, e.Row.RowIndex))
                e.Row.Cells(1).Text = ""
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#ffffda';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                If Not (Not Page.IsPostBack AndAlso dk("companyid") = Request.QueryString("companyid")) Then
                    e.Row.Style("display") = "none"
                End If
                If count = 0 Then
                    e.Row.Cells(2).Style("color") = "#c9c9c9"
                    e.Row.Cells(3).Style("color") = "#c9c9c9"
                Else
                    e.Row.Style("cursor") = "hand"
                    e.Row.Attributes.Add("onclick", String.Format("javascript:window.location.href='ClientsByStateDetail.aspx?companyid={0}&stateid={1}&groupid={2}';", dk("companyid"), dk("stateid"), ddlClientGroupStatus.SelectedItem.Value))
                End If
            Else
                groupList.Add(company, Nothing)
                e.Row.Attributes.Add("id", String.Format("tr_{0}_parent", company))
                imgTree.Attributes.Add("onclick", "toggleDocument('" & company & "','" & GridView1.ClientID & "');")
                If Not Page.IsPostBack AndAlso dk("companyid") = Request.QueryString("companyid") Then
                    imgTree.Src = "~/images/tree_minus.bmp"
                End If
            End If
        End If
    End Sub

    Protected Sub ddlClientGroupStatus_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlClientGroupStatus.DataBound
        If Not Page.IsPostBack AndAlso IsNumeric(Request.QueryString("groupid")) Then
            Dim li As ListItem = ddlClientGroupStatus.Items.FindByValue(Request.QueryString("groupid"))
            If Not IsNothing(li) Then
                li.Selected = True
            End If
        End If
    End Sub
End Class
