Imports System.Data

Partial Class admin_CakeSync
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Me.IsPostBack Then
            LoadCakeLogs()
        End If
    End Sub

    Private Sub CreateFakeTable(ByVal dt As DataTable)
        For Each col As DataColumn In dt.Columns
            col.AllowDBNull = True
        Next
        dt.Rows.Add(dt.NewRow())
    End Sub

    Private Sub LoadCakeLogs()
        Dim dt As DataTable = CakeHelper.GetCakeCampaignToSync()
        If dt.Rows.Count = 0 Then
            'We need to show the header and footer for empty datatable. Create table with dummy row and hide it. 
            CreateFakeTable(dt)
            Me.grdCakeCampaigns.DataSource = dt
            Me.grdCakeCampaigns.DataBind()
            grdCakeCampaigns.Rows(0).Visible = False
        Else
            Me.grdCakeCampaigns.DataSource = dt
            Me.grdCakeCampaigns.DataBind()
        End If
    End Sub

    Protected Sub grdCakeCampaigns_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles grdCakeCampaigns.PageIndexChanging
        Me.grdCakeCampaigns.PageIndex = e.NewPageIndex
        LoadCakeLogs()
    End Sub

    Protected Sub grdCakeCampaigns_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grdCakeCampaigns.RowCommand
        If e.CommandName = "Add" Then
            Dim row As GridViewRow = DirectCast(DirectCast(DirectCast(e.CommandSource, System.Object), System.Web.UI.WebControls.ImageButton).Parent, System.Web.UI.Control).Parent
            Dim ddlcampaign As DropDownList = CType(row.FindControl("ddlCampaign"), DropDownList)
            Dim ddlbuyer As DropDownList = CType(row.FindControl("ddlBuyer"), DropDownList)
            Dim ddloffer As DropDownList = CType(row.FindControl("ddlOffer"), DropDownList)
            Try
                'Validate CakeId and PostKey
                If Not ddlcampaign.SelectedValue > 0 Then Throw New Exception("Select an Affiliate.")
                If Not ddlbuyer.SelectedValue > 0 Then Throw New Exception("Select a Vendor.")
                If Not ddloffer.SelectedValue > 0 Then Throw New Exception("Select an Offer Type.")
                'Insert Cake Campaign
                InsertCakeCampaign(ddlcampaign.SelectedValue, ddlbuyer.SelectedValue, ddloffer.SelectedValue, row)
            Catch ex As Exception
                msgs.InnerHtml = GetHtmlFormattedError(ex.Message)
            End Try
        End If
    End Sub

    Protected Sub grdCakeCampaigns_SelectedIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSelectEventArgs) Handles grdCakeCampaigns.SelectedIndexChanging
        If e.NewSelectedIndex <> -1 Then
            Me.grdCakeCampaigns.SelectedIndex = e.NewSelectedIndex
            InsertCakeCampaign(Me.grdCakeCampaigns.SelectedDataKey("CampaignId"), Me.grdCakeCampaigns.SelectedDataKey("BuyerId"), Me.grdCakeCampaigns.SelectedDataKey("OfferId"), Me.grdCakeCampaigns.SelectedRow)
        End If
    End Sub

    Private Sub InsertCakeCampaign(ByVal CampaignId As Integer, ByVal BuyerId As Integer, ByVal OfferId As Integer, ByVal row As GridViewRow)
        Dim txtCakeId As TextBox = row.FindControl("txtCakeId")
        Dim txtPostKey As TextBox = row.FindControl("txtPostKey")
        Try
            'Validate CakeId and PostKey
            If txtCakeId.Text.Trim.Length = 0 Then Throw New Exception("Cake Id is required.")
            If Not Int32.TryParse(txtCakeId.Text, Nothing) Then Throw New Exception("Cake Id is invalid.")
            If txtPostKey.Text.Trim.Length = 0 Then Throw New Exception("Cake Post Key is required.")
            'Insert Record
            CakeHelper.InsertCakeCampaignSync(CampaignId, BuyerId, OfferId, txtCakeId.Text.Trim, txtPostKey.Text.Trim)
            Me.LoadCakeLogs()
            Me.grdCakeCampaigns.PageIndex = 0
            msgs.InnerHtml = "Item added successfully."
        Catch ex As Exception
            msgs.InnerHtml = GetHtmlFormattedError(ex.Message)
        End Try
    End Sub

    Private Function GetHtmlFormattedError(ByVal ErrorMsg As String) As String
        Return String.Format("<font color='red'>{0}</font>", ErrorMsg)
    End Function
End Class
