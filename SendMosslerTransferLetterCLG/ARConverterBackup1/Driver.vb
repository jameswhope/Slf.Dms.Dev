Imports System.Data.SqlClient
Imports LexxiomLetterTemplates
Imports System.IO
Imports System.Net.Mail
Imports System.Net

Module Driver

    Sub Main(args As String())
        ''Global Variables

        Dim Parameters As String() = args

        'MailServer(Settings)
        'Dim MailServer As String = "dc02.dmsi.local"
        'Dim UserName As String = "Administrator"
        'Dim Password As String = "Syn3rgy7945!"

        Dim MailServer As String = "smtp.gmail.com"
        Dim UserName As String = "info@lexxiom.com"
        Dim Password As String = "lexxiom1"

        'Email Settings
        Dim FromEmail As String = "info@lawfirmcs.com"
        Dim Subject As String = "Personal and Confidential: Message From The Mossler Law Firm"
        Dim Email_Was_A_Success As Boolean = False

        'Gathering List Of Clients Which Required An Email Notification
        Dim ClientIdentifiers As New List(Of Integer)
        ClientIdentifiers = GetClientList(Parameters)

        'For Each Client 1.Extract Dynamic Info 2.Build Email Body 3. Send Email 4. Log Result
        For Each client As Integer In ClientIdentifiers

            'Gathering Information Of Client For Dynamic Purposes
            Dim clientInfo As DataTable = GetClientInformation(client)

            Dim signingBatchID As String = SendLexxSignGTT(client, clientInfo.Rows(0)("EmailAddress"), clientInfo.Rows(0)("Language"), clientInfo.Rows(0)("Trust"))

            'Create custom email per client
            Dim EmailBody As String = BuildEmailBody(clientInfo, signingBatchID)

            'Variable used to check if email message was successful
            Email_Was_A_Success = False

            'Send message
            SendMessage(FromEmail, clientInfo.Rows(0)("EmailAddress"), Subject, EmailBody, MailServer, UserName, Password, Email_Was_A_Success)

            If Email_Was_A_Success Then

                'Record email details for initial deposit notice
                RecordEmails(client, clientInfo.Rows(0)("EmailAddress"), Subject, EmailBody)

                'Record a note for the initial deposit notice.
                CreateNote("Email was sent asking client to sign Mossler Transfer To CLG document", client)

            End If
        Next
    End Sub

    Private Function GetClientList(ByVal arguments As String()) As List(Of Integer)

        Dim list As New List(Of Integer)
        Dim query As String

        If arguments(0) = "-1" Then
            query = "select clientId,emailaddress from vw_ClientTransfer_MosslerToCLG"
        Else
            query = String.Format("select c.clientId,1 from tblClient c join tblPerson p on p.PersonId = c.PrimaryPersonId where c.currentclientstatusid in (14,16) and companyid = 4 and p.EmailAddress is not null and c.clientid = {0}", arguments(0))
        End If
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

    Public Function SendLexxSignGTT(ByVal clientId As Integer, ByVal cEmail As String, ByVal Language As Boolean, ByVal Trust As Boolean) As String
        Dim dlist As New List(Of String)
        dlist.Add("PalmerTransferToMcKnight")

        Dim docList As New List(Of LetterTemplates.BatchTemplate)   'holds returned documents to process
        Dim rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
        Dim dir As String = CreateDirForClient(clientId)
        Dim docId As String = GetDocID()
        Dim filePath As String = BuildAttachmentPath("T1010", docId, Now.ToString("yyMMdd"), clientId)

        'add documents to range
        docList.AddRange(rptTemplates.Generate_LexxSign_MosslerTransferToCLG(clientId, 28, True, Language, Trust))

        'get new unique signing batch id
        Dim signingBatchId As String = Guid.NewGuid.ToString

        'stores the names of the reports
        Dim dNames As New List(Of String)

        'needed to check for duplicate documents
        Dim docIDs As New Hashtable

        'only get documents that need signatures
        Dim nosign = From doc As LetterTemplates.BatchTemplate In docList Where Not doc.TemplateName.StartsWith("Signing") Select doc
        For Each doc As LetterTemplates.BatchTemplate In nosign
            'assign new doc  id
            Dim documentId As String = Guid.NewGuid.ToString
            docIDs.Add(doc.TemplateName.Replace("Signing_", ""), documentId)

            'export html docs for gui navigation
            Dim path As String = System.Configuration.ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.html", documentId)
            Using finalHTML As New DataDynamics.ActiveReports.Export.Html.HtmlExport
                finalHTML.OutputType = DataDynamics.ActiveReports.Export.Html.HtmlOutputType.DynamicHtml
                finalHTML.IncludeHtmlHeader = False
                finalHTML.IncludePageMargins = False
                finalHTML.Export(doc.TemplateRpt.Document, path)
            End Using

            'need matching pdf for final signing process
            If Not doc.NeedSignature Then
                path = System.Configuration.ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.pdf", documentId)
                Using finalPDF As New DataDynamics.ActiveReports.Export.Pdf.PdfExport
                    finalPDF.Export(doc.TemplateRpt.Document, path)
                End Using
            End If

            'save document to db
            Dim docTid As String = "T1010" 'rptTemplates.GetDocTypeID("MooslerTransferCLG")
            LexxSignHelper.NonCID.SaveLexxSignDocument(clientId, documentId, 28, docTid, signingBatchId, cEmail, 21, clientId)
            dNames.Add(doc.TemplateName)
        Next

        Dim needsign = From doc As LetterTemplates.BatchTemplate In docList Where doc.TemplateName.StartsWith("Signing") Select doc
        For Each doc As LetterTemplates.BatchTemplate In needsign
            Dim templateName As String = doc.TemplateName.Replace("Signing_", "")
            If docIDs.Contains(templateName) Then
                Dim path As String = System.Configuration.ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.pdf", docIDs(templateName))
                Using finalPDF As New DataDynamics.ActiveReports.Export.Pdf.PdfExport
                    finalPDF.Export(doc.TemplateRpt.Document, path.Replace(".html", ".pdf"))
                End Using
            End If
        Next

        Return signingBatchId
    End Function

    Public Function CreateDirForClient(ByVal ClientID As Integer) As String
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

    Private Function GetDocID() As String
        Dim docID As String

        Dim query As String = "SELECT [Value] FROM tblProperty WHERE [Name] = 'DocumentNumberPrefix'"
        docID = SqlHelper.ExecuteScalar(query, CommandType.Text).ToString

        Dim stp As String = "stp_GetDocumentNumber"
        docID += SqlHelper.ExecuteScalar(stp, CommandType.StoredProcedure).ToString()

        Return docID
    End Function

    Public Function BuildAttachmentPath(ByVal docTypeID As String, ByVal docID As String, ByVal dateStr As String, ByVal clientID As Integer, Optional ByVal subFolder As String = "") As String
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

    Private Function BuildEmailBody(ClientInfo As DataTable, signingBatchID As String) As String

        Dim body As String = ""
        Dim tab As String = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
        Dim space As String = "&nbsp;"
        Dim client As DataRow = ClientInfo.Rows(0)

        Dim clientname As String = client("fullname").ToString
        Dim Language As Boolean = CBool(client("Language").ToString)
        Dim Trust As Boolean = CBool(client("Trust").ToString)

        If Not Language Then
            If Trust Then
                body += "<html>"
                body += "<body>"
                body += String.Format("<p style=""font-size:.9em;"">Dear {0}, <br/>", clientname)
                body += String.Format("<p style=""font-size:.9em;"">This is a letter to inform you that your attorney Richard Mossler has decided to retire after a long and successful career.  In our continuing effort to provide you the best solutions for the financial burdens that brought you to the firm, we are pleased to inform you of a change in your current representation. With your permission, The Mossler Law Firm, PC. plans to transfer your representation to the Consumer Law Group. Jerome Ramsaran, Consumer Law Group’s managing attorney, is an experienced attorney practicing law in Florida. Mr. Ramsaran is familiar with the goals of our clients and the methods we have employed in representing them.</p>")
                body += String.Format("<p style=""font-size:.9em;"">The change will not cost you anything more than what you have already agreed to pay. Consumer Law Group will simply assume the role that we played before, and provide legal representation to you under the same terms and for the same fees that you agreed to with The Mossler Law Firm, PC.</p>")
                body += String.Format("<p style=""font-size:.9em;"">Once we receive a signed copy of the enclosed ""Letter Accepting Representation"" form The Mossler Law Firm, PC. will transfer any funds it holds in your name to the Consumer Law Group to be deposited for you into their trust account. In the future your monthly automatic drafts will go to the Consumer Law Group trust account and will no longer be collected or held by The Mossler Law Firm, PC.</p>")
                body += String.Format("<p style=""font-size:.9em;"">The transition will require the following. You will sign the attached ""Letter Accepting Representation"". This document does two things: (1) it terminates the representation of The Mossler Law Firm, PC., and (2) it engages the Consumer Law Group. Once this document has been received we will facilitate the transfer of your file and funds if applicable.</p>")
                body += String.Format("<p style=""font-size:.9em;"">We know that you may have questions regarding the transition that are not answered by this letter. Also, we understand that some of our clients will be reluctant to make changes. In either case we ask you to call 1 (800) 304-1655 to discuss this further. This is a special number where someone will be standing by to assist you with just these matters.</p>")
                body += String.Format("<p style=""font-size:.9em;"">We have enjoyed serving you and hope to provide additional services in the future. In the meantime, we wish you the best as you continue to work out a resolution of your financial difficulties.</p>")
                body += String.Format("<p style=""font-size:.9em;"">Sincerely,</p>")
                body += String.Format("<p style=""font-size:.9em;"">Richard Mossler</p>")

                Dim firmName As String = "The Mossler Law Firm, P.C."

                Dim lnkUrl As String = String.Format("http://service.lexxiom.com:80/public/lexxsign.aspx?sbId={0}&t=s", signingBatchID)

                'build email body
                body += String.Format("<table style='width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2' cellpadding='8' cellspacing='0'>")
                body += String.Format("<tr><td><h2>{0} has sent your <u>document(s)</u> to review and e-Sign</h2></td></tr>", firmName)
                body += String.Format("<tr><td><img src='http://service.lexxiom.com:80/public/images/24x24_pen.gif' align='absmiddle' /><a style='color: #1E90FF' href='{0}' target='_blank'>Click here to review and e-sign.</a></td></tr>", lnkUrl)
                body += String.Format("<tr><td>With just <b>one simple step,</b> you can electronically sign this document. After you e-sign the <b>document(s)</b>, all parties will receive an emailed signed copy (PDF).</td></tr>")
                body += String.Format("<tr><td><b>The following documents are ready to be e-signed:</b></td></tr>")
                body += String.Format("<tr><td style='background-color: #E8E8E8'>")
                body += String.Format("<p>Mossler Transfer Document</p>")
                body += String.Format("</td></tr>")
                body += String.Format("<tr><td>&nbsp;</td></tr>")
                body += String.Format("<tr><td style='background-color: #326FA2; border-top: solid 2px #A4D3EE; color: #fff; font-size: 11px'>Optionally, if you cannot click the link above please cut and paste the address below into your address bar.<br />{0}</td></tr>", lnkUrl)

                body += "</body>"
                body += "</html>"
            Else
                body += "<html>"
                body += "<body>"
                body += String.Format("<p style=""font-size:.9em;"">Dear {0}, <br/>", clientname)
                body += String.Format("<p style=""font-size:.9em;"">This is a letter to inform you that your attorney Richard Mossler has decided to retire after a long and successful career. In our continuing effort to provide you the best solutions for the financial burdens that brought you to the firm, we are pleased to inform you of a change in your current representation. With your permission, The Mossler Law Firm, PC. plans to transfer your representation to the Consumer Law Group. Jerome Ramsaran, Consumer Law Group’s managing attorney, is an experienced attorney practicing law in Florida. Mr. Ramsaran is familiar with the goals of our clients and the methods we have employed in representing them.</p>")
                body += String.Format("<p style=""font-size:.9em;"">The change will not cost you anything more than what you have already agreed to pay. Consumer Law Group will simply assume the role that we played before, and provide legal representation to you under the same terms and for the same fees that you agreed to with The Mossler Law Firm, PC.</p>")
                body += String.Format("<p style=""font-size:.9em;"">The transition will require the following. You will sign the attached ""Letter Accepting Representation"". This document does two things: (1) it terminates the representation of The Mossler Law Firm, PC., and (2) it engages the Consumer Law Group. Once this document has been received we will facilitate the transfer of your file and funds if applicable.</p>")
                body += String.Format("<p style=""font-size:.9em;"">We know that you may have questions regarding the transition that are not answered by this letter. Also, we understand that some of our clients will be reluctant to make changes. In either case we ask you to call 1 (800) 304-1655 to discuss this further. This is a special number where someone will be standing by to assist you with just these matters.</p>")
                body += String.Format("<p style=""font-size:.9em;"">We have enjoyed serving you and hope to provide additional services in the future. In the meantime, we wish you the best as you continue to work out a resolution of your financial difficulties.</p>")
                body += String.Format("<p style=""font-size:.9em;"">Sincerely,</p>")
                body += String.Format("<p style=""font-size:.9em;"">Richard Mossler</p>")

                Dim firmName As String = "The Mossler Law Firm, P.C."

                Dim lnkUrl As String = String.Format("http://service.lexxiom.com:80/public/lexxsign.aspx?sbId={0}&t=s", signingBatchID)

                'build email body
                body += String.Format("<table style='width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2' cellpadding='8' cellspacing='0'>")
                body += String.Format("<tr><td><h2>{0} has sent your <u>document(s)</u> to review and e-Sign</h2></td></tr>", firmName)
                body += String.Format("<tr><td><img src='http://service.lexxiom.com:80/public/images/24x24_pen.gif' align='absmiddle' /><a style='color: #1E90FF' href='{0}' target='_blank'>Click here to review and e-sign.</a></td></tr>", lnkUrl)
                body += String.Format("<tr><td>With just <b>one simple step,</b> you can electronically sign this document. After you e-sign the <b>document(s)</b>, all parties will receive an emailed signed copy (PDF).</td></tr>")
                body += String.Format("<tr><td><b>The following documents are ready to be e-signed:</b></td></tr>")
                body += String.Format("<tr><td style='background-color: #E8E8E8'>")
                body += String.Format("<p>Mossler Transfer Document</p>")
                body += String.Format("</td></tr>")
                body += String.Format("<tr><td>&nbsp;</td></tr>")
                body += String.Format("<tr><td style='background-color: #326FA2; border-top: solid 2px #A4D3EE; color: #fff; font-size: 11px'>Optionally, if you cannot click the link above please cut and paste the address below into your address bar.<br />{0}</td></tr>", lnkUrl)

                body += "</body>"
                body += "</html>"
            End If
        Else
            If Trust Then
                body += "<html>"
                body += "<body>"
                body += String.Format("<p style=""font-size:.9em;"">Estimado Sr./Sra {0}, <br/>", clientname)
                body += String.Format("<p style=""font-size:.9em;"">Esta carta es una continuación de nuestra conversación reciente por teléfono en referente a los cambios de su representación. En nuestro esfuerzo por proporcionarle las mejores soluciones para su carga financiera que lo trajo a la Firma, nos complace informarle de un cambio a su representación actual. Con su autorización, The Mossler Law Firm, PC., planea transferir su representación a Consumer Law Group. Jerome Ramsaran, el Abogado experto en la práctica de la ley en Florida. Sr. Ramsaran está familiarizado con los objetivos de nuestros clientes y los métodos que hemos empleado en que los representan. </p>")
                body += String.Format("<p style=""font-size:.9em;"">El cambio no le costara nada más que lo que tiene ya acordado pagar. Consumer Law Group simplemente asumirá el papel que se desempeñó anteriormente y proporciona representación legal en los mismos términos y para los mismos honorarios que usted acordó con The Mossler Law Firm, PC. </p>")
                body += String.Format("<p style=""font-size:.9em;"">Una vez que recibimos una copia firmada de la forma ""Carta de Aceptación de Representación"", The Mossler, PC. transferirá los fondos que posee en nombre a Consumer Law Group que se depositará en su cuenta de fideicomiso para usted. En el futuro sus giros bancarios mensuales ira a la cuenta de fideicomiso de Consumer Law Group y no se seguirán recaudando o será guardada por The Mossler Law Firm, PC. </p>")
                body += String.Format("<p style=""font-size:.9em;"">La transición requerirá los siguientes. Usted firmara la forma ""Carta de Aceptación de Representación"". Este documento hace dos cosas: (1) termina la representación de The Mossler Firm, PC., y (2) contrata a Consumer Law Group. Una vez recibido este documento, nos facilitará la transferencia de su archivo y fondos si es aplicable. </p>")
                body += String.Format("<p style=""font-size:.9em;"">Sabemos que usted puede tener preguntas sobre la transición las cuales no son contestadas por esta carta. Además, entendemos que algunos de nuestros clientes serán reacios a realizar cambios. En cualquier caso le pedimos que llame a 1 (800) 304-1655 a discutir esto más detalladamente. Este es un número especial donde alguien le podrá ayudar con estos asuntos. </p>")
                body += String.Format("<p style=""font-size:.9em;"">Ha sido un placer servirle y esperamos ofrecerle servicios adicionales en el futuro. Mientras tanto, le deseamos lo mejor a medida que continúe trabajando a una resolución de sus dificultades financieras. </p>")
                body += String.Format("<p style=""font-size:.9em;"">Atentamente,</p>")
                body += String.Format("<p style=""font-size:.9em;"">Richard Mossler</p>")

                Dim firmName As String = "The Mossler Law Firm, P.C."

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

                body += "</body>"
                body += "</html>"
            Else
                body += "<html>"
                body += "<body>"
                body += String.Format("<p style=""font-size:.9em;"">Estimado Sr./Sra {0}, <br/>", clientname)
                body += String.Format("<p style=""font-size:.9em;"">Esta carta es una continuación de nuestra conversación reciente por teléfono en referente a los cambios de su representación. En nuestro esfuerzo por proporcionarle las mejores soluciones para su carga financiera que lo trajo a la Firma, nos complace informarle de un cambio a su representación actual. Con su autorización, The Mossler Law Firm, PC., planea transferir su representación a Consumer Law Group. Jerome Ramsaran, el Abogado experto en la práctica de la ley en Florida. Sr. Ramsaran está familiarizado con los objetivos de nuestros clientes y los métodos que hemos empleado en que los representan. </p>")
                body += String.Format("<p style=""font-size:.9em;"">El cambio no le costara nada más que lo que tiene ya acordado pagar. Consumer Law Group simplemente asumirá el papel que se desempeñó anteriormente y proporciona representación legal en los mismos términos y para los mismos honorarios que usted acordó con The Mossler Law Firm, PC. </p>")
                body += String.Format("<p style=""font-size:.9em;"">Una vez que recibimos una copia firmada de la forma ""Carta de Aceptación de Representación"", The Mossler, PC. transferirá los fondos que posee en nombre a Consumer Law Group que se depositará en su cuenta de fideicomiso para usted. En el futuro sus giros bancarios mensuales ira a la cuenta de fideicomiso de Consumer Law Group y no se seguirán recaudando o será guardada por The Mossler Law Firm, PC. </p>")
                body += String.Format("<p style=""font-size:.9em;"">La transición requerirá los siguientes. Usted firmara la forma ""Carta de Aceptación de Representación"". Este documento hace dos cosas: (1) termina la representación de The Mossler Firm, PC., y (2) contrata a Consumer Law Group. Una vez recibido este documento, nos facilitará la transferencia de su archivo y fondos si es aplicable. </p>")
                body += String.Format("<p style=""font-size:.9em;"">Sabemos que usted puede tener preguntas sobre la transición las cuales no son contestadas por esta carta. Además, entendemos que algunos de nuestros clientes serán reacios a realizar cambios. En cualquier caso le pedimos que llame a 1 (800) 304-1655 a discutir esto más detalladamente. Este es un número especial donde alguien le podrá ayudar con estos asuntos. </p>")
                body += String.Format("<p style=""font-size:.9em;"">Ha sido un placer servirle y esperamos ofrecerle servicios adicionales en el futuro. Mientras tanto, le deseamos lo mejor a medida que continúe trabajando a una resolución de sus dificultades financieras. </p>")
                body += String.Format("<p style=""font-size:.9em;"">Atentamente,</p>")
                body += String.Format("<p style=""font-size:.9em;"">Richard Mossler</p>")

                Dim firmName As String = "The Mossler Law Firm, P.C."

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

                body += "</body>"
                body += "</html>"
            End If

        End If

        Return body
    End Function

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

    Private Sub RecordEmails(client As Integer, email As String, subject As String, body As String)

        Dim Type As String = "MosslerTransferToCLGEmailNotification"
        Dim DateSent As Date = Now
        Dim SentBy As Integer = 28
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

    Private Sub CreateNote(ByVal value As String, ByVal clientId As String)

        Dim Query As String = String.Format("insert tblNote (Value,Created,CreatedBy,LastModified,LastModifiedBy,ClientId,UserGroupId) values ('{0}', getdate(), 32, getdate(), 32, {1}, 6)", value, clientId)
        SqlHelper.ExecuteNonQuery(Query, CommandType.Text)

    End Sub

End Module
