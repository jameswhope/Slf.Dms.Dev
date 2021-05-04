Option Explicit On

Imports Slf.Dms.Records

Imports System.Web.UI
Imports System.ComponentModel
Imports System.Web.HttpContext
Imports System.Web.HttpServerUtility

<ToolboxData("<{0}:PropertyGrid runat=server></{0}:PropertyGrid>")> _
Public Class PropertyGrid
    Inherits Control

#Region "Variables"

    Private _propertycategories As Dictionary(Of String, PropertyCategory)

#End Region

#Region "Properties"

    <Browsable(False)> _
    ReadOnly Property PropertyCategories() As Dictionary(Of String, PropertyCategory)
        Get

            If _propertycategories Is Nothing Then
                _propertycategories = New Dictionary(Of String, PropertyCategory)
            End If

            Return _propertycategories

        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New()

    End Sub

#End Region

    Protected Overrides Sub Render(ByVal output As System.Web.UI.HtmlTextWriter)

        RenderGridRows(output)

    End Sub
    Private Sub RenderGridRows(ByVal output As HtmlTextWriter)

        If PropertyCategories.Count > 0 Then

            output.Write("<table onselectstart=""return false;"" class=""pgCategoryTable"" cellSpacing=""0"" cellPadding=""0"" border=""0"">") 'propertycategory table

            For Each pc As PropertyCategory In PropertyCategories.Values

                'display the propertycategory row
                output.Write("  <tr class=""pgCategoryHeaderHolder"">")
                output.Write("      <td onmouseup=""FolderClick(this);"" onmouseover=""FolderShow(this, true);"" onmouseout=""FolderShow(this, false);"" class=""pgCategoryHeader""><img align=""absmiddle"" class=""pgImageFolderPlus"" src=""" & ResolveUrl("~/images/tree_plus.bmp") & """ border=""0""><img style=""display:none;"" align=""absmiddle"" class=""pgImageFolderMinus"" src=""" & ResolveUrl("~/images/tree_minus.bmp") & """ border=""0""><img align=""absmiddle"" class=""pgImageFolder"" src=""" & ResolveUrl("~/images/16x16_properties.png") & """ border=""0"">" & pc.Name & "</td>")
                output.Write("  </tr>")

                If pc.Properties.Count > 0 Then

                    output.Write("  <tr>")
                    output.Write("      <td style=""display:none;"" class=""pgCategoryBody"">")
                    output.Write("          <table onselectstart=""return false;"" class=""pgDocumentTable"" cellSpacing=""0"" cellPadding=""0"" border=""0"">") 'property table

                    Dim k As Integer = 1

                    For Each p As [Property] In pc.Properties.Values

                        'display the document row
                        output.Write("          <tr>")

                        If k = pc.Properties.Count Then 'last property under this propertycategory
                            output.Write("              <td onmouseup=""FileClick(this, " & p.PropertyID & ");"" onmouseover=""FileShow(this, true);"" onmouseout=""FileShow(this, false);"" class=""pgDocumentRowRootConnector"" align=""right""><img class=""pgImageRootConnector"" align=""absmiddle"" src=""" & ResolveUrl("~/images/rootend.png") & """ border=""0""></td>")
                        Else
                            output.Write("              <td onmouseup=""FileClick(this, " & p.PropertyID & ");"" onmouseover=""FileShow(this, true);"" onmouseout=""FileShow(this, false);"" class=""pgDocumentRowRootConnector"" align=""right""><img class=""pgImageRootConnector"" align=""absmiddle"" src=""" & ResolveUrl("~/images/rootconnector.png") & """ border=""0""></td>")
                        End If

                        output.Write("              <td onmouseup=""FileClick(this, " & p.PropertyID & ");"" onmouseover=""FileShow(this, true);"" onmouseout=""FileShow(this, false);"" class=""pgRowName""><img class=""pgImageFile"" align=""absmiddle"" src=""" & ResolveUrl("~/images/16x16_redball_small.png") & """ border=""0"">" & p.Display & "</td>")

                        Dim Value As String = p.Value

                        If Not p.Multi Then

                            Select Case p.Type.ToLower
                                Case "dollar amount"
                                    Value = Double.Parse(p.Value).ToString("$#,##0.00")
                                Case "percentage"
                                    Value = Double.Parse(p.Value).ToString("#,##0.00%")
                                Case "number"
                                    Value = Double.Parse(p.Value).ToString("#,##0.00")
                            End Select

                        Else

                            Dim Values() As String = Value.Split("|")

                            For i As Integer = 0 To Values.Length - 1

                                Select Case p.Type.ToLower
                                    Case "dollar amount"
                                        Values(i) = Double.Parse(Values(i)).ToString("$#,##0.00")
                                    Case "percentage"
                                        Values(i) = Double.Parse(Values(i)).ToString("#,##0.00%")
                                    Case "number"
                                        Value = Double.Parse(p.Value).ToString("#,##0.00")
                                End Select

                            Next

                            Value = String.Join(", ", Values)

                        End If

                        If Value.Length > 20 Then
                            Value = Value.Substring(0, 20) & "..."
                        End If

                        output.Write("              <td onmouseup=""FileClick(this, " & p.PropertyID & ");"" onmouseover=""FileShow(this, true);"" onmouseout=""FileShow(this, false);"" class=""pgRowValue"" align=""right"">" & Value & "</td>")
                        output.Write("              <td onmouseup=""FileClick(this, " & p.PropertyID & ");"" onmouseover=""FileShow(this, true);"" onmouseout=""FileShow(this, false);"" class=""pgRowLastModified"">" & p.LastModifed.ToString("M/d/yyyy hh:mm tt") & "</td>")
                        output.Write("              <td onmouseup=""FileClick(this, " & p.PropertyID & ");"" onmouseover=""FileShow(this, true);"" onmouseout=""FileShow(this, false);"" class=""pgRowLastModifiedBy"">" & IIf(p.LastModifiedByName = String.Empty, "DRG DEVGROUP", p.LastModifiedByName) & "</td>")
                        output.Write("          </tr>")

                        k += 1

                    Next

                    output.Write("          </table>")
                    output.Write("      </td>")
                    output.Write("  </tr>")

                End If

            Next

            output.Write("</table>") 'propertycategory table

        End If

    End Sub
    Public Sub AddProperty(ByVal PropertyCategoryID As Integer, ByVal PropertyCategoryName As String, _
        ByVal PropertyID As Integer, ByVal Name As String, ByVal Display As String, ByVal Multi As Boolean, _
        ByVal Value As String, ByVal Type As String, ByVal Description As String, ByVal Created As DateTime, _
        ByVal CreatedBy As Integer, ByVal CreatedByName As String, ByVal LastModified As DateTime, _
        ByVal LastModifiedBy As Integer, ByVal LastModifiedByName As String)

        Dim pc As PropertyCategory = Nothing

        If Not PropertyCategories.TryGetValue(PropertyCategoryName, pc) Then 'propertycategory node is NOT on tree

            'create a new one
            pc = New PropertyCategory(PropertyCategoryID, PropertyCategoryName)

            PropertyCategories.Add(PropertyCategoryName, pc)

        End If

        Dim p As New [Property](PropertyID, PropertyCategoryID, Name, Display, Multi, Value, Type, _
            Description, Created, CreatedBy, CreatedByName, LastModified, LastModifiedBy, LastModifiedByName)

        pc.Properties.Add(Name, p)

    End Sub
End Class