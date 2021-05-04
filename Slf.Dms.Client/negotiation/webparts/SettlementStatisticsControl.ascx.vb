Imports Drg.Util.DataAccess
Imports System.Data
Partial Class negotiation_webparts_SettlementStatisticsControl
    Inherits System.Web.UI.UserControl
    Public UserID As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        If Session("UserID") Is Nothing Then
            Session("UserID") = UserID
        End If
    End Sub

    Protected Sub gvGroup_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvGroup.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                'change offer direction image
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim img As Image = e.Row.FindControl("imgDir")
                Select Case rowView("offerdirection").ToString.ToLower
                    Case "made"
                        img.ImageUrl = "~/negotiation/images/offerout.png"
                    Case "received"
                        img.ImageUrl = "~/negotiation/images/offerin.png"
                End Select
        End Select

    End Sub

    Protected Sub gvIndivid_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvIndivid.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                'change offer direction image
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim img As Image = e.Row.FindControl("imgDir")
                Select Case rowView("offerdirection").ToString.ToLower
                    Case "made"
                        img.ImageUrl = "~/negotiation/images/offerout.png"
                    Case "received"
                        img.ImageUrl = "~/negotiation/images/offerin.png"
                End Select
        End Select

    End Sub
End Class
