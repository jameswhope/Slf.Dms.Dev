Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO
Imports System.Linq

Imports AttachSifHelper

Imports LexxiomBarcodeHelper

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports iTextSharp.text
Imports iTextSharp.text.pdf

Partial Class ClientDocumentAttachTask
    Inherits System.Web.UI.UserControl
    Implements ICallbackEventHandler

    #Region "Fields"

    Public TaskID As Integer = 0

    Private UserID As Integer
    Private _AttachmentFilePath As String
    Private _IsPopup As Boolean
    Private _SettlementID As Integer
    Private _callResolutionId As Integer

    #End Region 'Fields

    #Region "Events"

    Public Event SIFAttached As EventHandler

    #End Region 'Events

    #Region "Properties"

    Public Property AttachmentFilePath() As String
        Get
            If IsNothing(Session("AttachFilePath")) Then
                Session("AttachFilePath") = ""
            End If
            Return Session("AttachFilePath")
        End Get
        Set(ByVal value As String)
            Session("AttachFilePath") = value
        End Set
    End Property

    Public Property CallResolutionId() As Integer
        Get
            Return _callResolutionId
        End Get
        Set(ByVal value As Integer)
            _callResolutionId = value
        End Set
    End Property

    Public Property IsPopup() As Boolean
        Get
            Return _IsPopup
        End Get
        Set(ByVal value As Boolean)
            _IsPopup = value
        End Set
    End Property

    Public Property SelectedSettlement() As _AttachSettlementInfo
        Get
            Return Session("_selectedSettlement")
        End Get
        Set(ByVal value As _AttachSettlementInfo)
            Session("_selectedSettlement") = value
        End Set
    End Property

    Public Property SettlementID() As Integer
        Get
            Return _SettlementID
        End Get
        Set(ByVal value As Integer)
            _SettlementID = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Public Shared Function CreateNewDocumentName(ByVal ClientID As Integer, ByVal documentTypeID As String, ByVal CreditorAccountID As Integer, ByVal CreditorID As Integer, ByVal ClientAccountNumber As String, ByVal creditorDIR As String) As String
        Dim tempName As New StringBuilder
        Dim tempPath As String
        Dim rootDIR As String = SharedFunctions.DocumentAttachment.CreateDirForClient(ClientID)
        Dim dateStr As String = DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0")
        Dim tempDocID As String = String.Format("{0}_{1}_{2}_{3}.pdf", ClientAccountNumber, documentTypeID, ReportsHelper.GetNewDocID(), dateStr)

        tempName.Append(AccountHelper.GetCreditorName(CreditorAccountID))
        tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "")
        tempPath = String.Format("{0}CreditorDocs\{1}{2}", rootDIR, creditorDIR, tempDocID)

        If Directory.Exists(rootDIR & "CreditorDocs\" + creditorDIR + "\") = False Then
            Directory.CreateDirectory(rootDIR & "CreditorDocs\" + creditorDIR + "\")
        End If

        Return tempPath
    End Function

    Public Shared Function CreateNewDocumentName(ByVal rootDir As String, ByVal ClientID As Integer, ByVal strDocTypeID As String, Optional ByVal subFolder As String = "ClientDocs\") As String
        Dim ssql As String = String.Format("SELECT AccountNumber FROM tblClient WHERE ClientID = {0}", ClientID.ToString)
        Dim acctNum As String = SqlHelper.ExecuteScalar(ssql, CommandType.Text)

        Dim ret As String
        ret = rootDir + subFolder + acctNum + "_" + strDocTypeID + "_" + ReportsHelper.GetNewDocID() + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        Return ret
    End Function

    Public Shadows Shared Function FindControl(ByVal startingControl As Control, ByVal id As String) As Control
        If id = startingControl.ID Then Return startingControl
        For Each ctl As Control In startingControl.Controls
            Dim found = FindControl(ctl, id)
            If found IsNot Nothing Then Return found
        Next
        Return Nothing
    End Function

    Public Shared Function ResizeImage(ByVal originalImage As System.Drawing.Image, ByVal width As Integer, ByVal height As Integer, ByVal format As System.Drawing.Imaging.ImageFormat) As System.Drawing.Image
        Dim finalImage As System.Drawing.Image = New Bitmap(width, height)

        Dim graphic As Graphics = Graphics.FromImage(finalImage)

        graphic.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality
        graphic.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality
        graphic.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic

        Dim rectangle As New Drawing.Rectangle(0, 0, width, height)

        graphic.DrawImage(originalImage, rectangle)

        Return finalImage
    End Function

    Public Function GetCallbackResult() As String Implements System.Web.UI.ICallbackEventHandler.GetCallbackResult
        Dim args As String() = Session("arg").ToString.Split("|")
        Select Case args(0)
            Case "adddocdrop"
                If Not IsNothing(SelectedSettlement) Then
                    Dim sd As New SettlementDocumentObject(args(2), args(3))
                    SelectedSettlement.SettlementDocuments.Add(sd)
                End If
        End Select

        Return Session("arg")
    End Function

    Public Sub RaiseCallbackEvent(ByVal eventArgument As String) Implements System.Web.UI.ICallbackEventHandler.RaiseCallbackEvent
        Dim args As String() = eventArgument.ToString.Split("|")

        Session("arg") = eventArgument
    End Sub

    Public Sub hideMSG()
        dvSettlementMsg.Style("display") = "none"
        dvSettlementMsg.Controls.Clear()
    End Sub
    Public Sub showMsg(ByVal msgText As String, ByVal msgType As String)
        dvSettlementMsg.Style("display") = "block"
        dvSettlementMsg.Attributes("class") = msgType
        dvSettlementMsg.Controls.Add(New LiteralControl(msgText))
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim sm As ScriptManager = ScriptManager.GetCurrent(Me.Page)

        If IsNothing(sm) Then
            sm = New ScriptManager
            Me.Page.Controls.Add(sm)
        End If

        sm.Scripts.Add(New ScriptReference("~/negotiation/attach/AttachSIFDragNDrop.js"))
        sm.Scripts.Add(New ScriptReference("PreviewScript.js", "Microsoft.Web.Preview"))
        sm.Scripts.Add(New ScriptReference("PreviewDragDrop.js", "Microsoft.Web.Preview"))

        UserID = Integer.Parse(Page.User.Identity.Name)
        TaskID = Request.QueryString("id").ToString

        ScriptManager.GetCurrent(Me.Page).RegisterPostBackControl(btnUpload)

        If Not IsPostBack Then
            hideMSG()
            AttachmentFilePath = ""
            ShowDisplay(ShowGUI_Enum.ResetGUI)
            LoadAttachData(TaskID)
        End If
        If AttachmentFilePath.ToString <> "" Then
            hideMSG()
            phSIFs.Controls.Clear()
            phSIFs.Controls.Add(ProcessAttachment(AttachmentFilePath))
        End If

        SetRollups()
        BuildCallbackString()
    End Sub

    Protected Sub btnAttachManual_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAttach.Click
        Try
            'do we need to process attachment
            'before moving to next row

            If SelectedSettlement.SettlementDocuments.Count > 0 Then
                With SelectedSettlement
                    .SpecialInstructions = SpecialInstructionsTextBox.Text
                    .OverrideReason = String.Format("{0};{1}", OverrideReasonHidden.Value, hdnOverrideAcctID.Value)
                    If .OverrideReason.Trim = ";" Then
                        .OverrideReason = ""
                    End If
                    .PayableTo = CheckPayableTextBox.Text.Replace("'", "''")
                End With

                If SelectedSettlement.IsClientStipulation Then
                    Dim csSetts = From sett As SettlementDocumentObject _
                                 In SelectedSettlement.SettlementDocuments _
                                 Where sett.DocumentType = "D9012" _
                                 Select sett
                    If csSetts.Count = 0 Then
                        showMsg("This settlement requires that a Client Stipulation document get attached!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", "error")
                        Exit Sub
                    End If
                End If

                AttachSifToClient(SelectedSettlement)

                'WorkflowHelper.ResolveTask(TaskID, UserID, 1)

                showMsg(String.Format("SIF Attached for {0}!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", SelectedSettlement.SettlementClientName), "success")

            Else
                showMsg(String.Format("There are no documents attached for {0}!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", SelectedSettlement.SettlementClientName), "error")
            End If

        Catch ex As Exception
            Throw
        End Try
    End Sub

    Protected Sub btnResetUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnResetUpload.Click
        hdnFile.Value = ""
        AttachmentFilePath = ""
        ShowDisplay(ShowGUI_Enum.ResetGUI)
    End Sub

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click
        Dim script As String = String.Empty

        If filSif.HasFile Then
            If Not Path.GetExtension(filSif.PostedFile.FileName).ToLower = ".tif" And Not Path.GetExtension(filSif.PostedFile.FileName).ToLower = ".pdf" Then
                script = "The uploaded file is not a valid image file."
            End If
        Else
            script = "Please specify a valid file."
        End If

        If String.IsNullOrEmpty(script) Then
            'Uploaded file is valid, now we can do whatever we like to do, copying it file system,
            Dim sFileName As New StringBuilder

            sFileName.Append(ConfigurationManager.AppSettings("SifDirectory") & "\")
            sFileName.Append(Path.GetFileName(filSif.PostedFile.FileName))
            If Not File.Exists(sFileName.ToString) Then
                filSif.PostedFile.SaveAs(sFileName.ToString)
            End If

            filSif.PostedFile.InputStream.Close()
            filSif.PostedFile.InputStream.Dispose()

            hdnFile.Value = sFileName.ToString
            AttachmentFilePath = hdnFile.Value
            Try
                phSIFs.Controls.Clear()
                phSIFs.Controls.Add(ProcessAttachment(AttachmentFilePath))
                ShowDisplay(ShowGUI_Enum.ShowUploadSuccess)
                script = "SIF uploaded."
            Catch ex As Exception
                divUploadError.Controls.Add(New LiteralControl("Error converting PDF.  Try converting to TIF."))
                divUploadError.Attributes.Add("class", "error")
                divUploadError.Style("display") = "block"
                AttachmentFilePath = ""
            End Try

        Else
            divUploadError.Controls.Add(New LiteralControl(script))
            divUploadError.Attributes.Add("class", "error")
            divUploadError.Style("display") = "block"
        End If
    End Sub

    Private Shared Function CreateDocs(ByVal attach As _AttachSettlementInfo, ByVal LoggedInUserID As Integer) As List(Of SettlementDocumentObject)
        Dim docHashTbl As New Dictionary(Of String, List(Of String))
        Dim strCredFolder As String = SharedFunctions.DocumentAttachment.GetCreditorDir(attach.SettlementCreditorAccountID)
        Dim newDocList As New List(Of SettlementDocumentObject)
        Try
            For Each docObj As KeyValuePair(Of String, List(Of String)) In groupLikeDocuments(attach)
                'create new document for each doc type
                'create pdf doc
                Dim pdfFilePath As String = ""
                Dim document As iTextSharp.text.Document = Nothing
                Dim writer As PdfWriter = Nothing
                Dim cb As PdfContentByte = Nothing
                document = New iTextSharp.text.Document(PageSize.A4, 50, 50, 50, 50)
                'get new pdf doc name
                pdfFilePath = CreateNewDocumentName(attach.SettlementClientID, docObj.Key, attach.SettlementCreditorAccountID, attach.SettlementCreditorID, attach.SettlementClientSDAAccountNumber, strCredFolder)
                newDocList.Add(New SettlementDocumentObject(docObj.Key, pdfFilePath))

                writer = PdfWriter.GetInstance(document, New FileStream(pdfFilePath, FileMode.Create))
                document.Open()
                cb = writer.DirectContent
                For Each pageObj As String In TryCast(docObj.Value, List(Of String))

                    Using img As System.Drawing.Image = ResizeImage(System.Drawing.Image.FromFile(pageObj.Replace("%20", " ").Replace("/", "\").Replace("file:", "")), 800, 1000, Imaging.ImageFormat.Jpeg)
                        Dim textImg As iTextSharp.text.Image = iTextSharp.text.Image.GetInstance(img, Drawing.Imaging.ImageFormat.Jpeg)
                        textImg.ScalePercent(70.0F)
                        textImg.SetAbsolutePosition(20, 50)
                        cb.AddImage(textImg)

                        'append doc info barcode
                        Dim barcodeString As New StringBuilder
                        Dim dID As String() = Path.GetFileNameWithoutExtension(pdfFilePath).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
                        barcodeString.AppendFormat("*{0}:{1}*", attach.SettlementClientSDAAccountNumber, dID(2).ToString)  'account 600#:docid

                        Using bcImg As System.Drawing.Image = Drawing.Image.FromStream(buildbarcodeImage(barcodeString.ToString, barcodeOrientation.enumVertical))
                            Dim barImg As iTextSharp.text.Image = iTextSharp.text.Image.GetInstance(bcImg, Drawing.Imaging.ImageFormat.Png)
                            barImg.SetAbsolutePosition(5, 500)
                            cb.AddImage(barImg)
                        End Using

                        document.NewPage()
                    End Using
                Next
                document.Close()
                document = Nothing
                cb = Nothing
                writer = Nothing
                GC.Collect()
            Next

        Catch ex As Exception
            Throw New Exception(String.Format("Attach SIF - CreateDocs ERROR : {0}", ex.Message))
        Finally
            GC.Collect()
        End Try

        Return newDocList
    End Function

    Private Shared Function groupLikeDocuments(ByVal attach As _AttachSettlementInfo) As Dictionary(Of String, List(Of String))
        'group documents, tried linq group by
        Dim docHashTbl As New Dictionary(Of String, List(Of String))
        For Each docName As SettlementDocumentObject In attach.SettlementDocuments
            If docHashTbl.ContainsKey(docName.DocumentType) Then
                'add page to doc
                docHashTbl.Item(docName.DocumentType).Add(docName.DocumentPath)
            Else
                'create new doc
                Dim lstDocs As New List(Of String)
                lstDocs.Add(docName.DocumentPath)
                docHashTbl.Add(docName.DocumentType, lstDocs)
            End If

        Next
        Return docHashTbl
    End Function

    Private Sub AttachDoc(ByVal attach As _AttachSettlementInfo, ByVal pdfFileList As List(Of SettlementDocumentObject))
        Dim strUserID As String = Integer.Parse(Page.User.Identity.Name)
        Dim sNegotiator As String = UserHelper.GetName(strUserID)
        Dim msgText As New StringBuilder

        Dim sqlNote As String = "stp_NegotiationsSystemNoteInfo " & attach.SettlementCreditorAccountID
        Using dtNote As DataTable = SqlHelper.GetDataTable(sqlNote, CommandType.Text)
            For Each drow As DataRow In dtNote.Rows
                msgText.AppendFormat("{0}/{1} #{2}, ", drow("OriginalCreditorName").ToString, drow("CurrentCreditorName").ToString, drow("CreditorAcctLast4").ToString)
                Exit For
            Next
        End Using
        msgText.AppendFormat("the following documents were received on {0} by {1} :" & vbCrLf, Now, sNegotiator)
        'build note text
        For Each pdfFilePath As SettlementDocumentObject In pdfFileList
            Dim rptName As String = SqlHelper.ExecuteScalar(String.Format("select displayname from tbldocumenttype where typeid = '{0}'", pdfFilePath.DocumentType), CommandType.Text)
            msgText.AppendFormat(vbTab & "{0}" & vbCrLf, rptName)
        Next

        Dim intNoteID As Integer = NoteHelper.InsertNote(msgText.ToString, strUserID, attach.SettlementClientID)

        For Each pdfFilePath As SettlementDocumentObject In pdfFileList
            Dim credFolderPath As String = Path.GetDirectoryName(pdfFilePath.DocumentPath)
            credFolderPath = String.Format("{0}\", credFolderPath.Substring(credFolderPath.LastIndexOf("\") + 1))

            'relate creditor to note
            NoteHelper.RelateNote(intNoteID, 2, attach.SettlementCreditorAccountID)

            'attach creditor copy of letter
            SharedFunctions.DocumentAttachment.AttachDocument("note", intNoteID, Path.GetFileName(pdfFilePath.DocumentPath), strUserID, credFolderPath)
            SharedFunctions.DocumentAttachment.AttachDocument("account", attach.SettlementCreditorAccountID, Path.GetFileName(pdfFilePath.DocumentPath), strUserID, credFolderPath)
            NegotiationRoadmapHelper.InsertRoadmap(attach.SettlementID, 8, String.Format("{0} Received", pdfFilePath.DocumentType), strUserID)
        Next
    End Sub

    Private Function AttachSifToClient(ByVal attach As _AttachSettlementInfo) As Control
        Dim sifList As New List(Of AttachSIFResult)
        Dim sb As New StringBuilder

        '12.3.10.ug.resolve attach sif/cs step
        Dim tid As Integer = SettlementMatterHelper.GetMatterCurrentTaskID(attach.SettlementMatterID)
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("TaskId", tid))
        params.Add(New SqlParameter("userID", UserID))
        params.Add(New SqlParameter("taskresolutionID", "1"))
        SqlHelper.ExecuteScalar("stp_workflow_resolveTask", CommandType.StoredProcedure, params.ToArray)

        'create doc
        Dim pdfFilePaths As List(Of SettlementDocumentObject) = CreateDocs(attach, UserID)

        'attach doc
        AttachDoc(attach, pdfFilePaths)

        '*** Uncomment when we roll out the Processing Interface
        '*** Why are we doing this here? Move this into the Accept SIF app
        SettlementProcessingHelper.InsertSettlement(attach.SettlementID)

        sifList.Add(New AttachSIFResult() With {.ClientName = attach.SettlementClientName, _
                                         .CreditorName = Drg.Util.DataHelpers.AccountHelper.GetCurrentCreditorName(attach.SettlementCreditorAccountID), _
                                         .DocumentsAttachedCount = attach.SettlementDocuments.Count, _
                                         .SIFPath = "", .SpecialInstructions = attach.SpecialInstructions, _
                                         .SAFPath = ""})

        Dim specIntructions As String = attach.SpecialInstructions
        Dim settID As String = attach.SettlementID
        AttachSifHelper.SaveSpecialInstructions(settID, specIntructions, UserID)

        'get reasons
        If Not IsNothing(attach.OverrideReason) Then
            Dim overrideReason As String = attach.OverrideReason
            '0 = info
            Dim oreasonInfo As String() = overrideReason.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
            If oreasonInfo.Length > 0 Then
                Dim oinfo As String() = oreasonInfo(0).ToString.Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                '1 = override acct id
                Dim oAcct As String = oreasonInfo(1).ToString
                For Each o As String In oinfo
                    'fieldname,real value, entered value
                    Dim odata As String() = o.Split(New Char() {"*"}, StringSplitOptions.None)
                    If odata.Length < 3 Then
                        AttachSifHelper.SaveOverride(settID, oAcct, odata(0), odata(1), "", UserID)
                    Else
                        AttachSifHelper.SaveOverride(settID, oAcct, odata(0), odata(1), odata(2), UserID)
                    End If
                Next
            End If

        End If
        'Dim gv As GridView = BuildResultsGrid()
        'gv.DataSource = sifList
        'gv.DataBind()
        Dim lt As New LiteralControl("SIF Attached!")
        Return lt
    End Function
    Private Sub BuildCallbackString()
        Dim cm As ClientScriptManager = Page.ClientScript
        Dim cbReference As String
        cbReference = cm.GetCallbackEventReference(Me, "arg", "ReceiveServerData", "")
        Dim callbackScript As String = ""
        callbackScript &= "function CallServer(arg, context)" & "{" & cbReference & "; }"
        cm.RegisterClientScriptBlock(Me.Page.GetType(), "CallServer", callbackScript, True)

        Dim sm As ScriptManager = ScriptManager.GetCurrent(Me.Page)
        sm.RegisterPostBackControl(btnUpload)
    End Sub
    Private Function FindDocumentTypeDDLs(ByVal controlToSearch As Control) As List(Of DropDownList)
        Dim lst As New List(Of DropDownList)
        For Each ctl As Control In controlToSearch.Controls
            If TypeOf ctl Is DropDownList Then
                lst.Add(ctl)
            End If
            If ctl.HasControls Then
                lst.AddRange(FindDocumentTypeDDLs(ctl))
            End If
        Next

        Return lst
    End Function

    Private Sub LoadAttachData(ByVal taskID As Integer)
        Dim sqlGet As String = String.Format("select s.settlementid from tblmatter m inner join tblsettlements s on s.matterid = m.matterid inner join tbltask t on t.matterid = m.matterid where(t.taskid = {0})", taskID)
        Dim settId As String = SqlHelper.ExecuteScalar(sqlGet, CommandType.Text)

        SelectedSettlement = AttachSifHelper.GetSettlementInfo(settId)

        'load sett info
        Dim ssql As String = String.Format("stp_Negotiations_Get_AttachSIFData {0}", settId)
        Using dt As DataTable = SqlHelper.GetDataTable(ssql, Data.CommandType.Text)
            Dim irow As Integer = 1
            For Each row As DataRow In dt.Rows

                SettlementAmountLabel.Value = FormatCurrency(row("settlementamount").ToString, 2)
                SettlementDueDateLabel.Value = Format(CDate(row("settlementduedate").ToString), "MM/dd/yyyy")
                CreditorAccountBalanceLabel.Value = FormatCurrency(row("CreditorAccountBalance").ToString, 2)
                CreditorAccountNumberFullLabel.Value = row("CreditorAccountNumberFull").ToString
                CreditorReferenceNumberLabel.Value = row("CreditorReferenceNumber").ToString
                OriginalCreditorNameLabel.Value = row("Original Creditor Name").ToString
                CreditorNameLabel.Value = row("creditor name").ToString
                CheckPayableLabel.Value = "Dont Validate"
                rblClientNameMatch.SelectedValue = "NO"
                rblCreditorNameMatch.SelectedValue = "NO"

                Dim ph As PlaceHolder = TryCast(pnlSIFDocs.FindControl("phSifs"), PlaceHolder)
                Dim ddls As List(Of DropDownList) = FindDocumentTypeDDLs(ph)
                If SelectedSettlement.IsClientStipulation Then
                    Dim innerTxt As String = "<div style=""display:inline-block;background-color:#ffcccc;color:red;font-weight:bold;width:100%;" & _
                                            "text-align:center;border:solid 1px #8B1A1A; height:20px;vertical-align:middle;"">CLIENT STIPULATION IS REQUIRED!</div>"
                    dvSettlementMsg.InnerHtml = innerTxt
                    For Each ddl As DropDownList In ddls
                        ddl.SelectedIndex = 1
                        ddl.Items(2).Enabled = False
                    Next
                Else
                    dvSettlementMsg.InnerHtml = ""
                    For Each ddl As DropDownList In ddls
                        ddl.SelectedIndex = 0
                        ddl.Items(2).Enabled = True
                    Next
                End If

                irow += 1
            Next
        End Using
        chkOverride.Attributes.Add("onclick", String.Format("return showPopup(this,'{0}','{1}')", SelectedSettlement.SettlementID, SelectedSettlement.SettlementCreditorAccountID))
        fldSifDetail.Style("display") = "inline-block"
    End Sub

    Private Sub SetRollups()

        Dim div As Panel = FindControl(Me.Page.Master, "pnlRollupCommonTasks")
        Dim CommonTasks As HtmlTable = div.Controls(1)
        Dim tr As New HtmlTableRow
        Dim td As New HtmlTableCell
        Dim lnkTitle As String = "Resolve Task"
    
        td.InnerHtml = String.Format("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""javascript:AttachSettlementDocument();""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""{0}"" align=""absmiddle""/>{1}</a>", ResolveUrl("~/images/16x16_taskresolution.png"), lnkTitle)
        tr.Cells.Add(td)
        CommonTasks.Rows.Add(tr)
    End Sub

    Private Sub ShowDisplay(ByVal bShow As ShowGUI_Enum)
        Select Case bShow
            Case ShowGUI_Enum.ShowClientsFound
                fldUpload.Visible = False
                fldUpload.Style("display") = "none"
                fldSIFS.Visible = True
            Case ShowGUI_Enum.ShowUploadSuccess
                fldUpload.Visible = False
                fldUpload.Style("display") = "none"
                fldSIFS.Visible = True
            Case ShowGUI_Enum.ResetGUI
                fldUpload.Visible = True
                fldUpload.Style("display") = "block"
                fldSIFS.Visible = False
        End Select
    End Sub

    #End Region 'Methods

End Class