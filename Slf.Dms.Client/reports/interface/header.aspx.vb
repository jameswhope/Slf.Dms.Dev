Option Explicit On

Imports Drg.Util.DataAccess

Partial Class reports_interface_header
    Inherits System.Web.UI.Page

    Private report As String
    Private format As String
    Private download As Boolean = False

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        report = Session("report")
        format = Session("format")
        download = Session("download")

        If Not IsPostBack Then
            SetStyle(format)
            ShowReport()
        End If

    End Sub
    
    Private Sub ShowReport()

        Dim str As String = String.Empty

        If report.Length > 0 Then

            str = ResolveUrl("~/reports/engine/container.ashx") & "?rpt=" & report _
                & "&f=" & format & "&d=" & download

        End If

        Response.Write("<SCRIPT>top.Reload('" & str & "'," & IIf(format.ToLower = "pdf", "true", "false") & ");</SCRIPT>")

    End Sub
    Private Sub lnkSaveAs_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lnkSaveAs.Click

        Session("download") = True
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub

    Protected Sub lnkSwitchFormat_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSwitchFormat.Click
        Session("format") = txtFormat.Value
        format = Session("format")
        Session("download") = False
        SetStyle(format)
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub
    Private Sub SetStyle(ByVal format As String)
        aPDF.Attributes("class") = "menuButton"
        aRTF.Attributes("class") = "menuButton"
        aHTML.Attributes("class") = "menuButton"
        aText.Attributes("class") = "menuButton"
        Select Case format
            Case "pdf"
                aPDF.Attributes("class") = "menuButtonSel"
            Case "rtf"
                aRTF.Attributes("class") = "menuButtonSel"
            Case "html"
                aHTML.Attributes("class") = "menuButtonSel"
            Case "txt"
                aText.Attributes("class") = "menuButtonSel"
        End Select
    End Sub
End Class