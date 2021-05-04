Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports Slf.Dms.Controls

Imports System
Imports System.Web.UI
Imports System.Collections
Imports Microsoft.VisualBasic
Imports System.Collections.Generic

Public Interface IPermissionControl
    Sub AddPermissionControls(ByVal c As Dictionary(Of String, Control))
    Sub AddControl(ByVal c As Control, ByVal Controls As Dictionary(Of String, Control), ByVal FunctionName As String, ByVal PermissionTypeId As Integer, ByVal Action As Boolean)
    Sub AddControl(ByVal c As Control, ByVal Controls As Dictionary(Of String, Control), ByVal FunctionName As String)
    Sub AddControl(ByVal c As Control, ByVal Controls As Dictionary(Of String, Control))
End Interface


Public MustInherit Class PermissionPage
    Inherits Page
    Implements IPermissionControl

    Public MustOverride Sub AddPermissionControls(ByVal c As Dictionary(Of String, Control)) Implements IPermissionControl.AddPermissionControls

    Public Sub AddControl(ByVal c As Control, ByVal Controls As Dictionary(Of String, Control)) Implements IPermissionControl.AddControl
        AddControl(c, Controls, Nothing)
    End Sub
    Public Sub AddControl(ByVal c As Control, ByVal Controls As Dictionary(Of String, Control), ByVal FunctionName As String) Implements IPermissionControl.AddControl
        AddControl(c, Controls, FunctionName, 1, False)
    End Sub
    Public Sub AddControl(ByVal c As Control, ByVal Controls As Dictionary(Of String, Control), ByVal FunctionName As String, ByVal PermissionTypeId As Integer, ByVal Action As Boolean) Implements IPermissionControl.AddControl
        Controls.Add(c.ID, c)
        If Not String.IsNullOrEmpty(FunctionName) Then
            PermissionHelper.DatabaseMakeControl(c.ID, Me.GetType.Name, FunctionName, PermissionTypeId, Action)
        End If
    End Sub
    Protected Overrides Sub OnLoad(ByVal e As System.EventArgs)
        MyBase.OnLoad(e)
        Dim c As New Dictionary(Of String, Control)
        Me.AddPermissionControls(c)
        PermissionHelper.ApplyPermissions(Context, Me.GetType.Name, DataHelper.Nz_int(Page.User.Identity.Name), c)

    End Sub
    Public Function GetFunctionPermission(ByVal FunctionId As Integer) As PermissionHelper.Permission
        Dim Permissions As Dictionary(Of Integer, PermissionHelper.Permission) = PermissionHelper.GetPermissionsAll(Me.Context, DataHelper.Nz_int(Page.User.Identity.Name))
        Dim p As PermissionHelper.Permission = Nothing
        Permissions.TryGetValue(FunctionId, p)
        Return p
    End Function
    Public Function GetFunctionPermission(ByVal FunctionName As String) As PermissionHelper.Permission
        Dim FunctionId As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblFunction", "FunctionId", "name='" & FunctionName & "'"))
        Return GetFunctionPermission(FunctionId)
    End Function
    Public Function GetControlPermission(ByVal ControlName As String) As PermissionHelper.Permission
        Dim Permissions As Dictionary(Of Integer, PermissionHelper.Permission) = PermissionHelper.GetPermissionsAll(Me.Context, DataHelper.Nz_int(Page.User.Identity.Name))
        For Each p As PermissionHelper.Permission In Permissions.Values
            Dim found As Boolean = False
            For Each pc As PermissionHelper.PermissionControl In p.Controls
                If pc.ControlName = ControlName Then
                    Return p
                End If
            Next
        Next
        Return Nothing
    End Function
    Public ReadOnly Property Permission() As PermissionHelper.Permission
        Get
            Dim FunctionId As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPage", "FunctionId", "name='" & Me.GetType.Name & "'"))
            Dim p As PermissionHelper.Permission = GetFunctionPermission(FunctionId)
            If p Is Nothing Then p = New PermissionHelper.Permission()
            Return p
        End Get
    End Property
End Class


Public MustInherit Class PermissionMasterPage
    Inherits MasterPage
    Implements IPermissionControl

    Public MustOverride Sub AddPermissionControls(ByVal c As Dictionary(Of String, Control)) Implements IPermissionControl.AddPermissionControls
    Public Sub AddControl(ByVal c As Control, ByVal Controls As Dictionary(Of String, Control)) Implements IPermissionControl.AddControl
        AddControl(c, Controls, Nothing)
    End Sub
    Public Sub AddControl(ByVal c As Control, ByVal Controls As Dictionary(Of String, Control), ByVal FunctionName As String) Implements IPermissionControl.AddControl
        AddControl(c, Controls, FunctionName, 1, False)
    End Sub
    Public Sub AddControl(ByVal c As Control, ByVal Controls As Dictionary(Of String, Control), ByVal FunctionName As String, ByVal PermissionTypeId As Integer, ByVal Action As Boolean) Implements IPermissionControl.AddControl
        Controls.Add(c.ID, c)
        If Not String.IsNullOrEmpty(FunctionName) Then
            PermissionHelper.DatabaseMakeControl(c.ID, Me.GetType.Name, FunctionName, PermissionTypeId, Action)
        End If
    End Sub
    Protected Overrides Sub OnLoad(ByVal e As System.EventArgs)
        MyBase.OnLoad(e)
        Dim c As New Dictionary(Of String, Control)
        Me.AddPermissionControls(c)
        PermissionHelper.ApplyPermissions(Context, Me.GetType.Name, DataHelper.Nz_int(Page.Page.User.Identity.Name), c)


    End Sub
    Public Function GetFunctionPermission(ByVal FunctionId As Integer) As PermissionHelper.Permission
        Dim Permissions As Dictionary(Of Integer, PermissionHelper.Permission) = PermissionHelper.GetPagePermissions(Me.GetType.Name, Me.Context, DataHelper.Nz_int(Page.Page.User.Identity.Name))
        Dim p As PermissionHelper.Permission = Nothing
        Permissions.TryGetValue(FunctionId, p)
        Return p
    End Function
    Public Function GetFunctionPermission(ByVal FunctionName As String) As PermissionHelper.Permission
        Dim FunctionId As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblFunction", "FunctionId", "servername='" & FunctionName & "'"))
        Return GetFunctionPermission(FunctionId)
    End Function
    Public Function GetControlPermission(ByVal ControlName As String) As PermissionHelper.Permission
        Dim Permissions As Dictionary(Of Integer, PermissionHelper.Permission) = PermissionHelper.GetPagePermissions(Me.GetType.Name, Me.Context, DataHelper.Nz_int(Page.Page.User.Identity.Name))
        For Each p As PermissionHelper.Permission In Permissions.Values
            Dim found As Boolean = False
            For Each pc As PermissionHelper.PermissionControl In p.Controls
                If pc.ControlName = ControlName Then
                    Return p
                End If
            Next
        Next
        Return Nothing
    End Function
    Public ReadOnly Property Permission() As PermissionHelper.Permission
        Get
            Dim FunctionId As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPage", "FunctionId", "servername='" & Me.GetType.Name & "'"))
            Dim p As PermissionHelper.Permission = GetFunctionPermission(FunctionId)
            If p Is Nothing Then p = New PermissionHelper.Permission()
            Return p
        End Get
    End Property
End Class
