Option Explicit On

Imports System
Imports System.Drawing

Partial Class util_pop_colorpicker
    Inherits System.Web.UI.Page

    Protected ImageSrc As String = "~/images/pallete.png"
    Protected strSetupScript As String
    Protected Width As Integer
    Protected Height As Integer
    Protected Factor As Integer
    Private Const TargetSize As Integer = 150

    Public actionCode As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.QueryString("v") Is Nothing Then
            actionCode = ""
        Else
            actionCode = "window.top.dialogArguments." & Request.QueryString("v") & " = div.style.backgroundColor;"
        End If

        Dim FileName As String = Server.MapPath(ImageSrc)
        Using bmp As Bitmap = New Bitmap(FileName)

            Width = bmp.Width
            Height = bmp.Height
            Factor = TargetSize / Width

            Dim sb As New StringBuilder
            sb.AppendLine("c=new Array(")
            For x As Integer = 0 To bmp.Width - 1
                If x > 0 Then sb.AppendLine(",")
                sb.Append("new Array(")
                For y As Integer = 0 To bmp.Height - 1
                    Dim c As Color = bmp.GetPixel(x, y)
                    If y > 0 Then sb.Append(",")
                    sb.Append("""" & ColorTranslator.ToHtml(c) & """")
                Next
                sb.Append(")")
            Next
            sb.Append(");")
            strSetupScript = sb.ToString
        End Using

        'GeneratePallete("c:\pallete.png")
    End Sub

    Private Sub GeneratePallete(ByVal FileName As String)
        Using bmp As Bitmap = New Bitmap(22, 66)

            For h As Single = 0 To 359 Step 18
                For b As Single = 0 To 10 Step 1
                    For s As Single = 1 To 5
                        Dim c As Color = LocalHelper.ColorFromAhsb(255, h, s / 5, b / 10)
                        Dim x As Single = h / 18
                        Dim y As Single = (s * 11) + b
                        bmp.SetPixel(x, y, c)
                    Next
                Next
            Next
            For y As Single = 0 To 44
                Dim c As Color = LocalHelper.ColorFromAhsb(255, 0, 0, y / 44)
                bmp.SetPixel(21, y, c)
            Next

            bmp.Save(FileName, Imaging.ImageFormat.Png)

        End Using
    End Sub
End Class