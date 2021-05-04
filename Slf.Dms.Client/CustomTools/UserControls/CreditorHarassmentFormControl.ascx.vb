Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports HarassmentHelper

Imports Infragistics.Web
Imports Infragistics.WebUI.UltraWebListbar

Imports SharedFunctions

Partial Class CreditorHarassmentFormControl
    Inherits System.Web.UI.UserControl

#Region "Fields"

    Private _ClientID As String
    Private _accountID As String
    Private _userid As String
    Private connString As String

#End Region 'Fields

#Region "Events"

    Public Event ReloadDocuments(ByVal sender As Object, ByVal e As harassDocumentEventArgs)

    Private Event FormCreated As EventHandler

    Delegate Sub FormArgumentsHandler(ByVal sender As Object, ByVal fe As FormArguments)
    Public Event FormInvalid As FormArgumentsHandler

#End Region 'Events

#Region "Properties"

    Public Property CreatedBy() As String
        Get
            Return Me._userid
        End Get
        Set(ByVal value As String)
            Me._userid = value
        End Set
    End Property

    Public Property CreditorAccountID() As String
        Get
            Return _accountID
        End Get
        Set(ByVal value As String)
            _accountID = value
        End Set
    End Property

    Public Property DataClientID() As String
        Get
            Return _ClientID
        End Get
        Set(ByVal value As String)
            _ClientID = value
        End Set
    End Property

#End Region 'Properties

