<%@ WebHandler Language="VB" Class="savecell" %>

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System
Imports System.Xml
Imports System.Web
Imports System.Data
Imports System.Collections
Imports System.Collections.Generic

Public Class savecell : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim UserID As Integer = Integer.Parse(context.User.Identity.Name)
        
        Dim strAgencyID As String = DataHelper.FieldLookup("tblAgency", "AgencyID", "UserID=" & UserID)
        Dim AgencyID As Integer
        
        If Integer.TryParse(strAgencyID, AgencyID) Then
            Dim strRows As string = context.Request.Form("Rows")
            
            If String.IsNullOrEmpty(strRows) Then 'Update request
            
                Dim Row As Integer = Integer.Parse(context.Request.Form("Row"))
                Dim Col As Integer = Integer.Parse(context.Request.Form("Col"))
                Dim Value As String = context.Server.UrlDecode(context.Request.Form("Value").Trim())
            
                'trim value to a max length of 255
                If Value.Length > 255 Then Value = Value.Substring(0, 255)
                
                Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ClientQueue_IoU")
                    DatabaseHelper.AddParameter(cmd, "Value", Value)
                    DatabaseHelper.AddParameter(cmd, "AgencyID", AgencyID)
                    DatabaseHelper.AddParameter(cmd, "Row", Row)
                    DatabaseHelper.AddParameter(cmd, "Col", Col)

                    Using cmd.Connection
                        cmd.Connection.Open()
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
                
                context.Response.Clear()
                context.Response.ContentType = "text/plain"
                    
                Dim agh As New AgencyGridHelper("clients_new_agencydefault_aspx")
                    
                context.Response.Write(agh.Validate(Value, Col))
                context.Response.End()
            
            Else 'Delete request
                Dim Rows As String() = strRows.Split(",")
                For Each s As String In Rows
                    Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_ClientQueue_DeleteRow")
                        DatabaseHelper.AddParameter(cmd, "AgencyID", AgencyID)
                        DatabaseHelper.AddParameter(cmd, "Row", Integer.Parse(s))

                        Using cmd.Connection
                            cmd.Connection.Open()
                            cmd.ExecuteNonQuery()
                        End Using
                    End Using
                Next
            End If
        Else
            context.Response.Clear()
            context.Response.ContentType = "text/plain"
            context.Response.Write("Bad request or invalid user")
            context.Response.End()
        End If
    End Sub
    
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class