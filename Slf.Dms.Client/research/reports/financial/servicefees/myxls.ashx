<%@ WebHandler Language="VB" Class="report_servicefeemyxls" %>

Imports System
Imports System.Collections
Imports System.Collections.Specialized
Imports System.Collections.Generic
Imports System.Data
Imports System.Web
Imports System.Web.UI

Public Class report_servicefeemyxls
    Implements IHttpHandler, IRequiresSessionState

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Try
            Dim cs As List(Of Payment) = context.Session("xls_servicefeemy_list")
            
            
            context.Response.ContentType = "application/vnd.ms-excel"
            context.Response.AddHeader("Content-Disposition", "filename=Commission.xls")
         
            Dim writer As New HtmlTextWriter(context.Response.Output)
            
            writer.Write("<table border=""1"">")
            writer.Write("<tr><td>Service Fee Payments:</td></tr>")
            writer.Write("<tr><td>")
            writer.Write("Account No.")
            writer.Write("</td><td>")
            writer.Write("Hire Date")
            writer.Write("</td><td>")
            writer.Write("First Name")
            writer.Write("</td><td>")
            writer.Write("Last Name")
            writer.Write("</td><td>")
            writer.Write("Fee Category")
            writer.Write("</td><td>")
            writer.Write("Setl No.")
            writer.Write("</td><td>")
            writer.Write("Orig Bal.")
            writer.Write("</td><td>")
            writer.Write("Beg Bal.")
            writer.Write("</td><td>")
            writer.Write("Pmt Amt.")
            writer.Write("</td><td>")
            writer.Write("End Bal.")
            writer.Write("</td><td>")
            writer.Write("Rate")
            writer.Write("</td><td>")
            writer.Write("Amount")
            writer.Write("</td></tr>")
                     
            For Each c As Payment In cs
                RenderRow(writer, c)
            Next
         
            writer.Write("</table>")
         
            'Render Payments
            dim charges as List(of payment)= context.Session("xls_servicefeemycharges_list")
            if not charges is nothing then
            padrows(writer,2)
                writer.Write("<table border=""1"">")
                writer.Write("<tr><td>Service Fee New Charges/Overview:</td></tr>")
                writer.Write("<tr><td>")
                writer.Write("Account No.")
                writer.Write("</td><td>")
                writer.Write("Hire Date")
                writer.Write("</td><td>")
                writer.Write("First Name")
                writer.Write("</td><td>")
                writer.Write("Last Name")
                writer.Write("</td><td>")
                writer.Write("Fee Category")
                writer.Write("</td><td>")
                writer.Write("Amount")
                writer.Write("</td></tr>")
                         
                For Each p As Payment In charges
                    RenderRow2(writer, p)
                Next
             
                writer.Write("</table>")
                        padrows(writer,2)
                dim totals as List(of single) = context.Session("xls_servicefeemytotals_list")
                writer.Write("<table border=""1"">")
                writer.Write("<tr><td></td><td></td><td></td><td></td><td>Previous Balance</td><td>" & totals(0) & "</td></tr>")
                writer.Write("<tr><td></td><td></td><td></td><td></td><td>New Charges Total</td><td>" & totals(1) & "</td></tr>")
                writer.Write("<tr><td></td><td></td><td></td><td></td><td>Service Fee Payments Total</td><td>" & totals(2) & "</td></tr>")
                writer.Write("<tr><td></td><td></td><td></td><td></td><td>Ending Balance</td><td>" & totals(3) & "</td></tr>")
                writer.Write("</table>")
            end if
         
            writer.Close()
        Catch
        End Try
    End Sub

    public Sub PadRows(ByVal writer As HtmlTextWriter, ByVal count as Integer)
        writer.Write("<table>")
        for i as Integer = 1 to count
            writer.Write("<tr><td> </td></tr>")
        next
        writer.Write("</table>")
    end sub

    Public Sub RenderRow(ByVal writer As HtmlTextWriter, ByVal c As Payment)
        writer.Write("<tr><td>")
        WriteCellContent(writer, c.AccountNumber)
        writer.Write("</td><td>")
        WriteCellContent(writer, LocalHelper.GetDateString(c.HireDate))
        writer.Write("</td><td>")
        WriteCellContent(writer, c.FirstName)
        writer.Write("</td><td>")
        WriteCellContent(writer, c.LastName)
        writer.Write("</td><td>")
        WriteCellContent(writer, c.FeeCategory)
        writer.Write("</td><td>")
        WriteCellContent(writer, c.SettlementNumber)
        writer.Write("</td><td>")
        WriteCellContent(writer, LocalHelper.GetSingleString(c.OriginalBalance,true))
        writer.Write("</td><td>")
        WriteCellContent(writer, LocalHelper.GetSingleString(c.BeginningBalance,true))
        writer.Write("</td><td>")
        WriteCellContent(writer, LocalHelper.GetSingleString(c.PaymentAmount,true))
        writer.Write("</td><td>")
        WriteCellContent(writer, LocalHelper.GetSingleString(c.EndingBalance,true))
        writer.Write("</td><td>")
        WriteCellContent(writer, LocalHelper.GetSingleString(c.Rate,true))
        writer.Write("</td><td>")
        WriteCellContent(writer, LocalHelper.GetSingleString(c.Amount,true))
        writer.Write("</td></tr>")
    End Sub
     Public Sub RenderRow2(ByVal writer As HtmlTextWriter, ByVal c As Payment)
        writer.Write("<tr><td>")
        WriteCellContent(writer, c.AccountNumber)
        writer.Write("</td><td>")
        WriteCellContent(writer, LocalHelper.GetDateString(c.HireDate))
        writer.Write("</td><td>")
        WriteCellContent(writer, c.FirstName)
        writer.Write("</td><td>")
        WriteCellContent(writer, c.LastName)
        writer.Write("</td><td>")
        WriteCellContent(writer, c.FeeCategory)
        writer.Write("</td><td>")
        WriteCellContent(writer, LocalHelper.GetSingleString(c.Amount,true))
        writer.Write("</td></tr>")
    End Sub
      
    Sub WriteCellContent(ByVal writer As HtmlTextWriter, ByVal s As String)
        If Not String.IsNullOrEmpty(s) Then
            writer.Write(s)
        End If
    End Sub
   
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class