Imports System.Data
Imports System.Data.SqlClient

Partial Class admin_AdManager
    Inherits System.Web.UI.Page

    #Region "Properties"

    Public Property Userid() As Integer
        Get
            Return ViewState("_userid")
        End Get
        Set(ByVal value As Integer)
            ViewState("_userid") = value
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
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        gvAds.DataBind()
        gvOffers.DataBind()
    End Sub

    Protected Sub gvAds_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvAds.RowCommand
        Select Case e.CommandName.ToLower
            Case "select".ToLower
                btnCreateOffer.Style("display") = "block"
                btnCreateOffer.OnClientClick = String.Format("return showOffer({0},'a','0','','','','','');", e.CommandArgument)

                Dim lnkDiv As String = String.Format("<b>Ad ID# {0} Info:</b><br/>", e.CommandArgument)
                lnkDiv += String.Format("URL : http://idtrkr.com/r/?a={0}<br/>", e.CommandArgument)
                lnkDiv += String.Format("<a style=""color:blue;text-decoration:underline;"" href=""http://idtrkr.com/r/?a={0}"" target=""_blank"">Click to Test</a>", e.CommandArgument)
                divSampleLink.InnerHtml = lnkDiv
                divSampleLink.Style("display") = "block"
        End Select
    End Sub

    Protected Sub gvAds_RowCreated(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAds.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvAds, e.Row, Me.Page)

        End Select
    End Sub

    Protected Sub gvAds_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAds.RowDataBound
        Select Case e.Row.RowType

            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                Dim adid As String = rowView("adid").ToString
                Dim lnkAdd As LinkButton = e.Row.FindControl("lnkEditAd")
                lnkAdd.OnClientClick = String.Format("return showAd({0},'e','{1}','{2}','{3}');", adid, rowView("addescription").ToString, rowView("adtypeID").ToString, rowView("active").ToString)

                Dim img As Image = e.Row.FindControl("imgAdActive")
                Dim imgUrl As String = "~/images/16-circle-green.png"
                If Not rowView("Active") = True Then
                    imgUrl = "~/images/16-circle-red.png"
                End If
                img.ImageUrl = imgUrl

        End Select
    End Sub

    Protected Sub gv_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvOffers.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                Dim lnk As LinkButton = e.Row.FindControl("lnkEditOffer")
                lnk.Attributes("onclick") = String.Format("showOffer({0},'e','{1}','{2}','{3}','{4}','{5}');", rowView("adid").ToString, rowView("adofferid").ToString, rowView("OfferDescription").ToString, rowView("OfferRedirectUrl").ToString, rowView("Weight").ToString, rowView("active").ToString)

                Dim img As Image = e.Row.FindControl("imgOfferActive")
                Dim imgUrl As String = "~/images/16-circle-green.png"
                If Not rowView("Active") = True Then
                    imgUrl = "~/images/16-circle-red.png"
                End If
                img.ImageUrl = imgUrl

        End Select
    End Sub

    #End Region 'Methods

End Class