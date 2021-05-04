Option Explicit On

Public Class [Property]

#Region "Variables"

    Private _propertyid As Integer
    Private _propertycategoryid As Integer
    Private _name As String
    Private _display As String
    Private _multi As Boolean
    Private _value As String
    Private _type As String
    Private _description As String
    Private _created As DateTime
    Private _createdby As Integer
    Private _createdbyname As String
    Private _lastmodified As DateTime
    Private _lastmodifiedby As Integer
    Private _lastmodifiedbyname As String

#End Region

#Region "Properties"

    ReadOnly Property PropertyID() As Integer
        Get
            Return _propertyid
        End Get
    End Property
    ReadOnly Property PropertyCategoryID() As Integer
        Get
            Return _propertycategoryid
        End Get
    End Property
    ReadOnly Property Name() As String
        Get
            Return _name
        End Get
    End Property
    ReadOnly Property Display() As String
        Get
            Return _display
        End Get
    End Property
    ReadOnly Property Multi() As Boolean
        Get
            Return _multi
        End Get
    End Property
    ReadOnly Property Value() As String
        Get
            Return _value
        End Get
    End Property
    ReadOnly Property Type() As String
        Get
            Return _type
        End Get
    End Property
    ReadOnly Property Description() As String
        Get
            Return _description
        End Get
    End Property
    ReadOnly Property Created() As DateTime
        Get
            Return _created
        End Get
    End Property
    ReadOnly Property CreatedBy() As Integer
        Get
            Return _createdby
        End Get
    End Property
    ReadOnly Property CreatedByName() As String
        Get
            Return _createdbyname
        End Get
    End Property
    ReadOnly Property LastModifed() As DateTime
        Get
            Return _lastmodified
        End Get
    End Property
    ReadOnly Property LastModifiedBy() As Integer
        Get
            Return _lastmodifiedby
        End Get
    End Property
    ReadOnly Property LastModifiedByName() As String
        Get
            Return _lastmodifiedbyname
        End Get
    End Property

#End Region

#Region "Constructor"

    Public Sub New(ByVal PropertyID As Integer, ByVal PropertyCategoryID As Integer, ByVal Name As String, _
        ByVal Display As String, ByVal Multi As Boolean, ByVal Value As String, ByVal Type As String, _
        ByVal Description As String, ByVal Created As DateTime, ByVal CreatedBy As Integer, _
        ByVal CreatedByName As String, ByVal LastModified As DateTime, ByVal LastModifiedBy As Integer, _
        ByVal LastModifiedByName As String)

        _propertyid = PropertyID
        _propertycategoryid = PropertyCategoryID
        _name = Name
        _display = Display
        _multi = Multi
        _value = Value
        _type = Type
        _description = Description
        _created = Created
        _createdby = CreatedBy
        _createdbyname = CreatedByName
        _lastmodified = LastModified
        _lastmodifiedby = LastModifiedBy
        _lastmodifiedbyname = LastModifiedByName

    End Sub

#End Region

End Class