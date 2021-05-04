Option Explicit On

Imports AssistedSolutions.WebControls.CityStateFinder

Imports System.Xml

Partial Class clients_new_xml_citystatefinder
    Inherits System.Web.UI.Page

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Dim zip As String = String.Empty
        Dim doc As XmlDocument = New XmlDocument
        Dim adr As XmlElement = doc.CreateElement("address")

        If Not Request.QueryString("zip") Is Nothing Then
            zip = Request.QueryString("zip")
        End If

        Dim loc() As CityStateLocations = AssistedSolutions.WebControls.CityStateFinder.CityStateFinder.SearchOn(zip, True)

        If loc.Length > 0 Then
            adr.SetAttribute("city", loc(0).City)
            adr.SetAttribute("stateabbreviation", loc(0).StateAbbreviation)
            adr.SetAttribute("statename", loc(0).StateName)
            adr.SetAttribute("ziphigh", loc(0).ZipHigh)
            adr.SetAttribute("ziplow", loc(0).ZipLow)
        End If

        doc.AppendChild(adr)

        Response.ClearContent()
        Response.ClearHeaders()
        Response.ContentType = "text/xml"

        Response.Write("<?xml version=""1.0""?>")
        doc.Save(Response.OutputStream)
        Response.End()

    End Sub
End Class