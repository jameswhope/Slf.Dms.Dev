Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Net
Imports System.Net.Http
Imports System.Net.Mail
Imports System.Web.Script.Serialization
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports RestSharp

Public Class PrivicaHelper
    Public Shared apiKey = "M76NULlhrIBG88wSJoBGOnhTtL84p49o"
    Public Shared apiSecret = "qbD7nld2z8X1jPwbEERVcf17pFLBCO9u"
    Public Shared myOrigin = "http://example.com"

#Region "User"
    Public Shared Function CreateUser(ByVal debug As Boolean, ByVal email As String, ByVal password As String, ByVal confirmPassword As String, Optional ByVal isTest As Boolean = False, Optional ByVal leadID As String = "")
        Dim aetApiUrl = "https://api.aet.dev/v2/companies/users"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/companies/users"
        End If

        If isTest Then
            email = leadID + email
        End If

        Dim body = "{""data"":{""type"":""users"",""attributes"":{""email"":""" + email + """,""password"":""" + password + """,""confirmPassword"": """ + confirmPassword + """,""sendEmail"": false}}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("POST"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        Return result

    End Function

    Public Shared Sub VerifyUser(ByVal debug As Boolean, ByVal userID As String) 'Dev testing only

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/verify"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/verify"
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("PATCH"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub GetUsers(ByVal debug As Boolean)
        Dim aetApiUrl = "https://api.aet.dev/v2/companies/users"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/companies/users?perPage=26&page=1"
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("GET"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub GetSingleUser(ByVal debug As Boolean, ByVal userID As String)
        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + ""

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + ""
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("GET"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub UpdateUser(ByVal debug As Boolean, ByVal userID As String, ByVal fName As String, ByVal lName As String, Optional ByVal city As String = " ", Optional ByVal state As String = " ", Optional ByVal ssn As String = " ", Optional ByVal DOB As String = " ", Optional ByVal add1 As String = " ", Optional ByVal add2 As String = " ", Optional ByVal zip As String = " ", Optional ByVal isTest As Boolean = False, Optional ByVal leadID As String = "")

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + ""

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + ""
        End If
        If isTest Then
            ssn = "8" & leadID.ToString().Substring(2, 4) & "0000"
        End If

        Dim body = "{""data"":{""type"":""users"",""attributes"":{""firstName"":""" + fName + """,""lastName"":""" + lName + """,""city"":""" + city + """,""state"":""" + state + """,""ssn"":""" + ssn.Replace("-", "") + """,""dateOfBirth"":""" + DOB + """,""address1"":""" + add1 + """,""address2"":""" + add2 + """,""zip"":""" + zip + """}}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("PATCH"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        'If debug Then
        '    System.Console.WriteLine(result)
        '    System.Console.ReadLine()
        'End If
    End Sub
#End Region

#Region "Onboarding"
    Public Shared Function CreateQuestion(ByVal debug As Boolean, ByVal userID As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/questions"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/questions"
        End If


        Dim body = "{""data"":{""type"":""questions""}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("POST"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        Return result
    End Function

    Public Shared Function AnswerQuestions(ByVal debug As Boolean, ByVal userID As String, ByVal answerID1 As String, ByVal answerID2 As String, ByVal answerID3 As String, ByVal answerID4 As String, ByVal answerID5 As String) As Boolean

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/questions"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/questions"
        End If

        Dim body = "{""data"":{""id"":2,""type"":""questions"",""attributes"":{""answers"":[{""question_id"":1,""answer_id"":" + answerID1 + "},{""question_id"":2,""answer_id"":" + answerID2 + "},{""question_id"":3,""answer_id"":" + answerID3 + "},{""question_id"":4,""answer_id"":" + answerID4 + "},{""question_id"":5,""answer_id"":" + answerID5 + "}]}}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("PATCH"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        'Dim content As HttpContent = response.Content
        'Dim result As String = content.ReadAsStringAsync().Result

        If response.StatusCode = 200 Then
            Return True
        Else
            Return False
        End If

    End Function

    Public Shared Function RequestReview(ByVal debug As Boolean, ByVal userID As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/review"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/review"
        End If

        Dim body = "{""data"":{""type"":""users"",""attributes"":{""onboardingStatus"":""Review""}}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("PATCH"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If response.StatusCode = 200 Then
            Return True
        Else
            Return False
        End If
    End Function
#End Region

#Region "AETAccount"
    Public Shared Sub CreateAETAccount(ByVal debug As Boolean, ByVal userID As String)
        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/account"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/account"
        End If

        Dim body = "{""data"":{""type"":""iras"",""attributes"":{""iraType"":""Trust""}}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("POST"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub GetAETAccount(ByVal debug As Boolean, ByVal userID As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/account"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/account"
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("GET"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub GetMultipleTransactions(ByVal debug As Boolean, ByVal userID As String, ByVal accountID As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/accounts/" + accountID + "/ledger"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/accounts/" + accountID + "/ledger"
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("GET"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub GetSingleTransaction(ByVal debug As Boolean, ByVal userID As String, ByVal accountID As String, ByVal ledgerID As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/accounts/" + accountID + "/ledgers/" + ledgerID

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/accounts/" + accountID + "/ledgers/" + ledgerID
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("GET"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub GetAccountSummary(ByVal debug As Boolean, ByVal userID As String, ByVal accountID As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/accounts/" + accountID + "/summary"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/accounts/" + accountID + "/summary"
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("GET"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub MakeDeposit(ByVal debug As Boolean, ByVal userID As String, ByVal accountID As String, ByVal amount As String, ByVal depositType As String, ByVal bank As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/accounts/" + accountID + "/deposit"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/accounts/" + accountID + "/deposit"
        End If


        Dim body = "{""data"":{""type"":""banks"",""attributes"":{""bank"":""" + bank + """,""amount"":""" + amount + """,""type"":""" + depositType + """}}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("POST"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub WithdrawDeposit(ByVal debug As Boolean, ByVal userID As String, ByVal accountID As String, ByVal amount As String, ByVal depositType As String, ByVal bank As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/accounts/" + accountID + "/withdrawal"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/accounts/" + accountID + "/withdrawal"
        End If


        Dim body = "{""data"":{""type"":""banks"",""attributes"":{""bank"":""" + bank + """,""amount"":""" + amount + """,""type"":""" + depositType + """}}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("POST"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub InterAccountTransfer(ByVal debug As Boolean, ByVal userID As String, ByVal accID As String, ByVal account As String, ByVal amt As String, ByVal type As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/accounts/" + accID + "/transfer"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/accounts/" + accID + "/transfer"
        End If


        Dim body = "{""data"":{""type"":""transfers"",""attributes"":{""account"":" + account + ",""amount"":""" + amt + """,""type"":""" + type + """}}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("POST"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub
#End Region

#Region "BankAccount"
    Public Shared Sub CreateBankAccount(ByVal debug As Boolean, ByVal userID As String, ByVal accName As String, ByVal accNum As String, ByVal accType As String, ByVal routingNum As String, ByVal institution As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/banks"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/banks"
        End If

        Dim body = "{""data"":{""type"":""bankAccounts"",""attributes"":{""accountName"":""" + accName + """,""accountNumber"":""" + accNum + """,""accountType"":""" + accType + """,""routingNumber"":""" + routingNum + """,""institution"":""" + institution + """}}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("POST"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub VerifyBankAccount(ByVal debug As Boolean, ByVal userID As String, ByVal bankID As String, ByVal firstAmt As String, ByVal secondAmt As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/banks/" + bankID + "/verify"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/banks/" + bankID + "/verify"
        End If

        Dim body = "{""data"":{""type"":""banks"",""attributes"":{""amount"":{""first"":" + firstAmt + ",""second"":" + secondAmt + "}}}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("POST"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub GetBankAccounts(ByVal debug As Boolean, ByVal userID As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/banks"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/banks"
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("GET"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub GetSingleBankAccount(ByVal debug As Boolean, ByVal userID As String, ByVal bankID As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/banks/" + bankID + ""

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/banks/" + bankID + ""
        End If

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("GET"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub RemoveBankAccount(ByVal debug As Boolean, ByVal userID As String, ByVal bankID As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/users/" + userID + "/banks/" + bankID + ""

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/users/" + userID + "/banks/" + bankID + ""
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("DELETE"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub
#End Region

#Region "Company"
    Public Shared Sub GetAccounts(ByVal debug As Boolean)
        Dim aetApiUrl = "https://api.aet.dev/v2/companies/accounts"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/companies/accounts"
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("GET"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub GetAccountSummary(ByVal debug As Boolean, ByVal accountID As String)
        Dim aetApiUrl = "https://api.aet.dev/v2/companies/accounts/" + accountID + "/summary"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/companies/accounts/" + accountID + "/summary"
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("GET"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub CreateVendor(ByVal debug As Boolean, ByVal accountID As String, ByVal name As String, ByVal bankName As String, ByVal accountName As String, Optional ByVal type As String = "", Optional ByVal achRoutingNumber As String = "", Optional ByVal wireRoutingNumber As String = "", Optional ByVal city As String = "", Optional ByVal state As String = "", Optional ByVal zip As String = "", Optional ByVal address As String = "")
        Dim aetApiUrl = "https://api.aet.dev/v2/companies/accounts/" + accountID + "/vendors"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/companies/accounts/" + accountID + "/vendors"
        End If

        Dim body = ""

        If type.ToLower = "check" Then
            body = "{""data"":{""type"":""vendors"",""attributes"":{""type"":""Check"",""name"":""" + name + """,""bankName"":""" + bankName + """,""accountName"":""" + accountName + """,""city"":""" + city + """,""state"":""" + state + """,""zip"":""" + zip + """,""address"":""" + address + """}}}"
        ElseIf type.ToLower = "ach" Then
            body = "{""data"":{""type"":""vendors"",""attributes"":{""type"":""ACH"",""name"":""" + name + """,""bankName"":""" + bankName + """,""accountName"":""" + accountName + """,""achRoutingNumber"":""" + achRoutingNumber + """,""wireRoutingNumber"":""" + wireRoutingNumber + """}}}"
        ElseIf type.ToLower = "wire" Then
            body = "{""data"":{""type"":""vendors"",""attributes"":{""type"":""Wire"",""name"":""" + name + """,""bankName"":""" + bankName + """,""accountName"":""" + accountName + """,""achRoutingNumber"":""" + achRoutingNumber + """,""wireRoutingNumber"":""" + wireRoutingNumber + """}}}"
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("POST"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result


        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub GetCompanyDetails(ByVal debug As Boolean, ByVal companyID As String)
        Dim aetApiUrl = "https://api.aet.dev/v2/companies/" + companyID + ""

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/companies/" + companyID + ""
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("GET"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub GetVendor(ByVal debug As Boolean, ByVal vendorID As String)
        Dim aetApiUrl = "https://api.aet.dev/v2/vendors/" + vendorID + ""

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/vendors/" + vendorID + ""
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("GET"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub GetVendors(ByVal debug As Boolean, ByVal accountID As String)
        Dim aetApiUrl = "https://api.aet.dev/v2/companies/accounts/" + accountID + "/vendors?perPage=20&page=1"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/companies/accounts/" + accountID + "/vendors?perPage=20&page=1"
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("GET"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub PayVendor(ByVal debug As Boolean, ByVal vendorID As String, ByVal type As String, ByVal amount As String)
        Dim aetApiUrl = "https://api.aet.dev/v2/vendors/" + vendorID + "/send"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/vendors/" + vendorID + "/send"
        End If

        Dim body = "{""data"":{""type"":""vendors"",""attributes"":{""type"":""" + type + """,""amount"":" + amount + "}}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("POST"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result


        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub DeleteVendor(ByVal debug As Boolean, ByVal vendorID As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/vendors/" + vendorID + ""

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/vendors/" + vendorID + ""
        End If


        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("DELETE"))
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub UpdateVendorName(ByVal debug As Boolean, ByVal vendorID As String, ByVal name As String)

        Dim aetApiUrl = "https://api.aet.dev/v2/vendors/" + vendorID + ""

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/vendors/" + vendorID + ""
        End If

        Dim body = "{""data"":{""type"":""vendors"",""attributes"":{""name"":""" + name + """}}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("PATCH"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result

        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub

    Public Shared Sub CreateCompanyAccount(ByVal debug As Boolean)
        Dim aetApiUrl = "https://api.aet.dev/v2/companies/accounts"

        If debug Then
            aetApiUrl = "https://sandbox.aet.dev/v2/companies/accounts"
        End If

        Dim body = "{""data"":{""type"":""account"",""attributes"":{""type"":""Trust""}}}"

        Dim client = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request = client.CreateRequest(aetApiUrl, New HttpMethod("POST"), body)
        Dim bodyToSend = request.Content.ReadAsStringAsync().Result
        Dim response = client.SendRequestAsync(request).Result

        Dim content As HttpContent = response.Content
        Dim result As String = content.ReadAsStringAsync().Result


        If debug Then
            System.Console.WriteLine(result)
            System.Console.ReadLine()
        End If
    End Sub
#End Region

#Region "Documents"
    Public Shared Function UploadDocument(ByVal userID As String, ByVal filePath As String, ByVal filename As String, ByVal description As String, ByVal docType As String) As Boolean
        Dim aetApiUrl As String = "https://sandbox.aet.dev/v2/users/" + userID + "/documents"


        Dim client As RestClient = New RestClient("https://sandbox.aet.dev/v2/users/" + userID + "/documents")
        Dim aet As AetrustHttpClient = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request As RestRequest = aet.CreateRestRequest(aetApiUrl, New HttpMethod("POST"), filePath, filename, description, docType)
        Dim response As IRestResponse = client.Execute(request)

        Dim jsonFlaggedResult As String = response.Content

        Try
            Dim obj As JObject = JObject.Parse(jsonFlaggedResult)

            Dim exists As Integer = CInt(obj.SelectToken("data").SelectToken("id").ToString)

            If exists > 0 Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Return False
        End Try
    End Function

    'Users can upload documents associated with their accounts for AML/KYC
    Public Shared Function UploadBankDocument(ByVal userID As String, ByVal accID As String, ByVal filePath As String, ByVal filename As String, ByVal description As String, ByVal docType As String) As String
        Dim aetApiUrl As String = "https://sandbox.aet.dev/v2/users/" + userID + "/accounts/" + accID + "/documents"


        Dim client As RestClient = New RestClient("https://sandbox.aet.dev/v2/users/" + userID + "/accounts/" + accID + "/documents")
        Dim aet As AetrustHttpClient = New AetrustHttpClient(New HttpClient(), apiSecret, apiKey, myOrigin)
        Dim request As RestRequest = aet.CreateRestRequest(aetApiUrl, New HttpMethod("POST"), filePath, filename, description, docType)
        Dim response As IRestResponse = client.Execute(request)

        'Dim jsonFlaggedResult As String = "ubd- " & response.Content
        'System.Console.WriteLine(jsonFlaggedResult)
        'Return responseCode(response.StatusCode, jsonFlaggedResult)
        Dim jsonFlaggedResult As String = response.Content

        Try
            Dim obj As JObject = JObject.Parse(jsonFlaggedResult)

            Dim exists As Integer = CInt(obj.SelectToken("data").SelectToken("id").ToString)

            If exists > 0 Then
                Return True
            Else
                Return False
            End If
        Catch ex As Exception
            Return False
        End Try
    End Function
#End Region


#Region "PrivicaPosting"
    Public Shared Function PostToPrivica(ByVal email As String, ByVal processorID As String, ByVal processorBankAccountID As String, ByVal password As String) As String

        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls Or SecurityProtocolType.Tls11 Or SecurityProtocolType.Tls12

        Dim client = New RestClient("https://privica.com/public/post.ashx?email=" & email & "&custodianId=" & processorID & "&custodianBankId=" & processorBankAccountID & "&username=" & email & "&password=" & password & "")
        client.Timeout = -1
        Dim request = New RestRequest(Method.POST)
        request.AddHeader("Cookie", "ARRAffinity=4b807d9a748b80f4d6f5d7d60f140eb240a610cb121e4138d97300cb56c732ea")
        Dim response As IRestResponse = client.Execute(request)
        Console.WriteLine(response.Content)


        Dim privID As String
        Dim isNotValid As Boolean = response.Content.Contains("Duplicate")
        If Not isNotValid Then
            privID = response.Content
        Else
            privID = String.Empty
        End If

        Return privID
    End Function

    Public Shared Sub PostToPrivicaUpdate(ByVal PrivUserID As String, ByVal firstName As String, ByVal lastName As String, ByVal phone As String, ByVal address As String, ByVal city As String, ByVal state As String, ByVal zip As String, ByVal dob As String, ByVal ssn As String)

        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls Or SecurityProtocolType.Tls11 Or SecurityProtocolType.Tls12

        Dim client = New RestClient("https://privica.com/public/post2.ashx?privicaid=" & PrivUserID & "&first=" & firstName & "&last=" & lastName & "&Phone=" & phone & "&address1=" & address & "&city=" & city & "&state=" & state & "&zip=" & zip & "&dob=" & dob & "&ssn=" & ssn)
        client.Timeout = -1
        Dim request = New RestRequest(Method.POST)
        Dim response As IRestResponse = client.Execute(request)
        Console.WriteLine(response.Content)

    End Sub

#End Region


    Public Shared Sub EmailClientPrivicaAccountInfo(ByVal aid As Integer, ByVal bSpanish As Boolean)
        Dim email As String
        Dim firstName As String
        Dim lastName As String
        Dim body As New StringBuilder
        Dim subject As String

        'get server url for links
        Dim svrPath As String = String.Format("{0}", HttpContext.Current.Request.ServerVariables("SERVER_NAME"))
        Dim svrPort As String = String.Format("{0}", HttpContext.Current.Request.ServerVariables("SERVER_PORT"))
        Dim strHTTP As String = "https"
        Dim sSvr As String = ""
        If svrPort.ToString <> "" Then
            svrPath += ":" & svrPort
            If svrPort.ToString = "8181" Then
                svrPath += "/QA/"
            End If
        Else
            strHTTP += "s"
        End If
        If svrPath.Contains("localhost") Then
            svrPath += "/Slf.Dms.Client"
        End If

        svrPath = svrPath.Replace("web1", "service.lexxiom.com")
        svrPath = "lexxware.com"

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("LeadApplicantId", aid))
        Dim dt As DataTable = SqlHelper.GetDataTable("stp_GetLeadInfoForPrivica", CommandType.StoredProcedure, params.ToArray)

        'fill info based on LeadApplicantID
        email = dt.Rows(0)("email")
        firstName = dt.Rows(0)("firstname")
        lastName = dt.Rows(0)("lastname")

        Select Case bSpanish
            Case True
                subject = "Bienvenido a Privica"

                body.Append("<br/><br/>")
                body.Append("<table style='width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2' cellpadding='8' cellspacing='0'>")
                body.Append("<tr><td><h2>Su cuenta Privica ha sido creada y está pendiente de aprobación, por ahora, aquí están sus credenciales de inicio de sesión.</h2></td></tr>")
                body.AppendFormat("<tr><td><img src='{0}://{1}/public/images/24x24_pen.gif' align='absmiddle' /><a style='color: #1E90FF' href='{2}' target='_blank'>El sitio web se encuentra en: <a href=""https://privica.azurewebsites.net/login.aspx?bankverf=y"">https://privica.azurewebsites.net</a></td></tr>", strHTTP, svrPath, "https://privica.azurewebsites.net/login.aspx?bankverf=y")
                body.Append("<tr><td>Nombre de usuario: " + email + "<br/>Contraseña: Primera letra de su nombre (en mayúscula) + " & aid & " + últimos cuatro dígitos de su número de seguro social + primera letra de su apellido (en minúsculas) </td></tr>")
                body.AppendFormat("<tr><td style='font-size: 11px'><br/><br/> <br/><br/> </td></tr>")
                body.AppendFormat("<tr><td style='background-color: #2dbe60; padding-top:10px' align='left'><img src='{0}://{1}/public/images/Privica_Email_Logo.png' /></td></tr>", strHTTP, svrPath)

            Case Else
                subject = "Welcome to Privica"

                body.Append("<br/><br/>")
                body.Append("<table style='width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2' cellpadding='8' cellspacing='0'>")
                body.Append("<tr><td><h2>Your Privica account has been created and is awaiting approval, for now, here is your login credentials.</h2></td></tr>")
                body.AppendFormat("<tr><td><img src='{0}://{1}/public/images/24x24_pen.gif' align='absmiddle' /><a style='color: #1E90FF' href='{2}' target='_blank'>The website is located at: <a href=""https://privica.azurewebsites.net/login.aspx?bankverf=y"">https://privica.azurewebsites.net</a></td></tr>", strHTTP, svrPath, "https://privica.azurewebsites.net/login.aspx?bankverf=y")
                body.Append("<tr><td>Username: " + email + "<br/>Password: First letter of your first name (Capitalized) + " & aid & " + last four digits of your social security number + first letter of your last name (lower case) </td></tr>")
                body.AppendFormat("<tr><td style='font-size: 11px'><br/><br/> <br/><br/> </td></tr>")
                body.AppendFormat("<tr><td style='background-color: #2dbe60; padding-top:10px' align='left'><img src='{0}://{1}/public/images/Privica_Email_Logo.png' /></td></tr>", strHTTP, svrPath)
        End Select

        SendEmailMessage(ConfigurationManager.AppSettings("gmailMailServer"), "info@lexxiom.com", ConfigurationManager.AppSettings("gmailPassword"), "info@lawfirmcs.com", email, subject, body)
    End Sub



    Private Shared Sub SendEmailMessage(ByVal mailserver As String, ByVal userName As String, ByVal passWord As String, ByVal fromAddress As String, ByVal toAddress As String, ByVal subject As String, ByVal bodyEmail As StringBuilder)
        Dim client As SmtpClient = New SmtpClient(mailserver, 587)
        Dim message As MailMessage = New MailMessage(fromAddress, toAddress)
        message.Subject = subject
        message.Body = bodyEmail.ToString
        message.IsBodyHtml = True

        Try

            If message.[To].Count > 0 Then
                Dim nc As NetworkCredential = New NetworkCredential(userName, passWord)
                client.UseDefaultCredentials = False
                client.Credentials = nc
                client.DeliveryMethod = SmtpDeliveryMethod.Network
                client.EnableSsl = True
                client.Send(message)
            End If

        Catch ex As SystemException
            Console.WriteLine(ex)
        End Try
    End Sub
End Class
