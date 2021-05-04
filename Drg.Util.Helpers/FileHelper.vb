Option Explicit On 

Imports Microsoft.Win32

Public Class FileHelper

    Const ONE_KB As Double = 1024
    Const ONE_MB As Double = ONE_KB * 1024
    Const ONE_GB As Double = ONE_MB * 1024
    Const ONE_TB As Double = ONE_GB * 1024
    Const ONE_PB As Double = ONE_TB * 1024
    Const ONE_EB As Double = ONE_PB * 1024
    Const ONE_ZB As Double = ONE_EB * 1024
    Const ONE_YB As Double = ONE_ZB * 1024

    Public Shared Sub ForceValidate(ByVal Directory As String)

        If Not New IO.DirectoryInfo(Directory).Exists Then
            IO.Directory.CreateDirectory(Directory)
        End If

    End Sub
    Public Shared Function Normalize(ByVal Path As String) As String

        If Not Path.Substring(Path.Length - 1, 1) = "\" Then
            Return Path & "\"
        Else
            Return Path
        End If

    End Function
    Public Shared Function FormatBytes(ByVal num_bytes As Double) As String
        If num_bytes <= 999 Then
            ' Format in bytes.
            FormatBytes = Format$(num_bytes, "0") & " bytes"
        ElseIf num_bytes <= ONE_KB * 999 Then
            ' Format in KB.
            FormatBytes = ThreeNonZeroDigits(num_bytes / _
                ONE_KB) & " KB"
        ElseIf num_bytes <= ONE_MB * 999 Then
            ' Format in MB.
            FormatBytes = ThreeNonZeroDigits(num_bytes / _
                ONE_MB) & " MB"
        ElseIf num_bytes <= ONE_GB * 999 Then
            ' Format in GB.
            FormatBytes = ThreeNonZeroDigits(num_bytes / _
                ONE_GB) & " GB"
        ElseIf num_bytes <= ONE_TB * 999 Then
            ' Format in TB.
            FormatBytes = ThreeNonZeroDigits(num_bytes / _
                ONE_TB) & " TB"
        ElseIf num_bytes <= ONE_PB * 999 Then
            ' Format in PB.
            FormatBytes = ThreeNonZeroDigits(num_bytes / _
                ONE_PB) & " PB"
        ElseIf num_bytes <= ONE_EB * 999 Then
            ' Format in EB.
            FormatBytes = ThreeNonZeroDigits(num_bytes / _
                ONE_EB) & " EB"
        ElseIf num_bytes <= ONE_ZB * 999 Then
            ' Format in ZB.
            FormatBytes = ThreeNonZeroDigits(num_bytes / _
                ONE_ZB) & " ZB"
        Else
            ' Format in YB.
            FormatBytes = ThreeNonZeroDigits(num_bytes / _
                ONE_YB) & " YB"
        End If
    End Function
    Private Shared Function ThreeNonZeroDigits(ByVal value As Double) As String
        If value >= 100 Then
            ' No digits after the decimal.
            ThreeNonZeroDigits = Format$(CLng(value))
        ElseIf value >= 10 Then
            ' One digit after the decimal.
            ThreeNonZeroDigits = Format$(value, "0.0")
        Else
            ' Two digits after the decimal.
            ThreeNonZeroDigits = Format$(value, "0.00")
        End If
    End Function
    Public Shared Function IsFile(ByVal Path As String) As Boolean

        If IO.File.Exists(Path) Then
            Return True
        End If

    End Function
    Public Shared Function IsDirectory(ByVal Path As String) As Boolean

        If IO.Directory.Exists(Path) Then
            Return True
        End If

    End Function
    Public Shared Function Size(ByVal Path As String) As Long

        Try
            Return New IO.FileInfo(Path).Length
        Catch
            Return 0
        End Try

    End Function
    Public Shared Function Type(ByVal Extension As String) As String

        Try
            Return Registry.ClassesRoot.OpenSubKey(Extension).GetValue("Content Type", "application/unknown").ToString()
        Catch ex As Exception
            Return "application/unknown"
        End Try

    End Function
    Public Shared Function TypeOpener(ByVal Extension As String) As String

        Try

            Dim feData As String = Registry.ClassesRoot.OpenSubKey(Extension).GetValue(Nothing, "").ToString
            Dim feDataType As String = Registry.ClassesRoot.OpenSubKey(feData).GetValue(Nothing, "").ToString

            Return feDataType

        Catch ex As Exception
            Return ""
        Finally

        End Try

    End Function
    Public Shared Function TypeOpenerLocation(ByVal Extension As String) As String

        Try

            Dim feData As String = Registry.ClassesRoot.OpenSubKey(Extension).GetValue(Nothing, "").ToString
            Dim feDataLocation As String = Registry.ClassesRoot.OpenSubKey(feData & "\shell\open\command").GetValue(Nothing, "").ToString

            Dim SplitArray() As String

            SplitArray = Split(feDataLocation, """")

            If SplitArray(0).Trim.Length > 0 Then
                Return SplitArray(0).Replace("%1", "")
            Else
                Return SplitArray(1).Replace("%1", "")
            End If

        Catch ex As Exception
            Return ""
        End Try

    End Function
End Class