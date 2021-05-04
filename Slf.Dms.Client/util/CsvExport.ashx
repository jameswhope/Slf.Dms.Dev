<%@ WebHandler Language="VB" Class="CsvExport" %>

Imports System
Imports System.Web

Public Class CsvExport : Implements IHttpHandler
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim fname As String = ""
        If Not isnothing(context.Request.QueryString("f")) Then
            fname = context.Request.QueryString("f")
        End If
        If String.IsNullOrEmpty(fname) Then
            fname = "CSV_Export"
        End If
    
        context.Response.ContentType = "application/force-download"
        context.Response.AddHeader("content-disposition", String.Format("attachment;filename={0}.csv", fname))
        context.Response.Write(context.Request.Form("exportdata"))
        context.Response.Flush()
        context.Response.End()
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class