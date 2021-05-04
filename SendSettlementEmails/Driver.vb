Imports System.IO
Imports System.Net.Mail
Imports System.Net
Imports System.Data.SqlClient

Module Driver

    Sub Main()
        ''Global Variables

        'MailServer(Settings)
        Dim MailServer As String = "dc02.dmsi.local"
        Dim UserName As String = "Administrator"
        Dim Password As String = "M1n10n11690"

        'Email Settings
        Dim FromEmail As String = "donotreply@lawfirmcs.com"
        Dim Subject As String = "Personal and Confidential: Monthly Settlements"
        Dim Email_Was_A_Success As Boolean = False

        'Client Value
        Dim ClientIdentifiers As New List(Of Integer)

        'Date Settings
        Dim TodaysDate As Date = Now.AddDays(0)
        Dim Today As String = TodaysDate.ToString("MM/dd/yyyy")

        'Gathering List Of Clients Which Required An Email Notification
        ClientIdentifiers = GetClientList()

        'For Each Client 1.Extract Dynamic Info 2.Build Email Body 3. Send Email 4. Log Result
        For Each client As Integer In ClientIdentifiers

            'Gathering Information Of Client For Dynamic Purposes
            Dim clientInfo As DataTable = GetClientInformation(client)

            'Create custom email per client
            Dim EmailBody As String = BuildEmailBody(clientInfo)

            'Variable used to check if email message was successful
            Email_Was_A_Success = False

            'Send message
            SendMessage(FromEmail, clientInfo.Rows(0)("EmailAddress"), Subject, EmailBody, MailServer, UserName, Password, Email_Was_A_Success)

            If Email_Was_A_Success Then

                'Record email details for initial deposit notice
                RecordEmails(client, clientInfo.Rows(0)("EmailAddress"), Subject, EmailBody)

                'Record a note for the initial deposit notice.
                CreateNote("Email was sent informing client that client''s statement is available through client portal", client)

                'Mark as Complete
                MarkAsComplete(client)
            End If
        Next

    End Sub

    Private Function GetClientList() As List(Of Integer)

        Dim list As New List(Of Integer)

        Dim query As String = "select clientId from tblStatementPersonal where ElectronicStatement = 1 and StmtCreated = 1 and EmailSentDate is null"
        Dim dt As DataTable = SqlHelper.GetDataTable(query, CommandType.Text)

        For Each dr As DataRow In dt.Rows
            list.Add(CInt(dr("ClientId").ToString))
        Next
        Return list
    End Function
    Private Function GetClientInformation(Client As Integer) As DataTable

        Dim clientInfo As DataTable = Nothing
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("clientid", Client))

        clientInfo = SqlHelper.GetDataTable("stp_GetClientEStatementInfo", CommandType.StoredProcedure, params.ToArray)

        Return clientInfo
    End Function
    Private Function BuildEmailBody(ClientInfo As DataTable) As String

        Dim body As String = ""
        Dim tab As String = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
        Dim space As String = "&nbsp;"
        Dim client As DataRow = ClientInfo.Rows(0)

        Dim clientname As String = client("fullname").ToString
        Dim firmname As String = client("firmname").ToString
        Dim firmwebsite As String = client("website").ToString
        Dim clientservicephone As String = FormatPhone(client("customerservicephone"))
        Dim clientservicehours As String = client("customerservicehours")
        Dim attorneycustomerservicephone As String = FormatPhone(client("attorneycustomerservicephone"))
        Dim attorneycustomerservicefax As String = FormatPhone(client("attorneycustomerservicefax"))
        Dim attorneycustomerserviceaddress As String = client("attorneycustomerserviceaddress")

        'If Language = 1 Then
        body += "<html>"
        body += "<body>"
        body += String.Format("<p style=""font-size:.9em;"">Dear {0}, <br/>", clientname)
        body += String.Format("<p style=""font-size:.9em;"">Thank you for choosing {0} to represent you.{1}We look forward to continuing to working with you to reach your goal.</p>", firmname, space)
        body += String.Format("<p style=""font-size:.9em;"">Your monthly statement is now available in the online client portal.{0}Please login to {1} to review your transactions and print your statement for your records.</p><br/>", space, firmwebsite)
        body += String.Format("<p style=""font-size:.9em;"">FOR YOUR REFERENCE:</p>")
        body += String.Format("<p style=""font-size:.9em;"">If you have any questions or concerns regarding your representation, please call our firm’s Client Services Department at {0}.{1}A representative of the firm will be happy to assist you {2}.</p>", clientservicephone, space, clientservicehours)
        body += String.Format("<p style=""font-size:.9em;"">If any collectors contact you by phone please read the script from the telephone response card included in your welcome package and direct the collector to call {0} to put them in touch with someone at our firm who can assist them.", attorneycustomerservicephone)
        body += String.Format("<p style=""font-size:.9em;"">If you receive any notices or statements from your creditors, please fax to {0} or mail to {1}.", attorneycustomerservicefax, attorneycustomerserviceaddress)
        body += String.Format("<hr/>")
        body += String.Format("<p style=""font-size:.75em;"">IMPORTANT NOTES")
        body += String.Format("<p style=""font-size:.75em;"">THE SEQUENCE IN WHICH YOUR DEBTS ARE SETTLED, AS WELL AS THE AMOUNT AND FREQUENCY OF YOUR DEPOSITS IS CRITICAL TO THE EFFORTS TO SETTLE THE ACCOUNTS. IN GENERAL, THE MORE YOU ARE ABLE TO DEPOSIT, THE SOONER WE CAN SEEK SUCCESSFUL SETTLEMENTS OF THE ACCOUNTS. SINCE THE MONTHLY SERVICE FEE STOPS ON AN ACCOUNT ONCE IT IS SETTLED AND CONTINGENCY FEES DUE HAVE BEEN PAID, YOU MAY BE ABLE TO REDUCE THE AMOUNT OF MONTHLY SERVICE FEES YOU PAY BY ENABLING US TO NEGOTIATE SUCCESSFUL SETTLEMENTS SOONER. WHILE OTHER FACTORS WE CANNOT CONTROL (SUCH AS WHAT SETTLEMENT A CREDITOR MAY ACCEPT, AND WHEN THEY ACCEPT IT) WILL AFFECT HOW SOON YOUR ACCOUNTS ARE SETTLED, YOUR DEPOSIT AMOUNTS WILL BE AN IMPORTANT FACTOR IN YOUR SUCCESS.")
        body += String.Format("<p style=""font-size:.75em;"">CONFIDENTIALITY NOTICE: This e-mail transmission, and any documents, files or previous e-mail messages attached to it, may contain confidential information that is legally privileged. If you are not the intended recipient, or a person responsible for delivering it to the intended recipient, you are hereby notified that any disclosure, copying, distribution or use of any of the information contained in or attached to this message is STRICTLY PROHIBITED. If you have received this transmission in error, please immediately notify us by reply e-mail, and destroy the original transmission and its attachments without reading them or saving them to disk. Thank you.")
        body += String.Format("<p style=""font-size:.75em;"">IRS CIRCULAR 230 NOTICE: To ensure compliance with requirements imposed by the IRS, we inform you that any U.S. tax advice contained in this communication (or in any attachment) is not intended or written to be used, and cannot be used, for the purpose of (i) avoiding penalties under the Internal Revenue Code or (ii) promoting, marketing or recommending to another party any transaction or matter addressed in this communication (or in any attachment).")
        body += "</body>"
        body += "</html>"
        'Else
        'body += "<html>"
        'body += "<body>"
        'body += String.Format("<p style=""font-size:.9em;"">Estimado {0}, <br/>", clientname)
        'body += String.Format("<p style=""font-size:.9em;"">Gracias por elegir {0} para que lo represente.{1}Esperamos con interés continuar trabajando con usted para llegar a su objetivo.</p>", firmname, space)
        'body += String.Format("<p style=""font-size:.9em;"">Su estado de cuenta mensual está ahora disponible en el portal del cliente en línea.{0}Por favor, inicie sesión en {1} para revisar sus transacciones e imprimir su declaración de sus registros.</p><br/>", space, firmwebsite)
        'body += String.Format("<p style=""font-size:.9em;"">PARASU CONSULTA:</p>")
        'body += String.Format("<p style=""font-size:.9em;"">Si tiene alguna pregunta o inquietud con respecto a su representación, por favor llame a el Departamento de Servicios al Cliente al {0}.{1}Un representante de la empresa estará encantado de ayudarle {2}.</p>", clientservicephone, space, clientservicehours)
        'body += String.Format("<p style=""font-size:.9em;"">Si cualquier coleccionistas contacto con usted por teléfono, por favor lea el guión de la respuesta telefónica tarjeta incluida en su paquete de bienvenida y dirigir el coleccionista, con el objeto de llamar al {0} para ponerlos en contacto con alguien de nuestra empresa que les puede ayudar.", attorneycustomerservicephone)
        'body += String.Format("<p style=""font-size:.9em;"">Si recibe las notificaciones o declaraciones de sus acreedores, por favor envíe por fax al {0} o por correo al Centro de Procesamiento {1}.", attorneycustomerservicefax, attorneycustomerserviceaddress)
        'body += String.Format("<hr/>")
        'body += String.Format("<p style=""font-size:.75em;"">IMPORTANT NOTES")
        'body += String.Format("<p style=""font-size:.75em;"">THE SEQUENCE IN WHICH YOUR DEBTS ARE SETTLED, AS WELL AS THE AMOUNT AND FREQUENCY OF YOUR DEPOSITS IS CRITICAL TO THE EFFORTS TO SETTLE THE ACCOUNTS. IN GENERAL, THE MORE YOU ARE ABLE TO DEPOSIT, THE SOONER WE CAN SEEK SUCCESSFUL SETTLEMENTS OF THE ACCOUNTS. SINCE THE MONTHLY SERVICE FEE STOPS ON AN ACCOUNT ONCE IT IS SETTLED AND CONTINGENCY FEES DUE HAVE BEEN PAID, YOU MAY BE ABLE TO REDUCE THE AMOUNT OF MONTHLY SERVICE FEES YOU PAY BY ENABLING US TO NEGOTIATE SUCCESSFUL SETTLEMENTS SOONER. WHILE OTHER FACTORS WE CANNOT CONTROL (SUCH AS WHAT SETTLEMENT A CREDITOR MAY ACCEPT, AND WHEN THEY ACCEPT IT) WILL AFFECT HOW SOON YOUR ACCOUNTS ARE SETTLED, YOUR DEPOSIT AMOUNTS WILL BE AN IMPORTANT FACTOR IN YOUR SUCCESS.")
        'body += String.Format("<p style=""font-size:.75em;"">CONFIDENTIALITY NOTICE: This e-mail transmission, and any documents, files or previous e-mail messages attached to it, may contain confidential information that is legally privileged. If you are not the intended recipient, or a person responsible for delivering it to the intended recipient, you are hereby notified that any disclosure, copying, distribution or use of any of the information contained in or attached to this message is STRICTLY PROHIBITED. If you have received this transmission in error, please immediately notify us by reply e-mail, and destroy the original transmission and its attachments without reading them or saving them to disk. Thank you.")
        'body += String.Format("<p style=""font-size:.75em;"">IRS CIRCULAR 230 NOTICE: To ensure compliance with requirements imposed by the IRS, we inform you that any U.S. tax advice contained in this communication (or in any attachment) is not intended or written to be used, and cannot be used, for the purpose of (i) avoiding penalties under the Internal Revenue Code or (ii) promoting, marketing or recommending to another party any transaction or matter addressed in this communication (or in any attachment).")
        'body += "</body>"
        'body += "</html>"
        'End If

        Return body
    End Function
    Private Sub CreateNote(ByVal value As String, ByVal clientId As String)

        Dim Query As String = String.Format("insert tblNote (Value,Created,CreatedBy,LastModified,LastModifiedBy,ClientId,UserGroupId) values ('{0}', getdate(), 32, getdate(), 32, {1}, 6)", value, clientId)
        SqlHelper.ExecuteNonQuery(Query, CommandType.Text)

    End Sub
    Private Sub SendMessage(ByVal from As String, _
                           ByVal toAddress As String, _
                           ByVal subject As String, _
                           ByVal body As String, _
                           ByVal smtpServerAddress As String, _
                           ByVal smtpUser As String, _
                           ByVal smtpPassword As String, _
                           ByRef success As Boolean)
        If toAddress = "" Then
            Return
        End If

        Dim email As New SmtpClient(smtpServerAddress)

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
                email.Send(message)
                success = True
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub
    Private Function FormatPhone(ByVal phone As String) As String

        Dim formatted As String = ""
        If phone.Trim().Length = 10 Then
            formatted = "(" + phone.Substring(0, 3) + ") " + phone.Substring(3, 3) + "-" + phone.Substring(6, 4)
        End If

        Return formatted

    End Function
    Private Sub RecordEmails(client As Integer, email As String, subject As String, body As String)

        Dim Type As String = "EStatementNotification"
        Dim DateSent As Date = Now
        Dim SentBy As Integer = 1265

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("ClientId", client))
        params.Add(New SqlParameter("Email", email))
        params.Add(New SqlParameter("Subject", subject))
        params.Add(New SqlParameter("Body", body))
        params.Add(New SqlParameter("Type", Type))
        params.Add(New SqlParameter("DateSent", DateSent))
        params.Add(New SqlParameter("SentBy", SentBy))

        SqlHelper.ExecuteNonQuery("stp_InsertEmailRecord", CommandType.StoredProcedure, params.ToArray)

    End Sub
    Private Sub MarkAsComplete(ClientId As Integer)

        Dim query As String = String.Format("update tblStatementPersonal set EmailSentDate = '{0}' where ClientId = {1} and EmailSentDate is null", Now, ClientId)
        SqlHelper.ExecuteNonQuery(query, CommandType.Text)

    End Sub

End Module
