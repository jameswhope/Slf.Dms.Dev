Imports System.Data
Imports System.Web.Services

Partial Class admin_websites
    Inherits System.Web.UI.Page
    
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

    Private Sub BindData()
        dsWebsites.DataBind()
        gvWebsites.DataBind()
    End Sub

    Protected Sub btnRefresh_Click(sender As Object, e As System.EventArgs) Handles btnRefresh.Click
        BindData()
    End Sub

    Protected Sub admin_websites_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindData()
        End If
    End Sub

    Protected Sub gvWebsites_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvWebsites.PreRender
        Dim pg As GridViewRow = gvWebsites.BottomPagerRow
        If Not IsNothing(pg) Then
            pg.Visible = True
        End If

    End Sub

    Protected Sub gvWebsites_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvWebsites.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvWebsites, e.Row, Me.Page)

        End Select
    End Sub

    Protected Sub gvWebsites_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvWebsites.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowview As DataRowView = TryCast(e.Row.DataItem, DataRowView)

                Dim lnk As LinkButton = TryCast(e.Row.FindControl("lnkSelect"), LinkButton)
                If Not IsNothing(lnk) Then
                    lnk.OnClientClick = String.Format("return showDialog({0});", rowview("websiteid").ToString)
                End If

                Dim lbl As Label = TryCast(e.Row.FindControl("lblSurvey"), Label)
                If Not IsNothing(lbl) Then
                    If Not rowview("defaultsurveyid").ToString = -1 Then
                        lbl.Text = String.Format("({0})", rowview("defaultsurveyid").ToString)
                    End If
                    lbl.Text += String.Format("{0}", rowview("surveyname").ToString)
                End If

                Dim hl As HyperLink = TryCast(e.Row.FindControl("hlSup"), HyperLink)
                If CInt(rowview("supcnt")) > 0 Then
                    hl.NavigateUrl = "sup/" & rowview("name").ToString.Replace(".", "_").Replace(" ", "") & "_sup.csv"
                    hl.Text = FormatNumber(rowview("supcnt"), 0)
                Else
                    hl.Text = ""
                End If

                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#CCFFFF';")
                If e.Row.RowState = DataControlRowState.Alternate Then
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#f9f9f9';")
                Else
                    e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
                End If
        End Select
    End Sub
End Class
