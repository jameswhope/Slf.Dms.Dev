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
Imports System.Data
Imports System.Data.Sql
Imports System.Data.SqlClient


Public MustInherit Class GridBase2
    Inherits WebControl
    Implements IPostBackDataHandler
#Region "Instance Field"
    Private _DataCommand As IDbCommand
    Private _SortOptions As New sSortOptions
    Private _ClickOptions As New sClickOptions

    Private _ResultsPerPage As Integer = 20
    Private WithEvents _lnkResort As LinkButton
    Private _txtSortField As HtmlInputHidden
    Private NewSortField As String
    Private _Caching As Boolean = True
    Private _XmlSchemaFile As String
    Private _Permission As PermissionHelper.Permission

    Private WithEvents _lnkFirst As LinkButton
    Private WithEvents _lnkPrevious As LinkButton
    Private WithEvents _lnkNext As LinkButton
    Private WithEvents _lnkLast As LinkButton

    Private _IllegalFields As New List(Of String)

    Public Event OnFillTable(ByRef tbl As DataTable)
#End Region
#Region "Property"
    Public Property Permission() As PermissionHelper.Permission
        Get
            Return _Permission
        End Get
        Set(ByVal value As PermissionHelper.Permission)
            _Permission = value
        End Set
    End Property
    Public Property IllegalFields() As List(Of String)
        Get
            Return _IllegalFields
        End Get
        Set(ByVal value As List(Of String))
            _IllegalFields = value
        End Set
    End Property
    Public Property XmlSchemaFile() As String
        Get
            Return _XmlSchemaFile
        End Get
        Set(ByVal value As String)
            _XmlSchemaFile = value
        End Set
    End Property
    Public Property Caching() As Boolean
        Get
            Return _Caching
        End Get
        Set(ByVal value As Boolean)
            _Caching = value
        End Set
    End Property
    Protected ReadOnly Property TableClass() As String
        Get
            Return IIf(ClickOptions.Clickable, "list", "fixedlist")
        End Get
    End Property
    Public Property PageSize() As Integer
        Get
            Return _ResultsPerPage
        End Get
        Set(ByVal value As Integer)
            _ResultsPerPage = value
        End Set
    End Property

    Public Property IconSrcURL() As String
        Get
            Return Setting("IconSrcURL", "~/")
        End Get
        Set(ByVal value As String)
            Setting("IconSrcURL") = value
        End Set
    End Property
    Protected Property lnkFirst() As LinkButton
        Get
            Return _lnkFirst
        End Get
        Set(ByVal value As LinkButton)
            _lnkFirst = value
        End Set
    End Property
    Protected Property lnkPrevious() As LinkButton
        Get
            Return _lnkPrevious
        End Get
        Set(ByVal value As LinkButton)
            _lnkPrevious = value
        End Set
    End Property
    Protected Property lnkNext() As LinkButton
        Get
            Return _lnkNext
        End Get
        Set(ByVal value As LinkButton)
            _lnkNext = value
        End Set
    End Property
    Protected Property lnkLast() As LinkButton
        Get
            Return _lnkLast
        End Get
        Set(ByVal value As LinkButton)
            _lnkLast = value
        End Set
    End Property
    Private _DataTable As DataTable
    Public Property Table() As DataTable
        Get
            If _DataTable Is Nothing Then
                _DataTable = Setting("table")
                If _DataTable Is Nothing Then
                    FillTable()
                End If
            End If
            Return _DataTable
        End Get
        Set(ByVal value As DataTable)
            Setting("table") = value
            _DataTable = value
        End Set
    End Property

    Public Property SortOptions() As sSortOptions
        Get
            Return _SortOptions
        End Get
        Set(ByVal value As sSortOptions)
            _SortOptions = value
        End Set
    End Property
    Public Property ClickOptions() As sClickOptions
        Get
            Return _ClickOptions
        End Get
        Set(ByVal value As sClickOptions)
            _ClickOptions = value
        End Set
    End Property
    Public Property PageIndex() As Integer
        Get
            Return DataHelper.Nz_int(Setting("p"), 0)
        End Get
        Set(ByVal value As Integer)
            Setting("p") = value
        End Set
    End Property
    Public Property SortField() As String
        Get
            Return Setting("SortField")
        End Get
        Set(ByVal value As String)
            Setting("SortField") = value
        End Set
    End Property
    Public Property SortOrder() As String
        Get
            Return Setting("SortOrder")
        End Get
        Set(ByVal value As String)
            Setting("SortOrder") = value
        End Set
    End Property
    Protected ReadOnly Property Session() As Web.SessionState.HttpSessionState
        Get
            Return Me.Context.Session
        End Get
    End Property
    Protected ReadOnly Property Identity() As String
        Get
            Return Me.Page.GetType.Name & "_" & Me.ID
        End Get
    End Property
    Protected Property Setting(ByVal s As String) As Object
        Get
            Return Session(Identity & "_" & s)
        End Get
        Set(ByVal value As Object)
            Session(Identity & "_" & s) = value
        End Set
    End Property
    Protected ReadOnly Property Setting(ByVal s As String, ByVal d As Object) As Object
        Get
            Dim o As Object = Setting(s)
            If o Is Nothing Then
                Return d
            Else
                Return o
            End If
        End Get
    End Property
    Protected Sub RemoveSetting(ByVal s As String)
        Session.Remove(Identity & "_" & s)
    End Sub
    Public Property DataCommand() As IDbCommand
        Get
            Return _DataCommand
        End Get
        Set(ByVal value As IDbCommand)
            _DataCommand = value
        End Set
    End Property

    Public Function FillTable() As DataTable
        If Not DataCommand Is Nothing Then
            Using cmd As IDbCommand = DataCommand
                Dim adapter As New SqlDataAdapter(cmd)
                Dim t As New DataTable
                adapter.Fill(t)
                Table = t
            End Using
        Else
            Dim t As New DataTable
            RaiseEvent OnFillTable(t)
            Table = t
        End If

        Return Table
    End Function

    'Public Property List() As List(Of GridRow)
    '    Get
    '        SetDefaults()
    '        Dim l As List(Of GridRow) = CType(Setting("list"), List(Of GridRow))

    '        If l Is Nothing Then
    '            l = New List(Of GridRow)
    '            Using cmd As IDbCommand = DataCommand

    '                ' If there's a command and the list isn't populated,
    '                ' run the query and populate the list
    '                If Not cmd Is Nothing AndAlso Not cmd.Connection Is Nothing AndAlso Not String.IsNullOrEmpty(cmd.Connection.ConnectionString) Then

    '                    ' If sorting is on, remove the old @OrderBy paramater,
    '                    ' and add the new one based on the current sort field and order
    '                    If SortOptions.Allow Then
    '                        If DataCommand.Parameters.Contains("@OrderBy") Then
    '                            DataCommand.Parameters.RemoveAt(DataCommand.Parameters.IndexOf("@OrderBy"))
    '                        End If
    '                        DatabaseHelper.AddParameter(DataCommand, "OrderBy", SortField & " " & SortOrder)
    '                    End If

    '                    Using cmd.Connection
    '                        cmd.Connection.Open()
    '                        Using rd As IDataReader = cmd.ExecuteReader
    '                            While rd.Read
    '                                Dim r As New GridRow

    '                                ' Look up the key fields
    '                                If Not String.IsNullOrEmpty(ClickOptions.KeyField) Then
    '                                    r.KeyId1 = DatabaseHelper.Peel_int(rd, ClickOptions.KeyField)
    '                                End If
    '                                If Not String.IsNullOrEmpty(ClickOptions.KeyField2) Then
    '                                    r.KeyId2 = DatabaseHelper.Peel_int(rd, ClickOptions.KeyField2)
    '                                End If

    '                                'Look up all the other fields
    '                                For Each f As GridField In Fields
    '                                    Dim v As Object = Nothing
    '                                    Select Case f.DataType
    '                                        Case SqlDbType.Bit
    '                                            v = DatabaseHelper.Peel_bool(rd, f.DataField)
    '                                        Case SqlDbType.Binary, SqlDbType.VarBinary
    '                                            v = DatabaseHelper.Peel_byte(rd, f.DataField)
    '                                        Case SqlDbType.DateTime, SqlDbType.SmallDateTime
    '                                            v = DatabaseHelper.Peel_date(rd, f.DataField)
    '                                        Case SqlDbType.Decimal
    '                                            v = DatabaseHelper.Peel_decimal(rd, f.DataField)
    '                                        Case SqlDbType.BigInt, SqlDbType.Int, SqlDbType.SmallInt, SqlDbType.TinyInt
    '                                            v = DatabaseHelper.Peel_int(rd, f.DataField)
    '                                        Case SqlDbType.Float, SqlDbType.Real, SqlDbType.Money, SqlDbType.SmallMoney
    '                                            v = DatabaseHelper.Peel_float(rd, f.DataField)
    '                                        Case SqlDbType.VarChar, SqlDbType.Text, SqlDbType.NVarChar, SqlDbType.NText, SqlDbType.NChar, SqlDbType.Char
    '                                            v = DatabaseHelper.Peel_string(rd, f.DataField)
    '                                    End Select
    '                                    r.Cells.Add(v)
    '                                Next
    '                                l.Add(r)
    '                            End While
    '                        End Using
    '                    End Using
    '                End If
    '            End Using

    '            ' Assign the new list to setting
    '            Setting("list") = l
    '        End If

    '        ' Return the list
    '        Return l
    '    End Get
    '    Set(ByVal value As List(Of GridRow))
    '        ' Assign the new list to setting
    '        Setting("list") = value
    '    End Set
    'End Property
