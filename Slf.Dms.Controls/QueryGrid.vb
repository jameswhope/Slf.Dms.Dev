Option Explicit On

Imports Slf.Dms.Records
Imports System.Collections.Specialized
Imports System.Collections.Generic
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls
Imports System.ComponentModel
Imports System.Web.HttpContext
Imports System.Web.HttpServerUtility
Imports System.Text
Imports System.IO
Imports System.Data
Imports Drg.Util.Helpers
Imports Drg.Util.DataHelpers
Imports Drg.Util.DataAccess
<ToolboxData("<{0}:QueryGrid runat=server></{0}:QueryGrid>")> _
Public Class QueryGrid
    Inherits GridBase

#Region "Instance Field"
    Private _NoWrap As Boolean

    Private txtPage As TextBox

    Private _AllowAction As Boolean
    Private _ActionButtonID As String = ""
    Private txtSelected As HtmlInputHidden
    Private _SelectedValues As String
#End Region
#Region "Property"
    Public Property ActionButtonID() As String
        Get
            Return _ActionButtonID
        End Get
        Set(ByVal value As String)
            _ActionButtonID = value
        End Set
    End Property
    Public ReadOnly Property SelectedValues() As List(Of Integer)
        Get
            Dim lstIds As New List(Of Integer)
            If _SelectedValues.Length > 0 Then
                Dim strIds As String() = _SelectedValues.Split(",")
                For Each s As String In strIds
                    lstIds.Add(Integer.Parse(s))
                Next
            End If
            Return lstIds
        End Get
    End Property
    Public Property AllowAction() As Boolean
        Get
            Return _AllowAction
        End Get
        Set(ByVal value As Boolean)
            _AllowAction = value
        End Set
    End Property
    Public Property NoWrap() As Boolean
        Get
            Return _NoWrap
        End Get
        Set(ByVal value As Boolean)
            _NoWrap = value
        End Set
    End Property
#End Region
#Region "Method"
    Public Function GetSelectedValuesReference() As String
        Return " document.getElementById('" & txtSelected.ClientID & "').value "
    End Function
