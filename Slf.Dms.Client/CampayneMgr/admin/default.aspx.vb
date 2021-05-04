Imports System.Xml
Imports mshtml
Imports System.Data

Partial Class admin_default
    Inherits System.Web.UI.Page
    
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then

        End If
    End Sub

    Protected Sub gvOffers_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvOffers.RowCreated
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.CssClass = "normal"
        End If
    End Sub

    Protected Sub btnSaveOffers_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSaveOffers.Click
        Dim offerID As Integer
        Dim chkActive, chkData As CheckBox

        For Each row As GridViewRow In gvOffers.Rows
            offerID = CInt(gvOffers.DataKeys(row.RowIndex).Value)
            chkActive = CType(row.FindControl("chkActive"), CheckBox)
            chkData = CType(row.FindControl("chkData"), CheckBox)
            LeadHelper.SaveOffer(offerID, chkActive.Checked, chkData.Checked, CInt(Page.User.Identity.Name))
        Next

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "err_msg", "$().toastmessage('showSuccessToast', ""Changes saved."");", True)
    End Sub

End Class
