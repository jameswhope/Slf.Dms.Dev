Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://service.lexxiom.com/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class DocumentTRAK
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function RecieveDocument(ByVal orderID As String, ByVal docID As String, ByVal completed As Boolean, ByVal docContents As Byte()) As String

        Try
            Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir").ToString & String.Format("{0}.pdf", docID)
            Dim writer As New System.IO.BinaryWriter(System.IO.File.OpenWrite(path))

            writer.Write(docContents)
            writer.Flush()
            writer.Close()

            If completed Then 'should always be true
                DocumentNowHelper.LeadDocumentComplete(docID)
            End If
        Catch ex As Exception
            DocumentNowHelper.LogException(ex.Message)
        End Try

        Return True.ToString()
    End Function

End Class
