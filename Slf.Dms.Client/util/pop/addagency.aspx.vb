Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data

Partial Class util_pop_addagency
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        ' insert company
        Dim AgencyID As Integer = AgencyHelper.Insert(txtName.Text, UserID)

        'flip the main panel off
        pnlMain.Visible = False
        pnlMessage.Visible = True

        ltrJScript.Text = "<script type=""text/javascript"">Record_Propagate(" _
            & AgencyID & ",""" & txtName.Text & """);window.close();</script>"

    End Sub
End Class