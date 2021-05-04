<%@ WebHandler Language="VB" Class="CallHandler" %>

Imports System
Imports System.Web
Imports System.Web.Script.Serialization
Imports System.IO
Imports System.Net

Public Class CallHandler : Implements IHttpHandler, IReadOnlySessionState

    Dim _context As HttpContext
    Dim _callback As String

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
        Try
            _callback = _context.Request("callback").ToString
            
        Catch ex As Exception
            _callback = ""
        End Try
        
        Dim json As String
        
        If _context.Request.HttpMethod = "POST" Then
            _context.Request.InputStream.Position = 0
            Using inputStream As New StreamReader(_context.Request.InputStream)
                json = inputStream.ReadToEnd()
            End Using
        Else
            If _callback.Trim.Length > 0 Then
                Try
                    json = _context.Request(Nothing)
                Catch ex As Exception
                    json = ""
                End Try
            End If
        End If
            
        Select Case action.Trim.ToLower
            Case "getvendorleadcode"
                Dim vicileadid As String = _context.Request("vicileadid")
                Dim jsondata As String = "0"
                If VicidialHelper.GetVendorCode(vicileadid).Length > 0 Then
                    jsondata = "1"
                End If
                writeRaw(jsondata)
            Case "leadmanualdial", "connectleadcall", "getleadstatusreasons", "clientmanualdial", "startmanualrecording", "stopmanualrecording"
                Dim obj As VicidialAction = VicidialAction.Create(action.Trim.ToLower)
                Dim jsondata As String = obj.Execute(json)
                writeRaw(jsondata)
        End Select
    End Sub
 
    Public Sub writeJson(ByVal obj As Object)
        Dim javaScriptSerializer As New JavaScriptSerializer()
        Dim jsondata As String = javaScriptSerializer.Serialize(obj)
        If _callback.Trim.Length > 0 Then jsondata = String.Format("{0}({1});", _callback, jsondata)
        writeRaw(jsondata)
    End Sub
        
    Public Function readJson(ByVal json As String, ByVal objType As Type) As Object
        Dim ser As New JavaScriptSerializer()
        Return ser.GetType().GetMethod("Deserialize").MakeGenericMethod(objType).Invoke(ser, New Object(0) {json})
    End Function
  
    Public Sub writeRaw(ByVal text As String)
        If _callback.Trim.Length > 0 Then text = String.Format("{0}({1});", _callback, text)
        _context.Response.Write(text)
    End Sub

End Class