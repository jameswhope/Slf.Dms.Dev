<%@ WebHandler Language="VB" Class="KeepAlive" %>

Imports System
Imports System.Web

Public Class KeepAlive : Implements IHttpHandler, IRequiresSessionState
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Session("KeepSessionAlive") = "KeepAlive!"
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class