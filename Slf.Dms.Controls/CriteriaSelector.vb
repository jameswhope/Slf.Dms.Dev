Option Explicit On

Imports System
Imports System.Text
Imports System.Web.UI
Imports System.Drawing
Imports System.ComponentModel
Imports System.Web.UI.WebControls
Imports Microsoft.VisualBasic.CompilerServices

<DefaultProperty("Text"), ToolboxData("<{0}:CriteriaSelector runat=server></{0}:CriteriaSelector>")> _
Public Class CriteriaSelector
    Inherits Control

#Region "Variables"

    Private _items As ListItemCollection
    Private _selecteditems As ListItemCollection
    Private _unselecteditems As ListItemCollection

    Private _selectedrows As Integer
    Private _width As String
    Private _padding As Integer
    Private _spacing As Integer
    Private _text As String
    Private _textstyle As String
    Private _selectorstyle As String
    Private _selectedstyle As String
    Private _tablestyle As String

#End Region

#Region "Properties"

    Property Items() As ListItemCollection
        Get
            If _items Is Nothing Then
                _items = New ListItemCollection
            End If

            Return _items
        End Get
        Set(ByVal Value As ListItemCollection)
            _items = Value
        End Set
    End Property
    Property SelectedItems() As ListItemCollection
        Get
            If _selecteditems Is Nothing Then
                _selecteditems = New ListItemCollection
            End If

            Return _selecteditems
        End Get
        Set(ByVal Value As ListItemCollection)
            _selecteditems = Value
        End Set
    End Property
    Property UnselectedItems() As ListItemCollection
        Get
            If _unselecteditems Is Nothing Then
                _unselecteditems = New ListItemCollection
            End If

            Return _unselecteditems
        End Get
        Set(ByVal Value As ListItemCollection)
            _unselecteditems = Value
        End Set
    End Property
    Property SelectedRows() As Integer
        Get
            Return _selectedrows
        End Get
        Set(ByVal Value As Integer)
            _selectedrows = Value
        End Set
    End Property
    Property Width() As String
        Get
            Return _width
        End Get
        Set(ByVal Value As String)
            _width = Value
        End Set
    End Property
    Property Padding() As Integer
        Get
            Return _padding
        End Get
        Set(ByVal Value As Integer)
            _padding = Value
        End Set
    End Property
    Property Spacing() As Integer
        Get
            Return _spacing
        End Get
        Set(ByVal Value As Integer)
            _spacing = Value
        End Set
    End Property
    Property Text() As String
        Get
            Return _text
        End Get
        Set(ByVal Value As String)
            _text = Value
        End Set
    End Property
    Property TextStyle() As String
        Get
            Return _textstyle
        End Get
        Set(ByVal Value As String)
            _textstyle = Value
        End Set
    End Property
    Property SelectorStyle() As String
        Get
            Return _selectorstyle
        End Get
        Set(ByVal Value As String)
            _selectorstyle = Value
        End Set
    End Property
    Property SelectedStyle() As String
        Get
            Return _selectedstyle
        End Get
        Set(ByVal Value As String)
            _selectedstyle = Value
        End Set
    End Property
    Property TableStyle() As String
        Get
            Return _tablestyle
        End Get
        Set(ByVal Value As String)
            _tablestyle = Value
        End Set
    End Property

