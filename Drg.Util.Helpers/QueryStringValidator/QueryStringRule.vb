Option Explicit On

Imports System.Collections.Specialized 

Public MustInherit Class QueryStringRule
    Protected _name as String

    Public Readonly Property Name() as String
        Get
            Return _name
        End Get
    End Property

    Public MustOverride Function Validate(ByVal queryString As QueryStringCollection)
End Class