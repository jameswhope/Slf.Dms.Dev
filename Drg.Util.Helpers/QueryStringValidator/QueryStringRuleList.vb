Option Explicit On 

Imports System.Collections.Specialized
Imports System.Xml

Public Class QueryStringRuleList
    Inherits CollectionBase

    Public Function Add(ByVal rule As QueryStringRule) As Integer
        Return InnerList.Add(rule)
    End Function

    Public Property Item(ByVal index As Integer) As QueryStringRule
        Get
            Return InnerList.Item(index)
        End Get
        Set(ByVal value As QueryStringRule)
            InnerList.Item(index) = value
        End Set
    End Property

    Public Sub Load(ByVal el As XmlElement)
        Dim subEl As XmlElement

        For Each subEl In el.SelectNodes("*")
            Select Case subEl.Name
                Case "mustexistrule"
                    Add(New QueryStringMustExistRule(subEl))
                Case "regexrule"
                    Add(New QueryStringRegexRule(subEl))
                Case "combinationrule"
                    Add(New QueryStringCombinationRule(subEl))
            End Select
        Next subEl
    End Sub
End Class
