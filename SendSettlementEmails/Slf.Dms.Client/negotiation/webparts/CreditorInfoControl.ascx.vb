Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Linq

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Drg.Util.Helpers

Imports LexxiomWebPartsControls
Imports DataDynamics.ActiveReports.Export.Pdf
Imports System.IO

Partial Class negotiation_webparts_CreditorInfoControl
    Inherits System.Web.UI.UserControl

#Region "Fields"

    Public CreditorAccountID As String

#End Region 'Fields

#Region "Events"

    'Public bVerifiedAccount As Boolean = False
    ''' <summary>
    ''' event when a edit is complete
    ''' </summary>
    ''' <param name="EditClientID"></param>
    ''' <param name="EditCreditorAcctID"></param>
    ''' <remarks></remarks>
    Public Event EditComplete(ByVal EditClientID As String, ByVal EditCreditorAcctID As String)

    Public Event LoadCreditorFilter(ByVal CreditorName As String)

#End Region 'Events

#Region "Properties"

    Public Property CurrentCreditorName() As String
        Get
            Return hdnCurrentCreditorName.Value
        End Get
        Set(ByVal value As String)
            hdnCurrentCreditorName.Value = value
        End Set
    End Property

    Public Property IsNewLORNeeded() As Boolean
        Get
            Return ViewState("_bNeedNewLOR")
        End Get
        Set(ByVal value As Boolean)
            ViewState("_bNeedNewLOR") = value
        End Set
    End Property
    Public Property DataClientid() As String
        Get
            Return ViewState("_DataClientid")
        End Get
        Set(ByVal value As String)
            ViewState("_DataClientid") = value
        End Set
    End Property
    Public Property Userid() As Integer
        Get
            Return ViewState("_userid")
        End Get
        Set(ByVal value As Integer)
            ViewState("_userid") = value
        End Set
    End Property
    Public Property noteID() As String
        Get
            Return Me.hdnNoteID.Value
        End Get
        Set(ByVal value As String)
            Me.hdnNoteID.Value = value
        End Set
    End Property

#End Region 'Properties

