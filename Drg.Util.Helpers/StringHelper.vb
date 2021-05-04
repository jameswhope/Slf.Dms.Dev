Option Explicit On 

Imports System.Text
Imports System.Text.RegularExpressions

Public Class StringHelper

#Region "Enums"

    Public Enum Filter
        None
        NumericOnly
        AphaNumericOnly
    End Enum

    Public Enum ReturnCase
        Original
        Upper
        Lower
    End Enum

    Public Enum ValidationType
        URL
        Currency
        EmailAddress
        DateTime
        DateTimeMonth
        DateTimeYear
        Time
        ZipCode
        NumberLong
        NumberInteger
        NumberShort
        NumberByte
        NumberDouble
    End Enum

#End Region

    Public Shared Function SplitQuoted(ByVal Text As String, Optional ByVal Separator As String = ",", Optional ByVal Quotes As String = """") As ArrayList

        ' this is the result
        Dim res As New ArrayList()

        ' get the open and close chars, escape them for using in regular expressions
        Dim openChar As String = System.Text.RegularExpressions.Regex.Escape(Quotes.Chars(0))

        Dim closeChar As String = System.Text.RegularExpressions.Regex.Escape(Quotes.Chars(Quotes.Length - 1))

        ' build the patter that searches for both quoted and unquoted elements
        ' notice that the quoted element is defined by group #2 
        ' and the unquoted element is defined by group #3
        Dim pattern As String = "\s*(" & openChar & "([^" & closeChar & "]*)" & closeChar & "|([^" & Separator & "]+))\s*"

        ' search all the elements
        Dim m As System.Text.RegularExpressions.Match

        For Each m In System.Text.RegularExpressions.Regex.Matches(Text, pattern)
            ' get a reference to the unquoted element, if it's there
            Dim g3 As String = m.Groups(3).Value
            If Not (g3 Is Nothing) AndAlso g3.Length > 0 Then
                ' if the 3rd group is not null, then the element wasn't quoted
                res.Add(g3)
            Else
                ' get the quoted string, but without the quotes
                res.Add(m.Groups(2).Value)
            End If
        Next

        Return res

    End Function
    Public Shared Function FindAndMakeURLs(ByVal Value As String) As String
        Return FindAndMakeURLs(Value, String.Empty)
    End Function
    Public Shared Function FindAndMakeURLs(ByVal Value As String, ByVal CssClass As String) As String

        Dim s As New StringBuilder(Value)
        Dim p As New Regex("<a\s+href[^>]+>.*?</a>|((?:http|https|ftp):\S+(?<![.,?!]))")

        For Each m As Match In p.Matches(Value)

            If Not m.Value.Substring(0, 2) = "<a" Then 'found naked url

                s.Replace(m.Value, "<a class=""" & CssClass & """ href=""" & m.Value & """>" & m.Value & "</a>")

            End If

        Next

        Return s.ToString()

    End Function
    Public Shared Function Validate(ByVal Type As ValidationType, ByVal Value As String) As Boolean

        Dim str As String = Nothing

        Select Case Type
            Case ValidationType.URL

                str = "^(((ht|f)tp(s?))\://)?(www.|[a-zA-Z].)[a-zA-Z0-9\-\.]+\.(com|edu|gov|mil|net" _
                        & "|org|biz|info|name|museum|us|ca|uk)(\:[0-9]+)*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+" _
                        & "&%\$#\=~_\-]+))*$"

            Case ValidationType.Currency

                str = "^\d+(?:\.\d{0,2})?$"

            Case ValidationType.DateTime

                str = "(?n:^(?=\d)((?<month>(0?[13578])|1[02]|(0?[469]|11)(?!.31)|0?2(?(.29)(?=.29.(" _
                        & "(1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|(16|[2468][048]|[3579][26]" _
                        & ")00))|(?!.3[01])))(?<sep>[-./])(?<day>0?[1-9]|[12]\d|3[01])\k<sep>(?<year>" _
                        & "(1[6-9]|[2-9]\d)\d{2})(?(?=\x20\d)\x20|$))?(?<time>((0?[1-9]|1[012])(:[0-5]" _
                        & "\d){0,2}(?i:\x20[AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$)"

            Case ValidationType.Time

                str = "^((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))$|^([01]\d|2[0-3])(:[0-5]\d){1,2}$"

            Case ValidationType.EmailAddress

                str = "^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|" _
                        & "(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$"

            Case ValidationType.ZipCode

                str = "^[0-9]{5}([- /]?[0-9]{4})?$"

            Case ValidationType.DateTimeMonth

                Try

                    Dim Month As Byte = Byte.Parse(Value)

                    Return (Month >= 1 And Month <= 12)

                Catch ex As Exception
                    Return False
                End Try

            Case ValidationType.DateTimeYear

                Return (Value.Length = 4 And IsNumeric(Value))

            Case ValidationType.NumberLong

                Try

                    Dim NewValue As Long = Long.Parse(Value)

                    Return True

                Catch ex As Exception
                    Return False
                End Try

            Case ValidationType.NumberByte

                Try

                    Dim NewValue As Byte = Byte.Parse(Value)

                    Return True

                Catch ex As Exception
                    Return False
                End Try

            Case ValidationType.NumberInteger

                Try

                    Dim NewValue As Integer = Integer.Parse(Value)

                    Return True

                Catch ex As Exception
                    Return False
                End Try

            Case ValidationType.NumberShort

                Try

                    Dim NewValue As Short = Short.Parse(Value)

                    Return True

                Catch ex As Exception
                    Return False
                End Try

            Case ValidationType.NumberDouble

                Try

                    Dim NewValue As Double = Double.Parse(Value)

                    Return True

                Catch ex As Exception
                    Return False
                End Try

        End Select

        Return New Regex(str).IsMatch(Value)

    End Function
    Public Shared Function Acronym(ByVal Value As String, ByVal ReturnCase As ReturnCase) As String

        Dim strs() As String = Value.Split(" ")

        Acronym = Nothing

        For Each str As String In strs
            Select Case ReturnCase
                Case ReturnCase.Original
                    Acronym += Left(str, 1)
                Case ReturnCase.Upper
                    Acronym += Left(str, 1).ToUpper
                Case ReturnCase.Lower
                    Acronym += Left(str, 1).ToLower
            End Select
        Next

    End Function
    Public Shared Function ApplyFilter(ByVal Value As String, ByVal Filter As Filter) As String

        Dim i As Integer

        ApplyFilter = ""

        For i = 0 To Value.Length - 1

            Select Case Filter

                Case Filter.None
                    ApplyFilter += Value.Substring(i, 1)

                Case Filter.NumericOnly
                    If Char.IsDigit(Value.Substring(i, 1)) Then
                        ApplyFilter += Value.Substring(i, 1)
                    End If

                Case Filter.AphaNumericOnly
                    If Char.IsLetterOrDigit(Value.Substring(i, 1)) Then
                        ApplyFilter += Value.Substring(i, 1)
                    End If

            End Select

        Next

    End Function
    Public Shared Function PlaceInMask(ByVal Value As String, ByVal Mask As String) As String
        Return PlaceInMask(Value, Mask, "_", Filter.None, False)
    End Function
    Public Shared Function PlaceInMask(ByVal Value As String, ByVal Mask As String, ByVal MaskChar As Char, ByVal Filter As Filter) As String
        Return PlaceInMask(Value, Mask, MaskChar, Filter, False)
    End Function
    Public Shared Function PlaceInMask(ByVal Value As String, ByVal Mask As String, ByVal MaskChar As Char, ByVal Filter As Filter, ByVal DisplayEmpty As Boolean) As String

        Dim i As Integer = 0
        Dim j As Integer = 0

        PlaceInMask = ""

        Value = ApplyFilter(Value, Filter)

        For i = 0 To Mask.Length - 1

            If Not Mask.Substring(i, 1) = MaskChar Then
                PlaceInMask += Mask.Substring(i, 1)
            Else

                If j < Value.Length Then
                    PlaceInMask += Value.Substring(j, 1)
                    j += 1
                Else
                    PlaceInMask += MaskChar
                End If

            End If

        Next

        If Not DisplayEmpty And PlaceInMask = Mask Then
            PlaceInMask = ""
        End If

    End Function

#Region "Parse"

    Public Shared Function ParseBoolean(ByVal value As String) As Boolean
        Return ParseBoolean(value, False)
    End Function
    Public Shared Function ParseBoolean(ByVal value As String, ByVal defaultValue As Boolean) As Boolean
        Dim returnValue As Boolean

        If Not Boolean.TryParse(value, returnValue) Then
            returnValue = defaultValue
        End If

        Return returnValue
    End Function
    Public Shared Function ParseInt(ByVal value As String) As Integer
        Return ParseInt(value, 0)
    End Function
    Public Shared Function ParseInt(ByVal value As String, ByVal defaultValue As Integer) As Integer
        Dim returnValue As Integer

        If Not Integer.TryParse(value, returnValue) Then
            returnValue = defaultValue
        End If

        Return returnValue
    End Function

    Public Shared Function ParseDouble(ByVal value As String) As Double
        Return ParseDouble(value, 0.0)
    End Function

    Public Shared Function ParseDouble(ByVal value As String, ByVal defaultValue As Double) As Double
        Dim returnValue As Double

        If Not Double.TryParse(value, returnValue) Then
            returnValue = defaultValue
        End If

        Return returnValue
    End Function

    Public Shared Function ParseDateTime(ByVal value As String) As DateTime
        Return ParseDateTime(value, DateTime.Now)
    End Function

    Public Shared Function ParseDateTime(ByVal value As String, ByVal defaultValue As DateTime) As DateTime

        Dim returnValue As DateTime

        If Not DateTime.TryParse(value, returnValue) Then
            returnValue = defaultValue
        End If

        Return returnValue

    End Function

#End Region

End Class