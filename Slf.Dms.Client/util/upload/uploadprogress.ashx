<%@ WebHandler language="vb" Class="SimpleUploadProgressHandler" %>

Imports System
Imports System.Collections
Imports System.ComponentModel
Imports System.Data
Imports System.IO
Imports System.Web
Imports System.Web.SessionState
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls
Imports System.Xml

Imports AssistedSolutions.SlickUpload

'Provides a <see cref="IHttpHandler">IHttpHandler</see> that returns information about an upload given its uploadId.
public class SimpleUploadProgressHandler
    Implements IHttpHandler
		
    Public Overridable Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim uploadId As String = context.Request.QueryString("uploadId")

        context.Response.ContentType = "text/xml"

        Dim writer As XmlTextWriter = New XmlTextWriter(context.Response.OutputStream, context.Response.ContentEncoding)

        writer.WriteStartDocument()

        writer.WriteStartElement("uploadStatus")

        Dim status As UploadStatus = HttpUploadModule.GetUploadStatus(uploadId)

        If Not status Is Nothing Then
            writer.WriteAttributeString("state", status.State.ToString())
            writer.WriteAttributeString("positionRaw", status.Position.ToString())
            writer.WriteAttributeString("contentLengthRaw", status.ContentLength.ToString())
            writer.WriteAttributeString("remainingLengthRaw", (status.ContentLength - status.Position).ToString())
            writer.WriteAttributeString("transferredLengthRaw", (status.ContentLength - (status.ContentLength - status.Position)).ToString())
            writer.WriteAttributeString("positionText", FormatBytes(status.Position))
            writer.WriteAttributeString("contentLengthText", FormatBytes(status.ContentLength))
            writer.WriteAttributeString("remainingLengthText", FormatBytes(status.ContentLength - status.Position))
            writer.WriteAttributeString("transferredLengthText", FormatBytes(status.ContentLength - (status.ContentLength - status.Position)))
            Dim elapsed As TimeSpan = DateTime.Now.Subtract(status.Start)
            writer.WriteAttributeString("elapsedTimeText", elapsed.TotalMinutes.ToString("G2") + " Min")
            writer.WriteAttributeString("remainingTimeText", ((elapsed.TotalMinutes / status.Position) * (status.ContentLength - status.Position) + elapsed.TotalMinutes).ToString("G2") + " Min")
        End If

        writer.WriteEndElement()
        writer.WriteEndDocument()

        writer.Flush()
    End Sub

    Function FormatBytes(ByVal bytes As Long) As String
        Const ONE_KB As Double = 1024
        Const ONE_MB As Double = ONE_KB * 1024
        Const ONE_GB As Double = ONE_MB * 1024
        Const ONE_TB As Double = ONE_GB * 1024
        Const ONE_PB As Double = ONE_TB * 1024
        Const ONE_EB As Double = ONE_PB * 1024
        Const ONE_ZB As Double = ONE_EB * 1024
        Const ONE_YB As Double = ONE_ZB * 1024

        If bytes <= 999 Then
            Return bytes.ToString() + " bytes"
        ElseIf bytes <= ONE_KB * 999 Then
            Return ThreeNonZeroDigits(bytes / ONE_KB) + " KB"
        ElseIf bytes <= ONE_MB * 999 Then
            Return ThreeNonZeroDigits(bytes / ONE_MB) + " MB"
        ElseIf bytes <= ONE_GB * 999 Then
            Return ThreeNonZeroDigits(bytes / ONE_GB) + " GB"
        ElseIf bytes <= ONE_TB * 999 Then
            Return ThreeNonZeroDigits(bytes / ONE_TB) + " TB"
        ElseIf bytes <= ONE_PB * 999 Then
            Return ThreeNonZeroDigits(bytes / ONE_PB) + " PB"
        ElseIf bytes <= ONE_EB * 999 Then
            Return ThreeNonZeroDigits(bytes / ONE_EB) + " EB"
        ElseIf bytes <= ONE_ZB * 999 Then
            Return ThreeNonZeroDigits(bytes / ONE_ZB) + " ZB"
        Else
            Return ThreeNonZeroDigits(bytes / ONE_YB) + " YB"
        End If
    End Function

    Protected Function ThreeNonZeroDigits(ByVal value As Double) As String
        If value >= 100 Then
            Return CType(value, Integer).ToString()
        ElseIf value >= 10 Then
            Return value.ToString("0.0")
        Else
            Return value.ToString("0.00")
        End If
    End Function

    Public Overridable ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return True
        End Get
    End Property
End class
