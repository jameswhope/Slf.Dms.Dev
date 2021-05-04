Option Explicit On

Imports Slf.Dms.Records

Imports System.Web.UI
Imports System.ComponentModel
Imports System.Web.HttpContext
Imports System.Web.HttpServerUtility

<ToolboxData("<{0}:RoadmapGrid runat=server></{0}:RoadmapGrid>")> _
Public Class RoadmapGrid
    Inherits Control

#Region "Variables"

    Private _roadmaps As Dictionary(Of Integer, Roadmap)
    Private _roadmapsMaster As Dictionary(Of Integer, Roadmap)

#End Region

#Region "Properties"

    <Browsable(False)> _
    ReadOnly Property Roadmaps() As Dictionary(Of Integer, Roadmap)
        Get

            If _roadmaps Is Nothing Then
                _roadmaps = New Dictionary(Of Integer, Roadmap)
            End If

            Return _roadmaps

        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New()
        _roadmapsMaster = New Dictionary(Of Integer, Roadmap)
    End Sub

#End Region

    Protected Overrides Sub Render(ByVal output As System.Web.UI.HtmlTextWriter)

        'render the header
        output.Write("<table onselectstart=""return false;"" class=""rmgTable"" cellSpacing=""0"" cellPadding=""0"" border=""0"">")
        output.Write("  <tr>")
        output.Write("      <td class=""rmgHeaderStatus""></td>")
        output.Write("      <td class=""rmgHeaderStatus"">Action</td>")
        output.Write("      <td class=""rmgHeaderCreated"">When</td>")
        output.Write("      <td class=""rmgHeaderFacilitator"">Facilitated By</td>")
        output.Write("  </tr>")
        output.Write("</table>")

        'start the recursion
        RenderGridRows(output, Roadmaps, True)

    End Sub
    Private Sub RenderGridRows(ByVal output As HtmlTextWriter, ByVal rms As Dictionary(Of Integer, Roadmap), ByVal IsFirst As Boolean)

        If rms.Count > 0 Then

            output.Write("<table onselectstart=""return false;"" class=""rmgTable"" cellSpacing=""0"" cellPadding=""0"" border=""0"">") 'propertycategory table

            Dim c As Integer = 1

            For Each rm As Roadmap In rms.Values

                Dim IsLast As Boolean = (c = rms.Count)

                Dim Status As String = rm.ClientStatusName

                If rm.Reason.Length > 0 Then
                    Status += " - <font style=""font-style:italic;color:blue;"">" & rm.Reason & "</font>"
                End If

                Dim StatusTable As String = String.Empty

                StatusTable = "<table class=""rmgCellTable"" cellpadding=""0"" cellspacing=""0"" border=""0"">" _
                    & " <tr>"
                StatusTable += "<td class=""rmgCellStatus"" style=""width:35px""><a class=""lnk"" href=""javascript:DeleteConfirm(" & rm.RoadmapID & ")""><img border=""0"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """/></a></td>"
                If IsFirst Then
                    StatusTable += "<td class=""rmgCellStatus"">" & Status & "</td>"
                Else

                    If IsLast Then
                        StatusTable += "<td nowrap=""true"" class=""rmgCellStatus""><img align=""absmiddle"" class=""rmgImage"" src=""" & ResolveUrl("~/images/rootend.png") & """ border=""0"">" & Status & "</td>"
                    Else
                        StatusTable += "<td nowrap=""true"" class=""rmgCellStatus""><img align=""absmiddle"" class=""rmgImage"" src=""" & ResolveUrl("~/images/rootconnector.png") & """ border=""0"">" & Status & "</td>"
                    End If

                End If

                StatusTable += "<td class=""rmgCellCreated"">" & rm.Created.ToString("MMM d, yyyy hh:mm tt") & "</td>" _
                    & "     <td class=""rmgCellFacilitator"">" & rm.CreatedByName & "&nbsp;</td>" _
                    & " </tr>"

                ' add notes
                If rm.Notes.Count > 0 Then

                    StatusTable += "<tr>"
                    StatusTable += "    <td colspan=""4"" class=""rmgCellNote"">"
                    StatusTable += "        <table class=""rmgCellNoteTable"" cellpadding=""3"" cellspacing=""0"" border=""0"">"

                    Dim n As Integer = 1

                    For Each Note As Note In rm.Notes.Values

                        Dim Value As String = Note.Value

                        If Value.Length > 250 Then
                            Value = Value.Substring(0, 250) & "..."
                        End If

                        StatusTable += "</tr>"
                        StatusTable += "  <td class=""rmgCellNoteImage""><img src=""" & ResolveUrl("~/images/16x16_note.png") & """ border=""0"" align=""absmiddle""/></td>"
                        StatusTable += "  <td class=""rmgCellNoteStatus"">" & Value & "</td>"
                        StatusTable += "  <td class=""rmgCellNoteCreated"">" & Note.Created.ToString("MMM d, yyyy hh:mm tt") & "</td>"
                        StatusTable += "  <td class=""rmgCellNoteFacilitator"">" & Note.CreatedByName & "&nbsp;</td>"
                        StatusTable += "</tr>"

                        If n < rm.Notes.Count Then 'more notes to add

                            'add dotted splitter row
                            StatusTable += "</tr>"
                            StatusTable += "  <td colspan=""4"" class=""rmgCellNoteSplitter""><img height=""5"" width=""1"" src=""" & ResolveUrl("~/images/spacer.gif") & """/></td>"
                            StatusTable += "</tr>"

                        End If

                        n += 1

                    Next

                    StatusTable += "        </table>"
                    StatusTable += "    </td>"
                    StatusTable += "</tr>"

                End If

                ' add tasks
                If rm.Tasks.Count > 0 Then

                    StatusTable += "<tr>"
                    StatusTable += "    <td colspan=""4"" class=""" & IIf(rm.Notes.Count > 0, "rmgCellTaskAfterNotes", "rmgCellTask") & """>"
                    StatusTable += "        <table class=""rmgCellTaskTable"" cellpadding=""3"" cellspacing=""0"" border=""0"">"

                    Dim t As Integer = 1

                    For Each Task As Task In rm.Tasks.Values

                        Dim Value As String = Task.Description

                        If Value.Length > 250 Then
                            Value = Value.Substring(0, 250) & "..."
                        End If

                        StatusTable += "</tr>"
                        StatusTable += "  <td class=""rmgCellTaskImage""><img src=""" & ResolveUrl("~/images/16x16_calendar.png") & """ border=""0"" align=""absmiddle""/></td>"
                        StatusTable += "  <td class=""rmgCellTaskStatus"">" & Value & "</td>"

                        If Task.Resolved.HasValue Then
                            StatusTable += "  <td class=""rmgCellTaskResolved""><a style=""color:rgb(0,129,0);"" href=""" & ResolveUrl("~/tasks/task/resolve.aspx?id=" & Task.TaskID) & """ class=""lnk"">RESOLVED</a><br><font class=""rmgCellTaskResolvedDate"">" & Task.Resolved.Value.ToString("MM/dd/yy hh:mm tt") & "</font></td>"
                        Else
                            If Task.Due < Now Then
                                StatusTable += "  <td class=""rmgCellTaskResolved"" style=""color:red;"">PAST DUE<br><a style=""color:#a1a1a1;font-size:9;"" href=""" & ResolveUrl("~/tasks/task/resolve.aspx?id=" & Task.TaskID) & """ class=""lnk"">Resolve</a></td>"
                            Else
                                StatusTable += "  <td class=""rmgCellTaskResolved""><a style=""color:black;"" href=""" & ResolveUrl("~/tasks/task/resolve.aspx?id=" & Task.TaskID) & """ class=""lnk"">OPEN</a></td>"
                            End If
                        End If

                        StatusTable += "  <td class=""rmgCellTaskCreated"">" & Task.Created.ToString("MMM d, yyyy hh:mm tt") & "</td>"
                        StatusTable += "  <td class=""rmgCellTaskFacilitator"">" & Task.CreatedByName & "&nbsp;</td>"
                        StatusTable += "</tr>"

                        If Task.Notes.Count > 0 Then 'this task has notes of it's own to add

                            StatusTable += "<tr>"
                            StatusTable += "    <td colspan=""5"" class=""rmgCellTaskNote"">"
                            StatusTable += "        <table class=""rmgCellTaskNoteTable"" cellpadding=""3"" cellspacing=""0"" border=""0"">"

                            Dim n As Integer = 1

                            For Each Note As Note In Task.Notes.Values

                                Value = Note.Value

                                If Value.Length > 250 Then
                                    Value = Value.Substring(0, 250) & "..."
                                End If

                                StatusTable += "</tr>"
                                StatusTable += "  <td class=""rmgCellTaskNoteImage""><img src=""" & ResolveUrl("~/images/16x16_note.png") & """ border=""0"" align=""absmiddle""/></td>"
                                StatusTable += "  <td class=""rmgCellTaskNoteStatus"">" & Value & "</td>"
                                StatusTable += "  <td class=""rmgCellTaskNoteCreated"">" & Note.Created.ToString("MMM d, yyyy hh:mm tt") & "</td>"
                                StatusTable += "  <td class=""rmgCellTaskNoteFacilitator"">" & Note.CreatedByName & "&nbsp;</td>"
                                StatusTable += "</tr>"

                                If n < Task.Notes.Count Then 'more notes to add

                                    'add dotted splitter row
                                    StatusTable += "</tr>"
                                    StatusTable += "  <td colspan=""4"" class=""rmgCellTaskNoteSplitter""><img height=""5"" width=""1"" src=""" & ResolveUrl("~/images/spacer.gif") & """/></td>"
                                    StatusTable += "</tr>"

                                End If

                                n += 1

                            Next

                            StatusTable += "        </table>"
                            StatusTable += "    </td>"
                            StatusTable += "</tr>"

                        End If

                        If t < rm.Tasks.Count Then 'more notes to add

                            'add dotted splitter row
                            StatusTable += "</tr>"
                            StatusTable += "  <td colspan=""5"" class=""rmgCellTaskSplitter""><img height=""5"" width=""1"" src=""" & ResolveUrl("~/images/spacer.gif") & """/></td>"
                            StatusTable += "</tr>"

                        End If

                        t += 1

                    Next

                    StatusTable += "        </table>"
                    StatusTable += "    </td>"
                    StatusTable += "</tr>"

                End If

                StatusTable += "</table>"

                'display the roadmap row
                output.Write("  <tr class=""rmgRow"">")

                If IsFirst Then
                    output.Write("      <td class=""rmgCellFirst"">" & StatusTable & "</td>")
                Else
                    output.Write("      <td class=""rmgCell"">" & StatusTable & "</td>")
                End If

                output.Write("  </tr>")

                If rm.Roadmaps.Count > 0 Then

                    output.Write("  <tr>")

                    If IsFirst Then
                        output.Write("      <td class=""rmgHolderFirst"">")
                    Else
                        output.Write("      <td class=""rmgHolder"">")
                    End If

                    'recursively add child roadmaps
                    RenderGridRows(output, rm.Roadmaps, False)

                    output.Write("      </td>")
                    output.Write("  </tr>")

                End If

                c += 1

            Next

            output.Write("</table>")

        End If

    End Sub
    Public Sub AddRoadmap(ByVal RoadmapID As Integer, ByVal ParentRoadmapId As Integer, ByVal ClientID As Integer, ByVal ClientStatusID As Integer, _
        ByVal ParentClientStatusID As Integer, ByVal ClientStatusName As String, ByVal Reason As String, _
        ByVal Created As DateTime, ByVal CreatedBy As Integer, ByVal CreatedByName As String, _
        ByVal LastModified As DateTime, ByVal LastModifiedBy As Integer, ByVal LastModifiedByName As String)

        AddRoadmap(New Roadmap(RoadmapID, ParentRoadmapId, ClientID, ClientStatusID, ParentClientStatusID, _
                ClientStatusName, Reason, Created, CreatedBy, CreatedByName, LastModified, LastModifiedBy, _
                LastModifiedByName))

    End Sub
    Public Sub AddRoadmap(ByVal Roadmap As Roadmap)

        Dim rm As Roadmap = Nothing 'FindRoadmap(Roadmaps, Roadmap.ParentClientStatusID)
        If rm Is Nothing AndAlso _roadmapsMaster.ContainsKey(Roadmap.ParentRoadmapID) Then
            rm = _roadmapsMaster.Item(Roadmap.ParentRoadmapID)
        End If

        If rm Is Nothing Then

            'parent is NOT on tree, so add a new one as a root
            Roadmaps.Add(Roadmap.RoadmapID, Roadmap)

        Else

            'parent IS on tree, so add a new one as child to that parent
            rm.Roadmaps.Add(Roadmap.RoadmapID, Roadmap)

        End If

        _roadmapsMaster(Roadmap.RoadmapID) = Roadmap
    End Sub
    'Private Function FindRoadmap(ByVal Roadmaps As Dictionary(Of Integer, Roadmap), _
    '    ByVal ClientStatusID As Integer) As Roadmap

    '    For Each rm As Roadmap In Roadmaps.Values

    '        If rm.ClientStatusID = ClientStatusID Then
    '            Return rm
    '        Else
    '            Return FindRoadmap(rm.Roadmaps, ClientStatusID)
    '        End If

    '    Next

    '    Return Nothing
    'End Function
End Class