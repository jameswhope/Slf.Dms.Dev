Imports LexxiomWebPartsControls
Imports System.Data
Imports System.Data.SqlClient
Imports Drg.Util.DataHelpers
Imports Drg.Util.DataAccess
Partial Class negotiation_webparts_SessionNotesControl
    Inherits System.Web.UI.UserControl

    Public Event SelectOffer(ByVal settlementID As String)

#Region "View Comms modules"
#Region "Declares"
    Public RelationTypeID As Integer = 0
    Public RelationTypeName As String = ""
    Public RelationID As Integer = 0
    Public clientName As String = ""
    Public creditorName As String = ""
    Public EntityName As String = ""
   
    Public PhoneCallID As Integer
    Private qs As Drg.Util.Helpers.QueryStringCollection
    Private baseTable As String = "tblNote"
    Public ContextSensitive As String
    Public Event NewNote(ByVal noteID As Integer)

    Public Enum FormType
        Comms = 0
        Note = 1
        PhoneCall = 2
        Litigation = 3
    End Enum

    Public Property AccountID() As String
        Get
            Return ViewState("_AccountID")
        End Get
        Set(ByVal value As String)
            ViewState("_AccountID") = value
        End Set
    End Property
    Public Property DataClientID() As String
        Get
            Return ViewState("_DataClientID")
        End Get
        Set(ByVal value As String)
            ViewState("_DataClientID") = value
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
#End Region

#Region "Events"
#Region "CommsGridview"
    
    Protected Sub gvNotes_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvNotes.RowCommand
        Select Case e.CommandName.ToLower
            Case "select"
                Dim gv As GridView = DirectCast(sender, GridView)
                Dim dk As DataKey = gv.DataKeys(e.CommandArgument)

                Me.hdnAction.Value = "e"

                Select Case dk(1)
                    Case "NOTE"
                        LoadNote(dk(0))
                        ShowForm(FormType.Note)
                    Case "PHONE"
                        LoadCall(dk(0))
                        ShowForm(FormType.PhoneCall)
                    Case "phonecall", "mail"
                        Me.LoadLitComm(dk(0), dk(2), dk(3), dk(4), dk(5))
                        ShowForm(FormType.Litigation)
                End Select

        End Select

    End Sub
    Protected Sub gvNotes_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNotes.RowDataBound
        Select Case e.Row.RowType

            Case DataControlRowType.DataRow

                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#DADAFA'; this.style.filter = 'alpha(opacity=75)';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")
                e.Row.Attributes.Add("onclick", Page.ClientScript.GetPostBackEventReference(sender, "Select$" + e.Row.RowIndex.ToString))

                e.Row.Attributes.Add("cellspacing", "0px")
                e.Row.Style("height") = "5px"


                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim lblS As Label = e.Row.FindControl("noteSubject")
                lblS.Text = rowView("Subject")

                Dim lblD As Label = e.Row.FindControl("noteText")
                Dim descText As String = rowView("description")

                If descText.Length > 100 Then
                    lblD.Text = descText.Substring(0, 100) & "..."
                Else
                    lblD.Text = descText
                End If

                Dim img As Image = e.Row.FindControl("imgDir")

                Select Case rowView("type").ToString.ToLower

                    Case "phone"
                        img.ImageUrl = "../../images/16x16_call" & IIf(rowView("direction") = True, "out", "in") & ".png"
                    Case "phonecall"
                        img.ImageUrl = "../../images/16x16_phone.png"
                    Case "mail"
                        img.ImageUrl = "../../images/16x16_email_read.png"
                    Case Else
                        img.ImageUrl = "../../images/16x16_note.png"

                End Select
        End Select
    End Sub
    
    Protected Sub ddlPage_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddlCurrentPage As DropDownList = DirectCast(sender, DropDownList)

        gvNotes.PageIndex = ddlCurrentPage.SelectedValue - 1

        'Dim dtNotes As DataTable = DirectCast(ViewState("gvNotesDataSource"), DataTable)
        'gvNotes.DataSource = dtNotes
        'gvNotes.DataBind()


    End Sub
