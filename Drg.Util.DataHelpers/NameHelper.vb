Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess

Imports Slf.Dms.Records

Imports System.Data
Imports System.Collections.Generic

Public Class NameHelper

    Public Shared Function GetGender(ByVal Name As String) As String

        Dim Gender As String = DataHelper.FieldLookup("tblName", "Gender", "[Name] = '" & Name & "'")

        Return IIf(Gender.ToLower = "neutral", String.Empty, Gender)

    End Function
End Class