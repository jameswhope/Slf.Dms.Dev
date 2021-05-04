Option Explicit On

Imports Slf.Dms.Records
Imports System.Collections.Specialized
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls
Imports System.ComponentModel
Imports System.Web.HttpContext
Imports System.Web.HttpServerUtility
Imports System.Text
Imports System.IO
Imports Drg.Util.Helpers
Imports Drg.Util.DataHelpers
Imports Drg.Util.DataAccess
Imports System.Xml

<ToolboxData("<{0}:StandardGrid2 runat=server></{0}:StandardGrid2>")> _
Public Class StandardGrid2
    Inherits GridBase2
    Implements INamingContainer

#Region "Instance Field"
    Private _phTitle As ITemplate
    Private WithEvents lnkDelete As LinkButton
    Private _ShowTotal As Boolean = True
    Private _ShowTitle As Boolean = True
    Private _ShowPrint As Boolean = True
    Private _Caption As String
    Private txtSelected As HtmlInputHidden
    Private lblPage As Label
    Public Event MultiDelete(ByVal IDs As List(Of Integer))
    Private SelectedValues As String
    Private _AddOptions As New sAddOptions
    Private _DeleteOptions As New sDeleteOptions
#End Region
#Region "Property"
    <DefaultValue(CType(Nothing, String))> _
      <Browsable(False)> _
      <TemplateContainer(GetType(ContainerTemplate))> _
      <PersistenceMode(PersistenceMode.InnerProperty)> _
      Public Overridable Property phTitle() As ITemplate
        Get
            Return _phTitle
        End Get
        Set(ByVal Value As ITemplate)
            _phTitle = Value
        End Set
    End Property
    Public Property ShowPrint() As Boolean
        Get
            Return _ShowPrint
        End Get
        Set(ByVal value As Boolean)
            _ShowPrint = value
        End Set
    End Property
    Public Property ShowTotal() As Boolean
        Get
            Return _ShowTotal
        End Get
        Set(ByVal value As Boolean)
            _ShowTotal = value
        End Set
    End Property
    Public Property ShowTitle() As Boolean
        Get
            Return _ShowTitle
        End Get
        Set(ByVal value As Boolean)
            _ShowTitle = value
        End Set
    End Property

    Public Property AddOptions() As sAddOptions
        Get
            Return _AddOptions
        End Get
        Set(ByVal value As sAddOptions)
            _AddOptions = value
        End Set
    End Property
    Public Property DeleteOptions() As sDeleteOptions
        Get
            Return _DeleteOptions
        End Get
        Set(ByVal value As sDeleteOptions)
            _DeleteOptions = value
        End Set
    End Property
    Public Property Caption() As String
        Get
            Return _Caption
        End Get
        Set(ByVal value As String)
            _Caption = value
        End Set
    End Property
