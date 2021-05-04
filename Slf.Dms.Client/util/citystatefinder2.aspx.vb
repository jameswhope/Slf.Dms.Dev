Option Explicit On

Imports AssistedSolutions.WebControls.CityStateFinder
Imports System.Net
Imports System.Xml
Imports System.Security.Cryptography.X509Certificates

Partial Class util_citystatefinder2
    Inherits System.Web.UI.Page

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Dim zip As String = String.Empty
        Dim doc As XmlDocument = New XmlDocument
        Dim adr As XmlElement = doc.CreateElement("address")

        If Not Request.QueryString("zip") Is Nothing Then
            zip = Request.QueryString("zip")
        End If

        Try
            ServicePointManager.ServerCertificateValidationCallback = New Security.RemoteCertificateValidationCallback(AddressOf customCertificateValidation)

            Dim loc() As CityStateLocations = AssistedSolutions.WebControls.CityStateFinder.CityStateFinder.SearchOn(zip, True)

            If loc.Length > 0 Then
                'adr.SetAttribute("city", loc(0).City)
                'adr.SetAttribute("stateabbreviation", loc(0).StateAbbreviation)
                'adr.SetAttribute("statename", loc(0).StateName)
                'adr.SetAttribute("ziphigh", loc(0).ZipHigh)
                'adr.SetAttribute("ziplow", loc(0).ZipLow)
                Response.Write(loc(0).City)
            End If

            'doc.AppendChild(adr)

            'Response.ClearContent()
            'Response.ClearHeaders()
            'Response.ContentType = "text/xml"

            'Response.Write("<?xml version=""1.0""?>")
            'doc.Save(Response.OutputStream)
            'Response.End()
        Catch ex As Exception
            Response.Write(ex.Message)
        End Try

    End Sub

    Private Function customCertificateValidation(ByVal sender As Object, ByVal cert As X509Certificate, ByVal chain As X509Chain, ByVal sslPolicyErrors As Security.SslPolicyErrors) As Boolean
        Return True
    End Function
End Class