#End Region

    Public Sub New()

        Width = "150px"

        Padding = 0
        Spacing = 5
        SelectedRows = 10

        TextStyle = "FONT-FAMILY: Tahoma; FONT-SIZE: 11px; FONT-WEIGHT: Bold;"
        SelectorStyle = "FONT-FAMILY: Tahoma; FONT-SIZE: 11px; WIDTH: 150px;"
        SelectedStyle = "FONT-FAMILY: Tahoma; FONT-SIZE: 11px; WIDTH: 150px;"

    End Sub
    Protected Overrides Sub Render(ByVal output As System.Web.UI.HtmlTextWriter)

        Dim txtSelected As HtmlControls.HtmlInputHidden = New HtmlControls.HtmlInputHidden

        txtSelected.ID = Me.ClientID + "_txtSelected"
        txtSelected.Name = Me.ClientID + "_txtSelected"

        're-create the hidden textbox value
        For Each li As ListItem In SelectedItems
            If txtSelected.Value.Length > 0 Then
                txtSelected.Value += "|" & li.Value
            Else
                txtSelected.Value = li.Value
            End If
        Next

        output.Write("<TABLE style=""" & _tablestyle & """ border=""0"" cellpadding=""" & Padding & """ cellspacing=""" & Spacing & """>")
        output.Write("	<TR>")
        output.Write("		<TD style=""" & _textstyle & """>" & Text & "</TD>")
        output.Write("	</TR>")
        output.Write("	<TR>")
        output.Write("		<TD>")
        output.Write("          <SELECT width=""" & _width & """ style=""" & _selectorstyle & """ onchange=""Listbox_Add(this);"">")

        For Each li As ListItem In UnselectedItems
            output.Write("		<OPTION value=""" & li.Value & """>" & li.Text & "</OPTION>")
        Next

        output.Write("			</SELECT>")
        output.Write("      </TD>")
        output.Write("	</TR>")
        output.Write("	<TR>")
        output.Write("		<TD vAlign=""top"">")
        output.Write("          <SELECT width=""" & _width & """ ondblclick=""Listbox_Remove(this);"" style=""" & _selectedstyle & """ size=""" & SelectedRows & """>")

        For Each li As ListItem In SelectedItems
            output.Write("		<OPTION value=""" & li.Value & """>" & li.Text & "</OPTION>")
        Next

        output.Write("         </SELECT>")
        output.Write("      </TD>")
        output.Write("	</TR>")
        output.Write("	<TR>")
        output.Write("		<TD vAlign=""top"">")

        txtSelected.RenderControl(output)

        output.Write("		</TD>")
        output.Write("	</TR>")
        output.Write("</TABLE>")

    End Sub
    Protected Overrides Sub OnPreRender(ByVal e As System.EventArgs)

        'slap the javascript on the page
        MyBase.OnPreRender(e)
        RegisterScript()

    End Sub
    Protected Sub RegisterScript()

        Dim sb As StringBuilder = New StringBuilder

        sb.Append("<script>" & vbCrLf)
        sb.Append("function Listbox_Add(cbo)")
        sb.Append("{")
        sb.Append("	if (cbo.selectedIndex != -1 && cbo.options[cbo.selectedIndex].value > 0) {")
        sb.Append("		var cboText = cbo.options[cbo.selectedIndex].text;")
        sb.Append("		var cboValue = cbo.options[cbo.selectedIndex].value;")
        sb.Append("")
        sb.Append("		var par = cbo.parentNode.parentNode.parentNode.parentNode;")
        sb.Append("		var lbo = par.rows[2].childNodes[0].childNodes[0];")
        sb.Append("		var opt = new Option(cboText, cboValue);")
        sb.Append("")
        sb.Append("		Select_Add(lbo, opt);")
        sb.Append("		Select_Remove(cbo, cbo.selectedIndex);")
        sb.Append("")
        sb.Append("		Selected_Set(par);")
        sb.Append("	}")
        sb.Append("}")
        sb.Append("function Listbox_Remove(lbo)")
        sb.Append("{")
        sb.Append("	if (lbo.selectedIndex != -1) {")
        sb.Append("		var lboText = lbo.options[lbo.selectedIndex].text;")
        sb.Append("		var lboValue = lbo.options[lbo.selectedIndex].value;")
        sb.Append("")
        sb.Append("		var par = lbo.parentNode.parentNode.parentNode.parentNode;")
        sb.Append("		var cbo = par.rows[1].childNodes[0].childNodes[0];")
        sb.Append("		var opt = new Option(lboText, lboValue);")
        sb.Append("")
        sb.Append("		Select_Add(cbo, opt);")
        sb.Append("		Select_Remove(lbo, lbo.selectedIndex);")
        sb.Append("")
        sb.Append("		Selected_Set(par);")
        sb.Append("	}")
        sb.Append("}")
        sb.Append("function Selected_Set(par)")
        sb.Append("{")
        sb.Append("	var lbo = par.rows[2].childNodes[0].childNodes[0];")
        sb.Append("	var txt = par.rows[3].childNodes[0].childNodes[0];")
        sb.Append("")
        sb.Append("	txt.value = """";")
        sb.Append("")
        sb.Append("	for (i = 0; i < lbo.length; i++) {")
        sb.Append("		if (txt.value == """")")
        sb.Append("			txt.value = lbo.options[i].value;")
        sb.Append("        else")
        sb.Append("			txt.value += ""|"" + lbo.options[i].value;")
        sb.Append("	}")
        sb.Append("}")
        sb.Append("function Select_Add(obj, opt)")
        sb.Append("{")
        sb.Append("	var i = 0;")
        sb.Append("")
        sb.Append("	for (i = 0; i < obj.length; i++) {")
        sb.Append("		if (obj.options[i].text > opt.text)")
        sb.Append("			break;")
        sb.Append("	}")
        sb.Append("")
        sb.Append("	obj.options.add(opt, i);")
        sb.Append("}")
        sb.Append("function Select_Remove(obj, index)")
        sb.Append("{")
        sb.Append("	obj.options[index] = null;")
        sb.Append("}")
        sb.Append("</script>" & vbCrLf)

        Page.ClientScript.RegisterClientScriptBlock(GetType(String), "Asi.CriteriaSelector", sb.ToString)

    End Sub
    Public Sub ClearSelected()

        'clear selected and fill unselected
        SelectedItems.Clear()
        UnselectedItems = Items

    End Sub
    Private Sub CriteriaSelector_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load

        'start off by assigning at least the values that were selected on the form.
        ResetSelected()
        ResetUnselected()

    End Sub
    Private Sub ResetSelected()

        Dim sel As String = Page.Request.Form(Me.ClientID + "_txtSelected")

        If Not sel Is Nothing Then

            Dim retValue As String
            Dim retValues() As String = sel.Split("|")

            Dim selLi As ListItem

            For Each retValue In retValues
                selLi = Items.FindByValue(retValue.Trim)

                If Not selLi Is Nothing Then
                    SelectedItems.Add(selLi)
                End If
            Next

        End If

    End Sub
    Private Sub ResetUnselected()

        _unselecteditems = New ListItemCollection

        Dim sel As String = Page.Request.Form(Me.ClientID + "_txtSelected")

        'first add all the items in
        For Each li As ListItem In Items
            _unselecteditems.Add(li)
        Next

        'second loop through list and yank out selected values
        If Not sel Is Nothing Then

            Dim retValue As String
            Dim retValues() As String = sel.Split("|")

            Dim unsLi As ListItem

            For Each retValue In retValues
                unsLi = _unselecteditems.FindByValue(retValue.Trim)

                If Not unsLi Is Nothing Then
                    _unselecteditems.Remove(unsLi)
                End If
            Next

        End If

    End Sub
End Class