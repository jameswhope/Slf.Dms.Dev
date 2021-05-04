Imports System.Collections.Generic
Imports HarassmentHelper
Imports SharedFunctions
Imports System.Data.SqlClient
Imports System.IO
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers
Imports Infragistics.WebUI.UltraWebListbar
Imports Infragistics.Web
Imports System.Data

Partial Class Clients_Creditors_harassment
	Inherits System.Web.UI.UserControl
#Region "Declares"
	Private Event FormCreated As EventHandler
	Private Event FormInvalid As EventHandler
	Public Event ReloadDocuments(ByVal sender As Object, ByVal e As harassDocumentEventArgs)
	Private _ClientID As String
	Private _accountID As String
	Private _userid As String
	Private connString As String
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
	Public Property CreatedBy() As String
		Get
			Return Me._userid
		End Get
		Set(ByVal value As String)
			Me._userid = value
		End Set
	End Property
	Public Sub ShowPopUp()
		'public prop to show pop up
		Me.ModalPopupExtender1.Show()
	End Sub
	Public Class harassDocumentEventArgs
		Inherits EventArgs
		Private _reloadDocuments As Boolean

		Public Sub New(ByVal BtnClickTime As Boolean)
			_reloadDocuments = BtnClickTime
		End Sub
		Public Property ReloadDocuments() As Boolean
			Get
				Return _reloadDocuments
			End Get
			Set(ByVal Value As Boolean)
				_reloadDocuments = Value
			End Set
		End Property
	End Class
