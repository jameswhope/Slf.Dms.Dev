Option Explicit On

Imports Drg.Util.DataAccess

Public Class TimeZoneHelper

    Public Shared Function GetLocalTime(ByVal PersonID As Integer) As DateTime

        Dim PersonTimeZoneID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPerson", _
            "WebTimeZoneID", "PersonID = " & PersonID))

        If Not PersonTimeZoneID = 0 Then 'has a timezone found

            Dim CurrentDifferenceFromUTC As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblTimeZone", _
                "FromUTC", "DBIsHere = 1"))

            Dim PersonDifferenceFromUTC As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblTimeZone", _
                "FromUTC", "TimeZoneID = " & PersonTimeZoneID))

            Return GetLocalTime(CurrentDifferenceFromUTC, PersonDifferenceFromUTC)

        Else
            Return Now
        End If

    End Function
    Public Shared Function GetLocalTime(ByVal CurrentDifferenceFromUTC As Integer, ByVal PersonDifferenceFromUTC As Integer) As DateTime
        Return Now.AddHours(PersonDifferenceFromUTC - CurrentDifferenceFromUTC)
    End Function
End Class