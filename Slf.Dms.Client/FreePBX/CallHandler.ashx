<%@ WebHandler Language="VB" Class="CallHandler" %>

Imports System
Imports System.Web
Imports System.Web.Script.Serialization
Imports System.IO

Public Class CallHandler : Implements IHttpHandler, IReadOnlySessionState

    Dim _context As HttpContext

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        _context = context
        _context.Response.ContentType = "application/json"
        _context.Response.ContentEncoding = Encoding.UTF8
        
        ExecJsonRequest()
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return True
        End Get
    End Property
    
    Private Sub ExecJsonRequest()
        Dim action As String = _context.Request("action")
        Dim json As String
        
        _context.Request.InputStream.Position = 0
        Using inputStream As New StreamReader(_context.Request.InputStream)
            json = inputStream.ReadToEnd()
        End Using
            
        Select Case action.Trim.ToLower
            Case "storesessionvar"
                Dim sessionvarname As String = _context.Request("sessionvarname")
                Dim sessionvarvalue As String = _context.Request("sessionvarvalue")
                If not sessionvarname is Nothing andalso sessionvarname.Trim.Length > 0 Then
                    If sessionvarvalue is Nothing orelse sessionvarvalue.Trim.Length = 0 then  
                        _context.Session(sessionvarname) = Nothing
                    Else
                        _context.Session(sessionvarname) = sessionvarvalue
                    End If
                End If
            Case "connectleadcall", "clientmanualdial", "manualdial", "leadmanualdial", "verificationrecording", "settlementrecording", "sendrecordingemail", "createconference"
                Dim obj As FPBXAction = FPBXAction.Create(action.Trim.ToLower)
                writeRaw(obj.Execute(json))
        End Select
    End Sub
 
    Public Sub writeJson(ByVal obj As Object)
        Dim javaScriptSerializer As New JavaScriptSerializer()
        Dim jsondata As String = javaScriptSerializer.Serialize(obj)
        writeRaw(jsondata)
    End Sub
        
    Public Function readJson(ByVal json As String, ByVal objType As Type) As Object
        Dim ser As New JavaScriptSerializer()
        Return ser.GetType().GetMethod("Deserialize").MakeGenericMethod(objType).Invoke(ser, New Object(0) {json})
    End Function
  
    Public Sub writeRaw(ByVal text As String)
        _context.Response.Write(text)
    End Sub

End Class