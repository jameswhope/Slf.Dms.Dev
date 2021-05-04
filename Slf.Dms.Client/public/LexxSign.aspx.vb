Imports System.Collections.Generic
Imports System.Data
Imports System.IO
Imports System.Runtime.InteropServices
Imports System.Runtime.Serialization.Json
Imports System.Web.Services
Imports System.Windows.Forms

Imports LexxSignHelper
Imports LexxSignHelper.NonCID

Imports LexxiomLetterTemplates

Imports iTextSharp
Imports iTextSharp.text
Imports iTextSharp.text.Image
Imports iTextSharp.text.pdf
Imports System.Data.SqlClient

Partial Class LexxSign
    Inherits System.Web.UI.Page
    Public bHideInits As Boolean = True
#Region "Fields"

    Private _CodebtorInitImgPath As String
    Private _CodebtorSigImgPath As String
    Private _DebtorInitImgPath As String
    Private _DebtorSigImgPath As String
    Private _DocumentID As String
    Private _DocumentInfo As SignedDocumentInfo
    Private _SigCountInDoc As Integer
    Private _SigningBatchID As String
    Private _bHasCoApplicant As Boolean
    Private _doclist As Dictionary(Of String, List(Of System.Web.UI.Control))
    Private _formHTML As String
    Private _hFiles As Dictionary(Of String, String)
    Private _SigningType As String
#End Region 'Fields

#Region "Properties"

    Public Property CodebtorInitImgPath() As String
        Get
            Return _CodebtorInitImgPath
        End Get
        Set(ByVal value As String)
            _CodebtorInitImgPath = value
        End Set
    End Property

    Public Property CodebtorSigImgPath() As String
        Get
            Return _CodebtorSigImgPath
        End Get
        Set(ByVal value As String)
            _CodebtorSigImgPath = value
        End Set
    End Property

    Public Property CurrentDoc() As Integer
        Get
            Return Session("_CurrentDoc")
        End Get
        Set(ByVal value As Integer)
            Session("_CurrentDoc") = value
        End Set
    End Property

    Public Property CurrentPage() As Integer
        Get
            Return Session("_CurrentPage")
        End Get
        Set(ByVal value As Integer)
            Session("_CurrentPage") = value
        End Set
    End Property

    Public Property DebtorInitImgPath() As String
        Get
            Return _DebtorInitImgPath
        End Get
        Set(ByVal value As String)
            _DebtorInitImgPath = value
        End Set
    End Property

    Public Property DebtorSigImgPath() As String
        Get
            Return _DebtorSigImgPath
        End Get
        Set(ByVal value As String)
            _DebtorSigImgPath = value
        End Set
    End Property

    Public Property DocList() As Dictionary(Of String, List(Of System.Web.UI.Control))
        Get
            Return Session("_doclist")
        End Get
        Set(ByVal value As Dictionary(Of String, List(Of System.Web.UI.Control)))
            Session("_doclist") = value
        End Set
    End Property

    Public Property HFiles() As ArrayList 'Dictionary(Of String, String)
        Get
            Return Session("_hFiles")
        End Get
        Set(ByVal value As ArrayList) 'Dictionary(Of String, String))
            Session("_hFiles") = value
        End Set
    End Property

    Public Property SigningType() As String
        Get
            Return _SigningType
        End Get
        Set(ByVal value As String)
            _SigningType = value
        End Set
    End Property
    Public Property TotalInitialsNeeded() As Integer
        Get
            Return ViewState("_TotalInitialsNeeded")
        End Get
        Set(ByVal value As Integer)
            ViewState("_TotalInitialsNeeded") = value
        End Set
    End Property

    Public Property TotalSignaturesNeeded() As Integer
        Get
            Return ViewState("_TotalSignaturesNeeded")
        End Get
        Set(ByVal value As Integer)
            ViewState("_TotalSignaturesNeeded") = value
        End Set
    End Property

#End Region 'Properties

