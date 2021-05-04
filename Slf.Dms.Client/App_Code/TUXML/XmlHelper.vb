Imports System.IO
Imports System.Xml.Serialization
Imports System.Xml.Xsl
Imports System.Xml

Public Class XmlHelper
    Public Shared Function Deserialize(Of T)(xml As String) As T
        Dim ser As New XmlSerializer(GetType(T))
        Using r As New StringReader(xml)
            Return CType(ser.Deserialize(r), T)
        End Using
    End Function

    Public Shared Function ConvertToTUHtml(ByVal xmlpath As String) As String
        Dim html As String = ""

        Try
            'Use xslt to generate html 
            Dim xmlDoc As XmlDocument = New XmlDocument()
            Dim xml As String = File.ReadAllText(xmlpath).Replace("xmlns=""https://api.creditly.co/v2""", "")
            xmlDoc.LoadXml(xml)
            Dim xslTran As XslCompiledTransform = New XslCompiledTransform(False)
            xslTran.Load(HttpContext.Current.Server.MapPath("~/App_Code/TUXML/TUXSLT.xslt"), New XsltSettings() With {.EnableScript = True}, New XmlUrlResolver)
            Dim sb As New StringBuilder
            Using sw As XmlWriter = XmlWriter.Create(sb, New XmlWriterSettings() With {.OmitXmlDeclaration = True, .CloseOutput = True})
                xslTran.Transform(xmlDoc, Nothing, sw)
                html = sb.ToString()
            End Using
        Catch ex As Exception
            html = "<p>Error transforming document</p>"
        End Try

        Return html
    End Function

End Class
