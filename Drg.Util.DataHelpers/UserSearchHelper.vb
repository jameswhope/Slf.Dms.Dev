Option Explicit On

Imports Drg.Util.DataAccess

Public Class UserSearchHelper

    Public Shared Sub Delete(ByVal UserSearchID As Integer)

        '(1) remove user search record
        DataHelper.Delete("tblUserSearch", "UserSearchID = " & UserSearchID)

    End Sub
    Public Shared Sub DeleteForUser(ByVal UserID As Integer)

        Dim UserSearchIDs() As Integer = DataHelper.FieldLookupIDs("tblUserSearch", _
            "UserSearchID", "UserID = " & UserID)

        Delete(UserSearchIDs)

    End Sub
    Public Shared Sub Delete(ByVal UserSearchIDs() As Integer)

        For Each UserSearchID As Integer In UserSearchIDs
            Delete(UserSearchID)
        Next

    End Sub
End Class