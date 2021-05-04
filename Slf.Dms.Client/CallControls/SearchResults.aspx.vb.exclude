Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers
Imports Slf.Dms.Records
Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.Data

Partial Class CallControls_SearchResults
    Inherits System.Web.UI.Page
#Region "Variables"
    Private UserID As Integer
#End Region

#Region "Page Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        pnlSearchClients.Visible = False
        pnlNoSearchClients.Visible = True
        UserID = Integer.Parse(Page.User.Identity.Name)
        Requery(Me.Request("Phone").ToString)
    End Sub
#End Region

#Region "Other Events"
    Protected Sub grvResults_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grvResults.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#DADAFA'; this.style.filter = 'alpha(opacity=75)';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")
                'e.Row.Attributes.Add("onclick", String.Format("CloseDialog('{0}');", CType(e.Row.DataItem, Slf.Dms.Records.ClientSearch).ClientID))
                e.Row.Attributes.Add("onclick", String.Format("SelectClient('{0}');", CType(e.Row.DataItem, Slf.Dms.Records.ClientSearch).ClientID))
        End Select
    End Sub

#End Region

#Region "Utilities"
    Public Sub Requery(ByVal PhoneNumber As String)
        If Not String.IsNullOrEmpty(PhoneNumber) Then
            Dim dtClients As DataTable = CallControlsHelper.GetClientSearches(PhoneNumber)
            Dim results As Integer = dtClients.Rows.Count
            UserHelper.StoreSearch(UserID, PhoneNumber, results, results, 0, 0, 0, 0, 0)
            RequeryClients(dtClients)
        End If
        hdnSearch.Value = PhoneNumber
    End Sub

    Private Sub RequeryClients(ByVal dtClients As DataTable)
        Dim ClientSearches As New List(Of ClientSearch)

        For Each dr As DataRow In dtClients.Rows
            ClientSearches.Add(New ClientSearch(dr("ClientId"), dr("ClientStatus").ToString, dr("Type").ToString, dr("Name").ToString, dr("Address").ToString, dr("ContactType").ToString, dr("ContactNumber").ToString, ResolveUrl("~/")))
        Next

        grvResults.DataSource = ClientSearches
        grvResults.DataBind()

        pnlSearchClients.Visible = ClientSearches.Count > 0
        pnlNoSearchClients.Visible = ClientSearches.Count = 0

    End Sub

    #End Region

    Protected Sub lnkClientSelected_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClientSelected.Click
        Dim ClientId As Integer = hdnClientID.Value
        Try
            Dim currentInteraction As ININ.IceLib.Interactions.Interaction = Session("CurrentInteraction")
            CallControlsHelper.InsertCallClient(currentInteraction.CallIdKey, ClientId)
        Catch ex As Exception

        End Try
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), "CloseDialogWnd", String.Format("CloseDialog('{0}');", ClientId), True)

    End Sub
End Class
