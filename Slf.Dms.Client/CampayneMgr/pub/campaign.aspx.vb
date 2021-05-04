Imports AdminHelper

Partial Class pub_campaign
    Inherits System.Web.UI.Page

#Region "Properties"

    Public Property Userid() As Integer
        Get
            Return Session("_userid")
        End Get
        Set(ByVal value As Integer)
            Session("_userid") = value
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

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        gvCampaign.DataBind()
    End Sub

    Protected Sub gvCampaign_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvCampaign.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvCampaign, e.Row, Me.Page)

        End Select
    End Sub

    Protected Sub gvCampaign_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvCampaign.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                Dim rowView As CampaignObject = TryCast(e.Row.DataItem, CampaignObject)

                Dim img As Image = e.Row.FindControl("imgActive")
                Dim imgUrl As String = GetImgUrl(rowView.Active)
                img.ImageUrl = imgUrl
                img.ToolTip = String.Format("Campaign Active : {0}", rowView.Active)

                Dim showCampaign As New StringBuilder
                showCampaign.Append("return ShowCampaign(")
                Dim pixel As String = rowView.AffiliatePixel
                If IsNothing(pixel) Then
                    pixel = ""
                Else
                    pixel = pixel.Replace("'", """").Replace(vbCrLf, "").Replace(vbLf, "")
                End If
                showCampaign.AppendFormat("{0},'{1}',{2},'{3}',{4},'{5}','{6}','{7}',{8},{9});", _
                                       rowView.CampaignID, _
                                       rowView.Campaign, _
                                       rowView.AffiliateID, _
                                       String.Concat(rowView.MediaTypeID, "|", rowView.TrafficTypeID), _
                                       rowView.OfferID, _
                                       FormatNumber(rowView.Price, 2), _
                                       pixel, _
                                       rowView.Active, _
                                       rowView.Priority, _
                                       rowView.Pickle)
                Dim lnk As LinkButton = e.Row.FindControl("lnkEdit")
                lnk.OnClientClick = showCampaign.ToString

                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
                If e.Row.RowState = DataControlRowState.Alternate Then
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
                Else
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If
        End Select
    End Sub

    Protected Sub gvCampaign_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvCampaign.Sorting
        odsCampaigns.SelectParameters("sortField").DefaultValue = e.SortExpression
        If ViewState("sortOrder") = "ASC" Then
            odsCampaigns.SelectParameters("sortOrder").DefaultValue = "DESC"
            ViewState("sortOrder") = "DESC"
        Else
            odsCampaigns.SelectParameters("sortOrder").DefaultValue = "ASC"
            ViewState("sortOrder") = "ASC"
        End If

        e.Cancel = True
    End Sub

    Protected Sub pub_campaign_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Userid = CInt(Page.User.Identity.Name)
        hdnUID.Value = Userid.ToString
    End Sub

    Protected Sub btnFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilter.Click
        gvCampaign.DataBind()
    End Sub

#End Region 'Methods

End Class