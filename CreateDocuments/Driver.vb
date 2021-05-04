Imports System.Data.SqlClient
Imports DataDynamics.ActiveReports.Export.Pdf
Imports System.IO
Imports System.Text
Imports Drg.Util.DataAccess

Module Driver

    Dim _CurrentUserID As Integer = 28

    Sub Main(args As String())

        'List of Possible Console Agruments 
        Dim tempList(1) As String
        tempList(0) = "3"

        'MailServer(Settings)
        Dim MailServer As String = "dc02.dmsi.local"
        Dim UserName As String = "Administrator"
        Dim Password As String = "M1n10n11690"

        'Email Settings
        Dim FromEmail As String = "donotreply@lawfirmcs.com"
        Dim Subject As String = "Personal and Confidential: Message From Thomas Kerns McKnight, Esq."
        Dim Email_Was_A_Success As Boolean = False

        'Dummy Variable
        Dim dummyV As Integer

        'Retrieve Command Line Arguments
        Dim Arguments As String() = tempList 'My.Application.CommandLineArgs.ToArray

        'Loop Through Each Document Type
        For Each Str As String In Arguments
            'Validate that entries are numeric
            If Not Integer.TryParse(Str, dummyV) Then
                Continue For
            End If

            'Collect Leads For This DocType
            Dim ClientIdentifiers As New List(Of Client)
            ClientIdentifiers = GetClientList(Str)

            'For Each Lead Generate The Necessary Documents
            For Each ct As Client In ClientIdentifiers
                Console.WriteLine("{0},{1},{2}", ct.FullName, ct.SettlementId, ct.SettlementAmount)
                Exit For
            Next

        Next

    End Sub

    Public Function GetClientList(ByVal EnumDocType As String) As List(Of Client)

        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("QueueType", EnumDocType))

        Dim dt As DataTable = SqlHelper.GetDataTable("stp_LetterTemplates_getPrintQueue", CommandType.StoredProcedure, params.ToArray)

        If dt.Rows.Count = 0 Then
            Return Nothing
        End If

        Return GenerateClientList(dt)

    End Function

    Public Function GenerateClientList(dt As DataTable) As List(Of Client)

        Dim clients As New List(Of Client)

        For Each dr As DataRow In dt.Rows
            Dim client As New Client
            client.SettlementId = IIf(IsNumeric(dr("QID").ToString()), CInt(dr("QID").ToString()), -1)
            client.FullName = dr("Client Name").ToString()
            client.TotalPages = IIf(IsNumeric(dr("Total Pages").ToString()), CInt(dr("Total Pages").ToString()), 0)
            client.LastDateModififed = dr("ActionDate").ToString()
            client.EmailAddress = dr("PrintDocumentPath").ToString()
            client.ClientId = dr("DataClientID").ToString()
            client.CreditorName = dr("Creditor").ToString()
            client.SettlementAmount = dr("SettlementAmount").ToString()
            client.SettlementDueDate = dr("SettlementDueDate").ToString()

            clients.Add(client)
        Next

        Return clients

    End Function

    Public Function GenerateClientsDocuments(ct As Client) As Boolean

        Dim docName As String = "FinalizedSettlementKitCoverLetter"
        Dim docId As String = "D5005"
        Dim iMissingSaf As Integer = 0
        Dim iEmailSentCnt As Integer = 0

        Dim emailMergeDocPath As String = ""
        Using reportObj As New DataDynamics.ActiveReports.ActiveReport3
            Using pdf As New PdfExport()
                Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                    Dim rptDoc As DataDynamics.ActiveReports.Document.Document = Nothing
                    Dim settID As String = ct.SettlementId
                    Dim MatterId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "MatterId", "SettlementId = " & settID))
                    Dim dataclientID As Integer = ct.ClientId
                    Dim acctID As String = SqlHelper.ExecuteScalar(String.Format("select CreditorAccountID from tblsettlements where settlementid = {0}", settID), CommandType.Text)
                    Dim rootDir As New StringBuilder
                    Dim SifPath As String = SettlementMatterHelper.GetSIFForPrinting(MatterId)
                    Dim CheckPath As String = SettlementMatterHelper.GetCheckPathForPrinting(MatterId)
                    Dim SAFPath As String = SettlementMatterHelper.GetSAFPathForPrinting(MatterId, settID)
                    Dim RELPath As String = SettlementMatterHelper.GetRELPathForPrinting(MatterId, settID)

                    If SAFPath.Trim = "" Then
                        iMissingSaf += 1
                        SAFPath = RePrintSAF(settID, dataclientID, "D6004", "SettlementAcceptanceForm")
                    End If

                    'create client root directory
                    rootDir.Append(SharedFunctions.DocumentAttachment.CreateDirForClient(dataclientID))

                    Dim filePath As String = SharedFunctions.DocumentAttachment.GetUniqueDocumentName(docId, dataclientID)
                    Dim credPath As String = String.Format("{0}ClientDocs\", rootDir.ToString)
                    If Directory.Exists(credPath) = False Then
                        Directory.CreateDirectory(credPath)
                    End If

                    'get client email address
                    'if exists send email else print
                    Dim numPagesInReport As Integer = 0
                    Dim clientEmail As String = row.Cells(7).Text.Replace("&nbsp;", "")
                    Dim cvrLtrPath As String = credPath & filePath
                    Dim args As New List(Of String)
                    args.Add(dataclientID)
                    rptDoc = rptTemplates.ViewTemplate(docName, dataclientID, args.ToArray, False, _CurrentUserID)
                    'add pages to report
                    reportObj.Document.Pages.AddRange(rptDoc.Pages)
                    numPagesInReport = reportObj.Document.Pages.Count
                    Using fStream As New System.IO.FileStream(cvrLtrPath, FileMode.CreateNew)
                        pdf.Export(reportObj.Document, fStream)
                    End Using

                    Using dtMerge As New DataTable


                        dtMerge.Columns.Add("DocPath", GetType(System.String))
                        dtMerge.Columns.Add("DocPages", GetType(System.String))

                        If Not String.IsNullOrEmpty(cvrLtrPath) AndAlso File.Exists(cvrLtrPath) Then
                            Dim nr As DataRow = dtMerge.NewRow
                            nr(0) = cvrLtrPath
                            nr(1) = "1"
                            dtMerge.Rows.Add(nr)
                        End If
                        If Not String.IsNullOrEmpty(SifPath) AndAlso File.Exists(SifPath) Then
                            Dim nr As DataRow = dtMerge.NewRow
                            nr(0) = SifPath
                            nr(1) = "1"
                            dtMerge.Rows.Add(nr)
                        End If
                        If Not String.IsNullOrEmpty(CheckPath) AndAlso File.Exists(CheckPath) Then
                            Dim nr As DataRow = dtMerge.NewRow
                            nr(0) = CheckPath
                            nr(1) = "1"
                            dtMerge.Rows.Add(nr)
                        End If
                        If Not String.IsNullOrEmpty(SAFPath) AndAlso File.Exists(SAFPath) Then
                            Dim nr As DataRow = dtMerge.NewRow
                            nr(0) = SAFPath
                            nr(1) = "1"
                            dtMerge.Rows.Add(nr)
                        End If
                        If Not String.IsNullOrEmpty(RELPath) AndAlso File.Exists(RELPath) Then
                            Dim nr As DataRow = dtMerge.NewRow
                            nr(0) = RELPath
                            nr(1) = "1,2"
                            dtMerge.Rows.Add(nr)
                        End If

                        Dim kipInsertPath As String = "\\Nas02\d\DocumentInserts\KnowledgeIsPower.pdf"
                        If Not String.IsNullOrEmpty(kipInsertPath) AndAlso File.Exists(kipInsertPath) Then
                            Dim nr As DataRow = dtMerge.NewRow
                            nr(0) = kipInsertPath
                            nr(1) = "1,2"
                            dtMerge.Rows.Add(nr)
                        End If


                        If dtMerge.Rows.Count > 0 Then
                            emailMergeDocPath = String.Format("{0}{1}", credPath, SharedFunctions.DocumentAttachment.GetUniqueDocumentName(docId, dataclientID))
                            PdfManipulation.ExtractAndMergePdfPages(dtMerge, emailMergeDocPath)
                            Dim nid As Integer = 0
                            If clientEmail.Trim <> "" Then
                                iEmailSentCnt += 1
                                Dim attList As New List(Of String)
                                Dim eSubject As String = "Finalized Settlement Kit"
                                Dim eBody As String = "Your finalized settlement kit has arrived with information about an account we settled on your behalf."
                                attList.Add(emailMergeDocPath)
                                EmailHelper.SendMessage("noreply@lawfirm.com", clientEmail, eSubject, eBody, attList)
                                nid = NoteHelper.InsertNote("Final Settlement Kit emailed from print queue.", _CurrentUserID, dataclientID)
                            End If

                            SharedFunctions.DocumentAttachment.AttachDocument("note", nid, Path.GetFileName(emailMergeDocPath), _CurrentUserID)
                            SharedFunctions.DocumentAttachment.AttachDocument("account", acctID, Path.GetFileName(emailMergeDocPath), _CurrentUserID)
                            SharedFunctions.DocumentAttachment.AttachDocument("matter", MatterId, Path.GetFileName(emailMergeDocPath), _CurrentUserID)
                            SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(emailMergeDocPath), _CurrentUserID, Now)
                            InsertPrintInfo(docId, dataclientID, emailMergeDocPath, _CurrentUserID, numPagesInReport)
                        End If
                    End Using
                End Using
            End Using
        End Using
        ' docCnt += 1
        'End If
        'End If
        'Next
        'qr.DocumentCount = docCnt
        'qr.ResultMessage = String.Format("{0} Document(s) FSK's Processed. {1} Documents(s) Emailed.  {2} Client(s) Missing SAF.  ", docCnt, iEmailSentCnt, iMissingSaf)
        Return False ' qr
    End Function

End Module
