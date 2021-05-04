Imports Drg.Util.DataHelpers
Imports System.Data
Imports Drg.Util.DataAccess
Imports System.Data.SqlClient
Imports GridViewHelper
Partial Class processing_webparts_SettlementNotes
    Inherits System.Web.UI.UserControl
#Region "View Comms modules"
#Region "Declares"
    Private SettlementID As Integer
    Private Information As SettlementMatterHelper.SettlementInformation
    Public RelationTypeID As Integer = 0
    Public RelationTypeName As String = ""
    Public RelationID As Integer = 0
    Public clientName As String = ""
    Public creditorName As String = ""
    Public EntityName As String = ""
    Public DataClientID As String = ""
    Public AccountID As String

    Public PhoneCallID As Integer
    Private qs As Drg.Util.Helpers.QueryStringCollection
    Private baseTable As String = "tblNote"
    Public ContextSensitive As String

    Public Enum FormType
        Comms = 0
        Note = 1
        PhoneCall = 2
        Litigation = 3
    End Enum

    Public Property NegotiationSessionGUID() As String
        Get
            Return Me.NegGuid.Value
        End Get
        Set(ByVal value As String)
            Me.NegGuid.Value = value
        End Set
    End Property
#End Region

#Region "Events"
#Region "CommsGridview"
    Protected Sub gvNotes_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvNotes.DataBound


    End Sub
    Protected Sub gvNotes_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvNotes.PageIndexChanging
        gvNotes.PageIndex = e.NewPageIndex

        Dim dtNotes As DataTable = DirectCast(ViewState("gvNotesDataSource"), DataTable)
        gvNotes.DataSource = dtNotes
        gvNotes.DataBind()
    End Sub
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
                End Select

        End Select

    End Sub
    Protected Sub gvNotes_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNotes.RowCreated

    End Sub
    Protected Sub gvNotes_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNotes.RowDataBound
        Select Case e.Row.RowType

            Case DataControlRowType.DataRow

                e.Row.Style("cursor") = "hand"
                e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor = '#f3f3f3'; ")
                e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor = '#ffffff'; this.style.textDecoration = 'none';")
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
    Protected Sub gvNotes_Sorting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSortEventArgs) Handles gvNotes.Sorting

        Dim dtNotes As DataTable = DirectCast(ViewState("gvNotesDataSource"), DataTable)

        If Not dtNotes Is Nothing Then

            Dim gv As GridView = DirectCast(sender, GridView)
            GridViewHelper.AppendSortOrderImageToGridHeader(e.SortDirection, e.SortExpression, gv)

            Dim dataView As DataView = New DataView(dtNotes)
            Dim sortExp As String = "[" & e.SortExpression & "]"

            If sortExp = "[Note]" Then
                sortExp = "[Subject],[Description] "
            End If
            If ViewState("SortDir") = "ASC" Then
                sortExp += " DESC"
                ViewState("SortDir") = "DESC"
            Else
                sortExp += " ASC"
                ViewState("SortDir") = "ASC"
            End If

            dataView.Sort = sortExp

            Dim dtSort As DataTable = dataView.ToTable
            gvNotes.DataSource = dtSort
            gvNotes.DataBind()

            ViewState("gvNotesDataSource") = dtSort

        End If


    End Sub
    Protected Sub ddlPage_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddlCurrentPage As DropDownList = DirectCast(sender, DropDownList)

        gvNotes.PageIndex = ddlCurrentPage.SelectedValue - 1

        Dim dtNotes As DataTable = DirectCast(ViewState("gvNotesDataSource"), DataTable)
        gvNotes.DataSource = dtNotes
        gvNotes.DataBind()


    End Sub
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Not Request.QueryString("id") Is Nothing Then
                SettlementID = SettlementMatterHelper.GetSettlementFromTask(Integer.Parse(Request.QueryString("id")))

                Information = SettlementMatterHelper.GetSettlementInformation(SettlementID)

                DataClientID = Information.ClientID
                AccountID = Information.AccountID

            End If

            If Not DataClientID Is Nothing And Not AccountID Is Nothing Then
                GetCommEntities(DataClientID, AccountID)
                LoadCommData(DataClientID, SettlementID)
                PopulateExternal()
                PopulateInternal()
                Me.hiddenIDs.Value = DataClientID & ":" & AccountID & ":" & SettlementID
                ViewState("SortDir") = "ASC"
            End If
        End If

    End Sub
    Protected Sub radCommType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles radCommType.SelectedIndexChanged
        Dim rad As RadioButtonList = DirectCast(sender, RadioButtonList)
        Dim IDs As String() = Me.hiddenIDs.Value.Split(":")

        Select Case rad.SelectedValue
            Case 0  'all
                Me.LoadCommData(IDs(0), IDs(2), 0, , 0)
                Me.hdnRelationTypeID.Value = 1

            Case 1  'client only
                Me.LoadCommData(IDs(0), IDs(2), 1, , 1)
                Me.hdnRelationTypeID.Value = 1
            Case 2  'creditor
                'LoadComms(IDs(0), IDs(1), 2)
                Me.LoadCommData(IDs(0), IDs(2), 2, IDs(1), 0)
                Me.hdnRelationTypeID.Value = 2
        End Select
    End Sub
