Imports System
Imports System.Configuration
Imports System.Data
Imports System.IO
Imports System.Web
Imports System.Web.Security
Imports System.Web.UI
Imports System.Web.UI.HtmlControls
Imports System.Web.UI.WebControls
Imports System.Web.UI.WebControls.WebParts

Imports Microsoft.VisualBasic

Public Class GridViewHelper

    #Region "Methods"
    Public Shared Sub AddJqueryUI(ByRef gv As GridView)
        If gv.Rows.Count > 0 Then
            With gv
                .UseAccessibleHeader = True
                .HeaderRow.TableSection = TableRowSection.TableHeader
                .HeaderRow.CssClass = "ui-widget-header"
                .RowStyle.CssClass = "ui-widget-content"
                .FooterRow.TableSection = TableRowSection.TableFooter

                If Not IsNothing(.TopPagerRow) Then
                    .TopPagerRow.TableSection = TableRowSection.TableHeader
                End If

                If Not IsNothing(.BottomPagerRow) Then
                    .BottomPagerRow.TableSection = TableRowSection.TableFooter
                    .BottomPagerRow.Visible = True
                End If
            End With
        End If
    End Sub
    ''' <summary>
    ''' adds proper sort images  to columns when sorting gridview
    ''' </summary>
    ''' <param name="gv">gridview to apply sorting images to</param>
    ''' <param name="e">row args for creating rows</param>
    ''' <remarks> called like below
    ''' Protected Sub gvPhoneProcessing_RowCreated
    '''  Select Case e.Row.RowType
    '''  Case DataControlRowType.Header
    '''         GridViewHelper.AddSortImage(gvPhoneProcessing, e)
    '''
    '''    End Select
    ''' End Sub
    '''</remarks>
    Public Shared Sub AddSortImage(ByRef gv As GridView, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        For Each tc As TableCell In e.Row.Cells
            If tc.HasControls Then
                Dim lnk As LinkButton = TryCast(tc.Controls(0), LinkButton)
                If Not IsNothing(lnk) Then
                    If gv.SortExpression = lnk.CommandArgument Then
                        'tc.Controls.Clear()
                        'Dim tbl As New Table
                        'tbl.CssClass = "entry"
                        'Dim tr As New TableRow
                        'Dim td As New TableCell

                        'td.Controls.Add(lnk)
                        'tr.Cells.Add(td)

                        'td = New TableCell
                        'td.Width = 10
                        Dim glyph As New Label
                        glyph.EnableTheming = False
                        glyph.Font.Name = "webdings"
                        glyph.Font.Size = FontUnit.Small
                        glyph.Text = IIf(gv.SortDirection = SortDirection.Ascending, " 5", " 6").ToString
                        tc.Controls.Add(glyph)
                        'td.Controls.Add(glyph)
                        'tr.Cells.Add(td)
                        'tr.Style("height") = "auto"
                        'tbl.Rows.Add(tr)
                        'tc.Controls.Add(tbl)
                    End If
                End If
            End If
        Next
    End Sub

    Public Shared Sub addHandOnHover(ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        e.Row.Style("cursor") = "pointer"
    End Sub
    Public Shared Sub styleGridviewRows(ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs, Optional ByVal hoverColor As String = "#D6E7F3", _
                                        Optional ByVal rowColor As String = "#fff", _
                                        Optional ByVal AltRowColor As String = "#F7F7DE")


        Dim oColor As String = String.Empty
        If Not IsNothing(TryCast(e.Row.Parent.Parent, GridView).AlternatingRowStyle.BackColor) Then
            Dim cl As Drawing.Color = TryCast(e.Row.Parent.Parent, GridView).AlternatingRowStyle.BackColor
            oColor = Drawing.ColorTranslator.ToHtml(cl)
            AltRowColor = oColor
        End If

        Select Case e.Row.RowState
            Case DataControlRowState.Alternate
                e.Row.Attributes.Add("onmouseout", String.Format("this.style.backgroundColor = '{0}';this.style.cursor= '';", AltRowColor))
            Case DataControlRowState.Normal
                e.Row.Attributes.Add("onmouseout", String.Format("this.style.backgroundColor = '{0}';this.style.cursor= '';", rowColor))
        End Select
        e.Row.Attributes.Add("onmouseover", String.Format("this.style.backgroundColor = '{0}';this.style.cursor = 'pointer';", hoverColor))
    End Sub

    #End Region 'Methods

    #Region "Nested Types"

    Public Class GridViewExportUtil

        #Region "Methods"

        Public Shared Sub Export(ByVal fileName As String, ByVal gv As GridView)
            HttpContext.Current.Response.Clear()
            HttpContext.Current.Response.AddHeader("content-disposition", String.Format("attachment; filename={0}", fileName))
            HttpContext.Current.Response.ContentType = "application/ms-excel"
            Dim sw As StringWriter = New StringWriter
            Dim htw As HtmlTextWriter = New HtmlTextWriter(sw)
            '  Create a form to contain the grid
            Dim table As Table = New Table
            table.GridLines = gv.GridLines
            '  add the header row to the table
            If (Not (gv.HeaderRow) Is Nothing) Then
                GridViewExportUtil.PrepareControlForExport(gv.HeaderRow)
                table.Rows.Add(gv.HeaderRow)
            End If
            '  add each of the data rows to the table
            For Each row As GridViewRow In gv.Rows
                GridViewExportUtil.PrepareControlForExport(row)
                table.Rows.Add(row)
            Next
            '  add the footer row to the table
            If (Not (gv.FooterRow) Is Nothing) Then
                GridViewExportUtil.PrepareControlForExport(gv.FooterRow)
                table.Rows.Add(gv.FooterRow)
            End If
            '  render the table into the htmlwriter
            table.RenderControl(htw)
            '  render the htmlwriter into the response
            HttpContext.Current.Response.Write(sw.ToString)
            HttpContext.Current.Response.End()
        End Sub

        ' Replace any of the contained controls with literals
        Private Shared Sub PrepareControlForExport(ByVal control As Control)
            Dim i As Integer = 0
            Do While (i < control.Controls.Count)
                Dim current As Control = control.Controls(i)
                If (TypeOf current Is LinkButton) Then
                    control.Controls.Remove(current)
                    control.Controls.AddAt(i, New LiteralControl(CType(current, LinkButton).Text))
                ElseIf (TypeOf current Is ImageButton) Then
                    control.Controls.Remove(current)
                    control.Controls.AddAt(i, New LiteralControl(CType(current, ImageButton).AlternateText))
                ElseIf (TypeOf current Is HyperLink) Then
                    control.Controls.Remove(current)
                    control.Controls.AddAt(i, New LiteralControl(CType(current, HyperLink).Text))
                ElseIf (TypeOf current Is DropDownList) Then
                    control.Controls.Remove(current)
                    control.Controls.AddAt(i, New LiteralControl(CType(current, DropDownList).SelectedItem.Text))
                ElseIf (TypeOf current Is CheckBox) Then
                    control.Controls.Remove(current)
                    control.Controls.AddAt(i, New LiteralControl(CType(current, CheckBox).Checked))
                    'TODO: Warning!!!, inline IF is not supported ?
                End If
                If current.HasControls Then
                    GridViewExportUtil.PrepareControlForExport(current)
                End If
                i = (i + 1)
            Loop
        End Sub

        #End Region 'Methods

    End Class

#End Region 'Nested Types

End Class

Public Class CheckboxTemplate
    Implements ITemplate

#Region "Fields"

    Private _ctlName As String
    Private _lit As ListItemType

#End Region 'Fields

#Region "Constructors"

    Public Sub New(ByVal TypeOfList As ListItemType)
        _lit = TypeOfList
    End Sub

#End Region 'Constructors

#Region "Methods"

    Public Sub InstantiateIn(ByVal container As System.Web.UI.Control) Implements System.Web.UI.ITemplate.InstantiateIn
        Select Case _lit
            Case DataControlRowType.Header
                Dim lc As New CheckBox
                lc.ID = "chk_selectAll"
                lc.Attributes.Add("onclick", "checkAll(this);")
                container.Controls.Add(lc)
                Exit Select
            Case ListItemType.Item
                Dim chk As New CheckBox
                chk.ID = "chk_select"
                container.Controls.Add(chk)

        End Select
    End Sub



#End Region 'Methods

End Class

Public Class GridViewTemplate
    Implements ITemplate

    Private _type As ListItemType
    Private _idCol As String
    Private _textCol As String

    Public Sub New(ByVal type As ListItemType, ByVal idCol As String)
        _type = type
        _idCol = idCol
        '_textCol = textCol
    End Sub

    Private Sub InstantiateIn(ByVal container As System.Web.UI.Control) Implements ITemplate.InstantiateIn
        Select Case _type
            Case ListItemType.Item
                Dim ht As New HyperLink()
                ht.Font.Underline = True
                AddHandler ht.DataBinding, AddressOf ht_DataBinding
                container.Controls.Add(ht)
        End Select
    End Sub

    Private Sub ht_DataBinding(ByVal sender As Object, ByVal e As EventArgs)
        Dim lnk As HyperLink = DirectCast(sender, HyperLink)
        Dim container As GridViewRow = DirectCast(lnk.NamingContainer, GridViewRow)
        Dim dataValue As Object = DataBinder.Eval(container.DataItem, _idCol)
        If Not dataValue Is DBNull.Value Then
            lnk.Text = dataValue.ToString()
            lnk.NavigateUrl = String.Format("javascript: ShowCampaigns({0},'{1}');", dataValue.ToString, dataValue.ToString)
        End If
    End Sub

End Class