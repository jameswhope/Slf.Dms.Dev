Imports System.Data

Partial Class billing_Default
    Inherits System.Web.UI.Page

    Protected Sub btnRefresh_Click(sender As Object, e As System.EventArgs) Handles btnRefresh.Click

    End Sub
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

    Protected Sub gvInvoices_RowCreated(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvInvoices.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvInvoices, e.Row, Me.Page)
        End Select
    End Sub

    Protected Sub billing_Default_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        BindData()
    End Sub
    Private Sub BindData()
        dsInvoices.SelectParameters("statusid").DefaultValue = DBNull.Value.ToString
        dsInvoices.DataBind()
        gvInvoices.DataBind()
        gvInvoices.ShowFooter = True
        GetSummaryRow()
    End Sub

    Protected Sub gvInvoices_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvInvoices.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowview As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                Using ddl As DropDownList = TryCast(e.Row.FindControl("ddlActions"), DropDownList)
                    ddl.Attributes.Add("onchange", String.Format("return InvoiceAction({0},this.value);", rowview("BillingInvoiceID").ToString))
                End Using
             

        End Select
    End Sub

    Private Sub GetSummaryRow()
        gvInvoices.Columns(2).FooterStyle.HorizontalAlign = HorizontalAlign.Right
        gvInvoices.Columns(2).FooterText = "TOTAL (All Transactions)"

        Using dv As DataView = dsInvoices.Select(DataSourceSelectArguments.Empty)
            Using dt As DataTable = dv.ToTable
                If dt.Rows.Count > 0 Then
                    gvInvoices.Columns(4).FooterText = FormatCurrency(dt.Compute("sum(InvoiceAmount)", Nothing).ToString, 2)
                    gvInvoices.Columns(4).FooterStyle.HorizontalAlign = HorizontalAlign.Right
                End If
            End Using
        End Using
    End Sub

End Class
