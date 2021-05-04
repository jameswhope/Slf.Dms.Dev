Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.IO
Imports System.Linq
Imports System.Runtime.Serialization.Json

Imports AttachSifHelper

Imports GrapeCity.ActiveReports.Export.Pdf

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports LexxiomBarcodeHelper

Imports LexxiomLetterTemplates

Imports iTextSharp.text
Imports iTextSharp.text.pdf

Partial Class negotiation_attach_AttachGrid
    Inherits System.Web.UI.Page
    Implements System.Web.UI.ICallbackEventHandler

    #Region "Fields"

    Private _LastRow As Integer
    Private _UserID As Integer

    #End Region 'Fields

    #Region "Events"

    Public Event SIFAttached As EventHandler

    #End Region 'Events

    #Region "Properties"

    ''' <summary>
    ''' holds list of items to attach to client/creditor acct
    ''' </summary>
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

    Public Property LastRow() As Integer
        Get
            If IsNothing(_LastRow) Then
                _LastRow = 0
            End If
            Return _LastRow
        End Get
        Set(ByVal value As Integer)
            If value > 0 Then
                _LastRow = value
            Else
                _LastRow = 0
            End If
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
            Return _UserID
        End Get
        Set(ByVal value As Integer)
            _UserID = value
        End Set
    End Property

    #End Region 'Properties

    #Region "Methods"

    Public Shared Function CreateNewDocumentName(ByVal ClientID As Integer, ByVal documentTypeID As String, ByVal CreditorAccountID As Integer, ByVal CreditorID As Integer, ByVal ClientAccountNumber As String, ByVal creditorDIR As String) As String
        Dim tempName As New StringBuilder
        Dim tempPath As String
        Dim rootDIR As String = "e:\clientstorage\" 'SharedFunctions.DocumentAttachment.CreateDirForClient(ClientID)
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

    Public Shared Function CreateNewDocumentPathAndName(ByVal rootDir As String, ByVal ClientID As Integer, ByVal strDocTypeID As String, Optional ByVal subFolder As String = "ClientDocs\") As String
        Dim ssql As String = String.Format("SELECT AccountNumber FROM tblClient WHERE ClientID = {0}", ClientID.ToString)
        Dim acctNum As String = SqlHelper.ExecuteScalar(ssql, CommandType.Text)

        Dim ret As String
        ret = rootDir + subFolder + acctNum + "_" + strDocTypeID + "_" + ReportsHelper.GetNewDocID() + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        Return ret
    End Function

    <System.Web.Services.WebMethodAttribute()>
    Public Shared Function PM_getLikeAccounts(ByVal settID As String, ByVal credID As String, ByVal chkID As String) As String
        Dim ap As New acctPickerObj

        Dim sbTbl As New StringBuilder
        Dim dcID As String = SqlHelper.ExecuteScalar(String.Format("select clientid from tblsettlements where settlementid = {0}", settID), CommandType.Text)
        Dim sqlAccts As New StringBuilder
        sqlAccts.AppendFormat("stp_LexxCMS_creditors_getAllByClientID {0}", dcID)

        Using dt As DataTable = SqlHelper.GetDataTable(sqlAccts.ToString, CommandType.Text)
            If dt.Rows.Count > 0 Then
                Dim cols As String() = "creditorinstanceid,CurrentName,OriginalName,accountnumber,referencenumber,CurrentBalance".Split(New Char() {","}, StringSplitOptions.RemoveEmptyEntries)
                Dim SB As New StringBuilder()
                Dim SW As New StringWriter(SB)
                Dim htmlTW As New HtmlTextWriter(SW)
                sbTbl.Append("<div class=""tableContainer""><table class=""entry"" cellpadding=""0"" cellspacing=""0"">")
                sbTbl.Append("<thead><tr style=""background-color: #DCDCDC;border-bottom: solid 1px #d3d3d3; font-weight:normal;color:Black; font-size:11px; font-family:tahoma;height:30px;"">")
                sbTbl.Append("<th class=""headitem5"">&nbsp;</th>")
                For Each dc As DataColumn In dt.Columns

                    Select Case dc.ColumnName.ToLower
                        Case "creditorinstanceid".ToLower

                        Case "CurrentName".ToLower
                            sbTbl.Append("<th class=""headitem5"">Current Creditor</th>")
                        Case "OriginalName".ToLower
                            sbTbl.Append("<th>Original Creditor</th>")
                        Case "accountnumber".ToLower
                            sbTbl.Append("<th>Acct #</th>")
                        Case "referencenumber".ToLower
                            sbTbl.Append("<th>Ref #</th>")
                        Case "CurrentBalance".ToLower
                            sbTbl.Append("<th style=""text-align:right;"">Bal $</th>")
                    End Select
                Next
                sbTbl.Append("</tr></thead><tbody>")
                For Each Row As DataRow In dt.Rows
                    sbTbl.Append("<tr style=""cursor:pointer;border-bottom: solid 1px #d3d3d3; "" onmouseover=""this.style.cursor='pointer';this.style.backgroundColor='#C6DEF2'"" onmouseout=""this.style.cursor='default';this.style.backgroundColor=''"" >")
                    Dim bSelected As String = ""
                    If credID = Row("accountid").ToString Then
                        bSelected = "CHECKED"
                    End If
                    sbTbl.AppendFormat("<td class=""headitem5""><input type=""radio"" name=""acctPicker"" value=""{0}"" {1} /></td>", Row("creditorinstanceid").ToString, bSelected)
                    For Each dc As DataColumn In dt.Columns

                        Select Case dc.ColumnName.ToLower
                            Case "creditorinstanceid".ToLower

                            Case "CurrentName".ToLower, "OriginalName".ToLower, "accountnumber".ToLower, "referencenumber".ToLower
                                sbTbl.AppendFormat("<td>{0}</td>", Row(dc).ToString)
                            Case "CurrentBalance".ToLower
                                sbTbl.AppendFormat("<td align=""right"">{0}</td>", FormatCurrency(Row(dc).ToString, 2))

                        End Select
                    Next
                    sbTbl.Append("</tr>")
                Next
                sbTbl.Append("</tbody></table></div>")
            Else
                sbTbl.Append("<table><tr><td>No Accounts Match</td></tr></table>")
            End If

        End Using

        ap.tableData = sbTbl.ToString
        ap.CheckboxID = chkID

        Return jsonHelper.SerializeObjectIntoJson(ap)
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

    Public Sub showMsg(ByVal msgText As String, ByVal msgType As String)
        divMsg.Style("display") = "block"
        divMsg.Attributes("class") = msgType
        phMsg.Controls.Add(New LiteralControl(msgText))
    End Sub

    Protected Sub btnAttachManual_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAttachManual.Click
        Try

            LastRow = gvClients.SelectedRow.RowIndex
            divMsg.Style("display") = "none"
            'do we need to process attachment
            'before moving to next row
            If Not IsNothing(SelectedSettlement) AndAlso Not IsNothing(SelectedSettlement.SettlementDocuments) Then
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

                    If String.IsNullOrEmpty(SelectedSettlement.SettlementMatterID) Then
                        showMsg("This settlement needs a Matter ID.  Contact IT to resolve!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", "error")
                        Exit Sub
                    End If

                    AttachSifToClient(SelectedSettlement)
                    showMsg(String.Format("SIF Attached for {0}!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", SelectedSettlement.SettlementClientName), "success")

                    LastRow -= 1

                    dsSearch.DataBind()
                    gvClients.DataBind()

                    hdnFile.Value = ""
                    AttachmentFilePath = ""
                    SelectedSettlement = New _AttachSettlementInfo
                    ShowDisplay(ShowGUI_Enum.ResetGUI)
                    fldSifDetail.Style("display") = "none"
                    lblNoSelect.Style("display") = "block"

                    ResetSifDetailInfo()
                Else
                    showMsg(String.Format("There are no documents attached for {0}!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", SelectedSettlement.SettlementClientName), "error")
                End If
            Else
                showMsg("No Client Selected!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", "error")
            End If
            'SelectedSettlement = Nothing
        Catch ex As Exception
            showMsg(String.Format("Error Attaching SIF:<br>{0}", ex.Message), "error")
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

            'Using uploadPDF As New FileUpload.'System.IO.MemoryStream()(YourFileUpload.PostedFile.InputStream)

            'AzureStorageHelper.ExportSIFUpload(filSif.PostedFile.InputStream, filSif.PostedFile.FileName)
            'sFileName.Append("https://lexxwarestore1.blob.core.windows.net/doctestfolder/sifupload/" + filSif.PostedFile.FileName)
            'End Using

            filSif.PostedFile.InputStream.Close()
                filSif.PostedFile.InputStream.Dispose()

                hdnFile.Value = sFileName.ToString
                AttachmentFilePath = hdnFile.Value
                Try
                    phSIFs.Controls.Clear()
                    phSIFs.Controls.Add(ProcessAttachment(AttachmentFilePath))
                    ShowDisplay(ShowGUI_Enum.ShowUploadSuccess)
                    script = "SIF uploaded."
                    divUploadError.Style("display") = "none"
                    divUploadError.Attributes.Add("class", "")
                    ReloadDDls()
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

    Protected Sub dsSearch_Selected(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles dsSearch.Selected
        Try
            gvClients.SelectedIndex = LastRow - 1
        Catch ex As Exception
            gvClients.SelectedIndex = 0
        End Try
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

    Protected Sub gvClients_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvClients.RowCommand
        Select Case e.CommandName.ToLower
            Case "select".ToLower
                divMsg.Style("display") = "none"
                divUploadError.Style("display") = "none"
                divUploadError.Attributes.Add("class", "")
                LastRow = e.CommandArgument
                Dim dk As DataKey = gvClients.DataKeys(e.CommandArgument)
                Dim settid As String = dk(0)
                SelectedSettlement = AttachSifHelper.GetSettlementInfo(settid)
                ResetSifDetailInfo()

                'load sett info
                Dim ssql As String = String.Format("stp_Negotiations_Get_AttachSIFData {0}", settid)
                Using dt As DataTable = SqlHelper.GetDataTable(ssql, Data.CommandType.Text)
                    Dim irow As Integer = 1
                    For Each row As DataRow In dt.Rows

                        lblClientName.Text = String.Format("{0} - ", row("ClientAccountNumber").ToString)
                        lblClientName.Text += String.Format("{0}<br>", IIf(row("co client name").ToString = "", row("client name").ToString, String.Format("{0}, {1}", row("client name").ToString, row("co client name").ToString)))
                        lblClientName.Text += String.Format("{0} #{1}", row("creditor name").ToString, row("CreditorAccountNumber").ToString)

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
                        ReloadDDls()
                        irow += 1
                    Next
                End Using
                chkOverride.Attributes.Add("onclick", String.Format("return showPopup(this,'{0}','{1}')", SelectedSettlement.SettlementID, SelectedSettlement.SettlementCreditorAccountID))
                fldSifDetail.Style("display") = "inline-block"
                lblNoSelect.Style("display") = "none"

        End Select
    End Sub

    Protected Sub gvClients_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvClients.RowCreated
        Select Case e.Row.RowType
            Case DataControlRowType.Header
                GridViewHelper.AddSortImage(sender, e)
        End Select
    End Sub

    Protected Sub gvClients_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvClients.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Attributes.Add("onclick", Page.ClientScript.GetPostBackEventReference(sender, "Select$" + e.Row.RowIndex.ToString))
                e.Row.Style("cursor") = "hand"
                If CDate(DataBinder.Eval(e.Row.DataItem, "SettlementDueDate")) < Now Then
                    e.Row.ForeColor = System.Drawing.Color.Red
                Else
                    e.Row.ForeColor = System.Drawing.Color.Black
                End If
        End Select
    End Sub

    Protected Sub gvClients_SelectedIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSelectEventArgs) Handles gvClients.SelectedIndexChanging
        e.NewSelectedIndex = LastRow
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

    Protected Sub lnkClearSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkClearSearch.Click
        dsSearch.FilterExpression = Nothing

        dsSearch.DataBind()
        gvClients.DataBind()
    End Sub

    Protected Sub lnkSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSearch.Click
        dsSearch.FilterExpression = String.Format("[Client Name] like '%{0}%' or convert(ClientAccountNumber, 'System.String')  like '{0}%' or [Creditor Name] like '%{0}%'", txtsearch.Text)
        dsSearch.DataBind()
        gvClients.DataBind()
    End Sub

    Private Sub ReloadDDls()
        Dim ph As PlaceHolder = TryCast(pnlSIFDocs.FindControl("phSifs"), PlaceHolder)
        Dim ddls As List(Of DropDownList) = FindDocumentTypeDDLs(ph)
        If SelectedSettlement.IsClientStipulation Then
            Dim innerTxt As String = "<div style=""display:inline-block;background-color:#ffcccc;color:red;font-weight:bold;width:100%;" & _
                                    "text-align:center;border:solid 1px #8B1A1A; height:20px;vertical-align:middle;"">CLIENT STIPULATION IS REQUIRED!</div>"
            dvSettlementMsg.InnerHtml = innerTxt
            For Each ddl As DropDownList In ddls
                ddl.SelectedIndex = 1
                ddl.Items(0).Enabled = False
                ddl.Items(1).Enabled = True
            Next
        Else
            dvSettlementMsg.InnerHtml = ""
            For Each ddl As DropDownList In ddls
                ddl.SelectedIndex = 0
                ddl.Items(0).Enabled = True
                ddl.Items(1).Enabled = False
            Next
        End If
    End Sub

    Protected Sub negotiation_attach_AttachGrid_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)

        If Not IsPostBack Then
            hdnZoom.Value = 100
            AttachmentFilePath = ""
            SelectedSettlement = New _AttachSettlementInfo
            ShowDisplay(ShowGUI_Enum.ResetGUI)
            BindData()
        End If
        If AttachmentFilePath.ToString <> "" Then
            phSIFs.Controls.Clear()
            phSIFs.Controls.Add(ProcessAttachment(AttachmentFilePath))
            ReloadDDls()
        End If

        BuildCallbackString()
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
                'get new pdf doc name ---- document name change here -----
                pdfFilePath = CreateNewDocumentName(attach.SettlementClientID, docObj.Key, attach.SettlementCreditorAccountID, attach.SettlementCreditorID, attach.SettlementClientSDAAccountNumber, strCredFolder)
                newDocList.Add(New SettlementDocumentObject(docObj.Key, pdfFilePath))

                writer = PdfWriter.GetInstance(document, New FileStream(pdfFilePath, FileMode.Create))
                document.Open()
                cb = writer.DirectContent
                For Each pageObj As String In TryCast(docObj.Value, List(Of String))
                    If pageObj.StartsWith("http:") Then
                        pageObj = HttpContext.Current.Server.MapPath(pageObj.Replace(LocalHelper.GetVirtualBasePath(), ""))
                    End If
                    Using img As System.Drawing.Image = ResizeImage(System.Drawing.Image.FromFile(pageObj.Replace("%20", " ").Replace("/", "\").Replace("file:", "")), 800, 1000, Imaging.ImageFormat.Jpeg)
                        Dim textImg As iTextSharp.text.Image = iTextSharp.text.Image.GetInstance(img, Imaging.ImageFormat.Jpeg)
                        textImg.ScalePercent(70.0F)
                        textImg.SetAbsolutePosition(20, 50)
                        cb.AddImage(textImg)

                        'append doc info barcode
                        Dim barcodeString As New StringBuilder
                        Dim dID As String() = Path.GetFileNameWithoutExtension(pdfFilePath).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
                        barcodeString.AppendFormat("*{0}:{1}*", attach.SettlementClientSDAAccountNumber, dID(2).ToString)  'account 600#:docid

                        Using bcImg As System.Drawing.Image = Drawing.Image.FromStream(buildbarcodeImage(barcodeString.ToString, barcodeOrientation.enumVertical))
                            Dim barImg As iTextSharp.text.Image = iTextSharp.text.Image.GetInstance(bcImg, Imaging.ImageFormat.Png)
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

    Private Shared Function CreateSAFFilePath(ByVal clientId As Integer, ByVal creditorAcctId As Integer) As String
        Dim filePath As String = ""
        Dim tempName As String
        Dim strDocTypeName As String = "SettlementAcceptanceForm"
        Dim strDocID As String = "D6004"
        Dim rootDir = SharedFunctions.DocumentAttachment.CreateDirForClient(clientId)
        Dim strCredName As String = AccountHelper.GetCreditorName(creditorAcctId)

        tempName = strCredName
        tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
        filePath = CreateNewDocumentPathAndName(rootDir, clientId, strDocID, String.Format("CreditorDocs\{0}_{1}\", creditorAcctId, tempName))

        If Directory.Exists(String.Format("{0}CreditorDocs\{1}_{2}\", rootDir, creditorAcctId, tempName)) = False Then
            Directory.CreateDirectory(String.Format("{0}CreditorDocs\{1}_{2}\", rootDir, creditorAcctId, tempName))
        End If
        Return filePath
    End Function

    Private Shared Function IsValidImageFile(ByVal file As FileUpload) As Boolean
        Try
            Using bmp As New Bitmap(file.PostedFile.InputStream)
                Return True
            End Using
        Catch generatedExceptionName As ArgumentException
            'throws exception if not valid image
        End Try

        Return False
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
            SharedFunctions.DocumentAttachment.AttachDocument("matter", attach.SettlementMatterID, Path.GetFileName(pdfFilePath.DocumentPath), strUserID, credFolderPath)
            SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(pdfFilePath.DocumentPath), strUserID, Now)
            NegotiationRoadmapHelper.InsertRoadmap(attach.SettlementID, 8, String.Format("{0} Received", pdfFilePath.DocumentType), strUserID)
        Next
    End Sub

    Private Function EmailSIFStipulation(ByVal Settlement As _AttachSettlementInfo, ByVal EmailTo As String, ByVal pdfFiles As List(Of SettlementDocumentObject)) As Boolean
        'Created Adjustments
        Dim stipFiles = (From doc As SettlementDocumentObject In pdfFiles _
                       Where doc.DocumentType = "D9012" _
                       Select doc.DocumentPath).ToList
        If stipFiles.Count > 0 Then
            'Create and send Email
            EmailTo = "opereira@lexxiom.com"
            SettlementMatterHelper.EmailStipulationLetter(Settlement.SettlementClientID, EmailTo.Trim, stipFiles)
            'Log Letter Sent
            SettlementMatterHelper.InsertStipulationLog(Settlement.SettlementID, stipFiles(0), "email", EmailTo, UserID)
        End If
    End Function

    Private Function AttachSifToClient(ByVal attach As _AttachSettlementInfo) As Control
        Dim sifList As New List(Of AttachSIFResult)
        Dim sb As New StringBuilder
        Dim resultMsg As String = ""
        'create doc
        Dim pdfFilePaths As List(Of SettlementDocumentObject) = CreateDocs(attach, UserID)

        If Not attach.SettlementMatterID = "" Then

            'resolve step
            SettlementMatterHelper.ResolveAttachDocumentTask(attach.SettlementID, _UserID, pdfFilePaths)

            'attach doc
            AttachDoc(attach, pdfFilePaths)

            '*** Uncomment when we roll out the Processing Interface
            '*** Why are we doing this here? Move this into the Accept SIF app
            'SettlementProcessingHelper.InsertSettlement(attach.SettlementID)

            sifList.Add(New AttachSIFResult() With {.ClientName = attach.SettlementClientName, _
                                             .CreditorName = Drg.Util.DataHelpers.AccountHelper.GetCurrentCreditorName(attach.SettlementCreditorAccountID), _
                                             .DocumentsAttachedCount = attach.SettlementDocuments.Count, _
                                             .SIFPath = "", .SpecialInstructions = attach.SpecialInstructions, _
                                             .SAFPath = ""})

            Dim specIntructions As String = attach.SpecialInstructions
            Dim settID As String = attach.SettlementID
            AttachSifHelper.SaveSpecialInstructions(settID, specIntructions, UserID)

            If Not String.IsNullOrEmpty(attach.PayableTo) Then
                AttachSifHelper.UpdateSettlementPayTo(attach.SettlementID, attach.PayableTo, UserID)
            End If


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

            Dim cEmail As String = SqlHelper.ExecuteScalar(String.Format("select top 1 [emailaddress]=isnull(emailaddress,'NONE') from tblClient c join tblperson p on p.personid = c.primarypersonid where c.clientid = {0}", attach.SettlementClientID), CommandType.Text)
            Dim bEsp As Boolean = SqlHelper.ExecuteScalar(String.Format("select top 1 [bSpanish] = case when languageid > 1 then 1 else 0 end from tblClient c join tblperson p on p.personid = c.primarypersonid where c.clientid = {0}", attach.SettlementClientID), CommandType.Text)
            Dim bESign As Boolean = SqlHelper.ExecuteScalar(String.Format("select UseESign from tblClient c where c.clientid = {0}", attach.SettlementClientID), CommandType.Text)
            If cEmail.ToString.ToLower <> "none" AndAlso cEmail.ToString.ToLower <> "" And bESign Then
                If EmailAddressCheck(cEmail) Then
                    cEmail = "opereira@lexxiom.com"
                    SendLexxSignSAF(attach.SettlementClientID, attach.SettlementID, attach.SettlementCreditorAccountID, cEmail)
                    If attach.IsClientStipulation Then
                        EmailSIFStipulation(attach, cEmail, pdfFilePaths)
                    End If
                End If
            End If
            resultMsg = "SIF Attached!"
        Else
            resultMsg = "Settlement needs a Matter, contact IT Dept.!"
        End If
        Dim lt As New LiteralControl("SIF Attached!")
        Return lt
    End Function

    Private Sub BindData()
        dsSearch.SelectParameters("UserID").DefaultValue = UserID
        dsSearch.SelectParameters("searchTerm").DefaultValue = "%"
        dsSearch.DataBind()
    End Sub

    Private Sub BuildCallbackString()
        Dim cm As ClientScriptManager = Page.ClientScript
        Dim cbReference As String
        cbReference = cm.GetCallbackEventReference(Me, "arg", "ReceiveServerData", "")
        Dim callbackScript As String = ""
        callbackScript &= "function CallServer(arg, context)" & "{" & cbReference & "; }"
        cm.RegisterClientScriptBlock(Me.GetType(), "CallServer", callbackScript, True)

        Dim sm As ScriptManager = ScriptManager.GetCurrent(Me)
        sm.RegisterPostBackControl(btnUpload)
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

    Function EmailAddressCheck(ByVal emailAddress As String) As Boolean
        Dim pattern As String = "^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
        Dim emailAddressMatch As Match = Regex.Match(emailAddress, pattern)
        If emailAddressMatch.Success Then
            EmailAddressCheck = True
        Else
            EmailAddressCheck = False
        End If
    End Function

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

    Sub PageDropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        ' Retrieve the pager row.
        Dim pagerRow As GridViewRow = gvClients.BottomPagerRow

        ' Retrieve the PageDropDownList DropDownList from the bottom pager row.
        Dim pageList As DropDownList = CType(pagerRow.Cells(0).FindControl("ddlPage"), DropDownList)

        ' Set the PageIndex property to display that page selected by the user.
        gvClients.PageIndex = pageList.SelectedIndex
    End Sub

    Private Sub ResetSifDetailInfo()
        SettlementAmountTextBox.Text = ""
        SettlementDueDateTextBox.Text = ""
        CheckPayableTextBox.Text = ""
        CreditorAccountNumberFullTextBox.Text = ""
        CreditorReferenceNumberTextBox.Text = ""
        CreditorAccountBalanceTextBox.Text = ""
        SpecialInstructionsTextBox.Text = ""
        'PaymentDateTextBox.Text = ""
        'PaymentAmtTextBox.Text = ""
    End Sub

    Private Sub SendLexxSignSAF(ByVal clientId As Integer, ByVal settlementId As Integer, ByVal creditorAcctId As Integer, ByVal cEmail As String)
        Dim dlist As New List(Of String)
        dlist.Add("Settlement Acceptance Form")

        Dim docList As New List(Of LetterTemplates.BatchTemplate)   'holds returned documents to process
        Dim rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
        Dim report As New GrapeCity.ActiveReports.SectionReport
        Dim rptDoc As GrapeCity.ActiveReports.Document.SectionDocument = Nothing
        Dim filePath As String = CreateSAFFilePath(clientId, creditorAcctId)

        Dim rArgs As String = "SettlementAcceptanceForm," & settlementId
        Dim args As String() = rArgs.Split(",")

        'rptDoc = rptTemplates.ViewTemplate("SettlementAcceptanceFormV2", clientId, args, False, UserID)
        docList.AddRange(rptTemplates.Generate_LexxSign_SAF(settlementId, UserID, Path.GetFileNameWithoutExtension(filePath).Split("_")(2)))

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
            Using finalHTML As New GrapeCity.ActiveReports.Export.Html.Section.HtmlExport
                finalHTML.OutputType = GrapeCity.ActiveReports.Export.Html.Section.HtmlOutputType.DynamicHtml
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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Response.Redirect("~/negotiation/waitingSif.aspx")
    End Sub

#End Region 'Methods

End Class