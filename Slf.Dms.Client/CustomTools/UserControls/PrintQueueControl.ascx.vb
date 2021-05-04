﻿Imports System.Collections.Generic
Imports System.Drawing

Imports System.Diagnostics
Imports System.Data
Imports System.IO
Imports System

Imports GrapeCity.ActiveReports
Imports GrapeCity.ActiveReports.Export.Pdf

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports LexxiomLetterTemplates
Imports LexxiomLetterTemplates.LetterTemplates

Imports ReportsHelper
Imports iTextSharp.text
Imports iTextSharp.text.pdf

Imports Microsoft.VisualBasic

Partial Class PrintQueueControl
    Inherits System.Web.UI.UserControl

#Region "Fields"

    Private _CurrentUserID As Integer
    Private _NetworkPrinterName As String '= "\\DMF-APP-0001\dmf-prn-0001"

#End Region 'Fields

#Region "Enumerations"

    Public Enum enumPrintQueueType
        WelcomeEmail = 0
        Reprint = 1
        AutomatedSettlementProcessing = 2
        FinalSettlementKit = 3
        PendingCancellationNotice = 4
        PendingBankruptcyRequest = 5
        WelcomePackage = 6
        ClientStipulation = 7
        NonDeposit = 8
        BouncedDeposit = 9
        LettersOfRepresentation = 10
        ClientStatements = 11
        FinalSettlementKitPAPaymentsByClient = 12
        ClientDepositCheck = 13
        AttorneyPaymentCheck = 14
    End Enum

#End Region 'Enumerations

#Region "Properties"

    Public Property CurrentUserID() As Integer
        Get
            Return _CurrentUserID
        End Get
        Set(ByVal value As Integer)
            _CurrentUserID = value
        End Set
    End Property

    Public Property NetworkPrinterName() As String
        Get
            If IsNothing(hdnPrinterName.Value) Or hdnPrinterName.Value.ToString.Trim = "" Then
                hdnPrinterName.Value = "NONE"
            End If
            Return hdnPrinterName.Value.ToString
        End Get
        Set(ByVal value As String)
            hdnPrinterName.Value = value
        End Set
    End Property

    Public Property QueueType() As enumPrintQueueType
        Get
            Return ViewState("qid")
        End Get
        Set(ByVal value As enumPrintQueueType)
            ViewState("qid") = Int(value)
        End Set
    End Property

#End Region 'Properties

