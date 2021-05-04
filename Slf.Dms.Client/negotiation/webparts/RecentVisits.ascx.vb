Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data.SqlClient

Partial Class negotiation_webparts_RecentVisits
    Inherits System.Web.UI.UserControl

#Region "Variables"
    Private UserID As Integer

    Private SearchLength As Integer
#End Region

#Region "Page Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        SearchLength = 5

        LoadVisits()
    End Sub
#End Region

#Region "Other Events"
    Protected Sub lnkRecentVisit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRecentVisit.Click
        'NegotiationHelper.RegisterClientVisit(hdnRecentVisit.Value, UserID)

        Response.Redirect("~/clients/client/?id=" & hdnRecentVisit.Value)
    End Sub
#End Region

#Region "Utilities"
    Private Sub LoadVisits()
        Using cmd As New SqlCommand("SELECT DISTINCT TOP " & SearchLength & " ucv.ClientID, p.FirstName + ' ' + p.LastName as [Name], MAX(ucv.VisitedOn) FROM tblUserClientVisit as ucv inner join tblClient as c on c.ClientID = ucv.ClientID inner join tblPerson as p on p.PersonID = c.PrimaryPersonID WHERE ucv.UserID = " & UserID & " GROUP BY ucv.ClientID, p.FirstName, p.LastName ORDER BY MAX(ucv.VisitedOn) DESC", ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    rptSearches.DataSource = reader
                    rptSearches.DataBind()
                End Using
            End Using
        End Using

        rptSearches.Visible = rptSearches.Items.Count > 0
        trNoSearches.Visible = rptSearches.Items.Count = 0
    End Sub
#End Region

End Class