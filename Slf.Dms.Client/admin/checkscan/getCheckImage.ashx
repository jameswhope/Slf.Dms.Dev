<%@ WebHandler Language="VB" Class="getCheckImage" %>

Imports System
Imports System.Web

Public Class getCheckImage : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim fileName As String = ""
        If Not IsNothing(context.Request.QueryString("fid")) Then
            fileName = context.Request.QueryString("fid")
        Else
            Throw New ArgumentException("No File Specified")
        End If
        'fileName = fileName.Replace("lex-dev-30", "192.168.0.30")
        Try
            using img As System.Drawing.Image = System.Drawing.Image.FromFile(fileName)
                context.Response.ContentType = "image/jpg"
                using tImg As System.Drawing.Image = img.GetThumbnailImage(500,200,Nothing,Nothing)
                    tImg.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg)
                End Using
            End Using
        Catch fnx As IO.FileNotFoundException
        
        
        End Try
        

        
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class