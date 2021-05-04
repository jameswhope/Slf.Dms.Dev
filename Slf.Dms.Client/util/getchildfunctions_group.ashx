<%@ WebHandler Language="VB" Class="getchildfunctions_group" %>

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System
Imports System.Xml
Imports System.Web
Imports System.Data
Imports System.Collections
Imports System.Collections.Generic

Public Class getchildfunctions_group : Implements IHttpHandler
    
    Public Function GetBool(ByVal b As Nullable(Of Boolean)) As String
        If b.HasValue Then
            If b.Value = True Then
                Return "1"
            Else
                Return "0"
            End If
        Else
            Return ""
        End If
    End Function
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim doc As XmlDocument = New XmlDocument
        Dim root As XmlElement = doc.CreateElement("functions")

        Dim UserGroupId As Integer = Integer.Parse(context.Request.QueryString("UserGroupId"))
        Dim ParentFunctionId As Integer = Integer.Parse(context.Request.QueryString("fid"))
        Dim DefinedOnly As Boolean = Boolean.Parse(context.Request.QueryString("definedonly"))

        Dim Permissions As New Dictionary(Of Integer, GridPermission)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Permissions_GroupFunctionFunctions_Get")
            DatabaseHelper.AddParameter(cmd, "ParentFunctionId", ParentFunctionId)
            DatabaseHelper.AddParameter(cmd, "UserGroupId", UserGroupId)

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()
                        Dim FunctionId As Integer = DatabaseHelper.Peel_int(rd, "FunctionId")
                        Dim FunctionName As String = DatabaseHelper.Peel_string(rd, "FunctionName")
                        Dim Value As Nullable(Of Boolean) = LocalHelper.peel_bool_nullable(rd, "Value")
                        Dim PermissionTypeId As Integer = DatabaseHelper.Peel_int(rd, "PermissionTypeId")
                        Dim IsOperation As Boolean = DatabaseHelper.Peel_bool(rd, "IsOperation")
                        Dim IsSystem As Boolean = DatabaseHelper.Peel_bool(rd, "IsSystem")
                        Dim NumChildren As Integer = DatabaseHelper.Peel_int(rd, "NumChildren")

                        Dim OldP As GridPermission = Nothing
                        If Permissions.TryGetValue(FunctionId, OldP) Then
                            If Value.HasValue Then
                                Select Case PermissionTypeId
                                    Case 1
                                        OldP.View = Value
                                    Case 2
                                        OldP.Add = Value
                                    Case 3
                                        OldP.EditOwn = Value
                                    Case 4
                                        OldP.EditAll = Value
                                    Case 5
                                        OldP.DeleteOwn = Value
                                    Case 6
                                        OldP.DeleteAll = Value
                                End Select
                            End If
                        Else
                            'add a new one
                            Dim NewP As New GridPermission
                            NewP.Id = FunctionId
                            NewP.Name = FunctionName
                            NewP.ParentId = ParentFunctionId
                            NewP.IsOperation = IsOperation
                            NewP.IsSystem = IsSystem
                            newp.NumChildren=NumChildren
                            Select Case PermissionTypeId
                                Case 1
                                    NewP.View = Value
                                Case 2
                                    NewP.Add = Value
                                Case 3
                                    NewP.EditOwn = Value
                                Case 4
                                    NewP.EditAll = Value
                                Case 5
                                    NewP.DeleteOwn = Value
                                Case 6
                                    NewP.DeleteAll = Value
                            End Select
                            Permissions.Add(FunctionId, NewP)
                        End If
                                        
                    End While
                    For Each p As GridPermission In Permissions.Values
                        Dim el As XmlElement = doc.CreateElement("function")

                        el.SetAttribute("FunctionId", p.Id)
                        el.SetAttribute("FunctionName", p.Name)
                        el.SetAttribute("View", GetBool(p.View))
                        el.SetAttribute("Add", GetBool(p.Add))
                        el.SetAttribute("EditOwn", GetBool(p.EditOwn))
                        el.SetAttribute("EditAll", GetBool(p.EditAll))
                        el.SetAttribute("DeleteOwn", GetBool(p.DeleteOwn))
                        el.SetAttribute("DeleteAll", GetBool(p.DeleteAll))
                        el.SetAttribute("IsOperation", GetBool(p.IsOperation))
                        el.SetAttribute("IsSystem", GetBool(p.IsSystem))
                        el.SetAttribute("NumChildren", p.NumChildren)

                        root.AppendChild(el)
                    
                    Next
                End Using
            End Using
        End Using
        
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