#Region "Methods"

    Public Shared Shadows Function FindControl(ByVal startingControl As Control, ByVal id As String) As Control
        If id = startingControl.ID Then Return startingControl
        For Each ctl As Control In startingControl.Controls
            Dim found = FindControl(ctl, id)
            If found IsNot Nothing Then Return found
        Next
        Return Nothing
    End Function

    Public Sub BindData(Optional ByVal printQ As enumPrintQueueType = enumPrintQueueType.WelcomeEmail)
        dsQueue.SelectParameters("QueueType").DefaultValue = printQ
        dsQueue.DataBind()
        gvQueue.DataSourceID = dsQueue.ID
        gvQueue.DataBind()
    End Sub

    Public Sub ClearGrid()
        BindData(Me.QueueType)
    End Sub

    Public Shadows Function FindControl(ByVal id As String) As Control
        Return FindControl(Page, id)
    End Function

    Public Sub PrintSelected() Handles lnkPrintQ.Click
        Dim docCnt As Integer = 0
        Dim qStatus As QResults = Nothing

        If NetworkPrinterName = "NONE" AndAlso IsPrinterNeeded() Then
            divMsg.Attributes("display") = "block"
            divMsg.Attributes("class") = "error"
            divMsg.InnerHtml = "No Printer selected!" & "<a href=""#"" onclick=""this.parentElement.style.display='none';return false;"">Close</a>"
            Exit Sub
        End If

        Select Case QueueType
            Case enumPrintQueueType.Reprint
                qStatus = PrintReprintQueue()
            Case enumPrintQueueType.WelcomeEmail
                qStatus = PrintWelcomeQueue()
            Case enumPrintQueueType.AutomatedSettlementProcessing
                qStatus = PrintSettlementQueue()
            Case enumPrintQueueType.FinalSettlementKit
                qStatus = PrintSettlementKit()
                'Case enumPrintQueueType.PendingCancellationNotice
                '    docCnt = PrintPendingCancellationNotice()
                'Case enumPrintQueueType.PendingBankruptcyRequest
                '    docCnt = PrintBankruptcyRequestNotice()
            Case enumPrintQueueType.WelcomePackage
                qStatus = PrintWelcomePackage()
            Case enumPrintQueueType.ClientStipulation
                qStatus = PrintClientStipulations()
            Case enumPrintQueueType.NonDeposit
                qStatus = PrintNonDeposit()
            Case enumPrintQueueType.BouncedDeposit
                qStatus = PrintBouncedDeposit()
            Case enumPrintQueueType.LettersOfRepresentation
                qStatus = PrintLOR()
            Case enumPrintQueueType.ClientStatements
                qStatus = PrintClientStatements()
            Case enumPrintQueueType.FinalSettlementKitPAPaymentsByClient
                qStatus = PrintPAbyClientSettlementKit()
            Case enumPrintQueueType.ClientDepositCheck
                qStatus = PrintClientDepositCheck()
            Case enumPrintQueueType.AttorneyPaymentCheck
                qStatus = PrintAttorneyPaymentCheck()
        End Select

        If qStatus.DocumentCount > 0 Then
            divMsg.Attributes("display") = "block"
            divMsg.Attributes("class") = "success"
            divMsg.InnerHtml = qStatus.ResultMessage & "<a href=""#"" onclick=""this.parentElement.style.display='none';return false;"">Close</a>"
            BindData(Me.QueueType)
        Else
            divMsg.Attributes("display") = "block"
            divMsg.Attributes("class") = "warning"
            divMsg.InnerHtml = String.Format("{0}", qStatus.ResultMessage) & "<a href=""#"" onclick=""this.parentElement.style.display='none';return false;"">Close</a>"
        End If

    End Sub

    Public Sub SearchGrid()
        Dim searchTerm As String = hdnSearchText.Value
        Dim sTerm As New StringBuilder
        sTerm.AppendFormat("[Display Name] like '%{0}%' or ", searchTerm)
        sTerm.AppendFormat("[Client Name] like '%{0}%'", searchTerm)
        Dim d As New DataSourceSelectArguments

        dsQueue.SelectParameters("QueueType").DefaultValue = QueueType
        Dim dv As DataView = dsQueue.Select(DataSourceSelectArguments.Empty)
        dv.RowFilter = sTerm.ToString

        gvQueue.DataSourceID = Nothing
        gvQueue.DataSource = dv
        gvQueue.DataBind()

        divMsg.Attributes("display") = "block"
        divMsg.Attributes("class") = "info"
        divMsg.InnerHtml = String.Format("Search Term : [{0}] found {1} result(s).  <a href=""default.aspx"">Reset search</a>", searchTerm, dv.Count)
    End Sub

    Public Sub SetPagerButtonStates(ByVal gridView As GridView, ByVal gvPagerRow As GridViewRow, ByVal page As System.Web.UI.Page)
        Dim pageIndex As Integer = gridView.PageIndex
        Dim pageCount As Integer = gridView.PageCount

        Dim btnFirst As LinkButton = TryCast(gvPagerRow.FindControl("btnFirst"), LinkButton)
        Dim btnPrevious As LinkButton = TryCast(gvPagerRow.FindControl("btnPrevious"), LinkButton)
        Dim btnNext As LinkButton = TryCast(gvPagerRow.FindControl("btnNext"), LinkButton)
        Dim btnLast As LinkButton = TryCast(gvPagerRow.FindControl("btnLast"), LinkButton)
        Dim lblNumber As System.Web.UI.WebControls.Label = TryCast(gvPagerRow.FindControl("lblNumber"), System.Web.UI.WebControls.Label)

        lblNumber.Text = pageCount.ToString()

        btnFirst.Enabled = btnPrevious.Enabled = (pageIndex <> 0)
        btnLast.Enabled = btnNext.Enabled = (pageIndex < (pageCount - 1))

        btnPrevious.Enabled = (pageIndex <> 0)
        btnNext.Enabled = (pageIndex < (pageCount - 1))

        If btnNext.Enabled = False Then
            btnNext.Attributes.Remove("CssClass")
        End If
        Dim ddlPageSelector As DropDownList = DirectCast(gvPagerRow.FindControl("ddlPageSelector"), DropDownList)
        ddlPageSelector.Items.Clear()

        For i As Integer = 1 To gridView.PageCount
            ddlPageSelector.Items.Add(i.ToString())
        Next

        ddlPageSelector.SelectedIndex = pageIndex

        'Used delegates over here
        AddHandler ddlPageSelector.SelectedIndexChanged, AddressOf pageSelector_SelectedIndexChanged
    End Sub

    Public Sub pageSelector_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        Using gv As GridView = ddl.Parent.Parent.Parent.Parent
            If Not IsNothing(gv) Then
                gv.PageIndex = ddl.SelectedIndex
                gv.DataBind()
            End If
        End Using
    End Sub

    Protected Sub CustomTools_UserControls_PrintQueueControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            divMsg.Attributes("display") = "none"
            'Filter only Qtype
            If Not Request.QueryString("qtype") Is Nothing AndAlso Request.QueryString("qtype").ToString.Trim.Length > 0 Then
                QueueType = CInt(Request.QueryString("qtype").ToString)
                BindData(QueueType)
            Else
                BindData()
            End If

            loadQueueTypes()
            loadPrinters()
        End If
    End Sub
    Protected Sub ddlq_selectedindexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlQueueType.SelectedIndexChanged
        Dim ddl As DropDownList = TryCast(sender, DropDownList)
        QueueType = ddl.SelectedItem.Value

        BindData(ddl.SelectedItem.Value)

        divMsg.Attributes("display") = "none"
        divMsg.Attributes("class") = ""
        divMsg.InnerHtml = ""
    End Sub

    Protected Sub dsQueue_Selected(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsQueue.Selected
        lblQCount.Text = String.Format("{0} Client(s) in Queue ", e.AffectedRows)
    End Sub

    Protected Sub gvQueue_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvQueue.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
            Case DataControlRowType.Pager
                SetPagerButtonStates(gvQueue, e.Row, Me.Page)
        End Select
    End Sub

    Protected Sub gvQueue_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvQueue.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                toggleQueueDisplay(e)
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                toggleQueueDisplay(e)
        End Select
    End Sub

    Protected Sub lnkClear_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClear.Click
        dsQueue.SelectParameters("QueueType").DefaultValue = QueueType
        Dim dv As DataView = dsQueue.Select(DataSourceSelectArguments.Empty)
        dv.RowFilter = Nothing

        gvQueue.DataSourceID = Nothing
        gvQueue.DataSource = dv
        gvQueue.DataBind()

        divMsg.Attributes("display") = ""
        divMsg.Attributes("class") = ""
        divMsg.InnerHtml = ""
        txtSearch.Text = ""
    End Sub

    Protected Sub lnkGo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkGo.Click
        Dim searchTerm As String = txtSearch.Text
        Dim sTerm As New StringBuilder
        sTerm.AppendFormat("[Display Name] like '%{0}%' or ", searchTerm)
        sTerm.AppendFormat("[Client Name] like '%{0}%'", searchTerm)
        Dim d As New DataSourceSelectArguments

        dsQueue.SelectParameters("QueueType").DefaultValue = QueueType
        Dim dv As DataView = dsQueue.Select(DataSourceSelectArguments.Empty)
        dv.RowFilter = sTerm.ToString

        gvQueue.DataSourceID = Nothing
        gvQueue.DataSource = dv
        gvQueue.DataBind()

        divMsg.Attributes("display") = "block"
        divMsg.Attributes("class") = "info"
        divMsg.InnerHtml = String.Format("Search Term : [{0}] found {1} result(s).", searchTerm, dv.Count)
    End Sub

    Private Shared Sub ExtractPOAFromLSA(ByVal DataClientID As Integer, ByVal UserID As Integer)
        Dim sqlLSA As String = String.Format("select top 1 '\\' + c.StorageServer + '\' + c.StorageRoot + '\' + c.accountnumber + case when dr.subfolder is null or dr.subfolder = 'ClientDocs' then '\ClientDocs\' else '\CreditorDocs\' + dr.subfolder end + c.accountnumber + '_' + dr.Doctypeid + '_' + dr.DocID + '_' + dr.DateString + '.pdf'[pdfPath] from tbldocrelation dr inner join tblclient c on c.clientid = dr.clientid where doctypeid in ('sd0001','sd0001SCAN','D2001','SD0001ESP','D2001SCAN','SD0001ESPSCAN') and c.clientid = {0} order by relateddate desc", DataClientID)

        Dim destDir As String = SharedFunctions.DocumentAttachment.CreateDirForClient(DataClientID) & "ClientDocs\"
        Dim docName = ReportsHelper.GetUniqueDocumentName(DataClientID, "9019")
        Dim lsaPath As String = SqlHelper.ExecuteScalar(sqlLSA, CommandType.Text)
        If File.Exists(lsaPath) Then
            Dim lsa As New iTextSharp.text.pdf.PdfReader(lsaPath)
            Dim lastPageIdx As Integer = lsa.NumberOfPages
            lsa.Close()
            lsa = Nothing
            'build new poapath
            Dim poaPath As String = String.Format("{0}{1}", destDir, ReportsHelper.GetUniqueDocumentName(DataClientID, "9019"))
            Dim doctypeid As String = Path.GetFileNameWithoutExtension(lsaPath).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)(1)
            Select Case lastPageIdx
                Case 11, 13, 14
                    Select Case doctypeid.ToUpper
                        Case "D2001"
                            lastPageIdx = 7
                        Case Else
                            lastPageIdx = 5
                    End Select
                Case 10
                    lastPageIdx = 6
                Case 18, 19
                    lastPageIdx = 7
                Case 20
                    lastPageIdx = 8
            End Select

            PdfManipulation.ExtractPdfPage(lsaPath, lastPageIdx, poaPath)

            Dim intNoteID As Integer = NoteHelper.InsertNote("Automated POA  extraction from LSA.", -1, DataClientID)
            'attach creditor copy of letter
            SharedFunctions.DocumentAttachment.AttachDocument("note", intNoteID, Path.GetFileName(poaPath), UserID)
            SharedFunctions.DocumentAttachment.AttachDocument("client", DataClientID, Path.GetFileName(poaPath), UserID)
            SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(poaPath), UserID, Now)
        Else
            Throw New Exception("No POA Extracted")
        End If
    End Sub

    Private Sub AttachDocumentToCreditor(ByVal DataClientID As String, ByVal accountID As String, ByVal filePath As String, ByVal tempName As String, ByVal strLogText As String, ByVal matterId As String)
        Dim noteid As Integer = NoteHelper.InsertNote(strLogText, CurrentUserID, DataClientID)           'attach client copy of letter
        NoteHelper.RelateNote(noteid, 1, DataClientID)              'relate to client
        NoteHelper.RelateNote(noteid, 2, accountID)                 'relate to creditor
        'attach  document
        SharedFunctions.DocumentAttachment.AttachDocument("note", noteid, Path.GetFileName(filePath), CurrentUserID, accountID + "_" + tempName & "\")
        SharedFunctions.DocumentAttachment.AttachDocument("account", accountID, Path.GetFileName(filePath), CurrentUserID, accountID + "_" + tempName & "\")
        If String.IsNullOrEmpty(matterId) Then
            SharedFunctions.DocumentAttachment.AttachDocument("matter", matterId, Path.GetFileName(filePath), _CurrentUserID, accountID + "_" + tempName & "\")
        End If
        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(filePath), CurrentUserID, Now)
    End Sub

    Private Sub GenerateAndPrintSAF(ByVal settID As String, ByVal dataclientID As Integer, ByVal docId As String, ByVal docName As String, ByVal generateCoverLetter As Boolean)
        Using reportObj As New GrapeCity.ActiveReports.SectionReport
            Using pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                    Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing
                    Dim matterId As String = 0
                    Dim acctID As String = 0
                    Dim createdByID As String = 0
                    Dim CreditorInstanceIDsCommaSeparated As String = AccountHelper.GetCurrentCreditorInstanceID(acctID)
                    Dim SettlementAgentName As String = ""
                    Dim SettlementAgentFax As String = ""
                    Dim SignBeforeDate As String = ""

                    Dim sqlInfo As New StringBuilder
                    sqlInfo.Append("select top 1 s.MatterID,s.CreditorAccountID,s.createdby,s.settlementduedate ,e.fullname,e.ext ")
                    sqlInfo.Append("from tblsettlements s inner join tbluser u on u.userid = s.createdby left join tblUserExt e on e.[login] = u.username ")
                    sqlInfo.AppendFormat("where settlementid = {0}", settID)
                    Using dt As DataTable = SqlHelper.GetDataTable(sqlInfo.ToString, CommandType.Text)
                        For Each row As DataRow In dt.Rows
                            matterId = row("matterid").ToString
                            acctID = row("CreditorAccountID").ToString
                            createdByID = row("createdby").ToString
                            SignBeforeDate = FormatDateTime(row("settlementduedate").ToString, DateFormat.ShortDate)
                            SettlementAgentName = row("fullname").ToString
                            SettlementAgentFax = String.Format("{0}", row("ext").ToString)
                            Exit For
                        Next
                    End Using
                    CreditorInstanceIDsCommaSeparated = AccountHelper.GetCurrentCreditorInstanceID(acctID)

                    Dim rootDir As New StringBuilder
                    'create client root directory
                    Try
                        rootDir.Append(SharedFunctions.DocumentAttachment.CreateDirForClient(dataclientID))
                    Catch e As Exception
                        divMsg.Attributes("display") = "block"
                        divMsg.Attributes("class") = "error"
                        divMsg.InnerHtml = String.Format("{0}", e.Message)
                    End Try

                    Dim CreditorName As String = AccountHelper.GetCreditorName(acctID)
                    Dim CreditorFolderPath As String = CreditorName
                    CreditorFolderPath = CreditorFolderPath.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
                    Dim filePath As String = GetUniqueDocumentNameForReports(rootDir.ToString, dataclientID, docId, CurrentUserID, "CreditorDocs\" + acctID + "_" + CreditorFolderPath + "\")
                    Dim credPath As String = String.Format("{0}CreditorDocs\{1}_{2}\", rootDir.ToString, acctID, CreditorFolderPath)
                    If Directory.Exists(credPath) = False Then
                        Directory.CreateDirectory(credPath)
                    End If

                    'main call for reports
                    Dim args As New List(Of String)
                    args.Add(dataclientID)
                    args.Add(CreditorInstanceIDsCommaSeparated)
                    args.Add(SettlementAgentName)
                    args.Add(SettlementAgentFax)
                    args.Add(SignBeforeDate)

                    If generateCoverLetter Then
                        'saf cover letter
                        rptDoc = rptTemplates.ViewTemplate("SettlementAgreementCoverLetter", dataclientID, args.ToArray, False, _CurrentUserID)
                        reportObj.Document.Pages.AddRange(rptDoc.Pages) 'add pages to report
                    End If

                    'saf
                    args = New List(Of String)
                    args.Add(dataclientID)
                    args.Add(settID)
                    rptDoc = rptTemplates.ViewTemplate(docName, dataclientID, args.ToArray, False, _CurrentUserID)
                    reportObj.Document.Pages.AddRange(rptDoc.Pages) 'add pages to report

                    Dim numPagesInReport As Integer = reportObj.Document.Pages.Count
                    Using fStream As New System.IO.FileStream(filePath, FileMode.CreateNew)
                        pdf.Export(reportObj.Document, fStream)
                    End Using
                    RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, filePath)

                    Dim strLogText As New StringBuilder
                    Dim sqlNote As String = "stp_NegotiationsSystemNoteInfo " & acctID
                    Using dtNote As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlNote, ConfigurationManager.AppSettings("connectionstring").ToString)
                        For Each dRow As DataRow In dtNote.Rows
                            strLogText.AppendFormat("{0}/{1} #{2}.  ", dRow("OriginalCreditorName").ToString, dRow("CurrentCreditorName").ToString, dRow("CreditorAcctLast4").ToString)
                            strLogText.AppendFormat("Settlement Acceptance Form Printed & Mailed from print queue for {0}." & Chr(13), dRow("CurrentCreditorName").ToString)
                            Exit For
                        Next
                    End Using

                    AttachDocumentToCreditor(dataclientID, acctID, filePath, CreditorFolderPath, strLogText.ToString, matterId)
                    InsertPrintInfo(docId, dataclientID, filePath, _CurrentUserID, numPagesInReport)

                    SqlHelper.ExecuteNonQuery(String.Format("update tblsettlements set safprinted = getdate() where settlementid = {0}", settID), CommandType.Text)
                End Using
            End Using
        End Using
    End Sub

    Private Function RePrintSAF(ByVal settID As String, ByVal dataclientID As Integer, ByVal docId As String, ByVal docName As String) As String
        Dim safDOCPath As String = ""
        Using reportObj As New GrapeCity.ActiveReports.SectionReport
            Using pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                    Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing
                    Dim matterId As String = 0
                    Dim acctID As String = 0
                    Dim createdByID As String = 0
                    Dim CreditorInstanceIDsCommaSeparated As String = AccountHelper.GetCurrentCreditorInstanceID(acctID)
                    Dim SettlementAgentName As String = ""
                    Dim SettlementAgentFax As String = ""
                    Dim SignBeforeDate As String = ""
                    Dim IsPaymentArrangement As Boolean
                    Dim PAByClient As Boolean

                    Dim sqlInfo As New StringBuilder
                    sqlInfo.Append("select top 1 s.MatterID,s.CreditorAccountID,s.createdby,s.settlementduedate ,e.fullname,e.ext, isnull(s.IsPaymentArrangement,0) [IsPaymentArrangement], PAByClient  ")
                    sqlInfo.Append("from tblsettlements s inner join tbluser u on u.userid = s.createdby left join tblUserExt e on e.[login] = u.username ")
                    sqlInfo.AppendFormat("where settlementid = {0}", settID)
                    Using dt As DataTable = SqlHelper.GetDataTable(sqlInfo.ToString, CommandType.Text)
                        For Each row As DataRow In dt.Rows
                            matterId = row("matterid").ToString
                            acctID = row("CreditorAccountID").ToString
                            createdByID = row("createdby").ToString
                            SignBeforeDate = FormatDateTime(row("settlementduedate").ToString, DateFormat.ShortDate)
                            SettlementAgentName = row("fullname").ToString
                            SettlementAgentFax = String.Format("{0}", row("ext").ToString)
                            IsPaymentArrangement = row("IsPaymentArrangement")
                            PAByClient = row("PAByClient")
                            Exit For
                        Next
                    End Using
                    CreditorInstanceIDsCommaSeparated = AccountHelper.GetCurrentCreditorInstanceID(acctID)

                    Dim rootDir As New StringBuilder
                    'create client root directory
                    Try
                        rootDir.Append(SharedFunctions.DocumentAttachment.CreateDirForClient(dataclientID))
                        Dim CreditorName As String = AccountHelper.GetCreditorName(acctID)
                        Dim CreditorFolderPath As String = CreditorName
                        CreditorFolderPath = CreditorFolderPath.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
                        Dim filePath As String = GetUniqueDocumentNameForReports(rootDir.ToString, dataclientID, docId, CurrentUserID, "CreditorDocs\" + acctID + "_" + CreditorFolderPath + "\")
                        Dim credPath As String = String.Format("{0}CreditorDocs\{1}_{2}\", rootDir.ToString, acctID, CreditorFolderPath)
                        If Directory.Exists(credPath) = False Then
                            Directory.CreateDirectory(credPath)
                        End If
                        safDOCPath = filePath

                        'main call for reports 
                        'saf
                        Dim args As New List(Of String)
                        args = New List(Of String)
                        args.Add(dataclientID)
                        args.Add(settID)
                        Dim cRpt As GrapeCity.ActiveReports.SectionReport = Nothing
                        If Not IsPaymentArrangement Then
                            cRpt = New SettlementAcceptanceForm_v3(docName, settID, _CurrentUserID, Path.GetFileNameWithoutExtension(safDOCPath).Split("_")(2), False)
                        ElseIf PAByClient Then
                            cRpt = New SettlementAcceptanceFormFinalPaymentArrangement(docName, settID, _CurrentUserID, Path.GetFileNameWithoutExtension(safDOCPath).Split("_")(2), False)
                        Else
                            cRpt = New SettlementAcceptanceFormPaymentArrangement_v3(docName, settID, _CurrentUserID, Path.GetFileNameWithoutExtension(safDOCPath).Split("_")(2), False)
                        End If
                        cRpt.Run()
                        reportObj.Document.Pages.AddRange(cRpt.Document.Pages) 'add pages to report

                        Dim numPagesInReport As Integer = reportObj.Document.Pages.Count
                        Using fStream As New System.IO.FileStream(safDOCPath, FileMode.CreateNew)
                            pdf.Export(reportObj.Document, fStream)
                        End Using

                        Dim strLogText As New StringBuilder
                        Dim sqlNote As String = "stp_NegotiationsSystemNoteInfo " & acctID
                        Using dtNote As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlNote, ConfigurationManager.AppSettings("connectionstring").ToString)
                            For Each dRow As DataRow In dtNote.Rows
                                strLogText.AppendFormat("{0}/{1} #{2}.  ", dRow("OriginalCreditorName").ToString, dRow("CurrentCreditorName").ToString, dRow("CreditorAcctLast4").ToString)
                                strLogText.AppendFormat("Settlement Acceptance Form Printed & Mailed from print queue for {0}." & Chr(13), dRow("CurrentCreditorName").ToString)
                                Exit For
                            Next
                        End Using
                        AttachDocumentToCreditor(dataclientID, acctID, safDOCPath, CreditorFolderPath, strLogText.ToString, matterId)

                        SqlHelper.ExecuteNonQuery(String.Format("update tblsettlements set safprinted = getdate() where settlementid = {0}", settID), CommandType.Text)
                    Catch e As Exception
                        divMsg.Attributes("display") = "block"
                        divMsg.Attributes("class") = "error"
                        divMsg.InnerHtml = String.Format("{0}", e.Message)
                    End Try

                    Return safDOCPath
                End Using
            End Using
        End Using
    End Function

    Private Function PrintReprintQueue() As QResults
        Dim qr As New QResults
        Dim docCnt As Integer = 0
        For Each row As GridViewRow In gvQueue.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")  'TryCast(row.Controls(0).Controls(1), System.Web.UI.WebControls.CheckBox)
                If chk.Checked = True Then
                    Dim reprintPath As String = dks("PrintDocumentPath").ToString
                    RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, reprintPath)
                    docCnt += 1
                End If
            End If
        Next
        qr.DocumentCount = docCnt
        qr.ResultMessage = String.Format("{0} Document(s) Printed.", docCnt)
        Return qr
    End Function

    Private Function PrintClientStatements() As QResults
        Dim qr As New QResults
        Dim docCnt As Integer = 0

        For Each row As GridViewRow In gvQueue.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")  'TryCast(row.Controls(0).Controls(1), System.Web.UI.WebControls.CheckBox)
                If chk.Checked = True Then
                    Dim StmtPath As String = dks("PrintDocumentPath").ToString
                    RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, StmtPath)
                    docCnt += 1
                End If
            End If
        Next
        qr.DocumentCount = docCnt
        qr.ResultMessage = String.Format("{0} Document(s) Printed.", docCnt)
        Return qr
    End Function

    Private Function PrintSettlementKit() As QResults
        Dim qr As New QResults
        Dim docName As String = "FinalizedSettlementKitCoverLetter"
        Dim docId As String = "D5005"
        Dim iMissingSaf As Integer = 0
        Dim iEmailSentCnt As Integer = 0
        Dim docCnt As Integer = 0

        For Each row As GridViewRow In gvQueue.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")  'TryCast(row.Controls(0).Controls(1), System.Web.UI.WebControls.CheckBox)
                If chk.Checked = True Then
                    Dim emailMergeDocPath As String = ""
                    Using reportObj As New GrapeCity.ActiveReports.SectionReport
                        Using pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                            Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                                Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing
                                Dim settID As String = dks("qid").ToString()
                                Dim MatterId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "MatterId", "SettlementId = " & settID))
                                Dim dataclientID As Integer = dks("DataClientID").ToString()
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
                                Try
                                    rootDir.Append(SharedFunctions.DocumentAttachment.CreateDirForClient(dataclientID))
                                Catch e As Exception
                                    divMsg.Attributes("display") = "block"
                                    divMsg.Attributes("class") = "error"
                                    divMsg.InnerHtml = String.Format("{0}", e.Message)
                                End Try

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
                                        Else
                                            'main call for reports
                                            'ccastelo - commented out printing of documents 
                                            RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, emailMergeDocPath)
                                            nid = NoteHelper.InsertNote("Final Settlement Kit Printed & Mailed from print queue.", _CurrentUserID, dataclientID)
                                        End If

                                        SharedFunctions.DocumentAttachment.AttachDocument("note", nid, Path.GetFileName(emailMergeDocPath), CurrentUserID)
                                        SharedFunctions.DocumentAttachment.AttachDocument("account", acctID, Path.GetFileName(emailMergeDocPath), CurrentUserID)
                                        SharedFunctions.DocumentAttachment.AttachDocument("matter", MatterId, Path.GetFileName(emailMergeDocPath), CurrentUserID)
                                        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(emailMergeDocPath), CurrentUserID, Now)
                                        InsertPrintInfo(docId, dataclientID, emailMergeDocPath, _CurrentUserID, numPagesInReport)
                                    End If
                                End Using
                            End Using
                        End Using
                    End Using
                    docCnt += 1
                End If
            End If
        Next
        qr.DocumentCount = docCnt
        qr.ResultMessage = String.Format("{0} Document(s) FSK's Processed. {1} Documents(s) Emailed.  {2} Client(s) Missing SAF.  ", docCnt, iEmailSentCnt, iMissingSaf)
        Return qr
    End Function

    Private Function IsPrinterNeeded() As Boolean
        Select Case QueueType
            Case enumPrintQueueType.FinalSettlementKitPAPaymentsByClient
                For Each row As GridViewRow In gvQueue.Rows
                    If row.RowType = DataControlRowType.DataRow Then
                        Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")
                        If chk.Checked = True Then
                            If row.Cells(7).Text.ToLower.Contains("16x16_print.png") Then
                                Return True
                            End If
                        End If
                    End If
                Next
                Return False
            Case Else
                Return True
        End Select
    End Function

    Private Function PrintPAbyClientSettlementKit() As QResults
        Dim qr As New QResults
        Dim docName As String = "FinalizedSettlementKitCoverLetter"
        Dim docId As String = "D5005"
        Dim iMissingSaf As Integer = 0
        Dim iEmailSentCnt As Integer = 0
        Dim docCnt As Integer = 0

        For Each row As GridViewRow In gvQueue.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")
                If chk.Checked = True Then
                    Dim emailMergeDocPath As String = ""
                    Using reportObj As New GrapeCity.ActiveReports.SectionReport
                        Using pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                            Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                                Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing
                                Dim settID As String = dks("qid").ToString()
                                Dim MatterId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "MatterId", "SettlementId = " & settID))
                                Dim dataclientID As Integer = dks("DataClientID").ToString()
                                Dim acctID As String = SqlHelper.ExecuteScalar(String.Format("select CreditorAccountID from tblsettlements where settlementid = {0}", settID), CommandType.Text)
                                Dim rootDir As New StringBuilder
                                Dim SifPath As String = SettlementMatterHelper.GetSIFForPrinting(MatterId)
                                Dim CheckPath As String = SettlementMatterHelper.GetCheckPathForPrinting(MatterId)
                                Dim SAFPath As String = SettlementMatterHelper.GetSAFPathForPrinting(MatterId, settID)
                                Dim RELPath As String = SettlementMatterHelper.GetRELPathForPrinting(MatterId, settID)
                                Dim SignedStip As String = SettlementMatterHelper.GetSignedStipulationPathForPrinting(MatterId)

                                If SAFPath.Trim = "" Then
                                    iMissingSaf += 1
                                    SAFPath = RePrintSAF(settID, dataclientID, "D6004", "SettlementAcceptanceForm")
                                End If

                                'create client root directory
                                Try
                                    rootDir.Append(SharedFunctions.DocumentAttachment.CreateDirForClient(dataclientID))
                                Catch e As Exception
                                    divMsg.Attributes("display") = "block"
                                    divMsg.Attributes("class") = "error"
                                    divMsg.InnerHtml = String.Format("{0}", e.Message)
                                End Try

                                Dim filePath As String = SharedFunctions.DocumentAttachment.GetUniqueDocumentName(docId, dataclientID)
                                Dim credPath As String = String.Format("{0}ClientDocs\", rootDir.ToString)
                                If Directory.Exists(credPath) = False Then
                                    Directory.CreateDirectory(credPath)
                                End If

                                'get client email address
                                'if exists send email else print
                                Dim numPagesInReport As Integer = 0
                                Dim clientEmail As String = ""
                                If row.Cells(7).Text.ToLower.Contains("16x16_email.png") Then
                                    clientEmail = row.Cells(7).Text.Replace("&nbsp;", "|").Split("|")(1).Trim
                                End If
                                clientEmail = "opereira@lexxiom.com"
                                'Dim cvrLtrPath As String = credPath & filePath
                                'Dim args As New List(Of String)

                                'args.Add(dataclientID)
                                'rptDoc = rptTemplates.ViewTemplate(docName, dataclientID, args.ToArray, False, _CurrentUserID)
                                'add pages to report
                                'reportObj.Document.Pages.AddRange(rptDoc.Pages)
                                'numPagesInReport = reportObj.Document.Pages.Count
                                'Using fStream As New System.IO.FileStream(cvrLtrPath, FileMode.CreateNew)
                                'pdf.Export(reportObj.Document, fStream)
                                'End Using

                                docName = "FinalPaymentArrangementAccount"
                                Dim PALetterID As String = "D9069"
                                Dim creditorDir As String = SharedFunctions.DocumentAttachment.GetCreditorDir(acctID)
                                filePath = SharedFunctions.DocumentAttachment.GetUniqueDocumentName(PALetterID, dataclientID)
                                Dim strDocID As String = SettlementMatterHelper.GetDocIdFromPath(filePath)
                                Dim pmtLtrPath As String = SharedFunctions.DocumentAttachment.BuildAttachmentPath(PALetterID, strDocID, DateTime.Now.ToString("yyMMdd"), dataclientID, creditorDir)
                                Dim parentDirectory As String = Directory.GetParent(pmtLtrPath).FullName
                                If Not Directory.Exists(parentDirectory) Then
                                    Directory.CreateDirectory(parentDirectory)
                                End If


                                rptDoc = rptTemplates.Generate_SettlementPaymentLetter(settID, CurrentUserID)
                                'add pages to report
                                reportObj.Document.Pages.Clear()
                                reportObj.Document.Pages.AddRange(rptDoc.Pages)
                                numPagesInReport = reportObj.Document.Pages.Count
                                Using fStream As New System.IO.FileStream(pmtLtrPath, FileMode.CreateNew)
                                    pdf.Export(reportObj.Document, fStream)
                                End Using
                                SharedFunctions.DocumentAttachment.AttachDocument("account", acctID, Path.GetFileName(pmtLtrPath), CurrentUserID)
                                SharedFunctions.DocumentAttachment.AttachDocument("matter", MatterId, Path.GetFileName(pmtLtrPath), CurrentUserID)
                                SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(pmtLtrPath), CurrentUserID, Now)

                                Using dtMerge As New DataTable

                                    dtMerge.Columns.Add("DocPath", GetType(System.String))
                                    dtMerge.Columns.Add("DocPages", GetType(System.String))

                                    'If Not String.IsNullOrEmpty(cvrLtrPath) AndAlso File.Exists(cvrLtrPath) Then
                                    'Dim nr As DataRow = dtMerge.NewRow
                                    'nr(0) = cvrLtrPath
                                    'nr(1) = "1"
                                    'dtMerge.Rows.Add(nr)
                                    'End If

                                    If Not String.IsNullOrEmpty(pmtLtrPath) AndAlso File.Exists(pmtLtrPath) Then
                                        Dim nr As DataRow = dtMerge.NewRow
                                        nr(0) = pmtLtrPath
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
                                    If Not String.IsNullOrEmpty(SignedStip) AndAlso File.Exists(SignedStip) Then
                                        Dim nr As DataRow = dtMerge.NewRow
                                        nr(0) = SignedStip
                                        nr(1) = "0"
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
                                        Else
                                            'main call for reports
                                            RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, emailMergeDocPath)
                                            nid = NoteHelper.InsertNote("Final Settlement Kit Printed & Mailed from print queue.", _CurrentUserID, dataclientID)
                                        End If

                                        SharedFunctions.DocumentAttachment.AttachDocument("note", nid, Path.GetFileName(emailMergeDocPath), CurrentUserID)
                                        SharedFunctions.DocumentAttachment.AttachDocument("account", acctID, Path.GetFileName(emailMergeDocPath), CurrentUserID)
                                        SharedFunctions.DocumentAttachment.AttachDocument("matter", MatterId, Path.GetFileName(emailMergeDocPath), CurrentUserID)
                                        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(emailMergeDocPath), CurrentUserID, Now)
                                        InsertPrintInfo(docId, dataclientID, emailMergeDocPath, _CurrentUserID, numPagesInReport)
                                    End If
                                End Using
                            End Using
                        End Using
                    End Using
                    docCnt += 1
                End If
            End If
        Next
        qr.DocumentCount = docCnt
        qr.ResultMessage = String.Format("{0} Document(s) FSK's for P.A. when client makes the payments Processed. {1} Documents(s) Emailed.  {2} Client(s) Missing SAF.  ", docCnt, iEmailSentCnt, iMissingSaf)
        Return qr
    End Function

    Private Function PrintClientDepositCheck() As QResults
        Dim qr As New QResults
        Dim docName As String = ""
        Dim docId As String = ""
        Dim docCnt As Integer = 0
        Dim dtMerge As New DataTable

        dtMerge.Columns.Add("DocPath", GetType(System.String))
        dtMerge.Columns.Add("DocPages", GetType(System.String))

        For Each row As GridViewRow In gvQueue.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")  'TryCast(row.Controls(0).Controls(1), System.Web.UI.WebControls.CheckBox)
                If chk.Checked = True Then
                    Using reportObj As New GrapeCity.ActiveReports.SectionReport
                        Using pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                            Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                                Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing
                                Dim nacharegisterid As Integer = dks("qid").ToString()
                                Dim cid As Integer = dks("DataClientID").ToString()
                                Dim acct As String = dks("PrintDocumentPath").ToString()
                                Dim rootDir As New StringBuilder
                                'create client root directory
                                Try
                                    'rootDir.Append(SharedFunctions.DocumentAttachment.CreateDirForClient(cid))
                                Catch e As Exception
                                    Throw e
                                End Try
                                docName = "ClientDepositCheck"
                                docId = "C1001"
                                Dim filePath As String = GetUniqueDocumentNameForReports(cid, docId, _CurrentUserID)
                                'filePath = "c:/clientcheckdeposits/" + filePath
                                filePath = "C:/clientcheckdeposits/" + filePath
                                'main call for reports

                                Dim params As New List(Of SqlClient.SqlParameter)
                                params.Add(New SqlClient.SqlParameter("nacharegisterid", nacharegisterid))

                                Dim dt As DataTable = SqlHelper.GetDataTable("stp_Check_getNachaRegisterDetails", CommandType.StoredProcedure, params.ToArray)
                                Dim registerid As String = dt.Rows(0)("registerid").ToString
                                Dim phonenumber As String = dt.Rows(0)("phone").ToString
                                Dim checkAmount As String = dt.Rows(0)("amount").ToString
                                Dim cHelper As New CheckHelper
                                Dim amountText As String = cHelper.AmountToText(CDbl(checkAmount)).Replace(",", "-")
                                Dim memo As String = "Monthly Deposit for Acct #" + dt.Rows(0)("AccountNumber").ToString
                                Dim recipient As String = dt.Rows(0)("CheckDepositDisplay").ToString

                                Dim args As New List(Of String)
                                args.Add("")
                                args.Add(phonenumber)
                                args.Add(registerid)
                                args.Add(checkAmount)
                                args.Add(amountText.ToString())
                                args.Add(memo)
                                args.Add(recipient)
                                rptDoc = rptTemplates.ViewTemplate(docName, cid, args.ToArray, False, _CurrentUserID, Path.GetFileNameWithoutExtension(filePath).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)(2))
                                'add pages to report
                                reportObj.Document.Pages.AddRange(rptDoc.Pages)
                                Dim numPagesInReport As Integer = reportObj.Document.Pages.Count
                                Using fStream As New System.IO.FileStream(filePath, FileMode.CreateNew)
                                    pdf.Export(reportObj.Document, fStream)
                                End Using

                                'RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, filePath)

                                If Not String.IsNullOrEmpty(filePath) AndAlso File.Exists(filePath) Then
                                    Dim nr As DataRow = dtMerge.NewRow
                                    nr(0) = filePath
                                    nr(1) = "1"
                                    dtMerge.Rows.Add(nr)
                                End If

                                SharedFunctions.DocumentAttachment.AttachDocument("client", cid, Path.GetFileName(filePath), _CurrentUserID, "ClientDocs")
                                SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(filePath), _CurrentUserID, Now)
                                InsertPrintInfo(docId, cid, filePath, _CurrentUserID, numPagesInReport)
                                UpdateNachaRecord(nacharegisterid, _CurrentUserID)
                            End Using
                        End Using
                    End Using
                    docCnt += 1
                End If
            End If
        Next

        If dtMerge.Rows.Count > 0 Then
            Dim emailMergeDocPath As String = "C:/clientcheckdeposits/merged/" + Now.ToString("yyyy_MM_dd_HHmmss") + ".pdf"
            PdfManipulation.ExtractAndMergePdfPages(dtMerge, emailMergeDocPath)
        End If

        qr.DocumentCount = docCnt
        qr.ResultMessage = String.Format("{0} Document(s) Printed.", docCnt)
        Return qr
    End Function

    Private Function PrintAttorneyPaymentCheck() As QResults
        Dim qr As New QResults
        Dim docName As String = ""
        Dim docId As String = ""
        Dim docCnt As Integer = 0
        Dim dtMerge As New DataTable

        dtMerge.Columns.Add("DocPath", GetType(System.String))
        dtMerge.Columns.Add("DocPages", GetType(System.String))

        For Each row As GridViewRow In gvQueue.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")  'TryCast(row.Controls(0).Controls(1), System.Web.UI.WebControls.CheckBox)
                If chk.Checked = True Then
                    Using reportObj As New GrapeCity.ActiveReports.SectionReport
                        Using pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                            Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                                Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing
                                Dim nacharegisterid As Integer = dks("qid").ToString()
                                Dim cid As Integer = dks("DataClientID").ToString()
                                Dim acct As String = dks("PrintDocumentPath").ToString()
                                Dim rootDir As New StringBuilder
                                'create client root directory
                                Try
                                    'rootDir.Append(SharedFunctions.DocumentAttachment.CreateDirForClient(cid))
                                Catch e As Exception
                                    Throw e
                                End Try
                                docName = "ClientDepositCheck"
                                docId = "C1001"
                                Dim filePath As String = GetUniqueDocumentNameForReports(cid, docId, _CurrentUserID)
                                'filePath = "c:/clientcheckdeposits/" + filePath
                                filePath = "C:/clientcheckdeposits/" + filePath
                                'main call for reports

                                Dim params As New List(Of SqlClient.SqlParameter)
                                params.Add(New SqlClient.SqlParameter("nacharegisterid", nacharegisterid))

                                Dim dt As DataTable = SqlHelper.GetDataTable("stp_Check_getNachaRegisterDetails", CommandType.StoredProcedure, params.ToArray)
                                Dim registerid As String = dt.Rows(0)("registerid").ToString
                                Dim phonenumber As String = dt.Rows(0)("phone").ToString
                                Dim checkAmount As String = dt.Rows(0)("amount").ToString
                                Dim cHelper As New CheckHelper
                                Dim amountText As String = cHelper.AmountToText(CDbl(checkAmount)).Replace(",", "-")
                                Dim memo As String = "Monthly Deposit for Acct #" + dt.Rows(0)("AccountNumber").ToString
                                Dim recipient As String = dt.Rows(0)("CheckDepositDisplay").ToString

                                Dim args As New List(Of String)
                                args.Add("")
                                args.Add(phonenumber)
                                args.Add(registerid)
                                args.Add(checkAmount)
                                args.Add(amountText.ToString())
                                args.Add(memo)
                                args.Add(recipient)
                                rptDoc = rptTemplates.ViewTemplate(docName, cid, args.ToArray, False, _CurrentUserID, Path.GetFileNameWithoutExtension(filePath).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)(2))
                                'add pages to report
                                reportObj.Document.Pages.AddRange(rptDoc.Pages)
                                Dim numPagesInReport As Integer = reportObj.Document.Pages.Count
                                Using fStream As New System.IO.FileStream(filePath, FileMode.CreateNew)
                                    pdf.Export(reportObj.Document, fStream)
                                End Using

                                'RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, filePath)

                                If Not String.IsNullOrEmpty(filePath) AndAlso File.Exists(filePath) Then
                                    Dim nr As DataRow = dtMerge.NewRow
                                    nr(0) = filePath
                                    nr(1) = "1"
                                    dtMerge.Rows.Add(nr)
                                End If

                                SharedFunctions.DocumentAttachment.AttachDocument("client", cid, Path.GetFileName(filePath), _CurrentUserID, "ClientDocs")
                                SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(filePath), _CurrentUserID, Now)
                                InsertPrintInfo(docId, cid, filePath, _CurrentUserID, numPagesInReport)
                                UpdateNachaRecord(nacharegisterid, _CurrentUserID)
                            End Using
                        End Using
                    End Using
                    docCnt += 1
                End If
            End If
        Next

        If dtMerge.Rows.Count > 0 Then
            Dim emailMergeDocPath As String = "C:/clientcheckdeposits/merged/" + Now.ToString("yyyy_MM_dd_HHmmss") + ".pdf"
            PdfManipulation.ExtractAndMergePdfPages(dtMerge, emailMergeDocPath)
        End If

        qr.DocumentCount = docCnt
        qr.ResultMessage = String.Format("{0} Document(s) Printed.", docCnt)
        Return qr
    End Function
    Private Function PrintNonDeposit() As QResults
        Return PrintNondepositLetter()
    End Function

    Private Function PrintBouncedDeposit() As QResults
        Return PrintNondepositLetter()
    End Function

    Private Function PrintLOR() As QResults
        Dim qr As New QResults
        Dim docCnt As Integer = 0
        For Each row As GridViewRow In gvQueue.Rows
            Try
                If row.RowType = DataControlRowType.DataRow Then
                    Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
                    Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")
                    If chk.Checked = True Then
                        Dim dataclientid As Integer = CInt(dks("qid").ToString())
                        Dim poaPath As String = FindPOAByClientID(dataclientid)
                        If poaPath.ToString.Trim <> "" Then

                            Dim ssql As New StringBuilder
                            ssql.Append("select distinct [docpath]= '\\' + c.storageserver + '\' + c.storageroot + '\' + c.accountnumber + '\CreditorDocs\' + dr.subfolder ")
                            ssql.Append("+ c.accountnumber + '_' + dr.doctypeid + '_' + dr.docid + '_' + dr.datestring + '.pdf', a.accountid, dr.subfolder  ")
                            ssql.Append(",[CreditorDocsFolder]= '\\' + c.storageserver + '\' + c.storageroot + '\' + c.accountnumber + '\CreditorDocs\' ")
                            ssql.Append("from tbldocrelation dr with(nolock) inner join tblclient c with(nolock) on c.clientid = dr.clientid ")
                            ssql.Append("inner join tblaccount a with(nolock) on a.accountid = dr.relationid ")
                            ssql.AppendFormat("where dr.clientid = {0} and doctypeid = 'D4006' ", dataclientid)
                            ssql.Append("and not  a.accountstatusid in (170,171,55)")
                            Using dt As DataTable = SqlHelper.GetDataTable(ssql.ToString, CommandType.Text)

                                Using MemStream As New System.IO.MemoryStream

                                    'build 1 big pdf: poa then loa
                                    Dim bigPdf As String = ""
                                    If dt.Rows.Count > 0 Then
                                        bigPdf = String.Format("{0}All_LORS_With_Poa.pdf", dt.Rows(0)("CreditorDocsFolder").ToString)
                                    End If
                                    Dim doc As New iTextSharp.text.Document()
                                    Dim writer As PdfWriter = PdfWriter.GetInstance(doc, New FileStream(bigPdf, FileMode.Create))
                                    doc.Open()

                                    Dim cb As iTextSharp.text.pdf.PdfContentByte = writer.DirectContent
                                    Dim rotation As Integer = 0
                                    Dim poaReader As New iTextSharp.text.pdf.PdfReader(poaPath)

                                    For Each dr As DataRow In dt.Rows
                                        Try

                                            'attach lor to creditor
                                            Dim lorpath As String = dr("docpath").ToString
                                            InsertPrintInfo("D4006", dataclientid, lorpath, _CurrentUserID, 1)
                                            SharedFunctions.DocumentAttachment.AttachDocument("account", dr("accountid").ToString, Path.GetFileName(lorpath), _CurrentUserID, dr("subfolder").ToString)
                                            SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(lorpath), _CurrentUserID, Now)

                                            'add poa to master document
                                            doc.SetPageSize(PageSize.LETTER)
                                            doc.NewPage()
                                            Dim poaPage As PdfImportedPage = writer.GetImportedPage(poaReader, 1)
                                            rotation = poaReader.GetPageRotation(1)
                                            If (rotation = 90) Or (rotation = 270) Then
                                                cb.AddTemplate(poaPage, 0, -1.0F, 1.0F, 0, 0, poaReader.GetPageSizeWithRotation(1).Height)
                                            Else
                                                cb.AddTemplate(poaPage, 1.0F, 0, 0, 1.0F, 0, 0)
                                            End If

                                            'add lor to master document after poa
                                            Dim lorReader As New iTextSharp.text.pdf.PdfReader(lorpath)
                                            doc.SetPageSize(PageSize.LETTER)
                                            doc.NewPage()
                                            Dim lorPage As PdfImportedPage = writer.GetImportedPage(lorReader, 1)
                                            rotation = lorReader.GetPageRotation(1)
                                            If (rotation = 90) Or (rotation = 270) Then
                                                cb.AddTemplate(lorPage, 0, -1.0F, 1.0F, 0, 0, lorReader.GetPageSizeWithRotation(1).Height)
                                            Else
                                                cb.AddTemplate(lorPage, 1.0F, 0, 0, 1.0F, 0, 0)
                                            End If
                                            lorReader.Close()
                                            lorReader = Nothing

                                        Catch ex As Exception
                                            Continue For
                                        End Try
                                    Next
                                    poaReader.Close()
                                    poaReader = Nothing

                                    'print big pdf
                                    doc.Close()
                                    doc = Nothing

                                    RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, bigPdf)

                                End Using


                            End Using

                            docCnt += 1
                        Else
                            qr.ResultMessage += String.Format("{0} has no POA on file.", row.Cells(3).Text)
                            Continue For

                        End If
                        'Clean Letter from Queue

                    End If
                End If
            Catch ex As Exception
                qr.ResultMessage += String.Format(",Error:{0}.", ex.Message.ToCharArray)
                Continue For
            End Try

        Next
        qr.DocumentCount = docCnt
        qr.ResultMessage += String.Format("{0} Document(s) Printed.", docCnt)
        Return qr
    End Function

    Private Function PrintNondepositLetter() As QResults
        Dim qr As New QResults
        Dim docCnt As Integer = 0
        For Each row As GridViewRow In gvQueue.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")
                If chk.Checked = True Then
                    Dim NonDepositLetterId As Integer = CInt(dks("qid").ToString())
                    Dim dt As DataTable = NonDepositHelper.GetNonDepositLetterToPrint(NonDepositLetterId)
                    If dt Is Nothing OrElse dt.Rows.Count = 0 Then Throw New Exception("Cannot generate a non deposit letter because a non deposit record does not exist.")
                    Dim dr As DataRow = dt.Rows(0)
                    Dim DataClientId As Integer = dr("ClientId")
                    Dim LetterToSend As String = dr("LetterType")
                    Dim DocPath As String = ""
                    If Not dr("Filename") Is DBNull.Value AndAlso File.Exists(dr("Filename").ToString.Trim) Then
                        DocPath = dr("Filename").ToString.Trim
                    Else
                        DocPath = NonDepositHelper.GenerateLetter(NonDepositLetterId, _CurrentUserID)
                    End If
                    Dim emails As String = NonDepositHelper.GetValidClientEmailAdresses(DataClientId)
                    Dim sentToEmail As Boolean = False
                    If emails.Trim.Length > 0 Then
                        sentToEmail = NonDepositHelper.SendLetterByEmail("donotreply@lawfirmcs.com", emails, DocPath)
                    End If
                    If Not sentToEmail Then
                        RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, DocPath)
                    End If
                    InsertPrintInfo(LetterToSend, DataClientId, DocPath.Substring(DocPath.LastIndexOf("\")), _CurrentUserID, 1)
                    'Clean Letter from Queue
                    NonDepositHelper.UpdateLetter(NonDepositLetterId, "", Now, _CurrentUserID, sentToEmail)
                    docCnt += 1
                End If
            End If
        Next
        qr.DocumentCount = docCnt
        qr.ResultMessage = String.Format("{0} Document(s) Printed.", docCnt)
        Return qr
    End Function

    'Private Function PrintPendingCancellationNotice() As Integer
    '    Dim docCnt As Integer = 0
    '    For Each row As GridViewRow In gvQueue.Rows
    '        If row.RowType = DataControlRowType.DataRow Then
    '            Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
    '            Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")
    '            If chk.Checked = True Then
    '                Dim MatterId As Integer = CInt(dks("qid").ToString())
    '                Dim dataclientID As Integer = CInt(dks("DataClientID").ToString())
    '                Dim ActionDate As DateTime = CDate(row.Cells(6).Text)
    '                Dim CheckPath As String = PendingCancelHelper.GeneratePendingCancellationLetter(MatterId, dataclientID, _CurrentUserID, ActionDate, "D5023")
    '                RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, CheckPath)
    '                InsertPrintInfo("D5023", dataclientID, CheckPath.Substring(CheckPath.LastIndexOf("\")), _CurrentUserID, 1)
    '                'CheckPath = PendingCancelHelper.GeneratePendingCancellationLetter(MatterId, dataclientID, _CurrentUserID, ActionDate, "D5015")
    '                'RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, CheckPath)
    '                'InsertPrintInfo("D5015", dataclientID, CheckPath.Substring(CheckPath.LastIndexOf("\")), _CurrentUserID, 1)
    '                docCnt += 1
    '            End If
    '        End If
    '    Next
    '    Return docCnt
    'End Function
    'Private Function PrintBankruptcyRequestNotice() As Integer
    '    Dim docCnt As Integer = 0
    '    For Each row As GridViewRow In gvQueue.Rows
    '        If row.RowType = DataControlRowType.DataRow Then
    '            Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
    '            Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")
    '            If chk.Checked = True Then
    '                Dim MatterId As Integer = CInt(dks("qid").ToString())
    '                Dim dataclientID As Integer = CInt(dks("DataClientID").ToString())
    '                Dim ActionDate As DateTime = CDate(row.Cells(6).Text)
    '                Dim CheckPath As String = PendingCancelHelper.GeneratePendingCancellationLetter(MatterId, dataclientID, _CurrentUserID, ActionDate, "D8019")
    '                RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, CheckPath)
    '                InsertPrintInfo("D8019", dataclientID, CheckPath.Substring(CheckPath.LastIndexOf("\")), _CurrentUserID, 1)
    '                docCnt += 1
    '            End If
    '        End If
    '    Next
    '    Return docCnt
    'End Function

    Private Function PrintSettlementQueue() As QResults
        Dim qr As New QResults
        Dim docName As String = "SettlementAcceptanceForm"
        Dim docId As String = "D6004"

        Dim docCnt As Integer = 0
        For Each row As GridViewRow In gvQueue.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")  'TryCast(row.Controls(0).Controls(1), System.Web.UI.WebControls.CheckBox)
                If chk.Checked = True Then
                    Dim settID As String = dks("qid").ToString()
                    Dim MatterId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "MatterId", "SettlementId = " & settID))
                    Dim SAFPath As String = SettlementMatterHelper.GetSAFPathForPrinting(MatterId)

                    If String.IsNullOrEmpty(SAFPath) AndAlso File.Exists(SAFPath) Then
                        RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, SAFPath)
                    Else
                        Me.GenerateAndPrintSAF(settID, dks("DataClientID").ToString(), "D6004", "SettlementAcceptanceForm", True)
                    End If
                    docCnt += 1
                End If
            End If
        Next
        qr.DocumentCount = docCnt
        qr.ResultMessage = String.Format("{0} Document(s) Printed.", docCnt)
        Return qr
    End Function

    Private Shared Function FindPOAByClientID(ByVal dataClientID As String) As String
        Dim signedPoaPath As String = ""
        Dim clientDIR As New IO.DirectoryInfo(String.Format("{0}ClientDocs\", SharedFunctions.DocumentAttachment.CreateDirForClient(dataClientID)))
        Dim clientFiles As IO.FileInfo() = clientDIR.GetFiles("*.pdf", SearchOption.AllDirectories)
        For Each cFile As IO.FileInfo In clientFiles
            Dim fileParts As String() = Path.GetFileNameWithoutExtension(cFile.FullName).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
            If fileParts.Length > 1 Then
                Select Case fileParts(1).ToString
                    Case "9019", "9019SCAN"
                        signedPoaPath = cFile.FullName
                        Exit For
                End Select
            End If
        Next
        Return signedPoaPath
    End Function

    Private Shared Function FindPOA(ByVal rootDir As StringBuilder) As String
        Dim signedPoaPath As String = ""
        Dim clientDIR As New IO.DirectoryInfo(String.Format("{0}ClientDocs\", rootDir))
        Dim clientFiles As IO.FileInfo() = clientDIR.GetFiles("*.pdf", SearchOption.AllDirectories)
        For Each cFile As IO.FileInfo In clientFiles
            Dim fileParts As String() = Path.GetFileNameWithoutExtension(cFile.FullName).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
            If fileParts.Length > 1 Then
                Select Case fileParts(1).ToString
                    Case "9019", "9019SCAN"
                        signedPoaPath = cFile.FullName
                        Exit For
                End Select
            End If
        Next
        Return signedPoaPath
    End Function

    Private Function PrintClientStipulations() As QResults
        Dim docCnt As Integer = 0
        Dim qr As New QResults
        Dim results As New List(Of String)

        For Each row As GridViewRow In gvQueue.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")  'TryCast(row.Controls(0).Controls(1), System.Web.UI.WebControls.CheckBox)
                If chk.Checked = True Then
                    Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing
                    Dim dataclientID As Integer = dks("DataClientID").ToString()
                    Dim csPath As String = dks("PrintDocumentPath").ToString
                    Dim doc As New iTextSharp.text.pdf.PdfReader(csPath)
                    Dim numPagesInReport As Integer = doc.NumberOfPages
                    doc.Close()
                    doc = Nothing
                    RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, csPath)
                    InsertPrintInfo("D9012", dataclientID, csPath, _CurrentUserID, numPagesInReport)
                    docCnt += 1
                End If
            End If
        Next
        qr.DocumentCount = docCnt
        qr.ResultMessage = String.Format("{0} Client Stipulation(s) Printed", docCnt)
        Return qr
    End Function

    Private Function PrintWelcomePackage() As QResults
        Dim docCnt As Integer = 0
        Dim qr As New QResults
        Dim results As New List(Of String)

        For Each row As GridViewRow In gvQueue.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")  'TryCast(row.Controls(0).Controls(1), System.Web.UI.WebControls.CheckBox)
                If chk.Checked = True Then
                    Dim tblDocs As New DataTable
                    tblDocs.Columns.Add(New DataColumn("DocPath"))
                    tblDocs.Columns.Add(New DataColumn("Pages"))

                    Dim welcomePkgPath As String = ""
                    Dim signedPoaPath As String = ""
                    Using reportObj As New GrapeCity.ActiveReports.SectionReport
                        Using pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                            Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                                Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing
                                Dim dataclientID As Integer = dks("DataClientID").ToString()
                                Dim creditors As Dictionary(Of Integer, CreditorInfo) = GetCreditors(dataclientID)
                                Dim rootDir As New StringBuilder
                                rootDir.Append(SharedFunctions.DocumentAttachment.CreateDirForClient(dataclientID))

                                Try
                                    ExtractPOAFromLSA(dataclientID, CurrentUserID)
                                Catch ex As Exception
                                    results.Add(String.Format("{0} has no POA on file.", row.Cells(3).Text))
                                    Continue For
                                End Try

                                'find POA  and add
                                signedPoaPath = FindPOA(rootDir)

                                welcomePkgPath = String.Format("{0}ClientDocs\{1}", rootDir, SharedFunctions.DocumentAttachment.GetUniqueDocumentName("D4000K", dataclientID))
                                Dim tempWPkg As String = welcomePkgPath.Replace(".pdf", "_temp.pdf")
                                Dim nr As DataRow = tblDocs.NewRow
                                nr("docpath") = tempWPkg
                                nr("Pages") = "0"
                                tblDocs.Rows.Add(nr)
                                Dim crpt As New GrapeCity.ActiveReports.SectionReport

                                'main call for reports
                                'build list of documents to generate
                                Dim args As New List(Of String)
                                args.Add(dataclientID)
                                Dim letterLst As New SortedList
                                Dim bWelcomeCallLtrNeeded As Boolean = SqlHelper.ExecuteScalar(String.Format("Select isnull(WelcomeCallLetterNeeded,0)[WelcomeCallLetterNeeded] from tblclient where clientid = {0}", dataclientID), CommandType.Text)
                                If bWelcomeCallLtrNeeded Then
                                    letterLst.Add(1, "WelcomeCallLetter:D4010")
                                    letterLst.Add(2, "ClientLetter:D4000")
                                    letterLst.Add(3, "InformationSheet:D4001")
                                    letterLst.Add(4, "LegalServiceAgreementOnlyScheduleA:SD0003")
                                Else
                                    letterLst.Add(1, "ClientLetter:D4000")
                                    letterLst.Add(2, "InformationSheet:D4001")
                                    letterLst.Add(3, "LegalServiceAgreementOnlyScheduleA:SD0003")
                                End If

                                For ltr As Integer = 1 To letterLst.Count
                                    Dim linfo As String() = letterLst(ltr).Split(New Char() {":"}, StringSplitOptions.RemoveEmptyEntries)
                                    Select Case linfo(0)
                                        Case "LegalServiceAgreementOnlyScheduleA"
                                            crpt = New ScheduleA_v3(dataclientID, False, False, False, False)
                                        Case "InformationSheet"
                                            crpt = New ClientInfoSheet(dataclientID, "9019")
                                        Case Else
                                            crpt = New MasterTemplate(dataclientID, linfo(0), args.ToArray, False, CurrentUserID, linfo(1))
                                    End Select

                                    If Not crpt Is Nothing Then
                                        crpt.Run(True)
                                        reportObj.Document.Pages.AddRange(crpt.Document.Pages)
                                    End If
                                Next

                                'lor copies
                                For Each credID As Integer In creditors.Keys
                                    Dim credName As String = creditors(credID).Name.ToString.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
                                    Dim credPath As String = String.Format("{0}CreditorDocs\{1}_{2}", rootDir.ToString, creditors(credID).CreditorID, credName)
                                    If Directory.Exists(credPath) = False Then
                                        Directory.CreateDirectory(credPath)
                                    End If
                                    crpt = New MasterTemplate(dataclientID, "LetterOfRepresentation", credID, True, CurrentUserID, "D4006")
                                    If Not crpt Is Nothing Then
                                        'lor
                                        crpt.Run(True)
                                        Dim lorPath As String = String.Format("{0}\{1}", credPath, SharedFunctions.DocumentAttachment.GetUniqueDocumentName("D4006", dataclientID))
                                        Using fStream As New System.IO.FileStream(lorPath, FileMode.CreateNew)
                                            pdf.Export(crpt.Document, fStream)
                                        End Using
                                        nr = tblDocs.NewRow
                                        nr("docpath") = lorPath
                                        nr("Pages") = 1
                                        tblDocs.Rows.Add(nr)
                                        SharedFunctions.DocumentAttachment.AttachDocument("account", creditors(credID).CreditorID.ToString(), Path.GetFileName(lorPath), CurrentUserID, creditors(credID).CreditorID.ToString() + "_" + credName + "\")
                                        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(lorPath), CurrentUserID, Now)
                                        'reportObj.Document.Pages.AddRange(crpt.Document.Pages)
                                    End If
                                Next

                                'lors
                                For Each credID As Integer In creditors.Keys
                                    Dim credName As String = creditors(credID).Name.ToString.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
                                    Dim credPath As String = String.Format("{0}CreditorDocs\{1}_{2}", rootDir.ToString, creditors(credID).CreditorID, credName)
                                    If Directory.Exists(credPath) = False Then
                                        Directory.CreateDirectory(credPath)
                                    End If
                                    crpt = New MasterTemplate(dataclientID, "LetterOfRepresentation", credID, False, CurrentUserID, "D4006")
                                    If Not crpt Is Nothing Then
                                        'lor
                                        crpt.Run(True)
                                        Dim lorPath As String = String.Format("{0}\{1}", credPath, SharedFunctions.DocumentAttachment.GetUniqueDocumentName("D4006", dataclientID))
                                        Using fStream As New System.IO.FileStream(lorPath, FileMode.CreateNew)
                                            pdf.Export(crpt.Document, fStream)
                                        End Using
                                        nr = tblDocs.NewRow
                                        nr("docpath") = lorPath
                                        nr("Pages") = 1
                                        tblDocs.Rows.Add(nr)

                                        SharedFunctions.DocumentAttachment.AttachDocument("account", creditors(credID).CreditorID.ToString(), Path.GetFileName(lorPath), CurrentUserID, creditors(credID).CreditorID.ToString() + "_" + credName + "\")
                                        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(lorPath), CurrentUserID, Now)
                                        'reportObj.Document.Pages.AddRange(crpt.Document.Pages)
                                        If signedPoaPath.ToString <> "" Then
                                            nr = tblDocs.NewRow
                                            nr("docpath") = signedPoaPath
                                            nr("Pages") = 1
                                            tblDocs.Rows.Add(nr)
                                        End If

                                    End If
                                Next

                                Dim numPagesInReport As Integer = reportObj.Document.Pages.Count

                                Using fStream As New System.IO.FileStream(tempWPkg, FileMode.CreateNew)
                                    pdf.Export(reportObj.Document, fStream)
                                End Using

                                PdfManipulation.ExtractAndMergePdfPages(tblDocs, welcomePkgPath)
                                RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, welcomePkgPath)
                                InsertPrintInfo("D4000K", dataclientID, welcomePkgPath, _CurrentUserID, numPagesInReport)

                                Dim ssql As String = String.Format("select depositmethod,depositday,DepositStartDate,depositamount, InitialDraftDate,InitialDraftAmount from tblclient where clientid = {0}", dataclientID)
                                Dim depositmethod As String = ""
                                Dim depositday As String = ""
                                Dim DepositStartDate As String = ""
                                Dim depositamount As String = ""
                                Dim InitialDraftDate As String = ""
                                Dim InitialDraftAmount As String = ""

                                Using dt As DataTable = SqlHelper.GetDataTable(ssql, CommandType.Text)
                                    For Each dr As DataRow In dt.Rows
                                        depositmethod = dr("depositmethod").ToString
                                        depositday = dr("depositday").ToString
                                        DepositStartDate = dr("DepositStartDate").ToString
                                        depositamount = dr("depositamount").ToString
                                        InitialDraftDate = dr("InitialDraftDate").ToString
                                        InitialDraftAmount = dr("InitialDraftAmount").ToString
                                        Exit For
                                    Next
                                End Using

                                Dim noteText As New StringBuilder
                                noteText.Append("Mailed client welcome package with copies of the representation letter that were sent to creditor with POA. ")
                                noteText.AppendFormat("{0} will be due on the {1} of each month beginning ", depositmethod, depositday)
                                noteText.AppendFormat("{0} in the amount of {1}.  ", DepositStartDate, depositamount)
                                noteText.AppendFormat("ADDITION ACH WILL BE DRAFTED ON {0} IN THE AMOUNT OF {1}", FormatDateTime(InitialDraftDate, DateFormat.ShortDate), FormatCurrency(InitialDraftAmount, 2))

                                Dim nid As Integer = NoteHelper.InsertNote(noteText.ToString, _CurrentUserID, dataclientID)
                                SharedFunctions.DocumentAttachment.AttachDocument("client", dataclientID, Path.GetFileName(welcomePkgPath), CurrentUserID)
                                SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(welcomePkgPath), CurrentUserID, Now)

                                File.Delete(tempWPkg)

                            End Using
                        End Using
                    End Using
                    docCnt += 1
                End If
            End If
        Next
        qr.DocumentCount = docCnt
        qr.ResultMessage = Join(results.ToArray, ",")
        Return qr
    End Function

    Private Function PrintWelcomeQueue() As QResults
        Dim qr As New QResults
        Dim docName As String = ""
        Dim docId As String = ""
        Dim docCnt As Integer = 0
        For Each row As GridViewRow In gvQueue.Rows
            If row.RowType = DataControlRowType.DataRow Then
                Dim dks As DataKey = gvQueue.DataKeys(row.RowIndex)
                Dim chk As System.Web.UI.HtmlControls.HtmlInputCheckBox = row.FindControl("chk_select")  'TryCast(row.Controls(0).Controls(1), System.Web.UI.WebControls.CheckBox)
                If chk.Checked = True Then
                    Using reportObj As New GrapeCity.ActiveReports.SectionReport
                        Using pdf As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                            Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
                                Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing
                                Dim cid As Integer = dks("qid").ToString()
                                Dim rootDir As New StringBuilder
                                'create client root directory
                                Try
                                    rootDir.Append(SharedFunctions.DocumentAttachment.CreateDirForClient(cid))
                                Catch e As Exception
                                    Throw e
                                End Try
                                docName = "WelcomeEmailLetter"
                                docId = "W0001"
                                Dim filePath As String = GetUniqueDocumentNameForReports(rootDir.ToString, cid, docId, _CurrentUserID)
                                'main call for reports
                                Dim args As New List(Of String)
                                args.Add(cid)
                                rptDoc = rptTemplates.ViewTemplate(docName, cid, args.ToArray, False, _CurrentUserID, Path.GetFileNameWithoutExtension(filePath).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)(2))
                                'add pages to report
                                reportObj.Document.Pages.AddRange(rptDoc.Pages)
                                Dim numPagesInReport As Integer = reportObj.Document.Pages.Count
                                Using fStream As New System.IO.FileStream(filePath, FileMode.CreateNew)
                                    pdf.Export(reportObj.Document, fStream)
                                End Using
                                RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, filePath)
                                Dim nid As Integer = NoteHelper.InsertNote("Welcome Email Letter Printed & Mailed from print queue.", _CurrentUserID, cid)
                                SharedFunctions.DocumentAttachment.AttachDocument("note", nid, Path.GetFileName(filePath), _CurrentUserID, "ClientDocs")
                                SharedFunctions.DocumentAttachment.AttachDocument("client", cid, Path.GetFileName(filePath), _CurrentUserID, "ClientDocs")
                                SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(filePath), _CurrentUserID, Now)
                                InsertPrintInfo(docId, cid, filePath, _CurrentUserID, numPagesInReport)

                                Dim agendyID As Integer = SharedFunctions.AsyncDB.executeScalar(String.Format("select isnull(agencyid,-1) from tblclient where clientid = {0}", cid), ConfigurationManager.AppSettings("connectionstring").ToString)
                                Select Case agendyID
                                    Case 856
                                        docName = "FollowUpLetterCID"
                                        docId = "W0002"
                                    Case Else
                                        docName = "FollowUpLetterOther"
                                        docId = "W0003"
                                End Select
                                filePath = GetUniqueDocumentNameForReports(rootDir.ToString, cid, docId, _CurrentUserID)
                                rptDoc = rptTemplates.ViewTemplate(docName, cid, args.ToArray, False, _CurrentUserID, Path.GetFileNameWithoutExtension(filePath).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)(2))
                                'add pages to report
                                reportObj.Document.Pages.AddRange(rptDoc.Pages)
                                numPagesInReport = reportObj.Document.Pages.Count
                                Using fStream As New System.IO.FileStream(filePath, FileMode.CreateNew)
                                    pdf.Export(reportObj.Document, fStream)
                                End Using
                                RawPrinterHelper.SendFileToPrinter(NetworkPrinterName, filePath)
                                nid = NoteHelper.InsertNote("Welcome Email Follow-up Letter Printed & Mailed from print queue.", _CurrentUserID, cid)
                                SharedFunctions.DocumentAttachment.AttachDocument("note", nid, Path.GetFileName(filePath), _CurrentUserID, "ClientDocs")
                                SharedFunctions.DocumentAttachment.AttachDocument("client", cid, Path.GetFileName(filePath), _CurrentUserID, "ClientDocs")
                                SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(filePath), _CurrentUserID, Now)
                                InsertPrintInfo(docId, cid, filePath, _CurrentUserID, numPagesInReport)

                            End Using
                        End Using
                    End Using
                    docCnt += 1
                End If
            End If
        Next
        qr.DocumentCount = docCnt
        qr.ResultMessage = String.Format("{0} Document(s) Printed.", docCnt)
        Return qr
    End Function

    Private Sub loadPrinters()
        Dim liNone As New System.Web.UI.WebControls.ListItem("NONE")
        liNone.Selected = True
        ddlPrinter.Items.Add(liNone)
        For Each printer As String In System.Drawing.Printing.PrinterSettings.InstalledPrinters
            Dim pName As String = printer.ToString
            If pName.StartsWith("\\") Then
                ddlPrinter.Items.Add(printer.ToString)
            End If
        Next printer
        'add some known printers
        Dim deptNames As String() = "Mail Room,Data Entry Dept.,Client Services Dept.,Compliance Dept.,Creditor Services Dept.,Client Intake, Information Technology Dept., Human Resources Dept.".Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
        For i As Integer = 1 To 8
            Dim li As System.Web.UI.WebControls.ListItem = ddlPrinter.Items.FindByValue(String.Format("\\Lex-DCO-001\{0}", i)) '\\DMF-APP-0001\dmf-prn-000{0}
            If IsNothing(li) Then
                li = New System.Web.UI.WebControls.ListItem(deptNames(i - 1), String.Format("\\DMF-APP-0001\dmf-prn-000{0}", i))
                ddlPrinter.Items.Add(li)
            End If
        Next

        ddlPrinter.Items.Add(New System.Web.UI.WebControls.ListItem("DEV Printer", "\\DMF-WKS-0363\HP LaserJet 2430 PCL 5 DEV"))

    End Sub

    Private Sub loadQueueTypes()

        Dim names As String() = System.Enum.GetNames(GetType(enumPrintQueueType))
        Dim vals As enumPrintQueueType() = System.Enum.GetValues(GetType(enumPrintQueueType))

        'Filter only Qtype
        If Not Request.QueryString("qtype") Is Nothing AndAlso Request.QueryString("qtype").ToString.Trim.Length > 0 Then
            names = New String() {Array.Find(names, Function(x) x = System.Enum.GetName(GetType(enumPrintQueueType), CInt(Request.QueryString("qtype").ToString)))}
            vals = New Integer() {CInt(Request.QueryString("qtype").ToString)}
        End If

        Dim qList As New SortedList(Of String, String)

        For i As Integer = 0 To names.Length - 1
            qList.Add(names(i), vals(i))
        Next

        For i As Integer = 0 To qList.Count - 1
            Dim li As New System.Web.UI.WebControls.ListItem(ClientFileDocumentHelper.InsertSpaceAfterCap(qList.Keys(i)), qList.Values(i))
            ddlQueueType.Items.Add(li)
        Next

        If Not IsNothing(ViewState("qid")) Then
            ddlQueueType.SelectedValue = ViewState("qid").ToString
        Else
            ddlQueueType.SelectedValue = "0"
        End If


    End Sub

    Private Sub toggleQueueDisplay(ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case QueueType
            Case enumPrintQueueType.WelcomeEmail ', enumPrintQueueType.BouncedDeposit, enumPrintQueueType.NonDeposit
                e.Row.Cells(4).Visible = False
                e.Row.Cells(5).Visible = False
                e.Row.Cells(7).Visible = False
                e.Row.Cells(8).Visible = False
                e.Row.Cells(9).Visible = False
                e.Row.Cells(10).Visible = False
            Case enumPrintQueueType.Reprint
                'e.Row.Cells(0).Visible = False
                e.Row.Cells(2).HorizontalAlign = HorizontalAlign.Left
                e.Row.Cells(2).Width = 300
                e.Row.Cells(7).Visible = False
                e.Row.Cells(8).Visible = False
                e.Row.Cells(9).Visible = False
                e.Row.Cells(10).Visible = False
            Case enumPrintQueueType.AutomatedSettlementProcessing
                e.Row.Cells(2).HorizontalAlign = HorizontalAlign.Left
                e.Row.Cells(7).Visible = False
            Case enumPrintQueueType.WelcomePackage
                e.Row.Cells(4).Visible = False
                e.Row.Cells(5).Visible = False
                e.Row.Cells(7).Visible = False
                e.Row.Cells(8).Visible = False
                e.Row.Cells(9).Visible = False
                e.Row.Cells(10).Visible = False
            Case enumPrintQueueType.ClientStipulation
                e.Row.Cells(5).Visible = False
                Dim dpath As String = e.Row.Cells(7).Text
                Dim hl As New HyperLink
                If File.Exists(dpath) Then
                    hl.Attributes.Add("onclick", String.Format("javascript:window.open('{0}');return false;", LocalHelper.GetVirtualDocFullPath(dpath)))
                Else
                    hl.Attributes.Add("onclick", "javascript:alert('Document not found!');return false;")
                    hl.ForeColor = System.Drawing.Color.Red
                End If
                hl.NavigateUrl = "#"
                hl.Text = "Client Stipulation"
                If e.Row.RowType = DataControlRowType.DataRow Then
                    e.Row.Cells(7).Controls.Add(hl)
                End If

            Case enumPrintQueueType.LettersOfRepresentation
                e.Row.Cells(4).Visible = False
                'e.Row.Cells(5).Visible = False
                e.Row.Cells(5).Width = New Unit(100)
                e.Row.Cells(7).Visible = False
                e.Row.Cells(8).Visible = False
                e.Row.Cells(9).Visible = False
                e.Row.Cells(10).Visible = False

            Case enumPrintQueueType.ClientStatements
                e.Row.Cells(0).Visible = True 'check box
                e.Row.Cells(1).Visible = True
                gvQueue.Columns(2).HeaderText = "Account Number"
                e.Row.Cells(2).Visible = True 'Client Account number instead of Firm Name
                e.Row.Cells(3).Visible = True 'Client Name
                e.Row.Cells(4).Visible = False 'Printed By
                e.Row.Cells(5).Visible = False 'Width = New Unit(100)
                gvQueue.Columns(6).HeaderText = "Next Deposit Date"
                e.Row.Cells(6).Visible = True 'Date
                e.Row.Cells(7).Visible = False 'Document Path
                e.Row.Cells(7).Width = New Unit(100)
                gvQueue.Columns(8).HeaderText = "Document Name"
                e.Row.Cells(8).Visible = True 'Creditor
                e.Row.Cells(9).Visible = False 'Settlement$
                e.Row.Cells(10).Visible = False 'Due Date
            Case enumPrintQueueType.FinalSettlementKitPAPaymentsByClient
                gvQueue.Columns(7).HeaderText = "Document Destination"
                If e.Row.RowType = DataControlRowType.DataRow Then
                    If e.Row.Cells(7).Text.Replace("&nbsp;", " ").Trim <> "" Then
                        e.Row.Cells(7).Text = String.Format("<img src=""{0}"" style=""vertical-align:middle;""></img>&nbsp;{1}", ResolveUrl("~/images/16x16_email.png"), e.Row.Cells(7).Text)
                    Else
                        e.Row.Cells(7).Text = String.Format("<img src=""{0}"" style=""vertical-align:middle;""></img>&nbsp;{1}", ResolveUrl("~/images/16x16_print.png"), "Printer")
                    End If
                End If
            Case enumPrintQueueType.ClientDepositCheck

        End Select
    End Sub

    Private Sub UpdateNachaRecord(ByVal NachaRegisterId As String, ByVal CurrentUser As String)
        Dim query As String = String.Format("update tblnacharegister2 set Drafted = 1, DraftedDate = '{0}', DraftedBy = {1} where NachaRegisterId = {2}", Now.ToString("yyyy/MM/dd HH:mm:ss"), CurrentUser, NachaRegisterId)
        SqlHelper.ExecuteScalar(query, CommandType.Text)
    End Sub

#End Region 'Methods

#Region "Nested Types"

    Private Class QResults

#Region "Fields"

        Private _DocumentCount As Integer
        Private _ResultMessage As String

#End Region 'Fields

#Region "Properties"

        Public Property DocumentCount() As Integer
            Get
                Return _DocumentCount
            End Get
            Set(ByVal value As Integer)
                _DocumentCount = value
            End Set
        End Property

        Public Property ResultMessage() As String
            Get
                Return _ResultMessage
            End Get
            Set(ByVal value As String)
                _ResultMessage = value
            End Set
        End Property

#End Region 'Properties

    End Class

#End Region 'Nested Types

    Protected Sub dsQueue_Selecting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceSelectingEventArgs) Handles dsQueue.Selecting
        e.Command.CommandTimeout = 300
    End Sub
End Class