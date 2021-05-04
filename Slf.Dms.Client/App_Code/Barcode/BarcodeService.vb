Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://service.lexxiom.com/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class BarcodeService
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function CreateBarCode(ByVal inputstr As String, ByVal Rotate As String) As Byte()
        Dim scwc As New TechnoRiver.SmartCodeWeb.SmartCodeWebControl()
        scwc.Symbology = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeSymbology.CODE39ASCII
        scwc.BarcodeData = inputstr
        Select Case Rotate.ToLower
            Case "", "none"
                scwc.Rotation = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeRotation.None
            Case "left"
                scwc.Rotation = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeRotation.Rotate270
            Case "right"
                scwc.Rotation = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeRotation.Rotate90
            Case "over"
                scwc.Rotation = TechnoRiver.SmartCodeWeb.SmartCodeWebControl.BarcodeRotation.Rotate180
        End Select
        Dim bmp As System.Drawing.Bitmap = scwc.GetBitMap()
        Dim stream As New System.IO.MemoryStream()
        bmp.Save(stream, System.Drawing.Imaging.ImageFormat.Png)
        stream.Close()
        Return stream.ToArray()
    End Function

End Class
