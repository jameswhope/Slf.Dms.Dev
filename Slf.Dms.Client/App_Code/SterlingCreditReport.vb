Imports System.Data
Imports System.IO
Imports System.Net
Imports System.Xml
Imports System.Xml.XmlDocument
Imports Microsoft.VisualBasic

Public Class SterlingCreditReport

    Public Shared Function Index(firstName As String, lastName As String, address As String, city As String, zip As String, state As String, ssn As String, leadApplicantID As Integer) As String
        ServicePointManager.Expect100Continue = True
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12

        Dim TestMode As Boolean = False
        Dim url As String = "https://trustedcreditfile.com//api//v2"

        If TestMode Then
            firstName = "DORENE"
            lastName = "HOPE"
            address = "402 ROCKEFELLER"
            city = "IRVINE"
            zip = "92612"
            state = "CA"
            ssn = "560547416"
            'url = "https://api.creditly.co/v2" 'dev link didn't work
        End If

        Dim name As String = firstName + " " + lastName
        Dim jsonString As String = Nothing
        Dim result As HttpStatusCode = Nothing
        Dim request = HttpWebRequest.Create(url)
        Dim postData = String.Format("apikey=9c72c0371ae4e2b625994a78e282751352c4040eb8d8a9e0f86c76e879ee2d68&name={0}&address={1}&city={2}&zip={3}&state={4}&ssn={5}&ftype=XML", name, address, city, zip, state, ssn)
        Dim data = Encoding.ASCII.GetBytes(postData)
        request.Method = "POST"
        request.ContentType = "application/x-www-form-urlencoded"
        request.ContentLength = data.Length

        Using stream = request.GetRequestStream()
            stream.Write(data, 0, data.Length)
        End Using

        Using response = TryCast(request.GetResponse(), HttpWebResponse)

            If response IsNot Nothing Then
                result = response.StatusCode

                If result = HttpStatusCode.OK Then
                    Dim streamReader As StreamReader = New StreamReader(response.GetResponseStream())
                    jsonString = streamReader.ReadToEnd()
                End If
                saveXML(jsonString, firstName, lastName, leadApplicantID)
                'StoreXMLFile(jsonString.ToString, leadApplicantID, firstName, lastName)
                response.Close()
            End If
            Return jsonString
        End Using
    End Function

    'supposed to store XML in the database. Not working
    Private Shared Sub StoreXMLFile(ByVal xml As String, ByVal leadApplicanID As Integer, ByVal firstName As String, ByVal lastName As String)
        Dim xdoc As XmlDocument = New XmlDocument()
        xdoc.LoadXml(xml)
        Dim cmdText As String = String.Format("INSERT INTO tblCreditorReportXML (leadApplicantID, XMLReport) VALUES ( {0}, (SELECT * FROM OPENROWSET (BULK '{1}', SINGLE_BLOB) AS x))", leadApplicanID, xdoc.InnerXml)
        SqlHelper.ExecuteNonQuery(cmdText, CommandType.Text)
    End Sub

    'saves the XML to a folder on the computer and creates the path if it doesn't exist
    Public Shared Sub saveXML(ByVal xml As String, ByVal firstName As String, ByVal lastName As String, ByVal leadApplicantID As Integer)
        Dim xdoc As XmlDocument = New XmlDocument()
        xdoc.LoadXml(xml)
        If (Not System.IO.Directory.Exists("C:\\xml")) Then
            System.IO.Directory.CreateDirectory("C:\\xml")
        End If
        xdoc.Save(String.Format("C:\\xml\\CreditReport_{0}_{1}_{2}.xml", firstName, lastName, leadApplicantID))
    End Sub
End Class
