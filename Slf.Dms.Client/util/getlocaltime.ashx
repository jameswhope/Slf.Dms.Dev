<%@ WebHandler Language="VB" Class="getlocaltime" %>

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports System
Imports System.Xml
Imports System.Web

Public Class getlocaltime : Implements IHttpHandler
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        Dim zip As String = String.Empty
        Dim format As String = String.Empty

        Dim doc As XmlDocument = New XmlDocument
        Dim el As XmlElement = doc.CreateElement("location")

        If Not context.Request.QueryString("zip") Is Nothing Then
            zip = context.Request.QueryString("zip")
        End If

        If Not context.Request.QueryString("format") Is Nothing Then
            format = context.Request.QueryString("format")
        End If

        If zip.Trim.Length >= 5 Then

            Dim WebInfo As AddressHelper.AddressInfo = AddressHelper.GetInfoForZip(zip.Trim.Substring(0, 5))

            If Not WebInfo Is Nothing AndAlso WebInfo.ZipCode.Length > 0 Then

                Dim CurrentDifferenceFromUTC As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblTimeZone", _
                    "FromUTC", "DBIsHere = 1"))

                Dim PersonDifferenceFromUTC As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblTimeZone", _
                    "FromUTC", "TimeZoneID = " & WebInfo.TimeZoneID))

                Dim CurrentTime As DateTime = TimeZoneHelper.GetLocalTime(CurrentDifferenceFromUTC, _
                    PersonDifferenceFromUTC)

                If format.Trim.Length > 0 Then
                    el.SetAttribute("time", CurrentTime.ToString(format))
                Else
                    el.SetAttribute("time", CurrentTime.ToString("MM/dd/yyyy hh:mm:ss tt"))
                End If

                el.SetAttribute("zone", WebInfo.TimeZone)

            End If

        End If

        doc.AppendChild(el)

        context.Response.ClearContent()
        context.Response.ClearHeaders()
        context.Response.ContentType = "text/xml"

        context.Response.Write("<?xml version=""1.0""?>")
        doc.Save(context.Response.OutputStream)
        context.Response.End()

    End Sub
 
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class