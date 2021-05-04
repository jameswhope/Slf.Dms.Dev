Option Explicit On

Public Class ReferenceField

#Region "Variables"

    Private _referencefieldid As Integer
    Private _referenceid As Integer
    Private _category As String
    Private _caption As String
    Private _field As String
    Private _definition As String
    Private _join As String
    Private _type As String
    Private _multi As Boolean
    Private _multiorder As Integer
    Private _multiformat As String
    Private _width As String
    Private _align As String
    Private _single As Boolean
    Private _singleformat As String
    Private _editable As Boolean
    Private _required As Boolean
    Private _validate As String
    Private _attributes As String
    Private _input As String
    Private _immask As String
    Private _ddlsource As String
    Private _ddlvalue As String
    Private _ddltext As String
    Private _fieldtosave As String

#End Region

#Region "Properties"

    ReadOnly Property ReferenceFieldID() As Integer
        Get
            Return _referencefieldid
        End Get
    End Property
    ReadOnly Property ReferenceID() As Integer
        Get
            Return _referenceid
        End Get
    End Property
    ReadOnly Property Category() As String
        Get
            Return _category
        End Get
    End Property
    ReadOnly Property Caption() As String
        Get
            Return _caption
        End Get
    End Property
    ReadOnly Property Field() As String
        Get
            Return _field
        End Get
    End Property
    ReadOnly Property Definition() As String
        Get
            Return _definition
        End Get
    End Property
    ReadOnly Property Join() As String
        Get
            Return _join
        End Get
    End Property
    ReadOnly Property Type() As String
        Get
            Return _type
        End Get
    End Property
    ReadOnly Property Multi() As Boolean
        Get
            Return _multi
        End Get
    End Property
    ReadOnly Property MultiOrder() As Integer
        Get
            Return _multiorder
        End Get
    End Property
    ReadOnly Property MultiFormat() As String
        Get
            Return _multiformat
        End Get
    End Property
    ReadOnly Property Width() As String
        Get
            Return _width
        End Get
    End Property
    ReadOnly Property Align() As String
        Get
            Return _align
        End Get
    End Property
    ReadOnly Property [Single]() As Boolean
        Get
            Return _single
        End Get
    End Property
    ReadOnly Property SingleFormat() As String
        Get
            Return _singleformat
        End Get
    End Property
    ReadOnly Property Editable() As Boolean
        Get
            Return _editable
        End Get
    End Property
    ReadOnly Property Required() As Boolean
        Get
            Return _required
        End Get
    End Property
    ReadOnly Property Validate() As String
        Get
            Return _validate
        End Get
    End Property
    ReadOnly Property Attributes() As String
        Get
            Return _attributes
        End Get
    End Property
    ReadOnly Property Input() As String
        Get
            Return _input
        End Get
    End Property
    ReadOnly Property IMMask() As String
        Get
            Return _immask
        End Get
    End Property
    ReadOnly Property DDLSource() As String
        Get
            Return _ddlsource
        End Get
    End Property
    ReadOnly Property DDLValue() As String
        Get
            Return _ddlvalue
        End Get
    End Property
    ReadOnly Property DDLText() As String
        Get
            Return _ddltext
        End Get
    End Property
    ReadOnly Property FieldToSave() As String
        Get
            Return _fieldtosave
        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal ReferenceFieldID As Integer, ByVal ReferenceID As Integer, ByVal Category As String, _
        ByVal Caption As String, ByVal Field As String, ByVal Definition As String, ByVal Join As String, _
        ByVal Type As String, ByVal Multi As Boolean, ByVal MultiOrder As Integer, ByVal MultiFormat As String, _
        ByVal Width As String, ByVal Align As String, ByVal [Single] As Boolean, ByVal SingleFormat As String, _
        ByVal Editable As Boolean, ByVal Required As Boolean, ByVal Validate As String, _
        ByVal Attributes As String, ByVal Input As String, ByVal IMMask As String, ByVal DDLSource As String, _
        ByVal DDLValue As String, ByVal DDLText As String, ByVal FieldToSave As String)

        _referencefieldid = ReferenceFieldID
        _referenceid = ReferenceID
        _category = Category
        _caption = Caption
        _field = Field
        _definition = Definition
        _join = Join
        _type = Type
        _multi = Multi
        _multiorder = MultiOrder
        _multiformat = MultiFormat
        _width = Width
        _align = Align
        _single = [Single]
        _singleformat = SingleFormat
        _editable = Editable
        _required = Required
        _validate = Validate
        _attributes = Attributes
        _input = Input
        _immask = IMMask
        _ddlsource = DDLSource
        _ddlvalue = DDLValue
        _ddltext = DDLText
        _fieldtosave = FieldToSave

    End Sub

#End Region

End Class