#End Region
#Region "HistoryGridview"
    Protected Sub gvHistory_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvHistory.RowCommand
        Select Case e.CommandName.ToLower
            Case "select"
                RaiseEvent SelectOffer(e.CommandArgument)
        End Select
    End Sub
    Protected Sub gvHistory_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvHistory.RowDataBound
        Select Case e.Row.RowType

            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#DADAFA'; this.style.filter = 'alpha(opacity=75)';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")

                Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)
                Dim img As Image = e.Row.FindControl("imgDir")

                Select Case rowView("offerdirection").ToString
                    Case "Made"
                        img.ImageUrl = "~/negotiation/images/offerout.png"
                    Case "Received"
                        img.ImageUrl = "~/negotiation/images/offerin.png"
                End Select

        End Select
    End Sub
#End Region
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            DataClientID = Request.QueryString("cid")
            AccountID = Request.QueryString("crid")

            If AccountID Is Nothing And DataClientID Is Nothing Then
                Exit Sub
            End If
            If Request.QueryString("sid") IsNot Nothing Then
                Using cmd As New SqlCommand("SELECT ClientID, CreditorAccountID FROM tblSettlements WHERE SettlementID = " & Request.QueryString("sid"), _
                ConnectionFactory.Create())
                    Using cmd.Connection
                        cmd.Connection.Open()
                        Using reader As SqlDataReader = cmd.ExecuteReader()
                            If reader.Read() Then
                                DataClientID = DataHelper.Nz_int(reader("ClientID"), -1)
                                AccountID = DataHelper.Nz_int(reader("CreditorAccountID"), -1)
                            End If
                        End Using
                    End Using
                End Using
            End If

            Me.historyHiddenIDs.Value = DataClientID & ":" & AccountID
            BindGrid(DataClientID, AccountID)

            Me.hiddenIDs.Value = DataClientID & ":" & AccountID
            ViewState("SortDir") = "ASC"

            GetCommEntities(DataClientID, AccountID)
            PopulateExternal()
            PopulateInternal()
        End If

    End Sub
    Protected Sub radCommType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles radCommType.SelectedIndexChanged
        Dim rad As RadioButtonList = DirectCast(sender, RadioButtonList)

        Select Case rad.SelectedValue
            Case 0  'all
                Me.LoadCommData(DataClientID, 0, , 0)
                Me.hdnRelationTypeID.Value = 1

            Case 1  'client only
                Me.LoadCommData(DataClientID, 1, , 1)
                Me.hdnRelationTypeID.Value = 1
            Case 2  'creditor
                'LoadComms(IDs(0), IDs(1), 2)
                Me.LoadCommData(DataClientID, 2, AccountID, 0)
                Me.hdnRelationTypeID.Value = 2
        End Select
    End Sub
#End Region