#End Region

#Region "Subs/Funcs"
    Public Sub GetCommEntities(ByVal sClientID As String, ByVal sCreditorAcctID As String)

        Try
            clientName = ClientHelper.GetDefaultPersonName(sClientID).Replace("'", "&#39;")
            Me.radCommType.Items(1).Text = "Comms specific to " & clientName

            Dim sqlSelect As String = "SELECT cast(c.CreditorID as varchar) + '|' +  c.Name as [Info] "
            sqlSelect += "FROM tblAccount AS a INNER JOIN tblCreditorInstance AS ci "
            sqlSelect += "ON a.CurrentCreditorInstanceID = ci.CreditorInstanceID INNER "
            sqlSelect += "JOIN tblCreditor AS c ON ci.CreditorID = c.CreditorID "
            sqlSelect += "WHERE (a.AccountID = [@AccountID])"
            sqlSelect = sqlSelect.Replace("[@AccountID]", sCreditorAcctID)

            Dim cmd As New SqlClient.SqlCommand(sqlSelect, New SqlClient.SqlConnection(System.Configuration.ConfigurationManager.AppSettings("connectionstring")))
            cmd.Connection.Open()

            Dim CredInfo As String() = cmd.ExecuteScalar().ToString.Split("|")
            Me.radCommType.Items(2).Text = "Comms specific to " & CredInfo(1)

            Dim bSelected As Boolean = False
            For Each lType As ListItem In Me.radCommType.Items
                If lType.Selected = True Then bSelected = True
            Next
            If bSelected = False Then
                Me.radCommType.Items(0).Selected = True
            End If

            cmd.Dispose()
            cmd = Nothing

            Me.hdnCreditorID.Value = CredInfo(0)

        Catch ex As Exception

        End Try

    End Sub
    Public Sub LoadCommData(ByVal sClientID As String, ByVal _SettlementId As Integer, Optional ByVal RelationType As Integer = 0, Optional ByVal CreditorAccountID As String = "", Optional ByVal ClientOnly As Integer = 0)
        Dim sqlSelect As String = "stp_GetNotesForSettlement " & sClientID & ", " & _SettlementId

        Dim intRad As Integer = Me.radCommType.SelectedIndex
        If RelationType = 0 Then
            sqlSelect += ",NULL,NULL,0"
            Me.radCommType.SelectedIndex = 0
        Else
            Select Case intRad
                Case 1
                    sqlSelect += ",NULL,NULL,1"
                Case 2
                    sqlSelect += "," & CreditorAccountID & ",2,0"
            End Select
        End If

        Using saTemp = New SqlClient.SqlDataAdapter(sqlSelect, System.Configuration.ConfigurationManager.AppSettings("connectionstring"))
            Dim dtComm As New DataTable
            saTemp.Fill(dtComm)
            If RelationType = 0 Then
                Dim clientAcctNum As String = Drg.Util.DataAccess.DataHelper.FieldLookup("tblClient", "Accountnumber", "clientid = " & sClientID)
            End If

            gvNotes.AutoGenerateColumns = False
            Me.gvNotes.PageIndex = 0
            Me.gvNotes.DataSource = dtComm
            Me.gvNotes.DataBind()

            ViewState("gvNotesDataSource") = Me.gvNotes.DataSource
        End Using

    End Sub
    'Private Sub BuildCommsGrid()

    '    Dim strColNames As String() = "Type,By,Date,Subject,Description".Split(",")
    '    Me.gvNotes.Columns.Clear()

    '    For Each s As String In strColNames
    '        Dim dc As New BoundField
    '        dc.ItemStyle.HorizontalAlign = HorizontalAlign.Left
    '        dc.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
    '        dc.SortExpression = s.ToString
    '        dc.DataField = s.ToString
    '        dc.HeaderText = s.ToString
    '        Select Case s.ToString.ToLower
    '            Case "Type"
    '                dc.HeaderStyle.Width = "30px"
    '                dc.ItemStyle.Width = "30px"
    '        End Select
    '        Me.gvNotes.Columns.Add(dc)
    '    Next
    'End Sub
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
                        Me.LoadCommData(IDs(0), IDs(2), 0, , 0)
                        Me.hdnRelationTypeID.Value = 1
                    Case 1  'client only
                        Me.LoadCommData(IDs(0), IDs(2), 1, , 1)
                        Me.hdnRelationTypeID.Value = 1
                    Case 2  'creditor
                        Me.LoadCommData(IDs(0), IDs(2), 2, IDs(1), 0)
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

#End Region
#End Region

#Region "Note Modules"

