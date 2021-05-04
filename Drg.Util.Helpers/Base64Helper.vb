Option Explicit On

Public Class Base64Helper

    Public Shared Function Base64Encode(ByVal str As String) As String
        Dim utf8 As New System.Text.UTF8Encoding
        Dim bytes As Byte() = utf8.GetBytes(str.Trim)

        Return Convert.ToBase64String(bytes)
    End Function

    Public Shared Function Base64Decode(ByVal str As String) As String
        Dim utf8 As New System.Text.UTF8Encoding
        Dim bytes As Byte() = Convert.FromBase64String(str.Trim)

        Return utf8.GetString(bytes)
    End Function

End Class