#End Region
#Region "Render"

    Protected Overrides Sub OnPreRender(ByVal e As EventArgs)
        MyBase.OnPreRender(e)

        'Manually set the page to call control's postback handlers
        If Page IsNot Nothing Then Page.RegisterRequiresPostBack(Me)
    End Sub
    Private Shared Function GetSection(ByVal col As List(Of GridRow), ByVal index As Integer, ByVal size As Integer) As List(Of GridRow)
        ' Returns a list of the specified section of the
        ' provided list of gridrow

        Dim l As New List(Of GridRow)
        If col.Count > 0 Then
            Dim i1 As Integer = Math.Min(index * size, col.Count - 1)
            Dim i2 As Integer = Math.Min(i1 + size - 1, col.Count - 1)

            For i As Integer = i1 To i2
                l.Add(col(i))
            Next
        End If
        Return l
    End Function
    
    Private Function StartupScript() As String
        Dim s As New StringBuilder
        s.Append("var " & Me.ID & "_OrigOnLoadBody = document.body.onload;")
        s.Append("if (" & Me.ID & "_OrigOnLoadBody){")
        s.Append("document.body.onload=function(e){" & Me.ID & "_OrigOnLoadBody(e);" & Me.ID & "_Load();};")
        s.Append("}else{")
        s.Append("document.body.onload=function(e){" & Me.ID & "_Load();};")
        s.Append("}")
        s.Append("function " & Me.ID & "_Load(){")
        s.Append("var tbl = document.getElementById(""" & Me.ID & "_tblGrid"");")
        s.Append("var txtSelected = tbl.nextSibling;")
        s.Append("if(txtSelected.value.length>0){Grid_FixChecks(tbl,txtSelected);}")
        s.Append("}")
        Return s.ToString
    End Function
    Protected Overrides Sub Render(ByVal output As System.Web.UI.HtmlTextWriter)
        SetDefaults()

        'Reset the Selection
        txtSelected.Value = ""
        If AllowAction Then
            output.Write("<script>" & StartupScript() & "</script>")
        End If
        If SortOptions.Allow Then
            Me.Page.ClientScript.RegisterForEventValidation(Me.ClientID & "_lnkResort", "")
            output.Write("<script>" & SortScript() & "</script>")
        End If
        output.Write("<tr>")
        output.Write("<td valign=""top"" style=""height:100%;width:100%"">")
        output.Write("<div style=""width:100%;height:100%;overflow:auto"">")


        output.Write("<table id=""" & Me.ID & "_tblGrid"" class=""" & TableClass & """ " & IIf(ClickOptions.Clickable, " onmousemove=""Grid_RowHover(this, true);"" onmouseout=""Grid_RowHover(this, false);"" ", "") & "onselectstart=""return false;"" style=""font-size:11px;font-family:tahoma;"" cellspacing=""0"" cellpadding=""3"" width=""100%"" border=""0"">")
        output.Write("<thead>")
        output.Write("<tr>")

        'render headers
        If AllowAction Then
            output.Write("<th align=""center"" style=""width:20;""><img onmouseup=""this.style.display='none';this.nextSibling.style.display='inline';Grid_CheckAll(this);"" style=""cursor:pointer;"" title=""Check All"" src=""" & ResolveUrl("~/images/11x11_checkall.png") & """ border=""0"" /><img onmouseup=""this.style.display='none';this.previousSibling.style.display='inline';Grid_UncheckAll(this);"" style=""cursor:pointer;display:none;"" title=""Uncheck All"" src=""" & ResolveUrl("~/images/11x11_uncheckall.png") & """ border=""0"" /></th>")
        End If
        output.Write("<th nowrap style=""width:22;"" align=""center""><img src=""" & ResolveUrl("~/images/16x16_icon.png") & """ border=""0"" align=""absmiddle""/></th>")

        For Each f As GridField In Fields
            output.Write("<th ")
            If SortOptions.Allow And f.Sortable And Not String.IsNullOrEmpty(f.FullyQualifiedDataField) Then
                output.Write("onclick=""" & Me.ID & "_Sort(this)"" fieldName=""" & f.FullyQualifiedDataField & """ ")
            End If
            If Not String.IsNullOrEmpty(f.ForcedWidth) Then
                output.Write(" style=""width:" & f.ForcedWidth & """ ")
            End If
            output.Write("nowrap align=""" & f.Align & """ >" & f.Title)
            If SortOptions.Allow And f.Sortable And SortField = f.FullyQualifiedDataField Then
                output.Write("<img src=""" & ResolveUrl("~/images/sort-" & SortOrder & ".png") & """ align=""absmiddle"" border=""0"" style=""margin-left:5px""/>")
            End If
            output.Write("</th>")
        Next
        output.Write("</tr>")
        output.Write("</thead>")
        output.Write("<tbody>")



        'render rows
        Dim Master As List(Of GridRow) = List
        HandlePager(PageSize, Master.Count)
        Dim l As List(Of GridRow) = GetSection(Master, PageIndex, PageSize)
        If l.Count > 0 Then
            RenderRows(output, l)
        Else
            output.Write("<tr hover=""false"" style=""border-bottom:none""><td colspan=""" & (Fields.Count + IIf(AllowAction, 2, 1)).ToString() & """><div style=""color:#c1c1c1;text-align:center;padding:20 5 5 5;"">You have no results meeting the supplied criteria.</div></td></tr>")
        End If

        output.Write("</tbody>")

        'Following order REQUIRED for Grid javascript functionality
        output.Write("</table>")
        txtSelected.RenderControl(output)
        output.Write("<input type=""hidden"" value=""" & ActionButtonID & """/>")

        MyBase.Render(output)

        output.Write("</td></tr><tr><td>")
        RenderPager(output)
        output.Write("</div>")

        output.Write("</td></tr>")
    End Sub

    Private Sub RenderRows(ByVal output As HtmlTextWriter, ByVal l As List(Of GridRow))
        Dim even As Boolean
        For Each r As GridRow In l
            even = Not even

            If ClickOptions.Clickable Then
                Dim url As String = ""
                If String.IsNullOrEmpty(r.ClickableURL) Then
                    url = ResolveUrl(ClickOptions.ClickableURL)
                    url = url.Replace("$x$", r.KeyId1)
                    If Not ClickOptions.KeyField2 Is Nothing Then
                        url = url.Replace("$y$", r.KeyId2)
                    End If
                Else
                    url = ResolveUrl(r.ClickableURL)
                End If
                output.Write("<a class=""lnk"" href=""" & url & """>")
            End If

            output.Write("<tr KeyID=""" & r.KeyId1 & """ " & IIf(even AndAlso Not ClickOptions.Clickable, "style=""background-color:#f1f1f1;""", "") & ">")

            If AllowAction Then
                output.Write("<td style=""width:20;"" align=""center""><img onmouseup=""this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;"" src=""" & ResolveUrl("~/images/13x13_check_cold.png") & """ border=""0"" align=""absmiddle"" /><img onmouseup=""this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;"" style=""display:none;"" src=""" & ResolveUrl("~/images/13x13_check_hot.png") & """ border=""0"" align=""absmiddle"" /><input onpropertychange=""Grid_CheckOrUncheck(this, this.parentElement.parentElement.KeyID);"" style=""display:none;"" type=""checkbox"" /></td>")
            End If

            output.Write("<td style=""width:22""><img src=""")
            If String.IsNullOrEmpty(r.IconSrcURL) Then
                output.Write(ResolveUrl(IconSrcURL))
            Else
                output.Write(ResolveUrl(r.IconSrcURL))
            End If
            output.Write(""" border=""0""/></td>")

            For i As Integer = 0 To r.Cells.Count - 1
                Dim f As GridField = Fields(i)
                Dim o As Object = r.Cells(i)
                output.Write("<td align=""" & f.Align & """" & IIf(NoWrap, " nowrap", "") & ">")
                WriteValue(output, o, f)
                output.Write("&nbsp;</td>")
            Next

            output.Write("</tr>")
            If ClickOptions.Clickable Then
                output.Write("</a>")
            End If
        Next
    End Sub

#End Region
#Region "Pager"
    Private Sub HandlePager(ByVal PageSize As Single, ByVal SearchCount As Single)
        Dim Pages As Integer = Math.Max(Math.Ceiling(SearchCount / PageSize), 1)

        If SearchCount > 0 Then

            If PageIndex > Pages - 1 Or PageIndex = -1 Then
                PageIndex = Pages - 1
            ElseIf PageIndex < 0 Then
                PageIndex = 0
            End If

            If PageIndex = 0 Then
                lnkFirst.Enabled = False
                lnkFirst.Text = lnkFirst.Text.Replace("first.png", "first_gray.png")
                lnkPrevious.Enabled = False
                lnkPrevious.Text = lnkPrevious.Text.Replace("prev.png", "prev_gray.png")
            End If

            If PageIndex = Pages - 1 Then
                lnkLast.Enabled = False
                lnkLast.Text = lnkLast.Text.Replace("last.png", "last_gray.png")
                lnkNext.Enabled = False
                lnkNext.Text = lnkNext.Text.Replace("next.png", "next_gray.png")
            End If

            txtPage.Text = (PageIndex + 1).ToString()
        Else
            txtPage.Text = "1"
        End If
    End Sub
    Private Sub RenderPager(ByVal output As HtmlTextWriter)
        Dim SearchCount As Integer = List.Count
        Dim Pages As Integer = Math.Max(Math.Ceiling(SearchCount / PageSize), 1)

        output.Write("<table onselectstart=""return false;"" style=""height:25;background-color:rgb(239,236,222);background-image:url(" & ResolveUrl("~/images/grid_bottom_back.bmp") & ");background-repeat:repeat-x;background-position:left bottom;font-size:11px;font-family:tahoma;"" cellspacing=""0"" cellpadding=""0"" width=""100%"" border=""0"">")
        output.Write("<tr>")
        output.Write("<td style=""padding:4 0 4 0;"">")

        lnkFirst.RenderBeginTag(output)
        output.Write(lnkFirst.Text)
        lnkFirst.RenderEndTag(output)

        output.Write("</td>")
        output.Write("<td style=""padding:4 0 4 0;"">")

        lnkPrevious.RenderBeginTag(output)
        output.Write(lnkPrevious.Text)
        lnkPrevious.RenderEndTag(output)

        output.Write("</td>")
        output.Write("<td><img style=""margin:0 5 0 5;"" border=""0"" src=""" & ResolveUrl("~/images/grid_bottom_separator.png") & """ /></td>")
        output.Write("<td nowrap=""true"">Page&nbsp;&nbsp;")

        txtPage.RenderControl(output)

        output.Write("&nbsp;&nbsp;of&nbsp;" & Pages & "</td>")
        output.Write("<td><img style=""margin:0 5 0 5;"" border=""0"" src=""" & ResolveUrl("~/images/grid_bottom_separator.png") & """ /></td>")
        output.Write("<td style=""padding:4 0 4 0;"">")

        lnkNext.RenderBeginTag(output)
        output.Write(lnkNext.Text)
        lnkNext.RenderEndTag(output)

        output.Write("</td>")
        output.Write("<td style=""padding:4 0 4 0;"">")

        lnkLast.RenderBeginTag(output)
        output.Write(lnkLast.Text)
        lnkLast.RenderEndTag(output)

        output.Write("</td>")
        output.Write("<td style=""width:100%;"">&nbsp;</td>")
        output.Write("<td style=""padding-right:7;"" nowrap=""true"" align=""right"">Results:&nbsp;" & SearchCount & "</td>")
        output.Write("</tr>")
        output.Write("</table>")
    End Sub
    Protected Overrides Sub SetupControls()
        MyBase.SetupControls()

        txtSelected = New HtmlInputHidden
        txtSelected.ID = Me.ID & "_txtSelected"

        lnkFirst = New LinkButton
        lnkFirst.ID = Me.ID & "_lnkFirst"
        lnkFirst.CssClass = "gridButton"
        lnkFirst.Style("padding-top") = "1"
        lnkFirst.Text = "<img align=""absmiddle"" src=""" & ResolveUrl("~/images/16x16_selector_first.png") & """ border=""0""/>"

        lnkPrevious = New LinkButton
        lnkPrevious.ID = Me.ID & "_lnkPrevious"
        lnkPrevious.CssClass = "gridButton"
        lnkPrevious.Style("padding-top") = "1"
        lnkPrevious.Text = "<img align=""absmiddle"" src=""" & ResolveUrl("~/images/16x16_selector_prev.png") & """ border=""0""/>"

        txtPage = New TextBox
        txtPage.ID = Me.ID & "_txtPage"
        txtPage.CssClass = "entry2"
        txtPage.AutoPostBack = True
        txtPage.Style("width") = "40"
        txtPage.Style("text-align") = "center"
        txtPage.Attributes("onselectstart") = "event.cancelBubble=true;return true;"

        lnkNext = New LinkButton
        lnkNext.ID = Me.ID & "_lnkNext"
        lnkNext.CssClass = "gridButton"
        lnkNext.Style("padding-top") = "1"
        lnkNext.Text = "<img align=""absmiddle"" src=""" & ResolveUrl("~/images/16x16_selector_next.png") & """ border=""0""/>"

        lnkLast = New LinkButton
        lnkLast.ID = Me.ID & "_lnkLast"
        lnkLast.CssClass = "gridButton"
        lnkLast.Style("padding-top") = "1"
        lnkLast.Text = "<img align=""absmiddle"" src=""" & ResolveUrl("~/images/16x16_selector_last.png") & """ border=""0""/>"

        Me.Controls.Add(txtSelected)

        Me.Controls.Add(lnkFirst)
        Me.Controls.Add(lnkPrevious)
        Me.Controls.Add(txtPage)
        Me.Controls.Add(lnkNext)
        Me.Controls.Add(lnkLast)
    End Sub
#End Region
#Region "Event"
    Public Overrides Function LoadPostData(ByVal postDataKey As String, ByVal postCollection As System.Collections.Specialized.NameValueCollection) As Boolean
        _SelectedValues = postCollection(Me.UniqueID & "_txtSelected")

        If Not String.IsNullOrEmpty(postCollection(Me.UniqueID & "_txtPage")) Then
            PageIndex = Integer.Parse(postCollection(Me.UniqueID & "_txtPage")) - 1
        End If
        MyBase.LoadPostData(postDataKey, postCollection)
    End Function
#End Region
End Class
