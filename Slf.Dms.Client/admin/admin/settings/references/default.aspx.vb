Option Explicit On

Imports Slf.Dms.Controls

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Data
Imports System.Collections.Generic

Partial Class admin_settings_references_default
    Inherits System.Web.UI.Page

#Region "Variables"

    Private UserID As Integer

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        SetRollups()

        trInfoBox.Visible = DataHelper.FieldCount("tblUserInfoBox", "UserInfoBoxID", _
            "UserID = " & UserID & " AND InfoBoxID = " & 1) = 0

    End Sub
    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = CType(Master, admin_settings_settings).CommonTasks

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""window.print();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_print.png") & """ align=""absmiddle""/>Print these references</a>")

    End Sub
    Protected Sub lnkCloseInformation_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCloseInformation.Click

        'insert flag record
        UserInfoBoxHelper.Insert(1, UserID)

        'reload
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub
End Class