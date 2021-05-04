Imports Microsoft.VisualBasic
Imports System.Xml.Serialization

Public Class verifyRequestItem
    <XmlAttribute("ANI")> Public ANI As String = String.Empty
    <XmlAttribute("verify-item")> Public verifyItem As String = String.Empty

    Public Sub New()

    End Sub

    Public Sub New(ByVal pAni As String, ByVal pVerifyItem As String)
        ANI = pAni
        verifyItem = pVerifyItem
    End Sub
End Class
