<%@ WebHandler Language="VB" Class="ViewTiffHandler" %>

Imports System
Imports System.Web

Public Class ViewTiffHandler : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim path As String = HttpContext.Current.Request.QueryString("f").ToString
        Dim img As Drawing.Image = Drawing.Image.FromFile(path)
        img.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Gif)
        context.Response.ContentType = "image/gif"

    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class