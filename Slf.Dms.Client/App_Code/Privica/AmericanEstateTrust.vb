Imports System
Imports System.Security.Cryptography

Module AmericanEstateTrust

    Function GenerateSignature(ByVal secret As String, ByVal requestPath As String, ByVal current As DateTime, ByVal Optional method As String = "GET", ByVal Optional body As String = Nothing) As AetrustSignature

        Dim currentTimestamp = Math.Floor(
            current.ToUniversalTime().Subtract(New DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalMilliseconds / 1000)

        Dim accountData = If(body IsNot Nothing AndAlso body.Length > 0, body.Replace(" ", ""), "")

        Dim payload = currentTimestamp & method & requestPath & accountData

        Return New AetrustSignature(Convert.ToBase64String(CreateHMACSHA256(payload, secret)), CLng(currentTimestamp))

    End Function

    Function CreateHMACSHA256(ByVal message As String, ByVal secret As String) As Byte()

        Dim encoding = New System.Text.ASCIIEncoding()
        Dim keyByte As Byte() = encoding.GetBytes(secret)
        Dim messageBytes As Byte() = encoding.GetBytes(message)

        Using hmacsha256 = New HMACSHA256(keyByte)
            Return hmacsha256.ComputeHash(messageBytes)
        End Using

    End Function
End Module