#Region "Methods"

    ''' <summary>
    ''' Load the current creditor info for client
    ''' </summary>
    ''' <param name="accountID"></param>
    ''' <param name="dataClientID"></param>
    ''' <param name="bFilterAssignments"></param>
    ''' <remarks></remarks>
    Public Sub LoadCreditorInfo(ByVal accountID As String, ByVal dataClientID As String, Optional ByVal bFilterAssignments As Boolean = True)
        Me.hiddenIDs.Value = dataClientID & ":" & accountID
        Me.tblEdit.Style("display") = "block"
        Using dtCreditor As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(String.Format("stp_GetSettlementCreditorInfo {0}", accountID), System.Configuration.ConfigurationManager.AppSettings("connectionstring"))
            For Each dRow As Data.DataRow In dtCreditor.Rows
                ClearForm()
                Me.txtEditForCreditorName.Text = dRow("forcreditorname").ToString
                Me.txtEditCurrCreditorName.Text = dRow("creditorname").ToString
                Me.txtEditAcctNum.Text = dRow("accountnumber").ToString
                Me.ImgAcctNum.Attributes.Add("onclick", String.Format("window.top.parent.DialPadString('{0}');", dRow("accountnumber").ToString.Trim))
                Me.txtEditRefNum.Text = dRow("referencenumber").ToString
                Me.txtEditOrigAmt.Text = FormatCurrency(dRow("originalamount").ToString, 2)
                Me.txtEditCurrAmt.Text = FormatCurrency(dRow("currentamount").ToString, 2)
                Me.txtEditAcquired.Text = FormatDateTime(dRow("Acquired"), DateFormat.ShortDate)
                Me.CurrentCreditorName = dRow("creditorname").ToString
                Me.hdnCreditorInstanceID.Value = dRow("creditorinstanceID").ToString
                Me.hdnAcctID.Value = dRow("accountid").ToString
                Me.hdnforCreditorInfo.Value = dRow("ForCreditorID").ToString
                Me.hdnCurrCreditorInfo.Value = dRow("CreditorID").ToString

                GetOriginalCreditorID(Me.hdnAcctID.Value)
                If bFilterAssignments = True Then
                    RaiseEvent LoadCreditorFilter(dRow("creditorname").ToString)
                End If
                LoadContactData(dataClientID, accountID)
                LoadCreditorTrends(dRow("creditorname").ToString)

                Dim createdDate As String = DataHelper.FieldLookup("tblClient", "Created", String.Format("Clientid = {0}", dataClientID))
                Dim acctBal As String = 0
                'fix op 05/03/13
                If CDate(createdDate) < CDate("9/24/2010") Then
                    'Old clients
                    txtEditCurrAmt.BackColor = Drawing.ColorTranslator.FromHtml("#009900")
                    txtEditCurrAmt.ToolTip = "Using Current Balance for calculations."
                    ltrVerified.Text = ""
                Else
                    If dRow("verified") = 0 Then
                        txtEditOrigAmt.BackColor = Drawing.ColorTranslator.FromHtml("#009900")
                        txtEditOrigAmt.ToolTip = "Using Original Balance for calculations."
                        ltrVerified.Text = "<span class='unverifLabel'>(not verified)</span>"
                    Else
                        ltrVerified.Text = String.Format("<span class='verifLabel'>Verified: </span><span class='verifText verifHiLite' title='{1}'>{0:c}</span>", dRow("VerifiedAmount"), "Using Verified Original Balance for Calculations.")
                    End If
                End If


                SaveOldValues()
                Exit For
            Next
        End Using
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = Integer.Parse(Page.User.Identity.Name)
        If Not IsPostBack Then
            DataClientid = Request.QueryString("cid")
            CreditorAccountID = Request.QueryString("crid")
            If CreditorAccountID Is Nothing And DataClientid Is Nothing Then
                Me.ibtnUpdate.Enabled = False
                Exit Sub
            End If
            LoadCreditorInfo(CreditorAccountID, DataClientid, True)
            hdnDataClientID.Value = DataClientid

        End If
    End Sub

    Protected Sub gvTrends_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvTrends.RowDataBound
        Select Case e.Row.RowType
            Case DataControlRowType.DataRow
                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#D6E7F3';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '';")
        End Select
    End Sub

    Protected Sub ibtnUpdate_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibtnUpdate.Click
        Try
            Dim ids As String() = Me.hiddenIDs.Value.Split(":")

            UpdateCreditorContact()
            IsNewLORNeeded = False
            If Me.IsFormDirty Then
                UpdateCreditor()
                InsertAction(ids(0), ids(1))
                RaiseEvent EditComplete(ids(0), Me.hdnAcctID.Value)
                Me.LoadCreditorInfo(Me.hdnAcctID.Value, ids(0), True)

                If IsNewLORNeeded = True Then
                    'show new lor here
                    LoadForm("LOR", GenerateLORDocument(ids(1)))

                End If

            End If

            Me.tblEdit.Style("display") = "block"
        Catch ex As Exception

        End Try
    End Sub

    Private Sub ClearForm()
        Me.txtEditForCreditorName.Text = ""
        Me.txtEditCurrCreditorName.Text = ""
        Me.txtEditAcctNum.Text = ""
        Me.txtEditRefNum.Text = ""
        Me.txtEditOrigAmt.Text = ""
        Me.txtEditCurrAmt.Text = ""
        Me.txtEditAcquired.Text = ""

        Me.hdnCreditorInstanceID.Value = ""
        Me.hdnAcctID.Value = ""
        Me.hdnforCreditorInfo.Value = ""
        Me.hdnCurrCreditorInfo.Value = ""
    End Sub

    Private Function GetNewValues() As Dictionary(Of String, String)
        Dim dNew As New Dictionary(Of String, String)
        For Each c As Control In Me.tblEdit.Controls
            For Each r As Control In c.Controls
                Dim edits = From ctl As Control In r.Controls _
                      Where TypeOf ctl Is TextBox AndAlso ctl.ClientID.Contains("txtEdit") _
                      Select ctl
                If edits.Count() > 0 Then
                    For Each t As TextBox In edits
                        Dim cellID As String = t.ClientID
                        Dim lblName As String = cellID.Substring(cellID.LastIndexOf("_") + 1).Replace("txtEdit", "")
                        dNew.Add(lblName, DirectCast(t, TextBox).Text)
                    Next
                End If
            Next

        Next
        Return dNew
    End Function

    Private Function GetOldValues() As Dictionary(Of String, String)
        Return DirectCast(ViewState("CreditorInfoOldVal"), Dictionary(Of String, String))
    End Function

    Private Sub GetOriginalCreditorID(ByVal accountID As String)
        Me.hdnOriginalCreditorID.Value = AccountHelper.GetOriginalCreditorID(accountID)
    End Sub

    ''' <summary>
    ''' insert action to session log
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub InsertAction(ByVal sClientID As String, ByVal sCreditorAcctID As String)
        Dim strLogText As New StringBuilder
        Try
            'load old values
            Dim dOld As Dictionary(Of String, String) = GetOldValues()
            'load new values
            Dim dNew As Dictionary(Of String, String) = GetNewValues()

            'insert session note about offer
            Dim CreditorID As Integer = 0
            Dim CurrCreditorName As String = ""
            Dim OrigCreditorName As String = ""
            Dim CreditorAcctLast4 As String = ""
            Dim sqlNote As New StringBuilder
            sqlNote.AppendFormat("stp_NegotiationsSystemNoteInfo {0}", sCreditorAcctID)
            Using dtNote As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlNote.ToString, ConfigurationManager.AppSettings("connectionstring").ToString)
                For Each nt As DataRow In dtNote.Rows
                    CreditorID = CInt(nt("currcreditorid").ToString)
                    CurrCreditorName = nt("CurrentCreditorName").ToString
                    OrigCreditorName = nt("OriginalCreditorName").ToString
                    CreditorAcctLast4 = nt("CreditorAcctLast4").ToString
                    Exit For
                Next
            End Using
            strLogText.AppendFormat("{0}/{1} #{2},  Updated the following creditor account information:" & vbCrLf, OrigCreditorName, CurrCreditorName, CreditorAcctLast4)

            'compare
            For Each d As KeyValuePair(Of String, String) In dOld
                If dNew.Item(d.Key) <> d.Value Then
                    Dim fieldName As String = d.Key.ToString
                    fieldName = InsertSpaceAfterCap(fieldName)
                    strLogText.AppendFormat("Changed {0} from {1} to {2}" & vbCrLf, fieldName, d.Value, dNew.Item(d.Key))
                End If
            Next
        Catch ex As Exception
            Throw ex
        End Try

        If noteID.ToString = "" Then
            noteID = NoteHelper.InsertNote(strLogText.ToString, Session("userid"), sClientID)
        Else
            NoteHelper.AppendNote(noteID, strLogText.ToString, Session("userid"))
        End If
        NoteHelper.RelateNote(noteID, 2, sCreditorAcctID)
    End Sub

    Private Function InsertSpaceAfterCap(ByVal strToChange As String) As String
        If strToChange.Contains("CityStateZip") Then
            strToChange = strToChange.Replace("CityStateZip", "City,StateZip")
        End If

        Dim sChars() As Char = strToChange.ToCharArray()
        Dim strNew As String = ""

        For Each c As Char In sChars
            Select Case Asc(c)
                Case 65 To 95, 49 To 57   'upper caps or numbers
                    strNew += Space(1) & c.ToString
                Case 97 To 122  'lower caps
                    strNew += c.ToString
                Case Else
                    strNew += Space(1) & c.ToString
            End Select
        Next

        strNew = strNew.Replace("I D", "ID")
        Return strNew.Trim
    End Function

    ''' <summary>
    ''' check if text was changed
    ''' </summary>
    ''' <returns>boolean</returns>
    ''' <remarks></remarks>
    Private Function IsFormDirty() As Boolean
        Dim IsDirty As Boolean = False

        Try
            'load old values
            Dim dOld As Dictionary(Of String, String) = GetOldValues()

            'load new values
            Dim dNew As Dictionary(Of String, String) = GetNewValues()

            'compare
            For Each d As KeyValuePair(Of String, String) In dOld
                If dNew.Item(d.Key) <> d.Value Then
                    If d.Key = "CurrCreditorName" Then
                        IsNewLORNeeded = True
                    End If
                    IsDirty = True
                    Exit For
                End If
            Next

            Return IsDirty
        Catch ex As Exception
            Return False
        End Try
    End Function

    Private Sub LoadContactData(ByVal DataClientID As String, ByVal creditorAccoutID As String)
        Dim dtContact As DataTable = ContactInfoHelper.GetContactInfo(creditorAccoutID, ContactInfoHelper.ContactPhoneType.Telephone)
        Dim dRow As DataRow

        If Not dtContact Is Nothing Then
            If dtContact.Rows.Count = 1 Then
                dRow = dtContact.Rows(0)
                Me.txtEditFirst.Text = dRow("FirstName").ToString
                Me.txtEditLast.Text = dRow("LastName").ToString
                Me.txtEditEmail.Text = dRow("EmailAddress").ToString
                Me.txtEditArea.Text = dRow("AreaCode").ToString
                Me.txtEditNumber.Text = dRow("Number").ToString
                Me.txtEditExt.Text = dRow("Extension").ToString
                Me.imgCredPH.Attributes.Add("onclick", String.Format("make_call('{0}{1}');", dRow("AreaCode").ToString.Trim, dRow("Number").ToString.Trim))
                Me.imgCredExt.Attributes.Add("onclick", String.Format("window.top.parent.DialPadString('{0}');", dRow("Extension").ToString.Trim))
            End If
        End If

        dtContact = ContactInfoHelper.GetContactInfo(creditorAccoutID, ContactInfoHelper.ContactPhoneType.Fax)
        If Not dtContact Is Nothing Then
            If dtContact.Rows.Count = 1 Then
                dRow = dtContact.Rows(0)
                Me.txtEditFaxArea.Text = dRow("AreaCode").ToString
                Me.txtEditFax.Text = dRow("Number").ToString
            End If
        End If

        Me.ibtnUpdate.Enabled = True
    End Sub

    Private Sub LoadCreditorTrends(ByVal creditorName As String)
        dsTrends.SelectParameters("Creditorname").DefaultValue = creditorName
        dsTrends.DataBind()
        gvTrends.DataBind()
    End Sub

    Private Sub SaveOldValues()
        Dim dOld As New Dictionary(Of String, String)
        For Each c As Control In Me.tblEdit.Controls
            For Each r As Control In c.Controls
                For Each rc As Control In r.Controls
                    Dim edits = From ctl As Control In r.Controls _
                        Where TypeOf ctl Is TextBox Or TypeOf ctl Is Label AndAlso ctl.ClientID.Contains("txtEdit") _
                        Select ctl
                    If edits.Count() > 0 Then
                        For Each t As Control In edits
                            Dim cellID As String = t.ClientID
                            Dim lblName As String = cellID.Substring(cellID.LastIndexOf("_") + 1).Replace("txtEdit", "")
                            If dOld.Keys.Contains(lblName) = False Then
                                If TypeOf rc Is Label Then
                                    dOld.Add(lblName, DirectCast(rc, Label).Text)
                                ElseIf TypeOf rc Is TextBox Then
                                    dOld.Add(lblName, DirectCast(rc, TextBox).Text)
                                End If
                            End If

                        Next
                    End If
                Next
            Next
        Next
        ViewState("CreditorInfoOldVal") = dOld
    End Sub

    ''' <summary>
    ''' update creditor info
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub UpdateCreditor()
        Dim acctID As String = Me.hdnAcctID.Value
        Dim forCreditor As String() = Me.hdnforCreditorInfo.Value.Split("|")
        Dim currCreditor As String() = Me.hdnCurrCreditorInfo.Value.Split("|")
        Dim contactID As Integer = 0
        Dim phoneID As Integer = 0
        Dim CurrCreditorID As String
        Dim UserID As Integer = DataHelper.Nz_int(Page.User.Identity.Name)

        If currCreditor(0) = "-1" Then 'have to create a new creditor
            Dim CreditorGroupID As Integer = CInt(currCreditor(7))
            If CreditorGroupID = -1 Then
                CreditorGroupID = CreditorGroupHelper.InsertCreditorGroup(currCreditor(1), UserID)
            End If
            CurrCreditorID = CreditorHelper.InsertCreditor(currCreditor(1), currCreditor(2), currCreditor(3), currCreditor(4), Integer.Parse(currCreditor(5)), currCreditor(6), UserID, CreditorGroupID)
        Else
            CurrCreditorID = currCreditor(0)
        End If

        If Me.hdnOriginalCreditorID.Value = "" Then
            forCreditor(0) = "NULL"
        Else
            forCreditor(0) = Me.hdnOriginalCreditorID.Value
        End If

        ''insert new creditor instance
        Using cmd As New SqlCommand()
            cmd.Connection = New Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring"))

            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandText = "stp_Negotiation_InsertCreditorInstance"
            cmd.Parameters.Add(New SqlParameter("AccountID", acctID))
            cmd.Parameters.Add(New SqlParameter("CreditorID", CurrCreditorID))
            cmd.Parameters.Add(New SqlParameter("ForCreditorID", forCreditor(0)))
            cmd.Parameters.Add(New SqlParameter("Acquired", FormatDateTime(Me.txtEditAcquired.Text, DateFormat.ShortDate)))
            cmd.Parameters.Add(New SqlParameter("Amount", System.Double.Parse(Me.txtEditCurrAmt.Text, System.Globalization.NumberStyles.Currency)))
            cmd.Parameters.Add(New SqlParameter("OriginalAmount", System.Double.Parse(Me.txtEditOrigAmt.Text, System.Globalization.NumberStyles.Currency)))
            cmd.Parameters.Add(New SqlParameter("AccountNumber", Me.txtEditAcctNum.Text))
            cmd.Parameters.Add(New SqlParameter("ReferenceNumber", Me.txtEditRefNum.Text))
            cmd.Parameters.Add(New SqlParameter("UserID", Session("UserID")))
            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()

                Me.hdnAcctID.Value = acctID
            Finally
                cmd.Connection.Close()
                cmd.Connection.Dispose()
            End Try

        End Using
    End Sub

    Private Sub UpdateCreditorContact()
        Dim contactID As Integer = 0
        Dim phoneID As Integer = 0
        Dim IDs As String() = Me.hiddenIDs.Value.ToString.Split(":")

        'insert contact, insert instead of update to keep trail
        If Me.txtEditFirst.Text.ToString <> "" Or Me.txtEditLast.Text.ToString <> "" Then

            '1.17.09.ug:  Padding creditorid when it should be the accountid
            contactID = ContactHelper.InsertContact(IDs(1), Me.txtEditFirst.Text, Me.txtEditLast.Text, Me.txtEditEmail.Text, Session("UserID"), Me.noteID)

            If Me.txtEditArea.Text.ToString <> "" And Me.txtEditNumber.Text.ToString <> "" Then
                phoneID = PhoneHelper.InsertPhone(56, txtEditArea.Text, txtEditNumber.Text, txtEditExt.Text, Session("UserID"))
                ContactHelper.RelatePhoneToContact(contactID, phoneID, Session("UserID"))
            End If
            If Me.txtEditFaxArea.Text.ToString <> "" And Me.txtEditFax.Text.ToString <> "" Then
                phoneID = PhoneHelper.InsertPhone(57, txtEditFaxArea.Text, txtEditFax.Text, "", Session("UserID"))
                ContactHelper.RelatePhoneToContact(contactID, phoneID, Session("UserID"))
                Drg.Util.DataHelpers.CreditorPhoneHelper.Insert(IDs(1), phoneID, Session("UserID"))
            End If

        End If
    End Sub