#Region "Declares"

    Public NoteID As Integer
#End Region

#Region "Subs/Funcs"
    Private Sub LoadNote(ByVal sNoteID As Integer)

        GetRelationInfo()

        Me.hdnTempNoteID.Value = sNoteID

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT Created, CreatedBy, LastModified, LastModifiedBy, Value FROM tblNote WHERE NoteID = @NoteID"

        DatabaseHelper.AddParameter(cmd, "NoteID", sNoteID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then
                Dim created As DateTime = DatabaseHelper.Peel_date(rd, "Created")
                Dim lastModified As DateTime = DatabaseHelper.Peel_date(rd, "LastModified")

                txtCreatedBy.Text = UserHelper.GetName(DatabaseHelper.Peel_int(rd, "CreatedBy"))
                txtCreatedDate.Text = created.ToShortDateString() + " at " + created.ToShortTimeString()
                txtLastModifiedBy.Text = UserHelper.GetName(DatabaseHelper.Peel_int(rd, "LastModifiedBy"))
                txtLastModifiedDate.Text = lastModified.ToShortDateString() + " at " + lastModified.ToShortTimeString()

                txtMessage.Text = DatabaseHelper.Peel_string(rd, "Value")

            End If
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

    End Sub

    Public Sub LoadNotes()
        If Not Request.QueryString("id") Is Nothing Then
            SettlementID = SettlementMatterHelper.GetSettlementFromTask(Integer.Parse(Request.QueryString("id")))
            Information = SettlementMatterHelper.GetSettlementInformation(SettlementID)
            LoadCommData(Information.ClientID, SettlementID)
        End If
    End Sub

    Private Function InsertOrUpdateNote() As Integer
        If Me.hdnAction.Value = "a" Then
            Dim IDs As String() = Me.hiddenIDs.Value.Split(":")

            SettlementMatterHelper.AddSettlementNote(IDs(2), txtMessage.Text, Session("UserID"))

        Else
            NoteID = Me.hdnTempNoteID.Value
            NoteHelper.UpdateNote(NoteID, txtMessage.Text, Session("UserID"))
        End If

        Return NoteID
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

        Me.InsertOrUpdateNote()
        Me.ShowForm(FormType.Comms)
    End Sub
#End Region

#End Region

#Region "Phone Call Modules"

#Region "Declares"

#End Region

#Region "Subs/Funcs"
    Private Sub PopulateExternal()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT FirstName, LastName, PersonID FROM tblPerson WHERE ClientID = @ClientID"

        DatabaseHelper.AddParameter(cmd, "ClientID", DataClientID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            cboExternal.Items.Clear()
            cboExternal.Items.Add(New ListItem("", "0"))
            cboExternal.SelectedIndex = 0

            While rd.Read()
                Dim Name As String = DatabaseHelper.Peel_string(rd, "FirstName") & " " & DatabaseHelper.Peel_string(rd, "LastName")
                cboExternal.Items.Add(New ListItem(Name, DatabaseHelper.Peel_int(rd, "PersonID").ToString))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub
    Private Sub PopulateInternal()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT FirstName, LastName, UserId FROM tblUser"

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            cboInternal.Items.Clear()
            cboInternal.Items.Add(New ListItem("", "0"))
            cboInternal.SelectedIndex = 0

            While rd.Read()
                Dim Name As String = DatabaseHelper.Peel_string(rd, "FirstName") & " " & DatabaseHelper.Peel_string(rd, "LastName")
                cboInternal.Items.Add(New ListItem(Name, DatabaseHelper.Peel_int(rd, "UserID").ToString))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub
    Private Sub LoadCall(ByVal PhoneID As Integer)

        GetRelationInfo()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPhoneCall WHERE PhoneCallID = @PhoneCallID"

        DatabaseHelper.AddParameter(cmd, "PhoneCallID", PhoneID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim created As DateTime = DatabaseHelper.Peel_date(rd, "Created")
                Dim lastModified As DateTime = DatabaseHelper.Peel_date(rd, "LastModified")


                txtCallMsg.Text = rd("Body").ToString
                txtSubject.Text = DatabaseHelper.Peel_string(rd, "Subject")
                txtStarted.Text = DatabaseHelper.Peel_date(rd, "StartTime").ToString("MM/dd/yyyy hh:mm:ss tt")
                txtEnded.Text = DatabaseHelper.Peel_date(rd, "EndTime").ToString("MM/dd/yyyy hh:mm:ss tt")
                txtPhoneNumber.Text = DatabaseHelper.Peel_string(rd, "PhoneNumber")

                ListHelper.SetSelected(cboExternal, DatabaseHelper.Peel_int(rd, "PersonID").ToString())
                ListHelper.SetSelected(cboInternal, DatabaseHelper.Peel_int(rd, "UserID").ToString())

                Select Case DatabaseHelper.Peel_bool(rd, "Direction")

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

            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try

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

End Class
