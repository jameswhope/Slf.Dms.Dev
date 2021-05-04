Partial Class portals_portal
    Inherits System.Web.UI.MasterPage

    #Region "Fields"

    Private Userid As Integer
    Private _UserTypeId As Integer

    #End Region 'Fields

    #Region "Properties"

    Public Property UserTypeId() As String
        Get
            Return hdnUserTypeID.Value
        End Get
        Set(ByVal value As String)
            hdnUserTypeID.Value = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Protected Sub lnkLogout_Click(sender As Object, e As System.EventArgs) Handles lnkLogout.Click
        Session.Clear()
        Session.Abandon()
        FormsAuthentication.SignOut()
        Response.Redirect(ResolveUrl("~/login.aspx"))
    End Sub

    Protected Sub portals_portal_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Userid = Page.User.Identity.Name

        Using cu As UserHelper.UserObj = UserHelper.GetUserObject(Userid)
            Dim uname As String = cu.FirstName
            If String.IsNullOrEmpty(UserTypeId) Then
                UserTypeId = cu.UserTypeId
            End If
            DisplayMenu(UserTypeId)
            divWelcome.InnerHtml = PortalHelper.BuildUserNameBlock(cu)
        End Using
    End Sub

    Private Sub DisplayMenu(roleid As Integer)
        Select Case roleid
            Case 5
                'menuAffiliate.Style("display") = "block"
                'menuBuyer.Style("display") = "none"
                'menuAdvertiser.Style("display") = "none"
            Case 6
                'menuAffiliate.Style("display") = "none"
                'menuBuyer.Style("display") = "block"
                'menuAdvertiser.Style("display") = "none"
            Case 7
                'menuAffiliate.Style("display") = "none"
                'menuBuyer.Style("display") = "none"
                'menuAdvertiser.Style("display") = "block"
            Case 1
                'mnuAdmin.Style("display") = "block"
                'menuAffiliate.Style("display") = "none"
                'menuBuyer.Style("display") = "none"
                'menuAdvertiser.Style("display") = "none"
            Case Else
                Response.Redirect(ResolveUrl("~/default.aspx"))
        End Select

    End Sub

    #End Region 'Methods

End Class