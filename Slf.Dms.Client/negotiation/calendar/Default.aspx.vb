Imports Drg.Util.DataHelpers

Partial Class negotiation_calendar_Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            'NegotiationHelper.CacheView()
        End If
    End Sub
End Class