Imports System.Net.Mail
Imports System.Net
Imports System.IO
Imports System.Data.SqlClient

Module Driver
    ''' <summary>
    ''' 1. Inform all clients of impending draft date three days prior to intitial deposit date.
    ''' 2. Inform all clients of impending draft date three days prior to draft date.
    ''' Clients will be informed via email if any of the forementioned events occur. 
    ''' </summary>
    ''' <remarks></remarks>
    Sub Main()

        'MailServer(Settings)
        Dim MailServer As String = "smtp.gmail.com"
        Dim UserName As String = "info@lexxiom.com"
        Dim Password As String = "lexxiom1"

        'Email Settings
        Dim FromEmail As String = "info@lawfirmcs.com"
        Dim Subject As String = "Deposit Reminder"

        ''******* For Daily Use ********'

        'Run The Daily Job
        RunDailyJob(MailServer, UserName, Password, FromEmail, Subject)

        ''******* For Testing ********'

        'Dim AccountNumber As String = "7000169"
        'Dim Email_Was_A_Success As Boolean = False
        'Dim InitialDeposit As String = Now.AddDays(3).ToString("MM/dd/yyyy")

        ''*** Send Initial Deposit Notice To Single User ***'
        'SendInitialDepositEmail(AccountNumber, MailServer, UserName, Password, Today, FromEmail, Subject, Email_Was_A_Success)

        ''*** Send Non-Deposit Notice To Single User ***'
        'SendNonDepositEmail(AccountNumber, MailServer, UserName, Password, InitialDeposit, FromEmail, Subject, Email_Was_A_Success)



    End Sub

    Public Sub RunDailyJob(MailServer As String, UserName As String, Password As String, FromEmail As String, Subject As String)

        'Logging Destination Of File
        If Not Directory.Exists(String.Format("{0}\logs", My.Application.Info.DirectoryPath)) Then
            Directory.CreateDirectory(String.Format("{0}\logs", My.Application.Info.DirectoryPath))
        End If

        'Location of Log File
        Dim logPath As String = String.Format("{0}\logs\UpcomingDepositsEmail_Log_{1}.log", My.Application.Info.DirectoryPath, Format(Now, "yyyyMMddhhmm"))

        'Instance of StreamWriter
        Using sw As New StreamWriter(logPath, False)

            'Logging Start Of Application
            sw.WriteLine(String.Format("[{0}]Starting Upcoming Deposit Email Application!", Now))

            'Logging MailServer Settings
            sw.WriteLine("[{0}]Location to Email Server: {1}", Now, MailServer)
            sw.WriteLine("[{0}]Server UserName: {1}", Now, UserName)
            sw.WriteLine("[{0}]Server Password: {1}", Now, Password)

            'Date Settings
            Dim TodaysDate As Date = Now.AddDays(0)
            Dim Today As String = TodaysDate.ToString("MM/dd/yyyy")
            Dim DepositDate As String = TodaysDate.AddDays(1).ToString("MM/dd/yyyy")

            'Logging Date Settings
            sw.WriteLine("[{0}]Today's Date Is: {1}", Now, Today)
            sw.WriteLine("[{0}]Deposit Date Is: {1}", Now, DepositDate)

            'Logging Email Settings
            sw.WriteLine("[{0}]The 'From' For These Emails Are: {1}", Now, FromEmail)
            sw.WriteLine("[{0}]The 'Subject' For These Emails Are: {1} ", Now, Subject)

            'Marker For Successful Emails
            Dim Email_Was_A_Success As Boolean = False

            '*** Retrieve all clients receiving the three day notice. ***'

            'Logging Statement
            sw.WriteLine("[{0}]Retrieving A List Of Clients For Initial Deposits Reminder ...", Now)

            'Pull the list clients whos first deposit date falls on the same day as the variable.
            Dim ReminderClients As DataTable = GetInitialDepositReminderList(DepositDate)

            'Checking to see if any results were returned.
            If ReminderClients.Rows.Count < 1 Then
                sw.WriteLine("[{0}]The Initial Deposit Reminder Email List is Empty. ", Now)
                sw.WriteLine("[{0}]Moving On To Next Step. ", Now)
            Else
                sw.WriteLine("[{0}]The Initial Deposit Reminder Email List Has {1} Email To Send. ", Now, ReminderClients.Rows.Count)
                sw.WriteLine("[{0}]Moving On To Next Step. ", Now)
            End If

            'SEND EACH CLIENT A REMINDER OF THE UPCOMING INITIAL DEPOSIT.
            For Each client As DataRow In ReminderClients.Rows

                'Logging Client FullName, ClientID, Account Number, InitialDraftDate, InitialDraftAmount
                sw.WriteLine("[{0}]The Current Client: {1}", Now, client("FirstName") + " " + client("LastName"))
                sw.WriteLine("[{0}]ClientId / Account Number: {1} / {2}", Now, client("ClientId"), client("AccountNumber"))
                sw.WriteLine("[{0}]Initial Draft Date is {1:MM/dd/yyyy} for {2:C2}", Now, CDate(client("InitialDraftDate").ToString()), CInt(client("InitialDraftAmount").ToString()))

                'Create custom email per client
                Dim body As String = CreateXDayNoticeEmail(client("firstname") + " " + client("lastname"), client("address"), client("city"), client("state"), client("zipcode"), client("accountNumber"), client("InitialDraftDate"), client("InitialDraftAmount"), client("DepositMethod"), client("companyname").ToString, client("phonenumber").ToString, client("BillingMessage").ToString)

                'Variable used to check if email message was successful
                Email_Was_A_Success = False

                'Logging Statement
                sw.WriteLine("[{0}]Sending Email ...", Now)

                'Send message
                SendMessage(FromEmail, client("EmailAddress"), String.Format("Deposit Reminder: Message From {0}", client("companyname")), body, MailServer, UserName, Password, Email_Was_A_Success)

                'Logging Email Status
                sw.WriteLine("[{0}]Email Delivery Status: {1}", Now, Email_Was_A_Success)

                If Email_Was_A_Success Then

                    'Logging Recording Initital Deposit Record In Database
                    sw.WriteLine("[{0}]Recording Delivery Of Email ...", Now)

                    'Record email details for initial deposit notice
                    RecordInitialDepositEmail(client("clientId"), client("EmailAddress"), client("DepositMethod"), client("InitialDraftDate"))

                    'Logging Creation of Note in Database.
                    sw.WriteLine("[{0}]Creating A Note For Client In Database ...", Now)

                    'Record a note for the initial deposit notice.
                    CreateNote("Email was sent informing client that client''s initial deposit is due in three days", client("ClientId"))
                End If

            Next

            'Logging Statement
            sw.WriteLine("[{0}]Clearing All Clients Past Thirty Days In Initial Deposit Table From Being Reviewed Again ...", Now)

            'Mark all clients that have passed 30 days as checked'
            ClearAllThirtyDayClients()

            '*** Retrieve all clients that are active ***'

            'Logging getting a list of initial deposit clients.
            sw.WriteLine("[{0}]Retrieving List Of All Clients Who Are Active ...", Now)

            'Pull the list clients who have a deposit date which match the the email deposit date.
            Dim ClientList As DataTable = GetAllDepositingClients(DepositDate)

            'Checking to see if any results were returned.
            If ClientList.Rows.Count < 1 Then
                sw.WriteLine("[{0}]The Monthly Deposit Reminder Email List is Empty. ", Now)
                sw.WriteLine("[{0}]Moving On To Next Step. ", Now)
            Else
                sw.WriteLine("[{0}]The Monthly Deposit Reminder Email List Has {1} Email To Send. ", Now, ClientList.Rows.Count)
                sw.WriteLine("[{0}]Moving On To Next Step. ", Now)
            End If

            'Run through list.
            For Each clients As DataRow In ClientList.Rows

                'Dim client As DataRow = GetClient(clients("ClientId")).Rows(0)

                sw.WriteLine("[{0}]{1} Has A Deposit On {2} ...", Now, clients("firstname") + " " + clients("lastname"), DepositDate)

                'Create custom email per client
                Dim body As String = CreateMonthlyNoticeEmailBody(clients("firstname").ToString + " " + clients("lastname").ToString, clients("address").ToString, clients("city").ToString, _
                                               clients("state").ToString, clients("zipcode").ToString, clients("accountnumber").ToString, _
                                               clients("depositDate").ToString, clients("depositMethod").ToString, clients("depositAmount").ToString, _
                                               clients("companyname").ToString, clients("phonenumber").ToString, clients("BillingMessage").ToString)

                'Variable used to check if email message was successful
                Email_Was_A_Success = False

                'Send message
                'SendMessage(FromEmail, clients("EmailAddress"), Subject, body, MailServer, UserName, Password, Email_Was_A_Success)

                If Email_Was_A_Success Then

                    'Record email details in tblClientEmails
                    'RecordEmails()

                    'Record a note for the initial deposit notice.
                    CreateNote(String.Format("Email was sent informing client that client''s deposit is due on {0}.", DepositDate), clients("ClientId"))

                End If

            Next

            'Logging Statement
            sw.WriteLine("[{0}]Terminating Deposit Email Program ...", Now)

        End Using
    End Sub

    ''' <summary>
    ''' Marks all clients that are beyond thirty days
    ''' from being checked by the system.
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub ClearAllThirtyDayClients()

        Dim Query As String = "update tblInitialDepositEmail set Checked = 1 where InitialDepositDate < DateAdd(d,-30,getdate())"
        SqlHelper.ExecuteNonQuery(Query, CommandType.Text)

    End Sub

    Public Function GetAllDepositingClients(DepositDate As DateTime) As DataTable

        Dim Query As String = "stp_GetUpcomingDepositsByDate"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("depositDate", DepositDate))
        Return SqlHelper.GetDataTable(Query, CommandType.StoredProcedure, params.ToArray)

    End Function

    ''' <summary>
    ''' Retrieves a list of clients who have not made
    ''' their initial deposit. 
    ''' </summary>
    ''' <param name="InitialDeposit"></param>
    ''' <returns>Data Table [Lsit of Clients]</returns>
    ''' <remarks></remarks>

    Public Function GetClientList(ByVal InitialDeposit As Date) As DataTable

        Dim Query As String = "select de.ClientId [ClientId], de.ToEmailAddress [EmailAddress], de.TypeOfDeposit [DepositType], de.InitialDepositDate [InitialDepositDate] from tblInitialDepositEmail de where de.Checked = 0"
        Return SqlHelper.GetDataTable(Query, CommandType.Text)

    End Function

    ''' <summary>
    ''' Retrieves a list of clients who have an initial deposit date
    ''' which equals that of the supplied argument.
    ''' </summary>
    ''' <param name="InitialDeposit"></param>
    ''' <returns>Data table [List of clients]</returns>
    ''' <remarks></remarks>
    Public Function GetInitialDepositReminderList(ByVal InitialDeposit As Date) As DataTable
        Dim Query As String = "stp_GetInitialDepositReminderList"
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("depositDate", InitialDeposit))
        Return SqlHelper.GetDataTable(Query, CommandType.StoredProcedure, params.ToArray)

    End Function

    'TESTING ONLY
    Public Sub SendInitialDepositEmail(AccountNumber As String, MailServer As String, UserName As String, Password As String, InitialDeposit As DateTime, fromEmail As String, subject As String, ByRef Email_Was_A_Success As Boolean)

        Dim clients As DataTable = GetClient(AccountNumber)
        Dim client As DataRow = clients.Rows(0)

        'Create custom email per client
        Dim body As String = CreateXDayNoticeEmail(client("firstname") + " " + client("lastname"), client("address"), client("city"), client("state"), client("zipcode"), client("accountNumber"), client("InitialDraftDate"), client("InitialDraftAmount"), client("DepositMethod"), clients("companyname").ToString, clients("phonenumber").ToString, clients("BillingMessage").ToString)

        'Variable used to check if email message was successful
        Email_Was_A_Success = False

        'Send message
        SendMessage(fromEmail, client("EmailAddress"), String.Format("Deposit Reminder: Message From {0}", client("CompanyName")), body, MailServer, UserName, Password, Email_Was_A_Success)

        If Not Email_Was_A_Success Then

            'Record email details for initial deposit notice
            RecordInitialDepositEmail(client("clientId"), client("EmailAddress"), client("DepositMethod"), client("InitialDraftDate"))

            'Record a note for the initial deposit notice.
            CreateNote("Email was sent informing client that client''s initial deposit is due in three days", client("ClientId"))
        End If

    End Sub
    'TESTING ONLY
    Public Sub SendMonthlyDepositEmail(AccountNumber As String, MailServer As String, UserName As String, Password As String, InitialDeposit As DateTime, fromEmail As String, subject As String, ByRef Email_Was_A_Success As Boolean)

        'Dim clients As DataTable = GetClient(AccountNumber)
        'Dim client As DataRow = clients.Rows(0)

        ''Create custom email per client
        'Dim body As String = CreateMonthlyNoticeEmail(client("firstname") + " " + client("lastname"), client("address"), client("city"), client("state"), client("zipcode"), client("accountNumber"), client("InitialDraftDate"), client("InitialDraftAmount"))

        ''Variable used to check if email message was successful
        'Email_Was_A_Success = False

        ''Send message
        'SendMessage(fromEmail, client("EmailAddress"), subject, body, MailServer, UserName, Password, Email_Was_A_Success)

        'If Not Email_Was_A_Success Then

        '    'Record email details for initial deposit notice
        '    'RecordMonthlyDepositEmail(client("clientId"), client("EmailAddress"), client("DepositMethod"), client("InitialDraftDate"))

        '    'Record a note for the initial deposit notice.
        '    CreateNote("Email was sent informing client that client''s initial deposit is due in three days", client("ClientId"))
        'End If

    End Sub

    Public Function GetClient(AccountNumber As String) As DataTable

        Dim Query As String = String.Format("select c.ClientId, c.PrimaryPersonId, c.AccountNumber, c.DepositMethod, c.CurrentClientStatusId, c.InitialDraftDate, c.InitialDraftAmount, p.FirstName, p.LastName, p.Street As Address, p.City, s.Name As State, p.ZipCode, p.EmailAddress from tblClient c join tblPerson p on p.PersonId = c.PrimaryPersonId join tblState s on s.StateId = p.StateId where c.AccountNumber = {0}", AccountNumber)
        Return SqlHelper.GetDataTable(Query, CommandType.Text)

    End Function

    Private Function CreateXDayNoticeEmail(name As String, address As String, city As String, _
                                               statecode As String, zipcode As String, account As String, _
                                               depositDate As DateTime, depositAmount As Double, depositMethod As String, _
                                               companyName As String, companyPhone As String, companyHours As String) As String
        Dim email As String = ""
        Dim tab As String = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
        Dim space As String = "&nbsp;"
        Dim phone As String = companyPhone
        phone = "(" + phone.Substring(0, 3) + ")" + phone.Substring(3, 3) + "-" + phone.Substring(6, 4)

        email += "<html>"
        email += "<body>"
        email += String.Format("<p style=""font-size:.9em;"">{0}</p>", Now.ToString("MMMM d, yyyy"))
        email += String.Format("<p style=""font-size:.95em;""><span style=""font-size:1em;"">{0}</span><br/>{1}<br/>{2}, {3} {4}</p>", name, address, city, statecode, zipcode)
        email += String.Format("<p>Account #: <strong>{0}</strong></p>", account)
        email += String.Format("<p style=""font-size:.9em;"">Dear {0}, <br/>{1}Congratulations on taking the first step to resolving your debt problems.{2}By now you should have received your Welcome Package in the Client Portal.</p>", name, tab, space)
        If depositMethod.ToLower = "check" Then
            email += String.Format("<p style=""font-size:.9em;"">{0}As a reminder, your <em>first initial deposit</em> is due by check on <strong>{1:MM/dd/yyyy}</strong> in the amount of <strong>${2}</strong>.{3}Please ensure that the funds do arrive on that day, so you can start building funds up in your Trust Account to negotiate your debts.", tab, depositDate, depositAmount.ToString("0.00"), space)
        Else
            email += String.Format("<p style=""font-size:.9em;"">{0}As a reminder, your <em>first initial deposit</em> is due to be drafted on <strong>{1:MM/dd/yyyy}</strong> in the amount of <strong>${2}</strong>.{3}Please ensure that the funds are available on that day, so you can start building funds up in your Trust Account to negotiate your debts.", tab, depositDate, depositAmount.ToString("0.00"), space)
        End If
        email += String.Format("<p style=""font-size:.9em;"">{0}If you have any questions please contact our office {1} at {2}.", tab, companyHours, phone)
        email += String.Format("<p style=""font-size:.95em;"">very truly yours,<br/><br/><img src="""" alt=""signature""><br/><br/>{0}</p>", companyName)
        email += "</body>"
        email += "</html>"

        Return email
    End Function

    Private Function CreateMonthlyNoticeEmailBody(name As String, address As String, city As String, _
                                               statecode As String, zipcode As String, account As String, _
                                               depositDate As DateTime, depositMethod As String, depositAmount As Double, _
                                               companyName As String, companyPhone As String, companyHours As String) As String
        Dim email As String = ""
        Dim tab As String = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
        Dim space As String = "&nbsp;"
        Dim toBeDrafted As String = ""
        Dim phone As String = companyPhone
        phone = "(" + phone.Substring(0, 3) + ")" + phone.Substring(3, 3) + "-" + phone.Substring(6, 4)

        If depositMethod.ToLower = "ach" Then
            toBeDrafted = "to be drafted "
        End If

        email += "<html>"
        email += "<body>"
        email += String.Format("<p style=""font-size:.9em;"">{0}</p>", Now.ToString("MMMM d, yyyy"))
        email += String.Format("<p style=""font-size:.95em;""><span style=""font-size:1em;"">{0}</span><br/>{1}<br/>{2}, {3} {4}</p>", name, address, city, statecode, zipcode)
        email += String.Format("<p>Account #: <strong>{0}</strong></p>", account)
        email += String.Format("<p style=""font-size:.9em;"">Dear {0}, <br/>{1}As a reminder, your deposit for your trust account is due {2}on <strong>{3:MM/dd/yyyy}</strong> in the amount of <strong>${4}</strong>.", name, tab, toBeDrafted, depositDate, depositAmount)
        email += String.Format("{0}Please ensure that the funds are available on that day, so you can start building funds up in your Account to negotiate your debts.</p>", space)
        email += String.Format("<p style=""font-size:.9em;"">If you have any questions please contact our office {0} at {1}.</p>", companyHours, phone)
        email += String.Format("<p style=""font-size:.95em;"">very truly yours,<br/><br/><img src="""" alt=""signature""><br/><br/>{0}</p>", companyName)
        email += "</body>"
        email += "</html>"

        Return email
    End Function

    Private Sub RecordInitialDepositEmail(clientId As String, ToEmail As String, TypeOfDeposit As String, InitialDepositDate As String)

        Dim query As String = "insert tblInitialDepositEmail "
        query += "(ClientId, ToEmailAddress, TypeOfDeposit, InitialDepositDate, InitialDepositEmail, Checked) "
        query += String.Format("values ('{0}', '{1}', '{2}', '{3}', getdate(), 0)", clientId, ToEmail, TypeOfDeposit, InitialDepositDate)
        Try
            SqlHelper.ExecuteNonQuery(query, CommandType.Text)
        Catch ex As Exception
            'Throw ex
        End Try

    End Sub

    Private Sub CreateNote(ByVal value As String, ByVal clientId As String)

        Dim Query As String = String.Format("insert tblNote (Value,Created,CreatedBy,LastModified,LastModifiedBy,ClientId,UserGroupId) values ('{0}', getdate(), 32, getdate(), 32, {1}, 6)", value, clientId)
        SqlHelper.ExecuteNonQuery(Query, CommandType.Text)

    End Sub

    Public Sub SendMessage(ByVal from As String, _
                           ByVal toAddress As String, _
                           ByVal subject As String, _
                           ByVal body As String, _
                           ByVal smtpServerAddress As String, _
                           ByVal smtpUser As String, _
                           ByVal smtpPassword As String, _
                           ByRef success As Boolean)

        Dim email As New SmtpClient(smtpServerAddress, 587)

        Dim message As New MailMessage()
        message.From = New MailAddress(from)
        message.To.Add(New MailAddress(toAddress))
        message.Subject = subject
        message.Body = body

        message.IsBodyHtml = True

        'create the mail message
        Dim mail As New MailMessage()

        Try
            'make sure we have someone to send it to if all emails were invalid
            If message.To.Count > 0 Then
                Dim nc As New NetworkCredential(smtpUser, smtpPassword)
                email.UseDefaultCredentials = False
                email.Credentials = nc
                email.DeliveryMethod = SmtpDeliveryMethod.Network
                email.EnableSsl = True
                email.Send(message)
                success = True
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

End Module
