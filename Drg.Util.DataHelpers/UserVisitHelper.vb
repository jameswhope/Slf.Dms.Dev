Option Explicit On

Imports Drg.Util.DataAccess

Public Class UserVisitHelper

    Public Shared Sub Delete(ByVal UserVisitID As Integer)

        '(1) remove user visit record
        DataHelper.Delete("tblUserVisit", "UserVisitID = " & UserVisitID)

    End Sub
    Public Shared Sub DeleteForUser(ByVal UserID As Integer)

        Dim UserVisitIDs() As Integer = DataHelper.FieldLookupIDs("tblUserVisit", _
            "UserVisitID", "UserID = " & UserID)

        Delete(UserVisitIDs)

    End Sub
    Public Shared Sub Delete(ByVal UserVisitIDs() As Integer)

        For Each UserVisitID As Integer In UserVisitIDs
            Delete(UserVisitID)
        Next

    End Sub
End Class