<%@ WebHandler Language="VB" Class="Setting" %>

Imports System
Imports System.Data
Imports System.Web

imports Drg.Util.DataHelpers
imports Drg.Util.DataAccess
Public Class Setting : Implements IHttpHandler, IRequiresSessionState
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim setting As String = context.Request.Form("s")
        Dim value As String = context.Request.Form("v")
        Dim UserID As String = context.Request.Form("uid")
        Dim ClassName As String = context.Request.Form("classname")
        
        If setting IsNot Nothing Then
            Select Case setting
                Case "Comms_IsOpen"
                    If value IsNot Nothing Then
                        context.Session(setting) = Boolean.Parse(value)
                    End If
                    try
                        value = context.Session(setting).ToString()
                    catch
                        value="False"
                        context.Session(setting) = false
                    end try
                Case "Comms_AutoSync"
                    If value IsNot Nothing Then
                        context.Session("Comms_AutoSync") = boolean.Parse(value)
                        DataHelper.Delete("tblquerysetting","classname='" & classname & "' and userid=" & userid & "and [object]='AutoSync'")
                        QuerySettingHelper.Insert(ClassName, UserID, "AutoSync", "value", value)
                    end if
                    value = context.Session(setting).ToString()
                Case "Comms_OpenIn"
                    If value IsNot Nothing Then
                        DataHelper.Delete("tblquerysetting","classname='" & classname & "' and userid=" & userid & "and [object]='ddlOpenIn'")
                        QuerySettingHelper.Insert(ClassName, UserID, "ddlOpenIn", "index", value)
                    end if
                    value=""
            End Select
            
            
            context.Response.ContentType = "text/plain"
            context.Response.Write(value)
            context.Response.End()
            context.Response.Close()
        End If
    End Sub
    
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class