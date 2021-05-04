Imports System.Data

Imports Drg.Util.DataHelpers

Partial Class negotiation_assignments_Default
    Inherits System.Web.UI.Page

    #Region "Fields"

    Private _userid As Integer

    #End Region 'Fields

    #Region "Properties"

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
    
    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)
    End Sub
    ''' <summary>
    ''' set gridview pager buttons
    ''' </summary>
    ''' <param name="gridView"></param>
    ''' <param name="gvPagerRow"></param>
    ''' <param name="page"></param>
    ''' <remarks></remarks>
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
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Userid = Integer.Parse(Page.User.Identity.Name)

        If Not IsPostBack Then
            loadData()
        End If

    End Sub

    Protected Sub gvAssignments_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAssignments.RowCreated

        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(sender, e.Row, Me.Page)
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
            Case DataControlRowType.DataRow

        End Select
    End Sub

    Protected Sub gvAssignments_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAssignments.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                'GridViewHelper.styleGridviewRows(e)
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

                Dim hlClient As HyperLink = TryCast(e.Row.FindControl("lnkClientName"), HyperLink)
                hlClient.Text = String.Format("{0}", rowView("clientname").ToString)
                hlClient.NavigateUrl = "#" 'String.Format("~/clients/client/?id={0}", rowView("clientid").ToString)

                Dim hlCreditor As HyperLink = TryCast(e.Row.FindControl("lnkCreditorName"), HyperLink)
                hlCreditor.Text = String.Format("{0}", rowView("CreditorName").ToString)
                hlCreditor.NavigateUrl = String.Format("~/negotiation/clients/?cid={0}&crid={1}", rowView("clientid").ToString, rowView("creditoraccountid").ToString)

        End Select
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

    Private Sub lnkExportExcel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkExportExcel.Click
        Dim stringWrite As New System.IO.StringWriter()
        Dim htmlWrite As New HtmlTextWriter(stringWrite)

        Dim dv As DataView = dsAssignments.Select(DataSourceSelectArguments.Empty)
        Response.Clear()
        Response.AddHeader("content-disposition", "attachment;filename=MyAssignments.xls")
        Response.Charset = ""
        ' If you want the option to open the Excel file without saving then
        ' comment out the line below
        ' Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.ContentType = "application/ms-excel"

        Dim lnk As LinkButton = TryCast(sender, LinkButton)
        Using gv As GridView = gvAssignments '= TryCast(lnk.NamingContainer.NamingContainer, GridView)
            gv.DataSourceID = dsAssignments.ID

            gv.AllowPaging = False
            gv.DataBind()

            PrepareGridViewForExport(gv)
            gv.RenderControl(htmlWrite)
        End Using

        Response.Write(stringWrite.ToString())
        Response.End()

        Response.Write(stringWrite.ToString())
        Response.End()


        loadData()
    End Sub
    Private Sub loadData(Optional ByVal bIncludePaid As Integer = 0)
        dsSummary.SelectParameters("userid").DefaultValue = Userid
        dsSummary.DataBind()
        gvSummary.DataBind()

        dsAssignments.SelectParameters("userid").DefaultValue = Userid
        dsAssignments.SelectParameters("includePaid").DefaultValue = bIncludePaid
        dsAssignments.DataBind()
        gvAssignments.DataBind()

    End Sub

    #End Region 'Methods

    Protected Sub chkShowPaid_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkShowPaid.CheckedChanged
        If chkShowPaid.Checked Then
            loadData(1)
        Else
            loadData()
        End If
    End Sub
End Class