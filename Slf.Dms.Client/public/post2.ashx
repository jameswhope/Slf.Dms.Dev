<%@ WebHandler Language="VB" Class="post" %>

Imports System
Imports System.Web
Imports System.Collections.Generic

Public Class post : Implements IHttpHandler

    'based on website rather than into tblLeadData

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        Dim rawUrl As String
        Dim params As New List(Of String)
        Dim redirectUrl As String = ""
        Dim errorMsg As String = ""
        Dim respType As String = ""
        Dim disposition As String = ""
        Dim LeadStatus As Integer = 10

        'If context.Request.Form.Count > 0 Then
        '    For Each name In context.Request.Form.Keys
        '        params.Add(String.Concat(name, "=", context.Request.Form(name)))
        '    Next
        '    rawUrl = String.Concat("?", String.Join("&", params.ToArray))
        'Else
        rawUrl = context.Request.RawUrl
        'End If

        SqlHelper.ExecuteNonQuery(String.Format("insert into tblErrorLog (RawData) values ('{0}')", rawUrl), Data.CommandType.Text)

    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class