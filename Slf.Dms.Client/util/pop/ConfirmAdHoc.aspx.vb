Option Explicit On

Partial Class util_pop_confirmadhoc
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Title = Request.QueryString("t")
        lblMessage.Text = Request.QueryString("m")
        Dim ClientId As Integer = Request.QueryString("id")
        Dim DepositDate As String = Request.QueryString("d")
        Dim AdhocAchId As Integer = Request.QueryString("aid")
        If MultiDepositHelper.GetOtherAdhocsInRange(ClientId, AdhocAchId, DepositDate, 3) Then
            lblMessage.Text = lblMessage.Text & "<br/><br/>" & "WARNING: There are other additionals set up near " & DepositDate & "."
        End If
        lnkAction.InnerHtml = Request.QueryString("t") & "<img style=""margin-left:6px;"" src=""" & ResolveUrl("~/images/16x16_forward.png") & """ border=""0"" align=""absmiddle"" />"
        lnkAction.Attributes("onclick") = "window.parent.dialogArguments." & Request.QueryString("f") & "();window.close();return false;"
    End Sub
End Class