#End Region
#Region "Events"
	Protected Sub Page_FormCancelled(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.FormInvalid
		'no reason selected show error div
		Me.dvError.Style("display") = "block"

		'continue to show popup
		Me.ModalPopupExtender1.Show()
	End Sub
	Protected Sub Page_FormCreated(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.FormCreated
		'reset controls, form was saved
		ResetReasons(pnlReasons)
		lbreasons_27_string.Groups(0).Expanded = True

		ResetReasons(pnlAdditional)


		'hide popup
		Me.ModalPopupExtender1.Hide()

		'trigger reload docs event
		RaiseEvent ReloadDocuments(Me, New harassDocumentEventArgs(True))
	End Sub
	Protected Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
		'fix webpanel z-index prob
		For Each rc As Control In pnlReasons.Controls
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
			ResetReasons(pnlReasons)
			Me.lbreasons_27_string.Groups(0).Expanded = True
			ResetReasons(pnlAdditional)
		End If
	End Sub
	Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
		'set ddl selected items
		'Me.cboOrigCreditor.SelectedIndex = ReturnSelectedIdx(Me._accountID, 0, Me.cboOrigCreditor)
		'Me.cboDebtCollector_137_string.SelectedIndex = ReturnSelectedIdx(Me._accountID, 0, Me.cboDebtCollector_137_string)
		Me.cboCardHolderName_9_string.SelectedIndex = 0
	End Sub
	Protected Sub lnkSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSubmit.Click
		'save harassment info to harass class
		Dim harass As HarassmentHelper.Harassment = getHarassmentInfo()

		'check if something was selected
		If harass.ReasonHeaderID = "" Or harass.ReasonHeaderID Is Nothing Then
			RaiseEvent FormInvalid(Me, New EventArgs())
			Exit Sub
		Else
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
			Dim rpt As Infragistics.Documents.Report.Report = HarassmentHelper.ProcessHarassmentForm(harass)
			Dim myDocuments As String = DocumentAttachment.CreateDirForClient(harass.DataClientID)
			Dim strCredDir As String = DocumentAttachment.GetCreditorDir(harass.CreditorAccountID)
			myDocuments += "CreditorDocs\" & strCredDir
			myDocuments += DocumentAttachment.GetUniqueDocumentName("D8008", harass.DataClientID)
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
			ResetReasons(pnlReasons)

			'raise event that form was successful
			RaiseEvent FormCreated(Me, New EventArgs())

		End If
	End Sub
#End Region
#Region "subs/Funcs"
	Private Sub FormatDatesTimes(ByVal topControl As Control)
		'set dates to today and time to timeofday

		Me.dteAbuse_133_string.Value = Now
		Me.dteAbuse_133_string.Font.Size = New FontUnit(FontSize.XSmall)

		Me.dteSpokeCallingIndividualDateOfAbuse_19_string.Value = Now
		Me.dteSpokeCallingIndividualDateOfAbuse_19_string.Font.Size = New FontUnit(FontSize.XSmall)

		Me.dteNoticeOfRep.Font.Size = New FontUnit(FontSize.XSmall)
		Me.dteCease.Font.Size = New FontUnit(FontSize.XSmall)

		Me.iSpokeCallingIndividualTime_21_string.Value = Now.TimeOfDay
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
					Case "D6003", "D4006"	'notice of rep
						Me.dteNoticeOfRep.Value = Date.Parse(drow("lastsent").ToString)
						Me.txtRepTotal.Text = drow("total").ToString

					Case "D3022", "D3023"	'demand letter
						Me.dteCease.Value = Date.Parse(drow("lastsent").ToString)
						Me.txtCeaseTotal.Value = drow("total").ToString
				End Select

			Next

		End Using

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
	Private Sub ResetReasons(ByVal topControl As Control)
		'loop thru all controls setting there 
		'values to a default state

		For Each rc As Control In topControl.Controls
			If TypeOf rc Is Infragistics.WebUI.WebDataInput.WebTextEdit Then
				TryCast(rc, Infragistics.WebUI.WebDataInput.WebTextEdit).Text = ""
			ElseIf TypeOf rc Is UltraWebListbar Then
				Dim lb As UltraWebListbar = DirectCast(rc, UltraWebListbar)
				For Each grp As Infragistics.WebUI.UltraWebListbar.Group In lb.Groups
					grp.Expanded = False
				Next
			ElseIf TypeOf rc Is Infragistics.WebUI.Misc.WebPanel Then
				TryCast(rc, Infragistics.WebUI.Misc.WebPanel).Expanded = False
			ElseIf TypeOf rc Is Infragistics.WebUI.WebDataInput.WebMaskEdit Then
				TryCast(rc, Infragistics.WebUI.WebDataInput.WebMaskEdit).Text = ""
			ElseIf TypeOf rc Is RadioButtonList Then
				TryCast(rc, RadioButtonList).SelectedIndex = -1
			ElseIf TypeOf rc Is CheckBoxList Then
				For Each li As ListItem In TryCast(rc, CheckBoxList).Items
					li.Selected = False
				Next
			ElseIf TypeOf rc Is LiteralControl Then

			End If

			If rc.HasControls Then
				ResetReasons(rc)
			End If
		Next

		dvError.Style("display") = "none"
	End Sub
	''' <summary>
	''' gather data from controls on the form
	''' </summary>
	''' <returns></returns>
	''' <remarks></remarks>
	Private Function getHarassmentInfo() As HarassmentHelper.Harassment

		Dim rList As List(Of HarassmentReason) = Nothing
		Dim harass As New HarassmentHelper.Harassment
		harass.CreditorAccountID = Me._accountID
		'8.12.09.ug
		'remove webcombo use dropdownlist
		'value = c.ClientID|c.AccountNumber|s.Abbreviation|p.personid
		Dim CardHolder() As String = cboCardHolderName_9_string.SelectedItem.Value.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
		harass.DataClientID = CardHolder(0)	' Me.cboCardHolderName_9_string.SelectedRow.Cells(0).Value
		harass.ClientAccountNumber = CardHolder(1) 'Me.cboCardHolderName_9_string.SelectedRow.Cells(1).Value
		harass.CardHolderState = CardHolder(2) 'Me.cboCardHolderName_9_string.SelectedRow.Cells(2).Value
		harass.ClientPersonID = CardHolder(3) 'Me.cboCardHolderName_9_string.SelectedRow.Cells(4).Value
		harass.CardHoldersName = cboCardHolderName_9_string.SelectedItem.Text.ToString 'Me.cboCardHolderName_9_string.SelectedRow.Cells(3).Value

		'8.12.09.ug
		'remove webcombo use dropdownlist
		'value = AccountID|CurrentCredID
		Dim OrigCredInfo() As String = cboOrigCreditor.SelectedItem.Value.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)
		Dim CurrCredInfo() As String = cboDebtCollector_137_string.SelectedItem.Value.Split(New Char() {"|"}, StringSplitOptions.RemoveEmptyEntries)

		harass.OriginalCreditorID = OrigCredInfo(1) ' Me.cboOrigCreditor.SelectedRow.Cells(2).Value
		harass.OriginalCreditorName = Me.cboOrigCreditor.SelectedItem.Text.ToString	'Me.cboOrigCreditor.SelectedRow.Cells(1).Value
		harass.BeingSuedByCreditor = IIf(Me.radSued.SelectedValue = "YES", True, False)
		harass.DebtCollectorID = CurrCredInfo(1) 'Me.cboDebtCollector_137_string.SelectedRow.Cells(2).Value
		harass.DebtCollectorName = Me.cboDebtCollector_137_string.SelectedItem.Text.ToString 'Me.cboDebtCollector_137_string.SelectedRow.Cells(1).Value
		harass.IndividualCallingName = Me.txtSpokeIndividualCalling_135_String.Text

		Dim idents As New List(Of String)
		For Each itm As ListItem In Me.cblSpokeCallingIndividual_16_array.Items
			If itm.Selected Then
				idents.Add(itm.Text)
				If itm.Value = "Other" Then
					idents.Add(txtSpokeCallingIndividualOther_17_string.Text)
				End If
			End If
		Next
		harass.IndividualCallingIdentity = idents

		harass.IndividualCallingPhone = Me.txtSpokeCallingIndividualPhone_136_string.Value
		harass.IndividualCallingDateOfCall = Me.dteSpokeCallingIndividualDateOfAbuse_19_string.Value
		harass.IndividualCallingNumTimesCalled = Me.txtSpokeCallingIndividualNumTimesCalled_20_string.Text
		harass.IndividualCallingTimeOfCall = Me.iSpokeCallingIndividualTime_21_string.Value

		harass.CreatedBy = Me._userid
		harass.OriginalNoticeOfRepresentationMailDate = IIf(Me.dteNoticeOfRep.Value Is Nothing, Nothing, Me.dteNoticeOfRep.Value)
		harass.CeaseAndDesistNoticeMailDate = IIf(Me.dteCease.Value Is Nothing, Nothing, Me.dteCease.Value)
		harass.CreditorAddedUnAuthorizedCharges = IIf(Me.chkInterest.Checked, True, False)

		'new list of reasons
		Dim reasonList As New List(Of HarassmentReason)
		Dim additList As New List(Of HarassmentReason)

		'loop thru reasons
		For Each g As Infragistics.WebUI.UltraWebListbar.Group In lbreasons_27_string.Groups
			'group was clicked
			If g.Expanded Then
				'get reason id from webpanel text
				harass.ReasonHeaderID = HarassmentHelper.getReasonHeaderIDByText(g.Text)
				harass.ReasonHeaderText = g.Text
				reasonList.Add(New HarassmentReason("27", g.Text, "<item>yes</item>", "27_string"))
				Select Case g.Tag.ToString.ToLower
					Case "mail"
						Dim cbl As CheckBoxList = g.FindControl("rblMail")
						For Each itm As ListItem In cbl.Items
							If itm.Selected Then
								reasonList.Add(New HarassmentReason("31", "", itm.Value, "31_string"))
								Exit For
							End If
						Next
				End Select
				Exit For
			End If
		Next

		'get description
		Dim txtDescribe As TextBox = pnlReasons.FindControl("txtDoorContactInfo_32_string")
		harass.DescribeCreditorContact = txtDescribe.Text

		'get additional
		For Each g As Infragistics.WebUI.UltraWebListbar.Group In lbAdditional.Groups
			'group was clicked
			If g.Expanded Then
				Dim strReasonText As String = ""
				Dim fIDs As String() = g.Key.Split("_")
				additList.Add(New HarassmentReason(fIDs(0), g.Text, "<item>yes</item>", g.Key))
				Select Case g.Tag.ToString.ToLower
					Case "threat"
						Dim lb As UltraWebListbar = g.FindControl("lbThreatWhatHappened_106_array")
						Dim threatItem As String = ""
						Dim strOther As String = ""
						Dim unlawItem As String = ""	'keep track of items
						For Each threatGrp As Infragistics.WebUI.UltraWebListbar.Group In lb.Groups
							'group was clicked
							If threatGrp.Expanded Then
								threatItem += threatGrp.Text & "|"
								Select Case threatGrp.Tag
									Case "unlawful"
										Dim lbu As UltraWebListbar = threatGrp.FindControl("lbThreatWhatHappenedUnlawFul_115_array")
										For Each unGrp As Infragistics.WebUI.UltraWebListbar.Group In lbu.Groups
											'group was clicked
											If unGrp.Expanded Then
												Select Case unGrp.Text.ToLower
													Case "other"
														Dim txt As TextBox = unGrp.FindControl("txtThreatWhatHappenedUnlawFulOther_116_string")
														additList.Add(New HarassmentReason("116", "Explain ", txt.Text, "116_string"))
													Case Else
														unlawItem += unGrp.Text & "|"
												End Select
											End If
										Next
									Case "other"
										Dim txt As TextBox = threatGrp.FindControl("txtThreatWhatHappenedOther_104_string")
										strOther = txt.Text
								End Select
							End If
						Next
						If threatItem.ToString <> "" Then
							additList.Add(New HarassmentReason("106", g.Text, threatItem, "106_array"))
						End If
						If unlawItem.ToString <> "" Then
							additList.Add(New HarassmentReason("115", "", unlawItem, "115_array"))
						End If
						If strOther.ToString <> "" Then
							additList.Add(New HarassmentReason("104", "Explain ", strOther, "104_string"))
						End If

					Case "lang", "another"
						strReasonText = "What Happened : " & vbCrLf
						Dim fieldTag As String = getWhatFieldTag(g.Tag)
						Dim fTags As String() = fieldTag.Split("_")

						Dim cbl As CheckBoxList = g.FindControl("cbl" & g.Tag & "WhatHappened_" & fieldTag)
						For Each itm As ListItem In cbl.Items
							If itm.Selected Then
								strReasonText += itm.Value & "|"
							End If
						Next
						additList.Add(New HarassmentReason(fTags(0), g.Text, strReasonText, fieldTag))

						fieldTag = getExplainFieldTag(g.Tag)
						Dim txtExplain As TextBox = g.FindControl("txt" & g.Tag & "WhatHappenedExplain_" & fieldTag)
						If txtExplain.Text <> "" Then
							strReasonText = "Explain: " & txtExplain.Text
							additList.Add(New HarassmentReason(fTags(0), g.Text, strReasonText, fieldTag))
						End If

					Case "third"
						Dim lb As UltraWebListbar = g.FindControl("lbThirdParties")
						For Each thirdGrp As Infragistics.WebUI.UltraWebListbar.Group In lb.Groups
							'group was clicked
							If thirdGrp.Expanded Then
								Dim tIDs As String() = thirdGrp.Key.Split("_")

								Select Case thirdGrp.Text.ToLower
									Case "other"
										Dim txt As TextBox = thirdGrp.FindControl("txtThirdOther_86_string")
										additList.Add(New HarassmentReason(tIDs(0), thirdGrp.Text, "Other Parties Contacted : " & txt.Text, thirdGrp.Key))

									Case Else
										additList.Add(New HarassmentReason(tIDs(0), thirdGrp.Text, "<item>yes</item>", thirdGrp.Key))
										strReasonText = ""
										Dim nameFieldTag As String = getNameFieldTag(thirdGrp.Tag)
										Dim phoneFieldTag As String = getPhoneFieldTag(thirdGrp.Tag)
										Dim contactFieldTag As String = getMayWeContactFieldTag(thirdGrp.Tag)
										Dim whatFieldTag As String = getWhatFieldTag(thirdGrp.Tag)

										Dim txtName As Infragistics.WebUI.WebDataInput.WebTextEdit = thirdGrp.FindControl("txtThird" & thirdGrp.Tag & "ContactName_" & nameFieldTag)
										Dim txtPhone As Infragistics.WebUI.WebDataInput.WebTextEdit = thirdGrp.FindControl("txtThird" & thirdGrp.Tag & "ContactPhone_" & phoneFieldTag)
										Dim cblContact As RadioButtonList = thirdGrp.FindControl("rblThird" & thirdGrp.Tag & "MayWeContact_" & contactFieldTag)

										'get reason id from field tag
										Dim nTag As String() = nameFieldTag.Split("_")
										Dim pTag As String() = phoneFieldTag.Split("_")
										Dim cTag As String() = contactFieldTag.Split("_")
										Dim wTag As String() = whatFieldTag.Split("_")

										additList.Add(New HarassmentReason(nTag(0), thirdGrp.Text, "Contact Name :" & txtName.Text, nameFieldTag))
										additList.Add(New HarassmentReason(pTag(0), thirdGrp.Text, "Contact Phone : " & txtPhone.Text, phoneFieldTag))
										additList.Add(New HarassmentReason(cTag(0), thirdGrp.Text, "May we contact them : " & cblContact.SelectedValue, contactFieldTag))

										strReasonText += "What Happened : " & vbCrLf
										Dim cblWhat As CheckBoxList = thirdGrp.FindControl("cblThird" & thirdGrp.Tag & "WhatHappened_" & whatFieldTag)
										For Each itm As ListItem In cblWhat.Items
											If itm.Selected Then
												strReasonText += itm.Value & "|"
											End If
										Next
										additList.Add(New HarassmentReason(wTag(0), thirdGrp.Text, strReasonText, whatFieldTag))
								End Select

							End If
						Next
				End Select



			End If
		Next


		harass.ReasonData = reasonList
		harass.AdditionalReasonData = additList

		Return harass

	End Function

#Region "these functions return the field ids used by touchpoint"
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
	Private Function getMayWeContactFieldTag(ByVal tagName As String) As String
		Return CStr(Microsoft.VisualBasic.Switch( _
		  tagName.ToLower = "employer".ToLower, "46_string", _
		  tagName.ToLower = "coworker".ToLower, "54_string", _
		  tagName.ToLower = "Neighbors".ToLower, "66_string", _
		  tagName.ToLower = "Friends".ToLower, "74_string", _
		  tagName.ToLower = "Family".ToLower, "82_string"))
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
	Private Function getExplainFieldTag(ByVal tagName As String) As String
		Return CStr(Microsoft.VisualBasic.Switch( _
		tagName = "lang", "98_string", _
		tagName = "another", "110_string" _
		))
	End Function
#End Region
#End Region
End Class







