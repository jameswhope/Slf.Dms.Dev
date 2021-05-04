Imports Drg.Util.DataAccess

Imports System.Data.SqlClient

Partial Class negotiation_webparts_RecentSearches
    Inherits System.Web.UI.UserControl

#Region "Delegates"
    Public Event Search(ByVal terms As String, ByVal depth As String)
#End Region

#Region "Variables"
    Private UserID As Integer
    Private SearchLength As Integer
#End Region

#Region "Page Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        SearchLength = 5

        LoadSearches()
    End Sub
#End Region

#Region "Other Events"
    Protected Sub lnkSearchTerms_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearchTerms.Click
        RaiseEvent Search(hdnSearchTerms.Value, "system")
    End Sub
#End Region

#Region "Utilities"
    Public Sub LoadSearches()
        Using cmd As New SqlCommand("SELECT TOP " & SearchLength & " Terms, MAX(Search), MAX(UserSearchID) FROM tblUserSearch with(nolock) WHERE UserID = " & UserID & " group BY Terms ORDER BY MAX(Search) DESC, MAX(UserSearchID) DESC", ConnectionFactory.Create())
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