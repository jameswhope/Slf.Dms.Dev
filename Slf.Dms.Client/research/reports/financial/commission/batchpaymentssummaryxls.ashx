<%@ WebHandler Language="VB" Class="batchpaymentssummaryxls" %>

Imports System
Imports System.Collections
Imports System.Collections.Specialized
Imports System.Collections.Generic
Imports System.Data
Imports System.Web
Imports System.Web.UI
imports Drg.Util.DataAccess

Public Class batchpaymentssummaryxls
    Implements IHttpHandler, IRequiresSessionState
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Try
            Dim Agencies As String
            Agencies = context.Session("xls_BatchPaymentsSummary_list")
            
            context.Response.ContentType = "application/vnd.ms-excel"
            context.Response.AddHeader("Content-Disposition", "filename=BatchPaymentsSummary_" + DateTime.Now.Year.ToString() + "_" + DateTime.Now.Month.ToString().PadLeft(2, "0") + "_" + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".xls")
            
            Dim writer As New HtmlTextWriter(context.Response.Output)
            
            writer.Write("<table>")
            writer.Write(RemoveImages(Agencies))
            writer.Write("</table>")
            
            writer.Close()
        Catch
        End Try
    End Sub
    
    Public Function RemoveImages(ByVal Agencies As String) As String
        Dim idx As Integer = 1
        Dim endidx As Integer = 0
        While idx > 0
            idx = Agencies.IndexOf("<img", idx)
            If idx > 0
                endidx = Agencies.IndexOf(">", idx)
                Agencies = Agencies.Remove(idx, endidx - idx + 1)
                Agencies = Agencies.Insert(idx, "&nbsp;&nbsp;&nbsp;&nbsp;")
            End If
        End While

        Return Agencies
    End Function
   
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class