#End Region 'Methods
    Private Function GenerateLORDocument(ByVal accountID As Integer) As String
        Dim creditorInstanceID As Integer = AccountHelper.GetCurrentCreditorInstanceID(accountID)
        Dim filePath As String = ""
        Dim tempName As String
        Dim strDocTypeName As String = "LetterOfRepresentation"
        Dim strDocID As String = ""
        Dim rootDir As String = ""
        Dim strCredName As String = ""
        Dim safFilePath As String = ""
        Try
            Using rptTemplates As New LexxiomLetterTemplates.LetterTemplates(System.Configuration.ConfigurationManager.AppSettings("ReportConnString").ToString)
                Dim currName As String = ""
                Dim origName As String = ""
                Dim acctLastFour As String = ""
                Dim numPagesInReport As Integer = 0
                Dim strLogText As New StringBuilder
                Dim sqlNote As String = "stp_NegotiationsSystemNoteInfo " & accountID
                Using dtNote As DataTable = SharedFunctions.AsyncDB.executeDataTableAsync(sqlNote, ConfigurationManager.AppSettings("connectionstring").ToString)
                    For Each dRow As DataRow In dtNote.Rows
                        currName = dRow("CurrentCreditorName").ToString
                        origName = dRow("OriginalCreditorName").ToString
                        acctLastFour = dRow("CreditorAcctLast4").ToString
                        Exit For
                    Next
                End Using

                Using report As New DataDynamics.ActiveReports.ActiveReport3

                    Dim pdf As New PdfExport()
                    Dim rptDoc As DataDynamics.ActiveReports.Document.Document = Nothing

                    strDocID = rptTemplates.GetDocTypeID(strDocTypeName)
                    rootDir = SharedFunctions.DocumentAttachment.CreateDirForClient(DataClientid)
                    strCredName = AccountHelper.GetCreditorName(accountID)

                    tempName = strCredName
                    tempName = tempName.Replace("*", "").Replace(".", "").Replace("""", "").Replace("'", "").Replace("[", "").Replace("]", "").Replace("{", "").Replace("}", "").Replace(":", "").Replace(";", "").Replace("|", "").Replace("=", "").Replace(" ", "_").Replace("/", "_").Replace("*", "").Replace("&", "").Trim()
                    filePath = CreateNewDocumentPathAndName(rootDir, DataClientid, strDocID, "CreditorDocs\" & accountID & "_" & tempName & "\")
                    If Directory.Exists(rootDir & "CreditorDocs\" & accountID & "_" & tempName & "\") = False Then
                        Directory.CreateDirectory(rootDir & "CreditorDocs\" & accountID & "_" & tempName & "\")
                    End If

                    Dim rArgs As String = "LetterOfRepresentation," & creditorInstanceID
                    Dim args As String() = rArgs.Split(",")
                    rptDoc = rptTemplates.ViewTemplate("LetterOfRepresentation", DataClientid, args, False, Userid, Path.GetFileNameWithoutExtension(filePath).Split("_")(2))
                    report.Document.Pages.AddRange(rptDoc.Pages)    'add pages to report

                    numPagesInReport = report.Document.Pages.Count
                    Using fStream As New System.IO.FileStream(filePath, FileMode.CreateNew)
                        pdf.Export(report.Document, fStream)
                    End Using

                    strLogText.AppendFormat("{0}/{1} #{2}.  ", origName, currName, acctLastFour)
                    strLogText.AppendFormat("Letter Of Representation generated for {0}." & Chr(13), currName)
                    AttachDocumentToCreditor(DataClientid, accountID, filePath, tempName, strLogText.ToString)
                    ReportsHelper.InsertPrintInfo("D4006", DataClientid, filePath, Userid, numPagesInReport)

                End Using

            End Using
        Catch ex As Exception
            Throw ex
        End Try

        Return filePath

    End Function
    Public Shared Function CreateNewDocumentPathAndName(ByVal rootDir As String, ByVal ClientID As Integer, ByVal strDocTypeID As String, Optional ByVal subFolder As String = "ClientDocs\") As String
        Dim ssql As String = String.Format("SELECT AccountNumber FROM tblClient WHERE ClientID = {0}", ClientID.ToString)
        Dim acctNum As String = SqlHelper.ExecuteScalar(ssql, CommandType.Text)

        Dim ret As String
        ret = rootDir + subFolder + acctNum + "_" + strDocTypeID + "_" + ReportsHelper.GetNewDocID() + "_" + DateTime.Now.Year.ToString().Substring(2, 2) + DateTime.Now.Month.ToString().PadLeft(2, "0") + DateTime.Now.Day.ToString().PadLeft(2, "0") + ".pdf"
        Return ret
    End Function
    Private Sub AttachDocumentToCreditor(ByVal DataClientID As String, ByVal accountID As String, ByVal filePath As String, ByVal tempName As String, ByVal strLogText As String)
        Dim nid As String = NoteHelper.InsertNote(strLogText, Userid, DataClientID)           'attach client copy of letter
        NoteHelper.RelateNote(nid, 1, DataClientID)              'relate to client
        NoteHelper.RelateNote(nid, 2, accountID)                 'relate to creditor
        'attach  document
        SharedFunctions.DocumentAttachment.AttachDocument("note", nid, Path.GetFileName(filePath), Userid, accountID + "_" + tempName & "\")
        SharedFunctions.DocumentAttachment.AttachDocument("account", accountID, Path.GetFileName(filePath), UserID, accountID + "_" + tempName & "\")
        SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(filePath), UserID, Now)
    End Sub
    Private Sub LoadForm(ByVal formTitle As String, ByVal pdfPaths As String)

        Dim tabCont As New TabContainer
        tabCont.CssClass = "tabContainer"

        Dim tp As New TabPanel
        tp.HeaderText = formTitle
        tabCont.Tabs.Add(tp)

        Dim ifrm As New HtmlGenericControl("iframe style=""width: 100%; height: 95%"" ")
        ifrm.Visible = True
        ifrm.Attributes("src") = pdfPaths
        hdnLorPath.Value = pdfPaths
        tabCont.Tabs(tabCont.Tabs.Count - 1).Controls.Add(ifrm)

        'get poa doc if it exists
        Try
            Dim clientSixNumber As String = SqlHelper.ExecuteScalar(String.Format("select accountnumber from tblclient where clientid = {0}", DataClientid), CommandType.Text)
            Dim ServerPath As String = String.Format("\\{0}", ConfigurationManager.AppSettings("storage_documentPath").ToString).Replace("\\", "\")
            Dim clientDIR As New IO.DirectoryInfo(ServerPath.Replace("lex-dev-30", "nas02") & "\" & clientSixNumber.Trim & "\clientdocs")
            Dim clientFiles As IO.FileInfo() = clientDIR.GetFiles("*.pdf")
            Dim bPOAFound As Boolean = False
            Dim poaPath As String = String.Empty
            For Each cFile As IO.FileInfo In clientFiles
                Dim fileParts As String() = Path.GetFileNameWithoutExtension(cFile.FullName).Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
                If fileParts.Length > 1 Then
                    Select Case fileParts(1).ToString
                        Case "9019"
                            poaPath = cFile.FullName
                            bPOAFound = True
                            Exit For
                    End Select
                End If
            Next

            If bPOAFound Then
                tp = New TabPanel
                tp.HeaderText = "Power of Attorney"
                tabCont.Tabs.Add(tp)

                ifrm = New HtmlGenericControl("iframe style=""width: 100%; height: 95%"" ")
                ifrm.Visible = True
                ifrm.Attributes("src") = poaPath
                hdnPOAPath.Value = poaPath
                tabCont.Tabs(tabCont.Tabs.Count - 1).Controls.Add(ifrm)
            Else
                msg.Attributes("class") = "error"
                msg.InnerHtml = "<b>NO POA FOUND</b>"
                msg.Style("display") = "block"
            End If
            msg.Style("display") = "none"
        Catch ex As Exception
            msg.Attributes("class") = "error"
            msg.InnerHtml = String.Format("<b>{0}</b>", ex.Message)
            msg.Style("display") = "block"
        End Try
        
        phDocuments.Controls.Add(tabCont)
        mpeLOR.Show()
    End Sub
End Class