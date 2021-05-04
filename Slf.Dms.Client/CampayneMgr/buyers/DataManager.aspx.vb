Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Net

Imports DataManagerHelper
Imports System.Web.Script.Serialization
Imports AdminHelper
Imports BuyerHelper

Partial Class admin_DataManager
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

    Protected Sub admin_DataManager_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ViewState("sortOrder") = "ASC"
        End If

        If Not IsNothing(Session("CurrentBuyerPageIdx")) Then
            gvBuyerContracts.PageIndex = Session("CurrentBuyerPageIdx")
        End If
        If Not IsNothing(Session("CurrentBuyerRowIdx")) Then
            gvBuyerContracts.SelectedIndex = Session("CurrentBuyerRowIdx")
        End If
      
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        gvBuyerContracts.DataBind()
    End Sub

    Protected Sub gvBuyerContracts_PageIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvBuyerContracts.PageIndexChanged
        Session("CurrentBuyerPageIdx") = gvBuyerContracts.PageIndex
    End Sub

    Protected Sub gvBuyerContracts_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvBuyerContracts.RowCommand
        Select Case e.CommandName.ToLower
            Case "select"
                Session("CurrentBuyerRowIdx") = e.CommandArgument
                Session("CurrentBuyerPageIdx") = gvBuyerContracts.PageIndex
        End Select
    End Sub

    Protected Sub gvBuyerContracts_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvBuyerContracts.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvBuyerContracts, e.Row, Me.Page)

        End Select
    End Sub

    
    Protected Sub gvBuyerContracts_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvBuyerContracts.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Cells(0).Style("cursor") = "hand"
                e.Row.Cells(1).Style("cursor") = "hand"

                Dim rowView As BuyerContractObject = TryCast(e.Row.DataItem, BuyerContractObject)
                Dim imgBuyer As Image = e.Row.FindControl("imgBuyerActive")
                Dim imgContract As Image = e.Row.FindControl("imgContractActive")

                Dim imgUrl As String = GetImgUrl(rowView.BuyerActive)
                imgBuyer.ImageUrl = imgUrl
                imgBuyer.ToolTip = String.Format("Buyer Active : {0}", rowView.BuyerActive)

                imgUrl = GetImgUrl(rowView.Active)
                imgContract.ImageUrl = imgUrl
                imgContract.ToolTip = String.Format("Contract Active : {0}", rowView.Active)

                Dim lnk As LinkButton = e.Row.FindControl("lnkShowContract")
                Dim showContract As New StringBuilder
                showContract.AppendFormat("return showContractDialog({0},'{1}');", rowView.BuyerOfferXrefID, rowView.ContractName)
                e.Row.Cells(2).Attributes.Add("onclick", showContract.ToString)

                Dim showBuyer As New StringBuilder
                Dim bo As BuyersObject = BuyerHelper.getBuyer(rowView.BuyerID)
                showBuyer = New StringBuilder
                showBuyer.AppendFormat("return showBuyerDialog({0},'{1}');", rowView.BuyerID, rowView.Buyer)
                e.Row.Cells(1).Attributes.Add("onclick", showBuyer.ToString)
                
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
                If e.Row.RowState = DataControlRowState.Alternate Then
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
                Else
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If
        End Select
    End Sub

    Protected Sub gvBuyerContracts_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvBuyerContracts.Sorting
        odsBuyerContracts.SelectParameters("sortField").DefaultValue = e.SortExpression
        If ViewState("sortOrder") = "ASC" Then
            odsBuyerContracts.SelectParameters("sortOrder").DefaultValue = "DESC"
            ViewState("sortOrder") = "DESC"
        Else
            odsBuyerContracts.SelectParameters("sortOrder").DefaultValue = "ASC"
            ViewState("sortOrder") = "ASC"
        End If

        e.Cancel = True
    End Sub

#End Region 'Methods

    Protected Sub btnFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnFilter.Click
        Select Case ddlActive.SelectedValue
            Case 1
                odsBuyerContracts.SelectParameters("contractactive").DefaultValue = "1"
            Case 0
                odsBuyerContracts.SelectParameters("contractactive").DefaultValue = "0"
            Case Else
                odsBuyerContracts.SelectParameters("contractactive").DefaultValue = "-1"
        End Select

        Select Case ddlCallCenter1.SelectedValue
            Case 1
                odsBuyerContracts.SelectParameters("showcallcenter").DefaultValue = "1"
            Case 0
                odsBuyerContracts.SelectParameters("showcallcenter").DefaultValue = "0"
            Case Else
                odsBuyerContracts.SelectParameters("showcallcenter").DefaultValue = "-1"
        End Select

        odsBuyerContracts.SelectParameters("verticalid").DefaultValue = ddlVertical1.SelectedValue

        odsBuyerContracts.DataBind()
        gvBuyerContracts.DataBind()

    End Sub
End Class