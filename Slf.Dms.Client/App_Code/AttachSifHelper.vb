Imports System
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports System.Runtime.InteropServices

Imports AttachSifHelper

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions.AsyncDB

Imports iTextSharp.text
Imports iTextSharp.text.pdf

Public Class AttachSifHelper

    #Region "Enumerations"

    Public Enum ShowGUI_Enum
        ShowUploadSuccess = 0
        ShowClientsFound = 1
        ResetGUI = 2
    End Enum

    #End Region 'Enumerations

#Region "Methods"
    Public Shared Function GetSettlementAmount(ByVal settlementid As Integer) As Double
        Return SqlHelper.ExecuteScalar(String.Format("select settlementamount from tblsettlements where settlementid = {0}", settlementid), CommandType.Text)
    End Function

    Public Shared Function GetSettlementInfo(ByVal settlementid As Integer) As _AttachSettlementInfo
        Dim ssql As New StringBuilder
        ssql.Append("SELECT s.SettlementID, s.ClientID, p.FirstName + ' ' + p.LastName AS ClientName, c.AccountNumber, s.CreditorAccountID, ")
        ssql.Append("ci.CreditorID,isnull(s.ispaymentarrangement,0)[ispaymentarrangement],isnull(s.isclientstipulation,0)[isclientstipulation], s.settlementduedate, s.matterid ")
        ssql.Append(",[IsShortage]=case when isnull(s.SettlementAmount,0) > isnull(c.AvailableSDA,0) then 1 else 0 end , s.settlementamount, ci.accountnumber ")
        ssql.Append("FROM tblPerson AS p INNER JOIN tblClient AS c ON p.PersonID = c.PrimaryPersonID INNER JOIN ")
        ssql.Append("tblSettlements AS s ON c.ClientID = s.ClientID INNER JOIN tblAccount AS a ON s.CreditorAccountID = a.AccountID INNER JOIN ")
        ssql.Append("tblCreditorInstance AS ci ON a.CurrentCreditorInstanceID = ci.CreditorInstanceID ")
        ssql.Append("left join tblsettlements_overs as so with(nolock) on s.settlementid = so.settlementid ")
        ssql.AppendFormat("WHERE (s.settlementid = {0})", settlementid)

        Using si As New _AttachSettlementInfo
            Using dt As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(ssql.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
                For Each row As DataRow In dt.Rows
                    si.SettlementID = row("SettlementID").ToString
                    si.SettlementClientID = row("ClientID").ToString
                    si.SettlementClientName = row("ClientName").ToString
                    si.SettlementClientSDAAccountNumber = row("AccountNumber").ToString
                    si.SettlementCreditorAccountID = row("CreditorAccountID").ToString
                    si.SettlementCreditorID = row("CreditorID").ToString
                    si.IsPaymentArrangement = row("ispaymentarrangement").ToString
                    si.IsClientStipulation = row("isclientstipulation").ToString
                    si.SettlementDueDate = row("SettlementDueDate").ToString
                    si.SettlementMatterID = row("MatterID").ToString
                    si.IsShortage = row("IsShortage").ToString
                    si.SettlementAmount = row("settlementamount").ToString
                    si.SettlementCreditorAccountNumber = row("accountnumber").ToString
                    si.SettlementDocuments = New List(Of SettlementDocumentObject)
                    Exit For
                Next
            End Using
            Return si
        End Using
    End Function

    Private Shared Sub CreateDocumentDragPanel(ByVal index As Integer, ByVal ig As Web.UI.WebControls.Image, ByVal tab As TabPanel)
        Dim pnl As New Panel
        pnl.GroupingText = "2.  Click & drag document"
        pnl.ScrollBars = ScrollBars.Vertical
        pnl.ID = "pnlImage_" & index
        pnl.Controls.Add(ig)
        tab.Controls.Add(pnl)
        tab.ID = "SifTab" & index
        tab.HeaderText = "Document #" & index + 1
        tab.ToolTip = "Left click & hold on document to start drag operation"
    End Sub
    Private Shared Function CreateDocumentTypePanel(ByVal index As Integer) As Panel
        Dim pnlDoc As New Panel
        pnlDoc.GroupingText = "1.  Select document type"
        pnlDoc.Style("padding") = "3px"
        'create doc type ddl
        Dim ddl As New DropDownList
        ddl.ID = String.Format("ddlDocType{0}", index)
        ddl.ToolTip = "What type of document are you adding? (ie SIF, Client Stipulation)"
        ddl.CssClass = "entry"
        ddl.Items.Add(New Web.UI.WebControls.ListItem("Settlement In Full", "D6011"))
        ddl.Items.Add(New Web.UI.WebControls.ListItem("Client Stipulation", "D9012"))
        'ddl.Items.Add(New Web.UI.WebControls.ListItem("Payment Arrangement", "D9013"))
        pnlDoc.Controls.Add(ddl)
        Return pnlDoc
    End Function
    Private Shared Function CreateZoomPanel(ByVal index As Integer) As Panel
        Dim pnlDoc As New Panel
        pnlDoc.GroupingText = "Document Zoom"
        pnlDoc.Style("padding") = "3px"
        Dim tbl As New HtmlTable
        tbl.Attributes("class") = "entry2"

        Dim tr As New HtmlTableRow
        Dim td As HtmlTableCell = Nothing

        'display zoom value
        Dim lbl As New Label
        lbl.ID = String.Format("lblZoomVal_{0}", index)


        'minus zoom button
        td = New HtmlTableCell
        td.Width = 20
        td.Align = "center"
        td.VAlign = "middle"
        td.Style("font-size") = "20px"
        td.Style("font-weight") = "bold"

        td.Attributes.Add("onclick", String.Format("Zoom(-5,'{0}');", index))
        td.Attributes.Add("onmouseover", "this.style.cursor='hand';this.style.backgroundColor='#C6DEF2';")
        td.Attributes.Add("onmouseout", "this.style.cursor='';this.style.backgroundColor='';")
        td.InnerHtml = "-"
        tr.Cells.Add(td)

        'zoom slider
        td = New HtmlTableCell
        td.Align = "center"
        td.VAlign = "middle"
        Dim txt As New TextBox
        txt.ID = String.Format("txtZoom_{0}", index)
        txt.Attributes.Add("onchange", String.Format("SlideZoom('{0}');", index))

        td.Controls.Add(txt)
        Dim slider As New AjaxControlToolkit.SliderExtender
        slider.BehaviorID = String.Format("Slider_{0}", index)
        slider.TargetControlID = txt.ID
        slider.BoundControlID = lbl.ID
        slider.EnableHandleAnimation = True
        slider.Minimum = 100
        slider.Maximum = 200
        slider.TooltipText = "Zoom %: {0}. Please slide to change value."
        slider.Length = 300

        td.Controls.Add(slider)
        tr.Cells.Add(td)

        'plus zoom button
        td = New HtmlTableCell
        td.Width = 20
        td.Align = "center"
        td.VAlign = "middle"
        td.Attributes.Add("onclick", String.Format("Zoom(5,'{0}');", index))
        td.Attributes.Add("onmouseover", "this.style.cursor='hand';this.style.backgroundColor='#C6DEF2';")
        td.Attributes.Add("onmouseout", "this.style.cursor='';this.style.backgroundColor='';")
        td.Style("font-size") = "20px"
        td.Style("font-weight") = "bold"
        td.InnerHtml = "+"
        tr.Cells.Add(td)


        'add display label
        td = New HtmlTableCell
        td.Width = 25
        td.Align = "right"
        td.Controls.Add(lbl)
        tr.Cells.Add(td)

        td = New HtmlTableCell
        td.InnerHtml = "%"
        td.Align = "left"
        tr.Cells.Add(td)

        tbl.Rows.Add(tr)
        pnlDoc.Controls.Add(tbl)
        Return pnlDoc
    End Function
    
    Public Shared Function ProcessAttachment(ByVal AttachmentFilePath As String) As Control
        If AttachmentFilePath.ToString = "" Then Return Nothing
        Dim fName As String = Path.GetFileNameWithoutExtension(AttachmentFilePath)
        Dim tabs As New TabContainer
        tabs.ID = "tabSifDocuments"
        tabs.Style("width") = "100%"
        tabs.CssClass = "tabContainer"

        Dim sifFolder As String = System.Configuration.ConfigurationManager.AppSettings("SifDirectory")
        If Directory.Exists(sifFolder & "\" & System.Web.HttpContext.Current.Session.SessionID) = False Then
            Directory.CreateDirectory(sifFolder & "\" & System.Web.HttpContext.Current.Session.SessionID)
        End If
        sifFolder += "\" & System.Web.HttpContext.Current.Session.SessionID & "\"

        Select Case Path.GetExtension(AttachmentFilePath).ToLower
            Case ".pdf"
                Dim upPdfDoc As iTextSharp.text.pdf.PdfReader = Nothing
                Try
                    upPdfDoc = New iTextSharp.text.pdf.PdfReader(AttachmentFilePath)
                    For index As Integer = 1 To upPdfDoc.NumberOfPages
                        Dim sFileName As String = sifFolder & fName & "_SIF_" & index & ".jpg"
                        If Not File.Exists(sFileName) Then
                            ghostScriptHelper.Convert(AttachmentFilePath, sFileName, index, index)
                        End If
                        Dim ig As New Web.UI.WebControls.Image
                        'ig.ImageUrl = LocalHelper.GetVirtualDocFullPath(sFileName)
                        'added 3/19/2019
                        Dim link As String = LocalHelper.GetVirtualDocFullPath(sFileName)
                        link = link.Replace("site/", "").Replace("wwwroot/", "").Replace("home/", "")
                        ig.ImageUrl = link

                        ig.ID = String.Format("img_sif_{0}", index)
                        ig.Width = New Unit(500)
                        'create new tab
                        Using tab As New TabPanel
                            'create document type ddl
                            Dim pnlDoc As Panel = CreateDocumentTypePanel(index)
                            tab.Controls.Add(pnlDoc)

                            'add zoom panel
                            Dim pnlZoom As Panel = CreateZoomPanel(index)
                            tab.Controls.Add(pnlZoom)

                            'create drag panel
                            CreateDocumentDragPanel(index, ig, tab)
                            tabs.Tabs.Add(tab)
                        End Using
                    Next
                Catch ioex As IOException
                    Throw New Exception("There was an unspecified IO error converting the pdf.  <br>Please try converting to tif first then uploading.")
                End Try


            Case ".tif"
                Dim tiff As New TiffImage(AttachmentFilePath)

                Dim totalPages As Integer = tiff.PageCount - 1
                For index As Integer = 0 To totalPages
                    Dim sFileName As String = sifFolder & fName & "_SIF_" & index & ".jpg"
                    If Not File.Exists(sFileName) Then
                        'save image
                        Dim img As System.Drawing.Image = tiff.GetSpecificPage(index)
                        Dim Info As System.Drawing.Imaging.ImageCodecInfo() = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders()
                        Dim Params As New System.Drawing.Imaging.EncoderParameters(1)
                        Params.Param(0) = New EncoderParameter(Encoder.Quality, 100L)
                        img.Save(sFileName, Info(1), Params)
                    End If
                    Dim ig As New Web.UI.WebControls.Image
                    ig.ImageUrl = LocalHelper.GetVirtualDocFullPath(sFileName)
                    'ig.ImageUrl = sFileName
                    ig.ID = String.Format("img_sif_{0}", index)
                    ig.Width = New Unit(500)
                    'create new tab
                    Using tab As New TabPanel
                        'create document type ddl
                        Dim pnlDoc As Panel = CreateDocumentTypePanel(index)
                        tab.Controls.Add(pnlDoc)

                        'add zoom panel
                        Dim pnlZoom As Panel = CreateZoomPanel(index)
                        tab.Controls.Add(pnlZoom)

                        'create drag panel
                        CreateDocumentDragPanel(index, ig, tab)
                        tabs.Tabs.Add(tab)
                    End Using
                Next index

        End Select

        Return tabs
    End Function

    Public Shared Sub SaveOverride(ByVal settlementID As String, ByVal OverrideSelectedAccountID As String, ByVal fieldName As String, ByVal realValue As String, ByVal entereValue As String, ByVal currentUserID As Integer)
        Dim myparams As New List(Of SqlParameter)
        myparams.Add(New SqlParameter("SettlementID", settlementID))
        myparams.Add(New SqlParameter("OverrideAccountID", OverrideSelectedAccountID))
        myparams.Add(New SqlParameter("FieldName", fieldName))
        myparams.Add(New SqlParameter("RealValue", realValue))
        myparams.Add(New SqlParameter("EnteredValue", entereValue))
        myparams.Add(New SqlParameter("CreatedBy", currentUserID))
        SqlHelper.ExecuteNonQuery("stp_settlements_insertOverride", CommandType.StoredProcedure, myparams.ToArray)
    End Sub

    Public Shared Sub SaveSpecialInstructions(ByVal settlementID As Double, ByVal specialinstructions As String, ByVal createdUserID As Integer)
        Dim sqlInsert As New StringBuilder
        sqlInsert.Append("INSERT INTO [tblSettlements_SpecialInstructions]([SettlementID],[SpecialInstructions],[Created],[CreatedBy]) ")
        sqlInsert.AppendFormat("VALUES({0},'{1}',getdate(),{2})", settlementID, specialinstructions, createdUserID)
        SharedFunctions.AsyncDB.executeScalar(sqlInsert.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
    End Sub
    Public Shared Sub UpdateSettlementPayTo(ByVal settlementID As Integer, ByVal payTo As String, Optional ByVal CurrentUserID As Integer = -1)
        Dim ssql As String = String.Format("update tblSettlements_DeliveryAddresses set PayableTo='{0}', Lastmodified=getdate(), LastmodifiedBy = {1} where SettlementID = {2}", payTo, CurrentUserID, settlementID)
        SqlHelper.ExecuteNonQuery(ssql, CommandType.Text)
    End Sub

    Public Shared Function createPDF(ByVal imgFilePath As String) As String
        'create pdf doc
        Dim pdfFilePath As String = ""
        Dim document As iTextSharp.text.Document = Nothing
        Dim writer As PdfWriter = Nothing
        Dim cb As PdfContentByte = Nothing

        Try
            document = New iTextSharp.text.Document(PageSize.A4, 50, 50, 50, 50)
            pdfFilePath = imgFilePath.Replace(".jpg", ".pdf")
            writer = PdfWriter.GetInstance(document, New FileStream(pdfFilePath, FileMode.Create))
            document.Open()
            cb = writer.DirectContent

            Dim img As System.Drawing.Image = System.Drawing.Image.FromFile(imgFilePath.Replace("%20", " ").Replace("/", "\").Replace("file:", ""))
            Dim textImg As iTextSharp.text.Image = iTextSharp.text.Image.GetInstance(img, Imaging.ImageFormat.Jpeg)
            'textImg.ScalePercent(85.0F)

            textImg.SetAbsolutePosition(0, 0)
            cb.AddImage(textImg)
            document.NewPage()
            img.Dispose()

            'close pdf doc
            document.Close()
        Catch ex As Exception
            Throw New Exception(String.Format("Attach SIF - createPDF ERROR : {0}", ex.Message))
        Finally
            cb = Nothing
            writer = Nothing
            document = Nothing
            GC.Collect()
        End Try

        Return pdfFilePath
    End Function

#End Region 'Methods

    #Region "Nested Types"

    <Serializable> _
    Public Structure AttachItem

        #Region "Fields"

        Public _DropObject As List(Of String)
        Public _SourceObject As String

        #End Region 'Fields

        #Region "Constructors"

        Sub New(ByVal DragObject As String, ByVal DropObject As List(Of String))
            Me._SourceObject = DragObject
            Me._DropObject = DropObject
        End Sub

        #End Region 'Constructors

    End Structure

    ''' <summary>
    ''' used for js 
    ''' </summary>
    ''' <remarks></remarks>
    Public Structure SettlementInfo
        Implements IDisposable

        #Region "Fields"

        Public SettlementClientID As String
        Public SettlementClientName As String
        Public SettlementClientSDAAccountNumber As String
        Public SettlementCreditorAccountID As String
        Public SettlementCreditorID As String
        Public SettlementID As String

        #End Region 'Fields

        #Region "Methods"

        Public Sub Dispose() Implements System.IDisposable.Dispose
        End Sub

        #End Region 'Methods

    End Structure

    <Serializable> _
    Public Class AttachSIFResult

        #Region "Fields"

        Private _ClientName As String
        Private _CreditorName As String
        Private _NumDocumentsAttached As Integer
        Private _SAFPath As String
        Private _SIFPath As String
        Private _SpecialInstructions As String

        #End Region 'Fields

        #Region "Properties"

        Public Property ClientName() As String
            Get
                Return _ClientName
            End Get
            Set(ByVal value As String)
                _ClientName = value
            End Set
        End Property

        Public Property CreditorName() As String
            Get
                Return _CreditorName
            End Get
            Set(ByVal value As String)
                _CreditorName = value
            End Set
        End Property

        Public Property DocumentsAttachedCount() As Integer
            Get
                Return _NumDocumentsAttached
            End Get
            Set(ByVal value As Integer)
                _NumDocumentsAttached = value
            End Set
        End Property

        Public Property SAFPath() As String
            Get
                Return _SAFPath
            End Get
            Set(ByVal value As String)
                _SAFPath = value
            End Set
        End Property

        Public Property SIFPath() As String
            Get
                Return _SIFPath
            End Get
            Set(ByVal value As String)
                _SIFPath = value
            End Set
        End Property

        Public Property SpecialInstructions() As String
            Get
                Return _SpecialInstructions
            End Get
            Set(ByVal value As String)
                _SpecialInstructions = value
            End Set
        End Property

        #End Region 'Properties

    End Class

    <Serializable> _
    Public Class SettlementDocumentObject

        #Region "Fields"

        Private _documentPath As String
        Private _documentType As String

        #End Region 'Fields

        #Region "Constructors"

        Sub New(ByVal docType As String, ByVal docPath As String)
            _documentType = docType
            _documentPath = docPath
        End Sub

        #End Region 'Constructors

        #Region "Properties"

        Public Property DocumentPath() As String
            Get
                Return _documentPath
            End Get
            Set(ByVal value As String)
                _documentPath = value
            End Set
        End Property

        Public Property DocumentType() As String
            Get
                Return _documentType
            End Get
            Set(ByVal value As String)
                _documentType = value
            End Set
        End Property

        #End Region 'Properties

    End Class

    Public Class TiffImage

        #Region "Fields"

        Private _fileName As String
        Private _tiffImage As System.Drawing.Image = Nothing

        #End Region 'Fields

        #Region "Constructors"

        Public Sub New(ByVal fileName As String)
            _fileName = fileName
        End Sub

        Public Sub New(ByVal tiffImage As System.Drawing.Image)
            _tiffImage = tiffImage
        End Sub

        #End Region 'Constructors

        #Region "Properties"

        Public ReadOnly Property FileName() As String
            Get
                Return _fileName
            End Get
        End Property

        Public ReadOnly Property PageCount() As Integer
            Get
                If File.Exists(FileName) Then
                    Dim image As System.Drawing.Image
                    If Me._tiffImage Is Nothing Then
                        ' Get the frame dimension list from the image of the file and
                        image = Drawing.Image.FromFile(FileName)
                    Else
                        image = Me._tiffImage
                    End If

                    ' Get the globally unique identifier (GUID)
                    Dim objGuid As Guid = image.FrameDimensionsList(0)

                    ' Create the frame dimension
                    Dim frameDimension As New FrameDimension(objGuid)

                    'Gets the total number of frames in the .tiff file
                    Return image.GetFrameCount(frameDimension)
                Else
                    Return 0
                End If
            End Get
        End Property

        Public ReadOnly Property TiffImage() As System.Drawing.Image
            Get
                Return _tiffImage
            End Get
        End Property

        #End Region 'Properties

        #Region "Methods"

        ' Return the memory stream of a specific page
        Public Function GetSpecificPage(ByVal pageNumber As Integer) As System.Drawing.Image
            Dim image As System.Drawing.Image
            If Me._tiffImage Is Nothing Then
                ' Get the frame dimension list from the image of the file and
                image = System.Drawing.Image.FromFile(FileName)
            Else
                image = Me._tiffImage
            End If

            Using ms As New MemoryStream()
                Dim objGuid As Guid = image.FrameDimensionsList(0)

                Dim objDimension As New FrameDimension(objGuid)

                image.SelectActiveFrame(objDimension, pageNumber)

                image.Save(ms, ImageFormat.Bmp)

                Dim retImage As System.Drawing.Image = System.Drawing.Image.FromStream(ms)

                ' Get the source bitmap.
                Dim bm_source As New Drawing.Bitmap(retImage)

                ' Make a bitmap for the result.
                Dim bm_dest As New Drawing.Bitmap(800, 1000, Imaging.PixelFormat.Format32bppPArgb)
                bm_dest.SetResolution(600, 600)

                ' Make a Graphics object for the result Bitmap.
                Dim gr_dest As Drawing.Graphics = Drawing.Graphics.FromImage(bm_dest)

                ' Copy the source image into the destination bitmap.
                gr_dest.DrawImage(bm_source, 0, 0, bm_dest.Width + 1, bm_dest.Height + 1)

                Return bm_dest

                'Return retImage
            End Using
        End Function

        #End Region 'Methods

    End Class

    <Serializable> _
    Public Class _AttachSettlementInfo
        Implements IDisposable

        #Region "Fields"

        Private _OverrideReason As String
        Private _PayableTo As String
        Private _PaymentArrangementInitialPaymentAmt As String
        Private _PaymentArrangementInitialPaymentDate As String
        Private _PaymentArrangementMonthlyInstallmentAmt As String
        Private _PaymentArrangementNumberInstallments As Integer
        Private _SettlementClientID As String
        Private _SettlementClientName As String
        Private _SettlementClientSDAAccountNumber As String
        Private _SettlementCreditorAccountID As String
        Private _SettlementCreditorID As String
        Private _SettlementDocuments As List(Of SettlementDocumentObject)
        Private _SettlementID As String
        Private _SpecialInstructions As String
        Private _bIsClientStipulation As Boolean
        Private _bIsPaymentArrangement As Boolean
        Private _settdue As String
        Private _matterid As String
        Private _bIsShortage As Boolean
        Private _SettlementAmount As String
        Private _SettlementCreditorAccountNumber As String
        Private disposedValue As Boolean = False 'To detect redundant calls

        #End Region 'Fields

        #Region "Constructors"

        Sub New()
        End Sub

        Sub New(ByVal SettlementID As String, ByVal SettlementClientID As String, ByVal SettlementClientSDAAccountNumber As String, ByVal SettlementCreditorAccountID As String, ByVal SettlementCreditorID As String, ByVal SettlementClientName As String, ByVal SettlementDocuments As List(Of SettlementDocumentObject))
            _SettlementID = SettlementID
            _SettlementClientID = SettlementClientID
            _SettlementClientSDAAccountNumber = SettlementClientSDAAccountNumber
            _SettlementCreditorAccountID = SettlementCreditorAccountID
            _SettlementCreditorID = SettlementCreditorID
            _SettlementClientName = SettlementClientName
            _SettlementDocuments = SettlementDocuments
        End Sub

        #End Region 'Constructors

        #Region "Properties"

        Public Property IsShortage() As Boolean
            Get
                Return _bIsShortage
            End Get
            Set(ByVal value As Boolean)
                _bIsShortage = value
            End Set
        End Property
        Public Property IsClientStipulation() As Boolean
            Get
                Return _bIsClientStipulation
            End Get
            Set(ByVal value As Boolean)
                _bIsClientStipulation = value
            End Set
        End Property

        Public Property IsPaymentArrangement() As Boolean
            Get
                Return _bIsPaymentArrangement
            End Get
            Set(ByVal value As Boolean)
                _bIsPaymentArrangement = value
            End Set
        End Property

        Public Property SettlementAmount() As String
            Get
                Return _SettlementAmount
            End Get
            Set(ByVal value As String)
                _SettlementAmount = value
            End Set
        End Property
        Public Property SettlementMatterID() As String
            Get
                Return _matterid
            End Get
            Set(ByVal value As String)
                _matterid = value
            End Set
        End Property
        Public Property OverrideReason() As String
            Get
                Return _OverrideReason
            End Get
            Set(ByVal value As String)
                _OverrideReason = value
            End Set
        End Property

        Public Property PayableTo() As String
            Get
                Return _PayableTo
            End Get
            Set(ByVal value As String)
                _PayableTo = value
            End Set
        End Property

        Public Property PaymentArrangementInitialPaymentAmt() As String
            Get
                Return _PaymentArrangementInitialPaymentAmt
            End Get
            Set(ByVal value As String)
                _PaymentArrangementInitialPaymentAmt = value
            End Set
        End Property

        Public Property PaymentArrangementInitialPaymentDate() As String
            Get
                Return _PaymentArrangementInitialPaymentDate
            End Get
            Set(ByVal value As String)
                _PaymentArrangementInitialPaymentDate = value
            End Set
        End Property

        Public Property PaymentArrangementMonthlyInstallmentAmt() As String
            Get
                Return _PaymentArrangementMonthlyInstallmentAmt
            End Get
            Set(ByVal value As String)
                _PaymentArrangementMonthlyInstallmentAmt = value
            End Set
        End Property

        Public Property PaymentArrangementNumberInstallments() As Integer
            Get
                Return _PaymentArrangementNumberInstallments
            End Get
            Set(ByVal value As Integer)
                _PaymentArrangementNumberInstallments = value
            End Set
        End Property

        Public Property SettlementDueDate() As String
            Get
                Return _settdue
            End Get
            Set(ByVal value As String)
                _settdue = value
            End Set
        End Property
        Public Property SettlementClientID() As String
            Get
                Return _SettlementClientID
            End Get
            Set(ByVal value As String)
                _SettlementClientID = value
            End Set
        End Property

        Public Property SettlementClientName() As String
            Get
                Return _SettlementClientName
            End Get
            Set(ByVal value As String)
                _SettlementClientName = value
            End Set
        End Property

        Public Property SettlementClientSDAAccountNumber() As String
            Get
                Return _SettlementClientSDAAccountNumber
            End Get
            Set(ByVal value As String)
                _SettlementClientSDAAccountNumber = value
            End Set
        End Property

        Public Property SettlementCreditorAccountID() As String
            Get
                Return _SettlementCreditorAccountID
            End Get
            Set(ByVal value As String)
                _SettlementCreditorAccountID = value
            End Set
        End Property

        Public Property SettlementCreditorID() As String
            Get
                Return _SettlementCreditorID
            End Get
            Set(ByVal value As String)
                _SettlementCreditorID = value
            End Set
        End Property

        Public Property SettlementDocuments() As List(Of SettlementDocumentObject)
            Get
                Return _SettlementDocuments
            End Get
            Set(ByVal value As List(Of SettlementDocumentObject))
                _SettlementDocuments = value
            End Set
        End Property

        Public Property SettlementID() As String
            Get
                Return _SettlementID
            End Get
            Set(ByVal value As String)
                _SettlementID = value
            End Set
        End Property

        Public Property SettlementCreditorAccountNumber() As String
            Get
                Return _SettlementCreditorAccountNumber
            End Get
            Set(ByVal value As String)
                _SettlementCreditorAccountNumber = value
            End Set
        End Property
        Public Property SpecialInstructions() As String
            Get
                Return _SpecialInstructions
            End Get
            Set(ByVal value As String)
                _SpecialInstructions = value
            End Set
        End Property

        #End Region 'Properties

        #Region "Methods"

        ' This code added by Visual Basic to correctly implement the disposable pattern.
        Public Sub Dispose() Implements IDisposable.Dispose
            ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(True)
            GC.SuppressFinalize(Me)
        End Sub

        ' IDisposable
        Protected Overridable Sub Dispose(ByVal disposing As Boolean)
            If Not Me.disposedValue Then
                If disposing Then
                    ' TODO: free other state (managed objects).
                End If

                ' TODO: free your own state (unmanaged objects).
                ' TODO: set large fields to null.
            End If
            Me.disposedValue = True
        End Sub

        #End Region 'Methods

    End Class

    Public Class acctPickerObj

        #Region "Fields"

        Private _checkboxID As String
        Private _tbl As String

        #End Region 'Fields

        #Region "Properties"

        Public Property CheckboxID() As String
            Get
                Return _checkboxID
            End Get
            Set(ByVal value As String)
                _checkboxID = value
            End Set
        End Property

        Public Property tableData() As String
            Get
                Return _tbl
            End Get
            Set(ByVal value As String)
                _tbl = value
            End Set
        End Property

        #End Region 'Properties

    End Class

    #End Region 'Nested Types

End Class