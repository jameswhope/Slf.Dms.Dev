Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Partial Class admin_users_usertype_permissions_default
    Inherits PermissionPage


#Region "Variables"

    Private UserID As Integer
    Protected UserTypeId As Integer
    Private qs As QueryStringCollection

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then

            UserTypeId = DataHelper.Nz_int(qs("id"))

        End If

        If Not IsPostBack Then

            Requery()

            lnkUser.InnerHtml = DataHelper.FieldLookup("tblUserType", "Name", "UserTypeId=" & UserTypeId)
            lnkUser.HRef = ResolveUrl("~/admin/users/usertype/?id=" & UserTypeId)

        End If

        SetRollups()

    End Sub
    Public Function GetBoolString(ByVal b As Nullable(Of Boolean), ByVal param As String) As String
        Return GetBoolString(b, False, param)
    End Function
    Public Function GetBoolString(ByVal b As Nullable(Of Boolean), ByVal Switch As Boolean, ByVal param As String) As String
        Return GetBoolString(b, Switch, False, param)
    End Function
    Public Function GetBoolString(ByVal b As Nullable(Of Boolean), ByVal Switch As Boolean, ByVal NullVal As Boolean, ByVal param As String) As String
        If Not b.HasValue Then
            b = NullVal
        Else
            If Switch Then b = Not b.Value
        End If
        Return IIf(b, param & "=""true""", "")
    End Function
    'Protected Function GetRootImg(ByVal p As GridPermission) As String
    '    If p.ParentId.HasValue Then
    '        Return "<img src=""" & ResolveUrl("~/images/" & IIf(p.IsLast, "rootend.png", "rootconnector.png")) & """/>"
    '    Else
    '        Return ""
    '    End If
    'End Function
    Private Sub Requery()
        Dim Permissions As New Dictionary(Of Integer, GridPermission)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Permissions_UserTypeFunctions_Get")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "UserTypeId", UserTypeId)
                DatabaseHelper.AddParameter(cmd, "DefinedOnly", chkDefinedOnly.Checked)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    While (rd.Read)
                        Dim FunctionId As Integer = DatabaseHelper.Peel_int(rd, "FunctionId")
                        Dim ParentFunctionId As Nullable(Of Integer) = DatabaseHelper.Peel_nint(rd, "ParentFunctionId")
                        Dim FunctionName As String = DatabaseHelper.Peel_string(rd, "FunctionName")

                        Dim Value As Nullable(Of Boolean) = LocalHelper.peel_bool_nullable(rd, "Value")
                        Dim PermissionTypeId As Integer = DatabaseHelper.Peel_int(rd, "PermissionTypeId")
                        Dim IsOperation As Boolean = DatabaseHelper.Peel_bool(rd, "IsOperation")
                        Dim IsSystem As Boolean = DatabaseHelper.Peel_bool(rd, "IsSystem")

                        Dim OldP As GridPermission = Nothing
                        If Permissions.TryGetValue(FunctionId, OldP) Then
                            'merge if already existant (due to multiple functions having the same control,
                            'multiple positions for the same user, or manually-set user permissions.)
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
                        Else
                            'add a new one
                            Dim NewP As New GridPermission
                            NewP.Id = FunctionId
                            NewP.Name = FunctionName
                            NewP.ParentId = ParentFunctionId
                            NewP.IsOperation = IsOperation
                            NewP.IsSystem = IsSystem
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
                End Using
            End Using
        End Using

        Dim ToRemove As New List(Of Integer)
        'Dim ToAdd As New List(Of GridPermission)

        'add child permissions to their parent's children list
        For Each p As GridPermission In Permissions.Values
            If p.ParentId.HasValue Then

                Dim Parent As GridPermission = Nothing

                If Permissions.TryGetValue(p.ParentId, Parent) Then
                    Parent.Children.Add(p)
                Else
                    'try to find it.  If a child is defined but a parent isn't, the parent still needs to be shown
                    'FindAndAddParentsRecursive(p, ToAdd)
                End If

                'removes anything not root
                ToRemove.Add(p.Id)
            End If
        Next

        For Each s As Integer In ToRemove
            Permissions.Remove(s)
        Next

        'For Each p As GridPermission In ToAdd
        'Permissions.Add(p.Id, p)
        'Next

        If Permissions.Count > 0 Then
            rpPermissions.DataSource = Permissions.Values
            rpPermissions.DataBind()
        End If
        pnlNone.Visible = Permissions.Count = 0
        rpPermissions.Visible = Permissions.Count > 0
    End Sub

    'Private Sub FindAndAddParentsRecursive(ByVal p As GridPermission, ByVal lst As List(Of GridPermission))
    '    Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
    '        Using cmd.Connection
    '            cmd.CommandText = "SELECT Name, IsOperation, ParentFunctionId FROM tblFunction WHERE FunctionId=@functionId"
    '            DatabaseHelper.AddParameter(cmd, "functionId", p.ParentId)
    '            cmd.Connection.Open()
    '            Using rd As IDataReader = cmd.ExecuteReader(CommandBehavior.SingleRow)
    '                If rd.Read Then
    '                    Dim FunctionName As String = DatabaseHelper.Peel_string(rd, "Name")
    '                    Dim IsOperation As Boolean = DatabaseHelper.Peel_bool(rd, "IsOperation")
    '                    Dim ParentFunctionId As Nullable(Of Integer) = DatabaseHelper.Peel_nint(rd, "ParentFunctionId")
    '                    Dim newP As New GridPermission(p.ParentId, ParentFunctionId, FunctionName, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, IsOperation)
    '                    lst.Add(newP)
    '                    newP.Children.Add(p)
    '                    If newP.ParentId.HasValue Then
    '                        FindAndAddParentsRecursive(newP, lst)
    '                    End If
    '                End If
    '            End Using
    '        End Using
    '    End Using
    'End Sub

    Private Sub AddRecursive(ByVal p As GridPermission, ByVal lst As List(Of GridPermission), ByVal Level As Integer)
        p.Level = Level
        lst.Add(p)
        If p.Children.Count > 0 Then
            For Each child As GridPermission In p.Children
                AddRecursive(child, lst, Level + 1)
            Next
            p.Children(p.Children.Count - 1).IsLast = True
        End If

    End Sub

    Private Sub SetRollups()

        Dim CommonTasks As List(Of String) = CType(Master, admin_users_usertype_usertype).CommonTasks

        'add applicant tasks
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save user type</a>")
        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_SaveAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save_close.png") & """ align=""absmiddle""/>Save and close</a>")

    End Sub
    Private Sub Refresh()
        Response.Redirect(Request.Url.AbsoluteUri)
    End Sub
    Private Sub Close()
        Response.Redirect("~/admin/users/")
    End Sub
    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""idonly""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Private Sub AddParameter(ByVal cmd As IDbCommand, ByVal name As String, ByVal src As String)
        If src.Length = 0 Then
            DatabaseHelper.AddParameter(cmd, name, DBNull.Value, DbType.Boolean)
        Else
            DatabaseHelper.AddParameter(cmd, name, IIf(src = "1", True, False), DbType.Boolean)
        End If
    End Sub
    Private Sub Save()
        Dim Permissions As String() = txtPermissionsToSave.Value.Split("|")
        For Each Permission As String In Permissions
            Dim parts As String() = Permission.Split(",")
            Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_Permissions_UserType_IoU")
                Using cmd.Connection
                    DatabaseHelper.AddParameter(cmd, "UserTypeId", UserTypeId)
                    DatabaseHelper.AddParameter(cmd, "FunctionId", parts(0))

                    AddParameter(cmd, "CanView", parts(1))
                    AddParameter(cmd, "CanAdd", parts(2))
                    AddParameter(cmd, "CanEditOwn", parts(3))
                    AddParameter(cmd, "CanEditAll", parts(4))
                    AddParameter(cmd, "CanDeleteOwn", parts(5))
                    AddParameter(cmd, "CanDeleteAll", parts(6))

                    cmd.Connection.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        Next
    End Sub
    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        Close()
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
        Save()
        Refresh()
    End Sub
    Protected Sub lnkSaveAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveAndClose.Click
        Save()
        Close()
    End Sub

    Protected Sub chkDefinedOnly_ServerChange(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkDefinedOnly.ServerChange
        Requery()
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(pnlBody, c, "Admin-Users-Group Single Record-Permissions")
    End Sub
End Class