Imports Microsoft.VisualBasic
Imports System.Collections.Generic
Imports System.Text
Imports System.Net
Imports System
Imports System.IO
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports System.Data.SqlClient
Imports System.Data

Public Class SalesVerification

#Region "Variables"

    Const LoginId As String = "Lexxiom!"
    Const LoginPwd As String = "53C972@"
    Const RequestUri As String = "https://veleroservices.salesverifications.com/Lead.svc/lead"
    Public leadapplicantid As Integer = 0
    Public Response As String = ""
    Public DictSize As Integer = 0

#End Region

#Region "Properties"

#End Region

#Region "Methods"

    Public Sub InsertLead(ByVal lead As Integer)

        leadapplicantid = lead
        Response += PostData()
        StoreResponse()
        ProcessAndSaveDetails()

    End Sub

    Public Function BuildDictionary() As Dictionary(Of String, String)

        Dim dict As New Dictionary(Of String, String)
        Dim params As New List(Of SqlParameter)

        params.Add(New SqlParameter("leadapplicantid", leadapplicantid))

        Dim dt As DataTable = SqlHelper.GetDataTable("stp_GetLeadInfoFor3PVServicer", Data.CommandType.StoredProcedure, params.ToArray)

        If dt.Rows.Count > 0 Then
            Dim processingpattern As String = dt.Rows(0)("processingpattern").ToString()
            Dim pattern As String() = processingpattern.Split("|")

            dict.Add("CompanyName", dt.Rows(0)("lawfirm"))
            dict.Add("AccountHolderSalutation", "customer")
            dict.Add("AccountHolderFirstName", dt.Rows(0)("firstname"))
            dict.Add("AccountHolderLastName", dt.Rows(0)("lastname"))
            dict.Add("CIDName", dt.Rows(0)("bankname"))
            dict.Add("AccountNumber", dt.Rows(0)("bankacct"))
            dict.Add("SwitchType", dt.Rows(0)("state"))
            dict.Add("Rate", dt.Rows(0)("fixedfee"))
            dict.Add("SecurityAnswer2", pattern(0).ToString())
            dict.Add("SecurityQuestion", pattern(1).ToString())
            dict.Add("SecurityQuestion2", pattern(2).ToString())
            dict.Add("SecondPrice", pattern(3).ToString())
            dict.Add("SecurityAnswer", dt.Rows(0)("ssn"))
            dict.Add("ExternalConfirmationNumber ", dt.Rows(0)("leadid"))
            dict.Add("AltPhone", dt.Rows(0)("repdirectphone"))
            DictSize = 15
        End If

        Return dict

    End Function

    Public Function BuildJSONBlock(ByVal dict As Dictionary(Of String, String)) As String

        Dim strBuilder As String = ""
        strBuilder += "["

        For Each kvp As KeyValuePair(Of String, String) In dict
            If DictSize = 1 Then
                strBuilder += "{""FieldCode"":""" + kvp.Key + ""","
                strBuilder += """FieldValue"":""" + kvp.Value + """}]"
            Else
                strBuilder += "{""FieldCode"":""" + kvp.Key + ""","
                strBuilder += """FieldValue"":""" + kvp.Value + """},"
            End If

            DictSize -= 1

        Next

        Return strBuilder

    End Function

    Public Function PostData() As String

        Dim dict As New Dictionary(Of String, String)
        dict = BuildDictionary()

        Dim postingData As New StringBuilder
        postingData.Append(BuildJSONBlock(dict))

        Dim data As Byte()
        data = Encoding.UTF8.GetBytes(postingData.ToString())

        Dim uri As New Uri(RequestUri)

        Dim result_post As String
        result_post = SendRequest(uri, data, "application/json", "POST")

        Return result_post

    End Function

    Public Sub ProcessAndSaveDetails()

        Dim numbers As String() = Response.Split("\")

        If numbers.Length > 2 Then

            Dim identfication As String = numbers(2).Substring(1, 6)

            If IsNumeric(identfication) Then

                Dim params As New List(Of SqlParameter)

                params.Add(New SqlParameter("leadapplicantid", leadapplicantid))
                params.Add(New SqlParameter("postid", identfication))

                SqlHelper.ExecuteNonQuery("stp_update3PVPostId", Data.CommandType.StoredProcedure, params.ToArray)

            End If

        End If

    End Sub

    Public Function SendRequest(uri As Uri, jsonDataBytes As Byte(), contentType As String, method As String) As String
        Dim req As WebRequest = WebRequest.Create(uri)
        req.ContentType = contentType
        req.Method = method
        req.ContentLength = jsonDataBytes.Length

        Dim _auth, _enc, _cred As String
        _auth = String.Format("{0}:{1}", LoginId, LoginPwd)
        _enc = Convert.ToBase64String(Encoding.ASCII.GetBytes(_auth))
        _cred = String.Format("{0} {1}", "Basic", _enc)
        req.Headers(HttpRequestHeader.Authorization) = _cred

        Dim stream As Stream
        stream = req.GetRequestStream()
        stream.Write(jsonDataBytes, 0, jsonDataBytes.Length)
        stream.Close()

        Dim response As Stream
        response = req.GetResponse().GetResponseStream()

        Dim reader As New StreamReader(response)
        Dim res As String
        res = reader.ReadToEnd()
        reader.Close()
        response.Close()

        Return res
    End Function

    Public Sub StoreResponse()

        Dim params As New List(Of SqlParameter)

        params.Add(New SqlParameter("leadapplicantid", leadapplicantid))
        params.Add(New SqlParameter("response", Response))

        SqlHelper.ExecuteNonQuery("stp_Input3PVPostResponse", Data.CommandType.StoredProcedure, params.ToArray)

    End Sub

#End Region

End Class
