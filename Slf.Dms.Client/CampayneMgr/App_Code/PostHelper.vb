Imports System.Data.SqlClient
Imports System.Xml
Imports System.Net
Imports System.IO
Imports System.Text
Imports System.Threading

Public Class PostHelper

    Public Shared Function POST(ByVal LeadID As Integer, ByVal postData As String, ByVal requestUri As String, ByVal throttle As Boolean, ByRef postError As Boolean) As String
        Dim results As String = ""
        Dim rand As New Random

        If throttle Then
            Dim ms As Integer = rand.Next(100, 500) '.1-.5 sec
            System.Threading.Thread.Sleep(ms)
        End If

        Try
            Dim req As HttpWebRequest = WebRequest.Create(requestUri)
            req.Method = "POST"
            'req.Timeout = 10000 '10 sec
            req.ContentType = "application/x-www-form-urlencoded"
            If postData.StartsWith("<?xml") Then
                req.ContentType = "text/xml"
            End If

            req.ContentLength = postData.Length

            Dim encoding As New System.Text.ASCIIEncoding
            Dim data() As Byte = encoding.GetBytes(postData)
            Dim stream As IO.Stream = req.GetRequestStream
            stream.Write(data, 0, data.Length) 'send the data
            stream.Close()

            Dim resp As HttpWebResponse = req.GetResponse
            Dim sr As New StreamReader(resp.GetResponseStream)
            results = sr.ReadToEnd
            sr.Close()
            resp.Close()
            postError = False
        Catch ex As Exception
            LogError("DataMgr.POST", ex.Message, requestUri & "?" & postData, LeadID)
            postError = True
            results = ex.Message
        End Try

        Return results
    End Function

    Public Shared Function _GET(ByVal LeadID As Integer, ByVal postData As String, ByVal requestUri As String, throttle As Boolean, ByRef postError As Boolean) As String
        Dim results As String = ""
        Dim address As String
        Dim q As String = "?"
        Dim rand As New Random

        If throttle Then
            Dim ms As Integer = rand.Next(100, 500) '.1-.5 sec
            System.Threading.Thread.Sleep(ms)
        End If

        If postData.Contains("?") Then
            q = ""
        End If

        address = String.Concat(requestUri, q, postData)

        Try
            Using client As New WebClient
                results = client.DownloadString(address)
            End Using
            postError = False
        Catch ex As Exception
            LogError("PostHelper.GET", ex.Message, address, LeadID)
            postError = True
            results = ex.Message
        End Try

        Return results
    End Function

    Private Shared Sub LogError(ByVal Source As String, ByVal Message As String, ByVal StackTrace As String, Optional ByVal LeadID As Integer = -1)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("Source", Source.Replace("www.", "")))
        params.Add(New SqlParameter("Message", Message))
        params.Add(New SqlParameter("StackTrace", StackTrace))
        params.Add(New SqlParameter("LeadID", LeadID)) 'if error is specific to a lead
        SqlHelper.ExecuteNonQuery("stp_LogError", , params.ToArray)
    End Sub

End Class

