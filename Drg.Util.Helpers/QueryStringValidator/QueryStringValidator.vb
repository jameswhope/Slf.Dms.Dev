Option Explicit On 

Imports System.Collections.Specialized

Public Class QueryStringValidator
    Protected _queryString As QueryStringCollection
    Protected _baseRule As QueryStringCombinationRule

    Public ReadOnly Property Rules() As QueryStringRuleList
        Get
            Return _baseRule.Rules
        End Get
    End Property

    Public ReadOnly Property QueryString() As QueryStringCollection
        Get
            Return _queryString
        End Get
    End Property

    Public Sub New(ByVal queryString As NameValueCollection)
        _queryString = New QueryStringCollection(queryString)
        _baseRule = New QueryStringCombinationRule("&&")
    End Sub

    Public Function Validate() As Boolean
        Return _baseRule.Validate(QueryString)
    End Function
End Class
