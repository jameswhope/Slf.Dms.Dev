Imports Microsoft.VisualBasic
Imports System
Imports System.Data

Imports System.Collections
Imports System.Collections.Generic
Imports System.Web
Imports System.Web.UI

Imports Drg.Util.DataAccess

Public Class PermissionHelper
#Region "Util"
    Private Shared Function peel_bool_nullable(ByVal rd As IDataReader, ByVal field As String) As Nullable(Of Boolean)
        Dim i As Integer = rd.GetOrdinal(field)
        If rd.IsDBNull(i) Then
            Return Nothing
        Else
            Return rd.GetBoolean(i)
        End If
    End Function
    Public Shared Function GetPagePermissions(ByVal PageName As String, ByVal context As HttpContext, ByVal userid As Integer) As Dictionary(Of Integer, Permission)
        Dim AllPages As Dictionary(Of String, Dictionary(Of Integer, Permission)) = GetPermissions(context, userid)
        Dim Permissions As Dictionary(Of Integer, Permission) = Nothing
        If AllPages.TryGetValue(PageName, Permissions) Then
            Return Permissions
        End If
        Return Nothing
    End Function
    Public Shared Function GetPermission(ByVal context As HttpContext, ByVal PageName As String, ByVal FunctionId As Integer, ByVal UserId As Integer) As Permission
        Dim Pages As Dictionary(Of String, Dictionary(Of Integer, Permission)) = GetPermissions(context, UserId)
        Dim Permissions As Dictionary(Of Integer, Permission) = Nothing
        If Pages.TryGetValue(PageName, Permissions) Then
            Dim p As Permission = Nothing
            If Permissions.TryGetValue(FunctionId, p) Then
                Return p
            End If
        End If
        Return Nothing
    End Function
    Public Shared Function GetPermission(ByVal context As HttpContext, ByVal FunctionId As Integer, ByVal UserId As Integer) As Permission
        Dim AllPermissions As Dictionary(Of Integer, Permission) = GetPermissionsAll(context, UserId)
        Dim p As Permission = Nothing
        If AllPermissions.TryGetValue(FunctionId, p) Then
            Return p
        End If
        Return Nothing
    End Function
    Public Shared Function GetPermissions(ByVal context As HttpContext, ByVal userid As Integer) As Dictionary(Of String, Dictionary(Of Integer, Permission))
        Dim list As Dictionary(Of String, Dictionary(Of Integer, Permission)) = CType(context.Session("Permission_PagesList"), Dictionary(Of String, Dictionary(Of Integer, Permission)))
        If list Is Nothing Then list = StashPermissions(context, userid)
        Return list
    End Function
    Public Shared Function GetPermissionsAll(ByVal context As HttpContext, ByVal userid As Integer) As Dictionary(Of Integer, Permission)
        Dim list As Dictionary(Of Integer, Permission) = CType(context.Session("Permission_List"), Dictionary(Of Integer, Permission))
        If list Is Nothing Then list = StashPermissionsAll(context, userid)
        Return list
    End Function
    Public Shared Function StashPermissionsAll(ByVal context As HttpContext, ByVal UserId As Integer) As Dictionary(Of Integer, Permission)
        Dim Permissions As Dictionary(Of Integer, Permission) = New Dictionary(Of Integer, Permission)

        ApplyInheritance(Permissions)
        AddAllPermissions(UserId, Permissions)

        context.Session("Permission_List") = Permissions
        Return Permissions
    End Function
    Public Shared Function StashPermissions(ByVal context As HttpContext, ByVal UserId As Integer) As Dictionary(Of String, Dictionary(Of Integer, Permission))
        Dim AllPages As New List(Of String)

        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            Using cmd.Connection
                cmd.CommandText = "select * from tblpage"
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While rd.Read()
                        AllPages.Add(DatabaseHelper.Peel_string(rd, "ServerName"))
                    End While
                End Using
            End Using
        End Using

        Dim Pages As Dictionary(Of String, Dictionary(Of Integer, Permission)) = New Dictionary(Of String, Dictionary(Of Integer, Permission))

        For Each PageName As String In AllPages
            Dim Permissions As Dictionary(Of Integer, Permission) = New Dictionary(Of Integer, Permission)

            AddPagePermissions(PageName, UserId, Permissions)
            ApplyInheritance(Permissions)
            Pages.Add(PageName, Permissions)
        Next
        context.Session("Permission_PagesList") = Pages
        Return Pages
    End Function
