Option Explicit On

Imports Slf.Dms.Records

Imports System.Text
Imports System.Web.UI
Imports System.ComponentModel
Imports System.Web.UI.WebControls
Imports System.Collections.Generic

<Description("A calendar grid that displays tasks.")> _
Public Class TaskCalendar
    Inherits Control

#Region "Variables"

    Private _mode As DisplayMode
    Private _startdate As DateTime
    Private _enddate As DateTime

    Private _tasks As List(Of Task)

#End Region

#Region "Properties"

    Public Property Mode() As DisplayMode
        Get
            Return _mode
        End Get
        Set(ByVal Value As DisplayMode)
            _mode = Value
        End Set
    End Property
    Public Property StartDate() As DateTime
        Get
            Return _startdate
        End Get
        Set(ByVal Value As DateTime)
            _startdate = Value
        End Set
    End Property
    Public Property EndDate() As DateTime
        Get
            Return _enddate
        End Get
        Set(ByVal Value As DateTime)
            _enddate = Value
        End Set
    End Property
    ReadOnly Property Tasks() As List(Of Task)
        Get

            If _tasks Is Nothing Then
                _tasks = New List(Of Task)
            End If

            Return _tasks

        End Get
    End Property

#End Region

#Region "Enums"

    Public Enum DisplayMode
        Day = 0
        Week = 1
        Month = 2
    End Enum

#End Region

#Region "Constructor"

    Public Sub New()
        ResetToDefault()
    End Sub

