Imports System.Data.SqlClient
Imports System.Net.Mail
Imports System.Configuration

Module Module1

    Private dir As String = ConfigurationManager.AppSettings("templateDir").ToString

    Sub Main()
        Dim aArgs As String = Command$()
        Dim split() As String = aArgs.Split(New [Char]() {"/"c})

        If split.Length > 1 Then
            Select Case Trim(split(1).ToLower)
                Case "welcome"
                    SendWelcomeEmails()
                Case "followup"
                    SendFollowupEmails()
                Case "eligible"
                    SendEligibleAcctNotifications()
                Case "nonrepnotice"
                    SendNonRepresentationNotices()
                Case "palmer"
                    SendPalmerExclusionReport()
                Case "postlsa"
                    SendPostLSAEmails()
                Case Else
                    Console.WriteLine("*** Invalid command. App aborted. ***")
            End Select
        Else
            Console.WriteLine("*** No commands provided. App aborted. ***")
        End If
    End Sub

    Private Sub SendWelcomeEmails()
        Dim tblClients As DataTable = SqlHelper.GetDataTable("stp_GetEmailClientsWelcome", CommandType.StoredProcedure)
        Dim sr As IO.StreamReader
        Dim template As String
        Dim subject As String
        Dim type As String = "Welcome"
        Dim success, failed As Integer

        sr = IO.File.OpenText(dir & "\Welcome.txt")
        template = sr.ReadToEnd
        sr.Close()
        sr.Dispose()

        For Each row As DataRow In tblClients.Rows
            Try
                subject = String.Format("Welcome from {0}", row("company"))
                SendEmail(row, subject, template, type)
                InsertNote("Welcome Email Sent", CInt(row("clientid")))
                success += 1
            Catch ex As Exception
                LogException(CInt(row("clientid")), type, ex.Message)
                failed += 1
            End Try
        Next

        Console.WriteLine(String.Format("Success: {0}, Failed: {1}", success, failed))
    End Sub

    Private Sub SendFollowupEmails()
        Dim tblClients As DataTable = SqlHelper.GetDataTable("stp_GetEmailClientsFollowup", CommandType.StoredProcedure)
        Dim sr As IO.StreamReader
        Dim template As String
        Dim subject As String
        Dim type As String = "Follow-up"
        Dim success, failed As Integer

        For Each row As DataRow In tblClients.Rows
            Try
                Select Case CInt(row("agencyid"))
                    Case 856 'CID
                        sr = IO.File.OpenText(dir & "\FollowupCID.txt")
                    Case Else '838, 839, 842
                        sr = IO.File.OpenText(dir & "\FollowupOther.txt")
                End Select

                template = sr.ReadToEnd
                sr.Close()
                sr.Dispose()

                subject = String.Format("Follow-up from {0}", row("company"))
                SendEmail(row, subject, template, type)
                InsertNote("Welcome Follow-up Email Sent", CInt(row("clientid")))
                success += 1
            Catch ex As Exception
                LogException(CInt(row("clientid")), type, ex.Message)
                failed += 1
            End Try
        Next

        Console.WriteLine(String.Format("Success: {0}, Failed: {1}", success, failed))
    End Sub

    Private Sub SendEmail(ByVal row As DataRow, ByVal subject As String, ByVal template As String, ByVal type As String)
        Dim email As New SmtpClient(ConfigurationManager.AppSettings("smtp"))
        Dim clientservicesphone As String
        Dim clientservicesfax As String
        Dim creditorservicesphone As String
        Dim from As String
        Dim emailID As Integer
        Dim url As String

        from = String.Format("Client Services <noreply@{0}.lawfirmcs.com>", row("company").ToString.ToLower.Replace(" ", "").Replace(".", "").Replace(",", "").Replace("&", "and"))

        clientservicesphone = String.Format("({0}) {1}-{2}", Left(row("clientservicesphone"), 3), Mid(row("clientservicesphone"), 4, 3), Right(row("clientservicesphone"), 4))
        clientservicesfax = String.Format("({0}) {1}-{2}", Left(row("clientservicesfax"), 3), Mid(row("clientservicesfax"), 4, 3), Right(row("clientservicesfax"), 4))
        creditorservicesphone = String.Format("({0}) {1}-{2}", Left(row("creditorservicesphone"), 3), Mid(row("creditorservicesphone"), 4, 3), Right(row("creditorservicesphone"), 4))

        url = String.Format("http://{0}", row("website"))

        template = template.Replace("{{clientname}}", row("clientname"))
        template = template.Replace("{{company}}", row("company"))
        template = template.Replace("{{clientservicesphone}}", clientservicesphone)
        template = template.Replace("{{clientservicesfax}}", clientservicesfax)
        template = template.Replace("{{creditorservicesphone}}", creditorservicesphone)
        template = template.Replace("{{companyaddress}}", row("companyaddress"))
        template = template.Replace("{{url}}", url)

        emailID = InsertClientEmail(CInt(row("clientid")), row("emailaddress"), subject, template, type, 1265)

        template &= String.Format("<img src='http://lexscd.com/tracker/{0}.aspx' />", emailID)

        Dim message As New MailMessage(from, row("emailaddress"), subject, template)
        message.IsBodyHtml = True
        email.Send(message)
    End Sub

    Private Sub SendEligibleAcctNotifications()
        Dim tblClients As DataTable = SqlHelper.GetDataTable("stp_GetEligibleAcctClients", CommandType.StoredProcedure)
        Dim email As New SmtpClient(ConfigurationManager.AppSettings("smtp"))
        Dim clients, sent, failed As Integer
        Dim emailID As Integer
        Dim sendTo As String

        For Each row As DataRow In tblClients.Rows
            Dim params(0) As SqlParameter
            Dim tblAccts As DataTable

            params(0) = New SqlParameter("leadapplicantid", row("LeadApplicantID"))
            tblAccts = SqlHelper.GetDataTable("stp_LetterTemplates_LSACreditorList", CommandType.StoredProcedure, params)

            If tblAccts.Select("CreditorAcctNum like '%(Not Represented)%'").Length > 0 Then
                Dim sr As IO.StreamReader
                Dim template As String
                Dim type As String = "Eligible"
                Dim subject As String
                Dim from As String

                sr = IO.File.OpenText(dir & "\EligibleAccts.txt")
                template = sr.ReadToEnd
                sr.Close()
                sr.Dispose()

                template = Replace(template, "{{company}}", row("company"))
                subject = "Important information from " & row("company")
                from = String.Format("Client Services <noreply@{0}.lawfirmcs.com>", row("company").ToString.ToLower.Replace(" ", "").Replace(".", "").Replace(",", "").Replace("&", "and"))
                sendTo = CStr(row("emailaddress"))

                Try
                    emailID = InsertClientEmail(CInt(row("clientid")), sendTo, subject, template, type, 1265)
                    template &= String.Format("<img src='http://lexscd.com/tracker/{0}.aspx' />", emailID)
                    Dim message As New MailMessage(from, sendTo, subject, template)
                    message.IsBodyHtml = True
                    email.Send(message)
                    InsertNote("Notification of eligible accounts email sent.", CInt(row("clientid")))
                    sent += 1
                Catch ex As Exception
                    LogException(CInt(row("clientid")), type, ex.Message)
                    failed += 1
                End Try
            End If

            clients += 1
        Next

        Console.WriteLine(String.Format("New Clients: {0}, Sent: {1}, Failed: {2}", clients, sent, failed))
    End Sub

    Private Sub SendPostLSAEmails()
        Dim tblClients As DataTable = SqlHelper.GetDataTable("stp_PostLSAEmails", CommandType.StoredProcedure)
        Dim email As New SmtpClient(ConfigurationManager.AppSettings("smtp"))
        Dim sent, failed As Integer
        Dim emailID As Integer
        Dim sendTo As String
        Dim sr As IO.StreamReader
        Dim html As String
        Dim template As String
        Dim type As String = "Post LSA"
        Dim subject As String
        Dim from As String
        Dim phone As String

        sr = IO.File.OpenText(dir & "\PostLSA.txt")
        html = sr.ReadToEnd
        sr.Close()
        sr.Dispose()

        For Each row As DataRow In tblClients.Rows
            phone = CStr(row("phonenumber"))
            phone = String.Format("({0}) {1}-{2}", Left(phone, 3), Mid(phone, 4, 3), Right(phone, 4))

            template = html
            template = Replace(template, "{{rep}}", row("rep"))
            template = Replace(template, "{{company}}", row("company"))
            template = Replace(template, "{{clientname}}", row("leadname"))
            template = Replace(template, "{{phone}}", phone)
            subject = "Important notice from " & row("company")
            from = String.Format("Client Services <noreply@{0}.lawfirmcs.com>", row("company").ToString.ToLower.Replace(" ", "").Replace(".", "").Replace(",", "").Replace("&", "and"))
            sendTo = CStr(row("email"))

            Try
                emailID = InsertClientEmail(CInt(row("clientid")), sendTo, subject, template, type, 1265)
                template &= String.Format("<img src='http://lexscd.com/tracker/{0}.aspx' />", emailID)
                Dim message As New MailMessage(from, sendTo, subject, template)
                message.IsBodyHtml = True
                email.Send(message)
                'InsertNote("Verification Call notice email sent.", CInt(row("clientid")))
                'InsertLeadNote("Verification Call notice email sent.", CInt(row("leadapplicantid")))
                sent += 1
            Catch ex As Exception
                LogException(CInt(row("clientid")), type, ex.Message)
                failed += 1
            End Try
        Next

        Console.WriteLine(String.Format("Sent: {0}, Failed: {1}", sent, failed))
    End Sub

    Private Sub SendNonRepresentationNotices()
        Dim tblClients As DataTable = SqlHelper.GetDataTable("stp_GetNonRepClients", CommandType.StoredProcedure)
        Dim email As New SmtpClient(ConfigurationManager.AppSettings("smtp"))
        Dim sent, failed As Integer
        Dim emailID As Integer
        Dim sendTo As String
        Dim sr As IO.StreamReader
        Dim html As String
        Dim template As String
        Dim type As String = "Non-rep"
        Dim subject As String
        Dim from As String
        Dim phone As String

        sr = IO.File.OpenText(dir & "\NonRepNotice.txt")
        html = sr.ReadToEnd
        sr.Close()
        sr.Dispose()

        For Each row As DataRow In tblClients.Rows
            phone = CStr(row("phonenumber"))
            phone = String.Format("({0}) {1}-{2}", Left(phone, 3), Mid(phone, 4, 3), Right(phone, 4))

            template = html
            template = Replace(template, "{{company}}", row("company"))
            template = Replace(template, "{{client_name}}", row("leadname"))
            template = Replace(template, "{{date}}", Today.ToString("D"))
            template = Replace(template, "{{contact}}", row("contact1"))
            template = Replace(template, "{{phone}}", phone)
            subject = "Important Non-Representation Notice"
            from = String.Format("Client Services <noreply@{0}.lawfirmcs.com>", row("company").ToString.ToLower.Replace(" ", "").Replace(".", "").Replace(",", "").Replace("&", "and"))
            sendTo = CStr(row("email"))

            Try
                emailID = InsertClientEmail(CInt(row("clientid")), sendTo, subject, template, type, 1265)
                template &= String.Format("<img src='http://lexscd.com/tracker/{0}.aspx' />", emailID)
                Dim message As New MailMessage(from, sendTo, subject, template)
                message.IsBodyHtml = True
                email.Send(message)
                InsertNote("Non-Representation Notice email sent.", CInt(row("clientid")))
                InsertLeadNote("Non-Representation Notice email sent.", CInt(row("leadapplicantid")))
                sent += 1
            Catch ex As Exception
                LogException(CInt(row("clientid")), type, ex.Message)
                failed += 1
            End Try
        Next

        Console.WriteLine(String.Format("Sent: {0}, Failed: {1}", sent, failed))
    End Sub

    Private Sub SendPalmerExclusionReport()
        Dim tbl As DataTable = SqlHelper.GetDataTable("stp_PalmerExcludedRecipients", CommandType.StoredProcedure)
        Dim email As New SmtpClient(ConfigurationManager.AppSettings("smtp"))
        Dim body As New Text.StringBuilder
        Dim sumDaily As Double
        Dim sumAccum As Double

        body.Append("<table style='font-family:tahoma; font-size:12px'>")
        body.Append("<tr><td><u>Recipient</u></td><td style='text-align:right; width: 150px'><u>Today</u></td><td style='text-align:right; width: 150px'><u>Accumulated</u></td></tr>")
        For Each row As DataRow In tbl.Rows
            body.Append("<tr>")
            body.Append(String.Format("<td>{0}</td>", row("recipient")))
            body.Append(String.Format("<td style='text-align:right'>{0}</td>", FormatCurrency(CDbl(row("today")), 2)))
            body.Append(String.Format("<td style='text-align:right'>{0}</td>", FormatCurrency(CDbl(row("total")), 2)))
            body.Append("</tr>")
            sumDaily += CDbl(row("today"))
            sumAccum += CDbl(row("total"))
        Next
        body.Append(String.Format("<tr><td>&nbsp;</td><td style='text-align:right'><b>{0}</b></td><td style='text-align:right'><b>{1}</b></td></tr>", FormatCurrency(sumDaily, 2), FormatCurrency(sumAccum, 2)))
        body.Append("</table>")

        Dim message As New MailMessage("noreply@lexxiom.com", ConfigurationManager.AppSettings("sendPalmerExclusionTo"), "Palmer Exclusion Report", body.ToString)
        message.IsBodyHtml = True
        email.Send(message)
    End Sub

    Private Sub InsertNote(ByVal Note As String, ByVal ClientID As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("insert tblnote (clientid,[value],created,createdby,lastmodified,lastmodifiedby) values ({0},'{1}',getdate(),1265,getdate(),1265)", ClientID, Note.Replace("'", "''")), CommandType.Text)
    End Sub

    Private Sub InsertLeadNote(ByVal Note As String, ByVal LeadApplicantID As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("insert tblLeadNotes (LeadApplicantID, notetypeid, NoteType, Value, Created, CreatedByID, Modified, ModifiedBy) values ({0}, 1, 'Email', '{1}', getdate(), 1265, getdate(), 1265)", LeadApplicantID, Note.Replace("'", "''")), CommandType.Text)
    End Sub

    Private Function InsertClientEmail(ByVal ClientID As Integer, ByVal Email As String, ByVal Subject As String, ByVal Body As String, ByVal Type As String, ByVal SentBy As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar(String.Format("insert tblclientemails (clientid,email,[subject],body,[type],sentby) values ({0},'{1}','{2}','{3}','{4}',1265) select scope_identity()", ClientID, Email, Subject, Body.Replace("'", "''"), Type), CommandType.Text))
    End Function

    Private Sub LogException(ByVal ClientID As Integer, ByVal Type As String, ByVal Exception As String)
        SqlHelper.ExecuteNonQuery(String.Format("insert tblclientemailerrorlog (clientid,exception,[type]) values ({0},'{1}','{2}')", ClientID, Exception, Type), CommandType.Text)
    End Sub

End Module