#End Region
#Region "Method"
    Public Overrides Sub SuckXmlGridProperties(ByVal xml As System.Xml.XmlTextReader)
        MyBase.SuckXmlGridProperties(xml)
        Dim s As String = Nothing

        s = xml.GetAttribute("AddOptions.Allow")
        If Not String.IsNullOrEmpty(s) Then
            Me.AddOptions.Allow = Boolean.Parse(s)
        End If
        s = xml.GetAttribute("AddOptions.Caption")
        If Not String.IsNullOrEmpty(s) Then
            Me.AddOptions.Caption = s
        End If
        s = xml.GetAttribute("AddOptions.URL")
        If Not String.IsNullOrEmpty(s) Then
            Me.AddOptions.URL = s
        End If
        s = xml.GetAttribute("AddOptions.IconSrcURL")
        If Not String.IsNullOrEmpty(s) Then
            Me.AddOptions.IconSrcURL = s
        End If
        s = xml.GetAttribute("DeleteOptions.Allow")
        If Not String.IsNullOrEmpty(s) Then
            Me.DeleteOptions.Allow = Boolean.Parse(s)
        End If
        s = xml.GetAttribute("DeleteOptions.ConfirmTitle")
        If Not String.IsNullOrEmpty(s) Then
            Me.DeleteOptions.ConfirmTitle = s
        End If
        s = xml.GetAttribute("DeleteOptions.ConfirmCaption")
        If Not String.IsNullOrEmpty(s) Then
            Me.DeleteOptions.ConfirmCaption = s
        End If
        s = xml.GetAttribute("Caption")
        If Not String.IsNullOrEmpty(s) Then
            Me.Caption = s
        End If
        s = xml.GetAttribute("ShowTotal")
        If Not String.IsNullOrEmpty(s) Then
            Me.ShowTotal = Boolean.Parse(s)
        End If
        s = xml.GetAttribute("ShowPrint")
        If Not String.IsNullOrEmpty(s) Then
            Me.ShowPrint = Boolean.Parse(s)
        End If
        s = xml.GetAttribute("ShowTitle")
        If Not String.IsNullOrEmpty(s) Then
            Me.ShowTitle = Boolean.Parse(s)
        End If
    End Sub
    Public Overrides Sub SetDefaults()
        MyBase.SetDefaults()

        If String.IsNullOrEmpty(ClickOptions.KeyField) Then
            DeleteOptions.Allow = False
        End If
        If String.IsNullOrEmpty(AddOptions.Caption) And String.IsNullOrEmpty(AddOptions.IconSrcURL) Then
            AddOptions.Allow = False
        End If
        If Not Permission Is Nothing Then
            If Permission.CanDo(PermissionHelper.PermissionType.Add) = False Then
                AddOptions.Allow = False
            End If
            If Permission.CanDo(PermissionHelper.PermissionType.DeleteOwn) = False Then
                DeleteOptions.Allow = False
            End If
        End If
    End Sub