#Region "Methods"

    Public Sub ShowPopUp()
        'public prop to show pop up
        Me.ModalPopupExtender1.Show()
    End Sub

    Protected Sub Page_FormCancelled(ByVal sender As Object, ByVal e As FormArguments) Handles Me.FormInvalid

        Me.dvError.InnerHtml = e.FormMessage

        'no reason selected show error div
        Me.dvError.Style("display") = "block"

        'continue to show popup
        Me.ModalPopupExtender1.Show()
    End Sub

    Protected Sub Page_FormCreated(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.FormCreated
        'reset controls, form was saved
        'ResetReasons(acpReasons)
        ''lbreasons_27_string.Groups(0).Expanded = True

        'ResetReasons(acpAdditional)


        'hide popup
        Me.ModalPopupExtender1.Hide()

        'trigger reload docs event
        RaiseEvent ReloadDocuments(Me, New harassDocumentEventArgs(True))
    End Sub

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        'fix webpanel z-index prob
        For Each rc As Control In acpReasons.Controls
            If TypeOf rc Is Infragistics.WebUI.Misc.WebPanel Then
                TryCast(rc, Infragistics.WebUI.Misc.WebPanel).FindControl("nothing")
            End If
        Next
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        connString = System.Configuration.ConfigurationManager.AppSettings("connectionstring").ToString
        If Not IsPostBack Then
            LoadClientInfo()
            LoadCreditors()
            LoadPreviousNotices()
            FormatDatesTimes(Me)
            ResetReasons(acpReasons)
            'Me.lbreasons_27_string.Groups(0).Expanded = True
            ResetReasons(acpAdditional)

            'txtDoorContactInfo_32_string.Text = "I dialed [Enter Phone Number Here] and it rang to [Enter Company Name]."
            lbreasons_27_string.RequireOpenedPane = False
            lbreasons_27_string.SelectedIndex = -1
        End If
    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        'set ddl selected items
        'Me.cboOrigCreditor.SelectedIndex = ReturnSelectedIdx(Me._accountID, 0, Me.cboOrigCreditor)
        'Me.cboDebtCollector_137_string.SelectedIndex = ReturnSelectedIdx(Me._accountID, 0, Me.cboDebtCollector_137_string)
        Me.cboCardHolderName_9_string.SelectedIndex = 0
    End Sub

    Protected Sub lnkSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSubmit.Click
        Dim fa As FormArguments = Nothing
        If dteSpokeCallingIndividualDateOfAbuse_19_string.Text = "" Then
            fa = New FormArguments("Submit", "Date of Abuse is a required field!")
            RaiseEvent FormInvalid(Me, fa)
            Exit Sub
        End If
        If iSpokeCallingIndividualTime_21_string.Text = "" Then
            fa = New FormArguments("Submit", "Time of call is required!")
            RaiseEvent FormInvalid(Me, fa)
            Exit Sub
        End If
        If lbreasons_27_string.SelectedIndex = -1 Then
            fa = New FormArguments("Submit", "Harassment reason is required!")
            RaiseEvent FormInvalid(Me, fa)
            Exit Sub
        End If
        fa = Nothing

        'save harassment info to harass class
        Using harass As HarassmentHelper.Harassment = getHarassmentInfo()
            'check if something was selected
            Select Case harass.ReasonHeaderID
                Case 1, 2, 4, 5, 6 'reasons don't have sub reasons
                Case Else
                    If harass.ReasonData.Count = 0 Then
                        RaiseEvent FormInvalid(Me, New EventArgs())
                        Exit Sub
                    End If
            End Select

            'save form data to db
            'Publish the report to the current user's
            Dim myDocuments As String = DocumentAttachment.CreateDirForClient(harass.DataClientID)
            Dim strCredDir As String = DocumentAttachment.GetCreditorDir(harass.CreditorAccountID)
            myDocuments += "CreditorDocs\" & strCredDir
            Dim uniqueDocName As String = DocumentAttachment.GetUniqueDocumentName("D8008", harass.DataClientID)
            myDocuments += uniqueDocName
            harass.DocumentID = uniqueDocName.Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)(2)
            Dim rpt As Infragistics.Documents.Report.Report = HarassmentHelper.ProcessHarassmentForm(harass)
            rpt.Publish(myDocuments, Infragistics.Documents.Report.FileFormat.PDF)

            'attach documents to note
            Dim newNote As New StringBuilder
            newNote.AppendLine(harass.OriginalCreditorName & "/" & harass.DebtCollectorName & ": Abuse Intake Form Created by " & UserHelper.GetName(harass.CreatedBy) & ".")

            Dim intNoteID As Integer = NoteHelper.InsertNote(newNote.ToString, harass.CreatedBy, harass.DataClientID)
            'relate
            NoteHelper.RelateNote(intNoteID, 2, harass.CreditorAccountID)
            'attach
            SharedFunctions.DocumentAttachment.AttachDocument("note", intNoteID, Path.GetFileName(myDocuments), harass.CreatedBy, strCredDir)
            SharedFunctions.DocumentAttachment.AttachDocument("account", harass.CreditorAccountID, Path.GetFileName(myDocuments), harass.CreatedBy, strCredDir)
            SharedFunctions.DocumentAttachment.AttachDocument("client", harass.DataClientID, Path.GetFileName(myDocuments), harass.CreatedBy, "ClientDocs")
            SharedFunctions.DocumentAttachment.CreateScan(Path.GetFileName(myDocuments), harass.CreatedBy, Now)

            'reset form
            ResetReasons(acpReasons)

            'raise event that form was successful
            RaiseEvent FormCreated(Me, New EventArgs())
        End Using

    End Sub

    Private Sub FormatDatesTimes(ByVal topControl As Control)
        'set dates to today and time to timeofday

        Me.dteAbuse_133_string.Text = Now
        Me.dteAbuse_133_string.Font.Size = New FontUnit(FontSize.XSmall)

        Me.dteSpokeCallingIndividualDateOfAbuse_19_string.Text = "" 'Now
        Me.dteSpokeCallingIndividualDateOfAbuse_19_string.Font.Size = New FontUnit(FontSize.XSmall)

        Me.dteNoticeOfRep.Font.Size = New FontUnit(FontSize.XSmall)
        Me.dteCease.Font.Size = New FontUnit(FontSize.XSmall)

        Me.iSpokeCallingIndividualTime_21_string.Text = "" ' Now.TimeOfDay
        Me.iSpokeCallingIndividualTime_21_string.Font.Size = New FontUnit(FontSize.XSmall)
    End Sub

    Private Sub LoadClientInfo()
        'get client ifnor for
        'cardholder and state info
        Dim sqlInfo As String = "SELECT c.AccountNumber,  s.Abbreviation FROM tblClient c INNER JOIN tblPerson p ON p.ClientID = c.ClientID " & _
         "INNER JOIN tblState s ON s.StateID = p.StateID WHERE c.clientid = " & Me._ClientID

        Using dtInfo As Data.DataTable = AsyncDB.executeDataTableAsync(sqlInfo, connString)
            If dtInfo.Rows.Count > 0 Then
                Dim dr As Data.DataRow = dtInfo.Rows(0)
                Me.txtAcctNum_8_String.Text = dr("AccountNumber").ToString
                Me.txtStateName_132_string.Text = dr("Abbreviation").ToString
            End If
        End Using

        sqlInfo = "SELECT p.FirstName+ ' ' + p.LastName as [CardHolder], "
        sqlInfo += "convert(varchar,c.ClientID) + '|' + convert(varchar,c.AccountNumber) + '|' "
        sqlInfo += "+ convert(varchar,s.Abbreviation) + '|' + convert(varchar,p.personid) [CardHolderInfo],"
        sqlInfo += "c.ClientID, c.AccountNumber,  s.Abbreviation, p.personid "
        sqlInfo += "FROM tblClient c INNER JOIN tblPerson p ON p.ClientID = c.ClientID INNER JOIN tblState s ON s.StateID = p.StateID "
        sqlInfo += String.Format("WHERE c.clientid = {0}", Me._ClientID)

        Using dtCard As Data.DataTable = AsyncDB.executeDataTableAsync(sqlInfo, connString)
            For Each card In dtCard.Rows
                cboCardHolderName_9_string.Items.Add(New ListItem(card("CardHolder").ToString, card("CardHolderInfo").ToString))
            Next
        End Using
    End Sub

    Private Sub LoadCreditors()
        Dim sqlOrig As New StringBuilder
        Dim sqlCurr As New StringBuilder

        sqlOrig.Append("select [OriginalCreditor],[OriginalCreditorAcct],convert(varchar,accountid) + '|' + convert(varchar,OrigCredID)[OriginalInfo],accountid ")
        sqlOrig.Append("from(SELECT a.accountid,OrigCr.[Name] [OriginalCreditor],' #' + right(OrigCi.AccountNumber,4) as [OriginalCreditorAcct],OrigCr.creditorid as OrigCredID ")
        sqlOrig.Append("FROM tblAccount as a INNER JOIN tblCreditorInstance OrigCi ON OrigCi.CreditorInstanceID = a.originalCreditorInstanceID ")
        sqlOrig.Append("INNER JOIN tblCreditor OrigCr ON OrigCr.CreditorID = OrigCi.CreditorID INNER JOIN tblCreditor cr ON cr.CreditorID = OrigCr.CreditorID ")
        sqlOrig.AppendFormat("WHERE (a.clientid = {0}) ", Me._ClientID)
        sqlOrig.Append("union select 	'-1' as accountid , 'Unknown' as OriginalInfo,''[OriginalCreditorAcct], '-1' as OrigCredID) as OrigCredData ORDER BY OriginalInfo")
        Using dtOrig As Data.DataTable = AsyncDB.executeDataTableAsync(sqlOrig.ToString, connString)
            For Each cred As DataRow In dtOrig.Rows
                Dim itemText As String = String.Format("{0} {1}", cred("OriginalCreditor").ToString, cred("OriginalCreditorAcct").ToString)
                Dim item As New ListItem(itemText, cred("OriginalInfo").ToString)
                If Me._accountID = cred("accountid").ToString Then
                    item.Selected = True
                End If
                cboOrigCreditor.Items.Add(item)
            Next
        End Using

        sqlCurr.Append("SELECT CurrentCreditor,[CurrentCreditorAcct],convert(varchar,AccountID) + '|' +  convert(varchar,CurrentCredID )[CurrentInfo],accountid ")
        sqlCurr.Append("FROM (SELECT a.AccountID, cr.Name[CurrentCreditor],' #' + RIGHT (ci.AccountNumber, 4)[CurrentCreditorAcct], cr.CreditorID AS CurrentCredID ")
        sqlCurr.Append("FROM tblAccount AS a INNER JOIN tblCreditorInstance AS OrigCi ")
        sqlCurr.Append("ON OrigCi.CreditorInstanceID = a.OriginalCreditorInstanceID ")
        sqlCurr.Append("INNER JOIN tblCreditorInstance AS ci ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID ")
        sqlCurr.Append("INNER JOIN tblCreditor AS cr ON cr.CreditorID = ci.CreditorID ")
        sqlCurr.AppendFormat("WHERE (a.ClientID = {0})  ", Me._ClientID)
        sqlCurr.Append("UNION SELECT '-1' AS accountid, 'Unknown' AS CurrentInfo, ''[CurrentCreditorAcct],'-1' AS CurrentCredID) AS CurrCredData ORDER BY CurrentInfo")
        Using dtCurr As Data.DataTable = AsyncDB.executeDataTableAsync(sqlCurr.ToString, connString)
            For Each cred As DataRow In dtCurr.Rows
                Dim itemText As String = String.Format("{0} {1}", cred("CurrentCreditor").ToString, cred("CurrentCreditorAcct").ToString)
                Dim item As New ListItem(itemText, cred("CurrentInfo").ToString)

                If Me._accountID = cred("accountid").ToString Then
                    item.Selected = True
                End If
                cboDebtCollector_137_string.Items.Add(item)
            Next
        End Using
    End Sub

    Private Sub LoadPreviousNotices()
        'get all ltr of rep/CAD notices and display date
        'of last notice and total count

        Dim sqlNotices As String = "SELECT DocTypeID, accountid,MAX(SentDate) AS LastSent,  count(*) as [Total] " & _
        "FROM vwSentLetters WHERE ClientID = " & _ClientID & " and accountid = '" & _accountID & "' and DocTypeID in ('D6003','D4006','D3022','D3023')" & _
        "group by DocTypeID,accountid"
        Using dtNotice As Data.DataTable = AsyncDB.executeDataTableAsync(sqlNotices, ConfigurationManager.AppSettings("connectionstring").ToString)

            For Each drow As Data.DataRow In dtNotice.Rows
                Select Case drow("doctypeid").ToString
                    Case "D6003", "D4006"   'notice of rep
                        Me.dteNoticeOfRep.Text = Date.Parse(drow("lastsent").ToString)
                        Me.txtRepTotal.Text = drow("total").ToString

                    Case "D3022", "D3023"   'demand letter
                        Me.dteCease.Text = Date.Parse(drow("lastsent").ToString)
                        Me.txtCeaseTotal.Text = drow("total").ToString
                End Select

            Next

        End Using
    End Sub

    Private Sub ResetReasons(ByVal topControl As Control)
        'loop thru all controls setting there
        'values to a default state

        For Each rc As Control In topControl.Controls
            If TypeOf rc Is TextBox Then
                TryCast(rc, TextBox).Text = ""
            ElseIf TypeOf rc Is CollapsiblePanelExtender Then
                TryCast(rc, CollapsiblePanelExtender).Collapsed = True
            ElseIf TypeOf rc Is Accordion Then
                TryCast(rc, Accordion).SelectedIndex = -1
            ElseIf TypeOf rc Is RadioButtonList Then
                TryCast(rc, RadioButtonList).SelectedIndex = -1
            ElseIf TypeOf rc Is CheckBoxList Then
                For Each li As ListItem In TryCast(rc, CheckBoxList).Items
                    li.Selected = False
                Next
            ElseIf TypeOf rc Is LiteralControl Then
                'TryCast(rc, LiteralControl).Text = ""
            End If

            If rc.HasControls Then
                ResetReasons(rc)
            End If
        Next

        dvError.Style("display") = "none"
    End Sub

    Private Function ReturnSelectedIdx(ByVal ValueToFind As String, ByVal columnIdxToMatch As Integer, ByVal comboToSearch As Infragistics.WebUI.WebCombo.WebCombo) As Integer
        'get the ddl's selected idx
        Dim rowIdx As Integer = -1
        For Each r As Infragistics.WebUI.UltraWebGrid.UltraGridRow In comboToSearch.Rows
            If r.Cells(columnIdxToMatch).Value = ValueToFind Then
                rowIdx = r.Index
                Exit For
            End If
        Next
        Return rowIdx
    End Function

    Private Function getExplainFieldTag(ByVal tagName As String) As String
        Return CStr(Microsoft.VisualBasic.Switch( _
        tagName = "lang", "98_string", _
        tagName = "another", "110_string" _
        ))
    End Function

    
    Public Function getHeaderText(ByVal ctlID As String) As String
        Dim hdrText As String = ""
        Select Case ctlID.Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)(1)
            Case "36"
                hdrText = "Collector is calling you at home (before 8am or after 9pm)."
            Case "38"
                hdrText = "Collector is calling you at work."
            Case "40"
                hdrText = "Collector is contacting third-parties with information regarding your debt(s)."
            Case "90"
                hdrText = "Collector is using abusive language."
            Case "101"
                hdrText = "Collector is threatening you."
            Case "108"
                hdrText = "Collector is Harassing you in another manner."
            Case "43"
                hdrText = "Employer"
            Case "51"
                hdrText = "Co-Worker"
            Case "70"
                hdrText = "Neighbors"
            Case "78"
                hdrText = "Friends"
            Case "79"
                hdrText = "Family"
            Case "86"
                hdrText = "Other"
            Case "106"
                If ctlID.Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries).Length > 3 Then
                    Select Case ctlID.Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)(3)
                        Case "violence"
                            hdrText = "Used or threatened to use violence."
                        Case "body"
                            hdrText = "Harmed or threatened to harm you or another person (body, property or reputation)."
                        Case "sell"
                            hdrText = "Threatened to sell your debt to a third party."
                        Case "criminal"
                            hdrText = "Threatened criminal prosecution if you did not give them a post dated check."
                        Case "unlawful"
                            hdrText = "Threatened to take unlawful actions against you before judgement is taken."
                    End Select
                End If
            Case "115"
                If ctlID.Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries).Length > 4 Then
                    Select Case ctlID.Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)(4)
                        Case "arrest"
                            hdrText = "Arrest"
                        Case "seizure"
                            hdrText = "Seizure of Property"
                        Case "jobloss"
                            hdrText = "Job Loss"
                        Case "garnishment"
                            hdrText = "Garnishment"
                    End Select
                End If
        End Select
       

      


        Return hdrText
    End Function


    Private Function getCallingIndividualIdentity(ByVal listItems As ListItemCollection) As List(Of String)
        Dim idents As New List(Of String)
        For Each itm As ListItem In listItems 'Me.cblSpokeCallingIndividual_16_array.Items
            If itm.Selected Then
                idents.Add(itm.Text)
                If itm.Value = "Other" Then
                    idents.Add(txtSpokeCallingIndividualOther_17_string.Text)
                End If
            End If
        Next
        Return idents
    End Function
    ''' <summary>
    ''' gather data from controls on the form
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function getHarassmentInfo() As HarassmentHelper.Harassment
        Dim rList As List(Of HarassmentReason) = Nothing
        Dim harass As New HarassmentHelper.Harassment
        harass.CreditorAccountID = Me._accountID

        'value = c.ClientID|c.AccountNumber|s.Abbreviation|p.personid
        Dim CardHolder() As String = cboCardHolderName_9_string.SelectedItem.Value.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
        harass.DataClientID = CardHolder(0)
        harass.ClientAccountNumber = CardHolder(1)
        harass.CardHolderState = CardHolder(2)
        harass.ClientPersonID = CardHolder(3)
        harass.CardHoldersName = cboCardHolderName_9_string.SelectedItem.Text.ToString

        'value = AccountID|CurrentCredID
        Dim OrigCredInfo() As String = cboOrigCreditor.SelectedItem.Value.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
        Dim CurrCredInfo() As String = cboDebtCollector_137_string.SelectedItem.Value.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)

        harass.OriginalCreditorID = OrigCredInfo(1)
        harass.OriginalCreditorName = Me.cboOrigCreditor.SelectedItem.Text.ToString
        harass.BeingSuedByCreditor = IIf(Me.radSued.SelectedValue = "YES", True, False)
        harass.DebtCollectorID = CurrCredInfo(1)
        harass.DebtCollectorName = Me.cboDebtCollector_137_string.SelectedItem.Text.ToString
        harass.IndividualCallingName = Me.txtSpokeIndividualCalling_135_String.Text

        Dim idents As List(Of String) = getCallingIndividualIdentity(Me.cblSpokeCallingIndividual_16_array.Items)
        harass.IndividualCallingIdentity = idents

        harass.IndividualCallingPhone = Me.txtSpokeCallingIndividualPhone_136_string.Text
        harass.IndividualCallingNumberDialed = txtPhoneCreditorCalled.Text
        harass.IndividualCallingDateOfCall = Me.dteSpokeCallingIndividualDateOfAbuse_19_string.Text
        harass.IndividualCallingNumTimesCalled = Me.txtSpokeCallingIndividualNumTimesCalled_20_string.Text
        harass.IndividualCallingTimeOfCall = String.Format("{0} {1}", Me.iSpokeCallingIndividualTime_21_string.Text, ddlTZ.SelectedItem.Text)
        harass.AbuseBeginDate = dteDateAbuseBegan.Text
        harass.EstNumberDailyCalls = txtEstNumTimes.Text

        harass.CreatedBy = Me._userid
        harass.OriginalNoticeOfRepresentationMailDate = IIf(Me.dteNoticeOfRep.Text Is Nothing, Nothing, Me.dteNoticeOfRep.Text)
        harass.CeaseAndDesistNoticeMailDate = IIf(Me.dteCease.Text Is Nothing, Nothing, Me.dteCease.Text)
        harass.CreditorAddedUnAuthorizedCharges = IIf(Me.chkInterest.Checked, True, False)

        'new list of reasons
        'get reason
        Dim reasonList As New List(Of HarassmentReason)
        Dim reasonInfo As String() = lbreasons_27_string.Panes(lbreasons_27_string.SelectedIndex).ID.Split(New Char() {"_"}, StringSplitOptions.RemoveEmptyEntries)
        Dim reasonChk As CheckBox = DirectCast(lbreasons_27_string.Panes(lbreasons_27_string.SelectedIndex).HeaderContainer.Controls(1), CheckBox)
        Dim reasonText As String = reasonChk.Text
        harass.ReasonHeaderID = HarassmentHelper.getReasonHeaderIDByText(reasonText)
        harass.ReasonHeaderText = reasonText
        reasonList.Add(New HarassmentReason("27", reasonText, "<item>yes</item>", "27_string"))
        If reasonInfo(1).ToLower = "mail" Then
            Dim cbl As CheckBoxList = lbreasons_27_string.Panes(lbreasons_27_string.SelectedIndex).ContentContainer.FindControl("cblMail_31_string")
            For Each itm As ListItem In cbl.Items
                If itm.Selected Then
                    reasonList.Add(New HarassmentReason("31", "", itm.Value, "31_string"))
                    Exit For
                End If
            Next
        End If

        'get description
        Dim txtDescribe As TextBox = acpReasons.FindControl("txtDoorContactInfo_32_string")
        harass.DescribeCreditorContact = txtDescribe.Text

        Dim additList As New List(Of HarassmentReason)
        For Each ctl As Control In acpAdditional.ContentContainer.Controls
            If TypeOf ctl Is AjaxControlToolkit.CollapsiblePanelExtender Then
                Using additionalReason As CollapsiblePanelExtender = DirectCast(ctl, CollapsiblePanelExtender)
                    If additionalReason.ClientState = "false" Then
                        'get header info
                        Dim hdrId As String = additionalReason.CollapseControlID.ToString
                        Using hdr As Panel = acpAdditional.ContentContainer.FindControl(hdrId)
                            Dim hdrText As String = getHeaderText(hdrId)
                            'get content info
                            Dim cntId As String = additionalReason.TargetControlID.ToString
                            Using cnt As Panel = acpAdditional.ContentContainer.FindControl(cntId)
                                reasonText = hdrText
                                Dim fIDs As String() = hdrId.Split("_")
                                Dim fldKey As String = String.Format("{0}_{1}", fIDs(1), fIDs(0))
                                additList.Add(New HarassmentReason(fIDs(1), reasonText, "<item>yes</item>", fldKey))

                                Select Case fIDs(2)
                                    Case "threat"
                                        Dim threatItem As String = ""
                                        Dim strOther As String = ""
                                        Dim unlawItem As String = ""    'keep track of items
                                        For Each threat As Control In divThreat.Controls
                                            If TypeOf threat Is AjaxControlToolkit.CollapsiblePanelExtender Then
                                                Using threatPanel As CollapsiblePanelExtender = DirectCast(threat, CollapsiblePanelExtender)
                                                    If threatPanel.ClientState = "false" Then
                                                        Dim threatHdrId As String = threatPanel.CollapseControlID.ToString
                                                        Using threatHdr As Panel = divThreat.FindControl(threatHdrId)
                                                            Dim threatCntId As String = threatPanel.TargetControlID.ToString
                                                            Using threatCnt As Panel = divThreat.FindControl(threatCntId)
                                                                Dim threatHdrText As String = getHeaderText(threatHdrId)
                                                                Dim threatIDs As String() = threatHdrId.Split("_")
                                                                Select Case threatIDs(3)
                                                                    Case "unlawful"
                                                                        threatItem += threatHdrText & "|"
                                                                        For Each unlaw As Control In divUnlawful.Controls
                                                                            If TypeOf unlaw Is AjaxControlToolkit.CollapsiblePanelExtender Then
                                                                                Using unlawPanel As CollapsiblePanelExtender = DirectCast(unlaw, CollapsiblePanelExtender)
                                                                                    If unlawPanel.ClientState = "false" Then
                                                                                        Dim unlawHdrId As String = unlawPanel.CollapseControlID.ToString
                                                                                        Using unlawHdr As Panel = divUnlawful.FindControl(unlawHdrId)
                                                                                            Dim unlawCntId As String = unlawPanel.TargetControlID.ToString
                                                                                            Using unlawCnt As Panel = divUnlawful.FindControl(unlawCntId)
                                                                                                Dim unlawHdrText As String = getHeaderText(unlawHdrId)
                                                                                                Dim unlawIDs As String() = unlawHdrId.Split("_")
                                                                                                Select Case unlawIDs(4)
                                                                                                    Case "other"
                                                                                                        Using txt As TextBox = unlawCnt.FindControl("txtThreatWhatHappenedUnlawFulOther_116_string")
                                                                                                            additList.Add(New HarassmentReason("116", "Explain ", txt.Text, "116_string"))
                                                                                                            unlawItem += String.Format("{0}{1}|", unlawHdrText, txt.Text)
                                                                                                        End Using
                                                                                                    Case Else
                                                                                                        unlawItem += String.Format("{0}|", unlawHdrText)
                                                                                                End Select
                                                                                            End Using
                                                                                        End Using
                                                                                    End If
                                                                                End Using
                                                                            End If
                                                                        Next
                                                                    Case "other"
                                                                        Using txt As TextBox = threatCnt.FindControl("txtThreatWhatHappenedOther_104_string")
                                                                            strOther = txt.Text
                                                                            threatItem += String.Format("{0}{1}|", threatHdrText, txt.Text)
                                                                        End Using

                                                                End Select
                                                            End Using
                                                        End Using
                                                    End If
                                                End Using
                                            End If
                                        Next

                                        If threatItem.ToString <> "" Then
                                            additList.Add(New HarassmentReason("106", hdrText, threatItem, "106_array"))
                                        End If
                                        If unlawItem.ToString <> "" Then
                                            additList.Add(New HarassmentReason("115", "", unlawItem, "115_array"))
                                        End If
                                        If strOther.ToString <> "" Then
                                            additList.Add(New HarassmentReason("104", "Explain ", strOther, "104_string"))
                                        End If
                                    Case "lang", "another"
                                        Dim fldTag As String = fIDs(2)
                                        reasonText = "What Happened : " & vbCrLf
                                        Dim fieldTag As String = getWhatFieldTag(fldTag)
                                        Dim fTags As String() = fieldTag.Split("_")

                                        Dim cbl As CheckBoxList = cnt.FindControl("cbl" & fldTag & "WhatHappened_" & fieldTag)
                                        For Each itm As ListItem In cbl.Items
                                            If itm.Selected Then
                                                reasonText += itm.Value & "|"
                                            End If
                                        Next
                                        additList.Add(New HarassmentReason(fTags(0), hdrText, reasonText, fieldTag))

                                        fieldTag = getExplainFieldTag(fldTag)
                                        Dim txtExplain As TextBox = cnt.FindControl("txt" & fldTag & "WhatHappenedExplain_" & fieldTag)
                                        If txtExplain.Text <> "" Then
                                            reasonText = "Explain: " & txtExplain.Text
                                            additList.Add(New HarassmentReason(fTags(0), hdrText, reasonText, fieldTag))
                                        End If
                                    Case "third"
                                        For Each third As Control In divThirdParties.Controls
                                            If TypeOf third Is AjaxControlToolkit.CollapsiblePanelExtender Then
                                                Using thirdPanel As CollapsiblePanelExtender = DirectCast(third, CollapsiblePanelExtender)
                                                    If thirdPanel.ClientState = "false" Then
                                                        Dim thirdHdrId As String = thirdPanel.CollapseControlID.ToString
                                                        Using thirdHdr As Panel = divThirdParties.FindControl(thirdHdrId)
                                                            Dim thirdHdrText As String = getHeaderText(thirdHdrId)
                                                            Dim thirdCntId As String = thirdPanel.TargetControlID.ToString
                                                            Using thirdCnt As Panel = divThirdParties.FindControl(thirdCntId)
                                                                Dim tIDs As String() = thirdHdrId.Split("_")
                                                                Dim thirdKey As String = String.Format("{0}_{1}", tIDs(1), tIDs(0))

                                                                Select Case tIDs(1)
                                                                    Case "86"
                                                                        Using txt As TextBox = thirdCnt.FindControl("txtThirdOther_86_string")
                                                                            additList.Add(New HarassmentReason(tIDs(1), thirdHdrText, "Other Parties Contacted : " & txt.Text, thirdKey))
                                                                        End Using


                                                                    Case Else
                                                                        additList.Add(New HarassmentReason(tIDs(1), thirdHdrText, "<item>yes</item>", thirdKey))
                                                                        reasonText = ""
                                                                        Dim nameFieldTag As String = getNameFieldTag(thirdHdrText.Replace("-", ""))
                                                                        Dim phoneFieldTag As String = getPhoneFieldTag(thirdHdrText.Replace("-", ""))
                                                                        Dim contactFieldTag As String = getMayWeContactFieldTag(thirdHdrText.Replace("-", ""))
                                                                        Dim whatFieldTag As String = getWhatFieldTag(thirdHdrText.Replace("-", ""))

                                                                        Dim txtName As TextBox = thirdCnt.FindControl("txtThird" & thirdHdrText.Replace("-", "") & "ContactName_" & nameFieldTag)
                                                                        Dim txtPhone As TextBox = thirdCnt.FindControl("txtThird" & thirdHdrText.Replace("-", "") & "ContactPhone_" & phoneFieldTag)
                                                                        Dim cblContact As RadioButtonList = thirdCnt.FindControl("rblThird" & thirdHdrText.Replace("-", "") & "MayWeContact_" & contactFieldTag)

                                                                        'get reason id from field tag
                                                                        Dim nTag As String() = nameFieldTag.Split("_")
                                                                        Dim pTag As String() = phoneFieldTag.Split("_")
                                                                        Dim cTag As String() = contactFieldTag.Split("_")
                                                                        Dim wTag As String() = whatFieldTag.Split("_")

                                                                        additList.Add(New HarassmentReason(nTag(0), thirdHdrText, "Contact Name :" & txtName.Text, nameFieldTag))
                                                                        additList.Add(New HarassmentReason(pTag(0), thirdHdrText, "Contact Phone : " & txtPhone.Text, phoneFieldTag))
                                                                        additList.Add(New HarassmentReason(cTag(0), thirdHdrText, "May we contact them : " & cblContact.SelectedValue, contactFieldTag))

                                                                        reasonText += "What Happened : " & vbCrLf
                                                                        Dim cblWhat As CheckBoxList = thirdCnt.FindControl("cblThird" & thirdHdrText.Replace("-", "") & "WhatHappened_" & whatFieldTag)
                                                                        For Each itm As ListItem In cblWhat.Items
                                                                            If itm.Selected Then
                                                                                reasonText += itm.Value & "|"
                                                                            End If
                                                                        Next
                                                                        additList.Add(New HarassmentReason(wTag(0), thirdHdrText, reasonText, whatFieldTag))
                                                                End Select

                                                            End Using
                                                        End Using
                                                    End If
                                                End Using
                                            End If
                                        Next

                                End Select
                            End Using
                        End Using
                    End If
                End Using
            End If
        Next


        harass.ReasonData = reasonList
        harass.AdditionalReasonData = additList

        Return harass
    End Function

    Private Function getMayWeContactFieldTag(ByVal tagName As String) As String
        Return CStr(Microsoft.VisualBasic.Switch( _
          tagName.ToLower = "employer".ToLower, "46_string", _
          tagName.ToLower = "coworker".ToLower, "54_string", _
          tagName.ToLower = "Neighbors".ToLower, "66_string", _
          tagName.ToLower = "Friends".ToLower, "74_string", _
          tagName.ToLower = "Family".ToLower, "82_string"))
    End Function

    Private Function getNameFieldTag(ByVal tagName As String) As String
        Return CStr(Microsoft.VisualBasic.Switch( _
          tagName.ToLower = "employer".ToLower, "44_string", _
          tagName.ToLower = "coworker".ToLower, "52_string", _
          tagName.ToLower = "Neighbors".ToLower, "64_string", _
          tagName.ToLower = "Friends".ToLower, "72_string", _
          tagName.ToLower = "Family".ToLower, "80_string", _
          tagName.ToLower = "Other".ToLower, "86_string"))
    End Function

    Private Function getPhoneFieldTag(ByVal tagName As String) As String
        Return CStr(Microsoft.VisualBasic.Switch( _
          tagName.ToLower = "employer".ToLower, "45_string", _
          tagName.ToLower = "coworker".ToLower, "53_string", _
          tagName.ToLower = "Neighbors".ToLower, "65_string", _
          tagName.ToLower = "Friends".ToLower, "73_string", _
          tagName.ToLower = "Family".ToLower, "81_string"))
    End Function

    Private Function getWhatFieldTag(ByVal tagName As String) As String
        Return CStr(Microsoft.VisualBasic.Switch( _
          tagName.ToLower = "employer".ToLower, "50_array", _
          tagName.ToLower = "coworker".ToLower, "55_array", _
          tagName.ToLower = "Neighbors".ToLower, "67_array", _
          tagName.ToLower = "Friends".ToLower, "75_array", _
          tagName.ToLower = "Family".ToLower, "83_array", _
          tagName.ToLower = "Lang".ToLower, "97_array", _
          tagName.ToLower = "another".ToLower, "112_array" _
          ))
    End Function

#End Region 'Methods

#Region "Nested Types"

    Public Class FormArguments
        Inherits EventArgs

        Public Sub New(ByVal _formSource As String, ByVal _formMessage As String)
            Me.FormSource = _formSource
            Me.FormMessage = _formMessage
        End Sub 'New

        ' The fire event will have two pieces of information-- 
        ' 1) Where the fire is, and 2) how "ferocious" it is. 

        Public FormSource As String
        Public FormMessage As String
    End Class 'FireEventArgs


    Public Class harassDocumentEventArgs
        Inherits EventArgs

#Region "Fields"

        Private _reloadDocuments As Boolean

#End Region 'Fields

#Region "Constructors"

        Public Sub New(ByVal BtnClickTime As Boolean)
            _reloadDocuments = BtnClickTime
        End Sub

#End Region 'Constructors

#Region "Properties"

        Public Property ReloadDocuments() As Boolean
            Get
                Return _reloadDocuments
            End Get
            Set(ByVal Value As Boolean)
                _reloadDocuments = Value
            End Set
        End Property

#End Region 'Properties

    End Class

#End Region 'Nested Types

End Class