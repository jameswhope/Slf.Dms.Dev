Imports System.IO
Imports System.Runtime.Serialization.Json

Public Class jsonHelper
    Public Shared Function SerializeObjectIntoJson(ByVal s As Object) As String
        Dim serializer As New DataContractJsonSerializer(s.[GetType]())
        Using ms As New MemoryStream()
            serializer.WriteObject(ms, s)
            ms.Flush()
            Dim bytes As Byte() = ms.GetBuffer()
            Dim jsonString As String = Encoding.UTF8.GetString(bytes, 0, bytes.Length).Trim(ControlChars.NullChar)
            Return jsonString
        End Using
    End Function
    Public Shared Function ControlToHTML(ByVal ctl As Control) As String
        Dim SB As New StringBuilder()
        Dim SW As New StringWriter(SB)
        Dim htmlTW As New HtmlTextWriter(SW)
        ctl.RenderControl(htmlTW)
        Return SB.ToString()
    End Function
End Class