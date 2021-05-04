Partial Class portals_affiliate_offers
    Inherits System.Web.UI.Page

    #Region "Fields"

    Private Userid As Integer

    #End Region 'Fields

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

    Protected Sub gvOffers_DataBound(sender As Object, e As System.EventArgs) Handles gvOffers.DataBound
        If Not IsNothing(gvOffers.BottomPagerRow) Then
            gvOffers.BottomPagerRow.Visible = True
        End If
    End Sub

    Protected Sub gvOffers_PreRender(sender As Object, e As System.EventArgs) Handles gvOffers.PreRender
        GridViewHelper.AddJqueryUI(gvOffers)
    End Sub

    Protected Sub gvTraffic_RowCreated(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvOffers.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvOffers, e.Row, Me.Page)

        End Select
    End Sub

    Protected Sub lnkFilter_Click(sender As Object, e As System.EventArgs) Handles lnkFilter.Click
        BindData()
    End Sub

    Protected Sub lnkReset_Click(sender As Object, e As System.EventArgs) Handles lnkReset.Click
        Response.Redirect("offers.aspx")
    End Sub

    Protected Sub portals_affiliate_offers_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Userid = Page.User.Identity.Name

        If Not IsPostBack Then
            LoadDropDowns()
            BindData()
        End If
    End Sub

 

    Private Sub BindData()
        Dim searchText As String = txtSearch.Text.Trim

        dsOffers.SelectParameters("userid").DefaultValue = Userid

        If Not String.IsNullOrEmpty(searchText) Then
            dsOffers.SelectParameters("OfferName").DefaultValue = searchText
        Else
            dsOffers.SelectParameters("OfferName").DefaultValue = DBNull.Value.ToString
        End If

        If Not String.IsNullOrEmpty(ddlStatus.SelectedItem.Value) Then
            dsOffers.SelectParameters("OfferStatus").DefaultValue = ddlStatus.SelectedItem.Value
        Else
            dsOffers.SelectParameters("OfferStatus").DefaultValue = DBNull.Value.ToString
        End If
        If Not String.IsNullOrEmpty(ddlVerticals.SelectedItem.Value) Then
            dsOffers.SelectParameters("OfferVertical").DefaultValue = ddlVerticals.SelectedItem.Value
        Else
            dsOffers.SelectParameters("OfferVertical").DefaultValue = DBNull.Value.ToString
        End If
        dsOffers.SelectParameters("OfferMediaType").DefaultValue = 56

        dsOffers.DataBind()
        gvOffers.DataBind()
    End Sub

    Private Sub LoadDropDowns()
        dsVerticals.SelectParameters("userid").DefaultValue = Userid
        dsVerticals.DataBind()
    End Sub

    #End Region 'Methods

    Protected Sub gvOffers_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvOffers.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                GridViewHelper.addHandOnHover(e)
        End Select
    End Sub
End Class