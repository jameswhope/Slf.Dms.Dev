Imports Microsoft.VisualBasic

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic

Imports Drg.Util.Helpers
Imports Drg.Util.DataHelpers
Imports Drg.Util.DataAccess

Imports Slf.Dms.Controls

Imports AssistedSolutions.WebControls


Public Class Pair(Of C)
    Private _First As C
    Private _Second As C

    Public Property First() As C
        Get
            Return _First
        End Get
        Set(ByVal value As C)
            _First = value
        End Set
    End Property
    Public Property Second() As C
        Get
            Return _Second
        End Get
        Set(ByVal value As C)
            _Second = value
        End Set
    End Property
    Public Sub New()

    End Sub
    Public Sub New(ByVal First As C, ByVal Second As C)
        _First = First
        _Second = Second
    End Sub
End Class


Public Class LocalHelper

    Public Enum VirtualPathTypes
        Clients = 0
        Leads
    End Enum

    Public Shared Function ColorFromAhsb(ByVal a As Integer, ByVal h As Single, ByVal s As Single, ByVal b As Single) As Color
        If 0 > a OrElse 255 < a Then
            Throw New ArgumentOutOfRangeException("a", a)
        End If
        If 0.0F > h OrElse 360.0F < h Then
            Throw New ArgumentOutOfRangeException("h", h)
        End If
        If 0.0F > s OrElse 1.0F < s Then
            Throw New ArgumentOutOfRangeException("s", s)
        End If
        If 0.0F > b OrElse 1.0F < b Then
            Throw New ArgumentOutOfRangeException("b", b)
        End If
        If 0 = s Then
            Return Color.FromArgb(a, Convert.ToInt32(b * 255), Convert.ToInt32(b * 255), Convert.ToInt32(b * 255))
        End If
        Dim fMax As Single
        Dim fMid As Single
        Dim fMin As Single
        Dim iSextant As Integer
        Dim iMax As Integer
        Dim iMid As Integer
        Dim iMin As Integer
        If 0.5 < b Then
            fMax = b - (b * s) + s
            fMin = b + (b * s) - s
        Else
            fMax = b + (b * s)
            fMin = b - (b * s)
        End If
        iSextant = CType(Math.Floor(h / 60.0F), Integer)
        If 300.0F <= h Then
            h -= 360.0F
        End If
        h /= 60.0F
        h -= 2.0F * CType(Math.Floor(((iSextant + 1.0F) Mod 6.0F) / 2.0F), Single)
        If 0 = iSextant Mod 2 Then
            fMid = h * (fMax - fMin) + fMin
        Else
            fMid = fMin - h * (fMax - fMin)
        End If
        iMax = Convert.ToInt32(fMax * 255)
        iMid = Convert.ToInt32(fMid * 255)
        iMin = Convert.ToInt32(fMin * 255)
        Select Case iSextant
            Case 1
                Return Color.FromArgb(a, iMid, iMax, iMin)
            Case 2
                Return Color.FromArgb(a, iMin, iMax, iMid)
            Case 3
                Return Color.FromArgb(a, iMin, iMid, iMax)
            Case 4
                Return Color.FromArgb(a, iMid, iMin, iMax)
            Case 5
                Return Color.FromArgb(a, iMax, iMin, iMid)
            Case Else
                Return Color.FromArgb(a, iMax, iMid, iMin)
        End Select
    End Function
    Public Shared Function AdjustColor(ByVal c As Color, ByVal factor As Single) As String
        If factor < 0 Then factor = 0
        If factor > 2 Then factor = 2

        Dim DifferenceR = IIf(factor > 1, 255 - c.R, c.R)
        Dim DifferenceG = IIf(factor > 1, 255 - c.G, c.G)
        Dim DifferenceB = IIf(factor > 1, 255 - c.B, c.B)

        Dim AdjustR As Integer = DifferenceR * (factor - 1)
        Dim AdjustG As Integer = DifferenceG * (factor - 1)
        Dim AdjustB As Integer = DifferenceB * (factor - 1)

        Dim cNew As Color = Color.FromArgb(255, c.R + AdjustR, c.G + AdjustG, c.B + AdjustB)

        Return "rgb(" & cNew.R & "," & cNew.G & "," & cNew.B & ")"
    End Function
    Public Shared Function AdjustColor(ByVal colorstr As String, ByVal factor As Single) As String
        Return AdjustColor(ColorTranslator.FromHtml(colorstr), factor)
    End Function
    Public Shared Function FormatTimeSpan(ByVal ts As TimeSpan) As String
        Dim Length As String = String.Empty

        If Math.Abs(ts.Hours) > 0 Then

            If Length.Length > 0 Then
                Length += " "
            End If

            Length += Math.Abs(ts.Hours).ToString("0") & "H"

        End If

        If Math.Abs(ts.Minutes) > 0 Then

            If Length.Length > 0 Then
                Length += " "
            End If

            Length += Math.Abs(ts.Minutes) & "M"

        End If

        If Math.Abs(ts.Seconds) > 0 Then

            If Length.Length > 0 Then
                Length += " "
            End If

            Length += Math.Abs(ts.Seconds) & "S"

        End If



        Return Length
    End Function
    Public Shared Function IsNull(ByVal o1 As Object, ByVal o2 As Object) As Object
        If IsDBNull(o1) Then
            Return o2
        Else
            Return o1
        End If
    End Function
    Public Shared Function AddBusinessDays(ByVal d As DateTime, ByVal days As Integer) As DateTime
        Dim result As DateTime = d
        If days = 0 Then Return result
        Dim stp As Integer = IIf(days > 0, 1, -1)

        Dim cur As Integer = 0
        While Math.Abs(cur) < Math.Abs(days)
            result = result.AddDays(stp)

            If Not result.DayOfWeek = DayOfWeek.Saturday And Not result.DayOfWeek = DayOfWeek.Sunday Then
                Dim HolidayName As String = DataHelper.Nz_string(DataHelper.FieldLookup("tblBankHoliday", "Name", DataHelper.StripTime("Date") & "='" & result.ToString("MM/dd/yyyy") & "'"))
                If String.IsNullOrEmpty(HolidayName) Then 'Not a bank holiday
                    cur += stp
                End If
            End If
        End While

        Return result
    End Function
    Public Shared Function SortToList(Of T)(ByVal d As IDictionary(Of String, T))
        Dim AllKeys As New List(Of String)
        For Each s As String In d.Keys
            AllKeys.Add(s)
        Next
        AllKeys.Sort()
        Dim l As New List(Of T)
        For Each s As String In AllKeys
            l.Add(d(s))
        Next
        Return l
    End Function
    Public Shared Function ConvertToList(Of T)(ByVal d As IDictionary)
        Dim l As New List(Of T)
        For Each o As Object In d.Values
            l.Add(o)
        Next
        Return l
    End Function


    Public Shared Function peel_bool_nullable(ByVal rd As IDataReader, ByVal field As String) As Nullable(Of Boolean)
        Dim i As Integer = rd.GetOrdinal(field)
        If rd.IsDBNull(i) Then
            Return Nothing
        Else
            Return rd.GetBoolean(i)
        End If
    End Function
    Public Shared Function FormatSSN(ByVal s As String) As String
        Dim val As String = NumbersOnly(s)
        If val.Length = 9 Then
            Dim part1 As String = val.Substring(0, 3)
            Dim part2 As String = val.Substring(3, 2)
            Dim part3 As String = val.Substring(5, 4)

            Return part1 + "-" + part2 + "-" + part3
        Else
            Return s
        End If
    End Function
    Public Shared Function NumbersOnly(ByVal s As String) As String
        Dim a As Char() = s.ToCharArray()
        Dim result As String = ""
        For Each c As Char In a
            If IsNumeric(c) Then
                result += c
            End If
        Next
        Return result
    End Function
    Public Shared Function FormatPhone(ByVal s As String) As String
        Dim offset As Integer = 0

        Dim val As String = NumbersOnly(s)
        If val.Length >= 10 Then
            Dim part1 As String
            If val.StartsWith("1800") And val.Length > 10 Then
                part1 = "1800"
                offset = 1
            Else
                part1 = val.Substring(0, 3)
            End If


            Dim part2 As String = val.Substring(3 + offset, 3)
            Dim part3 As String = val.Substring(6 + offset, 4)
            Dim part4 As String = ""
            If val.Length > 10 + offset Then
                part4 = " x" + val.Substring(10 + offset)
            End If


            Return "(" + part1 + ") " + part2 + "-" + part3 + part4
        Else
            Return s
        End If
    End Function
    Public Shared Function GetDouble(ByVal f As Object) As Double
        Dim val As Double
        If TypeOf f Is Single Then
            val = CType(f, Single)
        ElseIf TypeOf f Is Double Then
            val = CType(f, Double)
        ElseIf TypeOf f Is Integer Then
            val = CType(f, Integer)
        End If
        Return val
    End Function
    Public Shared Function GetCurrencyColor(ByVal f As Object) As String
        If GetDouble(f) > 0 Then
            Return "color:rgb(0,129,0)"
        Else
            Return "color:rgb(255,0,0)"
        End If
    End Function
    Public Shared Function GetBoolString(ByVal o As Object) As String
        Return GetBoolString(o, False, Nothing)
    End Function
    Public Shared Function GetBoolString(ByVal o As Object, ByVal p As Page) As String
        Return GetBoolString(o, True, p)
    End Function
    Public Shared Function GetBoolString(ByVal o As Object, ByVal img As Boolean, ByVal p As Page) As String
        If Not o Is DBNull.Value Then
            If TypeOf (o) Is DateTime Then
                Return GetBoolString(Not CType(o, DateTime) = DateTime.MinValue, img, p)
            ElseIf TypeOf (o) Is Nullable(Of DateTime) Then
                Return GetBoolString(CType(o, Nullable(Of DateTime)).HasValue, img, p)
            End If

            Dim s As Boolean = CType(o, Boolean)
            If img Then
                Return IIf(s, "<img src=""" & p.ResolveUrl("~/images/16x16_check.png") & """/>", "")
            Else
                Return IIf(s, "X", "")
            End If
        End If
        Return ""
    End Function

    Public Shared Function GetDateString(ByVal o As Nullable(Of DateTime)) As String
        Return GetDateString(o, "MM/dd/yyyy")
    End Function
    Public Shared Function GetDateString(ByVal o As Nullable(Of DateTime), ByVal format As String) As String
        If o.HasValue Then
            Return (o.Value.ToString(format))
        Else
            Return ""
        End If
    End Function

    Public Shared Function GetDateString(ByVal o As Object) As String
        Dim d As DateTime = CType(o, DateTime)
        Return IIf(d = DateTime.MinValue, "", d.ToString("MM/dd/yyyy"))
    End Function

    Public Shared Function GetSingleString(ByVal o As Object) As String
        Return GetSingleString(o, False)
    End Function
    Public Shared Function GetSingleString(ByVal o As Object, ByVal zero As Boolean) As String
        If zero Then Return GetSingleStringZ(o)
        Dim s As Single = CType(o, Single)
        Return IIf(s = 0, "", s)
    End Function
    Private Shared Function GetSingleStringZ(ByVal o As Object) As String
        Dim s As Single = CType(o, Single)
        Return IIf(s = 0, "0", s)
    End Function
    Public Shared Function GetSSNString(ByVal Value As Object) As String
        Return StringHelper.PlaceInMask(Value, "___-__-____")
    End Function
    Public Shared Function GetCurrencyString(ByVal Value As Object) As String
        Return GetCurrencyString(Value, False)
    End Function
    Public Shared Function GetCurrencyString(ByVal Value As Object, ByVal zero As Boolean) As String
        If IsDBNull(Value) Then
            Return CType(0, Double).ToString("c")
        ElseIf Value = 0 And Not zero Then
            Return String.Empty
        Else
            Return CType(Value, Double).ToString("c")
        End If
    End Function
    Public Shared Sub CopyValues(ByVal l As List(Of Pair(Of Control)))
        For Each p As Pair(Of Control) In l
            Dim src As Control = p.Second
            Dim dest As Control = p.First

            Dim value As String = ""

            If TypeOf src Is TextBox Then
                value = CType(src, TextBox).Text
            ElseIf TypeOf src Is Label Then
                value = CType(src, Label).Text
            ElseIf TypeOf src Is DropDownList Then
                Dim li As ListItem = CType(src, DropDownList).SelectedItem
                If Not li Is Nothing Then
                    value = li.Text
                End If
            ElseIf TypeOf src Is HtmlSelect Then
                Dim sel As HtmlSelect = CType(src, HtmlSelect)
                Dim li As ListItem = sel.Items(sel.SelectedIndex)
                If Not li Is Nothing Then
                    value = li.Text
                End If

            ElseIf TypeOf src Is CheckBox Then
                value = CType(src, CheckBox).Checked.ToString()
            ElseIf TypeOf src Is HtmlInputRadioButton Then
                value = CType(src, HtmlInputRadioButton).Checked.ToString()
            ElseIf TypeOf src Is RadioButtonList Then
                value = CType(src, RadioButtonList).SelectedItem.Text
            ElseIf TypeOf src Is HtmlInputCheckBox Then
                value = CType(src, HtmlInputCheckBox).Checked.ToString()
            ElseIf TypeOf src Is InputMask Then
                value = CType(src, InputMask).Text
            End If

            If TypeOf dest Is TextBox Then
            ElseIf TypeOf dest Is Label Then
                CType(dest, Label).Text = value
            ElseIf TypeOf dest Is DropDownList Then
                CType(dest, DropDownList).SelectedItem.Text = value
            ElseIf TypeOf dest Is CheckBox Then
                CType(dest, CheckBox).Checked = Boolean.Parse(value)
                CType(dest, CheckBox).Style("color") = "black"
            ElseIf TypeOf dest Is HtmlInputRadioButton Then
                CType(dest, HtmlInputRadioButton).Checked = Boolean.Parse(value)
            ElseIf TypeOf dest Is HtmlInputCheckBox Then
                CType(dest, HtmlInputCheckBox).Checked = Boolean.Parse(value)
            ElseIf TypeOf dest Is InputMask Then
                CType(dest, InputMask).Text = value
            ElseIf TypeOf dest Is HtmlTableCell Then
                CType(dest, HtmlTableCell).InnerHtml = value
            End If

        Next
    End Sub
    Public Shared Sub SetControlValue(ByVal Control As Control, ByVal Value As String)

        If TypeOf Control Is TextBox Then
            CType(Control, TextBox).Text = Value
        ElseIf TypeOf Control Is HtmlInputText Then
            CType(Control, HtmlInputText).Value = Value
        ElseIf TypeOf Control Is HtmlInputHidden Then
            CType(Control, HtmlInputHidden).Value = Value
        ElseIf TypeOf Control Is DropDownList Then
            CType(Control, DropDownList).SelectedValue = Value
        ElseIf TypeOf Control Is HtmlSelect Then
            Dim sel As HtmlSelect = CType(Control, HtmlSelect)
            sel.SelectedIndex = sel.Items.IndexOf(sel.Items.FindByValue(Value))
        ElseIf TypeOf Control Is CheckBox Then
            CType(Control, CheckBox).Checked = DataHelper.Nz_bool(Value)
        ElseIf TypeOf Control Is HtmlInputRadioButton Then
            CType(Control, HtmlInputRadioButton).Checked = DataHelper.Nz_bool(Value)
        ElseIf TypeOf Control Is RadioButtonList Then
            CType(Control, RadioButtonList).SelectedValue = Value
        ElseIf TypeOf Control Is HtmlInputCheckBox Then
            CType(Control, HtmlInputCheckBox).Checked = DataHelper.Nz_bool(Value)
        ElseIf TypeOf Control Is InputMask Then
            CType(Control, InputMask).Text = Value
        ElseIf TypeOf Control Is TabStrip Then
            CType(Control, TabStrip).SelectedIndex = Integer.Parse(Value)
        End If

    End Sub
    Public Shared Sub SetControlAttribute(ByVal Control As Control, ByVal Attribute As String, ByVal Value As String)

        If TypeOf Control Is TextBox Then
            If Value.Length > 0 Then
                CType(Control, TextBox).Attributes(Attribute) = Value
            Else
                CType(Control, TextBox).Attributes.Remove(Attribute)
            End If
        ElseIf TypeOf Control Is DropDownList Then
            If Value.Length > 0 Then
                CType(Control, DropDownList).Attributes(Attribute) = Value
            Else
                CType(Control, DropDownList).Attributes.Remove(Attribute)
            End If
        ElseIf TypeOf Control Is CheckBox Then
            If Value.Length > 0 Then
                CType(Control, CheckBox).Attributes(Attribute) = Value
            Else
                CType(Control, CheckBox).Attributes.Remove(Attribute)
            End If
        ElseIf TypeOf Control Is HtmlInputRadioButton Then
            If Value.Length > 0 Then
                CType(Control, HtmlInputRadioButton).Attributes(Attribute) = Value
            Else
                CType(Control, HtmlInputRadioButton).Attributes.Remove(Attribute)
            End If
        ElseIf TypeOf Control Is RadioButtonList Then
            If Value.Length > 0 Then
                CType(Control, RadioButtonList).Attributes(Attribute) = Value
            Else
                CType(Control, RadioButtonList).Attributes.Remove(Attribute)
            End If
        ElseIf TypeOf Control Is HtmlInputCheckBox Then
            If Value.Length > 0 Then
                CType(Control, HtmlInputCheckBox).Attributes(Attribute) = Value
            Else
                CType(Control, HtmlInputCheckBox).Attributes.Remove(Attribute)
            End If
        ElseIf TypeOf Control Is LinkButton Then
            If Value.Length > 0 Then
                CType(Control, LinkButton).Attributes(Attribute) = Value
            Else
                CType(Control, LinkButton).Attributes.Remove(Attribute)
            End If
        ElseIf TypeOf Control Is InputMask Then
            If Value.Length > 0 Then
                CType(Control, InputMask).Attributes(Attribute) = Value
            Else
                CType(Control, InputMask).Attributes.Remove(Attribute)
            End If
        ElseIf TypeOf Control Is HtmlTableCell Then
            If Value.Length > 0 Then
                CType(Control, HtmlTableCell).Attributes(Attribute) = Value
            Else
                CType(Control, HtmlTableCell).Attributes.Remove(Attribute)
            End If

        End If

    End Sub
    Public Shared Sub SetControlStyle(ByVal Control As Control, ByVal Style As String, ByVal Value As String)

        If TypeOf Control Is TextBox Then
            If Value.Length > 0 Then
                CType(Control, TextBox).Style(Style) = Value
            Else
                CType(Control, TextBox).Style.Remove(Style)
            End If
        ElseIf TypeOf Control Is DropDownList Then
            If Value.Length > 0 Then
                CType(Control, DropDownList).Style(Style) = Value
            Else
                CType(Control, DropDownList).Style.Remove(Style)
            End If
        ElseIf TypeOf Control Is CheckBox Then
            If Value.Length > 0 Then
                CType(Control, CheckBox).Style(Style) = Value
            Else
                CType(Control, CheckBox).Style.Remove(Style)
            End If
        ElseIf TypeOf Control Is HtmlInputRadioButton Then
            If Value.Length > 0 Then
                CType(Control, HtmlInputRadioButton).Style(Style) = Value
            Else
                CType(Control, HtmlInputRadioButton).Style.Remove(Style)
            End If
        ElseIf TypeOf Control Is RadioButtonList Then
            If Value.Length > 0 Then
                CType(Control, RadioButtonList).Style(Style) = Value
            Else
                CType(Control, RadioButtonList).Style.Remove(Style)
            End If
        ElseIf TypeOf Control Is HtmlInputCheckBox Then
            If Value.Length > 0 Then
                CType(Control, HtmlInputCheckBox).Style(Style) = Value
            Else
                CType(Control, HtmlInputCheckBox).Style.Remove(Style)
            End If
        ElseIf TypeOf Control Is LinkButton Then
            If Value.Length > 0 Then
                CType(Control, LinkButton).Style(Style) = Value
            Else
                CType(Control, LinkButton).Style.Remove(Style)
            End If
        ElseIf TypeOf Control Is InputMask Then
            If Value.Length > 0 Then
                CType(Control, InputMask).Style(Style) = Value
            Else
                CType(Control, InputMask).Style.Remove(Style)
            End If
        ElseIf TypeOf Control Is HtmlTableCell Then
            If Value.Length > 0 Then
                CType(Control, HtmlTableCell).Style(Style) = Value
            Else
                CType(Control, HtmlTableCell).Style.Remove(Style)
            End If
        ElseIf TypeOf Control Is HtmlTableRow Then
            If Value.Length > 0 Then
                CType(Control, HtmlTableRow).Style(Style) = Value
            Else
                CType(Control, HtmlTableRow).Style.Remove(Style)
            End If
        End If

    End Sub
    Public Shared Sub LoadValues(ByVal SettingControls As Dictionary(Of String, Control), ByVal p As Page)

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetQuerySettings")

            DatabaseHelper.AddParameter(cmd, "WHERE", "WHERE UserID = " & p.User.Identity.Name _
                & " AND NOT SettingType = 'Store' AND ClassName = '" & p.GetType().Name & "'")

            Using cmd.Connection

                cmd.Connection.Open()

                Using rd As IDataReader = cmd.ExecuteReader()

                    While rd.Read()

                        Dim SettingType As String = DatabaseHelper.Peel_string(rd, "SettingType")
                        Dim [Object] As String = DatabaseHelper.Peel_string(rd, "Object")
                        Dim Value As String = DatabaseHelper.Peel_string(rd, "Value")
                        Try
                            Select Case SettingType.ToLower
                                Case "value"
                                    SetControlValue(SettingControls.Item([Object]), Value)
                                Case "attribute"

                                    Dim Attribute As String = Value.Split("=")(0)

                                    SetControlAttribute(SettingControls.Item([Object]), Attribute, _
                                        Value.Substring(Attribute.Length + 1))

                                Case "style"

                                    Dim Style As String = Value.Split(":")(0)

                                    SetControlStyle(SettingControls.Item([Object]), Style, _
                                        Value.Substring(Style.Length + 1))

                            End Select
                        Catch ex As Exception
                            'control doesn't exists. Eventually, we shuold delete the record
                        End Try
                    End While
                End Using
            End Using
        End Using

    End Sub

    Public Shared Function RoundDate(ByVal d As DateTime, ByVal Direction As Integer, ByVal Unit As DateUnit) As DateTime
        Dim result As DateTime = d

        If Unit = DateUnit.Week Then
            If Direction = 1 Then
                While Not result.DayOfWeek = DayOfWeek.Saturday
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.DayOfWeek = DayOfWeek.Sunday
                    result = result.AddDays(-1)
                End While
            Else
                If result.DayOfWeek = DayOfWeek.Wednesday Or result.DayOfWeek = DayOfWeek.Thursday Or result.DayOfWeek = DayOfWeek.Friday Then
                    While Not result.DayOfWeek = DayOfWeek.Saturday
                        result = result.AddDays(1)
                    End While
                ElseIf result.DayOfWeek = DayOfWeek.Monday Or result.DayOfWeek = DayOfWeek.Tuesday Then
                    While Not result.DayOfWeek = DayOfWeek.Sunday
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        ElseIf Unit = DateUnit.Month Then
            If Direction = 1 Then
                While Not result.Day = Date.DaysInMonth(result.Year, result.Month)
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.Day = 1
                    result = result.AddDays(-1)
                End While
            Else
                Dim DaysInMonth As Integer = Date.DaysInMonth(result.Year, result.Month)
                Dim Midpoint As Integer = DaysInMonth / 2

                If result.Day >= Midpoint And result.Day < DaysInMonth Then
                    While Not result.Day = DaysInMonth
                        result = result.AddDays(1)
                    End While
                ElseIf result.Day < Midpoint And result.Day > 1 Then
                    While Not result.Day = 1
                        result = result.AddDays(-1)
                    End While
                End If
            End If
        ElseIf Unit = DateUnit.Year Then
            Dim DaysInYear As Integer
            For i As Integer = 1 To 12
                DaysInYear += Date.DaysInMonth(result.Year, i)
            Next
            If Direction = 1 Then
                While Not result.DayOfYear = DaysInYear
                    result = result.AddDays(1)
                End While
            ElseIf Direction = -1 Then
                While Not result.DayOfYear = 1
                    result = result.AddDays(-1)
                End While
            Else
                Dim Midpoint As Integer = DaysInYear / 2

                If result.DayOfYear >= Midpoint And result.DayOfYear < DaysInYear Then
                    While Not result.DayOfYear = DaysInYear
                        result = result.AddDays(1)
                    End While
                ElseIf result.DayOfYear < Midpoint And result.DayOfYear > 1 Then
                    While Not result.DayOfYear = 1
                        result = result.AddDays(-1)
                    End While
                End If
            End If

        End If

        Return result

    End Function
    Public Shared Function AddCriteria(ByVal orig As String, ByVal strNew As String) As String
        Return AddCriteria(orig, strNew, False)
    End Function
    Public Shared Function AddCriteria(ByVal orig As String, ByVal strNew As String, ByVal Invert As Boolean) As String
        If orig.Length > 0 Then
            Return orig + " AND " & IIf(Invert, " NOT ", "") & "(" & strNew & ")"
        Else
            Return IIf(Invert, " NOT ", "") & "(" & strNew & ")"
        End If
    End Function
    Public Shared Function AddDateCriteria(ByVal orig As String, ByVal txt1 As TextBox, ByVal txt2 As TextBox, ByVal fieldName As String) As String
        Dim strWhere As String = ""
        If txt1.Text.Length > 0 Then
            If strWhere.Length > 0 Then
                strWhere += DataHelper.StripTime(fieldName) & " >= '" & txt1.Text & "'"
            Else
                strWhere = DataHelper.StripTime(fieldName) & " >= '" & txt1.Text & "'"
            End If
        End If

        If txt2.Text.Length > 0 Then
            If strWhere.Length > 0 Then
                strWhere += " AND " & DataHelper.StripTime(fieldName) & " <= '" & txt2.Text & "'"
            Else
                strWhere = DataHelper.StripTime(fieldName) & " <= '" & txt2.Text & "'"
            End If
        End If

        If strWhere.Length > 0 Then
            Return AddCriteria(orig, strWhere)
        Else
            Return orig
        End If
    End Function

    Public Shared Function GetVirtualBasePath() As String
        Return GetVirtualBasePath(IPHelper.IsIntranetAddress(IPHelper.GetIP4Address()))
    End Function

    Public Shared Function GetVirtualBasePath(ByVal intranet As Boolean) As String
        Dim basepath As String = ConfigurationManager.AppSettings("externalhostdomain").ToString
        If intranet Then
            basepath = ConfigurationManager.AppSettings("internalhostdomain").ToString
        End If
        If Not basepath.StartsWith("http://") Then basepath = "http://" & basepath
        Return basepath
    End Function

    Public Shared Function GetVirtualPathForType(ByVal PathType As VirtualPathTypes) As String
        Dim dirname As String = "clientstorage"
        Select Case PathType
            Case VirtualPathTypes.Leads
                dirname = "leaddocs"
        End Select
        Return dirname
    End Function

    Public Shared Function GetVirtualDocFullPath(ByVal IPAddress As String, ByVal PathType As VirtualPathTypes) As String
        Return String.Format("{0}/{1}", GetVirtualBasePath(IPAddress), GetVirtualPathForType(PathType))
    End Function

    Public Shared Function GetVirtualDocFullPath(ByVal filename As String) As String
        Return LocalHelper.GetVirtualBasePath() & filename.Substring(filename.IndexOf("\", 2)).Replace(".\", "\").Replace("\", "/")
    End Function

End Class