#End Region
#Region "Event"
    Protected Overrides Sub OnLoad(ByVal e As System.EventArgs)
        MyBase.OnLoad(e)
        SetupControls()
        If SortOptions.Allow Then
            InitSort()
        End If
    End Sub
    Private Sub lnkFirst_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles _lnkFirst.Click
        PageIndex = 0
    End Sub
    Private Sub lnkLast_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles _lnkLast.Click
        PageIndex = -1
    End Sub
    Private Sub lnkNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles _lnkNext.Click
        PageIndex = PageIndex + 1
    End Sub
    Private Sub lnkPrevious_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles _lnkPrevious.Click
        PageIndex = PageIndex - 1
    End Sub
    Private Sub lnkResort_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles _lnkResort.Click
        InitSort()
        If NewSortField = SortField Then
            'toggle sort order
            If SortOrder = "ASC" Then
                SortOrder = "DESC"
            Else
                SortOrder = "ASC"
            End If
        Else
            SortField = NewSortField
            SortOrder = "ASC"
        End If
        Reset(True)

    End Sub
    Public Function GetString(ByVal postDataKey As String, ByVal postCollection As System.Collections.Specialized.NameValueCollection, ByVal key As String)
        Dim s As String
        s = postCollection(postDataKey & "_" & key)
        If s Is Nothing Then
            s = postCollection(postDataKey & "$" & Me.ID & "_" & key)
        End If
        Return DataHelper.Nz_string(s)
    End Function
    Public Overridable Function LoadPostData(ByVal postDataKey As String, ByVal postCollection As System.Collections.Specialized.NameValueCollection) As Boolean Implements System.Web.UI.IPostBackDataHandler.LoadPostData
        NewSortField = GetString(postDataKey, postCollection, "txtSortField")
    End Function
    Public Sub RaisePostDataChangedEvent() Implements System.Web.UI.IPostBackDataHandler.RaisePostDataChangedEvent

    End Sub
