Imports System.Data
Imports System.Data.SqlClient

Imports DataManagerHelper
Imports System.Web.Script.Serialization
Imports AdminHelper
Imports BuyerHelper

Partial Class admin_BuyerManager
    Inherits System.Web.UI.Page

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
        gvBuyers.DataBind()
    End Sub

    Protected Sub gvBuyers_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvBuyers.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvBuyers, e.Row, Me.Page)

        End Select
    End Sub

    Protected Sub gvBuyers_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvBuyers.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                Dim rowView As BuyersObject = TryCast(e.Row.DataItem, BuyersObject)

                Dim lnk As LinkButton = e.Row.FindControl("lnkEdit")
                lnk.OnClientClick = String.Format("return showBuyerDialog({0},'{1}');", rowView.BuyerID, rowView.Buyer)
                e.Row.Attributes.Add("onclick", String.Format("return showBuyerDialog({0},'{1}');", rowView.BuyerID, rowView.Buyer))

                Dim imgBuyer As Image = e.Row.FindControl("imgBuyerActive")
                Dim imgUrl As String = "~/images/16-circle-green.png"

                If Not rowView.Active Then
                    imgUrl = "~/images/16-circle-red.png"
                End If
                imgBuyer.ImageUrl = imgUrl

                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
                If e.Row.RowState = DataControlRowState.Alternate Then
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
                Else
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If
        End Select
    End Sub

    Protected Sub gvBuyers_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvBuyers.Sorting
        odsBuyers.SelectParameters("sortField").DefaultValue = e.SortExpression
        If ViewState("sortOrder") = "ASC" Then
            odsBuyers.SelectParameters("sortOrder").DefaultValue = "DESC"
            ViewState("sortOrder") = "DESC"
        Else
            odsBuyers.SelectParameters("sortOrder").DefaultValue = "ASC"
            ViewState("sortOrder") = "ASC"
        End If

        e.Cancel = True
    End Sub

#End Region 'Methods

End Class