#Region "Subs/Funcs"
    Public Sub LoadInfoData(ByVal dataClientID As String, ByVal accountID As String, ByVal bBindGrid As Boolean)
        Me.historyHiddenIDs.Value = dataClientID & ":" & accountID

        If bBindGrid = True Then
            BindGrid(dataClientID, accountID)
        End If

        Me.hiddenIDs.Value = dataClientID & ":" & accountID
        ViewState("SortDir") = "ASC"
    End Sub

    Public Sub GetCommEntities(ByVal sClientID As String, ByVal sCreditorAcctID As String)

        Dim credName As String = CreditorGroupHelper.GetCreditorName(sCreditorAcctID)

        clientName = ClientHelper.GetDefaultPersonName(sClientID).Replace("'", "&#39;")
        radCommType.Items(1).Text = "Comms specific to " & clientName.Split("-")(0)
        radCommType.Items(2).Text = String.Format("Comms specific to {0}", credName)

        Dim bSelected As Boolean = False
        For Each lType As ListItem In radCommType.Items
            If lType.Selected = True Then bSelected = True
        Next
        If bSelected = False Then
            Me.radCommType.Items(0).Selected = True
        End If

        Me.hdnCreditorID.Value = AccountHelper.GetCurrentCreditorID(sCreditorAcctID)
    End Sub
    Private Sub LoadCommData(ByVal sClientID As String, Optional ByVal RelationType As Integer = 0, Optional ByVal CreditorAccountID As String = "", Optional ByVal ClientOnly As Integer = 0)
        dsNotes.SelectParameters("clientid").DefaultValue = sClientID
        If RelationType = 0 Then
            dsNotes.SelectParameters("relationid").DefaultValue = String.Empty
            dsNotes.SelectParameters("relationtypeid").DefaultValue = String.Empty
            dsNotes.SelectParameters("clientonly").DefaultValue = False
            Me.radCommType.SelectedIndex = 0
        Else
            Select Case radCommType.SelectedIndex
                Case 1
                    dsNotes.SelectParameters("relationid").DefaultValue = String.Empty
                    dsNotes.SelectParameters("relationtypeid").DefaultValue = String.Empty
                    dsNotes.SelectParameters("clientonly").DefaultValue = True
                Case 2
                    dsNotes.SelectParameters("relationid").DefaultValue = CreditorAccountID
                    dsNotes.SelectParameters("relationtypeid").DefaultValue = "2"
                    dsNotes.SelectParameters("clientonly").DefaultValue = False
            End Select
        End If
        dsNotes.DataBind()
        gvNotes.DataBind()
    End Sub
    
    Public Sub ShowForm(ByVal FormToShow As FormType)
        Select Case FormToShow
            Case FormType.Comms
                Me.pnlComms.Style("display") = "block"
                Me.pnlNote.Style("display") = "none"
                Me.pnlCall.Style("display") = "none"
                Me.pnlLit.Style("display") = "none"

                Dim IDs As String() = Me.hiddenIDs.Value.Split(":")
                Select Case Me.radCommType.SelectedValue
                    Case 0  'all
                        Me.LoadCommData(IDs(0), 0, , 0)
                        Me.hdnRelationTypeID.Value = 1
                    Case 1  'client only
                        Me.LoadCommData(IDs(0), 1, , 1)
                        Me.hdnRelationTypeID.Value = 1
                    Case 2  'creditor
                        Me.LoadCommData(IDs(0), 2, IDs(1), 0)
                        Me.hdnRelationTypeID.Value = 2
                End Select

            Case FormType.Note
                Me.pnlComms.Style("display") = "none"
                Me.pnlNote.Style("display") = "block"
                Me.pnlCall.Style("display") = "none"
                Me.pnlLit.Style("display") = "none"
            Case FormType.PhoneCall
                Me.pnlComms.Style("display") = "none"
                Me.pnlNote.Style("display") = "none"
                Me.pnlLit.Style("display") = "none"
                Me.pnlCall.Style("display") = "block"
            Case FormType.Litigation
                Me.pnlComms.Style("display") = "none"
                Me.pnlNote.Style("display") = "none"
                Me.pnlCall.Style("display") = "none"
                Me.pnlLit.Style("display") = "block"


        End Select
    End Sub
    Private Sub GetRelationInfo()
        Dim relTypeID As Integer = Me.radCommType.SelectedValue

        Me.hdnRelationTypeID.Value = relTypeID
        Select Case relTypeID
            Case 0, 1
                Me.EntityName = Me.radCommType.Items(1).Text
                Me.EntityName = Me.EntityName.Substring(Me.EntityName.LastIndexOf("to") + 2)
                Me.RelationTypeName = DataHelper.FieldLookup("tblRelationType", "Name", "relationtypeid=" & 1)
            Case 2
                Me.EntityName = Me.radCommType.Items(2).Text
                Me.EntityName = Me.EntityName.Substring(Me.EntityName.LastIndexOf("to") + 2)
                Me.RelationTypeName = DataHelper.FieldLookup("tblRelationType", "Name", "relationtypeid=" & 2)
        End Select

    End Sub
    Public Sub BindGrid(ByVal sClientID As String, ByVal sCreditorID As String)

        Me.historyHiddenIDs.Value = sClientID & ":" & sCreditorID

        Dim sqlSelect As String = "stp_negotiations_getSettlementForClientAndCreditor"

        With dsHistory
            .SelectCommandType = SqlDataSourceCommandType.StoredProcedure
            .SelectCommand = sqlSelect
            .SelectParameters("clientid").DefaultValue = sClientID
            .SelectParameters("creditoraccountid").DefaultValue = sCreditorID

            .DataBind()
        End With

        gvHistory.DataBind()

        BindData_PendingOffers()

    End Sub
    Public Sub BindGrid(ByVal SettlementID As String)
        Dim sClientID As String = ""
        Dim sAccountID As String = ""

        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("Select ClientID, CreditorAccountid from tblsettlements with(nolock) where Settlementid = {0}", SettlementID), CommandType.Text)
            For Each dr As DataRow In dt.Rows
                sClientID = dr("clientid").ToString
                sAccountID = dr("CreditorAccountid").ToString
            Next
        End Using
        BindGrid(sClientID, sAccountID)
    End Sub

#End Region
#End Region

#Region "Note Modules"

