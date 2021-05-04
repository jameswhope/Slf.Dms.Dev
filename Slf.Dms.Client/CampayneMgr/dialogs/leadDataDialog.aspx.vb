Imports System.Data.SqlClient

Partial Class dialogs_leadDataDialog
    Inherits System.Web.UI.Page
    Private _leadType As String
    Private _SchoolCampaignID As Integer

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsNothing(Request.QueryString("t")) Then
            LeadType = Request.QueryString("t").ToString
        End If
        If Not IsNothing(Request.QueryString("scid")) Then
            SchoolCampaignID = Request.QueryString("scid").ToString
        End If


        If Not IsPostBack Then
            BindData()
        End If

    End Sub
    Private Sub BindData()
        dsData.SelectParameters("SchoolCampaignID").DefaultValue = SchoolCampaignID
        dsData.SelectParameters("ResultCode").DefaultValue = LeadType
        dsData.DataBind()

        gvData.DataBind()
    End Sub
    Public Property LeadType() As String
        Get
            Return _leadType
        End Get
        Set(ByVal value As String)
            _leadType = value
        End Set
    End Property
    Public Property SchoolCampaignID() As Integer
        Get
            Return _SchoolCampaignID
        End Get
        Set(ByVal value As Integer)
            _SchoolCampaignID = value
        End Set
    End Property
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
    Protected Sub dsData_Selected(sender As Object, e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsData.Selected

        divInfo.InnerHtml = String.Format("<h2>Number of Leads : {0}</h2></br>", e.AffectedRows, SchoolCampaignID)
    End Sub

    Protected Sub gvData_RowCreated(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvData.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvData, e.Row, Me.Page)
        End Select
    End Sub
End Class
