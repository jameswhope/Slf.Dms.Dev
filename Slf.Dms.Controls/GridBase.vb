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

Public MustInherit Class GridBase
    Inherits Control
    Implements IPostBackDataHandler
#Region "Instance Field"
    Private _DataCommand As IDbCommand
    Private _SortOptions As New sSortOptions
    Private _ClickOptions As New sClickOptions
    Private _Fields As List(Of GridField)

    Private _IconSrcURL As String = "~/"
    Private _ResultsPerPage As Integer = 20
    Private WithEvents _lnkResort As LinkButton
    Private _txtSortField As HtmlInputHidden
    Private NewSortField As String

    Private WithEvents _lnkFirst As LinkButton
    Private WithEvents _lnkPrevious As LinkButton
    Private WithEvents _lnkNext As LinkButton
    Private WithEvents _lnkLast As LinkButton
#End Region
#Region "Property"
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
            Return _IconSrcURL
        End Get
        Set(ByVal value As String)
            _IconSrcURL = value
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
    Public Property Fields() As List(Of GridField)
        Get
            If _Fields Is Nothing Then _Fields = New List(Of GridField)
            Return _Fields
        End Get
        Set(ByVal value As List(Of GridField))
            _Fields = value
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

    Public Property List() As List(Of GridRow)
        Get
            SetDefaults()
            Dim l As List(Of GridRow) = CType(Setting("list"), List(Of GridRow))

            If l Is Nothing Then
                l = New List(Of GridRow)
                Using cmd As IDbCommand = DataCommand

                    ' If there's a command and the list isn't populated,
                    ' run the query and populate the list
                    If Not cmd Is Nothing AndAlso Not cmd.Connection Is Nothing AndAlso Not String.IsNullOrEmpty(cmd.Connection.ConnectionString) Then

                        ' If sorting is on, remove the old @OrderBy paramater,
                        ' and add the new one based on the current sort field and order
                        If SortOptions.Allow Then
                            If DataCommand.Parameters.Contains("@OrderBy") Then
                                DataCommand.Parameters.RemoveAt(DataCommand.Parameters.IndexOf("@OrderBy"))
                            End If
                            DatabaseHelper.AddParameter(DataCommand, "OrderBy", SortField & " " & SortOrder)
                        End If

                        Using cmd.Connection
                            cmd.Connection.Open()
                            Using rd As IDataReader = cmd.ExecuteReader
                                While rd.Read
                                    Dim r As New GridRow

                                    ' Look up the key fields
                                    If Not String.IsNullOrEmpty(ClickOptions.KeyField) Then
                                        r.KeyId1 = DatabaseHelper.Peel_int(rd, ClickOptions.KeyField)
                                    End If
                                    If Not String.IsNullOrEmpty(ClickOptions.KeyField2) Then
                                        r.KeyId2 = DatabaseHelper.Peel_int(rd, ClickOptions.KeyField2)
                                    End If

                                    'Look up all the other fields
                                    For Each f As GridField In Fields
                                        Dim v As Object = Nothing
                                        Select Case f.DataType
                                            Case SqlDbType.Bit
                                                v = DatabaseHelper.Peel_bool(rd, f.DataField)
                                            Case SqlDbType.Binary, SqlDbType.VarBinary
                                                v = DatabaseHelper.Peel_byte(rd, f.DataField)
                                            Case SqlDbType.DateTime, SqlDbType.SmallDateTime
                                                v = DatabaseHelper.Peel_date(rd, f.DataField)
                                            Case SqlDbType.Decimal
                                                v = DatabaseHelper.Peel_decimal(rd, f.DataField)
                                            Case SqlDbType.BigInt, SqlDbType.Int, SqlDbType.SmallInt, SqlDbType.TinyInt
                                                v = DatabaseHelper.Peel_int(rd, f.DataField)
                                            Case SqlDbType.Float, SqlDbType.Real, SqlDbType.Money, SqlDbType.SmallMoney
                                                v = DatabaseHelper.Peel_float(rd, f.DataField)
                                            Case SqlDbType.VarChar, SqlDbType.Text, SqlDbType.NVarChar, SqlDbType.NText, SqlDbType.NChar, SqlDbType.Char
                                                v = DatabaseHelper.Peel_string(rd, f.DataField)
                                        End Select
                                        r.Cells.Add(v)
                                    Next
                                    l.Add(r)
                                End While
                            End Using
                        End Using
                    End If
                End Using

                ' Assign the new list to setting
                Setting("list") = l
            End If

            ' Return the list
            Return l
        End Get
        Set(ByVal value As List(Of GridRow))
            ' Assign the new list to setting
            Setting("list") = value
        End Set
    End Property
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
    Public Overridable Function LoadPostData(ByVal postDataKey As String, ByVal postCollection As System.Collections.Specialized.NameValueCollection) As Boolean Implements System.Web.UI.IPostBackDataHandler.LoadPostData
        NewSortField = DataHelper.Nz_string(postCollection(Me.UniqueID & "_txtSortField"))
    End Function
    Public Sub RaisePostDataChangedEvent() Implements System.Web.UI.IPostBackDataHandler.RaisePostDataChangedEvent

    End Sub
