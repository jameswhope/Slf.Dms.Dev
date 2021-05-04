Imports System.IO
Imports System.Net
Imports System.Text
Imports TelAPI

Module Driver

    Sub Main()
        'Global Variables
        Dim AccountSID As String = "AC6c889084219baafd25274e3587efe0e7"
        Dim AuthToken As String = "bf6788e8a4cf460ab6e0dcfa70f5608f"
        Dim FromPhone As String = "(909) 532-5057"
        Dim ToPhone As String = "(951) 333-2766"
        Dim Message As String = "This is The Iniguez Law Firm, P.C. We have reached a Settlement on one of your accounts. Please contact us at 800-555-1212 to finalize."
        Dim client As TelAPIRestClient
        Dim SMS As TelAPI.SmsMessage

        'Logging Destination Of File
        If Not Directory.Exists(String.Format("{0}\logs", My.Application.Info.DirectoryPath)) Then
            Directory.CreateDirectory(String.Format("{0}\logs", My.Application.Info.DirectoryPath))
        End If

        'Location of Log File
        Dim logPath As String = String.Format("{0}\logs\SMSTester_Log_{1}.log", My.Application.Info.DirectoryPath, Format(Now, "yyyyMMddhhmm"))

        'Instance of Streamwriter
        Using sw As New StreamWriter(logPath, False)

            'Logging Start Of Application
            sw.WriteLine(String.Format("[{0}]Starting Testing Of SMSMessage!", Now))
            sw.WriteLine(String.Format("[{0}]", Now))

            Console.WriteLine(String.Format("[{0}]Starting Testing Of SMSMessage!", Now))
            Console.WriteLine(String.Format("[{0}]", Now))

            'Using API
            client = New TelAPIRestClient(AccountSID, AuthToken)

            Try
                SMS = client.SendSmsMessage(FromPhone, ToPhone, Message)
                Console.WriteLine("[{0}]SMS_SID ...{1}", Now, SMS.Sid)
            Catch ex As Exception
                sw.WriteLine("[{0}]Error:Terminating Testing Of SMSMessage! ...{1}", Now, ex.Message)
                Console.WriteLine("[{0}]Error:Terminating Testing Of SMSMessage! ...{1}", Now, ex.Message)
            End Try

            'Logging Statement
            sw.WriteLine("[{0}]Terminating Testing Of SMSMessage! ...", Now)
            Console.WriteLine("[{0}]Terminating Testing Of SMSMessage! ...", Now)
            Console.Read()

        End Using
    End Sub

End Module