#Region "Subs/Funcs"
    Private Sub LoadNote(ByVal sNoteID As Integer)

        GetRelationInfo()

        Me.hdnTempNoteID.Value = sNoteID

        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("SELECT top 1 Created, CreatedBy, LastModified, LastModifiedBy, Value FROM tblNote with(nolock) WHERE NoteID = {0}", sNoteID), CommandType.Text)
            For Each dr As DataRow In dt.Rows
                Dim created As DateTime = DateTime.Parse(dr("Created").ToString)
                Dim lastModified As DateTime = DateTime.Parse(dr("LastModified").ToString)

                txtCreatedBy.Text = UserHelper.GetName(dr("CreatedBy").ToString)
                txtCreatedDate.Text = created.ToShortDateString() + " at " + created.ToShortTimeString()
                txtLastModifiedBy.Text = UserHelper.GetName(dr("LastModifiedBy").ToString)
                txtLastModifiedDate.Text = lastModified.ToShortDateString() + " at " + lastModified.ToShortTimeString()

                txtMessage.Text = dr("Value").ToString

            Next
        End Using

    End Sub
    
    Private Function InsertOrUpdateNote() As Integer
        Dim IDs As String() = Me.hiddenIDs.Value.Split(":")

        If noteID.ToString = "" Then
            noteID = NoteHelper.InsertNote(txtMessage.Text, Session("userid"), IDs(0))
        Else
            NoteHelper.AppendNote(noteID, txtMessage.Text, Session("userid"))
        End If
        Return noteID

        'If Me.hdnAction.Value = "a" Then
        '    Dim IDs As String() = Me.hiddenIDs.Value.Split(":")

        '    If noteID.ToString = "" Then
        '        noteID = NoteHelper.InsertNote(txtMessage.Text, Session("userid"), IDs(0))
        '    Else
        '        NoteHelper.AppendNote(noteID, txtMessage.Text, Session("userid"))
        '    End If
        '    Return NoteID
        'Else
        '    Dim tmpNoteID As Integer = Me.hdnTempNoteID.Value
        '    NoteHelper.UpdateNote(tmpNoteID, txtMessage.Text, Session("UserID"))
        '    Return tmpNoteID
        'End If


    End Function
#End Region

#Region "Events"
    Protected Sub lnkAddNote_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddNote.Click
        Me.hdnAction.Value = "a"
        ltrNew.Text = "New&nbsp;"
        Dim now As DateTime = DateTime.Now
        Dim relTypeID As Integer = Me.radCommType.SelectedValue

        Select Case relTypeID
            Case 0, 1
                Me.EntityName = Me.radCommType.Items(1).Text
                Me.EntityName = Me.EntityName.Substring(Me.EntityName.LastIndexOf("to") + 2)
                Me.RelationTypeName = DataHelper.FieldLookup("tblRelationType", "Name", "relationtypeid=" & 1)
            Case 2
                Me.EntityName = Me.radCommType.Items(2).Text
                Me.EntityName = Me.EntityName.Substring(Me.EntityName.LastIndexOf("to") + 2)
                Me.RelationTypeName = DataHelper.FieldLookup("tblRelationType", "Name", "relationtypeid=" & 2)
        End Select

        txtCreatedBy.Text = UserHelper.GetName(Session("UserID"))
        txtCreatedDate.Text = now.ToShortDateString() '+ " at " + now.ToShortTimeString()
        txtLastModifiedBy.Text = UserHelper.GetName(Session("UserID"))
        txtLastModifiedDate.Text = now.ToShortDateString() '+ " at " + now.ToShortTimeString()
        txtMessage.Text = ""
        Me.ShowForm(FormType.Note)
    End Sub
    Protected Sub lnkCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancel.Click
        Me.ShowForm(FormType.Comms)
    End Sub
    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        Me.noteID = Me.InsertOrUpdateNote()
        Me.ShowForm(FormType.Comms)
    End Sub
#End Region

#End Region
    
#Region "Phone Call Modules"

