<%@ WebHandler Language="VB" Class="clients_client_reports_pdfexport" %>
Imports LexxiomLetterTemplates


Imports GrapeCity.ActiveReports
Imports GrapeCity.ActiveReports.Export.Pdf

Imports Drg.Util.DataAccess

Imports SharedFunctions

Imports System
Imports System.Configuration
Imports System.Collections
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Text
Imports System.Web
Imports System.Web.Security
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.WebControls.WebParts
Imports System.Web.UI.HtmlControls

Imports ReportsHelper


Public Class clients_client_reports_pdfexport : Implements IHttpHandler : Implements IReadOnlySessionState

    
   
  
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim ClientPOAPath As String = ""
        Dim ClientID As Integer = CInt(context.Session("clients_client_reports_clientid"))
        Dim UserID As Integer = CInt(context.Session("clients_client_reports_userid"))
        Dim ListOfReportsToPrint() As String = Nothing
        Dim URL_ReportString As String = ""
		
        'reporting objs
        Dim reportObj As GrapeCity.ActiveReports.SectionReport = Nothing
        Dim welcomePkg As New SectionReport
        
        Dim rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString)
        Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing
		
        Dim rootDir As String = ""
        Dim asWPkg As Boolean = False
        Dim bNCPkg As Boolean = False
		
        Dim creditors As Dictionary(Of Integer, ClientAccountInfo)
		
        Dim folderPath As String = ""
        Dim filePath As String = ""
        Dim tempName As String = ""
        Dim reportDocumentTypeName As String = ""
        Dim reportDocID As String = ""
		
        Dim creditorAccountID As String = ""
        Dim nInfo As New List(Of ReportNoteInfo)
        Dim charSeparators() As Char = {"|"c}
		
		
        'get client & report from cookie if session is lost
        If IsNothing(ClientID) Then
            ClientID = context.Request.Cookies("clientReportInfo")("clients_client_reports_clientid")
            UserID = context.Request.Cookies("clientReportInfo")("clients_client_reports_userid")
            context.Session("clients_client_reports_reports") = context.Request.Cookies("clientReportInfo")("clients_client_reports_reports")
        End If
     
        'create client root directory
        Try
            rootDir = SharedFunctions.DocumentAttachment.CreateDirForClient(ClientID)
        Catch e As Exception
            Exit Sub
        End Try
       
        'get all clients creditors
        creditors = GetCreditorAccounts(ClientID)

        Dim shouldReturn As Boolean
        PrepareReportString(context, URL_ReportString, asWPkg, creditors, shouldReturn)
        If shouldReturn Then
            Return
        End If

        'split report string into list object
        ListOfReportsToPrint = URL_ReportString.Split(charSeparators, StringSplitOptions.RemoveEmptyEntries)
        
        Try
            For Each PrintingReport As String In ListOfReportsToPrint
                'create new AR object to hold report
                reportObj = New SectionReport
                
                'split to extract report and args.
                Dim PrintingReportArgs() As String = PrintingReport.Split("_")
				
                'get report, feeding all arguments
                'get report name
                reportDocumentTypeName = PrintingReportArgs(0)
                'get report typeid
                reportDocID = rptTemplates.GetDocTypeID(reportDocumentTypeName)
                'get all report info
                Dim sRptInfo As LetterTemplates.ReportInfo = rptTemplates.GetReportInfoByTypeName(reportDocumentTypeName)

                'build docid
                'retrieve new docid for barcode
                Dim newDocID As String = PrintingReportArgs(PrintingReportArgs.Length - 1).ToString
                ReDim Preserve PrintingReportArgs(PrintingReportArgs.Length - 2)
                
                Select Case sRptInfo.ReportType
                    Case LetterTemplates.ReportDocType.Client
                        filePath = GetUniqueDocumentNameForReports(rootDir, ClientID, reportDocID, newDocID, UserID)
                    Case LetterTemplates.ReportDocType.Creditor
                        creditorAccountID = PrintingReportArgs(1).Replace("ESP", "")      'needed for the addition of esp letters
                        FindCreditorInCollection(creditors, tempName, creditorAccountID, PrintingReportArgs, sRptInfo)
                        folderPath = String.Format("CreditorDocs\{0}_{1}\", creditors(creditorAccountID).AccountID, tempName)
                        filePath = ReportsHelper.GetUniqueDocumentNameForReports(rootDir, ClientID, reportDocID, newDocID, UserID, folderPath)
                    Case LetterTemplates.ReportDocType.Package
                        filePath = GetUniqueDocumentNameForReports(rootDir, ClientID, reportDocID, newDocID, UserID)
                End Select
                If Directory.Exists(Path.GetDirectoryName(filePath)) = False Then
                    Directory.CreateDirectory(Path.GetDirectoryName(filePath))
                End If
                
                'main call for reports
                Select Case PrintingReportArgs(0).ToUpper
                    Case "NCCONVPKG"
                        rptDoc = rptTemplates.GenerateConversionPackage(Path.GetFileNameWithoutExtension(filePath).Split("_")(2), ClientID, PrintingReportArgs(1), UserID)
                    Case Else
                        'main call for reports
                        rptDoc = rptTemplates.ViewTemplate(PrintingReportArgs(0), ClientID, PrintingReportArgs, False, UserID,Path.GetFileNameWithoutExtension(filePath).Split("_")(2))
                End Select
                                              
                'add pages to report
                reportObj.Document.Pages.AddRange(rptDoc.Pages)
                Dim numPagesInReport As Integer = reportObj.Document.Pages.Count
               
                Select Case sRptInfo.ReportType
                    Case LetterTemplates.ReportDocType.Creditor

                        AddDocumentToCreditor(ClientID, UserID, reportObj, creditors, filePath, tempName, reportDocumentTypeName, creditorAccountID, nInfo)
                                                    
                        '8.20.2008.ug
                        'demand letter uses state specific text and needs to change the 
                        'account status when printed.
                        Dim aDemand As New List(Of String)
                        aDemand.Add("D3022")
                        aDemand.Add("D3023")
                        If aDemand.Contains(reportDocID) Then
                            Dim AccountStatusID As Integer = 164
                            'update the status field
                            Dim updates As New List(Of DataHelper.FieldValue)
                            Dim accountid = DataHelper.FieldLookup("tblAccount", "AccountID", "CurrentCreditorInstanceID = " & creditorAccountID & "or originalcreditorinstanceid = " & creditorAccountID)
                            updates.Add(New DataHelper.FieldValue("AccountStatusID", AccountStatusID))
                            If accountid <> "" Then
                                DataHelper.AuditedUpdate(updates, "tblAccount", Integer.Parse(accountid), UserID)
                            End If
                        End If
            
                        If Not asWPkg Then
                            welcomePkg.Document.Pages.Insert(welcomePkg.Document.Pages.Count, reportObj.Document.Pages.Item(0))
                        End If
                        '2.16.10.ug.code to popup client poa when printing LOR for Data entry
                        If reportDocID = "D4006" Then
                            ClientPOAPath = findClientPOA(rootDir)
                        End If
                        
                        
                    Case LetterTemplates.ReportDocType.Client
                        'attach to client
                        If Not reportObj Is Nothing Then
                            AddDocumentToClient(ClientID, UserID, reportObj, rootDir, filePath, reportDocumentTypeName, nInfo)
                        End If
                    Case LetterTemplates.ReportDocType.Package
                        If asWPkg = False Then
                            'attach to client
                            If Not reportObj Is Nothing Then
                                AddDocumentToClient(ClientID, UserID, reportObj, rootDir, filePath, reportDocumentTypeName, nInfo)
                            End If
                        End If
                End Select
             
                If asWPkg = True Then
                    welcomePkg.Document.Pages.AddRange(rptDoc.Pages)
                    'Continue For
                End If
             
             
            Next
            
            If asWPkg Then
                filePath = GetUniqueDocumentNameForReports(rootDir, ClientID, "D4000K", UserID)
                
                AddDocumentToPackage(ClientID, UserID, welcomePkg, filePath, reportDocumentTypeName, reportDocID, nInfo)
            End If
            
            'store the report pdf path to attach to note
            context.Session("ReportNotesInfoObj") = nInfo
            
            
            SetPrinted(ListOfReportsToPrint, ClientID, UserID)
            
            reportObj.Document.Dispose()
            reportObj.Dispose()
            
            welcomePkg.Document.Dispose()
            welcomePkg.Dispose()
            
            
            rptDoc.Dispose()
            rptTemplates.Dispose()

            Dim reURL As String = ""
            If ClientPOAPath = "" Then
                reURL = String.Format("report.aspx?showwizard=1&clientid={0}&reports={1}&user={2}", ClientID.ToString(), CStr(context.Session("clients_client_reports_reports")).Replace("&", "%26").Replace("#", "%23").Replace(System.Environment.NewLine, "\n"), UserID)
            Else
                reURL = String.Format("report.aspx?showwizard=1&clientid={0}&reports={1}&user={2}&printpoa=1&poapath={3}", ClientID.ToString(), CStr(context.Session("clients_client_reports_reports")).Replace("&", "%26").Replace("#", "%23").Replace(System.Environment.NewLine, "\n"), UserID, ClientPOAPath)
            End If
            context.Response.Redirect(reURL)
            
        Catch eRunReport As GrapeCity.ActiveReports.ReportException
            context.Response.Clear()
            context.Response.Write("<h1>Error running report:</h1><br />")
            context.Response.Write(eRunReport.ToString())
        Catch eNetwork As IOException
            context.Response.Clear()
            context.Response.Write("<h1>Error running report:</h1><br />")
            context.Response.Write(eNetwork.ToString())
        Finally
            ListOfReportsToPrint = Nothing
            reportObj = Nothing
            welcomePkg = Nothing
            creditors = Nothing
            rptDoc = Nothing
            rptTemplates = Nothing
        End Try
    End Sub
    Private Shared Sub AddDocumentToPackage(ByVal ClientID As Integer, ByVal UserID As Integer, ByVal welcomePkg As ActiveReport3, ByVal filePath As String, ByVal reportDocumentTypeName As String, ByVal reportDocID As String, ByVal nInfo As List(Of ReportNoteInfo))
        Using pdf As New PdfExport()
            Using fStream As New System.IO.FileStream(filePath, FileMode.Create)
                pdf.Export(welcomePkg.Document, fStream)
            End Using
        End Using
        SharedFunctions.DocumentAttachment.AttachDocument("client", ClientID, Path.GetFileName(filePath), UserID, "ClientDocs")
        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(filePath), UserID)
        nInfo.Add(New ReportNoteInfo("Package", reportDocumentTypeName, filePath, "ClientDocs"))
     
        InsertPrintInfo(reportDocID, ClientID, filePath, UserID, welcomePkg.Document.Pages.Count)
    End Sub
    Private Shared Sub AddDocumentToClient(ByVal ClientID As Integer, ByVal UserID As Integer, ByVal reportObj As GrapeCity.ActiveReports.SectionReport, ByVal rootDir As String, ByVal filePath As String, ByVal reportDocumentTypeName As String, ByVal nInfo As List(Of ReportNoteInfo))
        Using pdf As New PdfExport()
            Using fStream As New System.IO.FileStream(filePath, FileMode.Create)
                pdf.Export(reportObj.Document, fStream)
            End Using
        End Using
        
        SharedFunctions.DocumentAttachment.AttachDocument("client", ClientID, Path.GetFileName(filePath), UserID, "ClientDocs")
        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(filePath), UserID, Now)
        nInfo.Add(New ReportNoteInfo("client", reportDocumentTypeName, filePath, rootDir))
        InsertPrintInfo(Path.GetFileNameWithoutExtension(filePath).Split("_")(1), ClientID, filePath, UserID, reportObj.Document.Pages.Count)
    End Sub
    Private Shared Sub AddDocumentToCreditor(ByVal ClientID As Integer, ByVal UserID As Integer, ByVal reportObj As GrapeCity.ActiveReports.SectionReport, ByVal creditors As Dictionary(Of Integer, ClientAccountInfo), ByVal filePath As String, ByVal tempName As String, ByVal reportDocumentTypeName As String, ByVal creditorAccountID As String, ByVal nInfo As List(Of ReportNoteInfo))
        Using pdf As New PdfExport()
            Using fStream As New System.IO.FileStream(filePath, FileMode.Create)
                pdf.Export(reportObj.Document, fStream)
            End Using
        End Using
                
        SharedFunctions.DocumentAttachment.AttachDocument("account", creditors(creditorAccountID).AccountID, Path.GetFileName(filePath), UserID, creditors(creditorAccountID).AccountID.ToString() + "_" + tempName + "\")
        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(filePath), UserID, Now)
        nInfo.Add(New ReportNoteInfo("creditor", reportDocumentTypeName, filePath, creditors(creditorAccountID).AccountID.ToString() + "_" + tempName, creditors(creditorAccountID).AccountID.ToString()))
        InsertPrintInfo(Path.GetFileNameWithoutExtension(filePath).Split("_")(1), ClientID, filePath, UserID, reportObj.Document.Pages.Count)
    End Sub
    Private Shared Function findClientPOA(ByVal clientRootDir As String) As String
        Dim poaPath As String = ""
        Dim clientDIR As New IO.DirectoryInfo(String.Format("{0}{1}", clientRootDir, "\clientdocs"))
        Dim clientFiles As IO.FileInfo() = clientDIR.GetFiles("*.pdf")
        For Each cFile As IO.FileInfo In clientFiles
            Dim fileParts As String() = Path.GetFileNameWithoutExtension(cFile.FullName).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
            If fileParts.Length > 1 Then
                Select Case fileParts(1).ToString
                    Case "9019"
                        poaPath = cFile.FullName
                        Exit For
                End Select
            End If
        Next
        Return poaPath
    End Function
    

    
	Private Shared Sub PrepareReportString(ByVal context As HttpContext, ByRef URL_ReportString As String, ByRef asWPkg As Boolean, ByVal creditors As Dictionary(Of Integer, ClientAccountInfo), ByRef shouldReturn As Boolean)
    		shouldReturn = False
    		'prepare report string
    				If Not IsNothing(context.Session("clients_client_reports_reports")) Then
    					URL_ReportString = CStr(context.Session("clients_client_reports_reports"))
    
    					Dim rpts As String() = URL_ReportString.Split(New Char(){"|"}, StringSplitOptions.RemoveEmptyEntries)
                        Dim rptsLst As New List(Of String)(rpts)
                        rptsLst.Remove("chkClient")
                        rptsLst.Remove("chkCreditor")
                        rptsLst.Remove("chkPackage")
    
    					'remove descriptive text not needed
    					URL_ReportString = Join(rptsLst.ToArray,"|") 'URL_ReportString.Replace("chkClient|", "").Replace("chkCreditor|", "").Replace("chkPackage|", "")
    
    
    					'if this is welcome pkg mark as true
    					If URL_ReportString.Contains("chkPackage|") Then
    						asWPkg = True
    					End If
    
    					'loop thru creditors building new report string for each creditor
    					If URL_ReportString.Contains("LetterOfRepresentationOriginal") Then
    						Dim sbIndividLORs As New List(Of String)
    						For Each cred As KeyValuePair(Of Integer, ClientAccountInfo) In creditors
    							sbIndividLORs.Add(String.Format("LetterOfRepresentation_{0}", cred.Value.CreditorInstanceID))
    						Next
    						URL_ReportString = URL_ReportString.Replace("LetterOfRepresentationOriginal", Join(sbIndividLORs.ToArray, "|"))
    					End If
    
    		            'if no reports exit handler
    					If URL_ReportString.ToString = "" Then shouldReturn = True : Exit Sub
    				Else
    					shouldReturn = True : Exit Sub
    				End If
    End Sub
       Private Shared Sub FindCreditorInCollection(ByVal creditors As Dictionary(Of Integer, ClientAccountInfo), ByRef tempName As String, ByRef creditorAccountID As String, ByVal PrintingReportArgs As String(), ByVal sRptInfo As LetterTemplates.ReportInfo)
                       		'try to find creditor in collection
		Try
		    creditorAccountID = Val(creditorAccountID)
			'printing settlement acceptance form, only passed in settlementid
			If sRptInfo.ReportTypeName.ToString.ToLower = "settlementacceptanceform" or sRptInfo.ReportTypeName.ToString.ToLower = "restrictiveendorsementletter" Then
				creditorAccountID = Drg.Util.DataAccess.DataHelper.FieldLookup("tblSettlements", "CreditorAccountID", "SettlementID = " & PrintingReportArgs(1))
			End If
			tempName = creditors(creditorAccountID).CreditorName
			tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
		Catch knf As KeyNotFoundException
			Try
				'got passed the accountid find currentcreditorinstanceid by accountid
                creditorAccountID = Drg.Util.DataHelpers.AccountHelper.GetCurrentCreditorInstanceID(creditorAccountID)
				tempName = creditors(creditorAccountID).CreditorName
			Catch ex As Exception
				Try
					'got passed the originalcreditorinstanceid find currentcreditorinstanceid by originalcreditorinstanceid
					creditorAccountID = Drg.Util.DataAccess.DataHelper.FieldLookup("tblaccount","currentcreditorinstanceid","originalcreditorinstanceid = " & PrintingReportArgs(1))
					tempName = creditors(creditorAccountID).CreditorName
					tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
				Catch realX As KeyNotFoundException
					Throw New Exception("Error trying to attach document to creditor :" & PrintingReportArgs(1))
				End Try
				'Throw New Exception("Error trying to attach document to creditor :" & aArgs(1))
			End Try
		End Try
    End Sub
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
		Get
			Return False
		End Get
	End Property

End Class