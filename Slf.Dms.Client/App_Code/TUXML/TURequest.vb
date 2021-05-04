Imports System.Xml
Imports System.Xml.Serialization
Imports System.Net
Imports System.Security.Cryptography.X509Certificates
Imports System.IO

Public Class TURequest

    Public Enum ProcessingEnvs
        production = 0
        standardTest
    End Enum

    Private _version As String = "2.8"
    Private _industrycode As String
    Private _subscriberCode As String
    Private _subscriberPrefix As String
    Private _subscriberMember As String
    Private _creditReportId As String
    Private _subscriberPassword As String
    Private _serviceUrl As String
    Private _productCode As String
    Private _testMode As Boolean
    Private _person As TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicative
    Private _inquiry As TUXML.Inquiry.creditBureau
    Private _X509CertSubjectName As String = "LAWOFFI4"
    Private _AccountName As String

    Private Sub New(ByVal CreditReportId As String)
        _creditReportId = CreditReportId
    End Sub

    Public ReadOnly Property Version() As String
        Get
            Return _version
        End Get
    End Property

    Public Property CreditReportId() As String
        Get
            Return _creditReportId
        End Get
        Set(ByVal value As String)
            _creditReportId = value
        End Set
    End Property

    Public Property SubscriberPassword() As String
        Get
            Return _subscriberPassword
        End Get
        Set(ByVal value As String)
            _subscriberPassword = value
        End Set
    End Property

    Public Property ServiceUrl() As String
        Get
            Return _serviceUrl
        End Get
        Set(ByVal value As String)
            _serviceUrl = value
        End Set
    End Property

    Public Property ProductCode() As String
        Get
            Return _productCode
        End Get
        Set(ByVal value As String)
            _productCode = value
        End Set
    End Property

    Public Property TestMode() As Boolean
        Get
            Return _testMode
        End Get
        Set(ByVal value As Boolean)
            _testMode = value
        End Set
    End Property

    Public Property Person() As TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicative
        Get
            Return _person
        End Get
        Set(ByVal value As TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicative)
            _person = value
        End Set
    End Property

    Public ReadOnly Property SubscriberPrefix() As String
        Get
            Return _subscriberPrefix
        End Get
    End Property

    Public ReadOnly Property IndustryCode() As String
        Get
            Return _industrycode
        End Get
    End Property

    Public ReadOnly Property SubscriberMember() As String
        Get
            Return _subscriberMember
        End Get
    End Property

    Public Property SubscriberCode() As String
        Get
            Return _subscriberCode
        End Get
        Set(ByVal value As String)
            _subscriberCode = value.Replace(" ", "")
            _subscriberPrefix = SubscriberCode.Substring(0, 4)
            _industrycode = SubscriberCode.Substring(4, 1)
            _subscriberMember = "0" & SubscriberCode.Substring(5)
        End Set
    End Property

    Public ReadOnly Property ProcessingEnvironment() As String
        Get
            If _testMode Then
                Return [Enum].GetName(GetType(ProcessingEnvs), ProcessingEnvs.standardTest)
            Else
                Return [Enum].GetName(GetType(ProcessingEnvs), ProcessingEnvs.production)
            End If
        End Get
    End Property

    Public Property X509CertSubjectName() As String
        Get
            Return _X509CertSubjectName
        End Get
        Set(ByVal value As String)
            _X509CertSubjectName = value
        End Set
    End Property

    Public Property AccountName() As String
        Get
            Return _AccountName
        End Get
        Set(ByVal value As String)
            _AccountName = value
        End Set
    End Property

    Public Sub CreateInquiry()
        _inquiry = New TUXML.Inquiry.creditBureau
        With _inquiry
            .document = "request"
            .version = 2.8

            .transactionControl = New TUXML.Inquiry.creditBureauTransactionControl
            With .transactionControl
                .userRefNumber = Me.CreditReportId

                .subscriber = New TUXML.Inquiry.creditBureauTransactionControlSubscriber
                With .subscriber
                    .industryCode = Me.IndustryCode
                    .memberCode = Me.SubscriberMember
                    .inquirySubscriberPrefixCode = Me.SubscriberPrefix
                    .password = Me.SubscriberPassword
                End With

                .options = New TUXML.Inquiry.creditBureauTransactionControlOptions
                With .options
                    .processingEnvironment = Me.ProcessingEnvironment
                    .country = "us"
                    .language = "en"
                    .contractualRelationship = "individual"
                    .pointOfSaleIndicator = "none"
                End With
            End With

            .product = New TUXML.Inquiry.creditBureauProduct
            With .product
                .code = Me.ProductCode

                .subject = New TUXML.Inquiry.creditBureauProductSubject
                With .subject
                    .number = 1

                    .subjectRecord = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecord
                    With .subjectRecord

                        .indicative = Me.Person

                        '.addOnProduct = New TUXML.Inquiry.creditBureauProductSubjectSubjectRecordAddOnProduct
                        'With .addOnProduct
                        '.code = "00P02"
                        '.scoreModelProduct = True
                        'End With
                    End With
                End With

                .responseInstructions = New TUXML.Inquiry.creditBureauProductResponseInstructions
                With .responseInstructions
                    .returnErrorText = True
                    .document = String.Empty
                End With

                .permissiblePurpose = New TUXML.Inquiry.creditBureauProductPermissiblePurpose
                With .permissiblePurpose
                    .code = "CI"
                    .inquiryECOADesignator = "individual"
                End With

            End With

        End With
    End Sub

    Public Overrides Function ToString() As String
        Dim ser As New XmlSerializer(GetType(TUXML.Inquiry.creditBureau))
        Using sw As New System.IO.StringWriter()
            sw.NewLine = ""
            Using xw As XmlWriter = XmlWriter.Create(sw, New XmlWriterSettings With {.Indent = False}) 'New System.IO.StreamWriter("C:/users/opereira/documents/TUXML/mysample.xml")
                ser.Serialize(xw, _inquiry)
                Return sw.ToString
            End Using
        End Using
    End Function

    Public Function Send() As TUResponse
        Dim resp As TUResponse = Nothing

        Try
            Dim xml As String = Me.ToString
            Dim request As HttpWebRequest

            request = WebRequest.Create(New Uri(Me.ServiceUrl))
            request.Method = "POST"
            request.ContentType = "text/xml"
            'request.Accept = "text/xml"
            request.KeepAlive = False

            ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3

            Dim bytes As Byte() = System.Text.Encoding.UTF8.GetBytes(xml)

            Using rqs As System.IO.Stream = request.GetRequestStream()
                rqs.Write(bytes, 0, bytes.Length)
            End Using

            Dim cert As X509Certificate2 = GetCertificate()

            request.ClientCertificates.Add(cert)

            'ByPass SSL Certificate Validation Checking
            System.Net.ServicePointManager.ServerCertificateValidationCallback = New Security.RemoteCertificateValidationCallback(AddressOf customCertificateValidation)
            'Function(se As Object, ct As X509Certificate, chain As System.Security.Cryptography.X509Certificates.X509Chain, sslerror As System.Net.Security.SslPolicyErrors) True

            Dim srvResponse As HttpWebResponse = request.GetResponse()

            If srvResponse.StatusCode = HttpStatusCode.OK Then
                Using rps As New StreamReader(srvResponse.GetResponseStream())
                    resp = New TUResponse(rps.ReadToEnd)
                End Using
            Else
                Throw New Exception(String.Format("Request has failed. Status code is {0}", srvResponse.StatusCode))
            End If

        Catch wex As WebException
            resp = New TUResponse(wex)
        Catch ex As Exception
            resp = New TUResponse(ex)
        Finally
            System.Net.ServicePointManager.ServerCertificateValidationCallback = Nothing
        End Try

        Return resp

    End Function

    Private Function GetCertificate() As X509Certificate2
        Dim location As StoreLocation = StoreLocation.CurrentUser
        Dim name As StoreName = StoreName.My
        Dim cert As X509Certificate2 = Nothing
        Dim store As X509Store = New X509Store(name, location)
        Try
            store.Open(OpenFlags.ReadOnly)
            Dim certs As X509CertificateCollection = store.Certificates.Find(X509FindType.FindBySubjectName, _X509CertSubjectName, True)
            If certs.Count > 0 Then
                cert = certs(0)
            Else
                Throw New Exception("Security certificate not found")
            End If
        Finally
            store.Close()
        End Try
        Return cert
    End Function

    Private Shared Function customCertificateValidation(ByVal sender As Object, ByVal cert As X509Certificate, ByVal chain As X509Chain, ByVal sslPolicyErrors As Security.SslPolicyErrors) As Boolean
        Return True
    End Function

    Public Shared Function CreateRequest(ByVal CreditReportID As String, ByVal IsTest As Boolean, ByVal person As TUXML.Inquiry.creditBureauProductSubjectSubjectRecordIndicative) As TURequest
        Dim dt As System.Data.DataTable = CredStarHelper2.GetSettings(IsTest)

        If dt.Rows.Count = 0 Then Throw New Exception("Transunion configuration settings not found")

        Dim dr As System.Data.DataRow = dt.Rows(0)

        Dim r As New TURequest(CreditReportID) With { _
        .ProductCode = "07000" _
        , .SubscriberCode = dr("SubscriberCode").ToString _
        , .SubscriberPassword = dr("SubscriberPassword").ToString _
        , .ServiceUrl = dr("ServiceUrl").ToString _
        , .TestMode = IsTest _
        , .X509CertSubjectName = dr("Certificate").ToString _
        , .AccountName = dr("AccountName").ToString _
        , .Person = person}

        r.CreateInquiry()

        Return r
    End Function

End Class