#End Region
#Region "Render"
    Protected Overrides Sub OnPreRender(ByVal e As EventArgs)
        MyBase.OnPreRender(e)

        'Manually set the page to call control's postback handlers
        If Page IsNot Nothing Then Page.RegisterRequiresPostBack(Me)
    End Sub

    Private Function GetSection(ByVal src As DataTable, ByVal index As Integer, ByVal size As Integer) As List(Of DataRow)
        ' Returns a list of the specified section of the
        ' provided list of gridrow

        Dim rows As New List(Of DataRow)

        If src.Rows.Count > 0 Then
            'first sort it
            If Not String.IsNullOrEmpty(SortField) And Not String.IsNullOrEmpty(SortOrder) Then
                src.DefaultView.Sort = SortField & " " & SortOrder
            End If

            rows = New List(Of DataRow)(src.Select())

            Dim i1 As Integer = Math.Min(index * size, rows.Count - 1)
            Dim i2 As Integer = Math.Min(i1 + size - 1, rows.Count - 1)

            For i As Integer = src.Rows.Count - 1 To i2 + 1 Step -1
                rows.RemoveAt(i)
            Next
            For i As Integer = i1 - 1 To 0 Step -1
                rows.RemoveAt(i)
            Next
        End If
        Return rows
    End Function
    Private Function DeleteScript() As String
        Dim s As New StringBuilder
        s.Append("function " & Me.ID & "_DeleteConfirm(obj){if(!document.getElementById(""" & Me.ID & "_lnkDeleteConfirm"").disabled){showModalDialog(""" & ResolveUrl("~/util/pop/confirmholder.aspx") & "?f=" & Me.ID & "_Delete&t=" & DeleteOptions.ConfirmTitle & "&m=" & DeleteOptions.ConfirmCaption & """, window, ""status:off;help:off;dialogWidth:400px;dialogHeight:300px;"");}}")
        s.Append("function " & Me.ID & "_Delete(){" & Me.Page.ClientScript.GetPostBackEventReference(lnkDelete, Nothing) & ";}")
        Return s.ToString
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

        If DeleteOptions.Allow Then
            Me.Page.ClientScript.RegisterForEventValidation(Me.ClientID & "_lnkDelete", "")
            output.Write("<script>" & DeleteScript())
            output.Write(StartupScript() & "</script>")
        End If
        If SortOptions.Allow Then
            Me.Page.ClientScript.RegisterForEventValidation(Me.ClientID & "_lnkResort", "")
            output.Write("<script>" & SortScript() & "</script>")
        End If
        If ShowTitle Then
            output.Write("<table style=""font-family:tahoma;font-size:11px;width:100%;background-color:#f5f5f5;padding: 5 5 5 5;"" cellpadding=""0"" cellspacing=""0"" border=""0"">")
            output.Write("<tr>")
            output.Write("<td style=""color:rgb(50,112,163);"">" & Caption & "</td>")
            output.Write("<td align=""right"">")

            If Not phTitle Is Nothing Then
                Dim sp As New PlaceHolder
                phTitle.InstantiateIn(sp)
                sp.RenderControl(output)
                output.Write("&nbsp;&nbsp;|&nbsp;&nbsp;")
            End If

            If DeleteOptions.Allow Then
                output.Write("<a class=""lnk"" id=""" & Me.ID & "_lnkDeleteConfirm"" disabled=""true"" href=""javascript:" & Me.ID & "_DeleteConfirm();"">Delete</a>")
                output.Write("&nbsp;&nbsp;|&nbsp;&nbsp;")
            End If
            If AddOptions.Allow Then
                output.Write("<a class=""lnk"" runat=""server"" href=""" & ResolveUrl(AddOptions.URL) & """><img style=""margin-right:5;"" runat=""server"" src=""" & ResolveUrl(AddOptions.IconSrcURL) & """ border=""0"" align=""absmiddle""/>" & AddOptions.Caption & "</a>")
                output.Write("&nbsp;&nbsp;|&nbsp;&nbsp;")
            End If
            If ShowPrint Then
                output.Write("<a runat=""server"" href=""javascript:window.print();""><img runat=""server"" src=""" & ResolveUrl("~/images/16x16_print.png") & """ border=""0"" align=""absmiddle""/></a>")
            End If
            output.Write("</td></tr>")
            output.Write("</table>")
        End If
        output.Write("<table id=""" & Me.ID & "_tblGrid"" class=""" & TableClass & """ " & IIf(ClickOptions.Clickable, " onmousemove=""Grid_RowHover(this, true);"" onmouseout=""Grid_RowHover(this, false);"" ", "") & "onselectstart=""return false;"" style=""font-size:11px;font-family:tahoma"" cellspacing=""0"" cellpadding=""3"" width=""100%"" border=""0"">")
        output.Write("<thead>")
        output.Write("<tr>")

        'render headers
        If DeleteOptions.Allow Then
            output.Write("<th align=""center"" style=""width:20;""><img onmouseup=""this.style.display='none';this.nextSibling.style.display='inline';Grid_CheckAll(this);"" style=""cursor:pointer;"" title=""Check All"" src=""" & ResolveUrl("~/images/11x11_checkall.png") & """ border=""0"" /><img onmouseup=""this.style.display='none';this.previousSibling.style.display='inline';Grid_UncheckAll(this);"" style=""cursor:pointer;display:none;"" title=""Uncheck All"" src=""" & ResolveUrl("~/images/11x11_uncheckall.png") & """ border=""0"" /></th>")
        End If
        output.Write("<th nowrap style=""width:22;"" align=""center""><img src=""" & ResolveUrl("~/images/16x16_icon.png") & """ border=""0"" align=""absmiddle""/></th>")

        For Each c As DataColumn In Table.Columns
            If c.ExtendedProperties("Display") = True Then
                output.Write("<th ")
                If SortOptions.Allow And c.ExtendedProperties("Sortable") = True Then
                    output.Write("onclick=""" & Me.ID & "_Sort(this)"" fieldName=""" & c.ColumnName & """ ")
                End If
                If Not String.IsNullOrEmpty(c.ExtendedProperties("ForcedWidth")) Then
                    output.Write(" style=""width:" & c.ExtendedProperties("ForcedWidth") & """ ")
                End If
                output.Write("nowrap align=""" & c.ExtendedProperties("Align") & """ >" & c.Caption)
                If SortOptions.Allow And c.ExtendedProperties("Sortable") = True And SortField = c.ColumnName Then
                    output.Write("<img src=""" & ResolveUrl("~/images/sort-" & SortOrder & ".png") & """ align=""absmiddle"" border=""0"" style=""margin-left:5px""/>")
                End If
                output.Write("</th>")
            End If
        Next
        output.Write("</tr>")
        output.Write("</thead>")
        output.Write("<tbody>")

        'render rows
        Dim Master As DataTable = Table
        HandlePager(PageSize, Master.Rows.Count)
        Dim rows As List(Of DataRow) = GetSection(Master, PageIndex, PageSize)
        RenderRows(output, rows)

        output.Write("</tbody>")

        'only display footer if the pager or total is shown
        output.Write("<tfoot>")
        output.Write("<tr>")
        output.Write("<td colspan=""" & Master.Columns.Count + 2 & """ style=""padding-left:5px"">")
        output.Write("<table cellspacing=""0"" cellpadding=""0"" style=""font-family:tahoma;font-size:11px;width:100%;""><tr><td>")

        RenderControls(output)

        MyBase.Render(output)

        output.Write("</td>")
        If ShowTotal Then 'Render total at the bottom 
            output.Write("<td align=""right"" style=""padding-right:5px"">Total: " & Master.Rows.Count & "</td>")
        End If
        output.Write("</tr></table></td></tr>")
        output.Write("</tfoot>")

        'Following order REQUIRED for Grid javascript functionality
        output.Write("</table>")
        txtSelected.RenderControl(output)
        output.Write("<input type=""hidden"" value=""" & Me.ID & "_lnkDeleteConfirm""/>")
    End Sub

    Private Sub RenderRows(ByVal writer As HtmlTextWriter, ByVal rows As List(Of DataRow))
        Dim even As Boolean
        For Each r As DataRow In rows
            even = Not even

            If ClickOptions.Clickable Then
                Dim url As String = ""
                If String.IsNullOrEmpty(GetColumn(r, "ClickableURL")) Then
                    url = ResolveUrl(ClickOptions.ClickableURL)
                    url = url.Replace("$x$", GetColumn(r, Me.ClickOptions.KeyField))
                    If Not ClickOptions.KeyField2 Is Nothing Then
                        url = url.Replace("$y$", GetColumn(r, Me.ClickOptions.KeyField2))
                    End If
                Else
                    url = ResolveUrl(GetColumn(r, "ClickableURL", ""))
                End If
                writer.Write("<a class=""lnk"" href=""" & url & """>")
            End If

            writer.Write("<tr KeyID=""" & GetColumn(r, ClickOptions.KeyField, "") & """ " & IIf(even AndAlso Not ClickOptions.Clickable, "style=""background-color:#f1f1f1;""", "") & ">")

            If DeleteOptions.Allow Then
                writer.Write("<td style=""width:20;"" align=""center""><img onmouseup=""this.style.display='none';this.nextSibling.style.display='inline';this.nextSibling.nextSibling.checked=true;"" src=""" & ResolveUrl("~/images/13x13_check_cold.png") & """ border=""0"" align=""absmiddle"" /><img onmouseup=""this.style.display='none';this.previousSibling.style.display='inline';this.nextSibling.checked=false;"" style=""display:none;"" src=""" & ResolveUrl("~/images/13x13_check_hot.png") & """ border=""0"" align=""absmiddle"" /><input onpropertychange=""Grid_CheckOrUncheck(this, this.parentElement.parentElement.KeyID);"" style=""display:none;"" type=""checkbox"" /></td>")
            End If

            writer.Write("<td style=""width:22""><img src=""")
            If String.IsNullOrEmpty(GetColumn(r, "IconSrcURL", "")) Then
                writer.Write(ResolveUrl(IconSrcURL))
            Else
                writer.Write(ResolveUrl(GetColumn(r, "IconSrcURL", "")))
            End If
            writer.Write(""" border=""0""/></td>")


            For i As Integer = 0 To r.ItemArray.Length - 1
                Dim c As DataColumn = r.Table.Columns(i)
                If c.ExtendedProperties("Display") = True Then
                    writer.Write("<td ")
                    If Not String.IsNullOrEmpty(c.ExtendedProperties("ForcedWidth")) Then
                        writer.Write(" style=""width:" & c.ExtendedProperties("ForcedWidth") & """ ")
                    End If
                    writer.Write(" align=""" & c.ExtendedProperties("Align") & """>")
                    WriteValue(writer, c, r(i))
                    writer.Write("&nbsp;</td>")
                End If
            Next

            writer.Write("</tr>")
            If ClickOptions.Clickable Then
                writer.Write("</a>")
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
                lnkFirst.Text = lnkFirst.Text.Replace("first2.png", "first2_disabled.png")
                lnkPrevious.Enabled = False
                lnkPrevious.Text = lnkPrevious.Text.Replace("previous2.png", "previous2_disabled.png")
            End If

            If PageIndex = Pages - 1 Then
                lnkLast.Enabled = False
                lnkLast.Text = lnkLast.Text.Replace("last2.png", "last2_disabled.png")
                lnkNext.Enabled = False
                lnkNext.Text = lnkNext.Text.Replace("next2.png", "next2_disabled.png")
            End If

            If SearchCount <= PageSize Then
                lnkFirst.Visible = False
                lnkNext.Visible = False
                lnkLast.Visible = False
                lnkPrevious.Visible = False
                lblPage.Visible = False
            End If

            lblPage.Text = " Page " & (PageIndex + 1).ToString() + " of " & Pages.ToString()
        End If
    End Sub
    Private Sub RenderControls(ByVal output As HtmlTextWriter)


        lnkFirst.RenderBeginTag(output)
        output.Write(lnkFirst.Text)
        lnkFirst.RenderEndTag(output)
        output.Write("&nbsp;")

        lnkPrevious.RenderBeginTag(output)
        output.Write(lnkPrevious.Text)
        lnkPrevious.RenderEndTag(output)
        output.Write("&nbsp;")

        lblPage.RenderBeginTag(output)
        output.Write(lblPage.Text)
        lblPage.RenderEndTag(output)
        output.Write("&nbsp;")

        lnkNext.RenderBeginTag(output)
        output.Write(lnkNext.Text)
        lnkNext.RenderEndTag(output)
        output.Write("&nbsp;")

        lnkLast.RenderBeginTag(output)
        output.Write(lnkLast.Text)
        lnkLast.RenderEndTag(output)

        lnkDelete.RenderBeginTag(output)
        lnkDelete.RenderEndTag(output)
    End Sub

    Protected Overrides Sub SetupControls()
        MyBase.SetupControls()

        lnkDelete = New LinkButton
        lnkDelete.ID = Me.ID & "_lnkDelete"

        txtSelected = New HtmlInputHidden
        txtSelected.ID = Me.ID & "_txtSelected"

        lnkFirst = New LinkButton
        lnkFirst.ID = Me.ID & "_lnkFirst"
        lnkFirst.CssClass = "lnk"
        lnkFirst.Text = "<img align=""absmiddle"" src=""" & ResolveUrl("~/images/16x16_results_first2.png") & """ border=""0""/>"

        lnkPrevious = New LinkButton
        lnkPrevious.ID = Me.ID & "_lnkPrevious"
        lnkPrevious.CssClass = "lnk"
        lnkPrevious.Text = "<img align=""absmiddle"" src=""" & ResolveUrl("~/images/16x16_results_previous2.png") & """ border=""0""/>"

        lblPage = New Label

        lnkNext = New LinkButton
        lnkNext.ID = Me.ID & "_lnkNext"
        lnkNext.CssClass = "lnk"
        lnkNext.Text = "<img align=""absmiddle"" src=""" & ResolveUrl("~/images/16x16_results_next2.png") & """ border=""0""/>"

        lnkLast = New LinkButton
        lnkLast.ID = Me.ID & "_lnkLast"
        lnkLast.CssClass = "lnk"
        lnkLast.Text = "<img align=""absmiddle"" src=""" & ResolveUrl("~/images/16x16_results_last2.png") & """ border=""0""/>"

        Me.Controls.Add(lnkDelete)
        Me.Controls.Add(txtSelected)

        Me.Controls.Add(lnkFirst)
        Me.Controls.Add(lnkPrevious)
        Me.Controls.Add(lblPage)
        Me.Controls.Add(lnkNext)
        Me.Controls.Add(lnkLast)

    End Sub
#End Region
#Region "Event"
    Public Overrides Function LoadPostData(ByVal postDataKey As String, ByVal postCollection As System.Collections.Specialized.NameValueCollection) As Boolean
        MyBase.LoadPostData(postDataKey, postCollection)
        SelectedValues = postCollection(GetString(postDataKey, postCollection, "txtSelected"))
    End Function

    Protected Overrides Sub OnLoad(ByVal e As System.EventArgs)
        MyBase.OnLoad(e)
        If Not String.IsNullOrEmpty(XmlSchemaFile) Then
            SetupFromXML(Me.Page.GetType.Name, XmlSchemaFile)
        End If
        If Not Caching Then
            Reset(False)
        End If
    End Sub

    Private Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        If SelectedValues.Length > 0 Then
            Dim strIds As String() = SelectedValues.Split(",")
            Dim lstIds As New List(Of Integer)
            For Each s As String In strIds
                lstIds.Add(Integer.Parse(s))
            Next
            RaiseEvent MultiDelete(lstIds)
        End If
        Reset(False)
    End Sub
#End Region
#Region "Class"
    Public Class sAddOptions
        Private _Allow As Boolean
        Private _Caption As String
        Private _IconSrcURL As String
        Private _URL As String
        Public Property URL() As String
            Get
                Return _URL
            End Get
            Set(ByVal value As String)
                _URL = value
            End Set
        End Property
        Public Property Allow() As Boolean
            Get
                Return _Allow
            End Get
            Set(ByVal value As Boolean)
                _Allow = value
            End Set
        End Property
        Public Property Caption() As String
            Get
                Return _Caption
            End Get
            Set(ByVal value As String)
                _Caption = value
            End Set
        End Property
        Public Property IconSrcURL() As String
            Get
                Return _IconSrcURL
            End Get
            Set(ByVal value As String)
                _IconSrcURL = value
            End Set
        End Property
    End Class
    Public Class sDeleteOptions
        Private _Allow As Boolean
        Private _ConfirmTitle As String
        Private _ConfirmCaption As String
        Public Property Allow() As Boolean
            Get
                Return _Allow
            End Get
            Set(ByVal value As Boolean)
                _Allow = value
            End Set
        End Property
        Public Property ConfirmTitle() As String
            Get
                Return _ConfirmTitle
            End Get
            Set(ByVal value As String)
                _ConfirmTitle = value
            End Set
        End Property
        Public Property ConfirmCaption() As String
            Get
                Return _ConfirmCaption
            End Get
            Set(ByVal value As String)
                _ConfirmCaption = value
            End Set
        End Property
    End Class

#End Region


    Private Sub StandardGrid2_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        'Dim container As New ContainerTemplate()
        'phTitle.InstantiateIn(container)
        'Me.Page.Controls.Add(container)
    End Sub
End Class
