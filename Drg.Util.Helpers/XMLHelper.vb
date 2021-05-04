Option Explicit On 

Imports System.Xml

Public Class XMLHelper

    Public Shared Sub AddAttribute(ByVal el As XmlElement, ByVal Name As String, ByVal Value As String)

        AddAttribute(el, Name, Value, True)

    End Sub
    Public Shared Sub AddAttribute(ByVal el As XmlElement, ByVal Name As String, ByVal Value As String, ByVal Pad As Boolean)

        If Value.Length > 0 Or Not Pad Then
            el.SetAttribute(Name, Value)
        Else
            el.SetAttribute(Name, "&nbsp;")
        End If

    End Sub

    Public Shared Sub AddAttribute(ByVal el As XmlElement, ByVal Name As String, ByVal Value As String, ByVal ValueRaw As Long, ByVal Pad As Boolean)

        AddAttribute(el, Name, Value, Pad)
        AddAttribute(el, Name & "Raw", ValueRaw, Pad)

    End Sub

End Class