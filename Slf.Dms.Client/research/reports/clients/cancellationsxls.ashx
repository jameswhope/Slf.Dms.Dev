<%@ WebHandler Language="VB" Class="cancellationsxls" %>

Imports System
Imports System.Collections
Imports System.Collections.Specialized
Imports System.Collections.Generic
Imports System.Data
Imports System.Web
Imports System.Web.UI
imports Drg.Util.DataAccess

Public Class cancellationsxls
    Implements IHttpHandler, IRequiresSessionState
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/vnd.ms-excel"
        context.Response.AddHeader("Content-Disposition", "filename=CancellationsReport_" + DateTime.Now.Year.ToString() + "_" + DateTime.Now.Month.ToString().PadLeft(2, "0") + "_" + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".xls")
        
        Dim writer As New HtmlTextWriter(context.Response.Output)
        
        Dim pnl as Panel = context.Session("cancellationsxls_pnl")
        
        pnl.RenderControl(writer)
        
        writer.Close()
    End Sub
   
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class