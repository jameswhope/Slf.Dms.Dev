<%@ WebHandler Language="VB" Class="batchdetailxls" %>

Imports System
Imports System.Collections
Imports System.Collections.Specialized
Imports System.Collections.Generic
Imports System.Data
Imports System.Web
Imports System.Web.UI

Public Class batchdetailxls
    Implements IHttpHandler, IRequiresSessionState

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Try
            Dim final As String = context.Session("xls_batchdetail_list_detail")
            
            context.Response.ContentType = "application/vnd.ms-excel"
            context.Response.AddHeader("Content-Disposition", "filename=CommissionBatchPayments_" + DateTime.Now.Year.ToString() + "_" + DateTime.Now.Month.ToString().PadLeft(2, "0") + "_" + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".xls")
            
            Dim writer As New HtmlTextWriter(context.Response.Output)
            
            writer.Write(final)
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