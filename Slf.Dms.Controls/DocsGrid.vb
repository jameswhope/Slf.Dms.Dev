Option Explicit On 

Imports Slf.Dms.Records
Imports Slf.Dms.Controls

Imports Drg.Util.Helpers

Imports System.Web.UI
Imports System.ComponentModel
Imports System.Web.HttpContext
Imports System.Web.HttpServerUtility

<ToolboxData("<{0}:DocsGrid runat=server></{0}:DocsGrid>")> _
Public Class DocsGrid
    Inherits Control

#Region "Variables"

    Private _approot As String

    Private _docfolders As List(Of DocFolder)

#End Region

#Region "Properties"

    <Browsable(False)> _
    ReadOnly Property DocFolders() As List(Of DocFolder)
        Get

            If _docfolders Is Nothing Then
                _docfolders = New List(Of DocFolder)
            End If

            Return _docfolders

        End Get
    End Property
    Property AppRoot() As String
        Get
            Return _approot
        End Get
        Set(ByVal value As String)
            _approot = value
        End Set
    End Property

#End Region

#Region "Constructor"

    Public Sub New()

    End Sub

#End Region

    Protected Overrides Sub Render(ByVal output As System.Web.UI.HtmlTextWriter)

        If DocFolders.Count > 0 Then

            output.Write("<table onselectstart=""return false;"" class=""clientdocgrdTableFolders"" cellSpacing=""0"" cellPadding=""0"" border=""0"">")

            For i As Integer = 0 To DocFolders.Count - 1

                RenderChildDocFolders(DocFolders(i), output)

            Next

            output.Write("</table>")

        End If

    End Sub
    Private Sub RenderChildDocFolders(ByVal DocFolder As DocFolder, ByVal output As HtmlTextWriter)

        'display the doc folder row
        output.Write("  <tr>")
        output.Write("      <td nowrap=""true"" class=""clientdocgrdCellFolder"" onmouseup=""FolderClick(this);"" onmouseover=""Show(this, true);"" onmouseout=""Show(this, false);""><img style=""display:none;"" align=""absmiddle"" class=""clientdocgrdImagePlus"" src=""" & _approot & "images/tree_plus.bmp"" border=""0""><img align=""absmiddle"" class=""clientdocgrdImageMinus"" src=""" & _approot & "images/tree_minus.bmp"" border=""0""><img align=""absmiddle"" class=""clientdocgrdImageFolder"" src=""" & _approot & "images/16x16_folder.png"" border=""0"">" & DocFolder.Name & "</td>")
        output.Write("  </tr>")

        'check and add doc folders
        If DocFolder.DocFolders.Count > 0 Then

            output.Write("<tr>")
            output.Write("  <td nowrap=""true"" class=""clientdocgrdCellFolderBody"">")
            output.Write("      <table onselectstart=""return false;"" class=""clientdocgrdTableFolders"" cellSpacing=""0"" cellPadding=""0"" border=""0"">")

            For i As Integer = 0 To DocFolder.DocFolders.Count - 1

                'recursively add down
                RenderChildDocFolders(DocFolder.DocFolders(i), output)

            Next

            output.Write("      </table>") 'folder body
            output.Write("  </td>")
            output.Write("</tr>")

        End If

        'check and add docs
        If DocFolder.Docs.Count > 0 Then

            output.Write("<tr>")
            output.Write("  <td nowrap=""true"" class=""clientdocgrdCellDocBody"">")
            output.Write("      <table onselectstart=""return false;"" class=""clientdocgrdTableFiles"" cellSpacing=""0"" cellPadding=""0"" border=""0"">")

            For i As Integer = 0 To DocFolder.Docs.Count - 1

                Dim Doc As Doc = DocFolder.Docs(i)

                'build the right icon for this file
                Dim Icon As String

                Try

                    Icon = New IO.FileInfo(Doc.Name).Extension.Trim(New Char() {",", "."})

                    If IO.File.Exists(Current.Server.MapPath(_approot & "images/icons/" & Icon & ".png")) Then
                        Icon = "<img class=""clientdocgrdImageIcon"" align=""absmiddle"" src=""" & _approot & "images/icons/" & Icon & ".png"" border=""0"">"
                    Else
                        Icon = "<img class=""clientdocgrdImageIcon"" align=""absmiddle"" src=""" & _approot & "images/icons/xxx.png"" border=""0"">"
                    End If

                Catch ex As Exception
                    Icon = "<img align=""absmiddle"" src=""" & _approot & "images/icons/xxx.png"" border=""0"">"
                End Try

                'display the document row
                output.Write("  <tr>")

                If i = DocFolder.Docs.Count - 1 Then 'last doc under this folder
                    output.Write("  <td nowrap=""true"" onmouseup=""FileClick(this, " & Doc.FileID & ");"" onmouseover=""Show(this, true);"" onmouseout=""Show(this, false);"" class=""clientdocgrdCellRootEnd"" align=""right""><img class=""clientdocgrdImageRootEnd"" align=""absmiddle"" src=""" & _approot & "images/rootend.png"" border=""0""></td>")
                Else
                    output.Write("  <td nowrap=""true"" onmouseup=""FileClick(this, " & Doc.FileID & ");"" onmouseover=""Show(this, true);"" onmouseout=""Show(this, false);"" class=""clientdocgrdCellRootConnector"" align=""right""><img class=""clientdocgrdImageRootConnector"" align=""absmiddle"" src=""" & _approot & "images/rootconnector.png"" border=""0""></td>")
                End If

                Dim Extension As String = IO.Path.GetExtension(Doc.Name)
                Dim Type as String = FileHelper.TypeOpener(Extension)

                If Type.Length = 0 then
                    Type = Extension.Trim(new Char() {"."}).ToUpper() & " File"
                End If

                output.Write("      <td nowrap=""true"" onmouseup=""FileClick(this, " & Doc.FileID & ");"" onmouseover=""Show(this, true);"" onmouseout=""Show(this, false);"" class=""clientdocgrdCellName"">" & Icon & Doc.Name & "</td>")
                output.Write("      <td nowrap=""true"" onmouseup=""FileClick(this, " & Doc.FileID & ");"" onmouseover=""Show(this, true);"" onmouseout=""Show(this, false);"" class=""clientdocgrdCellSize"" align=""right"">" & Doc.SizeFormatted & "</td>")
                output.Write("      <td nowrap=""true"" onmouseup=""FileClick(this, " & Doc.FileID & ");"" onmouseover=""Show(this, true);"" onmouseout=""Show(this, false);"" class=""clientdocgrdCellType""><div nowrap=""true"">" & Type & "</div></td>")
                output.Write("      <td nowrap=""true"" onmouseup=""FileClick(this, " & Doc.FileID & ");"" onmouseover=""Show(this, true);"" onmouseout=""Show(this, false);"" class=""clientdocgrdCellDate"">" & Doc.LastModified.ToString("M/d/yy") & "</td>")
                output.Write("  </tr>")

            Next

            output.Write("      </table>") 'files body
            output.Write("  </td>")
            output.Write("</tr>")

        End If

    End Sub
End Class