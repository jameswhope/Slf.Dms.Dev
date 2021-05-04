Option Explicit On 

Imports System.Collections.Specialized
Imports System.Xml

Public Class QueryStringCombinationRule
    Inherits QueryStringRule

    Protected _operator As String

    Protected _rules As QueryStringRuleList

    Public ReadOnly Property Rules() As QueryStringRuleList
        Get
            Return _rules
        End Get
    End Property

    Public ReadOnly Property Op() As String
        Get
            Return _operator
        End Get
    End Property

    Public Sub New()
        Me.New("||")
    End Sub

    Public Sub New(ByVal Op As String)
        Me.New(String.Empty, Op)
    End Sub

    Public Sub New(ByVal name As String, ByVal Op As String)
        SetUp(name, Op)
    End Sub

    Public Sub New(ByVal el As XmlElement)
        If CollectionHelper.ContainsName(el.Attributes, "operator", False) Then
            SetUp(el.GetAttribute("name"), el.GetAttribute("operator"))
        Else
            SetUp(el.GetAttribute("name"), "||")
        End If

        _rules = New QueryStringRuleList()

        _rules.Load(el)
    End Sub

    Protected Sub SetUp(ByVal name As String, ByVal Op As String)
        _rules = New QueryStringRuleList()

        _name = name

        _operator = Op
    End Sub

    Public Overrides Function Validate(ByVal queryString As QueryStringCollection)
        Dim rule As QueryStringRule

        Dim succeeded As Boolean

        'Do the MustExist rules first
        For Each rule In Rules
            If TypeOf rule Is QueryStringMustExistRule Then
                If Not rule.Validate(queryString) Then
                    If Op = "&&" Then
                        Return False
                    End If
                Else
                    If Op = "||" Then
                        succeeded = True
                    End If
                End If
            End If
        Next rule


        'Do all the others
        For Each rule In Rules
            If Not TypeOf rule Is QueryStringMustExistRule Then
                If Not rule.Validate(queryString) Then
                    If Op = "&&" Then
                        Return False
                    End If
                Else
                    If Op = "||" Then
                        succeeded = True
                    End If
                End If
            End If
        Next rule

        If Op = "&&" Then
            Return True
        Else
            If succeeded Then
                Return True
            Else
                Return False
            End If
        End If
    End Function
End Class
