Imports System.Xml
Imports System.Net

Public Class TUResponseStatus

    Public Enum Statuses
        NotSet = 0
        OK
        TUError
        WebException
        Exception
    End Enum

    Private _status As Statuses = Statuses.NotSet
    Private _code As String
    Private _message As String

    Public ReadOnly Property Status() As Statuses
        Get
            Return _status
        End Get
    End Property

    Public ReadOnly Property Code() As String
        Get
            Return _code
        End Get
    End Property

    Public ReadOnly Property Message() As String
        Get
            Return _message
        End Get
    End Property

    Public Sub New(ByVal obj As Object)
        Select Case True
            Case TypeOf obj Is TUXML.Response.creditBureau
                _status = Statuses.OK
                _code = "0"
                _message = "success"
            Case TypeOf obj Is TUXML.Response.Error.creditBureau
                _status = Statuses.TUError
                _code = CType(obj, TUXML.Response.Error.creditBureau).product.error.code
                _message = CType(obj, TUXML.Response.Error.creditBureau).product.error.description
            Case TypeOf obj Is System.Net.WebException
                _status = Statuses.WebException

                Try
                    Dim errResp As WebResponse = CType(obj, WebException).Response
                    Dim xml As String
                    Using rps As New System.IO.StreamReader(errResp.GetResponseStream())
                        xml = rps.ReadToEnd()
                    End Using
                    Dim xmldoc As New XmlDocument
                    xmldoc.LoadXml(xml)
                    _code = xmldoc.SelectSingleNode("//errorcode").InnerText.Trim
                    _message = xmldoc.SelectSingleNode("//errortext").InnerText.Trim
                Catch ex As Exception
                    'ignore this and use web exception values
                    _code = CType(obj, System.Net.WebException).Status
                    _message = CType(obj, System.Net.WebException).Message
                End Try

            Case TypeOf obj Is System.Exception
                _status = Statuses.Exception
                _code = "1000"
                _message = CType(obj, System.Exception).Message
            Case Else
                'Default
        End Select
    End Sub

End Class

Public Class TUResponse

    Private _status As New TUResponseStatus(Nothing)
    Private _error As TUXML.Response.Error.creditBureau = Nothing
    Private _response As TUXML.Response.creditBureau = Nothing
    Private _xml As String = ""
    Private _xmlfilename As String = ""

    Public Sub New(ByVal xml As String)
        Try
            _xml = xml
            If ContainsError(xml) Then
                Me.[Error] = XmlHelper.Deserialize(Of TUXML.Response.Error.creditBureau)(xml)
                _status = New TUResponseStatus(Me.Error)
            Else
                Me.Response = XmlHelper.Deserialize(Of TUXML.Response.creditBureau)(xml)
                _status = New TUResponseStatus(Me.Response)
            End If
        Catch ex As Exception
            _status = New TUResponseStatus(ex)
        End Try
    End Sub

    Public Sub New(ByVal ex As System.Exception)
        _status = New TUResponseStatus(ex)
    End Sub

    Public Sub New(ByVal wex As System.Net.WebException)
        _status = New TUResponseStatus(wex)
    End Sub

    Public ReadOnly Property XML() As String
        Get
            Return _xml
        End Get
    End Property

    Public Property [Error]() As TUXML.Response.Error.creditBureau
        Get
            Return _error
        End Get
        Set(ByVal value As TUXML.Response.Error.creditBureau)
            _error = value
        End Set
    End Property

    Public Property Response() As TUXML.Response.creditBureau
        Get
            Return _response
        End Get
        Set(ByVal value As TUXML.Response.creditBureau)
            _response = value
        End Set
    End Property

    Public ReadOnly Property Status() As TUResponseStatus
        Get
            Return _status
        End Get
    End Property

    Public ReadOnly Property XMlFilename() As String
        Get
            Return _xmlfilename
        End Get
    End Property

    Public Function HasErrors() As Boolean
        Return Not Me.[Error] Is Nothing
    End Function

    Public Sub AddRequestParameters(ByVal req As TURequest)
        Dim xmldoc As New XmlDocument()
        xmldoc.LoadXml(XML)
        Dim ns As New XmlNamespaceManager(xmldoc.NameTable)
        ns.AddNamespace("myns", "https://api.creditly.co/v2")
        Dim rootnode As XmlNode = xmldoc.SelectSingleNode(String.Format("//{0}:creditBureau", "myns"), ns)
        If Not rootnode Is Nothing Then
            If rootnode.SelectSingleNode("requestParameters") Is Nothing Then
                Dim requestElement As XmlElement = xmldoc.CreateElement("requestParameters")
                rootnode.AppendChild(requestElement)
                Dim element As XmlElement = xmldoc.CreateElement("subjectName")
                element.InnerText = String.Format("{0}, {1}", req.Person.name.person.last, req.Person.name.person.first)
                requestElement.AppendChild(element)
                element = xmldoc.CreateElement("subjectSSN")
                element.InnerText = String.Format("{0}", req.Person.socialSecurity.number)
                requestElement.AppendChild(element)
                element = xmldoc.CreateElement("subjectStreet")
                element.InnerText = String.Format("{0}", req.Person.address.street.unparsed)
                requestElement.AppendChild(element)
                element = xmldoc.CreateElement("subjectLocation")
                element.InnerText = String.Format("{0} {1}. {2}", req.Person.address.location.city, req.Person.address.location.state, req.Person.address.location.zipCode)
                requestElement.AppendChild(element)
                element = xmldoc.CreateElement("subscriberName")
                element.InnerText = String.Format("{0}", req.AccountName)
                requestElement.AppendChild(element)
                _xml = xmldoc.OuterXml
            End If
        End If
    End Sub

    Public Function SaveXmlAsDocument() As String
        If Not Me.Response Is Nothing Then
            Try
                Dim xmlPath As String = ConfigurationManager.AppSettings("LeadDocumentsDir").ToString & String.Format("xml\{0}.xml", Me.Response.transactionControl.userRefNumber)
                Using wr As New System.IO.StreamWriter(xmlPath)
                    wr.Write(Me.XML)
                End Using
                _xmlfilename = xmlPath
            Catch ex As Exception
                'do nothing
            End Try
        End If
        Return _xmlfilename.Trim
    End Function

    Private Function ContainsError(ByVal xml As String) As Boolean
        Dim xmldoc As New XmlDocument
        xmldoc.LoadXml(xml)
        Dim ns As New XmlNamespaceManager(xmldoc.NameTable)
        ns.AddNamespace("myns", "https://api.creditly.co/v2")
        Return (Not xmldoc.SelectSingleNode(String.Format("//{0}:product/{0}:error/{0}:code", "myns"), ns) Is Nothing)
    End Function


End Class
