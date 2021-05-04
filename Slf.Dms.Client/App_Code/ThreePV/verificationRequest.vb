Imports Microsoft.VisualBasic
Imports System.Xml.Serialization
Imports System.Xml
Imports System.IO
Imports System.Text

<XmlRoot("verification-request")> _
Public Class verificationRequest
    <XmlAttribute("version")> Public version As String = "2.0"
    <XmlAttribute("vendor")> Public vendor As String = "SMARTDEBT"
    <XmlAttribute("language")> Public language As String = "en-US"
    <XmlAttribute("BTN")> Public btn As String
    <XmlAttribute("verify-type")> Public verifytype As String = "DEBT"
    <XmlAttribute("cname")> Public cname As String
    <XmlAttribute("caddr1")> Public caddr1 As String
    <XmlAttribute("caddr2")> Public caddr2 As String
    <XmlAttribute("city")> Public city As String
    <XmlAttribute("state")> Public state As String
    <XmlAttribute("zipcode")> Public zipCode As String
    <XmlAttribute("client-order")> Public clientOrder As String
    <XmlAttribute("business")> Public business As String = "N"
    <XmlAttribute("email-address")> Public emailAddress As String
    <XmlAttribute("site")> Public site As String
    <XmlAttribute("representative")> Public representative As String
    <XmlAttribute("birthdate")> Public birthdate As String
    <XmlAttribute("last-4-ssn")> Public last4SSN As String
    <XmlAttribute("centerid")> Public centerId As String
    <XmlAttribute("law-state")> Public lawStateCode As String
    <XmlAttribute("DraftDate")> Public draftDate As String
    <XmlAttribute("DraftAmount")> Public draftAmount As String

    <XmlElement("verify")> Public verifyRequestItems As verifyRequestItem()

    Public Function ToXml() As String
        Dim s As String = String.Empty
        Dim ns As New XmlSerializerNamespaces
        ns.Add("", "")
        Dim xs As New XmlSerializer(GetType(verificationRequest))
        Dim sw As New EncodedStringWriter(System.Text.Encoding.UTF8)
        Try
            xs.Serialize(sw, Me, ns)
            s = sw.ToString()
        Finally
            sw.Close()
        End Try
        Return s
    End Function
End Class

Public Class EncodedStringWriter
    Inherits StringWriter

    Private _Encoding As Encoding

    Public Sub New(ByVal Encoding As Encoding)
        _Encoding = Encoding
    End Sub

    Public Overrides ReadOnly Property Encoding() As Encoding
        Get
            Return _Encoding
        End Get
    End Property
End Class

