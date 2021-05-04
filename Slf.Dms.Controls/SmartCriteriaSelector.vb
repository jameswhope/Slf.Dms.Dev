Option Explicit On

Imports System
Imports System.Text
Imports System.Web.UI
Imports System.Drawing
Imports System.ComponentModel
Imports System.Web.UI.WebControls
Imports Microsoft.VisualBasic.CompilerServices
Imports System.Collections
Imports System.Collections.ObjectModel
Imports System.Collections.Generic
Imports System.Web.UI.HtmlControls

<DefaultProperty("Text"), ToolboxData("<{0}:SmartCriteriaSelector runat=server></{0}:SmartCriteriaSelector>")> _
Public Class SmartCriteriaSelector
    Inherits Control
    Implements IPostBackDataHandler


#Region "Variables"

    Private _items As Dictionary(Of String, ListItem)

    Private _selectedrows As Integer
    Private _width As String
    Private _padding As Integer
    Private _spacing As Integer
    Private _text As String
    Private _textstyle As String
    Private _selectorstyle As String
    Private _selectedstyle As String
    Private _tablestyle As String

    Private txtSelected As HtmlInputHidden
    Private _SelectedValues As String = ""

#End Region
#Region "Properties"

    Public Property Items() As Dictionary(Of String, ListItem)
        Get
            If _items Is Nothing Then
                _items = New Dictionary(Of String, ListItem)
            End If

            Return _items
        End Get
        Set(ByVal Value As Dictionary(Of String, ListItem))
            _items = Value
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
    Public ReadOnly Property EntireList() As List(Of String)
        Get
            Dim lstIds As New List(Of String)
            For Each li As ListItem In Items.Values
                lstIds.Add(li.Value)
            Next
            Return lstIds
        End Get
    End Property
    Public ReadOnly Property SelectedList() As List(Of String)
        Get
            Dim lstIds As New List(Of String)
            If _SelectedValues.Length > 0 Then
                Dim strIds As String() = _SelectedValues.Split("|")
                For Each s As String In strIds
                    lstIds.Add(s)
                Next
            End If
            Return lstIds
        End Get
    End Property
    Public Property SelectedStr() As String
        Get
            Return _SelectedValues
        End Get
        Set(ByVal value As String)
            _SelectedValues = value
        End Set
    End Property
    Public ReadOnly Property SelectedList_Int() As List(Of Integer)
        Get
            Dim lstIds As New List(Of Integer)
            If _SelectedValues.Length > 0 Then
                Dim strIds As String() = _SelectedValues.Split("|")
                For Each s As String In strIds
                    Dim i As Integer
                    If Integer.TryParse(s, i) Then
                        lstIds.Add(i)
                    End If
                Next
            End If
            Return lstIds
        End Get
    End Property

#End Region
    Public Sub AddItem(ByVal li As ListItem)
        Try
            Items.Add(li.Value, li)
        Catch
        End Try
    End Sub
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
        Dim sel As List(Of String) = SelectedList

        txtSelected.Value = SelectedStr

        output.Write("<TABLE style=""" & _tablestyle & """ border=""0"" cellpadding=""" & Padding & """ cellspacing=""" & Spacing & """>")
        output.Write("<TR>")
        output.Write("<TD style=""" & _textstyle & """>" & Text & "</TD>")
        output.Write("</TR>")
        output.Write("<TR>")
        output.Write("<TD>")
        output.Write("<SELECT width=""" & _width & """ style=""" & _selectorstyle & """ onchange=""Listbox_Add(this);"">")


        For Each li As ListItem In Items.Values
            If Not sel.Contains(li.Value) Then
                output.Write("<OPTION value=""" & li.Value & """>" & li.Text & "</OPTION>")
            End If
        Next

        output.Write("</SELECT>")
        output.Write("</TD>")
        output.Write("</TR>")
        output.Write("<TR>")
        output.Write("<TD vAlign=""top"">")
        output.Write("<SELECT width=""" & _width & """ ondblclick=""Listbox_Remove(this);"" style=""" & _selectedstyle & """ size=""" & SelectedRows & """>")

        For Each li As ListItem In Items.Values
            If sel.Contains(li.Value) Then
                output.Write("<OPTION value=""" & li.Value & """>" & li.Text & "</OPTION>")
            End If
        Next

        output.Write("</SELECT>")
        output.Write("</TD>")
        output.Write("</TR>")
        output.Write("<TR>")
        output.Write("<TD vAlign=""top"">")

        txtSelected.RenderControl(output)

        output.Write("</TD>")
        output.Write("</TR>")
        output.Write("</TABLE>")

    End Sub
    Protected Overrides Sub OnPreRender(ByVal e As System.EventArgs)

        'slap the javascript on the page
        MyBase.OnPreRender(e)
        RegisterScript()

        'Manually set the page to call control's postback handlers
        If Page IsNot Nothing Then Page.RegisterRequiresPostBack(Me)
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
    Private Sub SetupControls()
        txtSelected = New HtmlInputHidden
        txtSelected.ID = Me.ID & "_txtSelected"
        Me.Controls.Add(txtSelected)
    End Sub
    Public Function LoadPostData(ByVal postDataKey As String, ByVal postCollection As System.Collections.Specialized.NameValueCollection) As Boolean Implements System.Web.UI.IPostBackDataHandler.LoadPostData
        _SelectedValues = postCollection(Me.UniqueID & "_txtSelected")
    End Function
    Public Sub RaisePostDataChangedEvent() Implements System.Web.UI.IPostBackDataHandler.RaisePostDataChangedEvent

    End Sub
    Private Sub SmartCriteriaSelector_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SetupControls()
    End Sub
    Public Function GenerateCriteria(ByVal Field As String) As String
        Return GenerateCriteria(Field, String.Empty)
    End Function
    Public Function GenerateCriteria(ByVal Field As String, ByVal Qualifier As String) As String

        Dim Value As String = String.Empty

        For Each s As String In SelectedList
            If Value.Length > 0 Then
                Value += "," & Qualifier & s & Qualifier
            Else
                Value = Qualifier & s & Qualifier
            End If
        Next

        If Value.Length > 0 Then
            Value = Field & " IN (" & Value & ")"
        End If

        Return Value

    End Function
End Class