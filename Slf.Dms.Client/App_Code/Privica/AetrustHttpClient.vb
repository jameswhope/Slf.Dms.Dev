Imports System.Net.Http
Imports System.Text
Imports System
Imports System.Threading.Tasks
Imports RestSharp

Public Class AetrustHttpClient
    Private ReadOnly _client As HttpClient
    Private ReadOnly _secret As String
    Private ReadOnly _apiKey As String
    Private ReadOnly _origin As String

    Public Sub New(ByVal client As HttpClient, ByVal secret As String, ByVal apiKey As String, ByVal origin As String)
        _client = client
        _secret = secret
        _apiKey = apiKey
        _origin = origin
    End Sub

    Public Overridable Function CreateRequest(ByVal url As String, ByVal method As HttpMethod, ByVal Optional body As String = Nothing, ByVal Optional serverCurrent As DateTime? = Nothing) As HttpRequestMessage

        Dim message As HttpRequestMessage = New HttpRequestMessage With {
            .RequestUri = New System.Uri(url),
            .Method = method
        }

        Dim methodAsString As String = method.Method.ToUpper()
        Dim signature As AetrustSignature = AmericanEstateTrust.GenerateSignature(_secret, message.RequestUri.AbsolutePath, If(serverCurrent, DateTime.UtcNow), methodAsString, body)

        message.Headers.Add("Signature", signature.Signature)
        'message.Headers.TryAddWithoutValidation("Content-Type", "application/vnd.api+json")
        message.Headers.Add("Timestamp", signature.Timestamp.ToString())
        message.Headers.Add("ApiKey", _apiKey)
        message.Headers.Add("Origin", _origin)

        If (body IsNot Nothing) Then
            message.Content = New StringContent(body, Encoding.UTF8) ', "application/vnd.api+json"
        End If

        Return message

    End Function

    Public Overridable Function CreateRestRequest(ByVal url As String, ByVal method As HttpMethod, ByVal filePath As String, ByVal fileName As String, ByVal description As String, ByVal docType As String) As RestRequest

        Dim message As HttpRequestMessage = New HttpRequestMessage With {
            .RequestUri = New System.Uri(url),
            .Method = method
        }

        Dim methodAsString As String = method.Method.ToUpper()
        Dim signature As AetrustSignature = AmericanEstateTrust.GenerateSignature(_secret, message.RequestUri.AbsolutePath, DateTime.UtcNow, methodAsString)

        Dim request As New RestRequest
        request.Method = RestSharp.Method.POST
        request.AddHeader("Origin", _origin)
        request.AddHeader("Content-Type", "multipart/form-data")
        request.AddHeader("Signature", signature.Signature)
        request.AddHeader("ApiKey", _apiKey)
        request.AddHeader("Timestamp", signature.Timestamp.ToString())
        request.AddFile("file", filePath)
        request.AddParameter("name", fileName)
        request.AddParameter("description", description)
        request.AddParameter("docType", docType)
        'Dim response As IRestResponse = client.Execute(request)
        'Console.WriteLine(response.Content)


        Return request

    End Function

    Public Overridable Async Function SendRequestAsync(ByVal message As HttpRequestMessage) As Task(Of HttpResponseMessage)
        Return Await _client.SendAsync(message)
    End Function

End Class