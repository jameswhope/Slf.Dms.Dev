Imports Microsoft.VisualBasic
Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports System.Data
Imports System.Data.SqlClient
Imports System.Collections.Generic
Imports Lexxiom.ImportClients
Imports System.Web
Imports System.IO
Imports System.Net.Mail
Imports System.Net
Imports System.Security.Cryptography.X509Certificates
Imports System.Configuration

Public Class SmartDebtorHelper

#Region "Lead Documents"

    Public Enum DocType As Integer
        CreditReport = 9
        LSA = 222
        SDAA = 223
        SCHA = 225
        CHECK = 344
        TISDS = 766
        CVRLTR = 767
        VerificationCall = 9072
        VerificationRecorded = 9073
    End Enum

    Public Shared Sub SaveLeadDocument(ByVal leadApplicantID As Integer, ByVal documentID As String, ByVal submittedBy As Integer, ByVal docType As DocType, Optional ByVal signatoryEmail As String = "")
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "LeadApplicantID", leadApplicantID)
        DatabaseHelper.AddParameter(cmd, "DocumentId", documentID)
        DatabaseHelper.AddParameter(cmd, "DocumentTypeID", docType)
        DatabaseHelper.AddParameter(cmd, "SubmittedBy", submittedBy)

        Select Case docType
            Case docType.CreditReport, docType.VerificationCall, docType.VerificationRecorded
                DatabaseHelper.AddParameter(cmd, "Completed", Now)
                DatabaseHelper.AddParameter(cmd, "CurrentStatus", "Complete")
            Case docType.LSA
                DatabaseHelper.AddParameter(cmd, "SignatoryEmail", signatoryEmail)
                DatabaseHelper.AddParameter(cmd, "CurrentStatus", "Waiting on signatures")
        End Select

        DatabaseHelper.BuildInsertCommandText(cmd, "tblLeadDocuments", "LeadDocumentID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub
    Public Shared Sub SaveLeadDocument(ByVal leadApplicantID As Integer, ByVal documentID As String, ByVal submittedBy As Integer, ByVal docType As DocType, ByVal SigningBatchID As String, ByVal signatoryEmail As String)
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        DatabaseHelper.AddParameter(cmd, "LeadApplicantID", leadApplicantID)
        DatabaseHelper.AddParameter(cmd, "DocumentId", documentID)
        DatabaseHelper.AddParameter(cmd, "DocumentTypeID", docType)
        DatabaseHelper.AddParameter(cmd, "SigningBatchID", SigningBatchID)
        DatabaseHelper.AddParameter(cmd, "SubmittedBy", submittedBy)

        Select Case docType
            Case docType.CreditReport
                DatabaseHelper.AddParameter(cmd, "Completed", Now)
                DatabaseHelper.AddParameter(cmd, "CurrentStatus", "Complete")
            Case Else
                DatabaseHelper.AddParameter(cmd, "SignatoryEmail", signatoryEmail)
                DatabaseHelper.AddParameter(cmd, "CurrentStatus", "Waiting on signatures")

        End Select

        DatabaseHelper.BuildInsertCommandText(cmd, "tblLeadDocuments", "LeadDocumentID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Public Shared Function GetLeadDocument(ByVal DocumentId As String) As DataTable
        Return SqlHelper.GetDataTable(String.Format("select t.displayname, d.leaddocumentid, d.leadapplicantid, d.completed, d.signatoryemail, l.leadname from tblleaddocuments d join tbldocumenttype t on t.documenttypeid = d.documenttypeid join tblleadapplicant l on l.leadapplicantid = d.leadapplicantid where d.documentid = '{0}'", DocumentId))
    End Function

    Public Shared Function GetLeadDocumentsBySigningBatchID(ByVal signingBatchID As String) As DataTable
        Return SqlHelper.GetDataTable(String.Format("stp_esign_getDocuments '{0}'", signingBatchID))
    End Function

    Public Shared Sub SendEsignNotification(ByVal SendTo As String, ByVal DocumentName As String, ByVal DocumentId As String, ByVal RepID As Integer)
        'Dim tblRepInfo As DataTable = SqlHelper.GetDataTable("select firstname + ' ' + lastname[name], emailaddress, username from tbluser where userid = " & RepID)
        Dim mailMsg As New System.Net.Mail.MailMessage("Law Firm Compliance <noreply@lawfirmsd.com>", SendTo, "Please E-sign the " & DocumentName, String.Format("<a href='https://service.lexxiom.com/Slf.Dms.Client/public/esign.aspx?docId={0}' target='_blank'>Click here to review and e-sign {1}.</a>", DocumentId, DocumentName))
        Dim mailSmtp As New System.Net.Mail.SmtpClient(ConfigurationManager.AppSettings("EmailSMTP"))
        mailMsg.IsBodyHtml = True
        mailSmtp.Send(mailMsg)
    End Sub
    Public Shared Sub SendEsignNotification(ByVal SendTo As String, ByVal DocumentNameList As String(), ByVal signingBatchID As String, ByVal RepID As Integer, Optional ByVal bSpanishText As Boolean = False)
        'Dim tblRepInfo As DataTable = SqlHelper.GetDataTable("select firstname + ' ' + lastname[name], emailaddress, username from tbluser where userid = " & RepID)
        Dim msgBody As New System.Text.StringBuilder
        Dim msgSubj As New System.Text.StringBuilder


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

        Dim firmName As String = ""
        Dim sqlInfo As New System.Text.StringBuilder
        sqlInfo.Append("select co.name from tblleaddocuments ld inner join tblleadapplicant la on la.leadapplicantid = ld.leadapplicantid inner join tblcompany co on co.companyid = la.companyid ")
        sqlInfo.AppendFormat("where ld.signingbatchid = '{0}'", signingBatchID)
        Using dt As DataTable = SqlHelper.GetDataTable(sqlInfo.ToString, CommandType.Text)
            For Each row As DataRow In dt.Rows
                firmName = row("name").ToString
                Exit For
            Next
        End Using

        Dim lnkUrl As String = String.Format("{0}://{1}/public/esign.aspx?sbId={2}", strHTTP, svrPath, signingBatchID)

        'build email body
        Select Case bSpanishText
            Case True
                msgBody.Append("<table style='width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2' cellpadding='8' cellspacing='0'>")
                msgBody.AppendFormat("<tr><td><h2>{0} ha enviado su Paquete <u>Legal del Acuerdo de Servicio </u> a revisar y el e-signo</h2></td></tr>", firmName)
                msgBody.AppendFormat("<tr><td><img src='{0}://{1}/public/images/24x24_pen.gif' align='absmiddle' /><a style='color: #1E90FF' href='{2}' target='_blank'>Haga clic aquí para revisar y el e-signo.</a></td></tr>", strHTTP, svrPath, lnkUrl)
                msgBody.Append("<tr><td>Con sólo <b>un paso sencillo,</b> puede firmar electrónicamente este documento. Después de que usted e-signo el <b>Acuerdo Legal de Servicio</b>, todos los partidos recibirán un correo electrónico de la copia firmada (PDF).</td></tr>")
                msgBody.Append("<tr><td><b>Los documentos siguientes están listos para ser e-firmó:</b></td></tr>")
                msgBody.Append("<tr><td style='background-color: #E8E8E8'>")
                Dim espDocs As New List(Of String)
                For Each s As String In DocumentNameList
                    Select Case s
                        Case "CoverLetter"
                            ' don't add to list
                        Case Else
                            msgBody.Append("&nbsp;-&nbsp;" & s.Replace("LSA", "Contracto de Servicios Legales").Replace("ScheduleA", "Apéndice A").Replace("TruthInService", "Declaración de Transparencia en Servicio de Divulgación").Replace("SDAA", "Contracto de Depósito para Arreglo") & "<br/>")
                            espDocs.Add(s.Replace("LSA", "Contracto de Servicios Legales").Replace("ScheduleA", "Apéndice A").Replace("TruthInService", "Declaración de Transparencia en Servicio de Divulgación").Replace("SDAA", "Contracto de Depósito para Arreglo"))
                    End Select
                Next
                msgBody.Append("</td></tr>")
                msgBody.Append("<tr><td>&nbsp;</td></tr>")
                msgBody.AppendFormat("<tr><td style='background-color: #326FA2; border-top: solid 2px #A4D3EE; color: #fff; font-size: 11px'>Opcionalmente, si usted no puede hacer clic en el lazo encima por favor corte y pege la dirección abajo en su barra de dirección.<br />{0}</td></tr>", lnkUrl)
                msgBody.AppendFormat("<tr><td style='background-color: #326FA2; padding-top:30px' align='right'><img src='{0}://{1}/public/images/poweredby.png' /></td></tr>", strHTTP, svrPath)


                msgSubj.AppendFormat("Por favor E-firmar el {0}", Join(espDocs.ToArray, ", "))
            Case Else
                msgBody.Append("<table style='width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2' cellpadding='8' cellspacing='0'>")
                msgBody.AppendFormat("<tr><td><h2>{0} has sent your <u>Legal Service Agreement</u> Packet to review and e-Sign</h2></td></tr>", firmName)
                msgBody.AppendFormat("<tr><td><img src='{0}://{1}/public/images/24x24_pen.gif' align='absmiddle' /><a style='color: #1E90FF' href='{2}' target='_blank'>Click here to review and e-sign.</a></td></tr>", strHTTP, svrPath, lnkUrl)
                msgBody.Append("<tr><td>With just <b>one simple step,</b> you can electronically sign this document. After you e-sign the <b>Legal Service Agreement</b>, all parties will receive an emailed signed copy (PDF).</td></tr>")
                msgBody.Append("<tr><td><b>The following documents are ready to be e-signed:</b></td></tr>")
                msgBody.Append("<tr><td style='background-color: #E8E8E8'>")
                For Each s As String In DocumentNameList
                    Select Case s
                        Case "CoverLetter"
                            ' don't add to list
                        Case Else
                            msgBody.Append("&nbsp;-&nbsp;" & s.Replace("LSA", "Legal Service Agreement").Replace("ScheduleA", "Schedule A").Replace("TruthInService", "Truth In Service").Replace("SDAA", "Settlement Deposit Account Agreement") & "<br/>")
                    End Select
                Next
                msgBody.Append("</td></tr>")
                msgBody.Append("<tr><td>&nbsp;</td></tr>")
                msgBody.AppendFormat("<tr><td style='background-color: #326FA2; border-top: solid 2px #A4D3EE; color: #fff; font-size: 11px'>Optionally, if you cannot click the link above please cut and paste the address below into your address bar.<br />{0}</td></tr>", lnkUrl)
                msgBody.AppendFormat("<tr><td style='background-color: #326FA2; padding-top:30px' align='right'><img src='{0}://{1}/public/images/poweredby.png' /></td></tr>", strHTTP, svrPath)

                msgSubj.AppendFormat("Please E-sign the {0}", Join(DocumentNameList, ", "))
        End Select

        'added to bypass dc02 ccastelo 2017_11_13
        Dim MailServer As String = "smtp.gmail.com"
        Dim UserName As String = "info@lexxiom.com"
        Dim Password As String = "G>rU8LMn"

        System.Net.ServicePointManager.ServerCertificateValidationCallback = New System.Net.Security.RemoteCertificateValidationCallback(AddressOf RemoteCertificateValidationCallback)

        Dim email As New SmtpClient(MailServer, 587)

        Dim message As New MailMessage()
        message.From = New MailAddress("info@lawfirmcs.com")
        message.To.Add(New MailAddress(SendTo))
        message.Subject = msgSubj.ToString
        message.Body = msgBody.ToString

        message.IsBodyHtml = True

        'create the mail message
        Dim mail As New MailMessage()

        Try
            'make sure we have someone to send it to if all emails were invalid
            If message.To.Count > 0 Then
                Dim nc As New NetworkCredential(UserName, Password)
                email.UseDefaultCredentials = False
                email.Credentials = nc
                email.DeliveryMethod = SmtpDeliveryMethod.Network
                email.EnableSsl = True
                email.Send(message)
            End If
        Catch ex As System.Exception
            Throw ex
        End Try

        'Dim mailMsg As New System.Net.Mail.MailMessage(String.Format("{0} <info@lawfirmcs.com>", firmName), SendTo, msgSubj.ToString, msgBody.ToString)
        'Dim mailSmtp As New System.Net.Mail.SmtpClient(ConfigurationManager.AppSettings("EmailSMTP"))
        'mailMsg.IsBodyHtml = True
        'mailSmtp.Send(mailMsg)
    End Sub

    Public Shared Sub SendEsignNotificationWithPrivica(ByVal SendTo As String, ByVal DocumentNameList As String(), ByVal signingBatchID As String, ByVal RepID As Integer, ByVal leadapplicantid As String, Optional ByVal bSpanishText As Boolean = False)
        'Dim tblRepInfo As DataTable = SqlHelper.GetDataTable("select firstname + ' ' + lastname[name], emailaddress, username from tbluser where userid = " & RepID)
        Dim msgBody As New System.Text.StringBuilder
        Dim msgSubj As New System.Text.StringBuilder


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

        Dim firmName As String = ""
        Dim sqlInfo As New System.Text.StringBuilder
        sqlInfo.Append("select co.name from tblleaddocuments ld inner join tblleadapplicant la on la.leadapplicantid = ld.leadapplicantid inner join tblcompany co on co.companyid = la.companyid ")
        sqlInfo.AppendFormat("where ld.signingbatchid = '{0}'", signingBatchID)
        Using dt As DataTable = SqlHelper.GetDataTable(sqlInfo.ToString, CommandType.Text)
            For Each row As DataRow In dt.Rows
                firmName = row("name").ToString
                Exit For
            Next
        End Using

        Dim lnkUrl As String = String.Format("{0}://{1}/public/esign.aspx?sbId={2}", strHTTP, svrPath, signingBatchID)

        'build email body
        Select Case bSpanishText
            Case True
                msgBody.Append("<table style='width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2' cellpadding='8' cellspacing='0'>")
                msgBody.AppendFormat("<tr><td><h2>{0} ha enviado su Paquete <u>Legal del Acuerdo de Servicio </u> a revisar y el e-signo</h2></td></tr>", firmName)
                msgBody.AppendFormat("<tr><td><img src='{0}://{1}/public/images/24x24_pen.gif' align='absmiddle' /><a style='color: #1E90FF' href='{2}' target='_blank'>Haga clic aquí para revisar y el e-signo.</a></td></tr>", strHTTP, svrPath, lnkUrl)
                msgBody.Append("<tr><td>Con sólo <b>un paso sencillo,</b> puede firmar electrónicamente este documento. Después de que usted e-signo el <b>Acuerdo Legal de Servicio</b>, todos los partidos recibirán un correo electrónico de la copia firmada (PDF).</td></tr>")
                msgBody.Append("<tr><td><b>Los documentos siguientes están listos para ser e-firmó:</b></td></tr>")
                msgBody.Append("<tr><td style='background-color: #E8E8E8'>")
                Dim espDocs As New List(Of String)
                For Each s As String In DocumentNameList
                    Select Case s
                        Case "CoverLetter"
                            ' don't add to list
                        Case "ScheduleB"
                            ' don't add to list
                        Case Else
                            msgBody.Append("&nbsp;-&nbsp;" & s.Replace("LSA", "Contracto de Servicios Legales").Replace("ScheduleA", "Apéndice A").Replace("TruthInService", "Declaración de Transparencia en Servicio de Divulgación").Replace("SDAA", "Contracto de Depósito para Arreglo") & "<br/>")
                            espDocs.Add(s.Replace("LSA", "Contracto de Servicios Legales").Replace("ScheduleA", "Apéndice A").Replace("TruthInService", "Declaración de Transparencia en Servicio de Divulgación").Replace("SDAA", "Contracto de Depósito para Arreglo"))
                    End Select
                Next
                msgBody.Append("</td></tr>")
                msgBody.Append("<tr><td>&nbsp;</td></tr>")
                msgBody.AppendFormat("<tr><td style='background-color: #326FA2; border-top: solid 2px #A4D3EE; color: #fff; font-size: 11px'>Opcionalmente, si usted no puede hacer clic en el lazo encima por favor corte y pege la dirección abajo en su barra de dirección.<br />{0}</td></tr>", lnkUrl)
                msgBody.AppendFormat("<tr><td style='background-color: #326FA2; padding-top:30px' align='right'><img src='{0}://{1}/public/images/poweredby.png' /></td></tr>", strHTTP, svrPath)
                msgBody.Append("</td></tr>")
                msgBody.Append("<tr><td style='background-color: #FFFFFF;'>&nbsp;</td></tr>")

                Dim email2 As String
                Dim firstName As String
                Dim lastName As String

                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("LeadApplicantId", leadapplicantid))
                Dim dt As DataTable = SqlHelper.GetDataTable("stp_GetLeadInfoForPrivica", CommandType.StoredProcedure, params.ToArray)

                'fill info based on LeadApplicantID
                email2 = dt.Rows(0)("email")
                firstName = dt.Rows(0)("firstname")
                lastName = dt.Rows(0)("lastname")
                msgBody.Append("<br/><br/>")
                msgBody.Append("<table style='width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2' cellpadding='8' cellspacing='0'>")
                msgBody.Append("<tr><td><h2>Su cuenta Privica ha sido creada y está pendiente de aprobación, por ahora, aquí están sus credenciales de inicio de sesión.</h2></td></tr>")
                msgBody.AppendFormat("<tr><td><img src='{0}://{1}/public/images/24x24_pen.gif' align='absmiddle' /><a style='color: #1E90FF' href='{2}' target='_blank'>El sitio web se encuentra en: <a href=""https://privica.azurewebsites.net/login.aspx?bankverf=y"">https://privica.azurewebsites.net</a></td></tr>", strHTTP, svrPath, "https://privica.azurewebsites.net/login.aspx?bankverf=y")
                msgBody.Append("<tr><td>Nombre de usuario: " + email2 + "<br/>Contraseña: Primera letra de su nombre (en mayúscula) + " & leadapplicantid & " + últimos cuatro dígitos de su número de seguro social + primera letra de su apellido (en minúsculas) </td></tr>")
                msgBody.AppendFormat("<tr><td style='font-size: 11px'><br/><br/> <br/><br/> </td></tr>")

                msgBody.AppendFormat("<tr><td style='background-color: #2dbe60; padding-top:10px' align='left'><img src='{0}://{1}/public/images/Privica_Email_Logo.png' /></td></tr>", strHTTP, svrPath)

                msgSubj.AppendFormat("Por favor E-firmar el {0}", Join(espDocs.ToArray, ", "))
            Case Else
                msgBody.Append("<table style='width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2' cellpadding='8' cellspacing='0'>")
                msgBody.AppendFormat("<tr><td><h2>{0} has sent your <u>Legal Service Agreement</u> Packet to review and e-Sign</h2></td></tr>", firmName)
                msgBody.AppendFormat("<tr><td><img src='{0}://{1}/public/images/24x24_pen.gif' align='absmiddle' /><a style='color: #1E90FF' href='{2}' target='_blank'>Click here to review and e-sign.</a></td></tr>", strHTTP, svrPath, lnkUrl)
                msgBody.Append("<tr><td>With just <b>one simple step,</b> you can electronically sign this document. After you e-sign the <b>Legal Service Agreement</b>, all parties will receive an emailed signed copy (PDF).</td></tr>")
                msgBody.Append("<tr><td><b>The following documents are ready to be e-signed:</b></td></tr>")
                msgBody.Append("<tr><td style='background-color: #E8E8E8'>")
                For Each s As String In DocumentNameList
                    Select Case s
                        Case "CoverLetter"
                            ' don't add to list
                        Case "ScheduleB"
                            ' don't add to list
                        Case Else
                            msgBody.Append("&nbsp;-&nbsp;" & s.Replace("LSA", "Legal Service Agreement").Replace("ScheduleA", "Schedule A").Replace("TruthInService", "Truth In Service").Replace("SDAA", "Settlement Deposit Account Agreement") & "<br/>")
                    End Select
                Next
                msgBody.Append("</td></tr>")
                msgBody.Append("<tr><td>&nbsp;</td></tr>")
                msgBody.AppendFormat("<tr><td style='background-color: #326FA2; border-top: solid 2px #A4D3EE; color: #fff; font-size: 11px'>Optionally, if you cannot click the link above please cut and paste the address below into your address bar.<br />{0}</td></tr>", lnkUrl)
                msgBody.AppendFormat("<tr><td style='background-color: #326FA2; padding-top:30px' align='right'><img src='{0}://{1}/public/images/poweredby.png' /></td></tr>", strHTTP, svrPath)
                msgBody.Append("</td></tr>")
                msgBody.Append("<tr><td style='background-color: #FFFFFF;'>&nbsp;</td></tr>")

                Dim email2 As String
                Dim firstName As String
                Dim lastName As String

                Dim params As New List(Of SqlParameter)
                params.Add(New SqlParameter("LeadApplicantId", leadapplicantid))
                Dim dt As DataTable = SqlHelper.GetDataTable("stp_GetLeadInfoForPrivica", CommandType.StoredProcedure, params.ToArray)

                'fill info based on LeadApplicantID
                email2 = dt.Rows(0)("email")
                firstName = dt.Rows(0)("firstname")
                lastName = dt.Rows(0)("lastname")
                msgBody.Append("<br/><br/>")
                msgBody.Append("<table style='width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2' cellpadding='8' cellspacing='0'>")
                msgBody.Append("<tr><td><h2>Your Privica account has been created and is awaiting approval, for now, here is your login credentials.</h2></td></tr>")
                msgBody.AppendFormat("<tr><td><img src='{0}://{1}/public/images/24x24_pen.gif' align='absmiddle' /><a style='color: #1E90FF' href='{2}' target='_blank'>The website is located at: <a href=""https://privica.azurewebsites.net/login.aspx?bankverf=y"">https://privica.azurewebsites.net</a></td></tr>", strHTTP, svrPath, "https://privica.azurewebsites.net/login.aspx?bankverf=y")
                msgBody.Append("<tr><td>Username: " + email2 + "<br/>Password: First letter of your first name (Capitalized) + " & leadapplicantid & " + last four digits of your social security number + first letter of your last name (lower case) </td></tr>")
                msgBody.AppendFormat("<tr><td style='font-size: 11px'><br/><br/> <br/><br/> </td></tr>")

                msgBody.AppendFormat("<tr><td style='background-color: #2dbe60; padding-top:10px' align='left'><img src='{0}://{1}/public/images/Privica_Email_Logo.png' /></td></tr>", strHTTP, svrPath)

                msgSubj.AppendFormat("Please E-sign the {0}", Join(DocumentNameList, ", "))
        End Select

        'added to bypass dc02 ccastelo 2017_11_13
        Dim MailServer As String = "smtp.gmail.com"
        Dim UserName As String = "info@lexxiom.com"
        Dim Password As String = "G>rU8LMn"

        System.Net.ServicePointManager.ServerCertificateValidationCallback = New System.Net.Security.RemoteCertificateValidationCallback(AddressOf RemoteCertificateValidationCallback)

        Dim email As New SmtpClient(MailServer, 587)

        Dim message As New MailMessage()
        message.From = New MailAddress("info@lawfirmcs.com")
        message.To.Add(New MailAddress(SendTo))
        message.Subject = msgSubj.ToString
        message.Body = msgBody.ToString

        message.IsBodyHtml = True

        'create the mail message
        Dim mail As New MailMessage()

        Try
            'make sure we have someone to send it to if all emails were invalid
            If message.To.Count > 0 Then
                Dim nc As New NetworkCredential(UserName, Password)
                email.UseDefaultCredentials = False
                email.Credentials = nc
                email.DeliveryMethod = SmtpDeliveryMethod.Network
                email.EnableSsl = True
                email.Send(message)
            End If
        Catch ex As System.Exception
            Throw ex
        End Try

        'Dim mailMsg As New System.Net.Mail.MailMessage(String.Format("{0} <info@lawfirmcs.com>", firmName), SendTo, msgSubj.ToString, msgBody.ToString)
        'Dim mailSmtp As New System.Net.Mail.SmtpClient(ConfigurationManager.AppSettings("EmailSMTP"))
        'mailMsg.IsBodyHtml = True
        'mailSmtp.Send(mailMsg)
    End Sub


    Public Shared Function GetCurrentLeadDocument(ByVal LeadApplicantId As Integer, ByVal DocumentTypeId As Integer) As DataTable
        Dim sqlStr As String = String.Format("Select top 1 * from tblleaddocuments where currentstatus in ('Uploaded','Complete','Document signed') and leadapplicantid = {0} and documenttypeid = {1} order by completed desc", LeadApplicantId, DocumentTypeId)
        Return SqlHelper.GetDataTable(sqlStr, CommandType.Text)
    End Function

    Public Shared Sub ValidateRequiredDocuments(ByVal LeadApplicantId As Integer, ByVal DocTypes As Integer())
        Dim dt As DataTable
        For Each doctypeid As Integer In DocTypes
            dt = GetCurrentLeadDocument(LeadApplicantId, doctypeid)
            If dt.Rows.Count < 0 Then
                Throw New Exception(String.Format("Document of type {0} does not exist for this lead.", [Enum].GetName(GetType(DocType), doctypeid)))
            Else
                Dim dr As DataRow = dt.Rows(0)
                If Not System.IO.File.Exists(GetLeadDocumentFileName(dr("documentid"), doctypeid, dr("currentstatus"))) Then
                    Throw New Exception(String.Format("File with document of type {0} cannot be found for this lead.", [Enum].GetName(GetType(DocType), doctypeid)))
                End If
            End If
        Next
    End Sub

    Private Shared Function GetLeadDocumentFileName(ByVal DocumentName As String, ByVal DocumentTypeId As DocType, ByVal DocumentStatus As String) As String
        Dim extension As String = "pdf"
        Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir").ToString
        Select Case DocumentTypeId
            Case DocType.VerificationRecorded
                If DocumentStatus.ToLower = "uploaded" Then
                    path = System.IO.Path.Combine(path, "audio")
                End If
                extension = "wav"
        End Select
        Return System.IO.Path.Combine(path, String.Format("{0}.{1}", DocumentName, extension))
    End Function

    Public Shared Function RemoteCertificateValidationCallback(ByVal sender As Object, ByVal certification As System.Security.Cryptography.X509Certificates.X509Certificate, ByVal chain As System.Security.Cryptography.X509Certificates.X509Chain, ByVal sslPolicyErrors As System.Net.Security.SslPolicyErrors) As Boolean
        Return True
    End Function
#End Region

#Region "Lead Helper"

    Public Shared Function GetLeadApplicantID(ByVal ClientID As Integer) As Integer
        Dim id As Object = SqlHelper.ExecuteScalar("select l.leadapplicantid from tblclient c join tblimportedclient i on i.importid = c.serviceimportid join tblleadapplicant l on l.leadapplicantid = i.externalclientid where c.clientid = " & ClientID, CommandType.Text)
        If Not IsNothing(id) Then
            Return CInt(id)
        Else
            Return -1
        End If
    End Function

    Public Shared Function GetClientID(ByVal LeadApplicantID As Integer) As Integer
        Dim id As Object = SqlHelper.ExecuteScalar("select c.clientid from tblclient c join tblimportedclient i on i.importid = c.serviceimportid join tblleadapplicant l on l.leadapplicantid = i.externalclientid where l.leadapplicantid = " & LeadApplicantID, CommandType.Text)
        If Not IsNothing(id) Then
            Return CInt(id)
        Else
            Return -1
        End If
    End Function

    Public Shared Sub ReturnToCID(ByVal LeadApplicantID As Integer, ByVal Notes As String, ByVal ClientStatusID As Integer, ByVal UserID As Integer)
        Dim parentID As Integer = LeadRoadmapHelper.GetRoadmapID(LeadApplicantID)
        Dim clientID As Integer = CInt(SqlHelper.ExecuteScalar("select c.clientid from tblclient c join tblimportedclient i on i.importid = c.serviceimportid and i.externalclientid = " & LeadApplicantID, CommandType.Text))
        Dim username As String = CStr(SqlHelper.ExecuteScalar("select firstname + ' ' + left(lastname,1) from tbluser where userid = " & UserID, CommandType.Text))

        'Change lead status to Returned
        LeadRoadmapHelper.InsertRoadmap(LeadApplicantID, 18, parentID, "Applicant Status Changed.", UserID)
        SqlHelper.ExecuteNonQuery("update tblleadapplicant set statusid = 18 where leadapplicantid = " & LeadApplicantID, CommandType.Text)

        'Insert notes
        InsertLeadNote(username & ": " & Notes, LeadApplicantID, UserID)
        Drg.Util.DataHelpers.NoteHelper.InsertNote(username & ": " & Notes, UserID, clientID)

        'Change client status 
        RoadmapHelper.InsertRoadmap(clientID, ClientStatusID, Nothing, UserID)
        SqlHelper.ExecuteNonQuery(String.Format("update tblclient set currentclientstatusid = {0} where clientid = {1}  ", ClientStatusID, clientID), CommandType.Text)

        'Unassign the Underwriter if there is one. This client will come back to Verification in the New CID queue
        Dim taskID, taskAssignedTo As Integer
        taskAssignedTo = CInt(SqlHelper.ExecuteScalar("select isnull(AssignedUnderwriter,0) from tblclient where clientid = " & clientID, CommandType.Text))
        SqlHelper.ExecuteNonQuery("update tblClient set AssignedUnderwriter = null, AssignedUnderwriterDate = null where clientid = " & clientID, CommandType.Text)
        taskID = CInt(SqlHelper.ExecuteScalar(String.Format("select t.taskid from tblroadmap r join tblroadmaptask t on t.roadmapid = r.roadmapid join tbltask k on k.taskid = t.taskid and k.tasktypeid = 4 and k.assignedto = {0} where r.clientid = {1}", taskAssignedTo, clientID), CommandType.Text))
        TaskHelper.Delete(taskID, True)
    End Sub

    Public Shared Sub InsertLeadNote(ByVal Notes As String, ByVal LeadApplicantID As String, ByVal UserID As String)
        Dim strSQL As String = ""
        Dim cmd As SqlCommand = Nothing

        strSQL = "INSERT INTO tblLeadNotes (LeadApplicantID, notetypeid, NoteType, Value, Created, CreatedByID, Modified, ModifiedBy) " _
                           & "VALUES (" _
                           & LeadApplicantID & ", 3 ,'OTHER', '" _
                           & Notes.Replace("'", "''") & "', '" _
                           & Now & "', " _
                           & UserID & ", '" _
                           & Now & "', " _
                           & UserID & ")"

        cmd = New SqlCommand(strSQL, ConnectionFactory.Create())
        If cmd.Connection.State = ConnectionState.Closed Then
            cmd.Connection.Open()
        End If
        cmd.ExecuteNonQuery()
        cmd.Connection.Close()
        cmd = Nothing
    End Sub

    Public Shared Function GetAreaCodeInfo(ByVal AreaCode As String) As DataTable
        Return SqlHelper.GetDataTable(String.Format("Select v.stateId, s.companyid from vw_areacode_state v inner join tblstate s on s.stateid = v.stateid where areacode = '{0}'", AreaCode))
    End Function

#End Region

#Region "Phone List"

    Public Shared Sub AddMarket(ByVal market As String, ByVal userId As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("insert tblLeadMarket (Market,CreatedBy) values ('{0}',{1})", market, userId), CommandType.Text)
    End Sub

    Public Shared Function AddSource(ByVal marketId As Integer, ByVal source As String, ByVal userId As Integer) As Integer
        Dim params(2) As SqlParameter
        params(0) = New SqlParameter("LeadMarketID", marketId)
        params(1) = New SqlParameter("Source", Trim(source))
        params(2) = New SqlParameter("UserID", userId)
        Return CInt(SqlHelper.ExecuteScalar("stp_AddLeadSource", CommandType.StoredProcedure, params))
    End Function

    Public Shared Function GetMarkets() As DataTable
        Return SqlHelper.GetDataTable("select LeadMarketID,Market from tblLeadMarket order by Market")
    End Function

    Public Shared Sub RenameMarket(ByVal LeadMarketID As Integer, ByVal Market As String, ByVal UserID As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("if not exists (select 1 from tblLeadMarket where Market='{0}' and LeadMarketID={1}) begin update tblLeadMarket set Market='{2}', LastModified=getdate(), LastModifiedBy={3} where LeadMarketID={4} end", Market, LeadMarketID, Market, UserID, LeadMarketID), CommandType.Text)
    End Sub

    Public Shared Sub CombineMarkets(ByVal LeadMarketIDs() As String)
        Dim idtokeep As Integer = CInt(LeadMarketIDs(0))

        For i As Integer = 1 To LeadMarketIDs.Length - 1
            SqlHelper.ExecuteNonQuery(String.Format("update tblLeadSource set LeadMarketID={0} where LeadMarketID={1}", idtokeep, LeadMarketIDs(i)), CommandType.Text)
            SqlHelper.ExecuteNonQuery(String.Format("delete from tblLeadMarket where LeadMarketID={0}", LeadMarketIDs(i)), CommandType.Text)
        Next
    End Sub

    Public Shared Sub AddPhoneList(ByVal ForDate As String, ByVal LeadSourceID As Integer, ByVal Phone As String, ByVal Budget As Double, ByVal Actual As Double, ByVal UserID As Integer)
        Dim params(5) As SqlParameter
        params(0) = New SqlParameter("ForDate", CDate(ForDate))
        params(1) = New SqlParameter("LeadSourceID", LeadSourceID)
        params(2) = New SqlParameter("Phone", Phone)
        params(3) = New SqlParameter("Budget", Budget)
        params(4) = New SqlParameter("Actual", Actual)
        params(5) = New SqlParameter("UserID", UserID)
        SqlHelper.ExecuteNonQuery("stp_AddLeadPhoneList", CommandType.StoredProcedure, params)
    End Sub

    Public Shared Sub UpdatePhoneList(ByVal LeadPhoneListID As Integer, ByVal Phone As String, ByVal Budget As Double, ByVal Actual As Double, ByVal UserID As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("update tblLeadPhoneList set Phone='{0}', Budget={1}, Actual={2}, LastModified=getdate(), LastModifiedBy={3} where LeadPhoneListID={4}", Phone, Budget, Actual, UserID, LeadPhoneListID), CommandType.Text)
    End Sub

    Public Shared Sub RemovePhoneList(ByVal LeadPhoneListID As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("delete from tblLeadPhoneList where LeadPhoneListID={0}", LeadPhoneListID), CommandType.Text)
    End Sub

    Public Shared Sub DeletePhoneList(ByVal ForDate As String, ByVal UserID As Integer)
        SqlHelper.ExecuteNonQuery(String.Format("update tblLeadPhoneList set Deleted=1, LastModified=getdate(), LastModifiedBy={0} where ForDate='{1}'", UserID, ForDate), CommandType.Text)
    End Sub

    Public Shared Sub CopyPhoneList(ByVal CopyForDate As String, ByVal ForDate As String, ByVal UserID As Integer)
        Dim params(2) As SqlParameter
        params(0) = New SqlParameter("CopyForDate", CDate(CopyForDate))
        params(1) = New SqlParameter("ForDate", ForDate)
        params(2) = New SqlParameter("UserID", UserID)
        SqlHelper.ExecuteNonQuery("stp_CopyLeadPhoneList", CommandType.StoredProcedure, params)
    End Sub

    Public Shared Function GetPhoneList(ByVal forDate As String) As DataTable
        Dim sqlDA As SqlDataAdapter
        Dim ds As New DataSet

        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetLeadPhoneList")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "ForDate", CDate(forDate))

                sqlDA = New SqlDataAdapter(cmd)
                sqlDA.Fill(ds)
            End Using
        End Using

        Return ds.Tables(0)
    End Function

    Public Shared Function GetPhoneListDates() As DataTable
        Return SqlHelper.GetDataTable("select distinct ForDate from tblLeadPhoneList where deleted=0 order by ForDate desc")
    End Function

#End Region

#Region "Transfers"

    Public Shared Function ValidLawFirmState(ByVal StateCode As String, ByVal LawFirmId As Integer) As Boolean
        'Return CInt(SqlHelper.ExecuteScalar(String.Format("Select count(stateid) from tblstate where abbreviation = '{0}' and companyid = {1} and stateid <> -1", StateCode, LawFirmId), CommandType.Text)) > 0
        Return CInt(SqlHelper.ExecuteScalar(String.Format("select count(stateid) from tblState s join tblAttyStates a on a.State = s.Abbreviation join tblAttorney at ON at.AttorneyID = a.AttorneyID	join tblAttyRelation r ON r.AttorneyID = at.AttorneyID where(r.CompanyId = {1})	and s.Abbreviation = '{0}' and (r.AttyRelation IN ('Primary', 'Associated','Of Counsel','Employee'))", StateCode, LawFirmId), CommandType.Text)) > 0
    End Function

    Public Shared Function CreateExportJob(ByVal UserID As Integer) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_enrollment_insertLeadExportJob"
        DatabaseHelper.AddParameter(cmd, "UserId", UserID)
        Return DatabaseHelper.ExecuteScalar(cmd)
    End Function

    Public Shared Sub CreateExportDetails(ByVal JobId As Integer, ByVal clients As List(Of Integer))
        For Each LeadId As Integer In clients
            CreateExportItem(JobId, LeadId)
        Next
    End Sub

    Private Shared Function CreateExportItem(ByVal JobId As Integer, ByVal LeadApplicantId As Integer) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_enrollment_insertLeadExportDetail"
        DatabaseHelper.AddParameter(cmd, "ExportJobId", JobId)
        DatabaseHelper.AddParameter(cmd, "LeadApplicantId", LeadApplicantId)
        Return DatabaseHelper.ExecuteScalar(cmd)
    End Function

    Public Shared Sub LockClients(ByVal JobId As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.Text
        cmd.CommandText = "Update tblLeadExportDetail Set ExportStatus = 3 Where ExportJobId = " & JobId.ToString
        DatabaseHelper.ExecuteNonQuery(cmd)
    End Sub

    Public Shared Sub UnLockClients(ByVal JobId As Integer)
        Dim sb As New System.Text.StringBuilder
        sb.AppendFormat("Update tblLeadExportDetail Set ExportStatus = 0 Where ExportJobId = {0} and ExportStatus = 3", JobId.ToString)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.Text
        cmd.CommandText = sb.ToString
        DatabaseHelper.ExecuteNonQuery(cmd)
    End Sub

    Public Shared Function CreateClient(ByVal LeadApplicantId As Integer) As ClientInfo
        Dim client As New ClientInfo(LeadApplicantId)
        Dim catalog As New CatalogInfo
        Dim amountTolerance As Decimal = 999999999.99
        Dim AgencyId As Integer = 852 'Changed to Lexxiom 3/1/12
        Dim bMultiDeposit As Boolean = True

        'Get Lead Applicant Info
        Dim dtLead As DataTable = GetLead(LeadApplicantId)
        Dim drLead As DataRow
        If dtLead.Rows.Count > 0 Then
            drLead = dtLead.Rows(0)
            'Added 3/20/2015 for TKM's use of Webcorp Products
            Select Case drLead("ProductID").ToString
                Case "216", "217", "223"
                    AgencyId = 868
                Case Else
            AgencyId = GetAgencyID(drLead("ProductID"))
            End Select

        End If

        Dim dtLeadCalculator As DataTable = GetLeadCalculator(LeadApplicantId)
        Dim drLeadCalculator As DataRow
        If dtLeadCalculator.Rows.Count > 0 Then drLeadCalculator = dtLeadCalculator.Rows(0)

        Dim dtLeadBanks As DataTable = GetLeadBanks(LeadApplicantId)
        Dim drLeadBank As DataRow
        If dtLeadBanks.Rows.Count > 0 Then drLeadBank = dtLeadBanks.Rows(0)

        Dim dtLeadCreditors As DataTable = GetLeadCreditors(LeadApplicantId)
        Dim drLeadCreditors As DataRow
        If dtLeadCreditors.Rows.Count > 0 Then drLeadCreditors = dtLeadCreditors.Rows(0)

        Dim dtLeadCoApps As DataTable = GetLeadCoApplicants(LeadApplicantId)
        Dim dtLeadNotes As DataTable = GetLeadNotes(LeadApplicantId)

        'Client
        client.Agency = catalog.Agencies.FindById(AgencyId)
        If drLead("CompanyId") Is DBNull.Value Then
            Throw New Exception("No company has been assigned to this applicant")
        Else
            client.LawFirm = catalog.Lawfirms.FindById(drLead("CompanyId"))
            If client.LawFirm Is Nothing Then Throw New Exception("An invalid company has been assigned to this applicant")
        End If

        If drLead("RepId") Is DBNull.Value Then
            Throw New Exception("No Agent has been assigned to this applicant")
        Else
            Dim agent As RepresentativeInfo = RepresentativeInfo.GetRepresentativeById(drLead("RepId"))
            If Not agent Is Nothing Then
                client.AgentName = agent.FullName
            Else
                Throw New Exception("An invalid agent has been assigned to this applicant")
            End If
        End If

        If drLead("StatusId") Is DBNull.Value Then Throw New Exception("No status has been assigned to this applicant")

        'Enrollment
        Dim enrollment As New EnrollmentInfo
        enrollment.LawFirm = catalog.Lawfirms.FindById(drLead("CompanyId"))
        enrollment.Agency = catalog.Agencies.FindById(AgencyId)
        enrollment.ClientName = drLead("LeadName")
        If CleanPhoneNumber(drLead("LeadPhone").ToString).Length > 0 Then _
            enrollment.Phone = New PhoneInfo(PhoneType.home, drLead("LeadPhone"))
        enrollment.Address = New AddressInfo()
        enrollment.Address.ZipCode = drLead("LeadZip")
        enrollment.Qualified = True
        If drLeadCalculator("TotalDebt") Is DBNull.Value OrElse drLeadCalculator("TotalDebt") = 0 Then
            Throw New Exception("The total debt amount is not provided or it is zero. ")
        Else
            enrollment.TotalDebt = drLeadCalculator("TotalDebt")
        End If

        Select Case drLead("BehindId")
            Case 1, 2
                enrollment.BehindReason = BehindReasonType.current
            Case 3
                enrollment.BehindReason = BehindReasonType.late1to3months
            Case 4
                enrollment.BehindReason = BehindReasonType.late3to6months
            Case 5
                enrollment.BehindReason = BehindReasonType.latemorethan6months
            Case Else
                enrollment.BehindReason = BehindReasonType.unknown
        End Select
        If Not drLead("RepId") Is DBNull.Value Then
            enrollment.AssignedTo = RepresentativeInfo.GetRepresentativeById(drLead("RepId"))
        End If
        enrollment.Committed = True
        Select Case drLead("DeliveryId")
            Case 1
                enrollment.DeliveryMethod = DeliveryMethodType.mail
            Case 2
                enrollment.DeliveryMethod = DeliveryMethodType.email
            Case 3
                enrollment.DeliveryMethod = DeliveryMethodType.fax
            Case 4
                enrollment.DeliveryMethod = DeliveryMethodType.other
            Case Else
                enrollment.DeliveryMethod = DeliveryMethodType.unknown
        End Select
        If drLeadCalculator("DepositCommittment") Is DBNull.Value OrElse drLeadCalculator("DepositCommittment") = 0 Then Throw New Exception("Deposit commitment is not valid")
        enrollment.DepositCommitment = drLeadCalculator("DepositCommittment")
        Select Case drLead("ConcernsId")
            Case 1
                enrollment.Concern = ConcernReasonType.creditorcalls
            Case 2
                enrollment.Concern = ConcernReasonType.minimumonly
            Case 3
                enrollment.Concern = ConcernReasonType.payments
            Case 4
                enrollment.Concern = ConcernReasonType.unabletokeepup
        End Select
        client.Enrollment = enrollment

        'Primary
        Dim primaryApp As New PersonInfo()
        primaryApp.RelationshipWithPrincipalApplicant = PersonalRelationType.self
        primaryApp.CanAuthorize = True
        primaryApp.IsThirdParty = False
        primaryApp.Address = New AddressInfo()
        If drLead("Address1") Is DBNull.Value OrElse drLead("Address1").ToString.Trim.Length = 0 Then
            Throw New Exception("The applicant street address is required")
        Else
            primaryApp.Address.Street = drLead("Address1").ToString
        End If
        If drLead("City") Is DBNull.Value OrElse drLead("City").ToString.Trim.Length = 0 Then
            Throw New Exception("The applicant city is required")
        Else
            primaryApp.Address.City = drLead("City").ToString
        End If
        If drLead("StateId") Is DBNull.Value Then
            Throw New Exception("The applicant state is required")
        Else
            primaryApp.Address.USState = catalog.States.FindById(drLead("StateId"))
            If primaryApp.Address.USState Is Nothing Then Throw New Exception("An invalid state has been assigned to this applicant")

            If Not SmartDebtorHelper.ValidLawFirmState(primaryApp.Address.USState.Abbreviation.Trim.ToUpper, drLead("companyid")) Then
                Throw New System.Exception(String.Format("We don't accept clients from {0} anymore", primaryApp.Address.USState.Name))
            End If
        End If
        If drLead("ZipCode") Is DBNull.Value OrElse drLead("ZipCode").ToString.Trim.Length = 0 Then
            Throw New Exception("The applicant zip code is required")
        Else
            primaryApp.Address.ZipCode = drLead("ZipCode").ToString
        End If
        If Not drLead("DOB") Is DBNull.Value AndAlso CDate(drLead("DOB")) <> New Date(1900, 1, 1) Then
            primaryApp.DateOfBirth = drLead("DOB")
        Else
            Throw New Exception("The applicant date of birth was not provided or is invalid")
        End If
        primaryApp.Email = drLead("Email").ToString
        If drLead("FirstName") Is DBNull.Value OrElse drLead("FirstName").ToString.Trim.Length = 0 Then
            Throw New Exception("The first name is required for the primary applicant")
        Else
            primaryApp.FirstName = drLead("FirstName").ToString
        End If
        primaryApp.MiddleName = drLead("MiddleName").ToString
        If drLead("LastName") Is DBNull.Value OrElse drLead("LastName").ToString.Trim.Length = 0 Then
            Throw New Exception("The last name is required for the primary applicant")
        Else
            primaryApp.LastName = drLead("LastName").ToString
        End If
        If drLead("SSN") Is DBNull.Value OrElse CleanSSN(drLead("SSN").ToString).Length = 0 Then
            Throw New Exception("The SSN is required for the primary applicant")
        Else
            'Check the leads SSN for duplication in tblPerson
            If IsDuplicateSSN(drLead("SSN").ToString) Then Throw New Exception("There is already a client with the same SSN in the Lexxiom database.")
            primaryApp.SSN = drLead("SSN").ToString
        End If
        If drLead("LanguageId") Is DBNull.Value OrElse drLead("LanguageId") = 0 Then
            primaryApp.Language = Languages.english
        Else
            primaryApp.Language = drLead("LanguageId")
        End If
        If CleanPhoneNumber(drLead("HomePhone").ToString).Length > 0 Then _
            primaryApp.Phones.Add(New PhoneInfo(PhoneType.home, drLead("HomePhone")))
        If CleanPhoneNumber(drLead("CellPhone").ToString).Length > 0 Then _
            primaryApp.Phones.Add(New PhoneInfo(PhoneType.cell, drLead("CellPhone")))
        If CleanPhoneNumber(drLead("FaxNumber").ToString).Length > 0 Then _
            primaryApp.Phones.Add(New PhoneInfo(PhoneType.homefax, drLead("FaxNumber")))

        If primaryApp.Phones.Count = 0 OrElse (primaryApp.Phones.Count = 1 And (primaryApp.Phones(0).Type = PhoneType.homefax)) Then
            Throw New Exception("At least one phone number that is not a fax is required for the applicant")

        End If
        client.PrimaryApplicant = primaryApp

        'coapps
        client.CoApplicants = New List(Of PersonInfo)
        For Each drCoApp As DataRow In dtLeadCoApps.Rows
            Dim coApp As New PersonInfo()
            coApp.RelationshipWithPrincipalApplicant = GetPersonalRelationship(drCoApp("relationship").ToString)
            coApp.CanAuthorize = drCoApp("AuthorizationPower")
            coApp.IsThirdParty = False
            coApp.Address = New AddressInfo()

            coApp.Address.Street = drCoApp("Address").ToString
            coApp.Address.City = drCoApp("City").ToString
            coApp.Address.USState = catalog.States.FindById(drCoApp("StateId"))

            'If Not coApp.Address.USState Is Nothing AndAlso (coApp.Address.USState.Abbreviation.ToUpper = "SC") Then
            '    Throw New Exception(String.Format("We don't accept clients from {0} anymore", coApp.Address.USState.Name))
            'End If

            coApp.Address.ZipCode = drCoApp("ZipCode").ToString

            'if no address assign same as primary
            If coApp.Address.Street.Trim.Length = 0 AndAlso coApp.Address.City.Trim.Length = 0 _
                AndAlso coApp.Address.USState Is Nothing AndAlso coApp.Address.ZipCode.Trim.Length = 0 Then
                coApp.Address.Street = primaryApp.Address.Street
                coApp.Address.City = primaryApp.Address.City
                coApp.Address.USState = primaryApp.Address.USState
                coApp.Address.ZipCode = primaryApp.Address.ZipCode
            End If
            If Not drCoApp("DOB") Is DBNull.Value AndAlso CDate(drCoApp("DOB")) <> New Date(1900, 1, 1) Then
                coApp.DateOfBirth = drCoApp("DOB")
            Else
                Throw New Exception("Co-Applicant Date of Birth was not provided or is invalid")
            End If
            coApp.Email = drCoApp("Email").ToString
            If drCoApp("FirstName") Is DBNull.Value OrElse drCoApp("FirstName").ToString.Length = 0 Then
                Throw New Exception("Co-applicant first name is required")
            Else
                coApp.FirstName = drCoApp("FirstName").ToString
            End If
            coApp.MiddleName = drCoApp("MiddleName").ToString
            If drCoApp("LastName") Is DBNull.Value OrElse drCoApp("LastName").ToString.Length = 0 Then
                Throw New Exception("Co-applicant last name is required")
            Else
                coApp.LastName = drCoApp("LastName").ToString
            End If
            If drCoApp("SSN") Is DBNull.Value OrElse CleanSSN(drCoApp("SSN").ToString.Trim).Length = 0 Then
                Throw New Exception("Co-applicant SSN is required")
            Else
                If IsDuplicateSSN(drCoApp("SSN").ToString) Then Throw New Exception(String.Format("There is already a client with the same SSN of co-applicant {0} in the Lexxiom database.", coApp.FullName))
                coApp.SSN = drCoApp("SSN").ToString
            End If
            If CleanPhoneNumber(drCoApp("HomePhone").ToString).Length > 0 Then _
                coApp.Phones.Add(New PhoneInfo(PhoneType.home, drCoApp("HomePhone")))
            If CleanPhoneNumber(drCoApp("CellPhone").ToString).Length > 0 Then _
                coApp.Phones.Add(New PhoneInfo(PhoneType.cell, drCoApp("CellPhone")))
            If CleanPhoneNumber(drCoApp("FaxNumber").ToString).Length > 0 Then _
                coApp.Phones.Add(New PhoneInfo(PhoneType.homefax, drCoApp("FaxNumber")))
            client.CoApplicants.Add(coApp)
        Next

        'SetupData
        If drLead("EnrollmentPage") Is DBNull.Value Then Throw New Exception("Unknown calculator type")
        Dim enrollmentPage As String = drLead("EnrollmentPage").ToString.ToLower

        client.MultiDeposit = bMultiDeposit
        client.SetupData = New SetupInfo

        client.SetupData.DepositDays = New List(Of DepositDayInfo)
        Dim depositday As New DepositDayInfo()
        depositday.Frequency = DepositFrequencyType.month
        If drLeadCalculator("ReOccurringDepositDay") Is DBNull.Value OrElse drLeadCalculator("ReOccurringDepositDay") < 1 OrElse drLeadCalculator("ReOccurringDepositDay") > 31 Then
            Throw New Exception("Invalid re-occurring deposit day")
        Else
            depositday.DepositDay = drLeadCalculator("ReOccurringDepositDay")
        End If
        If drLeadCalculator("DepositCommittment") Is DBNull.Value OrElse drLeadCalculator("DepositCommittment") = 0 Then
            Throw New Exception("Deposit commitment is not valid")
        Else
            depositday.Amount = drLeadCalculator("DepositCommittment")
        End If
        depositday.Occurrence = 0
        client.SetupData.DepositDays.Add(depositday)
        If drLeadCalculator("DateOfFirstDeposit") Is DBNull.Value OrElse drLeadCalculator("DateOfFirstDeposit") = New Date(1900, 1, 1) Then
            Throw New Exception("The date of first desposit was not provided or is invalid.")
        ElseIf drLeadCalculator("DateOfFirstDeposit") < LocalHelper.AddBusinessDays(Now, 2) Then
            Throw New Exception("The date of first desposit must be at least 2 business days from today.")
        Else
            client.SetupData.FirstDepositDate = drLeadCalculator("DateOfFirstDeposit")
            'Determine the recurring start deposit day 
            client.SetupData.DepositsStartDate = GetDepositStartDate(client)
        End If
        client.SetupData.FirstDepositAmount = drLeadCalculator("InitialDeposit")
        client.SetupData.InitialAgencyPercent = 0

        client.SetupData.SettlementFeePercent = drLeadCalculator("SettlementFeePct")
        client.SetupData.SetupFeePercent = 0

        Select Case enrollmentPage
            Case "newenrollment.aspx"

                If drLeadCalculator("MaintenanceFee") Is DBNull.Value OrElse drLeadCalculator("MaintenanceFee") = 0 Then Throw New Exception("Maintenance Fee cannot be empty or zero")
                client.SetupData.MaintenanceFeeAmount = drLeadCalculator("MaintenanceFee")

                If drLeadCalculator("SubMaintenanceFee") Is DBNull.Value OrElse drLeadCalculator("SubMaintenanceFee") = 0 Then Throw New Exception("Subsequent Maintenance Fee cannot be empty or zero")
                client.SetupData.SubSeqMaintenanceFeeAmount = drLeadCalculator("SubMaintenanceFee")
                client.SetupData.SubSeqMaintenanceFeeStartDate = Today.AddYears(1) 'GetSubseqMaintenanceFeeStartDate(client)
                client.SetupData.AdditionalAccountFee = catalog.DefaultValues.AdditionalAccountFee
            Case "newenrollment2.aspx"

                If drLeadCalculator("ServiceFeePerAcct") Is System.DBNull.Value OrElse drLeadCalculator("ServiceFeePerAcct") < 0 Then Throw New System.Exception("Maintenance Fee cannot be empty or less than zero")
                client.SetupData.MaintenanceFeeAmount = drLeadCalculator("ServiceFeePerAcct")

                If drLeadCalculator("MaintenanceFeeCap") Is System.DBNull.Value OrElse drLeadCalculator("MaintenanceFeeCap") < 0 Then Throw New System.Exception("Maximum Maintenance Fee cannot be empty or less than zero")
                client.SetupData.MaintenanceFeeCap = drLeadCalculator("MaintenanceFeeCap")
                client.SetupData.AdditionalAccountFee = 0

            Case Else
                Throw New Exception("Unknown calculator type: " & enrollmentPage)
        End Select

        'BankAccounts
        Dim ignorebank As Boolean 'If true, do not create a bank object
        If Not drLeadBank Is Nothing AndAlso drLeadBank("ACH") Then
            client.SetupData.DepositMethod = DepositMethodType.ach
            ignorebank = False
        Else
            client.SetupData.DepositMethod = DepositMethodType.check
            ignorebank = (drLeadBank Is Nothing) OrElse ((drLeadBank("AccountNumber") Is DBNull.Value OrElse drLeadBank("AccountNumber").ToString.Trim.Length = 0) AndAlso (drLeadBank("RoutingNumber") Is DBNull.Value OrElse drLeadBank("RoutingNumber").ToString.Trim.Length = 0))
        End If

        If Not ignorebank Then
            Dim bankaccount As New BankAccountInfo
            If drLeadBank("AccountNumber") Is DBNull.Value OrElse drLeadBank("AccountNumber").ToString.Trim.Length = 0 Then
                Throw New Exception("The bank account number is required.")
            Else
                bankaccount.AccountNumber = drLeadBank("AccountNumber")
            End If
            If drLeadBank("RoutingNumber") Is DBNull.Value OrElse drLeadBank("RoutingNumber").ToString.Trim.Length = 0 Then
                Throw New Exception("The bank routing number is required.")
            Else
                If drLeadBank("RoutingNumber").ToString.Trim.Length <> 9 Then Throw New Exception("The bank routing number must have 9 digits!")
                bankaccount.RoutingNumber = drLeadBank("RoutingNumber")
            End If

            bankaccount.Address = New AddressInfo
            bankaccount.Address.Street = drLeadBank("Street").ToString
            bankaccount.Address.Street2 = drLeadBank("Street2").ToString
            bankaccount.Address.City = drLeadBank("City").ToString
            bankaccount.Address.USState = catalog.States.FindById(drLeadBank("StateId"))
            bankaccount.Address.ZipCode = drLeadBank("ZipCode").ToString

            If drLeadBank("BankName") Is DBNull.Value OrElse drLeadBank("BankName").ToString.Trim.Length = 0 Then
                Throw New Exception("The bank name is required")
            Else
                bankaccount.Name = drLeadBank("BankName")
            End If
            If CleanPhoneNumber(drLeadBank("PhoneNumber").ToString).Length > 0 Then
                bankaccount.Phone = New PhoneInfo(PhoneType.business, drLeadBank("PhoneNumber"))
                bankaccount.Phone.Extension = drLeadBank("Extension").ToString
            End If
            If drLeadBank("Checking") OrElse drLeadBank("Checking") Is DBNull.Value Then
                bankaccount.Type = BankAccountType.checking
            Else
                bankaccount.Type = BankAccountType.savings
            End If
            client.BankAccounts = New List(Of BankAccountInfo)
            client.BankAccounts.Add(bankaccount)
            client.PrimaryBank = bankaccount
        End If

        depositday.DepositMethod = client.SetupData.DepositMethod
        If depositday.DepositMethod = DepositMethodType.ach Then depositday.BankAccount = client.PrimaryBank

        'Creditor Accounts
        If dtLeadCreditors.Rows.Count > 0 Then

            'Throw New Exception("There are no creditors entered for this applicant.")
            client.Accounts = New List(Of AccountInfo)
            For Each draccount As DataRow In dtLeadCreditors.Rows
                Dim account = New AccountInfo
                account.AccountNumber = draccount("AccountNumber")
                account.Acquired = Today
                If draccount("Balance") Is DBNull.Value OrElse draccount("Balance") = 0 Then
                    Throw New Exception("The account balance cannot be empty or zero")
                Else
                    account.Balance = draccount("Balance")
                End If
                account.DueDate = Today
                account.Creditor = New CreditorInfo
                If draccount("CreditorId") <> -1 Then
                    account.Creditor.Id = draccount("CreditorId")
                End If
                If Not draccount("CreditorGroupId") Is DBNull.Value Then
                    account.Creditor.GroupId = draccount("CreditorGroupId")
                End If
                account.Creditor.CreatedBy = draccount("CreatedBy")
                account.Creditor.CreatedDate = draccount("Created")
                account.Creditor.LastModifiedBy = draccount("ModifiedBy")
                account.Creditor.LastModifiedDate = draccount("Modified")
                If draccount("Name") Is DBNull.Value OrElse draccount("Name").ToString.Trim.Length = 0 Then
                    Throw New Exception("The creditor name is required")
                Else
                    account.Creditor.Name = draccount("Name")
                End If
                account.Creditor.Address = New AddressInfo
                account.Creditor.Address.Street = draccount("Street")
                account.Creditor.Address.Street2 = draccount("Street2")
                account.Creditor.Address.City = draccount("City")
                If draccount("StateId") Is DBNull.Value OrElse draccount("StateId") = 0 Then
                    'Throw New Exception("The creditor state is required")
                Else
                    account.Creditor.Address.USState = catalog.States.FindById(draccount("StateId"))
                    If account.Creditor.Address.USState Is Nothing Then Throw New Exception("An invalid state has been assigned to creditor")
                End If
                account.Creditor.Address.ZipCode = draccount("ZipCode")

                If CleanPhoneNumber(draccount("Phone").ToString).Length > 0 Then
                    account.Creditor.Phone = New PhoneInfo(PhoneType.business, draccount("Phone"))
                    account.Creditor.Phone.Extension = draccount("Ext").ToString
                End If
                client.Accounts.Add(account)
            Next
        Else
            Throw New Exception("There are no creditors entered for this applicant.")
        End If

        'Validate debt sum
        'If Math.Abs(client.DebtSum - client.Enrollment.TotalDebt) > amountTolerance Then
        'Throw New Exception("The total debt amount and the sum of all account balances do not match")
        'End If

        'client.AgencyExtraFields 
        client.AgencyExtraFields = New AgencyExtensionData
        With client.AgencyExtraFields
            .DebtTotal = drLeadCalculator("TotalDebt")
            If Not drLead("LeadTransferInDate") Is DBNull.Value Then
                .DateReceived = drLead("LeadTransferInDate")
            Else
                .DateReceived = Now
            End If
            If Not drLead("LeadTransferOutDate") Is DBNull.Value Then
                .DateSent = drLead("LeadTransferOutDate")
            Else
                .DateSent = Now
            End If
            .LeadNumber = drLead("LeadApplicantId")
        End With

        'notes
        Dim note As NoteInfo
        client.Notes = New List(Of NoteInfo)
        For Each drnote As DataRow In dtLeadNotes.Rows
            note = New NoteInfo
            note.ExternalId = drnote("LeadNoteId")
            note.ExternalSource = "tblLeadNotes"
            note.DateCreated = drnote("Created")
            note.CreatedBy = RepresentativeInfo.GetRepresentativeById(drnote("CreatedById"))
            note.LastModifiedDate = drnote("Modified")
            note.LastModifiedBy = RepresentativeInfo.GetRepresentativeById(drnote("ModifiedBy"))
            note.Subject = drnote("Subject").ToString
            note.Text = drnote("Value").ToString
            client.Notes.Add(note)
        Next

        'If Now >= #12/01/2010# Then
        '    client.RemittanceName = "Woolery Accountancy"
        'Else
        client.RemittanceName = "Bank of America NT & SA"
        'End If

        Return client
    End Function

    Public Shared Sub SaveReport(ByVal JobId As Integer, ByVal report As ImportReport, ByVal UserID As Integer)
        If Not report Is Nothing Then
            Dim exceptionnote As String = String.Empty
            If Not report.ProcessException Is Nothing Then
                exceptionnote = report.ProcessException.Message.Trim
            End If
            UpdateReportStatus(JobId, report.Status, exceptionnote)
            'Update export status for applicants
            If Not report.SuccededClients Is Nothing Then
                For Each client As ClientInfo In report.SuccededClients
                    UpdateLeadStatus(JobId, client.ExternalID, client.ClientImportStatus, "")
                    UpdateLeadApplicantTransferOut(client.ExternalID)
                    Try
                        ClientDocTransfer(client.Id, client.ExternalID, UserID)
                    Catch ex As Exception
                        exceptionnote = "Exported but transfer of documents failed: " & ex.Message
                        UpdateLeadStatus(JobId, client.ExternalID, client.ClientImportStatus, exceptionnote)
                    End Try
                Next
            End If
            If Not report.FailedClients Is Nothing Then
                For Each client As ClientInfo In report.FailedClients
                    If Not client.ClientImportException Is Nothing Then
                        exceptionnote = client.ClientImportException.Message.Trim
                    End If
                    UpdateLeadStatus(JobId, client.ExternalID, client.ClientImportStatus, exceptionnote)
                Next
            End If
        End If
    End Sub

    Private Shared Sub ExtractPOAFromLSA(ByVal ClientID As Integer, ByVal UserID As Integer, ByVal sourceFile As String, ByVal destDir As String)
        Dim lsaPath As String = sourceFile
        Dim lsa As New iTextSharp.text.pdf.PdfReader(lsaPath)
        Dim lastPageIdx As Integer = lsa.NumberOfPages
        lsa.Close()
        lsa = Nothing
        'build new poapath
        Dim poaPath As String = String.Format("{0}{1}", destDir, ReportsHelper.GetUniqueDocumentName(ClientID, "9019"))
        Select Case lastPageIdx
            Case 11, 13, 14
                lastPageIdx = 11
            Case 18, 19
                lastPageIdx = 7
        End Select

        PdfManipulation.ExtractPdfPage(lsaPath, lastPageIdx, poaPath)

        Dim intNoteID As Integer = NoteHelper.InsertNote("Automated POA  extraction from LSA.", -1, ClientID)
        'attach creditor copy of letter
        SharedFunctions.DocumentAttachment.AttachDocument(ClientID, "note", intNoteID, Path.GetFileName(poaPath), UserID)
        SharedFunctions.DocumentAttachment.AttachDocument(ClientID, "client", ClientID, Path.GetFileName(poaPath), UserID)
        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(poaPath), UserID, Now)
    End Sub

    Private Shared Sub ClientDocTransfer(ByVal ClientID As Integer, ByVal LeadApplicantId As Integer, ByVal UserID As Integer)
        Dim sourceFile, destFile As String
        'Dim destDir As String = SharedFunctions.DocumentAttachment.CreateDirForClient(ClientID) & "ClientDocs\"
        Dim docName As String
        Dim tblDocs As DataTable = GetLeadDocuments(LeadApplicantId)

        For Each row As DataRow In tblDocs.Rows
            'sourceFile = ConfigurationManager.AppSettings("LeadDocumentsDir").ToString & String.Format("{0}.pdf", row("DocumentId"))

            Dim typeID As String = row("TypeID")

            Try
                If typeID = "9073" Then
                    sourceFile = ConfigurationManager.AppSettings("LeadDocumentsVirtualDir").ToString & String.Format("audio/{0}", row("DocumentId"))
                    sourceFile = sourceFile & ".wav"
                    'add ccastelo 1/15/2013 - 
                    CallVerificationHelper.UpdateClientId(LeadApplicantId, ClientID)
                Else
                    sourceFile = ConfigurationManager.AppSettings("LeadDocumentsVirtualDir").ToString & String.Format("{0}", row("DocumentId"))
                    sourceFile = sourceFile & ".pdf"
                End If

            Catch ex As System.Exception
                Continue For
            End Try

            Dim accountno As String

            Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
                Using cmd.Connection
                    cmd.CommandText = "SELECT accountnumber FROM tblClient WHERE ClientId = " + ClientID.ToString()
                    cmd.Connection.Open()
                    accountno = cmd.ExecuteScalar()
                End Using
            End Using

            If IO.File.Exists(sourceFile) Then
                'Dim typeID As String = row("TypeID")
                docName = ReportsHelper.GetUniqueDocumentName(ClientID, typeID, IO.Path.GetExtension(sourceFile))
                'destFile = destDir & docName
                'IO.File.Copy(sourceFile, destFile)

                Using inFile As New System.IO.FileStream(sourceFile, IO.FileMode.Open, IO.FileAccess.Read)
                    Dim filename As String = docName
                    AzureStorageHelper.ExportClientUpload(inFile, docName, accountno, "ClientDocs")
                End Using
                SharedFunctions.DocumentAttachment.AttachDocument("client", ClientID, docName, UserID, row("DocFolder"))
                SharedFunctions.DocumentAttachment.CreateScan(docName, UserID, CDate(row("Received")), "")
                If typeID = "9073" Then
                    CallVerificationHelper.UpdateRecordedCallPath(ClientID, String.Format("https://lexxwarestore1.blob.core.windows.net/clientdocs/{0}/ClientDocs/{1}", accountno, docName), False)
                End If
                'extract POA
                If typeID = "SD0001" Then
                    Try
                        'Not Setup For Cloud
                        'ExtractPOAFromLSA(ClientID, UserID, sourceFile, destDir)
                    Catch ex As System.Exception
                        Continue For
                    End Try
                End If
            End If
        Next
    End Sub

#Region "Build each tables data"

    Private Shared Function GetData(ByVal cmdText As String) As DataTable
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.Text
        cmd.CommandText = cmdText
        Dim ds As DataSet = DatabaseHelper.ExecuteDataset(cmd)
        Return ds.Tables(0)
    End Function

    Private Shared Function GetAgencyID(ByVal ProductId As Integer) As Integer
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.Text
        cmd.CommandText = String.Format("select isnull(v.agencyid,852) from tblleadvendors v join tblleadproducts p on p.vendorid = v.vendorid and p.productid = {0}", ProductId)
        Return CInt(DatabaseHelper.ExecuteScalar(cmd))
    End Function

    Private Shared Function GetLead(ByVal LeadId As Integer) As DataTable
        Dim sb As New System.Text.StringBuilder
        sb.AppendFormat("select * from tblLeadApplicant where LeadApplicantId = {0}", LeadId)
        Return GetData(sb.ToString)
    End Function

    Private Shared Function GetLeadCalculator(ByVal LeadId As Integer) As DataTable
        Dim sb As New System.Text.StringBuilder
        sb.AppendFormat("select * from tblLeadCalculator where LeadApplicantId = {0}", LeadId)
        Return GetData(sb.ToString)
    End Function

    Private Shared Function GetLeadBanks(ByVal LeadId As Integer) As DataTable
        Dim sb As New System.Text.StringBuilder
        sb.AppendFormat("select * from tblLeadBanks where LeadApplicantId = {0}", LeadId)
        Return GetData(sb.ToString)
    End Function

    Private Shared Function GetLeadCreditors(ByVal LeadId As Integer) As DataTable
        Dim sb As New System.Text.StringBuilder
        sb.AppendFormat("select * from tblLeadCreditorInstance where LeadApplicantId = {0} and represented = 1", LeadId)
        Return GetData(sb.ToString)
    End Function

    Private Shared Function GetLeadCoApplicants(ByVal LeadId As Integer) As DataTable
        Dim sb As New System.Text.StringBuilder
        sb.AppendFormat("select * from tblLeadCoApplicant where LeadApplicantId = {0}", LeadId)
        Return GetData(sb.ToString)
    End Function

    Private Shared Function GetLeadNotes(ByVal LeadId As Integer) As DataTable
        Dim sb As New System.Text.StringBuilder
        sb.AppendFormat("select * from tblLeadNotes where LeadApplicantId = {0} Order By LeadNoteId", LeadId)
        Return GetData(sb.ToString)
    End Function

    Private Shared Function GetUser(ByVal UserId As Integer) As DataTable
        Dim sb As New System.Text.StringBuilder
        sb.AppendFormat("select * from tblUser where UserId = {0}", UserId)
        Return GetData(sb.ToString)
    End Function

    Public Shared Sub UpdateLeadStatus(ByVal JobId As Integer, ByVal LeadApplicantId As Integer, ByVal Status As Integer, ByVal Note As String)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_enrollment_updateLeadExportDetail"
        DatabaseHelper.AddParameter(cmd, "ExportJobId", JobId)
        DatabaseHelper.AddParameter(cmd, "LeadApplicantId", LeadApplicantId)
        DatabaseHelper.AddParameter(cmd, "ExportStatus", Status)
        If Note.Trim.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Note", Note.Trim)
        DatabaseHelper.ExecuteNonQuery(cmd)
    End Sub

    Public Shared Sub UpdateLeadStatusForExport(ByVal JobId As Integer, ByVal LeadApplicantId As Integer, ByVal Status As Integer, ByVal Note As String)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_enrollment_updateLeadExportDetail"
        DatabaseHelper.AddParameter(cmd, "ExportJobId", JobId)
        DatabaseHelper.AddParameter(cmd, "LeadApplicantId", LeadApplicantId)
        DatabaseHelper.AddParameter(cmd, "ExportStatus", Status)
        If Note.Trim.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Note", Note.Trim)
        DatabaseHelper.ExecuteNonQuery(cmd)
    End Sub

    Public Shared Sub UpdateReportStatus(ByVal JobId As Integer, ByVal Status As Integer, ByVal Note As String)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.StoredProcedure
        cmd.CommandText = "stp_enrollment_updateLeadExportJob"
        DatabaseHelper.AddParameter(cmd, "ExportJobId", JobId)
        DatabaseHelper.AddParameter(cmd, "Status", Status)
        If Note.Trim.Length > 0 Then DatabaseHelper.AddParameter(cmd, "Notes", Note.Trim)
        DatabaseHelper.ExecuteNonQuery(cmd)
    End Sub

    Private Shared Sub UpdateLeadApplicantTransferOut(ByVal LeadApplicantId As Integer)
        Dim cmd As IDbCommand = ConnectionFactory.Create.CreateCommand()
        cmd.CommandType = CommandType.Text
        cmd.CommandText = String.Format("Update tblLeadApplicant Set LeadTransferOutDate = GetDate() Where LeadApplicantId = {0}", LeadApplicantId.ToString)
        DatabaseHelper.ExecuteNonQuery(cmd)
    End Sub

    Private Shared Function GetLeadDocuments(ByVal LeadApplicantId As Integer) As DataTable
        Dim cmdText As String = String.Format("select d.DocumentId, t.TypeID, t.DocFolder, isnull(d.Completed,d.Submitted) [Received] from tblLeadDocuments d join tblDocumentType t on t.DocumentTypeID = d.DocumentTypeID where d.LeadApplicantId={0} and d.Completed is not null", LeadApplicantId)
        Return SqlHelper.GetDataTable(cmdText)
    End Function

#End Region

#Region "Validation routines"

    'strip out the invalid characters   
    Public Shared Function CleanPhoneNumber(ByVal phonenumber As String) As String
        Return phonenumber.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "").Trim
    End Function

    Private Shared Function CleanSSN(ByVal SSN As String) As String
        Return SSN.Replace("-", "").Replace(" - ", "").Replace(" ", "").Trim
    End Function

    Private Shared Function CleanPhone(ByVal Phone As String) As String
        Return Phone.Replace("-", "").Replace("(", "").Replace(")", "").Replace(" ", "").Trim
    End Function

