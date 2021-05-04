Imports Microsoft.VisualBasic
Imports System.Collections.Generic

Public Class GridPermission
    Private _children As List(Of GridPermission) = New List(Of GridPermission)
    Private _id As Integer
    Private _parentId As Nullable(Of Integer)
    Private _view As Nullable(Of Boolean)
    Private _add As Nullable(Of Boolean)
    Private _editOwn As Nullable(Of Boolean)
    Private _deleteOwn As Nullable(Of Boolean)
    Private _editAll As Nullable(Of Boolean)
    Private _deleteAll As Nullable(Of Boolean)
    Private _level As Integer
    Private _isOperation As Integer
    Private _name As String
    Private _isLast As Boolean
    Private _isSystem As Boolean
    Private _NumChildren As Integer

    Public Sub New()

    End Sub
    Public Sub New(ByVal Id As Integer, ByVal ParentId As Nullable(Of Integer), ByVal Name As String, ByVal View As Nullable(Of Boolean), ByVal Add As Nullable(Of Boolean), ByVal EditOwn As Nullable(Of Boolean), ByVal EditAll As Nullable(Of Boolean), ByVal DeleteOwn As Nullable(Of Boolean), ByVal DeleteAll As Nullable(Of Boolean), ByVal IsOperation As Integer)
        Me.New(Id, ParentId, Name, View, Add, EditOwn, EditAll, DeleteOwn, DeleteAll, IsOperation, False)
    End Sub
    Public Sub New(ByVal Id As Integer, ByVal ParentId As Nullable(Of Integer), ByVal Name As String, ByVal View As Nullable(Of Boolean), ByVal Add As Nullable(Of Boolean), ByVal EditOwn As Nullable(Of Boolean), ByVal EditAll As Nullable(Of Boolean), ByVal DeleteOwn As Nullable(Of Boolean), ByVal DeleteAll As Nullable(Of Boolean), ByVal IsOperation As Integer, ByVal IsSystem As Boolean)
        _view = View
        _add = Add
        _editOwn = EditOwn
        _editAll = EditAll
        _deleteOwn = DeleteOwn
        _deleteAll = DeleteAll
        _id = Id
        _parentId = ParentId
        _isOperation = IsOperation
        _name = Name
        _isSystem = IsSystem
    End Sub
    Public Property NumChildren() As Integer
        Get
            Return _NumChildren
        End Get
        Set(ByVal value As Integer)
            _NumChildren = value
        End Set
    End Property
    Public Property IsSystem() As Boolean
        Get
            Return _isSystem
        End Get
        Set(ByVal value As Boolean)
            _isSystem = value
        End Set
    End Property
    Public Property IsLast() As Boolean
        Get
            Return _isLast
        End Get
        Set(ByVal value As Boolean)
            _isLast = value
        End Set
    End Property
    Public Property Name() As String
        Get
            Return _name
        End Get
        Set(ByVal value As String)
            _name = value
        End Set
    End Property
    Public Property Children() As List(Of GridPermission)
        Get
            Return _children
        End Get
        Set(ByVal value As List(Of GridPermission))
            _children = value
        End Set
    End Property
    Public Property IsOperation() As Integer
        Get
            Return _isOperation
        End Get
        Set(ByVal value As Integer)
            _isOperation = value
        End Set
    End Property
    Public Property Id() As Integer
        Get
            Return _id
        End Get
        Set(ByVal value As Integer)
            _id = value
        End Set
    End Property
    Public Property ParentId() As Nullable(Of Integer)
        Get
            Return _parentId
        End Get
        Set(ByVal value As Nullable(Of Integer))
            _parentId = value
        End Set
    End Property
    Public Property Level() As Integer
        Get
            Return _level
        End Get
        Set(ByVal value As Integer)
            _level = value
        End Set
    End Property
    Public Property View() As Nullable(Of Boolean)
        Get
            Return _view
        End Get
        Set(ByVal value As Nullable(Of Boolean))
            _view = value
        End Set
    End Property
    Public Property Add() As Nullable(Of Boolean)
        Get
            Return _add
        End Get
        Set(ByVal value As Nullable(Of Boolean))
            _add = value
        End Set
    End Property
    Public Property EditOwn() As Nullable(Of Boolean)
        Get
            Return _editOwn
        End Get
        Set(ByVal value As Nullable(Of Boolean))
            _editOwn = value
        End Set
    End Property
    Public Property EditAll() As Nullable(Of Boolean)
        Get
            Return _editAll
        End Get
        Set(ByVal value As Nullable(Of Boolean))
            _editAll = value
        End Set
    End Property
    Public Property DeleteOwn() As Nullable(Of Boolean)
        Get
            Return _deleteOwn
        End Get
        Set(ByVal value As Nullable(Of Boolean))
            _deleteOwn = value
        End Set
    End Property
    Public Property DeleteAll() As Nullable(Of Boolean)
        Get
            Return _deleteAll
        End Get
        Set(ByVal value As Nullable(Of Boolean))
            _deleteAll = value
        End Set
    End Property
End Class