
Imports SchoolFormControl.SchoolCampaignHelper
Imports SchoolFormControl
Imports System.Data

Partial Class SchoolFormCampaigns
    Inherits System.Web.UI.Page
    Private _total As Double
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
        BindData()
    End Sub
    Private Sub BindData()
        dsSchoolCampaigns.DataBind()
        gvSchoolCampaigns.DataBind()
    End Sub

    Protected Sub gvBuyers_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSchoolCampaigns.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvSchoolCampaigns, e.Row, Me.Page)
        End Select
    End Sub

    Protected Sub gvSchoolCampaigns_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSchoolCampaigns.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                GridViewHelper.styleGridviewRows(e)
                Dim rowView As DataRowView = TryCast(e.Row.DataItem, DataRowView)

                Dim scid As String = rowView("SchoolCampaignID").ToString

                Dim lbls As Label = TryCast(e.Row.FindControl("lblSchoolCampaign"), Label)
                If Not IsNothing(lbls) Then
                    lbls.ToolTip = rowView("Description")
                End If

                Dim dlg As String = String.Format("return showDialog({0});", scid)
                e.Row.Cells(0).Attributes.Add("onclick", dlg)

                Dim imgSchoolCampaignActive As Image = e.Row.FindControl("imgSchoolCampaignActive")
                Dim imgUrl As String = "~/images/16-circle-green.png"
                If Not rowView("Status") Then
                    imgUrl = "~/images/16-circle-red.png"
                End If
                imgSchoolCampaignActive.ImageUrl = imgUrl


                Dim hl As LinkButton = TryCast(e.Row.FindControl("lbSubmitted"), LinkButton)
                If Not IsNothing(hl) Then
                    hl.ToolTip = "View submitted lead info"
                    hl.OnClientClick = String.Format("return ShowLeads('submitted',{0});", scid)
                End If

                hl = TryCast(e.Row.FindControl("lbLeads"), LinkButton)
                If Not IsNothing(hl) Then
                    hl.ToolTip = "View successful lead info"
                    hl.OnClientClick = String.Format("return ShowLeads('Delivered',{0});", scid)
                End If

                hl = TryCast(e.Row.FindControl("lbRejected"), LinkButton)
                If Not IsNothing(hl) Then
                    hl.ToolTip = "View rejected lead info"
                    hl.OnClientClick = String.Format("return ShowLeads('Rejected',{0});", scid)
                End If

                hl = TryCast(e.Row.FindControl("lbCredited"), LinkButton)
                If Not IsNothing(hl) Then
                    hl.ToolTip = "View credited lead info"
                    hl.OnClientClick = String.Format("return ShowLeads('Billed',{0});", scid)
                End If

                _total += CDbl(rowView("estcommission").ToString)

        End Select
    End Sub

    Protected Sub admin_SchoolCampaigns_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'imgEnforce.ToolTip = "Forces use of acceptance in area."
        'imgAcceptAll.ToolTip = "Restricts form submission based on zip code."
        If Not IsPostBack Then
            BindData()
            GetTotals()
        End If
        
    End Sub

    Private Sub GetTotals()
        lblTotal.Text = String.Format("MTD Est Commission Total : {0} ", FormatCurrency(_total, 2, TriState.True, TriState.False, TriState.True))
    End Sub
End Class
