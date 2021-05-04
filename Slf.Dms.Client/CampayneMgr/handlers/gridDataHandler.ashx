<%@ WebHandler Language="VB" Class="gridDataHandler" %>

Imports System
Imports System.Web
Imports System.Web.Script.Serialization
Imports System.Data

Public Class gridDataHandler : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        Dim fbdl As New gridDataHandler
        Dim data As String = String.Empty
        
     
        'Dim reqType As String = context.Request.QueryString("t").ToString()
        Dim datatype As String = context.Request.QueryString("d").ToString()
        Dim id As String =context.Request.Form("id").ToString
        Dim oper As String = context.Request.Form("oper").ToString
       
        
        Dim scid As Integer = 0
        Dim sfid As Integer = 0
        
        GetFormValues(scid, sfid)
        
        Select Case oper.ToLower
            Case "edit"
                Select Case datatype
                    Case "field"
                        Dim fo As New SchoolFormControl.FieldsObject
                        With fo
                            .FieldLabel = context.Request.Form("FieldLabel").ToString
                            .FieldName = context.Request.Form("FieldName").ToString
                            .FieldsObjectID = context.Request.Form("FieldsObjectID").ToString
                            .Notes = context.Request.Form("Notes").ToString
                            .Required = context.Request.Form("Required").ToString
                            .SchoolFormID = sfid
                            .Type = context.Request.Form("Type").ToString
                            .Save()
                        End With
                    Case "fielditem"
                        Dim fo As New SchoolFormControl.FieldsObject.FieldsItemObject
                        With fo
                            .FieldsItemID = context.Request.Form("FieldsItemID").ToString
                            .FieldName = context.Request.Form("FieldName").ToString
                            .AcceptedName = context.Request.Form("AcceptedName").ToString
                            .AcceptedValue = context.Request.Form("AcceptedValue").ToString
                            .Save()
                        End With
                        
                    Case "rule"
                        Dim vr As New SchoolFormControl.ValidationRulesObject
                        With vr
                            .ValidationRuleID = context.Request.Form("ValidationRuleID").ToString
                            .SchoolCampaignID = scid
                            .SchoolFormID = sfid
                            .Rule = context.Request.Form("Rule").ToString
                            .FieldName = context.Request.Form("FieldName").ToString
                            .ParamName = context.Request.Form("ParamName").ToString
                            .ParamValue = context.Request.Form("ParamValue").ToString
                            .Save()
                        End With
                    Case "location"
                        Dim lo As New SchoolFormControl.SOAPLocationCurriculumObject
                        With lo
                            .LocationCurriculumID = context.Request.Form("LocationCurriculumID").ToString
                            .LocationID = context.Request.Form("LocationID").ToString
                            .LocationName = context.Request.Form("LocationName").ToString
                            .Active = context.Request.Form("Active").ToString
                            .SchoolCampaignID = scid
                            .SchoolFormID = sfid
                            .Save()
                        End With
                    Case "locationcurriculumitemid"
                        
                        Dim ci As New SchoolFormControl.SOAPLocationCurriculumObject.CurriculumItem
                        Dim lci As Integer = -1
                        
                        With ci
                            .LocationCurriculumID = context.Request.Form("LocationCurriculumID").ToString
                            .LocationCurriculumItemID = context.Request.Form("LocationCurriculumItemID").ToString
                            .LocationID = context.Request.Form("LocationID").ToString
                            .ItemName = context.Request.Form("ItemName").ToString
                            .ItemValue = context.Request.Form("ItemValue").ToString
                            .Outcome = context.Request.Form("Outcome").ToString
                            .Save(sfid)
                        End With
                        
                    Case Else
                        'no object
                End Select
            Case "add"
               
                Select Case datatype
                    Case "field"
                        Dim fo As New SchoolFormControl.FieldsObject
                        With fo
                            .FieldLabel = context.Request.Form("FieldLabel").ToString
                            .FieldName = context.Request.Form("FieldName").ToString
                            .FieldsObjectID = -1
                            .Notes = context.Request.Form("Notes").ToString
                            .Required = context.Request.Form("Required").ToString
                            .SchoolCampaignID = scid
                            .SchoolFormID = sfid
                            .Type = context.Request.Form("Type").ToString
                            .Save()
                        End With
                    Case "fielditem"
                        Dim fo As New SchoolFormControl.FieldsObject.FieldsItemObject
                        With fo
                            .FieldsItemID = -1
                            .FieldName = context.Request.Form("FieldName").ToString
                            .AcceptedName = context.Request.Form("AcceptedName").ToString
                            .AcceptedValue = context.Request.Form("AcceptedValue").ToString
                            .Add(scid, sfid)
                        End With
                    Case "rule"
                        Dim vr As New SchoolFormControl.ValidationRulesObject
                        With vr
                            .ValidationRuleID = -1
                            .SchoolCampaignID = scid
                            .SchoolFormID = sfid
                            .Rule = context.Request.Form("Rule").ToString
                            .FieldName = context.Request.Form("FieldName").ToString
                            .ParamName = context.Request.Form("ParamName").ToString
                            .ParamValue = context.Request.Form("ParamValue").ToString
                            .Save()
                        End With
                    Case "location"
                        Dim lo As New SchoolFormControl.SOAPLocationCurriculumObject
                        With lo
                            .LocationID = -1
                            .LocationName = context.Request.Form("LocationName").ToString
                            .SchoolCampaignID = scid
                            .SchoolFormID = sfid
                            .Save()
                        End With
                    Case "locationcurriculumitemid"
                      
                        Dim ci As New SchoolFormControl.SOAPLocationCurriculumObject.CurriculumItem
                        Dim lci As Integer = -1
                        
                        With ci
                            .LocationCurriculumItemID = -1
                            .LocationID = context.Request.Form("LocationID").ToString
                            Dim sqlLoc As String = String.Format("select LocationCurriculumID from tblSchoolCampaigns_LocationCurriculum where locationid = {0} and SchoolFormID = {1}", .LocationID, sfid)
                            .LocationCurriculumID = SqlHelper.ExecuteScalar(sqlLoc, CommandType.Text)
                            .ItemName = context.Request.Form("ItemName").ToString
                            .ItemValue = context.Request.Form("ItemValue").ToString
                            .Outcome = context.Request.Form("Outcome").ToString
                            .Save(sfid)
                        End With
                    Case Else
                        'no object
                                                
                End Select
            Case "del"    'delete
                Select Case datatype
                    Case "field"
                        
                        Dim fo As New SchoolFormControl.FieldsObject
                        With fo
                            .FieldsObjectID = context.Request.Form("FieldsObjectID").ToString
                            .Delete()
                        End With
                    Case "fielditem"
                        Dim fo As New SchoolFormControl.FieldsObject.FieldsItemObject
                        With fo
                            .FieldsItemID = context.Request.Form("FieldsItemID").ToString
                            .Delete()
                        End With
                    Case "rule"
                        Dim vr As New SchoolFormControl.ValidationRulesObject
                        With vr
                            .ValidationRuleID = context.Request.Form("ValidationRuleID").ToString
                            .Delete()
                        End With
                    Case "location"
                        Dim lo As New SchoolFormControl.SOAPLocationCurriculumObject
                        With lo
                            .LocationCurriculumID = context.Request.Form("LocationCurriculumID").ToString
                            .Delete()
                        End With
                    Case "locationcurriculumitemid"
                        Dim ci As New SchoolFormControl.SOAPLocationCurriculumObject.CurriculumItem
                        Dim lci As Integer = -1
                        With ci
                            .LocationCurriculumItemID = context.Request.Form("LocationCurriculumItemID").ToString
                            .Delete()
                        End With
                    Case Else
                        'no object
                        
                        
                End Select
                
        End Select
    End Sub
    Private Sub GetFormValues(ByRef schoolCampID As String, ByRef formID As String)
        If Not IsNothing(HttpContext.Current.Request.QueryString("scid")) Then
            schoolCampID = HttpContext.Current.Request.QueryString("scid").ToString
        Else
            If Not IsNothing(HttpContext.Current.Request.QueryString("SchoolCampaignID")) Then
                schoolCampID = HttpContext.Current.Request.Form("SchoolCampaignID").ToString
            Else
                If Not IsNothing(HttpContext.Current.Request.QueryString("scid")) Then
                    schoolCampID = HttpContext.Current.Request.Form("scid").ToString
                End If
            End If
        End If
                
        If Not IsNothing(HttpContext.Current.Request.QueryString("sfid")) Then
            formID = HttpContext.Current.Request.QueryString("sfid").ToString
        Else
            If Not IsNothing(HttpContext.Current.Request.Form("SchoolFormID")) Then
                formID = HttpContext.Current.Request.Form("SchoolFormID").ToString
            Else
                If Not IsNothing(HttpContext.Current.Request.Form("sfid")) Then
                    formID = HttpContext.Current.Request.Form("sfid").ToString
                End If
            End If
        End If
    End Sub
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
    
End Class