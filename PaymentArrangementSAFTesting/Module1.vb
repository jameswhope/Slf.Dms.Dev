Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports Slf.Dms.Records

Imports System.Data
Imports System.Drawing
Imports System.Collections.Generic
Imports Slf.Dms.Controls
Imports System.Data.SqlClient
Imports LexxiomLetterTemplates
Imports System.IO

Module Module1

    Sub Main()

    End Sub

    Public Sub PrintSAF(sender As Object, e As System.EventArgs)

        Dim rpt As New LetterTemplates(ConfigurationManager.AppSettings("connectionstring").ToString)

        Dim ClientId As Integer = lblClient.Text

        Dim rDoc As DataDynamics.ActiveReports.Document.Document
        If lblLanguage.Text = "Spanish" Then
            rDoc = rpt.Generate_LexxSign_GlobalTrustTranfer_Print(ClientId, 1265, "2105", False, True)
        Else
            rDoc = rpt.Generate_LexxSign_GlobalTrustTranfer_Print(ClientId, 1265, "2105", False)
        End If


        Dim memStream As New System.IO.MemoryStream()
        Dim pdf As New DataDynamics.ActiveReports.Export.Pdf.PdfExport

        pdf.Export(rDoc, memStream)
        memStream.Seek(0, IO.SeekOrigin.Begin)

        Session("LSAAgreement") = memStream.ToArray

        Dim _sb As New System.Text.StringBuilder()
        _sb.Append("window.open('Clients/Enrollment/viewLSA.aspx?type=lsa','',")
        _sb.Append("'toolbar=0,menubar=0,resizable=yes');")
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "winOpen", _sb.ToString(), True)

    End Sub

    Public Sub lnkEmail_Click(sender As Object, e As System.EventArgs)

        Dim dlist As New List(Of String)
        dlist.Add("Global Trust Transfer")

        Dim ClientId As Integer = lblClient.Text

        Dim docList As New List(Of LetterTemplates.BatchTemplate)   'holds returned documents to process
        Dim rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
        Dim dir As String = CreateDirForClient(ClientId)
        Dim docId As String = GetDocID()
        Dim filePath As String = BuildAttachmentPath("CD0001", docId, Now.ToString("yyMMdd"), ClientId)
        Dim email As String = lblEmails.Text
        Dim Spanish As Boolean = IIf(lblLanguage.Text = "Spanish", 1, 0)

        Dim rArgs As String = "GlobalTrustTransfer," & ClientId
        Dim args As String() = rArgs.Split(",")

        docList.AddRange(rptTemplates.Generate_LexxSign_GlobalTrustTranfer_Email(ClientId, 1265, "2105"))

        'get new unique signing batch id
        Dim signingBatchId As String = Guid.NewGuid.ToString

        'stores the names of the reports
        Dim dNames As New List(Of String)

        'needed to check for duplicate documents
        Dim docIDs As New Hashtable

        For Each doc As LetterTemplates.BatchTemplate In docList
            If doc.TemplateName.StartsWith("Signing") Then

            End If
        Next

        'only get documents that need signatures

        For Each Doc As LetterTemplates.BatchTemplate In docList
            If Not Doc.TemplateName.StartsWith("Signing") Then
                'assign new doc  id
                Dim documentId As String = Guid.NewGuid.ToString
                docIDs.Add(Doc.TemplateName.Replace("Signing_", ""), documentId)

                'export html docs for gui navigation
                Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.html", documentId)
                Using finalHTML As New DataDynamics.ActiveReports.Export.Html.HtmlExport
                    finalHTML.OutputType = DataDynamics.ActiveReports.Export.Html.HtmlOutputType.DynamicHtml
                    finalHTML.IncludeHtmlHeader = False
                    finalHTML.IncludePageMargins = False
                    finalHTML.Export(Doc.TemplateRpt.Document, path)
                End Using

                'need matching pdf for final signing process
                If Not Doc.NeedSignature Then
                    path = ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.pdf", documentId)
                    Using finalPDF As New DataDynamics.ActiveReports.Export.Pdf.PdfExport
                        finalPDF.Export(Doc.TemplateRpt.Document, path)
                    End Using
                End If

                'save document to db
                Dim docTid As String = "CD0001" 'rptTemplates.GetDocTypeID("GlobalTrustTransfer")
                LexxSignHelper.NonCID.SaveLexxSignDocument(ClientId, documentId, 1265, docTid, signingBatchId, email, 21, ClientId)
                dNames.Add(Doc.TemplateName)

            End If
        Next

        For Each Doc As LetterTemplates.BatchTemplate In docList
            If Doc.TemplateName.StartsWith("Signing") Then
                Dim templateName As String = Doc.TemplateName.Replace("Signing_", "")
                If docIDs.Contains(templateName) Then
                    Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.pdf", docIDs(templateName))
                    Using finalPDF As New DataDynamics.ActiveReports.Export.Pdf.PdfExport
                        finalPDF.Export(Doc.TemplateRpt.Document, path.Replace(".html", ".pdf"))
                    End Using
                End If

            End If
        Next

        'send notification to client
        SendEsignNotification(email, dNames.ToArray, signingBatchId, UserID, Spanish)

    End Sub

    Protected Sub SendEsignNotification(ByVal SendTo As String, ByVal DocumentNameList As String(), ByVal signingBatchID As String, ByVal RepID As Integer, Optional ByVal bSpanishText As Boolean = False)
        'Dim tblRepInfo As DataTable = SqlHelper.GetDataTable("select firstname + ' ' + lastname[name], emailaddress, username from tbluser where userid = " & RepID)

        Dim msgSubj As String = "Personal and Confidential: Message From Thomas Kerns McKnight, Esq."

        'get server url for links
        Dim svrPath As String = String.Format("{0}", HttpContext.Current.Request.ServerVariables("SERVER_NAME"))
        Dim svrPort As String = String.Format("{0}", HttpContext.Current.Request.ServerVariables("SERVER_PORT"))
        Dim strHTTP As String = "http"
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

        Dim firmName As String = ""
        Dim sqlInfo As New StringBuilder
        sqlInfo.Append("select co.name from tblleaddocuments ld inner join tblleadapplicant la on la.leadapplicantid = ld.leadapplicantid inner join tblcompany co on co.companyid = la.companyid ")
        sqlInfo.AppendFormat("where ld.signingbatchid = '{0}'", signingBatchID)
        Using dt As DataTable = SqlHelper.GetDataTable(sqlInfo.ToString, CommandType.Text)
            For Each row As DataRow In dt.Rows
                firmName = row("name").ToString
                Exit For
            Next
        End Using

        Dim lnkUrl As String = String.Format("{0}://{1}/public/esign.aspx?sbId={2}", strHTTP, svrPath, signingBatchID)

        Dim mailMsg As New System.Net.Mail.MailMessage(String.Format("{0} <noreply@lawfirmsd.com>", firmName), SendTo, msgSubj.ToString, BuildEmailBody(signingBatchID, bSpanishText))
        Dim mailSmtp As New System.Net.Mail.SmtpClient(ConfigurationManager.AppSettings("EmailSMTP"))
        mailMsg.IsBodyHtml = True
        mailSmtp.Send(mailMsg)
    End Sub

    Protected Function BuildEmailBody(signingBatchID As String, Spanish As Boolean) As String

        Dim body As String = ""
        Dim tab As String = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
        Dim space As String = "&nbsp;"

        Dim clientname As String = lblFirstName.Text + " " + lblLastName.Text
        Dim firmName As String = "Thomas Kerns McKnight, LLP"

        If Not Spanish Then
            body += "<html>"
            body += "<body>"
            body += String.Format("<p style=""font-size:.9em;"">Dear {0}, <br/>", clientname)
            body += String.Format("<p style=""font-size:.9em;"">As a valued client we truly appreciate your on-going participation and commitment to the successful resolution of accounts entrusted to our office. It is my sincere hope that your experience with us has been a pleasant and productive one and that our continuing relationship provides you with the level of service and the results that you expect from our organization.</p>")
            body += String.Format("<p style=""font-size:.9em;"">In that interest, I am writing to inform you of a fundamental change to the manner in which your account is serviced. We believe that this transition will provide us with an opportunity to perform our services more economically, reduce your current service fees, and as a result accumulate funds for settlement faster. Our hope is that through this transition, we may effectively reduce the amount of time required to resolve your current accounts.</p>")
            body += String.Format("<p style=""font-size:.9em;"">Effective October 1, 2014, with your consent, we will be transitioning your current settlement deposit account from Global Client Solutions to Wells Fargo Bank. This move allows us to begin servicing your accounts through one of the premier financial institutions in the country and provide you with a greater level of security and confidence in our efforts. In addition, it will eliminate the monthly $9.85 banking fee currently paid to Global Client Solutions to service your account and allow those funds to be directly applied to current settlement agreements or accumulated for future settlement use moving forward.</p>")
            body += String.Format("<p style=""font-size:.9em;"">The mechanics of this transition may have already, or will be, explained to you further to confirm that you completely understand the implications of this move and have an opportunity to have all of your questions answered. If you have not yet spoken with a representative of our offices please contact us immediately at 1(800)745-8311. We are committed to ensuring that this transition is completed efficiently and accurately so please rest assured that accounts currently engaged in settlement will continue to be paid and drafts will continue to be processed as scheduled without interruption.</p>")
            body += String.Format("<p style=""font-size:.9em;"">I appreciate your attention to this matter and continue to express my sincere gratitude for your ongoing cooperation. I am excited by the prospect of providing you with more affordable services and look forward to the successful resolution of your case here with our firm.</p>")
            body += String.Format("<p style=""font-size:.9em;"">Please sign and return the attached Authorization to Debit form within 48 hours so that this transition can be effectuated promptly and without interruption. Thank you again for your cooperation.</p>")
            body += String.Format("<p style=""font-size:.9em;"">Sincerely,</p>")
            body += String.Format("<p style=""font-size:.9em;"">Thomas Kerns McKnight, Esq.</p>")

            Dim lnkUrl As String = String.Format("http://service.lexxiom.com:80/public/lexxsign.aspx?sbId={0}&t=s", signingBatchID)

            'build email body
            body += String.Format("<table style='width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2' cellpadding='8' cellspacing='0'>")
            body += String.Format("<tr><td><h2>{0} has sent your <u>document(s)</u> to review and e-Sign</h2></td></tr>", firmName)
            body += String.Format("<tr><td><img src='http://service.lexxiom.com:80/public/images/24x24_pen.gif' align='absmiddle' /><a style='color: #1E90FF' href='{0}' target='_blank'>Click here to review and e-sign.</a></td></tr>", lnkUrl)
            body += String.Format("<tr><td>With just <b>one simple step,</b> you can electronically sign this document. After you e-sign the <b>document(s)</b>, all parties will receive an emailed signed copy (PDF).</td></tr>")
            body += String.Format("<tr><td><b>The following documents are ready to be e-signed:</b></td></tr>")
            body += String.Format("<tr><td style='background-color: #E8E8E8'>")
            body += String.Format("<p>Global Transfer Document</p>")
            body += String.Format("</td></tr>")
            body += String.Format("<tr><td>&nbsp;</td></tr>")
            body += String.Format("<tr><td style='background-color: #326FA2; border-top: solid 2px #A4D3EE; color: #fff; font-size: 11px'>Optionally, if you cannot click the link above please cut and paste the address below into your address bar.<br />{0}</td></tr>", lnkUrl)
            body += String.Format("<tr><td style='background-color: #326FA2; padding-top:30px' align='right'><img src='http://service.lexxiom.com:80/public/images/poweredby.png' /></td></tr>")

            body += String.Format("<p style=""font-size:.9em;"">Thomas Kerns McKnight, Esq.</p>")
            body += "</body>"
            body += "</html>"
        Else
            body += "<html>"
            body += "<body>"
            body += String.Format("<p style=""font-size:.9em;"">Estimado Sr./Sra {0}, <br/>", clientname)
            body += String.Format("<p style=""font-size:.9em;"">Lo/a consideramos un cliente valioso y realmente apreciamos su participación en su representación legal y su compromiso a la resolución exitosa de cuentas encomendadas a nuestra oficina. Es nuestra sincera esperanza que su experiencia con nosotros haya sido y siga siendo agradable y productiva. Esperamos que nuestra relación le proporcione el nivel de servicio optimo y los resultados que usted espera de nuestra organización.</p>")
            body += String.Format("<p style=""font-size:.9em;"">Con ese interés, le estamos escribiendo para informarle de un cambio fundamental en la manera en que le damos servicio a su cuenta. Creemos que esta transición nos proporcionará una oportunidad para llevar a cabo nuestros servicios de forma más económica, reducir sus tarifas de servicios actuales, y como resultado beneficial usted acumulara fondos para las negociaciones más rápido. Nuestra esperanza es que a través de esta transición, es posible reducir de forma efectiva la cantidad de tiempo necesario para resolver sus cuentas actuales.</p>")
            body += String.Format("<p style=""font-size:.9em;"">Con su consentimiento, vamos a trancisionar su cuenta de depósito actual. Cambiaremos su cuenta de ahorros para negociaciones de Global Client Solutions a Wells Fargo Bank. Este cambio nos permite comenzar a darle servicio a su cuenta a través de una de las instituciones financieras más importantes del país y brindarle un mayor nivel de seguridad y confianza en nuestros esfuerzos. Además, algo que le benificiara a usted como cliente es que se eliminará el costo mensual de $ 9.85 que cobra Global Client Solutions actualmente. Esos fondos ahora serán del cliente para atender a su cuenta y permite que esos fondos sean aplicados directamente a cualquier negociacion actual o para cualquier acuerdo de negociacion en el futuro para seguir adelante.</p>")
            body += String.Format("<p style=""font-size:.9em;"">La justificación de esta transición pudo haber sido o va a ser explicada en más detalle. Queremos que usted este bien informado/a y queremos asegurar que entienda completamente las implicaciones de este cambio. Usted tendrá la oportunidad de tener todas sus preguntas contestadas. Si usted todavía no ha hablado con un representante de nuestras oficinas, por favor póngase en contacto con nosotros de inmediato al (número). Estamos comprometidos para asegurar que esta transición se complete con eficiencia y precisión. Por favor sepa que las cuentas que estén actualmente en negociacion seguirán siendo pagadas y sus depósitos seguirán siendo procesados en la fecha prevista sin interrupción.</p>")
            body += String.Format("<p style=""font-size:.9em;"">Le agradezco su atención a este asunto y sigo para expresar mi sincera gratitud por su cooperación en su representación legal. Estoy muy emocionado por la perspectiva de que le proporcionaremos servicios más asequibles y con interés para la resolución exitosa de su caso aquí con nuestra firma.</p>")
            body += String.Format("<p style=""font-size:.9em;"">Por favor firme y devuelva la autorización adjunta al formulario de débito dentro de 24 horas para que esta transición pueda efectuarse rápidamente y sin interrupción. Gracias de nuevo por su cooperación.</p>")
            body += String.Format("<p style=""font-size:.9em;"">Si usted tiene alguna pregunta, por favor no dudes en contactar con nosotros en 1-800-745-8311. </p>")
            body += String.Format("<p style=""font-size:.9em;"">Atentamente,</p>")
            body += String.Format("<p style=""font-size:.9em;"">Thomas Kerns McKnight, Esq.</p>")

            Dim lnkUrl As String = String.Format("http://service.lexxiom.com:80/public/lexxsign.aspx?sbId={0}&t=s", signingBatchID)

            'build email body
            body += String.Format("<table style='width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2' cellpadding='8' cellspacing='0'>")
            body += String.Format("<tr><td><h2>{0} has sent your <u>document(s)</u> to review and e-Sign</h2></td></tr>", firmName)
            body += String.Format("<tr><td><img src='http://service.lexxiom.com:80/public/images/24x24_pen.gif' align='absmiddle' /><a style='color: #1E90FF' href='{0}' target='_blank'>Click here to review and e-sign.</a></td></tr>", lnkUrl)
            body += String.Format("<tr><td>With just <b>one simple step,</b> you can electronically sign this document. After you e-sign the <b>document(s)</b>, all parties will receive an emailed signed copy (PDF).</td></tr>")
            body += String.Format("<tr><td><b>The following documents are ready to be e-signed:</b></td></tr>")
            body += String.Format("<tr><td style='background-color: #E8E8E8'>")
            body += String.Format("</td></tr>")
            body += String.Format("<tr><td>&nbsp;</td></tr>")
            body += String.Format("<tr><td style='background-color: #326FA2; border-top: solid 2px #A4D3EE; color: #fff; font-size: 11px'>Optionally, if you cannot click the link above please cut and paste the address below into your address bar.<br />{0}</td></tr>", lnkUrl)
            body += String.Format("<tr><td style='background-color: #326FA2; padding-top:30px' align='right'><img src='http://service.lexxiom.com:80/public/images/poweredby.png' /></td></tr>")

            body += String.Format("<p style=""font-size:.9em;"">Thomas Kerns McKnight, Esq.</p>")
            body += "</body>"
            body += "</html>"
        End If

        Return body
    End Function

    Protected Function GetDocID() As String
        Dim docID As String

        Dim query As String = "SELECT [Value] FROM tblProperty WHERE [Name] = 'DocumentNumberPrefix'"
        docID = SqlHelper.ExecuteScalar(query, CommandType.Text).ToString

        Dim stp As String = "stp_GetDocumentNumber"
        docID += SqlHelper.ExecuteScalar(stp, CommandType.StoredProcedure).ToString()

        Return docID
    End Function

    Protected Function CreateDirForClient(ByVal ClientID As Integer) As String
        Dim rootDir As String = ""
        Dim tempDir As String = ""

        Dim query As String = "SELECT TOP 1 AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + ClientID.ToString()
        Dim dt As DataTable = SqlHelper.GetDataTable(query)

        Dim query2 As String = "SELECT DISTINCT [Name] FROM tblDocFolder"
        Dim dt2 As DataTable = SqlHelper.GetDataTable(query2)

        For Each dr As DataRow In dt.Rows
            rootDir = "\\" + dr("StorageServer").ToString + "\" + dr("StorageRoot").ToString + "\" + dr("AccountNumber").ToString + "\"
        Next

        If Not Directory.Exists(rootDir) Then
            Directory.CreateDirectory(rootDir)
        End If

        For Each dr As DataRow In dt2.Rows
            tempDir = rootDir + dr("Name").ToString
        Next

        If Not Directory.Exists(tempDir) Then
            Directory.CreateDirectory(tempDir)
        End If

        Return rootDir
    End Function

    Protected Function BuildAttachmentPath(ByVal docTypeID As String, ByVal docID As String, ByVal dateStr As String, ByVal clientID As Integer, Optional ByVal subFolder As String = "") As String
        Dim acctNo As String
        Dim server As String
        Dim storage As String
        Dim folder As String

        Dim query As String = "SELECT AccountNumber, StorageServer, StorageRoot FROM tblClient WHERE ClientID = " + clientID.ToString()
        Dim dt As DataTable = SqlHelper.GetDataTable(query)

        For Each dr As DataRow In dt.Rows
            acctNo = dr("AccountNumber").ToString()
            server = dr("StorageServer").ToString()
            storage = dr("StorageRoot").ToString()
        Next

        Dim query2 As String = "SELECT DocFolder FROM tblDocumentType WHERE TypeID = '" + docTypeID + "'"
        folder = SqlHelper.ExecuteScalar(query2, CommandType.Text)

        Return "\\" + server + "\" + storage + "\" + acctNo + "\" + folder + "\" + IIf(subFolder.Length > 0, subFolder, "") + acctNo + "_" + docTypeID + "_" + docID + "_" + dateStr + ".pdf"
    End Function

    Public Sub InsertNote(ByVal Value As String, ByVal UserID As Integer, ByVal ClientID As Integer)

        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        If Value.Length > 5000 Then
            DatabaseHelper.AddParameter(cmd, "Value", Value.Substring(0, 5000))
        Else
            DatabaseHelper.AddParameter(cmd, "Value", Value)
        End If

        DatabaseHelper.AddParameter(cmd, "Created", Now)
        DatabaseHelper.AddParameter(cmd, "CreatedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "LastModified", Now)
        DatabaseHelper.AddParameter(cmd, "LastModifiedBy", DataHelper.Nz_int(UserID))
        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

        DatabaseHelper.BuildInsertCommandText(cmd, "tblNote", "NoteID", SqlDbType.Int)

        Try
            cmd.Connection.Open()
            cmd.ExecuteNonQuery()
        Finally
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

End Module