#End Region
#Region "Method"
    
    Public Function GetXlsHtml() As String
        Dim sb As New StringBuilder

        SetDefaults()

        sb.Append("<table border=""1"">")
        sb.Append("<tr>")

        'render headers
        For Each f As GridField In Fields
            sb.Append("<td>")
            sb.Append(f.Title)
            sb.Append("</td>")
        Next
        sb.Append("</tr>")

        'render rows
        Dim l As List(Of GridRow) = List

        For Each r As GridRow In l
            sb.Append("<tr>")

            For i As Integer = 0 To r.Cells.Count - 1
                Dim f As GridField = Fields(i)
                Dim o As Object = r.Cells(i)
                sb.Append("<td>")
                WriteValue(sb, o, f)
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
        RemoveSetting("list")
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

    Protected Sub WriteValue(ByVal sb As StringBuilder, ByVal o As Object, ByVal f As GridField)
        Select Case f.DataType
            Case SqlDbType.Bit
                Dim v As Boolean = CType(o, Boolean)
                If (v) Then
                    sb.Append("<img src=""" & ResolveUrl("~/images/16x16_check.png") & """ border=""0""/>")
                End If
            Case SqlDbType.Binary, SqlDbType.VarBinary
                Dim v As Byte = CType(o, Byte)
                sb.Append(v.ToString(f.Format))
            Case SqlDbType.DateTime, SqlDbType.SmallDateTime
                If TypeOf o Is DateTime Then
                    Dim v As DateTime = CType(o, DateTime)
                    If v = DateTime.MinValue Then
                        sb.Append("&nbsp;")
                    Else
                        sb.Append(v.ToString(f.Format))
                    End If
                End If
            Case SqlDbType.Decimal
                Dim v As Decimal = CType(o, Decimal)
                sb.Append(v.ToString(f.Format))
            Case SqlDbType.BigInt, SqlDbType.Int, SqlDbType.SmallInt, SqlDbType.TinyInt
                Dim v As Integer = CType(o, Integer)
                sb.Append(v.ToString())
            Case SqlDbType.Float, SqlDbType.Money, SqlDbType.SmallMoney
                Dim v As Single = CType(o, Single)
                sb.Append(v.ToString(f.Format))
            Case SqlDbType.Real
                Dim v As Single = CType(o, Double)
                sb.Append(v.ToString(f.Format))
            Case SqlDbType.VarChar, SqlDbType.Text, SqlDbType.NVarChar, SqlDbType.NText, SqlDbType.NChar, SqlDbType.Char
                Dim v As String = CType(o, String)
                sb.Append(v)
        End Select
    End Sub
    Protected Sub WriteValue(ByVal output As System.Web.UI.HtmlTextWriter, ByVal o As Object, ByVal f As GridField)
        Select Case f.DataType
            Case SqlDbType.Bit
                Dim v As Boolean = CType(o, Boolean)
                If (v) Then
                    output.Write("<img src=""" & ResolveUrl("~/images/16x16_check.png") & """ border=""0""/>")
                End If
            Case SqlDbType.Binary, SqlDbType.VarBinary
                Dim v As Byte = CType(o, Byte)
                output.Write(v.ToString(f.Format))
            Case SqlDbType.DateTime, SqlDbType.SmallDateTime
                Dim v As DateTime = CType(o, DateTime)
                If v = DateTime.MinValue Then
                    output.Write("&nbsp;")
                Else
                    output.Write(v.ToString(f.Format))
                End If
            Case SqlDbType.Decimal
                Dim v As Decimal = CType(o, Decimal)
                output.Write(v.ToString(f.Format))
            Case SqlDbType.BigInt, SqlDbType.Int, SqlDbType.SmallInt, SqlDbType.TinyInt
                Dim v As Integer = CType(o, Integer)
                output.Write(v.ToString())
            Case SqlDbType.Float, SqlDbType.Money, SqlDbType.SmallMoney
                Dim v As Single = CType(o, Single)
                output.Write(v.ToString(f.Format))
            Case SqlDbType.Real
                Dim v As Single = CType(o, Double)
                output.Write(v.ToString(f.Format))
            Case SqlDbType.VarChar, SqlDbType.Text, SqlDbType.NVarChar, SqlDbType.NText, SqlDbType.NChar, SqlDbType.Char
                Dim v As String = CType(o, String)
                output.Write(v)
        End Select
    End Sub

    Public Overridable Sub SetDefaults()
        InitSort()
        If String.IsNullOrEmpty(IconSrcURL) Then
            IconSrcURL = "~/images/icon.png"
        End If
        If String.IsNullOrEmpty(ClickOptions.ClickableURL) Or String.IsNullOrEmpty(ClickOptions.KeyField) Then
            ClickOptions.Clickable = False
        End If
        For Each f As GridField In Fields
            f.SetDefaults()
        Next
    End Sub
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
    Public Class GridRow
        Private _KeyId1 As Integer
        Private _KeyId2 As Integer
        Private _Cells As List(Of Object)
        Private _ClickableURL As String
        Private _IconSrcUrl As String

        Public Property ClickableURL() As String
            Get
                Return _ClickableURL
            End Get
            Set(ByVal value As String)
                _ClickableURL = value
            End Set
        End Property
        Public Property IconSrcURL() As String
            Get
                Return _IconSrcUrl
            End Get
            Set(ByVal value As String)
                _IconSrcUrl = value
            End Set
        End Property
        Public Property Cells() As List(Of Object)
            Get
                If _Cells Is Nothing Then _Cells = New List(Of Object)
                Return _Cells
            End Get
            Set(ByVal value As List(Of Object))
                _Cells = value
            End Set
        End Property

        Public Property KeyId1() As Integer
            Get
                Return _KeyId1
            End Get
            Set(ByVal value As Integer)
                _KeyId1 = value
            End Set
        End Property
        Public Property KeyId2() As Integer
            Get
                Return _KeyId2
            End Get
            Set(ByVal value As Integer)
                _KeyId2 = value
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
    Public Class GridField

#Region "InstanceField"
        Private _Title As String
        Private _FieldType As eFieldType
        Private _Format As String
        Private _DataField As String
        Private _DataType As SqlDbType
        Private _Sortable As Boolean
        Private _FullyQualifiedDataField As String
        Private _ForcedWidth As String
        Private _ControlName As String
#End Region
#Region "Property"
        Public Property ControlName() As String
            Get
                Return _ControlName
            End Get
            Set(ByVal value As String)
                _ControlName = value
            End Set
        End Property
        Public Property ForcedWidth() As String
            Get
                Return _ForcedWidth
            End Get
            Set(ByVal value As String)
                _ForcedWidth = value
            End Set
        End Property
        Public Property Sortable() As Boolean
            Get
                Return _Sortable
            End Get
            Set(ByVal value As Boolean)
                _Sortable = value
            End Set
        End Property
        Public Property FullyQualifiedDataField() As String
            Get
                Return _FullyQualifiedDataField
            End Get
            Set(ByVal value As String)
                _FullyQualifiedDataField = value
            End Set
        End Property
        Public Property DataType() As SqlDbType
            Get
                Return _DataType
            End Get
            Set(ByVal value As SqlDbType)
                _DataType = value
            End Set
        End Property
        Public Property DataField() As String
            Get
                Return _DataField
            End Get
            Set(ByVal value As String)
                _DataField = value
            End Set
        End Property
        Public Property Format() As String
            Get
                Return _Format
            End Get
            Set(ByVal value As String)
                _Format = value
            End Set
        End Property
        Public Property FieldType() As eFieldType
            Get
                Return _FieldType
            End Get
            Set(ByVal value As eFieldType)
                _FieldType = value
            End Set
        End Property
        Public Property Title() As String
            Get
                Return _Title
            End Get
            Set(ByVal value As String)
                _Title = value
            End Set
        End Property
        Public ReadOnly Property Align()
            Get
                Select Case FieldType
                    Case eFieldType.Currency
                        Return "right"
                    Case eFieldType.DateTime
                        Return "center"
                    Case eFieldType.Percent
                        Return "center"
                    Case eFieldType.Text
                        Return "left"
                    Case eFieldType.Boolean
                        Return "center"
                    Case Else
                        Return "left"
                End Select
            End Get
        End Property
#End Region

        Public Sub SetDefaults()
            If String.IsNullOrEmpty(Format) Then
                Select Case FieldType
                    Case eFieldType.Currency
                        Format = "c"
                    Case eFieldType.DateTime
                        Format = "d MMM, yyyy"
                    Case eFieldType.Percent
                        Format = "P"
                    Case eFieldType.Boolean
                        Format = Nothing
                    Case eFieldType.Text
                        Format = Nothing
                End Select
            ElseIf Format = "" Then
                Format = Nothing
            End If
            If String.IsNullOrEmpty(Title) Then
                Title = ""
            End If
        End Sub
        Public Sub New()

        End Sub
        Public Sub New(ByVal Title As String, ByVal FieldType As eFieldType, ByVal Format As String, ByVal DataField As String, ByVal DataType As SqlDbType, ByVal sortable As Boolean, ByVal FullyQualifiedDataField As String, ByVal ForcedWidth As String)
            Me.New(Title, FieldType, Format, DataField, DataType, sortable, FullyQualifiedDataField)
            _ForcedWidth = ForcedWidth
        End Sub
        Public Sub New(ByVal Title As String, ByVal FieldType As eFieldType, ByVal Format As String, ByVal DataField As String, ByVal DataType As SqlDbType, ByVal sortable As Boolean, ByVal FullyQualifiedDataField As String)
            _Title = Title
            _FieldType = FieldType
            _Format = Format
            _DataField = DataField
            _DataType = DataType
            _Sortable = sortable
            _FullyQualifiedDataField = FullyQualifiedDataField
        End Sub
    End Class
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