#End Region

#Region "Other"

    Private Shared Function GetDepositStartDate(ByVal client As ClientInfo) As DateTime
        Dim depositday As Integer
        Dim mindepositdate As Date = client.SetupData.FirstDepositDate.AddDays(21)
        Dim depositdate As Date
        Dim startdepdate As Nullable(Of Date)
        Dim lastdayofmonth As Integer
        For Each depday As DepositDayInfo In client.SetupData.DepositDays
            depositdate = mindepositdate
            Do
                depositday = depday.DepositDay
                lastdayofmonth = DateTime.DaysInMonth(depositdate.Year, depositdate.Month)
                If depositday > lastdayofmonth Then depositday = lastdayofmonth
                depositdate = New Date(depositdate.Year, depositdate.Month, depositday)
                If depositdate >= mindepositdate Then
                    Exit Do
                End If
                depositdate = depositdate.AddMonths(1)
            Loop
            If Not startdepdate.HasValue OrElse startdepdate.Value > depositdate Then
                startdepdate = depositdate
            End If
        Next
        If Not startdepdate.HasValue Then startdepdate = mindepositdate
        Return startdepdate.Value
    End Function

    Private Shared Function GetPersonalRelationship(ByVal Relationship As String) As String
        Dim relation As PersonalRelationType = PersonalRelationType.unknown
        If Not Relationship Is Nothing AndAlso Relationship.Trim.Length > 0 Then
            Select Case Relationship.Trim.ToLower
                Case "spouse"
                    relation = PersonalRelationType.spouse
                Case "father"
                    relation = PersonalRelationType.father
                Case "mother"
                    relation = PersonalRelationType.mother
                Case "brother"
                    relation = PersonalRelationType.brother
                Case "sister"
                    relation = PersonalRelationType.sister
                Case "son"
                    relation = PersonalRelationType.son
                Case "daughter"
                    relation = PersonalRelationType.daughter
                Case "coworker"
                    relation = PersonalRelationType.coworker
                Case "friend"
                    relation = PersonalRelationType.friend
                Case "other"
                    relation = PersonalRelationType.other
                Case Else
                    relation = PersonalRelationType.unknown
            End Select
        End If
        Return relation
    End Function

    Private Shared Function IsDuplicateSSN(ByVal SSN As String) As Boolean
        Dim duplicate As Boolean = False
        SSN = CleanSSN(SSN)
        If SSN.Length > 0 Then
            Dim sql As New System.Text.StringBuilder()
            sql.AppendLine("Select Top 1 p.SSN From tblPerson p ")
            'sql.AppendLine(" join tblclient c on p.clientid = c.clientid and c.currentclientstatusid not in (17, 18)")
            sql.AppendFormat(" Where replace(replace(p.SSN, '-', ''),' ', '') in ('{0}')", SSN)
            Using cmd As New SqlCommand(sql.ToString, ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()
                    Dim SSN1 As String = cmd.ExecuteScalar
                    cmd.Connection.Close()
                    duplicate = (Not SSN1 Is Nothing AndAlso SSN1.Length > 0)
                End Using
            End Using
        End If
        Return duplicate
    End Function

    Private Shared Function IsDuplicateSSN(ByVal SSN As String, ByVal LeadID As Integer) As Boolean
        Dim duplicate As Boolean = False
        SSN = CleanSSN(SSN)
        If SSN.Length > 0 Then
            Dim sql As New System.Text.StringBuilder()
            sql.AppendLine("Select Top 1 p.SSN From tblPerson p ")
            sql.AppendLine("join tblclient c on c.clientid = p.clientid ")
            sql.AppendLine("left join vw_leadapplicant_client w on w.clientid = c.clientid ")
            sql.AppendFormat(" Where replace(replace(p.SSN, '-', ''),' ', '') in ('{0}') ", SSN)
            sql.AppendFormat(" and (w.leadapplicantid is null or w.leadapplicantid <> {0})", LeadID)
            Using cmd As New SqlCommand(sql.ToString, ConnectionFactory.Create())
                Using cmd.Connection
                    cmd.Connection.Open()
                    Dim SSN1 As String = cmd.ExecuteScalar
                    cmd.Connection.Close()
                    duplicate = (Not SSN1 Is Nothing AndAlso SSN1.Length > 0)
                End Using
            End Using
        End If
        Return duplicate
    End Function

    Private Shared Function IsDuplicatePhone(ByVal Phone As String, ByVal LeadID As Integer, ByVal UserID As Integer) As Boolean
        Dim duplicate As Boolean = False

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("userId", UserID))
        params.Add(New SqlParameter("LeadId", LeadID))
        params.Add(New SqlParameter("phoneNumber", Phone))

        Try
            Dim dt As DataTable = SqlHelper.GetDataTable("stp_getDuplicateLeads", CommandType.StoredProcedure, params.ToArray)
            If dt.Rows.Count > 0 Then
                duplicate = True
        End If
        Catch ex As Exception

        End Try
        Return duplicate
    End Function

    Public Shared Function GetTrustID(ByVal CompanyID As String) As Integer
        Return SqlHelper.ExecuteScalar(String.Format("SELECT TrustID FROM vw_Trust_Company WHERE EffectiveStartDate <= GETDATE()  AND CompanyID = {0} AND (EffectiveEndDate IS NULL OR EffectiveEndDate > GETDATE())", CompanyID), CommandType.Text)
    End Function

    Public Shared Function InsertTrustID(ByVal TrustID As Integer, ByVal ApplicantID As Integer) As Boolean
        Try
            DataHelper.FieldUpdate("tblLeadApplicant", "LSATrustID", TrustID)
        Catch ex As Exception
            Return False
        End Try
        Return True
    End Function

    Public Shared Sub SendToAttorney(ByVal ClientId As Integer, ByVal UserID As Integer)
        'Run this to Skip verification sheet 
        Using cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()
            DatabaseHelper.AddParameter(cmd, "VWUWSaved", Now)
            DatabaseHelper.AddParameter(cmd, "VWUWSavedBy", UserID)
            DatabaseHelper.AddParameter(cmd, "VWUWResolved", Now)
            DatabaseHelper.AddParameter(cmd, "VWUWResolvedBy", UserID)
            DatabaseHelper.AddParameter(cmd, "LastModified", Now)
            DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))
            DataHelper.AuditedUpdate(cmd, "tblClient", ClientId, UserID)
        End Using

        'Finish Underwriting
        RoadmapHelper.InsertRoadmap(ClientId, 11, Nothing, UserID) 'Verification Complete
        RoadmapHelper.InsertRoadmap(ClientId, 15, "Pending client verification", UserID) 'Inactive

        'used by attorney portal
        SqlHelper.ExecuteNonQuery(String.Format("insert tblPendingApproval (ClientID) values ({0})", ClientId), CommandType.Text)

        'get any currently-assigned customer service rep
        Dim AssignedCSRep As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblClient", "AssignedCSRep", "ClientID = " & ClientId))

        'do we even use this for anything anymore?? we used to create a task for this rep
        If AssignedCSRep = 0 Then
            'get this client's preferred language
            Dim LanguageID As Integer = DataHelper.Nz_int(DataHelper.FieldLookup("tblPerson", "LanguageID", "PersonID = " & ClientHelper.GetDefaultPerson(ClientId)))

            'get the next CS Rep who speaks this language
            Dim CSRepUserID As Integer = UserHelper.GetNextUser(LanguageID, 3)

            'assign underwriter on client record
            ClientHelper.UpdateField(ClientId, "AssignedCSRep", CSRepUserID, UserID)
        End If

        'update search results table for this client
        ClientHelper.LoadSearch(ClientId)
    End Sub

    Public Shared Function GetCIDReports(ByVal UserId As Integer) As DataTable
        Dim sqlParams As SqlParameter() = New SqlParameter() {New SqlParameter With {.ParameterName = "@UserId", .DbType = DbType.Int32, .Value = UserId}}
        Return SqlHelper.GetDataTable("stp_GetAllowedCIDReports", CommandType.StoredProcedure, sqlParams)
    End Function

    Public Shared Function IsDuplicate_SSN(ByVal SSN As String) As Boolean
        Return IsDuplicateSSN(SSN)
    End Function

    Public Shared Function IsDuplicate_SSN(ByVal SSN As String, ByVal LeadId As Integer) As Boolean
        Return IsDuplicateSSN(SSN, LeadId)
    End Function

    Public Shared Function IsDuplicate_Phone(ByVal Phone As String, ByVal LeadId As Integer, ByVal UserId As Integer) As Boolean
        Return IsDuplicatePhone(Phone, LeadId, UserId)
    End Function

    Public Shared Function IsITIN(ByVal SSN As String) As Boolean
        Dim n As String = SSN.Replace("-", "").Replace(" ", "").Trim
        Return n.Length = 9 AndAlso Int64.TryParse(n, Nothing) AndAlso Left(n, 1) = "9"
    End Function

#End Region

#End Region

End Class
