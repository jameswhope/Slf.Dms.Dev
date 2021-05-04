
Partial Class CustomTools_UserControls_Scanning_ScanningControl
    Inherits System.Web.UI.UserControl

    Public Property ObjectId() As String
        Get
            Return hdnScanObjectId.Value.Trim
        End Get
        Set(ByVal value As String)
            hdnScanObjectId.Value = value.Trim
        End Set
    End Property

    Public Property RelationId() As String
        Get
            Return hdnScanRelationId.Value.Trim
        End Get
        Set(ByVal value As String)
            hdnScanRelationId.Value = value.Trim
        End Set
    End Property

    Public Property SType() As String
        Get
            Return hdnScanType.Value.Trim
        End Get
        Set(ByVal value As String)
            hdnScanType.Value = value.Trim
        End Set
    End Property

    Public ReadOnly Property ScanUrl() As String
        Get
            Return String.Format("{0}?id={1}&type={2}&rel={3}", ResolveUrl("~/CustomTools/UserControls/scanning/scanningPop.ascx"), Me.ObjectId, Me.SType, Me.RelationId)
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            'Default values
            Me.ObjectId = Request.QueryString("id")
            Me.SType = "client"
            Me.RelationId = Me.ObjectId
        End If
    End Sub
End Class
