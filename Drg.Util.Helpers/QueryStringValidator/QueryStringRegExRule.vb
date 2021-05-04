Option Explicit On 

Imports System.Collections.Specialized
Imports System.Text.RegularExpressions
Imports System.Xml

Public Class QueryStringRegExRule
    Inherits QueryStringRule

    Protected _regEx As String

    Public ReadOnly Property RegEx() As String
        Get
            Return _regEx
        End Get
    End Property

    Public Sub New(ByVal name As String, ByVal regEx As String)
        SetUp(name, regEx)
    End Sub

    Public Sub New(ByVal el As XmlElement)
        'If el.Attributes.GetNamedItem("defaultValue") Is Nothing Then
        SetUp(el.GetAttribute("name"), el.GetAttribute("regex"))
        'Else
        '    SetUp(el.GetAttribute("name"), el.GetAttribute("mustExist"), el.GetAttribute("defaultValue"))
        'End If
    End Sub

    Protected Sub SetUp(ByVal name As String, ByVal regEx As String)
        _name = name

        _regEx = regEx
    End Sub

    Public Overrides Function Validate(ByVal queryString As QueryStringCollection)
        Dim value As String

        value = queryString(Name)
        System.Console.WriteLine(value)
        If Not (value Is Nothing Or value.Length = 0) Then
            Dim rx As Regex = New Regex(RegEx)

            If Not rx.IsMatch(value) Then
                System.Console.WriteLine("nogood")
                Return False
            End If
        End If

        Return True
    End Function
End Class
