
Partial Class admin_checkscan_checksready
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            BindGrids()
        End If
    End Sub
    Private Sub BindGrids()
        dsReady.DataBind()


    End Sub

  
End Class
