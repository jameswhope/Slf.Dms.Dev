Option Explicit On 

Imports System.Xml

Public Class ConfigHelper
    Protected xd As XmlDocument

    Public Sub New(ByVal fileName As String)
        xd = New XmlDocument()

        xd.Load(fileName)
    End Sub

    Public Function GetNode(ByVal xpath As String) As XmlNode
        Try
            Return xd.DocumentElement.SelectSingleNode(xpath)
        Catch
            Return Nothing
        End Try
    End Function
End Class
