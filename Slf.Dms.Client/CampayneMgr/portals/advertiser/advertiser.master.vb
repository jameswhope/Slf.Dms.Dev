
Partial Class portals_advertiser_advertiser
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

    Protected Sub portals_affiliate_affiliate_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Userid = Page.User.Identity.Name

        Using cu As UserHelper.UserObj = UserHelper.GetUserObject(Userid)
            Dim uname As String = cu.FirstName
            If String.IsNullOrEmpty(UserTypeId) Then
                UserTypeId = cu.UserTypeId
            End If
            DisplayMenu(UserTypeId)
            PortalHelper.BuildUserNameBlock(cu)
        End Using
    End Sub

    Private Sub DisplayMenu(roleid As Integer)
        Select Case roleid
            Case 7
            Case Else
                Response.Redirect(ResolveUrl("~/default.aspx"))
        End Select
    End Sub

#End Region 'Methods
End Class

