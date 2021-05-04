﻿Imports System
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports System.Linq

Imports AttachSifHelper

Imports GrapeCity.ActiveReports.Export.Pdf

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports LexxiomLetterTemplates

Imports SharedFunctions.AsyncDB

Imports iTextSharp.text
Imports iTextSharp.text.pdf

Partial Class AttachSifControl
    Inherits System.Web.UI.UserControl

    #Region "Fields"

    Public appTitleText As String

    Private _TotalClientSettlements As Integer
    Private _UserID As Integer

    #End Region 'Fields

    #Region "Enumerations"

    Public Enum enumMsgType
        SuccessMsg = 0
        ErrorMsg = 1
        WarningMsg = 2
        InfoMsg = 3
    End Enum

    #End Region 'Enumerations

    #Region "Events"

    Public Event SIFAttached As EventHandler

    #End Region 'Events

    #Region "Properties"

    ''' <summary>
    ''' holds list of items to attach to client/creditor acct
    ''' </summary>
    Public Property AttachSettlementInfoList() As Dictionary(Of String, List(Of _AttachSettlementInfo))
        Get
            Return Session("_attach")
        End Get
        Set(ByVal value As Dictionary(Of String, List(Of _AttachSettlementInfo)))
            If Session("_attach") Is Nothing Then
                Session("_attach") = New Dictionary(Of String, List(Of _AttachSettlementInfo))
            End If
            Session("_attach") = value
        End Set
    End Property

    Public Property AttachmentFilePath() As String
        Get
            Return Session("AttachFilePath")
        End Get
        Set(ByVal value As String)
            Session("AttachFilePath") = value
        End Set
    End Property

    Public Property TotalClientSettlements() As Integer
        Get
            Return ViewState("_TotalClientSettlements")
        End Get
        Set(ByVal value As Integer)
            ViewState("_TotalClientSettlements") = value
        End Set
    End Property

    Public Property UserID() As Integer
        Get
            Return ViewState("_UserID")
        End Get
        Set(ByVal value As Integer)
            ViewState("_UserID") = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Public Shared Function GetSIF_DocID() As String
        Dim docID As New StringBuilder

        docID.Append(executeScalar("SELECT [Value] FROM tblProperty WHERE [Name] = 'DocumentNumberPrefix'", ConfigurationManager.AppSettings("connectionstring").ToString))
        docID.Append(executeScalar("stp_GetDocumentNumber", ConfigurationManager.AppSettings("connectionstring").ToString))
        Return docID.ToString
    End Function

    Public Shared Function GetSIF_FileName(ByVal ClientID As Integer, ByVal CreditorAccountID As Integer, ByVal CreditorID As Integer, ByVal ClientAccountNumber As String, ByVal creditorDIR As String) As String
        Dim tempName As String
        Dim tempPath As String
        Dim rootDIR As String = SharedFunctions.DocumentAttachment.CreateDirForClient(ClientID)

        tempName = AccountHelper.GetCreditorName(CreditorAccountID)
        tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
        tempPath = rootDIR & "CreditorDocs\" & creditorDIR & ClientAccountNumber & "_D6011_" & GetSIF_DocID() & "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"

        If Directory.Exists(rootDIR & "CreditorDocs\" + creditorDIR + "\") = False Then
            Directory.CreateDirectory(rootDIR & "CreditorDocs\" + creditorDIR + "\")
        End If

        Return tempPath
    End Function

    Public Sub InitControl()
        AttachSettlementInfoList = New Dictionary(Of String, List(Of _AttachSettlementInfo))
    End Sub

    Protected Sub AttachSifControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        If Not IsPostBack Then
            ShowDisplay(ShowGUI_Enum.ResetGUI)
            AttachSettlementInfoList = New Dictionary(Of String, List(Of _AttachSettlementInfo))
            RaiseEvent SIFAttached(Me, Nothing)
        End If
        If AttachmentFilePath IsNot Nothing Then
            If AttachmentFilePath.ToString <> "" Then
                phSIFs.Controls.Clear()
                phSIFs.Controls.Add(ProcessAttachment(AttachmentFilePath))
            End If

        End If

        BindData()
    End Sub

    Protected Sub btnAttach_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAttach.Click
        If IsNothing(AttachSettlementInfoList) Then
            DisplayMessage(New LiteralControl("<b>No SIF's attached!<b><br/>Please try to attach document(s) to client(s) again."), enumMsgType.WarningMsg)
            Exit Sub
        End If
        If AttachSettlementInfoList.Count = 0 Then
            DisplayMessage(New LiteralControl("<b>No SIF's attached!<b><br/>Please try to attach document(s) to client(s) again."), enumMsgType.WarningMsg)
            Exit Sub
        End If

        Try
            Dim statusTbl As Control = AttachSifToClient(AttachSettlementInfoList)
            Dim sifFolder As New StringBuilder
            sifFolder.AppendFormat("{0}\{1}\", System.Configuration.ConfigurationManager.AppSettings("SifDirectory"), Session.SessionID)

            'clean up temp files
            Try
                Directory.Delete(sifFolder.ToString, True)
                File.Delete(AttachmentFilePath)
            Catch ex As Exception

            End Try

            AttachSettlementInfoList = New Dictionary(Of String, List(Of _AttachSettlementInfo))
            AttachmentFilePath = Nothing
            DisplayMessage(statusTbl, enumMsgType.SuccessMsg)
            RaiseEvent SIFAttached(Me, Nothing)

        Catch ex As Exception
            DisplayMessage(New LiteralControl(String.Format("Attach SIF Error:<br>{0}", ex.Message.ToString)), enumMsgType.ErrorMsg)
        End Try
    End Sub

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpload.Click
        Dim script As String = String.Empty

        If (filSIF.PostedFile IsNot Nothing) AndAlso (filSIF.PostedFile.ContentLength > 0) Then
            If Not IsValidImageFile(filSIF) Then
                script = "The uploaded file is not a valid image file."
            End If
        Else
            script = "Please specify a valid file."
        End If

        If String.IsNullOrEmpty(script) Then
            'Uploaded file is valid, now we can do whatever we like to do, copying it file system,
            Dim sFileName As New StringBuilder
            sFileName.Append(Configuration.ConfigurationManager.AppSettings("SifDirectory") & "\")
            sFileName.Append(Path.GetFileName(filSIF.PostedFile.FileName))
            If Not File.Exists(sFileName.ToString) Then
                filSIF.PostedFile.SaveAs(sFileName.ToString)
            End If
            filSIF.PostedFile.InputStream.Close()
            filSIF.PostedFile.InputStream.Dispose()

            hdnFile.Value = sFileName.ToString
            AttachmentFilePath = hdnFile.Value
            phSIFs.Controls.Clear()
            phSIFs.Controls.Add(ProcessAttachment(AttachmentFilePath))
            ShowDisplay(ShowGUI_Enum.ShowUploadSuccess)

            script = "SIF uploaded."
        Else
            divUploadError.Controls.Add(New LiteralControl(script))
            divUploadError.Attributes.Add("class", "error")
            divUploadError.Style("display") = "block"
        End If
    End Sub

    Protected Sub dsSearch_Selected(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsSearch.Selected
        _TotalClientSettlements = e.AffectedRows.ToString
        lblHeader.Text = String.Format("{0} Settlements Waiting on SIF", _TotalClientSettlements)
    End Sub

    Protected Sub dsSearch_Selecting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceSelectingEventArgs) Handles dsSearch.Selecting
        e.Command.CommandTimeout = 300
    End Sub

    Protected Sub gvClients_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvClients.DataBound
        Try
            Dim pagerRow As GridViewRow = gvClients.BottomPagerRow
            ' Retrieve the DropDownList and Label controls from the row.
            Dim pageList As DropDownList = CType(pagerRow.Cells(0).FindControl("ddlPage"), DropDownList)
            Dim pageLabel As Label = CType(pagerRow.Cells(0).FindControl("CurrentPageLabel"), Label)
            If Not pageList Is Nothing Then
                Dim i As Integer
                For i = 0 To gvClients.PageCount - 1
                    ' Create a ListItem object to represent a page.
                    Dim pageNumber As Integer = i + 1
                    Dim item As New System.Web.UI.WebControls.ListItem(pageNumber.ToString())
                    If i = gvClients.PageIndex Then
                        item.Selected = True
                    End If
                    pageList.Items.Add(item)
                Next i
            End If
            If Not pageLabel Is Nothing Then
                ' Calculate the current page number.
                Dim currentPage As Integer = gvClients.PageIndex + 1
                ' Update the Label control with the current page information.
                pageLabel.Text = " of " & gvClients.PageCount.ToString()
            End If

        Catch ex As Exception

        End Try
    End Sub

    Protected Sub gvClients_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvClients.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                e.Row.ID = String.Format("trClientRow_{0}", rowView("Settlementid").ToString)
                e.Row.Style("cursor") = "hand"

                Dim dv As HtmlGenericControl = e.Row.FindControl("divAttach")
                dv.Attributes.Add("rowID", e.Row.ClientID)

                Dim keys As DataKey = gvClients.DataKeys(e.Row.RowIndex)
                Dim sDrops As String = String.Format("AddDropTarget('{0}');", e.Row.ClientID)
                ScriptManager.RegisterStartupScript(Me, Me.GetType, e.Row.ID, sDrops, True)
                e.Row.VerticalAlign = VerticalAlign.Top
        End Select
    End Sub

    Protected Sub gv_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")

                Dim img As New HtmlImage
                img.Src = "~/images/16x16_check.png"
                e.Row.Cells(2).Controls.Add(img)

        End Select
    End Sub

    Protected Sub lnkClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClose.Click
        Response.Redirect("default.aspx")
    End Sub

    Private Shared Function CreateDoc(ByVal attach As KeyValuePair(Of String, List(Of _AttachSettlementInfo)), ByVal gotdocs As List(Of _AttachSettlementInfo)) As String
        'create pdf doc
        Dim pdfFilePath As String = ""
        Dim document As iTextSharp.text.Document = Nothing
        Dim writer As PdfWriter = Nothing
        Dim cb As PdfContentByte = Nothing

        Try
            document = New iTextSharp.text.Document(PageSize.A4, 50, 50, 50, 50)
            Dim strCredFolder As String = SharedFunctions.DocumentAttachment.GetCreditorDir(attach.Value.Item(0).SettlementCreditorAccountID)
            pdfFilePath = GetSIF_FileName(attach.Value.Item(0).SettlementClientID, attach.Value.Item(0).SettlementCreditorAccountID, attach.Value.Item(0).SettlementCreditorID, attach.Value.Item(0).SettlementClientSDAAccountNumber, strCredFolder)
            writer = PdfWriter.GetInstance(document, New FileStream(pdfFilePath, FileMode.Create))
            document.Open()
            cb = writer.DirectContent
            For Each doc As _AttachSettlementInfo In gotdocs
                'loop thru sifs to create one pdf
                For Each docName As SettlementDocumentObject In doc.SettlementDocuments
                    Dim img As System.Drawing.Image = System.Drawing.Image.FromFile(docName.DocumentPath.Replace("%20", " ").Replace("/", "\").Replace("file:", ""))
                    Dim textImg As iTextSharp.text.Image = iTextSharp.text.Image.GetInstance(img, Imaging.ImageFormat.Gif)
                    textImg.ScalePercent(70.0F)
                    textImg.SetAbsolutePosition(0, 50)
                    cb.AddImage(textImg)
                    document.NewPage()
                    img.Dispose()
                Next
            Next
            'close pdf doc
            document.Close()
        Catch ex As Exception
            Throw New Exception(String.Format("Attach SIF - CreateDoc ERROR : {0}", ex.Message))
        Finally
            cb = Nothing
            writer = Nothing
            document = Nothing
            GC.Collect()
        End Try

        Return pdfFilePath
    End Function

    Private Shared Function IsValidImageFile(ByVal file As HtmlInputFile) As Boolean
        Try
            Using bmp As New Bitmap(file.PostedFile.InputStream)
                Return True
            End Using
        Catch generatedExceptionName As ArgumentException
            'throws exception if not valid image
        End Try

        Return False
    End Function

    Private Sub AttachDoc(ByVal attach As KeyValuePair(Of String, List(Of _AttachSettlementInfo)), ByVal pdfFilePath As String)
        Dim strUserID As String = Integer.Parse(Page.User.Identity.Name)
        Dim credFolderPath As String = Path.GetDirectoryName(pdfFilePath)
        credFolderPath = String.Format("{0}\", credFolderPath.Substring(credFolderPath.LastIndexOf("\") + 1))
        Dim MatterId As Integer = CInt(DataHelper.FieldLookup("tblSettlements", "MatterId", "SettlementId = " & attach.Value.Item(0).SettlementID))
        'attach to creditor and client here
        Dim sMsg As New StringBuilder
        Dim sqlNote As String = "stp_NegotiationsSystemNoteInfo " & attach.Value.Item(0).SettlementCreditorAccountID
        Dim dtNote As DataTable = executeDataTableAsync(sqlNote, ConfigurationManager.AppSettings("connectionstring").ToString)
        For Each drow As DataRow In dtNote.Rows
            sMsg.AppendFormat("{0}/{1} #{2}, ", drow("OriginalCreditorName").ToString, drow("CurrentCreditorName").ToString, drow("CreditorAcctLast4").ToString)
            Exit For
        Next
        dtNote.Dispose()

        Dim sNegotiator As String = UserHelper.GetName(strUserID)
        sMsg.AppendFormat("SIF Received by {0} on {1}. " & vbCrLf, sNegotiator, Now)

        Dim intNoteID As Integer = NoteHelper.InsertNote(sMsg.ToString, strUserID, attach.Value.Item(0).SettlementClientID)
        'relate creditor to note
        NoteHelper.RelateNote(intNoteID, 2, attach.Value.Item(0).SettlementCreditorAccountID)

        'attach creditor copy of letter
        SharedFunctions.DocumentAttachment.AttachDocument("note", intNoteID, Path.GetFileName(pdfFilePath), strUserID, credFolderPath)
        SharedFunctions.DocumentAttachment.AttachDocument("account", attach.Value.Item(0).SettlementCreditorAccountID, Path.GetFileName(pdfFilePath), strUserID, credFolderPath)
        SharedFunctions.DocumentAttachment.AttachDocument("matter", MatterId, Path.GetFileName(pdfFilePath), strUserID, credFolderPath)
        NegotiationRoadmapHelper.InsertRoadmap(attach.Value.Item(0).SettlementID, 8, "SIF Received", strUserID)
    End Sub

    Private Function AttachSifToClient(ByVal goodDrops As Dictionary(Of String, List(Of _AttachSettlementInfo))) As Control
        Dim sifList As New List(Of AttachSIFResult)
        Dim sb As New StringBuilder

        For Each attach As KeyValuePair(Of String, List(Of _AttachSettlementInfo)) In goodDrops
            'get list of attachments
            Dim lat As List(Of _AttachSettlementInfo) = TryCast(attach.Value, List(Of _AttachSettlementInfo))
            'find all that have docs attached
            Dim gotdocs As List(Of _AttachSettlementInfo) = lat.FindAll(Function(e As _AttachSettlementInfo) e.SettlementDocuments.Count > 0)
            If gotdocs.Count > 0 Then
                InsertMatterAndTask(attach.Value.Item(0).SettlementClientID, attach.Value.Item(0).SettlementID, attach.Value.Item(0).SettlementCreditorAccountID)

                Dim sqlPayableTo As String = String.Format("UPDATE tblsettlements_DeliveryAddresses Set PayableTo = '{0}' where settlementid = {1}", attach.Value.Item(0).PayableTo, attach.Value.Item(0).SettlementID)
                SqlHelper.ExecuteNonQuery(sqlPayableTo, CommandType.Text)

                'create doc
                Dim pdfFilePath As String = CreateDoc(attach, gotdocs)
                'attach doc
                AttachDoc(attach, pdfFilePath)
                '*** Uncomment when we roll out the Processing Interface
                '*** Why are we doing this here? Move this into the Accept SIF app
                SettlementProcessingHelper.InsertSettlement(attach.Value.Item(0).SettlementID)
                Drg.Util.DataHelpers.SettlementHelper.DistributeSettlements()

                sifList.Add(New AttachSIFResult() With {.ClientName = attach.Value.Item(0).SettlementClientName, _
                                                 .CreditorName = Drg.Util.DataHelpers.AccountHelper.GetCurrentCreditorName(attach.Value.Item(0).SettlementCreditorAccountID), _
                                                 .DocumentsAttachedCount = attach.Value.Item(0).SettlementDocuments.Count, _
                                                 .SIFPath = pdfFilePath, .SpecialInstructions = attach.Value.Item(0).SpecialInstructions, _
                                                 .SAFPath = ""})

                Dim specIntructions As String = attach.Value.Item(0).SpecialInstructions
                Dim settID As String = attach.Value.Item(0).SettlementID
                AttachSifHelper.SaveSpecialInstructions(settID, specIntructions, UserID)

            End If

        Next

        Dim gv As GridView = BuildResultsGrid()
        gv.DataSource = sifList
        gv.DataBind()

        Return gv
    End Function

    Private Sub BindData()
        dsSearch.SelectParameters("UserID").DefaultValue = UserID
        dsSearch.SelectParameters("searchTerm").DefaultValue = "%"
        dsSearch.DataBind()
    End Sub

    Private Function BuildResultsGrid() As GridView
        Dim gv As New GridView
        AddHandler gv.RowDataBound, AddressOf gv_RowDataBound
        gv.CssClass = "entry"
        gv.Width = New Unit("100%")
        gv.AutoGenerateColumns = False
        Dim colNames As String() = "ClientName,CreditorName,DocumentsAttachedCount,SpecialInstructions".Split(",")
        gv.Caption = "<div style='font-weight: bold;font-size:14pt;background-color:#3376AB;color:white;'>Attach SIF Results</div>"
        For Each col As String In colNames
            Dim bf As New BoundField
            bf.HeaderStyle.BackColor = Drawing.ColorTranslator.FromHtml("#DCDCDC")
            bf.HtmlEncode = True
            bf.DataField = col
            bf.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
            bf.ItemStyle.HorizontalAlign = HorizontalAlign.Left
            Select Case col
                Case "ClientName", "CreditorName"
                    bf.HeaderText = col.Replace("Name", " Name")
                Case "DocumentsAttachedCount"
                    bf.HeaderText = "SIF Attached"
                    bf.HeaderStyle.HorizontalAlign = HorizontalAlign.Center
                    bf.ItemStyle.HorizontalAlign = HorizontalAlign.Center
                Case "SpecialInstructions"
                    bf.HeaderText = "Special Instructions"
            End Select

            gv.Columns.Add(bf)
        Next

        Return gv
    End Function

    Private Sub DisplayMessage(ByVal msgObjControl As Control, ByVal msgType As enumMsgType)
        tblAttach.Style("display") = "none"
        divMsg.Style("border") = "1px solid"
        divMsg.Style("margin") = "10px 0px"
        divMsg.Style("padding") = "15px 10px 15px 50px"
        divMsg.Style("background-repeat") = "no-repeat"
        divMsg.Style("background-position") = "10px center"
        divMsg.Style("font-size") = "11pt"

        Select Case msgType
            Case enumMsgType.SuccessMsg
                divMsg.Style("color") = "#4F8A10"
                divMsg.Style("background-color") = "#DFF2BF"
                divMsg.Style("background-image") = "url('../../images/success.png')"
            Case enumMsgType.ErrorMsg
                divMsg.Style("color") = "#D8000C"
                divMsg.Style("background-color") = "#FFBABA"
                divMsg.Style("background-image") = "url('../../images/error.png')"
            Case enumMsgType.WarningMsg
                divMsg.Style("color") = "#9F6000"
                divMsg.Style("background-color") = "#FEEFB3"
                divMsg.Style("background-image") = "url('../../images/warning.png')"
            Case enumMsgType.InfoMsg
                divMsg.Style("color") = "#00529B"
                divMsg.Style("background-color") = "#BDE5F8"
                divMsg.Style("background-image") = "url('../../images/info.png')"

        End Select

        phMsg.Controls.Add(msgObjControl)
        divStatus.Style("display") = "block"
    End Sub

    Private Function GetAccountNumber(ByVal conn As SqlConnection, ByVal ClientID As Integer) As String
        Dim accountno As String

        If conn.State = ConnectionState.Closed Then conn.Open()

        Using cmd As New SqlCommand("SELECT AccountNumber FROM tblClient WHERE ClientID = " + ClientID.ToString(), conn)
            accountno = cmd.ExecuteScalar().ToString()
        End Using

        Return accountno
    End Function

    Private Function GetDocID(ByVal conn As SqlConnection) As String
        Dim docID As String

        Using cmd As New SqlCommand("SELECT [Value] FROM tblProperty WHERE [Name] = 'DocumentNumberPrefix'", conn)
            docID = cmd.ExecuteScalar().ToString()

            cmd.CommandText = "stp_GetDocumentNumber"
            docID += cmd.ExecuteScalar().ToString()
        End Using

        Return docID
    End Function

    Private Function GetUniqueDocumentName2(ByVal rootDir As String, ByVal ClientID As Integer, ByVal strDocTypeID As String, ByVal UserID As Integer, Optional ByVal subFolder As String = "ClientDocs\") As String
        Dim ret As String

        Using conn As SqlConnection = New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
            conn.Open()

            ret = rootDir + subFolder + GetAccountNumber(conn, ClientID) + "_" + strDocTypeID + "_" + GetDocID(conn) + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        End Using

        Return ret
    End Function

    ''' <summary>
    ''' Inserts a Matter of Type Settlement, adds a Task of Type Client Approval 
    ''' Make Fee Adjustments
    ''' </summary>
    ''' <param name="clientId">Client associated with the settlement</param>
    ''' <param name="settlementId">An Integer to uniquely identify the settlement</param>
    ''' <param name="creditorAcctId">Creditor AccountId of the settlement</param>
    ''' <returns>An Integer representing if the transaction was successful</returns>
    ''' <remarks>Puts the settlement in ClientAlerts queue.Assigns AttorneyId for Attorney Portal</remarks>
    Private Function InsertMatterAndTask(ByVal clientId As Integer, ByVal settlementId As Integer, ByVal creditorAcctId As Integer) As Integer
        'Adjust settlement Fee
        Dim settDesc As String = "Settlement - "
        Dim settFeeDesc As String = "Settlement Fee - "
        Dim adjustedDesc As String = "Fee Adjustment - "
        Dim DelDesc As String = "Delivery Fee - "
        Dim Desc As String

        Dim settAMount As Double = CDbl(DataHelper.FieldLookup("tblSettlements", "SettlementAmount", "SettlementId = " & settlementId))
        Dim settFee As Double = CDbl(DataHelper.FieldLookup("tblSettlements", "SettlementFee", "SettlementId = " & settlementId))
        Dim delAmount As Double = CDbl(DataHelper.FieldLookup("tblSettlements", "DeliveryAmount", "SettlementId = " & settlementId))
        Dim delMethod As String = DataHelper.FieldLookup("tblSettlements", "DeliveryMethod", "SettlementId = " & settlementId)

        Dim strCredName As String = ""

        Desc = SettlementMatterHelper.GetSettRegisterEntryDesc(creditorAcctId)
        settDesc += Desc
        settFeeDesc += Desc
        adjustedDesc += Desc
        DelDesc += Desc

        SettlementFeeHelper.AdjustSettlementFee(settlementId, clientId, UserID, creditorAcctId)

        Dim adjustedFee As Double = CDbl(DataHelper.FieldLookup("tblSettlements", "AdjustedSettlementFee", "SettlementId = " & settlementId))

        SettlementMatterHelper.AddFeeAdjustmentsToSettlement(settlementId, 18, settDesc, (Math.Abs(settAMount) * -1), UserID, True, -1, False, Nothing)
        SettlementMatterHelper.AddFeeAdjustmentsToSettlement(settlementId, 4, settFeeDesc, (Math.Abs(settFee) * -1), UserID, True, -1, False, Nothing)

        If delAmount <> 0 Then
            If delAmount = 15 Then
                SettlementMatterHelper.AddFeeAdjustmentsToSettlement(settlementId, 6, DelDesc, (Math.Abs(delAmount) * -1), UserID, True, -1, False, Nothing)
            Else
                SettlementMatterHelper.AddFeeAdjustmentsToSettlement(settlementId, IIf(delMethod.Equals("chkbytel"), 28, 6), DelDesc, (Math.Abs(delAmount) * -1), UserID, True, -1, False, Nothing)
            End If
        End If

        If adjustedFee <> 0 Then
            SettlementMatterHelper.AddFeeAdjustmentsToSettlement(settlementId, -2, adjustedDesc, (adjustedFee * -1), UserID, True, -1, False, Nothing)
        End If

        'Add Matter
        Dim ret As Integer
        Dim returnValue As Integer
        Dim matterTransaction As IDbTransaction = Nothing
        Dim returnParam As IDataParameter
        Dim outputParam As IDataParameter
        Dim TaskTypeId As Integer

        '*** Uncomment this part when cancellations roll out
        Using connection As IDbConnection = ConnectionFactory.Create()
            connection.Open()
            matterTransaction = CType(connection, IDbConnection).BeginTransaction(IsolationLevel.RepeatableRead)
            'Using cmd As IDbCommand = connection.CreateCommand()
            '    cmd.CommandText = "stp_CreateMatterForSettlement"
            '    cmd.CommandType = CommandType.StoredProcedure
            '    DatabaseHelper.AddParameter(cmd, "ClientId", clientId)
            '    DatabaseHelper.AddParameter(cmd, "SettlementId", settlementId)
            '    DatabaseHelper.AddParameter(cmd, "CreditorAcctId", creditorAcctId)
            '    DatabaseHelper.AddParameter(cmd, "MatterStatusCodeId", 23)
            '    DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
            '    DatabaseHelper.AddParameter(cmd, "MatterTypeId", 3)
            '    DatabaseHelper.AddParameter(cmd, "MatterStatusId", 3)
            '    DatabaseHelper.AddParameter(cmd, "MatterMemo", "Generating a matter for the settlement")
            '    DatabaseHelper.AddParameter(cmd, "MatterSubStatusId", 51)
            '    returnParam = DatabaseHelper.CreateAndAddParamater(cmd, "Return", DbType.Int32)
            '    returnParam.Direction = ParameterDirection.ReturnValue
            '    outputParam = DatabaseHelper.CreateAndAddParamater(cmd, "MatterId", DbType.Int32)
            '    outputParam.Direction = ParameterDirection.Output
            '    cmd.Transaction = matterTransaction

            '    ret = cmd.ExecuteNonQuery()
            'End Using

            'If returnParam.Value = 0 Then
            '    TaskTypeId = DataHelper.FieldLookupIDs("tblTaskType", "TaskTypeId", "[Name] = " & "'Client Approval'")(0)
            '    Dim DueDate As String = DataHelper.FieldLookup("tblSettlements", "SettlementDueDate", "SettlementId = " & settlementId)
            '    returnValue = SettlementMatterHelper.InsertTaskForSettlement(outputParam.Value, UserID, creditorAcctId, TaskTypeId, "Client Approval", CDate(DueDate), connection, matterTransaction)
            'End If


            '*** Delete this part when cancellations roll out
            Using cmd As IDbCommand = connection.CreateCommand()
                cmd.CommandText = "stp_CreateMatterForSettlement"
                cmd.CommandType = CommandType.StoredProcedure
                DatabaseHelper.AddParameter(cmd, "ClientId", clientId)
                DatabaseHelper.AddParameter(cmd, "SettlementId", settlementId)
                DatabaseHelper.AddParameter(cmd, "CreditorAcctId", creditorAcctId)
                DatabaseHelper.AddParameter(cmd, "MatterStatusCodeId", 23)
                DatabaseHelper.AddParameter(cmd, "CreatedBy", UserID)
                DatabaseHelper.AddParameter(cmd, "MatterTypeId", 3)
                DatabaseHelper.AddParameter(cmd, "MatterStatusId", 3)
                DatabaseHelper.AddParameter(cmd, "MatterMemo", "Generating a matter for the settlement")
                DatabaseHelper.AddParameter(cmd, "MatterSubStatusId", 51)
                returnParam = DatabaseHelper.CreateAndAddParamater(cmd, "Return", DbType.Int32)
                returnParam.Direction = ParameterDirection.ReturnValue
                cmd.Transaction = matterTransaction

                ret = cmd.ExecuteNonQuery()
            End Using

            If returnParam.Value = 0 Then
                TaskTypeId = DataHelper.FieldLookupIDs("tblTaskType", "TaskTypeId", "[Name] = " & "'Client Approval'")(0)
                returnValue = SettlementMatterHelper.InsertTaskForSettlement(settlementId, UserID, TaskTypeId, "Client Approval", connection, matterTransaction)
            End If

            '*** Delete this part when cancellations roll out

            If returnParam.Value = 0 And returnValue = 0 Then
                matterTransaction.Commit()
            Else
                matterTransaction.Rollback()
            End If

            connection.Close()
        End Using

        Dim dlist As New List(Of String)
        Dim cEmail As String = SqlHelper.ExecuteScalar(String.Format("select top 1 [emailaddress]=isnull(emailaddress,'NONE') from tblClient c join tblperson p on p.personid = c.primarypersonid where c.clientid = {0}", clientId), CommandType.Text)
        Dim bEsp As Boolean = SqlHelper.ExecuteScalar(String.Format("select top 1 [bSpanish] = case when languageid > 1 then 1 else 0 end from tblClient c join tblperson p on p.personid = c.primarypersonid where c.clientid = {0}", clientId), CommandType.Text)
        If cEmail.ToString.ToLower <> "none" AndAlso cEmail.ToString.ToLower <> "" AndAlso EmailAddressCheck(cEmail) = True Then

            dlist.Add("Settlement Acceptance Form")

            'holds returned documents to process
            Dim docList As New List(Of LetterTemplates.BatchTemplate)

            Dim rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
            Dim report As New GrapeCity.ActiveReports.SectionReport
            Dim pdf As New PdfExport()
            Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing

            Dim filePath As String = ""
            Dim tempName As String
            Dim strDocTypeName As String = "SettlementAcceptanceForm"
            Dim strDocID As String = rptTemplates.GetDocTypeID(strDocTypeName)
            Dim rootDir = SharedFunctions.DocumentAttachment.CreateDirForClient(clientId)
            strCredName = AccountHelper.GetCreditorName(creditorAcctId)

            tempName = strCredName
            tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
            filePath = GetUniqueDocumentName2(rootDir, clientId, strDocID, UserID, String.Format("CreditorDocs\{0}_{1}\", creditorAcctId, tempName))

            If Directory.Exists(String.Format("{0}CreditorDocs\{1}_{2}\", rootDir, creditorAcctId, tempName)) = False Then
                Directory.CreateDirectory(String.Format("{0}CreditorDocs\{1}_{2}\", rootDir, creditorAcctId, tempName))
            End If

            Dim rArgs As String = "SettlementAcceptanceForm," & settlementId
            Dim args As String() = rArgs.Split(",")

            'rptDoc = rptTemplates.ViewTemplate("SettlementAcceptanceFormV2", clientId, args, False, UserID)
            docList.AddRange(rptTemplates.Generate_LexxSign_SAF(settlementId, UserID, Path.GetFileNameWithoutExtension(filePath)(2)))

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
                Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.html", documentId)
                Using finalHTML As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                    finalHTML.OutputType = GrapeCity.ActiveReports.Export.Html.HtmlOutputType.DynamicHtml
                    finalHTML.IncludeHtmlHeader = False
                    finalHTML.IncludePageMargins = False
                    finalHTML.Export(doc.TemplateRpt.Document, path)
                End Using

                'need matching pdf for final signing process
                If Not doc.NeedSignature Then
                    path = ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.pdf", documentId)
                    Using finalPDF As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                        finalPDF.Export(doc.TemplateRpt.Document, path)
                    End Using
                End If

                'save document to db
                Dim docTid As String = rptTemplates.GetDocTypeID("SettlementAcceptanceForm")
                LexxSignHelper.NonCID.SaveLexxSignDocument(clientId, documentId, UserID, docTid, signingBatchId, cEmail, 21, settlementId)
                dNames.Add(doc.TemplateName)
            Next

            Dim needsign = From doc As LetterTemplates.BatchTemplate In docList Where doc.TemplateName.StartsWith("Signing") Select doc
            For Each doc As LetterTemplates.BatchTemplate In needsign
                Dim templateName As String = doc.TemplateName.Replace("Signing_", "")
                If docIDs.Contains(templateName) Then
                    Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.pdf", docIDs(templateName))
                    Using finalPDF As New GrapeCity.ActiveReports.Export.Pdf.Section.PdfExport
                        finalPDF.Export(doc.TemplateRpt.Document, path.Replace(".html", ".pdf"))
                    End Using
                End If
            Next

            'send notification to client
            LexxSignHelper.NonCID.SendLexxSignNotification(cEmail, dlist.ToArray, signingBatchId, UserID)
        End If

        'add settlement alert
        Dim myParams As New List(Of SqlParameter)
        myParams.Add(New SqlParameter("Clientid", clientId))
        myParams.Add(New SqlParameter("AlertDescription", String.Format("Pending settlement for {0} in the amount of {1}, waiting on clients approval.", strCredName, settAMount)))
        myParams.Add(New SqlParameter("AlertRelationID", settlementId))
        myParams.Add(New SqlParameter("userid", UserID))
        SqlHelper.ExecuteNonQuery("stp_LexxCMS_alert_InsertNew", CommandType.StoredProcedure, myParams.ToArray)


        Return returnParam.Value
    End Function
    Function EmailAddressCheck(ByVal emailAddress As String) As Boolean

        Dim pattern As String = "^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
        Dim emailAddressMatch As Match = Regex.Match(emailAddress, pattern)
        If emailAddressMatch.Success Then
            EmailAddressCheck = True
        Else
            EmailAddressCheck = False
        End If

    End Function
    Sub PageDropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        ' Retrieve the pager row.
        Dim pagerRow As GridViewRow = gvClients.BottomPagerRow

        ' Retrieve the PageDropDownList DropDownList from the bottom pager row.
        Dim pageList As DropDownList = CType(pagerRow.Cells(0).FindControl("ddlPage"), DropDownList)

        ' Set the PageIndex property to display that page selected by the user.
        gvClients.PageIndex = pageList.SelectedIndex
    End Sub

    Private Sub ShowDisplay(ByVal bShow As ShowGUI_Enum)
        'fldQueue.Visible = True
        divClientSearch.Visible = True

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

    Sub lnkReset_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkClear.Click
        txtSearch.Text = ""
        dsSearch.SelectParameters("UserID").DefaultValue = UserID
        dsSearch.SelectParameters("searchTerm").DefaultValue = "%"
        dsSearch.DataBind()
        gvClients.DataBind()
    End Sub

    Sub lnkSearch_Click(ByVal sender As Object, ByVal e As EventArgs) Handles lnkSearch.click
        Dim lnk As LinkButton = TryCast(sender, LinkButton)
        Dim gRow As GridViewRow = TryCast(lnk.NamingContainer, GridViewRow)
        dsSearch.SelectParameters("UserID").DefaultValue = UserID
        dsSearch.SelectParameters("searchTerm").DefaultValue = String.Format("%{0}%", txtSearch.Text)
        dsSearch.DataBind()
    End Sub

    #End Region 'Methods

End Class