#Region "Subs/Funcs"
    Private Sub PopulateExternal()

        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("SELECT FirstName, LastName, PersonID FROM tblPerson with(nolock) WHERE ClientID = {0}", DataClientID), CommandType.Text)
            For Each dr As DataRow In dt.Rows
                Dim Name As String = String.Format("{0} {1}", dr("FirstName").ToString, dr("LastName").ToString)
                cboExternal.Items.Add(New ListItem(Name, dr("PersonID").ToString))
            Next
        End Using

    End Sub
    Private Sub PopulateInternal()
        Using dt As DataTable = SqlHelper.GetDataTable("SELECT FirstName, LastName, UserId FROM tblUser with(nolock)", CommandType.Text)
            For Each dr As DataRow In dt.Rows
                Dim Name As String = String.Format("{0} {1}", dr("FirstName").ToString, dr("LastName").ToString)
                cboInternal.Items.Add(New ListItem(Name, dr("UserID").ToString))
            Next
        End Using

    End Sub
    Private Sub LoadCall(ByVal PhoneID As Integer)

        GetRelationInfo()

        Using dt As DataTable = SqlHelper.GetDataTable(String.Format("SELECT * FROM tblPhoneCall with(nolock) WHERE PhoneCallID = {0}", PhoneID), CommandType.Text)
            For Each dr As DataRow In dt.Rows
                Dim created As DateTime = DateTime.Parse(dr("Created").ToString)
                Dim lastModified As DateTime = DateTime.Parse(dr("LastModified").ToString)


                txtCallMsg.Text = dr("Body").ToString
                txtSubject.Text = dr("Subject").ToString
                txtStarted.Text = dr("StartTime").ToString
                txtEnded.Text = dr("EndTime").ToString
                txtPhoneNumber.Text = dr("PhoneNumber").ToString

                'ListHelper.SetSelected(cboExternal, dr("PersonID").ToString())
                'ListHelper.SetSelected(cboInternal, dr("UserID").ToString())

                Select Case Boolean.Parse(dr("Direction").ToString)
                    Case True
                        rbOutgoing.Checked = True
                        rbIncoming.Checked = False
                    Case False
                        rbOutgoing.Checked = False
                        rbIncoming.Checked = True
                        ltrSwapOnLoad.Text = "<script>var cboInternal = document.getElementById(""" + cboInternal.ClientID + """);"
                        ltrSwapOnLoad.Text += "var cboExternal = document.getElementById(""" + cboExternal.ClientID + """);"
                        ltrSwapOnLoad.Text += "var tdSenderHolder = document.getElementById(""" + tdSenderHolder.ClientID + """);"
                        ltrSwapOnLoad.Text += "var tdRecipientHolder = document.getElementById(""" + tdRecipientHolder.ClientID + """);"
                        ltrSwapOnLoad.Text += "tdSenderHolder.appendChild(cboExternal);"
                        ltrSwapOnLoad.Text += "tdRecipientHolder.appendChild(cboInternal);</script>"
                End Select
            Next
        End Using

    End Sub
    Private Function InsertOrUpdatePhoneCall() As Integer
        Dim startDate As DateTime
        Dim endDate As DateTime

        If Not DateTime.TryParse(txtStarted.Text, startDate) Then
            startDate = DateTime.Now
        End If

        If Not DateTime.TryParse(txtEnded.Text, endDate) Then
            endDate = DateTime.Now
        End If

        If Me.hdnAction.Value = "a" Then
            Dim IDs As String() = Me.hiddenIDs.Value.Split(":")
            DataClientID = IDs(0)

            PhoneCallID = PhoneCallHelper.InsertPhoneCall(DataClientID, Session("UserID"), cboInternal.SelectedValue, cboExternal.SelectedValue, rbOutgoing.Checked, txtPhoneNumber.Text.Replace("(", "").Replace(")", "").Replace("-", ""), txtCallMsg.Text, txtSubject.Text, startDate, endDate)

            RelationID = IDs(1)
            PhoneCallHelper.RelatePhoneCall(PhoneCallID, 2, RelationID)

        Else

            PhoneCallHelper.UpdatePhoneCall(PhoneCallID, Session("UserID"), DataHelper.Nz_int(cboInternal.SelectedValue), _
            DataHelper.Nz_int(cboExternal.SelectedValue), rbOutgoing.Checked, txtPhoneNumber.Text.Replace("(", "").Replace(")", "").Replace("-", ""), _
            txtCallMsg.Text, txtSubject.Text, startDate, endDate)

        End If

        Return PhoneCallID
    End Function
#End Region

#Region "Events"
    Protected Sub lnkAddCall_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkAddCall.Click
        Me.hdnAction.Value = "a"
        Dim IDs As String() = Me.hiddenIDs.Value.Split(":")
        DataClientID = IDs(0)
        clientName = ClientHelper.GetDefaultPersonName(DataClientID)
        RelationID = DataHelper.Nz_int(IDs(1), -1)
        RelationTypeID = Me.radCommType.SelectedValue

        Select Case RelationTypeID
            Case 0, 1
                Me.EntityName = Me.radCommType.Items(1).Text
                Me.EntityName = Me.EntityName.Substring(Me.EntityName.LastIndexOf("to") + 2)
                Me.RelationTypeName = DataHelper.FieldLookup("tblRelationType", "Name", "relationtypeid=" & 1)
            Case 2
                Me.EntityName = Me.radCommType.Items(2).Text
                Me.EntityName = Me.EntityName.Substring(Me.EntityName.LastIndexOf("to") + 2)
                Me.RelationTypeName = DataHelper.FieldLookup("tblRelationType", "Name", "relationtypeid=" & 2)
        End Select

        Me.hdnRelationTypeID.Value = RelationTypeID

        If RelationTypeID = 2 Then
            ContextSensitive = "account"
        Else
            ContextSensitive = "all"
        End If

        ltrNew.Text = "New&nbsp;"
        txtCallMsg.Text = ""
        txtStarted.Text = Now.ToString("MM/dd/yyyy hh:mm:ss tt")
        txtEnded.Text = ""
        txtPhoneNumber.Text = ""
        ListHelper.SetSelected(cboInternal, Session("UserID"))
        ListHelper.SetSelected(cboExternal, "")

        hdnTempPhoneCallID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()

        ShowForm(FormType.PhoneCall)
    End Sub
    Protected Sub lnkCancelCall_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelCall.Click
        Me.ShowForm(FormType.Comms)
    End Sub
    Protected Sub lnkSaveCall_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSaveCall.Click
        InsertOrUpdatePhoneCall()
        Me.ShowForm(FormType.Comms)
    End Sub
#End Region

#End Region

#Region "Litigation"
    Protected Sub lnkCancelLit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelLit.Click
        Me.ShowForm(FormType.Comms)
    End Sub
    Private Sub LoadLitComm(ByVal accountNumber As String, ByVal CommTable As String, ByVal CommDate As String, ByVal CommTime As String, ByVal Staff As String)

        Using cmd As New SqlCommand("SELECT memo as Message, " + IIf(CommTable = "tm8user.phone", "subject", "[desc]") + _
                " as Subject, dateadd(s, (c_time - 1)/100, dateadd(d, c_date, '12-28-1800')) as Created, " + _
                "created_by as CreatedBy, dateadd(s, (m_time - 1)/100, dateadd(d, m_date, '12-28-1800')) as Modified, staff as ModifiedBy FROM " + _
                CommTable + " WHERE mat_no = '" + accountNumber + "' and [date] = " + CommDate.ToString() + " and time = " + CommTime.ToString() + " and staff = '" + _
                Staff + "'", New SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstringtimematters").ToString()))

            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        txtLitCreatedBy.Text = reader("CreatedBy").ToString()
                        txtLitCreatedDate.Text = DateTime.Parse(reader("Created")).ToString("g")

                        txtLitLastModifiedBy.Text = reader("ModifiedBy").ToString()
                        txtLitLastModifiedDate.Text = DateTime.Parse(reader("Modified")).ToString("g")

                        lblLitSubject.Text = reader("Subject").ToString()
                        txtLitMessage.Text = reader("Message").ToString()
                    End If
                End Using
            End Using
        End Using
    End Sub
#End Region

    Protected Sub gvPendingOffers_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPendingOffers.RowDataBound
          Select e.Row.RowType
            Case DataControlRowType.DataRow
                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#DADAFA'; this.style.filter = 'alpha(opacity=75)';")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = ''; this.style.filter = '';")
        End Select
    End Sub

    Protected Sub tcSettlementInfo_ActiveTabChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles tcSettlementInfo.ActiveTabChanged
        Select Case tcSettlementInfo.ActiveTabIndex
            Case 2
                GetCommEntities(DataClientID, AccountID)
                LoadCommData(DataClientID)
                PopulateExternal()
                PopulateInternal()
        End Select
    End Sub
    Private Sub BindData_PendingOffers()
        dsPendingOffers.SelectParameters("clientid").DefaultValue = DataClientID
        dsPendingOffers.DataBind()
        gvPendingOffers.DataBind()
        tpPendingOffers.HeaderText = "Pending Offers (" & gvPendingOffers.Rows.Count & ")"
    End Sub

End Class
