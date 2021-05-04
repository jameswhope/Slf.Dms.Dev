Imports Drg.Util.DataAccess
Imports Drg.Util.Helpers

Imports Slf.Dms.Records

Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class negotiation_webparts_ClientSearchControl
    Inherits System.Web.UI.UserControl

#Region "Delegates"
    Public Event Search(ByVal terms As String, ByVal depth As String)
    Public Event RecentSearches()
#End Region

#Region "Page Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.Form.DefaultButton = Me.FindControl("lnkGo").UniqueID
    End Sub
#End Region

#Region "Other Events"
    Protected Sub lnkGo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkGo.Click
        RaiseEvent Search(txtSearch.Text, radSearchDepth.SelectedValue)
        RaiseEvent RecentSearches()
    End Sub
#End Region

#Region "Utilities"
    Public Sub SearchClients(ByVal terms As String, ByVal depth As String)
        txtSearch.Text = terms
        radSearchDepth.SelectedValue = depth

        RaiseEvent Search(terms, depth)
        RaiseEvent RecentSearches()
    End Sub
#End Region

End Class