Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Net

Imports Drg.Util.DataHelpers

Imports LexxiomLetterTemplates

Imports SharedFunctions

Imports ToolsHelper

Imports iTextSharp.text.pdf
Imports Drg.Util.DataAccess
Imports System.Runtime.Remoting.Messaging

Partial Class research_tools_documents_findpoa
    Inherits System.Web.UI.Page

#Region "Fields"

    Private ClientList As New List(Of ClientInfo)

    Public Property UserID() As Integer
        Get
            If Not IsNothing(ViewState("userid")) Then
                Return ViewState("userid")
            Else
                Return -1
            End If
        End Get
        Set(ByVal value As Integer)
            ViewState("userid") = value
        End Set
    End Property
    Public Property UserEmail() As String
        Get
            If Not IsNothing(ViewState("UserEmail")) Then
                Return ViewState("UserEmail")
            Else
                Return -1
            End If
        End Get
        Set(ByVal value As String)
            ViewState("UserEmail") = value
        End Set
    End Property
#End Region 'Fields

#Region "Delegates"

    Public Delegate Sub ProcessList_Delegate(ByVal paramArgs As Object)

#End Region 'Delegates

#Region "Methods"

    Public Function BuildMSGDiv(ByVal MessageToDisplay As String, Optional ByVal MessageCSSName As String = "info") As String
        Dim sb As New StringBuilder

        sb.AppendFormat("<div class=""{0}"" style=""width:50%;"">", MessageCSSName)
        sb.AppendFormat("<br/>{0}</div>", MessageToDisplay)
        
        Return sb.ToString
    End Function

    Public Sub TaskCompleted(ByVal R As IAsyncResult)
        ' Write here code to handle the completion of
        ' your asynchronous method
        Dim aResult As AsyncResult = TryCast(R, AsyncResult)

        Dim temp As ProcessList_Delegate = TryCast(aResult.AsyncDelegate, ProcessList_Delegate)
        temp.EndInvoke(R)

        divstatus.innerhtml = BuildMSGDiv("Email has been sent!")

    End Sub
   
    Protected Sub research_tools_documents_findpoa_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            UserID = DataHelper.Nz_int(Page.User.Identity.Name)
            UserEmail = SharedFunctions.AsyncDB.executeScalar(String.Format("select emailaddress from tbluser where userid = {0}", UserID), ConfigurationManager.AppSettings("connectionstring").ToString)

            Dim Expression As New System.Text.RegularExpressions.Regex("\S+@\S+\.\S+")
            If Not Expression.IsMatch(UserEmail) Then
                divstatus.innerhtml = BuildMSGDiv("Current User does not have a valid email.", "error")
                tblPOA.style("display") = "none"
            End If
            setRollUps()
        End If

    End Sub
    Private Sub setRollUps()
        'Dim CommonTasks As List(Of String) = CType(Master, research_tools_tools).CommonTasks

        'CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:FindPOA();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_find.png") & """ align=""absmiddle""/>Find POA(s)</a>")

    End Sub

    Private Sub ProcessList(ByVal paramArgs As Object)
        Dim argParams As List(Of String) = DirectCast(paramArgs, List(Of String))
        Dim recipEmail As String = argParams(0)
        Dim listText As String = argParams(1)
        Dim bAddInfo As Boolean = argParams(2)
        Dim bModifiedLtrRep As Boolean = argParams(3)

        Dim faxSepPath As String = "\\nas02\clientstorage\FaxSeparatorPage\CapitalOne\FaxSeparator.pdf"

        Dim email As New Mail.MailMessage
        email.To.Add(New Mail.MailAddress(recipEmail))
        email.From = New Mail.MailAddress("ITGROUP@lexxiom.com")
        email.Subject = "Found Client POA's"
        email.Body = "The following client POA's have been found: " & vbCrLf

        Dim ServerPath As String = String.Format("\\{0}", ConfigurationManager.AppSettings("storage_documentPath").ToString).Replace("\\", "\")
        Dim ClientIDs As String() = listText.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
        Dim strBody As String = ""

        Dim combinedStampedPDFPOAPath = String.Format("\\nas02\clientstorage\MergePDFs\{0}", Guid.NewGuid.ToString & "_stamped.pdf")
        Dim doc As New iTextSharp.text.Document()
        Dim writer As PdfWriter = PdfWriter.GetInstance(doc, New FileStream(combinedStampedPDFPOAPath, FileMode.Create))
        doc.Open()
        doc.NewPage()
        For Each clientID As String In ClientIDs
            Try
                Dim currentClient As ClientInfo = Nothing
                Dim clientSixNumber As String = clientID
                Dim crLastFour As String = ""
                Dim bGotInfo As Boolean = False
                Dim bPOAFound As Boolean = False

                If bAddInfo = True Then
                    If clientID.Split(".").Length > 1 Then
                        clientSixNumber = clientID.Split(".")(0)
                        crLastFour = clientID.Split(".")(1)
                        Dim dtAccounts As DataTable = getAccountsForClient(clientSixNumber, crLastFour)
                        If dtAccounts.Rows.Count > 0 Then
                            For Each row As DataRow In dtAccounts.Rows
                                currentClient = New ClientInfo(row("clientid").ToString, _
                                                               row("creditorinstanceid").ToString, _
                                                               clientSixNumber, row("ssn").ToString, _
                                                               row("accountnumber").ToString, _
                                                               row("creditorid").ToString, _
                                                               row("accountid").ToString, _
                                                               row("creditorname").ToString.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim())
                                Exit For
                            Next
                            bGotInfo = True
                        Else
                            bGotInfo = False
                        End If
                        
                    Else
                        clientSixNumber = clientID.Split(".")(0)
                        crLastFour = ""
                    End If
                End If
                

                Dim clientDIR As New IO.DirectoryInfo(ServerPath & "\" & clientSixNumber.Trim & "\clientdocs")
                Dim clientFiles As IO.FileInfo() = clientDIR.GetFiles("*.pdf")
                Dim bf As BaseFont = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED)
                For Each cFile As IO.FileInfo In clientFiles
                    Dim fileParts As String() = Path.GetFileNameWithoutExtension(cFile.FullName).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
                    If fileParts.Length > 1 Then
                        Select Case fileParts(1).ToString
                            Case "9019"
                                'add separator page
                                If Not IsNothing(currentClient.CreditorName) Then
                                    If currentClient.CreditorName.ToLower.Replace("_", "").Contains("capitalone") Then
                                        Dim faxSep As New iTextSharp.text.pdf.PdfReader(faxSepPath)
                                        Dim faxPage As PdfImportedPage = writer.GetImportedPage(faxSep, 1)
                                        doc.NewPage()
                                        Dim cbSep As PdfContentByte = writer.DirectContent
                                        cbSep.AddTemplate(faxPage, 10, 10)
                                        faxPage = Nothing
                                        faxSep = Nothing
                                        cbSep = Nothing
                                    End If
                                End If
                                
                                Dim newPOAPath As String = cFile.FullName
                                'merge doc

                                Dim poa As New iTextSharp.text.pdf.PdfReader(cFile.FullName)

                                doc.SetPageSize(poa.GetPageSizeWithRotation(1))
                                doc.NewPage()
                                Dim page1 As PdfImportedPage = writer.GetImportedPage(poa, 1)

                                Dim cb As PdfContentByte = writer.DirectContent
                                cb.AddTemplate(page1, 10, 10)
                                cb.BeginText()
                                cb.SetFontAndSize(bf, 14)
                                Dim cInfo As String = ""
                                If bGotInfo AndAlso bAddInfo Then
                                    cInfo = String.Format("Client 600: {0}  Client SSN: {1} / Creditor Acct #: {2}", currentClient.ClientSixHundredNumber, currentClient.ClientSSN, currentClient.CreditorAcctNum)
                                Else
                                    cInfo = "Client Info Not Found!"
                                End If
                                cb.ShowTextAligned(PdfContentByte.ALIGN_LEFT, cInfo, 5, 5, 0)
                                cb.EndText()
                                cb = Nothing

                                page1 = Nothing
                                poa.Close()

                                strBody += clientSixNumber & " POA Found..." & vbCrLf
                                bPOAFound = True

                                Exit For
                        End Select
                    End If
                Next

                If bPOAFound = True AndAlso bModifiedLtrRep = True AndAlso Not IsNothing(currentClient.CreditorName) Then
                    Dim credDIR As New IO.DirectoryInfo(ServerPath & "\" & clientSixNumber.Trim & "\creditordocs\" & String.Format("{0}_{1}", currentClient.CreditorAccountID, currentClient.CreditorName))
                    Dim credFiles As IO.FileInfo() = credDIR.GetFiles("*.pdf")
                    Dim bGotModLtrRep As Boolean = False

                    For Each credFile As IO.FileInfo In credFiles
                        Dim fileParts As String() = Path.GetFileNameWithoutExtension(credFile.FullName).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
                        If fileParts.Length > 1 Then
                            Select Case fileParts(1).ToString
                                Case "D6003A"
                                    Dim mlor As New iTextSharp.text.pdf.PdfReader(credFile.FullName)
                                    doc.SetPageSize(mlor.GetPageSizeWithRotation(1))
                                    doc.NewPage()
                                    Dim cb As PdfContentByte = writer.DirectContent
                                    Dim page1 As PdfImportedPage = writer.GetImportedPage(mlor, 1)
                                    cb.AddTemplate(page1, 10, 10)
                                    mlor.Close()
                                    strBody += clientSixNumber & " Modified Letter Of Rep Found..." & vbCrLf
                                    bGotModLtrRep = True
                            End Select
                        End If

                    Next

                    If bGotModLtrRep = False Then
                        Dim objDocument As New SharedFunctions.DocumentAttachment
                        Dim docID As String
                        Using conn As New SqlConnection(ConfigurationManager.AppSettings("connectionstring").ToString)
                            If conn.State = ConnectionState.Closed Then conn.Open()
                            docID = objDocument.GetDocID(conn)
                        End Using

                        Dim pdfFileName As String = String.Format("{0}_D6003A_{1}_{2}.pdf", _
                              currentClient.ClientSixHundredNumber.Trim, _
                              docID, _
                              Format(Now, "yyddMM"))
                        Dim credFolder As String = String.Format("{0}_{1}", currentClient.CreditorAccountID, currentClient.CreditorName)
                        Dim pdfPath As String = String.Format("{0}\{1}\CreditorDocs\{2}\{3}", ServerPath, currentClient.ClientSixHundredNumber.Trim, credFolder, pdfFileName).Replace(" ", "")
                        objDocument = Nothing

                        'create new one
                        Dim rDoc As New GrapeCity.ActiveReports.Document.SectionDocument
                        Dim argString As String = "ModifiedLetterOfRepresentation," & currentClient.CreditorInstanceID
                        Dim args() As String = argString.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)

                        Using ltr As New LexxiomLetterTemplates.LetterTemplates(ConfigurationManager.ConnectionStrings("DMS_ConnectionString").ToString)
                            rDoc = ltr.ViewTemplate("ModifiedLetterOfRepresentation", currentClient.DataClientID, args, False, )
                        End Using

                        Dim badFileNameChars As Char() = System.IO.Path.GetInvalidFileNameChars
                        For Each badFileNameChar As Char In badFileNameChars
                            If pdfPath.Contains(badFileNameChar) Then
                                pdfPath.Replace(badFileNameChar, "_")
                            End If
                        Next
                        If Directory.Exists(Path.GetDirectoryName(pdfPath)) = False Then
                            Directory.CreateDirectory(Path.GetDirectoryName(pdfPath))
                        End If
                        Using pExp As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport()
                            pExp.Export(rDoc, pdfPath)
                        End Using

                        Dim mlor As New iTextSharp.text.pdf.PdfReader(pdfPath)
                        doc.SetPageSize(mlor.GetPageSizeWithRotation(1))
                        doc.NewPage()
                        Dim cb As PdfContentByte = writer.DirectContent
                        Dim page1 As PdfImportedPage = writer.GetImportedPage(mlor, 1)
                        cb.AddTemplate(page1, 10, 10)
                        mlor.Close()

                        Dim msg As String = String.Format("{0} #{1}: {2}", currentClient.CreditorName, Right(currentClient.CreditorAcctNum, 4), "Modified Letter of Representation generated from Find POA tool.")

                        Dim intNoteID As Integer = NoteHelper.InsertNote(msg.ToString, UserID, currentClient.DataClientID)
                        'relate creditor to note
                        NoteHelper.RelateNote(intNoteID, 2, currentClient.CreditorAccountID)

                        'attach creditor copy of letter

                        DocumentAttachment.AttachDocument("note", intNoteID, Path.GetFileName(pdfPath), UserID, String.Format("{0}\", credFolder))
                        DocumentAttachment.AttachDocument("client", currentClient.DataClientID, Path.GetFileName(pdfPath), UserID)
                        DocumentAttachment.AttachDocument("account", currentClient.CreditorAccountID, Path.GetFileName(pdfPath), UserID, String.Format("{0}\", credFolder))
                        DocumentAttachment.CreateScan(Path.GetFileName(pdfPath), UserID, Now)
                        strBody += clientSixNumber & " Modified Letter Of Rep Created..." & vbCrLf
                    End If
                Else
                    strBody += String.Format("{0} has no account ending in #{1}" & vbCrLf, clientSixNumber, crLastFour)
                End If

            Catch ex As Exception
                strBody += clientID & " POA Not Found!!!" & vbCrLf & ex.Message
                Continue For
            End Try
        Next

        Try
            doc.Close()

            email.Attachments.Add(New Mail.Attachment(combinedStampedPDFPOAPath))
            email.Body += strBody

        Catch ex As Exception
            email.Body += vbCrLf & ex.Message
        End Try

        Dim smtp As New Mail.SmtpClient("dc02.dmsi.local")
        smtp.Send(email)
    End Sub

    Private Sub btnProcess_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnProcess.Click
        If txtAccts.Text.ToString <> "" Then
            Dim pArgs As New List(Of String)
            UserEmail = SharedFunctions.AsyncDB.executeScalar(String.Format("select emailaddress from tbluser where userid = {0}", UserID), ConfigurationManager.AppSettings("connectionstring").ToString)
            pArgs.Add(UserEmail)
            pArgs.Add(txtAccts.Text)
            pArgs.Add(chkAddInfo.Checked)
            pArgs.Add(chkMLOR.Checked)

            tblPOA.Style("display") = "none"

            Dim p As ProcessList_Delegate
            p = New ProcessList_Delegate(AddressOf ProcessList)

            Dim r As IAsyncResult
            r = p.BeginInvoke(pArgs, New AsyncCallback(AddressOf TaskCompleted), Nothing)

            Session("result") = r

            divStatus.InnerHtml = BuildMSGDiv("You will receive an email when your files are ready.  <a href=""findpoa.aspx"">Find More</a>")
        Else
            divStatus.InnerHtml = BuildMSGDiv("At least 1 account must be specified!")
        End If
    End Sub

#End Region 'Methods
End Class