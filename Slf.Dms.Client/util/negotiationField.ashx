<%@ WebHandler Language="VB" Class="negotiationField" %>

Imports Lexxiom.BusinessServices

Imports System
Imports System.Xml
Imports System.Web
Imports System.Data

Public Class negotiationField : Implements IHttpHandler
    Dim bsCriteriaBuilder As Lexxiom.BusinessServices.CriteriaBuilder = New Lexxiom.BusinessServices.CriteriaBuilder()
    Dim ds As DataSet = New DataSet
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim FieldName As String = String.Empty
        Dim SearchText As String = String.Empty
        Dim CompareType As String = String.Empty        
        Dim QueryString As String = String.Empty
        Dim sb As StringBuilder = New StringBuilder()
        Dim indx As Integer
        
        Dim doc As XmlDocument = New XmlDocument
        Dim root As XmlElement = doc.CreateElement("negotiationfield")

        If Not context.Request.QueryString("FieldName") Is Nothing Then
            FieldName = context.Request.QueryString("FieldName").Trim
        End If

        If Not context.Request.QueryString("SearchText") Is Nothing Then
            SearchText = context.Request.QueryString("SearchText").Trim
        End If

        If Not context.Request.QueryString("compareType") Is Nothing Then
            CompareType = context.Request.QueryString("compareType").Trim
        End If       
        
        'build criteria
        Dim where As String = String.Empty
        
        Select Case CompareType
            Case "any"
                where = FieldName.Trim() & " LIKE '%" & replace(SearchText.Replace("'", "''")," ","%") & "%'"
            Case "exact"
                where = FieldName.Trim() & " = '" & SearchText.Replace("'", "''") & "'"
            Case "begin"
                where = FieldName.Trim() & " LIKE '" & Replace(SearchText.Replace("'", "''"), " ", "%") & "%'"
            Case "end"
                where = FieldName.Trim() & " LIKE '%" & Replace(SearchText.Replace("'", "''"), " ", "%") & "'"
            Case Else
                where = FieldName.Trim() & " LIKE '%" & replace(SearchText.Replace("'", "''")," ", "%") & "%'"
        End Select
        
        ds = bsCriteriaBuilder.GetFieldLookup(where, FieldName)
        If (ds.Tables(0).Rows.Count > 0) Then
            For indx = 0 To ds.Tables(0).Rows.Count - 1
                Dim el As XmlElement = doc.CreateElement("negotiationlookup")
                el.SetAttribute("Description", ds.Tables(0).Rows(indx)("Description"))
                root.AppendChild(el)                
            Next                
        End If
        
        doc.AppendChild(root)
        context.Response.ClearContent()
        context.Response.ClearHeaders()
        context.Response.ContentType = "text/xml"

        context.Response.Write("<?xml version=""1.0""?>")
        doc.Save(context.Response.OutputStream)
        context.Response.End()
    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class