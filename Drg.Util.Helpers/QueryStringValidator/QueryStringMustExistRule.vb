Option Explicit On 

Imports System.Collections.Specialized
Imports System.Xml

Public Class QueryStringMustExistRule
    Inherits QueryStringRule

    Protected _mustExist As Boolean
    Protected _defaultValue As String

    Public ReadOnly Property MustExist() As Boolean
        Get
            Return _mustExist
        End Get
    End Property

    Public Sub New(ByVal name As String, ByVal mustExist As Boolean)
        SetUp(name, mustExist, Nothing)
    End Sub

    Public Sub New(ByVal name As String, ByVal mustExist As Boolean, ByVal defaultValue As String)
        SetUp(name, mustExist, defaultValue)
    End Sub

    Public Sub New(ByVal el As XmlElement)
        Dim mustExist As Boolean

        If CollectionHelper.ContainsName(el.Attributes, "mustExist", False) Then
            mustExist = Boolean.Parse(el.GetAttribute("mustExist"))
        Else
            mustExist = True
        End If

        If CollectionHelper.ContainsName(el.Attributes, "defaultValue", False) Then
            SetUp(el.GetAttribute("name"), mustExist, el.GetAttribute("defaultValue"))
        Else
            SetUp(el.GetAttribute("name"), mustExist, Nothing)
        End If
    End Sub

    Protected Sub SetUp(ByVal name As String, ByVal mustExist As Boolean, ByVal defaultValue As String)
        _name = name

        If Not defaultValue Is Nothing Then
            mustExist = False
        End If

        _mustExist = mustExist
        _defaultValue = defaultValue
    End Sub

    Public Overrides Function Validate(ByVal queryString As QueryStringCollection)
        If Not CollectionHelper.Contains(queryString.Keys, Name, False) Then
            If Not _defaultValue Is Nothing Then
                'If _defaultValue.Length > 0 Then
                queryString.Add(Name, _defaultValue)
                'End If
            ElseIf _mustExist Then
                Return False
            End If
        End If

        Return True
    End Function
End Class
