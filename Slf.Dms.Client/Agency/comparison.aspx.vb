Imports System.Drawing
Imports Drg.Util.DataAccess
Imports Infragistics.UltraChart.Resources.Appearance
Imports Infragistics.UltraChart.Shared.Styles

Partial Class Agency_dailycomparison
    Inherits System.Web.UI.Page

    Private UserID As Integer

    Protected Sub Agency_dailycomparison_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsNumeric(Request.QueryString("id")) Then
            UserID = CInt(Request.QueryString("id"))
        Else
            UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        End If

        If Not IsPostBack Then
            LoadTimeFrames()
        End If

        Dim days As String() = ddlFrame.SelectedValue.Split(New Char() {"-"}, StringSplitOptions.RemoveEmptyEntries)
        LoadChart(days(0), days(1))
    End Sub

    Private Sub LoadTimeFrames()
        ddlFrame.Items.Add(New ListItem("1st --> 15th", "1-15", True))
        ddlFrame.Items.Add(New ListItem("16th --> EOM", "16-END"))
        ddlFrame.Items.Add(New ListItem("1st Week in Month", "1-7"))
        ddlFrame.Items.Add(New ListItem("2nd Week in Month", "8-14"))
        ddlFrame.Items.Add(New ListItem("3rd Week in Month", "15-21"))
        ddlFrame.Items.Add(New ListItem("4th Week in Month", "22-28"))
        ddlFrame.Items.Add(New ListItem("5th Week in Month", "29-END"))

    End Sub

    Private Sub LoadChart(ByVal startday As String, ByVal endDay As String)
        ds_InitialDraftsCompare.SelectParameters("UserID").DefaultValue = UserID
        ds_InitialDraftsCompare.SelectParameters.Item("startday").DefaultValue = startday
        ds_InitialDraftsCompare.SelectParameters.Item("endday").DefaultValue = endDay
        ds_InitialDraftsCompare.DataBind()

        ds_NonInitialDraftsCompare.SelectParameters("UserID").DefaultValue = UserID
        ds_NonInitialDraftsCompare.SelectParameters.Item("startday").DefaultValue = startday
        ds_NonInitialDraftsCompare.SelectParameters.Item("endday").DefaultValue = endDay
        ds_NonInitialDraftsCompare.DataBind()

        UltraChart1.Axis.X.Labels.Visible = False
        UltraChart2.Axis.X.Labels.Visible = False


    End Sub

    Protected Sub ddlFrame_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlFrame.SelectedIndexChanged
        Dim days As String() = ddlFrame.SelectedValue.Split(New Char() {"-"}, StringSplitOptions.RemoveEmptyEntries)

        LoadChart(days(0), days(1))
    End Sub
End Class

