Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System.Collections.Generic
Imports System.Data.SqlClient

Partial Class project_structure_Default
    Inherits System.Web.UI.Page

#Region "Structures"
    Private Structure NegotiationPod
        Public PodID As String
        Public PodName As String
        Public DBPodID As Integer

        Public Sub New(ByVal _PodID As String, ByVal _PodName As String, ByVal _DBPodID As Integer)
            Me.PodID = _PodID
            Me.PodName = _PodName
            Me.DBPodID = _DBPodID
        End Sub
    End Structure
#End Region

#Region "Variables"
    Public UserID As Integer
    Private IsAdministrator As Boolean
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        IsAdministrator = NegotiationHelper.IsAdministrator(UserID)

        If Not IsPostBack Then
            'Page.ClientScript.RegisterStartupScript(GetType(Page), "LoadScript", "Sys.WebForms.PageRequestManager.getInstance().add_endRequest(HandleLoading);" & Page.ClientScript.GetPostBackEventReference(lnkLoad, Nothing) & ";", True)

            'Using cmd As New SqlCommand("stp_CacheView", ConnectionFactory.Create())
            '    Using cmd.Connection
            '        cmd.Connection.Open()

            '        cmd.CommandType = Data.CommandType.StoredProcedure

            '        cmd.Parameters.Clear()
            '        cmd.Parameters.AddWithValue("view", "vwNegotiationDistributionSource")

            '        cmd.ExecuteNonQuery()
            '    End Using
            'End Using
        End If
    End Sub

    'Private Sub LoadAllNegotiation()
    '    Using cmd As New SqlCommand("", ConnectionFactory.Create())
    '        Using cmd.Connection
    '            cmd.Connection.Open()

    '            hdnUserPool.Value = LoadUserPool(cmd).Replace("'", "\'")
    '            hdnRolePool.Value = LoadRolePool(cmd).Replace("'", "\'")
    '            hdnStructure.Value = LoadEntities(cmd).Replace("'", "\'")
    '            hdnGroups.Value = LoadUserGroups(cmd).Replace("'", "\'")
    '            hdnRoles.Value = LoadUserRoles(cmd).Replace("'", "\'")
    '        End Using
    '    End Using
    'End Sub

    'Private Function LoadEntities(ByVal cmd As SqlCommand) As String
    '    Dim entities As New List(Of String)()
    '    Dim parentID As String
    '    Dim tempUserID As String
    '    Dim clientX As String
    '    Dim clientY As String

    '    If IsAdministrator Then
    '        cmd.CommandText = "SELECT NegotiationEntityID, [Type], [Name], ParentNegotiationEntityID, UserID, ClientX, ClientY FROM tblNegotiationEntity WHERE Deleted = 0 ORDER BY ParentNegotiationEntityID, NegotiationEntityID"
    '    Else
    '        cmd.CommandText = "SELECT NegotiationEntityID, [Type], [Name], ParentNegotiationEntityID, UserID, ClientX, ClientY FROM tblNegotiationEntity WHERE Deleted = 0 and (UserID = " & UserID & " or ParentNegotiationEntityID in (" & String.Join(", ", GetFunctionalIDs().ToArray()) & ")) ORDER BY ParentNegotiationEntityID, NegotiationEntityID"
    '    End If

    '    Using reader As SqlDataReader = cmd.ExecuteReader()
    '        While reader.Read()
    '            If reader("ParentNegotiationEntityID") Is DBNull.Value Then
    '                parentID = "null"
    '            Else
    '                parentID = reader("ParentNegotiationEntityID")
    '            End If

    '            If reader("UserID") Is DBNull.Value Then
    '                tempUserID = "null"
    '            Else
    '                tempUserID = reader("UserID")
    '            End If

    '            If reader("ClientX") Is DBNull.Value Then
    '                clientX = "null"
    '            Else
    '                clientX = reader("ClientX")
    '            End If

    '            If reader("ClientY") Is DBNull.Value Then
    '                clientY = "null"
    '            Else
    '                clientY = reader("ClientY")
    '            End If

    '            entities.Add(reader("NegotiationEntityID") & "|" & reader("Type") & "|" & reader("Name") & "|" & parentID & "|" & tempUserID & "|" & clientX & "|" & clientY & "|" & GetFilters(reader("NegotiationEntityID")) & "|" & HasOwnFilter(reader("NegotiationEntityID")))
    '        End While
    '    End Using

    '    Return String.Join(";", entities.ToArray())
    'End Function

    'Private Function GetFunctionalIDs() As List(Of String)
    '    Dim ids As New List(Of String)()
    '    Dim hasChildren As Boolean = True

    '    ids.Add("-1")

    '    Using cmd As New SqlCommand("", ConnectionFactory.Create())
    '        Using cmd.Connection
    '            cmd.Connection.Open()

    '            While hasChildren
    '                hasChildren = False

    '                If IsAdministrator Then
    '                    cmd.CommandText = "SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE Deleted = 0"
    '                Else
    '                    cmd.CommandText = "SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE Deleted = 0 and (UserID = " & UserID & " or ParentNegotiationEntityID in (" & String.Join(", ", ids.ToArray()) & "))"
    '                End If

    '                Using reader As SqlDataReader = cmd.ExecuteReader()
    '                    While reader.Read()
    '                        If Not ids.Contains(reader("NegotiationEntityID")) Then
    '                            ids.Add(reader("NegotiationEntityID"))

    '                            hasChildren = True
    '                        End If
    '                    End While
    '                End Using
    '            End While
    '        End Using
    '    End Using

    '    Return ids
    'End Function

    'Private Function HasOwnFilter(ByVal entityID As String) As Boolean
    '    Using cmd As New SqlCommand("SELECT count(*) FROM tblNegotiationFilterXref WHERE Deleted = 0 and EntityID = " & entityID, ConnectionFactory.Create())
    '        Using cmd.Connection
    '            cmd.Connection.Open()

    '            If Integer.Parse(cmd.ExecuteScalar()) > 0 Then
    '                Return True
    '            End If
    '        End Using
    '    End Using

    '    Return False
    'End Function

    'Private Function GetFilters(ByVal entityID As String) As String
    '    Dim list As New List(Of String)()

    '    list.Add("-1")

    '    Using cmd As New SqlCommand("SELECT isnull(FilterID, 0) as FilterID FROM tblNegotiationFilterXref WHERE Deleted = 0 and EntityID = " & entityID, ConnectionFactory.Create())
    '        Using cmd.Connection
    '            cmd.Connection.Open()

    '            Using reader As SqlDataReader = cmd.ExecuteReader()
    '                While reader.Read()
    '                    list.Add(reader("FilterID"))
    '                End While
    '            End Using
    '        End Using
    '    End Using

    '    AddChildFiltersRec(list, entityID)

    '    Return String.Join(",", list.ToArray())
    'End Function

    'Private Sub AddChildFiltersRec(ByRef list As List(Of String), ByVal entityID As String)
    '    Dim ids As New List(Of String)

    '    Using cmd As New SqlCommand("SELECT NegotiationEntityID FROM tblNegotiationEntity WHERE ParentNegotiationEntityID = " & entityID, ConnectionFactory.Create())
    '        Using cmd.Connection
    '            cmd.Connection.Open()

    '            Using reader As SqlDataReader = cmd.ExecuteReader()
    '                While reader.Read()
    '                    ids.Add(reader("NegotiationEntityID"))
    '                End While
    '            End Using
    '        End Using
    '    End Using

    '    If ids.Count > 0 Then
    '        Using cmd As New SqlCommand("SELECT isnull(xr.FilterID, 0) as FilterID FROM tblNegotiationFilterXref as xr inner join tblNegotiationFilters as nf on nf.FilterID = xr.FilterID WHERE xr.Deleted = 0 and nf.Deleted = 0 and nf.FilterType = 'leaf' and xr.EntityID in (" & String.Join(", ", ids.ToArray()) & ")", ConnectionFactory.Create())
    '            Using cmd.Connection
    '                cmd.Connection.Open()

    '                Using reader As SqlDataReader = cmd.ExecuteReader()
    '                    While reader.Read()
    '                        If Not list.Contains(reader("FilterID")) Then
    '                            list.Add(reader("FilterID"))
    '                        End If
    '                    End While
    '                End Using
    '            End Using
    '        End Using

    '        For Each id As Integer In ids
    '            AddChildFiltersRec(list, id)
    '        Next
    '    End If
    'End Sub

    'Private Function LoadUserGroups(ByVal cmd As SqlCommand) As String
    '    Dim groupStr As String = ""
    '    Dim oldID As String

    '    cmd.CommandText = "SELECT ug.NegotiationEntityID, g.GroupName FROM tblNegotiationEntityGroup as ug inner join " & _
    '        "tblNegotiationGroup as g on g.NegotiationGroupID = ug.NegotiationGroupID ORDER BY ug.NegotiationEntityID"

    '    Using reader As SqlDataReader = cmd.ExecuteReader()
    '        While reader.Read()
    '            If reader("NegotiationEntityID") = oldID Then
    '                groupStr += "|" & reader("GroupName")
    '            Else
    '                groupStr += ";" & reader("NegotiationEntityID") & "|" & reader("GroupName")
    '            End If

    '            oldID = reader("NegotiationEntityID")
    '        End While
    '    End Using

    '    If groupStr.Length > 0 Then
    '        groupStr = groupStr.Remove(0, 1)
    '    End If

    '    Return groupStr
    'End Function

    'Private Function LoadUserRoles(ByVal cmd As SqlCommand) As String
    '    Dim roleStr As String = ""

    '    Dim oldID As String

    '    cmd.CommandText = "SELECT NegotiationEntityID, NegotiationRoleID FROM tblNegotiationEntityRole ORDER BY NegotiationEntityID, NegotiationRoleID"

    '    Using reader As SqlDataReader = cmd.ExecuteReader()
    '        While reader.Read()
    '            If reader("NegotiationEntityID") = oldID Then
    '                roleStr += "|" & reader("NegotiationRoleID")
    '            Else
    '                roleStr += ";" & reader("NegotiationEntityID") & "|" & reader("NegotiationRoleID")
    '            End If

    '            oldID = reader("NegotiationEntityID")
    '        End While
    '    End Using

    '    If roleStr.Length > 0 Then
    '        roleStr = roleStr.Remove(0, 1)
    '    End If

    '    Return roleStr
    'End Function

    'Private Function LoadUserPool(ByVal cmd As SqlCommand) As String
    '    Dim neg As String = ""

    '    cmd.CommandText = "SELECT UserID, FirstName + ' ' + LastName as [Name] FROM tblUser WHERE UserGroupID = 4 ORDER BY LastName, FirstName"

    '    Using reader As SqlDataReader = cmd.ExecuteReader()
    '        While reader.Read()
    '            If reader("Name").ToString().Length > 0 Then
    '                neg += reader("UserID") & "|" & reader("Name") & ";"
    '            End If
    '        End While
    '    End Using

    '    Return neg
    'End Function

    'Private Function LoadRolePool(ByVal cmd As SqlCommand) As String
    '    Dim roles As String = ""

    '    cmd.CommandText = "SELECT NegotiationRoleID, RoleName FROM tblNegotiationRole ORDER BY RoleName"

    '    Using reader As SqlDataReader = cmd.ExecuteReader()
    '        While reader.Read()
    '            If reader("RoleName").ToString().Length > 0 Then
    '                roles += reader("NegotiationRoleID") & "|" & reader("RoleName") & ";"
    '            End If
    '        End While
    '    End Using

    '    Return roles
    'End Function

    'Private Sub SaveGroups(ByVal cmd As SqlCommand, ByVal nuid As Integer, ByVal groups() As String)
    '    Dim groupID As Integer

    '    For Each group As String In groups
    '        If group.Length > 0 Then
    '            cmd.CommandText = "SELECT NegotiationGroupID FROM tblNegotiationGroup WHERE GroupName = '" & group.Replace("'", "''") & "'"

    '            If Not Integer.TryParse(cmd.ExecuteScalar(), groupID) Then
    '                cmd.CommandText = "INSERT INTO tblNegotiationGroup (GroupName) VALUES ('" & group.Replace("'", "''") & "') SELECT scope_identity()"
    '                groupID = Integer.Parse(cmd.ExecuteScalar())
    '            End If

    '            cmd.CommandText = "INSERT INTO tblNegotiationEntityGroup (NegotiationEntityID, NegotiationGroupID) VALUES (" & nuid & ", " & groupID & ")"
    '            cmd.ExecuteNonQuery()
    '        End If
    '    Next
    'End Sub

    'Private Sub SaveRoles(ByVal cmd As SqlCommand, ByVal nuid As Integer, ByVal roles() As String)
    '    For Each roleID As String In roles
    '        If roleID.Length > 0 Then
    '            cmd.CommandText = "INSERT INTO tblNegotiationEntityRole (NegotiationEntityID, NegotiationRoleID) VALUES (" & nuid & ", " & roleID & ")"
    '            cmd.ExecuteNonQuery()
    '        End If
    '    Next
    'End Sub

    'Private Sub SaveNegotiationStructure()
    '    Dim idChanges As New Dictionary(Of String, Integer)()
    '    Dim idTracker As New Dictionary(Of Integer, String)()
    '    Dim entities() As String = hdnNegotiation.Value.Split(";")
    '    Dim entitySplit() As String
    '    Dim id As String
    '    Dim type As String
    '    Dim name As String
    '    Dim parentID As String
    '    Dim parentType As String
    '    Dim uID As String
    '    Dim clientX As String
    '    Dim clientY As String
    '    Dim roles As String
    '    Dim groups As String
    '    Dim count As Integer
    '    Dim tempID As Integer

    '    Using cmd As New SqlCommand("UPDATE tblNegotiationEntity SET Deleted = null WHERE Deleted = 0 and (UserID = " & UserID & " or ParentNegotiationEntityID in (" & String.Join(", ", GetFunctionalIDs().ToArray()) & "))", ConnectionFactory.Create())
    '        Using cmd.Connection
    '            cmd.Connection.Open()

    '            If IsAdministrator Then
    '                cmd.CommandText = "UPDATE tblNegotiationEntity SET Deleted = null WHERE Deleted = 0"
    '            End If

    '            cmd.ExecuteNonQuery()

    '            cmd.CommandText = "TRUNCATE TABLE tblNegotiationGroup"
    '            cmd.ExecuteNonQuery()

    '            cmd.CommandText = "TRUNCATE TABLE tblNegotiationEntityGroup"
    '            cmd.ExecuteNonQuery()

    '            cmd.CommandText = "TRUNCATE TABLE tblNegotiationEntityRole"
    '            cmd.ExecuteNonQuery()

    '            For Each entity As String In entities
    '                entitySplit = entity.Split("|")

    '                If entitySplit.Length = 10 Then
    '                    id = entitySplit(0)
    '                    type = entitySplit(1)
    '                    name = entitySplit(2)
    '                    parentID = entitySplit(3)
    '                    parentType = entitySplit(4)
    '                    uID = entitySplit(5)
    '                    clientX = entitySplit(6)
    '                    clientY = entitySplit(7)
    '                    roles = entitySplit(8)
    '                    groups = entitySplit(9)

    '                    count = 0

    '                    If Not id.Contains("Temp") Then
    '                        cmd.CommandText = "SELECT count(*) FROM tblNegotiationEntity WHERE Deleted is null and NegotiationEntityID = " & id

    '                        count = Integer.Parse(cmd.ExecuteScalar())
    '                    End If

    '                    If count = 1 Then
    '                        cmd.CommandText = "SELECT count(*) FROM tblNegotiationEntity WHERE Deleted is null and NegotiationEntityID = " & id & _
    '                            IIf(Not uID = "null" AndAlso uID = UserID, "", " and ParentNegotiationEntityID " & IIf(parentID.Contains("Temp"), "is null", DBPrepare(parentID, False)))

    '                        If Integer.Parse(cmd.ExecuteScalar()) = 0 Then
    '                            cmd.CommandText = "UPDATE tblNegotiationFilterXref SET EntityID = null WHERE EntityID = " & id

    '                            cmd.ExecuteNonQuery()
    '                        End If

    '                        cmd.CommandText = "UPDATE tblNegotiationEntity SET [Type] " & DBPrepUpdate(type) & ", [Name] " & DBPrepUpdate(name) & _
    '                            ", ParentNegotiationEntityID " & IIf(Not uID = "null" AndAlso uID = UserID, " = ParentNegotiationEntityID", IIf(parentID.Contains("Temp"), "= null", DBPrepUpdate(parentID, False))) & _
    '                            ", ParentType " & IIf(Not uID = "null" AndAlso uID = UserID, " = ParentType", DBPrepUpdate(parentType)) & ", UserID " & DBPrepUpdate(uID, False) & ", ClientX " & _
    '                            IIf(Not uID = "null" AndAlso uID = UserID, DBPrepUpdate(clientX, False), " = ClientX") & ", ClientY " & IIf(Not uID = "null" AndAlso uID = UserID, DBPrepUpdate(clientY, False), " = ClientY") & _
    '                            ", LastModified = getdate(), LastModifiedBy = " & uID & ", Deleted = 0 WHERE NegotiationEntityID = " & id

    '                        cmd.ExecuteNonQuery()

    '                        If parentID.Contains("Temp") Then
    '                            idTracker.Add(id, parentID)
    '                        End If
    '                    Else
    '                        cmd.CommandText = "INSERT INTO tblNegotiationEntity ([Type], [Name], ParentNegotiationEntityID, ParentType, UserID, " & _
    '                            "ClientX, ClientY, Created, CreatedBy, LastModified, LastModifiedBy, Deleted) VALUES (" & DBPrepInsert(type) & ", " & _
    '                            DBPrepInsert(name) & ", " & IIf(parentID.Contains("Temp"), "null", DBPrepInsert(parentID, False)) & ", " & DBPrepInsert(parentType) & ", " & _
    '                            DBPrepInsert(uID, False) & ", " & DBPrepInsert(clientX, False) & ", " & DBPrepInsert(clientY, False) & _
    '                            ", getdate(), " & UserID & ", getdate(), " & UserID & ", 0) SELECT scope_identity()"

    '                        tempID = cmd.ExecuteScalar()

    '                        idChanges.Add(id, tempID)

    '                        id = tempID

    '                        If parentID.Contains("Temp") Then
    '                            idTracker.Add(id, parentID)
    '                        End If
    '                    End If

    '                    SaveRoles(cmd, id, roles.Split("&"))
    '                    SaveGroups(cmd, id, groups.Split("&"))
    '                End If
    '            Next

    '            For Each id In idTracker.Keys
    '                cmd.CommandText = "UPDATE tblNegotiationEntity SET ParentNegotiationEntityID = " & idChanges(idTracker(id)) & _
    '                    " WHERE NegotiationEntityID = " & id

    '                cmd.ExecuteNonQuery()
    '            Next

    '            cmd.CommandText = "UPDATE tblNegotiationEntity SET Deleted = 1 WHERE Deleted is null"
    '            cmd.ExecuteNonQuery()

    '            cmd.CommandText = "UPDATE xr SET xr.EntityID = null FROM tblNegotiationFilterXref as xr inner join tblNegotiationEntity as ne on ne.NegotiationEntityID = xr.EntityID WHERE ne.Deleted = 1"
    '            cmd.ExecuteNonQuery()
    '        End Using
    '    End Using
    'End Sub

    'Private Function DBPrepare(ByVal str As String, Optional ByVal isStr As Boolean = True) As String
    '    If str.ToLower() = "null" Then
    '        Return "is null"
    '    ElseIf isStr Then
    '        Return "= '" & str & "'"
    '    End If

    '    Return "= " & str
    'End Function

    'Private Function DBPrepInsert(ByVal str As String, Optional ByVal isStr As Boolean = True) As String
    '    If str.ToLower() = "null" Then
    '        Return "null"
    '    ElseIf isStr Then
    '        Return "'" & str & "'"
    '    End If

    '    Return str
    'End Function

    'Private Function DBPrepUpdate(ByVal str As String, Optional ByVal isStr As Boolean = True) As String
    '    If str.ToLower() = "null" Then
    '        Return "= null"
    '    ElseIf isStr Then
    '        Return "= '" & str & "'"
    '    End If

    '    Return "= " & str
    'End Function

    'Public Sub Unlock()
    '    If NegotiationHelper.IsLockedBy() = UserID Then
    '        NegotiationHelper.Unlock(UserID)
    '    End If
    'End Sub

    'Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click
    '    SaveNegotiationStructure()
    '    LoadAllNegotiation()
    '    Unlock()
    'End Sub

    'Protected Sub lnkLoad_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLoad.Click
    '    LoadAllNegotiation()
    'End Sub
End Class