#End Region

    Public Shared Sub ApplyPermissions(ByVal context As HttpContext, ByVal PageName As String, ByVal UserId As Integer, ByVal Controls As Dictionary(Of String, Control))

        Dim Pages As Dictionary(Of String, Dictionary(Of Integer, Permission)) = GetPermissions(context, UserId)

        Dim Permissions As Dictionary(Of Integer, Permission) = Nothing
        If Pages.TryGetValue(PageName, Permissions) Then

            'add the controls
            For Each p As Permission In Permissions.Values
                For Each pc As PermissionControl In p.Controls
                    Dim ControlName As String = pc.ControlName
                    Dim c As Control = Nothing
                    If Controls.TryGetValue(ControlName, c) Then
                        pc.Control = c
                    End If
                Next
            Next

            'remove any permission for which there are no controls in the Controls list
            RemoveEmptyPermissions(Permissions)

            'only view permissions inherit from parents
            ApplyInheritance(Permissions)

            'apply the actual permissions to the controls
            ApplyPermissions(Permissions, Controls)

            ApplyFieldPermissions(Permissions, Controls)

            'remove the controls
            For Each p As Permission In Permissions.Values
                For Each pc As PermissionControl In p.Controls
                    pc.Control = Nothing
                Next
            Next
        End If
    End Sub
    Public Enum PermissionType
        View = 1
        Add = 2
        EditOwn = 3
        EditAll = 4
        DeleteOwn = 5
        DeleteAll = 6
    End Enum
    Public Shared Function ResolveValue(ByVal Value As Boolean, ByVal Action As Boolean) As Boolean
        If Action Then
            Return Not Value
        Else
            Return Value
        End If
    End Function
    Public Shared Sub ApplyPermissions(ByVal Permissions As Dictionary(Of Integer, Permission), ByVal Controls As Dictionary(Of String, Control))
        'for each permission
        Dim p As Permission = Nothing
        For Each i As Integer In Permissions.Keys
            If Permissions.TryGetValue(i, p) Then

                'for each of the permission's controls
                For Each pc As PermissionControl In p.Controls
                    Dim c As Control = pc.Control
                    If Not c Is Nothing Then
                        'if the control is a view control, and the permission has a view definition,
                        'apply permission
                        If p.HasPermissionType(PermissionType.View) And pc.PermissionType = PermissionType.View Then
                            c.Visible = ResolveValue(p.PermissionType(PermissionType.View), pc.Action)
                        End If

                        If TypeOf c Is GridBase2 Then
                            Dim grd As GridBase2 = CType(c, GridBase2)
                            grd.Permission = p
                        End If
                    End If
                Next
            End If
        Next
    End Sub
    Private Shared Sub ApplyFieldPermissions(ByVal Permissions As Dictionary(Of Integer, Permission), ByVal Controls As Dictionary(Of String, Control))
        For Each c As Control In Controls.Values
            If TypeOf c Is GridBase2 Then
                Dim grd As GridBase2 = CType(c, GridBase2)


                'for each permission with a control name beginning with the grid name
                Dim p As Permission = Nothing
                For Each i As Integer In Permissions.Keys
                    If Permissions.TryGetValue(i, p) Then
                        For Each s As String In p.ControlNames
                            If s.StartsWith(grd.ID) And s.Length > grd.ID.Length Then
                                grd.IllegalFields.Add(s.Substring(grd.ID.Length + 1))
                            End If
                        Next
                    End If
                Next
            End If
        Next
    End Sub
    Public Shared Sub RemoveEmptyPermissions(ByVal Permissions As Dictionary(Of Integer, Permission))
        'implement if necessary
    End Sub

    Public Shared Sub ApplyInheritance(ByVal Permissions As Dictionary(Of Integer, Permission))
        For Each i As Integer In Permissions.Keys()
            Dim p As Permission = Nothing
            If Permissions.TryGetValue(i, p) Then
                ApplyInheritanceRecursive(p, Permissions)
            End If
        Next
    End Sub
    Public Shared Sub ApplyInheritanceRecursive(ByVal p As Permission, ByVal Permissions As Dictionary(Of Integer, Permission))
        'only for view permissions, if there is none, apply the parent's value
        If Not p.HasPermissionType(PermissionType.View) AndAlso p.ParentFunctionId.HasValue Then
            Dim parent As Permission = Nothing
            If Permissions.TryGetValue(p.ParentFunctionId.Value, parent) Then
                ApplyInheritanceRecursive(parent, Permissions)
                If parent.HasPermissionType(PermissionType.View) Then
                    p.PermissionType(PermissionType.View) = parent.PermissionType(PermissionType.View)
                End If
            End If
        End If
    End Sub
    Public Shared Sub AddAllPermissions(ByVal UserId As Integer, ByVal Permissions As Dictionary(Of Integer, Permission))
        If Permissions Is Nothing Then
            Permissions = New Dictionary(Of Integer, Permission)
        End If

        'Get the defined permissions set
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Permissions_User_Get")
            DatabaseHelper.AddParameter(cmd, "UserId", UserId)

            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()

                    'get all of the permission functions
                    While rd.Read()
                        Dim FunctionId As Integer = DatabaseHelper.Peel_int(rd, "FunctionId")
                        Dim ParentFunctionId As Nullable(Of Integer) = DatabaseHelper.Peel_nint(rd, "ParentFunctionId")
                        Dim Value As Nullable(Of Boolean) = peel_bool_nullable(rd, "Value")
                        Dim PermissionTypeId As Integer = DatabaseHelper.Peel_int(rd, "PermissionTypeId")
                        Dim Level As Integer = DatabaseHelper.Peel_int(rd, "Level")


                        Dim NewP As New Permission
                        NewP.FunctionId = FunctionId
                        NewP.ParentFunctionId = ParentFunctionId
                        NewP.Level = Level
                        NewP.PermissionType(PermissionTypeId) = Value

                        Dim OldP As Permission = Nothing
                        If Permissions.TryGetValue(FunctionId, OldP) Then
                            'merge if already existant (due to multiple functions having the same control,
                            'multiple positions for the same user, or manually-set user permissions.)
                            If OldP.HasPermissionType(PermissionTypeId) Then
                                'resolve
                                OldP.PermissionType(PermissionTypeId) = ResolvePermission(OldP.PermissionType(PermissionTypeId), Value, OldP.Level, Level)
                            Else
                                OldP.PermissionType(PermissionTypeId) = Value
                            End If

                        Else
                            'add a new one
                            Permissions.Add(FunctionId, NewP)
                        End If
                    End While
                End Using
            End Using
        End Using
    End Sub
    Public Shared Sub AddPagePermissions(ByVal PageName As String, ByVal UserId As Integer, ByVal Permissions As Dictionary(Of Integer, Permission))
        If Permissions Is Nothing Then
            Permissions = New Dictionary(Of Integer, Permission)
        End If

        'Get the defined permissions set
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Permissions_UserPage_Get")
            DatabaseHelper.AddParameter(cmd, "UserId", UserId)
            DatabaseHelper.AddParameter(cmd, "PageName", PageName)

            Using cmd.Connection
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()

                    'get all of the permission functions
                    While rd.Read()
                        Dim FunctionId As Integer = DatabaseHelper.Peel_int(rd, "FunctionId")
                        Dim ParentFunctionId As Nullable(Of Integer) = DatabaseHelper.Peel_nint(rd, "ParentFunctionId")
                        Dim Value As Nullable(Of Boolean) = peel_bool_nullable(rd, "Value")
                        Dim PermissionTypeId As Integer = DatabaseHelper.Peel_int(rd, "PermissionTypeId")
                        Dim Level As Integer = DatabaseHelper.Peel_int(rd, "Level")


                        Dim NewP As New Permission
                        NewP.FunctionId = FunctionId
                        NewP.ParentFunctionId = ParentFunctionId
                        NewP.Level = Level
                        NewP.PermissionType(PermissionTypeId) = Value

                        Dim OldP As Permission = Nothing
                        If Permissions.TryGetValue(FunctionId, OldP) Then
                            'merge if already existant (due to multiple functions having the same control,
                            'multiple positions for the same user, or manually-set user permissions.)
                            If OldP.HasPermissionType(PermissionTypeId) Then
                                'resolve
                                OldP.PermissionType(PermissionTypeId) = ResolvePermission(OldP.PermissionType(PermissionTypeId), Value, OldP.Level, Level)
                            Else
                                OldP.PermissionType(PermissionTypeId) = Value
                            End If

                        Else
                            'add a new one
                            Permissions.Add(FunctionId, NewP)
                        End If
                    End While

                    rd.NextResult()

                    'get all the controls and associate them with their permission function
                    While rd.Read
                        Dim ControlName As String = DatabaseHelper.Peel_string(rd, "ControlName")
                        Dim FunctionId As Integer = DatabaseHelper.Peel_int(rd, "FunctionId")
                        Dim Action As Boolean = DatabaseHelper.Peel_bool(rd, "Action")
                        Dim PermissionTypeId As Integer = DatabaseHelper.Peel_int(rd, "PermissionTypeId")
                        Dim p1 As Permission = Nothing
                        If Permissions.TryGetValue(FunctionId, p1) Then
                            Dim pc As New PermissionControl
                            pc.ControlName = ControlName
                            pc.Action = Action
                            pc.PermissionType = PermissionTypeId
                            p1.Controls.Add(pc)
                        End If
                    End While
                End Using
            End Using
        End Using
    End Sub

    Public Shared Sub IndexControl(ByVal c As Control, ByVal Controls As Dictionary(Of String, Control))
        Controls.Add(c.GetType().Name, c)
    End Sub
    Public Shared Sub IndexControls(ByVal cs As Control(), ByVal Controls As Dictionary(Of String, Control))
        For Each c As Control In cs
            Controls.Add(c.GetType().Name, c)
        Next
    End Sub

    Public Shared Function ResolvePermission(ByVal bool1 As Nullable(Of Boolean), ByVal bool2 As Nullable(Of Boolean), ByVal Level1 As Integer, ByVal Level2 As Integer) As Nullable(Of Boolean)

        'return undefined if both are undefined
        If Not bool1.HasValue And Not bool2.HasValue Then
            Return Nothing

            'return value if both are the same
        ElseIf bool1.HasValue AndAlso bool1.Equals(bool2) Then
            Return bool1

            'default to the one that's defined if one isn't
        ElseIf Not bool1.HasValue Then
            Return bool2
        ElseIf Not bool2.HasValue Then
            Return bool1

            'default to the permission with the smallest level
            '   -user(Level 0) takes precidence over group(Level 1)
            '   -group(Level 1) takes precidence over usertype(Level 2)
        ElseIf Level1 < Level2 Then
            Return bool1
        ElseIf Level2 < Level1 Then
            Return bool2

            'otherwise, default to false
        Else
            Return False

        End If

    End Function

    Public Class PermissionControl
        Private _Action As Boolean
        Private _PermissionType As PermissionType
        Private _Control As Control
        Private _ControlName As String
        Public Property ControlName() As String
            Get
                Return _ControlName
            End Get
            Set(ByVal value As String)
                _ControlName = value
            End Set
        End Property

        Public Property PermissionType() As PermissionType
            Get
                Return _PermissionType
            End Get
            Set(ByVal value As PermissionType)
                _PermissionType = value
            End Set
        End Property
        Public Property Action() As Boolean
            Get
                Return _Action
            End Get
            Set(ByVal value As Boolean)
                _Action = value
            End Set
        End Property
        Public Sub New(ByVal c As Control, ByVal Action As Boolean, ByVal PermissionType As PermissionType)
            _Control = c
            _Action = Action
            _PermissionType = PermissionType
        End Sub
        Public Sub New()

        End Sub
        Public Property Control() As Control
            Get
                Return _Control
            End Get
            Set(ByVal value As Control)
                _Control = value
            End Set
        End Property
    End Class
    Public Class Permission
        Private _controls As List(Of PermissionControl) = New List(Of PermissionControl)
        Private _functionId As Integer
        Private _parentFunctionId As Nullable(Of Integer)
        Private _PermissionsTypes As New Dictionary(Of Integer, Boolean)
        Private _level As Integer

        Public Sub New()

        End Sub
        Public Function CanDo(ByVal OwnP As PermissionType, ByVal AllP As PermissionType, ByVal IsMy As Boolean) As Boolean
            Return (CanDo(OwnP) And IsMy) Or CanDo(AllP)
        End Function
        Public Function UserEdit(ByVal IsMy) As Boolean
            Return CanDo(PermissionHelper.PermissionType.EditOwn, PermissionHelper.PermissionType.EditAll, IsMy)
        End Function
        Public Function UserDelete(ByVal IsMy) As Boolean
            Return CanDo(PermissionHelper.PermissionType.DeleteOwn, PermissionHelper.PermissionType.DeleteAll, IsMy)
        End Function
        Public ReadOnly Property ControlNames() As List(Of String)
            Get
                Dim l As New List(Of String)
                For Each pc As PermissionControl In Controls
                    l.Add(pc.ControlName)
                Next
                Return l
            End Get
        End Property
        Public Sub New(ByVal Id As Integer, ByVal ParentId As Nullable(Of Integer), ByVal Level As Integer)
            _functionId = Id
            _parentFunctionId = ParentId
            _level = Level
        End Sub
        Public ReadOnly Property HasPermissionType(ByVal pt As PermissionType) As Boolean
            Get
                Return PermissionTypes.ContainsKey(pt)
            End Get
        End Property
        Public Function CanDo(ByVal pt As PermissionType) As Boolean
            If HasPermissionType(pt) Then
                Return PermissionTypes(pt)
            Else
                Return True
            End If
        End Function

        Public Property PermissionType(ByVal pt As PermissionType) As Nullable(Of Boolean)
            Get
                If HasPermissionType(pt) Then
                    Return PermissionTypes(pt)
                Else
                    Return CType(Nothing, Nullable(Of Boolean))
                End If
            End Get
            Set(ByVal value As Nullable(Of Boolean))
                If value.HasValue() Then
                    PermissionTypes(pt) = value
                End If
            End Set
        End Property
        Public Property PermissionTypes() As Dictionary(Of Integer, Boolean)
            Get
                Return _PermissionsTypes
            End Get
            Set(ByVal value As Dictionary(Of Integer, Boolean))
                _PermissionsTypes = value
            End Set
        End Property
        Public Property Controls() As List(Of PermissionControl)
            Get
                Return _controls
            End Get
            Set(ByVal value As List(Of PermissionControl))
                _controls = value
            End Set
        End Property
        Public Property FunctionId() As Integer
            Get
                Return _functionId
            End Get
            Set(ByVal value As Integer)
                _functionId = value
            End Set
        End Property
        Public Property ParentFunctionId() As Nullable(Of Integer)
            Get
                Return _parentFunctionId
            End Get
            Set(ByVal value As Nullable(Of Integer))
                _parentFunctionId = value
            End Set
        End Property
        Public Property Level() As Integer
            Get
                Return _level
            End Get
            Set(ByVal value As Integer)
                _level = value
            End Set
        End Property
    End Class
    Public Shared Sub DatabaseMakeControl(ByVal ControlName As String, ByVal PageName As String, ByVal FunctionName As String, ByVal PermissionTypeId As Integer, ByVal Action As Boolean)
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Permissions_Control_Make")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "ControlName", ControlName)
                DatabaseHelper.AddParameter(cmd, "PageName", PageName)
                DatabaseHelper.AddParameter(cmd, "FunctionName", FunctionName)
                DatabaseHelper.AddParameter(cmd, "PermissionTypeId", PermissionTypeId)
                DatabaseHelper.AddParameter(cmd, "Action", Action)

                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub
End Class
