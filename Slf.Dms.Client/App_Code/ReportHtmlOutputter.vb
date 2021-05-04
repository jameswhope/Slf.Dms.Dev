Option Explicit On

Imports System.IO

Imports GrapeCity.ActiveReports.Export.Html

Public Class ReportHtmlOutputter
    Implements IOutputHtml

    Private context As System.Web.HttpContext = Nothing

    Public Sub New(ByVal context As System.Web.HttpContext)

        If context Is Nothing Then
            Throw New ArgumentException("context")
        End If

        Me.context = context

    End Sub
    Public Function OutputHtmlData(ByVal info As HtmlOutputInfoArgs) As String Implements IOutputHtml.OutputHtmlData
        Dim temp As String = ""
        Select Case (info.OutputKind)
            Case HtmlOutputKind.BookmarksHtml
                'temp = Me.GenUniqueFileNameWithExtension(".html")

                'Dim fs As FileStream = File.Create(temp)
                'Me.WriteStreamToStream(info.OutputStream, fs)
                'fs.Close()

                'Return temp

            Case HtmlOutputKind.FramesetHtml
                'temp = Me.GenUniqueFileNameWithExtension(".html")

                'Dim fs As FileStream = File.Create(temp)
                'Me.WriteStreamToStream(info.OutputStream, fs)
                'fs.Close()

                'Return temp

            Case HtmlOutputKind.HtmlPage

                ' We want to hold on to the name of the main page so we can redirect the browser to it:
                'Me.mainPage = Me.GenUniqueFileNameWithExtension(".html")

                'context.Response.WriteBytes(info.OutputStream.
                'Dim fs As FileStream = File.Create(Me.mainPage)
                Me.WriteStreamToStream(info.OutputStream, context.Response.OutputStream)
                'fs.Close()
                'Return Me.mainPage
            Case HtmlOutputKind.ImageJpg

                ' should be a file with a .jpg extension:

                'temp = Me.GenUniqueFileNameWithExtension(".jpg")

                'Dim fs As FileStream = File.Create(temp)
                'Me.WriteStreamToStream(info.OutputStream, fs)
                'fs.Close()
                'Return temp

            Case HtmlOutputKind.ImagePng

                ' should be a file witha .png extension
                temp = Web.HttpContext.Current.Server.MapPath("~/research/temp/" & Guid.NewGuid.ToString & ".png")

                Dim fs As FileStream = File.Create(temp)

                Me.WriteStreamToStream(info.OutputStream, fs)

                fs.Close()
                Return temp

            Case Else

                ' This case shouldn't really happen, but we'll default to html just in case some special type is added in the future
                'temp = Me.GenUniqueFileNameWithExtension(".html")

                'Dim fs As FileStream = File.Create(temp)
                'Me.WriteStreamToStream(info.OutputStream, fs)
                'fs.Close()

                'Return temp

        End Select
        Return String.Empty
    End Function

    Public Sub Finish() Implements GrapeCity.ActiveReports.Export.Html.IOutputHtml.Finish

    End Sub

    Private Sub WriteStreamToStream(ByVal sourceStream As Stream, ByVal targetStream As Stream)
        ' Whats the size of the source stream:
        Dim size As Integer = CType(sourceStream.Length, Integer)

        ' Create a buffer that same size:
        Dim buffer(size) As Byte

        ' Move the source stream to the begining:
        sourceStream.Seek(0, SeekOrigin.Begin)

        ' copy the whole sourceStream in to our buffer:
        sourceStream.Read(buffer, 0, size)

        ' Write out buffer to the target stream:
        targetStream.Write(buffer, 0, size)
    End Sub

End Class