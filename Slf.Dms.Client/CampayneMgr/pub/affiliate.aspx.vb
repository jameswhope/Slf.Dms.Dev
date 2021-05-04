Imports System.Data
Imports System.Data.SqlClient

Imports AdminHelper

Partial Class admin_affiliate
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

    Protected Sub admin_affiliate_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Userid = CInt(Page.User.Identity.Name)
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        gvAffiliates.DataBind()
    End Sub

    Protected Sub gvAffiliates_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvAffiliates.PreRender
        Dim pg As GridViewRow = gvAffiliates.BottomPagerRow
        If Not IsNothing(pg) Then
            pg.Visible = True
        End If

    End Sub
    Protected Sub gvAffiliates_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvAffiliates.Sorting
        odsAffiliates.SelectParameters("sortField").DefaultValue = e.SortExpression
        If ViewState("sortOrder") = "ASC" Then
            odsAffiliates.SelectParameters("sortOrder").DefaultValue = "DESC"
            ViewState("sortOrder") = "DESC"
        Else
            odsAffiliates.SelectParameters("sortOrder").DefaultValue = "ASC"
            ViewState("sortOrder") = "ASC"
        End If

        e.Cancel = True
    End Sub
    Protected Sub gvAffiliates_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAffiliates.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvAffiliates, e.Row, Me.Page)

        End Select
    End Sub

    Protected Sub gvAffiliates_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAffiliates.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                Dim rowView As AffiliateObject = TryCast(e.Row.DataItem, AffiliateObject)

                Dim img As Image = e.Row.FindControl("imgActive")
                Dim imgUrl As String = "~/images/16-circle-green.png"
                If Not rowView.Active Then
                    imgUrl = "~/images/16-circle-red.png"
                End If
                img.ImageUrl = imgUrl

                'Dim dvl As HtmlGenericControl = e.Row.FindControl("divLastModified")
                Dim lmText As String = String.Format("Last modified on {0} By {1}.", rowView.LastModified, rowView.LastModifiedBy)
                'dvl.InnerHtml = lmText

                Dim showOffer As New StringBuilder
                showOffer.Append("return ShowAffiliate(")
                showOffer.AppendFormat("{0},'{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}');", rowView.AffiliateID, _
                                       rowView.Name, rowView.AccountManagerID, rowView.Website, _
                                       rowView.BillingCycle, rowView.Street, rowView.City, rowView.State, rowView.Zip, _
                                       rowView.Country, rowView.Notes, rowView.Active, lmText)
                Dim lnk As LinkButton = e.Row.FindControl("lnkEdit")
                lnk.OnClientClick = showOffer.ToString
                e.Row.Attributes.Add("onclick", showOffer.ToString)

                'If Not String.IsNullOrEmpty(rowView.Street) Then
                '    Dim dv As HtmlGenericControl = e.Row.FindControl("divAddress")
                '    Dim addText As String = String.Format("{0}<br/>", rowView.Street)
                '    addText += String.Format("{0}, {1}  {2} {3}", rowView.City, rowView.State, rowView.Zip, rowView.Country)
                '    dv.InnerHtml = addText
                'End If

                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
                If e.Row.RowState = DataControlRowState.Alternate Then
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
                Else
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If
        End Select
    End Sub

    #End Region 'Methods

End Class