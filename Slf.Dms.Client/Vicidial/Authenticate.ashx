<%@ WebHandler Language="VB" Class="Authenticate" %>

Imports System
Imports System.Web
Imports Drg.Util.DataAccess

Public Class Authenticate : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim username As String = context.Request.QueryString("username")
        Dim password As String = context.Request.QueryString("password")

        Dim response As String = "" 'NOTHING FOUND

        If Not username Is Nothing AndAlso username.Trim.Length > 0 Then
            If Not password Is Nothing AndAlso password.Trim.Length > 0 Then
                Try
                    response = VicidialHelper.GetAuthenticationToken(username, DataHelper.GenerateSHAHash(password.Trim))
                Catch ex As Exception
                    response = ""
                End Try
            End If
        End If

        context.Response.ContentType = "text/plain"
        context.Response.Write(response)
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class