Imports Microsoft.VisualBasic
Imports System.Collections.Generic
Imports System.Data

Public Class Query
#Region "Instance Field"
    Private _ActiveReportName As String
    Private _Criteria As List(Of IQueryCriteria)
    Private _Fields As List(Of QueryField)

    Private _Clickable As Boolean
    Private _ClickableURL As String
    Private _IconSrcURL As String
    Private _DataCommand As IDbCommand
#End Region
#Region "Property"
    Public Property DataCommand() As IDbCommand
        Get
            Return _DataCommand
        End Get
        Set(ByVal value As IDbCommand)
            _DataCommand = value
        End Set
    End Property
    Public Property ActiveReportName() As String
        Get
            Return _ActiveReportName
        End Get
        Set(ByVal value As String)
            _ActiveReportName = value
        End Set
    End Property

    Public Property Criteria() As List(Of IQueryCriteria)
        Get
            If _Criteria Is Nothing Then _Criteria = New List(Of IQueryCriteria)
            Return _Criteria
        End Get
        Set(ByVal value As List(Of IQueryCriteria))
            _Criteria = value
        End Set
    End Property

    Public Property Fields() As List(Of QueryField)
        Get
            If _Fields Is Nothing Then _Fields = New List(Of QueryField)
            Return _Fields
        End Get
        Set(ByVal value As List(Of QueryField))
            _Fields = value
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
#End Region
    Public Sub SetDefaults()
        If String.IsNullOrEmpty(ClickableURL) Then
            Clickable = False
        End If
        If String.IsNullOrEmpty(IconSrcURL) Then
            IconSrcURL = "~/images/icon.png"
        End If
    End Sub

    Public Sub New()

    End Sub
End Class

Public Interface IQueryCriteria

End Interface

Public Class QueryCriteria_CS
    Implements IQueryCriteria

    Private _DataCommand As IDbCommand
    Private _ValueField As String
    Private _DisplayField As String
    Private _Caption As String

    Public Property Caption() As String
        Get
            Return _Caption
        End Get
        Set(ByVal value As String)
            _Caption = value
        End Set
    End Property
    Public Property DataCommand() As IDbCommand
        Get
            Return _DataCommand
        End Get
        Set(ByVal value As IDbCommand)
            _DataCommand = value
        End Set
    End Property
    Public Property ValueField() As String
        Get
            Return _ValueField
        End Get
        Set(ByVal value As String)
            _ValueField = value
        End Set
    End Property
    Public Property DisplayField() As String
        Get
            Return _DisplayField
        End Get
        Set(ByVal value As String)
            _DisplayField = value
        End Set
    End Property
End Class

Public Class QueryCriteria_DateRange
    Implements IQueryCriteria

    Private _Caption As String

    Public Property Caption() As String
        Get
            Return _Caption
        End Get
        Set(ByVal value As String)
            _Caption = value
        End Set
    End Property

End Class

Public Class QueryCriteria_AmountRange
    Implements IQueryCriteria

    Private _Caption As String

    Public Property Caption() As String
        Get
            Return _Caption
        End Get
        Set(ByVal value As String)
            _Caption = value
        End Set
    End Property

End Class

Public Class QueryField

    Public Enum eFieldType
        Text = 1
        DateTime = 2
        Currency = 3
        Percent = 4
    End Enum
#Region "InstanceField"
    Private _Title As String
    Private _FieldType As eFieldType
    Private _Format As String
    Private _DataField As String
    Private _Sortable As Boolean
    Private _FullyQualifiedDataField As String
#End Region
#Region "Property"
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
#End Region

    Public Sub SetDefaults()
        If String.IsNullOrEmpty(Format) Then
            Select Case FieldType
                Case eFieldType.Currency
                    Format = "c"
                Case eFieldType.DateTime
                    Format = "d MMM, yyyy"
                Case eFieldType.Percent
                    Format = "D"
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
End Class