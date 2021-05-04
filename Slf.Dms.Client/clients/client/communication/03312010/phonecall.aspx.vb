Option Explicit On

Imports Drg.Util.Helpers
Imports Drg.Util.DataAccess
Imports Drg.Util.DataHelpers

Imports SharedFunctions

Imports Slf.Dms.Records

Imports System.Data
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Collections.Generic

Partial Class clients_client_communication_phonecall
    Inherits PermissionPage

#Region "Variables"

    Private Action As String
    Private strNavigation As String
    Public AccountID As Integer
    Public PhoneCallID As Integer
    Public Shadows ClientID As Integer
    Private qs As QueryStringCollection
    Private baseTable As String = "tblPhoneCall"
    Private UserID As Integer
    Private IsMy As Boolean
    Public AddRelation As Integer
    Public AddRelationType As String
    Public MatterId As Integer

    Public CreditorInstanceId As Integer
#End Region

    Private Sub PopulateExternal()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT FirstName, LastName, PersonID FROM tblPerson WHERE ClientID = @ClientID"

        DatabaseHelper.AddParameter(cmd, "ClientID", ClientID)

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
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        UserID = DataHelper.Nz_int(Page.User.Identity.Name)

        qs = LoadQueryString()

        If Not qs Is Nothing Then
            ClientID = DataHelper.Nz_int(qs("id"), 0)
            AccountID = DataHelper.Nz_int(qs("aid"), 0)
            PhoneCallID = DataHelper.Nz_int(qs("pcid"), 0)
            Action = DataHelper.Nz_string(qs("a"))
            strNavigation = DataHelper.Nz_string(qs("t"))

            If Not qs("mid") Is Nothing Then
                MatterId = DataHelper.Nz_string(qs("mid"))
                CreditorInstanceId = DataHelper.Nz_int(qs("ciid"), 0)
            Else
                MatterId = 0
                CreditorInstanceId = 0
            End If
            If Not IsPostBack Then
                PopulateExternal()
                PopulateInternal()
            End If

            HandleAction()

            If Not IsPostBack Then

                AddRelation = 0

                Select Case Action
                    Case "a"
                        hdnTempPhoneCallID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()
                    Case "am" 'Add Matter Phone Call
                        hdnTempPhoneCallID.Value = SharedFunctions.DocumentAttachment.GetUniqueTempID()
                        MatterId = DataHelper.Nz_string(qs("mid"))
                        TrPhoneStatus.Visible = True
                        PopulatePhonecallEntry()
                    Case Else
                        hdnTempPhoneCallID.Value = 0
                        LoadCreditorRelations()
                End Select

                LoadDocuments()
            End If
        End If
    End Sub

    Protected Sub lnkDeleteDocument_OnClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteDocument.Click
        SharedFunctions.DocumentAttachment.DeleteAttachment(hdnCurrentDoc.Value, UserID)
        LoadDocuments()
    End Sub

    Private Sub LoadCreditorRelations()
        Using cmd As New SqlCommand("SELECT rt.DocRelation, pr.RelationID FROM tblPhoneCallRelation as pr inner join tblRelationType as rt on rt.RelationTypeID = pr.RelationTypeID left outer join tblmatter mt on mt.matterid=pr.relationid WHERE not rt.DocRelation is null and isNull(mt.IsDeleted,0)=0 and pr.PhoneCallID = " + PhoneCallID.ToString(), ConnectionFactory.Create())
            Using cmd.Connection
                cmd.Connection.Open()

                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        AddRelation = Integer.Parse(reader("RelationID"))
                        AddRelationType = reader("DocRelation").ToString()
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub HandleAction()
        

        Dim CommonTasks As List(Of String) = Master.CommonTasks
        Select Case Action
            Case "a"    'add

                lblPhoneCall.Text = "Add New Phone Call"

                txtStarted.Text = Now.ToString("MM/dd/yyyy hh:mm:ss tt")

                ListHelper.SetSelected(cboInternal, UserID)
                trRelations.Visible = False
            Case "am"    'add Matter Phone Call
                lblPhoneCall.Text = "Add New Phone Call for a Matter"

                txtStarted.Text = Now.ToString("MM/dd/yyyy hh:mm:ss tt")

                ListHelper.SetSelected(cboInternal, UserID)
                trRelations.Visible = False
            Case Else   'edit

                lblPhoneCall.Text = "Phone Call"

                LoadRecord()

                'add delete task
                If Master.UserEdit And Permission.UserDelete(IsMy) Then
                    CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_DeleteConfirm();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_delete.png") & """ align=""absmiddle""/>Delete this phone call</a>")
                End If
                trRelations.Visible = True
        End Select
      
        If Master.UserEdit Then
            'add applicant tasks
            If Permission.UserEdit(IsMy) Then
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_cancel.png") & """ align=""absmiddle""/>Cancel and close</a>")
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_Save();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_save.png") & """ align=""absmiddle""/>Save this phone call</a>")
            Else
                CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
            End If
            

            'add normal tasks
            
        Else
            CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""Record_CancelAndClose();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_back.png") & """ align=""absmiddle""/>Return</a>")
        End If

        lnkClient.InnerText = ClientHelper.GetDefaultPersonName(ClientID)
        lnkClient.HRef = "~/clients/client/?id=" & ClientID
        lnkCommunications.HRef = "~/clients/client/communication/?id=" & ClientID

        CommonTasks.Add("<a style=""color:rgb(51,118,171);"" class=""lnk"" href=""#"" onclick=""javascript:OpenScanning();return false;""><img style=""margin-right:8px;"" border=""0"" runat=""server"" src=""" & ResolveUrl("~/images/16x16_file_remove.png") & """ align=""absmiddle""/>Scan Document</a>")
    End Sub

    Private Sub LoadDocuments()
        If PhoneCallID = 0 Then
            rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(Integer.Parse(hdnTempPhoneCallID.Value), "phonecall", Request.Url.AbsoluteUri)
        Else
            rpDocuments.DataSource = SharedFunctions.DocumentAttachment.GetAttachmentsForRelation(PhoneCallID, "phonecall", Request.Url.AbsoluteUri)
        End If

        rpDocuments.DataBind()

        If rpDocuments.DataSource.Count > 0 Then
            hypDeleteDoc.Disabled = False
        Else
            hypDeleteDoc.Disabled = True
        End If
    End Sub
    Private Sub PopulatePhonecallEntry()
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT PhoneEntry, MatterPhoneEntryID FROM tblMatterPhoneEntry"

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader()

            cboPhoneCallEntry.Items.Clear()
            cboPhoneCallEntry.Items.Add(New ListItem("Select", "0"))
            cboPhoneCallEntry.SelectedIndex = 0

            While rd.Read()
                Dim Name As String = DatabaseHelper.Peel_string(rd, "PhoneEntry")
                cboPhoneCallEntry.Items.Add(New ListItem(Name, DatabaseHelper.Peel_int(rd, "MatterPhoneEntryID").ToString))
            End While

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub

    Private Sub LoadRecord()

        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        cmd.CommandText = "SELECT * FROM tblPhoneCall WHERE PhoneCallID = @PhoneCallID"

        DatabaseHelper.AddParameter(cmd, "PhoneCallID", PhoneCallID)

        Try

            cmd.Connection.Open()
            rd = cmd.ExecuteReader(CommandBehavior.SingleRow)

            If rd.Read() Then

                Dim created As DateTime = DatabaseHelper.Peel_date(rd, "Created")
                Dim lastModified As DateTime = DatabaseHelper.Peel_date(rd, "LastModified")

                If txtMessage.Text.Length = 0 Then
                    txtMessage.Text = DatabaseHelper.Peel_string(rd, "Body")
                End If

                If txtSubject.Text.Length = 0 Then
                    txtSubject.Text = DatabaseHelper.Peel_string(rd, "Subject")
                End If

                txtStarted.Text = DatabaseHelper.Peel_date(rd, "StartTime").ToString("MM/dd/yyyy hh:mm:ss tt")
                txtEnded.Text = DatabaseHelper.Peel_date(rd, "EndTime").ToString("MM/dd/yyyy hh:mm:ss tt")
                txtPhoneNumber.Text = DatabaseHelper.Peel_string(rd, "PhoneNumber")

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

                ListHelper.SetSelected(cboExternal, DatabaseHelper.Peel_int(rd, "PersonID").ToString())
                ListHelper.SetSelected(cboInternal, DatabaseHelper.Peel_int(rd, "UserID").ToString())

                IsMy = (DatabaseHelper.Peel_int(rd, "CreatedBy") = UserID)
            End If

        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
        LoadRelations()
    End Sub

    Private Sub LoadRelations()
        Using cmd As IDbCommand = ConnectionFactory.CreateCommand("stp_GetRelationsForPhoneCall")
            Using cmd.Connection
                DatabaseHelper.AddParameter(cmd, "phonecallid", PhoneCallID)
                cmd.Connection.Open()
                Using rd As IDataReader = cmd.ExecuteReader()
                    rpRelations.DataSource = rd
                    rpRelations.DataBind()
                End Using
            End Using
        End Using
    End Sub

    Protected Function LoadQueryString() As QueryStringCollection

        Dim qsv As QueryStringValidator = New QueryStringValidator(Request.QueryString)

        qsv.Rules.Load(New ConfigHelper(Server.MapPath("~/app.config")).GetNode("page[@name=""clients_client_applicants_applicant_default""]/querystringrules"))

        If Not qsv.Validate() Then
            Response.Redirect("error.aspx")
            Return Nothing
        End If

        Return qsv.QueryString

    End Function
    Private Sub Close()
        If strNavigation = "m" Then
            Response.Redirect("~/clients/client/creditors/matters/matterinstance.aspx?id=" & ClientID & "&aid=" & AccountID & "&mid=" & MatterId & "&ciid=" & CreditorInstanceId)
        End If
        If Action = "am" And MatterId > 0 Then
            Response.Redirect("~/clients/client/creditors/matters/matterinstance.aspx?id=" & ClientID & "&aid=" & AccountID & "&mid=" & MatterId & "&ciid=" & CreditorInstanceId)
        Else
            Response.Redirect("~/clients/client/communication/phonecalls.aspx?id=" & ClientID)
        End If
    End Sub
    Private Function InsertOrUpdatePhoneCall() As Integer

        If Action = "am" And MatterId > 0 Then

            PhoneCallID = PhoneCallHelper.InsertPhoneCall(ClientID, UserID, cboInternal.SelectedValue, cboExternal.SelectedValue, rbOutgoing.Checked, txtPhoneNumber.TextUnMasked, txtMessage.Text, txtSubject.Text, DateTime.Parse(txtStarted.Text), DateTime.Parse(txtEnded.Text))
            Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

            DatabaseHelper.AddParameter(cmd, "PhoneCallID", PhoneCallID)
            ' Id 19 is Matter    
            DatabaseHelper.AddParameter(cmd, "RelationTypeID", 19)
            DatabaseHelper.AddParameter(cmd, "RelationID", MatterId)
            DatabaseHelper.BuildInsertCommandText(cmd, "tblPhoneCallRelation", "PhoneCallRelationId", SqlDbType.Int)

            Try
                cmd.Connection.Open()
                cmd.ExecuteNonQuery()
            Finally
                DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
            End Try
       ElseIf Action = "a" Then
            PhoneCallID = PhoneCallHelper.InsertPhoneCall(ClientID, UserID, cboInternal.SelectedValue, cboExternal.SelectedValue, rbOutgoing.Checked, txtPhoneNumber.TextUnMasked, txtMessage.Text, txtSubject.Text, DateTime.Parse(txtStarted.Text), DateTime.Parse(txtEnded.Text))
            SharedFunctions.DocumentAttachment.SolidifyTempRelation(hdnTempPhoneCallID.Value, "phonecall", ClientID, PhoneCallID)
        Else

            PhoneCallHelper.UpdatePhoneCall(PhoneCallID, UserID, DataHelper.Nz_int(cboInternal.SelectedValue), _
                DataHelper.Nz_int(cboExternal.SelectedValue), rbOutgoing.Checked, txtPhoneNumber.TextUnMasked, _
                txtMessage.Text, txtSubject.Text, DateTime.Parse(txtStarted.Text), DateTime.Parse(txtEnded.Text))
        End If

        Return PhoneCallID

    End Function

    Protected Sub lnkCancelAndClose_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkCancelAndClose.Click
        SharedFunctions.DocumentAttachment.DeleteAllForItem(hdnTempPhoneCallID.Value, "note", UserID)
        Close()
    End Sub

    Protected Sub lnkSave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkSave.Click

        InsertOrUpdatePhoneCall()
        Close()

    End Sub

    Protected Sub lnkDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDelete.Click
        SharedFunctions.DocumentAttachment.DeleteAllForItem(PhoneCallID, "phonecall", UserID)

        'delete applicant
        PhoneCallHelper.Delete(PhoneCallID)

        'drop back to applicants
        Close()
    End Sub

    Public Overrides Sub AddPermissionControls(ByVal c As System.Collections.Generic.Dictionary(Of String, System.Web.UI.Control))
        AddControl(phBody, c, "Clients-Client Single Record-Communication-Phone Call")
        AddControl(bodMain, c, "Users-User Single Record", 3, True)
        AddControl(bodReadOnly, c, "Users-User Single Record", 3, False)
    End Sub

    Private Function GetPairs() As List(Of Pair(Of Control))
        Dim l As New List(Of Pair(Of Control))

        l.Add(New Pair(Of Control)(ro_cboExternal, cboExternal))
        l.Add(New Pair(Of Control)(ro_cboInternal, cboInternal))
        l.Add(New Pair(Of Control)(ro_txtEnded, txtEnded))
        l.Add(New Pair(Of Control)(ro_txtStarted, txtStarted))
        l.Add(New Pair(Of Control)(ro_txtSubject, txtSubject))

        Return l
    End Function

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        If Permission.UserEdit(IsMy) Then
            'editable
            bodMain.Visible = True
            bodReadOnly.Visible = False
        Else 'uneditable
            bodMain.Visible = False
            bodReadOnly.Visible = True
            Dim l As List(Of Pair(Of Control)) = GetPairs()
            LocalHelper.CopyValues(l)

            ro_tdDirection.InnerHtml = IIf(rbIncoming.Checked, "Incoming", "Outgoing")
            ro_txtPhoneNumber.Text = StringHelper.PlaceInMask(txtPhoneNumber.Text, "(___) ___-____")
        End If
    End Sub

    Protected Sub lnkDeleteRelation_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkDeleteRelation.Click

        If txtSelectedIDs.Value.Length > 0 Then

            'get selected "," delimited NoteId's
            Dim ids() As String = txtSelectedIDs.Value.Split(",")

            For Each id As String In ids
                DataHelper.Delete("tblPhonecallRelation", "phonecallrelationid=" & id)
            Next

        End If

        'reload same page (of applicants)
        Response.Redirect(Request.Url.AbsoluteUri)

    End Sub
    Protected Sub lnkShowDocs_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkShowDocs.Click
        LoadDocuments()
    End Sub
    Protected Sub cboPhoneCallEntry_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboPhoneCallEntry.SelectedIndexChanged
        Dim rd As IDataReader = Nothing
        Dim cmd As IDbCommand = ConnectionFactory.Create().CreateCommand()

        Try
            cmd.CommandText = " select PhoneEntryDesc,PhoneEntryBody from tblMatterPhoneEntry where MatterPhoneEntryID=@MatterPhoneEntryID"
            DatabaseHelper.AddParameter(cmd, "MatterPhoneEntryID", cboPhoneCallEntry.SelectedValue)
            txtSubject.Text = ""
            Try
                cmd.Connection.Open()
                rd = cmd.ExecuteReader()
                While rd.Read()
                    txtSubject.Text = DatabaseHelper.Peel_string(rd, "PhoneEntryDesc")
                    txtMessage.Text = DatabaseHelper.Peel_string(rd, "PhoneEntryBody")
                End While
            Finally

            End Try
        Catch ex As Exception
        Finally
            DatabaseHelper.EnsureReaderClosed(rd)
            DatabaseHelper.EnsureConnectionClosed(cmd.Connection)
        End Try
    End Sub
End Class
