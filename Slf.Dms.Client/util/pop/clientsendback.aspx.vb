Option Explicit On

Imports System.Drawing
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Partial Class util_pop_clientsendback
    Inherits System.Web.UI.Page

    Private UserID As Integer
    Private DataClientID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Title = Request.QueryString("t")
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)
        DataClientID = DataHelper.Nz_int(Request.QueryString("clientid"))
    End Sub

    Protected Sub lnkAction_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAction.Click
        If txtComment.Text.Length = 0 Then
            txtComment.BorderColor = Color.Red
            txtComment.BorderStyle = BorderStyle.Solid
            txtComment.BorderWidth = 2
        Else
            Dim pRoadmapID = DataHelper.Nz_int(DataHelper.FieldLookup("tblRoadmap", "RoadmapID", "ClientID=" & DataClientID & " and clientstatusid=21"))
            RoadmapHelper.InsertRoadmap(DataClientID, 24, pRoadmapID, txtComment.Text, UserID)
            NoteHelper.InsertNote(txtComment.Text, UserID, DataClientID)
            Page.ClientScript.RegisterStartupScript(Me.GetType, "exit", "window.parent.location=""" & ResolveUrl("~") & """;window.close();", True)
        End If
        
    End Sub
End Class