#End Region

    Protected Overrides Sub OnPreRender(ByVal e As EventArgs)
        MyBase.OnPreRender(e)
        Me.RegisterScript()
    End Sub
    Public Sub ForceRange(ByVal NewStartDate As DateTime, ByVal NewEndDate As DateTime, ByVal CurrentMode As DisplayMode)

        Dim TotalDays As Double = NewEndDate.Subtract(NewStartDate).Days + 1

        _startdate = NewStartDate
        _enddate = NewEndDate

        If TotalDays > 7 Then 'selected more than a week's worth

            _mode = DisplayMode.Month

            'move startdate back to a monday
            While Not _startdate.DayOfWeek = DayOfWeek.Monday
                _startdate = _startdate.Subtract(New TimeSpan(1, 0, 0, 0))
            End While

            Dim NewTotalDays As Double = _enddate.Subtract(_startdate).Days

            If NewTotalDays > 35 Then 'scale back to 35
                _enddate = _startdate.AddDays(34)
            Else

                'move enddate out to sunday
                While Not _enddate.DayOfWeek = DayOfWeek.Sunday
                    _enddate = _enddate.AddDays(1)
                End While

            End If

        Else

            If (CurrentMode = DisplayMode.Month Or CurrentMode = DisplayMode.Week) _
                And (TotalDays = 7 And _startdate.DayOfWeek = DayOfWeek.Monday) Then

                _mode = DisplayMode.Week
            Else
                _mode = DisplayMode.Day
            End If

        End If

    End Sub
    Public Sub ForceToMode(ByVal NewMode As DisplayMode)

        _mode = NewMode

        Select Case NewMode
            Case DisplayMode.Day 'day mode cannot have more than 7 days

                Dim TotalDays As Double = _enddate.Subtract(_startdate).Days

                If TotalDays > 7 Then
                    _enddate = _startdate.AddDays(6)
                End If

            Case DisplayMode.Week 'week mode cannot have no more or less than 7 days and must start on monday

                'move startdate back to a monday
                While Not _startdate.DayOfWeek = DayOfWeek.Monday
                    _startdate = _startdate.Subtract(New TimeSpan(1, 0, 0, 0))
                End While

                Dim TotalDays As Double = _enddate.Subtract(_startdate).Days + 1

                If TotalDays > 7 Then
                    _enddate = _startdate.AddDays(6)
                Else

                    'move enddate out to sunday
                    While Not _enddate.DayOfWeek = DayOfWeek.Sunday
                        _enddate = _enddate.AddDays(1)
                    End While

                End If

            Case DisplayMode.Month 'month mode cannot have more than 35 or less than 7 and must start on monday

                'move startdate back to a monday
                While Not _startdate.DayOfWeek = DayOfWeek.Monday
                    _startdate = _startdate.Subtract(New TimeSpan(1, 0, 0, 0))
                End While

                Dim TotalDays As Double = _enddate.Subtract(_startdate).Days

                If TotalDays > 35 Then 'scale back to 35
                    _enddate = _startdate.AddDays(34)
                Else

                    'move enddate out to sunday
                    While Not _enddate.DayOfWeek = DayOfWeek.Sunday
                        _enddate = _enddate.AddDays(1)
                    End While

                End If

        End Select

    End Sub
    Private Sub CheckAndFlipMode()

        Dim TotalDays As Double = _enddate.Subtract(_startdate).Days

        Select Case _mode
            Case DisplayMode.Day 'day mode cannot have more than 7

                If TotalDays > 7 Then
                    _mode = DisplayMode.Month
                End If

            Case DisplayMode.Week 'week mode cannot have more than 7

                If TotalDays > 7 Then
                    _mode = DisplayMode.Month
                Else
                    If TotalDays < 7 Then
                        _mode = DisplayMode.Day
                    End If
                End If

            Case DisplayMode.Month 'month mode cannot have more than 35

                If TotalDays > 35 Then
                    _enddate = _startdate.AddDays(34)
                End If

        End Select

    End Sub
    Public Sub ResetToDefault()

        _mode = DisplayMode.Day

        _startdate = Now
        _enddate = Now

    End Sub
    Protected Overrides Sub Render(ByVal output As HtmlTextWriter)

        Select Case _mode
            Case DisplayMode.Day
                RenderDay(output)
            Case DisplayMode.Week
                RenderWeek(output)
            Case DisplayMode.Month
                RenderMonth(output)
        End Select

        MyBase.Render(output)

    End Sub
    Private Sub RenderMonth(ByVal output As HtmlTextWriter)

        Dim CurrentInstance As DateTime = _startdate.Date
        Dim TotalDays As Double = _enddate.Subtract(_startdate).Days + 1
        Dim RowHeight As Double = 100 / (TotalDays / 7)

        output.Write("<table style=""font-family:tahoma;font-size:11px;border-left:solid 1px black;border-top:solid 1px black;table-layout:fixed;width:100%;height:100%;"" cellpadding=""0"" cellspacing=""0"" border=""0"" onselectstart=""return false;"" >")

        For r As Integer = 0 To 5

            output.Write("<tr>")

            If r = 0 Then

                output.Write("<td align=""center"" style=""border-right:solid 1px rgb(172,168,153);border-bottom:solid 1px rgb(172,168,153);border-left:solid 1px white;border-top:solid 1px white;background-color:rgb(236,233,216);height:25px;width:16.6667%;"">Monday</td>")
                output.Write("<td align=""center"" style=""border-right:solid 1px rgb(172,168,153);border-bottom:solid 1px rgb(172,168,153);border-left:solid 1px white;border-top:solid 1px white;background-color:rgb(236,233,216);height:25px;width:16.6667%;"">Tuesday</td>")
                output.Write("<td align=""center"" style=""border-right:solid 1px rgb(172,168,153);border-bottom:solid 1px rgb(172,168,153);border-left:solid 1px white;border-top:solid 1px white;background-color:rgb(236,233,216);height:25px;width:16.6667%;"">Wednesday</td>")
                output.Write("<td align=""center"" style=""border-right:solid 1px rgb(172,168,153);border-bottom:solid 1px rgb(172,168,153);border-left:solid 1px white;border-top:solid 1px white;background-color:rgb(236,233,216);height:25px;width:16.6667%;"">Thursday</td>")
                output.Write("<td align=""center"" style=""border-right:solid 1px rgb(172,168,153);border-bottom:solid 1px rgb(172,168,153);border-left:solid 1px white;border-top:solid 1px white;background-color:rgb(236,233,216);height:25px;width:16.6667%;"">Friday</td>")
                output.Write("<td align=""center"" style=""border-right:solid 1px rgb(172,168,153);border-bottom:solid 1px rgb(172,168,153);border-left:solid 1px white;border-top:solid 1px white;background-color:rgb(236,233,216);height:25px;width:16.6667%;"">Sat/Sun</td>")

            Else

                For c As Integer = 0 To 5

                    Dim BackgroundColor As String = String.Empty

                    output.Write("<td style=""border-right:solid 1px black;border-bottom:solid 1px black;background-color:rgb(255,255,213);height:" & RowHeight & "%;width:16.6667%;"">")

                    If Not CurrentInstance.DayOfWeek = DayOfWeek.Saturday Then

                        If CurrentInstance = Now.Date Then
                            BackgroundColor = "rgb(255,244,188)"
                        Else
                            BackgroundColor = "rgb(255,255,213)"
                        End If

                        output.Write("<table style=""background-color:" & BackgroundColor & ";table-layout:fixed;font-family:tahoma;font-size:11px;height:100%;width:100%;"" cellpadding=""0"" cellspacing=""0"" border=""0"" >")
                        output.Write("  <tr>")
                        output.Write("      <td style=""padding-top:3px;padding-right:3px;"" valign=""top"" align=""right"">")

                        If CurrentInstance.Day = 1 Then
                            output.Write(CurrentInstance.ToString("MMMM d"))
                        Else
                            output.Write(CurrentInstance.Day)
                        End If

                        output.Write("      </td>")
                        output.Write("  </tr>")
                        output.Write("  <tr>")
                        output.Write("      <td ondblclick=""ASI_TC_Task_AddNew('" & CurrentInstance.ToString("yyyyMMdd12") & "');"" valign=""top"" style=""height:100%;"">" & GetDayContent(CurrentInstance) & "</td>")
                        output.Write("  </tr>")
                        output.Write("</table>")

                    Else

                        If CurrentInstance = Now.Date Then
                            BackgroundColor = "rgb(255,244,188)"
                        Else
                            BackgroundColor = "rgb(239,239,243)"
                        End If

                        output.Write("<table style=""table-layout:fixed;font-family:tahoma;font-size:11px;height:100%;width:100%;"" cellpadding=""0"" cellspacing=""0"" border=""0"" >")
                        output.Write("  <tr>")
                        output.Write("      <td style=""background-color:" & BackgroundColor & ";padding-top:3px;padding-right:3px;"" valign=""top"" align=""right"">")

                        If CurrentInstance.Day = 1 Then
                            output.Write(CurrentInstance.ToString("MMMM d"))
                        Else
                            output.Write(CurrentInstance.Day)
                        End If

                        output.Write("      </td>")
                        output.Write("  </tr>")
                        output.Write("  <tr>")
                        output.Write("      <td ondblclick=""ASI_TC_Task_AddNew('" & CurrentInstance.ToString("yyyyMMdd12") & "');"" valign=""top"" style=""background-color:" & BackgroundColor & ";height:50%;"">" & GetDayContent(CurrentInstance) & "</td>")
                        output.Write("  </tr>")

                        CurrentInstance = CurrentInstance.AddDays(1)

                        If CurrentInstance = Now.Date Then
                            BackgroundColor = "rgb(255,244,188)"
                        Else
                            BackgroundColor = "rgb(239,239,243)"
                        End If

                        output.Write("  <tr>")
                        output.Write("      <td style=""background-color:" & BackgroundColor & ";padding-top:4px;padding-right:3px;border-top:solid 1px black;"" valign=""top"" align=""right"">")

                        If CurrentInstance.Day = 1 Then
                            output.Write(CurrentInstance.ToString("MMMM d"))
                        Else
                            output.Write(CurrentInstance.Day)
                        End If

                        output.Write("      </td>")
                        output.Write("  </tr>")
                        output.Write("  <tr>")
                        output.Write("      <td ondblclick=""ASI_TC_Task_AddNew('" & CurrentInstance.ToString("yyyyMMdd12") & "');"" valign=""top"" style=""background-color:" & BackgroundColor & ";height:50%;"">" & GetDayContent(CurrentInstance) & "</td>")
                        output.Write("  </tr>")
                        output.Write("</table>")

                    End If

                    output.Write("</td>")

                    CurrentInstance = CurrentInstance.AddDays(1)

                Next

            End If

            output.Write("  </tr>")

            If CurrentInstance > _enddate Then
                Exit For
            End If

        Next

        output.Write("</table>")

    End Sub
    Private Sub RenderWeek(ByVal output As HtmlTextWriter)

        Dim CurrentInstance As DateTime = _startdate.Date

        output.Write("<table style=""border-left:solid 1px rgb(172,168,153);border-top:solid 1px rgb(172,168,153);table-layout:fixed;width:100%;height:100%;"" cellpadding=""0"" cellspacing=""0"" border=""0"" onselectstart=""return false;"" >")

        For r As Integer = 0 To 2

            output.Write("<tr>")

            For c As Integer = 0 To 1

                output.Write("<td style=""height:33%;width:50%;"">")

                Dim BackgroundColor As String = String.Empty

                If Not CurrentInstance.DayOfWeek = DayOfWeek.Saturday Then

                    If CurrentInstance = Now.Date Then
                        BackgroundColor = "rgb(255,244,188)"
                    Else
                        BackgroundColor = "rgb(255,255,213)"
                    End If

                    output.Write("<table style=""table-layout:fixed;font-family:tahoma;font-size:11px;height:100%;width:100%;"" cellpadding=""2"" cellspacing=""0"" border=""0"" >")
                    output.Write("  <tr>")
                    output.Write("      <td valign=""bottom"" style=""height:19px;border-right:solid 1px rgb(172,168,153);border-top:solid 1px white;border-left:solid 1px white;border-bottom:solid 1px rgb(172,168,153);background-color:rgb(236,233,216);"" align=""right"">" & CurrentInstance.ToString("dddd, MMMM d") & "</td>")
                    output.Write("  </tr>")
                    output.Write("  <tr>")
                    output.Write("      <td ondblclick=""ASI_TC_Task_AddNew('" & CurrentInstance.ToString("yyyyMMdd12") & "');"" style=""border-bottom:solid 1px rgb(172,168,153);border-right:solid 1px rgb(172,168,153);background-color:" & BackgroundColor & ";height:100%;"">" & GetDayContent(CurrentInstance) & "</td>")
                    output.Write("  </tr>")
                    output.Write("</table>")

                Else

                    If CurrentInstance = Now.Date Then
                        BackgroundColor = "rgb(255,244,188)"
                    Else
                        BackgroundColor = "rgb(239,239,243)"
                    End If

                    output.Write("<table style=""table-layout:fixed;font-family:tahoma;font-size:11px;height:100%;width:100%;"" cellpadding=""2"" cellspacing=""0"" border=""0"" >")
                    output.Write("  <tr>")
                    output.Write("      <td valign=""bottom"" style=""height:19px;border-right:solid 1px rgb(172,168,153);border-top:solid 1px white;border-left:solid 1px white;border-bottom:solid 1px rgb(172,168,153);background-color:rgb(236,233,216);"" align=""right"">" & CurrentInstance.ToString("dddd, MMMM d") & "</td>")
                    output.Write("  </tr>")
                    output.Write("  <tr>")
                    output.Write("      <td ondblclick=""ASI_TC_Task_AddNew('" & CurrentInstance.ToString("yyyyMMdd12") & "');"" style=""border-bottom:solid 1px rgb(172,168,153);border-right:solid 1px rgb(172,168,153);background-color:" & BackgroundColor & ";height:50%;"">" & GetDayContent(CurrentInstance) & "</td>")
                    output.Write("  </tr>")

                    CurrentInstance = CurrentInstance.AddDays(1)

                    If CurrentInstance = Now.Date Then
                        BackgroundColor = "rgb(255,244,188)"
                    Else
                        BackgroundColor = "rgb(239,239,243)"
                    End If

                    output.Write("  <tr>")
                    output.Write("      <td valign=""bottom"" style=""height:19px;border-right:solid 1px rgb(172,168,153);border-top:solid 1px white;border-left:solid 1px white;border-bottom:solid 1px rgb(172,168,153);background-color:rgb(236,233,216);"" align=""right"">" & CurrentInstance.ToString("dddd, MMMM d") & "</td>")
                    output.Write("  </tr>")
                    output.Write("  <tr>")
                    output.Write("      <td ondblclick=""ASI_TC_Task_AddNew('" & CurrentInstance.ToString("yyyyMMdd12") & "');"" style=""border-bottom:solid 1px rgb(172,168,153);border-right:solid 1px rgb(172,168,153);background-color:" & BackgroundColor & ";height:50%;"">" & GetDayContent(CurrentInstance) & "</td>")
                    output.Write("  </tr>")
                    output.Write("</table>")

                End If

                output.Write("</td>")

                CurrentInstance = CurrentInstance.AddDays(1)

            Next

            output.Write("  </tr>")

        Next

        output.Write("</table>")

    End Sub
    Private Sub RenderDay(ByVal output As HtmlTextWriter)

        output.Write("<table onselectstart=""return false;"" style=""border:solid 1px rgb(172,168,153);table-layout:fixed;height:100%;width:100%;"" cellpadding=""0"" cellspacing=""0"" border=""0"">")
        output.Write("  <tr>")
        output.Write("      <td valign=""top"">")
        output.Write("          <table style=""height:26px;width:100%;background-color:rgb(236,233,216);font-family:tahoma;font-size:11px;"" cellpadding=""0"" cellspacing=""0"" border=""0"">")
        output.Write("              <tr>")
        output.Write("                  <td style=""border-bottom:solid 1px rgb(172,168,153);border-right:solid 1px rgb(172,168,153);border-left:solid 1px white;border-top:solid 1px white;width:50px;"">&nbsp;</td>")
        output.Write("                  <td>")
        output.Write("                      <table style=""table-layout:fixed;height:100%;width:100%;font-family:tahoma;font-size:11px;"" cellpadding=""0"" cellspacing=""0"" border=""0"">")
        output.Write("                          <tr>")

        Dim TotalDays As Double = EndDate.Subtract(_startdate).Days + 1
        Dim HeaderSize As Double = 100 / (TotalDays)

        'add column headers
        For d As Integer = 0 To TotalDays - 1

            output.Write("<td align=""center"" style=""width:" & HeaderSize & "%;border-top:solid 1px white;border-bottom:solid 1px rgb(172,168,153);border-left:solid 1px white;border-right:solid 1px rgb(172,168,153);"">")

            If _startdate.AddDays(d).Date = Now.Date Then
                output.Write("<strong>" & _startdate.AddDays(d).ToString("ddd, MMM d") & "</strong>")
            Else
                output.Write(_startdate.AddDays(d).ToString("ddd MMM, d"))
            End If

            output.Write("</td>")

        Next

        output.Write("                          </tr>")
        output.Write("                      </table>")
        output.Write("                  </td>")
        output.Write("                  <td style=""border-bottom:solid 1px rgb(172,168,153);border-right:solid 1px rgb(172,168,153);border-left:solid 1px white;border-top:solid 1px white;width:15px;"">&nbsp;</td>")
        output.Write("              </tr>")
        output.Write("          </table>")
        output.Write("      </td>")
        output.Write("  </tr>")
        output.Write("  <tr>")
        output.Write("      <td style=""height:100%;"" valign=""top"">")
        output.Write("          <div style=""height:100%;width:100%;overflow:auto;"">")
        output.Write("              <table style=""width:100%;table-layout:fixed;"" cellpadding=""0"" cellspacing=""0"" border=""0"">")

        'add rows
        For h As Integer = 0 To 23

            output.Write("              <tr>")
            output.Write("                  <td style=""border-top:solid 1px white;border-left:solid 1px white;width:50px;font-family:tahoma;font-size:11px;background-color:rgb(236,233,216);padding-top:5px;padding-right:5px;padding-bottom:7px;border-right:solid 1px rgb(172,168,153);border-bottom:solid 1px rgb(172,168,153);"" align=""right"" valign=""top"">")

            Dim ToWrite As String = String.Empty

            Select Case h
                Case 0
                    ToWrite = "12 AM"
                Case 12
                    ToWrite = "Noon"
                Case Else

                    If h > 12 Then
                        ToWrite = (h - 12).ToString() & ":00 P"
                    Else
                        ToWrite = h.ToString() & ":00 A"
                    End If

            End Select

            If Now.Hour = h Then
                output.Write("<strong>" & ToWrite & "</strong>")
            Else
                output.Write(ToWrite)
            End If

            output.Write("                  </td>")

            Dim NowInstance As New DateTime(Now.Year, Now.Month, Now.Day, Now.Hour, 0, 0)

            For d As Integer = 0 To TotalDays - 1

                Dim CurrentDate As DateTime = _startdate.AddDays(d)
                Dim CurrentInstance As DateTime = New DateTime(CurrentDate.Year, CurrentDate.Month, CurrentDate.Day, h, 0, 0)
                Dim CurrentBookmark As String = CurrentInstance.ToString("yyyy.MM.dd.HH")

                Dim Task As Task = GetTask(CurrentInstance)

                Dim BackgroundColor As String = String.Empty

                If CurrentInstance = NowInstance Then
                    BackgroundColor = "rgb(255,244,188)"
                Else
                    BackgroundColor = "rgb(255,255,213)"
                End If

                If Not Task Is Nothing Then

                    output.Write("                  <td style=""border-bottom:solid 1px rgb(246,219,162);background-color:" & BackgroundColor & ";height:27px;border-right:solid 1px black;"">")
                    output.Write("                      <a name=""" & CurrentBookmark & """></a>")
                    output.Write("                      <table ondblclick=""ASI_TC_Task_OnDblClick(" & Task.TaskID & ");"" style=""cursor:pointer;filter:progid:DXImageTransform.Microsoft.Shadow(color='#888888', Direction=135, Strength=4);width:100%;height:23px;font-size:11px;width:100%;"" cellpadding=""0"" cellspacing=""0"" border=""0"">")
                    output.Write("                          <tr>")

                    If Task.Resolved.HasValue Then 'task here, but already resolved

                        output.Write("                          <td style=""width:6px;border-top:solid 1px black;border-bottom:solid 1px black;border-right:solid 1px black;background-color:rgb(0,159,0);"">&nbsp;</td>")
                        output.Write("                          <td nowrap style=""padding-left:3px;padding-right:3px;border-top:solid 1px black;border-right:solid 1px black;border-bottom:solid 1px black;background-color:white;"">" & GetTaskText(Task) & "</td>")
                        output.Write("                          <td style=""width:10px;"">&nbsp;</td>")

                    Else
                        If Not Task.Resolved.HasValue And Task.Due > Now Then 'task here, not resolved, and IS past due

                            output.Write("                      <td style=""width:6px;border-top:solid 1px black;border-bottom:solid 1px black;border-right:solid 1px black;background-color:red;"">&nbsp;</td>")
                            output.Write("                      <td nowrap style=""padding-left:3px;padding-right:3px;border-top:solid 1px black;border-right:solid 1px black;border-bottom:solid 1px black;background-color:white;"">" & GetTaskText(Task) & "</td>")
                            output.Write("                      <td style=""width:10px;"">&nbsp;</td>")

                        Else 'task here, not resolved, but is NOT past due

                            output.Write("                      <td style=""width:6px;border-top:solid 1px black;border-bottom:solid 1px black;border-right:solid 1px black;background-color:blue;"">&nbsp;</td>")
                            output.Write("                      <td nowrap style=""padding-left:3px;padding-right:3px;border-top:solid 1px black;border-right:solid 1px black;border-bottom:solid 1px black;background-color:white;"">" & GetTaskText(Task) & "</td>")
                            output.Write("                      <td style=""width:10px;"">&nbsp;</td>")

                        End If
                    End If

                    output.Write("                          </tr>")
                    output.Write("                      </table>")
                    output.Write("                  </td>")

                Else 'no respons. here

                    output.Write("              <td style=""height:27px;border-right:solid 1px black;"">")
                    output.Write("                  <a name=""" & CurrentBookmark & """></a>")
                    output.Write("                  <table ondblclick=""ASI_TC_Task_AddNew('" & CurrentInstance.ToString("yyyyMMddHH") & "');"" style=""width:100%;height:100%;font-size:11px;width:100%;"" cellpadding=""0"" cellspacing=""0"" border=""0"">")
                    output.Write("                      <tr>")
                    output.Write("                          <td style=""width:6px;border-right:solid 1px black;background-color:white;"">&nbsp;</td>")
                    output.Write("                          <td style=""border-bottom:solid 1px rgb(246,219,162);background-color:" & BackgroundColor & ";"">&nbsp;</td>")
                    output.Write("                      </tr>")
                    output.Write("                  </table>")
                    output.Write("              </td>")

                End If

            Next

            output.Write("              </tr>")

        Next

        output.Write("              </table>")
        output.Write("          </div>")
        output.Write("      </td>")
        output.Write("  </tr>")
        output.Write("</table>")

    End Sub
    Private Function GetDayContent(ByVal CurrentDay As DateTime) As String

        Dim Tasks As List(Of Task) = GetTasks(CurrentDay)

        Dim BorderColor As String = String.Empty
        Dim BackgroundColor As String = String.Empty

        If Tasks.Count > 0 Then

            GetDayContent = "<div style=""padding-right:4px;height:100%;width:100%;overflow:auto;"">"
            GetDayContent += "   <table style=""font-family:tahoma;font-size:11px;table-layout:fixed;width:100%;"" cellpadding=""0"" cellspacing=""3"" border=""0"">"

            For i As Integer = 0 To Tasks.Count - 1

                GetDayContent += "<tr>"

                If Tasks(i).Resolved.HasValue Then  'resolved
                    BorderColor = "rgb(0,159,0)"
                    BackgroundColor = "rgb(230,255,230)"
                Else
                    If Not Tasks(i).Resolved.HasValue And Tasks(i).Due < Now Then   'past due
                        BorderColor = "red"
                        BackgroundColor = "rgb(255,230,230)"
                    Else
                        BorderColor = "blue"
                        BackgroundColor = "rgb(230,230,255)"
                    End If
                End If

                GetDayContent += "  <td onclick=""ASI_TC_Task_OnDblClick(" & Tasks(i).TaskID & ");"" nowrap style=""cursor:pointer;filter:progid:DXImageTransform.Microsoft.Shadow(color='#a1a1a1', Direction=135, Strength=3);border:solid 1px " & BorderColor & ";background-color:" & BackgroundColor & ";"">"

                GetDayContent += GetTaskText(Tasks(i))

                GetDayContent += "  </td>"
                GetDayContent += "</tr>"

            Next

            GetDayContent += "   </table>"
            GetDayContent += "</div>"

        Else
            GetDayContent = "&nbsp;"
        End If

    End Function
    Private Function GetTaskText(ByVal Task As Task) As String

        If Task.TaskTypeName.Length > 0 Then
            Return "&nbsp;" & Task.TaskTypeName
        Else
            Return "&nbsp;" & Task.Description
        End If

    End Function
    Private Function GetTask(ByVal CurrentInstance As DateTime) As Task

        For i As Integer = 0 To Tasks.Count - 1

            If Tasks(i).Due = CurrentInstance Then
                Return Tasks(i)
            End If

        Next

        Return Nothing

    End Function
    Private Function GetTasks(ByVal CurrentDay As DateTime) As List(Of Task)

        Dim tl As New List(Of Task)

        For i As Integer = 0 To Tasks.Count - 1

            If Tasks(i).Due.Date = CurrentDay.Date Then
                tl.Add(Tasks(i))
            End If

        Next

        Return tl

    End Function
    Protected Sub RegisterScript()

        Dim sb As New StringBuilder

        sb.Append(vbCrLf & vbCrLf & "<script type=text/javascript>" & vbCrLf & vbCrLf)
        sb.Append("//Product: Responsibility Calendar" & vbCrLf)
        sb.Append("//Release: 1.0" & vbCrLf)
        sb.Append("//Company: Assisted Solutions, Inc." & vbCrLf)
        sb.Append("//Website: http://www.assistedsolutions.com" & vbCrLf & vbCrLf)
        sb.Append("//This component has been copyrighted by Assisted Solutions, Inc.  It is not to be altered " & vbCrLf)
        sb.Append("//or distributed, except as part of an application.  This component represents a product which must " & vbCrLf)
        sb.Append("//have been purchased under licensing agreements set by Assisted Solutions, Inc. " & vbCrLf)
        sb.Append("//This product MAY NOT be sold for re-sale at any time " & vbCrLf)
        sb.Append("//by any organization or group without the express, written permissions of Assisted Solutions, Inc." & vbCrLf & vbCrLf)
        sb.Append("//This component is distributed ""AS IS"" with no warranty expressed or implied." & vbCrLf & vbCrLf)

        sb.Append(vbCrLf & vbCrLf & "</script>" & vbCrLf & vbCrLf)

        Page.ClientScript.RegisterClientScriptBlock(GetType(String), "AssistedSolutions.WebControls.TaskCalendar", sb.ToString())

    End Sub
    Private Sub TaskCalendar_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub
End Class