#End Region
#Region "Method"
    Public Overridable Sub SuckXmlGridProperties(ByVal xml As XmlTextReader)
        Dim s As String = Nothing

        s = xml.GetAttribute("ClickOptions.Clickable")
        If Not String.IsNullOrEmpty(s) Then
            Me.ClickOptions.Clickable = Boolean.Parse(s)
        End If
        s = xml.GetAttribute("ClickOptions.ClickableURL")
        If Not String.IsNullOrEmpty(s) Then
            Me.ClickOptions.ClickableURL = s
        End If
        s = xml.GetAttribute("ClickOptions.KeyField")
        If Not String.IsNullOrEmpty(s) Then
            Me.ClickOptions.KeyField = s
        End If
        s = xml.GetAttribute("ClickOptions.KeyField2")
        If Not String.IsNullOrEmpty(s) Then
            Me.ClickOptions.KeyField2 = s
        End If
        s = xml.GetAttribute("PageSize")
        If Not String.IsNullOrEmpty(s) Then
            Me.PageSize = Integer.Parse(s)
        End If
        s = xml.GetAttribute("IconSrcURL")
        If Not String.IsNullOrEmpty(s) Then
            Me.IconSrcURL = s
        End If
        s = xml.GetAttribute("SortOrder")
        If Not String.IsNullOrEmpty(s) Then
            Me.SortOrder = s
        End If
        s = xml.GetAttribute("SortField")
        If Not String.IsNullOrEmpty(s) Then
            Me.SortField = s
        End If
        s = xml.GetAttribute("SortOptions.Allow")
        If Not String.IsNullOrEmpty(s) Then
            Me.SortOptions.Allow = Boolean.Parse(s)
        End If
        s = xml.GetAttribute("SortOptions.DefaultSortField")
        If Not String.IsNullOrEmpty(s) Then
            Me.SortOptions.DefaultSortField = s
        End If
        s = xml.GetAttribute("Caching")
        If Not String.IsNullOrEmpty(s) Then
            Me.Caching = s
        End If
    End Sub
    Public Overridable Sub SuckXmlFieldProperties(ByVal xml As XmlTextReader)
        Dim DataField As String = xml.GetAttribute("datafield")
        If Table.Columns.Contains(DataField) Then
            Dim s As String = Nothing

            Dim FieldType As eFieldType
            s = xml.GetAttribute("fieldtype")
            If Not String.IsNullOrEmpty(s) Then
                FieldType = System.Enum.Parse(GetType(GridBase2.eFieldType), s)
            End If

            Dim Sortable As Boolean
            s = xml.GetAttribute("sortable")
            If Not String.IsNullOrEmpty(s) Then
                Sortable = Boolean.Parse(s)
            End If

            Dim ControlName As String = xml.GetAttribute("controlname")
            Dim Caption As String = xml.GetAttribute("caption")
            Dim Format As String = xml.GetAttribute("format")
            Dim ForcedWidth As String = xml.GetAttribute("forcedwidth")
            Dim c As DataColumn = Table.Columns(DataField)

            If Not IllegalFields.Contains(DataField) Then
                c.ExtendedProperties("Display") = True
            End If

            c.ExtendedProperties("ControlName") = ControlName
            c.ExtendedProperties("FieldType") = FieldType
            c.Caption = Caption
            c.ExtendedProperties("Format") = Format
            c.ExtendedProperties("Sortable") = Sortable
            c.ExtendedProperties("ForcedWidth") = ForcedWidth
        End If
    End Sub
    Public Sub SetupFromXML(ByVal PageName As String, ByVal xmlPath As String)
        Dim s As String = Nothing
        Dim gridName As String = PageName & "." & Me.ID

        Using xml As New XmlTextReader(Me.Page.Server.MapPath(xmlPath))
            xml.MoveToContent()
            xml.Read()

            'find correct grid
            While xml.Read()
                If xml.GetAttribute("id") = gridName Then
                    Exit While
                End If
                xml.Skip()
            End While
            If xml.GetAttribute("id") = gridName Then

                SuckXmlGridProperties(xml)

                'read the fields
                While (xml.Read)
                    If xml.LocalName = "Field" And xml.AttributeCount > 0 Then

                        SuckXmlFieldProperties(xml)

                    ElseIf xml.LocalName = "Grid" Then

                        Exit While

                    End If
                End While
            End If
        End Using

    End Sub
    Public Function GetXlsHtml() As String
        Dim sb As New StringBuilder

        SetDefaults()

        sb.Append("<table border=""1"">")
        sb.Append("<tr>")

        'render headers
        For Each c As DataColumn In Table.Columns
            sb.Append("<td>")
            sb.Append(c.Caption)
            sb.Append("</td>")
        Next
        sb.Append("</tr>")

        'render rows
        For Each r As DataRow In Table.Rows
            sb.Append("<tr>")

            For i As Integer = 0 To r.ItemArray.Length - 1
                sb.Append("<td>")
                WriteValue(sb, Table.Columns(i), r(i))
                sb.Append("</td>")
            Next

            sb.Append("</tr>")
        Next

        sb.Append("</table>")

        Return sb.ToString
    End Function
    Protected Overridable Sub SetupControls()
        _lnkResort = New LinkButton
        _lnkResort.ID = Me.ID & "_lnkResort"
        _txtSortField = New HtmlInputHidden
        _txtSortField.ID = Me.ID & "_txtSortField"

        Me.Controls.Add(_lnkResort)
        Me.Controls.Add(_txtSortField)
    End Sub
    Protected Function SortScript() As String
        Dim s As New StringBuilder
        s.Append("function " & Me.ID & "_Sort(obj){document.getElementById(""" & _txtSortField.ClientID & """).value = obj.fieldName;" & Me.Page.ClientScript.GetPostBackEventReference(_lnkResort, Nothing) & ";}")
        Return s.ToString
    End Function
    Public Sub Reset(ByVal pager As Boolean)
        RemoveSetting("table")
        _DataTable = Nothing
        If Not String.IsNullOrEmpty(XmlSchemaFile) Then
            SetupFromXML(Me.Page.GetType.Name, XmlSchemaFile)
        End If
        If pager Then RemoveSetting("p")
    End Sub
    Protected Sub InitSort()
        If String.IsNullOrEmpty(SortField) Then
            SortField = SortOptions.DefaultSortField
        End If
        If String.IsNullOrEmpty(SortOrder) Then
            SortOrder = "ASC"
        End If
    End Sub
    Protected Overrides Sub Render(ByVal writer As System.Web.UI.HtmlTextWriter)
        _lnkResort.RenderBeginTag(writer)
        _lnkResort.RenderEndTag(writer)
        _txtSortField.RenderControl(writer)
    End Sub

    Protected Sub WriteValue(ByVal sb As StringBuilder, ByVal c As DataColumn, ByVal o As Object)
        If TypeOf o Is Boolean Then
            Dim v As Boolean = CType(o, Boolean)
            If (v) Then
                sb.Append("<img src=""" & ResolveUrl("~/images/16x16_check.png") & """ border=""0""/>")
            End If
        ElseIf TypeOf o Is Byte Then
            Dim v As Byte = CType(o, Byte)
            sb.Append(v.ToString(c.ExtendedProperties("Format")))
        ElseIf TypeOf o Is DateTime Then
            Dim v As DateTime = CType(o, DateTime)
            If v = DateTime.MinValue Then
                sb.Append("&nbsp;")
            Else
                sb.Append(v.ToString(c.ExtendedProperties("Format")))
            End If
        ElseIf TypeOf o Is Decimal Then
            Dim v As Decimal = CType(o, Decimal)
            sb.Append(v.ToString(c.ExtendedProperties("Format")))
        ElseIf TypeOf o Is Integer Then
            Dim v As Integer = CType(o, Integer)
            sb.Append(v.ToString())
        ElseIf TypeOf o Is Single Then
            Dim v As Single = CType(o, Single)
            sb.Append(v.ToString(c.ExtendedProperties("Format")))
        ElseIf TypeOf o Is Double Then
            Dim v As Double = CType(o, Double)
            sb.Append(v.ToString(c.ExtendedProperties("Format")))
        ElseIf TypeOf o Is String Then
            Dim v As String = CType(o, String)
            sb.Append(v)
        End If
    End Sub
    Protected Sub WriteValue(ByVal output As System.Web.UI.HtmlTextWriter, ByVal c As DataColumn, ByVal o As Object)
        If TypeOf o Is Boolean Then
            Dim v As Boolean = CType(o, Boolean)
            If (v) Then
                output.Write("<img src=""" & ResolveUrl("~/images/16x16_check.png") & """ border=""0""/>")
            End If
        ElseIf TypeOf o Is Byte Then
            Dim v As Byte = CType(o, Byte)
            output.Write(v.ToString(c.ExtendedProperties("Format")))
        ElseIf TypeOf o Is DateTime Then
            Dim v As DateTime = CType(o, DateTime)
            If v = DateTime.MinValue Then
                output.Write("&nbsp;")
            Else
                output.Write(v.ToString(c.ExtendedProperties("Format")))
            End If
        ElseIf TypeOf o Is Decimal Then
            Dim v As Decimal = CType(o, Decimal)
            output.Write(v.ToString(c.ExtendedProperties("Format")))
        ElseIf TypeOf o Is Integer Then
            Dim v As Integer = CType(o, Integer)
            output.Write(v.ToString())
        ElseIf TypeOf o Is Single Then
            Dim v As Single = CType(o, Single)
            output.Write(v.ToString(c.ExtendedProperties("Format")))
        ElseIf TypeOf o Is Double Then
            Dim v As Double = CType(o, Double)
            output.Write(v.ToString(c.ExtendedProperties("Format")))
        ElseIf TypeOf o Is String Then
            Dim v As String = CType(o, String)
            output.Write(v)
        End If
    End Sub
    Public Overridable Sub SetDefaults()
        InitSort()
        If String.IsNullOrEmpty(IconSrcURL) Then
            IconSrcURL = "~/images/icon.png"
        End If
        If String.IsNullOrEmpty(ClickOptions.ClickableURL) Or String.IsNullOrEmpty(ClickOptions.KeyField) Then
            ClickOptions.Clickable = False
        End If
        For Each c As DataColumn In Table.Columns
            SetColumnDefaults(c)
        Next
    End Sub
    Private Function ContainsValue(ByVal c As PropertyCollection, ByVal s As String) As Boolean
        If Not c.ContainsKey(s) Then
            Return False
        Else
            Return Not (c(s) Is Nothing)
        End If
    End Function
    Public Sub SetColumnDefaults(ByVal c As DataColumn)
        If IllegalFields.Contains(c.ColumnName) Then
            c.ExtendedProperties("Display") = False
        End If

        If Not ContainsValue(c.ExtendedProperties, "Align") Then
            If c.DataType Is GetType(Single) Or c.DataType Is GetType(Double) Then
                c.ExtendedProperties("Align") = "right"
            ElseIf c.DataType Is GetType(DateTime) Or c.DataType Is GetType(Boolean) Then
                c.ExtendedProperties("Align") = "center"
            ElseIf c.DataType Is GetType(String) Then
                c.ExtendedProperties("Align") = "left"
            Else
                c.ExtendedProperties("Align") = "left"
            End If
        End If

        If Not ContainsValue(c.ExtendedProperties, "Format") Then
            Dim FieldType As eFieldType
            If ContainsValue(c.ExtendedProperties, "FieldType") Then
                FieldType = c.ExtendedProperties("FieldType")
            Else
                If c.DataType Is GetType(Single) Or c.DataType Is GetType(Double) Then
                    FieldType = eFieldType.Currency
                ElseIf c.DataType Is GetType(DateTime) Then
                    FieldType = eFieldType.DateTime
                ElseIf c.DataType Is GetType(Boolean) Then
                    FieldType = eFieldType.Boolean
                ElseIf c.DataType Is GetType(String) Then
                    FieldType = eFieldType.Text
                Else
                    FieldType = eFieldType.Text
                End If

                c.ExtendedProperties("FieldType") = FieldType
            End If

            Select Case FieldType
                Case eFieldType.Currency
                    c.ExtendedProperties("Format") = "c"
                Case eFieldType.DateTime
                    c.ExtendedProperties("Format") = "d MMM, yyyy"
                Case eFieldType.Percent
                    c.ExtendedProperties("Format") = "P"
                Case eFieldType.Boolean
                    c.ExtendedProperties("Format") = Nothing
                Case eFieldType.Text
                    c.ExtendedProperties("Format") = Nothing
            End Select
        End If
    End Sub
    Protected Function GetColumn(ByVal r As DataRow, ByVal ColumnName As String, ByVal [Default] As Object) As Object
        Try
            Dim o As Object = r(ColumnName)
            Return o
        Catch ex As Exception
            Return [Default]
        End Try
    End Function
    Protected Function GetColumn(ByVal r As DataRow, ByVal ColumnName As String) As Object
        Return GetColumn(r, ColumnName, Nothing)
    End Function
#End Region
#Region "Public Class"
    Public Class sSortOptions
        Private _Allow As Boolean
        Private _DefaultSortField As String
        Public Property DefaultSortField() As String
            Get
                Return _DefaultSortField
            End Get
            Set(ByVal value As String)
                _DefaultSortField = value
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
    End Class
    Public Enum eFieldType
        Text = 1
        DateTime = 2
        Currency = 3
        Percent = 4
        [Boolean] = 5
    End Enum
    Public Class sClickOptions
        Private _Clickable As Boolean
        Private _ClickableURL As String
        Private _KeyField As String
        Private _KeyField2 As String

        Public Property Clickable() As Boolean
            Get
                Return _Clickable
            End Get
            Set(ByVal value As Boolean)
                _Clickable = value
            End Set
        End Property
        Public Property ClickableURL() As String
            Get
                Return _ClickableURL
            End Get
            Set(ByVal value As String)
                _ClickableURL = value
            End Set
        End Property
        Public Property KeyField() As String
            Get
                Return _KeyField
            End Get
            Set(ByVal value As String)
                _KeyField = value
            End Set
        End Property
        Public Property KeyField2() As String
            Get
                Return _KeyField2
            End Get
            Set(ByVal value As String)
                _KeyField2 = value
            End Set
        End Property
    End Class
#End Region
End Class