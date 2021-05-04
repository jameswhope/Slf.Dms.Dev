Option Explicit On

Imports Drg.Util.DataAccess

Imports System.Data.SqlClient

Partial Class util_pop_void
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Title = "Void " & Request.QueryString("t")
        lblMessage.Text = "Are you sure you want to void this " & Request.QueryString("p") & "?"
        lnkVoid.InnerHtml = "Void " & Request.QueryString("t") & "<img style=""margin-left:6px;"" src=""" & ResolveUrl("~/images/16x16_forward.png") & """ border=""0"" align=""absmiddle"" />"

        'LoadReasons()
    End Sub
End Class