#Region "Methods"

    <WebMethod()> _
    Public Shared Function PM_ServerFileExists(ByVal filepath As String, ByVal containerID As String, ByVal docNum As Integer, ByVal pageNum As Integer, ByVal sigType As String) As String
        Dim s As New SignatureImage
        s.ImagePath = String.Format("temp/{0}", Path.GetFileName(filepath))
        s.ImageContainerID = containerID
        s.ImageExists = File.Exists(filepath)
        s.ImageDocNumber = docNum
        s.ImagePageNumber = pageNum
        s.SignatureType = sigType

        s.LegalMessage = String.Format("Would you like to apply your {0} to this location?", getSignatureTypeFromString(sigType))
        Return SerializeObjectIntoJson(s)
    End Function

    <WebMethod()> _
    Public Shared Function PM_UpdatePageHTML(ByVal docNum As Integer, ByVal pageNum As Integer, ByVal signatureType As String) As String
        'TryCast(HttpContext.Current.Session("_doclist")(docNum).Item(pageNum), HtmlGenericControl).InnerHtml = pageHTML
        Return Nothing
    End Function

    Public Shared Function getSignatureTypeFromString(ByVal sigTypeString As String) As String
        Dim sigString As String = ""
        If sigTypeString.Contains("S") Then
            Return "signature"
        Else
            Return "initials"
        End If
    End Function

    Public Sub BuildDocumentList(ByVal hFiles As ArrayList, ByVal DebtorSigImgPath As String, ByVal CodebtorSigImgPath As String, ByVal DebtorInitImgPath As String, ByVal CodebtorInitImgPath As String)
        Dim jsArray As New List(Of String)
        Dim iDocCnt As Integer = 0
        Dim iTotalSigs As Integer = 0
        Dim iTotalInits As Integer = 0
        Dim tempdoclist As New Dictionary(Of String, List(Of System.Web.UI.Control))
        'get signatures to apply
        Dim appliedSignatures As Dictionary(Of String, Dictionary(Of String, List(Of String))) = Build_getAppliedSignatures(hdnAppliedSignatures.Value)

        For Each doc As documentRow In hFiles
            Dim lbl As New System.Web.UI.WebControls.Label
            Dim docNode As New System.Web.UI.WebControls.TreeNode(doc.documentName)
            docNode.SelectAction = TreeNodeSelectAction.SelectExpand

            iDocCnt += 1
            'holds pages
            Dim _DocPageList As New List(Of System.Web.UI.Control)
            'holds page html
            Dim newHTML As String
            Using sr As New StreamReader(doc.documentPath)
                newHTML = sr.ReadToEnd()
            End Using

            'strip out unneccesary html
            Dim ifirstdiv As Integer = newHTML.IndexOf("<div")
            _formHTML = newHTML.Substring(ifirstdiv)
            _formHTML = _formHTML.Replace("</body>", "")
            _formHTML = _formHTML.Replace("</html>", "")

            'add runat to page divs
            _formHTML = _formHTML.Replace("<div style=""page-break-inside:avoid;", "<div runat=""server"" onfocus=""this.scrollTop=99999;"" style=""border:solid 1px black;padding:10px;page-break-inside:avoid;height:590px;width:100%;overflow-x: hidden; overflow-y: scroll; position:relative;background-color:white;")
            _formHTML = _formHTML.Replace("height:10.5in;", "")

            'parse pages
            Dim dv As System.Web.UI.Control = Page.ParseControl(_formHTML)
            For Each h As System.Web.UI.Control In dv.Controls

                If TypeOf h Is HtmlGenericControl Then
                    If TryCast(h, HtmlGenericControl).Style("page-break-inside") = "avoid" Then
                        'store page count
                        Dim bSigNeeded As Boolean = False
                        Dim bInitNeeded As Boolean = False
                        Dim ipage As Integer = _DocPageList.Count
                        Dim pageNode As New System.Web.UI.WebControls.TreeNode()
                        pageNode.SelectAction = TreeNodeSelectAction.SelectExpand
                        pageNode.Selected = False

                        'find signature/initital count in html string
                        Dim numAppSigs As Integer = Regex.Matches(TryCast(h, HtmlGenericControl).InnerHtml, "{{_es_[a-zA-Z1._%]+(signature)}}").Count
                        Dim numAppInits As Integer = Regex.Matches(TryCast(h, HtmlGenericControl).InnerHtml, "{{_es_[a-zA-Z1._%]+(initials)+}}").Count
                        Dim numCoappSigs As Integer = 0
                        Dim numCoappInits As Integer = 0
                        If doc.documentName <> "Voided Check" Then
                            numCoappSigs = Regex.Matches(TryCast(h, HtmlGenericControl).InnerHtml, "{{_es_[a-zA-Z2._%]+(signature)}}").Count
                            numCoappInits = Regex.Matches(TryCast(h, HtmlGenericControl).InnerHtml, "{{_es_[a-zA-Z2._%]+(initials)+}}").Count
                        End If

                        iTotalSigs += numAppSigs + numCoappSigs
                        iTotalInits += numAppInits + numCoappInits

                        Dim newH As String = ""
                        Dim hoverSignatureScriptCodes As New StringBuilder

                        'replace sig/init holders with javascript to
                        'navigate and swap with sig/init image
                        Dim actionCode As New StringBuilder
                        Dim strTab As String = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"

                        If numAppSigs > 0 Then
                            Dim replaceDiv As StringBuilder = Build_swapTextWithImage(enumSignaturePerson.debtor, enumSignatureType.signature, DebtorSigImgPath, iDocCnt, appliedSignatures, ipage)
                            newH = Regex.Replace(TryCast(h, HtmlGenericControl).InnerHtml, "{{_es_[a-zA-Z1._%]+(signature)}}", replaceDiv.ToString)
                            TryCast(h, HtmlGenericControl).InnerHtml = newH
                            actionCode.Append(BuildDocumentLinkPath(enumSignaturePerson.debtor, enumSignatureType.signature, iDocCnt, ipage, numAppSigs))
                            bSigNeeded = True
                        End If
                        If numAppInits > 0 Then
                            Dim replaceDiv As StringBuilder = Build_swapTextWithImage(enumSignaturePerson.debtor, enumSignatureType.initials, DebtorInitImgPath, iDocCnt, appliedSignatures, ipage)
                            newH = Regex.Replace(TryCast(h, HtmlGenericControl).InnerHtml, "{{_es_[a-zA-Z1._%]+(initials)}}", replaceDiv.ToString)
                            TryCast(h, HtmlGenericControl).InnerHtml = newH
                            actionCode.Append(BuildDocumentLinkPath(enumSignaturePerson.debtor, enumSignatureType.initials, iDocCnt, ipage, numAppSigs))
                            'bSigNeeded = True
                            bInitNeeded = True
                        End If
                        If numCoappSigs > 0 Then
                            Dim replaceDiv As StringBuilder = Build_swapTextWithImage(enumSignaturePerson.codebtor, enumSignatureType.signature, CodebtorSigImgPath, iDocCnt, appliedSignatures, ipage)
                            newH = Regex.Replace(TryCast(h, HtmlGenericControl).InnerHtml, "{{_es_[a-zA-Z2._%]+(signature)}}", replaceDiv.ToString)
                            TryCast(h, HtmlGenericControl).InnerHtml = newH
                            actionCode.Append(BuildDocumentLinkPath(enumSignaturePerson.codebtor, enumSignatureType.signature, iDocCnt, ipage, numAppSigs))
                            bSigNeeded = True
                        End If
                        If numCoappInits > 0 Then
                            Dim replaceDiv As StringBuilder = Build_swapTextWithImage(enumSignaturePerson.codebtor, enumSignatureType.initials, CodebtorInitImgPath, iDocCnt, appliedSignatures, ipage)
                            newH = Regex.Replace(TryCast(h, HtmlGenericControl).InnerHtml, "{{_es_[a-zA-Z2._%]+(initials)}}", replaceDiv.ToString)
                            TryCast(h, HtmlGenericControl).InnerHtml = newH
                            actionCode.Append(BuildDocumentLinkPath(enumSignaturePerson.codebtor, enumSignatureType.initials, iDocCnt, ipage, numAppSigs))
                            'bSigNeeded = True
                            bInitNeeded = True
                        End If

                        'add page
                        _DocPageList.Add(h)

                        Dim imgPath As String '= "sign-here.png"
                        'check if this sig has been applied already
                        If appliedSignatures.ContainsKey(iDocCnt) Then
                            If appliedSignatures(iDocCnt).ContainsKey(ipage) Then
                                If appliedSignatures(iDocCnt).Item(ipage).Contains("DS1") Then
                                    iTotalSigs -= 1
                                End If
                                If appliedSignatures(iDocCnt).Item(ipage).Contains("DS2") Then
                                    iTotalSigs -= 1
                                End If
                                If appliedSignatures(iDocCnt).Item(ipage).Contains("DI1") Then
                                    iTotalInits -= 1
                                End If
                                If appliedSignatures(iDocCnt).Item(ipage).Contains("DI2") Then
                                    iTotalInits -= 1
                                End If
                            End If
                        End If

                        'build treeview node
                        Dim hoverScriptCodes As New StringBuilder
                        Dim scriptAction As New StringBuilder
                        scriptAction.AppendFormat("onclick=""LoadPage('{0}','{1}');""", iDocCnt, ipage)
                        hoverScriptCodes.Append(scriptAction.ToString)
                        Dim nodeText As New StringBuilder
                        If bSigNeeded Then
                            nodeText.Append("<div style=""padding:2px;"">")
                            nodeText.AppendFormat("<img style=""border:solid 1px transparent""  alt=""page {0}"" height=""50"" width=""50"" src=""images/document_page{0}.png"" />", ipage + 1)
                            'Dim imgPath As String = "sign-here.png"
                            'check if this sig has been applied already
                            imgPath = ""
                            If appliedSignatures.ContainsKey(iDocCnt) Then
                                If appliedSignatures(iDocCnt).ContainsKey(ipage) Then
                                    If appliedSignatures(iDocCnt).Item(ipage).Contains("DS1") Or appliedSignatures(iDocCnt).Item(ipage).Contains("DS2") Then
                                        imgPath = "signed.png"
                                    End If
                                End If
                            Else
                                imgPath = "sign-here.png"
                            End If
                            nodeText.AppendFormat("<img style=""border:solid 1px transparent"" src=""images/{0}"" title=""Signature/Initials needed on this page"" id=""imgSign_{1}_{2}"" />", imgPath, iDocCnt, ipage)
                            nodeText.Append("</div>")

                        ElseIf bInitNeeded Then
                            nodeText.Append("<div style=""padding:2px;"">")
                            nodeText.AppendFormat("<img style=""border:solid 1px transparent""  alt=""page {0}"" height=""50"" width=""50"" src=""images/document_page{0}.png"" />", ipage + 1)
                            'Dim imgPath As String = "sign-here.png"
                            imgPath = ""
                            If appliedSignatures.ContainsKey(iDocCnt) Then
                                If appliedSignatures(iDocCnt).ContainsKey(ipage) Then
                                    If appliedSignatures(iDocCnt).Item(ipage).Contains("DI1") Or appliedSignatures(iDocCnt).Item(ipage).Contains("DI2") Then
                                        imgPath = "signed.png"
                                    End If
                                End If
                            Else
                                imgPath = "sign-here.png"
                            End If
                            nodeText.AppendFormat("<img style=""border:solid 1px transparent"" src=""images/{0}"" title=""Signature/Initials needed on this page"" id=""imgSign_{1}_{2}""/>", imgPath, iDocCnt, ipage)
                            nodeText.Append("</div>")

                        Else
                            nodeText.AppendFormat("<div style=""padding:2px;""><img style=""border:solid 1px transparent;"" alt=""page {0}"" height=""50"" width=""50"" src=""images/document_page{0}.png"" /></div>", ipage + 1)
                        End If

                        pageNode.Text = nodeText.ToString
                        pageNode.Value = ipage + 1

                        docNode.ChildNodes.Add(pageNode)
                    End If
                End If

            Next

            tempdoclist.Add(iDocCnt, _DocPageList)

            docNode.Value = iDocCnt
            If tvDocuments.Nodes.Count <> hFiles.Count Then
                tvDocuments.Nodes.Add(docNode)
            End If
        Next
        DocList = tempdoclist
        TotalSignaturesNeeded = iTotalSigs
        TotalInitialsNeeded = iTotalInits
        hdnSignCount.Value = iTotalSigs
        hdnInitCount.Value = iTotalInits

        divInfo.InnerHtml = String.Format("You need to <a href=""#"" onclick=""jumpToFirst(1);"">sign in {0} location(s)</a> and <a href=""#"" onclick=""jumpToFirst(2);"">initial in {1} location(s)</a>.", iTotalSigs, iTotalInits)
    End Sub

    Public Function GetClientIP() As String
        Dim currentRequest As HttpRequest = HttpContext.Current.Request
        Dim ipAddress As String = currentRequest.ServerVariables("HTTP_X_FORWARDED_FOR")
        If ipAddress = Nothing OrElse ipAddress.ToLower() = "unknown" Then
            ipAddress = currentRequest.ServerVariables("REMOTE_ADDR")
        End If

        Return ipAddress
    End Function
    Protected Sub JSCheck1_EnabledChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles JSCheck1.EnabledChanged
        updateClientJavascriptCheck(JSCheck1.Enabled)
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        _SigningBatchID = Request.QueryString("sbId")
        SigningType = Request.QueryString("t")

        Select Case JSCheck1.Enabled
            Case True
                pageContent.Style("display") = "block"
                pageNoJS.Style("display") = "none"
            Case Else
                pageContent.Style("display") = "none"
                pageNoJS.Style("display") = "block"
        End Select
        updateClientJavascriptCheck(JSCheck1.Enabled)


        DebtorSigImgPath = Server.MapPath(String.Format("temp/{0}.png", _SigningBatchID))
        CodebtorSigImgPath = Server.MapPath(String.Format("temp/{0}c.png", _SigningBatchID))
        DebtorInitImgPath = Server.MapPath(String.Format("temp/{0}i.png", _SigningBatchID))
        CodebtorInitImgPath = Server.MapPath(String.Format("temp/{0}ci.png", _SigningBatchID))

        HFiles = GetDocumentsBySigningBatchID(_SigningBatchID)
        If Not IsNothing(HFiles) Then
            BuildDocumentList(HFiles, DebtorSigImgPath, CodebtorSigImgPath, DebtorInitImgPath, CodebtorInitImgPath)
            If Not IsPostBack Then

                Dim firmName As String = ""
                Dim sqlInfo As New StringBuilder
                sqlInfo.AppendFormat("stp_lexxsign_getFirmName '{0}'", _SigningBatchID)
                Using dt As DataTable = SqlHelper.GetDataTable(sqlInfo.ToString, CommandType.Text)
                    For Each row As DataRow In dt.Rows
                        firmName = row("name").ToString
                        Exit For
                    Next
                End Using
                hTitle.InnerText = firmName

                Dim ldelete As New List(Of String)
                ldelete.Add(DebtorSigImgPath)
                ldelete.Add(CodebtorSigImgPath)
                ldelete.Add(DebtorInitImgPath)
                ldelete.Add(CodebtorInitImgPath)
                Build_DeleteFiles(ldelete)
                LoadPage(1, 0)
            Else

                Dim eventTarget As String = Request("__EVENTTARGET")
                Dim eventArg As String = Request("__EVENTARGUMENT")
                Select Case eventTarget.ToLower
                    Case "ApplySignature".ToLower
                        Dim args As String() = hdnPage.Value.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
                        If args.Length > 1 Then
                            Build_SavePage(args(0), args(1), eventArg)
                            LoadPage(args(0), args(1))
                        End If
                    Case "lnkApply".ToLower
                        Try
                            tvDocuments.SelectedNode.Text = tvDocuments.SelectedNode.Text.Replace("sign-here", "signed")
                        Catch ex As Exception
                            'nothing selected continue

                        End Try

                    Case Else

                        Dim args As String() = eventArg.Split("\")

                        Try
                            LoadPage(Integer.Parse(args(0).Replace("s", "")), Integer.Parse(args(1)) - 1)
                        Catch ex As Exception
                            Try
                                'no values, just load last page
                                LoadPage(CurrentDoc, CurrentPage)
                            Catch lex As Exception
                                LoadPage(1, 0)
                            End Try

                        End Try

                End Select

            End If
        End If

        'divInfo.InnerHtml = String.Format("You need to <b>sign in {0} location(s)</b> and <b>initial in {1} location(s)</b>.", hdnSignCount.Value, hdnInitCount.Value)
    End Sub

    Public Sub updateClientJavascriptCheck(ByVal bEnabled As Boolean)
        LexxSignHelper.NonCID.updateBrowserInfo(_SigningBatchID, Request.Browser.Browser, Request.Browser.Version, bEnabled)
    End Sub
    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        If Not IsPostBack Then
          


        End If

    End Sub

    Protected Sub lnkApply_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkApply.Click
        Dim gp As New HtmlGenericControl("div")
        Dim nv As String() = hdnPage.Value.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
        If nv.Length > 0 Then
            gp.Controls.Add(DocList(nv(0)).Item(nv(1)))
            phContent.Controls.Add(gp)
        End If
    End Sub

    Protected Sub lnkLoadPage_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLoadPage.Click
        Dim args As String() = hdnPage.Value.ToString.Split("|")
        If args.Length > 1 Then
            LoadPage(args(0), args(1))
        End If
    End Sub

    Protected Sub lnkLoad_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkLoad.Click
        Dim gp As New HtmlGenericControl("div")
        Dim nv As String() = hdnPage.Value.Split("|")
        gp.Controls.Add(DocList(nv(0)).Item(nv(1)))
        phContent.Controls.Add(gp)
    End Sub

    Protected Sub lnkSign_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSign.Click
        'get image paths here
        _DocumentInfo = LexxSignHelper.NonCID.getDocumentInfoByID(_SigningBatchID)

        If Integer.Parse(hdnSignCount.Value) = 0 AndAlso Integer.Parse(hdnInitCount.Value) = 0 Then
            Dim signedFiles As New Dictionary(Of String, String)
            For Each hf As documentRow In HFiles
                Try
                    'build and save signed doc
                    Dim pdfName As String = hf.documentPath.Replace(".html", ".pdf")
                    Dim signedDocPath As String = Signatures_ExtractImagesFromPDF(_SigCountInDoc, pdfName, _SigningBatchID, _bHasCoApplicant, DebtorSigImgPath, CodebtorSigImgPath, DebtorInitImgPath, CodebtorInitImgPath)
                    signedFiles.Add(hf.documentName, signedDocPath)
                Catch ex As Exception

                End Try

            Next

            SigningType = "s"

            lblDoneMsg.Text = "You have successfully signed. Signed copies will be e-mailed to all parties. "

            'update tblLeadDocuments
            LexxSignHelper.NonCID.updateCompletedDateBySigningBatchID(_SigningBatchID, GetClientIP(), SigningType)

            'email signed doc to lead
            LexxSignHelper.NonCID.emailSignedDocuments(_DocumentInfo.DocumentLeadEmail, lblLeadName.Text, _SigningBatchID, signedFiles)


            'delete signature images
            Dim ldelete As New List(Of String)
            ldelete.Add(DebtorSigImgPath)
            ldelete.Add(CodebtorSigImgPath)
            ldelete.Add(DebtorInitImgPath)
            ldelete.Add(CodebtorInitImgPath)
            Build_DeleteFiles(ldelete)

            'You're done!
            divInstructions.Visible = False
            divDone.Visible = True
            sigWrapper.Visible = False
            clickWrapper.Visible = False
            trDocuments.Style("display") = "none"
            tdDocuments.Style("display") = "none"
        Else
            ClientScript.RegisterStartupScript(Me.GetType, "NoSig", "alert('Please draw signature and apply your signatures before signing!');", True)
            'LoadPage(CurrentDoc, CurrentPage)
        End If
    End Sub

    Protected Sub tvDocuments_SelectedNodeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles tvDocuments.SelectedNodeChanged
        If Not IsNothing(tvDocuments.SelectedNode.Parent) Then
            If IsNumeric(tvDocuments.SelectedNode.Parent.Value) Then
                Dim idoc As Integer = tvDocuments.SelectedNode.Parent.Value
                Dim ipag As Integer = tvDocuments.SelectedNode.Value
                hdnPage.Value = String.Format("{0}|{1}", idoc, ipag - 1)
                CurrentDoc = idoc
                CurrentPage = ipag - 1
            End If
        End If
        LoadPage(CurrentDoc, CurrentPage)
    End Sub

    Private Shared Function BuildDocumentLinkPath(ByVal typeOfPerson As enumSignaturePerson, _
        ByVal typeOfSignature As enumSignatureType, _
        ByVal iDocCnt As Integer, _
        ByVal ipage As Integer, _
        ByVal numAppSigs As Integer) As String
        Dim strTab As String = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"

        Dim linkScript As New StringBuilder
        linkScript.Append(strTab & strTab)
        linkScript.AppendFormat("<a href=""#{0}{1}{2}"" ", typeOfPerson.ToString, typeOfSignature.ToString.Substring(0, 4), ipage)
        linkScript.AppendFormat("('{0}',", iDocCnt)
        linkScript.AppendFormat("'{3}{4}{0}');"">{3} {5}(s)</a><br>", ipage, numAppSigs, iDocCnt, StrConv(typeOfPerson.ToString, VbStrConv.ProperCase), typeOfSignature.ToString.Substring(0, 4), StrConv(typeOfSignature.ToString, VbStrConv.ProperCase))

        Return linkScript.ToString
    End Function

    Private Shared Function BuildDocumentTreeNodeLinkPath(ByVal typeOfPerson As enumSignaturePerson, _
        ByVal typeOfSignature As enumSignatureType, _
        ByVal iDocCnt As Integer, _
        ByVal ipage As Integer, _
        ByVal numAppSigs As Integer) As String
        Dim linkScript As New StringBuilder
        linkScript.AppendFormat("<a href=""#{0}{1}{2}"" ", typeOfPerson.ToString, typeOfSignature.ToString.Substring(0, 4), ipage)
        linkScript.AppendFormat("onclick=""GotoSignature")
        linkScript.AppendFormat("('{0}',", iDocCnt)
        linkScript.AppendFormat("'{3}{4}{0}');"">{3} {5}(s)</a><br>", ipage, numAppSigs, iDocCnt, StrConv(typeOfPerson.ToString, VbStrConv.ProperCase), typeOfSignature.ToString.Substring(0, 4), StrConv(typeOfSignature.ToString, VbStrConv.ProperCase))
        Return linkScript.ToString
    End Function

    Private Shared Function SerializeObjectIntoJson(ByVal s As Object) As String
        Dim serializer As New DataContractJsonSerializer(s.[GetType]())
        Using ms As New MemoryStream()
            serializer.WriteObject(ms, s)
            ms.Flush()
            Dim bytes As Byte() = ms.GetBuffer()
            Dim jsonString As String = Encoding.UTF8.GetString(bytes, 0, bytes.Length).Trim(ControlChars.NullChar)
            Return jsonString
        End Using
    End Function

    Private Sub Build_SavePage(ByVal docNum As Integer, ByVal pageNUm As Integer, ByVal pageHTML As String)
        TryCast(DocList(docNum).Item(pageNUm), HtmlGenericControl).InnerHtml = pageHTML
    End Sub

    Private Function Build_swapTextWithImage(ByVal typeOfPerson As enumSignaturePerson, _
        ByVal typeOfSignature As enumSignatureType, _
        ByVal signatureImgPath As String, _
        ByVal iDocCnt As Integer, _
        ByVal appliedSignatures As Dictionary(Of String, Dictionary(Of String, List(Of String))), _
        ByVal ipage As Integer) As StringBuilder
        Dim typeString As String = String.Format("D{0}{1}", typeOfSignature.ToString.Substring(0, 1).ToUpper, Integer.Parse(typeOfPerson))
        Dim hoverSignatureScriptCodes As New StringBuilder
        Dim replaceDiv As New StringBuilder

        replaceDiv.AppendFormat("<div id=""{0}{1}{2}"" ", typeOfPerson.ToString, typeOfSignature.ToString.Substring(0, 4), ipage)

        If appliedSignatures.ContainsKey(iDocCnt) AndAlso appliedSignatures(iDocCnt).ContainsKey(ipage) AndAlso appliedSignatures(iDocCnt).Item(ipage).Contains(typeString) Then
            replaceDiv.AppendFormat("><img src=""temp/{0}"" />", Path.GetFileName(signatureImgPath))
        Else
            replaceDiv.Append("class=""sigBox"" ")
            replaceDiv.AppendFormat("onclick=""ApplySignature(this,'{0}','{1}','{2}','{3}');"" ", iDocCnt, ipage, typeString, signatureImgPath.Replace("\", "\\"))
            replaceDiv.AppendFormat("{0}", hoverSignatureScriptCodes.ToString)
            replaceDiv.Append(" class=""signatureBlock"" >")

            Select Case typeOfSignature
                Case enumSignatureType.signature
                    replaceDiv.Append("<table width=""100%"" cellpadding=""0"" cellspacing=""0"">")
                    replaceDiv.Append("<tr>")
                    replaceDiv.Append("<td><img src=""images/sign-here.png"" /></td>")
                    replaceDiv.Append("<td style=""text-align:left;padding-left:5px;"">Click to Sign</td>")

                    ClientScript.RegisterArrayDeclaration("signNav", String.Format("'{0}|{1}'", iDocCnt, ipage))
                Case Else
                    replaceDiv.Append("<table cellpadding=""0"" cellspacing=""0"">")
                    replaceDiv.Append("<tr>")
                    replaceDiv.Append("<td><img src=""images/sign-here.png"" /></td>")
                    replaceDiv.Append("<td style=""text-align:left;padding-left:5px;"">Initial</td>")
                    'keeps track for hyperlink jumping
                    ClientScript.RegisterArrayDeclaration("initNav", String.Format("'{0}|{1}'", iDocCnt, ipage))
            End Select

            replaceDiv.Append("</tr>")
            replaceDiv.Append("</table>")
        End If
        replaceDiv.Append("</div>")

        Return replaceDiv
    End Function

    Private Sub GetDocument(ByVal docId As String)
        Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.pdf", docId)
        Dim tblDoc As DataTable = SmartDebtorHelper.GetLeadDocument(docId)
        Dim tblBorrowers As DataTable

        If tblDoc.Rows.Count = 1 Then
            If tblDoc.Rows(0)("completed") Is DBNull.Value Then
                _DocumentID = tblDoc.Rows(0)("leaddocumentid")
                tblBorrowers = CredStarHelper.GetBorrowers(CInt(tblDoc.Rows(0)("leadapplicantid")))
                _bHasCoApplicant = (tblBorrowers.Rows.Count > 1)
                hDocName.InnerHtml = tblDoc.Rows(0)("displayname")
                lblDoneMsg.Text = String.Format("You have successfully signed {0}. Signed copies will be e-mailed to all parties.", tblDoc.Rows(0)("displayname"))
                lblLeadName.Text = tblDoc.Rows(0)("leadname")
                lblLeadEmail.Text = tblDoc.Rows(0)("signatoryemail")
                'iPDF.Attributes("src") = path
                iSignature.Attributes("src") = "mySignature.aspx?t=sign&file=" & tblDoc.Rows(0)("leaddocumentid")
                iInitials.Attributes("src") = "mySignature.aspx?t=init&w=120&file=" & tblDoc.Rows(0)("leaddocumentid") & "i"

                divCoApp.Visible = _bHasCoApplicant
                If _bHasCoApplicant Then
                    iCoSignature.Attributes("src") = "mySignature.aspx?file=" & tblDoc.Rows(0)("leaddocumentid") & "c"
                    iCoInitials.Attributes("src") = "mySignature.aspx?w=120&file=" & tblDoc.Rows(0)("leaddocumentid") & "ci"
                End If
                'Signatures_CreateFoundGrid(path, _bHasCoApplicant)
            Else
                lblDoneMsg.Text = String.Format("You have successfully signed {0} on <u>{1}</u>. Signed copies have been e-mailed to all parties.", tblDoc.Rows(0)("displayname"), Format(CDate(tblDoc.Rows(0)("completed")), "M/d/yyyy"))
                'iPDF.Attributes("src") = path.Replace("temp\", "")
                hDocName.Visible = False
                divInstructions.Visible = False
                divDone.Visible = True
                sigWrapper.Visible = False
            End If
        Else 'Doc not found
            hDocName.Visible = False
            divInstructions.Visible = False
            divDone.Visible = False
            divNotFound.Visible = True
            sigWrapper.Visible = False
        End If
    End Sub

    Private Function GetDocumentsBySigningBatchID(ByVal signingBatchId As String) As ArrayList 'Dictionary(Of String, String)

        Dim myParams As New List(Of SqlParameter)
        myParams.Add(New SqlParameter("batchid", signingBatchId))
        SqlHelper.ExecuteNonQuery("stp_updateLexxSignStatusIfVerbalExists", CommandType.StoredProcedure, myParams.ToArray)

        Dim path As String = ConfigurationManager.AppSettings("LeadDocumentsDir") & String.Format("temp\{0}.html", signingBatchId)
        Dim tblDoc As DataTable = SqlHelper.GetDataTable(String.Format("stp_esign_getDocuments '{0}'", signingBatchId))

        Dim tbldocs As New ArrayList 'Dictionary(Of String, String)
        Dim bFirstRun As Boolean = True

        If tblDoc.Rows.Count >= 1 Then
            If tblDoc.Rows(0)("completed") Is DBNull.Value Then
                For Each d As DataRow In tblDoc.Rows
                    If d("displayname").ToString.Contains("Truth") Then
                        bHideInits = False
                    End If

                    tbldocs.Add(New documentRow(d("displayname").ToString, String.Format("{0}temp\{1}.html", ConfigurationManager.AppSettings("LeadDocumentsDir"), d("documentid").ToString)))

                    If bFirstRun Then
                        _DocumentID = d("leaddocumentid")
                        Using tblBorrowers As DataTable = CredStarHelper.GetBorrowers(CInt(d("leadapplicantid").ToString))
                            _bHasCoApplicant = (tblBorrowers.Rows.Count > 1)
                        End Using
                        'hDocName.InnerHtml += String.Format("{0}, ", d("displayname"))
                        lblDoneMsg.Text = String.Format("You have successfully signed {0}. Signed copies will be e-mailed to all parties.", tblDoc.Rows(0)("displayname"))
                        lblLeadName.Text = d("leadname")
                        lblLeadEmail.Text = d("signatoryemail")

                        Dim sigFrameType As String = ""
                        Select Case Request.Browser.Browser.ToLower
                            Case "ie"
                                sigFrameType = "mySignature"
                            Case Else
                                sigFrameType = "mySignature_html5"
                        End Select

                        iSignature.Attributes("src") = String.Format("{0}.aspx?t=sign&file={1}&w=350", sigFrameType, d("signingbatchid"))
                        iInitials.Attributes("src") = String.Format("{0}.aspx?t=init&file={1}i&w=100", sigFrameType, d("signingbatchid"))

                        divCoApp.Visible = _bHasCoApplicant
                        If _bHasCoApplicant Then
                            iCoSignature.Attributes("src") = String.Format("{0}.aspx?t=sign&file={1}c&w=350", sigFrameType, d("signingbatchid"))
                            iCoInitials.Attributes("src") = String.Format("{0}.aspx?t=init&file={1}ci&w=100", sigFrameType, d("signingbatchid"))
                        End If

                    End If

                    bFirstRun = False
                Next
                If bHideInits Then
                    divInitials.Style("display") = "none"
                End If
                Return tbldocs

            Else
                Dim docList As New List(Of String)

                For Each d As DataRow In tblDoc.Rows
                    docList.Add(String.Format("{0}", d("displayname").ToString))
                Next
                Select Case tblDoc.Rows(0)("currentstatus")
                    Case "Completed"
                        lblDoneMsg.Text = String.Format("This settlement was completed on <u>{0}</u>.", Format(CDate(tblDoc.Rows(0)("completed")), "M/d/yyyy"))
                    Case "Verbal Accept"
                        lblDoneMsg.Text = String.Format("This settlement was verbally accepted on <u>{0}</u>.", Format(CDate(tblDoc.Rows(0)("completed")), "M/d/yyyy"))
                    Case "Expired"
                        lblDoneMsg.Text = String.Format("Settlement expired on <u>{0}</u>.", Format(CDate(tblDoc.Rows(0)("completed")), "M/d/yyyy"))
                    Case "Rejected"
                        lblDoneMsg.Text = String.Format("You have rejected this settlement on <u>{0}</u>.", Format(CDate(tblDoc.Rows(0)("completed")), "M/d/yyyy"))
                    Case Else
                        lblDoneMsg.Text = String.Format("You have successfully signed :<br><br><b>{0}</b> <br><br>on <u>{1}</u>. Signed copies have been e-mailed to all parties.", Join(docList.ToArray, "<br>"), Format(CDate(tblDoc.Rows(0)("completed")), "M/d/yyyy"))
                End Select

                iPDF.Attributes("src") = path.Replace("temp\", "")
                hDocName.Visible = False
                divInstructions.Visible = False
                divDone.Visible = True
                sigWrapper.Visible = False
                tblDocuments.Style("display") = "none"
                trDocuments.Style("display") = "none"
                tdDocuments.Style("display") = "none"
                clickWrapper.Visible = False
                Return Nothing
            End If
        Else 'Doc not found
            hDocName.Visible = False
            divInstructions.Visible = False
            divDone.Visible = False
            divNotFound.Visible = True
            sigWrapper.Visible = False
            clickWrapper.Visible = False
            tblDocuments.Style("display") = "none"
            trDocuments.Style("display") = "none"
            tdDocuments.Style("display") = "none"
            Return Nothing
        End If
    End Function

    Private Sub LoadPage(ByVal docNum As Integer, ByVal pageNum As Integer)
        Dim gp As New HtmlGenericControl("div")
        Try
            gp.Controls.Add(DocList(docNum).Item(pageNum))
        Catch ex As Exception
            'goto first doc, first page
            gp.Controls.Add(DocList(1).Item(0))
        End Try
        phContent.Controls.Clear()
        phContent.Controls.Add(gp)
    End Sub

#End Region 'Methods

    Protected Sub lnkRejectSign_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkRejectSign.Click
        _DocumentInfo = LexxSignHelper.NonCID.getDocumentInfoByID(_SigningBatchID)

        'update tblLeadDocuments
        LexxSignHelper.NonCID.updateCompletedDateBySigningBatchID(_SigningBatchID, GetClientIP(), "r", "Rejected")

        'You're done!
        divInstructions.Visible = False
        divDone.Visible = False
        divNotFound.Visible = True
        divNotFound.InnerHtml = "Settlement Rejected!"
        sigWrapper.Visible = False
        clickWrapper.Visible = False
        lnkRejectSign.Visible = True
        tblDocuments.Style("display") = "none"
        trDocuments.Style("display") = "none"
        tdDocuments.Style("display") = "none"
    End Sub
    Public Structure documentRow
        Public documentName As String
        Public documentPath As String
        Sub New(ByVal docName As String, ByVal docPath As String)
            documentName = docName
            documentPath = docPath
        End Sub
    End Structure
End Class