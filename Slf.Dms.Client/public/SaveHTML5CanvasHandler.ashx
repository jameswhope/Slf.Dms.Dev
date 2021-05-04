<%@ WebHandler Language="VB" Class="SaveHTML5CanvasHandler" %>

Imports System
Imports System.Web

Public Class SaveHTML5CanvasHandler : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        
        Dim fileName As String = ""
        Dim sData As String = ""
        Dim bErr As Boolean = False
        
        If Not IsNothing(context.Request.Form("file")) Then
            fileName = context.Request.Form("file")
        Else
            'Throw New ArgumentException("No File Specified")
            context.Response.Write("No File Specified<br>")
            bErr = True
        End If
        If Not IsNothing(context.Request.Form("data")) Then
            sData = context.Request.Form("data")
            'sData = sData.Replace("\0 ", "").Replace(" ", "%2b").Replace("+", "%2b").Replace(Chr(32), "%2b")
            Do Until sData.Length Mod 4 = 0
                sData += "="
            Loop
            
        Else
            'Throw New ArgumentException("No data")
            context.Response.Write("No Data<br>")
            bErr = True
        End If
        If bErr = False Then
            '%2b
            Dim bytes As Byte() = Convert.FromBase64String(sData)
            Using ms As New IO.MemoryStream(bytes, 0, bytes.Length)
                ms.Write(bytes, 0, bytes.Length)
                Dim img As System.Drawing.Image = System.Drawing.Image.FromStream(ms, True)
                Dim imgPath As String = context.Server.MapPath(String.Format("temp/{0}.png", fileName))
                img.Save(imgPath)
            End Using
            'Try
            '    Using img As System.Drawing.Image = System.Drawing.Image.FromFile(fileName)
            '        context.Response.ContentType = "image/png"
            '        Using tImg As System.Drawing.Image = img.GetThumbnailImage(500, 200, Nothing, Nothing)
            '            tImg.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Png)
            '        End Using
            '    End Using
            'Catch fnx As IO.FileNotFoundException


            'End Try
        End If
        
     
              
        
       
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class