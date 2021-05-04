Option Explicit On

Imports Drg.Util.DataAccess

Public Class MediationHelper

    Public Shared Sub Delete(ByVal MediationID As Integer)

        '(1) delete the record
        DataHelper.Delete("tblMediation", "MediationID = " & MediationID)

    End Sub
    Public Shared Sub Delete(ByVal MediationIDs() As Integer)

        'loop through and delete each one
        For Each MediationID As Integer In MediationIDs
            Delete(MediationID)
        Next

    End Sub
End Class