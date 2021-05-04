Option Explicit On

Imports Slf.Dms.Records

Imports System.Web.UI
Imports System.ComponentModel
Imports System.Web.HttpContext
Imports System.Web.HttpServerUtility

<ToolboxData("<{0}:RoadmapGridSmall runat=server></{0}:RoadmapGridSmall>")> _
Public Class RoadmapGridSmall
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
        output.Write("<table onselectstart=""return false;"" class=""rmgsTable"" cellSpacing=""0"" cellPadding=""0"" border=""0"">")
        output.Write("  <tr>")
        output.Write("      <td class=""rmgsHeaderStatus"">Action</td>")
        output.Write("      <td class=""rmgsHeaderCreated"">When</td>")
        output.Write("  </tr>")
        output.Write("</table>")

        'start the recursion
        RenderGridRows(output, Roadmaps, True)

    End Sub
    Private Sub RenderGridRows(ByVal output As HtmlTextWriter, ByVal rms As Dictionary(Of Integer, Roadmap), ByVal IsFirst As Boolean)

        If rms.Count > 0 Then

            output.Write("<table onselectstart=""return false;"" class=""rmgsTable"" cellSpacing=""0"" cellPadding=""0"" border=""0"">") 'propertycategory table

            Dim c As Integer = 1

            For Each rm As Roadmap In rms.Values

                Dim IsLast As Boolean = (c = rms.Count)

                'display the roadmap row
                output.Write("  <tr class=""rmgsRow"">")

                If IsFirst Then
                    output.Write("  <td colspan=""2"" nowrap=""true"" class=""rmgsCellStatusFirst"">" & rm.ClientStatusName & "</td>")
                Else

                    If IsLast Then
                        output.Write("<td nowrap=""true"" class=""rmgsCellImage""><img align=""absmiddle"" class=""rmgsImage"" src=""" & ResolveUrl("~/images/rootend2.png") & """ border=""0""></td>")
                    Else
                        output.Write("<td nowrap=""true"" class=""rmgsCellImage""><img align=""absmiddle"" class=""rmgsImage"" src=""" & ResolveUrl("~/images/rootconnector2.png") & """ border=""0""></td>")
                    End If

                    output.Write("      <td nowrap=""true"" class=""rmgsCellStatus"">" & rm.ClientStatusName & "</td>")

                End If

                output.Write("      <td nowrap=""true"" class=""rmgsCellCreated"">" & rm.Created.ToString("MM/dd/yy") & "</td>")
                output.Write("  </tr>")

                If rm.Roadmaps.Count > 0 Then

                    output.Write("  <tr>")

                    If IsFirst Then
                        output.Write("      <td colspan=""3"" class=""rmgsHolderFirst"">")
                    Else
                        output.Write("      <td colspan=""3"" class=""rmgsHolder"">")
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

    'End Function
End Class