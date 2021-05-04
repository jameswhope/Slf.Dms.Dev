<%@ WebHandler Language="VB" Class="queryxls" %>

Imports System
Imports System.Collections
Imports System.Collections.Specialized
Imports System.Collections.Generic
Imports System.Data
Imports System.Web
Imports System.Web.UI

Public Class queryxls
    Implements IHttpHandler, IRequiresSessionState
   
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Try
            
            Dim Query As String = context.Request.QueryString("Query")
            Dim str As String = context.Session("xls_" & Query)
            
            context.Response.ContentType = "application/vnd.ms-excel"
            context.Response.AddHeader("Content-Disposition", "filename=Query.xls")
         
            Dim writer As New HtmlTextWriter(context.Response.Output)
            
            writer.Write(str)
                     
            writer.Close()
        Catch
        End Try
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class