Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.Services

Partial Class portals_affiliate_download
    Inherits System.Web.UI.Page
    Private UserID As Integer
    Private AffiliateID As Integer
    #Region "Methods"

    Protected Sub portals_affiliate_download_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        UserID = Page.User.Identity.Name
        If Not IsPostBack Then
            dsSites.SelectParameters("userid").DefaultValue = UserID
            dsSites.DataBind()
        End If
    End Sub

    
    

    
    #End Region 'Methods

End Class