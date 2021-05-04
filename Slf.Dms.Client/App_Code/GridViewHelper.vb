Imports Microsoft.VisualBasic

Public Class GridViewHelper
    ''' <param name="sortDir">Sort direction - either ascending (<c>SortDirection.Ascending</c>) or descending (<c>SortDirection.Descending</c>).</param>
    ''' <param name="sortExpr">Sort expression which is a database field.</param>
    ''' <param name="grid">ASP.NET GridView control.</param>
    ''' <remarks>
    ''' <para>Called from a grid's "Sorting" event, e.g. 
    ''' <code>AppendSortOrderImageToGridHeader(e.SortDirection, e.SortExpression, [gridname])</code>.
    ''' </para>
    ''' </remarks>
    Public Shared Sub AppendSortOrderImageToGridHeader(ByVal sortDir As System.Web.UI.WebControls.SortDirection, _
            ByVal sortExpr As String, ByRef grid As System.Web.UI.WebControls.GridView)

        ' looping variable 
        Dim i As Integer
        ' did we find the column header that's being sorted?
        Dim foundColumnIndex As Integer = -1

        ' constants for sort orders
        Const SORT_ASC As String = "<span style='font-family: Webdings; '> 5</span>"
        Const SORT_DESC As String = "<span style='font-family: Webdings; '> 6</span>"

        ' get which column we're sorting on
        For i = 0 To grid.Columns.Count - 1
            ' remove the current sort
            grid.Columns(i).HeaderStyle.CssClass = "headItem5"
            grid.Columns(i).HeaderText = grid.Columns(i).HeaderText.Replace(SORT_ASC, String.Empty)
            grid.Columns(i).HeaderText = grid.Columns(i).HeaderText.Replace(SORT_DESC, String.Empty)
            ' if the sort expression of this column matches the passed sort expression, 
            ' keep the column number and mark that we've found a match for further processing
            If sortExpr = grid.Columns(i).SortExpression Then
                ' store the column number, but we need to keep going through the loop
                ' to remove all the previous sorts
                foundColumnIndex = i
            End If
        Next

        ' if we found the sort column, append the sort direction 
        If foundColumnIndex > -1 Then
            ' append either ascending or descending string
            If sortDir = SortDirection.Ascending Then
                grid.Columns(foundColumnIndex).HeaderText &= SORT_ASC
            Else
                grid.Columns(foundColumnIndex).HeaderText &= SORT_DESC
            End If

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
                        tc.Controls.Clear()
                        Dim tbl As New Table
                        tbl.CssClass = "entry"
                        Dim tr As New TableRow
                        Dim td As New TableCell

                        td.Controls.Add(lnk)
                        tr.Cells.Add(td)

                        td = New TableCell
                        td.Width = 10
                        Dim glyph As New Label
                        glyph.EnableTheming = False
                        glyph.Font.Name = "webdings"
                        glyph.Font.Size = FontUnit.Small
                        glyph.Text = IIf(gv.SortDirection = SortDirection.Ascending, " 5", " 6").ToString
                        td.Controls.Add(glyph)
                        tr.Cells.Add(td)
                        tr.Style("height") = "auto"
                        tbl.Rows.Add(tr)
                        tc.Controls.Add(tbl)
                    End If
                End If
            End If
        Next
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
End Class
