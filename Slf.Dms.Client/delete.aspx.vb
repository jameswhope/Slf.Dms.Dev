Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data

Partial Class delete
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Title = "Delete " & Request.QueryString("t")
        lblMessage.Text = "Are you sure you want to delete this " & Request.QueryString("p") & "?"
        lnkDelete.InnerHtml = "Delete " & Request.QueryString("t") & "<img style=""margin-left:6px;"" src=""" & ResolveUrl("~/images/16x16_forward.png") & """ border=""0"" align=""absmiddle"" />"

    End Sub
End Class