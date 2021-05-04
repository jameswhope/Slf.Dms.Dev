Imports System.Data
Imports System.Data.SqlClient

Partial Class CustomTools_UserControls_RecentDialerCalls
    Inherits System.Web.UI.UserControl

#Region "Variables"
    Private UserID As Integer

#End Region

#Region "Page Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)
        LoadCalls()
    End Sub
#End Region

#Region "Other Events"
    Protected Sub lnkRecentCall_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRecentCall.Click
        Response.Redirect("~/DialerCall.aspx" & hdnRecentCall.Value)
    End Sub
#End Region

#Region "Utilities"
    Private Sub LoadCalls()
        Dim dt As DataTable = DialerHelper.GetLastCalls(UserID)
        rptCalls.DataSource = dt
        rptCalls.DataBind()
        rptCalls.Visible = rptCalls.Items.Count > 0
        trNoCalls.Visible = rptCalls.Items.Count = 0
    End Sub
#End Region

End Class