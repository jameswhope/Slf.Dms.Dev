Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Runtime.InteropServices
Imports System.Runtime.Serialization.Json
Imports System.Web.Services
Imports System.Windows.Forms

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports LexxiomLetterTemplates

Imports iTextSharp
Imports iTextSharp.text
Imports iTextSharp.text.Image
Imports iTextSharp.text.pdf
Imports System
Imports System.Net
Imports System.Net.Mail


Public Class LexxSignHelper

#Region "Enumerations"

    Public Enum enumSignaturePerson
        debtor = 1
        codebtor = 2
    End Enum

    Public Enum enumSignatureType
        signature = 0
        initials = 1
    End Enum

#End Region 'Enumerations

#Region "Methods"

    Public Shared Sub Build_DeleteFiles(ByVal listOfFilesToDelete As List(Of String))
        For Each filepath As String In listOfFilesToDelete
            If File.Exists(filepath) Then
                File.Delete(filepath)
            End If
        Next
    End Sub

    Public Shared Function Build_getAppliedSignatures(ByVal hiddenAppliedSignatureValues As String) As Dictionary(Of String, Dictionary(Of String, List(Of String)))
        Dim aSignatures As String() = hiddenAppliedSignatureValues.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
        Dim appliedSignatures As New Dictionary(Of String, Dictionary(Of String, List(Of String)))

        For Each sig As String In aSignatures
            Dim sigs As String() = sig.Split(New Char() {";"}, StringSplitOptions.RemoveEmptyEntries)
            Dim sigInfo As String() = sigs(1).Split(New Char() {"/"}, StringSplitOptions.RemoveEmptyEntries)
            If appliedSignatures.ContainsKey(sigs(0)) Then
                If appliedSignatures(sigs(0)).ContainsKey(sigInfo(0)) Then
                    appliedSignatures(sigs(0)).Item(sigInfo(0)).Add(sigInfo(1))
                Else
                    appliedSignatures(sigs(0)).Add(sigInfo(0), New List(Of String))
                    appliedSignatures(sigs(0)).Item(sigInfo(0)).Add(sigInfo(1))
                End If

            Else
                appliedSignatures.Add(sigs(0), New Dictionary(Of String, List(Of String)))
                appliedSignatures(sigs(0)).Add(sigInfo(0), New List(Of String))
                appliedSignatures(sigs(0)).Item(sigInfo(0)).Add(sigInfo(1))

            End If
        Next
        Return appliedSignatures
    End Function

    Public Shared Sub Document_emailSignedDocuments(ByVal SendTo As String, ByVal leadName As String, ByVal signingBatchID As String, ByVal signedPathList As Dictionary(Of String, String))
        Dim username As String = "info@lexxiom.com"   'CHolt 2/13/2020
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
        'CHolt 2/13/2020
        Dim mailSmtp As New SmtpClient(ConfigurationManager.AppSettings("gmailMailServer"), 587)
        'CHolt 2/13/2020
        Dim mailMsg As New MailMessage()
        mailMsg.From = New MailAddress("info@lawfirmcs.com", firmName)
        mailMsg.To.Add(New MailAddress(SendTo))
        mailMsg.Subject = String.Format("The documents (between {0} and {1}) are Signed and Filed!", firmName, leadName)

        Dim msgBody As New StringBuilder
        msgBody.Append("Your signed documents are attached.")
        mailMsg.Body = msgBody.ToString
        For Each doc As KeyValuePair(Of String, String) In signedPathList
            Try
                Dim attPath As String = doc.Value
                Dim att As New System.Net.Mail.Attachment(attPath)
                att.Name = String.Format("{0}.pdf", doc.Key)
                mailMsg.Attachments.Add(att)
            Catch ex As Exception
                Continue For
            End Try

        Next
        mailMsg.IsBodyHtml = True
        'CHolt 2/13/2020
        Dim nc As New NetworkCredential(username, ConfigurationManager.AppSettings("gmailPassword"))
        mailSmtp.UseDefaultCredentials = False
        mailSmtp.Credentials = nc
        mailSmtp.DeliveryMethod = SmtpDeliveryMethod.Network
        mailSmtp.EnableSsl = True
        mailSmtp.Send(mailMsg)
    End Sub

    'Sends signed documents to representative
    Public Shared Sub Document_emailSignedDocumentsToRep(ByVal SendTo As String, ByVal leadName As String, ByVal signingBatchID As String, ByVal signedPathList As Dictionary(Of String, String))
        Dim username As String = "info@lexxiom.com"    'CHolt 2/13/2020
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
        'CHolt 2/13/2020
        Dim mailSmtp As New SmtpClient(ConfigurationManager.AppSettings("gmailMailServer"), 587)
        'CHolt 2/13/2020
        Dim mailMsg As New MailMessage()
        mailMsg.From = New MailAddress("info@lawfirmcs.com", firmName)
        mailMsg.To.Add(New MailAddress(SendTo))
        mailMsg.Subject = String.Format("The documents (between {0} and {1}) are Signed and Filed!", firmName, leadName)

        Dim msgBody As New StringBuilder
        msgBody.Append("The signed documents for " + leadName + " are attached.")
        mailMsg.Body = msgBody.ToString
        For Each doc As KeyValuePair(Of String, String) In signedPathList
            Try
                Dim attPath As String = doc.Value
                Dim att As New System.Net.Mail.Attachment(attPath)
                att.Name = String.Format("{0}.pdf", doc.Key)
                mailMsg.Attachments.Add(att)
            Catch ex As Exception
                Continue For
            End Try

        Next
        mailMsg.IsBodyHtml = True
        'CHolt 2/13/2020
        Dim nc As New NetworkCredential(username, ConfigurationManager.AppSettings("gmailPassword"))
        mailSmtp.UseDefaultCredentials = False
        mailSmtp.Credentials = nc
        mailSmtp.DeliveryMethod = SmtpDeliveryMethod.Network
        mailSmtp.EnableSsl = True
        mailSmtp.Send(mailMsg)
    End Sub


    Public Shared Function Document_getDocumentID(ByVal docId As String) As SignedDocumentInfo
        Dim tblDoc As DataTable = SqlHelper.GetDataTable(String.Format("select top 1 d.leaddocumentid, d.signatoryemail from tblleaddocuments d join tbldocumenttype t on t.documenttypeid = d.documenttypeid where d.signingBatchID = '{0}'", docId))
        Dim sd As New SignedDocumentInfo
        For Each row As DataRow In tblDoc.Rows
            sd.LeadDocumentID = row("leaddocumentid").ToString
            sd.DocumentLeadEmail = row("signatoryemail").ToString
        Next
        Return sd
    End Function

    Public Shared Sub Document_updateBrowserInfo(ByVal SigningBatchID As String, ByVal clientBrowserName As String, ByVal clientBrowserVersion As String, ByVal bJSEnabled As Boolean)
        Dim sqlUpdate As String = String.Format("update tblleaddocuments set SigningBrowserName = '{0}', SigningBrowserVersion='{1}',SigningBrowserJSEnabled='{2}' where SigningBatchID = '{3}'", clientBrowserName, clientBrowserVersion, bJSEnabled, SigningBatchID)
        SqlHelper.ExecuteScalar(sqlUpdate, CommandType.Text)
    End Sub

    Public Shared Sub Document_updateCompletedDate(ByVal docId As String)
        SqlHelper.ExecuteScalar(String.Format("update tblleaddocuments set Completed = getdate(), currentstatus='Document signed' where documentid = '{0}'", docId), CommandType.Text)
    End Sub

    Public Shared Sub Document_updateCompletedDateBySigningBatchID(ByVal SigningBatchID As String, ByVal clientIPAddress As String)
        SqlHelper.ExecuteScalar(String.Format("update tblleaddocuments set Completed = getdate(), currentstatus='Document signed', SigningIPAddress='{0}' where SigningBatchID = '{1}'", clientIPAddress, SigningBatchID), CommandType.Text)
    End Sub

    ''' <summary>
    ''' replaces blank images with signature images
    ''' </summary>
    ''' <param name="sourcePdf"></param>
    ''' <param name="pathToApplicantSignatureImage"></param>
    ''' <param name="bHasCoapps"></param>
    ''' <param name="pathToCoapplicantSignatureImage"></param>
    ''' <param name="pathToApplicantInitialImage"></param>
    ''' <param name="pathToCoapplicantInitialImage"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function Signatures_ExtractImagesFromPDF(ByRef SigCountInDoc As Integer, _
        ByVal sourcePdf As String, _
        ByVal SigningBatchGUID As String, _
        ByVal bHasCoapps As Boolean, _
        ByVal pathToApplicantSignatureImage As String, _
        Optional ByVal pathToCoapplicantSignatureImage As String = Nothing, _
        Optional ByVal pathToApplicantInitialImage As String = Nothing, _
        Optional ByVal pathToCoapplicantInitialImage As String = Nothing) As String
        Dim appimg As Image = Nothing
        Dim coappimg As Image = Nothing
        Dim appinitimg As Image = Nothing
        Dim coappinitimg As Image = Nothing

        'ensure images are there
        'and apply blue border to image
        If Not IsNothing(pathToApplicantSignatureImage) Then
            If File.Exists(pathToApplicantSignatureImage) Then
                appimg = Image.GetInstance(pathToApplicantSignatureImage)
                appimg.ScaleToFit(300, 100)
            End If
        End If
        If Not IsNothing(pathToCoapplicantSignatureImage) Then
            If File.Exists(pathToCoapplicantSignatureImage) Then
                coappimg = Image.GetInstance(pathToCoapplicantSignatureImage)
                coappimg.ScaleToFit(300, 100)
            End If
        End If
        If Not IsNothing(pathToApplicantInitialImage) Then
            If File.Exists(pathToApplicantInitialImage) Then
                appinitimg = Image.GetInstance(pathToApplicantInitialImage)
                appinitimg.ScaleToFit(120, 100)

            End If
        End If
        If Not IsNothing(pathToCoapplicantInitialImage) Then
            If File.Exists(pathToCoapplicantInitialImage) Then
                coappinitimg = Image.GetInstance(pathToCoapplicantInitialImage)
                coappinitimg.ScaleToFit(120, 100)

            End If
        End If

        'signed document path
        Dim outFile As String = sourcePdf.Replace(".pdf", "_signed.pdf")
        outFile = sourcePdf.Replace("\temp", "")

        Dim pdf As New PdfReader(sourcePdf)
        Dim stp As New PdfStamper(pdf, New FileStream(outFile, FileMode.Create))
        Dim writer As PdfWriter = stp.Writer
        Try
            SigCountInDoc = 1
            Dim pageNumber As Integer = 1
            While pageNumber <= pdf.NumberOfPages
                'get page
                Dim pg As PdfDictionary = pdf.GetPageN(pageNumber)

                AddLexxEsignGuid(SigningBatchGUID, pdf, stp, pageNumber)

                'get resources on page
                Dim res As PdfDictionary = DirectCast(PdfReader.GetPdfObject(pg.[Get](PdfName.RESOURCES)), PdfDictionary)

                'get all resources from obj
                Dim xobj As PdfDictionary = DirectCast(PdfReader.GetPdfObject(res.[Get](PdfName.XOBJECT)), PdfDictionary)
                If Not IsNothing(xobj) Then
                    For Each name As PdfName In xobj.Keys
                        Try
                            Dim obj As PdfObject = xobj.[Get](name)
                            If obj.IsIndirect() Then
                                Dim tg As PdfDictionary = DirectCast(PdfReader.GetPdfObject(obj), PdfDictionary)
                                Dim type As PdfName = DirectCast(PdfReader.GetPdfObject(tg.[Get](PdfName.SUBTYPE)), PdfName)
                                Dim width As String = tg.[Get](PdfName.WIDTH).ToString()
                                Dim height As String = tg.[Get](PdfName.HEIGHT).ToString()
                                If PdfName.IMAGE.Equals(type) Then
                                    PdfReader.KillIndirect(obj)
                                    'get image dimensions
                                    Dim maskImage As Image = Nothing
                                    Dim swapImage As Image = Nothing

                                    'determine image type sig/init
                                    Select Case bHasCoapps
                                        Case True
                                            If SigCountInDoc Mod 2 = 0 Then
                                                Select Case width
                                                    Case Is < 350   'app init
                                                        maskImage = appinitimg.ImageMask
                                                        swapImage = appinitimg
                                                    Case Else       'app sig
                                                        maskImage = appimg.ImageMask
                                                        swapImage = appimg
                                                End Select
                                            Else
                                                If Not IsNothing(coappimg) Then
                                                    Select Case width
                                                        Case Is < 350   'coapp init
                                                            maskImage = coappinitimg.ImageMask
                                                            swapImage = coappinitimg
                                                        Case Else       'coapp sig
                                                            maskImage = coappimg.ImageMask
                                                            swapImage = coappimg
                                                    End Select
                                                End If
                                            End If
                                        Case Else
                                            Select Case width
                                                Case Is < 350   'app init
                                                    maskImage = appinitimg.ImageMask
                                                    swapImage = appinitimg
                                                Case Else       'app sig
                                                    maskImage = appimg.ImageMask
                                                    swapImage = appimg
                                            End Select
                                    End Select

                                    If Not IsNothing(maskImage) Then
                                        writer.AddDirectImageSimple(maskImage)
                                    End If
                                    If Not IsNothing(swapImage) Then
                                        writer.AddDirectImageSimple(swapImage, DirectCast(obj, PRIndirectReference))
                                        SigCountInDoc += 1
                                    End If

                                End If
                            End If
                        Catch ex As Exception
                            Continue For
                        End Try
                    Next
                End If
                System.Math.Max(System.Threading.Interlocked.Increment(pageNumber), pageNumber - 1)
            End While
            'File.Delete(sourcePdf) 'delete temp file
        Catch ex As Exception
            Throw ex
        Finally
            pdf.Close()
        End Try
        stp.FormFlattening = True
        stp.Close()
        Return outFile
    End Function

    ''' <summary>
    ''' finds all the signature images in a pdf
    ''' </summary>
    ''' <param name="sourcePdf"></param>
    ''' <param name="bHasCoapps"></param>
    ''' <returns>list of found signatures</returns>
    ''' <remarks></remarks>
    Public Shared Function Signatures_FindSignaturesInPDF(ByRef SigCountInDoc As Integer, ByVal sourcePdf As String, ByVal bHasCoapps As Boolean) As System.Collections.Generic.List(Of FoundSignatures)
        Dim images As New System.Collections.Generic.List(Of Byte())
        Dim found As New System.Collections.Generic.List(Of FoundSignatures)
        Dim pdf As New PdfReader(sourcePdf)
        Dim raf As RandomAccessFileOrArray = New iTextSharp.text.pdf.RandomAccessFileOrArray(sourcePdf)
        SigCountInDoc = 1
        Try
            Dim pageNumber As Integer = 1
            While pageNumber <= pdf.NumberOfPages
                Dim iPageCnt As Integer = 1
                Dim pg As PdfDictionary = pdf.GetPageN(pageNumber)
                Dim res As PdfDictionary = DirectCast(PdfReader.GetPdfObject(pg.[Get](PdfName.RESOURCES)), PdfDictionary)
                Dim xobj As PdfDictionary = DirectCast(PdfReader.GetPdfObject(res.[Get](PdfName.XOBJECT)), PdfDictionary)
                found.AddRange(Signatures_findAllImages(SigCountInDoc, pg, images, pdf, pageNumber, bHasCoapps))

                System.Math.Max(System.Threading.Interlocked.Increment(pageNumber), pageNumber - 1)
            End While
        Catch
            Throw
        Finally
            pdf.Close()
            raf.Close()
        End Try
        Return found
    End Function

    ''' <summary>
    ''' Finds all images on a pdf page
    ''' </summary>
    ''' <param name="dict"></param>
    ''' <param name="images"></param>
    ''' <param name="doc"></param>
    ''' <param name="pageFoundOn"></param>
    ''' <param name="hasCoapplicants"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function Signatures_findAllImages(ByRef SigCountInDoc As Integer, ByVal dict As pdf.PdfDictionary, ByVal images As System.Collections.Generic.List(Of Byte()), ByVal doc As pdf.PdfReader, ByVal pageFoundOn As Integer, Optional ByVal hasCoapplicants As Boolean = False) As System.Collections.Generic.List(Of FoundSignatures)
        Dim res As pdf.PdfDictionary = CType(pdf.PdfReader.GetPdfObject(dict.Get(pdf.PdfName.RESOURCES)), pdf.PdfDictionary)
        Dim xobj As pdf.PdfDictionary = CType(pdf.PdfReader.GetPdfObject(res.Get(pdf.PdfName.XOBJECT)), pdf.PdfDictionary)
        Dim found As New System.Collections.Generic.List(Of FoundSignatures)
        Dim iPageCnt As Integer = 1
        If xobj IsNot Nothing Then
            For Each name As pdf.PdfName In xobj.Keys
                Dim obj As pdf.PdfObject = xobj.Get(name)

                If (obj.IsIndirect) Then
                    Dim tg As pdf.PdfDictionary = CType(pdf.PdfReader.GetPdfObject(obj), pdf.PdfDictionary)
                    Dim subtype As pdf.PdfName = CType(pdf.PdfReader.GetPdfObject(tg.Get(pdf.PdfName.SUBTYPE)), pdf.PdfName)
                    If pdf.PdfName.IMAGE.Equals(subtype) Or pdf.PdfName.IMAGE.Equals(subtype).ToString = "/Image" Then
                        Dim xrefIdx As Integer = CType(obj, pdf.PRIndirectReference).Number
                        Dim pdfObj As pdf.PdfObject = doc.GetPdfObject(xrefIdx)
                        Dim width As String = tg.Get(pdf.PdfName.WIDTH).ToString
                        Dim height As String = tg.Get(pdf.PdfName.HEIGHT).ToString
                        Dim sigType As String = ""
                        Select Case hasCoapplicants
                            Case True
                                If SigCountInDoc Mod 2 = 0 Then
                                    Select Case width
                                        Case Is < 300
                                            sigType = "COAPPINIT"
                                        Case Else
                                            sigType = "COAPPSIG"
                                    End Select
                                Else
                                    Select Case width
                                        Case Is < 300
                                            sigType = "APPINIT"
                                        Case Else
                                            sigType = "APPSIG"
                                    End Select
                                End If
                            Case Else
                                Select Case width
                                    Case Is < 300
                                        sigType = "APPINIT"
                                    Case Else
                                        sigType = "APPSIG"
                                End Select
                        End Select
                        Dim fs As New FoundSignatures
                        fs.SignatureID = SigCountInDoc
                        fs.SignatureType = sigType
                        fs.PageFoundOn = pageFoundOn
                        found.Add(fs)

                        SigCountInDoc += 1

                    ElseIf pdf.PdfName.FORM.Equals(subtype) Or pdf.PdfName.GROUP.Equals(subtype) Then
                        Signatures_getAllImages(tg, images, doc)
                    End If
                End If
            Next
        End If
        Return found
    End Function

    ''' <summary>
    ''' finds all images in a pdf dict
    ''' </summary>
    ''' <param name="dict"></param>
    ''' <param name="images"></param>
    ''' <param name="doc"></param>
    ''' <remarks></remarks>
    Public Shared Sub Signatures_getAllImages(ByVal dict As pdf.PdfDictionary, ByVal images As System.Collections.Generic.List(Of Byte()), ByVal doc As pdf.PdfReader)
        Dim res As pdf.PdfDictionary = CType(pdf.PdfReader.GetPdfObject(dict.Get(pdf.PdfName.RESOURCES)), pdf.PdfDictionary)
        Dim xobj As pdf.PdfDictionary = CType(pdf.PdfReader.GetPdfObject(res.Get(pdf.PdfName.XOBJECT)), pdf.PdfDictionary)

        If xobj IsNot Nothing Then
            For Each name As pdf.PdfName In xobj.Keys
                Try
                    Dim obj As pdf.PdfObject = xobj.Get(name)
                    If (obj.IsIndirect) Then
                        Dim tg As pdf.PdfDictionary = CType(pdf.PdfReader.GetPdfObject(obj), pdf.PdfDictionary)
                        Dim subtype As pdf.PdfName = CType(pdf.PdfReader.GetPdfObject(tg.Get(pdf.PdfName.SUBTYPE)), pdf.PdfName)

                        If pdf.PdfName.IMAGE.Equals(subtype) Then
                            Dim xrefIdx As Integer = CType(obj, pdf.PRIndirectReference).Number
                            Dim pdfObj As pdf.PdfObject = doc.GetPdfObject(xrefIdx)
                            Dim str As pdf.PdfStream = CType(pdfObj, pdf.PdfStream)
                            Dim bytes As Byte() = pdf.PdfReader.GetStreamBytesRaw(CType(str, pdf.PRStream))

                            Dim filter As String = tg.Get(pdf.PdfName.FILTER).ToString
                            Dim width As String = tg.Get(pdf.PdfName.WIDTH).ToString
                            Dim height As String = tg.Get(pdf.PdfName.HEIGHT).ToString
                            Dim bpp As String = tg.Get(pdf.PdfName.BITSPERCOMPONENT).ToString

                            If filter = "/FlateDecode" Then
                                bytes = pdf.PdfReader.FlateDecode(bytes, True)
                                Dim pixelFormat As System.Drawing.Imaging.PixelFormat
                                Select Case Integer.Parse(bpp)
                                    Case 1
                                        pixelFormat = Drawing.Imaging.PixelFormat.Format1bppIndexed
                                    Case 24
                                        pixelFormat = Drawing.Imaging.PixelFormat.Format24bppRgb
                                    Case Else
                                        Throw New Exception("Unknown pixel format " + bpp)
                                End Select
                                Dim bmp As New System.Drawing.Bitmap(Int32.Parse(width), Int32.Parse(height), pixelFormat)
                                Dim bmd As System.Drawing.Imaging.BitmapData = bmp.LockBits(New System.Drawing.Rectangle(0, 0, Int32.Parse(width), Int32.Parse(height)), System.Drawing.Imaging.ImageLockMode.WriteOnly, pixelFormat)
                                Marshal.Copy(bytes, 0, bmd.Scan0, bytes.Length)
                                bmp.UnlockBits(bmd)
                                Using ms As New MemoryStream
                                    bmp.Save(ms, System.Drawing.Imaging.ImageFormat.Png)
                                    bytes = ms.GetBuffer
                                End Using
                            End If
                            images.Add(bytes)
                        ElseIf pdf.PdfName.FORM.Equals(subtype) Or pdf.PdfName.GROUP.Equals(subtype) Then
                            Signatures_getAllImages(tg, images, doc)
                        End If
                    End If
                Catch ex As Exception
                    Continue For
                End Try

            Next
        End If
    End Sub

    Private Shared Sub AddLexxEsignGuid(ByVal SigningBatchGUID As String, ByVal pdf As PdfReader, ByVal stp As PdfStamper, ByVal pageNumber As Integer)
        Dim pageSize As Rectangle = pdf.GetPageSizeWithRotation(pageNumber)
        Dim bf As BaseFont = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED)
        Dim cb As PdfContentByte = stp.GetUnderContent(pageNumber)
        cb.Rectangle(5, 5, pageSize.Width - 10, pageSize.Height - 10)
        cb.Stroke()

        'add guid to bottom of doc
        cb.BeginText()
        cb.SetFontAndSize(bf, 11)
        Dim cInfo As String = ""
        cInfo = String.Format("LexxSign {0}: {1}" & vbTab & " {2}: {3}", "Transaction Number".ToUpper, SigningBatchGUID, "Date".ToUpper, Now.ToString)
        cb.ShowTextAligned(PdfContentByte.ALIGN_LEFT, cInfo, 10, 10, 0)
        cb.EndText()
        cb = Nothing
    End Sub

    #End Region 'Methods

    #Region "Nested Types"

    Public Structure SignedDocumentInfo

        #Region "Fields"

        Public DocumentLeadEmail As String
        Public LeadDocumentID As String

        #End Region 'Fields

    End Structure

    Public Class AppliedImage

        #Region "Fields"

        Private _ImageContainer As String
        Private _ImageDocNumber As Integer
        Private _ImagePageNumber As Integer
        Private _SignatureType As String

        #End Region 'Fields

        #Region "Properties"

        Public Property ImageContainerID() As String
            Get
                Return _ImageContainer
            End Get
            Set(ByVal value As String)
                _ImageContainer = value
            End Set
        End Property

        Public Property ImageDocNumber() As Integer
            Get
                Return _ImageDocNumber
            End Get
            Set(ByVal value As Integer)
                _ImageDocNumber = value
            End Set
        End Property

        Public Property ImagePageNumber() As Integer
            Get
                Return _ImagePageNumber
            End Get
            Set(ByVal value As Integer)
                _ImagePageNumber = value
            End Set
        End Property

        Public Property SignatureType() As String
            Get
                Return _SignatureType
            End Get
            Set(ByVal value As String)
                _SignatureType = value
            End Set
        End Property

        #End Region 'Properties

    End Class

    Public Class FoundSignatures

        #Region "Fields"

        Private _PageFoundOn As Integer
        Private _SignatureID As Integer
        Private _SignatureType As String

        #End Region 'Fields

        #Region "Properties"

        Public Property PageFoundOn() As Integer
            Get
                Return _PageFoundOn
            End Get
            Set(ByVal value As Integer)
                _PageFoundOn = value
            End Set
        End Property

        Public Property SignatureID() As Integer
            Get
                Return _SignatureID
            End Get
            Set(ByVal value As Integer)
                _SignatureID = value
            End Set
        End Property

        Public Property SignatureType() As String
            Get
                Return _SignatureType
            End Get
            Set(ByVal value As String)
                _SignatureType = value
            End Set
        End Property

        #End Region 'Properties

    End Class

    Public Class NonCID

        #Region "Methods"

        Public Shared Function GetLexxSignDocumentsBySigningBatchID(ByVal signingBatchID As String) As DataTable
            Return SqlHelper.GetDataTable(String.Format("stp_esign_getDocuments '{0}'", signingBatchID))
        End Function

        Public Shared Sub ResolveClientApprovalMatter(ByVal SigningBatchID As String, ByVal bResolved As Boolean)
            Dim sID As Integer = SqlHelper.ExecuteScalar(String.Format("select relationid from tbllexxsigndocs where relationtypeid = 21 and signingBatchID = '{0}'", SigningBatchID), CommandType.Text)
            Dim cuID As Integer = 1481     'lexxsign user
            Dim dcID As Integer = -1
            Dim acctID As Integer = -1
            Using dt As DataTable = SqlHelper.GetDataTable(String.Format("select clientid, creditoraccountid,createdby from tblsettlements where settlementid= '{0}'", sID), CommandType.Text)
                For Each dr As DataRow In dt.Rows
                    dcID = dr("clientid").ToString
                    acctID = dr("creditoraccountid").ToString
                    Exit For
                Next

            End Using
            Dim iResolved As Integer = SettlementMatterHelper.ResolveClientApproval(sID, cuID, "LEXXSIGN", bResolved)
            Dim strDocID As String = "D6004SG"
            Dim rootDir As String = SharedFunctions.DocumentAttachment.CreateDirForClient(dcID)
            Dim strCredName As String = AccountHelper.GetCreditorName(acctID)
            Dim tempName As String = strCredName
            tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
            If Directory.Exists(rootDir & "CreditorDocs\" & acctID & "_" + tempName & "\") = False Then
                Directory.CreateDirectory(rootDir & "CreditorDocs\" & acctID & "_" & tempName & "\")
            End If
            If bResolved = True Then
                Dim noteID As Integer = NoteHelper.InsertNote("Settlement Acceptance Form signed by client.", cuID, dcID)           'attach client copy of letter
                NoteHelper.RelateNote(noteID, 1, dcID)              'relate to client
                NoteHelper.RelateNote(noteID, 2, acctID)                 'relate to creditor
                Dim docID As String = ""
                Dim filePath As String = ""
                Using dtdocs As DataTable = SqlHelper.GetDataTable(String.Format("select documentid from tbllexxsigndocs where signingbatchid = '{0}'", SigningBatchID), CommandType.Text)
                    For Each doc As DataRow In dtdocs.Rows
                        Try
                            docID = doc("documentid").ToString
                            filePath = GetUniqueDocumentName2(rootDir, dcID, strDocID, cuID, "CreditorDocs\" & acctID & "_" & tempName & "\")
                            File.Copy(String.Format("\\dc02\leaddocuments\{0}.pdf", doc("documentid").ToString), filePath)
                            'attach  document
                            SharedFunctions.DocumentAttachment.AttachDocument("note", noteID, Path.GetFileName(filePath), cuID, String.Format("{0}_{1}\", acctID, tempName))
                            SharedFunctions.DocumentAttachment.AttachDocument("account", acctID, Path.GetFileName(filePath), cuID, String.Format("{0}_{1}\", acctID, tempName))
                            SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(filePath), cuID, Now)
                        Catch ex As IOException
                            Continue For
                        End Try

                    Next
                End Using

                'update matter
                'Using settinfo As AttachSifHelper._AttachSettlementInfo = AttachSifHelper.GetSettlementInfo(sID)
                '    Dim currTaskID As String = SettlementMatterHelper.GetMatterCurrentTaskID(settinfo.SettlementMatterID)
                '    ResolveSigningTask(currTaskID, cuID)
                '    Dim matterStatus As Integer = 0
                '    Dim matterSubstatus As Integer = 0
                '    If settinfo.IsShortage Then
                '        'insert manager approval task
                '        InsertAfterSigningTask(settinfo.SettlementMatterID, 74, currTaskID, "Waiting Manager Approval", settinfo.SettlementDueDate, cuID)
                '        matterStatus = 27
                '        matterSubstatus = 55
                '    Else
                '        'insert payment task
                '        InsertAfterSigningTask(settinfo.SettlementMatterID, 73, currTaskID, "Pending Accounting Approval", settinfo.SettlementDueDate, cuID)
                '        matterStatus = 38
                '        matterSubstatus = 67
                '        InsertPaymentProcessing(settinfo.SettlementID)
                '    End If
                '    SettlementMatterHelper.UpdateMatterStatus(settinfo.SettlementMatterID, matterStatus)
                '    SettlementMatterHelper.UpdateMatterSubStatus(settinfo.SettlementMatterID, matterSubstatus)
                'End Using
            Else
                Dim noteID As Integer = NoteHelper.InsertNote("Settlement Acceptance Form rejected by client through LexxSign.", cuID, dcID)           'attach client copy of letter
                NoteHelper.RelateNote(noteID, 1, dcID)              'relate to client
                NoteHelper.RelateNote(noteID, 2, acctID)
                'SettlementMatterHelper.UpdateMatterStatus(sID, 25)
                'SettlementMatterHelper.UpdateMatterSubStatus(sID, 53)
            End If
        End Sub
        Private Shared Sub InsertPaymentProcessing(ByVal settlementID As Integer, Optional ByVal LoggedInUserID As Integer = 1481)
            Dim sqlResolve As String = "stp_settlements_insertPaymentProcessing"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("settlementid", settlementID))
            params.Add(New SqlParameter("userid", LoggedInUserID))
            SqlHelper.ExecuteNonQuery(sqlResolve, CommandType.StoredProcedure, params.ToArray)
        End Sub

        Public Shared Sub SaveLexxSignDocument(ByVal DataClientID As Integer, ByVal documentID As String, ByVal submittedBy As Integer, ByVal docTypeID As String, ByVal SigningBatchID As String, ByVal signatoryEmail As String, ByVal relationTypeID As Integer, ByVal relationID As Integer)
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)
            DatabaseHelper.AddParameter(cmd, "DocumentId", documentID)
            DatabaseHelper.AddParameter(cmd, "DocumentTypeID", docTypeID)
            DatabaseHelper.AddParameter(cmd, "SigningBatchID", SigningBatchID)
            DatabaseHelper.AddParameter(cmd, "SubmittedBy", submittedBy)
            DatabaseHelper.AddParameter(cmd, "RelationTypeID", relationTypeID)
            DatabaseHelper.AddParameter(cmd, "RelationID", relationID)

            Select Case docTypeID
                Case "D2006"
                    DatabaseHelper.AddParameter(cmd, "Completed", Now)
                    DatabaseHelper.AddParameter(cmd, "CurrentStatus", "Complete")
                Case Else
                    DatabaseHelper.AddParameter(cmd, "SignatoryEmail", signatoryEmail)
                    DatabaseHelper.AddParameter(cmd, "CurrentStatus", "Waiting on signatures")

            End Select

            DatabaseHelper.BuildInsertCommandText(cmd, "tblLexxSignDocs", "LexxSignDocumentID", SqlDbType.Int)

            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try
        End Sub

        Public Shared Sub SendLexxSignNotification(ByVal SendTo As String, ByVal DocumentNameList As String(), ByVal signingBatchID As String, ByVal RepID As Integer)
            Dim msgBody As New StringBuilder
            Dim msgSubj As New StringBuilder

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
            sqlInfo.Append("select co.name from tblLexxSignDocs lsd inner join tblclient c on c.clientid = lsd.clientid inner join tblcompany co on co.companyid = c.companyid ")
            sqlInfo.AppendFormat("where lsd.signingbatchid = '{0}'", signingBatchID)
            Using dt As DataTable = SqlHelper.GetDataTable(sqlInfo.ToString, CommandType.Text)
                For Each row As DataRow In dt.Rows
                    firmName = row("name").ToString
                    Exit For
                Next
            End Using

            Dim lnkUrl As String = String.Format("{0}://{1}/public/LexxSign.aspx?sbId={2}&t=s", strHTTP, svrPath, signingBatchID)

            'build email body
            msgBody.Append("<table style='width: 700px; min-width: 700px; font-family: Verdana; font-size:12px; background-color: #F2F2F2' cellpadding='8' cellspacing='0'>")
            msgBody.AppendFormat("<tr><td><h2>{0} has sent your <u>document(s)</u> to review and e-Sign</h2></td></tr>", firmName)
            msgBody.AppendFormat("<tr><td><img src='{0}://{1}/public/images/24x24_pen.gif' align='absmiddle' /><a style='color: #1E90FF' href='{2}' target='_blank'>Click here to review and e-sign.</a></td></tr>", strHTTP, svrPath, lnkUrl)
            msgBody.Append("<tr><td>With just <b>one simple step,</b> you can electronically sign this document. After you e-sign the <b>document(s)</b>, all parties will receive an emailed signed copy (PDF).</td></tr>")
            msgBody.Append("<tr><td><b>The following documents are ready to be e-signed:</b></td></tr>")
            msgBody.Append("<tr><td style='background-color: #E8E8E8'>")
            For Each s As String In DocumentNameList
                Select Case s
                    Case "CoverLetter"
                        ' don't add to list
                    Case Else
                        msgBody.Append("&nbsp;-&nbsp;" & s.Replace("LSA", "Legal Service Agreement").Replace("ScheduleA", "Schedule A").Replace("TruthInService", "Truth In Service").Replace("SDAA", "Settlement Deposit Account Agreement") & "<br/>")
                End Select
            Next
            msgBody.Append("</td></tr>")
            msgBody.Append("<tr><td>&nbsp;</td></tr>")
            msgBody.AppendFormat("<tr><td style='background-color: #326FA2; border-top: solid 2px #A4D3EE; color: #fff; font-size: 11px'>Optionally, if you cannot click the link above please cut and paste the address below into your address bar.<br />{0}</td></tr>", lnkUrl)
            msgBody.AppendFormat("<tr><td style='background-color: #326FA2; padding-top:30px' align='right'><img src='{0}://{1}/public/images/poweredby.png' /></td></tr>", strHTTP, svrPath)

            msgSubj.AppendFormat("Please E-sign the {0}", Join(DocumentNameList, ", "))

            Dim mailMsg As New System.Net.Mail.MailMessage(String.Format("{0} <noreply@lawfirmsd.com>", firmName), SendTo, msgSubj.ToString, msgBody.ToString)
            Dim mailSmtp As New System.Net.Mail.SmtpClient(ConfigurationManager.AppSettings("EmailSMTP"))
            mailMsg.IsBodyHtml = True
            Try
                mailSmtp.Send(mailMsg)
            Catch ex As Exception

            End Try
        End Sub

        Public Shared Sub emailSignedDocuments(ByVal SendTo As String, ByVal leadName As String, ByVal signingBatchID As String, ByVal signedPathList As Dictionary(Of String, String))
            Dim firmName As String = ""
            Dim sqlInfo As New StringBuilder
            sqlInfo.Append("select co.name from tbllexxsigndocs ld inner join tblclient la on la.clientid = ld.clientid inner join tblcompany co on co.companyid = la.companyid ")
            sqlInfo.AppendFormat("where ld.signingbatchid = '{0}'", signingBatchID)
            Using dt As DataTable = SqlHelper.GetDataTable(sqlInfo.ToString, CommandType.Text)
                For Each row As DataRow In dt.Rows
                    firmName = row("name").ToString
                    Exit For
                Next
            End Using

            Dim mailMsg As New System.Net.Mail.MailMessage()
            mailMsg.From = New System.Net.Mail.MailAddress("noreply@lawfirmsd.com", firmName)
            mailMsg.To.Add(New System.Net.Mail.MailAddress(SendTo))
            mailMsg.Subject = String.Format("The documents (between {0} and {1}) are Signed and Filed!", firmName, leadName)

            Dim msgBody As New StringBuilder
            msgBody.Append("Your signed documents are attached.")
            mailMsg.Body = msgBody.ToString
            For Each doc As KeyValuePair(Of String, String) In signedPathList
                Try
                    Dim attPath As String = doc.Value
                    Dim att As New System.Net.Mail.Attachment(attPath)
                    att.Name = String.Format("{0}.pdf", doc.Key)
                    mailMsg.Attachments.Add(att)
                Catch ex As Exception
                    Continue For
                End Try

            Next

            Dim mailSmtp As New System.Net.Mail.SmtpClient(ConfigurationManager.AppSettings("EmailSMTP"))
            mailMsg.IsBodyHtml = False
            mailSmtp.Send(mailMsg)
        End Sub

        Public Shared Function getDocumentInfoByID(ByVal docId As String) As SignedDocumentInfo
            Dim tblDoc As DataTable = SqlHelper.GetDataTable(String.Format("select top 1 d.lexxsigndocumentid, d.signatoryemail from tbllexxsigndocs d join tbldocumenttype t on t.typeid = d.documenttypeid where d.signingBatchID = '{0}'", docId))
            Dim sd As New SignedDocumentInfo
            For Each row As DataRow In tblDoc.Rows
                sd.LeadDocumentID = row("lexxsigndocumentid").ToString
                sd.DocumentLeadEmail = row("signatoryemail").ToString
            Next
            Return sd
        End Function

        Public Shared Sub updateBrowserInfo(ByVal SigningBatchID As String, ByVal clientBrowserName As String, ByVal clientBrowserVersion As String, ByVal bJSEnabled As Boolean)
            Dim sqlUpdate As String = String.Format("update tbllexxsigndocs set SigningBrowserName = '{0}', SigningBrowserVersion='{1}',SigningBrowserJSEnabled='{2}' where SigningBatchID = '{3}'", clientBrowserName, clientBrowserVersion, bJSEnabled, SigningBatchID)
            SqlHelper.ExecuteScalar(sqlUpdate, CommandType.Text)
        End Sub

        Public Shared Sub updateCompletedDateBySigningBatchID(ByVal SigningBatchID As String, ByVal clientIPAddress As String, ByVal signTypeForAction As String, Optional ByVal CurrentStatus As String = "Document signed")
            SqlHelper.ExecuteScalar(String.Format("update tbllexxsigndocs set Completed = getdate(), currentstatus='{0}', SigningIPAddress='{1}' where SigningBatchID = '{2}'", CurrentStatus, clientIPAddress, SigningBatchID), CommandType.Text)

            Select Case signTypeForAction.ToLower
                Case "s"
                    ResolveClientApprovalMatter(SigningBatchID, True)
                Case Else
                    ResolveClientApprovalMatter(SigningBatchID, False)
            End Select
        End Sub

        Private Shared Function GetUniqueDocumentName2(ByVal rootDir As String, ByVal ClientID As Integer, ByVal strDocTypeID As String, ByVal UserID As Integer, Optional ByVal subFolder As String = "ClientDocs\") As String
            Dim ret As String
            Dim docID As String = SqlHelper.ExecuteScalar("SELECT [Value] FROM tblProperty WHERE [Name] = 'DocumentNumberPrefix'", CommandType.Text)
            docID += SqlHelper.ExecuteScalar("stp_GetDocumentNumber", CommandType.StoredProcedure)

            Dim aID As String = SqlHelper.ExecuteScalar(String.Format("SELECT AccountNumber FROM tblClient WHERE ClientID = {0}", ClientID), CommandType.Text)

            ret = String.Format("{0}{1}{2}_{3}_{4}_{5}.pdf", rootDir, subFolder, aID, strDocTypeID, docID, DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0"))

            Return ret
        End Function

        Private Shared Sub InsertAfterSigningTask(ByVal matterid As Integer, ByVal TaskTypeId As Integer, ByVal ParentTaskID As Integer, ByVal Description As String, ByVal due As String, ByVal userid As Integer)
            Dim sqlInsert As String = "stp_workflow_insertTask"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("TaskTypeId", TaskTypeId))
            params.Add(New SqlParameter("ParentTaskID", ParentTaskID))
            params.Add(New SqlParameter("Description", Description))
            params.Add(New SqlParameter("Due", due))
            params.Add(New SqlParameter("userID", userid))
            params.Add(New SqlParameter("matterid", matterid))
            SqlHelper.ExecuteNonQuery(sqlInsert, CommandType.StoredProcedure, params.ToArray)
        End Sub

        Private Shared Sub ResolveSigningTask(ByVal TaskID As Integer, ByVal _UserId As Integer)
            Dim sqlResolve As String = "stp_workflow_resolveTask"
            Dim params As New List(Of SqlParameter)
            params.Add(New SqlParameter("taskid", TaskID))
            params.Add(New SqlParameter("userid", _UserId))
            params.Add(New SqlParameter("taskresolutionid", 1))
            SqlHelper.ExecuteNonQuery(sqlResolve, CommandType.StoredProcedure, params.ToArray)
        End Sub

#End Region 'Methods

    End Class

    Public Class SignatureImage

        #Region "Fields"

        Private _ImageContainer As String
        Private _ImageDocNumber As Integer
        Private _ImageExists As Boolean
        Private _ImagePageNumber As Integer
        Private _ImagePath As String
        Private _LegalMessage As String
        Private _SignatureType As String

        #End Region 'Fields

        #Region "Properties"

        Public Property ImageContainerID() As String
            Get
                Return _ImageContainer
            End Get
            Set(ByVal value As String)
                _ImageContainer = value
            End Set
        End Property

        Public Property ImageDocNumber() As Integer
            Get
                Return _ImageDocNumber
            End Get
            Set(ByVal value As Integer)
                _ImageDocNumber = value
            End Set
        End Property

        Public Property ImageExists() As Boolean
            Get
                Return _ImageExists
            End Get
            Set(ByVal value As Boolean)
                _ImageExists = value
            End Set
        End Property

        Public Property ImagePageNumber() As Integer
            Get
                Return _ImagePageNumber
            End Get
            Set(ByVal value As Integer)
                _ImagePageNumber = value
            End Set
        End Property

        Public Property ImagePath() As String
            Get
                Return _ImagePath
            End Get
            Set(ByVal value As String)
                _ImagePath = value
            End Set
        End Property

        Public Property LegalMessage() As String
            Get
                Return _LegalMessage
            End Get
            Set(ByVal value As String)
                _LegalMessage = value
            End Set
        End Property

        Public Property SignatureType() As String
            Get
                Return _SignatureType
            End Get
            Set(ByVal value As String)
                _SignatureType = value
            End Set
        End Property

        #End Region 'Properties

    End Class

    Public Class SignatureObj

        #Region "Fields"

        Private _DocNumber As Integer
        Private _PageNum As Integer
        Private _SigPerson As enumSignaturePerson
        Private _SigType As enumSignatureType

        #End Region 'Fields

        #Region "Properties"

        Public Property DocNumber() As Integer
            Get
                Return _DocNumber
            End Get
            Set(ByVal value As Integer)
                _DocNumber = value
            End Set
        End Property

        Public Property PageNumber() As Integer
            Get
                Return _PageNum
            End Get
            Set(ByVal value As Integer)
                _PageNum = value
            End Set
        End Property

        Public Property SigPerson() As enumSignaturePerson
            Get
                Return _SigPerson
            End Get
            Set(ByVal value As enumSignaturePerson)
                _SigPerson = value
            End Set
        End Property

        Public Property SigType() As enumSignatureType
            Get
                Return _SigType
            End Get
            Set(ByVal value As enumSignatureType)
                _SigType = value
            End Set
        End Property

        #End Region 'Properties

        #Region "Methods"

        Public Overrides Function ToString() As String
            Return String.Format("'{0}';'{1}';'{2}';'{3}'", DocNumber, PageNumber, SigPerson.ToString, SigType)
        End Function

        #End Region 'Methods

    End Class

    #End Region 'Nested Types

End Class